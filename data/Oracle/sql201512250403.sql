CREATE TABLE expandBaseRightInfo(
  id int primary key  NOT NULL,
  modeid int NOT NULL,
  expandid int NOT NULL,
  righttype int NOT NULL,
  relatedid int NULL,
  showlevel int NULL,
  showlevel2 int NULL,
  modifytime varchar(32) NULL,
  rolelevel int NULL,
  conditiontype int NULL,
  conditionsql varchar(4000) NULL,
  conditiontext varchar(4000) NULL
  )
/
  
create sequence expandBaseRightInfo_ID
minvalue 1
start with 1
increment by 1
/

create or replace trigger expandBaseRightInfo_tri
before insert on expandBaseRightInfo for each row
begin
select expandBaseRightInfo_ID.nextval into :new.id from dual;
end;
/

CREATE TABLE expandBaseRightExpressions(
  id int primary key NOT NULL,
  rightid int NOT NULL,
  relation int NOT NULL,
  expids varchar2(1000) NULL,
  expbaseid int NULL
)
/

create sequence expandBaseRightExpressions_ID
minvalue 1
start with 1
increment by 1
/

create or replace trigger expandBaseRightExpressions_tri
before insert on expandBaseRightExpressions for each row
begin
select expandBaseRightExpressions_ID.nextval into :new.id from dual;
end;
/

CREATE TABLE expandBaseRightExpressionBase(
  id int primary key NOT NULL,
  fieldid int NULL,
  fieldname varchar(100) NULL,
  fieldlabel varchar(200) NULL,
  rightid int NULL,
  compareopion int NULL,
  compareopionlabel varchar(200) NULL,
  htmltype varchar(100) NULL,
  fieldtype varchar(100) NULL,
  fielddbtype varchar(1000) NULL,
  fieldvalue varchar(1000) NULL,
  fieldtext varchar(1000) NULL,
  relationtype int NULL,
  valetype int NULL
)
/

create sequence expandRightExpressionBase_ID
minvalue 1
start with 1
increment by 1
/

create or replace trigger expandRightExpressionBase_tri
before insert on expandBaseRightExpressionBase for each row
begin
select expandRightExpressionBase_ID.nextval into :new.id from dual;
end;
/

insert into expandBaseRightInfo 
       (modeid, expandid, righttype, relatedid, showlevel, modifytime)
select modeid, id, 5, 0, 10, to_char(sysdate,'yyyy-mm-dd')
  from mode_pageexpand
 where modeid > 0
   and nvl(issystemflag,0) not in (1,2,3,4,5,6,8,10,100,101,102,103,104) 
/

delete from HtmlLabelIndex where id=125969 
/
delete from HtmlLabelInfo where indexid=125969 
/
INSERT INTO HtmlLabelIndex values(125969,'继承建模编辑权限') 
/
INSERT INTO HtmlLabelInfo VALUES(125969,'继承建模编辑权限',7) 
/
INSERT INTO HtmlLabelInfo VALUES(125969,'Inheritance modeling edit permissions',8) 
/
INSERT INTO HtmlLabelInfo VALUES(125969,'继承建模编辑权限',9) 
/

declare
 cursor expandcur  is 
     select *  from MODE_PAGEEXPAND
      where (trim(showcondition) is not null or trim(showcondition2) is not null)
        and isbatch <> 1
        and nvl(issystemflag,0) not in (1,2,3,4,5,6,8,10,100,101,102,103,104);
 expand MODE_PAGEEXPAND%rowtype;
begin 
 open expandcur;
 loop 
  fetch expandcur  into expand;
  exit when  expandcur%notfound;
  if trim(expand.showcondition) is null then
    if trim(expand.showcondition2) is not null then
      update EXPANDBASERIGHTINFO 
         set conditionsql = expand.showcondition2,
             CONDITIONTYPE = 2
       where expandid = expand.id;
    end if;
  else
     if trim(expand.showcondition2) is null then
      update EXPANDBASERIGHTINFO
         set conditionsql = expand.showcondition,
             CONDITIONTYPE = 2
       where expandid = expand.id; 
    else
       update EXPANDBASERIGHTINFO
         set conditionsql = '('||expand.showcondition|| ') and ('||expand.showcondition2||')',
             CONDITIONTYPE = 2
       where expandid = expand.id; 
    end if;
  end if;
 end loop;
 close expandcur;
end;
/

delete from HtmlLabelIndex where id=126450 
/
delete from HtmlLabelInfo where indexid=126450 
/
INSERT INTO HtmlLabelIndex values(126450,'扩展用途为查询列表设置条件不生效。') 
/
INSERT INTO HtmlLabelInfo VALUES(126450,'扩展用途为查询列表设置条件不生效。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(126450,'The condition does not take effect for search.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(126450,'擴展用途為查詢列表設置條件不生效。',9) 
/

delete from HtmlLabelIndex where id=126564 
/
delete from HtmlLabelInfo where indexid=126564 
/
INSERT INTO HtmlLabelIndex values(126564,'扩展权限') 
/
INSERT INTO HtmlLabelInfo VALUES(126564,'扩展权限',7) 
/
INSERT INTO HtmlLabelInfo VALUES(126564,'Extended rights',8) 
/
INSERT INTO HtmlLabelInfo VALUES(126564,'擴展權限',9) 
/

delete from HtmlLabelIndex where id=126574 
/
delete from HtmlLabelInfo where indexid=126574 
/
INSERT INTO HtmlLabelIndex values(126574,'扩展用途为查询列表继承建模编辑权限不生效。') 
/
INSERT INTO HtmlLabelInfo VALUES(126574,'扩展用途为查询列表继承建模编辑权限不生效。',7) 
/
INSERT INTO HtmlLabelInfo VALUES(126574,'This permission does not take effect for the search.',8) 
/
INSERT INTO HtmlLabelInfo VALUES(126574,'擴展用途為查詢列表繼承建模編輯權限不生效。',9) 
/

