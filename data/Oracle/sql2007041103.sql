alter table HrmOtherSettings add needdynapass int
/
alter table HrmOtherSettings add dynapasslen int
/
update  HrmOtherSettings set needdynapass=0,dynapasslen=6
/
create table hrmpassword(id int,loginid varchar2(20),password varchar2(60))
/
INSERT INTO HtmlLabelIndex values(20286,'使用动态密码')
/
INSERT INTO HtmlLabelInfo VALUES(20286,'使用动态密码',7)
/
INSERT INTO HtmlLabelInfo VALUES(20286,'Use Dynamic Password',8)
/
alter table hrmresource add needdynapass int
/

CREATE OR REPLACE PROCEDURE HrmResourceSystemInfo_Insert
(id_1 integer,
loginid_2 varchar2,
password_3 varchar2,
systemlanguage_4 integer,
seclevel_5 integer,
email_6 varchar2,
needusb1 integer,
serial1 char,
account_2 varchar2,
lloginid_2 varchar2,
needdynapass_2 integer,
flag out integer,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
count_1 integer;
oldpass varchar2(60);
chgpasswddate char(10);

begin
	if loginid_2 is null or loginid_2 = '' then
		UPDATE HrmResource SET loginid ='',lloginid='',account='', systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6 WHERE id = id_1;
	else
		select password into oldpass from HrmResource where id=id_1;
		if (oldpass is null and password_3!='0' ) or oldpass!=password_3 then
			chgpasswddate:=to_char(sysdate,'yyyy-mm-dd');
		end if;
		if loginid_2 is not null and loginid_2 != 'sysadmin' then
			select count(id)  into count_1 from HrmResource where id != id_1 and loginid = loginid_2;
		end if;
		if ( count_1 is not null and count_1 > 0 ) or loginid_2 = 'sysadmin' then
			open thecursor for
			select 0 from dual;
	    else
			UPDATE HrmResource_Trigger SET seclevel = seclevel_5 WHERE id = id_1;
			if password_3 = '0' then
				if serial1='0' then
					UPDATE HrmResource SET loginid = loginid_2, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2 WHERE id = id_1;
				else
					UPDATE HrmResource SET loginid = loginid_2, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,serial=serial1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2  WHERE id = id_1;
				end if;
			else
				if serial1='0' then
					UPDATE HrmResource SET loginid = loginid_2, password = password_3, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2  WHERE id = id_1;
				else
					UPDATE HrmResource SET loginid = loginid_2, password = password_3, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,serial=serial1,account= account_2,lloginid=lloginid_2,needdynapass=needdynapass_2  WHERE id = id_1;
				end if;
			end if;
		end if;
	end if;
end;
/
