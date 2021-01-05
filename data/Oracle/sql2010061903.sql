CREATE OR REPLACE PROCEDURE workflow_currentoperator_copy (
   requestid_0            INTEGER,
   userid_0               INTEGER,
   usertype_0             INTEGER,
   flag          OUT      INTEGER,
   msg           OUT      VARCHAR2,
   thecursor     IN OUT   cursor_define.weavercursor
)
AS
   operatedate_0   VARCHAR (10);
   operatetime_0   VARCHAR (8);
   nodetype_0 char(1);
   isremark_0 char(1);
BEGIN
    isremark_0:='2';
   SELECT TO_CHAR (SYSDATE, 'yyyy-mm-dd')
     INTO operatedate_0
     FROM DUAL;

   SELECT TO_CHAR (SYSDATE, 'hh24:mi:ss')
     INTO operatetime_0
     FROM DUAL;
   select currentnodetype into nodetype_0 from workflow_requestbase where requestid= requestid_0;
   if nodetype_0 is null then
   nodetype_0:='0';
   end if;
   IF nodetype_0='3' then 
   isremark_0:='4';
  end if;
   
update workflow_currentoperator 
set isremark=isremark_0,operatedate=operatedate_0,operatetime=operatetime_0
where requestid=requestid_0 and userid=userid_0 and usertype=usertype_0 and isremark in('1','7','8');

END;
/
