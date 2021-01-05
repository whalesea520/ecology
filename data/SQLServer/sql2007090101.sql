delete from HtmlLabelIndex where id=20867
go

delete from HtmlLabelInfo where indexid=20867
go

INSERT INTO HtmlLabelIndex values(20867,'该属性选中保存后将不可取消！') 
GO
INSERT INTO HtmlLabelInfo VALUES(20867,'该属性选中保存后将不可取消！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20867,'this selected can not cancle!',8) 
GO
