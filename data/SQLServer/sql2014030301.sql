delete from SystemLogItem where itemid='156' 
GO
insert into SystemLogItem(itemid,lableid,itemdesc) values('156',32713,'角色网段管理')
GO



delete from HtmlLabelIndex where id=32713 
GO
delete from HtmlLabelInfo where indexid=32713 
GO
INSERT INTO HtmlLabelIndex values(32713,'角色网段管理') 
GO
INSERT INTO HtmlLabelInfo VALUES(32713,'角色网段管理',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32713,'The role of network management',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32713,'角色網段管理',9) 
GO

delete from HtmlLabelIndex where id=32717 
GO
delete from HtmlLabelInfo where indexid=32717 
GO
INSERT INTO HtmlLabelIndex values(32717,'网段') 
GO
INSERT INTO HtmlLabelInfo VALUES(32717,'网段',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32717,'Segment',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32717,'網段',9) 
GO

delete from HtmlLabelIndex where id=32721 
GO
delete from HtmlLabelInfo where indexid=32721 
GO
INSERT INTO HtmlLabelIndex values(32721,'此网段已被角色使用，无法删除') 
GO
INSERT INTO HtmlLabelInfo VALUES(32721,'此网段已被角色使用，无法删除',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(32721,'This network has been the role of use, cannot be deleted',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(32721,'此網段已被角色使用，無法删除',9) 
GO