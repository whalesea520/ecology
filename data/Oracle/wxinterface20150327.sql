create table WX_SENDMSGLOG (
   id                   integer          null,
   senduserid			      integer					 null,
   receiveuserids		    varchar(4000)		 null,
   content				      varchar(4000)		 null,
   ifsend				        smallint				 null,
   errormsg				      varchar(4000)		 null,
   createtime			      varchar(20)      null
)
/
create sequence WX_SENDMSGLOG_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger WX_SENDMSGLOG_id_trigger
before insert on WX_SENDMSGLOG
for each row
begin
select WX_SENDMSGLOG_id.nextval into :new.id from dual;
end;
/
