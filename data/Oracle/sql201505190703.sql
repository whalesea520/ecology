CREATE TABLE FnabudgetfeetypeRuleSet(
  	id integer PRIMARY KEY NOT NULL,
  	mainid integer NOT NULL,
  	type integer NOT NULL,
	orgid integer NOT NULL
)
/

create sequence seq_FnabudgetfeetypeRuleSet_ID minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/

create index idx_frs_mainid on FnabudgetfeetypeRuleSet (mainid)
/

create index idx_frs_type on FnabudgetfeetypeRuleSet (type)
/

create index idx_frs_orgid on FnabudgetfeetypeRuleSet (orgid)
/

create or replace trigger FnaFeetypeRuleSet_Trigger
before insert 
on FnabudgetfeetypeRuleSet
for each row 
begin 
	select seq_FnabudgetfeetypeRuleSet_id.nextval into :new.id from dual; 
end;
/

