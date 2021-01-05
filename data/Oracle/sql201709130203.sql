create table fnaInvoiceLedger( 
  id Integer PRIMARY KEY NOT NULL, 
  billingDate char(10), 
  invoiceCode varchar2(60), 
  invoiceNumber varchar2(60), 
  invoiceType integer, 
  seller varchar2(1500), 
  purchaser varchar2(1500), 
  invoiceServiceYype varchar2(1500), 
  priceWithoutTax decimal(20, 2), 
  taxRate decimal(8, 2), 
  tax decimal(20, 2), 
  taxIncludedPrice decimal(20, 2), 
  authenticity integer, 
  reimbursementDate char(10), 
  reimbursePerson integer, 
  requestId integer  
) 
/ 

create sequence fnaInvoiceLedger_ID minvalue 1 maxvalue 999999999999999999999999999 start with 1 increment by 1 nocache 
/

create or replace trigger fnaInvoiceLedger_Trigger before insert on fnaInvoiceLedger for each row 
begin select fnaInvoiceLedger_ID.nextval INTO :new.id from dual; end;
/ 




delete from SystemRightDetail where rightid =2138
/
delete from SystemRightsLanguage where id =2138
/
delete from SystemRights where id =2138
/
insert into SystemRights (id,rightdesc,righttype) values (2138,'发票台账设置','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,8,'Invoice ledger settings','Invoice ledger settings') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,15,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,7,'发票台账设置','发票台账设置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,13,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,9,'發票台賬設置','發票台賬設置') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,14,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43361,'发票台账设置','FnaInvoiceLedger:settings',2138) 
/