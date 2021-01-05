ALTER TABLE fnaFeeWfInfoField ADD showAllType INTeger
/


update fnaFeeWfInfoField set showAllType=0
/



ALTER TABLE fnaFeeWfInfo ADD templateFile varchar2(4000)
/
ALTER TABLE fnaFeeWfInfo ADD templateFileMobile varchar2(4000)
/


update fnaFeeWfInfo 
set templateFile='FnaSubmitRequestJs.jsp', 
templateFileMobile='FnaSubmitRequestJs4Mobile.jsp' 
/