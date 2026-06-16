permissionset 50101 "Hotel Finance"
{
    Assignable = true;
    Caption = 'Hotel Finance';

    Permissions =
        tabledata "Hotel Room" = R,
        tabledata "Hotel Reservation" = RIM,
        tabledata "Hotel Service Charge" = R,
        tabledata "Hotel Payment Entry" = RIM,
        tabledata "Hotel Posted Invoice" = RIM,
        tabledata "Hotel Setup" = RM,
        table "Hotel Room" = X,
        table "Hotel Reservation" = X,
        table "Hotel Service Charge" = X,
        table "Hotel Payment Entry" = X,
        table "Hotel Posted Invoice" = X,
        table "Hotel Setup" = X,
        page "Hotel Room List" = X,
        page "Hotel Reservation List" = X,
        page "Hotel Reservation Card" = X,
        page "Hotel Posted Invoices" = X,
        page "Hotel Posted Invoice Card" = X,
        page "Hotel Payment Entries" = X,
        page "Hotel Setup" = X,
        codeunit "Hotel Reservation Mgt" = X,
        codeunit "Hotel Invoice Posting" = X,
        codeunit "Hotel Refund Mgt" = X,
        codeunit "Hotel Tax" = X,
        codeunit "Hotel Permission Check" = X;
}
