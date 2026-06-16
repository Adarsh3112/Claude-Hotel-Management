page 50010 "Hotel Room List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Hotel Room";
    Caption = 'Hotel Rooms';
    CardPageId = "Hotel Room Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Room Type"; Rec."Room Type") { ApplicationArea = All; }
                field(Floor; Rec.Floor) { ApplicationArea = All; }
                field("Max Occupancy"; Rec."Max Occupancy") { ApplicationArea = All; }
                field("Nightly Rate"; Rec."Nightly Rate") { ApplicationArea = All; }
                field(Occupied; Rec.Occupied) { ApplicationArea = All; }
                field(Blocked; Rec.Blocked) { ApplicationArea = All; }
            }
        }
    }
}
