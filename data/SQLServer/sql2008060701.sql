delete from HtmlLabelIndex where id=21147 
GO
delete from HtmlLabelInfo where indexid=21147 
GO
INSERT INTO HtmlLabelIndex values(21147,'年度截至当月冻结预算') 
GO
INSERT INTO HtmlLabelInfo VALUES(21147,'年度截至当月冻结预算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21147,'As of the month to freeze the annual budget',8) 
GO

delete from HtmlLabelIndex where id=21502 
GO
delete from HtmlLabelInfo where indexid=21502 
GO
INSERT INTO HtmlLabelIndex values(21502,'相关动支') 
GO
INSERT INTO HtmlLabelInfo VALUES(21502,'相关动支',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21502,'relate apply amount',8) 
GO

delete from HtmlLabelIndex where id=21505 
GO
delete from HtmlLabelInfo where indexid=21505 
GO
INSERT INTO HtmlLabelIndex values(21505,'动支流程标识') 
GO
INSERT INTO HtmlLabelInfo VALUES(21505,'动支流程标识',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21505,'applyamount workflow flag',8) 
GO

delete from HtmlLabelIndex where id=21518 
GO
delete from HtmlLabelInfo where indexid=21518 
GO
INSERT INTO HtmlLabelIndex values(21518,'动支流程id') 
GO
INSERT INTO HtmlLabelInfo VALUES(21518,'动支流程id',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21518,'applyamount workflow id',8) 
GO

delete from HtmlLabelIndex where id=21524 
GO
delete from HtmlLabelInfo where indexid=21524 
GO
INSERT INTO HtmlLabelIndex values(21524,'出纳报销操作标记') 
GO
INSERT INTO HtmlLabelInfo VALUES(21524,'出纳报销操作标记',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21524,'Cashier claims operation flag',8) 
GO

delete from HtmlLabelIndex where id=21526 
GO
delete from HtmlLabelInfo where indexid=21526 
GO
INSERT INTO HtmlLabelIndex values(21526,'动支明细id') 
GO
INSERT INTO HtmlLabelInfo VALUES(21526,'动支明细id',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21526,'applyamount detail id',8) 
GO

delete from HtmlLabelIndex where id=21506 
GO
delete from HtmlLabelInfo where indexid=21506 
GO
INSERT INTO HtmlLabelIndex values(21506,'确定将该流程作废？一旦作废，流程数据将不可恢复！') 
GO
INSERT INTO HtmlLabelInfo VALUES(21506,'确定将该流程作废？一旦作废，流程数据将不可恢复！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21506,'Are you sure to blank out the workflow ?Once the cancellation, the data of workflow will not be allowed to resume!',8) 
GO

delete from HtmlLabelIndex where id=21507 
GO
delete from HtmlLabelInfo where indexid=21507 
GO
INSERT INTO HtmlLabelIndex values(21507,'所选流程动支总额') 
GO
INSERT INTO HtmlLabelInfo VALUES(21507,'所选流程动支总额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21507,'Total fixed-selected process',8) 
GO

delete from HtmlLabelIndex where id=21509 
GO
delete from HtmlLabelInfo where indexid=21509 
GO
INSERT INTO HtmlLabelIndex values(21509,'所选流程动支余额') 
GO
INSERT INTO HtmlLabelInfo VALUES(21509,'所选流程动支余额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21509,'Selected dynamic process with the balance',8) 
GO

delete from HtmlLabelIndex where id=21525 
GO
delete from HtmlLabelInfo where indexid=21525 
GO
INSERT INTO HtmlLabelIndex values(21525,'报销总额不能大于所选流程动支余额') 
GO
INSERT INTO HtmlLabelInfo VALUES(21525,'报销总额不能大于所选流程动支余额',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21525,'Claims could not total more than the selected fixed-flow balance',8) 
GO


delete from HtmlLabelIndex where id=21146 
GO
delete from HtmlLabelInfo where indexid=21146 
GO
INSERT INTO HtmlLabelIndex values(21146,'年度冻结预算') 
GO
INSERT INTO HtmlLabelInfo VALUES(21146,'年度冻结预算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21146,'The annual budget freeze',8) 
GO
delete from HtmlLabelIndex where id=21148 
GO
delete from HtmlLabelInfo where indexid=21148 
GO
INSERT INTO HtmlLabelIndex values(21148,'月度冻结预算') 
GO
INSERT INTO HtmlLabelInfo VALUES(21148,'月度冻结预算',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21148,'Monthly budget freeze',8) 
GO
