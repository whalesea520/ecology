CREATE TABLE workflow_customQuerytype (
	id int IDENTITY (1, 1) NOT NULL ,
	typename varchar(100) NULL ,
	typenamemark text NULL,
    showorder decimal(10, 2) default (0)
)
GO
INSERT INTO workflow_customQuerytype (typename, typenamemark, showorder)  VALUES ('自定义查询', '自定义查询',0)
GO

alter table Workflow_Custom add Querytypeid int
GO
alter table Workflow_Custom add Customname varchar(100)
GO
alter table Workflow_Custom add Customdesc text
GO
alter table Workflow_Custom add workflowids text
GO
alter table Workflow_CustomDspField add queryorder int default(0)
GO
update Workflow_CustomDspField set queryorder=0
GO
update Workflow_Custom set Querytypeid=1
GO
update Workflow_Custom set Customname=(select formname from workflow_formbase where workflow_formbase.id=Workflow_Custom.formid) where isbill!='1' or isbill is null
GO
update Workflow_Custom set Customname=(select HtmlLabelinfo.labelname from workflow_bill,HtmlLabelinfo where workflow_bill.namelabel=HtmlLabelinfo.indexid and HtmlLabelinfo.languageid=7 and workflow_bill.id=Workflow_Custom.formid) where isbill='1'
GO

alter  PROCEDURE Workflow_CustomDspField_Init
(@reportid_1    int, @flag   int   output, @msg    varchar(80)   output) AS 

begin

INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( @reportid_1, -9,'0','1',9,9) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( @reportid_1, -8,'0','1',8,8) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( @reportid_1, -7,'0','1',7,7) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( @reportid_1, -6,'0','1',6,6) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( @reportid_1, -5,'1','1',5,5) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( @reportid_1, -4,'1','1',4,4) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( @reportid_1, -3,'1','1',3,3) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( @reportid_1, -2,'1','1',2,2) ;
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder)
VALUES ( @reportid_1, -1,'1','1',1,1) ;
end 

GO

alter  PROCEDURE Workflow_CustomDspField_Insert
(@reportid_1    int, @fieldid_2   int,  @dborder_3     char(1) , @shows char(1), @compositororder  varchar(10),@queryorder int, @flag   int   output, @msg    varchar(80)   output) AS
INSERT INTO Workflow_CustomDspField ( customid, fieldid, ifquery, ifshow,showorder,queryorder) VALUES ( @reportid_1, @fieldid_2, @dborder_3, @shows, @compositororder,@queryorder) 

GO

CREATE PROCEDURE Workflow_QueryType_Insert (
@typename_1 	varchar(100),
@typenamemark_2 text,
@showorder_3 	decimal(10, 2),
@flag	int	output,
@msg	varchar(80)	output) 
AS 
INSERT INTO workflow_customQuerytype (typename, typenamemark, showorder)  VALUES ( @typename_1, @typenamemark_2, @showorder_3) 

GO

CREATE PROCEDURE Workflow_QueryType_Update (
@id_1 	int,
@typename_2 	varchar(100),
@typenamemark_3 	text,
@showorder_4 	decimal(10, 2),
@flag	int	output,
@msg	varchar(80)	output)
AS 
UPDATE workflow_customQuerytype  SET  typename = @typename_2, typenamemark = @typenamemark_3, showorder = @showorder_4  WHERE (id= @id_1) 

GO

CREATE  PROCEDURE Workflow_QueryType_Delete (
 @id_1 	int,
 @flag	int	output, 
 @msg	varchar(80)	output)
 AS 
 declare @count integer
 select @count = count(id) from Workflow_Custom where Querytypeid = @id_1 
 if (@count > 0)
 begin 
 select 0 return
 end 
 else 
 begin DELETE workflow_customQuerytype WHERE ( id = @id_1)
 end
GO
