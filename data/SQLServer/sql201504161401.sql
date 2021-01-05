delete from HtmlLabelIndex where id=82765 
GO
delete from HtmlLabelInfo where indexid=82765 
GO
INSERT INTO HtmlLabelIndex values(82765,'可用调休天数') 
GO
INSERT INTO HtmlLabelInfo VALUES(82765,'可用调休天数',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82765,'Available off days',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82765,'可用調休天數',9) 
GO

delete from HtmlLabelIndex where id=82767 
GO
delete from HtmlLabelInfo where indexid=82767 
GO
INSERT INTO HtmlLabelIndex values(82767,'可用调休天数为0，不能请调休假！') 
GO
INSERT INTO HtmlLabelInfo VALUES(82767,'可用调休天数为0，不能请调休假！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82767,'Available transfer off day number 0, please turn it off!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82767,'可用調休天數爲0，不能請調休假！',9) 
GO

delete from HtmlLabelIndex where id=82766 
GO
delete from HtmlLabelInfo where indexid=82766 
GO
INSERT INTO HtmlLabelIndex values(82766,'本次所请调休天数大于您的可用调休天数，请修改请假时间！') 
GO
INSERT INTO HtmlLabelInfo VALUES(82766,'本次所请调休天数大于您的可用调休天数，请修改请假时间！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82766,'This time please take days off more than you can stay, please modify the time of leave!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82766,'本次所請調休天數大于您的可用調休天數，請修改請假時間！',9) 
GO

delete from HtmlLabelIndex where id=82768 
GO
delete from HtmlLabelInfo where indexid=82768 
GO
INSERT INTO HtmlLabelIndex values(82768,'未签到说明明细') 
GO
INSERT INTO HtmlLabelInfo VALUES(82768,'未签到说明明细',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(82768,'No sign that details',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(82768,'未簽到說明明細',9) 
GO