codeunit 60001 "Credit Limit Subscribers"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterValidateEvent, "Sell-to Customer No.", false, false)]
    local procedure OnAfterValidateSellToCustomerNo(var Rec: Record "Sales Header"; var xRec: Record "Sales Header"; CurrFieldNo: Integer)
    var
        Customer: Record Customer;
        CreditLimitPolicy: Codeunit "Credit Limit Policy";
        WarningMsg: Text;
    begin
        if Rec."Sell-to Customer No." = '' then
            exit;

        if not Customer.Get(Rec."Sell-to Customer No.") then
            exit;

        Customer.CalcFields("Balance (LCY)");
        
        WarningMsg := CreditLimitPolicy.CheckCreditLimitWarning(
            Customer."No.", 
            Customer.Name, 
            Customer."Balance (LCY)", 
            Customer."Credit Limit (LCY)"
        );

        if WarningMsg <> '' then
            Message(WarningMsg);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var IsHandled: Boolean)
    var
        Customer: Record Customer;
        CreditLimitPolicy: Codeunit "Credit Limit Policy";
    begin
        if PreviewMode then
            exit;

        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            exit;

        if not Customer.Get(SalesHeader."Sell-to Customer No.") then
            exit;

        Customer.CalcFields("Balance (LCY)");
        SalesHeader.CalcFields("Amount Including VAT");

        CreditLimitPolicy.CheckCreditLimitForRelease(
            Customer."Balance (LCY)",
            SalesHeader."Amount Including VAT",
            Customer."Credit Limit (LCY)",
            SalesHeader."Credit Limit Approved"
        );
    end;
}
