codeunit 50101 "Hotel Payment Mgt"
{
    Permissions = tabledata "Hotel Payment Entry" = rim,
                  tabledata "Hotel Reservation" = rm;

    procedure CaptureDeposit(var Reservation: Record "Hotel Reservation"; Amount: Decimal; PaymentSuccess: Boolean) Success: Boolean
    var
        PaymentEntry: Record "Hotel Payment Entry";
    begin
        Reservation.TestField("Reservation No.");
        if Amount <= 0 then
            Error(AmountMustBePositiveErr);
        if Reservation."Deposit Captured" then
            Error(DepositAlreadyCapturedErr, Reservation."Reservation No.");

        PaymentEntry.Init();
        PaymentEntry."Reservation No." := Reservation."Reservation No.";
        PaymentEntry."Posting Date" := WorkDate();
        PaymentEntry."Payment Kind" := PaymentEntry."Payment Kind"::Deposit;
        PaymentEntry.Amount := Amount;
        PaymentEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(PaymentEntry."User ID"));

        if PaymentSuccess then begin
            PaymentEntry.Status := PaymentEntry.Status::Captured;
            PaymentEntry.Description := CopyStr(StrSubstNo(DepositCapturedTxt, Amount), 1, MaxStrLen(PaymentEntry.Description));
            PaymentEntry.Insert(true);

            Reservation."Deposit Amount" := Amount;
            Reservation."Deposit Captured" := true;
            Reservation."Amount Paid" += Amount;
            Reservation.Modify(true);
            Success := true;
        end else begin
            PaymentEntry.Status := PaymentEntry.Status::Failed;
            PaymentEntry.Description := CopyStr(StrSubstNo(DepositFailedTxt, Amount), 1, MaxStrLen(PaymentEntry.Description));
            PaymentEntry.Insert(true);
            Success := false;
            // Do NOT mark deposit captured; do NOT inflate Amount Paid.
        end;
    end;

    procedure ProcessFinalPayment(var Reservation: Record "Hotel Reservation"; Amount: Decimal; PaymentSuccess: Boolean) Success: Boolean
    var
        PaymentEntry: Record "Hotel Payment Entry";
        Invoice: Record "Hotel Invoice Header";
    begin
        Reservation.TestField("Reservation No.");
        if Amount <= 0 then
            Error(AmountMustBePositiveErr);
        if not Reservation."Invoice Generated" then
            Error(NoInvoiceErr, Reservation."Reservation No.");

        PaymentEntry.Init();
        PaymentEntry."Reservation No." := Reservation."Reservation No.";
        PaymentEntry."Invoice No." := Reservation."Invoice No.";
        PaymentEntry."Posting Date" := WorkDate();
        PaymentEntry."Payment Kind" := PaymentEntry."Payment Kind"::Final;
        PaymentEntry.Amount := Amount;
        PaymentEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(PaymentEntry."User ID"));

        if PaymentSuccess then begin
            PaymentEntry.Status := PaymentEntry.Status::Captured;
            PaymentEntry.Description := CopyStr(StrSubstNo(FinalCapturedTxt, Amount), 1, MaxStrLen(PaymentEntry.Description));
            PaymentEntry.Insert(true);

            Reservation."Amount Paid" += Amount;
            Reservation."Amount Due" -= Amount;
            if Reservation."Amount Due" < 0 then
                Reservation."Amount Due" := 0;
            Reservation.Modify(true);

            if Invoice.Get(Reservation."Invoice No.") then begin
                Invoice."Amount Due" := Reservation."Amount Due";
                Invoice.Paid := Reservation."Amount Due" = 0;
                Invoice.Modify(true);
            end;

            Success := true;
        end else begin
            PaymentEntry.Status := PaymentEntry.Status::Failed;
            PaymentEntry.Description := CopyStr(StrSubstNo(FinalFailedTxt, Amount), 1, MaxStrLen(PaymentEntry.Description));
            PaymentEntry.Insert(true);
            Success := false;
        end;
    end;

    procedure TotalCapturedDeposit(ReservationNo: Code[20]) Total: Decimal
    var
        PaymentEntry: Record "Hotel Payment Entry";
    begin
        PaymentEntry.SetRange("Reservation No.", ReservationNo);
        PaymentEntry.SetRange("Payment Kind", PaymentEntry."Payment Kind"::Deposit);
        PaymentEntry.SetRange(Status, PaymentEntry.Status::Captured);
        PaymentEntry.CalcSums(Amount);
        exit(PaymentEntry.Amount);
    end;

    var
        AmountMustBePositiveErr: Label 'Payment amount must be greater than zero.';
        DepositAlreadyCapturedErr: Label 'Deposit for reservation %1 has already been captured.';
        NoInvoiceErr: Label 'Reservation %1 has no invoice generated yet.';
        DepositCapturedTxt: Label 'Deposit captured: %1';
        DepositFailedTxt: Label 'Deposit capture failed: %1';
        FinalCapturedTxt: Label 'Final payment captured: %1';
        FinalFailedTxt: Label 'Final payment failed: %1';
}
