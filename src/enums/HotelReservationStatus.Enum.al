enum 50100 "Hotel Reservation Status"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; Confirmed)
    {
        Caption = 'Confirmed';
    }
    value(1; Occupied)
    {
        Caption = 'Occupied';
    }
    value(2; Closed)
    {
        Caption = 'Closed';
    }
}
