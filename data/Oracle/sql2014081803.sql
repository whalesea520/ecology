alter table cus_formdict add fieldname varchar2(30) null
/
alter table cus_formdict add fieldlabel varchar2(200) null
/
update cus_formdict set fieldname='field'||to_char(id) where fieldname is null
/
alter table cus_formdict add scope varchar2(200) null
/
alter table cus_formfield add doc_fieldlabel int null
/

alter table cus_selectitem add doc_isdefault int default 0
/

alter table cus_selectitem add cancel int default 0
/

alter table DocSecCategoryDocProperty add customNameEng varchar2(200) null
/

alter table DocSecCategoryDocProperty add customNameTran varchar2(200) null
/
alter table DocSecCategory add isuser int null
/
alter table DocSecCategory add e8number varchar2(100) null
/
alter table workflow_base add isWorkflowDoc int null
/

update workflow_base set isWorkflowDoc=1 where id in (select workflowid from workflow_createdoc where status=1 and flowDocField>-1)
/
alter table DocMould add lastModTime varchar2(32) null
/
alter table DocMailMould add lastModTime varchar2(32) null
/
alter table DocMouldfile add lastModTime varchar2(32) null
/
alter table DocMould add subcompanyid int null
/

alter table DocFrontpage add subcompanyid int null
/

alter table DocMouldfile add subcompanyid int null
/

alter table  DocSecCategoryTemplate add subcompanyid int null
/

alter table  DocMailMould add subcompanyid int null
/

alter table  WebMagazineType add subcompanyid int null
/

alter table   DocMainCategory add subcompanyid int null
/
CREATE TABLE workflow_process_relative(
	ID integer  NOT NULL primary key,
	workflowid int not null,
	nodeids varchar2(100) NULL,
	officaltype int NULL,
	pdid int NOT NULL
)

/
create sequence workflow_process_relative_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20
/

create or replace trigger "wf_process_relative_id_TRIGGER"
  before insert on workflow_process_relative
  for each row
begin
  select workflow_process_relative_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_processdefine(
	ID integer  NOT NULL primary key,
	sysid int null,
	label varchar(100) NULL,
	status int NULL,
	sortorder decimal(15,2) NULL,
	linktype int NOT NULL,
	shownamelabel int null,
	isSys int not null 
)

/
create sequence workflow_processdefine_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20
/

create or replace trigger "wf_processdefine_id_TRIGGER"
  before insert on workflow_processdefine
  for each row
begin
  select workflow_processdefine_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_processinst(
	id int NOT NULL primary key,
	pd_id int null,
	phraseDesc varchar2(200) NULL,
	phraseShort varchar2(100) NULL,
	sortorder NUMERIC(15,2) NULL,
	isdefault int default 0
)

/

create sequence workflow_processinst_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20

/

create or replace trigger "wf_processinst_id_TRIGGER"
  before insert on workflow_processinst
  for each row
begin
  select workflow_processinst_id.nextval into :new.id from dual;
end;
/
CREATE or replace PROCEDURE DocFrontpage_Insert_New
        (@frontpagename_1 	varchar2(200),
         @frontpagedesc_2 	varchar2(200), 
         @isactive_3 	char(1), 
         @departmentid_4 	int, 
         @linktype_5 	varchar2(2),
         @hasdocsubject_6 	char(1), 
         @hasfrontpagelist_7 	char(1), 
         @newsperpage_8 	int, 
         @titlesperpage_9 	int, 
         @defnewspicid_10 	int, 
         @backgroundpicid_11 	int, 
         @importdocid_12 	varchar2(200), 
         @headerdocid_13 	int,
         @footerdocid_14 	int, 
         @secopt_15 	varchar2(2), 
         @seclevelopt_16 	int, 
         @departmentopt_17 	int, 
         @dateopt_18 	int, 
         @languageopt_19 	int, 
         @clauseopt_20 	varchar2(4000), 
         @newsclause_21 	varchar2(4000), 
         @languageid_22 	int, 
         @publishtype_23 	int , 
         @newstypeid_24 	int , 
         @typeordernum_25 int, 
         @subcompanyid_26 int, 
         @flag	int	output, 
         @msg	varchar(80)	output) AS 
         INSERT INTO DocFrontpage 
                ( frontpagename, 
                frontpagedesc, 
                isactive, 
                departmentid, 
                linktype, 
                hasdocsubject, 
                hasfrontpagelist, 
                newsperpage, 
                titlesperpage, 
                defnewspicid, 
                backgroundpicid, 
                importdocid, 
                headerdocid, 
                footerdocid, 
                secopt, 
                seclevelopt, 
                departmentopt, 
                dateopt, 
                languageopt, 
                clauseopt, 
                newsclause, 
                languageid, 
                publishtype, 
                newstypeid, 
                typeordernum,
                subcompanyid)
          VALUES ( @frontpagename_1, 
                   @frontpagedesc_2, 
                   @isactive_3, 
                   @departmentid_4, 
                   @linktype_5, 
                   @hasdocsubject_6,
                   @hasfrontpagelist_7, 
                   @newsperpage_8, 
                   @titlesperpage_9, 
                   @defnewspicid_10, 
                   @backgroundpicid_11, 
                   @importdocid_12, 
                   @headerdocid_13, 
                   @footerdocid_14, 
                   @secopt_15, 
                   @seclevelopt_16, 
                   @departmentopt_17, 
                   @dateopt_18, 
                   @languageopt_19, 
                   @clauseopt_20, 
                   @newsclause_21, 
                   @languageid_22, 
                   @publishtype_23, 
                   @newstypeid_24,
                   @typeordernum_25,
                   @subcompanyid_26) select max(id) from DocFrontpage 
/
CREATE or replace PROCEDURE DocFrontpage_Update_New (
       @id_1 	int, 
       @frontpagename_2 	varchar2(200), 
       @frontpagedesc_3 	varchar2(200), 
       @isactive_4 	char(1), 
       @departmentid_5 	int, 
       @hasdocsubject_7 	char(1), 
       @hasfrontpagelist_8 	char(1), 
       @newsperpage_9 	int, 
       @titlesperpage_10 	int, 
       @defnewspicid_11 	int, 
       @backgroundpicid_12 	int, 
       @importdocid_13 	varchar2(200), 
       @headerdocid_14 	int, 
       @footerdocid_15 	int, 
       @secopt_16 	varchar(2), 
       @seclevelopt_17 	int, 
       @departmentopt_18 	int, 
       @dateopt_19 	int, 
       @languageopt_20 	int, 
       @clauseopt_21 	varchar2(4000), 
       @newsclause_22 	varchar2(4000), 
       @languageid_23 	int, 
       @publishtype_24 	int , 
       @newstypeid_25  int, 
       @typeordernum_26  int, 
       @checkOutStatus_27  int, 
       @checkOutUserId_28  int, 
       @subcompanyid_29 int, 
       @flag	int	output, 
       @msg	varchar(80)	output) AS 
       UPDATE DocFrontpage  SET  
              frontpagename	 = @frontpagename_2, 
              frontpagedesc	 = @frontpagedesc_3, 
              isactive	 = @isactive_4, 
              departmentid	 = @departmentid_5, 
              hasdocsubject	 = @hasdocsubject_7, 
              hasfrontpagelist	 = @hasfrontpagelist_8, 
              newsperpage	 = @newsperpage_9, 
              titlesperpage	 = @titlesperpage_10, 
              defnewspicid	 = @defnewspicid_11, 
              backgroundpicid	 = @backgroundpicid_12, 
              importdocid	 = @importdocid_13, 
              headerdocid	 = @headerdocid_14, 
              footerdocid	 = @footerdocid_15, 
              secopt	 = @secopt_16, 
              seclevelopt	 = @seclevelopt_17, 
              departmentopt	 = @departmentopt_18, 
              dateopt	 = @dateopt_19, 
              languageopt	 = @languageopt_20, 
              clauseopt	 = @clauseopt_21, 
              newsclause	 = @newsclause_22, 
              languageid	 = @languageid_23, 
              publishtype	 = @publishtype_24, 
              newstypeid=@newstypeid_25, 
              typeordernum=@typeordernum_26, 
              checkOutStatus=@checkOutStatus_27, 
              checkOutUserId=@checkOutUserId_28,
              subcompanyid=@subcompanyid_29  WHERE ( id = @id_1) 
/
CREATE TABLE ecology_pagesize(
  ID integer  NOT NULL primary key,
  pagesize integer not null,
  pageid varchar2(200) null
)
/

create sequence ecology_pagesize_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20
/

create or replace trigger "ecology_pagesize_id_TRIGGER"
  before insert on ecology_pagesize
  for each row
begin
  select ecology_pagesize_id.nextval into :new.id from dual;
end;
/
CREATE OR REPLACE FUNCTION f_GetPy(P_NAME IN VARCHAR2) RETURN VARCHAR2 AS
     V_COMPARE VARCHAR2(100);
     V_RETURN VARCHAR2(4000);

     FUNCTION F_NLSSORT(P_WORD IN VARCHAR2) RETURN VARCHAR2 AS
     BEGIN
      RETURN NLSSORT(P_WORD, 'NLS_SORT=SCHINESE_PINYIN_M');
     END;
    BEGIN

    FOR I IN 1..NVL(LENGTH(P_NAME), 0) LOOP
     V_COMPARE := F_NLSSORT(SUBSTR(P_NAME, I, 1));
     IF V_COMPARE >= F_NLSSORT('吖') AND V_COMPARE <= F_NLSSORT('驁') THEN
      V_RETURN := V_RETURN || 'A';
     ELSIF V_COMPARE >= F_NLSSORT('八') AND V_COMPARE <= F_NLSSORT('簿') THEN
      V_RETURN := V_RETURN || 'B';
     ELSIF V_COMPARE >= F_NLSSORT('嚓') AND V_COMPARE <= F_NLSSORT('錯') THEN
      V_RETURN := V_RETURN || 'C';
     ELSIF V_COMPARE >= F_NLSSORT('咑') AND V_COMPARE <= F_NLSSORT('鵽') THEN
      V_RETURN := V_RETURN || 'D';
     ELSIF V_COMPARE >= F_NLSSORT('妸') AND V_COMPARE <= F_NLSSORT('樲') THEN
      V_RETURN := V_RETURN || 'E';
     ELSIF V_COMPARE >= F_NLSSORT('发') AND V_COMPARE <= F_NLSSORT('猤') THEN
      V_RETURN := V_RETURN || 'F';
     ELSIF V_COMPARE >= F_NLSSORT('旮') AND V_COMPARE <= F_NLSSORT('腂') THEN
      V_RETURN := V_RETURN || 'G';
     ELSIF V_COMPARE >= F_NLSSORT('妎') AND V_COMPARE <= F_NLSSORT('夻') THEN
      V_RETURN := V_RETURN || 'H';
     ELSIF V_COMPARE >= F_NLSSORT('丌') AND V_COMPARE <= F_NLSSORT('攈') THEN
      V_RETURN := V_RETURN || 'J';
     ELSIF V_COMPARE >= F_NLSSORT('咔') AND V_COMPARE <= F_NLSSORT('穒') THEN
      V_RETURN := V_RETURN || 'K';
     ELSIF V_COMPARE >= F_NLSSORT('垃') AND V_COMPARE <= F_NLSSORT('擽') THEN
      V_RETURN := V_RETURN || 'L';
     ELSIF V_COMPARE >= F_NLSSORT('嘸') AND V_COMPARE <= F_NLSSORT('椧') THEN
      V_RETURN := V_RETURN || 'M';
     ELSIF V_COMPARE >= F_NLSSORT('拏') AND V_COMPARE <= F_NLSSORT('瘧') THEN
      V_RETURN := V_RETURN || 'N';
     ELSIF V_COMPARE >= F_NLSSORT('筽') AND V_COMPARE <= F_NLSSORT('漚') THEN
      V_RETURN := V_RETURN || 'O';
     ELSIF V_COMPARE >= F_NLSSORT('妑') AND V_COMPARE <= F_NLSSORT('曝') THEN
      V_RETURN := V_RETURN || 'P';
     ELSIF V_COMPARE >= F_NLSSORT('七') AND V_COMPARE <= F_NLSSORT('裠') THEN
      V_RETURN := V_RETURN || 'Q';
     ELSIF V_COMPARE >= F_NLSSORT('亽') AND V_COMPARE <= F_NLSSORT('鶸') THEN
      V_RETURN := V_RETURN || 'R';
     ELSIF V_COMPARE >= F_NLSSORT('仨') AND V_COMPARE <= F_NLSSORT('蜶') THEN
      V_RETURN := V_RETURN || 'S';
     ELSIF V_COMPARE >= F_NLSSORT('侤') AND V_COMPARE <= F_NLSSORT('籜') THEN
      V_RETURN := V_RETURN || 'T';
     ELSIF V_COMPARE >= F_NLSSORT('屲') AND V_COMPARE <= F_NLSSORT('鶩') THEN
      V_RETURN := V_RETURN || 'W';
     ELSIF V_COMPARE >= F_NLSSORT('夕') AND V_COMPARE <= F_NLSSORT('鑂') THEN
      V_RETURN := V_RETURN || 'X';
     ELSIF V_COMPARE >= F_NLSSORT('丫') AND V_COMPARE <= F_NLSSORT('韻') THEN
      V_RETURN := V_RETURN || 'Y';
     ELSIF V_COMPARE >= F_NLSSORT('帀') AND V_COMPARE <= F_NLSSORT('咗') THEN
      V_RETURN := V_RETURN || 'Z';
     END IF;
    END LOOP;
    RETURN V_RETURN;
   END;
   /
  CREATE TABLE MouldBookMarkEdit (
  id int primary key ,
  mouldId int NULL ,
  name   varchar(100) NULL,
  descript   varchar(200) NULL,
  showOrder decimal(6,2)   NULL
)
/

create sequence MouldBookMarkEdit_Id
	start with 1
	increment by 1
	nomaxvalue
	nocycle
/
create or replace trigger MouldBookMarkEdit_Trigger
	before insert on MouldBookMarkEdit
	for each row
	begin
	select MouldBookMarkEdit_Id.nextval into :new.id from dual;
	end;
/

CREATE TABLE WorkFlow_DocShowEdit (
  id int  primary key ,
  flowId int NULL ,
  selectItemId int NULL ,
  secCategoryID  varchar(500) NULL,
  modulId int NULL ,
  fieldId int NULL,
  docMouldID int NULL,
  isDefault char(1) NULL,
  dateShowType char(1) NULL
)
/

create sequence WorkFlow_DocShowEdit_Id
	start with 1
	increment by 1
	nomaxvalue
	nocycle
/
create or replace trigger WorkFlow_DocShowEdit_Trigger
	before insert on WorkFlow_DocShowEdit
	for each row
	begin
	select WorkFlow_DocShowEdit_Id.nextval into :new.id from dual;
	end;
/

ALTER TABLE DocDetail ADD editMouldId int null
/
delete from workflow_processdefine where sysid=1
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('拟稿',1,1,'1.0',1,0,1)

/


delete from workflow_processdefine where sysid=2
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('核稿',2,1,'2.0',1,0,1)
	
/


delete from workflow_processdefine where sysid=3
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('会签',3,1,'3.0',1,0,1)
	
/


delete from workflow_processdefine where sysid=4
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('签发',4,1,'4.0',1,0,1)
	
/


delete from workflow_processdefine where sysid=5
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('套红',5,1,'5.0',1,0,1)
	
/

delete from workflow_processdefine where sysid=6
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('签章',6,1,'6.0',1,0,1)
	
/


delete from workflow_processdefine where sysid=7
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('打印',7,1,'7.0',1,0,1)
	
/


delete from workflow_processdefine where sysid=8
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('分发',8,1,'8.0',1,0,1)
	
/


delete from workflow_processdefine where sysid=9
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('查收',9,1,'9.0',1,0,1)
/	

delete from workflow_processdefine where sysid=10
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('拟稿',10,1,'1.0',3,0,1)

/


delete from workflow_processdefine where sysid=11
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('核稿',11,1,'2.0',3,0,1)
	
/


delete from workflow_processdefine where sysid=12
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('会签',12,1,'3.0',3,0,1)
	
/


delete from workflow_processdefine where sysid=13
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('签发',13,1,'4.0',3,0,1)
	
/


delete from workflow_processdefine where sysid=14
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('确认',14,1,'5.0',3,0,1)
	
/

delete from workflow_processdefine where sysid=15
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('通知',15,1,'6.0',3,0,1)
	
/

delete from workflow_processdefine where sysid=16
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('登记',16,1,'1.0',2,0,1)

/


delete from workflow_processdefine where sysid=17
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('拟办',17,1,'2.0',2,0,1)
	
/


delete from workflow_processdefine where sysid=18
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('审核',18,1,'3.0',2,0,1)
	
/


delete from workflow_processdefine where sysid=19
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('批示',19,1,'4.0',2,0,1)
	
/

delete from workflow_processdefine where sysid=20
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('办理',20,1,'5.0',2,0,1)
	
/

delete from workflow_processdefine where sysid=21
/
insert into workflow_processdefine(label,sysid,status,sortorder,linktype,shownamelabel,isSys)
	values('传阅',21,1,'6.0',2,0,1)
/

CREATE TABLE system_default_col(
	ID integer  NOT NULL primary key,
	isdefault char(1) default '0',
	pageid varchar2(200) NULL,
	align varchar2(10) default 'left',
	name varchar2(32) NULL,
	column_ varchar2(32) NULL,
	orderkey varchar2(200) NULL,
	linkvaluecolumn varchar2(32) NULL,
	linkkey varchar2(32) NULL,
	href varchar2(200) NULL,
	target varchar2(32) default '_self',
	transmethod varchar2(100) NULL,
	otherpara varchar2(2000) NULL,
	orders int default 0,
	width varchar2(30) NULL,
	text_ varchar2(400) NULL,
	labelid varchar2(50) NULL,
  hide_ varchar2(10) default 'true'
)
/
create sequence system_default_col_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20
/

create or replace trigger "system_default_col_id_TRIGGER"
  before insert on system_default_col
  for each row
begin
  select system_default_col_id.nextval into :new.id from dual;
end;
/
CREATE TABLE table_col_base(
  ID integer  NOT NULL primary key,
  tablename varchar2(200) null,
  colName varchar2(200) not null,
  labelId integer null,
  fieldid integer null
)

/
create sequence table_col_base_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20

/
create or replace trigger "table_col_base_id_TRIGGER"
  before insert on table_col_base
  for each row
begin
  select table_col_base_id.nextval into :new.id from dual;
end;
/
CREATE TABLE user_default_col(
  ID integer  NOT NULL primary key,
  pageid varchar2(200) not null,
  userid int not null,
  col_base_id integer null,
  systemid  integer  not null,
  orders integer default 0
)

/
create sequence user_default_col_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20
/

create or replace trigger "user_default_col_id_TRIGGER"
  before insert on user_default_col
  for each row
begin
  select user_default_col_id.nextval into :new.id from dual;
end;
/
CREATE TABLE workflow_interfaces(
  ID integer  NOT NULL primary key,
  name varchar(200) NOT NULL,
  deploy_status varchar(1) default '0',
  memo varchar(200) NULL,
  closed varchar(1) default '0'
)

/
create sequence workflow_interfaces_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20
/

create or replace trigger "workflow_interfaces_id_TRIGGER"
  before insert on workflow_interfaces
  for each row
begin
  select workflow_interfaces_id.nextval into :new.id from dual;
end;
/

CREATE TABLE workflow_mould(
  ID integer  NOT NULL primary key,
  workflowid integer not null,
  mouldid integer not null,
  mouldType integer null,
  visible integer default 1,
  seccategory integer null
)
/
create sequence workflow_mould_id
	minvalue 1
	maxvalue 999999999999999999999999999
	start with 1
	increment by 1
	cache 20
/

create or replace trigger "workflow_mould_id_TRIGGER"
  before insert on workflow_mould
  for each row
begin
  selectworkflow_mould.nextval into :new.id from dual;
end;
/
