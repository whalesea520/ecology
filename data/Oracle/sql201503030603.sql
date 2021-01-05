UPDATE cptDefineField SET fieldlabel = '16914' WHERE id = -27
/
UPDATE workflow_billfield SET fielddbtype = 'number(15,2)' WHERE  billid = 221 and fieldname = 'losscount'
/

alter   table   cptcapital   add( temploss  number(15,2))     
/
update cptcapital set temploss = frozennum 
/
update cptcapital set frozennum = '' 
/
ALTER TABLE cptcapital modify frozennum  number(15,2)
/
update cptcapital set frozennum = temploss 
/
alter table cptcapital drop column temploss
/

alter   table   bill_cptloss   add( temploss  number(15,2))     
/
update bill_cptloss set temploss = losscount 
/
update bill_cptloss set losscount = '' 
/
ALTER TABLE bill_cptloss modify losscount  number(15,2)
/
update bill_cptloss set losscount = temploss 
/
alter table bill_cptloss drop column temploss
/

CREATE OR REPLACE PROCEDURE CptUseLogLoss_Insert2 (capitalid_1 	integer, usedate_2 	char, usedeptid_3 	integer, useresourceid_4 	integer, usecount_5 	number, useaddress_6 	varchar2, userequest_7 	integer, maintaincompany_8 	varchar2, fee_9 	decimal, usestatus_10 	varchar2, remark_11 	varchar2, costcenterid_12   integer, sptcount_13	char,olddeptid_14 	integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  AS num_1 number; begin if sptcount_13<>'1' then select capitalnum into num_1 from CptCapital where id = capitalid_1; if num_1<usecount_5 then open thecursor for select -1 from dual; return; else num_1 := num_1 - usecount_5; end if; end if;  INSERT INTO CptUseLog (capitalid, usedate, usedeptid , useresourceid , usecount , useaddress , userequest , maintaincompany , fee , usestatus , remark,olddeptid )  VALUES (capitalid_1, usedate_2, usedeptid_3, useresourceid_4, usecount_5, useaddress_6, userequest_7, maintaincompany_8, fee_9, '-7', remark_11,olddeptid_14); if sptcount_13='1' then  Update CptCapital Set departmentid=null, costcenterid=null, resourceid=null, stateid = usestatus_10  where id = capitalid_1; else Update CptCapital Set capitalnum = num_1 where id = capitalid_1; end if;   open thecursor for select 1 from dual; return; end;
/
CREATE OR REPLACE PROCEDURE CptUseLogDiscard_Insert2 (capitalid_1 	integer, usedate_2 	char, usedeptid_3 	integer, useresourceid_4 	integer, usecount_5 	decimal, useaddress_6 	varchar2, userequest_7 	integer, maintaincompany_8 	varchar2, fee_9 	decimal, usestatus_10 	varchar2, remark_11 	varchar2, sptcount_12	char,olddeptid_13 	integer, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  AS num_1 decimal ; begin if sptcount_12<>'1' then select capitalnum into num_1  from CptCapital where id = capitalid_1 ; if num_1<usecount_5 then open thecursor for select -1 from dual; return; else num_1 := num_1 - usecount_5 ; end if; end if; INSERT INTO CptUseLog (capitalid, usedate, usedeptid , useresourceid , usecount , useaddress , userequest , maintaincompany , fee , usestatus , remark ,olddeptid)   VALUES (capitalid_1, usedate_2, usedeptid_3, useresourceid_4, usecount_5, useaddress_6, userequest_7,  maintaincompany_8, fee_9, '5', remark_11,olddeptid_13) ; if sptcount_12 ='1' then   Update CptCapital Set departmentid = null, costcenterid = null, resourceid   = null, location	     =  null,   stateid = usestatus_10 where id = capitalid_1 ; else Update CptCapital Set capitalnum = num_1   where id = capitalid_1 ; end if ;  open thecursor for select 1 from dual; return; end;
/
CREATE OR REPLACE PROCEDURE CptUseLogBack_Insert2 (capitalid_1       integer, usedate_2         char, usedeptid_3       integer, useresourceid_4   integer, usecount_5        integer, useaddress_6      varchar2, userequest_7      integer, maintaincompany_8 varchar2, fee_9             decimal, usestatus_10      varchar2,  remark_11         varchar2, costcenterid_12   integer, sptcount_13       char,olddeptid_14       integer, flag              out integer,  msg               out varchar2, thecursor         IN OUT cursor_define.weavercursor) AS num_1 integer;   begin if sptcount_13 <> '1' then select capitalnum into num_1 from CptCapital where id = capitalid_1;   end if;   INSERT INTO CptUseLog (capitalid, usedate, usedeptid, useresourceid, usecount, useaddress, userequest,   maintaincompany, fee, usestatus, remark,olddeptid) VALUES (capitalid_1, usedate_2, usedeptid_3, useresourceid_4,   usecount_5, useaddress_6, userequest_7, maintaincompany_8, fee_9, '0', remark_11,olddeptid_14); if sptcount_13 = '1'   then Update CptCapital Set departmentid = olddepartment where id = capitalid_1;   Update CptCapital Set costcenterid = null, resourceid = null, stateid = usestatus_10,deprestartdate = null   where id = capitalid_1; else Update CptCapital Set capitalnum = num_1 + usecount_5 where id = capitalid_1;   end if; open thecursor for select 1 from dual; return; end;
/
CREATE OR REPLACE PROCEDURE CptUseLogMend_Insert2 ( capitalid_1 	integer, usedate_2 	char, usedeptid_3 	integer, useresourceid_4 	integer, usecount_5 	integer, useaddress_6 	varchar2, userequest_7 	integer, maintaincompany_8 	varchar2, fee_9 	decimal, usestatus_10 	varchar2, remark_11 	varchar2, resourceid_12 	varchar2, mendperioddate_13 	varchar2,olddeptid_14 	integer, flag  out integer, msg  out varchar2, thecursor IN OUT cursor_define.weavercursor ) AS begin   INSERT INTO CptUseLog ( capitalid, usedate, usedeptid, useresourceid, usecount,   useaddress, userequest, maintaincompany, fee, usestatus, remark, resourceid, mendperioddate,olddeptid)    VALUES ( capitalid_1, usedate_2, usedeptid_3, useresourceid_4, usecount_5, useaddress_6,   userequest_7, maintaincompany_8, fee_9, '4', remark_11, resourceid_12, mendperioddate_13,olddeptid_14) ;    Update CptCapital Set stateid = usestatus_10  where id = capitalid_1 ;   end;
/