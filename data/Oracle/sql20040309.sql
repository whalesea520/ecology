alter table workflow_formfield add isdetail char(1)
/

CREATE TABLE workflow_formdictdetail (
	id integer ,
	fieldname varchar2 (40) ,
	fielddbtype varchar2 (40) ,
	fieldhtmltype char (1) ,
	type integer 
)
/

insert into SequenceIndex(indexdesc,currentid) values('workflowformdictid',0)
/

create or replace procedure tem_exemycom
as

temint1 integer;
temint2 integer;
begin
select max(id) into temint1 from workflow_formdict;
select max(fieldid) into temint2 from workflow_formfield;
IF (temint1>temint2) then
	UPDATE SequenceIndex
	SET currentid=temint1+1
	WHERE indexdesc = 'workflowformdictid';
ELSE
	UPDATE SequenceIndex
	SET currentid=temint2+1
	WHERE indexdesc = 'workflowformdictid';
end if;
end;
/
call tem_exemycom()
/
drop procedure tem_exemycom
/


create or replace PROCEDURE SequenceIndex_SWFformdictid
(flag out integer , 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)  
AS 
begin
update SequenceIndex set currentid = currentid+1 where indexdesc='workflowformdictid';
open thecursor for 
select currentid from SequenceIndex where indexdesc='workflowformdictid';
end;
/


CREATE TABLE workflow_formdetailinfo (
	formid integer  ,
	rowcalstr varchar2(300) ,
	colcalstr varchar2(200) ,
    maincalstr varchar2(200) 
)
/

CREATE TABLE workflow_formdetail (
	id integer NOT NULL ,
	requestid integer
)
/
create sequence workflow_formdetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger workflow_formdetail_Trigger
before insert on workflow_formdetail
for each row
begin
select workflow_formdetail_id.nextval into :new.id from dual;
end;
/

create or replace PROCEDURE workflow_FieldID_Select 
(formid_1		integer, 
flag out integer , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
begin
open thecursor for 
select fieldid,fieldorder from workflow_formfield where formid=formid_1 
and (isdetail<>'1' or isdetail is null) order by fieldid;
end;
/


drop trigger WORKFLOW_FORMDICT_TRIGGER
/
