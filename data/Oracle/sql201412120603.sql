ALTER TABLE LDAPSET add needSynPassword char(1)
/
ALTER TABLE LDAPSET add keystorepath varchar(500)
/
ALTER TABLE LDAPSET add keystorepassword varchar(100)
/
ALTER TABLE LDAPSET add ldapserverurl2 varchar(500)
/
ALTER TABLE LDAPSET add needSynOrg char(1)
/
ALTER TABLE LDAPSET add needDismiss char(1)
/
ALTER TABLE LDAPSET add needCloseDep char(1)
/
ALTER TABLE LDAPSET add needSynPerson char(1)
/
ALTER TABLE LDAPSET add passwordpolicy varchar(500)
/
CREATE TABLE ldapsetdetail (
id INTEGER PRIMARY key not null,
subcompanycode varchar(100) NULL ,
subcomusertodepcode varchar(100) NULL ,
subcompanydomain varchar(500) NULL 
)
/
CREATE SEQUENCE ldapsetdetail_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger ldapsetdetail_Tri
  before insert on ldapsetdetail
  for each row
begin
  select ldapsetdetail_seq.nextval into :new.id from dual;
end;
/
CREATE TABLE addepmap (
id INTEGER PRIMARY key not null,
dep varchar(100) NULL ,
pguid varchar(200) NULL ,
distin varchar(200) NULL ,
subcomcode varchar(100) NULL ,
orgtype varchar(10) NULL ,
guid varchar(200) NULL 
)
/
CREATE SEQUENCE addepmap_seq
 START WITH     1
 INCREMENT BY   1
 NOCACHE
 NOMAXVALUE
/
create or replace trigger addepmap_Tri
  before insert on addepmap
  for each row
begin
  select addepmap_seq.nextval into :new.id from dual;
end;
/