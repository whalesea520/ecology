/*将 用工需求权限 加入到 人力资源维护组的默认权限 BUG 227 ,Created BY Huang Yu*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=374
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,374)
/
DELETE FROM SystemRightRoles WHERE RightID = 374 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (374,4,2)
/

/*将 招聘计划权限 加入到 人力资源维护组的默认权限 BUG 233,Created By Huang Yu*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=375
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,375)
/
DELETE FROM SystemRightRoles WHERE RightID = 375 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (375,4,2)
/

/*修改"其他消息"为"其它消息" BUG 230  Created BY Huang Yu*/
DELETE FROM HtmlLabelIndex WHERE ID = 1847
/
DELETE FROM HtmlLabelInfo WHERE IndexID = 1847
/
INSERT INTO HtmlLabelIndex values(1847,'其它要求') 
/
INSERT INTO HtmlLabelInfo VALUES(1847,'其它要求',7) 
/
INSERT INTO HtmlLabelInfo VALUES(1847,'Other Request',8) 
/

/*将该招聘计划页面的‘新建’菜单，修改为‘新建招聘信息 BUG 238  Created BY Huang Yu*/
INSERT INTO HtmlLabelIndex values(17153,'新建招聘信息') 
/
INSERT INTO HtmlLabelInfo VALUES(17153,'新建招聘信息',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17153,'New Invitation Info',8) 
/

Create Table HrmCareerPlanInform(
       ID integer not null primary key,
       CareerPlanID integer not null,
       ResourceID integer not null,	
       Type integer default 0 not null ,
       StepID integer not null
)
/
create sequence HrmCareerPlanInform_id
start with 1
increment by 1
nomaxvalue
nocycle
/                           


create or replace trigger HrmCareerPlanInform_Tri
before insert on HrmCareerPlanInform
for each row
begin
select HrmCareerPlanInform_id.nextval into :new.id from dual;
end;
/
/*FOR BUG 260,将salarynow,salaryneed字段的类型改为decimal*/

ALTER TABLE HrmCareerApplyOtherInfo add salarynow_t decimal(38,2)
/
update HrmCareerApplyOtherInfo set salarynow_t=salarynow
/
ALTER TABLE HrmCareerApplyOtherInfo drop column salarynow
/
ALTER TABLE HrmCareerApplyOtherInfo add salarynow decimal(38,2)
/
update HrmCareerApplyOtherInfo set salarynow=salarynow_t
/
ALTER TABLE HrmCareerApplyOtherInfo drop column salarynow_t
/

ALTER TABLE HrmCareerApplyOtherInfo add salaryneed_t decimal(38,2)
/
update HrmCareerApplyOtherInfo set salaryneed_t=salaryneed
/
ALTER TABLE HrmCareerApplyOtherInfo drop column salaryneed
/
ALTER TABLE HrmCareerApplyOtherInfo add salaryneed decimal(38,2)
/
update HrmCareerApplyOtherInfo set salaryneed=salaryneed_t
/
ALTER TABLE HrmCareerApplyOtherInfo drop column salaryneed_t
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
