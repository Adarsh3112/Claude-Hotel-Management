table 50106 "Hotel Invoice Line"
{
    Caption = 'Hotel Invoice Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            NotBlank = true;
            TableRelation = "Hotel Invoice Header"."Invoice No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Line Type"; Enum "Hotel Invoice Line Type")
        {
            Caption = 'Type';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(6; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DecimalPlaces = 2 : 2;
        }
        field(7; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            DecimalPlaces = 2 : 2;
        }
    }

    keys
    {
        key(PK; "Invoice No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
