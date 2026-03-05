namespace SMP;
using System.IO;
using Microsoft.Sales.Document;

report 69000 SMPSalesInvoiceImport
{
    /*Summary
        This report is used to import sales invoices from an excel file.
        It then creates a sales invoice in BC.
        The excel file should be in a specific format, and the first row is header. 
    */
    ApplicationArea = All;
    Caption = 'Germany Sales Invoice Import';
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
        FileName: Text;
        SheetName: Text;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSuccessMsg: Label 'Excel records have been successfully imported.';
        PostingDescription: Text[100];

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
        this.TempExcelBuffer.OpenBookStream(IStream, SheetName);
        this.TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        RowNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        MaxRowNo := 0;
        Clear(this.PostingDescription);
        this.TempExcelBuffer.Reset();
        if this.TempExcelBuffer.FindLast() then
            MaxRowNo := this.TempExcelBuffer."Row No.";
        for RowNo := 2 to MaxRowNo do
            this.CreateInvoice(RowNo);
        Message(this.ExcelImportSuccessMsg);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        this.TempExcelBuffer.Reset();
        if this.TempExcelBuffer.Get(RowNo, ColNo) then
            exit(this.TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure createInvoice(RowNo_: Integer)
    begin
        if this.SalesHeader."Sell-to Customer No." <> this.GetValueAtCell(RowNo_, 2) then begin
            Clear(this.SalesHeader);
            Clear(this.PostingDescription);
            this.LineNo := 0;
            this.SalesHeader.Init();
            this.SalesHeader.Validate("Document Type", this.SalesHeader."Document Type"::Invoice);
            this.SalesHeader.InitInsert();
            Evaluate(this.SalesHeader."Sell-to Customer No.", this.GetValueAtCell(RowNo_, 2));
            this.SalesHeader.Validate("Sell-to Customer No.");
            Evaluate(this.SalesHeader."Posting Date", this.GetValueAtCell(RowNo_, 5));
            this.SalesHeader.Validate("Posting Date");
            Evaluate(this.SalesHeader."Document Date", this.GetValueAtCell(RowNo_, 6));
            this.SalesHeader.Validate("Document Date");
            Evaluate(this.SalesHeader."Due Date", this.GetValueAtCell(RowNo_, 7));
            this.SalesHeader.Validate("Due Date");
            Evaluate(this.SalesHeader."Shortcut Dimension 1 Code", this.GetValueAtCell(RowNo_, 1)); //Company Code
            Evaluate(this.SalesHeader."External Document No.", this.GetValueAtCell(RowNo_, 8));
            if this.GetValueAtCell(RowNo_, 11) <> '' then begin
                Evaluate(this.SalesHeader."Gen. Bus. Posting Group", this.GetValueAtCell(RowNo_, 11));
                this.SalesHeader.Validate("Gen. Bus. Posting Group");
            end;
            if (this.GetValueAtCell(RowNo_, 13) <> '') and (this.PostingDescription = '') then
                Evaluate(this.PostingDescription, this.GetValueAtCell(RowNo_, 13));
            this.SalesHeader.Validate("Posting Description", this.PostingDescription);
            this.SalesHeader.Insert();
        end;
        this.SalesLine.Init();
        this.SalesLine.Validate("Document Type", this.SalesHeader."Document Type");
        this.SalesLine.Validate("Document No.", this.SalesHeader."No.");
        this.LineNo := this.LineNo + 10000;
        this.SalesLine."Line No." := this.LineNo;
        this.SalesLine.Validate(Type, this.SalesLine.Type::"G/L Account");
        Evaluate(this.SalesLine."No.", this.GetValueAtCell(RowNo_, 9));
        this.SalesLine.Validate("No.");
        Evaluate(this.SalesLine.Description, this.GetValueAtCell(RowNo_, 3));
        if this.GetValueAtCell(RowNo_, 11) <> '' then begin
            Evaluate(this.SalesLine."Gen. Bus. Posting Group", this.GetValueAtCell(RowNo_, 11));
            this.SalesLine.Validate("Gen. Bus. Posting Group");
        end;
        if this.GetValueAtCell(RowNo_, 12) <> '' then begin
            Evaluate(this.SalesLine."Gen. Prod. Posting Group", this.GetValueAtCell(RowNo_, 12));
            this.SalesLine.Validate("Gen. Prod. Posting Group");
        end;
        if this.GetValueAtCell(RowNo_, 10) <> '' then begin
            Evaluate(this.SalesLine."VAT Prod. Posting Group", this.GetValueAtCell(RowNo_, 10));
            this.SalesLine.Validate("VAT Prod. Posting Group");
        end;
        this.SalesLine.Validate(Quantity, 1);
        Evaluate(this.SalesLine."Unit Price", this.GetValueAtCell(RowNo_, 4));
        this.SalesLine.Validate("Unit Price");

        this.SalesLine.Insert();
    end;
}
