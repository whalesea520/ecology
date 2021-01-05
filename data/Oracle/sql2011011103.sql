CREATE or replace TRIGGER Tri_Update_HrmMessager after insert or update or delete ON HrmResource 
for each row
Declare 
        oldloginid	  varchar(100);
        newloginid	  varchar(100);
        groupname     integer;
        groupcount    integer;
begin
    oldloginid := lower(:old.loginid);
    newloginid := lower(:new.loginid);

    IF ((newloginid = '' or newloginid is null) and (oldloginid <> '' or oldloginid is not null)) then
		DELETE FROM HrmMessagerGroupUsers WHERE userloginid = oldloginid;
    end if;
    
    IF (newloginid <> '' or newloginid is not null) then
	    IF (oldloginid = '' or oldloginid is null) then
	        select count(0) into groupcount from HrmMessagerGroupUsers where userloginid = newloginid;
	        select groupname into groupname from HrmMessagerGroup;
	        if (groupcount = 0 and (groupname <> '' or groupname is not null)) then
	        	insert into HrmMessagerGroupUsers(userloginid,groupname,isadmin) values(newloginid,groupname,'N');
	        end if;
	    end if;
	    
	    if ((oldloginid <> '' or oldloginid is not null) and (oldloginid <> newloginid)) then
    		select count(0) into groupcount from HrmMessagerGroupUsers where userloginid = oldloginid;
		    select groupname into groupname from HrmMessagerGroup;
    		if (groupcount > 0 and (groupname <> '' or groupname is not null)) then
	    		UPDATE HrmMessagerGroupUsers set userloginid = newloginid where userloginid = oldloginid;
		    end if;
	    end if;
    end if;
end;
/