delete from HtmlLabelIndex where id=19808
GO
delete from HtmlLabelInfo where indexid=19808
GO
INSERT INTO HtmlLabelIndex values(19808,'恒安借款申请单') 
GO
INSERT INTO HtmlLabelInfo VALUES(19808,'恒安借款申请单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19808,'hengan loan apply bill',8) 
GO

delete from HtmlLabelIndex where id=19845 or id=19846
GO
delete from HtmlLabelInfo where indexid=19845 or indexid=19846
GO
INSERT INTO HtmlLabelIndex values(19845,'借款金额(本外币)') 
GO
INSERT INTO HtmlLabelInfo VALUES(19845,'借款金额(本外币)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19845,'loan amount (pound)',8) 
GO
INSERT INTO HtmlLabelIndex values(19846,'借款金额(人民币)') 
GO
INSERT INTO HtmlLabelInfo VALUES(19846,'借款金额(人民币)',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19846,'loan amount (RMB)',8) 
GO

delete from HtmlLabelIndex where id=19879
GO
delete from HtmlLabelInfo where indexid=19879
GO
delete from HtmlLabelIndex where id>=19883 and id<=19898
GO
delete from HtmlLabelInfo where indexid>=19883 and indexid<=19898
GO

delete from HtmlLabelIndex where id=19931 
GO
delete from HtmlLabelInfo where indexid=19931
GO
delete from HtmlLabelIndex where id=19932
GO
delete from HtmlLabelInfo where indexid=19932
GO

delete from HtmlLabelIndex where id=19934 and id<=19938
GO
delete from HtmlLabelInfo where indexid>19934 and indexid<=19938
GO

delete from HtmlLabelIndex where id=19958 and id<=19962
GO
delete from HtmlLabelInfo where indexid>19958 and indexid<=19962
GO

INSERT INTO HtmlLabelIndex values(19879,'余额操作标记') 
GO
INSERT INTO HtmlLabelInfo VALUES(19879,'余额操作标记',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19879,'balance operate flag',8) 
GO

INSERT INTO HtmlLabelIndex values(19883,'恒安出差申请单') 
GO
INSERT INTO HtmlLabelIndex values(19886,'相关借款') 
GO
INSERT INTO HtmlLabelIndex values(19889,'出差地点') 
GO
INSERT INTO HtmlLabelIndex values(19890,'出差时间从') 
GO
INSERT INTO HtmlLabelIndex values(19894,'年度截至当月预算余额') 
GO
INSERT INTO HtmlLabelIndex values(19895,'年度费用实际') 
GO
INSERT INTO HtmlLabelIndex values(19898,'报销金额（人民币）') 
GO
INSERT INTO HtmlLabelIndex values(19884,'参考号码') 
GO
INSERT INTO HtmlLabelIndex values(19885,'会计期间') 
GO
INSERT INTO HtmlLabelIndex values(19887,'动支金额') 
GO
INSERT INTO HtmlLabelIndex values(19891,'出差时间到') 
GO
INSERT INTO HtmlLabelIndex values(19893,'年度预算余额') 
GO
INSERT INTO HtmlLabelIndex values(19896,'月度预算余额') 
GO
INSERT INTO HtmlLabelIndex values(19897,'报销金额（本外币）') 
GO
INSERT INTO HtmlLabelIndex values(19888,'预算部门') 
GO
INSERT INTO HtmlLabelIndex values(19892,'动支说明') 
GO
INSERT INTO HtmlLabelIndex values(19932,'报销操作标记') 
GO
INSERT INTO HtmlLabelIndex values(19931,'动支操作标记') 
GO
INSERT INTO HtmlLabelIndex values(19934,'员工级别') 
GO
INSERT INTO HtmlLabelIndex values(19935,'出差目的') 
GO
INSERT INTO HtmlLabelIndex values(19936,'收款人') 
GO
INSERT INTO HtmlLabelIndex values(19937,'开户行') 
GO
INSERT INTO HtmlLabelIndex values(19938,'费用控制') 
GO
INSERT INTO HtmlLabelIndex values(19958,'人民币') 
GO
INSERT INTO HtmlLabelIndex values(19961,'港币') 
GO
INSERT INTO HtmlLabelIndex values(19962,'日元') 
GO
INSERT INTO HtmlLabelIndex values(19959,'美元') 
GO
INSERT INTO HtmlLabelIndex values(19960,'英镑') 
GO



INSERT INTO HtmlLabelInfo VALUES(19883,'恒安出差申请单',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19884,'参考号码',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19885,'会计期间',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19886,'相关借款',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19887,'动支金额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19888,'预算部门',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19889,'出差地点',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19890,'出差时间从',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19891,'出差时间到',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19892,'动支说明',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19893,'年度预算余额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19894,'年度截至当月预算余额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19895,'年度费用实际',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19896,'月度预算余额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19897,'报销金额（本外币）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19898,'报销金额（人民币）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19931,'动支操作标记',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19932,'报销操作标记',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19934,'员工级别',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19935,'出差目的',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19936,'收款人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19937,'开户行',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19938,'费用控制',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19958,'人民币',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19959,'美元',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19960,'英镑',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19961,'港币',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(19962,'日元',7) 
GO


INSERT INTO HtmlLabelInfo VALUES(19883,'HengAn BussinessTrip apply',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19884,'applyid',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19885,'budgetperiod',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19886,'relate loan',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19887,'apply amount',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19888,'budget department',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19889,'trip target',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19890,'trip date from',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19891,'trip date to',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19892,'apply notes',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19893,'budget balance of year',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19894,'budget balance tomonth',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19895,'expense of year',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19896,'budget of month',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19897,'wipeamount(all currency)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19898,'wipeamount(RMB)',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19931,'apply operation flag',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19932,'wipe operation flag',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19934,'employee level',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19935,'business trip description',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19936,'payee',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19937,'bank',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19938,'expense control',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19958,'RMB',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19959,'dollar',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19960,'pound',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19961,'Hongkong dollar',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(19962,'yen',8) 
GO
