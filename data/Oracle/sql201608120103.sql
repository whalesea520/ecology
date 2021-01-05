create table social_broadcast(
	id int primary key,
  	plaintext clob,
  	msgid varchar2(50),
  	fromUserId int,
  	sendtime varchar2(20),
  	requestobjs varchar2(1000),
  	extra varchar2(500)
)
/
create table social_broadcastreceiver(
	id int primary key,
  	msgid varchar2(50),
  	receiverId int
)
/
create sequence social_broadcast_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/
create or replace trigger social_broadcast_trigger 
before insert on social_broadcast
for each row 
begin 
	select social_broadcast_seq.nextval into:new.id from sys.dual;
end;
/
create sequence social_broadcast_rev_seq 
start with 1 
increment by 1 
nomaxvalue 
nocycle
/
create or replace trigger social_broadcast_rev_trigger 
before insert on social_broadcastreceiver
for each row 
begin 
	select social_broadcast_rev_seq.nextval into:new.id from sys.dual;
end;
/
create index social_fromUserId_index on social_broadcast(fromUserId)
/
create index social_bcreceiverId_index on social_broadcastreceiver(receiverId)
/