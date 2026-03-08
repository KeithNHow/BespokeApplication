# Summary
Vendor Comments
Sales Invoice Import from Excel
New Vendor fields
German Captions

# Vendor Comments - 20/02/2026 - 27.0.0.0
tableExt - SMPVendor - "Comment Count"
pageExt - SMPVendorCard - "Last Comment"
(trigger OnafterGetCurrRecord calls CU Proc SMPCommentCount)
pageExt - SMPVendorList - "Comment Count", "Last Comment"
(trigger OnafterGetRecord calls CU Proc SMPCommentCount)
pageExt - SMPVendStatFactbox - "Comment Count"
codeunit - SMPFunctions (Proc SMPCommentCount)

# Sales Invoice Import from Excel - 20/02/2026 - 27.0.0.0
report - SMPVendorComment

# New Vendor fields - 20/02/2026 - 27.0.0.0
enum - SMPSalutation
pageExt - SMPVendorCard - GenTab "Salutation", AddrTab "House No."
tableExt - SMPVendor - "Salutation", "House No."

# German Captions - 01/03/2026 - 27.0.0.1
German captions added to enum - SMPSalutation, tableExt - SMPVendor, pageExt - SMPVendorCard
pageExt - SMPVendorList, pageExt - SMPVendStatFactbox