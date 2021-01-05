alter table HrmSubCompany add supsubcomid integer default 0
/
alter table HrmSubCompany add   url varchar2(50) 
/
alter table HrmSubCompany add   showorder integer
/
update HrmSubCompany set supsubcomid=0
/

CREATE TABLE HrmGroup(
	id integer NOT NULL ,
	name char(10)  ,
	type integer ,
	owner integer
)
/
create sequence HrmGroup_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmGroup_Tri
before insert on HrmGroup
for each row
begin
select HrmGroup_id.nextval into :new.id from dual;
end;
/

CREATE TABLE HrmGroupMembers (
	groupid integer NOT NULL ,
	userid integer NOT NULL ,
	usertype char(1)) 
/

CREATE TABLE HrmGroupShare (
	id integer NOT NULL ,
	groupid integer  ,
	sharetype integer  ,
	seclevel integer ,
	rolelevel integer ,
	sharelevel integer  ,
	userid integer ,
	subcompanyid integer  ,
	departmentid integer ,
	roleid integer  ,
	foralluser integer  ,
	crmid integer) 
/
create sequence HrmGroupShare_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmGroupShare_Tri
before insert on HrmGroupShare
for each row
begin
select HrmGroupShare_id.nextval into :new.id from dual;
end;
/


ALTER TABLE HrmGroup ADD 
	CONSTRAINT PK_HrmGroup PRIMARY KEY 
    (
	id
	)
/

ALTER TABLE HrmGroupMembers ADD 
    CONSTRAINT PK_HrmGroupMembers PRIMARY KEY 
	(
		groupid,
		userid
	)
/

INSERT INTO HtmlLabelIndex values(17617,'组') 
/
INSERT INTO HtmlLabelInfo VALUES(17617,'自定义组',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17617,'custom group',8) 
/

insert into SystemRights (id,rightdesc,righttype) values (462,'hrm自定义组维护','3')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc)
values (462,7,'hrm自定义组维护','hrm自定义组维护')
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc)
values (462,8,'','')
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid)
values (3154,'hrm自定义组编辑','CustomGroup:Edit',462)
/
insert into SystemRightToGroup (groupid,rightid) values (3,462)
/
insert into SystemRightRoles (rightid,roleid,rolelevel) values (462,4,'2')
/
INSERT INTO HtmlLabelIndex values(17618,'私人组')
/
INSERT INTO HtmlLabelInfo VALUES(17618,'私人组',7)
/
INSERT INTO HtmlLabelInfo VALUES(17618,'private group',8)
/
INSERT INTO HtmlLabelIndex values(17619,'公共组') 
/
INSERT INTO HtmlLabelInfo VALUES(17619,'公共组',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17619,'public group',8) 
/
INSERT INTO HtmlLabelIndex values(17620,'所有组') 
/
INSERT INTO HtmlLabelInfo VALUES(17620,'所有组',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17620,'all group',8) 
/

CREATE OR REPLACE PROCEDURE HrmSubCompany_Insert 
(subcompanyname_1 	varchar2,
subcompanydesc_2 	varchar2,
companyid_3 	smallint,
supsubcomid_4 integer,
url_5 varchar2,
showorder_6 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
count0 integer;
count1 integer;
begin 
select count(*) into count0 from HrmSubCompany where subcompanyname=subcompanyname_1 ;
select count(*) into count1 from HrmSubCompany where subcompanydesc=subcompanydesc_2 ;
if count0>0 then
   flag:=2;
   msg:='该分部简称已经存在，不能保存！' ;
   return;
end if; 
if count1>0 then
   flag:=3;
   msg:='该分部全称已经存在，不能保存！' ;
   return;
end if;
INSERT INTO HrmSubCompany ( subcompanyname, subcompanydesc, companyid,supsubcomid,url,showorder) VALUES ( subcompanyname_1, subcompanydesc_2, companyid_3,supsubcomid_4,url_5,showorder_6); 
open thecursor for select (max(id)) from HrmSubCompany ; 
end;
/

CREATE OR REPLACE PROCEDURE HrmSubCompany_Update 
(id_1 	integer,
subcompanyname_2 	varchar2,
subcompanydesc_3 	varchar2,
companyid_4 	smallint,
supsubcomid_5 integer,
url_6 varchar2,
showorder_7 integer, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
AS 
count0 integer;
count1 integer;
begin 
select count(*) into count0 from HrmSubCompany where subcompanyname=subcompanyname_2 and id!=id_1;
select count(*) into count1 from HrmSubCompany where subcompanydesc=subcompanydesc_3 and id!=id_1;
if count0>0 then
   flag:=2;
   msg:='该分部简称已经存在，不能保存！' ;
   return;
end if; 
if count1>0 then
   flag:=3;
   msg:='该分部全称已经存在，不能保存！' ;
   return;
end if; 
UPDATE HrmSubCompany SET subcompanyname	 = subcompanyname_2, subcompanydesc	 = subcompanydesc_3, companyid	 = companyid_4,supsubcomid=supsubcomid_5,url=url_6, showorder=showorder_7 WHERE ( id = id_1) ; 
end;
/