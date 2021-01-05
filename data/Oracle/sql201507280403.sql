create table prj_typecreatelist
(
  id                   INTEGER not null,
  typeid                    INTEGER not null,
  seclevel                 INTEGER,
  departmentid             INTEGER,
  roleid                   INTEGER,
  rolelevel                INTEGER,
  usertype                 INTEGER,
  permissiontype           INTEGER not null,
  operationcode            INTEGER not null,
  userid                   INTEGER,
  subcompanyid             INTEGER,
  seclevelmax              INTEGER
)
/
alter table prj_typecreatelist
  add primary key (ID)
  using index
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  )
/
create sequence prj_typecreatelist_ID
minvalue 1
maxvalue 9999999999999999999999999999
start with 81
increment by 1
cache 20
/


create or replace trigger prj_typecreatelist_Trigger 
before insert on prj_typecreatelist 
for each row 
begin select prj_typecreatelist_ID.nextval 
into :new.id from dual; 
end;
 /

insert into prj_typecreatelist(typeid, seclevel, operationcode, permissiontype,seclevelmax) select t.id,0,0,3,100 from prj_projecttype t
/