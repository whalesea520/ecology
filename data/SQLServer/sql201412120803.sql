delete from ofProperty where name ='xmpp.client.processing.threads'
go
insert into ofProperty(name,propValue) values ('xmpp.client.processing.threads','2000')
go