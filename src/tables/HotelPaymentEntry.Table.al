table 50005 "Hotel Payment Entry"
{
    Caption = 'Hotel Payment Entry';
    DataClassification = CustomerContent;
    LookupPageId = "Hotel Payment Entries";
    DrillDownPageId = "Hotel Payment Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Reservation No."; Code[20])
        {
            Caption = 'Reservation No.';
            TableRelation = "Hotel Reservation";
        }
        field(3; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            TableRelation = "Hotel Posted Invoice"."No.";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Entry Type"; Enum "Hotel Payment Type")
        {
            Caption = 'Entry Type';
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 2;
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; Successful; Boolean)
        {
            Caption = 'Successful';
        }
        field(9; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
        }
        field(10; "External Reference"; Code[35])
        {
            Caption = 'External Reference';
        }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(Reservation; "Reservation No.", "Entry Type") { }
        key(Invoice; "Invoice No.") { }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Entry No.", "Reservation No.", "Entry Type", Amount, Successful) { }
    }
}
