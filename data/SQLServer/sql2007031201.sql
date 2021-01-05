delete from HtmlLabelIndex where id=20245
go
delete from HtmlLabelInfo where indexid=20245
go

INSERT INTO HtmlLabelIndex values(20245,'帐户已被邮件规则引用，请先删除或转移相应的邮件规则！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20245,'帐户已被邮件规则引用，请先删除或转移相应的邮件规则！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20245,'Mail account has been referred, Please first remove or move the rules!',8) 
GO
delete from HtmlLabelIndex where id in (20250,20251,20252)
go
delete from HtmlLabelInfo where indexid in (20250,20251,20252)
go

INSERT INTO HtmlLabelIndex values(20250,'请先选择联系人') 
GO
INSERT INTO HtmlLabelInfo VALUES(20250,'请先选择联系人',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20250,'Please first select contacter',8) 
GO
INSERT INTO HtmlLabelIndex values(20252,'确定将所选的联系人移至') 
GO
INSERT INTO HtmlLabelIndex values(20251,'确定将所选的邮件移至') 
GO
INSERT INTO HtmlLabelInfo VALUES(20251,'确定将所选的邮件移至',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20251,'Do you confirm moving the mail to',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20252,'确定将所选的联系人移至',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20252,'Do you confirm moving the contacter to',8) 
GO
