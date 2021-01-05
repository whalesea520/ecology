delete from SystemRightDetail where rightid =1884
/
delete from SystemRightsLanguage where id =1884
/
delete from SystemRights where id =1884
/
insert into SystemRights (id,rightdesc,righttype) values (1884,'个人借款汇总表查询','2') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1884,12,'','') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1884,8,'Loan repayment analysis of statistical table query','Loan repayment analysis of statistical table query') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1884,7,'个人借款汇总表查询','个人借款汇总表查询') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (1884,9,'個人借款彙總表查詢','個人借款彙總表查詢') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (43115,'个人借款汇总表查询','LoanRepaymentAnalysis:qry',1884) 
/