DROP TABLE WorkPlanType
/

CREATE TABLE WorkPlanType
(
   workPlanTypeID         integer    PRIMARY KEY NOT NULL,
   workPlanTypeName       varchar2(200)         NULL,
   workPlanTypeAttribute  integer                  NULL,
   workPlanTypeColor      char(7)              NULL,
   available              char(1)              NULL,
   displayOrder           integer                  NULL
)
/

create sequence  WorkPlanType_workPTID                                     
		start with 1
		increment by 1
		nomaxvalue
		nocycle 
/
create or replace trigger WorkPlanType_trigger		
	before insert on WorkPlanType
	for each row
	begin
	select WorkPlanType_workPTID.nextval into :new.workPlanTypeID from dual;
	end ;
/


