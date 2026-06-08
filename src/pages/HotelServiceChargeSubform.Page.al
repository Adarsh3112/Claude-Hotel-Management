page 50014 "Hotel Service Charge Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Hotel Service Charge";
    AutoSplitKey = true;
    DelayedInsert = true;
    Caption = 'Service Charges';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Service Type"; Rec."Service Type") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Unit Price"; Rec."Unit Price") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Posted By"; Rec."Posted By") { ApplicationArea = All; Visible = false; }
            }
        }
    }
}
