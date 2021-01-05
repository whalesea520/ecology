CREATE TABLE fullSearch_FaqDetail
(
  id integer  NOT NULL primary key,
  faqLabel varchar2(1000) NULL,
  faqDesc varchar2(1000) NULL,
  faqlastmoddate char(10) NULL,
  faqlastmodtime char(8) NULL,
  faqAnswer clob NULL,
  faqStatus integer  NOT NULL,
  faqcreateDate char(10) NOT NULL,
  faqCreateTime char(8) NOT NULL,
  faqcreateId integer NOT NULL,
  faqlasteditId integer NULL
)
/

create sequence seq_fullSearch_FaqDetail
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger FaqDetail_tri
before insert on fullSearch_FaqDetail
for each row
begin
select seq_fullSearch_FaqDetail.nextval into :new.id from dual;
end ;
/