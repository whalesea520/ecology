delete from HtmlLabelIndex where id=34285 
GO
delete from HtmlLabelInfo where indexid=34285 
GO
INSERT INTO HtmlLabelIndex values(34285,'该角色被引用，无法删除') 
GO
INSERT INTO HtmlLabelInfo VALUES(34285,'该角色被引用，无法删除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(34285,'This role is on use，can not delete',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(34285,'該角色被引用，無法删除',9) 
GO
