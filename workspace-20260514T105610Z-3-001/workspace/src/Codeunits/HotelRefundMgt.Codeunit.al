codeunit 50104 "Hotel Refund Mgt"
{
    // Refund processing is restricted to the Finance role.
    // Object-level permission (granted only in HOTEL_FINANCE permission set)
    // plus an explicit runtime permission check provide defense in depth so
    // that Front Desk users cannot trigger refunds even via API.
    Permissions = tabledata "Hotel Payment Entry" = rim,
                  tabledata "Hotel Reservation" = rm,
                  tabledata "Hotel Invoice Header" = rm;

    procedure ProcessRefund(var Reservation: Record "Hotel Reservation"; Amount: Decimal; Reason: Text[100]) Success: Boolean
    var
        PaymentEntry: Record "Hotel Payment Entry";
        Invoice: Record "Hotel Invoice Header";
    begin
        EnsureFinanceUser();

        Reservation.TestField("Reservation No.");
        if Amount <= 0 then
            Error(AmountMustBePositiveErr);
        if Amount > Reservation."Amount Paid" then
            Error(RefundExceedsPaidErr, Amount, Reservation."Amount Paid");

        PaymentEntry.Init();
        PaymentEntry."Reservation No." := Reservation."Reservation No.";
        PaymentEntry."Invoice No." := Reservation."Invoice No.";
        PaymentEntry."Posting Date" := WorkDate();
        PaymentEntry."Payment Kind" := PaymentEntry."Payment Kind"::Refund;
        PaymentEntry.Amount := -Amount;
        PaymentEntry.Status := PaymentEntry.Status::Refunded;
        PaymentEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(PaymentEntry."User ID"));
        PaymentEntry.Description := CopyStr(StrSubstNo(RefundDescTxt, Amount, Reason), 1, MaxStrLen(PaymentEntry.Description));
        PaymentEntry.Insert(true);

        Reservation."Amount Paid" -= Amount;
        Reservation."Amount Due" += Amount;
        Reservation.Modify(true);

        if Invoice.Get(Reservation."Invoice No.") then begin
            Invoice."Amount Due" := Reservation."Amount Due";
            Invoice.Paid := Reservation."Amount Due" = 0;
            Invoice.Modify(true);
        end;

        Success := true;
    end;

    local procedure EnsureFinanceUser()
    var
        DummyPaymentEntry: Record "Hotel Payment Entry";
        DummyInvoiceHeader: Record "Hotel Invoice Header";
    begin
        // Runtime check: refunds require write access to both Payment Entry
        // and Invoice Header. Front Desk has read-only on these tables, so
        // this guard blocks Front Desk callers even if they reach this codeunit
        // through an indirect path.
        if not (DummyPaymentEntry.WritePermission() and DummyInvoiceHeader.WritePermission()) then
            Error(UnauthorizedRefundErr);
    end;

    var
        AmountMustBePositiveErr: Label 'Refund amount must be greater than zero.';
        RefundExceedsPaidErr: Label 'Refund amount %1 exceeds the amount paid (%2).';
        UnauthorizedRefundErr: Label 'You are not authorized to process refunds. Only Finance users may perform this action.';
        RefundDescTxt: Label 'Refund of %1 - %2';
}
