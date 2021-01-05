CREATE OR REPLACE  PROCEDURE HrmResource_UpdatePassword
(id_1 	integer,
passwordold_2  varchar2,
passwordnew_3  varchar2,
flag	out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
rowcountsum integer;
count_1  integer;
count_2 integer;

begin
	rowcountsum := 0;
	update HrmResource set password = passwordnew_3,passwdchgdate = to_char(sysdate,'yyyy-mm-dd')
		  where id=id_1 and password = passwordold_2;
	select count(password) into count_1 from HrmResource where id=id_1 and password = passwordnew_3;

	if count_1 >0 then 
	rowcountsum := 1;
	end if;

	update HrmResourceManager set password = passwordnew_3 where id=id_1 and password = passwordold_2;
	select count(password) into count_2 from HrmResourceManager where id=id_1 and password = passwordnew_3;

	if count_2 >0 then 
	rowcountsum := 1;
	end if;

	if rowcountsum =1 then
	open thecursor for
	select 1 from dual;
	return;
	else
	open thecursor for
	select 2 from dual;
	return;
	end if;
end;
/