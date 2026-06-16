page 50013 "Hotel Reservation Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Hotel Reservation";
    Caption = 'Hotel Reservation';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Created At"; Rec."Created At") { ApplicationArea = All; }
                field("Created By"; Rec."Created By") { ApplicationArea = All; }
            }
            group(Stay)
            {
                Caption = 'Stay';
                field("Room No."; Rec."Room No.") { ApplicationArea = All; }
                field("Nightly Rate"; Rec."Nightly Rate") { ApplicationArea = All; }
                field("Check-in Date"; Rec."Check-in Date") { ApplicationArea = All; }
                field("Check-out Date"; Rec."Check-out Date") { ApplicationArea = All; }
                field("Checked In At"; Rec."Checked In At") { ApplicationArea = All; }
                field("Checked Out At"; Rec."Checked Out At") { ApplicationArea = All; }
            }
            part(ServiceCharges; "Hotel Service Charge Subform")
            {
                ApplicationArea = All;
                Caption = 'Service Charges';
                SubPageLink = "Reservation No." = field("No.");
                UpdatePropagation = Both;
            }
            group(Billing)
            {
                Caption = 'Billing';
                field("Deposit Amount"; Rec."Deposit Amount") { ApplicationArea = All; }
                field("Deposit Captured"; Rec."Deposit Captured") { ApplicationArea = All; }
                field("Room Charges"; Rec."Room Charges") { ApplicationArea = All; }
                field("Service Charges Total"; Rec."Service Charges Total") { ApplicationArea = All; }
                field("Amount Excl. VAT"; Rec."Amount Excl. VAT") { ApplicationArea = All; }
                field("VAT %"; Rec."VAT %") { ApplicationArea = All; }
                field("VAT Amount"; Rec."VAT Amount") { ApplicationArea = All; }
                field("Total Amount"; Rec."Total Amount") { ApplicationArea = All; }
                field("Paid Amount"; Rec."Paid Amount") { ApplicationArea = All; }
                field("Refunded Amount"; Rec."Refunded Amount") { ApplicationArea = All; }
                field("Amount Due"; Rec."Amount Due") { ApplicationArea = All; }
                field("Invoice No."; Rec."Invoice No.") { ApplicationArea = All; }
                field(Invoiced; Rec.Invoiced) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Operations)
            {
                Caption = 'Operations';

                action(RecalcTotals)
                {
                    ApplicationArea = All;
                    Caption = 'Recalculate Totals';
                    Image = Calculate;

                    trigger OnAction()
                    var
                        Tax: Codeunit "Hotel Tax";
                    begin
                        Tax.RecalcReservationTax(Rec);
                        CurrPage.Update(false);
                    end;
                }
                action(CaptureDepositAction)
                {
                    ApplicationArea = All;
                    Caption = 'Capture Deposit';
                    Image = CashFlow;

                    trigger OnAction()
                    var
                        Mgt: Codeunit "Hotel Reservation Mgt";
                        Amount: Decimal;
                        ExternalRef: Text;
                    begin
                        Amount := Rec."Deposit Amount";
                        if Amount <= 0 then
                            Error(DepositAmountRequiredErr);
                        Mgt.CaptureDeposit(Rec, Amount, true, '');
                        CurrPage.Update(false);
                    end;
                }
                action(CheckInAction)
                {
                    ApplicationArea = All;
                    Caption = 'Check In';
                    Image = ReceiveLoaner;

                    trigger OnAction()
                    var
                        Mgt: Codeunit "Hotel Reservation Mgt";
                    begin
                        Mgt.CheckIn(Rec);
                        CurrPage.Update(false);
                    end;
                }
                action(CheckOutAction)
                {
                    ApplicationArea = All;
                    Caption = 'Check Out';
                    Image = ReturnReceipt;

                    trigger OnAction()
                    var
                        Mgt: Codeunit "Hotel Reservation Mgt";
                        Invoice: Record "Hotel Posted Invoice";
                    begin
                        Mgt.CheckOut(Rec, Invoice);
                        CurrPage.Update(false);
                        Message(InvoiceCreatedMsg, Invoice."No.");
                    end;
                }
            }
            group(Finance)
            {
                Caption = 'Finance';

                action(PostFinalPaymentAction)
                {
                    ApplicationArea = All;
                    Caption = 'Post Final Payment';
                    Image = Payment;

                    trigger OnAction()
                    var
                        Mgt: Codeunit "Hotel Reservation Mgt";
                    begin
                        Rec.TestField(Invoiced, true);
                        Mgt.PostFinalPayment(Rec, Rec."Amount Due", true, '');
                        CurrPage.Update(false);
                    end;
                }
                action(RefundAction)
                {
                    ApplicationArea = All;
                    Caption = 'Process Refund';
                    Image = Cancel;

                    trigger OnAction()
                    var
                        Refund: Codeunit "Hotel Refund Mgt";
                        Refundable: Decimal;
                    begin
                        Refundable := Rec."Paid Amount" - Rec."Refunded Amount";
                        if Refundable <= 0 then
                            Error(NothingToRefundErr);
                        Refund.ProcessRefund(Rec, Refundable, '', '');
                        CurrPage.Update(false);
                    end;
                }
            }
            group(Navigate)
            {
                Caption = 'Navigate';

                action(ViewPayments)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Entries';
                    Image = Ledger;
                    RunObject = page "Hotel Payment Entries";
                    RunPageLink = "Reservation No." = field("No.");
                }
                action(ViewInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Invoice';
                    Image = Invoice;
                    RunObject = page "Hotel Posted Invoices";
                    RunPageLink = "Reservation No." = field("No.");
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(CaptureDeposit_Promoted; CaptureDepositAction) { }
                actionref(CheckIn_Promoted; CheckInAction) { }
                actionref(CheckOut_Promoted; CheckOutAction) { }
            }
            group(Category_Finance)
            {
                Caption = 'Finance';
                actionref(PostFinalPayment_Promoted; PostFinalPaymentAction) { }
                actionref(Refund_Promoted; RefundAction) { }
            }
        }
    }

    var
        InvoiceCreatedMsg: Label 'Invoice %1 was created.', Comment = '%1=Invoice No.';
        DepositAmountRequiredErr: Label 'Set Deposit Amount before capturing the deposit.';
        NothingToRefundErr: Label 'There is no refundable balance on this reservation.';
}
