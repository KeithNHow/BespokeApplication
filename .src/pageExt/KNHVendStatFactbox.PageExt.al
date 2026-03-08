namespace KNHBespoke;
using Microsoft.Purchases.Vendor;

pageextension 69004 KNHVendStatFactbox extends "Vendor Statistics FactBox"
{
    layout
    {
        addafter(BalanceAsCustomer)
        {
            field("Comment Count"; Rec."KNH Comment Count")
            {
                ApplicationArea = Basic, Suite;
                Editable = false;
                CaptionML = ENU = 'Comment Count', DEU = 'Kommentaranzahl';
                ToolTip = 'Specifies the number of comments that have been created for the vendor.';
            }
        }
    }
}