alter table HrmSubCompany add supsubcomid int default 0
GO 
alter table HrmSubCompany add   url varchar(50) 
GO 
alter table HrmSubCompany add   showorder int
GO
update HrmSubCompany set supsubcomid=0
go


CREATE TABLE HrmGroup(
	id int IDENTITY (1, 1) NOT NULL ,
	name char(10)  ,
	type int ,
	owner int  
) 
GO

CREATE TABLE HrmGroupMembers (
	groupid int NOT NULL ,
	userid int NOT NULL ,
	usertype char(1) 
) 
GO

CREATE TABLE HrmGroupShare (
	id int IDENTITY (1, 1) NOT NULL ,
	groupid int  ,
	sharetype int  ,
	seclevel int ,
	rolelevel int ,
	sharelevel int  ,
	userid int ,
	subcompanyid int  ,
	departmentid int ,
	roleid int  ,
	foralluser int  ,
	crmid int 
) 
GO

ALTER TABLE HrmGroup WITH NOCHECK ADD 
	CONSTRAINT PK_HrmGroup PRIMARY KEY  CLUSTERED 
	(
		id
	)  
GO

ALTER TABLE HrmGroupMembers WITH NOCHECK ADD 
	CONSTRAINT PK_HrmGroupMembers PRIMARY KEY  CLUSTERED 
	(
		groupid,
		userid
	)  
GO





INSERT INTO HtmlLabelIndex values(17617,'组') 
GO
INSERT INTO HtmlLabelInfo VALUES(17617,'自定义组',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17617,'custom group',8) 
GO

insert into SystemRights (id,rightdesc,righttype) values (462,'hrm自定义组维护','3')

GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc)
values (462,7,'hrm自定义组维护','hrm自定义组维护')
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc)
values (462,8,'','')

GO
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid)
values (3154,'hrm自定义组编辑','CustomGroup:Edit',462)
GO

insert into SystemRightToGroup (groupid,rightid) values (3,462)

GO
insert into SystemRightRoles (rightid,roleid,rolelevel) values (462,4,'2')
GO

INSERT INTO HtmlLabelIndex values(17618,'私人组') 
GO
INSERT INTO HtmlLabelInfo VALUES(17618,'私人组',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17618,'private group',8) 
GO
 
INSERT INTO HtmlLabelIndex values(17619,'公共组') 
GO
INSERT INTO HtmlLabelInfo VALUES(17619,'公共组',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17619,'public group',8) 
GO

INSERT INTO HtmlLabelIndex values(17620,'所有组') 
GO
INSERT INTO HtmlLabelInfo VALUES(17620,'所有组',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17620,'all group',8) 
GO
 

 alter PROCEDURE HrmSubCompany_Insert (@subcompanyname_1 	[varchar](200), @subcompanydesc_2 	[varchar](200), @companyid_3 	[tinyint], @supsubcomid_4 [int],@url_5 [varchar](50),@showorder_6 [int],@flag                             integer output, @msg                             varchar(80) output)  AS  
 
 declare @count int
 declare @count1 int
 select @count=count(*)  from HrmSubCompany where subcompanyname=@subcompanyname_1
 select @count1=count(*)  from HrmSubCompany where subcompanydesc=@subcompanydesc_2
 if @count>0
 begin set @flag=2 set @msg='该分部简称已经存在，不能保存！' 
 return
 end 
 if @count1>0
 begin set @flag=3 set @msg='该分部全称已经存在，不能保存！' 
 return
 end 
 INSERT INTO [HrmSubCompany] ( [subcompanyname], [subcompanydesc], [companyid],[supsubcomid],[url],[showorder])  VALUES ( @subcompanyname_1, @subcompanydesc_2, @companyid_3,@supsubcomid_4,@url_5,@showorder_6 )
 select (max(id)) from [HrmSubCompany] 
 if @@error<>0 
 begin set @flag=1 set @msg='	更新储存过程失败' 
 return 
 end 
 else 
 begin set @flag=0 set @msg='	更新储存过程成功' 
 return 
 end
GO




 alter PROCEDURE HrmSubCompany_Update (@id_1 	[int], @subcompanyname_2 	[varchar](200), @subcompanydesc_3 	[varchar](200), @companyid_4 	[tinyint],@supsubcomid_5 [int],@url_6 [varchar](50),@showorder_7 [int], @flag                             integer output, @msg                             varchar(80) output)  AS 
 
 declare @count int
 declare @count1 int
 select @count=count(*)   from HrmSubCompany where subcompanyname=@subcompanyname_2 and id!=@id_1
 select @count1=count(*)   from HrmSubCompany where subcompanydesc=@subcompanydesc_3 and id!=@id_1
 if @count>0
 begin set @flag=2 set @msg='该分部简称已经存在，不能保存！' 
 return
 end 
 if @count1>0
 begin set @flag=3 set @msg='该分部全称已经存在，不能保存！' 
 return
 end 
 UPDATE [HrmSubCompany]  SET  [subcompanyname]	 = @subcompanyname_2, [subcompanydesc]	 = @subcompanydesc_3, [companyid]	 = @companyid_4,[supsubcomid]=@supsubcomid_5,[url]=@url_6, [showorder]=@showorder_7 WHERE ( [id]	 = @id_1)
 if @@error<>0 begin set @flag=1 set @msg='	更新储存过程失败' 
 return 
 end 
 else 
 begin 
 set @flag=0 set @msg='	更新储存过程成功' 
 return 
 end
GO
 
