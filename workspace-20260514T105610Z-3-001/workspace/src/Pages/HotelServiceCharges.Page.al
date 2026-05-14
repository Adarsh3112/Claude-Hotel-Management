page 50104 "Hotel Service Charges"
{
    Caption = 'Service Charges';
    PageType = ListPart;
    SourceTable = "Hotel Service Charge";
    AutoSplitKey = true;
    ApplicationArea = All;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Service Type"; Rec."Service Type") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
            }
        }
    }
}
