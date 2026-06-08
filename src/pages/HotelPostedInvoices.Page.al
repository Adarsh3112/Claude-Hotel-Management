page 50016 "Hotel Posted Invoices"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Hotel Posted Invoice";
    Caption = 'Hotel Posted Invoices';
    Editable = false;
    CardPageId = "Hotel Posted Invoice Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Reservation No."; Rec."Reservation No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Room No."; Rec."Room No.") { ApplicationArea = All; }
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
