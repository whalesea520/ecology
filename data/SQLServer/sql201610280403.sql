create table fnaInitDataTb(
  typeName varchar(200), 
  result1 char(1) 
)
GO

update FnaBudgetfeeType set isEditFeeType = 0
GO

update FnaBudgetfeeType set isEditFeeType = 1 where feelevel = 3
GO


create table FnabudgetfeetypeCGE(
  mainSubjectId int not null, 
  subjectId int not null 
)
GO

ALTER TABLE FnabudgetfeetypeCGE WITH NOCHECK ADD CONSTRAINT pk_FnaBftCGE PRIMARY KEY NONCLUSTERED(mainSubjectId, subjectId)
GO

ALTER TABLE FnaBudgetfeeType ADD groupCtrlGuid CHAR(32)
GO
ALTER TABLE FnaBudgetfeeType ADD groupCtrlId int 
GO

ALTER TABLE FnaBudgetfeeType ADD isEditFeeTypeGuid CHAR(32)
GO
ALTER TABLE FnaBudgetfeeType ADD isEditFeeTypeId int 
GO

Create function fnaChkSubjectAffi(@supSubjectId int, @subjectId int) 
returns INT
as 
begin 
  declare @pCnt int;
	
	WITH allsub(id,name,supsubject)
	as (
	  SELECT id,name,supsubject 
	  FROM FnaBudgetfeeType 
	  where id = @supSubjectId 
	  UNION ALL 
	  SELECT a.id,a.name,a.supsubject 
	  FROM FnaBudgetfeeType a,allsub b 
	  where a.supsubject = b.id
	) select @pCnt = count(*) from allsub 
	where id = @subjectId 

  return @pCnt 
end
GO

Create function fnaGetGroupCtrlKmId(@subjectId int) 
returns INT
as 
begin 
  declare @GroupCtrlId int;

  WITH allsub(id,name,supsubject,groupCtrl)
  as (
    SELECT id,name,supsubject,groupCtrl 
    FROM FnaBudgetfeeType 
    where id = @subjectId 
    UNION ALL 
    SELECT a.id,a.name,a.supsubject,a.groupCtrl 
    FROM FnaBudgetfeeType a,allsub b 
    where a.id = b.supsubject 
  ) select @GroupCtrlId = id from allsub 
  where groupCtrl = 1 

  return @GroupCtrlId 
end
GO

drop function verifySameGroupCtrlSubjectId
GO

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
		select @pGcSubject1 = a.groupCtrlId from FnaBudgetfeeType a where a.id = @pSubjectId;
		select @pGcSubject2 = a.groupCtrlId from FnaBudgetfeeType a where a.id = @pSqlSubjectId;

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
