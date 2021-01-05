create table CRM_SellchanceAtt(
  id int,
  resourceid int,
  sellchanceid int
)
/
create sequence CRM_SellchanceAtt_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CRM_SellchanceAtt_id_trigger
before insert on CRM_SellchanceAtt
for each row 
begin
select CRM_SellchanceAtt_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_SellchanceLabel (
	id int NOT NULL ,
	userid int NULL ,
	name varchar(200) NULL ,
	labelColor  varchar(200) NULL ,
	createdate varchar(50) NULL ,
	createtime varchar(50) NULL ,
	isUsed int NULL ,
	labelOrder int NULL ,
	labelType varchar(100) NULL ,
	textColor varchar(20) NULL 
)
/
create sequence CRM_SellchanceLabel_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CRM_SellchanceLabel_id_trigger
before insert on CRM_SellchanceLabel
for each row 
begin
select CRM_SellchanceLabel_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_Sellchance_label (
	id int NOT NULL  ,
	userid int null,
	sellchanceid int NULL ,
	labelid int NULL 
)
/
create sequence CRM_Sellchance_label_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CRM_Sellchance_label_id_tri
before insert on CRM_Sellchance_label
for each row 
begin
select CRM_Sellchance_label_id.nextval into :new.id from dual;
end;
/