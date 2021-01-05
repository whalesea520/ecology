Delete HtmlLabelIndex where id=20827
GO
Delete HtmlLabelInfo where indexid=20827
GO
INSERT INTO HtmlLabelIndex values(20827,'引用此菜单到下级分部') 
GO
INSERT INTO HtmlLabelInfo VALUES(20827,'引用此菜单到下级分部',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20827,'refer to this menu to next subcompany',8) 
GO

Delete HtmlLabelIndex where id=20830
GO
Delete HtmlLabelInfo where indexid=20830
GO
INSERT INTO HtmlLabelIndex values(20830,'删除此菜单将会删除所有下级分部的此菜单，是否继续?') 
GO
INSERT INTO HtmlLabelInfo VALUES(20830,'删除此菜单将会删除所有下级分部的此菜单，是否继续?',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(20830,'It''ll delete all subcompany''s this menu if you delete this menu!',8) 
GO