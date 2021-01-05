update blog_app set iconPath='images/app-workplan.png' where id=8
/


alter table cowork_items add  replyNum int DEFAULT 0
/
alter table cowork_items add  readNum int DEFAULT 0
/
alter table cowork_items add  lastupdatedate VARCHAR(10)
/
alter table cowork_items add  lastupdatetime VARCHAR(10)
/
alter table cowork_discuss add topdiscussid int DEFAULT 0
/
alter table cowork_discuss add commentid int DEFAULT 0
/
alter table cowork_discuss add commentuserid int DEFAULT 0
/
alter table cowork_discuss add istop int DEFAULT 0
/
update cowork_discuss set topdiscussid=0,commentid=0,commentuserid=0,istop=0
/
declare
val_coworkid integer;
val_replyNum integer;
val_readNum integer;
val_maxdiscussid integer;
val_lastupdatedate VARCHAR2(10);
var_lastupdatetime VARCHAR2(10);

cursor cursor0 is SELECT id FROM cowork_items order by id;
begin

if cursor0%isopen = false then
		open cursor0;
end if;

fetch cursor0 into val_coworkid;
while cursor0%found loop

   select count(*) into val_replyNum from cowork_discuss where coworkid=val_coworkid and commentid=0;
			  
   select count(*) into val_readNum from cowork_log where coworkid=val_coworkid and type=2;

	 select max(id) into val_maxdiscussid from cowork_discuss where coworkid=val_coworkid;

	 if val_maxdiscussid is not null then

   select createdate,createtime into val_lastupdatedate,var_lastupdatetime from cowork_discuss where id=(select max(id) from cowork_discuss where coworkid=val_coworkid);

	 end if ;

  if val_lastupdatedate='' or var_lastupdatetime='' then
		BEGIN
			 update cowork_items set replyNum=val_replyNum,readNum=val_readNum,lastupdatedate=createdate,lastupdatetime=createtime where id=val_coworkid;
		END;
   ELSE
		BEGIN
				update cowork_items set replyNum=val_replyNum,readNum=val_readNum,lastupdatedate=val_lastupdatedate,lastupdatetime=var_lastupdatetime where id=val_coworkid;
		END;
 end if;

   fetch cursor0 into val_coworkid;
end loop;

close cursor0;
end;
/

alter table cowork_types add isApproval int DEFAULT 0
/
alter table cowork_types add isAnonymous int DEFAULT 0
/
update cowork_types set isApproval=0,isAnonymous=0
/
alter table cowork_items add isApproval int DEFAULT 0 --协作是否需要审批
/
alter table cowork_items add isAnonymous int DEFAULT 0 --协作是否允许匿名
/
alter table cowork_items add approvalAtatus int DEFAULT 0 --协作审批状态
/
update cowork_items set isApproval=0,isAnonymous=0,approvalAtatus=0
/
alter table cowork_discuss add approvalAtatus int DEFAULT 0 --留言审批状态
/
alter table cowork_discuss add isAnonymous int DEFAULT 0 --留言是否匿名
/
alter table cowork_discuss add isDel int DEFAULT 0
/
update cowork_discuss set approvalAtatus=0,isAnonymous=0,isDel=0 
/

alter table cowork_items add isTop int DEFAULT 0 --协作是否顶置协作
/
update cowork_items set isTop=0
/

update leftmenuconfig set visible=0  where infoid='81'
/
update leftmenuconfig set visible=0  where infoid='99'
/
update leftmenuconfig set visible=0  where infoid='100'
/
update leftmenuconfig set visible=0  where infoid='495'
/

ALTER TABLE cowork_maintypes ADD  sequence INT
/

update cowork_maintypes set sequence=1
/

CREATE TABLE cowork_app
	(
	id       INT NOT NULL,
	name     VARCHAR (20) NULL,
	isActive INT NULL,
	appType  VARCHAR (50) NULL,
	sort     INT NULL,
	iconPath VARCHAR (255) NULL
	)
/
create sequence cowork_app_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger cowork_app_id_trigger
before insert on cowork_app
for each row 
begin
select cowork_app_id.nextval into :new.id from dual;
end;
/


INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('58', 1, 'doc', 1, 'images/app-doc.png')
/
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('18015', 1, 'workflow', 2, 'images/app-wl.png')
/
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('136', 1, 'crm', 3, 'images/app-crm.png')
/
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('101', 1, 'project', 4, 'images/app-project.png')
/
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('1332', 1, 'task', 5, 'images/app-task.png')
/
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('156', 1, 'attachment', 6, '')
/
INSERT INTO cowork_app (name, isActive, appType, sort, iconPath) VALUES ('2211', 1, 'workplan', 7, 'images/app-workplan.png')
/

create table cowork_remind(
	id int,
	reminderid int,
	discussid int,
	coworkid int,
	createdate varchar(10),
	createtime varchar(8)
)
/
create sequence cowork_remind_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger cowork_remind_id_trigger
before insert on cowork_remind
for each row 
begin
select cowork_remind_id.nextval into :new.id from dual;
end;
/

update leftmenuconfig set visible=0  where infoid='351'
/


ALTER TABLE cowork_items ADD isApply CHAR(1)
/


CREATE TABLE cowork_apply_info(
	id INT,
	coworkid CHAR (10) NULL ,
	status CHAR(2) NULL ,
	resourceid CHAR(10) NULL,
	applydate CHAR(20) NULL ,
	approveid CHAR(10) NULL ,
	approvedate CHAR(20) NULL,
	ipaddress CHAR(15) NULL 

)
/
create sequence cowork_apply_info_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger cowork_apply_info_id_trigger
before insert on cowork_apply_info
for each row 
begin
select cowork_apply_info_id.nextval into :new.id from dual;
end;
/

CREATE TABLE MailConfigureInfo( 
	innerMail INT ,
	outterMail INT,
	filePath VARCHAR(1000),
	totalAttachmentSize INT,
	perAttachmentSize INT,
	attachmentCount INT
)
/

CREATE TABLE MailLog(
	id           INT NOT NULL,
	submiter     INT NULL,
	submitdate   VARCHAR (30) NULL,
	logtype      CHAR (2) NULL,
	clientip     CHAR (15) NULL,
	subject 	 VARCHAR(1200)
)
/
create sequence MailLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger MailLog_id_trigger
before insert on MailLog
for each row 
begin
select MailLog_id.nextval into :new.id from dual;
end;
/

ALTER TABLE  webmail_domain DROP COLUMN IS_SSL_AUTH
/

ALTER TABLE  webmail_domain ADD  IS_SSL_POP VARCHAR(100)
/

ALTER TABLE  webmail_domain ADD  IS_SSL_SMTP VARCHAR(100)
/

ALTER TABLE webmail_domain ADD NEED_SAVE INT
/

ALTER TABLE webmail_domain ADD AUTO_RECEIVE INT 
/

ALTER TABLE webmail_domain ADD RECEIVE_SCOPT INT 
/

ALTER TABLE DocMailMould ADD moulddesc VARCHAR(100)
/

ALTER TABLE HrmResource ADD totalSpace FLOAT DEFAULT 100
/

ALTER TABLE HrmResource ADD occupySpace FLOAT DEFAULT 0 
/

update HrmResource set totalSpace = 100 , occupySpace = 0
/

DECLARE m_id integer;  m_size float; m_contentsize float; m_totalsize FLOAT;
CURSOR sizecursor is SELECT id FROM MailResource where isInternal = 1 and originalMailId is null ;      
begin
  OPEN sizecursor;
  loop
  FETCH sizecursor INTO m_id;
  exit when sizecursor%notfound;
        SELECT NVL(sum(filesize),0) into m_size FROM MailResourceFile WHERE mailid = m_id;
        
        select dbms_lob.getlength(mailcontent) into m_contentsize from mailcontent where mailid = m_id;
        
        SELECT (nvl(m_contentsize ,0)+nvl(lengthb(subject),0) + m_size) into m_totalsize FROM MailResource WHERE id = m_id;
        
        UPDATE MailResource SET size_n = m_totalsize WHERE id = m_id;  
				UPDATE MailResource SET size_n = m_totalsize WHERE originalMailId = m_id;          
    END loop;
  CLOSE sizecursor;
end;
/



DECLARE m_id integer;  m_size float; m_contentsize float; m_totalsize FLOAT;
CURSOR sizecursor is SELECT id FROM MailResource  where size_n is null or size_n <= 0 ;      
begin
  OPEN sizecursor;
  loop
  FETCH sizecursor INTO m_id;
  exit when sizecursor%notfound;
        SELECT NVL(sum(filesize),0) into m_size FROM MailResourceFile WHERE mailid = m_id;
        
        select dbms_lob.getlength(mailcontent) into m_contentsize from mailcontent where mailid = m_id;
        
        SELECT (nvl(m_contentsize ,0)+nvl(lengthb(subject),0) + m_size) into m_totalsize FROM MailResource WHERE id = m_id;
        
        UPDATE MailResource SET size_n = m_totalsize WHERE id = m_id;            
    END loop;
  CLOSE sizecursor;
end;
/


DECLARE m_id integer;m_size FLOAT;
CURSOR statecursor IS SELECT DISTINCT resourceid , sum(size_n) si FROM MailResource where canview = 1 GROUP BY resourceid;
BEGIN
OPEN statecursor;
LOOP
FETCH  statecursor INTO m_id , m_size;
exit when statecursor%notfound; 
    UPDATE HrmResource SET occupySpace = round(m_size/(1024  * 1024),2) WHERE id = m_id;
END LOOP;
CLOSE statecursor;
END;
/


UPDATE MainMenuInfo SET defaultLevel = 1, defaultParentId = 0 ,  parentId = 0 WHERE id = 1047
/
UPDATE MainMenuInfo SET defaultLevel = 1, defaultParentId = 0 ,  parentId = 0 WHERE id = 359
/
UPDATE MainMenuInfo SET defaultLevel = 1, defaultParentId = 0 ,  parentId = 0 WHERE id = 1381
/

ALTER TABLE DocMailMould ADD mouldSubject VARCHAR(100)
/
update LeftMenuInfo set iconUrl='/images_face/ecologyFace_2/LeftMenuIcon/CPT_58.png' where id=58
/


