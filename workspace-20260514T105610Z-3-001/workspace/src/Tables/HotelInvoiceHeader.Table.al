table 50105 "Hotel Invoice Header"
{
    Caption = 'Hotel Invoice Header';
    DataClassification = CustomerContent;
    LookupPageId = "Hotel Invoice List";
    DrillDownPageId = "Hotel Invoice List";

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            NotBlank = true;
        }
        field(2; "Reservation No."; Code[20])
        {
            Caption = 'Reservation No.';
            TableRelation = "Hotel Reservation"."Reservation No.";
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(4; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; Subtotal; Decimal)
        {
            Caption = 'Subtotal';
            DecimalPlaces = 2 : 2;
        }
        field(7; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
        }
        field(8; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            DecimalPlaces = 2 : 2;
        }
        field(9; "Total Incl. VAT"; Decimal)
        {
            Caption = 'Total Incl. VAT';
            DecimalPlaces = 2 : 2;
        }
        field(10; "Deposit Applied"; Decimal)
        {
            Caption = 'Deposit Applied';
            DecimalPlaces = 2 : 2;
        }
        field(11; "Amount Due"; Decimal)
        {
            Caption = 'Amount Due';
            DecimalPlaces = 2 : 2;
        }
        field(12; Paid; Boolean)
        {
            Caption = 'Paid';
        }
        field(13; Posted; Boolean)
        {
            Caption = 'Posted';
        }
    }

    keys
    {
        key(PK; "Invoice No.")
        {
            Clustered = true;
        }
        key(Reservation; "Reservation No.") { }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Invoice No.", "Customer Name", "Total Incl. VAT", "Amount Due", Paid) { }
    }
}
