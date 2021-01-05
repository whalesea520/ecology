ALTER TRIGGER Tri_Update_HrmMessager ON HrmResource
FOR INSERT, UPDATE, DELETE 
AS
DECLARE 
        @newloginid    	varchar(100),
		@oldloginid    	varchar(100),
        @groupname  	int,
        @groupcount 	int
begin
	SELECT @newloginid = lower(loginid) FROM inserted
    SELECT @oldloginid = lower(loginid) FROM deleted
    
    IF ((@newloginid = '' or @newloginid is null) and (@oldloginid <> '' and @oldloginid is not null)) BEGIN
		delete from HrmMessagerGroupUsers where userloginid = @oldloginid
    END
    
    IF (@newloginid <> '' and @newloginid is not null) BEGIN
	    IF (@oldloginid = '' or @oldloginid is null) BEGIN
	        select @groupcount = count(0) from HrmMessagerGroupUsers where userloginid = @newloginid
	        select @groupname = groupname from HrmMessagerGroup
	        if (@groupcount = 0 and (@groupname <> '' and @groupname is not null)) begin
	        	insert into HrmMessagerGroupUsers(userloginid,groupname,isadmin) values(@newloginid,@groupname,'N')
	        end
	    END
	    
	    if ((@oldloginid <> '' and @oldloginid is not null) and (@oldloginid <> @newloginid)) begin
    		select @groupcount = count(0) from HrmMessagerGroupUsers where userloginid = @oldloginid
		    select @groupname = groupname from HrmMessagerGroup
    		if (@groupcount > 0 and (@groupname <> '' and @groupname is not null)) begin
	    		update HrmMessagerGroupUsers set userloginid = @newloginid where userloginid = @oldloginid
		    end
	    end
    END
end

GO