namespace SMP;
using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.Comment;

tableextension 69001 SMPVendor extends Vendor
{
    fields
    {
        field(69000; "SMP Comment Count"; Integer)
        {
            CaptionML = ENU = 'Comment Count', DEU = 'Kommentaranzahl';
            AllowInCustomizations = AsReadWrite;
            CalcFormula = count("Comment Line" where("Table Name" = const(Vendor),
                                                      "No." = field("No.")));
            FieldClass = FlowField;
            Editable = false;
            ToolTip = 'Specifies whether the vendor has comments.';
        }
        field(69001; "SMP Salutation"; Enum SMPSalutation)
        {
            CaptionML = ENU = 'Salutation', DEU = 'Anrede';
            DataClassification = CustomerContent;
            AllowInCustomizations = AsReadWrite;
            ToolTip = 'Specifies the salutation to be used in correspondence with the vendor.';
        }
        field(69002; "SMP House No."; Text[10])
        {
            CaptionML = ENU = 'House No.', DEU = 'Hausnummer';
            DataClassification = CustomerContent;
            AllowInCustomizations = AsReadWrite;
            ToolTip = 'Specifies the house number of the vendor address.';
        }
    }
}
