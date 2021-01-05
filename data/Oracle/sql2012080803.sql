create table modeTreeField(			
	id			integer,	
	treeFieldName		varchar2(80),	
	superFieldid		integer,			
	allSuperFieldId		varchar2(80),	
	treelevel			integer,			
	isLast			char(1),	
	showOrder		number(6,2),
	treeFieldDesc		varchar2(500)		
)
/

create sequence modeTreeField_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger modeTreeField_Tri
before insert on modeTreeField
for each row
begin
select modeTreeField_id.nextval into :new.id from dual;
end;
/

insert into modeTreeField(treeFieldName,superFieldid,allSuperFieldId,treelevel,isLast,showOrder)
values('Ä£¿é',0,'',0,'0','0')
/

create table modeinfo(				
	id			integer,	
	modename		varchar2(50),	
	modedesc		varchar2(255),	
	modetype		integer,			
	formid			integer,			
	maincategory		integer,			
	subcategory		integer,			
	seccategory		integer,			
	isImportDetail		integer,			
	codeid			integer		
)
/
create sequence modeinfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger modeinfo_Tri
before insert on modeinfo
for each row
begin
select modeinfo_id.nextval into :new.id from dual;
end;
/

create table modehtmllayout(		
	id		integer,
	modeid		integer,				
	formid		integer,			
	type		integer,			
	layoutname	varchar2(200),		
	syspath		varchar2(1000),		
	colsperrow	integer,			
	cssfile		integer			
)
/
create sequence modehtmllayout_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger modehtmllayout_Tri
before insert on modeinfo
for each row
begin
select modehtmllayout_id.nextval into :new.id from dual;
end;
/

create table modefieldattr(			
	id		integer,
	modeid		integer,				
	formid		integer,				
	type		integer,				
	fieldid		integer,				
	attrcontent	varchar2(4000)		
	
)
/
create sequence modefieldattr_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger modefieldattr_Tri
before insert on modefieldattr
for each row
begin
select modefieldattr_id.nextval into :new.id from dual;
end;
/

create table modeformfield(			
	modeid		integer,				
	type		integer,				
	fieldid		integer,				
	isview		integer,				
	isedit		integer,				
	ismandatory	integer,				
	orderid		number(10, 2)
)
/

create table modeformgroup(		
	modeid		integer,			
	formid		integer,			
	type		integer,			
	groupid		integer,			
	isadd		integer,			
	isedit		integer,			
	isdelete	integer,			
	ishidenull	integer,			
	Isneed		integer,			
	isdefault	integer				
)
/

create table DefaultValue(		
	id			integer,
	modeid			integer,			
	fieldid			integer,			
	customervalue		varchar2(255)	
)
/
create sequence DefaultValue_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger DefaultValue_Tri
before insert on DefaultValue
for each row
begin
select DefaultValue_id.nextval into :new.id from dual;
end;
/


create table modeattrlinkage(		
	id				integer,
	modeid				integer,			
	type				integer,			
	selectfieldid			varchar2(20),	
	selectfieldvalue		integer,			
	changefieldids			varchar2(255),	
	viewattr			integer				
)
/
create sequence modeattrlinkage_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger modeattrlinkage_Tri
before insert on modeattrlinkage
for each row
begin
select modeattrlinkage_id.nextval into :new.id from dual;
end;
/

create table modeDataInputentry(		
	id				integer,
	modeid				integer,			
	triggerName			varchar2(100),	
	triggerfieldname		varchar2(255),	
	type				char(1)			
)
/
create sequence modeDataInputentry_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger modeDataInputentry_Tri
before insert on modeDataInputentry
for each row
begin
select modeDataInputentry_id.nextval into :new.id from dual;
end;
/

create table modeDataInputmain(		
	id				integer,
	entryID				integer,			
	WhereClause			varchar2(1000),
	IsCycle				integer,
	OrderID				integer,
	datasourcename			varchar2(100)	
)
/
create sequence modeDataInputmain_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger modeDataInputmain_Tri
before insert on modeDataInputmain
for each row
begin
select modeDataInputmain_id.nextval into :new.id from dual;
end;
/

create table modeDataInputtable(		
	id				integer,
	DataInputID			integer,			
	TableName			varchar2(40),	
	Alias				varchar2(10),	
	FormId				char(1)
)
/
create sequence modeDataInputtable_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger modeDataInputtable_Tri
before insert on modeDataInputtable
for each row
begin
select modeDataInputtable_id.nextval into :new.id from dual;
end;
/

create table modeDataInputfield(	
	id				integer,
	DataInputID			integer,			
	TableID				integer,			
	Type				integer,			
	DBFieldName			varchar2(40),	
	PageFieldName			varchar2(40)	
)
/
create sequence modeDataInputfield_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger modeDataInputfield_Tri
before insert on modeDataInputfield
for each row
begin
select modeDataInputfield_id.nextval into :new.id from dual;
end;
/

create table moderightinfo(				
	id				integer,	
	modeid				integer,			
	righttype			integer,			
	sharetype			integer,									
	relatedid			integer,			
	rolelevel			integer,			
	showlevel			integer			
)
/
create sequence moderightinfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger moderightinfo_Tri
before insert on moderightinfo
for each row
begin
select moderightinfo_id.nextval into :new.id from dual;
end;
/


create table ModeCode(
	id			integer,	
	isUse			integer,	
	modeId			integer,
	codeFieldId		integer,	
	currentCode		varchar2(255)		
)
/
create sequence ModeCode_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger ModeCode_Tri
before insert on ModeCode
for each row
begin
select ModeCode_id.nextval into :new.id from dual;
end;
/

create table ModeCodeDetail(
	id			integer,	
	codemainid		integer,		
	showname		integer,		
	showtype		integer,		
	showvalue		varchar2(50),
	codeorder		integer			
)
/
create sequence ModeCodeDetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/

create or replace trigger ModeCodeDetail_Tri
before insert on ModeCodeDetail
for each row
begin
select ModeCodeDetail_id.nextval into :new.id from dual;
end;
/