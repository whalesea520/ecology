
Create function verifySameGroupCtrlSubjectId(@pSubjectId INT, @pSqlSubjectId INT) 
returns INT
as 
begin 
  declare @pGcSubject1 int;
  declare @pGcSubject2 int;
  declare @pRetInt int;

	IF (@pSubjectId = @pSqlSubjectId) 
	BEGIN
		SET @pRetInt = 1 ;
	END
	ELSE 
	BEGIN
		WITH allsub(id,name,supsubject,archive,feeperiod,groupCtrl)
		as (
		SELECT id,name,supsubject,archive,feeperiod,groupCtrl FROM FnaBudgetfeeType where id=@pSubjectId
		 UNION ALL SELECT aa.id,aa.name,aa.supsubject,aa.archive,aa.feeperiod,aa.groupCtrl FROM FnaBudgetfeeType aa,allsub b where aa.id = b.supsubject 
		) select @pGcSubject1 = tt.id from allsub tt 
		where tt.groupCtrl = 1 ;

		WITH allsub(id,name,supsubject,archive,feeperiod,groupCtrl)
		as (
		SELECT id,name,supsubject,archive,feeperiod,groupCtrl FROM FnaBudgetfeeType where id=@pSqlSubjectId
		 UNION ALL SELECT aa.id,aa.name,aa.supsubject,aa.archive,aa.feeperiod,aa.groupCtrl FROM FnaBudgetfeeType aa,allsub b where aa.id = b.supsubject 
		) select @pGcSubject2 = tt.id from allsub tt 
		where tt.groupCtrl = 1 ;

		IF (@pGcSubject1 = @pGcSubject2) 
		BEGIN
			SET @pRetInt = 1 ;
		END
		ELSE 
		BEGIN
			SET @pRetInt = 0 ;
		END
	END
	
  return @pRetInt 
end
GO
