delete from SystemRightDetail where rightid =1884
GO
delete from SystemRightsLanguage where id =1884
GO
delete from SystemRights where id =1884
GO
insert into SystemRights (id,rightdesc,righttype) values (1884,'���˽����ܱ���ѯ','2') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1884,12,'','') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1884,8,'Loan repayment analysis of statistical table query','Loan repayment analysis of statistical table query') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1884,7,'���˽����ܱ���ѯ','���˽����ܱ���ѯ') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1884,9,'���˽�������ԃ','���˽�������ԃ') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43115,'���˽����ܱ���ѯ','LoanRepaymentAnalysis:qry',1884) 
GO