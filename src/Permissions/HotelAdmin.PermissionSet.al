permissionset 50100 "HOTEL_ADMIN"
{
    Assignable = true;
    Caption = 'Hotel - Admin';

    Permissions =
        tabledata "Hotel Room" = RIMD,
        tabledata "Hotel Reservation" = RIMD,
        tabledata "Hotel Service Charge" = RIMD,
        tabledata "Hotel Setup" = RIMD,
        tabledata "Hotel Payment Entry" = RIMD,
        tabledata "Hotel Invoice Header" = RIMD,
        tabledata "Hotel Invoice Line" = RIMD,
        table "Hotel Room" = X,
        table "Hotel Reservation" = X,
        table "Hotel Service Charge" = X,
        table "Hotel Setup" = X,
        table "Hotel Payment Entry" = X,
        table "Hotel Invoice Header" = X,
        table "Hotel Invoice Line" = X,
        codeunit "Hotel Reservation Mgt" = X,
        codeunit "Hotel Payment Mgt" = X,
        codeunit "Hotel Billing Mgt" = X,
        codeunit "Hotel VAT Mgt" = X,
        codeunit "Hotel Refund Mgt" = X,
        page "Hotel Room List" = X,
        page "Hotel Room Card" = X,
        page "Hotel Reservation List" = X,
        page "Hotel Reservation Card" = X,
        page "Hotel Service Charges" = X,
        page "Hotel Setup" = X,
        page "Hotel Payment Entries" = X,
        page "Hotel Invoice List" = X,
        page "Hotel Invoice Card" = X,
        page "Hotel Invoice Lines" = X;
}
