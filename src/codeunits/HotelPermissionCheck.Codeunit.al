codeunit 50054 "Hotel Permission Check"
{
    Access = Public;

    procedure CheckIsFinance()
    var
        Setup: Record "Hotel Setup";
        FinanceSetId: Code[20];
    begin
        Setup.GetSetup();
        FinanceSetId := Setup."Finance Permission Set";
        if FinanceSetId = '' then
            FinanceSetId := DefaultFinanceSetTok;
        if not UserHasPermissionSet(FinanceSetId) then
            Error(RefundNotAllowedErr);
    end;

    procedure IsFinance(): Boolean
    var
        Setup: Record "Hotel Setup";
        FinanceSetId: Code[20];
    begin
        Setup.GetSetup();
        FinanceSetId := Setup."Finance Permission Set";
        if FinanceSetId = '' then
            FinanceSetId := DefaultFinanceSetTok;
        exit(UserHasPermissionSet(FinanceSetId));
    end;

    local procedure UserHasPermissionSet(PermissionSetId: Code[20]): Boolean
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.SetRange("User Security ID", UserSecurityId());
        AccessControl.SetFilter("Role ID", '%1|%2', PermissionSetId, SuperPermissionSetTok);
        exit(not AccessControl.IsEmpty());
    end;

    var
        DefaultFinanceSetTok: Label 'HOTEL FINANCE', Locked = true;
        SuperPermissionSetTok: Label 'SUPER', Locked = true;
        RefundNotAllowedErr: Label 'You do not have permission to process refunds. This action is restricted to Finance users.';
}
