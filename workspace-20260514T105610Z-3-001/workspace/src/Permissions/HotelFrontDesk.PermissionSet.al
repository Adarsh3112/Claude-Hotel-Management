permissionset 50101 "HOTEL_FRONTDESK"
{
    Assignable = true;
    Caption = 'Hotel - Front Desk';
    // Front Desk: operational tasks only.
    // Can: read/modify reservations & rooms, post service charges, capture deposits & check-in/out.
    // Cannot: process refunds, modify tax setup, or directly adjust posted finance records.

    Permissions =
        tabledata "Hotel Room" = RM,
        tabledata "Hotel Reservation" = RIM,
        tabledata "Hotel Service Charge" = RIMD,
        tabledata "Hotel Setup" = R,
        tabledata "Hotel Payment Entry" = R,
        tabledata "Hotel Invoice Header" = R,
        tabledata "Hotel Invoice Line" = R,
        table "Hotel Room" = X,
        table "Hotel Reservation" = X,
        table "Hotel Service Charge" = X,
        codeunit "Hotel Reservation Mgt" = X,
        codeunit "Hotel Payment Mgt" = X,
        // Intentionally NO execute on "Hotel Refund Mgt" and NO execute on "Hotel VAT Mgt" with write.
        page "Hotel Room List" = X,
        page "Hotel Room Card" = X,
        page "Hotel Reservation List" = X,
        page "Hotel Reservation Card" = X,
        page "Hotel Service Charges" = X,
        page "Hotel Payment Entries" = X,
        page "Hotel Invoice List" = X,
        page "Hotel Invoice Card" = X,
        page "Hotel Invoice Lines" = X;
}
