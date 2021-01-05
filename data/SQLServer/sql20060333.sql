INSERT INTO HtmlLabelIndex values(18743,'计算符号') 
GO
INSERT INTO HtmlLabelInfo VALUES(18743,'计算符号',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18743,'compute sign',8) 
GO

INSERT INTO HtmlLabelIndex values(18744,'退格') 
GO
INSERT INTO HtmlLabelInfo VALUES(18744,'退格',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18744,'back',8) 
GO

INSERT INTO HtmlLabelIndex values(18689,'请填写要加入的数字') 
GO
INSERT INTO HtmlLabelIndex values(18688,'真的要删除这条规则吗？') 
GO

INSERT INTO HtmlLabelInfo VALUES(18688,'真的要删除这条规则吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18688,'Are you sure to delete?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(18689,'请填写要加入的数字',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18689,'please,Input number',8) 
GO

INSERT INTO HtmlLabelIndex values(18745,'是否合计') 
GO
INSERT INTO HtmlLabelInfo VALUES(18745,'是否合计',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18745,'wheather total',8) 
GO

INSERT INTO HtmlLabelIndex values(18746,'赋值给主字段') 
GO
INSERT INTO HtmlLabelInfo VALUES(18746,'赋值给主字段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(18746,'set value to mainfield',8) 
GO
 

ALTER  TABLE workflow_formdetailinfo 
ALTER  COLUMN  rowcalstr text NULL 
go
 ALTER  TABLE workflow_formdetailinfo 
ALTER  COLUMN  colcalstr text NULL 
go
 ALTER  TABLE workflow_formdetailinfo 
ALTER  COLUMN  maincalstr text NULL
go