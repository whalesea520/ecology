alter table SystemSet add  mailAutoCloseLeft char(1) default '1'
GO
update SystemSet set mailAutoCloseLeft='1'
GO

alter table SystemSet add  rtxAlert char(1) default '1'
GO
update SystemSet set rtxAlert='1'
GO