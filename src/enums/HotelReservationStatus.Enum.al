enum 50090 "Hotel Reservation Status"
{
    Extensible = true;
    Caption = 'Hotel Reservation Status';

    value(0; Confirmed) { Caption = 'Confirmed'; }
    value(1; Occupied) { Caption = 'Occupied'; }
    value(2; Closed) { Caption = 'Closed'; }
}
