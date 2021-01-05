
/*更改体重字段为 decimal类型*/
UPDATE HrmCareerApply SET weight ='0' where weight =''
GO
ALTER TABLE HrmCareerApply
	Alter column weight decimal(38,2)

GO

/*FOR BUG 260,
	修改传入的参数 @height_14 和 @weight_15的类型为 Decimal(38,2)
*/
ALTER  PROCEDURE HrmCareerApply_InsertPer
( @id_1 int, 
  @birthday_2 char(10), 
  @folk_3 varchar(30), 
  @nativeplace_4 varchar(100), 
  @regresidentplace_5 varchar(60), 
  @maritalstatus_6 char(1), 
  @policy_7 varchar(30),
  @bememberdate_8 char(10), 
  @bepartydate_9 char(10), 
  @islabouunion_10 char(1),
  @educationlevel_11 int, 
  @degree_12 varchar(30), 
  @healthinfo_13  char(1), 
  @height_14 decimal(38,2),
  @weight_15 decimal(38,2), 
  @residentplace_16 varchar(60), 
  @tempresidentnumber_18 varchar(60), 
  @certificatenum_19 varchar(60),
  @flag int output, @msg varchar(60) output)
AS UPDATE HrmCareerApply SET 
  birthday = @birthday_2,
  folk = @folk_3,
  nativeplace = @nativeplace_4,
  regresidentplace = @regresidentplace_5,
  maritalstatus = @maritalstatus_6,
  policy = @policy_7,
  bememberdate = @bememberdate_8,
  bepartydate = @bepartydate_9,
  islabouunion = @islabouunion_10,
  educationlevel = @educationlevel_11,
  degree = @degree_12,
  healthinfo = @healthinfo_13,
  height = @height_14,
  weight = @weight_15,
  residentplace = @residentplace_16,
  tempresidentnumber = @tempresidentnumber_18,
  certificatenum = @certificatenum_19
WHERE
  id = @id_1

GO

