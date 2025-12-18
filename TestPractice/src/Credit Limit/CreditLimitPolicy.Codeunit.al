codeunit 60000 "Credit Limit Policy"
{
    // Business logic for Credit Limit checks.
    // Isolated from UI/Database for easier unit testing.

    procedure CheckCreditLimitWarning(CustomerNo: Code[20]; CustomerName: Text[100]; Balance: Decimal; CreditLimit: Decimal): Text
    var
        WarningMsg: Label 'Customer %1 (%2) has exceeded their credit limit.\Balance: %3\Credit Limit: %4';
    begin
        if CreditLimit = 0 then
            exit('');

        if Balance > CreditLimit then
            exit(StrSubstNo(WarningMsg, CustomerNo, CustomerName, Balance, CreditLimit));

        exit('');
    end;

    procedure CheckCreditLimitForRelease(Balance: Decimal; DocumentAmount: Decimal; CreditLimit: Decimal; IsApproved: Boolean)
    var
        LimitExceededErr: Label 'Credit Limit Exceeded! Approval is required.\Balance: %1\Document Amount: %2\Credit Limit: %3';
    begin
        if CreditLimit = 0 then
            exit;

        if (Balance + DocumentAmount > CreditLimit) and (not IsApproved) then
            Error(LimitExceededErr, Balance, DocumentAmount, CreditLimit);
    end;
}
