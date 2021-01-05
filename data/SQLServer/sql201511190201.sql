delete from HtmlLabelIndex where id=126047 
GO
delete from HtmlLabelInfo where indexid=126047 
GO
INSERT INTO HtmlLabelIndex values(126047,'删除此菜单将会删除此菜单的所有下级菜单，是否继续?') 
GO
INSERT INTO HtmlLabelInfo VALUES(126047,'删除此菜单将会删除此菜单的所有下级菜单，是否继续?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(126047,'The operation will delete all submenu of this menu,continue?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(126047,'删除此菜單将會删除此菜單的所有下級菜單，是否繼續?',9) 
GO

