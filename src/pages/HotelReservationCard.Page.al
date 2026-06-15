page 50103 "Hotel Reservation Card"
{
    Caption = 'Hotel Reservation';
    PageType = Card;
    SourceTable = "Hotel Reservation";
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Reservation No."; Rec."Reservation No.")
                {
                    ApplicationArea = All;
                    Editable = NewMode;
                }
                field("Customer No."; Rec."Customer No.") { ApplicationArea = All; }
                field("Customer Name"; Rec."Customer Name") { ApplicationArea = All; }
                field("Room No."; Rec."Room No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        ReservationMgt: Codeunit "Hotel Reservation Mgt";
                    begin
                        // Re-route through codeunit for overbooking validation
                        if Rec."Room No." <> '' then
                            ReservationMgt.AssignRoom(Rec, Rec."Room No.");
                    end;
                }
                field("Check-in Date"; Rec."Check-in Date") { ApplicationArea = All; }
                field("Check-out Date"; Rec."Check-out Date") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
            }
            group(Financial)
            {
                Caption = 'Financial';
                field("Deposit Amount"; Rec."Deposit Amount") { ApplicationArea = All; }
                field("Deposit Captured"; Rec."Deposit Captured") { ApplicationArea = All; }
                field("Service Charges Total"; Rec."Service Charges Total") { ApplicationArea = All; }
                field("Total Amount"; Rec."Total Amount") { ApplicationArea = All; }
                field("VAT Amount"; Rec."VAT Amount") { ApplicationArea = All; }
                field("Amount Paid"; Rec."Amount Paid") { ApplicationArea = All; }
                field("Amount Due"; Rec."Amount Due") { ApplicationArea = All; }
                field("Invoice No."; Rec."Invoice No.") { ApplicationArea = All; }
                field("Invoice Generated"; Rec."Invoice Generated") { ApplicationArea = All; }
            }
            part(ServiceCharges; "Hotel Service Charges")
            {
                ApplicationArea = All;
                SubPageLink = "Reservation No." = field("Reservation No.");
                UpdatePropagation = Both;
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

                action(CaptureDeposit)
                {
                    Caption = 'Capture Deposit';
                    ApplicationArea = All;
                    Image = Payment;
                    trigger OnAction()
                    var
                        PaymentMgt: Codeunit "Hotel Payment Mgt";
                        Amount: Decimal;
                    begin
                        Amount := Rec."Deposit Amount";
                        if Amount <= 0 then
                            Error(EnterDepositAmountErr);
                        if PaymentMgt.CaptureDeposit(Rec, Amount, true) then
                            Message(DepositCapturedMsg)
                        else
                            Message(DepositFailedMsg);
                    end;
                }
                action(CheckIn)
                {
                    Caption = 'Check In';
                    ApplicationArea = All;
                    Image = ReceiptLines;
                    trigger OnAction()
                    var
                        ReservationMgt: Codeunit "Hotel Reservation Mgt";
                    begin
                        ReservationMgt.CheckIn(Rec);
                        Message(CheckedInMsg);
                    end;
                }
                action(CheckOut)
                {
                    Caption = 'Check Out';
                    ApplicationArea = All;
                    Image = PostedReceipt;
                    trigger OnAction()
                    var
                        ReservationMgt: Codeunit "Hotel Reservation Mgt";
                    begin
                        ReservationMgt.CheckOut(Rec);
                        Message(CheckedOutMsg);
                    end;
                }
            }
            group(Finance)
            {
                Caption = 'Finance';

                action(GenerateInvoice)
                {
                    Caption = 'Generate Invoice';
                    ApplicationArea = All;
                    Image = Invoice;
                    trigger OnAction()
                    var
                        BillingMgt: Codeunit "Hotel Billing Mgt";
                    begin
                        BillingMgt.GenerateInvoice(Rec);
                        Message(InvoiceGeneratedMsg, Rec."Invoice No.");
                    end;
                }
                action(SettleFinalPayment)
                {
                    Caption = 'Settle Final Payment';
                    ApplicationArea = All;
                    Image = Payment;
                    trigger OnAction()
                    var
                        PaymentMgt: Codeunit "Hotel Payment Mgt";
                        ReservationMgt: Codeunit "Hotel Reservation Mgt";
                    begin
                        if Rec."Amount Due" <= 0 then
                            Error(NothingDueErr);
                        if PaymentMgt.ProcessFinalPayment(Rec, Rec."Amount Due", true) then begin
                            if Rec."Amount Due" = 0 then
                                ReservationMgt.CloseReservation(Rec);
                            Message(FinalPaymentMsg);
                        end else
                            Message(FinalFailedMsg);
                    end;
                }
                action(ProcessRefund)
                {
                    Caption = 'Process Refund';
                    ApplicationArea = All;
                    Image = Cancel;
                    trigger OnAction()
                    var
                        RefundMgt: Codeunit "Hotel Refund Mgt";
                    begin
                        RefundMgt.ProcessRefund(Rec, Rec."Amount Paid", RefundReasonTxt);
                        Message(RefundProcessedMsg);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(CaptureDeposit_Promoted; CaptureDeposit) { }
                actionref(CheckIn_Promoted; CheckIn) { }
                actionref(CheckOut_Promoted; CheckOut) { }
                actionref(GenerateInvoice_Promoted; GenerateInvoice) { }
                actionref(SettleFinalPayment_Promoted; SettleFinalPayment) { }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        HotelSetup: Record "Hotel Setup";
    begin
        NewMode := true;
        if Rec."Reservation No." = '' then begin
            HotelSetup.GetSingleton();
            Rec."Reservation No." := HotelSetup.NextReservationNo();
        end;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        NewMode := false;
    end;

    var
        NewMode: Boolean;
        EnterDepositAmountErr: Label 'Please enter a Deposit Amount before capturing.';
        DepositCapturedMsg: Label 'Deposit captured successfully.';
        DepositFailedMsg: Label 'Deposit capture failed. Reservation is not marked as deposited.';
        CheckedInMsg: Label 'Guest checked in.';
        CheckedOutMsg: Label 'Guest checked out.';
        InvoiceGeneratedMsg: Label 'Invoice %1 generated.';
        FinalPaymentMsg: Label 'Final payment settled.';
        FinalFailedMsg: Label 'Final payment failed.';
        NothingDueErr: Label 'There is no amount due on this reservation.';
        RefundProcessedMsg: Label 'Refund processed.';
        RefundReasonTxt: Label 'Manual refund';
}
