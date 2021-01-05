INSERT INTO HtmlLabelIndex values(18011,'是否跟随文档关联人赋权') 
GO
INSERT INTO HtmlLabelInfo VALUES(18011,'是否跟随文档关联人赋权',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18011,'set doc right by operator',8) 
GO

alter table workflow_base
add docRightByOperator int
go

CREATE TABLE Workflow_DocSource (
	id		int IDENTITY(1,1)	not null,
	requestId	int			null,
	nodeId		int			null,
	fieldId		int 			null,
	docId		int			null,
	userId		int			null,
	userType	int			null
)
GO


CREATE PROCEDURE Workflow_DocSource_Insert
@requestid	int, 
@nodeid		int,
@fieldid	int,
@docid		int,
@userid		int, 
@usertype	int, 
@flag 		integer 	output , 
@msg 		varchar(80) 	output 
AS 
declare @mcount int
select @mcount=count(*) from Workflow_DocSource where requestid =@requestid and fieldid =@fieldid and docid=@docid

if @mcount=0
	insert into Workflow_DocSource(requestId,nodeId,fieldId,docId,userId,userType) 
	values(@requestid,@nodeid,@fieldid,@docid,@userid,@usertype)

GO