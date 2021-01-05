/* 开发者：王金永 功能：‘临时状态的员工升级位‘试用’状态的人力资源’*/
INSERT INTO HtmlLabelIndex values(17509,'被试用人') 
GO
INSERT INTO HtmlLabelIndex values(17511,'试用备注') 
GO
INSERT INTO HtmlLabelIndex values(17512,'试用通知人') 
GO
INSERT INTO HtmlLabelIndex values(17510,'试用日期') 
GO
INSERT INTO HtmlLabelIndex values(17513,'人员试用') 
GO
INSERT INTO HtmlLabelInfo VALUES(17509,'被试用人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17509,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17510,'试用日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17510,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17511,'试用备注',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17511,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17512,'试用通知人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17512,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17513,'人员试用',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17513,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17514,'员工试用通知') 
GO
INSERT INTO HtmlLabelInfo VALUES(17514,'员工试用通知',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17514,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17515,'文档下载日志') 
GO
INSERT INTO HtmlLabelInfo VALUES(17515,'文档下载日志',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17515,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17516,'下载人') 
GO
INSERT INTO HtmlLabelIndex values(17517,'文件名称') 
GO
INSERT INTO HtmlLabelIndex values(17519,'下载日期') 
GO
INSERT INTO HtmlLabelIndex values(17518,'所属文档') 
GO
INSERT INTO HtmlLabelInfo VALUES(17516,'下载人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17516,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17517,'文件名称',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17517,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17518,'所属文档',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17518,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17519,'下载日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17519,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17528,'客户级别批量修改') 
GO
INSERT INTO HtmlLabelInfo VALUES(17528,'客户级别批量修改',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17528,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17529,'级别批量修改') 
GO
INSERT INTO HtmlLabelInfo VALUES(17529,'级别批量修改',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17529,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17530,'升级') 
GO
INSERT INTO HtmlLabelIndex values(17531,'降级') 
GO
INSERT INTO HtmlLabelInfo VALUES(17530,'升级',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17530,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17531,'降级',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17531,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17534,'生日提醒') 
GO
INSERT INTO HtmlLabelInfo VALUES(17534,'生日提醒',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17534,'',8) 
GO

INSERT INTO HtmlLabelIndex values(17535,'培训参与') 
GO
INSERT INTO HtmlLabelInfo VALUES(17535,'培训参与',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17535,'',8) 
GO


INSERT INTO HtmlLabelIndex values(17537,'时间工资汇总') 
GO
INSERT INTO HtmlLabelIndex values(17538,'人员工资汇总') 
GO
INSERT INTO HtmlLabelIndex values(17536,'工资报表') 
GO
INSERT INTO HtmlLabelInfo VALUES(17536,'工资报表',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17536,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17537,'时间工资汇总',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17537,'',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(17538,'人员工资汇总',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17538,'',8) 
GO


CREATE PROCEDURE HrmResource_Try
(@id_1 int,
 @changedate_2 char(10),
 @changereason_3 char(10),
 @infoman_5 varchar(255),
 @oldjobtitleid_7 int,
 @type_n_8 char(1),  
 @flag int output, @msg varchar(60) output)
AS INSERT INTO HrmStatusHistory
(resourceid,
 changedate,
 changereason,
 infoman,
 oldjobtitleid,
 type_n  )
VALUES
(@id_1, 
 @changedate_2,
 @changereason_3,
 @infoman_5,
 @oldjobtitleid_7 ,
 @type_n_8   )

GO


/*增加下载日志*/
CREATE TABLE DownloadLog (
	userid int NOT NULL ,
    username varchar (20) ,
	downloadtime char (19) ,
    imageid int ,
    imagename varchar(100) ,
    docid int ,
    docname varchar(200)
) 
GO

/*增加身份证号码*/
alter table CRM_CustomerContacter add IDCard varchar(20);
GO

alter PROCEDURE CRM_CustomerContacter_Update 
 (@id_1 	int, 
 @title_3 	int,
 @fullname_4 	varchar(50),
 @lastname_5 	varchar(50),
 @firstname_6 	varchar(50), 
 @jobtitle_7 	varchar(100), 
 @email_8 	varchar(150), 
 @phoneoffice_9 	varchar(20),
 @phonehome_10 	varchar(20), 
 @mobilephone_11 	varchar(20),
 @fax_12 	varchar(20), 
 @language_13 	int, 
 @manager_14 	int, 
 @main_15 	tinyint, 
 @picid_16 	int, 
 @interest_1	varchar(100),
 @hobby_1	varchar(100),
 @managerstr_1	varchar(100),
 @subordinate_1	varchar(100),
 @strongsuit_1	varchar(100),
 @age_1		int, 
 @birthday_1	varchar(100),
 @home_1	varchar(100),
 @school_1	varchar(100),
 @speciality_1	varchar(100),
 @nativeplace_1	varchar(100),
 @experience_1	varchar(200),
 @datefield1_17 	varchar(10),
 @datefield2_18 	varchar(10),
 @datefield3_19 	varchar(10), 
 @datefield4_20 	varchar(10),
 @datefield5_21 	varchar(10), 
 @numberfield1_22 	float, 
 @numberfield2_23 	float,
 @numberfield3_24 	float, 
 @numberfield4_25 	float, 
 @numberfield5_26 	float,
 @textfield1_27 	varchar(100), 
 @textfield2_28 	varchar(100), 
 @textfield3_29 	varchar(100), 
 @textfield4_30 	varchar(100),
 @textfield5_31 	varchar(100), 
 @tinyintfield1_32 	tinyint, 
 @tinyintfield2_33 	tinyint,
 @tinyintfield3_34 	tinyint,
 @tinyintfield4_35 	tinyint, 
 @tinyintfield5_36 	tinyint, 
 @IDCard_37 	varchar(20), 
 @flag	int	output, 
 @msg	varchar(80)	output)  
 AS UPDATE CRM_CustomerContacter  
 SET	 title	 = @title_3, 
 fullname	 = @fullname_4, 
 lastname	 = @lastname_5, 
 firstname	 = @firstname_6,
 jobtitle	 = @jobtitle_7,
 email	 = @email_8, 
 phoneoffice	 = @phoneoffice_9, 
 phonehome	 = @phonehome_10,
 mobilephone	 = @mobilephone_11,
 fax	 = @fax_12, 
 language	 = @language_13, 
 manager	 = @manager_14,
 main	 = @main_15, picid	 = @picid_16,
 datefield1	 = @datefield1_17, 
 datefield2	 = @datefield2_18, 
 datefield3	 = @datefield3_19,
 datefield4	 = @datefield4_20,
 datefield5	 = @datefield5_21, 
 numberfield1	 = @numberfield1_22,
 numberfield2	 = @numberfield2_23,
 numberfield3	 = @numberfield3_24,
 numberfield4	 = @numberfield4_25,
 numberfield5	 = @numberfield5_26,
 textfield1	 = @textfield1_27, 
 textfield2	 = @textfield2_28, 
 textfield3	 = @textfield3_29,
 textfield4	 = @textfield4_30,
 textfield5	 = @textfield5_31,
 tinyintfield1	 = @tinyintfield1_32, 
 tinyintfield2	 = @tinyintfield2_33,
 tinyintfield3	 = @tinyintfield3_34, 
 tinyintfield4	 = @tinyintfield4_35, 
 tinyintfield5	 = @tinyintfield5_36, 
 IDCard          = @IDCard_37,
 interest	 = @interest_1,
 hobby	 = @hobby_1,
 managerstr	 = @managerstr_1,
 subordinate	 = @subordinate_1,
 strongsuit	 = @strongsuit_1,
 age	 = @age_1,
 birthday	 = @birthday_1,
 home	 = @home_1,
 school	 = @school_1,
 speciality	 = @speciality_1,
 nativeplace	 = @nativeplace_1,
 experience	 = @experience_1
WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 

GO


alter PROCEDURE CRM_CustomerContacter_Insert 
 (@customerid_1 	int,
 @title_2 	int,
 @fullname_3 	varchar(50), 
 @lastname_4 	varchar(50),
 @firstname_5 	varchar(50),
 @jobtitle_6 	varchar(100),
 @email_7 	varchar(150), 
 @phoneoffice_8 	varchar(20),
 @phonehome_9 	varchar(20), 
 @mobilephone_10 	varchar(20), 
 @fax_11 	varchar(20),
 @language_12 	int,
 @manager_13 	int, 
 @main_14 	tinyint, 
 @picid_15 	int,
 @interest_1	varchar(100),
 @hobby_1	varchar(100),
 @managerstr_1	varchar(100),
 @subordinate_1	varchar(100),
 @strongsuit_1	varchar(100),
 @age_1		int, 
 @birthday_1	varchar(100),
 @home_1	varchar(100),
 @school_1	varchar(100),
 @speciality_1	varchar(100),
 @nativeplace_1	varchar(100),
 @experience_1	varchar(200),
 @datefield1_16 	varchar(10),
 @datefield2_17 	varchar(10),
 @datefield3_18 	varchar(10),
 @datefield4_19 	varchar(10), 
 @datefield5_20 	varchar(10), 
 @numberfield1_21 	float, 
 @numberfield2_22 	float, 
 @numberfield3_23 	float, 
 @numberfield4_24 	float, 
 @numberfield5_25 	float,
 @textfield1_26 	varchar(100),
 @textfield2_27 	varchar(100),
 @textfield3_28 	varchar(100),
 @textfield4_29 	varchar(100), 
 @textfield5_30 	varchar(100),
 @tinyintfield1_31 	tinyint, 
 @tinyintfield2_32 	tinyint,
 @tinyintfield3_33 	tinyint, 
 @tinyintfield4_34 	tinyint,
 @tinyintfield5_35 	tinyint,
 @IDCard_36 	varchar(20),
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS INSERT INTO CRM_CustomerContacter
 ( customerid, title, fullname, lastname, firstname, jobtitle, email, phoneoffice, phonehome, mobilephone, fax, language, manager, main, picid, datefield1, datefield2, datefield3, datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, textfield1, textfield2, textfield3, textfield4, textfield5, tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5 ,interest ,hobby ,managerstr,subordinate,strongsuit,age,birthday,home,school,speciality,nativeplace,experience,IDCard) 
 VALUES 
 ( @customerid_1, @title_2, @fullname_3, @lastname_4, @firstname_5, @jobtitle_6, @email_7, @phoneoffice_8, @phonehome_9, @mobilephone_10, @fax_11, @language_12, @manager_13, @main_14, @picid_15, @datefield1_16, @datefield2_17, @datefield3_18, @datefield4_19, @datefield5_20, @numberfield1_21, @numberfield2_22, @numberfield3_23, @numberfield4_24, @numberfield5_25, @textfield1_26, @textfield2_27, @textfield3_28, @textfield4_29, @textfield5_30, @tinyintfield1_31, @tinyintfield2_32, @tinyintfield3_33, @tinyintfield4_34, @tinyintfield5_35, @interest_1 , @hobby_1 , @managerstr_1, @subordinate_1 , @strongsuit_1 , @age_1 , @birthday_1 , @home_1 , @school_1 , @speciality_1 , @nativeplace_1 , @experience_1, @IDCard_36 )  set @flag = 1 set @msg = 'OK!' 

GO


/*生日提醒*/

alter table CRM_CustomerContacter add isbirthdaynotify char(1), birthdaynotifydays char(10)
GO

alter PROCEDURE CRM_CustomerContacter_Update 
 (@id_1 	int, 
 @title_3 	int,
 @fullname_4 	varchar(50),
 @lastname_5 	varchar(50),
 @firstname_6 	varchar(50), 
 @jobtitle_7 	varchar(100), 
 @email_8 	varchar(150), 
 @phoneoffice_9 	varchar(20),
 @phonehome_10 	varchar(20), 
 @mobilephone_11 	varchar(20),
 @fax_12 	varchar(20), 
 @language_13 	int, 
 @manager_14 	int, 
 @main_15 	tinyint, 
 @picid_16 	int, 
 @interest_1	varchar(100),
 @hobby_1	varchar(100),
 @managerstr_1	varchar(100),
 @subordinate_1	varchar(100),
 @strongsuit_1	varchar(100),
 @age_1		int, 
 @birthday_1	varchar(100),
 @home_1	varchar(100),
 @school_1	varchar(100),
 @speciality_1	varchar(100),
 @nativeplace_1	varchar(100),
 @experience_1	varchar(200),
 @datefield1_17 	varchar(10),
 @datefield2_18 	varchar(10),
 @datefield3_19 	varchar(10), 
 @datefield4_20 	varchar(10),
 @datefield5_21 	varchar(10), 
 @numberfield1_22 	float, 
 @numberfield2_23 	float,
 @numberfield3_24 	float, 
 @numberfield4_25 	float, 
 @numberfield5_26 	float,
 @textfield1_27 	varchar(100), 
 @textfield2_28 	varchar(100), 
 @textfield3_29 	varchar(100), 
 @textfield4_30 	varchar(100),
 @textfield5_31 	varchar(100), 
 @tinyintfield1_32 	tinyint, 
 @tinyintfield2_33 	tinyint,
 @tinyintfield3_34 	tinyint,
 @tinyintfield4_35 	tinyint, 
 @tinyintfield5_36 	tinyint, 
 @IDCard_37 	varchar(20), 
 @isbirthdaynotify_38   char(1),
 @birthdaynotifydays_39 char(10),
 @flag	int	output, 
 @msg	varchar(80)	output)  
 AS UPDATE CRM_CustomerContacter  
 SET	 title	 = @title_3, 
 fullname	 = @fullname_4, 
 lastname	 = @lastname_5, 
 firstname	 = @firstname_6,
 jobtitle	 = @jobtitle_7,
 email	 = @email_8, 
 phoneoffice	 = @phoneoffice_9, 
 phonehome	 = @phonehome_10,
 mobilephone	 = @mobilephone_11,
 fax	 = @fax_12, 
 language	 = @language_13, 
 manager	 = @manager_14,
 main	 = @main_15, picid	 = @picid_16,
 datefield1	 = @datefield1_17, 
 datefield2	 = @datefield2_18, 
 datefield3	 = @datefield3_19,
 datefield4	 = @datefield4_20,
 datefield5	 = @datefield5_21, 
 numberfield1	 = @numberfield1_22,
 numberfield2	 = @numberfield2_23,
 numberfield3	 = @numberfield3_24,
 numberfield4	 = @numberfield4_25,
 numberfield5	 = @numberfield5_26,
 textfield1	 = @textfield1_27, 
 textfield2	 = @textfield2_28, 
 textfield3	 = @textfield3_29,
 textfield4	 = @textfield4_30,
 textfield5	 = @textfield5_31,
 tinyintfield1	 = @tinyintfield1_32, 
 tinyintfield2	 = @tinyintfield2_33,
 tinyintfield3	 = @tinyintfield3_34, 
 tinyintfield4	 = @tinyintfield4_35, 
 tinyintfield5	 = @tinyintfield5_36, 
 IDCard          = @IDCard_37,
 isbirthdaynotify   =@isbirthdaynotify_38,
 birthdaynotifydays =@birthdaynotifydays_39,
 interest	 = @interest_1,
 hobby	 = @hobby_1,
 managerstr	 = @managerstr_1,
 subordinate	 = @subordinate_1,
 strongsuit	 = @strongsuit_1,
 age	 = @age_1,
 birthday	 = @birthday_1,
 home	 = @home_1,
 school	 = @school_1,
 speciality	 = @speciality_1,
 nativeplace	 = @nativeplace_1,
 experience	 = @experience_1
WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 

GO


alter PROCEDURE CRM_CustomerContacter_Insert 
 (@customerid_1 	int,
 @title_2 	int,
 @fullname_3 	varchar(50), 
 @lastname_4 	varchar(50),
 @firstname_5 	varchar(50),
 @jobtitle_6 	varchar(100),
 @email_7 	varchar(150), 
 @phoneoffice_8 	varchar(20),
 @phonehome_9 	varchar(20), 
 @mobilephone_10 	varchar(20), 
 @fax_11 	varchar(20),
 @language_12 	int,
 @manager_13 	int, 
 @main_14 	tinyint, 
 @picid_15 	int,
 @interest_1	varchar(100),
 @hobby_1	varchar(100),
 @managerstr_1	varchar(100),
 @subordinate_1	varchar(100),
 @strongsuit_1	varchar(100),
 @age_1		int, 
 @birthday_1	varchar(100),
 @home_1	varchar(100),
 @school_1	varchar(100),
 @speciality_1	varchar(100),
 @nativeplace_1	varchar(100),
 @experience_1	varchar(200),
 @datefield1_16 	varchar(10),
 @datefield2_17 	varchar(10),
 @datefield3_18 	varchar(10),
 @datefield4_19 	varchar(10), 
 @datefield5_20 	varchar(10), 
 @numberfield1_21 	float, 
 @numberfield2_22 	float, 
 @numberfield3_23 	float, 
 @numberfield4_24 	float, 
 @numberfield5_25 	float,
 @textfield1_26 	varchar(100),
 @textfield2_27 	varchar(100),
 @textfield3_28 	varchar(100),
 @textfield4_29 	varchar(100), 
 @textfield5_30 	varchar(100),
 @tinyintfield1_31 	tinyint, 
 @tinyintfield2_32 	tinyint,
 @tinyintfield3_33 	tinyint, 
 @tinyintfield4_34 	tinyint,
 @tinyintfield5_35 	tinyint,
 @IDCard_36 	varchar(20),
 @isbirthdaynotify_37   char(1),
 @birthdaynotifydays_38 char(10),
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS INSERT INTO CRM_CustomerContacter
 ( customerid, title, fullname, lastname, firstname, jobtitle, email, phoneoffice, phonehome, mobilephone, fax, language, manager, main, picid, datefield1, datefield2, datefield3, datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, textfield1, textfield2, textfield3, textfield4, textfield5, tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5 ,interest ,hobby ,managerstr,subordinate,strongsuit,age,birthday,home,school,speciality,nativeplace,experience,IDCard,isbirthdaynotify,birthdaynotifydays) 
 VALUES 
 ( @customerid_1, @title_2, @fullname_3, @lastname_4, @firstname_5, @jobtitle_6, @email_7, @phoneoffice_8, @phonehome_9, @mobilephone_10, @fax_11, @language_12, @manager_13, @main_14, @picid_15, @datefield1_16, @datefield2_17, @datefield3_18, @datefield4_19, @datefield5_20, @numberfield1_21, @numberfield2_22, @numberfield3_23, @numberfield4_24, @numberfield5_25, @textfield1_26, @textfield2_27, @textfield3_28, @textfield4_29, @textfield5_30, @tinyintfield1_31, @tinyintfield2_32, @tinyintfield3_33, @tinyintfield4_34, @tinyintfield5_35, @interest_1 , @hobby_1 , @managerstr_1, @subordinate_1 , @strongsuit_1 , @age_1 , @birthday_1 , @home_1 , @school_1 , @speciality_1 , @nativeplace_1 , @experience_1, @IDCard_36, @isbirthdaynotify_37, @birthdaynotifydays_38 )  set @flag = 1 set @msg = 'OK!' 

GO


/*添加“客户级别直接批量审批的权限”，注意，必须在系统设置中把这个权限付给相关的角色*/
insert into SystemRights (id,rightdesc,righttype) values (444,'客户级别直接批量审批','0') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (444,7,'客户级别直接批量审批','客户级别直接批量审批') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (444,8,'Customer Approve','Customer Approve') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3135,'客户级别直接批量审批','MutiApproveCustomerNoRequest',444) 
GO

/*td:1040 创建与编辑客户联系人信息，生日提醒日期必须小于生日日期才能保存*/
INSERT INTO HtmlLabelIndex values(17548,'提前') 
GO
INSERT INTO HtmlLabelInfo VALUES(17548,'提前',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17548,'before',8) 
GO

/*生日提醒*/

alter table CRM_CustomerContacter drop column birthdaynotifydays 
GO

alter table CRM_CustomerContacter add birthdaynotifydays int
GO

alter PROCEDURE CRM_CustomerContacter_Update 
 (@id_1 	int, 
 @title_3 	int,
 @fullname_4 	varchar(50),
 @lastname_5 	varchar(50),
 @firstname_6 	varchar(50), 
 @jobtitle_7 	varchar(100), 
 @email_8 	varchar(150), 
 @phoneoffice_9 	varchar(20),
 @phonehome_10 	varchar(20), 
 @mobilephone_11 	varchar(20),
 @fax_12 	varchar(20), 
 @language_13 	int, 
 @manager_14 	int, 
 @main_15 	tinyint, 
 @picid_16 	int, 
 @interest_1	varchar(100),
 @hobby_1	varchar(100),
 @managerstr_1	varchar(100),
 @subordinate_1	varchar(100),
 @strongsuit_1	varchar(100),
 @age_1		int, 
 @birthday_1	varchar(100),
 @home_1	varchar(100),
 @school_1	varchar(100),
 @speciality_1	varchar(100),
 @nativeplace_1	varchar(100),
 @experience_1	varchar(200),
 @datefield1_17 	varchar(10),
 @datefield2_18 	varchar(10),
 @datefield3_19 	varchar(10), 
 @datefield4_20 	varchar(10),
 @datefield5_21 	varchar(10), 
 @numberfield1_22 	float, 
 @numberfield2_23 	float,
 @numberfield3_24 	float, 
 @numberfield4_25 	float, 
 @numberfield5_26 	float,
 @textfield1_27 	varchar(100), 
 @textfield2_28 	varchar(100), 
 @textfield3_29 	varchar(100), 
 @textfield4_30 	varchar(100),
 @textfield5_31 	varchar(100), 
 @tinyintfield1_32 	tinyint, 
 @tinyintfield2_33 	tinyint,
 @tinyintfield3_34 	tinyint,
 @tinyintfield4_35 	tinyint, 
 @tinyintfield5_36 	tinyint, 
 @IDCard_37 	varchar(20), 
 @isbirthdaynotify_38   char(1),
 @birthdaynotifydays_39 int,
 @flag	int	output, 
 @msg	varchar(80)	output)  
 AS UPDATE CRM_CustomerContacter  
 SET	 title	 = @title_3, 
 fullname	 = @fullname_4, 
 lastname	 = @lastname_5, 
 firstname	 = @firstname_6,
 jobtitle	 = @jobtitle_7,
 email	 = @email_8, 
 phoneoffice	 = @phoneoffice_9, 
 phonehome	 = @phonehome_10,
 mobilephone	 = @mobilephone_11,
 fax	 = @fax_12, 
 language	 = @language_13, 
 manager	 = @manager_14,
 main	 = @main_15, picid	 = @picid_16,
 datefield1	 = @datefield1_17, 
 datefield2	 = @datefield2_18, 
 datefield3	 = @datefield3_19,
 datefield4	 = @datefield4_20,
 datefield5	 = @datefield5_21, 
 numberfield1	 = @numberfield1_22,
 numberfield2	 = @numberfield2_23,
 numberfield3	 = @numberfield3_24,
 numberfield4	 = @numberfield4_25,
 numberfield5	 = @numberfield5_26,
 textfield1	 = @textfield1_27, 
 textfield2	 = @textfield2_28, 
 textfield3	 = @textfield3_29,
 textfield4	 = @textfield4_30,
 textfield5	 = @textfield5_31,
 tinyintfield1	 = @tinyintfield1_32, 
 tinyintfield2	 = @tinyintfield2_33,
 tinyintfield3	 = @tinyintfield3_34, 
 tinyintfield4	 = @tinyintfield4_35, 
 tinyintfield5	 = @tinyintfield5_36, 
 IDCard          = @IDCard_37,
 isbirthdaynotify   =@isbirthdaynotify_38,
 birthdaynotifydays =@birthdaynotifydays_39,
 interest	 = @interest_1,
 hobby	 = @hobby_1,
 managerstr	 = @managerstr_1,
 subordinate	 = @subordinate_1,
 strongsuit	 = @strongsuit_1,
 age	 = @age_1,
 birthday	 = @birthday_1,
 home	 = @home_1,
 school	 = @school_1,
 speciality	 = @speciality_1,
 nativeplace	 = @nativeplace_1,
 experience	 = @experience_1
WHERE ( id	 = @id_1)  set @flag = 1 set @msg = 'OK!' 

GO


alter PROCEDURE CRM_CustomerContacter_Insert 
 (@customerid_1 	int,
 @title_2 	int,
 @fullname_3 	varchar(50), 
 @lastname_4 	varchar(50),
 @firstname_5 	varchar(50),
 @jobtitle_6 	varchar(100),
 @email_7 	varchar(150), 
 @phoneoffice_8 	varchar(20),
 @phonehome_9 	varchar(20), 
 @mobilephone_10 	varchar(20), 
 @fax_11 	varchar(20),
 @language_12 	int,
 @manager_13 	int, 
 @main_14 	tinyint, 
 @picid_15 	int,
 @interest_1	varchar(100),
 @hobby_1	varchar(100),
 @managerstr_1	varchar(100),
 @subordinate_1	varchar(100),
 @strongsuit_1	varchar(100),
 @age_1		int, 
 @birthday_1	varchar(100),
 @home_1	varchar(100),
 @school_1	varchar(100),
 @speciality_1	varchar(100),
 @nativeplace_1	varchar(100),
 @experience_1	varchar(200),
 @datefield1_16 	varchar(10),
 @datefield2_17 	varchar(10),
 @datefield3_18 	varchar(10),
 @datefield4_19 	varchar(10), 
 @datefield5_20 	varchar(10), 
 @numberfield1_21 	float, 
 @numberfield2_22 	float, 
 @numberfield3_23 	float, 
 @numberfield4_24 	float, 
 @numberfield5_25 	float,
 @textfield1_26 	varchar(100),
 @textfield2_27 	varchar(100),
 @textfield3_28 	varchar(100),
 @textfield4_29 	varchar(100), 
 @textfield5_30 	varchar(100),
 @tinyintfield1_31 	tinyint, 
 @tinyintfield2_32 	tinyint,
 @tinyintfield3_33 	tinyint, 
 @tinyintfield4_34 	tinyint,
 @tinyintfield5_35 	tinyint,
 @IDCard_36 	varchar(20),
 @isbirthdaynotify_37   char(1),
 @birthdaynotifydays_38 int,
 @flag	int	output,
 @msg	varchar(80)	output) 
 AS INSERT INTO CRM_CustomerContacter
 ( customerid, title, fullname, lastname, firstname, jobtitle, email, phoneoffice, phonehome, mobilephone, fax, language, manager, main, picid, datefield1, datefield2, datefield3, datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, textfield1, textfield2, textfield3, textfield4, textfield5, tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5 ,interest ,hobby ,managerstr,subordinate,strongsuit,age,birthday,home,school,speciality,nativeplace,experience,IDCard,isbirthdaynotify,birthdaynotifydays) 
 VALUES 
 ( @customerid_1, @title_2, @fullname_3, @lastname_4, @firstname_5, @jobtitle_6, @email_7, @phoneoffice_8, @phonehome_9, @mobilephone_10, @fax_11, @language_12, @manager_13, @main_14, @picid_15, @datefield1_16, @datefield2_17, @datefield3_18, @datefield4_19, @datefield5_20, @numberfield1_21, @numberfield2_22, @numberfield3_23, @numberfield4_24, @numberfield5_25, @textfield1_26, @textfield2_27, @textfield3_28, @textfield4_29, @textfield5_30, @tinyintfield1_31, @tinyintfield2_32, @tinyintfield3_33, @tinyintfield4_34, @tinyintfield5_35, @interest_1 , @hobby_1 , @managerstr_1, @subordinate_1 , @strongsuit_1 , @age_1 , @birthday_1 , @home_1 , @school_1 , @speciality_1 , @nativeplace_1 , @experience_1, @IDCard_36, @isbirthdaynotify_37, @birthdaynotifydays_38 )  set @flag = 1 set @msg = 'OK!' 

GO

/*td：1065 将客户卡片页面的【null】修改为【客户编码】*/
INSERT INTO HtmlLabelIndex values(17080,'客户编码') 
GO
INSERT INTO HtmlLabelInfo VALUES(17080,'客户编码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17080,'CustomerCode',8) 
GO