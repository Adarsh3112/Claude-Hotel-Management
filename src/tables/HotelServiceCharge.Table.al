table 50102 "Hotel Service Charge"
{
    Caption = 'Hotel Service Charge';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Reservation No."; Code[20])
        {
            Caption = 'Reservation No.';
            NotBlank = true;
            TableRelation = "Hotel Reservation"."Reservation No.";
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
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
    }

    keys
    {
        key(PK; "Reservation No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        Reservation: Record "Hotel Reservation";
    begin
        if Reservation.Get("Reservation No.") then
            if Reservation."Invoice Generated" then
                Error(CannotAddAfterInvoiceErr, "Reservation No.");
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();
    end;

    var
        CannotAddAfterInvoiceErr: Label 'Service charges cannot be added to reservation %1 because an invoice has already been generated.';
}
