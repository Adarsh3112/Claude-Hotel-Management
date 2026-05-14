page 50105 "Hotel Setup"
{
    Caption = 'Hotel Setup';
    PageType = Card;
    SourceTable = "Hotel Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("VAT %"; Rec."VAT %") { ApplicationArea = All; }
                field("Default Currency"; Rec."Default Currency") { ApplicationArea = All; }
            }
            group(NumberSeries)
            {
                Caption = 'Numbering';
                field("Reservation No. Prefix"; Rec."Reservation No. Prefix") { ApplicationArea = All; }
                field("Invoice No. Prefix"; Rec."Invoice No. Prefix") { ApplicationArea = All; }
                field("Last Reservation No."; Rec."Last Reservation No.") { ApplicationArea = All; }
                field("Last Invoice No."; Rec."Last Invoice No.") { ApplicationArea = All; }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetSingleton();
        if not Rec.Get('') then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
