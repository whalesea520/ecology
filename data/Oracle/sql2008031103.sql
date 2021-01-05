delete from SystemlogItem where itemid = '101'
/
insert into SystemLogItem (itemid,lableid,itemdesc) values('101',21384,'Íø¶Î²ßÂÔ')
/

alter table HrmResource add passwordstate INTEGER
/

create table HrmnetworkSegStr
(id INTEGER not null,
 inceptipaddress varchar2(50),
 endipaddress varchar2(50),
 createrid INTEGER,
 createdate char(20) ,
 createtime char(20) ,
 segmentdesc varchar2(60) null
 )
/

create sequence NetWorkS
start with 1
increment by 1
nomaxvalue
nocycle
/

CREATE OR REPLACE TRIGGER HrmnetworkSegStr_Trigger before insert on HrmnetworkSegStr for each row 
begin 
select NetWorkS.nextval into :new.id from dual; 
end; 
/ 

CREATE OR REPLACE procedure  HrmnetworkSegStr_Insert (
inceptipaddress_1 varchar2, 
endipaddress_2 varchar2, 
createrid_3 integer, 
createdate_4 char,
createtime_5 char, 
segmentdesc_6 varchar2,  
flag	out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin 
INSERT INTO HrmnetworkSegStr (inceptipaddress, endipaddress, createrid, createdate, createtime,segmentdesc) VALUES (inceptipaddress_1, endipaddress_2, createrid_3, createdate_4,createtime_5, segmentdesc_6); 
end;
/

CREATE OR REPLACE procedure  HrmnetworkSegStr_Update (
id_1 integer,
inceptipaddress_2 varchar2, 
endipaddress_3 varchar2, 
segmentdesc_7 varchar2,
flag	out integer, 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)  
AS 
begin 
UPDATE HrmnetworkSegStr  SET inceptipaddress= inceptipaddress_2,endipaddress = endipaddress_3,segmentdesc=segmentdesc_7  WHERE ( id = id_1); 
end;
/

CREATE OR REPLACE procedure  HrmnetworkSegStr_Delete (
id_1 	integer,  
flag out integer , 
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor )  
AS 
begin 
DELETE HrmnetworkSegStr  WHERE ( id = id_1); 
end;
/

CREATE OR REPLACE PROCEDURE HrmResourceSystemInfo_Insert
(id_1 integer,
loginid_2 varchar2,
password_3 varchar2,
systemlanguage_4 integer,
seclevel_5 integer,
email_6 varchar2,
needusb1 integer,
serial1 varchar2,
account_2 varchar2,
lloginid_2 varchar2,
needdynapass_2 integer,
passwordstate_2 integer,
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
					UPDATE HrmResource SET loginid = loginid_2, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2,passwordstate=passwordstate_2 WHERE id = id_1;
				else
					UPDATE HrmResource SET loginid = loginid_2, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,serial=serial1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2 ,passwordstate=passwordstate_2 WHERE id = id_1;
				end if;
			else
				if serial1='0' then
					UPDATE HrmResource SET loginid = loginid_2, password = password_3, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,account=account_2,lloginid=lloginid_2,needdynapass=needdynapass_2,passwordstate=passwordstate_2  WHERE id = id_1;
				else
					UPDATE HrmResource SET loginid = loginid_2, password = password_3, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate,needusb=needusb1,serial=serial1,account= account_2,lloginid=lloginid_2,needdynapass=needdynapass_2,passwordstate=passwordstate_2  WHERE id = id_1;
				end if;
			end if;
		end if;
	end if;
end;
/
