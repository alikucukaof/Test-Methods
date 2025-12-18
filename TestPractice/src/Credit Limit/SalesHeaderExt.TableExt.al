tableextension 60000 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100; "Credit Limit Approved"; Boolean)
        {
            Caption = 'Credit Limit Approved';
            DataClassification = CustomerContent;
        }
    }
}
