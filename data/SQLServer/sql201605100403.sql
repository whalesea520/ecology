ALTER TABLE MailConfigureInfo ADD autoreceive INT
go
ALTER TABLE MailConfigureInfo ADD timecount INT
go
update MailConfigureInfo set autoreceive=1,timecount=5
GO