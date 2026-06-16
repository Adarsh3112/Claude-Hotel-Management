page 50017 "Hotel Posted Invoice Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Hotel Posted Invoice";
    Caption = 'Hotel Posted Invoice';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Reservation No."; Rec."Reservation No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Posted By"; Rec."Posted By") { ApplicationArea = All; }
            }
            group(Stay)
            {
                Caption = 'Stay';
                field("Room No."; Rec."Room No.") { ApplicationArea = All; }
                field("Check-in Date"; Rec."Check-in Date") { ApplicationArea = All; }
                field("Check-out Date"; Rec."Check-out Date") { ApplicationArea = All; }
            }
            group(Amounts)
            {
                Caption = 'Amounts';
                field("Room Charges"; Rec."Room Charges") { ApplicationArea = All; }
                field("Service Charges"; Rec."Service Charges") { ApplicationArea = All; }
                field("Amount Excl. VAT"; Rec."Amount Excl. VAT") { ApplicationArea = All; }
                field("VAT %"; Rec."VAT %") { ApplicationArea = All; }
                field("VAT Amount"; Rec."VAT Amount") { ApplicationArea = All; }
                field("Amount Incl. VAT"; Rec."Amount Incl. VAT") { ApplicationArea = All; }
                field("Deposit Applied"; Rec."Deposit Applied") { ApplicationArea = All; }
                field("Amount Due"; Rec."Amount Due") { ApplicationArea = All; }
            }
        }
    }
}
