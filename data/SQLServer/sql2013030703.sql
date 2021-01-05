delete from ofProperty where name = 'xmpp.client.roster.active'
GO
insert into ofproperty (name,propValue) values ('xmpp.client.roster.active','false')
GO
delete from hrmMessagerGroupUsers
GO
DROP TRIGGER TRI_UPDATE_HRMMESSAGER
GO
insert into ofProperty(name,propValue) values('xmpp.offline.quota','5242880')
GO
create table ofLastfrom
(
	username  varchar(64),
	lastfrom varchar(64)
)
GO