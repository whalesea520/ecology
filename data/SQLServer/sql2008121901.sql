insert into SystemRights (id,rightdesc,righttype) values (808,'COA段值维护','2') 
GO

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (808,9,'COA段值維護','COA段值維護') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (808,7,'COA段值维护','COA段值维护') 
GO
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (808,8,'COA Maintenance','COA Maintenance') 
GO

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (4319,'COA段值维护','coaset:all',808) 
GO
 


delete from HtmlLabelIndex where id=22087 
GO
delete from HtmlLabelInfo where indexid=22087 
GO
INSERT INTO HtmlLabelIndex values(22087,'晶澳借款单') 
GO
delete from HtmlLabelIndex where id=22092 
GO
delete from HtmlLabelInfo where indexid=22092 
GO
INSERT INTO HtmlLabelIndex values(22092,'预支金额小写') 
GO
delete from HtmlLabelIndex where id=22104 
GO
delete from HtmlLabelInfo where indexid=22104 
GO
INSERT INTO HtmlLabelIndex values(22104,'金额大写') 
GO
delete from HtmlLabelIndex where id=22100 
GO
delete from HtmlLabelInfo where indexid=22100 
GO
INSERT INTO HtmlLabelIndex values(22100,'相关借款流程') 
GO
delete from HtmlLabelIndex where id=22095 
GO
delete from HtmlLabelInfo where indexid=22095 
GO
INSERT INTO HtmlLabelIndex values(22095,'银行信息') 
GO
delete from HtmlLabelIndex where id=22094 
GO
delete from HtmlLabelInfo where indexid=22094 
GO
INSERT INTO HtmlLabelIndex values(22094,'记账日期') 
GO
delete from HtmlLabelIndex where id=22093 
GO
delete from HtmlLabelInfo where indexid=22093 
GO
INSERT INTO HtmlLabelIndex values(22093,'预支金额大写') 
GO
delete from HtmlLabelIndex where id=22088 
GO
delete from HtmlLabelInfo where indexid=22088 
GO
INSERT INTO HtmlLabelIndex values(22088,'晶澳还款单') 
GO
delete from HtmlLabelIndex where id=22103 
GO
delete from HtmlLabelInfo where indexid=22103 
GO
INSERT INTO HtmlLabelIndex values(22103,'金额小写') 
GO
delete from HtmlLabelIndex where id=22107 
GO
delete from HtmlLabelInfo where indexid=22107 
GO
INSERT INTO HtmlLabelIndex values(22107,'费用类型') 
GO
delete from HtmlLabelIndex where id=22106 
GO
delete from HtmlLabelInfo where indexid=22106 
GO
INSERT INTO HtmlLabelIndex values(22106,'相关借款单') 
GO
delete from HtmlLabelIndex where id=22110 
GO
delete from HtmlLabelInfo where indexid=22110 
GO
INSERT INTO HtmlLabelIndex values(22110,'金额大写') 
GO
delete from HtmlLabelIndex where id=22099 
GO
delete from HtmlLabelInfo where indexid=22099 
GO
INSERT INTO HtmlLabelIndex values(22099,'还款金额大写') 
GO
delete from HtmlLabelIndex where id=22109 
GO
delete from HtmlLabelInfo where indexid=22109 
GO
INSERT INTO HtmlLabelIndex values(22109,'单据张数') 
GO
delete from HtmlLabelIndex where id=22098 
GO
delete from HtmlLabelInfo where indexid=22098 
GO
INSERT INTO HtmlLabelIndex values(22098,'还款金额') 
GO
delete from HtmlLabelIndex where id=22097 
GO
delete from HtmlLabelInfo where indexid=22097 
GO
INSERT INTO HtmlLabelIndex values(22097,'还款方式') 
GO
delete from HtmlLabelIndex where id=22090 
GO
delete from HtmlLabelInfo where indexid=22090 
GO
INSERT INTO HtmlLabelIndex values(22090,'预支事由') 
GO
delete from HtmlLabelIndex where id=22101 
GO
delete from HtmlLabelInfo where indexid=22101 
GO
INSERT INTO HtmlLabelIndex values(22101,'是否已收到还款') 
GO
delete from HtmlLabelIndex where id=22091 
GO
delete from HtmlLabelInfo where indexid=22091 
GO
INSERT INTO HtmlLabelIndex values(22091,'预支金额') 
GO
delete from HtmlLabelIndex where id=22085 
GO
delete from HtmlLabelInfo where indexid=22085 
GO
INSERT INTO HtmlLabelIndex values(22085,'晶澳费用报销单') 
GO
delete from HtmlLabelIndex where id=22108 
GO
delete from HtmlLabelInfo where indexid=22108 
GO
INSERT INTO HtmlLabelIndex values(22108,'当前预算') 
GO
delete from HtmlLabelIndex where id=22102 
GO
delete from HtmlLabelInfo where indexid=22102 
GO
INSERT INTO HtmlLabelIndex values(22102,'申请事由') 
GO
delete from HtmlLabelIndex where id=22089 
GO
delete from HtmlLabelInfo where indexid=22089 
GO
INSERT INTO HtmlLabelIndex values(22089,'公司') 
GO
delete from HtmlLabelIndex where id=22086 
GO
delete from HtmlLabelInfo where indexid=22086 
GO
INSERT INTO HtmlLabelIndex values(22086,'晶澳费用申请单') 
GO
delete from HtmlLabelIndex where id=22096 
GO
delete from HtmlLabelInfo where indexid=22096 
GO
INSERT INTO HtmlLabelIndex values(22096,'还款人') 
GO
INSERT INTO HtmlLabelInfo VALUES(22085,'晶澳费用报销单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22085,'ja expense wipe',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22085,'晶澳費用報銷單',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22086,'晶澳费用申请单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22086,'ja expense applications',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22086,'晶澳費用申請單',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22087,'晶澳借款单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22087,'ja loan',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22087,'晶澳借款單',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22088,'晶澳还款单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22088,'ja repayment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22088,'晶澳還款單',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22089,'公司',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22089,'company',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22089,'公司',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22090,'预支事由',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22090,'The subject matter of advance',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22090,'預支事由',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22091,'预支金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22091,'The amount of advance',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22091,'預支金額',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22092,'预支金额小写',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22092,'Advance the amount of lower-case',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22092,'預支金額小寫',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22093,'预支金额大写',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22093,'Advance the amount of capital',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22093,'預支金額大寫',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22094,'记账日期',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22094,'accounting date',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22094,'記賬日期',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22095,'银行信息',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22095,'bank infomation',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22095,'銀行信息',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22096,'还款人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22096,'repayment person',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22096,'',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22097,'还款方式',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22097,'repayment type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22097,'還款方式',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22098,'还款金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22098,'Repayment amount',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22098,'還款金額',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22099,'还款金额大写',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22099,'Repayment of the amount of capital',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22099,'還款金額大寫',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22100,'相关借款流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22100,'relate loan workflow',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22100,'相關借款流程',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22101,'是否已收到还款',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22101,'Whether it has received repayment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22101,'是否已收到還款',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22102,'申请事由',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22102,'reason',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22102,'申請事由',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22103,'金额小写',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22103,'The amount of lower-case',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22103,'金額小寫',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22104,'金额大写',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22104,'The amount of capital',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22104,'金額大寫',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22106,'相关借款单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22106,'relate loan',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22106,'相關借款單',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22107,'费用类型',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22107,'expense type',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22107,'費用類型',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22108,'当前预算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22108,'current budget',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22108,'當前預算',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22109,'单据张数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22109,'bill sum',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22109,'單據張數',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22110,'金额大写',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22110,'amount capital',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22110,'金額大寫',9) 
GO

 delete from HtmlLabelIndex where id=22112 
GO
delete from HtmlLabelInfo where indexid=22112 
GO
INSERT INTO HtmlLabelIndex values(22112,'段值') 
GO
INSERT INTO HtmlLabelInfo VALUES(22112,'段值',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22112,'Paragraph value',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22112,'段值',9) 
GO

delete from HtmlLabelIndex where id=22117 
GO
delete from HtmlLabelInfo where indexid=22117 
GO
INSERT INTO HtmlLabelIndex values(22117,'COA段值设置') 
GO
INSERT INTO HtmlLabelInfo VALUES(22117,'COA段值设置',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22117,'COA SET',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22117,'COA段值設置',9) 
GO
delete from HtmlLabelIndex where id=22126 
GO
delete from HtmlLabelInfo where indexid=22126 
GO
INSERT INTO HtmlLabelIndex values(22126,'部门段') 
GO
delete from HtmlLabelIndex where id=22127 
GO
delete from HtmlLabelInfo where indexid=22127 
GO
INSERT INTO HtmlLabelIndex values(22127,'账户段') 
GO
delete from HtmlLabelIndex where id=22128 
GO
delete from HtmlLabelInfo where indexid=22128 
GO
INSERT INTO HtmlLabelIndex values(22128,'子目段') 
GO
INSERT INTO HtmlLabelInfo VALUES(22126,'部门段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22126,'Department paragraph',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22126,'部門段',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22127,'账户段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22127,'Account paragraph',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22127,'帳戶段',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(22128,'子目段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22128,'sub account Paragraph',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22128,'子目段',9) 
GO
delete from HtmlLabelIndex where id=22105 
GO
delete from HtmlLabelInfo where indexid=22105 
GO
INSERT INTO HtmlLabelIndex values(22105,'相关流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(22105,'相关流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22105,'related requests',8) 
GO

delete from HtmlLabelIndex where id=22105 
GO
delete from HtmlLabelInfo where indexid=22105 
GO
INSERT INTO HtmlLabelIndex values(22105,'相关流程') 
GO
INSERT INTO HtmlLabelInfo VALUES(22105,'相关流程',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22105,'related requests',8) 
GO



delete from HtmlLabelIndex where id=22207 
GO
delete from HtmlLabelInfo where indexid=22207 
GO
INSERT INTO HtmlLabelIndex values(22207,'现金流量标识') 
GO
INSERT INTO HtmlLabelInfo VALUES(22207,'现金流量标识',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(22207,'Cash Flow Code',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(22207,'現金流量標識',9) 
GO
