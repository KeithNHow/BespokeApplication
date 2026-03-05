namespace SMP;
using Microsoft.Purchases.Vendor;

pageextension 69003 SMPVendorCard extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field(Salutation; Rec."SMP Salutation")
            {
                ApplicationArea = Basic, Suite;
                Importance = Standard;
                CaptionML = ENU = 'Salutation', DEU = 'Anrede';
                ToolTip = 'Specifies the value of the SMP Salutation field.';
            }
            field("Last Comment"; LastComment)
            {
                ApplicationArea = Basic, Suite;
                MultiLine = true;
                Importance = Standard;
                Editable = false;
                CaptionML = ENU = 'Last Comment', DEU = 'Letzter Kommentar';
                ToolTip = 'Specifies the last comment added for the vendor.';
            }
        }
        addbefore(Address)
        {
            field("House No."; Rec."SMP House No.")
            {
                ApplicationArea = Basic, Suite;
                Importance = Standard;
                CaptionML = ENU = 'House No.', DEU = 'Hausnummer';
                ToolTip = 'Specifies the value of the SMP House No. field.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        SMPFunctions: Codeunit SMPFunctions;
    begin
        LastComment := SMPFunctions.SMPCommentCount(Rec."No.");
    end;

    var
        LastComment: Text[80];
}
