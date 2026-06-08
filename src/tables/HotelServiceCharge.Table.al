table 50002 "Hotel Service Charge"
{
    Caption = 'Hotel Service Charge';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Reservation No."; Code[20])
        {
            Caption = 'Reservation No.';
            NotBlank = true;
            TableRelation = "Hotel Reservation";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Service Type"; Enum "Hotel Service Type")
        {
            Caption = 'Service Type';

            trigger OnValidate()
            begin
                if Description = '' then
                    Description := Format("Service Type");
            end;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(6; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            MinValue = 0;
            AutoFormatType = 2;

            trigger OnValidate()
            begin
                CalcAmount();
            end;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
            MinValue = 0;
            AutoFormatType = 2;
        }
        field(8; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(9; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            Editable = false;
            TableRelation = User."User Name";
        }
    }

    keys
    {
        key(PK; "Reservation No.", "Line No.") { Clustered = true; }
        key(Type; "Service Type") { }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Service Type", Description, Quantity, "Unit Price", Amount) { }
    }

    trigger OnInsert()
    var
        Reservation: Record "Hotel Reservation";
    begin
        Reservation.Get("Reservation No.");
        if Reservation.Invoiced then
            Error(ReservationInvoicedErr, "Reservation No.");
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();
        "Posted By" := CopyStr(UserId(), 1, MaxStrLen("Posted By"));
        if Quantity = 0 then
            Quantity := 1;
        CalcAmount();
    end;

    trigger OnModify()
    var
        Reservation: Record "Hotel Reservation";
    begin
        Reservation.Get("Reservation No.");
        if Reservation.Invoiced then
            Error(ReservationInvoicedErr, "Reservation No.");
        CalcAmount();
    end;

    trigger OnDelete()
    var
        Reservation: Record "Hotel Reservation";
    begin
        if Reservation.Get("Reservation No.") then
            if Reservation.Invoiced then
                Error(ReservationInvoicedErr, "Reservation No.");
    end;

    var
        ReservationInvoicedErr: Label 'Reservation %1 has already been invoiced; service charges cannot be changed.', Comment = '%1=Reservation No.';

    local procedure CalcAmount()
    begin
        Amount := Round(Quantity * "Unit Price", 0.01);
    end;
}
