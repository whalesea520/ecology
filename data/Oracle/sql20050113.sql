create table HrmOtherSettings(
remindperiod char(4),
valid char(1)
)
/
insert into HrmOtherSettings(remindperiod,valid) values('30','1')
/
alter table HrmResource add passwdchgdate char(10)
/

insert into SystemRights (id,rightdesc,righttype) values (454,'hrm其他设置维护','3') 
/

insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (454,7,'hrm其他设置维护','hrm其他设置维护') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (454,8,'','') 
/

insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (3145,'hrm其他设置编辑','OtherSettings:Edit',454)
/

insert into SystemRightToGroup (groupid,rightid) values (3,454)
/

insert into SystemRightRoles (rightid,roleid,rolelevel) values (454,4,'2')
/

INSERT INTO HtmlLabelIndex values(17563,'hrm其他设置') 
/
INSERT INTO HtmlLabelInfo VALUES(17563,'其他设置',7) 
/
INSERT INTO HtmlLabelInfo VALUES(17563,'',8) 
/




CREATE OR REPLACE PROCEDURE HrmResourceSystemInfo_Insert (id_1 integer, loginid_2 varchar2, password_3 varchar2, systemlanguage_4 integer, seclevel_5 integer, email_6 varchar2, flag	out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS count_1 integer;oldpass varchar(60);chgpasswddate char(10); begin select password into oldpass from HrmResource where id=id_1;if (oldpass is null and password_3!='0' ) or oldpass!=password_3 then chgpasswddate:=to_char(sysdate,'yyyy-mm-dd');end if;if loginid_2 is not null and loginid_2 != 'sysadmin' then select count(id)  into count_1 from HrmResource where id != id_1 and loginid = loginid_2; end if; if ( count_1 is not null and count_1 > 0 ) or loginid_2 = 'sysadmin' then open thecursor for select 0 from dual; else  UPDATE HrmResource_Trigger SET seclevel = seclevel_5 WHERE id = id_1;  if password_3 = '0' then UPDATE HrmResource SET loginid = loginid_2, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate WHERE id = id_1; else UPDATE HrmResource SET loginid = loginid_2, password = password_3, systemlanguage = systemlanguage_4, seclevel = seclevel_5, email = email_6,passwdchgdate =chgpasswddate WHERE id = id_1; end if; end if; end;
/


CREATE OR REPLACE PROCEDURE HrmResource_UpdatePassword (id_1 	integer, passwordold_2     varchar2, passwordnew_3     varchar2, flag	out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) AS count_1 integer ; begin  if id_1 != 1 then select count(password) into count_1 from HrmResource where id=id_1 and password = passwordold_2; update HrmResource set password = passwordnew_3,passwdchgdate=to_char(sysdate,'yyyy-mm-dd') where id=id_1 and password = passwordold_2; else select count(password) into count_1 from HrmResourceManager where id=id_1 and password = passwordold_2; update HrmResourceManager set password = passwordnew_3 where id=id_1 and password = passwordold_2; end if; if count_1 > 0 then open thecursor for select 1 from dual; return ; else open thecursor for select 2 from dual; return ; end if; end;
/

update HrmResource set passwdchgdate=to_char(sysdate,'yyyy-mm-dd') where loginid is not null and password is not null
/