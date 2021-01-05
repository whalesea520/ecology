CREATE type obj_DocShare as object(sourceid integer , sharelevel integer);
/
CREATE type table_DocShare as table of obj_DocShare;
/
CREATE or replace FUNCTION GetDocShareDetailTable 
(userid_1 varchar2,
usertype_2  varchar2)
RETURN table_DocShare
AS
seclevel_1 varchar2(10);
departmentid_2 varchar2(10);
subcompanyid_3 varchar2(10);
type_4 varchar2(10);
count_5 integer;
isSysadmin_1 integer;
DocShareDetail table_DocShare := table_DocShare();
BEGIN  
   if usertype_2 ='1'
   then
      select count(id) into count_5 from  hrmresource where id = userid_1;
	  if count_5 >0 then
	  select seclevel into seclevel_1 from hrmresource where id = userid_1;
	  select  departmentid into departmentid_2  from hrmresource where id = userid_1;
	  select subcompanyid1 into subcompanyid_3 from hrmresource where id = userid_1;
	  end if;
	  select count(*) into isSysadmin_1 from hrmresourcemanager where id = userid_1;
	  if isSysadmin_1=1 then
			SELECT obj_DocShare(sourceid,MAX(sharelevel)) bulk collect into DocShareDetail  from shareinnerdoc where 
			(type=1 and content= userid_1) or (  type=4 and content in 
			(select concat(to_char(roleid),to_char(rolelevel)) from hrmrolemembers where resourceid = userid_1) and seclevel <= seclevel_1) GROUP BY sourceid;
      else
        SELECT obj_DocShare(sourceid,MAX(sharelevel)) bulk collect into DocShareDetail from shareinnerdoc where (type=1 and content = userid_1) or  (type=2 and content = subcompanyid_3 and seclevel <= seclevel_1) or 
        (type=3 and content = departmentid_2 and seclevel <= seclevel_1) or (type=4 and content in 
        (select concat(to_char(roleid),to_char(rolelevel)) from hrmrolemembers where resourceid = userid_1) and seclevel <= seclevel_1) GROUP BY sourceid;
	  end if;
   else 
      select count(id) into count_5 from crm_customerinfo where id = userid_1;
      if count_5 >0 then
	  select type into type_4 from crm_customerinfo where id = userid_1;
		select seclevel into seclevel_1 from crm_customerinfo where id = userid_1;
		end if;
      SELECT obj_DocShare(sourceid,MAX(sharelevel)) bulk collect into DocShareDetail from shareouterdoc where (type=9 and content = userid_1) or (type=10 and content = type_4 and seclevel <= seclevel_1) GROUP BY sourceid;
   end if;
   RETURN DocShareDetail;
END;
/

CREATE or REPLACE PROCEDURE DocRpSum 
 (optional_1	varchar2,
 userid_1 integer,
 flag	out integer,
 msg   out  varchar2,
thecursor IN OUT cursor_define.weavercursor
 ) 
 AS 
 resultid_1  integer;
 count_1  integer;
 replycount_1  integer ;
 begin
     if   optional_1='doccreater' then
	for resultid_cursor in(
	select * from (select count(id) resultcount,ownerid resultid from docdetail  t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare))  t2 where t1.id=t2.sourceid and t1.docstatus in (1,2,5) group by ownerid order by resultcount desc) where rownum<21)
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare)) t2 where t1.id=t2.sourceid and 
            t1.docstatus in (1,2,5) and 
            doccreaterid = resultid_1 and isreply='1' ;
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1);
        end loop; 
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

     if   optional_1='crm'  then
	for resultid_cursor in(
	select * from (select count(id) resultcount,t1.crmid resultid from docdetail t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare)) t2 where t1.id=t2.sourceid and t1.docstatus in (1,2,5) group by t1.crmid 
	    order by resultcount desc) where rownum<21) 
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail  t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare))  t2 where t1.id=t2.sourceid and t1.docstatus 
		    in (1,2,5) and t1.crmid=resultid_1 and isreply='1' ; 
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ;
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

     if   optional_1='resource'  then
	for resultid_cursor in(
	select * from (select count(id) resultcount,hrmresid resultid from docdetail t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare)) t2 where t1.id=t2.sourceid and t1.docstatus in (1,2,5) group by hrmresid 
	   order by resultcount desc) where rownum<21)
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail t1,table(cast(GetDocShareDetailTable(1,1) as table_DocShare))  t2 where t1.id=t2.sourceid and 
	        t1.docstatus in (1,2,5) and hrmresid = resultid_1 and isreply='1';
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1);
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

    if   optional_1='project' then
	for resultid_cursor in(
	select * from (select count(id) resultcount,projectid resultid from docdetail t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare)) t2 where t1.id=t2.sourceid and t1.docstatus in (1,2,5) group by projectid 
    order by resultcount desc) where rownum<21)
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail  t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare))  t2 where t1.id=t2.sourceid and t1.docstatus 
        in (1,2,5) and projectid=resultid_1 and isreply='1' ;
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ; 
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

    if   optional_1='department'  then 
	for resultid_cursor in(
	select * from (select count(id) resultcount,docdepartmentid resultid from docdetail t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare)) t2 where t1.id=t2.sourceid and t1.docstatus in (1,2,5)  group by docdepartmentid order by resultcount desc) where rownum<21 )
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare)) t2 where t1.id=t2.sourceid and 
        t1.docstatus in (1,2,5) and docdepartmentid=resultid_1 and 
        isreply='1';
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ; 
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

   if   optional_1='language'  then 
	for resultid_cursor in(
	select * from (select count(id) resultcount,doclangurage resultid from docdetail t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare)) t2 where t1.id=t2.sourceid and t1.docstatus in (1,2,5) 
    group by doclangurage order by resultcount desc  
	) where rownum<21 )
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
		select count(id) into replycount_1 from docdetail t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare)) t2 where t1.id=t2.sourceid and t1.docstatus 
        in (1,2,5) and doclangurage=resultid_1 and isreply='1' ;
		insert into TM_DocRpSum values(resultid_1,count_1,replycount_1) ;
        end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;

   if   optional_1='item'  then
	for resultid_cursor in(
	select * from (select count(id) resultcount,itemid resultid from docdetail t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare)) t2 where t1.id=t2.sourceid and t1.docstatus in (1,2,5) 
	 group by itemid order by resultcount desc ) where rownum<21 )
	loop
		count_1 :=resultid_cursor.resultcount;
		resultid_1 :=resultid_cursor.resultid;
	select count(id) into replycount_1 from docdetail t1,table (cast (GetDocShareDetailTable(userid_1 ,1) as table_DocShare)) t2 where t1.id=t2.sourceid and t1.docstatus 
        in (1,2,5) and itemid=resultid_1 and isreply='1';
	insert into TM_DocRpSum values(resultid_1,count_1,replycount_1);
	end loop;
	open thecursor for
	select * from TM_DocRpSum order by acount desc ;
   end if;
end;
/

INSERT INTO HtmlLabelIndex values(18741,'此文档的状态为草稿状态，他人将看不到此文档！') 
/
INSERT INTO HtmlLabelInfo VALUES(18741,'此文档的状态为草稿状态，他人将看不到此文档！',7) 
/
INSERT INTO HtmlLabelInfo VALUES(18741,'The document is draft,others can''t view it.',8) 
/
