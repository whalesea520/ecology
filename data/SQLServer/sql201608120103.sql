create table social_broadcast(
	id int IDENTITY,
  	plaintext text,
  	msgid varchar(50),
  	fromUserId int,
  	sendtime varchar(20),
  	requestobjs varchar(1000),
  	extra varchar(500)
)
GO
create table social_broadcastreceiver(
	id int IDENTITY,
  	msgid varchar(50),
  	receiverId int
)
GO
create index social_fromUserId_index on social_broadcast(fromUserId)
GO
create index social_bcreceiverId_index on social_broadcastreceiver(receiverId)
GO