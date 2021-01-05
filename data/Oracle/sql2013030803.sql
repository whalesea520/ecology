update mode_pageexpandtemplate set expendname = '保存' where issystemflag = 1
/
update mode_pageexpandtemplate set expendname = '保存' where issystemflag = 2
/
update mode_pageexpandtemplate set expendname = '编辑' where issystemflag = 3
/
update mode_pageexpandtemplate set expendname = '共享' where issystemflag = 4
/
update mode_pageexpandtemplate set expendname = '删除' where issystemflag = 5
/
update mode_pageexpandtemplate set expendname = '删除' where issystemflag = 6
/
update mode_pageexpand set expendname = '保存' where issystemflag = 1
/
update mode_pageexpand set expendname = '保存' where issystemflag = 2
/
update mode_pageexpand set expendname = '编辑' where issystemflag = 3
/
update mode_pageexpand set expendname = '共享' where issystemflag = 4
/
update mode_pageexpand set expendname = '删除' where issystemflag = 5
/
update mode_pageexpand set expendname = '删除' where issystemflag = 6
/

alter table mode_customsearch add opentype integer
/

create table mode_batchSet(
	id integer ,
	expandid integer,
	showorder number(15,2),
	customsearchid integer,
	isuse integer
)
/
create sequence mode_batchSet_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger mode_batchSet_Tri
before insert on mode_batchSet
for each row
begin
select mode_batchSet.nextval into :new.id from dual;
end;
/

alter table mode_pageexpandtemplate add expenddesc varchar2(4000)
/
alter table mode_pageexpandtemplate add isbatch integer default 0
/
alter table mode_pageexpandtemplate add defaultenable integer default 0
/
alter table mode_pageexpand add expenddesc varchar2(4000)
/
alter table mode_pageexpand add isbatch integer default 0
/
alter table mode_pageexpand add defaultenable integer default 0
/
alter table mode_batchSet add listbatchname varchar2(100)
/
alter table mode_pageexpand add createpage integer default 0
/
alter table mode_pageexpand add managepage integer default 0
/
alter table mode_pageexpand add viewpage integer default 0
/
alter table mode_pageexpand add moniterpage integer default 0
/
alter table mode_customsearch add norightlist char(1) default 0
/


update mode_pageexpandtemplate set isbatch = 0,defaultenable=0
/
update mode_pageexpand set isbatch = 0,defaultenable=0
/
update mode_pageexpand set createpage=1,managepage=1,viewpage=1,moniterpage=0 where issystem = 0
/



insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('搜索','2','3','0','0','','1','100','1','100','搜索','1','1')
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('新建','2','3','0','0','','1','101','1','101','新建','1','1')
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('删除','2','3','0','0','','1','102','1','102','删除','1','1')
/
insert into mode_pageexpandtemplate(expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) values('批量导入','2','3','0','0','','1','103','1','103','批量导入','1','1')
/

insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'搜索','2','3','0','0','','1','100','1','100','搜索','1','1' from modeinfo
/
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'新建','2','3','0','0','','1','101','1','101','新建','1','1' from modeinfo
/
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'删除','2','3','0','0','','1','102','1','102','删除','1','1' from modeinfo
/
insert into mode_pageexpand(modeid,expendname,showtype,opentype,hreftype,hrefid,hreftarget,isshow,showorder,issystem,issystemflag,expenddesc,isbatch,defaultenable) select id,'批量导入','2','3','0','0','','1','103','1','103','批量导入','1','1' from modeinfo
/

alter table mode_customtree add defaultaddress varchar2(4000)
/
alter table mode_customtree add expandfirstnode char(1)
/
alter table mode_customtreedetail add iconField varchar2(100)
/
alter table mode_customtreedetail add dataorder varchar2(1000)
/
alter table mode_customtreedetail add datacondition varchar2(4000)
/
alter table mode_customtreedetail add hrefField varchar2(100)
/

Delete from MainMenuInfo where id=1239
/
call MMConfig_U_ByInfoInsert (1207,3)
/
call MMInfo_Insert (1239,30063,'自定义页面设置','/formmode/custompage/CustomList.jsp','mainFrame',1207,2,3,0,'',0,'',0,'','',0,'','',9)
/

create or replace PROCEDURE mode_createviewlog_p AS
  tableIndex  integer;
  tablename   varchar2(100);
  sqltext     varchar2(1000);
  existstable integer;
  CURSOR tableindex_cur IS
    select id from modeinfo where id < 10;
BEGIN
  OPEN tableindex_cur;
  LOOP
    FETCH tableindex_cur
      INTO tableIndex;
    EXIT WHEN tableindex_cur%NOTFOUND;
    tablename := 'ModeViewLog_' || tableIndex;
    select count(*)
      into existstable
      from user_tables t
     where lower(t.table_name) = lower(tablename);
     
	if existstable <= 0 then
		sqltext := 'CREATE TABLE ' || tablename || ' (
          id int primary key NOT NULL ,
          relatedid int NOT NULL ,
          relatedname varchar2(1000)  NOT NULL ,
          operatetype int  NOT NULL ,
          operatedesc varchar2(4000)  NULL ,
          operateuserid int NOT NULL ,
          operatedate char(10)  NOT NULL ,
          operatetime char(8)  NOT NULL ,
          clientaddress varchar2(30)  NULL
        )';
	EXECUTE IMMEDIATE (sqltext);
      
	sqltext := 'create sequence ' || tablename || '_id
		start with 1
		increment by 1
		nomaxvalue
		nocycle';
	EXECUTE IMMEDIATE (sqltext);

	sqltext := 'create or replace trigger ' || tablename || '_Tri
		before insert on ' || tablename || '
		for each row
		begin
		select ' || tablename || '_id.nextval into :new.id from dual;
		end;';
	EXECUTE IMMEDIATE (sqltext);
      
      sqltext := 'create index ' ||tablename|| '_operatetype on ' ||tablename|| ' (relatedid,operatetype,operateuserid)';
      EXECUTE IMMEDIATE (sqltext);
    end if;
  END LOOP;
  CLOSE tableindex_cur;
END;
/

declare
begin
	mode_createviewlog_p();
end;
/

drop PROCEDURE mode_createviewlog_p
/