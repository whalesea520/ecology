alter table HistoryMsg ADD temp ntext
GO
alter table HistoryMsg ADD fullAmount ntext
GO
UPDATE HistoryMsg set temp = msgContent
GO
EXEC sp_rename 'HistoryMsg.msgContent','msgContentBak'
GO
EXEC sp_rename 'HistoryMsg.temp','msgContent'
GO
alter table social_IMConversation add isopenfire int
GO
update social_IMConversation set isopenfire = 0
GO
alter table mobile_rongGroup add isopenfire int
GO
update mobile_rongGroup set isopenfire = 0
GO