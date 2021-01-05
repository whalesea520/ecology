alter TRIGGER Tri_Update_HrmMessager ON HrmResource
FOR UPDATE
AS
DECLARE 
        @id_1 	    	int,
        @newloginid    	varchar(100),
		@oldloginid    	varchar(100),
        @groupname  	int,
        @groupcount 	int
begin
	SELECT @newloginid = loginid FROM inserted
    SELECT @oldloginid = loginid FROM deleted
    /*插入时 idinsert >0 AND iddelete is null */
    /*删除时 idinsert is null */
    /*更新时 idinsert >0 AND iddelete > 0 */

    /*插入*/
    IF ((@oldloginid = '' or @oldloginid is null) and  (@newloginid <> '' or @newloginid is not null)) BEGIN
        select @groupcount = count(0) from HrmMessagerGroupUsers where userloginid = @newloginid
        select @groupname = groupname from HrmMessagerGroup
        
        if (@id_1 > 0 and @groupname > 0 and @groupcount = 0) begin
        	insert into HrmMessagerGroupUsers(userloginid,groupname,isadmin) values(@newloginid,@groupname,'N')
        end
    END

    /*删除*/
    IF ((@newloginid = '' or @newloginid is null) and  (@oldloginid <> '' or @oldloginid is not null)) BEGIN

       DELETE FROM HrmMessagerGroupUsers WHERE userloginid = @oldloginid
    END
end

GO
