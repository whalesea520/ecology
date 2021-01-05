create table fnaInvoiceLedger( 
  id INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
  billingDate char(10), 
  invoiceCode varchar(60), 
  invoiceNumber varchar(60), 
  invoiceType int, 
  seller varchar(1500), 
  purchaser varchar(1500), 
  invoiceServiceYype varchar(1500), 
  priceWithoutTax decimal(20, 2), 
  taxRate decimal(8, 2), 
  tax decimal(20, 2), 
  taxIncludedPrice decimal(20, 2), 
  authenticity int, 
  reimbursementDate char(10), 
  reimbursePerson int, 
  requestId int 
) 
go 




delete from SystemRightDetail where rightid =2138
GO
delete from SystemRightsLanguage where id =2138
GO
delete from SystemRights where id =2138
GO
insert into SystemRights (id,rightdesc,righttype) values (2138,'发票台账设置','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,8,'Invoice ledger settings','Invoice ledger settings') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,15,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,7,'发票台账设置','发票台账设置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,13,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,9,'發票台賬設置','發票台賬設置') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (2138,14,'','') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43361,'发票台账设置','FnaInvoiceLedger:settings',2138) 
GO