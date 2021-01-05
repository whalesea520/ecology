
/*以下是陈英杰《Ecology－产品开发人力资源银行提交测试报告 》的脚本*/
 
 CREATE OR REPLACE PROCEDURE HrmBank_Insert 
          ( bankname_1	varchar2, 
            bankdesc_2	varchar2, 
            flag out integer,
            msg out varchar2,
            thecursor IN OUT cursor_define.weavercursor
             )
  AS 
  begin
  INSERT INTO hrmbank(bankname, bankdesc) values(bankname_1, bankdesc_2);
  open thecursor for
  select max(id) from hrmbank ; 
  end;
/

  
CREATE OR REPLACE PROCEDURE HrmBank_Update 
  (id_1	integer, 
  bankname_1 varchar2, 
  bankdesc_1 varchar2,
  flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor)  
  AS 
  begin
  update HrmBank set 
  bankname = bankname_1,
  bankdesc = bankdesc_1
  where  id = id_1 ;  
  end;
/

/* 以下是刘煜《 Ecology产品开发 资产性能改进 提交测试报告.doc 》的脚本*/

CREATE or REPLACE PROCEDURE CptAssortmentShareInfo_Insert 
(relateditemid_1 integer,
sharetype_2 smallint,
seclevel_3 smallint,
rolelevel_4 smallint,
sharelevel_5 smallint,
userid_6 integer,
departmentid_7 integer,
roleid_8 integer,
foralluser_9 smallint,
sharefrom_10 integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
INSERT INTO CptCapitalShareInfo
(relateditemid,
sharetype,
seclevel,
rolelevel,
sharelevel,
userid,
departmentid,
roleid,
foralluser,
sharefrom)
VALUES
(relateditemid_1,
sharetype_2,
seclevel_3,
rolelevel_4,
sharelevel_5,
userid_6,
departmentid_7,
roleid_8,
foralluser_9,
sharefrom_10);
end;
/




/*以下是陈英杰的Ecology－产品开发应聘人员录用修改提交测试报告的脚本*/

CREATE OR REPLACE procedure HrmCareerApplyHire
(resourceid_1 	integer, 
 flag out integer,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor
             )

as 
begin
delete HrmCareerApply 
where
 id = resourceid_1;

delete HrmInterview
where 
 resourceid = resourceid_1;

delete HrmInterviewAssess
where
 resourceid = resourceid_1;

delete HrmInterviewResult
where
 resourceid = resourceid_1;

delete HrmCareerApplyOtherInfo
where 
  applyid = resourceid_1;
end;
/


/*以下是陈英杰提交的《Ecology－产品开发人力资源自定义字段编辑提交测试报告》的脚本*/
create or replace procedure HrmResourceDefine_Update
 (id_1 integer,
  datefield1_2 varchar2,
  numberfield1_3 float,
  textfield1_4 varchar2,
  smallintfield1_5 smallint,
  datefield2_6 varchar2,
  numberfield2_7 float,
  textfield2_8 varchar2,
  smallintfield2_9 smallint,
  datefield3_10 varchar2,
  numberfield3_11 float,
  textfield3_12 varchar2,
  smallintfield3_13 smallint,
  datefield4_14 varchar2,
  numberfield4_15 float,
  textfield4_16 varchar2,
  smallintfield4_17 smallint,
  datefield5_18 varchar2,
  numberfield5_19 float,
  textfield5_20 varchar2,
  smallintfield5_21 smallint,
  flag out integer,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor)
 as 
 begin
 update HrmResource 
 set
  datefield1 = datefield1_2,
  numberfield1 = numberfield1_3,
  textfield1 = textfield1_4,
  tinyintfield1 = smallintfield1_5,
  datefield2 = datefield2_6,
  numberfield2 = numberfield2_7,
  textfield2 = textfield2_8,
  tinyintfield2 = smallintfield2_9,
  datefield3 = datefield3_10,
  numberfield3 = numberfield3_11,
  textfield3 = textfield3_12,
  tinyintfield3 = smallintfield3_13,
  datefield4 = datefield4_14,
  numberfield4 = numberfield4_15,
  textfield4 = textfield4_16,
  tinyintfield4 = smallintfield4_17,
  datefield5 = datefield5_18,
  numberfield5 = numberfield5_19,
  textfield5 = textfield5_20,
  tinyintfield5 = smallintfield5_21
 where
  (id = id_1);
 end;
/
 

/*以下是杨国生的提交测试报告《ecology产品开发职务的职务类型归属不正确提交测试报》的脚本*/

drop table HrmJobActivities
/

drop sequence HrmJobActivities_id
/

drop table HrmJobGroups
/


drop sequence HrmJobGroups_id
/

CREATE TABLE HrmJobGroups (
	id int  NOT NULL ,
	jobgroupname varchar2(200)  NULL ,
	jobgroupremark varchar2(4000)  NULL 
)
/

create sequence HrmJobGroups_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger HrmJobGroups_Trigger
before insert on HrmJobGroups
for each row
begin
select HrmJobGroups_id.nextval into :new.id from dual;
end;
/


CREATE TABLE HrmJobActivities (
	id int  NOT NULL ,
	jobactivitymark varchar2(60) NULL ,
	jobactivityname varchar2(200) NULL ,
	jobgroupid integer NULL ,
	joblevelfrom integer NULL ,
	joblevelto integer NULL 
) 
/

create sequence HrmJobActivities_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger HrmJobActivities_Trigger
before insert on HrmJobActivities
for each row
begin
select HrmJobActivities_id.nextval into :new.id from dual;
end;
/

insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('行政管理','行政管理',1)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('行政事务','行政事务',1)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('公司营运','公司营运',2)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('投资管理','投资管理',3)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('法律事务','法律事务',8)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('国际业务','国际业务',3)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('投资业务','投资业务',3)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('人事管理','人事管理',7)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('项目管理','项目管理',3)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('财务管理','财务管理',5)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('审计事务','审计事务',4)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('秘书','秘书',6)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('助理','助理',6)
/
insert into HrmJobActivities (jobactivitymark,jobactivityname,jobgroupid) values ('待定','待定',11)
/

insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('行政类','行政类')
/
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('管理类','管理类')
/
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('项目类','项目类')
/
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('审计类','审计类')
/
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('财务会计类','财务会计类')
/
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('秘书类','秘书类')
/
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('人事类','人事类')
/
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('法律类','法律类')
/
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('总裁','总裁')
/
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('支持类','支持类')
/
insert into HrmJobGroups (jobgroupname,jobgroupremark) values ('待定','待定')
/

update workflow_browserurl set 
browserurl = '/systeminfo/BrowserMain.jsp?url=/fna/maintenance/BudgetfeeTypeBrowser.jsp?sqlwhere=where feetype=to_char(1)' where tablename = 'FnaBudgetfeeType' 
/


/*以下是刘煜《Ecology产品开发- Oracle脚本BUG修改V1.0提交测试报告2003-07-25》的脚本*/
CREATE OR replace trigger DocDetailLog_Trigger
before INSERT ON DocDetailLog
for each row
begin
SELECT DocDetailLog_id.nextval INTO:new.id from DocDetailLog;
end;
/