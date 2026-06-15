permissionset 50102 "HOTEL_FINANCE"
{
    Assignable = true;
    Caption = 'Hotel - Finance';
    // Finance: invoicing, taxes, payments, refunds, and ledger review.

    Permissions =
        tabledata "Hotel Room" = R,
        tabledata "Hotel Reservation" = RM,
        tabledata "Hotel Service Charge" = R,
        tabledata "Hotel Setup" = RM,
        tabledata "Hotel Payment Entry" = RIMD,
        tabledata "Hotel Invoice Header" = RIMD,
        tabledata "Hotel Invoice Line" = RIMD,
        table "Hotel Setup" = X,
        table "Hotel Payment Entry" = X,
        table "Hotel Invoice Header" = X,
        table "Hotel Invoice Line" = X,
        codeunit "Hotel Billing Mgt" = X,
        codeunit "Hotel Payment Mgt" = X,
        codeunit "Hotel VAT Mgt" = X,
        codeunit "Hotel Refund Mgt" = X,
        page "Hotel Setup" = X,
        page "Hotel Payment Entries" = X,
        page "Hotel Invoice List" = X,
        page "Hotel Invoice Card" = X,
        page "Hotel Invoice Lines" = X,
        page "Hotel Reservation List" = X,
        page "Hotel Reservation Card" = X;
}
