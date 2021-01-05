create table CRM_customercontacter_mind(id int PRIMARY KEY,customerid varchar(100), contacterid varchar(100) ,parentid varchar(100),direction varchar(10))
/

CREATE TABLE CRM_customercontacter_mind_log (
	id int PRIMARY KEY,
	customerid VARCHAR (100),
	contacterid VARCHAR (100),
	operate_usr VARCHAR (20),
	operate_date VARCHAR (50),
	operate_time VARCHAR (50),
	operate_type VARCHAR (10),
	operate_value VARCHAR (2000)
)
/


create sequence SEQ_customercontacter_mind
minvalue 1       
nomaxvalue       
start with 1      
increment by 1    
nocycle           
nocache
/
       
CREATE OR REPLACE TRIGGER tg_customercontacter_mind
BEFORE INSERT ON CRM_customercontacter_mind FOR EACH ROW WHEN (new.id is null)
begin
select SEQ_customercontacter_mind.nextval into:new.id from dual;
end;
/

CREATE OR REPLACE TRIGGER tg_customercontacter_mind_log
BEFORE INSERT ON CRM_customercontacter_mind_log FOR EACH ROW WHEN (new.id is null)
begin
select SEQ_customercontacter_mind.nextval into:new.id from dual;
end;
/
create index idx_crmcontacterMind_1 on crm_customercontacter_mind_log(customerid)
/