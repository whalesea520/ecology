CREATE or replace TRIGGER Tri_Update_HrmMessager after update ON HrmResource 
for each row
Declare 
        id_1 	   	  integer;
        oldloginid	      varchar(100);
        newloginid	      varchar(100);
        groupname     integer;
        groupcount    integer;
begin
    oldloginid := :old.loginid;
    newloginid := :new.loginid;
    /*插入时 countinsert >0 AND countdelete is null */
    /*删除时 countinsert is null */
    /*更新时 countinsert >0 AND countdelete > 0 */

    /*插入*/
    IF ((oldloginid = '' or oldloginid is null) and  (newloginid <> '' or newloginid is not null)) then

        select count(0) into groupcount from HrmMessagerGroupUsers where userloginid = newloginid;
        select groupname into groupname from HrmMessagerGroup;
        
        if groupname > 0 and groupcount = 0 then
        	insert into HrmMessagerGroupUsers(userloginid,groupname,isadmin) values(newloginid,groupname,'N');
        end if;
    END if;

    /*删除*/
    IF ((newloginid = '' or newloginid is null) and  (oldloginid <> '' or oldloginid is not null)) then
       DELETE FROM HrmMessagerGroupUsers WHERE userloginid = oldloginid;
    END if;
end;
/
