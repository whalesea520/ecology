
/*以下是陈英杰《Ecology－产品开发人力资源银行提交测试报告 》的脚本*/
 
 alter PROCEDURE HrmBank_Insert 
  ( @bankname	varchar(60), 
  @bankdesc	varchar(200), 
  @flag                             integer output, 
  @msg                             varchar(80) output ) 
  AS INSERT INTO hrmbank values(@bankname, @bankdesc)  
  select max(id) from hrmbank  
  if @@error<>0 begin set @flag=1 set @msg='查询人力资源信息成功' 
  return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end
GO

  alter PROCEDURE HrmBank_Update 
  (@id	int, 
  @bankname	varchar(60), @bankdesc	varchar(200),
  @flag                             integer output, 
  @msg                             varchar(80) output ) 
  AS update hrmbank set 
  bankname=@bankname,
  bankdesc=@bankdesc
 where 
 id=@id  
 if @@error<>0
 begin set @flag=1 set @msg='查询人力资源信息成功' 
 return end else begin set @flag=0 set @msg='查询人力资源信息失败' return end
GO


/* 以下是刘煜《 Ecology产品开发 资产性能改进 提交测试报告.doc 》的脚本*/

alter PROCEDURE [CptAssortmentShareInfo_Insert]
(@relateditemid_1 [int],
@sharetype_2 [tinyint],
@seclevel_3 [tinyint],
@rolelevel_4 [tinyint],
@sharelevel_5 [tinyint],
@userid_6 [int],
@departmentid_7 [int],
@roleid_8 [int],
@foralluser_9 [tinyint],
@sharefrom_10 int ,
@flag integer output,
@msg varchar(80) output)

AS INSERT INTO [CptCapitalShareInfo]
( [relateditemid],
[sharetype],
[seclevel],
[rolelevel],
[sharelevel],
[userid],
[departmentid],
[roleid],
[foralluser],
sharefrom)

VALUES
( @relateditemid_1,
@sharetype_2,
@seclevel_3,
@rolelevel_4,
@sharelevel_5,
@userid_6,
@departmentid_7,
@roleid_8,
@foralluser_9,
@sharefrom_10)
GO


/*以下是陈英杰的Ecology－产品开发应聘人员录用修改提交测试报告的脚本*/

CREATE procedure HrmCareerApplyHire
(@resourceid_1 	[int], 
 @flag int output, @msg varchar(60) output)

as delete HrmCareerApply 
where
 id = @resourceid_1

delete HrmInterview
where 
 resourceid = @resourceid_1

delete HrmInterviewAssess
where
 resourceid = @resourceid_1

delete HrmInterviewResult
where
 resourceid = @resourceid_1

delete HrmCareerApplyOtherInfo
where 
  applyid = @resourceid_1
GO


/*以下是陈英杰提交的《Ecology－产品开发人力资源自定义字段编辑提交测试报告》的脚本*/
create procedure HrmResourceDefine_Update
 (@id_1 int,
  @datefield1_2 varchar(10),
  @numberfield1_3 float(8),
  @textfield1_4 varchar(100),
  @tinyintfield1_5 tinyint,
  @datefield2_6 varchar(10),
  @numberfield2_7 float(8),
  @textfield2_8 varchar(100),
  @tinyintfield2_9 tinyint,
  @datefield3_10 varchar(10),
  @numberfield3_11 float(8),
  @textfield3_12 varchar(100),
  @tinyintfield3_13 tinyint,
  @datefield4_14 varchar(10),
  @numberfield4_15 float(8),
  @textfield4_16 varchar(100),
  @tinyintfield4_17 tinyint,
  @datefield5_18 varchar(10),
  @numberfield5_19 float(8),
  @textfield5_20 varchar(100),
  @tinyintfield5_21 tinyint,
  @flag int output, @msg varchar(60) output)
 as update HrmResource set
  datefield1 = @datefield1_2 ,
  numberfield1 = @numberfield1_3 ,
  textfield1 = @textfield1_4 ,
  tinyintfield1 = @tinyintfield1_5 ,
  datefield2 = @datefield2_6 ,
  numberfield2 = @numberfield2_7 ,
  textfield2 = @textfield2_8 ,
  tinyintfield2 = @tinyintfield2_9 ,
  datefield3 = @datefield3_10 ,
  numberfield3 = @numberfield3_11 ,
  textfield3 = @textfield3_12 ,
  tinyintfield3 = @tinyintfield3_13 ,
  datefield4 = @datefield4_14 ,
  numberfield4 = @numberfield4_15 ,
  textfield4 = @textfield4_16 ,
  tinyintfield4 = @tinyintfield4_17 ,
  datefield5 = @datefield5_18 ,
  numberfield5 = @numberfield5_19 ,
  textfield5 = @textfield5_20 ,
  tinyintfield5 = @tinyintfield5_21
 where
  id = @id_1
 go
 

/*以下是杨国生的提交测试报告《ecology产品开发职务的职务类型归属不正确提交测试报》的脚本*/

drop table HrmJobActivities
GO
drop table HrmJobGroups
GO
CREATE TABLE [HrmJobGroups] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[jobgroupname] [varchar] (200)  NULL ,
	[jobgroupremark] [text]  NULL 
)
GO
CREATE TABLE [HrmJobActivities] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[jobactivitymark] [varchar] (60) NULL ,
	[jobactivityname] [varchar] (200) NULL ,
	[jobgroupid] [int] NULL ,
	[joblevelfrom] [int] NULL ,
	[joblevelto] [int] NULL 
) 
GO

insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('行政管理','行政管理',1)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('行政事务','行政事务',1)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('公司营运','公司营运',2)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('投资管理','投资管理',3)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('法律事务','法律事务',8)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('国际业务','国际业务',3)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('投资业务','投资业务',3)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('人事管理','人事管理',7)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('项目管理','项目管理',3)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('财务管理','财务管理',5)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('审计事务','审计事务',4)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('秘书','秘书',6)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('助理','助理',6)
GO
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('待定','待定',11)
GO

insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('行政类','行政类')
GO
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('管理类','管理类')
GO
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('项目类','项目类')
GO
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('审计类','审计类')
GO
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('财务会计类','财务会计类')
GO
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('秘书类','秘书类')
GO
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('人事类','人事类')
GO
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('法律类','法律类')
GO
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('总裁','总裁')
GO
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('支持类','支持类')
GO
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('待定','待定')
GO