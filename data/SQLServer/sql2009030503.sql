alter table hpFieldLength add imgsize varchar(50)
GO
update hpFieldLength set imgsize = '120*108'
GO
alter table imagefile add imgsize varchar(50)
GO
update imagefile set imgsize = '120*108'
GO
