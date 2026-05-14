enum 50102 "Hotel Payment Status"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; Pending)
    {
        Caption = 'Pending';
    }
    value(1; Captured)
    {
        Caption = 'Captured';
    }
    value(2; Failed)
    {
        Caption = 'Failed';
    }
    value(3; Refunded)
    {
        Caption = 'Refunded';
    }
}
