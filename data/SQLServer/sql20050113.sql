create table HrmOtherSettings(
remindperiod char(4),
valid char(1)
)
GO

insert into HrmOtherSettings(remindperiod,valid) values('30','1')
GO

alter table HrmResource add passwdchgdate char(10)
GO

insert into SystemRights (id,rightdesc,righttype) values (454,'hrm其他设置维护','3') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (454,7,'hrm其他设置维护','hrm其他设置维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (454,8,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3145,'hrm其他设置编辑','OtherSettings:Edit',454)
GO

insert into SystemRightToGroup (groupid,rightid) values (3,454)
GO

insert into SystemRightRoles (rightid,roleid,rolelevel) values (454,4,'2')
GO

INSERT INTO HtmlLabelIndex values(17563,'hrm其他设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(17563,'其他设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17563,'',8) 
GO


alter PROCEDURE HrmResourceSystemInfo_Insert (@id_1 int, @loginid_2 varchar(20), @password_3 varchar(60), @systemlanguage_4 int, @seclevel_5 int, @email_6 varchar(60) ,@flag int output, @msg varchar(60) output) AS declare @count int  declare @oldpass varchar(60)  declare @chgpasswddate char(10)  set @chgpasswddate=null select @oldpass=password from HrmResource where id=@id_1 if (@oldpass is null and @password_3<>'0' ) or @oldpass<>@password_3 set @chgpasswddate=convert(char(10),getdate(),120)  if @loginid_2 is not null and @loginid_2 != '' and @loginid_2 != 'sysadmin' select @count = count(id) from HrmResource where id != @id_1 and loginid = @loginid_2  if ( @count is not null and @count > 0 ) or @loginid_2 = 'sysadmin' select 0 else begin if @password_3 = '0' UPDATE HrmResource SET loginid = @loginid_2, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate WHERE id = @id_1 else UPDATE HrmResource SET loginid = @loginid_2, password = @password_3, systemlanguage = @systemlanguage_4, seclevel = @seclevel_5, email = @email_6,passwdchgdate =@chgpasswddate  WHERE id = @id_1 end
GO

alter PROCEDURE HrmResource_UpdatePassword (@id_1 	int, @passwordold_2     varchar(100), @passwordnew_3     varchar(100), @flag                             integer output, @msg                             varchar(80) output ) AS if @id_1 != 1 update HrmResource set password = @passwordnew_3,passwdchgdate=convert(char(10),getdate(),120) where id=@id_1 and password = @passwordold_2 else update HrmResourceManager set password = @passwordnew_3 where id=@id_1 and password = @passwordold_2  if @@ROWCOUNT<>0 begin set @flag=1 set @msg='更改密码成功' select 1 return end else begin set @flag=1 set @msg='更改密码失败' select 2 return end
GO


update HrmResource set passwdchgdate=convert(char(10),getdate(),120) where loginid is not null and password is not null
GO