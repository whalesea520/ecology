CREATE  or replace PROCEDURE Workflow_DocShareInfo_S 
(docid_1 integer, 
workflowid_2 integer,
requestid_3 integer, 
nodeid_4 integer, 
userid_5 integer,
beagentid_6 integer,
sharelevel_7 integer, 
flag	out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin
open thecursor for
select userid from Workflow_DocShareInfo where docid=docid_1 and workflowid=workflowid_2 and requestid=requestid_3   and nodeid=nodeid_4 and userid=userid_5 and beagentid=beagentid_6 and sharelevel=sharelevel_7;
end;
/

CREATE  or replace  PROCEDURE DocShare_FromDocSecCategoryI
(docid_1  integer, 
sharetype_2	integer,
seclevel_3	smallint,
rolelevel_4	smallint, 
sharelevel_5	smallint,
userid_6	integer, 
subcompanyid_7	integer,
departmentid_8	integer, 
roleid_9	integer, 
foralluser_10	smallint,
crmid_11	integer,
sharesource_12 integer,
flag	out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as


count_1 integer;
begin
select  count(*)  into count_1
from DocShare 
where docid=docid_1 and sharetype=sharetype_2 and seclevel=seclevel_3 and rolelevel=rolelevel_4 and sharelevel<=sharelevel_5 
and userid=userid_6 and subcompanyid=subcompanyid_7 and departmentid=departmentid_8 and roleid=roleid_9 and foralluser=foralluser_10 
and crmid=crmid_11 and sharesource=sharesource_12;

if count_1=0 then
	insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,sharesource) values(docid_1,sharetype_2,seclevel_3,rolelevel_4,sharelevel_5,userid_6,subcompanyid_7,departmentid_8,roleid_9,foralluser_10,crmid_11,sharesource_12);  
else 
	update DocShare 
	set docid=docid_1 , sharetype=sharetype_2 , seclevel=seclevel_3 , rolelevel=rolelevel_4 , 
	sharelevel=sharelevel_5 , userid=userid_6 , subcompanyid=subcompanyid_7 , departmentid=departmentid_8 
	, roleid=roleid_9 , foralluser=foralluser_10 , crmid=crmid_11 , sharesource=sharesource_12
	where docid=docid_1 and sharetype=sharetype_2 and seclevel=seclevel_3 and rolelevel=rolelevel_4 and 
	sharelevel<sharelevel_5 and userid=userid_6 and subcompanyid=subcompanyid_7 and departmentid=departmentid_8 
	and roleid=roleid_9 and foralluser=foralluser_10 and crmid=crmid_11 and sharesource=sharesource_12;
end if;
end;
/



