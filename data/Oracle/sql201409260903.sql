create table CRM_CustomerTag (
   id                 int,
   customerid         int                  null,
   tag                varchar(100)         null,
   creater            int                  null,
   createdate         char(10)             null,
   createtime         char(8)              null
)
/
create sequence CRM_CustomerTag_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CRM_CustomerTag_id_tri
before insert on CRM_CustomerTag
for each row 
begin
select CRM_CustomerTag_id.nextval into :new.id from dual;
end;
/

create index CRM_CT_Index_1 on CRM_CustomerTag (
customerid ASC
)
/

ALTER table CRM_CustomerContacter add department VARCHAR(100)
/

create table CRM_Attention(
  id int ,
  resourceid int,
  customerid int
)
/
create sequence CRM_Attention_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CRM_Attention_id_tri
before insert on CRM_Attention
for each row 
begin
select CRM_Attention_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_label (
	id int NOT NULL,
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
create sequence CRM_label_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CRM_label_id_trigger
before insert on CRM_label
for each row  
begin
select CRM_label_id.nextval into :new.id from dual;
end;
/

CREATE TABLE CRM_customer_label (
	id int,
	userid int null,
	customerid int NULL ,
	labelid int NULL 
)
/
create sequence CRM_cus_label_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger CRM_cus_label_tri
before insert on CRM_customer_label 
for each row  
begin
select CRM_cus_label_id.nextval into :new.id from dual;
end;
/
