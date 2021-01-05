CREATE GLOBAL TEMPORARY TABLE TM_FnaAccountList_Select 
( ledgerid      integer , 
tranid          integer  , 
tranmark        integer  , 
trandate        char(10)   , 
tranremark      varchar2(200) , 
tranaccount     number(18,3) , 
tranbalance     char(1))  
ON COMMIT DELETE ROWS
/

create GLOBAL TEMPORARY TABLE TM_FnaAccount_Select
( ledgerid integer ,
tranperiods char(6), 
trandaccount     number(18,3) ,
trancaccount     number(18,3) ,
tranremain      number(18,3) ) 
ON COMMIT DELETE ROWS
/

create GLOBAL TEMPORARY TABLE TM_FnaAccount_SelectBalance
( ledgerid  integer , 
precount  number(18,3), 
lastcount  number(18,3) ) 
ON COMMIT DELETE ROWS
/

create GLOBAL TEMPORARY TABLE TM_FnaAccount_SelectPL
 ( ledgerid  integer , 
 precount  number(18,3), 
 lastcount  number(18,3) ) 
 ON COMMIT DELETE ROWS
/

create GLOBAL TEMPORARY TABLE TM_HrmRoles_SystemRight
( rightgroup varchar(80),
rightlevel char,
rightid integer )
ON COMMIT DELETE ROWS
/


create GLOBAL TEMPORARY TABLE TM_FnaCurrencyExchange
( defcurrencyid  integer ,
thecurrencyid  integer,
endexchangerage       varchar2(20) )
ON COMMIT DELETE ROWS
/

create GLOBAL TEMPORARY TABLE TM_FnaYearsPeriodsListClose1
( ledgerid  integer ,
departmentid  integer,
ledgerbalance       char(1) )
ON COMMIT DELETE ROWS
/

create GLOBAL TEMPORARY TABLE TM_FnaYearsPeriodsListClose2
( ledgerid  integer ,
costcenterid  integer,
ledgerbalance       char(1) )
ON COMMIT DELETE ROWS
/

create GLOBAL TEMPORARY TABLE TM_FnaYearsPeriodsListClose3
( ledgerid  integer ,
departmentid  integer,
budgetmoduleid       integer )
ON COMMIT DELETE ROWS
/

create GLOBAL TEMPORARY TABLE TM_FnaYearsPeriodsListClose4
( ledgerid  integer ,
costcenterid  integer,
budgetmoduleid       integer )
ON COMMIT DELETE ROWS
/

create GLOBAL TEMPORARY TABLE TM_DocRpSum
( resultid  integer ,
acount  integer, 
replycount integer ) 
ON COMMIT DELETE ROWS
/

create GLOBAL TEMPORARY TABLE TM_DocReadRpSum
 ( docid  integer ,
 acount  integer,
 doccreaterid	integer,
 docdepartmentid	integer,
 maincategory	integer )
 ON COMMIT DELETE ROWS
/