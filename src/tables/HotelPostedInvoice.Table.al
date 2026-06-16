table 50004 "Hotel Posted Invoice"
{
    Caption = 'Hotel Posted Invoice';
    DataClassification = CustomerContent;
    LookupPageId = "Hotel Posted Invoices";
    DrillDownPageId = "Hotel Posted Invoices";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; "Reservation No."; Code[20])
        {
            Caption = 'Reservation No.';
            TableRelation = "Hotel Reservation";
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(4; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Room No."; Code[20])
        {
            Caption = 'Room No.';
        }
        field(7; "Check-in Date"; Date)
        {
            Caption = 'Check-in Date';
        }
        field(8; "Check-out Date"; Date)
        {
            Caption = 'Check-out Date';
        }
        field(10; "Room Charges"; Decimal)
        {
            Caption = 'Room Charges';
            AutoFormatType = 2;
        }
        field(11; "Service Charges"; Decimal)
        {
            Caption = 'Service Charges';
            AutoFormatType = 2;
        }
        field(12; "Amount Excl. VAT"; Decimal)
        {
            Caption = 'Amount Excl. VAT';
            AutoFormatType = 2;
        }
        field(13; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            DecimalPlaces = 0 : 5;
        }
        field(14; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            AutoFormatType = 2;
        }
        field(15; "Amount Incl. VAT"; Decimal)
        {
            Caption = 'Amount Incl. VAT';
            AutoFormatType = 2;
        }
        field(16; "Deposit Applied"; Decimal)
        {
            Caption = 'Deposit Applied';
            AutoFormatType = 2;
        }
        field(17; "Amount Due"; Decimal)
        {
            Caption = 'Amount Due';
            AutoFormatType = 2;
        }
        field(20; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            TableRelation = User."User Name";
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(Reservation; "Reservation No.") { }
        key(Customer; "Customer No.", "Posting Date") { }
    }

    fieldgroups
    {
        fieldgroup(Brick; "No.", "Customer Name", "Posting Date", "Amount Incl. VAT") { }
    }
}
