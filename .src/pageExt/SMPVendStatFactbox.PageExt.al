pageextension 69004 SMPVendStatFactbox extends "Vendor Statistics FactBox"
{
    layout
    {
        addafter(BalanceAsCustomer)
        {
            field("Comment Count"; Rec."SMP Comment Count")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                CaptionML = ENU = 'Comment Count', DEU = 'Kommentaranzahl';
                ToolTip = 'Specifies the number of comments that have been created for the vendor.';
            }
        }
    }
}