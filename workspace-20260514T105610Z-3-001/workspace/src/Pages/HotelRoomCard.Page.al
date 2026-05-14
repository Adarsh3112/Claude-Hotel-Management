page 50101 "Hotel Room Card"
{
    Caption = 'Hotel Room Card';
    PageType = Card;
    SourceTable = "Hotel Room";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Room No."; Rec."Room No.") { ApplicationArea = All; }
                field("Room Type"; Rec."Room Type") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Nightly Rate"; Rec."Nightly Rate") { ApplicationArea = All; }
                field(Blocked; Rec.Blocked) { ApplicationArea = All; }
                field(Occupied; Rec.Occupied)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
