codeunit 99002 "Credit Limit Warning Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "Library Assert";
        CreditLimitPolicy: Codeunit "Credit Limit Policy";

    [Test]
    procedure TestNoWarningIfBalanceBelowLimit()
    var
        CustomerNo: Code[20];
        CustomerName: Text[100];
        Balance: Decimal;
        CreditLimit: Decimal;
        WarningMessage: Text;
    begin
        // [GIVEN] Balance is below Credit Limit
        CustomerNo := 'C001';
        CustomerName := 'Test Customer';
        Balance := 900;
        CreditLimit := 1000;

        // [WHEN] Checking for warning
        WarningMessage := CreditLimitPolicy.CheckCreditLimitWarning(CustomerNo, CustomerName, Balance, CreditLimit);

        // [THEN] No warning message is returned
        Assert.AreEqual('', WarningMessage, 'Warning message should be empty when balance is below limit.');
    end;

    [Test]
    procedure TestWarningIfBalanceExceedsLimit()
    var
        CustomerNo: Code[20];
        CustomerName: Text[100];
        Balance: Decimal;
        CreditLimit: Decimal;
        WarningMessage: Text;
    begin
        // [GIVEN] Balance exceeds Credit Limit
        CustomerNo := 'C001';
        CustomerName := 'Test Customer';
        Balance := 1100;
        CreditLimit := 1000;

        // [WHEN] Checking for warning
        WarningMessage := CreditLimitPolicy.CheckCreditLimitWarning(CustomerNo, CustomerName, Balance, CreditLimit);

        // [THEN] Warning message is returned
        Assert.AreNotEqual('', WarningMessage, 'Warning message should not be empty when balance exceeds limit.');
    end;

    [Test]
    procedure TestWarningMessageContent()
    var
        CustomerNo: Code[20];
        CustomerName: Text[100];
        Balance: Decimal;
        CreditLimit: Decimal;
        WarningMessage: Text;
    begin
        // [GIVEN] Balance exceeds Credit Limit
        CustomerNo := 'C001';
        CustomerName := 'Test Customer';
        Balance := 1500;
        CreditLimit := 1000;

        // [WHEN] Checking for warning
        WarningMessage := CreditLimitPolicy.CheckCreditLimitWarning(CustomerNo, CustomerName, Balance, CreditLimit);

        // [THEN] Message contains relevant info
        Assert.ExpectedMessage(CustomerNo, WarningMessage);
        Assert.ExpectedMessage(CustomerName, WarningMessage);
        Assert.ExpectedMessage(Format(Balance), WarningMessage);
        Assert.ExpectedMessage(Format(CreditLimit), WarningMessage);
    end;
}
