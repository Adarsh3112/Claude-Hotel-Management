codeunit 50052 "Hotel Invoice Posting"
{
    Access = Public;

    procedure PostInvoice(var Reservation: Record "Hotel Reservation"; var PostedInvoice: Record "Hotel Posted Invoice"): Boolean
    var
        Setup: Record "Hotel Setup";
        NoSeries: Codeunit "No. Series";
        InvoiceNo: Code[20];
        DepositToApply: Decimal;
    begin
        if Reservation.Invoiced then
            Error(DuplicateInvoiceErr, Reservation."No.", Reservation."Invoice No.");
        if (Reservation."Check-in Date" = 0D) or (Reservation."Check-out Date" = 0D) then
            Error(MissingDatesErr, Reservation."No.");
        if Reservation."Room No." = '' then
            Error(MissingRoomErr, Reservation."No.");
        if Reservation."Customer No." = '' then
            Error(MissingCustomerErr, Reservation."No.");

        Setup.GetSetup();
        Setup.TestField("Invoice Nos.");

        // Recalculate totals using current tax setup at invoice time
        Reservation.RecalcTotals();

        InvoiceNo := NoSeries.GetNextNo(Setup."Invoice Nos.", WorkDate());

        // Determine deposit to apply (capped to total amount)
        DepositToApply := 0;
        if Reservation."Deposit Captured" then
            DepositToApply := Reservation."Deposit Amount";
        if DepositToApply > Reservation."Total Amount" then
            DepositToApply := Reservation."Total Amount";

        Clear(PostedInvoice);
        PostedInvoice.Init();
        PostedInvoice."No." := InvoiceNo;
        PostedInvoice."Reservation No." := Reservation."No.";
        PostedInvoice."Customer No." := Reservation."Customer No.";
        PostedInvoice."Customer Name" := Reservation."Customer Name";
        PostedInvoice."Posting Date" := WorkDate();
        PostedInvoice."Room No." := Reservation."Room No.";
        PostedInvoice."Check-in Date" := Reservation."Check-in Date";
        PostedInvoice."Check-out Date" := Reservation."Check-out Date";
        PostedInvoice."Room Charges" := Reservation."Room Charges";
        Reservation.CalcFields("Service Charges Total");
        PostedInvoice."Service Charges" := Reservation."Service Charges Total";
        PostedInvoice."Amount Excl. VAT" := Reservation."Amount Excl. VAT";
        PostedInvoice."VAT %" := Reservation."VAT %";
        PostedInvoice."VAT Amount" := Reservation."VAT Amount";
        PostedInvoice."Amount Incl. VAT" := Reservation."Total Amount";
        PostedInvoice."Deposit Applied" := DepositToApply;
        PostedInvoice."Amount Due" := Reservation."Total Amount" - DepositToApply;
        PostedInvoice."Posted By" := CopyStr(UserId(), 1, MaxStrLen(PostedInvoice."Posted By"));
        PostedInvoice.Insert();

        // Apply the deposit as a payment entry against the invoice
        if DepositToApply > 0 then
            LogPayment(Reservation, InvoiceNo, "Hotel Payment Type"::Payment, DepositToApply, DepositAppliedTxt, true, '');

        Reservation."Invoice No." := InvoiceNo;
        Reservation.Invoiced := true;
        Reservation."Paid Amount" := DepositToApply;
        Reservation."Amount Due" := Reservation."Total Amount" - DepositToApply;
        Reservation.Modify(true);

        exit(true);
    end;

    local procedure LogPayment(Reservation: Record "Hotel Reservation"; InvoiceNo: Code[20]; EntryType: Enum "Hotel Payment Type"; Amount: Decimal; Description: Text[100]; Successful: Boolean; ExternalRef: Code[35])
    var
        Entry: Record "Hotel Payment Entry";
    begin
        Clear(Entry);
        Entry.Init();
        Entry."Reservation No." := Reservation."No.";
        Entry."Invoice No." := InvoiceNo;
        Entry."Posting Date" := WorkDate();
        Entry."Entry Type" := EntryType;
        Entry.Amount := Amount;
        Entry.Description := Description;
        Entry.Successful := Successful;
        Entry."User ID" := CopyStr(UserId(), 1, MaxStrLen(Entry."User ID"));
        Entry."External Reference" := ExternalRef;
        Entry.Insert(true);
    end;

    var
        DuplicateInvoiceErr: Label 'Reservation %1 has already been invoiced as %2. A reservation may be invoiced only once.', Comment = '%1=Reservation, %2=Existing invoice';
        MissingDatesErr: Label 'Reservation %1 is missing check-in or check-out dates.', Comment = '%1=Reservation No.';
        MissingRoomErr: Label 'Reservation %1 has no room assigned.', Comment = '%1=Reservation No.';
        MissingCustomerErr: Label 'Reservation %1 has no customer assigned.', Comment = '%1=Reservation No.';
        DepositAppliedTxt: Label 'Deposit applied to invoice';
}
