alter table workflow_formfield add isdetail char(1)
go

CREATE TABLE workflow_formdictdetail (
	id int ,
	fieldname varchar (40) ,
	fielddbtype varchar (40) ,
	fieldhtmltype char (1) ,
	type int ,
)
go

insert into SequenceIndex(indexdesc,currentid) values('workflowformdictid',0);
go

create procedure tem_exemycom
as
declare @temint1 int
declare @temint2 int
select @temint1=max(id) from workflow_formdict
select @temint2=max(fieldid) from workflow_formfield
IF (@temint1>@temint2) BEGIN
	UPDATE SequenceIndex
	SET currentid=@temint1+1
	WHERE indexdesc = 'workflowformdictid'
END
ELSE BEGIN
	UPDATE SequenceIndex
	SET currentid=@temint2+1
	WHERE indexdesc = 'workflowformdictid'
END
go
exec tem_exemycom
go
drop procedure tem_exemycom
go


CREATE PROCEDURE SequenceIndex_SWFformdictid (@flag int output, @msg varchar(80) output)  AS select currentid from SequenceIndex where indexdesc='workflowformdictid' update SequenceIndex set currentid = currentid+1 where indexdesc='workflowformdictid'
GO


CREATE TABLE workflow_formdetailinfo (
	formid int  ,
	rowcalstr varchar(300) ,
	colcalstr varchar(200) ,
    maincalstr varchar(200) ,
)
GO

CREATE TABLE workflow_formdetail (
	id int IDENTITY (1, 1) NOT NULL ,
	requestid int ,
)
GO

alter PROCEDURE workflow_FieldID_Select @formid		int, @flag integer output , @msg varchar(80) output AS select fieldid,fieldorder from workflow_formfield where formid=@formid and (isdetail<>'1' or isdetail is null) order by fieldid  
GO

CREATE TABLE Tmp_workflow_formdict
	(
	id int NOT NULL,
	fieldname varchar(40) NULL,
	fielddbtype varchar(40) NULL,
	fieldhtmltype char(1) NULL,
	type int NULL
	)  
GO
INSERT INTO Tmp_workflow_formdict (id, fieldname, fielddbtype, fieldhtmltype, type)
		SELECT id, fieldname, fielddbtype, fieldhtmltype, type FROM workflow_formdict 
GO
DROP TABLE workflow_formdict

EXECUTE sp_rename 'Tmp_workflow_formdict','workflow_formdict', 'OBJECT'
GO



