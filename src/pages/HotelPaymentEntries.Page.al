page 50018 "Hotel Payment Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Hotel Payment Entry";
    Caption = 'Hotel Payment Entries';
    Editable = false;

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
                field("Entry Type"; Rec."Entry Type") { ApplicationArea = All; }
                field(Amount; Rec.Amount) { ApplicationArea = All; }
                field(Successful; Rec.Successful) { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("External Reference"; Rec."External Reference") { ApplicationArea = All; }
                field("User ID"; Rec."User ID") { ApplicationArea = All; }
            }
        }
    }
}
