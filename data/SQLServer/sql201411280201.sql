delete from HtmlLabelIndex where id=81685 
GO
delete from HtmlLabelInfo where indexid=81685 
GO
INSERT INTO HtmlLabelIndex values(81685,'该部门下有岗位,不能删除') 
GO
INSERT INTO HtmlLabelInfo VALUES(81685,'该部门下有岗位,不能删除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(81685,'The department has a job the next, you can not delete',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(81685,'該部門下有崗位,不能删除',9) 
GO


delete from HtmlNoteIndex where id=3400 
GO
delete from HtmlNoteInfo where indexid=3400 
GO
INSERT INTO HtmlNoteIndex values(3400,'操作异常,请刷新页面重新操作') 
GO
INSERT INTO HtmlNoteInfo VALUES(3400,'操作异常,请刷新页面重新操作',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(3400,'Abnormal operation, please refresh the page re-operation',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(3400,'操作異常，請刷新頁面重新操作',9) 
GO

delete from HtmlNoteIndex where id=103 
GO
delete from HtmlNoteInfo where indexid=103 
GO
INSERT INTO HtmlNoteIndex values(103,'无法删除：分部下包含其他部门！') 
GO
INSERT INTO HtmlNoteInfo VALUES(103,'无法删除：分部下包含其他部门！',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(103,'Cannot delete: segment contains other departments!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(103,'無法刪除：分部下包含其他部門！',9) 
GO

delete from HtmlNoteIndex where id=104 
GO
delete from HtmlNoteInfo where indexid=104 
GO
INSERT INTO HtmlNoteIndex values(104,'无法删除：分部下包含其他分部！') 
GO
INSERT INTO HtmlNoteInfo VALUES(104,'无法删除：分部下包含其他分部！',7) 
GO
INSERT INTO HtmlNoteInfo VALUES(104,'Cannot delete: segment contains other segment!',8) 
GO
INSERT INTO HtmlNoteInfo VALUES(104,'無法刪除：分部下包含其他分部！',9) 
GO
