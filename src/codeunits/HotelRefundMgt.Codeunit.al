codeunit 50053 "Hotel Refund Mgt"
{
    Access = Public;
    Permissions = tabledata "Hotel Payment Entry" = rim,
                  tabledata "Hotel Reservation" = rm;

    procedure ProcessRefund(var Reservation: Record "Hotel Reservation"; Amount: Decimal; Reason: Text[100]; ExternalRef: Code[35])
    var
        PermissionCheck: Codeunit "Hotel Permission Check";
        Entry: Record "Hotel Payment Entry";
        RefundableAmount: Decimal;
    begin
        PermissionCheck.CheckIsFinance();

        if Amount <= 0 then
            Error(InvalidAmountErr);
        if not Reservation.Invoiced then
            Error(NotInvoicedErr, Reservation."No.");

        RefundableAmount := Reservation."Paid Amount" - Reservation."Refunded Amount";
        if Amount > RefundableAmount then
            Error(RefundExceedsPaidErr, Amount, RefundableAmount);

        Clear(Entry);
        Entry.Init();
        Entry."Reservation No." := Reservation."No.";
        Entry."Invoice No." := Reservation."Invoice No.";
        Entry."Posting Date" := WorkDate();
        Entry."Entry Type" := Entry."Entry Type"::Refund;
        Entry.Amount := Amount;
        Entry.Successful := true;
        Entry."User ID" := CopyStr(UserId(), 1, MaxStrLen(Entry."User ID"));
        Entry."External Reference" := ExternalRef;
        if Reason = '' then
            Entry.Description := DefaultRefundTxt
        else
            Entry.Description := Reason;
        Entry.Insert(true);

        Reservation."Refunded Amount" := Reservation."Refunded Amount" + Amount;
        Reservation."Amount Due" := Reservation."Total Amount" - Reservation."Paid Amount" + Reservation."Refunded Amount";
        Reservation.Modify(true);
    end;

    var
        InvalidAmountErr: Label 'Refund amount must be greater than zero.';
        NotInvoicedErr: Label 'Reservation %1 has not been invoiced; nothing to refund.', Comment = '%1=Reservation No.';
        RefundExceedsPaidErr: Label 'Refund amount %1 exceeds the refundable balance %2.', Comment = '%1=Requested, %2=Available';
        DefaultRefundTxt: Label 'Refund processed';
}
