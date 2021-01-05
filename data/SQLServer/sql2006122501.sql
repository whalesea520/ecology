delete from HtmlLabelIndex where id=20068
go
delete from HtmlLabelInfo where indexid=20068
go

INSERT INTO HtmlLabelIndex values(20068,'身份证号码重复！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20068,'身份证号码重复！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20068,'The ID card number is repeated!',8) 
GO