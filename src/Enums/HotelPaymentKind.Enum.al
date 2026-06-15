enum 50103 "Hotel Payment Kind"
{
    Extensible = true;
    AssignmentCompatibility = true;

    value(0; Deposit)
    {
        Caption = 'Deposit';
    }
    value(1; Final)
    {
        Caption = 'Final';
    }
    value(2; Refund)
    {
        Caption = 'Refund';
    }
}
