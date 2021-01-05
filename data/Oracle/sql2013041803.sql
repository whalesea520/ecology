create table GroupAndContact
(
	id int  primary key,
	groupId int not null,
	contactId int not null
)
/


create sequence GroupAndContact_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger trigge_GroupAndContact_Tri
before insert on GroupAndContact
for each row
begin
select GroupAndContact_id.nextval into :new.id from dual;
end
/



create table webmail_domain(
	DOMAIN_ID integer ,
	DOMAIN varchar2(100),
	POP_SERVER varchar2(100),
	SMTP_SERVER varchar2(100),
	IS_SMTP_AUTH varchar2(100),
	POP_PORT varchar2(100),
	SMTP_PORT varchar2(100),
	IS_SSL_AUTH varchar2(100),
	IS_POP varchar2(100)
)
/

CREATE TABLE email_label(
	id int  NOT NULL,
	accountid int NULL,
	name varchar2(100) NULL,
	color varchar2(100) NULL,
	createdate varchar2(100) NULL,
	createtime varchar2(100) NULL
) 
/


create sequence email_label_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger trigge_email_label_Tri
before insert on email_label
for each row
begin
select email_label_id.nextval into :new.id from dual;
end
/

create table email_label_detail(
	id int NOT NULL,
	labelid int ,
	mailid int
)
/

create sequence email_label_detail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger trigge_email_label_detail_Tri
before insert on email_label_detail
for each row
begin
select email_label_detail_id.nextval into :new.id from dual;
end
/

alter table MailResource add originalMailId int
/


alter table MailSign add isActive int
/

alter table mailsetting add defaulttype int 
/
update mailsetting set defaulttype = 1
/


create table emailGuide
(
	id int primary key not null, 
	userid int
)
/
create sequence emailGuide_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger trigge_emailGuide_Tri
before insert on emailGuide
for each row
begin
select emailGuide_id.nextval into :new.id from dual;
end
/

CREATE OR REPLACE PROCEDURE MailResource_Update(
                                                id_1             integer,
                                                resourceid_2     integer,
                                                priority_3       char,
                                                sendfrom_4       varchar2,
                                                sendcc_5         varchar2,
                                                sendbcc_6        varchar2,
                                                sendto_7         varchar2,
                                                senddate_8       varchar2,
                                                size_9           integer,
                                                subject_10       varchar2,
                                                content_11       clob,
                                                mailtype_12      char,
                                                hasHtmlImage_13  char,
                                                mailAccountId_14 integer,
                                                status_15        char,
                                                folderId_16      integer,
                                                flag             out integer,
                                                msg              out varchar2,
                                                thecursor        IN OUT cursor_define.weavercursor) AS
begin
 update MailResource
set resourceid=resourceid_2, priority=priority_3, sendfrom=sendfrom_4,
sendcc=sendcc_5, sendbcc=sendbcc_6, sendto=sendto_7,
senddate=senddate_8, size_n=size_9, subject=subject_10,
content=content_11, mailtype=mailtype_12,
hasHtmlImage=hasHtmlImage_13, mailAccountId=mailAccountId_14,
status=status_15, folderId=folderId_16
where  id=id_1;
end;
/