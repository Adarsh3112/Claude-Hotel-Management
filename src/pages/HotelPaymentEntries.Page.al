page 50106 "Hotel Payment Entries"
{
    Caption = 'Hotel Payment Entries';
    PageType = List;
    SourceTable = "Hotel Payment Entry";
    UsageCategory = History;
    ApplicationArea = All;
    Editable = false;
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Posting Date"; Rec."Posting Date") { ApplicationArea = All; }
                field("Reservation No."; Rec."Reservation No.") { ApplicationArea = All; }
                field("Invoice No."; Rec."Invoice No.") { ApplicationArea = All; }
                field("Payment Kind"; Rec."Payment Kind") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("User ID"; Rec."User ID") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
        }
    }
}
