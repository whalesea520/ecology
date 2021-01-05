alter table mode_CustomDspField add isadvancedquery char(1)
/
alter table mode_CustomDspField add advancedqueryorder int default 0 not null
/
create table mode_TemplateDspField
(
    ID INT primary key ,
    templateid int,
    fieldid int,
    isshow int,
    fieldorder int,
    topt varchar(10),
    topt1 varchar(10),
    tvalue varchar(100),
    tvalue1 varchar(100),
    tname varchar(100)
)
/
create sequence mode_TemplateDspField_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_TemplateDspField_id_Tri
before insert on mode_TemplateDspField
for each row
begin
select mode_TemplateDspField_id.nextval into :new.id from dual;
end;
/
create table mode_TemplateInfo
(
    ID INT primary key ,
    customid int,
    templatename varchar(100),
    templatetype char(1),
    displayorder int,
    isdefault int,
    createrid int,
    createdate varchar(50)
)
/
create sequence mode_TemplateInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_TemplateInfo_id_Tri
before insert on mode_TemplateInfo
for each row
begin
select mode_TemplateInfo_id.nextval into :new.id from dual;
end;
/