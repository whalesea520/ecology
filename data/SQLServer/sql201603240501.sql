delete from HtmlLabelIndex where id=127000 
GO
delete from HtmlLabelInfo where indexid=127000 
GO
INSERT INTO HtmlLabelIndex values(127000,'同步后，用户在此门户中的个性化设置会丢失。确定要同步吗？') 
GO
delete from HtmlLabelIndex where id=127001 
GO
delete from HtmlLabelInfo where indexid=127001 
GO
INSERT INTO HtmlLabelIndex values(127001,'更新同步') 
GO
delete from HtmlLabelIndex where id=127002 
GO
delete from HtmlLabelInfo where indexid=127002 
GO
INSERT INTO HtmlLabelIndex values(127002,'完全同步') 
GO
INSERT INTO HtmlLabelInfo VALUES(127002,'完全同步',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127002,'Complete sync',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127002,'完全同步',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(127001,'更新同步',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127001,'Update synch',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127001,'更新同步',9) 
GO
INSERT INTO HtmlLabelInfo VALUES(127000,'同步后，用户在此门户中的个性化设置会丢失。确定要同步吗？',7) 
GO
INSERT INTO HtmlLabelInfo VALUES(127000,'After synchronization, the user''s personalization settings in this portal will be lost. Are you sure you want to sync?',8) 
GO
INSERT INTO HtmlLabelInfo VALUES(127000,'同步後，用戶在此門戶中的個性化設置會丢失。确定要同步嗎？',9) 
GO
