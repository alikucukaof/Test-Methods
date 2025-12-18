codeunit 99001 "Credit Limit Block Tests"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        Assert: Codeunit "Library Assert";
        CreditLimitPolicy: Codeunit "Credit Limit Policy";

    [Test]
    procedure TestReleaseAllowedIfUnderLimit()
    var
        Balance: Decimal;
        DocumentAmount: Decimal;
        CreditLimit: Decimal;
        IsApproved: Boolean;
    begin
        // [GIVEN] Total amount is under Credit Limit
        Balance := 900;
        DocumentAmount := 100;
        CreditLimit := 1000;
        IsApproved := false;

        // [WHEN] Checking for release
        CreditLimitPolicy.CheckCreditLimitForRelease(Balance, DocumentAmount, CreditLimit, IsApproved);

        // [THEN] No error occurs
    end;

    [Test]
    procedure TestReleaseBlockedIfOverLimitAndNotApproved()
    var
        Balance: Decimal;
        DocumentAmount: Decimal;
        CreditLimit: Decimal;
        IsApproved: Boolean;
    begin
        // [GIVEN] Total amount exceeds Credit Limit and NOT approved
        Balance := 900;
        DocumentAmount := 101;
        CreditLimit := 1000;
        IsApproved := false;

        // [WHEN] Checking for release
        asserterror CreditLimitPolicy.CheckCreditLimitForRelease(Balance, DocumentAmount, CreditLimit, IsApproved);

        // [THEN] Error occurs
        Assert.ExpectedError('Credit Limit Exceeded! Approval is required.');
    end;

    [Test]
    procedure TestReleaseAllowedIfOverLimitButApproved()
    var
        Balance: Decimal;
        DocumentAmount: Decimal;
        CreditLimit: Decimal;
        IsApproved: Boolean;
    begin
        // [GIVEN] Total amount exceeds Credit Limit BUT is approved
        Balance := 900;
        DocumentAmount := 101;
        CreditLimit := 1000;
        IsApproved := true;

        // [WHEN] Checking for release
        CreditLimitPolicy.CheckCreditLimitForRelease(Balance, DocumentAmount, CreditLimit, IsApproved);

        // [THEN] No error occurs
    end;

    [Test]
    procedure TestBlockErrorMessageContent()
    var
        Balance: Decimal;
        DocumentAmount: Decimal;
        CreditLimit: Decimal;
        IsApproved: Boolean;
    begin
        // [GIVEN] Total amount exceeds Credit Limit
        Balance := 1500;
        DocumentAmount := 500;
        CreditLimit := 1000;
        IsApproved := false;

        // [WHEN] Checking for release
        asserterror CreditLimitPolicy.CheckCreditLimitForRelease(Balance, DocumentAmount, CreditLimit, IsApproved);

        // [THEN] Error message contains details
        Assert.ExpectedError(Format(Balance));
        Assert.ExpectedError(Format(DocumentAmount));
        Assert.ExpectedError(Format(CreditLimit));
    end;
}
