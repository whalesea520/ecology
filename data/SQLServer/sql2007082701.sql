delete from HtmlLabelIndex where id in(20855,20856)
GO
delete from HtmlLabelInfo where indexid in(20855,20856)
GO
INSERT INTO HtmlLabelIndex values(20855,'¶©µ¥¼à¿Ø') 
GO
INSERT INTO HtmlLabelIndex values(20856,'ÉÌ»ú¼à¿Ø') 
GO
INSERT INTO HtmlLabelInfo VALUES(20855,'¶©µ¥¼à¿Ø',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20855,'Order Manager',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(20856,'ÉÌ»ú¼à¿Ø',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20856,'SellChange Manage',8) 
GO

