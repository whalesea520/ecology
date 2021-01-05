CREATE OR REPLACE PROCEDURE HrmResource_DepUpdate(id_1           integer,
                                                  departmentid_2 integer,
                                                  joblevel_3     integer,
                                                  costcenterid_4 integer,
                                                  jobtitle_5     integer,
                                                  newmanagerid_1 integer,
                                                  flag           out integer,
                                                  msg            out varchar2,
                                                  thecursor      IN OUT cursor_define.weavercursor) as
begin
  update HrmResource
     set departmentid = departmentid_2,
         joblevel     = joblevel_3,
         costcenterid = costcenterid_4,
         jobtitle     = jobtitle_5,
         managerid    = newmanagerid_1
   where id = id_1;

   update CRM_CustomerInfo 
      set department  = departmentid_2 
   where manager = id_1;
end;
/
CREATE or REPLACE PROCEDURE HrmResourceBasicInfo_Update
(
 id_1 integer, 
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
 accounttype_23 integer,
 belongto_24 integer,
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
 systemlanguage = systemlanguage_22,
 accounttype = accounttype_23,
 belongto = belongto_24
 WHERE
 id =  id_1;
 UPDATE CRM_CustomerInfo 
   SET department =  departmentid_7 
 WHERE manager = id_1;
 end;
/