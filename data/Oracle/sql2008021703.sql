CREATE OR REPLACE PROCEDURE workflow_CurOpe_UbySend 
	(requestid_0	integer, 
	 userid_0	integer, 
	 usertype_0	integer, 
	 flag out integer,
	 msg out varchar2,thecursor IN OUT cursor_define.weavercursor) 
AS  
	 currentdate_0 varchar(10); 
	 currenttime_0 varchar(8) ;
begin	 
    select to_char(sysdate,'yyyy-mm-dd') into currentdate_0 from dual;
    select to_char(sysdate,'hh24:mi:ss') into currenttime_0 from dual;
update workflow_currentoperator 
set isremark=2,operatedate=currentdate_0,operatetime=currenttime_0 
where requestid =requestid_0 and userid =userid_0 and usertype=usertype_0 and isremark=9;
end;
/

CREATE OR REPLACE PROCEDURE workflow_groupdetail_SByGroup 
(id_1 	integer, 	 flag out integer , msg out varchar2, thecursor IN OUT cursor_define.weavercursor) 
AS begin open thecursor for 
SELECT id, groupid, type, objid, level_n, level2_n, conditions, conditioncn, orders, signorder, 1+orders as sort from(
SELECT * FROM workflow_groupdetail 
WHERE ( groupid = id_1 and ((signorder != 3 and signorder != 4) or signorder is null) ) 
order by orders,id)a 
union 
SELECT id, groupid, type, objid, level_n, level2_n, conditions, conditioncn, orders, signorder, 10000+signorder as sort from(
SELECT * FROM workflow_groupdetail 
WHERE ( groupid = id_1 and (signorder = 3 or signorder = 4)) 
order by signorder,id)b 
order by sort ; 
end;
/
