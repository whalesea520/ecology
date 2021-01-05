ALTER PROCEDURE FnaBudgetfeeType_Delete
	@id int,
	@flag int output,
	@msg varchar(80) output
AS
	IF EXISTS (SELECT feetypeid FROM bill_expensedetail WHERE feetypeid = @id)
	OR EXISTS (SELECT id FROM FnaBudgetInfoDetail WHERE budgettypeid = @id)
	OR EXISTS (SELECT id FROM FnaBudgetCheckDetail WHERE budgettypeid = @id)
	OR EXISTS (SELECT id FROM FnaBudgetfeeType WHERE supsubject = @id)
    OR EXISTS (SELECT id FROM FnaExpenseInfo WHERE subject = @id)
    OR EXISTS (SELECT id FROM Bill_FnaWipeApplyDetail WHERE subject = @id)
    OR EXISTS (SELECT id FROM Bill_FnaBudgetChgApplyDetail WHERE subject=@id)
	BEGIN
		SELECT -1
		RETURN
	END
	DELETE fnaBudgetfeetype WHERE id = @id
GO
