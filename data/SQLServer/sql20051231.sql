CREATE table codemain (
    id int IDENTITY(1,1),
    titleImg Varchar(20),  /*标题图片*/
    titleName Varchar(20),
    isUse char(1),/*1:为启用 2:为不启用*/
    allowStr varchar(20) /*权限判定字符串*/

)
GO

CREATE table codedetail (
    id int IDENTITY(1,1),
    codemainid int not null, /*主表的ID*/
    showname varchar(20), 
    showtype char(1), /*1:checkbox  3:input  3.year */
    value varchar(20), /*0:不选择 1:选择  当为year时 1|1 表示需用，并且年为四年制 1|0表示年为两年制*/
    codeorder int
)
GO



INSERT INTO  codemain (titleImg,titleName,isUse,allowStr) VALUES ('/images/sales.gif','项目编码',1,'ProjCode:Maintenance')
GO

INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'编码前缀',2,'proj',1)
GO

INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'客户类型编码',1,'1',2)
GO

INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'项目类型编码',1,'1',3)
GO


INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'工作类型编码',1,'1',4)
GO


INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'年',3,'1|1',5)
GO
INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'月',1,'1',6)
GO

INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'日',1,'1',7)
GO


INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'流水号位数',2,'4',8)
GO


/*修改项目编码的链接地址到公共方法*/
update MainMenuInfo set linkAddress='/system/codeMaint.jsp?codemainid=1' where  linkAddress='/proj/CodeFormat/CodeFormatView.jsp'
Go
/*向工作类型表插入工作类型编码*/
ALTER  TABLE Prj_WorkType ADD worktypeCode varchar(50)
GO


alter PROCEDURE Prj_WorkType_Insert (
@fullname_1 	varchar(50), 
@description_2 	varchar(150),
@worktypecode varchar(50),
@flag	int	output, @msg	varchar(80)	output) 
AS
INSERT INTO Prj_WorkType ( fullname, description,worktypecode) 
VALUES ( @fullname_1, @description_2,@worktypecode) 
set @flag = 1 set @msg = 'OK!'
GO


alter PROCEDURE Prj_WorkType_Update (
@id	 	int,
 @fullname 	varchar(50),
 @description 	varchar(150), 
 @worktypecode varchar(50),
 @flag	int	output, @msg	varchar(80)	output) 
  AS 
  UPDATE Prj_WorkType  
  SET  fullname	 = @fullname, description = @description,worktypecode= @worktypecode  
   WHERE ( id	 = @id) 
    set @flag = 1 set @msg = 'OK!'


GO
