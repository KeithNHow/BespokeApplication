/*
namespace KNHBespoke;
using Microsoft.Purchases.Vendor;
using Microsoft.Foundation.Comment;

report 69001 KNHVendorComment
{
    ApplicationArea = Basic, Suite;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Vendor Comments';
    DefaultRenderingLayout = ExcelLayout;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.";
            DataItemTableView = sorting("No.");
            column(Number; "No.")
            {
                IncludeCaption = true;
                CaptionML = ENU = 'Number', DEU = 'Nummer';
            }
            column(Name; Name)
            {
                IncludeCaption = true;
                CaptionML = ENU = 'Name', DEU = 'der Name';
            }
            column(Balance; Balance)
            {
                IncludeCaption = true;
                CaptionML = ENU = 'Balance', DEU = 'Gleichgewicht';
            }
            dataitem(CommentLine; "Comment Line")
            {
                DataItemLinkReference = Vendor;
                DataItemLink = "No." = field("No.");
                DataItemTableView = where("Table Name" = filter(Vendor));
                column(Date; Date)
                {
                    IncludeCaption = true;
                    CaptionML = ENU = 'Date', DEU = 'Datum';
                }
                column(Comment; Comment)
                {
                    IncludeCaption = true;
                    CaptionML = ENU = 'Comment', DEU = 'Kommentar';
                }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    rendering
    {
        layout(ExcelLayout)
        {
            Type = Excel;
            LayoutFile = '.\src\Report\KNHVendorComments.xlsx';
        }
    }
}
*/
