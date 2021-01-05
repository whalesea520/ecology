delete from HtmlLabelIndex where id=27217 
GO
delete from HtmlLabelInfo where indexid=27217 
GO
INSERT INTO HtmlLabelIndex values(27217,'待办事宜（已看未处理）') 
GO
delete from HtmlLabelIndex where id=27218 
GO
delete from HtmlLabelInfo where indexid=27218 
GO
INSERT INTO HtmlLabelIndex values(27218,'待办事宜（未看）') 
GO
INSERT INTO HtmlLabelInfo VALUES(27217,'待办事宜（已看未处理）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27217,'Pending Matters （Viewed）',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27217,'待辦事宜（已看未處理）',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(27218,'待办事宜（未看）',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(27218,'Pending Matters（No view）',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(27218,'待辦事宜（未看）',9) 
GO
