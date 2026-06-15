table 50103 "Hotel Setup"
{
    Caption = 'Hotel Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 5;
        }
        field(3; "Default Currency"; Code[10])
        {
            Caption = 'Default Currency';
        }
        field(10; "Reservation No. Prefix"; Code[10])
        {
            Caption = 'Reservation No. Prefix';
        }
        field(11; "Invoice No. Prefix"; Code[10])
        {
            Caption = 'Invoice No. Prefix';
        }
        field(12; "Last Reservation No."; Integer)
        {
            Caption = 'Last Reservation No.';
        }
        field(13; "Last Invoice No."; Integer)
        {
            Caption = 'Last Invoice No.';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetSingleton()
    begin
        if not Get('') then begin
            Init();
            "Primary Key" := '';
            "VAT %" := 0;
            "Reservation No. Prefix" := 'RES';
            "Invoice No. Prefix" := 'INV';
            Insert();
        end;
    end;

    procedure NextReservationNo(): Code[20]
    begin
        GetSingleton();
        "Last Reservation No." += 1;
        Modify();
        exit(CopyStr("Reservation No. Prefix" + PadStr('', 5 - StrLen(Format("Last Reservation No.")), '0') + Format("Last Reservation No."), 1, 20));
    end;

    procedure NextInvoiceNo(): Code[20]
    begin
        GetSingleton();
        "Last Invoice No." += 1;
        Modify();
        exit(CopyStr("Invoice No. Prefix" + PadStr('', 5 - StrLen(Format("Last Invoice No.")), '0') + Format("Last Invoice No."), 1, 20));
    end;
}
