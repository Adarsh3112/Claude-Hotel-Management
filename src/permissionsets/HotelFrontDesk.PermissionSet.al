permissionset 50100 "Hotel Front Desk"
{
    Assignable = true;
    Caption = 'Hotel Front Desk';

    Permissions =
        tabledata "Hotel Room" = R,
        tabledata "Hotel Reservation" = RIMD,
        tabledata "Hotel Service Charge" = RIMD,
        tabledata "Hotel Payment Entry" = RI,
        tabledata "Hotel Posted Invoice" = R,
        tabledata "Hotel Setup" = R,
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
        page "Hotel Service Charge Subform" = X,
        page "Hotel Posted Invoices" = X,
        page "Hotel Posted Invoice Card" = X,
        page "Hotel Payment Entries" = X,
        codeunit "Hotel Reservation Mgt" = X,
        codeunit "Hotel Invoice Posting" = X,
        codeunit "Hotel Tax" = X,
        codeunit "Hotel Permission Check" = X;
}
