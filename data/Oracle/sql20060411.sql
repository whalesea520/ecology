CREATE OR REPLACE PROCEDURE DocShareDetail_SetByDoc(
        docid_1  integer ,
        createrid_2  integer ,
        owenerid_3  integer , 
        usertype_4  integer ,
        replydocid_5  integer ,
        departmentid_6  integer ,
        subcompanyid_7  integer , 
        managerid_8 integer ,
        considermanager_9 integer,
        flag out integer, 
        msg out varchar2,
        thecursor IN OUT cursor_define.weavercursor
)
AS
        recordercount integer;
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
        recordcounts integer;
        
        hrmallmanagerid_re varchar2(255);    
        temppos integer;
        tempHrmManager integer;
        tempDownUserId integer;
        sameSubUserId integer;
        subCompId integer;
        samedepartmentId integer;
        sameDepartUserId integer;
begin  
    if (usertype_4 <>1) then
    begin
         for shareuserid_cursor in(select  sharetype,sharelevel,userid from  docshare  where docid=docid_1 and  sharetype between  -82 and -80)
         loop
              tempsharetype := shareuserid_cursor.sharetype;
              tempsharelevel := shareuserid_cursor.sharelevel;
              tempuserid := shareuserid_cursor.userid;         
                if (tempsharetype=-80)  then /*外部用户创建人本人*/
                     if (tempsharelevel!=0)   then
                         insert into temptablevalue_3 values (tempuserid,2, tempsharelevel);
                         if createrid_2!=owenerid_3 then/*如果文档所有者和文档创建者不是一个人,则文档所有者默认为完全控制权限*/                        
                             insert into temptablevalue_3 values (owenerid_3,2, tempsharelevel);
                         end if;
                     end if;   
                 elsif (tempsharetype=-81)  then/*外部用户创建人经理*/ 
                     begin            
                          select count(manager) into recordcounts  from  CRM_CustomerInfo where  id=tempuserid;
                          if recordcounts>0 then
                                select manager into crmManagerId from CRM_CustomerInfo  where id=tempuserid;
                                 if (tempsharelevel!=0)    then
                                      insert into temptablevalue_3(userid,usertype,sharelevel) values(crmManagerId,1,tempsharelevel);
                                  end if; 
                          end if;
                      end;
                  elsif (tempsharetype=-82) then /*外部用户创建人经理的所有上级*/
                      begin
                        select count(manager) into recordcounts  from  CRM_CustomerInfo where  id=tempuserid; 
                        if recordcounts>0 then
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
                      end;                 
                 end if;                        
         end loop;
     end;
     else   /*对于内部用户的操作 +80 ~ +85*/
     begin
          for shareuserid_cursor in(select  sharetype,sharelevel,userid,seclevel from  docshare  where docid=docid_1 and  sharetype  between   80 and 85)
          loop
              tempsharetype := shareuserid_cursor.sharetype;
              tempsharelevel := shareuserid_cursor.sharelevel;
              tempuserid := shareuserid_cursor.userid;
              tempseclevel :=shareuserid_cursor.seclevel;
              if (tempsharetype=80) then  /*内部用户创建人本人*/
                   begin
                      if (tempsharelevel!=0) then
                            begin
                             tempsharelevelold := 0;
                             select count(sharelevel) into recordcounts   from temptablevalue_3 where userid=tempuserid and usertype=1;
                             if recordcounts> 0 then
                                select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=tempuserid  and usertype=1;
                             end if;   
                             
                             if (tempsharelevelold=0)  then   /*插入数据*/
                                  insert into  temptablevalue_3(userid,usertype,sharelevel) values (tempuserid,1,tempsharelevel);
                             elsif (tempsharelevel>tempsharelevelold)  then   /*更新数据*/
                                  update temptablevalue_3  set sharelevel=tempsharelevel where userid=tempuserid  and usertype=1;
                             end if;
                             
                             if createrid_2!=owenerid_3  then/*如果文档所有者和文档创建者不是一个人,则文档所有者默认为完全控制权限*/
                             begin
                                   tempsharelevelold :=0;
                                    select sharelevel into tempsharelevelold  from temptablevalue_3 where userid=owenerid_3  and usertype=1;
                                    if (tempsharelevelold=0) then/*插入数据*/
                                         insert into  temptablevalue_3(userid,usertype,sharelevel)values(owenerid_3,1,tempsharelevel);
                                    elsif(tempsharelevel>tempsharelevelold)  then/*更新数据*/
                                         update temptablevalue_3  set sharelevel=tempsharelevel where userid=owenerid_3 and usertype=1;
                                    end if;
                             end;
                             end if;
                         end; 
                       end if;
                   end;  
                   elsif (tempsharetype=81)  then /*内部用户创建人直接上级*/
                   begin
                      if (tempsharelevel!=0) then
                      begin
                         select count(managerid) into recordcounts  from  hrmresource where id=tempuserid;
                         if recordcounts>0 then
                           begin
                                select managerid into hrmManager  from hrmresource where id=tempuserid;
                                if hrmManager >=0 then                                
                                     tempsharelevelold := 0;                              
                                end if;
                           end;
                           end if; 
                            
                           select count(sharelevel) into recordcounts   from temptablevalue_3 where userid=hrmManager and usertype=1;
                           if recordcounts>0  then
                               select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=hrmManager  and usertype=1;
                           end if;
                           
                           if (tempsharelevelold=0)   then/*插入数据*/
                             insert into  temptablevalue_3(userid,usertype,sharelevel)  values(hrmManager,1,tempsharelevel);
                           elsif (tempsharelevel>tempsharelevelold)  then/*更新数据*/
                             update temptablevalue_3  set sharelevel=tempsharelevel where userid=hrmManager;
                           end if;     
                           
                      end;
                      end if;                      
                   end;   
                   elsif (tempsharetype=82)  then /*内部用户创建人本人间接上级*/
                   begin
                      if (tempsharelevel!=0) then
                      begin
                        select  managerstr into hrmallmanagerid   from hrmresource where id=tempuserid;
                         hrmallmanagerid_re :=  to_char(hrmallmanagerid) ;
                         temppos := INSTR(hrmallmanagerid_re, ',') ;
                         temppos := INSTR(hrmallmanagerid_re,',',temppos+1);
                         if  temppos<>0  then
                             hrmallmanagerid_re := SUBSTR(hrmallmanagerid_re,temppos,length(hrmallmanagerid_re));
                         end if;    /*hrmJmangers为间拉上级*/
                         hrmJmangers := to_char(hrmallmanagerid_re);
                         sepindex := INSTR(hrmJmangers,',')  ;
                         while  (sepindex != 0)
                         loop
                             tempHrmManager := to_number( SUBSTR (hrmJmangers,1,(sepindex-1)));
                             hrmJmangers := SUBSTR(hrmJmangers,(sepindex+1),(length(hrmJmangers)-sepindex));
                             sepindex := INSTR(hrmJmangers,',') ;
                             tempsharelevelold := 0;
                             SELECT count(sharelevel) into recordcounts from temptablevalue_3 where  userid=tempHrmManager  and usertype=1;

                             if recordcounts>0 then
                                 select sharelevel into tempsharelevelold  from temptablevalue_3 where  userid=tempHrmManager  and usertype=1;
                             end if;

                             if (tempsharelevelold=0) then/*插入数据*/
                                 insert into  temptablevalue_3(userid,usertype,sharelevel)values(tempHrmManager,1,tempsharelevel);
                             elsif (tempsharelevel>tempsharelevelold) then /*更新数据*/
                                 update temptablevalue_3  set sharelevel=tempsharelevel where userid=tempHrmManager and usertype=1 ;
                             end if;

                         end  loop;
                      end;
                      end if;
                   end; 
                   elsif (tempsharetype=83)  then  /*内部用户创建人下属*/
                   begin
                      if (tempsharelevel!=0) then
                      begin
                         for temp_cursor in(select id from  hrmresource where concat(',',managerstr) like concat(concat('%,',to_char(tempuserid)),',%') and seclevel>=tempseclevel and loginid is not   null)
                         loop
                         begin
                             tempDownUserId := temp_cursor.id;
                             tempsharelevelold := 0;
                              select sharelevel into tempsharelevelold  from temptablevalue_3 where userid=tempDownUserId and usertype=1 ;
                               if (tempsharelevelold=0)   then /*插入数据*/
                                 insert into  temptablevalue_3(userid,usertype,sharelevel) values(tempDownUserId,1,tempsharelevel);
                             elsif (tempsharelevel>tempsharelevelold)  then/*更新数据*/
                                 update temptablevalue_3  set sharelevel=tempsharelevel where userid=tempDownUserId  and usertype=1;
                             end if;    
                         end;                      
                         end loop;
                      end;
                      end if;
                   end; 
                   elsif (tempsharetype=84)  then /*内部用户创建人同分部*/
                   begin
                      if (tempsharelevel!=0) then
                      begin
                         select count(subcompanyid1) into recordcounts   from hrmresource where id=tempuserid;
                         if recordcounts>0  then
                         begin
                              select subcompanyid1 into subCompId   from  hrmresource where id=tempuserid;
                              for temp_cursor in( select id from  hrmresource where subcompanyid1=subCompId and seclevel>=tempseclevel and  loginid is not null)
                              loop
                              begin
                                  sameSubUserId := temp_cursor.id;
                                  tempsharelevelold := 0;
                                  
                                  select count(sharelevel) into recordcounts   from temptablevalue_3 where userid=sameSubUserId   and usertype=1;
                                  if recordcounts>0 then
                                       select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=sameSubUserId  and usertype=1;               
                                   end if;
                                   
                                  if (tempsharelevelold=0)  then/*插入数据*/
                                      insert into  temptablevalue_3(userid,usertype,sharelevel) values(sameSubUserId,1,tempsharelevel);
                                  elsif (tempsharelevel>tempsharelevelold)  then /*更新数据*/
                                      update temptablevalue_3  set sharelevel=tempsharelevel where userid=sameSubUserId and   usertype=1 ;
                                  end if;
                              end;
                              end loop;                              
                         end;
                         end if;
                      end;
                      end if;
                   end;  
                   elsif (tempsharetype=85)  then /*内部用户创建人同部门*/
                   begin

                      if (tempsharelevel!=0) then
                      begin
                        select count(departmentid) into recordcounts   from   hrmresource where id=tempuserid;
                         if recordcounts>0  then
                         begin         
                         
                             select departmentid into samedepartmentId   from  hrmresource where id=tempuserid;

                             for temp_cursor in(select id from  hrmresource where departmentid=samedepartmentId and   seclevel>=tempseclevel  and loginid is not null )
                             loop
                             begin
                                  sameDepartUserId := temp_cursor.id;
                                  tempsharelevelold := 0;
                                  select count(sharelevel) into recordcounts   from temptablevalue_3 where userid=sameDepartUserId  and usertype=1;
                                  if recordcounts> 0 then
                                     select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=sameDepartUserId and usertype=1;
                                  end if;
                                   if (tempsharelevelold=0) then /*插入数据*/                           
                                      insert into  temptablevalue_3(userid,usertype,sharelevel) values(sameDepartUserId,1,tempsharelevel) ;
                                   elsif (tempsharelevel>tempsharelevelold) then/*更新数据*/
                                      update temptablevalue_3  set sharelevel=tempsharelevel where userid=sameDepartUserId and usertype=1 ;
                                   end if;                                  
                             end;
                             end loop;
                         end;
                         end if;
                      end;
                      end if;
                   end;             
               end if;              
          end loop;
     end; 
  end if;          
  
  /* 文档共享信息 (内部用户) 不涉及角色部分 */
   for shareuserid_cursor in(  select distinct t1.id , t2.sharelevel from HrmResource t1 , DocShare  t2 where  t1.loginid is not null and t2.docid =docid_1 and ( (t2.foralluser=1 and t2.seclevel<=t1.seclevel) or ( t2.userid= t1.id ) or(t2.departmentid=t1.departmentid and t2.seclevel<=t1.seclevel)) and t2.sharetype not in(-80,-81,-82,80,81,82,83,84,85) )
    loop    
        tempuserid  := shareuserid_cursor.id;
        tempsharelevel  := shareuserid_cursor.sharelevel;
        tempsharelevelold := 0;
        
        select count(sharelevel) into recordcounts   from temptablevalue_3 where userid=tempuserid  and usertype=1;
        if recordcounts>0 then
            select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=tempuserid and usertype=1;
        end if;
        
         if (tempsharelevelold=0) then/*插入数据*/            
            insert into temptablevalue_3(userid,usertype,sharelevel) values(tempuserid,1,tempsharelevel);
         elsif (tempsharelevel>tempsharelevelold) then  /*更新数据*/            
            update temptablevalue_3 set sharelevel = tempsharelevel where userid=tempuserid and usertype = 1 ;
         end if;   
     end loop;
  
  /* 文档共享信息 (内部用户) 涉及角色部分 */
    for shareuserid_cursor in( select distinct t1.id , t2.sharelevel from HrmResource t1 ,  DocShare  t2,HrmRoleMembers  t3 where t1.loginid is not null  and t2.docid = docid_1 and ( t3.resourceid=t1.id and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and ( (t3.rolelevel=2) or (t3.rolelevel=0  and t1.departmentid=departmentid_6) or (t3.rolelevel=1 and t1.subcompanyid1=subcompanyid_7) ) ) and t2.sharetype not in(-80,-81,-82,80,81,82,83,84,85) and t1.loginid is not null)
    loop
        tempuserid  := shareuserid_cursor.id;
        tempsharelevel  := shareuserid_cursor.sharelevel;
        tempsharelevelold := 0;        
        select count(sharelevel) into recordcounts  from temptablevalue_3 where userid=tempuserid and usertype=1;

        if recordcounts> 0  then
            select sharelevel into tempsharelevelold   from temptablevalue_3 where userid=tempuserid and usertype=1;
        end if;
        
       if (tempsharelevelold=0) then/*插入数据*/ 
           insert into temptablevalue_3(userid,usertype,sharelevel) values(tempuserid,1,tempsharelevel);
       elsif (tempsharelevel>tempsharelevelold) then/*更新数据*/            
            update temptablevalue_3 set sharelevel = tempsharelevel where userid=tempuserid and usertype = 1;
       end if;
       
     end loop;    
     
   /* 文档共享信息 外部用户 ( 类型 ) */
    for shareuserid_cursor in( select distinct sharetype , seclevel, sharelevel from DocShare where sharetype < 0 and docid = docid_1 and sharetype not in(-80,-81,-82,80,81,82,83,84,85))
    loop
        tempsharetype := shareuserid_cursor.sharetype;
        tempuserid := shareuserid_cursor.seclevel;
        tempsharelevel  := shareuserid_cursor.sharelevel;
        tempsharelevelold := 0;
        
        select count(sharelevel) into recordcounts  from temptablevalue_3 where userid=tempuserid and usertype = tempsharetype;

        if recordcounts> 0  then
            select sharelevel into tempsharelevelold from temptablevalue_3 where userid=tempuserid and usertype = tempsharetype ;
        end if;
        
        
        if (tempsharelevelold=0) then/*插入数据*/            
            insert into temptablevalue_3(userid,usertype,sharelevel) values(tempuserid,tempsharetype,tempsharelevel);
        elsif(tempsharelevel>tempsharelevelold) then/*更新数据*/            
            update temptablevalue_3 set sharelevel = tempsharelevel where userid=tempuserid and usertype = tempuserid ;
        end if;
    end loop;
    
    /* 文档共享信息 外部用户 ( 用户id ) */
    for shareuserid_cursor in(       select distinct crmid , sharelevel from DocShare where crmid <> 0 and    sharetype = '9' and docid = docid_1 and sharetype not in(-80,-81,-82,80,81,82,83,84,85))   
    loop
        tempuserid  := shareuserid_cursor.crmid;
        tempsharelevel  := shareuserid_cursor.sharelevel;
        tempsharelevelold := 0;
        
        select count(sharelevel) into recordcounts  from temptablevalue_3 where userid=tempuserid and usertype = 9; 
        if recordcounts> 0  then
             select  sharelevel into tempsharelevelold  from temptablevalue_3 where userid=tempuserid and usertype = 9; 
        end if;
       
        if (tempsharelevelold=0) then/*插入数据*/            
            insert into temptablevalue_3(userid,usertype,sharelevel) values(tempuserid,9,tempsharelevel);
        elsif (tempsharelevel>tempsharelevelold) then/*更新数据*/            
            update temptablevalue_3 set sharelevel = tempsharelevel where userid=tempuserid and usertype = 9;
        end if;
    end loop;

    /* 将临时表中的数据写入共享表 */
    delete docsharedetail where docid = docid_1;
    insert into docsharedetail (docid,userid,usertype,sharelevel) select docid_1 , userid,usertype,sharelevel from  temptablevalue_3;                 
end;
/
CREATE OR REPLACE TRIGGER cus_fielddata_Trigger before insert on cus_fielddata for each row
begin select cus_fielddata_seqorder.nextval into :new.seqorder from dual; end;
/
CREATE or replace PROCEDURE WorkflowReportShare_Insert
(reportid_1       integer, 
sharetype_1	integer,
seclevel_1	smallint,
rolelevel_1	smallint,
sharelevel_1	smallint,
userid_1	integer, 
subcompanyid_1	integer,
departmentid_1	integer, 
roleid_1	integer, 
foralluser_1	smallint,
crmid_1	integer,
mutidepartmentid_1 varchar2,
flag out 	integer, 
msg out	varchar2,
thecursor IN OUT cursor_define.weavercursor)
as 
begin
insert into WorkflowReportShare(reportid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,mutidepartmentid) values(reportid_1,sharetype_1,seclevel_1,rolelevel_1,sharelevel_1,userid_1,subcompanyid_1,departmentid_1,roleid_1,foralluser_1,crmid_1,mutidepartmentid_1);
end;
/
CREATE OR REPLACE PROCEDURE WkfReportShareDetail_Insert (reportid_1 	integer, userid_2 	integer, usertype_3 	integer, sharelevel_4 	integer ,mutidepartmentid_5 varchar2, flag out 	integer, msg out	varchar2, thecursor IN OUT cursor_define.weavercursor) AS begin INSERT INTO WorkflowReportShareDetail ( reportid, userid, usertype, sharelevel,mutidepartmentid)  VALUES ( reportid_1, userid_2, usertype_3, sharelevel_4,mutidepartmentid_5); end;
/

declare
	maxid integer;

begin
select   max(id) into maxid  from workflow_formdict;

update SequenceIndex set currentid=maxid+1 where indexdesc='workflowformdictid';

end;
/
CREATE or REPLACE PROCEDURE Workflow_ReportDspField_ByRp 
(id_1 	integer,
language_2 integer,
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
isbill_3 char(1);
isbill_count integer;
begin
select  count(isbill) INTO   isbill_count  from workflow_base a , Workflow_Report b 
where b.id = id_1 and a.id = b.reportwfid;
if isbill_count>0 then
    select  isbill INTO  isbill_3  from workflow_base a , Workflow_Report b where b.id = id_1 and a.id = b.reportwfid;
end if;

if isbill_3 = '0' then
    open thecursor for
    select a.id , (select distinct fieldlable from workflow_fieldlable b where b.langurageid = language_2 and b.fieldid=a.fieldid  and b.formid=d.formid ) as fieldlable , a.dsporder , a.isstat ,a.dborder from Workflow_ReportDspField a , Workflow_Report c , workflow_base d where a.reportid = c.id  and c.reportwfid = d.id  and c.id = id_1 and  a.fieldid not in (-1,-2) order by a.dsporder;
else 
    open thecursor for
    select a.id , d.labelname , a.dsporder , a.isstat ,a.dborder from Workflow_ReportDspField a , workflow_billfield b ,Workflow_Report c ,HtmlLabelInfo d where a.reportid = c.id and a.fieldid= b.id and c.id = id_1 and b.fieldlabel = d.indexid and d.languageid = language_2  order by a.dsporder;
end if;
end;
/

create or replace procedure HrmResource_SelectAll 
 (	flag out integer  , 
  	msg  out varchar2,
	 thecursor IN OUT cursor_define.weavercursor
	) 
AS
begin 
open thecursor for
select 
  id,
  loginid,  
  lastname,
  sex,
  resourcetype,
  email,
  locationid,
  workroom, 
  departmentid,
  costcenterid,
  jobtitle,
  managerid,
  assistantid ,
  seclevel,
  joblevel,
  status,
  account,
  mobile
from HrmResource  ;
end;
/

CREATE or replace PROCEDURE HrmPubHoliday_Insert 
(countryid_1 	integer, 
holidaydate_2 	char,
holidayname_3 	varchar2,
changetype_4  integer ,
relateweekday_5 integer ,
flag out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS 
xx integer;
begin

select count(id) into xx from hrmpubholiday where countryid=countryid_1 and holidaydate=holidaydate_2; 
if xx=0 then
 INSERT INTO HrmPubHoliday ( countryid, holidaydate, holidayname,changetype,relateweekday) 
 VALUES (countryid_1, holidaydate_2, holidayname_3,changetype_4,relateweekday_5);
end if;
open thecursor for
select max(id) from hrmpubholiday;
end;
/