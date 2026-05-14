page 50108 "Hotel Invoice Card"
{
    Caption = 'Hotel Invoice';
    PageType = Card;
    SourceTable = "Hotel Invoice Header";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Invoice No."; Rec."Invoice No.") { ApplicationArea = All; }
                field("Reservation No."; Rec."Reservation No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
            }
            group(Totals)
            {
                Caption = 'Totals';
                field(Subtotal; Rec.Subtotal) { ApplicationArea = All; }
                field("VAT %"; Rec."VAT %") { ApplicationArea = All; }
                field("VAT Amount"; Rec."VAT Amount") { ApplicationArea = All; }
                field("Total Incl. VAT"; Rec."Total Incl. VAT") { ApplicationArea = All; }
                field("Deposit Applied"; Rec."Deposit Applied") { ApplicationArea = All; }
                field("Amount Due"; Rec."Amount Due") { ApplicationArea = All; }
                field(Paid; Rec.Paid) { ApplicationArea = All; }
                field(Posted; Rec.Posted) { ApplicationArea = All; }
            }
            part(InvoiceLines; "Hotel Invoice Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Invoice No." = field("Invoice No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RecalculateVAT)
            {
                Caption = 'Recalculate VAT';
                ApplicationArea = All;
                Image = Calculate;
                trigger OnAction()
                var
                    VATMgt: Codeunit "Hotel VAT Mgt";
                begin
                    VATMgt.RecalculateInvoice(Rec);
                    Message(RecalculatedMsg);
                end;
            }
        }
    }

    var
        RecalculatedMsg: Label 'Invoice recalculated with the current VAT rate.';
}
