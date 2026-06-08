table 50001 "Hotel Reservation"
{
    Caption = 'Hotel Reservation';
    DataClassification = CustomerContent;
    LookupPageId = "Hotel Reservation List";
    DrillDownPageId = "Hotel Reservation List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
                if "Customer No." = '' then begin
                    "Customer Name" := '';
                    exit;
                end;
                Cust.Get("Customer No.");
                "Customer Name" := Cust.Name;
            end;
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(4; "Room No."; Code[20])
        {
            Caption = 'Room No.';
            TableRelation = "Hotel Room";

            trigger OnValidate()
            var
                Room: Record "Hotel Room";
            begin
                if "Room No." = '' then begin
                    "Nightly Rate" := 0;
                    CalcRoomCharges();
                    exit;
                end;
                Room.Get("Room No.");
                if Room.Blocked then
                    Error(RoomBlockedErr, Room."No.");
                "Nightly Rate" := Room."Nightly Rate";
                CalcRoomCharges();
                CheckOverbooking();
            end;
        }
        field(5; "Check-in Date"; Date)
        {
            Caption = 'Check-in Date';

            trigger OnValidate()
            begin
                ValidateDates();
                CalcRoomCharges();
                CheckOverbooking();
            end;
        }
        field(6; "Check-out Date"; Date)
        {
            Caption = 'Check-out Date';

            trigger OnValidate()
            begin
                ValidateDates();
                CalcRoomCharges();
                CheckOverbooking();
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
            AutoFormatType = 2;
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
            TableRelation = "Hotel Posted Invoice"."No.";
        }
        field(11; Invoiced; Boolean)
        {
            Caption = 'Invoiced';
            Editable = false;
        }
        field(12; "Nightly Rate"; Decimal)
        {
            Caption = 'Nightly Rate';
            MinValue = 0;
            AutoFormatType = 2;
        }
        field(13; "Room Charges"; Decimal)
        {
            Caption = 'Room Charges';
            Editable = false;
            AutoFormatType = 2;
        }
        field(14; "Service Charges Total"; Decimal)
        {
            Caption = 'Service Charges';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Hotel Service Charge".Amount where("Reservation No." = field("No.")));
            AutoFormatType = 2;
        }
        field(15; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
            Editable = false;
            DecimalPlaces = 0 : 5;
        }
        field(16; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            Editable = false;
            AutoFormatType = 2;
        }
        field(17; "Amount Excl. VAT"; Decimal)
        {
            Caption = 'Amount Excl. VAT';
            Editable = false;
            AutoFormatType = 2;
        }
        field(18; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount (Incl. VAT)';
            Editable = false;
            AutoFormatType = 2;
        }
        field(19; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount';
            Editable = false;
            AutoFormatType = 2;
        }
        field(20; "Refunded Amount"; Decimal)
        {
            Caption = 'Refunded Amount';
            Editable = false;
            AutoFormatType = 2;
        }
        field(21; "Amount Due"; Decimal)
        {
            Caption = 'Amount Due';
            Editable = false;
            AutoFormatType = 2;
        }
        field(22; "Checked In At"; DateTime)
        {
            Caption = 'Checked In At';
            Editable = false;
        }
        field(23; "Checked Out At"; DateTime)
        {
            Caption = 'Checked Out At';
            Editable = false;
        }
        field(24; "Created At"; DateTime)
        {
            Caption = 'Created At';
            Editable = false;
        }
        field(25; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
            TableRelation = User."User Name";
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(Room; "Room No.", "Check-in Date") { }
        key(Status; Status) { }
        key(Customer; "Customer No.") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Customer Name", "Room No.", "Check-in Date", Status) { }
        fieldgroup(Brick; "No.", "Customer Name", "Room No.", "Check-in Date", "Check-out Date", Status) { }
    }

    trigger OnInsert()
    var
        Setup: Record "Hotel Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            Setup.GetSetup();
            Setup.TestField("Reservation Nos.");
            "No." := NoSeries.GetNextNo(Setup."Reservation Nos.", WorkDate());
        end;
        "Created At" := CurrentDateTime();
        "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
    end;

    trigger OnDelete()
    begin
        if Status = Status::Occupied then
            Error(CannotDeleteOccupiedErr, "No.");
        if Invoiced then
            Error(CannotDeleteInvoicedErr, "No.");
    end;

    var
        CheckOutAfterCheckInErr: Label 'Check-out Date must be after Check-in Date.';
        OverbookingErr: Label 'Room %1 is already reserved by %2 between %3 and %4.', Comment = '%1=Room, %2=Other reservation, %3=Other check-in, %4=Other check-out';
        RoomBlockedErr: Label 'Room %1 is blocked and cannot be reserved.', Comment = '%1=Room No.';
        CannotDeleteOccupiedErr: Label 'Reservation %1 cannot be deleted while it is occupied.', Comment = '%1=Reservation No.';
        CannotDeleteInvoicedErr: Label 'Reservation %1 cannot be deleted because it has been invoiced.', Comment = '%1=Reservation No.';

    local procedure ValidateDates()
    begin
        if ("Check-in Date" = 0D) or ("Check-out Date" = 0D) then
            exit;
        if "Check-out Date" <= "Check-in Date" then
            Error(CheckOutAfterCheckInErr);
    end;

    local procedure CalcRoomCharges()
    var
        Nights: Integer;
    begin
        Nights := 0;
        if ("Check-in Date" <> 0D) and ("Check-out Date" <> 0D) and ("Check-out Date" > "Check-in Date") then
            Nights := "Check-out Date" - "Check-in Date";
        "Room Charges" := "Nightly Rate" * Nights;
    end;

    procedure CheckOverbooking()
    var
        Other: Record "Hotel Reservation";
    begin
        if ("Room No." = '') or ("Check-in Date" = 0D) or ("Check-out Date" = 0D) then
            exit;
        Other.SetRange("Room No.", "Room No.");
        Other.SetFilter("No.", '<>%1', "No.");
        Other.SetFilter(Status, '%1|%2', Other.Status::Confirmed, Other.Status::Occupied);
        if Other.FindSet() then
            repeat
                if (Other."Check-in Date" < "Check-out Date") and (Other."Check-out Date" > "Check-in Date") then
                    Error(OverbookingErr, "Room No.", Other."No.", Other."Check-in Date", Other."Check-out Date");
            until Other.Next() = 0;
    end;

    procedure RecalcTotals()
    var
        Setup: Record "Hotel Setup";
        Base: Decimal;
    begin
        Setup.GetSetup();
        CalcFields("Service Charges Total");
        "VAT %" := Setup."VAT %";
        Base := "Room Charges" + "Service Charges Total";
        "Amount Excl. VAT" := Base;
        "VAT Amount" := Round(Base * "VAT %" / 100, 0.01);
        "Total Amount" := "Amount Excl. VAT" + "VAT Amount";
        "Amount Due" := "Total Amount" - "Paid Amount" + "Refunded Amount";
    end;
}
