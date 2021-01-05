CREATE TABLE ImageFileTempPic ( 
	id int  NOT NULL ,
	imagefileid integer NOT NULL,
	docid integer NULL,
	createid integer NULL,
	createdate char(10) NULL,
	createtime char(8) NULL
) 
/
create sequence ImageFileTempPic_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger ImageFileTempPic_id_trigger
before insert on ImageFileTempPic
for each row
begin
select ImageFileTempPic_id.nextval into :new.id from dual;
end;
/
create index temppic_imagefileid_idx on ImageFileTempPic(imagefileid)
/