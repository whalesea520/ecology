alter table workflow_flownode add isFormSignature char(1) null
/
update workflow_flownode set isFormSignature='0'
/

ALTER TABLE workflow_RequestLog ADD  isFormSignature char(1) null
/

ALTER TABLE workflow_RequestLog ADD  imageFileId integer null
/

CREATE TABLE workflow_requestLogSequence (
	requestLogId integer NULL 
)
/
insert into  workflow_requestLogSequence(requestLogId) values(0)
/

ALTER TABLE workflow_RequestLog ADD  requestLogId integer   default 0  NOT NULL
/
update workflow_RequestLog set requestLogId=logId
/
update workflow_requestLogSequence set requestLogId=(select max(requestLogId) from workflow_RequestLog)
/


CREATE TABLE Workflow_FormSignatureLog(
	id integer  NOT NULL ,
	workflowRequestLogId integer NULL ,
	fieldName varchar2(50) NULL ,
	markName varchar2(50) NULL ,
	userName varchar2(50) NULL ,
	dateTime varchar2(19) NULL ,
	hostName varchar2(50) NULL ,
	markGuid varchar2(128) NULL 
)
/

create sequence Workflow_FormSignatureLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/


create or replace trigger Workflow_FormSignLog_Tri
before insert on Workflow_FormSignatureLog
for each row
begin
select Workflow_FormSignatureLog_id.nextval into :new.id from dual;
end;
/


CREATE TABLE Workflow_FormSignatureImgLog(
	id integer NOT NULL ,
	requestLogId integer NULL ,
	imageFileId integer NULL 
)
/


create sequence Workflow_FormSignImgLog_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger Workflow_FormSignImgLog_Tri
before insert on Workflow_FormSignatureImgLog
for each row
begin
select Workflow_FormSignImgLog_id.nextval into :new.id from dual;
end;
/

CREATE OR REPLACE PROCEDURE workflow_RequestLogID_Update ( 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor ) 
AS 
begin 
  update workflow_requestlogsequence set requestlogId=requestlogId+1  ; 
  open thecursor for select requestlogId from workflow_requestlogsequence ; 
end;
/



CREATE OR REPLACE PROCEDURE workflow_RequestLog_Insert
( requestid1	integer, workflowid1	integer, nodeid1	integer,logtype1	char ,
operatedate1	char, operatetime1	char,operator1	integer, remark_1	varchar2,
clientip1	char, operatortype1	integer,destnodeid1	integer, operate1 varchar2,
agentorbyagentid1  integer,agenttype1  char,showorder1 integer,annexdocids1 varchar2,requestLogId1 integer,
flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor )
AS count1 integer;
currentdate char(10);
currenttime char(8);
isFormSignature1 char(1);

begin 
select to_char(sysdate,'yyyy-mm-dd') into currentdate from dual;
select to_char(sysdate,'hh24:mi:ss') into currenttime from dual;
isFormSignature1 := '0';

   if requestLogId1>0 then
       select  isFormSignature INTO  isFormSignature1 from workflow_requestlog where requestLogId=requestLogId1;
   end if;


   if logtype1 = '1' then
               select  count(*) INTO  count1 from workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 and operator = operator1 and operatortype = operatortype1;

               if count1 > 0 then
	           if isFormSignature1 = '1' then
                      update workflow_requestlog SET operatedate= currentdate, operatetime= currenttime,  clientip= clientip1, destnodeid= destnodeid1,annexdocids=annexdocids1 WHERE ( requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 and operator = operator1 and operatortype = operatortype1);
		   else
                      update workflow_requestlog SET operatedate= currentdate, operatetime= currenttime, remark= remark_1, clientip= clientip1, destnodeid= destnodeid1,annexdocids=annexdocids1 WHERE ( requestid=requestid1 and nodeid=nodeid1 and logtype=logtype1 and operator = operator1 and operatortype = operatortype1);
		   end if;
               else
	           if requestLogId1>0 then
		       if isFormSignature1 = '1'  then
                           update workflow_requestlog SET   requestid= requestid1, workflowid= workflowid1, nodeid= nodeid1, logtype= logtype1, operator= operator1, operatortype= operatortype1, receivedPersons= operate1, agentorbyagentid= agentorbyagentid1, agenttype= agenttype1, showorder= showorder1, operatedate   = currentdate, operatetime   = currenttime,  clientip   = clientip1, destnodeid   = destnodeid1, annexdocids= annexdocids1
                           WHERE  requestLogId  = requestLogId1;
		       else
                           update workflow_requestlog SET   requestid= requestid1, workflowid= workflowid1, nodeid= nodeid1, logtype= logtype1, operator= operator1, operatortype= operatortype1, receivedPersons= operate1, agentorbyagentid= agentorbyagentid1, agenttype= agenttype1, showorder= showorder1, operatedate   = currentdate, operatetime   = currenttime, remark    = remark_1, clientip   = clientip1, destnodeid   = destnodeid1, annexdocids= annexdocids1
                           WHERE  requestLogId  = requestLogId1;
		       end if;
		   else
                       insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids) values(requestid1,workflowid1,nodeid1,logtype1, currentdate,currenttime,operator1, remark_1,clientip1,operatortype1,destnodeid1,operate1,agentorbyagentid1,agenttype1,showorder1,annexdocids1);
		   end if;

               end if;
   else
       if requestLogId1>0 then
           delete workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and (logtype='1') and operator = operator1 and operatortype = operatortype1 and requestLogId<>requestLogId1;

           if isFormSignature1 = '1'  then
               update workflow_requestlog SET   requestid= requestid1, workflowid= workflowid1, nodeid= nodeid1, logtype= logtype1, operator= operator1, operatortype= operatortype1, receivedPersons= operate1, agentorbyagentid= agentorbyagentid1, agenttype= agenttype1, showorder= showorder1, operatedate   = currentdate, operatetime   = currenttime,clientip   = clientip1, destnodeid   = destnodeid1, annexdocids= annexdocids1
               WHERE  requestLogId  = requestLogId1;
	   else
               update workflow_requestlog SET   requestid= requestid1, workflowid= workflowid1, nodeid= nodeid1, logtype= logtype1, operator= operator1, operatortype= operatortype1, receivedPersons= operate1, agentorbyagentid= agentorbyagentid1, agenttype= agenttype1, showorder= showorder1, operatedate   = currentdate, operatetime   = currenttime, remark    = remark_1, clientip   = clientip1, destnodeid   = destnodeid1, annexdocids= annexdocids1
               WHERE  requestLogId  = requestLogId1;
	   end if;
       else
                  delete workflow_requestlog where requestid=requestid1 and nodeid=nodeid1 and (logtype='1') and operator = operator1 and operatortype = operatortype1;
                  insert into workflow_requestlog (requestid,workflowid,nodeid,logtype, operatedate,operatetime,operator, remark,clientip,operatortype,destnodeid,receivedPersons,agentorbyagentid,agenttype,showorder,annexdocids) values(requestid1,workflowid1,nodeid1,logtype1, currentdate,currenttime,operator1, remark_1,clientip1,operatortype1,destnodeid1,operate1,agentorbyagentid1,agenttype1,showorder1,annexdocids1);
       end if;
   end if;

end;
/