/*td:588 资产作维修处理，但是资产状态仍然不改变 */
CREATE or replace PROCEDURE CptUseLogMend_Insert
	(
     capitalid_1 	integer,
	 usedate_2 	char,
	 usedeptid_3 	integer,
	 useresourceid_4 	integer,
	 usecount_5 	integer,
	 useaddress_6 	varchar2,
	 userequest_7 	integer,
	 maintaincompany_8 	varchar2,
	 fee_9 	decimal,
	 usestatus_10 	varchar2,
	 remark_11 	varchar2,
	 flag  out integer,
	 msg  out varchar2,
     thecursor IN OUT cursor_define.weavercursor
     )
AS
begin
      INSERT INTO CptUseLog 
         (
         capitalid,
         usedate,
         usedeptid,
         useresourceid,
         usecount,
         useaddress,
         userequest,
         maintaincompany,
         fee,
         usestatus,
         remark) 
     
    VALUES 
        (         
         capitalid_1,
         usedate_2,
         usedeptid_3,
         useresourceid_4,
         usecount_5,
         useaddress_6,
         userequest_7,
         maintaincompany_8,
         fee_9,
         '4',
         remark_11) ;

    Update CptCapital Set stateid = usestatus_10  where id = capitalid_1 ;


end;
/
/* td:589 设置其中一个资产组的共享，那么所有资产组同步被设置了共享*/
CREATE or REPLACE PROCEDURE CptCapitalShareInfo_SbyRelated 
(relateditemid_1 integer , 
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
as 
begin 
open thecursor for 
select * from CptCapitalShareInfo where ( relateditemid = relateditemid_1 ) order by sharetype; 
end; 
/ 