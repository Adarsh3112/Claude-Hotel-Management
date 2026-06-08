codeunit 50051 "Hotel Tax"
{
    Access = Public;

    procedure GetCurrentVATPercent(): Decimal
    var
        Setup: Record "Hotel Setup";
    begin
        Setup.GetSetup();
        exit(Setup."VAT %");
    end;

    procedure CalcVAT(BaseAmount: Decimal; VATPercent: Decimal): Decimal
    begin
        if VATPercent <= 0 then
            exit(0);
        exit(Round(BaseAmount * VATPercent / 100, 0.01));
    end;

    procedure RecalcReservationTax(var Reservation: Record "Hotel Reservation")
    begin
        if Reservation.Invoiced then
            Error(AlreadyInvoicedErr, Reservation."No.");
        Reservation.RecalcTotals();
        Reservation.Modify(true);
    end;

    var
        AlreadyInvoicedErr: Label 'Reservation %1 has already been invoiced; tax cannot be recalculated.', Comment = '%1=Reservation No.';
}
