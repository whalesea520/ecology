alter table hpFieldLength add imgtype varchar(1) null
GO
alter table hpFieldLength add imgsrc varchar(200) null
GO
update hpFieldLength set imgtype='0'
GO