create table DocDetailContent (
docid integer primary key ,
doccontent clob
)
/

insert into DocDetailContent(docid, doccontent) select id , doccontent from docdetail 
/

alter table DocDetail drop column doccontent
/


create GLOBAL TEMPORARY TABLE TM_DocShareDetail_User
( userid integer,
  usertype integer,
  sharelevel integer ) 
ON COMMIT DELETE ROWS
/

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
        if considermanager_9 = 1 then
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
        if considermanager_9 = 1 then
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
