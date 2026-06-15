codeunit 50103 "Hotel VAT Mgt"
{
    Permissions = tabledata "Hotel Setup" = r,
                  tabledata "Hotel Invoice Header" = rm,
                  tabledata "Hotel Invoice Line" = r;

    procedure GetCurrentVATPercent(): Decimal
    var
        HotelSetup: Record "Hotel Setup";
    begin
        HotelSetup.GetSingleton();
        exit(HotelSetup."VAT %");
    end;

    procedure CalculateVAT(SubTotal: Decimal; VATPercent: Decimal): Decimal
    begin
        if VATPercent <= 0 then
            exit(0);
        exit(Round(SubTotal * VATPercent / 100, 0.01));
    end;

    procedure RecalculateInvoice(var Invoice: Record "Hotel Invoice Header")
    var
        InvoiceLine: Record "Hotel Invoice Line";
        Reservation: Record "Hotel Reservation";
        NewVATPercent: Decimal;
        Subtotal: Decimal;
    begin
        if Invoice.Posted then
            Error(CannotRecalcPostedErr, Invoice."Invoice No.");

        InvoiceLine.SetRange("Invoice No.", Invoice."Invoice No.");
        InvoiceLine.CalcSums("Line Amount");
        Subtotal := InvoiceLine."Line Amount";

        NewVATPercent := GetCurrentVATPercent();
        Invoice.Subtotal := Subtotal;
        Invoice."VAT %" := NewVATPercent;
        Invoice."VAT Amount" := CalculateVAT(Subtotal, NewVATPercent);
        Invoice."Total Incl. VAT" := Subtotal + Invoice."VAT Amount";
        Invoice."Amount Due" := Invoice."Total Incl. VAT" - Invoice."Deposit Applied";
        if Invoice."Amount Due" < 0 then
            Invoice."Amount Due" := 0;
        Invoice.Modify(true);

        if Reservation.Get(Invoice."Reservation No.") then begin
            Reservation."Total Amount" := Invoice."Total Incl. VAT";
            Reservation."VAT Amount" := Invoice."VAT Amount";
            Reservation."Amount Due" := Invoice."Amount Due";
            Reservation.Modify(true);
        end;
    end;

    var
        CannotRecalcPostedErr: Label 'Invoice %1 is already posted and cannot be recalculated.';
}
