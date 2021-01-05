CREATE TABLE DocSecCategoryCusSearch (
	id integer  NOT NULL,
	secCategoryId integer NULL,
	docPropertyId integer NULL,
	viewindex integer NULL,
	visible integer NULL,
	DocSecCategoryTemplateId integer NULL
)
/

create sequence  DocSecCategoryCusSearch_id                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger DocSecCCusS_trigger		
	before insert on DocSecCategoryCusSearch
	for each row
	begin
	select DocSecCategoryCusSearch_id.nextval into :new.id from dual;
	end ;
/


ALTER TABLE DocSecCategory ADD
	useCustomSearch integer NULL
/


ALTER TABLE DocSecCategoryTemplate ADD
	useCustomSearch integer NULL
/
