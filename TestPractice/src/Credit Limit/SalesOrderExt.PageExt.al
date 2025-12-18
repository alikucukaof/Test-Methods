pageextension 60001 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Credit Limit Approved"; Rec."Credit Limit Approved")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the credit limit warning has been approved.';
            }
        }
    }
}
