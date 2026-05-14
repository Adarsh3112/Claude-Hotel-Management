page 50102 "Hotel Reservation List"
{
    Caption = 'Hotel Reservations';
    PageType = List;
    SourceTable = "Hotel Reservation";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "Hotel Reservation Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Reservation No."; Rec."Reservation No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Room No."; Rec."Room No.") { ApplicationArea = All; }
                field("Check-in Date"; Rec."Check-in Date") { ApplicationArea = All; }
                field("Check-out Date"; Rec."Check-out Date") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Deposit Captured"; Rec."Deposit Captured") { ApplicationArea = All; }
                field("Invoice Generated"; Rec."Invoice Generated") { ApplicationArea = All; }
                field("Amount Due"; Rec."Amount Due") { ApplicationArea = All; }
            }
        }
    }
}
