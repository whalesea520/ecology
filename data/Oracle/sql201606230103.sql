create or replace trigger SocialHistoryMsgRight_trigger 
before insert on Social_historyMsgRight 
for each row 
begin 
	select SocialHistoryMsgRight_seq.nextval into:new.id from sys.dual;
end;
/

create or replace trigger SocialIMSysBroadcast_trigger 
before insert on Social_IMSysBroadcast
for each row 
begin 
	select SocialIMSysBroadcast_seq.nextval into:new.id from sys.dual;
end;
/