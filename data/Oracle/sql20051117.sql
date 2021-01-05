alter table CRM_SellChance add departmentId integer
/
alter table CRM_SellChance add subCompanyId integer
/

CREATE or REPLACE PROCEDURE CRM_SellChance_Update
(
	creater_1 integer ,
	subject_1 varchar2 ,
	customerid_1 integer ,
	comefromid_1 integer ,
	sellstatusid_1 integer ,
	endtatusid_1 char ,
	predate_1 char ,
	preyield_1 number ,
	currencyid_1 integer ,
	probability_1 number ,
	content_1 varchar2 ,
	id_1 integer,
	sufactor_1 integer,
	defactor_1 integer,
	departmentId_1 integer,
	subCompanyId_1 integer,
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
update CRM_SellChance set

	creater = creater_1,
	subject = subject_1,
	customerid =customerid_1,
	comefromid =comefromid_1,
	sellstatusid=sellstatusid_1 ,
	endtatusid =endtatusid_1,
	predate=predate_1 ,
	preyield =preyield_1,
	currencyid =currencyid_1,
	probability =probability_1,
	content= content_1,
	sufactor = sufactor_1,
	defactor = defactor_1,
	departmentId = departmentId_1,
	subCompanyId = subCompanyId_1
WHERE id=id_1;
end;
/

CREATE or REPLACE PROCEDURE CRM_SellChance_insert
(
	creater_1 integer ,
	subject_1 varchar2 ,
	customerid_1 integer ,
	comefromid_1 integer ,
	sellstatusid_1 integer ,
	endtatusid_1 char ,
	predate_1 char ,
	preyield_1 number ,
	currencyid_1 integer ,
	probability_1 number ,
	createdate_1 char ,
	createtime_1 char,
	content_1 varchar2 ,
	sufactor_1 integer,
	defactor_1 integer,
	departmentId_1 integer,
	subCompanyId_1 integer,
	flag out integer  , 
  	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
insert INTO CRM_SellChance
(
	creater ,
	subject ,
	customerid ,
	comefromid ,
	sellstatusid ,
	endtatusid ,
	predate ,
	preyield ,
	currencyid ,
	probability ,
	createdate ,
	createtime ,
	content,
	sufactor,
	defactor,
	departmentId,
	subCompanyId)
	values
	(
	creater_1  ,
	subject_1  ,
	customerid_1  ,
	comefromid_1  ,
	sellstatusid_1  ,
	endtatusid_1  ,
	predate_1  ,
	preyield_1  ,
	currencyid_1  ,
	probability_1 ,
	createdate_1  ,
	createtime_1  ,
	content_1 ,
	sufactor_1,
	defactor_1,
	departmentId_1,
	subCompanyId_1);
end;
/

CREATE or REPLACE Procedure Init_CRM_SellChance
as
	creater_1 integer;
	departmentId_1 integer;
	subCompanyId_1 integer;
begin
	FOR all_cursor in(
	select t1.creater,t2.departmentid,t2.subcompanyid1 from CRM_SellChance t1 left join HrmResource t2 on t1.creater=t2.id)
	loop 
		creater_1 := all_cursor.creater;
		departmentId_1 := all_cursor.departmentid;
		subCompanyId_1 := all_cursor.subcompanyid1;
		update CRM_SellChance set departmentId=departmentId_1,subCompanyId=subCompanyId_1 where creater = creater_1;
	end loop;	
end;
/
call Init_CRM_SellChance()
/