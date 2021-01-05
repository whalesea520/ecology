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
if loginid_2 is not null and loginid_2 != '' and loginid_2 != 'sysadmin'
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

CREATE or REPLACE PROCEDURE HrmResourceBasicInfo_Update
(id_1 integer, 
 workcode_2 varchar2, 
 lastname_3 varchar2, 
 sex_5 char, 
 resoureimageid_6 integer, 
 departmentid_7 integer, 
 costcenterid_8 integer, 
 jobtitle_9 integer, 
 joblevel_10 integer,
 jobactivitydesc_11 varchar2, 
 managerid_12 integer, 
 assistantid_13 integer, 
 status_14 char,
 locationid_15 integer, 
 workroom_16 varchar2, 
 telephone_17 varchar2, 
 mobile_18 varchar2,
 mobilecall_19 varchar2 , 
 fax_20 varchar2, 
 jobcall_21 integer,
 systemlanguage_22 integer,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
 AS
 begin

 UPDATE HrmResource_Trigger SET
        departmentid =   departmentid_7, 
         managerid =   managerid_12
        WHERE id = id_1;

 UPDATE HrmResource SET
 workcode =   workcode_2,
 lastname =  lastname_3,
 sex =   sex_5, 
 resourceimageid =   resoureimageid_6, 
 departmentid =   departmentid_7, 
 costcenterid =   costcenterid_8, 
 jobtitle =   jobtitle_9, 
 joblevel =   joblevel_10, 
 jobactivitydesc =   jobactivitydesc_11, 
 managerid =   managerid_12, 
 assistantid =   assistantid_13, 
 status =   status_14, 
 locationid =   locationid_15,
 workroom =   workroom_16, 
 telephone =   telephone_17, 
 mobile =   mobile_18, 
 mobilecall =   mobilecall_19, 
 fax =   fax_20,
 jobcall = jobcall_21,
 systemlanguage = systemlanguage_22
 WHERE
 id =  id_1; 
 end;
/

CREATE or REPLACE PROCEDURE HrmResource_UpdateManagerStr
(id_1 integer,
 managerstr_2 varchar2,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
AS 
begin
UPDATE HrmResource_Trigger SET
  managerstr = managerstr_2
WHERE
  id = id_1;

UPDATE HrmResource SET
  managerstr = managerstr_2
WHERE
  id = id_1;
end;
/

CREATE or REPLACE PROCEDURE HrmResource_UpdateSubCom
	(id_1 integer,
	subcompanyid1_2 integer,
	flag out integer  , 
	msg  out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)
as
begin
UPDATE HrmResource_Trigger SET
  subcompanyid1 = subcompanyid1_2
WHERE
  id = id_1;

update HrmResource set
  subcompanyid1 = subcompanyid1_2
where
  id = id_1;
end;
/

