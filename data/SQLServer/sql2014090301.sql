delete from HtmlLabelIndex where id=33858 
GO
delete from HtmlLabelInfo where indexid=33858 
GO
INSERT INTO HtmlLabelIndex values(33858,'已经签退，请勿重复签退') 
GO
INSERT INTO HtmlLabelInfo VALUES(33858,'已经签退，请勿重复签退',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(33858,'you have already signed，please do not repeat sign',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(33858,'已經簽退，請勿重複簽退',9) 
GO
