
CREATE OR REPLACE PROCEDURE cowork_sys_update as begin declare val_coworkid integer; val_discussid integer; val_floorNum integer; var_isnew clob; var_important clob; var_coworkers clob; var_creater varchar2(4000); var_principal varchar2(4000); val_splitChar varchar2(4000); var_userid varchar(10); pos1 integer; pos2 integer; cursor cursor0 is select id,isnew,userids,coworkers,creater,principal from cowork_items; cursor cursor1 is select id from cowork_discuss where coworkid=val_coworkid order by createdate asc,createtime asc; begin if cursor0%isopen = false then open cursor0; end if;  fetch cursor0 into val_coworkid,var_isnew,var_important,var_coworkers,var_creater,var_principal; while cursor0%found loop   while length(var_coworkers)<>0 loop  if length(var_coworkers)>4000 then pos1:=DBMS_LOB.INSTR(var_coworkers,',',3500,1); insert into coworkshare(sourceid,type,content,seclevel,sharelevel,srcfrom) values(val_coworkid,1,DBMS_LOB.substr(var_coworkers,pos1,1),0,1,1); var_coworkers:=DBMS_LOB.substr(var_coworkers,length(var_coworkers),pos1); else insert into coworkshare(sourceid,type,content,seclevel,sharelevel,srcfrom) values(val_coworkid,1,var_coworkers,0,1,1); var_coworkers:=''; end if; end loop; insert into coworkshare (sourceid,type,content,seclevel,sharelevel,srcfrom) values(val_coworkid,1,var_creater,0,2,2); insert into coworkshare (sourceid,type,content,seclevel,sharelevel,srcfrom) values(val_coworkid,1,var_principal,0,2,3);  while length(var_isnew)<>0 loop pos1:=DBMS_LOB.INSTR(var_isnew,',',1,1); pos2:=instr(DBMS_LOB.substr(var_isnew,length(var_isnew),DBMS_LOB.INSTR(var_isnew,',',1,1)+1),',',1,1); var_userid:=DBMS_LOB.substr(var_isnew,pos2-pos1,DBMS_LOB.INSTR(var_isnew,',',1,1)+1); if var_userid is not null then insert into cowork_read(coworkid,userid) values(val_coworkid,var_userid); end if; var_isnew:=DBMS_LOB.substr(var_isnew,length(var_isnew),instr(DBMS_LOB.substr(var_isnew,length(var_isnew),DBMS_LOB.INSTR(var_isnew,',',1,1)+1),',',1,1)+1); end loop;  if var_important is not null and length(var_important)<>0 then var_important:=','||var_important; end if ; while length(var_important)<>0 loop pos1:=DBMS_LOB.INSTR(var_important,',',1,1); pos2:=instr(DBMS_LOB.substr(var_important,length(var_important),DBMS_LOB.INSTR(var_important,',',1,1)+1),',',1,1); var_userid:=DBMS_LOB.substr(var_important,pos2-pos1,DBMS_LOB.INSTR(var_important,',',1,1)+1); if var_userid is not null then insert into cowork_important(coworkid,userid) values(val_coworkid,var_userid); end if; var_important:=DBMS_LOB.substr(var_important,length(var_important),instr(DBMS_LOB.substr(var_important,length(var_important),DBMS_LOB.INSTR(var_important,',',1,1)+1),',',1,1)+1); end loop;  val_floorNum:=1; open cursor1; fetch cursor1 into val_discussid; while cursor1%found loop update cowork_discuss set floorNum=val_floorNum,replayid=0 where id=val_discussid; val_floorNum:=val_floorNum+1; fetch cursor1 into val_discussid; end loop; close cursor1;  fetch cursor0 into val_coworkid,var_isnew,var_important,var_coworkers,var_creater,var_principal; end loop;  close cursor0; end; end;
/
CREATE OR REPLACE PROCEDURE CptBorrowBuffer_Check ( currDate char, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS m_recId integer; m_cptId integer; m_useDate char(10); m_deptId integer; m_userId integer; m_depositary varchar2(4000); m_remark varchar2(4000); begin for all_cursor in (SELECT id, cptId, useDate, deptId, userId, depositary, remark FROM CptBorrowBuffer) loop m_recId:=all_cursor.id; m_cptId:=all_cursor.cptid; m_useDate:=all_cursor.useDate; m_deptId:=all_cursor.deptId; m_userId:=all_cursor.userId; m_depositary:=all_cursor.depositary; m_remark:=all_cursor.remark;  IF (currDate >= m_useDate) then CptUseLogLend_IBCHK (m_cptId, m_useDate, m_deptId, m_userId, 1, m_depositary, 0, '', 0, '3', m_remark, 0 ) ; DELETE CptBorrowBuffer WHERE id = m_recId; END if;  end loop; end;
/
CREATE OR REPLACE PROCEDURE CptUseLogInStock2_Insert (capitalid_1 	integer, usedate_2 	char, usecount_5 	integer, userequest_7  integer, remark_11 	varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  AS departmentid_1  integer; resourceid_1 integer; location_1 varchar2(4000); num_1 integer; recordcount integer; begin  select 	count(*) into recordcount from CptCapital where id = capitalid_1; if recordcount > 0 then  select 	departmentid,resourceid,location,capitalnum into departmentid_1, resourceid_1,location_1,num_1 from CptCapital where id = capitalid_1; end if ;  INSERT INTO CptUseLog ( capitalid, usedate, usedeptid, useresourceid, usecount, useaddress, userequest, maintaincompany, fee, usestatus, remark)  VALUES ( capitalid_1, usedate_2, departmentid_1, resourceid_1, usecount_5, location_1, userequest_7, '', 0, '1', remark_11);  Update CptCapital Set capitalnum = num_1+usecount_5 where id = capitalid_1; end;
/
CREATE OR REPLACE PROCEDURE CRMRLOGDATE_UPDATE_BY_CRMID (crmid_1 number, flag	out integer, msg   out	varchar2, thecursor IN OUT cursor_define.weavercursor )  AS m_begindate varchar2(4000); BEGIN SELECT MAX(begindate) INTO m_begindate FROM WorkPlan WHERE type_n = '3' and concat(concat(',' , crmid), ',') LIKE concat(concat('%,' ,crmid_1),',%');  UPDATE CRM_ContacterLog_Remind SET lastestContactDate = m_begindate WHERE customerid = crmid_1; END;
/
CREATE OR REPLACE PROCEDURE CRM_ContactLog_WorkPlan ( flag out integer  , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS m_logid integer; m_customerid integer; m_resourceid integer; m_subject varchar2(4000); m_contactdate char(10); m_contacttime char(8); m_enddate char(10); m_endtime char(10); m_contactinfo varchar2(4000); m_documentid integer; m_submitdate char(10); m_submittime char(8); m_isfinished smallint; m_isprocessed smallint; m_agentid integer; m_status char(1); m_workid integer; m_userid integer; m_usertype integer; m_deptId integer; m_subcoId integer; m_id integer; begin for  all_cursor  in( SELECT id, customerid, resourceid, subject, contactdate, contacttime, enddate, endtime, contactinfo, documentid, submitdate, submittime, isfinished, isprocessed, agentid FROM CRM_ContactLog) loop m_logid := all_cursor.id; m_customerid := all_cursor.customerid; m_resourceid := all_cursor.resourceid; m_subject := all_cursor.subject; m_contactdate := all_cursor.contactdate; m_contacttime := all_cursor.contacttime; m_enddate := all_cursor.enddate; m_endtime := all_cursor.endtime; m_contactinfo := all_cursor.contactinfo; m_documentid := all_cursor.documentid; m_submitdate := all_cursor.submitdate; m_submittime := all_cursor.submittime; m_isfinished := all_cursor.isfinished; m_isprocessed := all_cursor.isprocessed; m_agentid := all_cursor.agentid; IF (m_subject <> 'Create') then  IF m_isfinished = 0 then m_status := '0'; elsif m_isprocessed = 0 then m_status := '1'; ELSE m_status := '2'; end if;  INSERT INTO WorkPlan ( type_n, urgentLevel, crmid, resourceid, name, begindate, begintime, enddate, endtime, description, docid, createdate, createtime,agentId, status, createrid) VALUES ('3', '1', m_customerid, m_resourceid, m_subject, m_contactdate, m_contacttime,m_enddate, m_endtime, m_contactinfo, m_documentid, m_submitdate, m_submittime, m_agentid, m_status, m_resourceid);  SELECT MAX(id) into m_workid  FROM WorkPlan;  select count(id) into m_id FROM CRM_SellChance WHERE comefromid = m_logid; if m_id <> 0 then UPDATE CRM_SellChance SET comefromid = m_workid WHERE comefromid = m_logid; end if;  SELECT departmentid, subcompanyid1 into m_deptId  , m_subcoId  FROM HrmResource WHERE id = m_resourceid; UPDATE WorkPlan SET deptId = m_deptId, subcompanyId = m_subcoId where id = m_workid;  INSERT INTO WorkPlanShare (workPlanId,shareType,userId,deptId,roleId,forAll,roleLevel,securityLevel,shareLevel,isdefault) SELECT m_workid,sharetype,seclevel,rolelevel,userid,departmentid,roleid,foralluser,0,1 FROM CRM_ShareInfo WHERE relateditemid = m_customerid; end if; end loop; end;
/
CREATE OR REPLACE PROCEDURE CRM_SectorRpSum (parentid_1	varchar, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS tempstr_1 varchar2(4000); tempid_1 integer; begin tempstr_1 :='%,'|| parentid_1 ||',%' ; tempid_1 := cast(parentid_1 as integer); open thecursor for select count(id)  from crm_customerinfo where sector in(select id from crm_sectorinfo where id=tempid_1 or sectors like tempstr_1); end;
/
CREATE OR REPLACE PROCEDURE DocFrontpage_SelectAllId ( pagenumber_1     integer, perpage_1        integer, countnumber_1    integer, logintype_1		integer, usertype_1		integer, userid_1			integer, userseclevel_1	integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as pagecount_1 integer ; pagecount2_1 integer ; id_1    integer; docsubject_1 varchar2(4000); doccreatedate_1 char(10); doccreatetime_1  char(8);   CURSOR all_cursor01 is select * from( Select distinct  n.id, n.docsubject , n.doccreatedate , n.doccreatetime from DocDetail n , DocShareDetail d where n.id=d.docid and d.userid=userid_1 and d.usertype = 1 and  (n.docpublishtype='2' or n.docpublishtype='3') and n.docstatus in('1','2','5') order by n.doccreatedate desc , n.doccreatetime desc ) where rownum<(pagecount_1+1);   CURSOR all_cursor02 is select * from( Select  n.id , n.docsubject , n.doccreatedate , n.doccreatetime from DocDetail n , DocShareDetail d where n.id=d.docid and d.usertype=usertype_1 and d.userid<=userseclevel_1 and (n.docpublishtype='2' or n.docpublishtype='3') and n.docstatus in('1','2','5') order by n.doccreatedate desc, n.doccreatetime desc ) where rownum< (pagecount_1+1);  begin  pagecount_1 :=  pagenumber_1 * perpage_1; if (countnumber_1 -(pagenumber_1 - 1)*perpage_1) < perpage_1 then pagecount2_1 := countnumber_1-(pagenumber_1 - 1) * perpage_1; else pagecount2_1 := perpage_1 ; end if;  if  logintype_1 = 1 then open all_cursor01; loop fetch all_cursor01 INTO id_1,docsubject_1,doccreatedate_1, doccreatetime_1; exit when all_cursor01%NOTFOUND; insert into temp_table_04 (id,docsubject,doccreatedate, doccreatetime) values (id_1,docsubject_1,doccreatedate_1, doccreatetime_1) ; end  loop; open thecursor for select * from (select * from temp_table_04 order by doccreatedate, doccreatetime) where rownum<(pagecount2_1+1); end if;  if   logintype_1<>1  then open all_cursor02; loop fetch all_cursor02 INTO id_1,docsubject_1,doccreatedate_1, doccreatetime_1; exit when all_cursor02%NOTFOUND; insert into temp_table_04 (id,docsubject,doccreatedate, doccreatetime) values (id_1,docsubject_1,doccreatedate_1, doccreatetime_1) ; end  loop; open thecursor for select * from(select * from temp_table_04 order by doccreatedate, doccreatetime) where rownum< (pagecount2_1+1); end if;  end;
/
CREATE or replace PROCEDURE DocShareDetail_SetByDoc 
(
  docid_1  integer,
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
  tempsharelevelold integer ;
  tempsharetype integer ;
  sepindex integer;
  crmManagerId integer;
  crmManagerUpIds varchar2(100);
  hrmManager integer;
  hrmJmangers varchar2(50);
  hrmallmanagerid varchar2(255);
  tempseclevel integer;
  hrmallmanagerid_re varchar2(255);
  temppos integer;
  tempHrmManager integer;
  tempDownUserId integer;
  subCompId integer;
  sameSubUserId integer;
  departmentId integer;
  sameDepartUserId integer;
  recordcounts  integer;
  recordcounts1  integer;
    recordcounts2  integer;
    recordcounts3  integer;
    recordcounts4  integer;
    recordcounts5  integer;

begin

  if (usertype_4 <>1) 
    then
    for shareuserid_cursor in(
       select  sharetype,sharelevel,userid from  docshare  where docid=docid_1 and  sharetype between  -82 and -80)
    loop
      tempsharetype := shareuserid_cursor.sharetype; 
      tempsharelevel := shareuserid_cursor.sharelevel; 
      tempuserid := shareuserid_cursor.userid; 
      if (tempsharetype=-80)   
        then
        if (tempsharelevel!=0) 
          then
          insert into temptablevalue_3 values (tempuserid,2, tempsharelevel);
          if createrid_2!=owenerid_3 
            then
            insert into temptablevalue_3 values (owenerid_3,2, tempsharelevel);
          end if;
        end if;             
      elsif (tempsharetype=-81)  
        then 
        select manager into crmManagerId from CRM_CustomerInfo  where id=tempuserid;

        if (tempsharelevel!=0) 
          then
          insert into temptablevalue_3(userid,usertype,sharelevel) values(crmManagerId,1,tempsharelevel);      
        end if; 
      
       elsif (tempsharetype=-82)  
        then        
        select manager into crmManagerId from CRM_CustomerInfo  where id=tempuserid;
        select concat(managerstr,'0') into crmManagerUpIds  from  hrmresource where id =crmManagerId;
        sepindex := INSTR(crmManagerUpIds,','); 
        while  sepindex != 0 
        loop 
          tempuserid := to_number( SUBSTR(crmManagerUpIds,1,(sepindex-1)));
          crmManagerUpIds := SUBSTR(crmManagerUpIds,(sepindex+1),(length(crmManagerUpIds)-sepindex));
          sepindex := INSTR(crmManagerUpIds,',');
          if tempsharelevel != 0
            then
            insert into temptablevalue_3(userid,usertype,sharelevel) values(tempuserid,1,tempsharelevel);
          end if;  
        end loop;
      end if;  
    end loop;

  else  
    for shareuserid_cursor in(
    select  sharetype,sharelevel,userid,seclevel from  docshare  where docid=docid_1 and  sharetype  between  
    80 and 85)
    loop 
      tempsharetype := shareuserid_cursor.sharetype;
      tempsharelevel := shareuserid_cursor.sharelevel;
      tempuserid := shareuserid_cursor.userid;
      tempseclevel :=shareuserid_cursor.seclevel;
      if (tempsharetype=80)  
        then
        if (tempsharelevel!=0)
          then       
          tempsharelevelold := 0;
          
          
          select count(sharelevel) into recordcounts   from temptablevalue_3 where userid=tempuserid   
          and usertype=1; 

          if recordcounts> 0then
          select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=tempuserid   
          and usertype=1; 
          end if;


            recordcounts:=0;  
          
          

          if (tempsharelevelold=0) 
            then
            insert into  temptablevalue_3(userid,usertype,sharelevel) 
            values(tempuserid,1,tempsharelevel); 
          elsif (tempsharelevel>tempsharelevelold) 
            then
            update temptablevalue_3  set sharelevel=tempsharelevel where userid=tempuserid  and 
            usertype=1;
          end if;

          if createrid_2!=owenerid_3 
            then
            tempsharelevelold :=0;
            select sharelevel into tempsharelevelold  from temptablevalue_3 where 
            userid=owenerid_3  and usertype=1;  
            if (tempsharelevelold=0) 
              then
              insert into  temptablevalue_3(userid,usertype,sharelevel)values(owenerid_3,1,tempsharelevel);
            elsif(tempsharelevel>tempsharelevelold)
              then
              update temptablevalue_3  set sharelevel=tempsharelevel where userid=owenerid_3  
              and usertype=1;
            end if;
          end if;
        end if; 

      elsif (tempsharetype=81)  
        then               
        if (tempsharelevel!=0)
          then   
          select managerid into hrmManager  from hrmresource where id=tempuserid;                      

          if hrmManager >=0
            then
            tempsharelevelold := 0;


          select count(sharelevel) into recordcounts1   from temptablevalue_3 where userid=hrmManager   
          and usertype=1; 

          if recordcounts1> 0then
          select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=hrmManager   
          and usertype=1; 
          end if;

             


         
            if (tempsharelevelold=0) 
              then
              insert into  temptablevalue_3(userid,usertype,sharelevel) 
              values(hrmManager,1,tempsharelevel);
      
            elsif (tempsharelevel>tempsharelevelold)
              then
              update temptablevalue_3  set sharelevel=tempsharelevel where userid=hrmManager;
            end if;
          end if;           
        end if;
      elsif (tempsharetype=82)  
        then
        if (tempsharelevel!=0)
          then   
          select  managerstr into hrmallmanagerid   from hrmresource where id=tempuserid;
          hrmallmanagerid_re :=  to_char(hrmallmanagerid) ;
          temppos := INSTR(hrmallmanagerid_re, ',') ;
          temppos := INSTR(hrmallmanagerid_re,',',temppos+1);
          if  temppos <>0 
            then
               hrmallmanagerid_re := SUBSTR(hrmallmanagerid_re,temppos,length(hrmallmanagerid_re));
          end if; 
          hrmJmangers := to_char(hrmallmanagerid_re);
          sepindex := INSTR(hrmJmangers,',')  ;
          while  (sepindex != 0)
            loop 
            tempHrmManager := to_number( SUBSTR (hrmJmangers,1,(sepindex-1))); 
            hrmJmangers := SUBSTR(hrmJmangers,(sepindex+1),(length(hrmJmangers)-sepindex));       
            sepindex := INSTR(hrmJmangers,',') ; 
            tempsharelevelold := 0;
            select sharelevel into tempsharelevelold  from temptablevalue_3 where 
            userid=tempHrmManager  and usertype=1;   
            if (tempsharelevelold=0) 
              then
              insert into  temptablevalue_3(userid,usertype,sharelevel)values(tempHrmManager,1,tempsharelevel);
            elsif (tempsharelevel>tempsharelevelold)
              then 
              update temptablevalue_3  set sharelevel=tempsharelevel where userid=tempHrmManager and 
              usertype=1 ;
            end if;  
          end  loop;  
        end if;
      elsif (tempsharetype=83)  
        then
        if (tempsharelevel!=0)
          then
          for temp_cursor in(
          select id from  hrmresource where concat(',',managerstr) like 
          concat(concat('%,',to_char(tempuserid)),',%') and seclevel>=tempseclevel and loginid is not 
          null and loginid is not null)
          loop
            tempDownUserId := temp_cursor.id;
            tempsharelevelold := 0;
            select sharelevel into tempsharelevelold  from temptablevalue_3 where 
            userid=tempDownUserId and usertype=1 ;  
            if (tempsharelevelold=0)
              then 
              insert into  temptablevalue_3(userid,usertype,sharelevel) values(tempDownUserId,1,tempsharelevel);
            elsif (tempsharelevel>tempsharelevelold) 
              then
              update temptablevalue_3  set sharelevel=tempsharelevel where userid=tempDownUserId  
              and usertype=1;
            end if;  
          end loop;
        end if;
      elsif (tempsharetype=84)   
        then
        if (tempsharelevel!=0)
          then
          select subcompanyid1 into subCompId   from  hrmresource where id=tempuserid;
          for temp_cursor in(
          select id from  hrmresource where subcompanyid1=subCompId and seclevel>=tempseclevel   and 
          loginid is not null)
          loop
            sameSubUserId := temp_cursor.id;
            tempsharelevelold := 0;



          select count(sharelevel) into recordcounts3   from temptablevalue_3 where userid=sameSubUserId   
          and usertype=1; 

          if recordcounts3> 0then
          select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=sameSubUserId   
          and usertype=1; 
          end if;




            if (tempsharelevelold=0) 
              then
              insert into  temptablevalue_3(userid,usertype,sharelevel) 
              values(sameSubUserId,1,tempsharelevel);
            elsif (tempsharelevel>tempsharelevelold)
              then 
              update temptablevalue_3  set sharelevel=tempsharelevel where userid=sameSubUserId and 
              usertype=1 ;
            end if;
          end loop;
        end if; 
      elsif (tempsharetype=85)   
        then
        if (tempsharelevel!=0)
          then
          select departmentid into departmentId   from  hrmresource where id=tempuserid;
          for temp_cursor in(
            select id from  hrmresource where departmentid=departmentId and 
          seclevel>=tempseclevel  and loginid is not null )
          loop
            sameDepartUserId := temp_cursor.id;
            tempsharelevelold := 0;

          select count(sharelevel) into recordcounts2   from temptablevalue_3 where userid=sameDepartUserId   
          and usertype=1; 

          if recordcounts2> 0then
          select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=sameDepartUserId   
          and usertype=1; 
          end if;


      
            if (tempsharelevelold=0) 
              then
              insert into  temptablevalue_3(userid,usertype,sharelevel) 
              values(sameDepartUserId,1,tempsharelevel) ;
            elsif (tempsharelevel>tempsharelevelold)
              then
              update temptablevalue_3  set sharelevel=tempsharelevel where userid=sameDepartUserId 
              and usertype=1 ;
            end if;
          end loop;
        end if;
              end if;     
    end loop;
  end if;

  for shareuserid_cursor in(
    select distinct t1.id , t2.sharelevel from HrmResource t1 ,  DocShare  t2 
  where  t1.loginid is not null and t2.docid = docid_1 and ( (t2.foralluser=1 and 
  t2.seclevel<=t1.seclevel)  or ( t2.userid= t1.id ) or (t2.departmentid=t1.departmentid and 
  t2.seclevel<=t1.seclevel)) and t2.sharetype not in(-80,-81,-82,80,81,82,83,84,85)  and t1.loginid is not null )
   loop 
    tempuserid  := shareuserid_cursor.id;
    tempsharelevel  := shareuserid_cursor.sharelevel;
    tempsharelevelold := 0;

          select count(sharelevel) into recordcounts4   from temptablevalue_3 where userid=tempuserid   
          and usertype=1; 

          if recordcounts4> 0then
          select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=tempuserid   
          and usertype=1; 
          end if;


    if (tempsharelevelold=0)
      then
      insert into temptablevalue_3(userid,usertype,sharelevel) values(tempuserid,1,tempsharelevel); 
    elsif (tempsharelevel>tempsharelevelold)
      then
      update temptablevalue_3 set sharelevel = tempsharelevel where userid=tempuserid and usertype = 1 ;
    end if;
  end loop;
    

  for shareuserid_cursor in(
    select distinct t1.id , t2.sharelevel from HrmResource t1 ,  DocShare  t2,  
  HrmRoleMembers  t3 where  t1.loginid is not null  and t2.docid = docid_1 and (  
  t3.resourceid=t1.id and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and ( (t3.rolelevel=2) or 
  (t3.rolelevel=0  and t1.departmentid=departmentid_6) or (t3.rolelevel=1 and t1.subcompanyid1=subcompanyid_7) ) ) 
  and t2.sharetype not in(-80,-81,-82,80,81,82,83,84,85) and t1.loginid is not null)
  loop
    tempuserid  := shareuserid_cursor.id;
    tempsharelevel  := shareuserid_cursor.sharelevel;
    tempsharelevelold := 0;

          select count(sharelevel) into recordcounts5   from temptablevalue_3 where userid=tempuserid   
          and usertype=1; 

          if recordcounts5> 0then
          select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=tempuserid   
          and usertype=1; 
          end if;

if (tempsharelevelold=0)
      then
      insert into temptablevalue_3(userid,usertype,sharelevel) values(tempuserid,1,tempsharelevel);
    elsif (tempsharelevel>tempsharelevelold)
      then
      update temptablevalue_3 set sharelevel = tempsharelevel where userid=tempuserid and usertype = 1; 
    end if;
  end loop;


  for shareuserid_cursor in(
    select distinct sharetype , seclevel, sharelevel from DocShare where 
  sharetype < 0 and docid = docid_1 and sharetype not in(-80,-81,-82,80,81,82,83,84,85))
  loop 
    tempsharetype := shareuserid_cursor.sharetype;
    tempuserid := shareuserid_cursor.seclevel;
    tempsharelevel  := shareuserid_cursor.sharelevel;
    tempsharelevelold := 0;
    select sharelevel into tempsharelevelold from temptablevalue_3 where userid=tempuserid and usertype = 
    tempsharetype ;  
    if (tempsharelevelold=0)
      then
      insert into temptablevalue_3(userid,usertype,sharelevel) values(tempuserid,tempsharetype,tempsharelevel);
    elsif(tempsharelevel>tempsharelevelold)
      then
      update temptablevalue_3 set sharelevel = tempsharelevel where userid=tempuserid and usertype = tempuserid ;
    end if;
  end loop;


  for shareuserid_cursor in(
    select distinct crmid , sharelevel from DocShare where crmid <> 0 and 
  sharetype = '9' and docid = docid_1 and sharetype not in(-80,-81,-82,80,81,82,83,84,85))
  loop 
    tempuserid  := shareuserid_cursor.crmid;
    tempsharelevel  := shareuserid_cursor.sharelevel;
    tempsharelevelold := 0;
    select  sharelevel into tempsharelevelold  from temptablevalue_3 where userid=tempuserid and usertype = 9; if (tempsharelevelold=0)
      then
      insert into temptablevalue_3(userid,usertype,sharelevel) values(tempuserid,9,tempsharelevel);
    elsif (tempsharelevel>tempsharelevelold) 
      then
      update temptablevalue_3 set sharelevel = tempsharelevel where userid=tempuserid and usertype = 9;  
    end if;

  end loop;

  delete docsharedetail where docid = docid_1;
  insert into docsharedetail (docid,userid,usertype,sharelevel) select docid_1 , userid,usertype,sharelevel from 
  temptablevalue_3;
end;
/
create or replace procedure Doc_AddSecidToFather( secid_1   integer, flag      out integer, msg       out varchar2, thecursor IN OUT cursor_define.weavercursor) as fatherid_1  integer; fatherid1_1 integer; secid_ch_1  varchar2(4000); secids_1    varchar2(4000); begin secid_ch_1 := to_char(secid_1); select subcategoryid into fatherid_1 from DocSecCategory where id = secid_1; if fatherid_1 is null then fatherid_1 := -1; end if; if fatherid_1 = 0 then fatherid_1 := -1; end if; while fatherid_1 <> -1 loop select subcategoryid, seccategoryids into fatherid1_1, secids_1 from DocSubCategory where id = fatherid_1; if secids_1 is null then update DocSubCategory set seccategoryids = secid_ch_1 where id = fatherid_1; elsif instr(concat(concat(',',secids_1),','), concat(concat(',',secid_ch_1),','), 1, 1) = 0 then update DocSubCategory set seccategoryids = concat(concat(secids_1, ','), secid_ch_1) where id = fatherid_1; end if; fatherid_1 := fatherid1_1; end loop; end;
/
CREATE OR REPLACE PROCEDURE Doc_GetOrderedFatherSubid ( mainid_1 integer, categorytype_1 integer, flag  out integer, msg out varchar2 , thecursor IN OUT cursor_define.weavercursor) as fatherid_1 integer; fatherid1_1 integer; fathername_1 varchar2(4000); orderid_1 integer; begin  orderid_1 := 0; if  categorytype_1 = 1  then select subcategoryid into fatherid_1 from DocSubCategory where id = mainid_1; elsif categorytype_1 = 2  then select subcategoryid into fatherid_1 from DocSecCategory where id = mainid_1;  if fatherid_1 is null  then fatherid_1 := -1; end if;  if fatherid_1 = 0 then fatherid_1 := -1; end if; else fatherid_1 := -1; end if;  while  fatherid_1 <> -1 loop select subcategoryid,categoryname into fatherid1_1, fathername_1 from DocSubCategory where id = fatherid_1; insert into temp_3 ( orderid,subcategoryid,subcategoryname) values(orderid_1, fatherid_1, fathername_1); fatherid_1 := fatherid1_1; orderid_1 := orderid_1 + 1; end loop; open thecursor for select orderid, subcategoryid, subcategoryname from temp_3 order by orderid desc; end ;
/
create or replace procedure Doc_GetPermittedCategory ( userid_1 integer, usertype_1 integer, seclevel_1 integer, operationcode_1 integer, departmentid_1 integer, subcompanyid_1 integer, roleid_1 varchar2, flag out integer  , msg  out varchar2, thecursor IN OUT cursor_define.weavercursor ) as secdirid_1 integer; secdirname_1 varchar2(4000); subdirid_1 integer; subdirid1_1 integer; superdirid_1 integer; superdirtype_1 integer; maindirid_1 integer; subdirname_1 varchar2(4000); count_1 integer; orderid_1 float; begin if usertype_1 = 0 then for secdir_cursor in(select id mainid, categoryname, subcategoryid, secorder from DocSecCategory where id in (select distinct sourceid from DirAccessControlDetail where sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1)))) loop secdirid_1 := secdir_cursor.mainid; secdirname_1 := secdir_cursor.categoryname; subdirid_1 := secdir_cursor.subcategoryid; orderid_1 :=secdir_cursor.secorder; insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1); if subdirid_1 is null then subdirid_1 := -1 ; end if; if subdirid_1 = 0 then subdirid_1 := -1 ; end if; while subdirid_1 <> -1 loop select subcategoryid,categoryname,subcategoryid,maincategoryid,suborder into subdirid1_1,subdirname_1,superdirid_1,maindirid_1,orderid_1  from DocSubCategory where  id = subdirid_1 ; if superdirid_1 = -1 then superdirid_1 := maindirid_1 ; superdirtype_1 := 0 ; else superdirtype_1 := 1 ; end if; count_1 := 0 ; select count(categoryid) into count_1 from temp_4 where categoryid = subdirid_1 and categorytype = 1 ; if count_1 <= 0 then insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 1, superdirid_1, superdirtype_1, subdirname_1, orderid_1); end if; subdirid_1 := subdirid1_1 ; end loop; end loop; else for secdir_cursor in (select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1)))) loop secdirid_1 := secdir_cursor.mainid; secdirname_1 := secdir_cursor.categoryname; subdirid_1 := secdir_cursor.subcategoryid; orderid_1 := secdir_cursor.secorder; insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1); if subdirid_1 is null then subdirid_1 := -1 ; end if; if subdirid_1 = 0 then subdirid_1 := -1 ; end if; while subdirid_1 <> -1 loop select subcategoryid,categoryname,subcategoryid,maincategoryid,suborder into subdirid1_1,subdirname_1,superdirid_1,maindirid_1,orderid_1  from DocSubCategory where id = subdirid_1; if superdirid_1 = -1 then superdirid_1 := maindirid_1 ; superdirtype_1 := 0 ; else superdirtype_1 := 1 ; end if; count_1 := 0 ; select count(categoryid) into count_1 from temp_4 where categoryid = subdirid_1 and categorytype = 1 ; if count_1 <= 0 then insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 1, superdirid_1, superdirtype_1, subdirname_1, orderid_1); end if; subdirid_1 := subdirid1_1 ; end loop; end loop; end if; for maindir_cursor in(select id, categoryname, categoryorder from DocMainCategory where id in (select distinct superdirid from temp_4 where superdirtype = 0)) loop subdirid_1 := maindir_cursor.id; subdirname_1 := maindir_cursor.categoryname; orderid_1 := maindir_cursor.categoryorder; insert into temp_4 (categoryi
d ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(subdirid_1, 0, -1, -1, subdirname_1, orderid_1); end loop; open thecursor for select * from temp_4 order by orderid,categoryid ; end;
/
create or replace procedure Doc_GetPermittedCategory_New ( userid_1 integer, usertype_1 integer, seclevel_1 integer, operationcode_1 integer, departmentid_1 integer, subcompanyid_1 integer, roleid_1 varchar2, categoryname_1 varchar2, flag out integer  , msg  out varchar2, thecursor IN OUT cursor_define.weavercursor ) as secdirid_1 integer; secdirname_1 varchar2(4000); subdirid_1 integer; subdirid1_1 integer; superdirid_1 integer; superdirtype_1 integer; maindirid_1 integer; subdirname_1 varchar2(4000); count_1 integer; orderid_1 float; begin if usertype_1 = 0 then if categoryname_1 = '' then for secdir_cursor in(select id mainid, categoryname, subcategoryid, secorder from DocSecCategory where id in (select distinct sourceid from DirAccessControlDetail where sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1)))) loop secdirid_1 := secdir_cursor.mainid; secdirname_1 := secdir_cursor.categoryname; subdirid_1 := secdir_cursor.subcategoryid; orderid_1 :=secdir_cursor.secorder; insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1); end loop; else for secdir_cursor in(select id mainid, categoryname, subcategoryid, secorder from DocSecCategory where categoryname like '%'||categoryname_1||'%' and  id in (select distinct sourceid from DirAccessControlDetail where sharelevel=operationcode_1 and ((type=1 and content=departmentid_1 and seclevel<=seclevel_1) or (type=2 and content in (select * from TABLE(CAST(SplitStr(roleid_1, ',')AS mytable))) and seclevel<=seclevel_1) or (type=3 and seclevel<=seclevel_1) or (type=4 and content=usertype_1 and seclevel<=seclevel_1) or (type=5 and content=userid_1) or (type=6 and content=subcompanyid_1 and seclevel<=seclevel_1)))) loop secdirid_1 := secdir_cursor.mainid; secdirname_1 := secdir_cursor.categoryname; subdirid_1 := secdir_cursor.subcategoryid; orderid_1 :=secdir_cursor.secorder; insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1); end loop; end if; else if categoryname_1 = '' then for secdir_cursor in (select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1)))) loop secdirid_1 := secdir_cursor.mainid; secdirname_1 := secdir_cursor.categoryname; subdirid_1 := secdir_cursor.subcategoryid; orderid_1 := secdir_cursor.secorder; insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1); end loop; else for secdir_cursor in (select id mainid, categoryname, subcategoryid,secorder from DocSecCategory where categoryname like '%'||categoryname_1||'%' and   id in (select distinct dirid mainid from DirAccessControlList where dirtype=2 and operationcode=operationcode_1 and ((permissiontype=3 and seclevel<=seclevel_1) or (permissiontype=4 and usertype=usertype_1 and seclevel<=seclevel_1)))) loop secdirid_1 := secdir_cursor.mainid; secdirname_1 := secdir_cursor.categoryname; subdirid_1 := secdir_cursor.subcategoryid; orderid_1 := secdir_cursor.secorder; insert into temp_4 (categoryid ,categorytype ,superdirid ,superdirtype ,categoryname ,orderid ) values(secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1); end loop; end if; end if; open thecursor for select * from temp_4 order by orderid,categoryid ; end;
/
CREATE OR REPLACE PROCEDURE Doc_SetSecIdsFromOldTable as subid_1 integer; secid_1 integer; secids_1 varchar2(4000); begin for subcategory_cur in  ( select id from DocSubCategory ) loop subid_1 := subcategory_cur.id ; secids_1 := ' ' ; for subcategory_cur in  ( select id from DocSecCategory where subcategoryid = subid_1 ) loop secid_1 := subcategory_cur.id ; secids_1 := concat(secids_1 , concat(to_char( secid_1) , ',')); end loop; if secids_1 is not null then secids_1 := substr(secids_1, 1, length(secids_1)-1); end if; update DocSubCategory  set seccategoryids = secids_1 where id = subid_1; end loop ; end;
/
CREATE OR REPLACE PROCEDURE Employee_CptSelectByID ( hrmid_1 integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as mark_1 varchar2(4000); name_1 varchar2(4000); cptnum_1 integer; capitalid_1 integer; cursor cpt_cursor is select capitalid,cptnum from HrmCapitalUse WHERE hrmid =hrmid_1; begin OPEN  cpt_cursor ; FETCH cpt_cursor into  capitalid_1,cptnum_1; while cpt_cursor%found loop open thecursor for select mark,name INTO mark_1,name_1 from CptCapital where id= capitalid_1; insert INTO temp_employee_02(mark,name,cptnum) values(mark_1,name_1,cptnum_1); FETCH cpt_cursor into  capitalid_1,cptnum_1; end loop; open thecursor for select * from temp_employee_02; end;
/
CREATE OR REPLACE PROCEDURE Employee_SByStatus ( flag	out		integer, msg  out		varchar2, thecursor IN OUT cursor_define.weavercursor) as hrmid_1 integer; id_1 integer; lastname_1 varchar2(4000); sex_1 char(1); startdate_1 char(10); departmentid_1 integer; joblevel_1 smallint; managerid_1 integer;  begin for employee_cursor  IN (select distinct(hrmid) from HrmInfoStatus t1,HrmResource t2 where t1.status ='0' and t1.hrmid = t2.id) loop hrmid_1 :=employee_cursor.hrmid ; select id,lastname,sex,startdate,departmentid,joblevel,managerid INTO id_1, lastname_1,sex_1,startdate_1,departmentid_1,joblevel_1,managerid_1 from HrmResource WHERE id=hrmid_1;  insert INTO temp_Employee_table_01(id,lastname,sex,startdate,departmentid,joblevel,managerid) values(id_1,lastname_1,sex_1,startdate_1,departmentid_1,joblevel_1,managerid_1); end loop; open thecursor for select * from temp_Employee_table_01; end;
/
CREATE OR REPLACE Procedure fix_workplan_data as id integer; crmid varchar2(4000); relatedprj varchar2(4000); relatedcus varchar2(4000); relatedwf varchar2(4000); relateddoc varchar2(4000); begin FOR all_cursor in( select id,crmid,relatedprj,relatedcus,relatedwf,relateddoc from WorkPlan where (relatedprj is not null or relatedcus is not null or relatedwf is not null or relateddoc is not null) and (relatedprj!='0' and relatedcus!='0' and relatedwf!='0' and relateddoc!='0')) loop id :=all_cursor.id; crmid :=all_cursor.crmid; relatedprj :=all_cursor.relatedprj; relatedcus :=all_cursor.relatedcus; relatedwf :=all_cursor.relatedwf; relateddoc :=all_cursor.relateddoc; update WorkPlan set taskid=relatedprj,crmid= concat(concat(crmid,','),relatedcus),requestid=relatedwf,docid=relateddoc where id=id; end loop; end;
/
CREATE OR REPLACE PROCEDURE FnaAccountList_Process (departmentid_1 	integer, tranperiods_2    char, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS count_1 integer; ledgerid_1 integer; tranid_1 integer; tranperiods_1 char(6); tranmark_1 integer; trandate_1 char(10); tranremark_1 varchar2(4000); tranaccount_1 number(18,3); tranbalance_1 char(1);  cursor transaction_cursor is select ledgerid, t.id, tranperiods, tranmark, trandate, d.tranremark, tranaccount, tranbalance from FnaTransaction t , FnaTransactionDetail d where t.id = d.tranid and trandepartmentid = departmentid_1 and tranperiods = tranperiods_2 and transtatus = '1';  begin select count(id) into count_1 from FnaYearsPeriodsList where fnayearperiodsid < tranperiods_2 and isactive = '1' and isclose ='0' ;  if count_1 <> 0 then open thecursor for select -1 from dual; return; end if;  open transaction_cursor; fetch transaction_cursor into ledgerid_1,tranid_1,tranperiods_1, tranmark_1,trandate_1, tranremark_1,tranaccount_1,tranbalance_1; while transaction_cursor%found loop insert into FnaAccountList ( ledgerid, tranid, tranperiods, tranmark, trandate, tranremark, tranaccount, tranbalance)  VALUES ( ledgerid_1, tranid_1, tranperiods_1, tranmark_1, trandate_1, tranremark_1, tranaccount_1, tranbalance_1); end loop; close transaction_cursor; update FnaTransaction set transtatus = '2' where trandepartmentid = departmentid_1 and tranperiods = tranperiods_2 and transtatus = '1'; end;
/
CREATE OR REPLACE PROCEDURE FnaAccountList_Select (ledgerid_0 	integer, periods_1    char, periods_2    char, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as count_1 integer; ledgerid_1 integer ; tranmark_1 integer ; trandate_1 char(10); tranremark_1 varchar2(4000); tranid_1 integer; tranaccount_1 number(18,3); tranremain_1 number(18,3); tranbalance_1 char(1); tmptranperiods_1 char(6); tranremain_1_count integer;  begin    if   ledgerid_0 = 0 then  for account_cursor in ( select ledgerid,tranid,tranmark,trandate,tranremark,tranaccount, tranbalance from  FnaAccountList where tranperiods >=  periods_1 and  tranperiods <=  periods_2  )  loop ledgerid_1 := account_cursor.ledgerid ; tranid_1 := account_cursor.tranid ; tranmark_1 := account_cursor.tranmark ; trandate_1 := account_cursor.trandate ; tranremark_1 := account_cursor.tranremark ; tranaccount_1 := account_cursor.tranaccount ; tranbalance_1 := account_cursor.tranbalance ;  insert into TM_FnaAccountList_Select values( ledgerid_1, tranid_1, tranmark_1, trandate_1, tranremark_1, tranaccount_1, tranbalance_1) ; end loop ;  for ledger_cursor in ( select ledgerid from TM_FnaAccountList_Select group by ledgerid ) loop ledgerid_1 :=  ledger_cursor.ledgerid ; tranremain_1 := 0 ; select  count(id) , max(tranperiods) into count_1, tmptranperiods_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods <  periods_1 ;  if  count_1 <> 0 then  select  tranremain into tranremain_1 from FnaAccount where ledgerid =  ledgerid_1 and tranperiods =  tmptranperiods_1 ; end if ;  insert into TM_FnaAccountList_Select values( ledgerid_1,0,0,null,null, tranremain_1,null) ; end loop ;  open thecursor for select * from TM_FnaAccountList_Select order by ledgerid , tranmark ;  else  for account_cursor in ( select ledgerid,tranid,tranmark,trandate,tranremark,tranaccount, tranbalance from  FnaAccountList where tranperiods >=  periods_1 and  tranperiods <=  periods_2 and ledgerid =  ledgerid_0  )  loop ledgerid_1 := account_cursor.ledgerid ; tranid_1 := account_cursor.tranid ; tranmark_1 := account_cursor.tranmark ; trandate_1 := account_cursor.trandate ; tranremark_1 := account_cursor.tranremark ; tranaccount_1 := account_cursor.tranaccount ; tranbalance_1 := account_cursor.tranbalance ;  insert into TM_FnaAccountList_Select values( ledgerid_1, tranid_1, tranmark_1, trandate_1, tranremark_1, tranaccount_1, tranbalance_1) ; end loop ;  tranremain_1 := 0 ; select  count(id) , max(tranperiods) into count_1, tmptranperiods_1 from FnaAccount where ledgerid =  ledgerid_0 and tranperiods <  periods_1 ; if  count_1 <> 0 then  select  count(tranremain) into tranremain_1_count from FnaAccount where ledgerid =  ledgerid_0 and tranperiods =  tmptranperiods_1 ; if tranremain_1_count =0 then tranremain_1_count :=null; else select  tranremain into tranremain_1 from FnaAccount where ledgerid =  ledgerid_0 and tranperiods =  tmptranperiods_1 ; end if; end if ;  insert into TM_FnaAccountList_Select values( ledgerid_1,0,0,null,null, tranremain_1,null) ;  open thecursor for select * from TM_FnaAccountList_Select order by ledgerid , tranmark ; end if ;  end;
/
CREATE OR REPLACE PROCEDURE FnaBudgetList_Process (departmentid_1 	integer, periodsfrom_2    char, periodsto_2      char, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as  ledgerid_1 integer ; budgetid_1 integer ; budgetmoduleid_1 integer ; budgetperiods_1 char(6);  budgetdepartmentid_1 integer; budgetcostcenterid_1 integer; budgetresourceid_1 integer;  budgetremark_1 varchar2(4000); budgetaccount_1 decimal(18,3);  begin  for budget_cursor in(select ledgerid, b.id budgetid, budgetmoduleid, budgetperiods, budgetdepartmentid, budgetcostercenterid, budgetresourceid, d.budgetremark , budgetdefaccount from FnaBudget b , FnaBudgetDetail d where b.id = d.budgetid and budgetdepartmentid =  departmentid_1 and budgetperiods >=  periodsfrom_2 and budgetperiods <=  periodsto_2 and budgetstatus = '1' ) loop  ledgerid_1 := budget_cursor.ledgerid ; budgetid_1 := budget_cursor.budgetid ; budgetmoduleid_1 := budget_cursor.budgetmoduleid ; budgetperiods_1 := budget_cursor.budgetperiods ; budgetdepartmentid_1 := budget_cursor.budgetdepartmentid ; budgetcostcenterid_1 := budget_cursor.budgetcostercenterid ; budgetresourceid_1 := budget_cursor.budgetresourceid ; budgetremark_1 := budget_cursor.budgetremark ; budgetaccount_1  := budget_cursor.budgetdefaccount ;  insert into FnaBudgetList ( ledgerid, budgetid, budgetmoduleid, budgetperiods, budgetdepartmentid, budgetcostcenterid, budgetresourceid, budgetremark, budgetaccount)  VALUES ( ledgerid_1, budgetid_1, budgetmoduleid_1, budgetperiods_1, budgetdepartmentid_1, budgetcostcenterid_1, budgetresourceid_1, budgetremark_1, budgetaccount_1); end loop ;  update FnaBudget set budgetstatus = '2' where budgetdepartmentid =  departmentid_1 and budgetperiods >=  periodsfrom_2 and budgetperiods <=  periodsto_2 and budgetstatus = '1' ; end;
/
CREATE OR REPLACE PROCEDURE FnaCurrencyExchange_SByLast (flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as defcurrencyid_1 integer; endexchangerage_1 varchar2 (20); begin for currencyid_cursor  in (select thecurrencyid , max(fnayearperiodsid) maxfnayearperiodsid from  FnaCurrencyExchange group by thecurrencyid ) loop select defcurrencyid ,endexchangerage into defcurrencyid_1 , endexchangerage_1 from FnaCurrencyExchange where thecurrencyid=  currencyid_cursor.thecurrencyid and fnayearperiodsid= currencyid_cursor.maxfnayearperiodsid ; insert into TM_FnaCurrencyExchange values(defcurrencyid_1 ,currencyid_cursor.thecurrencyid , endexchangerage_1) ; end loop; open thecursor for select * from TM_FnaCurrencyExchange ; end;
/
CREATE OR REPLACE PROCEDURE FnaLedger_DeleteAuto (crmcode_1 	varchar2, crmtype_1 	char, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS count_1 integer; ledgermark_1 varchar2(4000); ledgermark_2 varchar2(4000); ledgerid_1 integer; ledgerid_2 integer; supledgerid_1 integer; supledgerid_2 integer; ledgermark_count_1 integer; ledgermark_count_2 integer; recordcount integer;  begin if crmtype_1 = '1' then select count(ledgermark) into ledgermark_count_1 from FnaLedger where autosubledger = '1' ; if ledgermark_count_1>0 then  select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '1' ; end if; select count(ledgermark) into ledgermark_count_2 from FnaLedger where autosubledger = '2' ; if ledgermark_count_2>0 then  select ledgermark into ledgermark_2 from FnaLedger where autosubledger = '2' ; end if; end if; if crmtype_1 = '2' then select count(ledgermark) into ledgermark_count_1 from FnaLedger where autosubledger = '3' ; if ledgermark_count_1>0 then  select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '3'; end if;  select count(ledgermark) into ledgermark_count_2 from FnaLedger where autosubledger = '4' ; if ledgermark_count_2>0 then  select ledgermark into ledgermark_2 from FnaLedger where autosubledger = '4'; end if; end if ; select  count(id) INTO recordcount  from FnaLedger ; IF (recordcount>0) THEN  select  id,supledgerid into ledgerid_1, supledgerid_1 from FnaLedger where  ledgermark = concat(ledgermark_1 , crmcode_1); end if;  select count(id) into count_1 from FnaTransactionDetail where ledgerid = ledgerid_1; if count_1 <> 0 then open thecursor for select 2 from dual; return; end if; select  count(id) INTO recordcount  from FnaLedger ; IF (recordcount>0) THEN  select id,supledgerid into ledgerid_2 ,supledgerid_2 from FnaLedger where  ledgermark = concat(ledgermark_2 , crmcode_1); end if; select  count(id) into count_1 from FnaTransactionDetail where ledgerid = ledgerid_2 ; if count_1 <> 0 then open thecursor for select 2 from dual; return; end if; delete FnaLedger where id = ledgerid_1; delete FnaLedger where id = ledgerid_2 ; update FnaLedger set subledgercount = subledgercount-1 where id = supledgerid_1; update FnaLedger set subledgercount = subledgercount-1 where id = supledgerid_2 ; open thecursor for select 0 from dual; end;
/
CREATE OR REPLACE PROCEDURE FnaLedger_InsertAuto (crmname_1 	varchar2, crmtype_1 	char, crmcode_1 	varchar2, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS count_1 integer; init_1 number(18,3); ledgermark_1 varchar2(4000); ledgername_2 varchar2(4000); ledgertype_3 char(1); ledgergroup_4  char(1); ledgerbalance_5 char(1); ledgercurrency_7 char(1); supledgerid_8 integer; Categoryid_9 integer; supledgerall_10 varchar2(4000); ledgerid1_1 integer; ledgerid2_1 integer ; ledgermark_count integer; recordcount_2 integer; recordcount_1 integer; begin if crmtype_1 = '1'  then select count(ledgermark) into ledgermark_count from FnaLedger where autosubledger = '1'; if ledgermark_count>0 then  select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '1'; end if; select count(id) into count_1 from FnaLedger where  ledgermark = (ledgermark_1 || crmcode_1);  if count_1 <> 0 then open thecursor for select 1,0,0 from dual; return; end if; select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '2' ; select count(id) into count_1 from FnaLedger where  ledgermark = (ledgermark_1 || crmcode_1) ;  if count_1<> 0 then open thecursor for select 1,0,0 from dual; return; end if;  select count(*) into recordcount_1 from FnaLedger where autosubledger = '1'; if recordcount_1>0 then  select ledgermark,ledgername,ledgertype,ledgergroup,ledgerbalance,ledgercurrency,id,Categoryid,supledgerall into ledgermark_1, ledgername_2,ledgertype_3,ledgergroup_4,ledgerbalance_5,ledgercurrency_7, supledgerid_8,Categoryid_9,supledgerall_10 from FnaLedger where autosubledger = '1'; end if;  ledgermark_1:=ledgermark_1 || crmcode_1; ledgername_2 := ledgername_2 || '-' || crmname_1 ; supledgerall_10:= concat(supledgerall_10 ,( to_char(supledgerid_8) ||'|')) ;  INSERT INTO FnaLedger ( ledgermark, ledgername, ledgertype, ledgergroup, ledgerbalance, autosubledger, ledgercurrency, supledgerid, Categoryid, supledgerall) VALUES ( ledgermark_1, ledgername_2, ledgertype_3, ledgergroup_4, ledgerbalance_5, '0', ledgercurrency_7, supledgerid_8, Categoryid_9, supledgerall_10) ;  select  max(id) into ledgerid1_1 from FnaLedger; update FnaLedger set subledgercount = subledgercount+1 where id = supledgerid_8;  select ledgermark,ledgername,ledgertype,ledgergroup,ledgerbalance,ledgercurrency,id,Categoryid,supledgerall into ledgermark_1, ledgername_2,ledgertype_3,ledgergroup_4,ledgerbalance_5,ledgercurrency_7, supledgerid_8,Categoryid_9,supledgerall_10 from FnaLedger where autosubledger = '2';  ledgermark_1:= ledgermark_1 || crmcode_1 ; ledgername_2:= ledgername_2 || '-' || crmname_1; supledgerall_10:=supledgerall_10 || to_number(supledgerid_8) ||'|' ; INSERT INTO FnaLedger ( ledgermark, ledgername, ledgertype, ledgergroup, ledgerbalance, autosubledger, ledgercurrency, supledgerid, Categoryid, supledgerall) VALUES ( ledgermark_1, ledgername_2, ledgertype_3, ledgergroup_4, ledgerbalance_5, '0', ledgercurrency_7, supledgerid_8, Categoryid_9, supledgerall_10);  select max(id) into ledgerid2_1 from FnaLedger; update FnaLedger set subledgercount = subledgercount+1 where id = supledgerid_8; end if;  if crmtype_1 = '2' then select count(ledgermark) into ledgermark_count from FnaLedger where autosubledger = '3'; if ledgermark_count>0 then  select ledgermark into ledgermark_1  from FnaLedger where autosubledger = '3' ; end if; select count(id) into count_1 from FnaLedger where  ledgermark = (ledgermark_1 || crmcode_1) ; if count_1 <> 0 then open thecursor for select 1,0,0 from dual; return; end if;  select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '4' ; select count(id) into count_1 from FnaLedger where  ledgermark = (ledgermark_1 || crmcode_1); if count_1 <> 0 then open thecursor for select 1,0,0 from dual; return ; end if;  select count(*) into recordcount_2 from FnaLedger where autosubledger = '3'; if recordcount_2 >0 then   select ledgermark,ledgername,ledgertype,ledgergroup,ledgerbalance,ledgercurrency,id,Categoryid,supledgeral
l into ledgermark_1, ledgername_2,ledgertype_3,ledgergroup_4,ledgerbalance_5,ledgercurrency_7, supledgerid_8,Categoryid_9,supledgerall_10 from FnaLedger where autosubledger = '3'; end if; ledgermark_1:=ledgermark_1 || crmcode_1; ledgername_2:=ledgername_2 || '-' || crmname_1; supledgerall_10:=supledgerall_10 || to_char( supledgerid_8) ||'|' ;  INSERT INTO FnaLedger ( ledgermark, ledgername, ledgertype, ledgergroup, ledgerbalance, autosubledger, ledgercurrency, supledgerid, Categoryid, supledgerall)  VALUES ( ledgermark_1, ledgername_2, ledgertype_3, ledgergroup_4, ledgerbalance_5, '0', ledgercurrency_7, supledgerid_8, Categoryid_9, supledgerall_10);  select max(id) into ledgerid1_1 from FnaLedger; update FnaLedger set subledgercount = subledgercount+1 where id = supledgerid_8;  select ledgermark,ledgername,ledgertype,ledgergroup,ledgerbalance,ledgercurrency,id,Categoryid,supledgerall into ledgermark_1, ledgername_2,ledgertype_3,ledgergroup_4,ledgerbalance_5,ledgercurrency_7, supledgerid_8,Categoryid_9,supledgerall_10 from FnaLedger where autosubledger = '4';   ledgermark_1:=ledgermark_1 || crmcode_1; ledgername_2:=ledgername_2 || '-' || crmname_1; supledgerall_10:=supledgerall_10 || to_char(supledgerid_8) ||'|' ;  INSERT INTO FnaLedger ( ledgermark, ledgername, ledgertype, ledgergroup, ledgerbalance, autosubledger, ledgercurrency, supledgerid, Categoryid, supledgerall) VALUES ( ledgermark_1, ledgername_2, ledgertype_3, ledgergroup_4, ledgerbalance_5, '0', ledgercurrency_7, supledgerid_8, Categoryid_9, supledgerall_10);  select max(id) into ledgerid2_1 from FnaLedger; update FnaLedger set subledgercount = subledgercount+1 where id = supledgerid_8; end if;  open thecursor for select 0, ledgerid1_1, ledgerid2_1 from dual; end;
/
CREATE OR REPLACE PROCEDURE FnaLedger_UpdateAuto (oldcrmcode_1 	varchar2, crmcode_1 	varchar2, crmtype_1 	char, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS count_1 integer ; ledgermark_1 varchar2(4000); ledgermark_2 varchar2(4000); ledgerid_1 integer; ledgerid_2 integer; ledgermark_count_1 integer; ledgermark_count_2 integer; recordcount integer; begin if crmtype_1 = '1' then select count(ledgermark) into ledgermark_count_1 from FnaLedger where autosubledger = '1'; if ledgermark_count_1>0 then  select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '1'; end if; select count(ledgermark) into ledgermark_count_2 from FnaLedger where autosubledger = '2'; if ledgermark_count_2>0 then  select ledgermark into ledgermark_2 from FnaLedger where autosubledger = '2'; end if; end if; if crmtype_1 = '2' then select count(ledgermark) into ledgermark_count_1 from FnaLedger where autosubledger = '3'; if ledgermark_count_1>0 then  select ledgermark into ledgermark_1 from FnaLedger where autosubledger = '3'; end if; select count(ledgermark) into ledgermark_count_2 from FnaLedger where autosubledger = '4'; if ledgermark_count_2>0 then  select ledgermark into ledgermark_2 from FnaLedger where autosubledger = '4'; end if; end if; select count(id) into count_1 from FnaLedger where  ledgermark = concat(ledgermark_1 , crmcode_1) ; if count_1 <> 0 then open thecursor for select 1 from dual; return; end if; select count(id) into recordcount from FnaLedger where  ledgermark = concat(ledgermark_1 , oldcrmcode_1); if(recordcount > 0) then  select id into ledgerid_1 from FnaLedger where  ledgermark = concat(ledgermark_1 , oldcrmcode_1); end if; select count(id) into count_1 from FnaTransactionDetail where ledgerid = ledgerid_1 ; if count_1<> 0 then open thecursor for select 2 from dual; return ; end if; select count(id) into count_1 from FnaLedger where  ledgermark = concat(ledgermark_2 , crmcode_1); if count_1 <> 0 then open thecursor for select 1 from dual; return; end if;  select id into ledgerid_2 from FnaLedger where  ledgermark = concat(ledgermark_2 , oldcrmcode_1) ; select count(id) into count_1 from FnaTransactionDetail where ledgerid = ledgerid_2 ; if count_1 <> 0 then open thecursor for select 2 from dual; return ; end if; update FnaLedger set ledgermark = concat(ledgermark_1 , crmcode_1) where id = ledgerid_1 ; update FnaLedger set ledgermark = concat(ledgermark_2 , crmcode_1) where id = ledgerid_2 ; open thecursor for select 0 from dual; end;
/
CREATE OR REPLACE PROCEDURE FnaYearsPeriodsList_Update(id_1        integer, startdate_2 varchar2, enddate_3   varchar2, fnayearid_4 integer, isactive_5  varchar2, flag        out integer, msg         out varchar2, thecursor   IN OUT cursor_define.weavercursor) AS minfromdate_1 varchar2(4000); maxenddate_1  varchar2(4000); begin UPDATE FnaYearsPeriodsList SET startdate = startdate_2, enddate   = enddate_3, isactive  = isactive_5 WHERE (id = id_1); select min(startdate) into minfromdate_1 from FnaYearsPeriodsList where fnayearid = fnayearid_4 and (startdate is not null); select max(enddate) into maxenddate_1 from FnaYearsPeriodsList where fnayearid = fnayearid_4 and (enddate is not null); update FnaYearsPeriods set startdate = minfromdate_1, enddate = maxenddate_1 where id = fnayearid_4; end;
/
create or replace procedure FormLabelMaintenance as indexidn    int; labelnamen  varchar2(4000); languageidn int; begin FOR tmp_cursor IN (select hl.* from (select h.indexid, count(h.languageid) cl from workflow_bill b, htmllabelinfo h where b.namelabel = h.indexid and b.id<0 group by h.indexid having count(h.languageid) < 3) r, htmllabelinfo hl where r.indexid = hl.indexid and languageid = 7) loop indexidn    := tmp_cursor.indexid; labelnamen  := tmp_cursor.labelname; languageidn := tmp_cursor.languageid; delete from htmllabelinfo where indexid = indexidn; insert into htmllabelinfo values (indexidn, labelnamen, 7); insert into htmllabelinfo values (indexidn, labelnamen, 8); insert into htmllabelinfo values (indexidn, labelnamen, 9); commit; END LOOP; end;
/
create or replace procedure HrmResourceShare(resourceid_1      integer, departmentid_1    integer, subcompanyid_1    integer, managerid_1       integer, seclevel_1        integer, managerstr_1      varchar2, olddepartmentid_1 integer, oldsubcompanyid_1 integer, oldmanagerid_1    integer, oldseclevel_1     integer, oldmanagerstr_1   varchar2, flag_1            integer, flag              out integer, msg               out varchar2, thecursor         IN OUT cursor_define.weavercursor) AS supresourceid_1        integer; docid_1                integer; crmid_1                integer; prjid_1                integer; cptid_1                integer; sharelevel_1           integer; countrec               integer; managerstr_11          varchar2(4000); mainid_1               integer; subid_1                integer; secid_1                integer; members_1              varchar2(4000); contractid_1           integer; contractroleid_1       integer; sharelevel_Temp        integer; workPlanId_1           integer; m_countworkid          integer; docid_2                integer; sharelevel_2           integer; countrec_2             integer; managerId_2s_2         varchar2(4000); sepindex_2             integer; managerId_2            varchar2(4000); tempDownOwnerId_2      integer; oldsubcompanyid_1_this integer; begin if oldsubcompanyid_1 is null then oldsubcompanyid_1_this := 0; else oldsubcompanyid_1_this := oldsubcompanyid_1; end if; if (seclevel_1 <> oldseclevel_1) then update HrmResource_Trigger set seclevel = seclevel_1 where id = resourceid_1; end if; if (departmentid_1 <> olddepartmentid_1) then update HrmResource_Trigger set departmentid = departmentid_1 where id = resourceid_1; end if; if (managerstr_1 <> oldmanagerstr_1) then update HrmResource_Trigger set managerstr = managerstr_1 where id = resourceid_1; end if; if (subcompanyid_1 <> oldsubcompanyid_1_this) then update HrmResource_Trigger set subcompanyid1 = subcompanyid_1 where id = resourceid_1; end if;  if ((flag_1 = 1 and (departmentid_1 <> olddepartmentid_1 or oldsubcompanyid_1_this <> subcompanyid_1 or seclevel_1 <> oldseclevel_1)) or flag_1 = 0) then    managerstr_11 := Concat('%,', Concat(to_char(resourceid_1), ',%')); for subcontractid_cursor in (select id from CRM_Contract where (manager in (select distinct id from HrmResource_Trigger where concat(',', managerstr) like managerstr_11))) loop select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1; if countrec = 0 then insert into temptablevaluecontract values (contractid_1, 3); end if; end loop;  for contractid_cursor in (select id from CRM_Contract where manager = resourceid_1) loop contractid_1 := contractid_cursor.id; insert into temptablevaluecontract values (contractid_1, 2); end loop;  for roleids_cursor in (select roleid from SystemRightRoles where rightid = 396) loop for rolecontractid_cursor in (select distinct t1.id from CRM_Contract   t1, hrmrolemembers t2 where t2.roleid = contractroleid_1 and t2.resourceid = resourceid_1 and (t2.rolelevel = 2 or (t2.rolelevel = 0 and t1.department = departmentid_1) or (t2.rolelevel = 1 and t1.subcompanyid1 = subcompanyid_1))) loop contractid_1 := rolecontractid_cursor.id; select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1; if countrec = 0 then insert into temptablevaluecontract values (contractid_1, 2); else select sharelevel into sharelevel_1 from ContractShareDetail where contractid = contractid_1 and userid = resourceid_1 and usertype = 1; if sharelevel_1 = 1 then update ContractShareDetail set sharelevel = 2 where contractid = contractid_1 and userid = resourceid_1 and usertype = 1; end if; end if; end loop; end loop;  for sharecontractid_cursor in (select distinct t2.relateditemid, t2.sharelevel from Contract_ShareInfo t2 where ((t2.foralluser = 1 and t2.seclevel <= seclevel_1) or (t2.userid = resourceid_1) or (t2.departmentid = departmentid_1 and t2.seclevel <= seclevel_1))) loop contractid_1 := sharec
ontractid_cursor.relateditemid; sharelevel_1 := sharecontractid_cursor.sharelevel; select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1; if countrec = 0 then insert into temptablevaluecontract values (contractid_1, sharelevel_1); else select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1; if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1; end if; end if; end loop;  for sharecontractid_cursor in (select distinct t2.relateditemid, t2.sharelevel from CRM_Contract       t1, Contract_ShareInfo t2, HrmRoleMembers     t3 where t1.id = t2.relateditemid and t3.resourceid = resourceid_1 and t3.roleid = t2.roleid and t3.rolelevel >= t2.rolelevel and t2.seclevel <= seclevel_1 and ((t2.rolelevel = 0 and t1.department = departmentid_1) or (t2.rolelevel = 1 and t1.subcompanyid1 = subcompanyid_1) or (t3.rolelevel = 2))) loop contractid_1 := sharecontractid_cursor.relateditemid; sharelevel_1 := sharecontractid_cursor.sharelevel; select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1; if countrec = 0 then insert into temptablevaluecontract values (contractid_1, sharelevel_1); else select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1; if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1; end if; end if; end loop;  managerstr_11 := concat('%,', concat(to_char(resourceid_1), ',%')); for subcontractid_cursor in (select t2.id from CRM_CustomerInfo t1, CRM_Contract t2 where (t1.manager in (select distinct id from HrmResource_Trigger where concat(',', managerstr) like managerstr_11)) and (t2.crmId = t1.id)) loop contractid_1 := subcontractid_cursor.id; select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1; if countrec = 0 then insert into temptablevaluecontract values (contractid_1, 1); end if; end loop;  for contractid_cursor in (select t2.id from CRM_CustomerInfo t1, CRM_Contract t2 where (t1.manager = resourceid_1) and (t2.crmId = t1.id)) loop contractid_1 := contractid_cursor.id; insert into temptablevaluecontract values (contractid_1, 1); end loop;  delete from ContractShareDetail where userid = resourceid_1 and usertype = 1;  for allcontractid_cursor in (select * from temptablevaluecontract) loop contractid_1 := allcontractid_cursor.contractid; sharelevel_1 := allcontractid_cursor.sharelevel; insert into ContractShareDetail (contractid, userid, usertype, sharelevel) values (contractid_1, resourceid_1, 1, sharelevel_1); end loop;    for creater_cursor in (SELECT id FROM WorkPlan WHERE createrid = resourceid_1) loop workPlanId_1 := creater_cursor.id; INSERT INTO TmpTableValueWP (workPlanId, shareLevel) VALUES (workPlanId_1, 2); end loop; managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%'); for underling_cursor in (SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource_Trigger WHERE concat(',', MANAGERSTR) LIKE managerstr_11))) loop workPlanId_1 := underling_cursor.id; SELECT COUNT(workPlanId) into countrec FROM TmpTableValueWP WHERE workPlanId = workPlanId_1; IF (countrec = 0) then INSERT INTO TmpTableValueWP (workPlanId, shareLevel) VALUES (workPlanId_1, 1); end if; end loop;  end if;    if (flag_1 = 1 and managerstr_1 <> oldmanagerstr_1 and length(managerstr_1) > 1) then  managerId_2 := concat(',', managerstr_1); update shareinnerdoc set content = managerid_1 where srcfrom = 81 and opuser = resourceid_1;     for supuserid_cursor in (select distinct t1.id id_1, t2.id id_2 from HrmResource_Trigger t1, CRM_Contract t2 where managerId_2 like concat('%,', concat(to_char(t1.id), ',%')) and t2.manager = resourceid_1) loop supresourceid_1 := supuserid_cursor.id_1; contractid_1    := supuserid_cursor.id_2
; select count(contractid) into countrec from ContractShareDetail where contractid = contractid_1 and userid = supresourceid_1 and usertype = 1; if countrec = 0 then insert into ContractShareDetail (contractid, userid, usertype, sharelevel) values (contractid_1, supresourceid_1, 1, 3); end if; end loop;  for supuserid_cursor in (select distinct t1.id id_1, t3.id id_2 from HrmResource_Trigger t1, CRM_CustomerInfo    t2, CRM_Contract        t3 where managerId_2 like concat('%,', concat(to_char(t1.id), ',%')) and t2.manager = resourceid_1 and t2.id = t3.crmId) loop supresourceid_1 := supuserid_cursor.id_1; contractid_1    := supuserid_cursor.id_2; select count(contractid) into countrec from ContractShareDetail where contractid = contractid_1 and userid = supresourceid_1 and usertype = 1; if countrec = 0 then insert into ContractShareDetail (contractid, userid, usertype, sharelevel) values (contractid_1, supresourceid_1, 1, 1); end if; end loop;  end if; end;
/
CREATE OR REPLACE PROCEDURE HrmResourceSystemInfo_Insert (id_1 integer, loginid_2 varchar2, password_3 varchar2, systemlanguage_4 integer, seclevel_5 integer, email_6 varchar2, needusb1 integer, serial1 varchar2, account_2 varchar2, lloginid_2 varchar2, needdynapass_2 integer, passwordstate_2 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  AS count_1 integer; oldpass varchar2(4000); chgpasswddate char(10);  begin if loginid_2 is null or loginid_2 = '' then UPDATE HrmResource SET loginid ='',lloginid='',account='', systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6 WHERE id = id_1; else select password into oldpass from HrmResource where id=id_1; if (oldpass is null and password_3!='0' ) or oldpass!=password_3 then chgpasswddate:=to_char(sysdate,'yyyy-mm-dd'); end if; if loginid_2 is not null and loginid_2 != 'sysadmin' then select count(id)  into count_1 from HrmResource where id != id_1 and loginid = loginid_2; end if; if ( count_1 is not null and count_1 > 0 ) or loginid_2 = 'sysadmin' then open thecursor for select 0 from dual; else UPDATE HrmResource_Trigger SET seclevel = seclevel_5 WHERE id = id_1; if password_3 = '0' then if serial1='0' then UPDATE HrmResource SET loginid = loginid_2, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2,passwordstate=passwordstate_2 WHERE id = id_1; else UPDATE HrmResource SET loginid = loginid_2, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,serial=serial1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2 ,passwordstate=passwordstate_2 WHERE id = id_1; end if; else if serial1='0' then UPDATE HrmResource SET loginid = loginid_2, password = password_3, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2,passwordstate=passwordstate_2  WHERE id = id_1; else UPDATE HrmResource SET loginid = loginid_2, password = password_3, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,serial=serial1,account= account_2,lloginid=lloginid_2,needdynapass=needdynapass_2,passwordstate=passwordstate_2  WHERE id = id_1; end if; end if; end if; end if; end;
/
CREATE OR REPLACE PROCEDURE HrmResourceSystemInfo_Insert1 (id_1 integer, loginid_2 varchar2, password_3 varchar2, systemlanguage_4 integer, seclevel_5 integer, email_6 varchar2, needusb1 integer, serial1 varchar2, account_2 varchar2, lloginid_2 varchar2, needdynapass_2 integer, passwordstate_2 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  AS count_1 integer; oldpass varchar2(4000); chgpasswddate char(10);  begin if loginid_2 is null or loginid_2 = '' then UPDATE HrmResource SET loginid ='',lloginid='',account='', systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6 WHERE id = id_1; else select password into oldpass from HrmResource where id=id_1; if (oldpass is null and password_3!='0' ) or oldpass!=password_3 then chgpasswddate:=to_char(sysdate,'yyyy-mm-dd'); end if; if loginid_2 is not null and loginid_2 != 'sysadmin' then select count(id)  into count_1 from HrmResource where id != id_1 and loginid = loginid_2; end if; if loginid_2 = 'sysadmin' then open thecursor for select 0 from dual; else UPDATE HrmResource_Trigger SET seclevel = seclevel_5 WHERE id = id_1; if password_3 = '0' then if serial1='0' then UPDATE HrmResource SET loginid = loginid_2, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2,passwordstate=passwordstate_2 WHERE id = id_1; else UPDATE HrmResource SET loginid = loginid_2, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,serial=serial1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2 ,passwordstate=passwordstate_2 WHERE id = id_1; end if; else if serial1='0' then UPDATE HrmResource SET loginid = loginid_2, password = password_3, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2,passwordstate=passwordstate_2  WHERE id = id_1; else UPDATE HrmResource SET loginid = loginid_2, password = password_3, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,serial=serial1,account= account_2,lloginid=lloginid_2,needdynapass=needdynapass_2,passwordstate=passwordstate_2  WHERE id = id_1; end if; end if; end if; end if; end;
/
CREATE OR REPLACE PROCEDURE HrmResource_up_AllManagerstr as begin declare val_id integer; val_tempid integer; val_managerid integer; val_tempmanagerid integer; val_managerCount integer; var_managetstr varchar2(4000); var_hrmcount integer; cursor cursor0 is SELECT id,managerid FROM HrmResource order by id; begin var_managetstr:=''; val_tempmanagerid:=0; if cursor0%isopen = false then open cursor0; end if;  fetch cursor0 into val_id,val_managerid; while cursor0%found loop WHILE val_managerid<>0 AND val_managerid IS NOT NULL and ((val_id=val_managerid and val_managerCount=1) or (val_id<>val_managerid and val_managerCount<=2 AND instr(var_managetstr||',',','||to_char(val_managerid)||',',1)=0 )) loop val_tempmanagerid:=val_managerid; SELECT count(*) into var_hrmcount FROM HrmResource WHERE id=val_managerid; if var_hrmcount>0 then begin SELECT id into val_tempid FROM HrmResource WHERE id=val_managerid; SELECT managerid into val_managerid FROM HrmResource WHERE id=val_managerid; var_managetstr:=var_managetstr||','||to_char(val_tempid); end; end if;  if val_tempmanagerid=val_managerid then val_managerCount:=val_managerCount+1; end if;  var_hrmcount:=0; end loop;  if var_managetstr is not null then var_managetstr:=var_managetstr||','; end if;  UPDATE HrmResource SET managerstr=var_managetstr WHERE id=val_id; var_managetstr:=''; val_tempmanagerid:=0; val_managerCount:=1;  fetch cursor0 into val_id,val_managerid; end loop;  close cursor0; end; end;
/
create or replace procedure HrmRoleMembersShare(resourceid_1 integer, roleid_1     integer, rolelevel_1  integer, rolelevel_2  integer, flag_1       integer, flag         out integer, msg          out varchar2, thecursor    IN OUT cursor_define.weavercursor) AS oldrolelevel_1   char(1); oldresourceid_1  integer; oldroleid_1      integer; docid_1          integer; crmid_1          integer; prjid_1          integer; cptid_1          integer; sharelevel_1     integer; departmentid_1   integer; subcompanyid_1   integer; seclevel_1       integer; countrec         integer; countdelete      integer; countinsert      integer; managerstr_11    varchar2(4000); contractid_1     integer; contractroleid_1 integer; sharelevel_Temp  integer; workPlanId_1     integer; m_countworkid    integer; tempresourceid   integer;   loop for rolecontractid_cursor in (select distinct t1.id from CRM_Con
tract       t1, HrmRoleMembers_Tri t2 where t2.roleid = contractroleid_1 and t2.resourceid = resourceid_1 and (t2.rolelevel = 0 and t1.department = departmentid_1)) loop contractid_1 := rolecontractid_cursor.id; select count(contractid) into countrec from ContractShareDetail where contractid = contractid_1 and userid = resourceid_1 and usertype = 1; if countrec = 0 then insert into ContractShareDetail values (contractid_1, resourceid_1, 1, 2); else select sharelevel into sharelevel_1 from ContractShareDetail where contractid = contractid_1 and userid = resourceid_1 and usertype = 1; if sharelevel_1 = 1 then update ContractShareDetail set sharelevel = 2 where contractid = contractid_1 and userid = resourceid_1 and usertype = 1; end if; end if; end loop; end loop; end if; else if (flag_1 = 2 or (flag_1 = 1 and rolelevel_1 < rolelevel_2)) then   for sharecontractid_cursor in (select distinct t2.relateditemid, t2.sharelevel from Contract_ShareInfo t2 where ((t2.foralluser = 1 and t2.seclevel <= seclevel_1) or (t2.userid = resourceid_1) or (t2.departmentid = departmentid_1 and t2.seclevel <= seclevel_1))) loop contractid_1 := sharecontractid_cursor.relateditemid; sharelevel_1 := sharecontractid_cursor.sharelevel; select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1; if countrec = 0 then insert into temptablevaluecontract values (contractid_1, sharelevel_1); else select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1; if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1; end if; end if; end loop; for sharecontractid_cursor in (select distinct t2.relateditemid, t2.sharelevel from CRM_Contract       t1, Contract_ShareInfo t2, HrmRoleMembers_Tri t3 where t1.id = t2.relateditemid and t3.resourceid = resourceid_1 and t3.roleid = t2.roleid and t3.rolelevel >= t2.rolelevel and t2.seclevel <= seclevel_1 and ((t2.rolelevel = 0 and t1.department = departmentid_1) or (t2.rolelevel = 1 and t1.subcompanyid1 = subcompanyid_1) or (t3.rolelevel = 2))) loop contractid_1 := sharecontractid_cursor.relatedi
temid; sharelevel_1 := sharecontractid_cursor.sharelevel; select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1; if countrec = 0 then insert into temptablevaluecontract values (contractid_1, sharelevel_1); else select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1; if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1; end if; end if; end loop;   workPlan.id = workPlanShare.workPlanId AND workPlanShare.roleId = hrmRoleMembers_Tri.roleId AND hrmR
oleMembers_Tri.resourceid = resourceid_1 AND hrmRoleMembers_Tri.rolelevel >= workPlanShare.roleLevel AND workPlanShare.securityLevel <= seclevel_1)) loop workPlanId_1 := sharewp_cursor.workPlanId; sharelevel_1 := sharewp_cursor.shareLevel; SELECT COUNT(workPlanId) into countrec FROM TmpTableValueWP WHERE workPlanId = workPlanId_1; IF (countrec = 0) then INSERT INTO TmpTableValueWP VALUES (workPlanId_1, sharelevel_1); end if; end loop;   end if; end if; end loop; end if; end;
/
CREATE OR REPLACE PROCEDURE hrmroles_selBynameSubcom (rolesnameq_1 varchar2, subcomid_2 integer, flag out integer , msg out varchar2, thecursor in out cursor_define.weavercursor) as id_1 integer; rolesmark_1 varchar2(4000); rolesname_1 varchar2(4000); temptype_1 integer; subcomid_1 integer; id_2 integer; cnt_2 integer; CURSOR all_cursor is select id,rolesmark,rolesname,type,subcompanyid from hrmroles ; CURSOR roles_cursor is select id from hrmroles ; begin open all_cursor; loop fetch all_cursor INTO id_1,rolesmark_1,rolesname_1,temptype_1,subcomid_1; exit when all_cursor%NOTFOUND; insert into temp_table(id,rolesmark,rolesname,temptype,subcomid) values (id_1,rolesmark_1,rolesname_1,temptype_1,subcomid_1); end  loop;  open roles_cursor; loop fetch roles_cursor into id_2; exit when roles_cursor%NOTFOUND; select count(id) into cnt_2 from HrmRoleMembers where roleid=id_2; update temp_table set cnt=cnt_2 where id=id_2; end loop;  if rolesnameq_1<>'!@#$' then open thecursor for select id,rolesmark,rolesname,temptype as type,subcomid,cnt from temp_table where rolesname like concat(concat('%',rolesnameq_1),'%') and subcomid=subcomid_2 order by rolesname; else open thecursor for select id,rolesmark,rolesname,temptype as type,subcomid,cnt from temp_table where subcomid=subcomid_2 order by rolesname; end if; close roles_cursor; close all_cursor ; end;
/

CREATE OR REPLACE PROCEDURE hrmroles_selectall ( flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as id_1 integer; rolesmark_1 varchar2(4000); rolesname_1 varchar2(4000); id_2 integer; cnt_2 integer; CURSOR all_cursor is select id,rolesmark,rolesname from hrmroles ; CURSOR roles_cursor is select id from hrmroles ; begin open all_cursor; loop fetch all_cursor INTO id_1,rolesmark_1,rolesname_1; exit when all_cursor%NOTFOUND; insert into temp_table_02 (id,rolesmark,rolesname) values (id_1,rolesmark_1,rolesname_1) ; end  loop;   open roles_cursor; loop fetch roles_cursor INTO id_2; exit when roles_cursor%NOTFOUND;  select count(id) INTO cnt_2 from HrmRoleMembers where roleid=id_2 ; update  temp_table_02 set cnt=cnt_2 where id=id_2 ; end  loop; open thecursor for select id,rolesmark,rolesname,cnt from temp_table_02 order by rolesmark; close all_cursor ; close roles_cursor ; end;
/
CREATE OR REPLACE PROCEDURE hrmroles_selectallbyname (rolesnameq_1 varchar2, flag out integer , msg out varchar2, thecursor in out cursor_define.weavercursor) as id_1 integer; rolesmark_1 varchar2(4000); rolesname_1 varchar2(4000); temptype_1 integer; id_2 integer; cnt_2 integer; CURSOR all_cursor is select id,rolesmark,rolesname,type from hrmroles ; CURSOR roles_cursor is select id from hrmroles ; begin open all_cursor; loop fetch all_cursor INTO id_1,rolesmark_1,rolesname_1,temptype_1; exit when all_cursor%NOTFOUND; insert into temp_table(id,rolesmark,rolesname,temptype) values (id_1,rolesmark_1,rolesname_1,temptype_1); end  loop; open roles_cursor; loop fetch roles_cursor into id_2; exit when roles_cursor%NOTFOUND; select count(id) into cnt_2 from HrmRoleMembers where roleid=id_2; update temp_table set cnt=cnt_2 where id=id_2; end loop; if rolesnameq_1<>'!@#$' then open thecursor for select id,rolesmark,rolesname,temptype,cnt from temp_table where rolesname like concat(concat('%',rolesnameq_1),'%') order by rolesname; else open thecursor for select id,rolesmark,rolesname,temptype,cnt from temp_table order by rolesname; end if; close roles_cursor; end;
/
create or replace procedure importexpense as relatedcrm_1 integer; relatedprj_1 integer; organizationid_1 integer; occurdate_1 char(10); amount_1 number(15,3); subject_1 integer; requestid_1 integer; description_1 varchar2(4000);  begin FOR all_cursor in( select feetypeid,resourceid,crmid,projectid,amount,occurdate,releatedid,description from FnaAccountLog where iscontractid=0 or iscontractid is null) loop subject_1 := all_cursor.feetypeid; organizationid_1 := all_cursor.resourceid; relatedcrm_1 := all_cursor.crmid; relatedprj_1 := all_cursor.projectid; amount_1 := all_cursor.amount; occurdate_1 := all_cursor.occurdate; requestid_1 := all_cursor.releatedid; description_1 := all_cursor. description; insert into fnaexpenseinfo(subject,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,status,type,description) values(subject_1,3,organizationid_1,relatedcrm_1,relatedprj_1,amount_1,occurdate_1,requestid_1,1,2,description_1); end loop; end;
/
create or replace procedure importloan as relatedcrm_1 integer; relatedprj_1 integer; organizationid_1 integer; occurdate_1 char(10); amount_1 number(15,3); subject_1 integer; requestid_1 integer; description_1 varchar2(4000); loantype_1 integer; debitremark_1 varchar2(4000); processorid_1 integer; begin FOR all_cursor in( select loantypeid,resourceid,crmid,projectid,amount,occurdate,releatedid,description,credenceno,dealuser from FnaLoanLog) loop loantype_1 := all_cursor.loantypeid; organizationid_1 := all_cursor.resourceid; relatedcrm_1 := all_cursor.crmid; relatedprj_1 := all_cursor.projectid; amount_1 := all_cursor.amount; occurdate_1 := all_cursor.occurdate; requestid_1 := all_cursor.releatedid; description_1 := all_cursor.description; debitremark_1 := all_cursor.credenceno; processorid_1 := all_cursor.dealuser;  if(loantype_1!=1) then amount_1 := -1*amount_1; end if; insert into fnaloaninfo(loantype,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,remark,debitremark,processorid) values(loantype_1,3,organizationid_1,relatedcrm_1,relatedprj_1,amount_1,occurdate_1,requestid_1,description_1,debitremark_1,processorid_1); end loop; end;
/
create or replace procedure initMenuConfig as viewIndex_1        integer; useCustomName_1        integer; customName_1        varchar2(4000); customName_e_1        varchar2(4000); infoid_1        varchar2(4000);  begin  for mInfoList in( select id,defaultindex,useCustomName,customName,customName_e from mainmenuinfo) loop infoid_1:= mInfoList.id; viewIndex_1:= mInfoList.defaultindex; useCustomName_1:= mInfoList.useCustomName; customName_1:= mInfoList.customName; customName_e_1:= mInfoList.customName_e;  insert into mainmenuconfig(infoid,visible,viewIndex,resourceid,resourcetype,useCustomName,customName,customName_e) values (infoid_1,1, viewIndex_1,1,1,useCustomName_1,customName_1,customName_e_1);  insert into mainmenuconfig(infoid,visible,viewIndex,resourceid,resourcetype,useCustomName,customName,customName_e) select infoid_1,1,viewIndex_1,id,2,useCustomName_1,customName_1,customName_e_1 from hrmsubcompany; end loop; end;
/
create or replace procedure int_authorizeRight_Insert ( baseid_1  integer, type_2    varchar2, resourceids_3    varchar2, roleids_4	    varchar2, wfids_5    varchar2, ordernum_6 varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin   select MAX(id) into maxid_  from int_authorizeRight; open thecursor for  select maxid_  from dual; end;
/

create or replace procedure int_browermark_Insert ( mark_1   varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin   update int_browermark set mark=mark_1||maxid_ where id=maxid_; open thecursor for  select mark  from int_browermark where id=maxid_; end;
/
create or replace procedure int_BrowserbaseInfo_insert ( mark_1         varchar2, hpid_2   integer, poolid_3     integer, regservice_4 varchar2, brodesc_5  varchar2, authcontorl_6   varchar2, w_fid_7 integer, w_nodeid_8 integer, w_actionorder_9  integer, w_enable_10       integer, w_type_11     integer, ispreoperator_12  integer, nodelinkid_13    integer, browsertype_14    integer, isbill_15   integer, url_16   varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin  insert into int_BrowserbaseInfo (mark,hpid,poolid,regservice,brodesc,authcontorl,w_fid,w_nodeid,w_actionorder,w_enable,w_type,ispreoperator,nodelinkid,browsertype,isbill,parurl,isdelete) values (mark_1,hpid_2,poolid_3,regservice_4,brodesc_5,authcontorl_6,w_fid_7,w_nodeid_8,w_actionorder_9,w_enable_10,w_type_11,ispreoperator_12,nodelinkid_13,browsertype_14,isbill_15,url_16,0);  select MAX(id) into maxid_  from int_BrowserbaseInfo; open thecursor for  select maxid_  from dual; end;
/
CREATE OR REPLACE PROCEDURE IWorkflowCenterSettingDetailP as id_1          integer; eid_1         integer; typeids_1     varchar2(4000); flowids_1     varchar2(4000); nodeids_1     varchar2(4000); tabid_1       integer;  content_1    varchar2(4000);  srcfrom_1     integer; type_1        varchar2(4000); i integer; begin DELETE workflowcentersettingdetail ;  for shareuserid_cursor in (select id,eid, typeids, flowids, nodeids, tabid from hpsetting_wfcenter ) loop id_1:=shareuserid_cursor.id; eid_1:=shareuserid_cursor.eid; typeids_1:= dbms_lob.substr( shareuserid_cursor.typeids, 4000, 1 ); flowids_1:= dbms_lob.substr( shareuserid_cursor.flowids, 4000, 1 ); nodeids_1:= dbms_lob.substr( shareuserid_cursor.nodeids, 4000, 1 ); tabid_1:=shareuserid_cursor.tabid;  srcfrom_1:=id_1;  if length(typeids_1) >0 then begin i:=instr(typeids_1,','); type_1 := 'typeid'; while i>0 loop begin content_1:=substr(typeids_1,1,i-1);  insert into workflowcentersettingdetail (  eid, tabid, type, content, srcfrom )values(  eid_1, tabid_1, type_1, content_1, srcfrom_1 );  typeids_1:=substr(typeids_1,i   +1); i:=instr(typeids_1,',');   end; end loop; content_1:=typeids_1;  insert into workflowcentersettingdetail (  eid, tabid, type, content, srcfrom )values(  eid_1, tabid_1, type_1, content_1, srcfrom_1 ); end; end if;  if length(flowids_1) >0 then begin i:=instr(flowids_1,',');  type_1 := 'flowid'; while i>0 loop begin content_1:=substr(flowids_1,1,i-1);  insert into workflowcentersettingdetail (  eid, tabid, type, content, srcfrom )values(  eid_1, tabid_1, type_1, content_1, srcfrom_1 );  flowids_1:=substr(flowids_1,i+1);  i:=instr(flowids_1,',');   end; end loop; content_1:=flowids_1;  insert into workflowcentersettingdetail (  eid, tabid, type, content, srcfrom )values(  eid_1, tabid_1, type_1, content_1, srcfrom_1 ); end; end if;  if length(nodeids_1) >0 then begin i:=instr(nodeids_1,','); type_1 := 'nodeid'; while i>0 loop begin content_1:=substr(nodeids_1,1,i-1);  insert into workflowcentersettingdetail (  eid, tabid, type, content, srcfrom )values(  eid_1, tabid_1, type_1, content_1, srcfrom_1 );  nodeids_1:=substr(nodeids_1,i   +1); i:=instr(nodeids_1,',');   end; end loop; content_1:=nodeids_1;  insert into workflowcentersettingdetail (  eid, tabid, type, content, srcfrom )values(  eid_1, tabid_1, type_1, content_1, srcfrom_1 ); end; end if;   end loop;  end;
/
create or replace procedure LeftMenuConfig_InsertByUserId(userId_1 integer, flag     out integer, msg      out varchar2) as  id_1           integer; defaultIndex_1 integer; subcompany_id  integer; locked         char(1); locked_by_id   integer;  visible_1 char(1); viewIndex_1 integer; useCustomName_1 char(1); customName_1 varchar2(4000);  tmp_count_1 integer; tmp_count_2 integer; tmp_count_3 integer; tmp_count_4 integer;  CURSOR leftMenuInfo_cursor IS   SELECT count(0) into tmp_count_1 FROM LeftMenuConfig WHERE infoid = id_1 AND resourceId = 1 AND resourceType = '1' AND locked > 0; IF (tmp_count_1 > 0) THEN SELECT id INTO locked_by_id FROM LeftMenuConfig WHERE infoid = id_1 AND resourceId = 1 AND resourceType = '1'; ELSE SELECT subcompanyid1 into subcompany_id FROM HrmResource WHERE id = userId_1;  SELECT count(0) into tmp_count_2 FROM LeftMenuConfig WHERE infoid = id_1 AND resourceId = subcompany_id AND resourceType = '2' AND locked > 0;  IF (tmp_count_2 > 0) THEN SELECT id into locked_by_id FROM LeftMenuConfig WHERE infoid = id_1 AND resourceId = subcompany_id AND resourceType = '2'; ELSE  SELECT count(0) into tmp_count_3 FROM LeftMenuConfig WHERE infoid = id_1 AND resourceId = subcompany_id AND resourceType = '2' AND lockedbyid > 0; IF (tmp_count_3 > 0) THEN SELECT lockedbyid into locked_by_id FROM LeftMenuConfig WHERE infoid = id_1 AND resourceId = subcompany_id AND resourceType = '2'; END IF; END IF; END IF; SELECT visible,viewIndex,useCustomName,customName INTO visible_1,viewIndex_1,useCustomName_1,customName_1 FROM LeftMenuConfig WHERE infoid = id_1 AND resourceType = '2' AND resourceId = subcompany_id; END IF;  IF (locked_by_id > 0) THEN locked := '1'; END IF;  INSERT INTO LeftMenuConfig (userId, infoId, visible, viewIndex, resourceid, resourcetype, locked, lockedById, useCustomName, customName) VALUES (us
erId_1, id_1, visible_1, viewIndex_1, userId_1, '3', locked, locked_by_id, useCustomName_1, customName_1);  END LOOP;  CLOSE leftMenuInfo_cursor;  flag := 1; msg  := 'ok';  end;
/
CREATE OR REPLACE PROCEDURE LgcAssortmentMove_Move (assortmentid_1		integer, assetid_1		integer, flag out		integer , msg out			varchar2, thecursor IN OUT cursor_define.weavercursor) AS supassortmentstr_1 varchar2(4000); supassortmentstr_count integer; begin select count(supassortmentstr) into supassortmentstr_count from LgcAssetAssortment where id =  assortmentid_1; if supassortmentstr_count>0 then  select supassortmentstr into supassortmentstr_1 from LgcAssetAssortment where id =  assortmentid_1; end if; supassortmentstr_1 :=  concat(concat(supassortmentstr_1 , to_char(assortmentid_1)) , '|');  update LgcAsset set assortmentid =  assortmentid_1 , assortmentstr =  supassortmentstr_1 where id =  assetid_1; end;
/
CREATE OR REPLACE PROCEDURE LgcAttributeMove_Add (assortmentid_1 	integer, selectedattr_1  varchar2 , flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as assetattribute_x varchar2(4000); CURSOR  xx is select assetattribute from LgcAsset where assortmentid = assortmentid_1 and assetattribute not like '%'||selectedattr_1||'%'; begin open xx; fetch xx into assetattribute_x; while xx%found loop update LgcAsset set assetattribute = assetattribute_x || selectedattr_1; DBMS_OUTPUT.PUT_LINE(TO_CHAR(xx%ROWCOUNT)); fetch xx into assetattribute_x; end loop; close xx; end;
/
CREATE OR REPLACE PROCEDURE MostExceedPerson_Get( sqlStr_1  varchar2, flag      out integer, msg       out varchar2, thecursor IN OUT cursor_define.weavercursor) AS create_sql varchar2(4000); orderby_sql varchar2(4000); sqlstr_sql varchar2(4000); begin create_sql :='select userid, count(distinct workflow_requestbase.requestid) counts, (select count(requestid) from workflow_requestbase b where exists (select 1 from workflow_currentoperator a where a.requestid = b.requestid and a.userid = workflow_currentoperator.userid) and b.status is not null) countall, to_number(count(distinct workflow_requestbase.requestid) * 100) / to_number((select count(requestid) from workflow_requestbase b where exists (select 1 from workflow_currentoperator a where a.requestid = b.requestid and a.userid = workflow_currentoperator.userid) and b.status is not null)) percents from workflow_currentoperator, workflow_requestbase where workflow_currentoperator.requestid = workflow_requestbase.requestid and (24 * (to_date(NVL2(lastoperatedate, lastoperatedate || '|| ' || lastoperatetime, to_char(sysdate, '||'YYYY-MM-DD HH24:MI:SS'||')), '||'YYYY-MM-DD HH24:MI:SS'||') - to_date(createdate || '|| ' || createtime, '||'YYYY-MM-DD HH24:MI:SS'||')) - (select sum(NVL(to_number(nodepasshour), 0) + NVL(to_number(nodepassminute), 0) / 24) from workflow_nodelink where workflowid = workflow_requestbase.workflowid)  ) > 0 and workflow_requestbase.status is not null and exists (select 1 from workflow_nodelink where workflowid = workflow_requestbase.workflowid and (workflow_currentoperator.usertype = 0) and exists (select 1 from hrmresource where hrmresource.id = workflow_currentoperator.userid and hrmresource.status in (0, 1, 2, 3)) and (to_number(NVL(nodepasshour, 0)) > 0 or to_number(nvl(nodepassminute, 0)) > 0)) and workflow_currentoperator.isremark <> 4'; orderby_sql:='group by userid order by percents desc'; sqlstr_sql := create_sql || sqlStr_1 || orderby_sql; execute immediate create_sql; end;
/
CREATE OR REPLACE PROCEDURE NewDocFrontpage_SelectAllNId ( pagenumber_1     integer, perpage_1        integer, countnumber_1    integer, logintype_1		integer, usertype_1		integer, userid_1			integer, userseclevel_1	integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as pagecount_1 integer ; pagecount2_1 integer ; id_1    integer; docsubject_1 varchar2(4000); doccreatedate_1 char(10); doccreatetime_1  char(8);  CURSOR all_cursor01 is Select * from(Select distinct  c.id , c.docsubject , c.doccreatedate , c.doccreatetime from NewDocFrontpage n , DocShareDetail d , docdetail c where n.docid=d.docid and n.docid=c.id and n.userid=d.userid and  d.usertype=1 and n.userid=userid_1 and (c.docpublishtype='2' or c.docpublishtype='3') and c.docstatus in('1','2','5') order by c.doccreatedate  desc , c.doccreatetime desc ) WHERE rownum < (pagecount_1+1) ;  CURSOR all_cursor02 is Select * from(Select distinct  c.id , c.docsubject , c.doccreatedate , c.doccreatetime from NewDocFrontpage n , DocShareDetail d  , docdetail c where n.docid=d.docid and n.docid= c.id and  n.usertype = d.usertype and n.usertype=usertype_1 and d.userid <= userseclevel_1 and ( c.docpublishtype='2' or c.docpublishtype='3') and c.docstatus in('1','2','5') order by c.doccreatedate desc , c.doccreatetime desc ) WHERE rownum < (pagecount_1+1); begin  pagecount_1 :=  pagenumber_1 * perpage_1; if (countnumber_1-(pagenumber_1-1)*perpage_1) < perpage_1 then pagecount2_1  := countnumber_1-(pagenumber_1-1)*perpage_1; else pagecount2_1 := perpage_1; end if;  if logintype_1=1 then open all_cursor01; loop fetch all_cursor01 INTO id_1,docsubject_1,doccreatedate_1, doccreatetime_1; exit when all_cursor01%NOTFOUND; insert into temp_table_03 (id,docsubject,doccreatedate, doccreatetime) values (id_1,docsubject_1,doccreatedate_1, doccreatetime_1) ; end  loop; open thecursor for select * from (select * from temp_table_03 order by doccreatedate, doccreatetime) WHERE rownum<(pagecount2_1+1); end if; if logintype_1<> 1 then open all_cursor02; loop fetch all_cursor02 INTO id_1,docsubject_1,doccreatedate_1, doccreatetime_1; exit when all_cursor02%NOTFOUND; insert into temp_table_03 (id,docsubject,doccreatedate, doccreatetime) values (id_1,docsubject_1,doccreatedate_1, doccreatetime_1) ; end  loop; open thecursor for select * from (select * from temp_table_03 order by doccreatedate, doccreatetime) WHERE rownum<(pagecount2_1+1); end if; end;
/
CREATE OR REPLACE PROCEDURE NewPageInfo_Insert_All  AS id_1 integer; frontpagename_1 varchar2(4000); defaultIndex_1 integer; begin defaultIndex_1 := 1; FOR docFrontpage_cursor in( SELECT id, frontpagename FROM DocFrontpage WHERE isactive = 1 and publishtype = 1 ORDER BY id)   INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(-1000,16390,'/docs/news/DocNews.jsp','mainFrame',1,1,1000,0,0,0,9); end;
/
CREATE OR REPLACE PROCEDURE Prj_Plan_Approve (prjid_1 	integer,creater_1 integer,createdate_1 varchar2,createtime_1 varchar2, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor  ) AS  taskid_1 	integer; wbscoding_1 	varchar2(4000); subject_1 	varchar2(4000); begindate_1 	varchar2(4000); enddate_1 	varchar2(4000); workday_1        number (10,1); content_1 	varchar2(4000); fixedcost_1	number(18,2); parentid_1	integer; parentids_1	varchar2(4000); parenthrmids_1	varchar2(4000); level_1		smallint; hrmid_1		integer;   CURSOR all_cursor is select   id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid from Prj_TaskProcess where prjid = prjid_1;  begin open all_cursor; loop fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1; exit when all_cursor%NOTFOUND;  INSERT INTO Prj_TaskInfo (  prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid, isactived, version,creater,createdate,createtime) VALUES (  prjid_1, taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1,2,1,creater_1,createdate_1,createtime_1); end  loop;  CLOSE all_cursor; end;
/
CREATE OR REPLACE PROCEDURE Prj_Plan_SaveFromProcess (prjid_1 	integer, version_1	smallint,creater_1 integer,createdate_1 varchar2,createtime_1 varchar2, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor  ) AS taskid_1 	integer; wbscoding_1 	varchar2(4000); subject_1 	varchar2(4000); begindate_1 	varchar2(4000); enddate_1 	varchar2(4000); workday_1        number (10,1); content_1 	varchar2(4000); fixedcost_1	number(10,2); parentid_1	integer; parentids_1	varchar2(4000); parenthrmids_1	varchar2(4000); level_1		smallint; hrmid_1		integer;taskindex_1		integer;  CURSOR all_cursor is select  id , wbscoding, subject , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex from Prj_TaskProcess where prjid = prjid_1;  begin open all_cursor; loop fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1,parentid_1,parentids_1,parenthrmids_1,level_1,hrmid_1,taskindex_1; exit when all_cursor%NOTFOUND;  INSERT INTO Prj_TaskInfo ( prjid, taskid , wbscoding, subject ,begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid,taskindex, isactived, version,creater,createdate,createtime) VALUES (  prjid_1, taskid_1 , wbscoding_1, subject_1 , begindate_1, enddate_1, workday_1, content_1, fixedcost_1, parentid_1, parentids_1, parenthrmids_1, level_1, hrmid_1,taskindex_1,'1',version_1,creater_1,createdate_1,createtime_1); end  loop;   CLOSE all_cursor; end;
/
CREATE OR REPLACE PROCEDURE Prj_TaskInfo_NewPlan ( prjid_1 	  integer, oldversion_1  varchar2 , newversion_1  varchar2, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor  ) AS taskid_1 	integer; wbscoding_1 	varchar2(4000); subject_1 	varchar2(4000); version_1 	smallint; begindate_1 	varchar2(4000); enddate_1 	varchar2(4000); workday_1        number (10,1); content_1 	varchar2(4000); fixedcost_1	 number(10,2); temp_1		smallint; temp_count integer;    CURSOR all_cursor is select  taskid , wbscoding, subject , begindate, enddate, workday, content, fixedcost from Prj_TaskInfo where prjid =prjid_1 and version=temp_1; begin  select count(version) INTO  temp_count from prj_taskinfo where prjid=prjid_1; if(temp_count>0)then select max(version) INTO  temp_1 from prj_taskinfo where prjid=prjid_1; version_1 := temp_1 + 1; end if; open all_cursor; loop fetch all_cursor INTO taskid_1,wbscoding_1,subject_1,begindate_1,enddate_1, workday_1,content_1,fixedcost_1; exit when all_cursor%NOTFOUND; INSERT INTO Prj_TaskInfo ( prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost) VALUES (prjid_1,taskid_1 ,wbscoding_1,subject_1 ,version_1 ,begindate_1,enddate_1,workday_1,content_1,fixedcost_1); end  loop; CLOSE all_cursor;  update Prj_Member set version = concat(version , newversion_1)   WHERE (prjid =prjid_1  and version like   concat(concat('%' ,oldversion_1) , '%') ); update Prj_Tool set version = concat(version , newversion_1)   WHERE (prjid =prjid_1  and version like  concat(concat('%' ,oldversion_1) , '%') ); update Prj_Material set version = concat(version , newversion_1)   WHERE (prjid =prjid_1  and version like  concat(concat('%' ,oldversion_1) , '%') ); end;
/
CREATE OR REPLACE PROCEDURE Prj_TaskProcess_Insert (prjid_1 	integer, taskid_2 	integer, wbscoding_3 	varchar2, subject_4 	varchar2 , version_5 	smallint, begindate_6 	varchar2, enddate_7 	varchar2, workday_8  number, content_9 	varchar2, fixedcost_10  number , parentid_11  integer, parentids_12 varchar2, parenthrmids_13 varchar2, level_n_14 smallint, hrmid_15 integer, prefinish_16 varchar2, realManDays_17 number , taskIndex_18 integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS dsporder_9 integer; current_maxid integer; current_maxids integer; id_1 integer; maxid_1 varchar2(4000); maxhrmid_1 varchar2(4000); begin  select count(id) into current_maxids from Prj_TaskProcess where prjid = prjid_1 and version = version_5 and parentid = parentid_11 and isdelete!='1' ;  if current_maxids> 0 then select max(dsporder) into current_maxid from Prj_TaskProcess where prjid = prjid_1 and version = version_5 and parentid = parentid_11 and isdelete!='1' ; dsporder_9 := current_maxid + 1; end if;  if current_maxids= 0 then select max(dsporder) into current_maxid from Prj_TaskProcess where prjid = prjid_1 and version = version_5 and parentid = parentid_11 and isdelete!='1' ;  current_maxid := 0; dsporder_9 := current_maxid + 1;  end if;  INSERT INTO Prj_TaskProcess (prjid, taskid , wbscoding, subject , version , begindate, enddate, workday, content, fixedcost, parentid, parentids, parenthrmids, level_n, hrmid, islandmark, prefinish, dsporder, realManDays, taskIndex ) VALUES ( prjid_1, taskid_2 , wbscoding_3, subject_4 , version_5 , begindate_6, enddate_7, workday_8, content_9, fixedcost_10, parentid_11, parentids_12, parenthrmids_13, level_n_14, hrmid_15, '0', prefinish_16, dsporder_9, realManDays_17, taskIndex_18); select max(id) into id_1 from Prj_TaskProcess ; maxid_1 := concat(to_char(id_1) , ','); maxhrmid_1 := concat(concat(concat(concat('|' , to_char(id_1)) , ',' ),to_char(hrmid_15) ), '|'); update Prj_TaskProcess set parentids =concat(concat('',concat(parentids_12,maxid_1)),''), parenthrmids = concat(concat('''',concat(parenthrmids_13,maxhrmid_1)),'''') where id=id_1; select max(id) into flag from  Prj_TaskProcess; msg := 'OK!'; end;
/
CREATE OR REPLACE PROCEDURE Prj_TaskProcess_UParentHrmIds( hrmid_1 integer, oldhrmid_2 integer, id_3 integer, flag out integer  , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) AS currenthrmid varchar2(4000); currentoldhrmid varchar2(4000); begin if hrmid_1<>oldhrmid_2 then currenthrmid := concat(concat(concat(concat('|',to_char(id_3)), ','), to_char(hrmid_1)),'|'); currentoldhrmid := concat(concat(concat(concat('|' , to_char(id_3)), ','), to_char(oldhrmid_2)), '|'); UPDATE Prj_TaskProcess set parenthrmids = replace(parenthrmids,currentoldhrmid,currenthrmid) where (parenthrmids like concat(concat('%',currentoldhrmid),'%')); end if; end;
/
CREATE OR REPLACE PROCEDURE Prj_TaskProcess_UpdateParent (parentid_1	integer,	 flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) AS  begindate_1 varchar2(4000); enddate_1 varchar2(4000); workday_1 number; finish_1 number; begin  select  min(begindate), max(enddate), sum(workday) , to_number(sum(workday*finish)/sum(workday)) INTO begindate_1, enddate_1, workday_1,finish_1 from Prj_TaskProcess where parentid=parentid_1; if finish_1 > 100 then finish_1 := 100; end if; UPDATE Prj_TaskProcess  SET   begindate = begindate_1, enddate = enddate_1, workday = workday_1, finish = finish_1 WHERE ( id = parentid_1); end;
/
create or replace procedure sap_complexname_Insert ( baseid_1  integer, comtype_2    varchar2, name_3        varchar2, backtable_4 varchar2, backoper_5  integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin   select MAX(id) into maxid_  from sap_complexname; open thecursor for  select maxid_  from dual; end;
/
create or replace procedure sap_inParameter_Insert ( baseid_1   integer, sapfield_2 varchar2, oafield_3  varchar2, constant_4 varchar2, ordernum_5 varchar2, ismainfield_6  varchar2, fromfieldid_7 varchar2, isbill_8       varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin   select MAX(id) into maxid_  from sap_inParameter; open thecursor for  select maxid_  from dual; end;
/
create or replace procedure sap_inStructure_Insert ( baseid_1  integer, nameid_2    varchar2, sapfield_3    varchar2, oafield_4	    varchar2, constant_5    varchar2, ordernum_6  varchar2, orderGroupnum_7  varchar2, ismainfield_8  varchar2, fromfieldid_9  varchar2, isbill_10          varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin   select MAX(id) into maxid_  from sap_inStructure; open thecursor for  select maxid_  from dual; end;
/
create or replace procedure sap_inTable_Insert ( baseid_1  integer, nameid_2    varchar2, sapfield_3    varchar2, oafield_4	    varchar2, constant_5    varchar2, ordernum_6  varchar2, orderGroupnum_7  varchar2, ismainfield_8  varchar2, fromfieldid_9  varchar2, isbill_10    varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin   select MAX(id) into maxid_  from sap_inTable; open thecursor for  select maxid_  from dual; end;
/
create or replace procedure sap_outParameter_Insert ( baseid_1  integer, sapfield_2   varchar2, showname_3   varchar2, Display_4    varchar2, ordernum_5  varchar2, oafield_6  varchar2, ismainfield_7  varchar2, fromfieldid_8   varchar2, isbill_9   varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin   select MAX(id) into maxid_  from sap_outParameter; open thecursor for  select maxid_  from dual; end;
/
create or replace procedure sap_outparaprocess_Insert ( baseid_1  integer, nameid_2   varchar2, sapfield_3    varchar2, oafield_4    varchar2, constant_5  varchar2, ordernum_6  varchar2, ismainfield_7  varchar2, fromfieldid_8  varchar2, isbill_9          varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin   select MAX(id) into maxid_  from sap_outparaprocess; open thecursor for  select maxid_  from dual; end;
/
create or replace procedure sap_outStructure_Insert ( baseid_1  integer, nameid_2    varchar2, sapfield_3   varchar2, showname_4    varchar2, Display_5  varchar2, Search_6  varchar2, ordernum_7  integer, orderGroupnum_8   integer, oafield_9      varchar2, ismainfield_10 	varchar2, fromfieldid_11 varchar2, isbill_12   varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin   select MAX(id) into maxid_  from sap_outStructure; open thecursor for  select maxid_  from dual; end;
/
create or replace procedure sap_outTable_Insert ( baseid_1  integer, nameid_2    varchar2, sapfield_3   varchar2, showname_4    varchar2, Display_5  varchar2, Search_6  varchar2, Primarykey_7 varchar2, ordernum_8  varchar2, orderGroupnum_9 varchar2, oafield_10   varchar2, ismainfield_11 varchar2, fromfieldid_12 varchar2, isbill_13     varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as maxid_ varchar2(4000); begin   select MAX(id) into maxid_  from sap_outTable; open thecursor for  select maxid_  from dual; end;
/
CREATE OR REPLACE PROCEDURE SysRemindInfo_DeleteHasendwf ( userid1		integer, usertype1	integer, requestid1	integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as  tmp varchar2(4000); tmp_count integer; begin select  count(hasendwf) INTO tmp_count  from SysRemindInfo where userid = userid1 and usertype = usertype1; if tmp_count = 1 then select  hasendwf INTO tmp  from SysRemindInfo where userid = userid1 and usertype = usertype1; end if;  if tmp is not null  then  tmp := Replace( concat(concat(',',tmp),','),  concat(concat(',', to_char(requestid1)),',') ,  ',');  if length (tmp) < 2  then tmp := ''; else tmp := SUBSTR(tmp,2,length(tmp)-2); end if; update SysRemindInfo set hasendwf = tmp where userid = userid1 and usertype = usertype1; end if;  tmp_count := 0 ;  select  count(hasendwf) INTO tmp_count  from SysPopRemindInfo where userid = userid1 and usertype = usertype1; if tmp_count = 1 then select  hasendwf INTO tmp  from SysPopRemindInfo where userid = userid1 and usertype = usertype1; end if;  if tmp is not null  then  tmp := Replace( concat(concat(',',tmp),','),  concat(concat(',', to_char(requestid1)),',') ,  ',');  if length (tmp) < 2  then tmp := ''; else tmp := SUBSTR(tmp,2,length(tmp)-2); end if; update SysPopRemindInfo set hasendwf = tmp where userid = userid1 and usertype = usertype1; end if; end;
/
CREATE OR REPLACE PROCEDURE SysRemindInfo_DeleteHasnewwf ( userid1		integer, usertype1	integer, requestid1	integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as tmp varchar2(4000); tmp_count integer; begin select  count(hasnewwf) INTO tmp_count from SysRemindInfo where userid = userid1 and usertype = usertype1; if(tmp_count=1)then select  hasnewwf INTO tmp from SysRemindInfo where userid = userid1 and usertype = usertype1; end if;  if tmp is not null then tmp := Replace( concat(concat(',',tmp),','),  concat(concat(',', to_char(requestid1)),',') ,  ','); if length(tmp) < 2 then tmp := null; else tmp := SUBSTR(tmp,2,length(tmp)-2); end if; update SysRemindInfo set hasnewwf = tmp where userid = userid1 and usertype = usertype1; end if;  tmp_count := 0 ;  select  count(hasnewwf) INTO tmp_count from SysPopRemindInfo where userid = userid1 and usertype = usertype1; if(tmp_count=1)then select  hasnewwf INTO tmp from SysPopRemindInfo where userid = userid1 and usertype = usertype1; end if;  if tmp is not null then tmp := Replace( concat(concat(',',tmp),','),  concat(concat(',', to_char(requestid1)),',') ,  ','); if length(tmp) < 2 then tmp := null; else tmp := SUBSTR(tmp,2,length(tmp)-2); end if; update SysPopRemindInfo set hasnewwf = tmp where userid = userid1 and usertype = usertype1; end if; end;
/
CREATE OR REPLACE PROCEDURE SysRemindInfo_InserHasendwf ( userid1		integer, usertype1	integer, requestid1	integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as tmpid integer ; tmp varchar2(4000); recordcount integer; begin select count(*) INTO recordcount  from SysRemindInfo where userid = userid1 and usertype = usertype1; if recordcount>0 then select hasendwf , userid INTO tmp, tmpid  from SysRemindInfo where userid = userid1 and usertype = usertype1; if tmp = '' or tmp is null then update SysRemindInfo set hasendwf = to_char(requestid1) where userid = userid1 and usertype = usertype1; else if instr( concat(concat(',',tmp),','), concat(concat(',', to_char(requestid1)),',') ,1,1)=0 then update SysRemindInfo set hasendwf = concat(concat(hasendwf ,','),to_char(requestid1)) where userid = userid1 and usertype = usertype1; end if; end if; else insert into SysRemindInfo(userid,usertype,hasendwf) values(userid1,usertype1,to_char(requestid1)); end if;  recordcount := 0 ;  select count(*) INTO recordcount  from SysPopRemindInfo where userid = userid1 and usertype = usertype1; if recordcount>0 then select hasendwf , userid INTO tmp, tmpid  from SysPopRemindInfo where userid = userid1 and usertype = usertype1; if tmp = '' or tmp is null then update SysPopRemindInfo set hasendwf = to_char(requestid1) where userid = userid1 and usertype = usertype1; else if instr( concat(concat(',',tmp),','), concat(concat(',', to_char(requestid1)),',') ,1,1)=0 then update SysPopRemindInfo set hasendwf = concat(concat(hasendwf ,','),to_char(requestid1)) where userid = userid1 and usertype = usertype1; end if; end if; else insert into SysPopRemindInfo(userid,usertype,hasendwf) values(userid1,usertype1,to_char(requestid1)); end if; end;
/
CREATE OR REPLACE PROCEDURE SysRemindInfo_InserHasnewwf ( userid1		integer, usertype1	integer, requestid1	integer, flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor ) as tmpid integer ; tmp varchar2(4000); recordcount integer; begin select count(*) INTO recordcount  from SysRemindInfo where userid = userid1 and usertype = usertype1; if recordcount=0 then insert into SysRemindInfo(userid,usertype,hasnewwf) values(userid1,usertype1,to_char(requestid1)); else select userid,hasnewwf into   tmpid, tmp from SysRemindInfo where userid = userid1 and usertype = usertype1; if tmp = '' or tmp is null then update SysRemindInfo set hasnewwf = to_char(requestid1) where userid = userid1 and usertype = usertype1; else if instr (  concat(concat(',',tmp),',') , concat(concat(',', to_char(requestid1)),',') , 1, 1 )=0 then update SysRemindInfo set hasnewwf =concat(concat(hasendwf ,','),to_char(requestid1)) where userid = userid1 and usertype = usertype1; end if; end if; end if;  recordcount := 0 ;  select count(*) INTO recordcount  from SysPopRemindInfo where userid = userid1 and usertype = usertype1; if recordcount=0 then insert into SysPopRemindInfo(userid,usertype,hasnewwf) values(userid1,usertype1,to_char(requestid1)); else select userid,hasnewwf into   tmpid, tmp from SysPopRemindInfo where userid = userid1 and usertype = usertype1; if tmp = '' or tmp is null then update SysPopRemindInfo set hasnewwf = to_char(requestid1) where userid = userid1 and usertype = usertype1; else if instr (  concat(concat(',',tmp),',') , concat(concat(',', to_char(requestid1)),',') , 1, 1 )=0 then update SysPopRemindInfo set hasnewwf =concat(concat(hasendwf ,','),to_char(requestid1)) where userid = userid1 and usertype = usertype1; end if; end if; end if; end;
/
CREATE OR REPLACE PROCEDURE SystemRight_selectRightGroup ( flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )  as id_1 integer; groupname_1 varchar2(4000); count_1 integer; count_2 integer; begin  select count(*) into count_1  from SystemRights ; insert into temp_table_01 (id,groupname,cnt)  values(-1,'ȫ��',count_1) ;  for right_cursor in (select id , rightgroupname from SystemRightGroups  where id<>-2 order by id ) loop id_1 := right_cursor.id; groupname_1 := right_cursor.rightgroupname; select count(rightid) INTO  count_1  from SystemRightToGroup where groupid= id_1; insert into temp_table_01 (id,groupname,cnt)  values (id_1,groupname_1,count_1) ; end loop;  select  count(distinct a.id) into count_2 from SystemRights a left join SystemRightToGroup b on a.id=b.rightid where b.rightid is null; insert into temp_table_01 (id,groupname,cnt)  values(-2,'����Ȩ����',count_2);  open thecursor for select id,groupname,cnt from temp_table_01 ; end;
/
CREATE OR REPLACE PROCEDURE WorkFlowPending_Get( sqlStr_1  varchar2, flag      out integer, msg       out varchar2, thecursor IN OUT cursor_define.weavercursor) AS  create_sql  varchar2(4000); orderby_sql varchar2(4000); sqlstr_sql  varchar2(4000);  begin create_sql  := 'SELECT userid, COUNT(requestid) AS Expr1 FROM workflow_currentoperator WHERE (isremark IN (' || '0||'', '||'1||'', '||'5||'')) AND (islasttimes = 1) AND (usertype = 0) and exists (select 1 from hrmresource where hrmresource.id=workflow_currentoperator.userid and hrmresource.status in (0,1,2,3) )'; orderby_sql := 'GROUP BY userid ORDER BY COUNT(requestid) desc'; sqlstr_sql  := create_sql || sqlStr_1 || orderby_sql; execute immediate create_sql; end;
/
CREATE OR REPLACE PROCEDURE Share_forDoc
(
    docid_1 integer ,
    flag out integer, 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor
)
AS 
 sharetype_1 integer;
 newsharetype_1 integer;
 sharecontent_1 varchar2(4000);
 sharelevel_1 integer;
 foralluser_1 integer;
 departmentid_1 integer;
 subcompanyid_1 integer;
 userid_1 integer;
 ownerid_1 integer;
 createrid_1 integer;
 crmid_1 integer;
 orgGroupId_1 integer;
 temp_userid_1 integer;
 srcfrom_1 integer;
 opuser_1 integer;
 temp_departmentid_1 integer ;

 roleid_1 integer;
 rolelevel_1 integer;
 rolevalue_1 integer;
 seclevel_1 integer;
 sharesource_1 integer;

 isExistInner_1 integer;
 isExistOuter_1 integer;
  isSysadmin_1 integer;
  hasmanager_1        integer;
 count_1 integer;
 count_2 integer;
 count_3 integer;
 count_4 integer;
 count_5 integer;
 downloadlevel_1 integer;
BEGIN
    
    DELETE ShareinnerDoc  WHERE  sourceid=docid_1;
    DELETE ShareouterDoc  WHERE  sourceid=docid_1;

    
    for shareuserid_cursor in(select docid,sharetype,seclevel,userid,subcompanyid,departmentid,foralluser,sharelevel,roleid,rolelevel,crmid,orgGroupId,sharesource,downloadlevel 
    from docshare where docid=docid_1 and docid>0)
    loop
        sharetype_1 := shareuserid_cursor.sharetype;
        seclevel_1 := shareuserid_cursor.seclevel;
        userid_1 := shareuserid_cursor.userid;
        subcompanyid_1 := shareuserid_cursor.subcompanyid;
        departmentid_1 := shareuserid_cursor.departmentid;
        foralluser_1 := shareuserid_cursor.foralluser;
        sharelevel_1 := shareuserid_cursor.sharelevel;
        roleid_1 := shareuserid_cursor.roleid;
        rolelevel_1 := shareuserid_cursor.rolelevel;
        crmid_1 := shareuserid_cursor.crmid;
        orgGroupId_1 := shareuserid_cursor.orgGroupId;
        sharesource_1 := shareuserid_cursor.sharesource;
      downloadlevel_1:= shareuserid_cursor.downloadlevel;
        isExistInner_1:=0;
        isExistOuter_1:=0;
      if downloadlevel_1 is null then
            downloadlevel_1 := 0;
      end if;

        if sharetype_1=1  then  
           begin
                newsharetype_1 := 1;
                sharecontent_1 := userid_1 ;
                seclevel_1 := 0;
                srcfrom_1 := 1;
                opuser_1 := userid_1;

                isExistInner_1 := 1;
           end;
           
          elsif sharetype_1=2 then 
          begin
                newsharetype_1 := 2;
                sharecontent_1 := subcompanyid_1 ;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 2;
                opuser_1 := subcompanyid_1;
                isExistInner_1 := 1;
           end;  
           
           elsif  sharetype_1=3 then
           begin
                newsharetype_1 := 3;
                sharecontent_1 := departmentid_1; 
                seclevel_1 := seclevel_1;
                srcfrom_1 := 3;
                opuser_1 := departmentid_1;

                isExistInner_1 := 1;
           end;  

           elsif  sharetype_1=6 then
           begin
                newsharetype_1 := 6;
                sharecontent_1 := orgGroupId_1; 
                seclevel_1 := seclevel_1;
                srcfrom_1 := 6;
                opuser_1 := orgGroupId_1;

                isExistInner_1 := 1;
           end; 
     
           elsif sharetype_1=5  then
           begin
                newsharetype_1 := 5;
                sharecontent_1 := 1 ;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 5;
                opuser_1 := 0;

                isExistInner_1 := 1;

           end;
           
           elsif  sharetype_1=80 then 
           begin
                newsharetype_1 := 1;
                sharecontent_1 := userid_1 ;
                seclevel_1 := 0;
                srcfrom_1 := 80;
                opuser_1 := userid_1;
                isExistInner_1 := 1;

        select count(id) into count_1  from docdetail where id = docid_1;
        if count_1 >0 then
        select  ownerid into ownerid_1 from docdetail where id = docid_1;
        select doccreaterid into createrid_1 from docdetail where id = docid_1;
        end if;
        if (ownerid_1 != createrid_1) then
           insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) 
           values(docid_1,1,ownerid_1,0,sharelevel_1,86,0,0, downloadlevel_1); 
        end if; 
           end; 
                      
          elsif  sharetype_1=81  then
          begin
              
        select  count(*) into isSysadmin_1 from hrmresourcemanager where id = userid_1;
        select count(*)  into hasmanager_1  from hrmresource a,hrmresource b     where a.id=b.managerid and b.id= userid_1;
        if (isSysadmin_1 !=1 and hasmanager_1 = 1)  
        then                
          newsharetype_1 :=1;
          SELECT  managerid into count_2 FROM HrmResource where id = userid_1;
          if count_2 >=1 then
            SELECT  managerid into sharecontent_1 FROM HrmResource where id = userid_1;
          end if;
          seclevel_1 := 0;
          srcfrom_1 := 81;
          opuser_1 := userid_1;

          isExistInner_1 := 1;
         end  if;     
       end; 
           elsif  sharetype_1=84 then 
              begin
           
           select count(*) into isSysadmin_1 from hrmresourcemanager where id=userid_1;                   
                  if (isSysadmin_1!=1)   
                  then 
                  newsharetype_1 := 2;
                            
                  SELECT  count(departmentid) into count_3  FROM HrmResource where id=userid_1;
          if count_3 >=1 then
          SELECT departmentid into temp_departmentid_1  FROM HrmResource where id=userid_1;
          end if;
          select  count (subcompanyid1) into count_4  from  HrmDepartment where id = temp_departmentid_1;
          if count_4 >=1 then
                  select  subcompanyid1 into sharecontent_1   from  HrmDepartment where id = temp_departmentid_1;
          end if;
                    seclevel_1 := seclevel_1;
                    srcfrom_1 := 84;
                    opuser_1 := userid_1;

                    isExistInner_1 := 1;
                  end if;
        end; 
             elsif  sharetype_1=85 then 
              begin
                   
                  
          select count(*) into isSysadmin_1 from hrmresourcemanager where id=userid_1;
                  if (isSysadmin_1 != 1)   
                  then 
                 newsharetype_1 := 3;
                 SELECT count(departmentid) into count_5 FROM HrmResource where id=userid_1;
                   if count_5 >=1 then
                   SELECT departmentid into sharecontent_1 FROM HrmResource where id=userid_1;
                   end if;
                 seclevel_1 := seclevel_1;
                   srcfrom_1 := 85;
                   opuser_1 := userid_1;

                   isExistInner_1 := 1;
                  end if;
        end;  
              
              elsif  sharetype_1=-81 then 
          begin
               newsharetype_1 := 1;    
              select manager into sharecontent_1 from CRM_CustomerInfo where id=userid_1; 
               seclevel_1 := 0;
               srcfrom_1 := -81;
               opuser_1 := userid_1;

               isExistInner_1 := 1;
          end; 
       elsif  sharetype_1=9 then 
          begin
               newsharetype_1 := 9  ;           
               sharecontent_1:=crmid_1;
               seclevel_1 := 0;
               srcfrom_1 := 9;
               opuser_1 := crmid_1;

               isExistOuter_1 := 1;
          end; 

        elsif  sharetype_1=-80  then
          begin
               newsharetype_1 := 9  ;           
               sharecontent_1:=userid_1;
               seclevel_1 := 0;
               srcfrom_1 := -80;
               opuser_1 := userid_1;

               isExistOuter_1 := 1;
          end; 
         elsif  sharetype_1<0  then 
          begin
               newsharetype_1 := 10;           
               sharecontent_1:=sharetype_1*-1;

               srcfrom_1 := 10;
               opuser_1 := sharetype_1;

               isExistOuter_1 := 1;
          end; 
      elsif  sharetype_1=4  then 
          begin  
               newsharetype_1:=4;                                   
               
               srcfrom_1:=4;
               opuser_1:=roleid_1;
               
               if newsharetype_1 is null then  newsharetype_1:=0; end if;
               if sharecontent_1 is null then  sharecontent_1:=0; end if;
               if seclevel_1 is null then  seclevel_1:=0;  end if;
               if sharelevel_1 is null then  sharelevel_1:=0;  end if;
               if srcfrom_1 is null then  srcfrom_1:=0;  end if;
               if opuser_1 is null then  opuser_1:=0;  end if;
               if sharesource_1 is null then  sharesource_1:=0;  end if;
               
               IF rolelevel_1=0 then 
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(0));
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 );
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 );     
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 );
              END;
              elsIF rolelevel_1=1 then                        
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 )     ;
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 )     ;
              END;
              elsIF rolelevel_1=2 then
              BEGIN
                 sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
                 insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1 )     ;
              END;
              end if;
               isExistInner_1:=0;  
            end;   
           end if; 
           
            IF  isExistInner_1=1 then
             BEGIN                 
                 if newsharetype_1 is null then  newsharetype_1:=0; end if ;
                 if sharecontent_1 is null then  sharecontent_1:=0; end if ;
                 if seclevel_1 is null then  seclevel_1:=0; end if ;
                 if sharelevel_1 is null then  sharelevel_1:=0; end if ;
                 if srcfrom_1 is null then  srcfrom_1:=0; end if ;
                 if opuser_1 is null then  opuser_1:=0; end if ;
                  if sharesource_1 is null then  sharesource_1:=0; end if ;

                                          
                 insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1);             
             END; 
             End if;

             IF  isExistOuter_1=1  then
             BEGIN                 
                 if newsharetype_1 is null then  newsharetype_1:=0; end if ;
                 if sharecontent_1 is null then  sharecontent_1:=0; end if ;
                 if seclevel_1 is null then  seclevel_1:=0; end if ;
                 if sharelevel_1 is null then  sharelevel_1:=0; end if ;
                 if srcfrom_1 is null then  srcfrom_1:=0; end if ;
                 if opuser_1 is null then  opuser_1:=0; end if ;
                 if sharesource_1 is null then  sharesource_1:=0; end if ;

                 
                 insert into ShareouterDoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource,downloadlevel) values (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1,downloadlevel_1);
             END;
             End if;
      end loop;
       EXCEPTION WHEN OTHERS THEN
       BEGIN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            RETURN;
        END;
END;

/
CREATE OR REPLACE PROCEDURE Share_forDoc_init
(
    docid_1 integer
)
AS
 sharetype_1 integer;
 newsharetype_1 integer;
 sharecontent_1 varchar2(4000);
 sharelevel_1 integer;
 foralluser_1 integer;
 departmentid_1 integer;
 subcompanyid_1 integer;
 userid_1 integer;
 ownerid_1 integer;
 createrid_1 integer;
 crmid_1 integer;
 temp_userid_1 integer;
 srcfrom_1 integer;
 opuser_1 integer;
 temp_departmentid_1 integer ;

 roleid_1 integer;
 rolelevel_1 integer;
 rolevalue_1 integer;
 seclevel_1 integer;
 sharesource_1 integer;

 isExistInner_1 integer;
 isExistOuter_1 integer;
  isSysadmin_1 integer;
 count_1 integer;
 count_2 integer;
 count_3 integer;
 count_4 integer;
 count_5 integer;
BEGIN


    
    for shareuserid_cursor in(select docid,sharetype,seclevel,userid,subcompanyid,departmentid,foralluser,sharelevel,roleid,rolelevel,crmid,sharesource
    from docshare where docid=docid_1 and docid>0)
    loop
        sharetype_1 := shareuserid_cursor.sharetype;
        seclevel_1 := shareuserid_cursor.seclevel;
        userid_1 := shareuserid_cursor.userid;
        subcompanyid_1 := shareuserid_cursor.subcompanyid;
        departmentid_1 := shareuserid_cursor.departmentid;
        foralluser_1 := shareuserid_cursor.foralluser;
        sharelevel_1 := shareuserid_cursor.sharelevel;
        roleid_1 := shareuserid_cursor.roleid;
        rolelevel_1 := shareuserid_cursor.rolelevel;
        crmid_1 := shareuserid_cursor.crmid;
        sharesource_1 := shareuserid_cursor.sharesource;

        isExistInner_1:=0;
        isExistOuter_1:=0;


        if sharetype_1=1  then 
           begin
                newsharetype_1 := 1;
                sharecontent_1 := userid_1 ;
                seclevel_1 := 0;
                srcfrom_1 := 1;
                opuser_1 := userid_1;

                isExistInner_1 := 1;
           end;

          elsif sharetype_1=2 then 
          begin
                newsharetype_1 := 2;
                sharecontent_1 := subcompanyid_1 ;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 2;
                opuser_1 := subcompanyid_1;
                isExistInner_1 := 1;
           end;

           elsif  sharetype_1=3 then
           begin
                newsharetype_1 := 3;
                sharecontent_1 := departmentid_1;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 3;
                opuser_1 := departmentid_1;

                isExistInner_1 := 1;
           end;

           elsif sharetype_1=5  then
           begin
                newsharetype_1 := 5;
                sharecontent_1 := 1 ;
                seclevel_1 := seclevel_1;
                srcfrom_1 := 5;
                opuser_1 := 0;

                isExistInner_1 := 1;

           end;

           elsif  sharetype_1=80 then 
           begin
                newsharetype_1 := 1;
                sharecontent_1 := userid_1 ;
                seclevel_1 := 0;
                srcfrom_1 := 80;
                opuser_1 := userid_1;
                isExistInner_1 := 1;

        select count(id) into count_1  from docdetail where id = docid_1;
        if count_1 >0 then
        select  ownerid into ownerid_1 from docdetail where id = docid_1;
        select doccreaterid into createrid_1 from docdetail where id = docid_1;
        end if;
        if (ownerid_1 != createrid_1) then
           insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource)
           values(docid_1,1,ownerid_1,0,sharelevel_1,86,0,0);
        end if;
           end;

          elsif  sharetype_1=81  then
          begin
              
        select  count(*) into isSysadmin_1 from hrmresourcemanager where id = userid_1;
        if (isSysadmin_1 !=1)
        then
          newsharetype_1 :=1;
          SELECT  managerid into count_2 FROM HrmResource where id = userid_1;
          if count_2 >=1 then
            SELECT  managerid into sharecontent_1 FROM HrmResource where id = userid_1;
          end if;
          seclevel_1 := 0;
          srcfrom_1 := 81;
          opuser_1 := userid_1;

          isExistInner_1 := 1;
         end  if;
       end;
           elsif  sharetype_1=84 then 
              begin

           select count(*) into isSysadmin_1 from hrmresourcemanager where id=userid_1;
                  if (isSysadmin_1!=1)
                  then
                  newsharetype_1 := 2;

                  SELECT  count(departmentid) into count_3  FROM HrmResource where id=userid_1;
          if count_3 >=1 then
          SELECT departmentid into temp_departmentid_1  FROM HrmResource where id=userid_1;
          end if;
          select  count (subcompanyid1) into count_4  from  HrmDepartment where id = temp_departmentid_1;
          if count_4 >=1 then
                  select  subcompanyid1 into sharecontent_1   from  HrmDepartment where id = temp_departmentid_1;
          end if;
                    seclevel_1 := seclevel_1;
                    srcfrom_1 := 84;
                    opuser_1 := userid_1;

                    isExistInner_1 := 1;
                  end if;
        end;
             elsif  sharetype_1=85 then 
              begin

                  
          select count(*) into isSysadmin_1 from hrmresourcemanager where id=userid_1;
                  if (isSysadmin_1 != 1)
                  then
                 newsharetype_1 := 3;
                 SELECT count(departmentid) into count_5 FROM HrmResource where id=userid_1;
                   if count_5 >=1 then
                   SELECT departmentid into sharecontent_1 FROM HrmResource where id=userid_1;
                   end if;
                 seclevel_1 := seclevel_1;
                   srcfrom_1 := 85;
                   opuser_1 := userid_1;

                   isExistInner_1 := 1;
                  end if;
        end;

              elsif  sharetype_1=-81 then 
          begin
               newsharetype_1 := 1;
              select manager into sharecontent_1 from CRM_CustomerInfo where id=userid_1; 
               seclevel_1 := 0;
               srcfrom_1 := -81;
               opuser_1 := userid_1;

               isExistInner_1 := 1;
          end;
       elsif  sharetype_1=9 then 
          begin
               newsharetype_1 := 9  ;
               sharecontent_1:=crmid_1;
               seclevel_1 := 0;
               srcfrom_1 := 9;
               opuser_1 := crmid_1;

               isExistOuter_1 := 1;
          end;

        elsif  sharetype_1=-80  then
          begin
               newsharetype_1 := 9  ;
               sharecontent_1:=userid_1;
               seclevel_1 := 0;
               srcfrom_1 := -80;
               opuser_1 := userid_1;

               isExistOuter_1 := 1;
          end;
         elsif  sharetype_1<0 and sharetype_1>-80 then 
          begin
               newsharetype_1 := 10;
               sharecontent_1:=sharetype_1*-1;

               srcfrom_1 := 10;
               opuser_1 := sharetype_1;

               isExistOuter_1 := 1;
          end;
      elsif  sharetype_1=4  then
          begin
               newsharetype_1:=4;

               srcfrom_1:=4;
               opuser_1:=roleid_1;

               if newsharetype_1 is null then  newsharetype_1:=0; end if;
               if sharecontent_1 is null then  sharecontent_1:=0; end if;
               if seclevel_1 is null then  seclevel_1:=0;  end if;
               if sharelevel_1 is null then  sharelevel_1:=0;  end if;
               if srcfrom_1 is null then  srcfrom_1:=0;  end if;
               if opuser_1 is null then  opuser_1:=0;  end if;
               if sharesource_1 is null then  sharesource_1:=0;  end if;

               IF rolelevel_1=0 then 
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(0));
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 );
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 );
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 );
              END;
              elsIF rolelevel_1=1 then
              BEGIN
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(1)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 )     ;
                sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
               insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 )     ;
              END;
              elsIF rolelevel_1=2 then
              BEGIN
                 sharecontent_1:=to_number(to_char(roleid_1)||to_char(2)) ;
                 insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values  (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1 )     ;
              END;
              end if;
               isExistInner_1:=0;  
            end;
           end if;

            IF  isExistInner_1=1 then
             BEGIN
                 if newsharetype_1 is null then  newsharetype_1:=0; end if ;
                 if sharecontent_1 is null then  sharecontent_1:=0; end if ;
                 if seclevel_1 is null then  seclevel_1:=0; end if ;
                 if sharelevel_1 is null then  sharelevel_1:=0; end if ;
                 if srcfrom_1 is null then  srcfrom_1:=0; end if ;
                 if opuser_1 is null then  opuser_1:=0; end if ;
                  if sharesource_1 is null then  sharesource_1:=0; end if ;

                 
                 insert into ShareinnerDoc  (sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1);
             END;
             End if;

             IF  isExistOuter_1=1  then
             BEGIN
                 if newsharetype_1 is null then  newsharetype_1:=0; end if ;
                 if sharecontent_1 is null then  sharecontent_1:=0; end if ;
                 if seclevel_1 is null then  seclevel_1:=0; end if ;
                 if sharelevel_1 is null then  sharelevel_1:=0; end if ;
                 if srcfrom_1 is null then  srcfrom_1:=0; end if ;
                 if opuser_1 is null then  opuser_1:=0; end if ;
                 if sharesource_1 is null then  sharesource_1:=0; end if ;

                 
                 insert into ShareouterDoc(sourceid,type,content,seclevel,sharelevel,srcfrom,opuser,sharesource) values (docid_1,newsharetype_1,sharecontent_1,seclevel_1,sharelevel_1,srcfrom_1,opuser_1,sharesource_1);
             END;
             End if;
      end loop;
       EXCEPTION WHEN OTHERS THEN
       BEGIN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            RETURN;
        END;
END;

/

CREATE or REPLACE procedure Doc_GetPermittedCategory(userid_1        integer,
                                                     usertype_1      integer,
                                                     seclevel_1      integer,
                                                     operationcode_1 integer,
                                                     departmentid_1  integer,
                                                     subcompanyid_1  integer,
                                                     roleid_1        varchar2,
                                                     flag            out integer,
                                                     msg             out varchar2,
                                                     thecursor       IN OUT cursor_define.weavercursor) as
  secdirid_1     integer;
  secdirname_1   varchar2(4000);
  subdirid_1     integer;
  subdirid1_1    integer;
  superdirid_1   integer;
  superdirtype_1 integer;
  maindirid_1    integer;
  subdirname_1   varchar2(4000);
  count_1        integer;
  orderid_1      float;
begin
  if usertype_1 = 0 then
    for secdir_cursor in (select id mainid,
                                 categoryname,
                                 subcategoryid,
                                 secorder
                            from DocSecCategory
                           where id in
                                 (select distinct sourceid
                                    from DirAccessControlDetail
                                   where sharelevel = operationcode_1
                                     and ((type = 1 and
                                         content = departmentid_1 and
                                         seclevel <= seclevel_1) or
                                         (type = 2 and
                                         content in
                                         (select *
                                              from TABLE(CAST(SplitStr(roleid_1,
                                                                       ',') AS
                                                              mytable))) and
                                         seclevel <= seclevel_1) or
                                         (type = 3 and
                                         seclevel <= seclevel_1) or
                                         (type = 4 and content = usertype_1 and
                                         seclevel <= seclevel_1) or
                                         (type = 5 and content = userid_1) or
                                         (type = 6 and
                                         content = subcompanyid_1 and
                                         seclevel <= seclevel_1)))) loop
      secdirid_1   := secdir_cursor.mainid;
      secdirname_1 := secdir_cursor.categoryname;
      subdirid_1   := secdir_cursor.subcategoryid;
      orderid_1    := secdir_cursor.secorder;
      insert into temp_4
        (categoryid,
         categorytype,
         superdirid,
         superdirtype,
         categoryname,
         orderid)
      values
        (secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
      if subdirid_1 is null then
        subdirid_1 := -1;
      end if;
      if subdirid_1 = 0 then
        subdirid_1 := -1;
      end if;
      while subdirid_1 <> -1 loop
        select subcategoryid,
               categoryname,
               subcategoryid,
               maincategoryid,
               suborder
          into subdirid1_1,
               subdirname_1,
               superdirid_1,
               maindirid_1,
               orderid_1
          from DocSubCategory
         where id = subdirid_1;
        if superdirid_1 = -1 then
          superdirid_1   := maindirid_1;
          superdirtype_1 := 0;
        else
          superdirtype_1 := 1;
        end if;
        count_1 := 0;
        select count(categoryid)
          into count_1
          from temp_4
         where categoryid = subdirid_1
           and categorytype = 1;
        if count_1 <= 0 then
          insert into temp_4
            (categoryid,
             categorytype,
             superdirid,
             superdirtype,
             categoryname,
             orderid)
          values
            (subdirid_1,
             1,
             superdirid_1,
             superdirtype_1,
             subdirname_1,
             orderid_1);
        end if;
        subdirid_1 := subdirid1_1;
      end loop;
    end loop;
  else
    for secdir_cursor in (select id mainid,
                                 categoryname,
                                 subcategoryid,
                                 secorder
                            from DocSecCategory
                           where id in
                                 (select distinct dirid mainid
                                    from DirAccessControlList
                                   where dirtype = 2
                                     and operationcode = operationcode_1
                                     and ((permissiontype = 3 and
                                         seclevel <= seclevel_1) or
                                         (permissiontype = 4 and
                                         usertype = usertype_1 and
                                         seclevel <= seclevel_1)))) loop
      secdirid_1   := secdir_cursor.mainid;
      secdirname_1 := secdir_cursor.categoryname;
      subdirid_1   := secdir_cursor.subcategoryid;
      orderid_1    := secdir_cursor.secorder;
      insert into temp_4
        (categoryid,
         categorytype,
         superdirid,
         superdirtype,
         categoryname,
         orderid)
      values
        (secdirid_1, 2, subdirid_1, 1, secdirname_1, orderid_1);
      if subdirid_1 is null then
        subdirid_1 := -1;
      end if;
      if subdirid_1 = 0 then
        subdirid_1 := -1;
      end if;
      while subdirid_1 <> -1 loop
        select subcategoryid,
               categoryname,
               subcategoryid,
               maincategoryid,
               suborder
          into subdirid1_1,
               subdirname_1,
               superdirid_1,
               maindirid_1,
               orderid_1
          from DocSubCategory
         where id = subdirid_1;
        if superdirid_1 = -1 then
          superdirid_1   := maindirid_1;
          superdirtype_1 := 0;
        else
          superdirtype_1 := 1;
        end if;
        count_1 := 0;
        select count(categoryid)
          into count_1
          from temp_4
         where categoryid = subdirid_1
           and categorytype = 1;
        if count_1 <= 0 then
          insert into temp_4
            (categoryid,
             categorytype,
             superdirid,
             superdirtype,
             categoryname,
             orderid)
          values
            (subdirid_1,
             1,
             superdirid_1,
             superdirtype_1,
             subdirname_1,
             orderid_1);
        end if;
        subdirid_1 := subdirid1_1;
      end loop;
    end loop;
  end if;
  for maindir_cursor in (select id, categoryname, categoryorder
                           from DocMainCategory
                          where id in (select distinct superdirid
                                         from temp_4
                                        where superdirtype = 0)) loop
    subdirid_1   := maindir_cursor.id;
    subdirname_1 := maindir_cursor.categoryname;
    orderid_1    := maindir_cursor.categoryorder;
    insert into temp_4
      (categoryid,
       categorytype,
       superdirid,
       superdirtype,
       categoryname,
       orderid)
    values
      (subdirid_1, 0, -1, -1, subdirname_1, orderid_1);
  end loop;
  open thecursor for
    select * from temp_4 order by orderid, categoryid;
end;
/
create or replace procedure HrmResourceShare(resourceid_1      integer,
                                             departmentid_1    integer,
                                             subcompanyid_1    integer,
                                             managerid_1       integer,
                                             seclevel_1        integer,
                                             managerstr_1      varchar2,
                                             olddepartmentid_1 integer,
                                             oldsubcompanyid_1 integer,
                                             oldmanagerid_1    integer,
                                             oldseclevel_1     integer,
                                             oldmanagerstr_1   varchar2,
                                             flag_1            integer,
                                             flag              out integer,
                                             msg               out varchar2,
                                             thecursor         IN OUT cursor_define.weavercursor) AS
  supresourceid_1        integer;
  docid_1                integer;
  crmid_1                integer;
  prjid_1                integer;
  cptid_1                integer;
  sharelevel_1           integer;
  countrec               integer;
  managerstr_11          varchar2(4000);
  mainid_1               integer;
  subid_1                integer;
  secid_1                integer;
  members_1              varchar2(4000);
  contractid_1           integer;
  contractroleid_1       integer;
  sharelevel_Temp        integer;
  workPlanId_1           integer;
  m_countworkid          integer;
  docid_2                integer;
  sharelevel_2           integer;
  countrec_2             integer;
  managerId_2s_2         varchar2(4000);
  sepindex_2             integer;
  managerId_2            varchar2(4000);
  tempDownOwnerId_2      integer;
  oldsubcompanyid_1_this integer;
begin
  if oldsubcompanyid_1 is null then
    oldsubcompanyid_1_this := 0;
  else
    oldsubcompanyid_1_this := oldsubcompanyid_1;
  end if;
  if (seclevel_1 <> oldseclevel_1) then
    update HrmResource_Trigger
       set seclevel = seclevel_1
     where id = resourceid_1;
  end if;
  if (departmentid_1 <> olddepartmentid_1) then
    update HrmResource_Trigger
       set departmentid = departmentid_1
     where id = resourceid_1;
  end if;
  if (managerstr_1 <> oldmanagerstr_1) then
    update HrmResource_Trigger
       set managerstr = managerstr_1
     where id = resourceid_1;
  end if;
  if (subcompanyid_1 <> oldsubcompanyid_1_this) then
    update HrmResource_Trigger
       set subcompanyid1 = subcompanyid_1
     where id = resourceid_1;
  end if;

  if ((flag_1 = 1 and (departmentid_1 <> olddepartmentid_1 or
     oldsubcompanyid_1_this <> subcompanyid_1 or
     seclevel_1 <> oldseclevel_1)) or flag_1 = 0) then
  
    managerstr_11 := Concat('%,', Concat(to_char(resourceid_1), ',%'));
    for subcontractid_cursor in (select id
                                   from CRM_Contract
                                  where (manager in
                                        (select distinct id
                                            from HrmResource_Trigger
                                           where concat(',', managerstr) like
                                                 managerstr_11))) loop
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract values (contractid_1, 3);
      end if;
    end loop;
  
    for contractid_cursor in (select id
                                from CRM_Contract
                               where manager = resourceid_1) loop
      contractid_1 := contractid_cursor.id;
      insert into temptablevaluecontract values (contractid_1, 2);
    end loop;
  
    for roleids_cursor in (select roleid
                             from SystemRightRoles
                            where rightid = 396) loop
      for rolecontractid_cursor in (select distinct t1.id
                                      from CRM_Contract   t1,
                                           hrmrolemembers t2
                                     where t2.roleid = contractroleid_1
                                       and t2.resourceid = resourceid_1
                                       and (t2.rolelevel = 2 or
                                           (t2.rolelevel = 0 and
                                           t1.department = departmentid_1) or
                                           (t2.rolelevel = 1 and
                                           t1.subcompanyid1 =
                                           subcompanyid_1))) loop
        contractid_1 := rolecontractid_cursor.id;
        select count(contractid)
          into countrec
          from temptablevaluecontract
         where contractid = contractid_1;
        if countrec = 0 then
          insert into temptablevaluecontract values (contractid_1, 2);
        else
          select sharelevel
            into sharelevel_1
            from ContractShareDetail
           where contractid = contractid_1
             and userid = resourceid_1
             and usertype = 1;
          if sharelevel_1 = 1 then
            update ContractShareDetail
               set sharelevel = 2
             where contractid = contractid_1
               and userid = resourceid_1
               and usertype = 1;
          end if;
        end if;
      end loop;
    end loop;
  
    for sharecontractid_cursor in (select distinct t2.relateditemid,
                                                   t2.sharelevel
                                     from Contract_ShareInfo t2
                                    where ((t2.foralluser = 1 and
                                          t2.seclevel <= seclevel_1) or
                                          (t2.userid = resourceid_1) or
                                          (t2.departmentid = departmentid_1 and
                                          t2.seclevel <= seclevel_1))) loop
      contractid_1 := sharecontractid_cursor.relateditemid;
      sharelevel_1 := sharecontractid_cursor.sharelevel;
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract
        values
          (contractid_1, sharelevel_1);
      else
        select sharelevel
          into sharelevel_Temp
          from temptablevaluecontract
         where contractid = contractid_1;
        if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
          update temptablevaluecontract
             set sharelevel = sharelevel_1
           where contractid = contractid_1;
        end if;
      end if;
    end loop;
  
    for sharecontractid_cursor in (select distinct t2.relateditemid,
                                                   t2.sharelevel
                                     from CRM_Contract       t1,
                                          Contract_ShareInfo t2,
                                          HrmRoleMembers     t3
                                    where t1.id = t2.relateditemid
                                      and t3.resourceid = resourceid_1
                                      and t3.roleid = t2.roleid
                                      and t3.rolelevel >= t2.rolelevel
                                      and t2.seclevel <= seclevel_1
                                      and ((t2.rolelevel = 0 and
                                          t1.department = departmentid_1) or
                                          (t2.rolelevel = 1 and
                                          t1.subcompanyid1 =
                                          subcompanyid_1) or
                                          (t3.rolelevel = 2))) loop
      contractid_1 := sharecontractid_cursor.relateditemid;
      sharelevel_1 := sharecontractid_cursor.sharelevel;
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract
        values
          (contractid_1, sharelevel_1);
      else
        select sharelevel
          into sharelevel_Temp
          from temptablevaluecontract
         where contractid = contractid_1;
        if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
          update temptablevaluecontract
             set sharelevel = sharelevel_1
           where contractid = contractid_1;
        end if;
      end if;
    end loop;
  
    managerstr_11 := concat('%,', concat(to_char(resourceid_1), ',%'));
    for subcontractid_cursor in (select t2.id
                                   from CRM_CustomerInfo t1, CRM_Contract t2
                                  where (t1.manager in
                                        (select distinct id
                                            from HrmResource_Trigger
                                           where concat(',', managerstr) like
                                                 managerstr_11))
                                    and (t2.crmId = t1.id)) loop
      contractid_1 := subcontractid_cursor.id;
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract values (contractid_1, 1);
      end if;
    end loop;
  
    for contractid_cursor in (select t2.id
                                from CRM_CustomerInfo t1, CRM_Contract t2
                               where (t1.manager = resourceid_1)
                                 and (t2.crmId = t1.id)) loop
      contractid_1 := contractid_cursor.id;
      insert into temptablevaluecontract values (contractid_1, 1);
    end loop;
  
    delete from ContractShareDetail
     where userid = resourceid_1
       and usertype = 1;
  
    for allcontractid_cursor in (select * from temptablevaluecontract) loop
      contractid_1 := allcontractid_cursor.contractid;
      sharelevel_1 := allcontractid_cursor.sharelevel;
      insert into ContractShareDetail
        (contractid, userid, usertype, sharelevel)
      values
        (contractid_1, resourceid_1, 1, sharelevel_1);
    end loop;
  
    for creater_cursor in (SELECT id
                             FROM WorkPlan
                            WHERE createrid = resourceid_1) loop
      workPlanId_1 := creater_cursor.id;
      INSERT INTO TmpTableValueWP
        (workPlanId, shareLevel)
      VALUES
        (workPlanId_1, 2);
    end loop;
    managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%');
    for underling_cursor in (SELECT id
                               FROM WorkPlan
                              WHERE (createrid IN
                                    (SELECT DISTINCT id
                                        FROM HrmResource_Trigger
                                       WHERE concat(',', MANAGERSTR) LIKE
                                             managerstr_11))) loop
      workPlanId_1 := underling_cursor.id;
      SELECT COUNT(workPlanId)
        into countrec
        FROM TmpTableValueWP
       WHERE workPlanId = workPlanId_1;
      IF (countrec = 0) then
        INSERT INTO TmpTableValueWP
          (workPlanId, shareLevel)
        VALUES
          (workPlanId_1, 1);
      end if;
    end loop;
  
  end if;

  if (flag_1 = 1 and managerstr_1 <> oldmanagerstr_1 and
     length(managerstr_1) > 1) then
  
    managerId_2 := concat(',', managerstr_1);
    update shareinnerdoc
       set content = managerid_1
     where srcfrom = 81
       and opuser = resourceid_1;
  
    for supuserid_cursor in (select distinct t1.id id_1, t2.id id_2
                               from HrmResource_Trigger t1, CRM_Contract t2
                              where managerId_2 like
                                    concat('%,',
                                           concat(to_char(t1.id), ',%'))
                                and t2.manager = resourceid_1) loop
      supresourceid_1 := supuserid_cursor.id_1;
      contractid_1    := supuserid_cursor.id_2;
      select count(contractid)
        into countrec
        from ContractShareDetail
       where contractid = contractid_1
         and userid = supresourceid_1
         and usertype = 1;
      if countrec = 0 then
        insert into ContractShareDetail
          (contractid, userid, usertype, sharelevel)
        values
          (contractid_1, supresourceid_1, 1, 3);
      end if;
    end loop;
  
    for supuserid_cursor in (select distinct t1.id id_1, t3.id id_2
                               from HrmResource_Trigger t1,
                                    CRM_CustomerInfo    t2,
                                    CRM_Contract        t3
                              where managerId_2 like
                                    concat('%,',
                                           concat(to_char(t1.id), ',%'))
                                and t2.manager = resourceid_1
                                and t2.id = t3.crmId) loop
      supresourceid_1 := supuserid_cursor.id_1;
      contractid_1    := supuserid_cursor.id_2;
      select count(contractid)
        into countrec
        from ContractShareDetail
       where contractid = contractid_1
         and userid = supresourceid_1
         and usertype = 1;
      if countrec = 0 then
        insert into ContractShareDetail
          (contractid, userid, usertype, sharelevel)
        values
          (contractid_1, supresourceid_1, 1, 1);
      end if;
    end loop;
  
  end if;
end;
/
CREATE or REPLACE PROCEDURE workflow_requeststatus_Select(userid_1     integer,
                                                          requestid_1  integer,
                                                          workflowid_1 integer,
                                                          flag         out integer,
                                                          msg          out varchar2,
                                                          thecursor    IN OUT cursor_define.weavercursor) AS
  mcount         integer;
  viewnodeidstmp varchar2(4000);
  viewnodeids    varchar2(4000);
begin
  select count(*)
    into mcount
    from workflow_monitor_bound
   where monitorhrmid = userid_1
     and workflowid = workflowid_1;

  if mcount > 0 then
    open thecursor for
      select a.nodeid,
             b.nodename,
             a.userid,
             a.isremark,
             a.usertype,
             a.agentorbyagentid,
             a.agenttype,
             a.receivedate,
             a.receivetime,
             a.operatedate,
             a.operatetime,
             a.viewtype
        from (SELECT distinct requestid,
                              userid,
                              workflow_currentoperator.workflowid,
                              workflowtype,
                              isremark,
                              usertype,
                              workflow_currentoperator.nodeid,
                              agentorbyagentid,
                              agenttype
                              
                             ,
                              receivedate,
                              receivetime,
                              viewtype,
                              iscomplete
                              
                             ,
                              operatedate,
                              operatetime,
                              nodetype
                FROM workflow_currentoperator, workflow_flownode
               where workflow_currentoperator.nodeid =
                     workflow_flownode.nodeid
                 and requestid = requestid_1) a,
             workflow_nodebase b
       where a.nodeid = b.id
         and a.requestid = requestid_1
         and a.agenttype <> 1
       order by a.receivedate, a.receivetime, a.nodetype;
  
  else
  
    viewnodeids := '';
    for c1 in (select b.viewnodeids
                 from (SELECT distinct requestid,
                                       userid,
                                       workflow_currentoperator.workflowid,
                                       workflowtype,
                                       isremark,
                                       usertype,
                                       workflow_currentoperator.nodeid,
                                       agentorbyagentid,
                                       agenttype
                                       
                                      ,
                                       receivedate,
                                       receivetime,
                                       viewtype,
                                       iscomplete
                                       
                                      ,
                                       operatedate,
                                       operatetime,
                                       nodetype
                         FROM workflow_currentoperator, workflow_flownode
                        where workflow_currentoperator.nodeid =
                              workflow_flownode.nodeid
                          and requestid = requestid_1) a,
                      workflow_flownode b
                where a.workflowid = b.workflowid
                  and a.nodeid = b.nodeid
                  and a.requestid = requestid_1
                  and a.userid = userid_1
                  and a.usertype = 0) loop
      viewnodeidstmp := c1.viewnodeids;
      if viewnodeidstmp = '-1' then
        viewnodeids := '-1';
        exit;
      else
        viewnodeids := CONCAT(viewnodeids, viewnodeidstmp);
      end if;
    end loop;
  
    if viewnodeids = '-1' then
      open thecursor for
        select a.nodeid,
               b.nodename,
               a.userid,
               a.isremark,
               a.usertype,
               a.agentorbyagentid,
               a.agenttype,
               a.receivedate,
               a.receivetime,
               a.operatedate,
               a.operatetime,
               a.viewtype
          from (SELECT distinct requestid,
                                userid,
                                workflow_currentoperator.workflowid,
                                workflowtype,
                                isremark,
                                usertype,
                                workflow_currentoperator.nodeid,
                                agentorbyagentid,
                                agenttype
                                
                               ,
                                receivedate,
                                receivetime,
                                viewtype,
                                iscomplete
                                
                               ,
                                operatedate,
                                operatetime,
                                nodetype
                  FROM workflow_currentoperator, workflow_flownode
                 where workflow_currentoperator.nodeid =
                       workflow_flownode.nodeid
                   and requestid = requestid_1) a,
               workflow_nodebase b
         where a.nodeid = b.id
           and a.requestid = requestid_1
           and a.agenttype <> 1
         order by a.receivedate, a.receivetime, a.nodetype;
    else
      viewnodeids := trim(viewnodeids);
      if viewnodeids <> '' then
        viewnodeids := substr(viewnodeids, 1, length(viewnodeids) - 1);
        open thecursor for
          select a.nodeid,
                 b.nodename,
                 a.userid,
                 a.isremark,
                 a.usertype,
                 a.agentorbyagentid,
                 a.agenttype,
                 a.receivedate,
                 a.receivetime,
                 a.operatedate,
                 a.operatetime,
                 a.viewtype
            from (SELECT distinct requestid,
                                  userid,
                                  workflow_currentoperator.workflowid,
                                  workflowtype,
                                  isremark,
                                  usertype,
                                  workflow_currentoperator.nodeid,
                                  agentorbyagentid,
                                  agenttype
                                  
                                 ,
                                  receivedate,
                                  receivetime,
                                  viewtype,
                                  iscomplete
                                  
                                 ,
                                  operatedate,
                                  operatetime,
                                  nodetype
                    FROM workflow_currentoperator, workflow_flownode
                   where workflow_currentoperator.nodeid =
                         workflow_flownode.nodeid
                     and requestid = requestid_1) a,
                 workflow_nodebase b
           where a.nodeid = b.id
             and a.requestid = requestid_1
             and a.agenttype <> 1
           order by a.receivedate, a.receivetime, a.nodetype;
      end if;
    end if;
  end if;
end;
/