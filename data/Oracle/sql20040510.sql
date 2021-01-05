/*更改体重字段为 decimal类型*/
ALTER TABLE HrmCareerApply add weight_t decimal(38,2)
/
update HrmCareerApply set weight_t=weight
/
ALTER TABLE HrmCareerApply drop column weight
/
ALTER TABLE HrmCareerApply add weight decimal(38,2)
/
update HrmCareerApply set weight=weight_t
/
ALTER TABLE HrmCareerApply drop column weight_t
/
/*FOR BUG 260,
	修改传入的参数 height_14 和 weight_15的类型为 Decimal(38,2)
*/
CREATE OR REPLACE  PROCEDURE HrmCareerApply_InsertPer
( id_1 integer, 
  birthday_2 char, 
  folk_3 varchar2, 
  nativeplace_4 varchar2, 
  regresidentplace_5 varchar2, 
  maritalstatus_6 char, 
  policy_7 varchar2,
  bememberdate_8 char, 
  bepartydate_9 char, 
  islabouunion_10 char,
  educationlevel_11 integer, 
  degree_12 varchar2, 
  healthinfo_13  char, 
  height_14 decimal,
  weight_15 decimal, 
  residentplace_16 varchar2, 
  tempresidentnumber_18 varchar2, 
  certificatenum_19 varchar2,
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
UPDATE HrmCareerApply SET 
  birthday = birthday_2,
  folk = folk_3,
  nativeplace = nativeplace_4,
  regresidentplace = regresidentplace_5,
  maritalstatus = maritalstatus_6,
  policy = policy_7,
  bememberdate = bememberdate_8,
  bepartydate = bepartydate_9,
  islabouunion = islabouunion_10,
  educationlevel = educationlevel_11,
  degree = degree_12,
  healthinfo = healthinfo_13,
  height = height_14,
  weight = weight_15,
  residentplace = residentplace_16,
  tempresidentnumber = tempresidentnumber_18,
  certificatenum = certificatenum_19
WHERE
  id = id_1;
  end;

/

