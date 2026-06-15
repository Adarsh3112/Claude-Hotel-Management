page 50100 "Hotel Room List"
{
    Caption = 'Hotel Rooms';
    PageType = List;
    SourceTable = "Hotel Room";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "Hotel Room Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Room No."; Rec."Room No.") { ApplicationArea = All; }
                field("Room Type"; Rec."Room Type") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Nightly Rate"; Rec."Nightly Rate") { ApplicationArea = All; }
                field(Occupied; Rec.Occupied) { ApplicationArea = All; }
                field(Blocked; Rec.Blocked) { ApplicationArea = All; }
            }
        }
    }
}
