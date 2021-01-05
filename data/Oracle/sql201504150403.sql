CREATE OR REPLACE PROCEDURE HrmCheckPost_Insert ( checktypeid_2 integer, jobid_3 integer,  deptid_4 integer,  subcid_5 integer, flag out integer  , msg  out varchar2, thecursor IN OUT cursor_define.weavercursor ) AS begin insert into HrmCheckPost (checktypeid,jobid,deptid,subcid) values (checktypeid_2,jobid_3,deptid_4,subcid_5); end;
/
CREATE OR REPLACE PROCEDURE HrmEducationInfo_Update (id_1   integer, resourceid_2   integer, startdate_3   char, enddate_4   char, school_5   varchar2, speciality_6   varchar2, educationlevel_7   char, studydesc_8   varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as begin update HrmEducationInfo  SET  resourceid=resourceid_2, startdate=startdate_3, enddate=enddate_4, school=school_5, speciality=speciality_6, educationlevel=educationlevel_7, studydesc=studydesc_8 WHERE ( id=id_1); end;
/
CREATE OR REPLACE PROCEDURE HrmFamilyInfo_Update (id_1   integer, resourceid_2   integer, member_3   varchar2, title_4   varchar2, company_5   varchar2, jobtitle_6   varchar2, address_7   varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as begin update HrmFamilyInfo  SET  resourceid=resourceid_2, member=member_3, title=title_4, company=company_5, jobtitle=jobtitle_6, address=address_7  WHERE ( id=id_1); end;
/
CREATE OR REPLACE PROCEDURE HrmLanguageAbility_Update (id_1   integer, resourceid_2   integer, language_3   varchar2, thelevel_4   char, memo_5   varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor)  as begin update HrmLanguageAbility SET  resourceid=resourceid_2, language=language_3, level_n=thelevel_4, memo=memo_5  WHERE ( id=id_1); end;
/
DROP PROCEDURE HrmResourceComponent_Insert
/
DROP PROCEDURE HrmResourceComponent_Update
/
DROP PROCEDURE HrmSalaryPersonality_Insert
/
DROP PROCEDURE HrmSalaryPersonality_Update
/
DROP PROCEDURE HrmSalaryRank_Update
/
DROP PROCEDURE HrmSalaryRate_Delete
/
DROP PROCEDURE HrmSalaryRate_Insert
/
DROP PROCEDURE HrmSalaryRate_SelectAll
/
DROP PROCEDURE HrmSalaryRate_SelectByID
/
DROP PROCEDURE HrmSalaryRate_Update
/
DROP PROCEDURE HrmSalaryResult_delete
/
DROP PROCEDURE HrmSalaryResult_Insert
/
DROP PROCEDURE HrmSalaryResult_SByHrmid
/
DROP PROCEDURE HrmSalaryResult_SByid
/
DROP PROCEDURE HrmSalaryResult_send
/
DROP PROCEDURE HrmSalaryResult_Update
/
CREATE OR REPLACE PROCEDURE HrmTrainRecord_Update (id_1   integer, resourceid_3   integer, trainstartdate_4   char, trainenddate_2   char, traintype_5   integer, trainrecord_6   varchar2, trainhour_1    decimal, trainunit_1    varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as begin update HrmTrainRecord  SET resourceid=resourceid_3, trainstartdate=trainstartdate_4, trainenddate=trainenddate_2, traintype=traintype_5, trainrecord=trainrecord_6, trainhour= trainhour_1, trainunit= trainunit_1 WHERE ( id=id_1); end;
/
CREATE OR REPLACE PROCEDURE HrmWorkResume_Update (id_1   integer, resourceid_2   integer, startdate_3   char, enddate_4   char, company_5   varchar2, companystyle_6   integer, jobtitle_7   varchar2, workdesc_8   varchar2, leavereason_9   varchar2, flag out integer, msg out varchar2, thecursor IN OUT cursor_define.weavercursor) as begin update HrmWorkResume  SET  resourceid=resourceid_2, startdate=startdate_3, enddate=enddate_4, company=company_5, companystyle=companystyle_6, jobtitle=jobtitle_7, workdesc=workdesc_8, leavereason=leavereason_9  WHERE ( id=id_1); end;
/