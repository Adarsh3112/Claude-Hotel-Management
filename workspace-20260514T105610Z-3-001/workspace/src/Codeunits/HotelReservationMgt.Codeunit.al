codeunit 50100 "Hotel Reservation Mgt"
{
    Permissions = tabledata "Hotel Reservation" = rimd,
                  tabledata "Hotel Room" = rm;

    procedure CreateReservation(CustomerNo: Code[20]; CheckInDate: Date; CheckOutDate: Date) ReservationNo: Code[20]
    var
        Reservation: Record "Hotel Reservation";
        HotelSetup: Record "Hotel Setup";
    begin
        if CustomerNo = '' then
            Error(CustomerRequiredErr);
        if (CheckInDate = 0D) or (CheckOutDate = 0D) then
            Error(DatesRequiredErr);
        if CheckOutDate <= CheckInDate then
            Error(InvalidDateRangeErr);

        HotelSetup.GetSingleton();
        ReservationNo := HotelSetup.NextReservationNo();

        Reservation.Init();
        Reservation."Reservation No." := ReservationNo;
        Reservation.Validate("Customer No.", CustomerNo);
        Reservation."Check-in Date" := CheckInDate;
        Reservation.Validate("Check-out Date", CheckOutDate);
        Reservation.Status := Reservation.Status::Confirmed;
        Reservation.Insert(true);
    end;

    procedure AssignRoom(var Reservation: Record "Hotel Reservation"; RoomNo: Code[20])
    var
        Room: Record "Hotel Room";
    begin
        Reservation.TestField("Reservation No.");
        if Reservation.Status = Reservation.Status::Closed then
            Error(ReservationClosedErr, Reservation."Reservation No.");
        Room.Get(RoomNo);
        if Room.Blocked then
            Error(RoomBlockedErr, RoomNo);

        if HasOverlap(RoomNo, Reservation."Check-in Date", Reservation."Check-out Date", Reservation."Reservation No.") then
            Error(OverbookingErr, RoomNo);

        Reservation."Room No." := RoomNo;
        Reservation.Modify(true);
    end;

    procedure CheckIn(var Reservation: Record "Hotel Reservation")
    var
        Room: Record "Hotel Room";
    begin
        Reservation.TestField("Reservation No.");
        Reservation.TestField("Room No.");
        if Reservation.Status <> Reservation.Status::Confirmed then
            Error(MustBeConfirmedErr, Reservation."Reservation No.");
        if not Reservation."Deposit Captured" then
            Error(DepositRequiredErr, Reservation."Reservation No.");

        Room.Get(Reservation."Room No.");
        if Room.Occupied then
            Error(RoomAlreadyOccupiedErr, Room."Room No.");
        Room.Occupied := true;
        Room.Modify(true);

        Reservation.Status := Reservation.Status::Occupied;
        Reservation.Modify(true);
    end;

    procedure CheckOut(var Reservation: Record "Hotel Reservation")
    begin
        // Front Desk operational checkout: validate state and release the
        // room. Invoice generation, final payment and closing the reservation
        // are Finance responsibilities and are handled by separate codeunits.
        Reservation.TestField("Reservation No.");
        if Reservation.Status <> Reservation.Status::Occupied then
            Error(MustBeOccupiedErr, Reservation."Reservation No.");

        ReleaseRoom(Reservation."Room No.");
        Reservation.Modify(true);
    end;

    procedure CloseReservation(var Reservation: Record "Hotel Reservation")
    begin
        Reservation.Status := Reservation.Status::Closed;
        Reservation.Modify(true);
    end;

    procedure ReleaseRoom(RoomNo: Code[20])
    var
        Room: Record "Hotel Room";
    begin
        if RoomNo = '' then
            exit;
        if Room.Get(RoomNo) then begin
            Room.Occupied := false;
            Room.Modify(true);
        end;
    end;

    procedure HasOverlap(RoomNo: Code[20]; CheckIn: Date; CheckOut: Date; ExcludeReservationNo: Code[20]): Boolean
    var
        Reservation: Record "Hotel Reservation";
    begin
        if RoomNo = '' then
            exit(false);
        if (CheckIn = 0D) or (CheckOut = 0D) then
            exit(false);

        Reservation.SetRange("Room No.", RoomNo);
        Reservation.SetFilter("Reservation No.", '<>%1', ExcludeReservationNo);
        Reservation.SetFilter(Status, '%1|%2', Reservation.Status::Confirmed, Reservation.Status::Occupied);
        Reservation.SetFilter("Check-in Date", '<%1', CheckOut);
        Reservation.SetFilter("Check-out Date", '>%1', CheckIn);
        exit(not Reservation.IsEmpty());
    end;

    procedure CalculateRoomCharge(var Reservation: Record "Hotel Reservation") Total: Decimal
    var
        Room: Record "Hotel Room";
        Nights: Integer;
    begin
        if Reservation."Room No." = '' then
            exit(0);
        if not Room.Get(Reservation."Room No.") then
            exit(0);
        Nights := Reservation."Check-out Date" - Reservation."Check-in Date";
        if Nights < 1 then
            Nights := 1;
        exit(Nights * Room."Nightly Rate");
    end;

    var
        CustomerRequiredErr: Label 'A Customer No. is required to create a reservation.';
        DatesRequiredErr: Label 'Check-in and Check-out Dates are required.';
        InvalidDateRangeErr: Label 'Check-out Date must be after Check-in Date.';
        ReservationClosedErr: Label 'Reservation %1 is closed and cannot be modified.';
        RoomBlockedErr: Label 'Room %1 is blocked and cannot be assigned.';
        OverbookingErr: Label 'Room %1 is already booked for the selected period (overbooking is not allowed).';
        MustBeConfirmedErr: Label 'Reservation %1 must be in status Confirmed to check in.';
        MustBeOccupiedErr: Label 'Reservation %1 must be in status Occupied to check out.';
        DepositRequiredErr: Label 'Reservation %1 cannot be checked in because the deposit was not captured.';
        RoomAlreadyOccupiedErr: Label 'Room %1 is already occupied.';
}
