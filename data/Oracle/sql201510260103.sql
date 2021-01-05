CREATE TABLE FnaBudgetInfoOperFlag(
	id integer PRIMARY KEY NOT NULL,
	organizationtype integer NULL,
	budgetorganizationid integer NULL,
	budgetperiods integer NULL
)
/
create sequence seq_FnaBudgetInfoOperFlag_ID minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 cache 20
/
create index idx_fbio_organizationtype on FnaBudgetInfoOperFlag(organizationtype)
/
create index idx_fbio_budgetorganizationid on FnaBudgetInfoOperFlag(budgetorganizationid)
/
create index idx_fbio_budgetperiods on FnaBudgetInfoOperFlag(budgetperiods)
/

create or replace trigger FnaBudgetInfoOperFlag_Trigger before insert on FnaBudgetInfoOperFlag for each row 
begin select seq_FnaBudgetInfoOperFlag_ID.nextval INTO :new.id from dual; end;