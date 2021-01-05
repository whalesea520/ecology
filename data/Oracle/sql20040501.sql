/*For Bug 256*/

INSERT INTO HtmlLabelIndex values(17370,'曾任职务') 
/
INSERT INTO HtmlLabelInfo VALUES(17370,'曾任职务',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17370,'the former position',8) 
/


/*CREATED BY Huang Yu On May 11th,2004 , 应聘 基本信息更新*/
 CREATE or replace  procedure HrmCareerApply_UpdateBasic
(id_1 integer,
 lastname_2 varchar2,
 sex_3 char,
 jobtitle_4 integer,
 homepage_5 varchar2,
 email_6 varchar2,
 homeaddress_7 varchar2,
 homepostcode_8 varchar2,
 homephone_9 varchar2,
 inviteid_10 integer,
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
as 
begin
Update HrmCareerApply Set
lastname = lastname_2,
sex = sex_3,
jobtitle = jobtitle_4,
homepage = homepage_5,
email = email_6,
homeaddress = homeaddress_7 ,
homepostcode = homepostcode_8,
homephone = homephone_9,
careerinviteid = inviteid_10
WHERE id = id_1;
end;
/
/*CREATED BY Huang Yu On May 11th,2004 , 应聘其它信息更新*/

CREATE or replace  PROCEDURE HrmCareerApplyOtherInfo_Upd
	(applyid_2 	integer,
	 category_3 	char,
	 contactor_4 	varchar2,
	 salarynow_5 	varchar2,
	 worktime_6 	varchar2,
	 salaryneed_7 	varchar2,
	 currencyid_8 	integer,
	 reason_9 	varchar2,
	 otherrequest_10 	varchar2,
	 selfcomment_11 	Varchar2,
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
UPDATE HrmCareerApplyOtherInfo SET
	 category =category_3,
	 contactor=contactor_4,
	 salarynow=salarynow_5,
	 worktime=worktime_6,
	 salaryneed=salaryneed_7,
	 currencyid=currencyid_8,
	 reason=reason_9,
	 otherrequest=otherrequest_10,
	 selfcomment= selfcomment_11
WHERE applyid = applyid_2;
 end;

/

/*For Bug 266*/
CREATE or replace  PROCEDURE HrmInterviewResult_Insert
	(resourceid_1 	integer,
	 stepid_2 	integer,
	 result_3 	integer,
	 remark_4 	varchar2,
	 userid_5 	integer,
	 testdate_6 	char,
 flag out integer,
 msg out varchar2, 
 thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO HrmInterviewResult 
	 (resourceid,
	 stepid,
	 result,
	 remark,
	 tester,
	 testdate)
VALUES 
	(resourceid_1,
	 stepid_2,
	 result_3,
	 remark_4,
	 userid_5,
	 testdate_6);

update HrmInterview set 
  status = 1 WHERE ResourceID=resourceid_1 and StepID = stepid_2;
 end;
/

/*FOR BUG 256,更改字段height的类型为decimal  
  Oracle 中不能直接修改字段类型，除非该字段数据全为empty
*/

ALTER TABLE HrmCareerApply add height_t decimal(38,2)
/
update HrmCareerApply set height_t=height
/
ALTER TABLE HrmCareerApply drop column height
/
ALTER TABLE HrmCareerApply add height decimal(38,2)
/
update HrmCareerApply set height=height_t
/
ALTER TABLE HrmCareerApply drop column height_t
/