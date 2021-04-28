USE AssignmentProRep
GO

DECLARE @AProRepIndexes TABLE
(
	IndexName VARCHAR(100)
)

INSERT INTO @AProRepIndexes (IndexName)
VALUES
	('LEX_IDX_ENTRY_EXPENSE_TAX_Reverse'),
	('LEX_IDX_ENTRY_EXPENSE_TAX_PAYROLL_REPORT_ID_WITH_EET_ID_AND_DATE'),
	('LEX_IDX_ENTRY_EXPENSE_TAX_including_REVERSED_ENTRY_EXPENSE_TAX_ID_and_TYPE'),
	('LEX_IDX_ASSIGNMENT_COMPANY_ID_with_SEGMENT_LEVELS'),
	('LEX_IDX_VOUCHER_HISTORY_with_VOUCHER_ID_and_STATUS_ID_and_UPDATE_DATE'),
	('LEX_IDX_EntryExpenseTaxCRPT'),
	('LEX_IDX_EntryExpenseTax_Type_PayrollReportID'),
	('LEX_IDX_EntryCurrencyTrueUp'),
	('LEX_IDX_EntryAccountByPolicy'),
	('LEX_IDX_ENTRY_with_Company_ID_and_Create_Date');

DECLARE @name VARCHAR(100)

DECLARE index_cursor CURSOR FOR
SELECT IndexName
FROM @AProRepIndexes

OPEN index_cursor

FETCH NEXT FROM index_cursor INTO @name

WHILE @@FETCH_STATUS = 0

BEGIN
	IF EXISTS (SELECT * FROM sys.indexes where name = @name)
		PRINT 'The index already exists.';
	ELSE 
		Print @name + ' needs to be created in AssignmentProRep.';
FETCH NEXT FROM index_cursor INTO @name 
END


CLOSE index_cursor

DEALLOCATE index_cursor

