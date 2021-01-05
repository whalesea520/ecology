alter table HrmStatusHistory add
  status integer default(1)
/

create or replace procedure HrmSchedule_Select_ByDepID
(id_1 integer,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as 
begin
open thecursor for
select * from HrmSchedule 
where 
  relatedid = id_1
and
  scheduletype =1 ;
end;
/


create or replace procedure HrmResource_Extend 
(id_1 integer, 
 changedate_2 char, 
 changeenddate_3 char, 
 changereason_4 char, 
 changecontractid_5 integer, 
 infoman_6 varchar2, 
 oldjobtitleid_7 integer, 
 type_n_8 char,
 status_9 integer,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
begin
INSERT INTO HrmStatusHistory 
(resourceid, 
 changedate, 
 changeenddate, 
 changereason, 
 changecontractid, 
 infoman, 
 oldjobtitleid, 
 type_n,
 status) 
VALUES 
(id_1, 
 changedate_2, 
 changeenddate_3, 
 changereason_4, 
 changecontractid_5, 
 infoman_6, 
 oldjobtitleid_7 , 
 type_n_8,
 status_9) ;
UPDATE HrmResource SET enddate = changeenddate_3 WHERE id = id_1;
end;
/



create or replace procedure HrmResource_SelectAll 
 (	flag out integer  , 
  	msg  out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
	) 
AS
begin 
open thecursor for
select 
  id,
  loginid,  
  lastname,
  sex,
  resourcetype,
  email,
  locationid,
  workroom, 
  departmentid,
  costcenterid,
  jobtitle,
  managerid,
  assistantid ,
  seclevel,
  joblevel,
  status
from HrmResource  ;
end;
/



alter table workflow_form modify(document varchar2(200))
/

alter table workflow_form modify(  relateddocument varchar2(200) )
/

update workflow_formdict set fielddbtype='varchar2(200)', type =37 where fieldname = 'document' 
/

update workflow_formdict set fielddbtype='varchar2(200)', type =37 where fieldname = 'relateddocument' 
/

update workflow_bill set createpage='', managepage='',viewpage='' where id = 13
/


INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'relatedate',97,'char(10)',3,2,30,1)
/

INSERT INTO workflow_billfield ( billid, fieldname, fieldlabel, fielddbtype, fieldhtmltype, type, dsporder, viewtype) VALUES (7,'invoicenum',900,'varchar2(250)',1,1,38,1)
/


create or replace procedure Bill_ExpenseDetail_Insert 
(
	expenseid_1		integer,
	relatedate_1       char,
	feetypeid_1		integer,
	detailremark_1	    varchar2,
	accessory_1		integer,
	relatedcrm_1       integer,
	relatedproject_1   integer,
	feesum_1			number,
	realfeesum_1		number,
	invoicenum_1       varchar2,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
	insert into bill_expensedetail 
	(expenseid,relatedate,feetypeid,detailremark,accessory,relatedcrm,relatedproject,feesum,realfeesum,invoicenum)
	values
	(expenseid_1,relatedate_1,feetypeid_1,detailremark_1,accessory_1,relatedcrm_1,relatedproject_1,feesum_1,realfeesum_1,invoicenum_1);
end;
/

/*2003-05-20建立考核项目表*/
CREATE TABLE HrmCheckItem (
id integer NOT NULL ,
checkitemname varchar2(60) NULL,
checkitemexplain varchar2(200) NULL 
)
/
create sequence HrmCheckItem_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger HrmCheckItem_Trigger
before insert on HrmCheckItem
for each row
begin
select HrmCheckItem_id.nextval INTO :new.id from dual;
end;
/
ALTER TABLE HrmCheckItem  ADD 
	 PRIMARY KEY 
	(
		id
	)
/


/*2003-05-20建立考核项目的存储过程*/

create or replace PROCEDURE HrmCheckItem_Insert
	(checkitemname_2 varchar2,
	checkitemexplain_3 varchar2,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
 AS
 begin
 insert into HrmCheckItem (checkitemname, checkitemexplain) values (checkitemname_2,checkitemexplain_3);
end;
/

/*2003-05-20建立修改考核项目的存储过程*/

create or replace PROCEDURE HrmCheckItem_Update
(id_1 integer,
 checkitemname_2 varchar2,
 checkitemexplain_3 varchar2,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS 
begin
UPDATE HrmCheckItem set
checkitemname = checkitemname_2,
checkitemexplain = checkitemexplain_3
WHERE
 id = id_1;
end;
/


/*2003-05-20建立删除考核项目表的存储过程*/
create or replace PROCEDURE HrmCheckItem_Delete
(id_1 integer,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
begin
DELETE HrmCheckItem WHERE id = id_1;
end;
/

/*2003-05-20建立查看考核项目表的存储过程*/
create or replace PROCEDURE HrmCheckItem_SByid
(id_1 integer,
flag out integer  , 
msg  out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
AS
begin 
open thecursor for
SELECT * FROM HrmCheckItem WHERE id = id_1;
end;
/
