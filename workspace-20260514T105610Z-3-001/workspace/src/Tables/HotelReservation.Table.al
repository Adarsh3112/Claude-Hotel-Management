table 50101 "Hotel Reservation"
{
    Caption = 'Hotel Reservation';
    DataClassification = CustomerContent;
    LookupPageId = "Hotel Reservation List";
    DrillDownPageId = "Hotel Reservation List";

    fields
    {
        field(1; "Reservation No."; Code[20])
        {
            Caption = 'Reservation No.';
            NotBlank = true;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if "Customer No." = '' then begin
                    "Customer Name" := '';
                    exit;
                end;
                Customer.Get("Customer No.");
                "Customer Name" := Customer.Name;
            end;
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(4; "Room No."; Code[20])
        {
            Caption = 'Room No.';
            TableRelation = "Hotel Room"."Room No.";
        }
        field(5; "Check-in Date"; Date)
        {
            Caption = 'Check-in Date';
        }
        field(6; "Check-out Date"; Date)
        {
            Caption = 'Check-out Date';

            trigger OnValidate()
            begin
                if ("Check-out Date" <> 0D) and ("Check-in Date" <> 0D) then
                    if "Check-out Date" <= "Check-in Date" then
                        Error(CheckoutBeforeCheckinErr);
            end;
        }
        field(7; Status; Enum "Hotel Reservation Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(8; "Deposit Amount"; Decimal)
        {
            Caption = 'Deposit Amount';
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
        field(9; "Deposit Captured"; Boolean)
        {
            Caption = 'Deposit Captured';
            Editable = false;
        }
        field(10; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            Editable = false;
            TableRelation = "Hotel Invoice Header"."Invoice No.";
        }
        field(11; "Invoice Generated"; Boolean)
        {
            Caption = 'Invoice Generated';
            Editable = false;
        }
        field(12; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount (Incl. VAT)';
            Editable = false;
            DecimalPlaces = 2 : 2;
        }
        field(13; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Editable = false;
            DecimalPlaces = 2 : 2;
        }
        field(14; "Amount Due"; Decimal)
        {
            Caption = 'Amount Due';
            Editable = false;
            DecimalPlaces = 2 : 2;
        }
        field(15; "Amount Paid"; Decimal)
        {
            Caption = 'Amount Paid';
            Editable = false;
            DecimalPlaces = 2 : 2;
        }
        field(20; "Service Charges Total"; Decimal)
        {
            Caption = 'Service Charges Total';
            FieldClass = FlowField;
            CalcFormula = sum("Hotel Service Charge".Amount where("Reservation No." = field("Reservation No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Reservation No.")
        {
            Clustered = true;
        }
        key(Room; "Room No.", "Check-in Date", "Check-out Date") { }
        key(Customer; "Customer No.") { }
        key(StatusKey; Status) { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Reservation No.", "Customer Name", "Room No.", Status) { }
        fieldgroup(Brick; "Reservation No.", "Customer Name", "Room No.", "Check-in Date", "Check-out Date", Status) { }
    }

    trigger OnDelete()
    var
        ServiceCharge: Record "Hotel Service Charge";
    begin
        if Status <> Status::Closed then
            Error(CannotDeleteActiveReservationErr, "Reservation No.");
        ServiceCharge.SetRange("Reservation No.", "Reservation No.");
        ServiceCharge.DeleteAll();
    end;

    var
        CheckoutBeforeCheckinErr: Label 'Check-out Date must be after Check-in Date.';
        CannotDeleteActiveReservationErr: Label 'Reservation %1 cannot be deleted because it is not closed.';
}
