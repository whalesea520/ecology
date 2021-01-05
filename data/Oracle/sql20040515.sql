CREATE or replace PROCEDURE HrmResourceSystemInfo_Insert
(id_1 integer,
 loginid_2 varchar2,
 password_3 varchar2,
 systemlanguage_4 integer,
 seclevel_5 integer,
 email_6 varchar2,
 flag	out integer,
   msg out varchar2,
   thecursor IN OUT cursor_define.weavercursor)
AS 
    count_1 integer;
begin
if loginid_2 is not null and loginid_2 != 'sysadmin'
then
    select count(id)  into count_1 from HrmResource where id != id_1 and loginid = loginid_2;
end if;
if ( count_1 is not null and count_1 > 0 ) or loginid_2 = 'sysadmin'
then
open thecursor for
    select 0 from dual;
else 
    
    UPDATE HrmResource_Trigger SET
        seclevel = seclevel_5
        WHERE id = id_1;

    if password_3 = '0' 
    then
        UPDATE HrmResource SET
        loginid = loginid_2,
        systemlanguage = systemlanguage_4,
        seclevel = seclevel_5,
        email = email_6
        WHERE id = id_1;
    else 
        UPDATE HrmResource SET
        loginid = loginid_2,
        password = password_3,
        systemlanguage = systemlanguage_4,
        seclevel = seclevel_5,
        email = email_6
        WHERE id = id_1;
    end if;
end if;
end;
/
