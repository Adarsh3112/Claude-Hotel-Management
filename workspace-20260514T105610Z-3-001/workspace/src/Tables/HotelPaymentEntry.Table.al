table 50104 "Hotel Payment Entry"
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
            TableRelation = "Hotel Reservation"."Reservation No.";
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Payment Kind"; Enum "Hotel Payment Kind")
        {
            Caption = 'Payment Kind';
        }
        field(5; Amount; Decimal)
        {
            Caption = 'Amount';
            DecimalPlaces = 2 : 2;
        }
        field(6; Status; Enum "Hotel Payment Status")
        {
            Caption = 'Status';
        }
        field(7; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(9; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            TableRelation = "Hotel Invoice Header"."Invoice No.";
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Reservation; "Reservation No.", "Payment Kind", Status) { }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Entry No.", "Reservation No.", "Payment Kind", Amount, Status) { }
    }
}
