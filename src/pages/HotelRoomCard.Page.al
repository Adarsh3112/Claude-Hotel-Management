page 50011 "Hotel Room Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Hotel Room";
    Caption = 'Hotel Room';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Room Type"; Rec."Room Type") { ApplicationArea = All; }
                field(Floor; Rec.Floor) { ApplicationArea = All; }
                field("Max Occupancy"; Rec."Max Occupancy") { ApplicationArea = All; }
                field("Nightly Rate"; Rec."Nightly Rate") { ApplicationArea = All; }
            }
            group(Status)
            {
                Caption = 'Status';
                field(Occupied; Rec.Occupied) { ApplicationArea = All; }
                field(Blocked; Rec.Blocked) { ApplicationArea = All; }
            }
        }
    }
}
