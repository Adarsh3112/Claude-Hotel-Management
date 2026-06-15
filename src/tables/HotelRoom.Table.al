table 50100 "Hotel Room"
{
    Caption = 'Hotel Room';
    DataClassification = CustomerContent;
    LookupPageId = "Hotel Room List";
    DrillDownPageId = "Hotel Room List";

    fields
    {
        field(1; "Room No."; Code[20])
        {
            Caption = 'Room No.';
            NotBlank = true;
        }
        field(2; "Room Type"; Code[20])
        {
            Caption = 'Room Type';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Nightly Rate"; Decimal)
        {
            Caption = 'Nightly Rate';
            MinValue = 0;
            DecimalPlaces = 2 : 2;
        }
        field(5; Occupied; Boolean)
        {
            Caption = 'Occupied';
            Editable = false;
        }
        field(6; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
    }

    keys
    {
        key(PK; "Room No.")
        {
            Clustered = true;
        }
        key(Type; "Room Type") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Room No.", "Room Type", "Nightly Rate", Occupied) { }
        fieldgroup(Brick; "Room No.", "Room Type", "Nightly Rate") { }
    }

    trigger OnDelete()
    var
        Reservation: Record "Hotel Reservation";
    begin
        Reservation.SetRange("Room No.", "Room No.");
        Reservation.SetFilter(Status, '<>%1', Reservation.Status::Closed);
        if not Reservation.IsEmpty() then
            Error(CannotDeleteActiveRoomErr, "Room No.");
    end;

    var
        CannotDeleteActiveRoomErr: Label 'Room %1 cannot be deleted because it has active reservations.';
}
