permissionset 50102 "Hotel Admin"
{
    Assignable = true;
    Caption = 'Hotel Admin';

    Permissions =
        tabledata "Hotel Room" = RIMD,
        tabledata "Hotel Reservation" = R,
        tabledata "Hotel Service Charge" = R,
        tabledata "Hotel Payment Entry" = R,
        tabledata "Hotel Posted Invoice" = R,
        tabledata "Hotel Setup" = RIMD,
        table "Hotel Room" = X,
        table "Hotel Reservation" = X,
        table "Hotel Service Charge" = X,
        table "Hotel Payment Entry" = X,
        table "Hotel Posted Invoice" = X,
        table "Hotel Setup" = X,
        page "Hotel Room List" = X,
        page "Hotel Room Card" = X,
        page "Hotel Reservation List" = X,
        page "Hotel Reservation Card" = X,
        page "Hotel Posted Invoices" = X,
        page "Hotel Posted Invoice Card" = X,
        page "Hotel Payment Entries" = X,
        page "Hotel Setup" = X,
        codeunit "Hotel Tax" = X,
        codeunit "Hotel Permission Check" = X;
}
