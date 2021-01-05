delete from HtmlLabelIndex where id=25487 
GO
delete from HtmlLabelInfo where indexid=25487 
GO
INSERT INTO HtmlLabelIndex values(25487,'您还没有进行签章，请先签章！') 
GO
INSERT INTO HtmlLabelInfo VALUES(25487,'您还没有进行签章，请先签章！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(25487,'You haven''t carried on a signature, please sign first!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(25487,'您還沒有進行簽章，請先簽章！',9) 
GO
