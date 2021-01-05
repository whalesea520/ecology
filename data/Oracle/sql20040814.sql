/* TD577 */
CREATE TABLE CptBorrowBuffer (
id integer  not null primary key,
cptId integer NULL,
useDate char (10) NULL,
deptId integer NULL,
userId integer NULL,
depositary varchar2 (200) NULL,
remark varchar2(4000) NULL
)
/
create sequence CptBorrowBuffer_id
start with 1
increment by 1
nomaxvalue
nocycle
/        

create or replace trigger CptBorrowBuffer_Trigger
before insert on CptBorrowBuffer
for each row
begin
select CptBorrowBuffer_id.nextval into :new.id from dual;
end;
/

CREATE or REPLACE PROCEDURE CptBorrowBuffer_Insert (
cptId_1 integer, useDate_1 char, deptId_1 integer, userId_1 integer, depositary_1 varchar2, 
remark_1 Varchar2;
flag out integer;
msg out varchar2;
thecursor IN OUT cursor_define.weavercursor)
AS
count_1 integer;
BEGIN
SELECT count(cptId) into count_1 FROM CptBorrowBuffer WHERE cptId = cptId_1;
if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
end if;
INSERT INTO CptBorrowBuffer (
cptId, useDate, deptId, userId, depositary, remark) VALUES (
cptId_1, useDate_1, deptId_1, userId_1, depositary_1, remark_1);
end;
/

insert into ErrorMsgIndex (id,indexdesc) values (36,'该资产已被申请借用！') 
/

insert into ErrorMsgInfo (indexid,msgname,languageid) values (36, '该资产已被申请借用！', 7) 
/
insert into ErrorMsgInfo (indexid,msgname,languageid) values (36, 'This capital has been applied to borrow!', 8) 
/


CREATE or replace PROCEDURE CptUseLogLend_IBCHK 
	(capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	integer,
	 useaddress_6 	varchar2,
	 userequest_7 	integer,
	 maintaincompany_8 	varchar2,
	 fee_9 	decimal,
	 usestatus_10 	varchar2,
	 remark_11 	varchar2,
	 costcenterid_12   integer)

AS 
begin
INSERT INTO CptUseLog 
	 (capitalid,
	 usedate,
	 usedeptid,
	 useresourceid,
	 usecount,
	 useaddress,
	 userequest,
	 maintaincompany,
	 fee,
	 usestatus,
	 remark) 
 
VALUES 
	(capitalid_1,
	 usedate_2,
	 usedeptid_3,
	 useresourceid_4,
	 usecount_5,
	 useaddress_6,
	 userequest_7,
	 maintaincompany_8,
	 fee_9,
	 '3',
	 remark_11);

Update CptCapital
Set 
departmentid = usedeptid_3,
resourceid   = useresourceid_4,
location	     =  useaddress_6,
stateid = usestatus_10
where id = capitalid_1;
end;
/


CREATE or REPLACE PROCEDURE CptBorrowBuffer_Check (
currDate char, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS
 m_recId integer;
 m_cptId integer;
 m_useDate char(10);
 m_deptId integer;
 m_userId integer;
 m_depositary varchar2(200);
 m_remark varchar2(4000);
begin
for all_cursor in
(SELECT id, cptId, useDate, deptId, userId, depositary, remark FROM CptBorrowBuffer)
loop
    m_recId:=all_cursor.id;
    m_cptId:=all_cursor.cptid;
    m_useDate:=all_cursor.useDate;
    m_deptId:=all_cursor.deptId;
    m_userId:=all_cursor.userId;
    m_depositary:=all_cursor.depositary;
    m_remark:=all_cursor.remark;
    
    IF (currDate = m_useDate) then
    	CptUseLogLend_IBCHK (m_cptId, m_useDate, m_deptId, m_userId, 1, m_depositary, 0, '', 0, '3', m_remark, 0 ) ;
		DELETE CptBorrowBuffer WHERE id = m_recId;
	END if;
	
end loop;    
end;
/
UPDATE HtmlLabelIndex SET indexdesc = '借用' WHERE id = 1379
/
UPDATE HtmlLabelInfo SET labelname = '借用' WHERE indexid = 1379 AND languageid = 7
/

UPDATE HtmlLabelIndex SET indexdesc = '借用日期' WHERE id = 1404
/
UPDATE HtmlLabelInfo SET labelname = '借用日期' WHERE indexid = 1404 AND languageid = 7
/

/*FOR BUG 579 需求：不能提交减损日期大于当日日期的资产减损流程 by 路鹏*/
insert into HtmlNoteIndex (id,indexdesc) values (57,'减损日期必须小于当前日期！') 
/

insert into HtmlNoteInfo (indexid,notename,languageid) values (57, '减损日期必须小于当前日期！', 7) 
/
insert into HtmlNoteInfo (indexid,notename,languageid) values (57, 'The selected date should be earlier than current.', 8) 
/

/*TD 589 */
insert into HtmlNoteIndex (id,indexdesc) values (60,'维修日期必须小于当前日期！') 
/

insert into HtmlNoteInfo (indexid,notename,languageid) values (60, '维修日期必须小于当前日期！', 7) 
/
insert into HtmlNoteInfo (indexid,notename,languageid) values (60, 'The repair date should be not later than current date!', 8) 
/

/*  FOR BUG 656 系统管理员无权限查看自己创建的文档(仅oracle)*/
CREATE or replace PROCEDURE DocShareDetail_SetByDoc
(
docid_1  integer ,
createrid_2  integer , 
owenerid_3  integer , 
usertype_4  integer , 
replydocid_5  integer , 
departmentid_6  integer , 
subcompanyid_7  integer ,
managerid_8 integer ,
considermanager_9 integer ,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
AS 
recordercount integer ;
allmanagerid varchar2(255);
tempuserid integer;
tempsharelevel integer ;
tempsharetype integer ;
sepindex integer ;		/* 逗号所在地位置 */

begin

    /* 如果是回复某一个文档的回复文档，将原文档的共享加入本回复文档的共享 */
    if replydocid_5 != 0 then
        insert into TM_DocShareDetail_User(userid,usertype,sharelevel) 
        select userid,usertype,sharelevel from DocShareDetail where docid = replydocid_5 ;
    end if ;

    /* 对于内部用户 */
    if usertype_4 = 1  then
        /* 文档的创建者和所有者具有编辑的权限 */
        select count(sharelevel) into recordercount  from TM_DocShareDetail_User where userid=createrid_2 and usertype = 1 ;
        if recordercount = 0 then
            insert into TM_DocShareDetail_User(userid,usertype,sharelevel) values(createrid_2,1,2) ;
        else 
            update TM_DocShareDetail_User set sharelevel = 2 where userid=createrid_2 and usertype = 1 ;
        end if ;
        
        select count(sharelevel) into recordercount  from TM_DocShareDetail_User where userid=owenerid_3 and usertype = 1 ;
        if recordercount = 0 then
            insert into TM_DocShareDetail_User(userid,usertype,sharelevel) values(owenerid_3,1,2) ;
        else 
            update TM_DocShareDetail_User set sharelevel = 2 where userid=owenerid_3 and usertype = 1 ;
        end if ;
        
        /* 如果需要考虑所有经理这条线，所有上级经理有查看权限 */
        if considermanager_9 = 1 and createrid_2 != 1 then
            select concat(managerstr,'0') into allmanagerid  from HrmResource where id = createrid_2  ;
            sepindex := instr(allmanagerid , ',', 1, 1) ;
            
            while  sepindex != 0 LOOP
                tempuserid := TO_NUMBER(SUBSTR(allmanagerid,1,sepindex-1)) ;
                allmanagerid := SUBSTR(allmanagerid,sepindex+1) ;
                sepindex := instr(allmanagerid , ',', 1, 1) ;

                select count(sharelevel) into recordercount  from TM_DocShareDetail_User where userid=tempuserid and usertype = 1 ;
                if recordercount = 0 then
                    insert into TM_DocShareDetail_User(userid,usertype,sharelevel) values(tempuserid,1,1) ;
                end if ;
            end LOOP;
            
            if owenerid_3 != createrid_2 then
                select concat(managerstr,'0') into allmanagerid  from HrmResource where id = owenerid_3  ;
                sepindex := instr(allmanagerid , ',', 1, 1) ;
                
                while  sepindex != 0 LOOP
                    tempuserid := TO_NUMBER(SUBSTR(allmanagerid,1,sepindex-1)) ;
                    allmanagerid := SUBSTR(allmanagerid,sepindex+1) ;
                    sepindex := instr(allmanagerid , ',', 1, 1) ;

                    select count(sharelevel) into recordercount  from TM_DocShareDetail_User where userid=tempuserid and usertype = 1 ;
                    if recordercount = 0 then
                        insert into TM_DocShareDetail_User(userid,usertype,sharelevel) values(tempuserid,1,1) ;
                    end if ;
                end LOOP;
            end if ;
        end if ;
    /* 对于外部用户 */
    else  
        /* 文档的创建者（客户）和创建者（客户）的经理具有编辑的权限 */
        select count(sharelevel) into recordercount  from TM_DocShareDetail_User where userid=createrid_2 and usertype = 9 ;
        if recordercount = 0 then 
            insert into TM_DocShareDetail_User(userid,usertype,sharelevel) values(createrid_2,9,2) ;
        else 
            update TM_DocShareDetail_User set sharelevel = 2 where userid=createrid_2 and usertype = 9 ;
        end if ;
        
        select count(sharelevel) into recordercount  from TM_DocShareDetail_User where userid=managerid_8 and usertype = 1 ;
        if recordercount = 0 then 
            insert into TM_DocShareDetail_User(userid,usertype,sharelevel) values(managerid_8,1,2) ;
        else 
            update TM_DocShareDetail_User set sharelevel = 2 where userid=managerid_8 and usertype = 1 ;
        end if ;
        
        /* 如果需要考虑所有经理这条线，所有上级经理有查看权限 */
        if considermanager_9 = 1 and createrid_2 != 1 then
            select concat(managerstr,'0') into allmanagerid  from HrmResource where id = managerid_8  ;
            sepindex := instr(allmanagerid , ',', 1, 1) ;
            
            while  sepindex != 0 LOOP
                tempuserid := TO_NUMBER(SUBSTR(allmanagerid,1,sepindex-1)) ;
                allmanagerid := SUBSTR(allmanagerid,sepindex+1) ;
                sepindex := instr(allmanagerid , ',', 1, 1) ;

                select count(sharelevel) into recordercount  from TM_DocShareDetail_User where userid=tempuserid and usertype = 1 ;
                if recordercount = 0 then
                    insert into TM_DocShareDetail_User(userid,usertype,sharelevel) values(tempuserid,1,1) ;
                end if ;
            end LOOP;
        end if ;
    end if ;

    /* 文档共享信息 (内部用户) 不涉及角色部分 */
    for shareuserid_cursor IN (
    select distinct t1.id , t2.sharelevel from HrmResource t1 ,  DocShare  t2 where  t1.loginid is not null and t2.docid = docid_1 and ( (t2.foralluser=1 and t2.seclevel<=t1.seclevel)  or ( t2.userid= t1.id ) or (t2.departmentid=t1.departmentid and t2.seclevel<=t1.seclevel)) )
    loop
        tempuserid := shareuserid_cursor.id;
        tempsharelevel := shareuserid_cursor.sharelevel;
        select count(sharelevel) into recordercount  from TM_DocShareDetail_User where userid=tempuserid and usertype = 1 ;
        if recordercount = 0  then 
            insert into TM_DocShareDetail_User(userid,usertype,sharelevel) values(tempuserid,1,tempsharelevel) ;
        else 
            if tempsharelevel = 2 then
                update TM_DocShareDetail_User set sharelevel = 2 where userid=tempuserid and usertype = 1 ;
            end if ;
        end if ;
    end loop ;

    /* 文档共享信息 (内部用户) 涉及角色部分 */
    for shareuserid_cursor IN (
    select distinct t1.id , t2.sharelevel from HrmResource t1 ,  DocShare  t2,  HrmRoleMembers  t3 where  t1.loginid is not null and t2.docid = docid_1 and (  t3.resourceid=t1.id and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and ( (t3.rolelevel=2) or (t3.rolelevel=0  and t1.departmentid=departmentid_6) or (t3.rolelevel=1 and t1.subcompanyid1=subcompanyid_7) ) ) )
    loop
        tempuserid := shareuserid_cursor.id;
        tempsharelevel := shareuserid_cursor.sharelevel;
        select count(sharelevel) into recordercount  from TM_DocShareDetail_User where userid=tempuserid and usertype = 1 ;
        if recordercount = 0 then 
            insert into TM_DocShareDetail_User(userid,usertype,sharelevel) values(tempuserid,1,tempsharelevel) ;
        else 
            if tempsharelevel = 2 then 
                update TM_DocShareDetail_User set sharelevel = 2 where userid=tempuserid and usertype = 1 ;
            end if ;
        end if ;
    end loop ;

    /* 文档共享信息 外部用户 ( 类型 ) */
    for shareuserid_cursor IN (
    select distinct sharetype , seclevel, sharelevel from DocShare where sharetype < 0 and docid = docid_1 )
    loop
        tempsharetype := shareuserid_cursor.sharetype;
        tempuserid := shareuserid_cursor.seclevel;
        tempsharelevel := shareuserid_cursor.sharelevel;
        select count(sharelevel) into recordercount  from TM_DocShareDetail_User where userid=tempuserid and usertype = tempsharetype ;
        if recordercount = 0 then 
            insert into TM_DocShareDetail_User(userid,usertype,sharelevel) values(tempuserid,tempsharetype,tempsharelevel) ;
        else 
            if tempsharelevel = 2 then
                update TM_DocShareDetail_User set sharelevel = 2 where userid=tempuserid and usertype = tempsharetype ;
            end if ;
        end if ;
    end loop ;

    /* 文档共享信息 外部用户 ( 用户id ) */
    for shareuserid_cursor IN (
    select distinct crmid , sharelevel from DocShare where crmid <> 0 and sharetype = '9' and docid = docid_1 )
    loop
        tempuserid := shareuserid_cursor.crmid;
        tempsharelevel := shareuserid_cursor.sharelevel;
        select count(sharelevel) into recordercount  from TM_DocShareDetail_User where userid=tempuserid and usertype = 9 ;
        if recordercount = 0 then 
            insert into TM_DocShareDetail_User(userid,usertype,sharelevel) values(tempuserid,9,1) ;
        else 
            if tempsharelevel = 2 then 
                update TM_DocShareDetail_User set sharelevel = 2 where userid=tempuserid and usertype = 9 ;
            end if ;
        end if ;
    end loop ;

    /* 将临时表中的数据写入共享表 */
    delete docsharedetail where docid = docid_1 ;
    insert into docsharedetail (docid,userid,usertype,sharelevel) 
        select docid_1 , userid,usertype,sharelevel from TM_DocShareDetail_User ;
end ;
/

/*  FOR BUG 670 浏览按钮表现形式的‘ 资产种类’类型名称修改为‘产品种类’*/
update workflow_browserurl  set labelid=15106 where id=13
/

/*  FOR BUG 675 允许流程表单名称输入50个汉字或字符*/
ALTER TABLE workflow_formbase MODIFY (formname varchar2(100),formdesc varchar2(200))
/

/*  FOR BUG 741  称呼设置新建和编辑页面的‘使用’字段名称修改为‘ 使用方法’*/

INSERT INTO HtmlLabelIndex values(17504,'使用方法') 
/
INSERT INTO HtmlLabelInfo VALUES(17504,'使用方法',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17504,'Usage',8) 
/

/*TD 746 */
CREATE or REPLACE PROCEDURE CRM_AddressType_Delete (id_1 integer, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
AS
count_1 integer;
begin
    SELECT count(typeid) into count_1 FROM CRM_CustomerAddress WHERE typeid = id_1;
if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
end if;
  DELETE CRM_AddressType WHERE ( id	 = id_1);
end;
/

/*TD 750 */
CREATE or REPLACE PROCEDURE CRM_ContactWay_Delete (
id_1 	integer, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
AS 
count_1 integer;
begin
    SELECT count(id) into count_1 FROM CRM_CustomerInfo WHERE source = id_1;
if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
end if;
DELETE CRM_ContactWay WHERE ( id= id_1);
end;
/

/*TD 758 */
INSERT INTO HtmlLabelIndex values(17507,'上级行业') 
/
INSERT INTO HtmlLabelInfo VALUES(17507,'上级行业',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17507,'The superior trade',8) 
/

/*TD 760 */
insert into HtmlNoteIndex (id,indexdesc) values (62,'上下级行业不能一样。') 
/
insert into HtmlNoteInfo (indexid,notename,languageid) values (62, '上下级行业不能一样。', 7) 
/
insert into HtmlNoteInfo (indexid,notename,languageid) values (62, 'The parent vacation can not be himself.', 8) 
/

/*TD 761 */
CREATE or REPLACE PROCEDURE CRM_SectorInfo_Delete 
  (id_1 integer, 
  flag out integer,
  msg out varchar2, 
  thecursor IN OUT cursor_define.weavercursor) 
  AS 
  count_1 integer;
  begin
  SELECT count(id) into count_1 FROM CRM_CustomerInfo WHERE sector = id_1;
  if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;

  SELECT count(id) into count_1 FROM CRM_SectorInfo WHERE sectors LIKE CONCAT('%,', CONCAT(to_char(id_1), ',%'));
  if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;
  DELETE CRM_SectorInfo WHERE ( id= id_1);
  end;
/

/*TD 764 */
  CREATE or REPLACE PROCEDURE CRM_CustomerSize_Delete 
  (id_1 integer,
  flag out integer,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor) 
  AS
   count_1 integer;
  begin
    SELECT count(id) into count_1 FROM CRM_CustomerInfo WHERE size_n = id_1;
  if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;
  DELETE CRM_CustomerSize WHERE ( id= id_1);
  end;
/
/*TD 771 */
  CREATE or REPLACE PROCEDURE CRM_CustomerType_Delete 
   (id_1 int,   
   flag out integer,
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor) 
  AS 
count_1 integer;
begin
SELECT count(id) into count_1 FROM CRM_CustomerInfo WHERE type = id_1;
   if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;
  DELETE CRM_CustomerType WHERE ( id = id_1);
end;
/

/*TD 776 */
  CREATE or REPLACE PROCEDURE CRM_CustomerDesc_Delete 
  (id_1	int,
   flag out integer,
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor) 
  AS
  count_1 integer;
  begin
  SELECT count(id) into count_1 FROM CRM_CustomerInfo WHERE description = id_1;
if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;
  DELETE CRM_CustomerDesc WHERE ( id= id_1);
end;
/

/* TD 780*/
CREATE or REPLACE PROCEDURE CRM_Evaluation_L_Select (
   flag out integer,
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for
SELECT * FROM CRM_Evaluation_Level ORDER BY levelvalue;
end;
/

CREATE or REPLACE PROCEDURE CRM_Evaluation_Init 
AS
m_crmId integer;
m_crmValue decimal(10, 2);
m_evaId integer;
m_evaValue integer;
m_flag char(1);
begin
for all_cursor in
(SELECT id, evaluation FROM CRM_CustomerInfo)
loop
    m_crmId:=all_cursor.id;
    m_crmValue:=all_cursor.evaluation;
    IF m_crmValue IS NOT NULL then
        m_flag := '0';
        for all_cursor in
        (SELECT id, levelvalue FROM CRM_Evaluation_Level ORDER BY levelvalue)
        loop
            m_evaId:=all_cursor.id;
            m_crmValue:=all_cursor.levelvalue;
            IF m_crmValue <= m_evaValue then
                UPDATE CRM_CustomerInfo SET evaluation = m_evaId WHERE id = m_crmId;
                 m_flag := '1';
                exit;
            END if;
        end loop;
     END if;
        IF (m_flag = '0') then
           UPDATE CRM_CustomerInfo SET evaluation = NULL WHERE id = m_crmId;         
        end if;
 end loop;
END;
/
call CRM_Evaluation_Init ()
/

DROP PROCEDURE CRM_Evaluation_Init
/
ALTER TABLE CRM_CustomerInfo add evaluation_t integer
/
update CRM_CustomerInfo set evaluation_t=evaluation
/
ALTER TABLE CRM_CustomerInfo drop column evaluation
/
ALTER TABLE CRM_CustomerInfo add evaluation integer
/
update CRM_CustomerInfo set evaluation=evaluation_t
/
ALTER TABLE CRM_CustomerInfo drop column evaluation_t
/

CREATE or REPLACE PROCEDURE CRM_Evaluation_L_Delete
	(id_1 integer,   
    flag out integer,
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor)
AS 
count_1 integer;
begin
SELECT count(id) into count_1 FROM CRM_CustomerInfo WHERE evaluation = id_1;
if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
end if;
DELETE CRM_Evaluation_Level WHERE id = id_1;
end;
/

/*TD 786 */
insert into SystemRights (id,rightdesc,righttype) values (443,'销售机会维护','0') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (443,7,'销售机会维护','销售机会维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (443,8,'Sales Chance Maintenance','Sales Chance Maintenance') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3134,'销售机会维护','CrmSalesChance:Maintenance',443) 
/
 
insert into SystemRightToGroup (groupid, rightid) values (6, 443)
/

insert into SystemRightRoles (rightid, roleid, rolelevel) values (443, 8, '2')
/

/*TD 788 */
CREATE or REPLACE PROCEDURE CRM_SellStatus_Delete 
 (id_1	integer,
   flag out integer,
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor) 
 AS 
  count_1 integer;
  begin
 SELECT count(id) into count_1 FROM CRM_SellChance WHERE sellstatusid = id_1;
if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;
 DELETE CRM_SellStatus  WHERE ( id= id_1);
 end;
 /
/*TD 791*/
CREATE or REPLACE PROCEDURE CRM_Successfactor_Delete 
 (id_1	integer,
   flag out integer,
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor) 
 AS 
   count_1 integer;
  begin
SELECT count(id) into count_1 FROM CRM_SellChance WHERE sufactor = id_1;
if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;
 DELETE CRM_Successfactor  WHERE ( id= id_1);
 end;
 /

/*TD 794*/
CREATE or REPLACE PROCEDURE CRM_Failfactor_Delete 
 (id_1	integer,
   flag out integer,
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor) 
 AS
    count_1 integer;
  begin
SELECT count(id) into count_1 FROM CRM_SellChance WHERE defactor = id_1;
if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;
 DELETE CRM_Failfactor  WHERE ( id	 = id_1) ;
end;
/

/*TD 795*/
CREATE or REPLACE PROCEDURE CRM_ContractType_Delete
	(id_1 	integer ,
   flag out integer,
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor)
AS 
  count_1 integer;
  begin
SELECT count(id) into count_1 FROM CRM_Contract WHERE typeId = id_1;
if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;
DELETE CRM_ContractType WHERE ( id	 = id_1);
end;
/

/* TD 828*/
INSERT INTO HtmlLabelIndex values(17539,'使用新地址') 
/
INSERT INTO HtmlLabelInfo VALUES(17539,'使用新地址',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17539,'Use New Address',8) 
/

INSERT INTO HtmlLabelIndex values(17540,'恢复默认地址') 
/
INSERT INTO HtmlLabelInfo VALUES(17540,'恢复默认地址',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17540,'Roll Back',8) 
/ 
/*td:829 不能正确删除销售状态*/
 CREATE OR REPLACE PROCEDURE CRM_SellStatus_SelectByID 
 (id_1 integer,
 flag out integer ,
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS
begin
open thecursor for 
SELECT * FROM CRM_SellStatus WHERE ( id  = id_1)  ;
end;
/

 CREATE OR REPLACE PROCEDURE CRM_SellStatus_Delete
 (id_1    integer,
   flag out integer,
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor)
 AS
  count_1 integer;
  begin
 SELECT count(id) into count_1 FROM CRM_SellChance WHERE sellstatusid = id_1;
if count_1 <> 0 then
    open thecursor for
    select -1 from dual;
    return;
  end if;
 DELETE CRM_SellStatus  WHERE ( id= id_1);
 end;
/
