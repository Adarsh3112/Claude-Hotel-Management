page 50012 "Hotel Reservation List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Hotel Reservation";
    Caption = 'Hotel Reservations';
    CardPageId = "Hotel Reservation Card";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Room No."; Rec."Room No.") { ApplicationArea = All; }
                field("Check-in Date"; Rec."Check-in Date") { ApplicationArea = All; }
                field("Check-out Date"; Rec."Check-out Date") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; StyleExpr = StatusStyleExpr; }
                field("Deposit Captured"; Rec."Deposit Captured") { ApplicationArea = All; }
                field(Invoiced; Rec.Invoiced) { ApplicationArea = All; }
                field("Total Amount"; Rec."Total Amount") { ApplicationArea = All; }
                field("Amount Due"; Rec."Amount Due") { ApplicationArea = All; }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Confirmed:
                StatusStyleExpr := 'Standard';
            Rec.Status::Occupied:
                StatusStyleExpr := 'Strong';
            Rec.Status::Closed:
                StatusStyleExpr := 'Subordinate';
        end;
    end;

    var
        StatusStyleExpr: Text;
}
