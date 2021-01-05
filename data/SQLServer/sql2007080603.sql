declare @c_FnaBudgetInfo cursor
declare @f_id int
declare @f_budgetorganizationid int
declare @f_organizationtype int
declare @f_budgetperiods int
declare @f_o_budgetorganizationid int
declare @f_o_organizationtype int
declare @f_o_budgetperiods int
declare @i int
SET @c_FnaBudgetInfo = CURSOR FORWARD_ONLY STATIC FOR
SELECT id,budgetorganizationid,organizationtype,budgetperiods
FROM FnaBudgetInfo
WHERE STATUS in (1,2,3) and REVISION is null
ORDER BY budgetorganizationid,organizationtype,budgetperiods,id
delete from FnaBudgetInfo where id not in (select budgetinfoid from FnaBudgetInfoDetail) and (STATUS=0 or STATUS is null)
SET @i=1
SET @f_o_budgetorganizationid=0
SET @f_o_organizationtype=0
SET @f_o_budgetperiods=0
open @c_FnaBudgetInfo
FETCH NEXT FROM @c_FnaBudgetInfo INTO @f_id,@f_budgetorganizationid,@f_organizationtype,@f_budgetperiods
WHILE @@FETCH_STATUS = 0
BEGIN
if @f_o_budgetorganizationid=@f_budgetorganizationid and @f_o_organizationtype=@f_organizationtype and @f_o_budgetperiods=@f_budgetperiods
SET @i=@i+1
else
begin
SET @f_o_budgetorganizationid=@f_budgetorganizationid
SET @f_o_organizationtype=@f_organizationtype
SET @f_o_budgetperiods=@f_budgetperiods
SET @i=1
end
update FnaBudgetInfo set REVISION = @i where id = @f_id
FETCH NEXT FROM @c_FnaBudgetInfo INTO @f_id,@f_budgetorganizationid,@f_organizationtype,@f_budgetperiods
END
close @c_FnaBudgetInfo
GO