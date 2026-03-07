codeunit 69000 KNHFunctions
{
    procedure SMPCommentCount(VendorNo: Code[20]) LastComment: Text[80]
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.Reset();
        CommentLine.SetCurrentKey("Table Name", "No.", Date);
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Vendor);
        CommentLine.SetRange("No.", VendorNo);
        if CommentLine.FindLast() then
            LastComment := CommentLine.Comment;
    end;
}