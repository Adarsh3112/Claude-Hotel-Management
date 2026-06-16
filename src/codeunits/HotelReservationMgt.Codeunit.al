codeunit 50050 "Hotel Reservation Mgt"
{
    Access = Public;

    procedure CreateReservation(CustomerNo: Code[20]; RoomNo: Code[20]; CheckInDate: Date; CheckOutDate: Date; var Reservation: Record "Hotel Reservation"): Code[20]
    begin
        if CustomerNo = '' then
            Error(CustomerRequiredErr);
        if CheckInDate = 0D then
            Error(CheckInRequiredErr);
        if CheckOutDate <= CheckInDate then
            Error(CheckOutAfterCheckInErr);

        Clear(Reservation);
        Reservation.Init();
        Reservation."No." := '';
        Reservation.Insert(true);
        Reservation.Validate("Customer No.", CustomerNo);
        Reservation.Validate("Check-in Date", CheckInDate);
        Reservation.Validate("Check-out Date", CheckOutDate);
        if RoomNo <> '' then
            Reservation.Validate("Room No.", RoomNo);
        Reservation.Status := Reservation.Status::Confirmed;
        Reservation.RecalcTotals();
        Reservation.Modify(true);
        exit(Reservation."No.");
    end;

    procedure AssignRoom(var Reservation: Record "Hotel Reservation"; NewRoomNo: Code[20])
    begin
        if Reservation.Status = Reservation.Status::Closed then
            Error(ClosedReservationErr, Reservation."No.");
        Reservation.Validate("Room No.", NewRoomNo);
        Reservation.RecalcTotals();
        Reservation.Modify(true);
    end;

    procedure CaptureDeposit(var Reservation: Record "Hotel Reservation"; Amount: Decimal; Successful: Boolean; ExternalRef: Code[35])
    var
        Entry: Record "Hotel Payment Entry";
    begin
        if Amount <= 0 then
            Error(InvalidDepositAmountErr);
        if Reservation.Status = Reservation.Status::Closed then
            Error(ClosedReservationErr, Reservation."No.");

        Clear(Entry);
        Entry.Init();
        Entry."Reservation No." := Reservation."No.";
        Entry."Posting Date" := WorkDate();
        Entry."Entry Type" := Entry."Entry Type"::Deposit;
        Entry.Amount := Amount;
        Entry.Successful := Successful;
        Entry."User ID" := CopyStr(UserId(), 1, MaxStrLen(Entry."User ID"));
        Entry."External Reference" := ExternalRef;
        if Successful then
            Entry.Description := DepositCapturedTxt
        else
            Entry.Description := DepositFailedTxt;
        Entry.Insert(true);

        if not Successful then begin
            // Ensure no false-success: do not mark deposit captured
            Reservation."Deposit Captured" := false;
            Reservation.Modify(true);
            Error(PaymentFailedErr);
        end;

        Reservation."Deposit Amount" := Amount;
        Reservation."Deposit Captured" := true;
        Reservation.Modify(true);
    end;

    procedure CheckIn(var Reservation: Record "Hotel Reservation")
    var
        Room: Record "Hotel Room";
    begin
        if Reservation.Status <> Reservation.Status::Confirmed then
            Error(MustBeConfirmedErr, Reservation."No.");
        Reservation.TestField("Room No.");
        Reservation.TestField("Check-in Date");
        Reservation.TestField("Check-out Date");
        if not Reservation."Deposit Captured" then
            Error(DepositRequiredErr, Reservation."No.");

        Reservation.CheckOverbooking();

        Room.Get(Reservation."Room No.");
        Room.Occupied := true;
        Room.Modify(true);

        Reservation.Status := Reservation.Status::Occupied;
        Reservation."Checked In At" := CurrentDateTime();
        Reservation.Modify(true);
    end;

    procedure PostServiceCharge(var Reservation: Record "Hotel Reservation"; ServiceType: Enum "Hotel Service Type"; Description: Text[100]; Quantity: Decimal; UnitPrice: Decimal)
    var
        ServiceCharge: Record "Hotel Service Charge";
        LastLine: Record "Hotel Service Charge";
    begin
        if Reservation.Invoiced then
            Error(AlreadyInvoicedErr, Reservation."No.");
        if Reservation.Status = Reservation.Status::Closed then
            Error(ClosedReservationErr, Reservation."No.");
        if Quantity <= 0 then
            Quantity := 1;
        if UnitPrice < 0 then
            Error(NegativeAmountErr);

        LastLine.SetRange("Reservation No.", Reservation."No.");
        if LastLine.FindLast() then;

        Clear(ServiceCharge);
        ServiceCharge.Init();
        ServiceCharge."Reservation No." := Reservation."No.";
        ServiceCharge."Line No." := LastLine."Line No." + 10000;
        ServiceCharge."Service Type" := ServiceType;
        if Description = '' then
            ServiceCharge.Description := Format(ServiceType)
        else
            ServiceCharge.Description := Description;
        ServiceCharge.Quantity := Quantity;
        ServiceCharge."Unit Price" := UnitPrice;
        ServiceCharge.Amount := Round(Quantity * UnitPrice, 0.01);
        ServiceCharge."Posting Date" := WorkDate();
        ServiceCharge.Insert(true);
    end;

    procedure CheckOut(var Reservation: Record "Hotel Reservation"; var PostedInvoice: Record "Hotel Posted Invoice")
    var
        Room: Record "Hotel Room";
        InvoicePosting: Codeunit "Hotel Invoice Posting";
    begin
        if Reservation.Status <> Reservation.Status::Occupied then
            Error(MustBeOccupiedErr, Reservation."No.");

        InvoicePosting.PostInvoice(Reservation, PostedInvoice);

        if Room.Get(Reservation."Room No.") then begin
            Room.Occupied := false;
            Room.Modify(true);
        end;

        Reservation.Status := Reservation.Status::Closed;
        Reservation."Checked Out At" := CurrentDateTime();
        Reservation.Modify(true);
    end;

    procedure PostFinalPayment(var Reservation: Record "Hotel Reservation"; Amount: Decimal; Successful: Boolean; ExternalRef: Code[35])
    var
        Entry: Record "Hotel Payment Entry";
    begin
        if not Reservation.Invoiced then
            Error(NotInvoicedYetErr, Reservation."No.");
        if Amount <= 0 then
            Error(InvalidPaymentAmountErr);

        Clear(Entry);
        Entry.Init();
        Entry."Reservation No." := Reservation."No.";
        Entry."Invoice No." := Reservation."Invoice No.";
        Entry."Posting Date" := WorkDate();
        Entry."Entry Type" := Entry."Entry Type"::Payment;
        Entry.Amount := Amount;
        Entry.Successful := Successful;
        Entry."User ID" := CopyStr(UserId(), 1, MaxStrLen(Entry."User ID"));
        Entry."External Reference" := ExternalRef;
        if Successful then
            Entry.Description := PaymentCapturedTxt
        else
            Entry.Description := PaymentFailedTxt;
        Entry.Insert(true);

        if not Successful then
            Error(PaymentFailedErr);

        Reservation."Paid Amount" := Reservation."Paid Amount" + Amount;
        Reservation."Amount Due" := Reservation."Total Amount" - Reservation."Paid Amount" + Reservation."Refunded Amount";
        Reservation.Modify(true);
    end;

    var
        CustomerRequiredErr: Label 'A customer must be specified for the reservation.';
        CheckInRequiredErr: Label 'Check-in Date is required.';
        CheckOutAfterCheckInErr: Label 'Check-out Date must be after Check-in Date.';
        ClosedReservationErr: Label 'Reservation %1 is closed; this action is not allowed.', Comment = '%1=Reservation No.';
        InvalidDepositAmountErr: Label 'Deposit amount must be greater than zero.';
        InvalidPaymentAmountErr: Label 'Payment amount must be greater than zero.';
        PaymentFailedErr: Label 'Payment was not successful. No funds have been captured.';
        DepositRequiredErr: Label 'Reservation %1 requires a captured deposit before check-in.', Comment = '%1=Reservation No.';
        MustBeConfirmedErr: Label 'Reservation %1 must be in status Confirmed to check in.', Comment = '%1=Reservation No.';
        MustBeOccupiedErr: Label 'Reservation %1 must be in status Occupied to check out.', Comment = '%1=Reservation No.';
        AlreadyInvoicedErr: Label 'Reservation %1 has already been invoiced.', Comment = '%1=Reservation No.';
        NotInvoicedYetErr: Label 'Reservation %1 has not been invoiced; final payment cannot be posted.', Comment = '%1=Reservation No.';
        NegativeAmountErr: Label 'Amount cannot be negative.';
        DepositCapturedTxt: Label 'Deposit captured';
        DepositFailedTxt: Label 'Deposit capture failed';
        PaymentCapturedTxt: Label 'Final payment captured';
        PaymentFailedTxt: Label 'Final payment failed';
}
