delete from HtmlLabelIndex where id=126572 
GO
delete from HtmlLabelInfo where indexid=126572 
GO
INSERT INTO HtmlLabelIndex values(126572,'您无权限查看此流程, 它可能已被强制收回或删除！') 
GO
INSERT INTO HtmlLabelInfo VALUES(126572,'您无权限查看此流程, 它可能已被强制收回或删除！',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126572,'You do not have permission to view this workflow, it may have been forced to withdraw or delete!',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126572,'您無權限查看此流程, 它可能已被強制收回或删除！',9) 
GO