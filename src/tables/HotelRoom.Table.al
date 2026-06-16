table 50000 "Hotel Room"
{
    Caption = 'Hotel Room';
    DataClassification = CustomerContent;
    LookupPageId = "Hotel Room List";
    DrillDownPageId = "Hotel Room List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Room Type"; Enum "Hotel Room Type")
        {
            Caption = 'Room Type';
        }
        field(4; "Nightly Rate"; Decimal)
        {
            Caption = 'Nightly Rate';
            MinValue = 0;
            AutoFormatType = 2;
        }
        field(5; Occupied; Boolean)
        {
            Caption = 'Occupied';
            Editable = false;
        }
        field(6; Floor; Integer)
        {
            Caption = 'Floor';
        }
        field(7; "Max Occupancy"; Integer)
        {
            Caption = 'Max Occupancy';
            MinValue = 0;
        }
        field(8; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(RoomType; "Room Type") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Room Type", "Nightly Rate", Occupied) { }
        fieldgroup(Brick; "No.", Description, "Room Type", "Nightly Rate", Occupied) { }
    }

    trigger OnDelete()
    var
        Reservation: Record "Hotel Reservation";
    begin
        Reservation.SetRange("Room No.", "No.");
        Reservation.SetFilter(Status, '<>%1', Reservation.Status::Closed);
        if not Reservation.IsEmpty() then
            Error(CannotDeleteRoomErr, "No.");
    end;

    var
        CannotDeleteRoomErr: Label 'Room %1 cannot be deleted because it has open reservations.', Comment = '%1 = Room No.';
}
