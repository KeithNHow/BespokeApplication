namespace SMP;
using Microsoft.Purchases.Vendor;

pageextension 69005 SMPVendorList extends "Vendor List"
{
    layout
    {
        addafter("Phone No.")
        {
            field("Comment Count"; Rec."SMP Comment Count")
            {
                ApplicationArea = Basic, Suite;
                Importance = Standard;
                CaptionML = ENU = 'Comment Count', DEU = 'Kommentaranzahl';
                ToolTip = 'Specifies the number of comments that have been created for the vendor.';
            }
            field("Last Comment"; LastComment)
            {
                ApplicationArea = Basic, Suite;
                Importance = Standard;
                CaptionML = ENU = 'Last Comment', DEU = 'Letzter Kommentar';
                ToolTip = 'Specifies the last comment added for the vendor.';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        SMPFunctions: Codeunit SMPFunctions;
    begin
        LastComment := SMPFunctions.SMPCommentCount(Rec."No.");
    end;

    var
        LastComment: Text[80];
}