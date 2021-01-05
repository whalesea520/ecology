CREATE TABLE Workflow_DocShareInfo ( 
    id integer not null ,	/*自增长ID*/
    docId integer,	/*docid*/
    workflowId integer,	/*工作流id*/
    requestId integer,	/*请求id*/
    nodeId integer,	/*节点id*/
    userId integer,	/*被赋权人*/
    beAgentid integer,/*被代理人*/
    sharelevel integer		/*所赋权限*/
    )
/
create sequence Workflow_DocShareInfo_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Workflow_DocShareInfo_Trigger
before insert on Workflow_DocShareInfo
for each row
begin
select Workflow_DocShareInfo_id.nextval into :new.id from dual;
end;
/


alter table DocShare add  sharesource integer
/

CREATE or replace PROCEDURE Workflow_DocShareInfo_I 
(docid  integer, 
workflowId	integer,
requestId	integer,
nodeId integer,
userid	integer,
beAgentid integer,
sharelevel integer,
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor) 
as
BEGIN 
insert into Workflow_DocShareInfo 
(docid, workflowId, requestId, nodeId, userid, beAgentid, sharelevel)  
values (docid, workflowId, requestId, nodeId, userid, beAgentid, sharelevel);
END;
/

CREATE or replace  PROCEDURE WFDocShareInfo_Delete 
(requestId_1	integer,
userid_2    integer,
flag	out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
BEGIN
delete from Workflow_DocShareInfo where requestId=requestId_1 and userid=userid_2;
END;
/
CREATE or replace  PROCEDURE WFDocShareInfo_Select 
(requestId_1	integer,
userid_2    integer, 
flag	out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
begin
select * from Workflow_DocShareInfo where requestId=requestId_1 and userid=userid_2;
end;
/
CREATE or replace  PROCEDURE DocShare_FromDocSecCategoryI 
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
BEGIN
insert into DocShare(docid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,sharesource) values(docid_1,sharetype_2,seclevel_3,rolelevel_4,sharelevel_5,
userid_6,subcompanyid_7,departmentid_8,roleid_9,foralluser_10,crmid_11,sharesource_12);
END;   
/

CREATE or replace PROCEDURE WF_DocShare_AddSharesource 
		(docid_1	integer, 
		sharelevel_1	integer, 
		userid_1	integer, 
		usertype_1	integer,
		sharesource integer, 
		flag	out integer,
		msg out varchar2, 
		thecursor IN OUT cursor_define.weavercursor)
as
BEGIN 
		count_1 integer;
		count_2 integer;
    select count(*) into  count_1 from docdetail where usertype=usertype_1 and (ownerid=userid_1 or doccreaterid=userid_1);
		if count_1=0 then
				select count(*) into count_2 from DocShare where docid=docid_1 and sharelevel=sharelevel_1 and userid= userid_1;
				if count_2=0 then
						if usertype_1=0 then insert DocShare(docid,sharetype,sharelevel,userid,sharesource) values(docid_1,'1',sharelevel_1,userid_1,sharesource) 
						END if;
						if usertype_1=1 then
								insert DocShare(docid,sharetype,sharelevel,crmid) values(docid_1,'9',sharelevel_1,userid_1); 
						END if;
				END if;
		END if;
END;
/