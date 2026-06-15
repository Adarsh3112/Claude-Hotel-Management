codeunit 50102 "Hotel Billing Mgt"
{
    Permissions = tabledata "Hotel Invoice Header" = rimd,
                  tabledata "Hotel Invoice Line" = rimd,
                  tabledata "Hotel Reservation" = rm,
                  tabledata "Hotel Service Charge" = r;

    procedure GenerateInvoice(var Reservation: Record "Hotel Reservation") InvoiceNo: Code[20]
    var
        InvoiceHeader: Record "Hotel Invoice Header";
        InvoiceLine: Record "Hotel Invoice Line";
        ServiceCharge: Record "Hotel Service Charge";
        Room: Record "Hotel Room";
        VATMgt: Codeunit "Hotel VAT Mgt";
        HotelSetup: Record "Hotel Setup";
        LineNo: Integer;
        Nights: Integer;
        Subtotal: Decimal;
        VATPercent: Decimal;
    begin
        Reservation.TestField("Reservation No.");

        if Reservation."Invoice Generated" then
            Error(DuplicateInvoiceErr, Reservation."Reservation No.");

        // Defensive: existing invoice for this reservation also blocks
        InvoiceHeader.SetRange("Reservation No.", Reservation."Reservation No.");
        if not InvoiceHeader.IsEmpty() then
            Error(DuplicateInvoiceErr, Reservation."Reservation No.");
        InvoiceHeader.Reset();

        HotelSetup.GetSingleton();
        InvoiceNo := HotelSetup.NextInvoiceNo();

        InvoiceHeader.Init();
        InvoiceHeader."Invoice No." := InvoiceNo;
        InvoiceHeader."Reservation No." := Reservation."Reservation No.";
        InvoiceHeader."Customer No." := Reservation."Customer No.";
        InvoiceHeader."Customer Name" := Reservation."Customer Name";
        InvoiceHeader."Posting Date" := WorkDate();
        InvoiceHeader.Insert(true);

        LineNo := 0;

        // Room line
        if Room.Get(Reservation."Room No.") then begin
            Nights := Reservation."Check-out Date" - Reservation."Check-in Date";
            if Nights < 1 then
                Nights := 1;
            LineNo += 10000;
            InvoiceLine.Init();
            InvoiceLine."Invoice No." := InvoiceNo;
            InvoiceLine."Line No." := LineNo;
            InvoiceLine."Line Type" := InvoiceLine."Line Type"::Room;
            InvoiceLine.Description := CopyStr(StrSubstNo(RoomLineDescTxt, Room."Room No.", Nights), 1, MaxStrLen(InvoiceLine.Description));
            InvoiceLine.Quantity := Nights;
            InvoiceLine."Unit Price" := Room."Nightly Rate";
            InvoiceLine."Line Amount" := Nights * Room."Nightly Rate";
            InvoiceLine.Insert(true);
            Subtotal += InvoiceLine."Line Amount";
        end;

        // Service charge lines
        ServiceCharge.SetRange("Reservation No.", Reservation."Reservation No.");
        if ServiceCharge.FindSet() then
            repeat
                LineNo += 10000;
                InvoiceLine.Init();
                InvoiceLine."Invoice No." := InvoiceNo;
                InvoiceLine."Line No." := LineNo;
                InvoiceLine."Line Type" := InvoiceLine."Line Type"::Service;
                InvoiceLine.Description := ServiceCharge.Description;
                InvoiceLine.Quantity := 1;
                InvoiceLine."Unit Price" := ServiceCharge.Amount;
                InvoiceLine."Line Amount" := ServiceCharge.Amount;
                InvoiceLine.Insert(true);
                Subtotal += ServiceCharge.Amount;
            until ServiceCharge.Next() = 0;

        // VAT - read CURRENT rate so changes before invoicing take effect
        VATPercent := VATMgt.GetCurrentVATPercent();
        InvoiceHeader.Subtotal := Subtotal;
        InvoiceHeader."VAT %" := VATPercent;
        InvoiceHeader."VAT Amount" := VATMgt.CalculateVAT(Subtotal, VATPercent);
        InvoiceHeader."Total Incl. VAT" := Subtotal + InvoiceHeader."VAT Amount";
        InvoiceHeader."Deposit Applied" := Reservation."Deposit Amount";
        InvoiceHeader."Amount Due" := InvoiceHeader."Total Incl. VAT" - InvoiceHeader."Deposit Applied";
        if InvoiceHeader."Amount Due" < 0 then
            InvoiceHeader."Amount Due" := 0;
        InvoiceHeader.Posted := true;
        InvoiceHeader.Paid := InvoiceHeader."Amount Due" = 0;
        InvoiceHeader.Modify(true);

        Reservation."Invoice No." := InvoiceNo;
        Reservation."Invoice Generated" := true;
        Reservation."Total Amount" := InvoiceHeader."Total Incl. VAT";
        Reservation."VAT Amount" := InvoiceHeader."VAT Amount";
        Reservation."Amount Due" := InvoiceHeader."Amount Due";
        Reservation.Modify(true);
    end;

    var
        DuplicateInvoiceErr: Label 'Reservation %1 already has an invoice. Duplicate invoices are not allowed.';
        RoomLineDescTxt: Label 'Room %1 - %2 night(s)';
}
