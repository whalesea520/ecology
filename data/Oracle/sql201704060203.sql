CREATE TABLE prj_fielddata (
seqorder integer,
scope varchar2(50) NOT NULL ,
scopeid integer NOT NULL,
id integer NOT NULL 
)
/
create sequence prj_fielddata_seqorder
start with 1
increment by 1
nomaxvalue
nocycle
/
CREATE OR REPLACE TRIGGER prj_fielddata_Trigger before insert on prj_fielddata for each row
begin select prj_fielddata_seqorder.nextval into :new.seqorder from dual; end;
/