alter table fnaVoucherXml add interfacesAddress VARCHAR2(4000)
/



create table fnaVoucherXmlContentOld as Select * from fnaVoucherXmlContent
/
alter table fnaVoucherXmlContent drop column CONTENTVALUE
/
alter table fnaVoucherXmlContent drop column PARAMETER
/

alter table fnaVoucherXmlContent add CONTENTVALUE clob
/
alter table fnaVoucherXmlContent add PARAMETER clob
/



create table fnaVoucherXmlContentDsetOld as Select * from fnaVoucherXmlContentDset
/
alter table fnaVoucherXmlContentDset drop column PARAMETER
/
alter table fnaVoucherXmlContentDset add PARAMETER clob
/



create table fnaDataSetOld as Select * from fnaDataSet
/
alter table fnaDataSet drop column dSetStr
/
alter table fnaDataSet add dSetStr clob
/



create table WorkflowToFinanceUrlOld as Select * from WorkflowToFinanceUrl
/
alter table WorkflowToFinanceUrl drop column xmlSend
/
alter table WorkflowToFinanceUrl drop column REQUESTIDS
/
alter table WorkflowToFinanceUrl drop column XMLRECEIVE
/
alter table WorkflowToFinanceUrl drop column XMLOBJSEND
/
alter table WorkflowToFinanceUrl drop column XMLOBJRECEIVE
/
alter table WorkflowToFinanceUrl add xmlSend clob
/
alter table WorkflowToFinanceUrl add REQUESTIDS clob
/
alter table WorkflowToFinanceUrl add XMLRECEIVE clob
/
alter table WorkflowToFinanceUrl add XMLOBJSEND clob
/
alter table WorkflowToFinanceUrl add XMLOBJRECEIVE clob
/



create table fnaFinancesettingOld as Select * from fnaFinancesetting
/
alter table fnaFinancesetting drop column fieldValue
/
alter table fnaFinancesetting add fieldValue clob
/

alter table fnaVoucherXmlContent add isNullNotPrintNode integer
/

alter table fnaVoucherXml add profession INTEGER
/

