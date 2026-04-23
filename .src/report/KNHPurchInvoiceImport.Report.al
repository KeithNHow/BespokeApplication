namespace KNHBespoke;
using Microsoft.Purchases.Document;
using System.IO;

report 69002 KNHPurchInvoiceImport
{
    /*Summary
        This report is used to import Purch records from an excel file.
        It then creates Purch invoices based on the imported records.
        The excel file should be in a specific format, and the first row is header. 
    */
    ApplicationArea = All;
    Caption = 'Purchase Invoice Import';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnInitReport()
    begin
        this.ReadExcelSheet();
        this.ImportExcelData();
    end;

    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        LineNo: Integer;
        ExcelImportSuccessMsg: Label '%1 Excel records have been successfully imported.', Comment = '%1 = Number of records';
        NoFileFoundMsg: Label 'No Excel file found!';
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        FileName: Text;
        SheetName: Text;

    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text;
    begin
        UploadIntoStream(this.UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            this.FileName := FileMgt.GetFileName(FromFile);
            this.SheetName := this.TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(this.NoFileFoundMsg);
        this.TempExcelBuffer.Reset();
        this.TempExcelBuffer.DeleteAll();
        this.TempExcelBuffer.OpenBookStream(IStream, this.SheetName);
        this.TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        MaxRowNo: Integer;
        RowNo: Integer;
    begin
        RowNo := 0;
        MaxRowNo := 0;
        this.TempExcelBuffer.Reset();
        if this.TempExcelBuffer.FindLast() then
            MaxRowNo := this.TempExcelBuffer."Row No.";
        for RowNo := 2 to MaxRowNo do
            this.CreateInvoice(RowNo);
        Message(this.ExcelImportSuccessMsg, MaxRowNo - 1);
    end;

    local procedure GetValueAtCell(pColumnNo: Integer; pColNo: Integer): Text
    begin
        this.TempExcelBuffer.Reset();
        if this.TempExcelBuffer.Get(pColumnNo, pColNo) then
            exit(this.TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure CreateInvoice(ColumnNo: Integer)
    begin
        if this.PurchHeader."Vendor Invoice No." <> this.GetValueAtCell(ColumnNo, 8) then begin
            Clear(this.PurchHeader);
            this.LineNo := 0;
            this.PurchHeader.Init();
            this.PurchHeader.Validate("Document Type", this.PurchHeader."Document Type"::Invoice);
            this.PurchHeader.InitInsert();
            Evaluate(this.PurchHeader."Buy-from Vendor No.", this.GetValueAtCell(ColumnNo, 2));
            this.PurchHeader.Validate("Buy-from Vendor No.");
            Evaluate(this.PurchHeader."Posting Date", this.GetValueAtCell(ColumnNo, 5));
            this.PurchHeader.Validate("Posting Date");
            Evaluate(this.PurchHeader."Document Date", this.GetValueAtCell(ColumnNo, 6));
            this.PurchHeader.Validate("Document Date");
            Evaluate(this.PurchHeader."Due Date", this.GetValueAtCell(ColumnNo, 7));
            this.PurchHeader.Validate("Due Date");
            Evaluate(this.PurchHeader."Shortcut Dimension 1 Code", this.GetValueAtCell(ColumnNo, 1));
            Evaluate(this.PurchHeader."Vendor Invoice No.", this.GetValueAtCell(ColumnNo, 8));
            if this.GetValueAtCell(ColumnNo, 10) <> '' then begin
                Evaluate(this.PurchHeader."Gen. Bus. Posting Group", this.GetValueAtCell(ColumnNo, 10));
                this.PurchHeader.Validate("Gen. Bus. Posting Group");
            end;
            this.PurchHeader.Insert();
        end;
        this.PurchLine.Init();
        this.PurchLine.Validate("Document Type", this.PurchHeader."Document Type");
        this.PurchLine.Validate("Document No.", this.PurchHeader."No.");
        this.LineNo := this.LineNo + 10000;
        this.PurchLine."Line No." := this.LineNo;
        this.PurchLine.Validate(Type, this.PurchLine.Type::"G/L Account");
        Evaluate(this.PurchLine."No.", this.GetValueAtCell(ColumnNo, 9));
        this.PurchLine.Validate("No.");
        if this.GetValueAtCell(ColumnNo, 3) <> '' then begin
            Evaluate(this.PurchLine.Description, this.GetValueAtCell(ColumnNo, 3));
            this.PurchLine.Validate(Description);
        end;
        if this.GetValueAtCell(ColumnNo, 10) <> '' then begin
            Evaluate(this.PurchLine."Gen. Bus. Posting Group", this.GetValueAtCell(ColumnNo, 10));
            this.PurchLine.Validate("Gen. Bus. Posting Group");
        end;
        if this.GetValueAtCell(ColumnNo, 11) <> '' then begin
            Evaluate(this.PurchLine."Gen. Prod. Posting Group", this.GetValueAtCell(ColumnNo, 11));
            this.PurchLine.Validate("Gen. Prod. Posting Group");
        end;
        if this.GetValueAtCell(ColumnNo, 12) <> '' then begin
            Evaluate(this.PurchLine."VAT Prod. Posting Group", this.GetValueAtCell(ColumnNo, 12));
            this.PurchLine.Validate("VAT Prod. Posting Group");
        end;
        this.PurchLine.Validate(Quantity, 1);
        Evaluate(this.PurchLine.Amount, this.GetValueAtCell(ColumnNo, 4));
        this.PurchLine.Validate("Amount");

        this.PurchLine.Insert();
    end;
}