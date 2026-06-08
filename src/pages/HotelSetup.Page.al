page 50015 "Hotel Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Hotel Setup";
    Caption = 'Hotel Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Reservation Nos."; Rec."Reservation Nos.") { ApplicationArea = All; }
                field("Invoice Nos."; Rec."Invoice Nos.") { ApplicationArea = All; }
                field("Payment Nos."; Rec."Payment Nos.") { ApplicationArea = All; }
            }
            group(Tax)
            {
                Caption = 'Tax';
                field("VAT %"; Rec."VAT %") { ApplicationArea = All; }
            }
            group(Defaults)
            {
                Caption = 'Defaults';
                field("Default Currency Code"; Rec."Default Currency Code") { ApplicationArea = All; }
            }
            group(SecurityGroup)
            {
                Caption = 'Security';
                field("Finance Permission Set"; Rec."Finance Permission Set") { ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetSetup();
    end;
}
