/*td:1514 by zxf 在【我的下属】页面增加“计划”快捷链接*/
alter table HrmUserDefine add workplanable char(1) 
go
update HrmUserDefine set workplanable='1'
GO
alter PROCEDURE HrmUserDefine_Insert 
(@userid_1 		[int],
@hasresourceid_2 	[char](1),
@hasresourcename_3 	[char](1),
@hasjobtitle_4 	[char](1),
@hasactivitydesc_5 	[char](1),
@hasjobgroup_6 	[char](1), 
@hasjobactivity_7 	[char](1),
@hascostcenter_8 	[char](1),
@hascompetency_9 	[char](1),
@hasresourcetype_10 	[char](1),
@hasstatus_11 		[char](1),
@hassubcompany_12 	[char](1),
@hasdepartment_13 	[char](1),
@haslocation_14 	[char](1),
@hasmanager_15 	[char](1),
@hasassistant_16 	[char](1),
@hasroles_17 		[char](1),
@hasseclevel_18 	[char](1),
@hasjoblevel_19 	[char](1),
@hasworkroom_20 	[char](1),
@hastelephone_21 	[char](1),
@hasstartdate_22 	[char](1),
@hasenddate_23 	[char](1),
@hascontractdate_24 	[char](1),
@hasbirthday_25 	[char](1),
@hassex_26 		[char](1),
@projectable_27 	[char](1),
@crmable_28 		[char](1),
@itemable_29 		[char](1),
@docable_30 		[char](1),
@workflowable_31 	[char](1),
@subordinateable_32 	[char](1),
@trainable_33 		[char](1),
@budgetable_34 	[char](1),
@fnatranable_35 	[char](1),
@dspperpage_36 	[tinyint],
@hasage_37 		[char](1),
@hasworkcode_38 	[char](1),
@hasjobcall_39 	[char](1),
@hasmobile_40 		[char](1),
@hasmobilecall_41 	[char](1),
@hasfax_42 		[char](1),
@hasemail_43 		[char](1),
@hasfolk_44 		[char](1),
@hasregresidentplace_45[char](1),
@hasnativeplace_46 	[char](1),
@hascertificatenum_47 	[char](1),
@hasmaritalstatus_48 	[char](1),
@haspolicy_49 		[char](1),
@hasbememberdate_50 	[char](1),
@hasbepartydate_51 	[char](1),
@hasislabouunion_52 	[char](1),
@haseducationlevel_53 	[char](1),
@hasdegree_54 		[char](1),
@hashealthinfo_55 	[char](1),
@hasheight_56 		[char](1),
@hasweight_57 		[char](1),
@hasresidentplace_58 	[char](1),
@hashomeaddress_59 	[char](1),
@hastempresidentnumber_60 	[char](1),
@hasusekind_61 	[char](1),
@hasbankid1_62 	[char](1),
@hasaccountid1_63 	[char](1),
@hasaccumfundaccount_64 [char](1),
@hasloginid_65 	[char](1),
@hassystemlanguage_66 	[char](1),
@workplanable_67 [char](1),
@flag integer output,
@msg varchar(80) output )
AS 
DECLARE @recordercount integer 
Select @recordercount = count(userid) from HrmUserDefine where userid =convert(int, @userid_1) 
if @recordercount = 0 
begin 
INSERT INTO [HrmUserDefine] 
([userid], 
[hasresourceid],
[hasresourcename],
[hasjobtitle],
[hasactivitydesc],
[hasjobgroup],
[hasjobactivity],
[hascostcenter],
[hascompetency],
[hasresourcetype],
[hasstatus],
[hassubcompany],
[hasdepartment],
[haslocation],
[hasmanager],
[hasassistant],
[hasroles],
[hasseclevel],
[hasjoblevel],
[hasworkroom],
[hastelephone], 
[hasstartdate],
[hasenddate],
[hascontractdate], 
[hasbirthday], 
[hassex],
[projectable],
[crmable],
[itemable],
[docable],
[workflowable],
[subordinateable],
[trainable],
[budgetable],
[fnatranable],
[dspperpage],
[hasage],
[hasworkcode],
[hasjobcall],
[hasmobile],
[hasmobilecall],
[hasfax],
[hasemail], 
[hasfolk],
[hasregresidentplace],
[hasnativeplace],
[hascertificatenum],
[hasmaritalstatus],
[haspolicy],
[hasbememberdate],
[hasbepartydate],
[hasislabouunion],
[haseducationlevel],
[hasdegree],
[hashealthinfo],
[hasheight],
[hasweight],
[hasresidentplace],
[hashomeaddress],
[hastempresidentnumber],
[hasusekind],
[hasbankid1],
[hasaccountid1],
[hasaccumfundaccount],
[hasloginid],
[hassystemlanguage],
[workplanable]) 
VALUES 
(@userid_1, 
@hasresourceid_2,
@hasresourcename_3,
@hasjobtitle_4, 
@hasactivitydesc_5,
@hasjobgroup_6,
@hasjobactivity_7,
@hascostcenter_8,
@hascompetency_9,
@hasresourcetype_10,
@hasstatus_11,
@hassubcompany_12,
@hasdepartment_13, 
@haslocation_14,
@hasmanager_15, 
@hasassistant_16,
@hasroles_17,
@hasseclevel_18,
@hasjoblevel_19,
@hasworkroom_20, 
@hastelephone_21,
@hasstartdate_22,
@hasenddate_23,
@hascontractdate_24,
@hasbirthday_25,
@hassex_26,
@projectable_27,
@crmable_28, 
@itemable_29,
@docable_30,
@workflowable_31, 
@subordinateable_32,
@trainable_33, 
@budgetable_34,
@fnatranable_35,
@dspperpage_36,
@hasage_37,
@hasworkcode_38,
@hasjobcall_39,
@hasmobile_40,
@hasmobilecall_41,
@hasfax_42, 
@hasemail_43, 
@hasfolk_44, 
@hasregresidentplace_45,
@hasnativeplace_46, 
@hascertificatenum_47, 
@hasmaritalstatus_48, 
@haspolicy_49, 
@hasbememberdate_50,
@hasbepartydate_51,
@hasislabouunion_52, 
@haseducationlevel_53,
@hasdegree_54, 
@hashealthinfo_55,
@hasheight_56,
@hasweight_57, 
@hasresidentplace_58,
@hashomeaddress_59, 
@hastempresidentnumber_60,
@hasusekind_61, 
@hasbankid1_62,
@hasaccountid1_63,
@hasaccumfundaccount_64,
@hasloginid_65,
@hassystemlanguage_66,
@workplanable_67)
end else begin UPDATE [HrmUserDefine]  SET
[hasresourceid]	 = @hasresourceid_2, 
[hasresourcename]	 = @hasresourcename_3,
[hasjobtitle]		 = @hasjobtitle_4,
[hasactivitydesc]	 = @hasactivitydesc_5,
[hasjobgroup]		 = @hasjobgroup_6,
[hasjobactivity]	 = @hasjobactivity_7, 
[hascostcenter]	 = @hascostcenter_8,
[hascompetency]	 = @hascompetency_9, 
[hasresourcetype]	 = @hasresourcetype_10, 
[hasstatus]		 = @hasstatus_11, 
[hassubcompany]	 = @hassubcompany_12, 
[hasdepartment]	 = @hasdepartment_13,
[haslocation]	 = @haslocation_14,
[hasmanager]	 = @hasmanager_15,
[hasassistant]	 = @hasassistant_16,
[hasroles]	 = @hasroles_17, 
[hasseclevel]	 = @hasseclevel_18,
[hasjoblevel]	 = @hasjoblevel_19,
[hasworkroom]	 = @hasworkroom_20,
[hastelephone]	 = @hastelephone_21,
[hasstartdate]	 = @hasstartdate_22,
[hasenddate]	 = @hasenddate_23,
[hascontractdate]	 = @hascontractdate_24,
[hasbirthday]	 = @hasbirthday_25,
[hassex]	 = @hassex_26, 
[projectable]	 = @projectable_27, 
[crmable]	 = @crmable_28, 
[itemable]	 = @itemable_29,
[docable]	 = @docable_30,
[workflowable]	 = @workflowable_31,
[subordinateable]	 = @subordinateable_32,
[trainable]	 = @trainable_33,
[budgetable]	 = @budgetable_34,
[fnatranable]	 = @fnatranable_35,
[dspperpage]	 = @dspperpage_36, 
[hasage]	 = @hasage_37, 
[hasworkcode]	 = @hasworkcode_38, 
[hasjobcall]	 = @hasjobcall_39,
[hasmobile]	 = @hasmobile_40, 
[hasmobilecall]	 = @hasmobilecall_41, 
[hasfax]	 = @hasfax_42,
[hasemail]	 = @hasemail_43,
[hasfolk]	 = @hasfolk_44,
[hasregresidentplace]	 = @hasregresidentplace_45, 
[hasnativeplace]	 = @hasnativeplace_46,
[hascertificatenum]	 = @hascertificatenum_47,
[hasmaritalstatus]	 = @hasmaritalstatus_48, 
[haspolicy]	 = @haspolicy_49, 
[hasbememberdate]	 = @hasbememberdate_50,
[hasbepartydate]	 = @hasbepartydate_51,
[hasislabouunion]	 = @hasislabouunion_52,
[haseducationlevel]	 = @haseducationlevel_53,
[hasdegree]	 = @hasdegree_54,
[hashealthinfo]	 = @hashealthinfo_55, 
[hasheight]	 = @hasheight_56, 
[hasweight]	 = @hasweight_57, 
[hasresidentplace]	 = @hasresidentplace_58, 
[hashomeaddress]	 = @hashomeaddress_59,
[hastempresidentnumber]	 = @hastempresidentnumber_60,
[hasusekind]	 = @hasusekind_61, 
[hasbankid1]	 = @hasbankid1_62,
[hasaccountid1]	 = @hasaccountid1_63, 
[hasaccumfundaccount]	 = @hasaccumfundaccount_64,
[hasloginid]	 = @hasloginid_65,
[hassystemlanguage]	 = @hassystemlanguage_66 ,
[workplanable]=@workplanable_67  WHERE ( [userid]	 = @userid_1) 
end 
if @@error<>0 
begin 
set @flag=1 
set @msg='插入储存过程失败' 
return 
end 
else 
begin 
set @flag=0 
set @msg='插入储存过程成功' 
return 
end
GO
/* td:1345 by hxh*/
DELETE FROM htmllabelindex WHERE id=17579
GO
DELETE FROM HtmlLabelInfo WHERE indexid=17579
GO
DELETE FROM htmllabelindex WHERE id=17580
GO
DELETE FROM HtmlLabelInfo WHERE indexid=17580
GO

INSERT INTO HtmlLabelIndex values(17579,'每页客户数') 
GO
INSERT INTO HtmlLabelInfo VALUES(17579,'每页客户数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17579,'Each page of Customer quantity',8) 
GO

INSERT INTO HtmlLabelIndex values(17580,'选择显示列') 
GO
INSERT INTO HtmlLabelInfo VALUES(17580,'选择显示列',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(17580,'select colunms',8) 
GO

/*修改CRM_Customize表结构，记录创建权限来源*/
ALTER TABLE CRM_Customize
ADD perpage int NULL
GO

DROP PROCEDURE CRM_Customize_Insert 
GO
CREATE PROCEDURE CRM_Customize_Insert 
(@userid_1 	int, @logintype 	tinyint, @row1col1_2 	int, @row1col2_3 	int, 
@row1col3_4 	int, @row1col4_5 	int, @row1col5_6 	int, @row1col6_7 	int, 
@row2col1_8 	int, @row2col2_9 	int, @row2col4_10 	int, @row2col3_11 	int, 
@row2col5_12 	int, @row2col6_13 	int, @row3col1_14 	int, @row3col2_15 	int, 
@row3col3_16 	int, @row3col4_17 	int, @row3col5_18 	int, @row3col6_19 	int, 
@perpage_1 	int, @flag	int	output, @msg	varchar(80)	output)  
AS 
INSERT INTO CRM_Customize 
( userid, logintype, row1col1, row1col2, row1col3, row1col4, 
row1col5, row1col6, row2col1, row2col2, row2col4, row2col3, 
row2col5, row2col6, row3col1, row3col2, row3col3, row3col4, 
row3col5, row3col6, perpage)  
VALUES 
( @userid_1, @logintype, @row1col1_2, @row1col2_3, @row1col3_4, @row1col4_5, @row1col5_6, 
@row1col6_7, @row2col1_8, @row2col2_9, @row2col4_10, @row2col3_11, @row2col5_12, @row2col6_13, 
@row3col1_14, @row3col2_15, @row3col3_16, @row3col4_17, @row3col5_18, @row3col6_19, @perpage_1)  
set @flag = 1 set @msg = 'OK!' 

GO

DROP PROCEDURE CRM_Customize_Update 
GO
CREATE PROCEDURE CRM_Customize_Update 
(@userid_1 	int, @logintype 	tinyint, @row1col1_2 	int, @row1col2_3 	int, 
@row1col3_4 	int, @row1col4_5 	int, @row1col5_6 	int, @row1col6_7 	int, 
@row2col1_8 	int, @row2col2_9 	int, @row2col4_10 	int, @row2col3_11 	int, 
@row2col5_12 	int, @row2col6_13 	int, @row3col1_14 	int, @row3col2_15 	int, 
@row3col3_16 	int, @row3col4_17 	int, @row3col5_18 	int, @row3col6_19 	int, 
@perpage_1 	int, @flag	int	output, @msg	varchar(80)	output)  
AS 
UPDATE CRM_Customize  
SET  row1col1	 = @row1col1_2, row1col2	 = @row1col2_3, row1col3	 = @row1col3_4, 
row1col4	 = @row1col4_5, row1col5	 = @row1col5_6, row1col6	 = @row1col6_7, 
row2col1	 = @row2col1_8, row2col2	 = @row2col2_9, row2col4	 = @row2col4_10, 
row2col3	 = @row2col3_11, row2col5	 = @row2col5_12, row2col6	 = @row2col6_13, 
row3col1	 = @row3col1_14, row3col2	 = @row3col2_15, row3col3	 = @row3col3_16, 
row3col4	 = @row3col4_17, row3col5	 = @row3col5_18, row3col6	 = @row3col6_19,  
perpage		 = @perpage_1 	
WHERE 
( userid	 = @userid_1 and logintype	 = @logintype)  set @flag = 1 set @msg = 'OK!' 

GO


