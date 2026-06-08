table 50003 "Hotel Setup"
{
    Caption = 'Hotel Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            MinValue = 0;
            MaxValue = 100;
            DecimalPlaces = 0 : 5;
        }
        field(20; "Reservation Nos."; Code[20])
        {
            Caption = 'Reservation Nos.';
            TableRelation = "No. Series";
        }
        field(21; "Invoice Nos."; Code[20])
        {
            Caption = 'Invoice Nos.';
            TableRelation = "No. Series";
        }
        field(22; "Payment Nos."; Code[20])
        {
            Caption = 'Payment Nos.';
            TableRelation = "No. Series";
        }
        field(30; "Default Currency Code"; Code[10])
        {
            Caption = 'Default Currency Code';
            TableRelation = Currency;
        }
        field(40; "Finance Permission Set"; Code[20])
        {
            Caption = 'Finance Permission Set ID';
            InitValue = 'HOTEL FINANCE';
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }

    procedure GetSetup()
    begin
        if not Get('') then begin
            Init();
            "Primary Key" := '';
            Insert();
        end;
    end;
}
