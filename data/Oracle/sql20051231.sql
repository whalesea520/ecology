CREATE table codemain (
    id integer ,
    titleImg Varchar2(20),  /*标题图片*/
    titleName Varchar2(20),
    isUse char(1),/*1:为启用 2:为不启用*/
    allowStr Varchar2(20) /*权限判定字符串*/
)
/
create sequence codemain_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger codemain_Trigger
before insert on codemain
for each row
begin
select codemain_id.nextval into :new.id from dual;
end;
/

CREATE table codedetail (
    id integer ,
    codemainid integer not null, /*主表的ID*/
    showname Varchar2(20), 
    showtype char(1), /*1:checkbox  3:input  3.year */
    value Varchar2(20), /*0:不选择 1:选择  当为year时 1|1 表示需用，并且年为四年制 1|0表示年为两年制*/
    codeorder integer
)
/
create sequence codedetail_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger codedetail_Trigger
before insert on codedetail
for each row
begin
select codedetail_id.nextval into :new.id from dual;
end;
/



INSERT INTO  codemain (titleImg,titleName,isUse,allowStr) VALUES ('/images/sales.gif','项目编码',1,'ProjCode:Maintenance')
/

INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'编码前缀',2,'proj',1)
/

INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'客户类型编码',1,'1',2)
/

INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'项目类型编码',1,'1',3)
/


INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'工作类型编码',1,'1',4)
/


INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'年',3,'1|1',5)
/
INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'月',1,'1',6)
/

INSERT INTO  codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'日',1,'1',7)
/


INSERT INTO codedetail(codemainid,showname,showtype,value,codeorder) 
VALUES (1,'流水号位数',2,'4',8)
/


/*修改项目编码的链接地址到公共方法*/
update MainMenuInfo set linkAddress='/system/codeMaint.jsp?codemainid=1' where  linkAddress='/proj/CodeFormat/CodeFormatView.jsp'
/
/*向工作类型表插入工作类型编码*/
ALTER  TABLE Prj_WorkType ADD worktypeCode Varchar2(50)
/

Create or replace PROCEDURE Prj_WorkType_Insert (
fullname_1 	Varchar2, 
description_2 	Varchar2,
worktypecode_3 Varchar2,
  flag out integer, 
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor)
AS
BEGIN
INSERT INTO Prj_WorkType (fullname, description,worktypecode) 
VALUES ( fullname_1, description_2,worktypecode_3);
END;
/


Create or replace PROCEDURE Prj_WorkType_Update (
id_1	 	integer,
 fullname_2 	Varchar2,
 description_3 	Varchar2, 
 worktypecode_4 Varchar2,
  flag out integer, 
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor)
  AS
  BEGIN
  UPDATE Prj_WorkType  
  SET  fullname	 = fullname_2, description = description_3,worktypecode= worktypecode_4  
   WHERE ( id	 = id_1);
END;
/

