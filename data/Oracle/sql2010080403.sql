alter table CRM_ShareInfo add  contents integer
/

update CRM_ShareInfo set contents=userid where sharetype=1
/

update CRM_ShareInfo set contents=departmentid where sharetype=2
/

update CRM_ShareInfo set contents=roleid where sharetype=3
/

update CRM_ShareInfo set contents=1 where sharetype=4
/

update CRM_ShareInfo set contents=crmid where sharetype=9
/

CREATE or replace PROCEDURE CRM_ShareInfo_Insert 
(relateditemid_1 integer,
sharetype_1 smallint,
seclevel_1  smallint,
rolelevel_1 smallint,
sharelevel_1 smallint,
userid_1 integer,
departmentid_1 integer,
roleid_1 integer,
foralluser_1 smallint,
contents_1 smallint,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin
INSERT INTO CRM_ShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid,
departmentid, roleid, foralluser,contents ) VALUES 
( relateditemid_1 , sharetype_1, seclevel_1 , rolelevel_1 , sharelevel_1, userid_1, departmentid_1,
roleid_1, foralluser_1,contents_1);
end;
/

CREATE or REPLACE PROCEDURE WF_CRM_ShareInfo_Add 
(crmid_1		integer,            
 sharelevel_1		integer,
 userid_1		integer,
 usertype_1		integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
as
 count_2 integer;
 begin

select count(*) INTO count_2 from CRM_ShareInfo where relateditemid=crmid_1 and sharelevel=sharelevel_1 and userid= userid_1;
	if count_2 =0  then
		
		  if usertype_1=0 then
			  
			 insert INTO  CRM_ShareInfo(relateditemid,sharetype,sharelevel,userid,contents) values(crmid_1 , 1 ,sharelevel_1,userid_1,userid_1);
			 end if;
		    if usertype_1=1 then
			
			insert INTO  CRM_ShareInfo(relateditemid,sharetype,sharelevel,crmid,contents) values(crmid_1, 9 ,sharelevel_1,userid_1,userid_1);
			end if;
		end if;
end;
/

CREATE or REPLACE PROCEDURE CRM_ShareEditToManager(
crmId_1 integer, managerId_1 integer, 
flag out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
AS
count_1 integer;
begin
SELECT count(id) into count_1 FROM CRM_ShareInfo WHERE relateditemid = crmId_1
AND sharetype = 1 AND userid = managerId_1;
if count_1 <> 0 then
    UPDATE CRM_ShareInfo SET sharelevel = 2 WHERE relateditemid =crmId_1
    AND sharetype = 1 AND userid = managerId_1;
ELSE 
    INSERT INTO CRM_ShareInfo(relateditemid, sharetype, sharelevel, userid,contents) 
    VALUES(crmId_1, 1, 2, managerId_1,managerId_1);
end if;
end;
/
