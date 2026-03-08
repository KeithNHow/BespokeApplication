namespace SMP;
using System.IO;
using Microsoft.Sales.Document;

report 69000 KNHSalesInvoiceImport
{
    /*Summary
        This report is used to import sales records from an excel file.
        It then creates sales invoices based on the imported records.
        The excel file should be in a specific format, and the first row is header. 
    */
    ApplicationArea = All;
    Caption = 'Sales Invoice Import';
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
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
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
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
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
        if this.SalesHeader."External Document No." <> this.GetValueAtCell(ColumnNo, 8) then begin
            Clear(this.SalesHeader);
            this.LineNo := 0;
            this.SalesHeader.Init();
            this.SalesHeader.Validate("Document Type", this.SalesHeader."Document Type"::Invoice);
            this.SalesHeader.InitInsert();
            Evaluate(this.SalesHeader."Sell-to Customer No.", this.GetValueAtCell(ColumnNo, 2));
            this.SalesHeader.Validate("Sell-to Customer No.");
            Evaluate(this.SalesHeader."Posting Date", this.GetValueAtCell(ColumnNo, 5));
            this.SalesHeader.Validate("Posting Date");
            Evaluate(this.SalesHeader."Document Date", this.GetValueAtCell(ColumnNo, 6));
            this.SalesHeader.Validate("Document Date");
            Evaluate(this.SalesHeader."Due Date", this.GetValueAtCell(ColumnNo, 7));
            this.SalesHeader.Validate("Due Date");
            Evaluate(this.SalesHeader."Shortcut Dimension 1 Code", this.GetValueAtCell(ColumnNo, 1));
            Evaluate(this.SalesHeader."External Document No.", this.GetValueAtCell(ColumnNo, 8));
            if this.GetValueAtCell(ColumnNo, 10) <> '' then begin
                Evaluate(this.SalesHeader."Gen. Bus. Posting Group", this.GetValueAtCell(ColumnNo, 10));
                this.SalesHeader.Validate("Gen. Bus. Posting Group");
            end;
            this.SalesHeader.Insert();
        end;
        this.SalesLine.Init();
        this.SalesLine.Validate("Document Type", this.SalesHeader."Document Type");
        this.SalesLine.Validate("Document No.", this.SalesHeader."No.");
        this.LineNo := this.LineNo + 10000;
        this.SalesLine."Line No." := this.LineNo;
        this.SalesLine.Validate(Type, this.SalesLine.Type::"G/L Account");
        Evaluate(this.SalesLine."No.", this.GetValueAtCell(ColumnNo, 9));
        this.SalesLine.Validate("No.");
        if this.GetValueAtCell(ColumnNo, 3) <> '' then begin
            Evaluate(this.SalesLine.Description, this.GetValueAtCell(ColumnNo, 3));
            this.SalesLine.Validate(Description);
        end;
        if this.GetValueAtCell(ColumnNo, 10) <> '' then begin
            Evaluate(this.SalesLine."Gen. Bus. Posting Group", this.GetValueAtCell(ColumnNo, 10));
            this.SalesLine.Validate("Gen. Bus. Posting Group");
        end;
        if this.GetValueAtCell(ColumnNo, 11) <> '' then begin
            Evaluate(this.SalesLine."Gen. Prod. Posting Group", this.GetValueAtCell(ColumnNo, 11));
            this.SalesLine.Validate("Gen. Prod. Posting Group");
        end;
        if this.GetValueAtCell(ColumnNo, 12) <> '' then begin
            Evaluate(this.SalesLine."VAT Prod. Posting Group", this.GetValueAtCell(ColumnNo, 12));
            this.SalesLine.Validate("VAT Prod. Posting Group");
        end;
        this.SalesLine.Validate(Quantity, 1);
        Evaluate(this.SalesLine."Unit Price", this.GetValueAtCell(ColumnNo, 4));
        this.SalesLine.Validate("Unit Price");

        this.SalesLine.Insert();
    end;
}
