delete from HtmlLabelIndex where id=21802 
GO
delete from HtmlLabelInfo where indexid=21802 
GO
INSERT INTO HtmlLabelIndex values(21802,'年假导入') 
GO
delete from HtmlLabelIndex where id=21803 
GO
delete from HtmlLabelInfo where indexid=21803 
GO
INSERT INTO HtmlLabelIndex values(21803,'年假导出') 
GO
INSERT INTO HtmlLabelInfo VALUES(21802,'年假导入',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21802,'Import annual leave',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21803,'年假导出',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21803,'Export annual leave',8) 
GO
delete from HtmlLabelIndex where id=21811 
GO
delete from HtmlLabelInfo where indexid=21811 
GO
INSERT INTO HtmlLabelIndex values(21811,'年假小时数') 
GO
INSERT INTO HtmlLabelInfo VALUES(21811,'年假小时数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21811,'Annual leave hours',8) 
GO
delete from HtmlLabelIndex where id=21812 
GO
delete from HtmlLabelInfo where indexid=21812 
GO
INSERT INTO HtmlLabelIndex values(21812,'年假发生月的最后一天') 
GO
delete from HtmlLabelIndex where id=21813 
GO
delete from HtmlLabelInfo where indexid=21813 
GO
INSERT INTO HtmlLabelIndex values(21813,'是否本月发生') 
GO
INSERT INTO HtmlLabelInfo VALUES(21812,'年假发生月的最后一天',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21812,'Annual leave, occurred on the last day of',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(21813,'是否本月发生',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(21813,'is happened this month',8) 
GO
