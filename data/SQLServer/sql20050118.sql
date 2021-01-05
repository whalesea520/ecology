alter table Prj_ProjectInfo alter column description varchar(4000)
go
ALTER  PROCEDURE Prj_ProjectInfo_Insert (
@name_1 	varchar(50),
@description_2 	varchar(4000),
@prjtype_3 	int,
@worktype_4 	int, 
@securelevel_5 	int, 
@status_6 	int, 
@isblock_7 	tinyint,
@managerview_8 	tinyint, 
@parentview_9 	tinyint,
@budgetmoney_10 	varchar(50), 
@moneyindeed_11 	varchar(50), 
@budgetincome_12 	varchar(50),
@imcomeindeed_13 	varchar(50), 
@planbegindate_14 	varchar(10), 
@planbegintime_15 	varchar(5),
@planenddate_16 	varchar(10),
@planendtime_17 	varchar(5),
@truebegindate_18 	varchar(10),
@truebegintime_19 	varchar(5), 
@trueenddate_20 	varchar(10), 
@trueendtime_21 	varchar(5), 
@planmanhour_22 	int, 
@truemanhour_23 	int, 
@picid_24 	int, 
@intro_25 	varchar(255),
@parentid_26 	int,
@envaluedoc_27 	int, 
@confirmdoc_28 	int, 
@proposedoc_29 	int, 
@manager_30 	int, 
@department_31 	int, 
@subcompanyid1 	int, 
@creater_32 	int, 
@createdate_33 	varchar(10),
@createtime_34 	varchar(8), 
@isprocessed_35 	tinyint,
@processer_36 	int, 
@processdate_37 	varchar(10),
@processtime_38 	varchar(8), 
@datefield1_39 	varchar(10), 
@datefield2_40 	varchar(10), 
@datefield3_41 	varchar(10), 
@datefield4_42 	varchar(10), 
@datefield5_43 	varchar(10), 
@numberfield1_44 	float, 
@numberfield2_45 	float,
@numberfield3_46 	float, 
@numberfield4_47 	float, 
@numberfield5_48 	float, 
@textfield1_49 	varchar(100),
@textfield2_50 	varchar(100), 
@textfield3_51 	varchar(100),
@textfield4_52 	varchar(100), 
@textfield5_53 	varchar(100), 
@boolfield1_54 	tinyint, 
@boolfield2_55 	tinyint, 
@boolfield3_56 	tinyint, 
@boolfield4_57 	tinyint, 
@boolfield5_58 	tinyint,
@flag	int	output, 
@msg	varchar(80)	output)  


AS INSERT INTO Prj_ProjectInfo ( name, description, prjtype, worktype, securelevel, status, isblock, managerview, parentview, budgetmoney, moneyindeed, budgetincome, imcomeindeed, planbegindate, planbegintime, planenddate, planendtime, truebegindate, truebegintime, trueenddate, trueendtime, planmanhour, truemanhour, picid, intro, parentid, envaluedoc, confirmdoc, proposedoc, manager, department, subcompanyid1, creater, createdate, createtime, isprocessed, processer, processdate, processtime, datefield1, datefield2, datefield3, datefield4, datefield5, numberfield1, numberfield2, numberfield3, numberfield4, numberfield5, textfield1, textfield2, textfield3, textfield4, textfield5, tinyintfield1, tinyintfield2, tinyintfield3, tinyintfield4, tinyintfield5)  VALUES ( @name_1, @description_2, @prjtype_3, @worktype_4, @securelevel_5, @status_6, @isblock_7, @managerview_8, @parentview_9, convert(money,@budgetmoney_10), convert(money,@moneyindeed_11), convert(money,@budgetincome_12), convert(money,@imcomeindeed_13), @planbegindate_14, @planbegintime_15, @planenddate_16, @planendtime_17, @truebegindate_18, @truebegintime_19, @trueenddate_20, @trueendtime_21, @planmanhour_22, @truemanhour_23, @picid_24, @intro_25, @parentid_26, @envaluedoc_27, @confirmdoc_28, @proposedoc_29, @manager_30, @department_31, @subcompanyid1, @creater_32, @createdate_33, @createtime_34, @isprocessed_35, @processer_36, @processdate_37, @processtime_38, @datefield1_39, @datefield2_40, @datefield3_41, @datefield4_42, @datefield5_43, @numberfield1_44, @numberfield2_45, @numberfield3_46, @numberfield4_47, @numberfield5_48, @textfield1_49, @textfield2_50, @textfield3_51, @textfield4_52, @textfield5_53, @boolfield1_54, @boolfield2_55, @boolfield3_56, @boolfield4_57, @boolfield5_58) 

GO


ALTER   PROCEDURE Prj_ProjectInfo_Update (@id_1 	int, @name_2 	varchar(50), @description_3 	varchar(4000), @prjtype_4 	int, @worktype_5 	int, @securelevel_6 	int, @status_7 	int, @isblock_8 	tinyint, @managerview_9 	tinyint, @parentview_10 	tinyint, @budgetmoney_11 	varchar(50), @moneyindeed_12 	varchar(50), @budgetincome_13 	varchar(50), @imcomeindeed_14 	varchar(50), @planbegindate_15 	varchar(10), @planbegintime_16 	varchar(5), @planenddate_17 	varchar(10), @planendtime_18 	varchar(5), @truebegindate_19 	varchar(10), @truebegintime_20 	varchar(5), @trueenddate_21 	varchar(10), @trueendtime_22 	varchar(5), @planmanhour_23 	int, @truemanhour_24 	int, @picid_25 	int, @intro_26 	varchar(255), @parentid_27 	int, @envaluedoc_28 	int, @confirmdoc_29 	int, @proposedoc_30 	int, @manager_31 	int, @department_32 	int, @subcompanyid1 	int, @datefield1_40 	varchar(10), @datefield2_41 	varchar(10), @datefield3_42 	varchar(10), @datefield4_43 	varchar(10), @datefield5_44 	varchar(10), @numberfield1_45 	float, @numberfield2_46 	float, @numberfield3_47 	float, @numberfield4_48 	float, @numberfield5_49 	float, @textfield1_50 	varchar(100), @textfield2_51 	varchar(100), @textfield3_52 	varchar(100), @textfield4_53 	varchar(100), @textfield5_54 	varchar(100), @boolfield1_55 	tinyint, @boolfield2_56 	tinyint, @boolfield3_57 	tinyint, @boolfield4_58 	tinyint, @boolfield5_59 	tinyint, @flag	int	output, @msg	varchar(80)	output)  AS UPDATE Prj_ProjectInfo  SET  name	 = @name_2, description	 = @description_3, prjtype	 = @prjtype_4, worktype	 = @worktype_5, securelevel	 = @securelevel_6, status	 = @status_7, isblock	 = @isblock_8, managerview	 = @managerview_9, parentview	 = @parentview_10, budgetmoney	 = convert(money,@budgetmoney_11), moneyindeed	 = convert(money,@moneyindeed_12), budgetincome	 = convert(money,@budgetincome_13), imcomeindeed	 = convert(money,@imcomeindeed_14), planbegindate	 = @planbegindate_15, planbegintime	 = @planbegintime_16, planenddate	 = @planenddate_17, planendtime	 = @planendtime_18, truebegindate	 = @truebegindate_19, truebegintime	 = @truebegintime_20, trueenddate	 = @trueenddate_21, trueendtime	 = @trueendtime_22, planmanhour	 = @planmanhour_23, truemanhour	 = @truemanhour_24, picid	 = @picid_25, intro	 = @intro_26, parentid	 = @parentid_27, envaluedoc	 = @envaluedoc_28, confirmdoc	 = @confirmdoc_29, proposedoc	 = @proposedoc_30, manager	 = @manager_31, department	 = @department_32, subcompanyid1 = @subcompanyid1, datefield1	 = @datefield1_40, datefield2	 = @datefield2_41, datefield3	 = @datefield3_42, datefield4	 = @datefield4_43, datefield5	 = @datefield5_44, numberfield1	 = @numberfield1_45, numberfield2	 = @numberfield2_46, numberfield3	 = @numberfield3_47, numberfield4	 = @numberfield4_48, numberfield5	 = @numberfield5_49, textfield1	 = @textfield1_50, textfield2	 = @textfield2_51, textfield3	 = @textfield3_52, textfield4	 = @textfield4_53, textfield5	 = @textfield5_54, tinyintfield1	 = @boolfield1_55, tinyintfield2	 = @boolfield2_56, tinyintfield3	 = @boolfield3_57, tinyintfield4	 = @boolfield4_58, tinyintfield5	 = @boolfield5_59  WHERE ( id	 = @id_1) 

GO