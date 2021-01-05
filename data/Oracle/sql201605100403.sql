ALTER TABLE MailConfigureInfo ADD autoreceive INTEGER
/
ALTER TABLE MailConfigureInfo ADD timecount INTEGER
/
update MailConfigureInfo set autoreceive=1,timecount=5
/