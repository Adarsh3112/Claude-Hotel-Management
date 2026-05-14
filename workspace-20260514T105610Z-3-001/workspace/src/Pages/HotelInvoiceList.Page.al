page 50107 "Hotel Invoice List"
{
    Caption = 'Hotel Invoices';
    PageType = List;
    SourceTable = "Hotel Invoice Header";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "Hotel Invoice Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Invoice No."; Rec."Invoice No.") { ApplicationArea = All; }
                field("Reservation No."; Rec."Reservation No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field(Subtotal; Rec.Subtotal) { ApplicationArea = All; }
                field("VAT %"; Rec."VAT %") { ApplicationArea = All; }
                field("VAT Amount"; Rec."VAT Amount") { ApplicationArea = All; }
                field("Total Incl. VAT"; Rec."Total Incl. VAT") { ApplicationArea = All; }
                field("Deposit Applied"; Rec."Deposit Applied") { ApplicationArea = All; }
                field("Amount Due"; Rec."Amount Due") { ApplicationArea = All; }
                field(Paid; Rec.Paid) { ApplicationArea = All; }
                field(Posted; Rec.Posted) { ApplicationArea = All; }
            }
        }
    }
}
