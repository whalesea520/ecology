create table CRM_Evaluation_LevelDetail(
	id  integer primary key not null,
	customerID varchar2(20) NOT NULL,
	evaluationID varchar2(20) NOT NULL,
	levelID varchar2(20) NOT NULL
)
/
create sequence Evaluation_LevelDetail_id
        start with 1
        increment by 1
        nomaxvalue
        nocycle
/
create or replace trigger Et_LevelDetail_id_Trigger
        before insert on CRM_Evaluation_LevelDetail
	for each row
	begin
	  select Evaluation_LevelDetail_id.nextval into :new.id from dual;
	end; 
/