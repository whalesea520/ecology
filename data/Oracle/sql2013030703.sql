delete from ofProperty where name = 'xmpp.client.roster.active'
/
insert into ofproperty (name,propValue) values ('xmpp.client.roster.active','false')
/
delete from hrmMessagerGroupUsers
/
DROP TRIGGER TRI_UPDATE_HRMMESSAGER
/
insert into ofProperty(name,propValue) values('xmpp.offline.quota','5242880')
/
create table ofLastfrom
(
	username  VARCHAR2(60),
	lastfrom VARCHAR2(60)
)
/