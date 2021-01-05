CREATE OR REPLACE PROCEDURE HrmResourceBasicInfo_Insert(id_1               integer,
                                                        workcode_2         varchar2,
                                                        lastname_3         varchar2,
                                                        sex_5              char,
                                                        resoureimageid_6   integer,
                                                        departmentid_7     integer,
                                                        costcenterid_8     integer,
                                                        jobtitle_9         integer,
                                                        joblevel_10        integer,
                                                        jobactivitydesc_11 varchar2,
                                                        managerid_12       integer,
                                                        assistantid_13     integer,
                                                        status_14          char,
                                                        locationid_15      integer,
                                                        workroom_16        varchar2,
                                                        telephone_17       varchar2,
                                                        mobile_18          varchar2,
                                                        mobilecall_19      varchar2,
                                                        fax_20             varchar2,
                                                        jobcall_21         integer,
                                                        subcompanyid1_22   integer,
                                                        managerstr_23      varchar2,
                                                        accounttype_24     integer,
                                                        belongto_25        integer,
                                                        systemlanguage_26  integer,
                                                        email_27           VARCHAR2,
                                                        dsporder_28        INT,
                                                        mobileshowtype_29  INT,
                                                        flag               out integer,
                                                        msg                out varchar2,
                                                        thecursor          IN OUT cursor_define.weavercursor) AS
BEGIN
  INSERT INTO HrmResource
    (id,
     workcode,
     lastname,
     sex,
     resourceimageid,
     departmentid,
     costcenterid,
     jobtitle,
     joblevel,
     jobactivitydesc,
     managerid,
     assistantid,
     status,
     locationid,
     workroom,
     telephone,
     mobile,
     mobilecall,
     fax,
     jobcall,
     seclevel,
     subcompanyid1,
     managerstr,
     dsporder,
     accounttype,
     belongto,
     systemlanguage,
     email ,
     mobileshowtype )
  VALUES
    (id_1,
     workcode_2,
     lastname_3,
     sex_5,
     resoureimageid_6,
     departmentid_7,
     costcenterid_8,
     jobtitle_9,
     joblevel_10,
     jobactivitydesc_11,
     managerid_12,
     assistantid_13,
     status_14,
     locationid_15,
     workroom_16,
     telephone_17,
     mobile_18,
     mobilecall_19,
     fax_20,
     jobcall_21,
     0,
     subcompanyid1_22,
     managerstr_23,
     dsporder_28,
     accounttype_24,
     belongto_25,
     systemlanguage_26,
     email_27,
     mobileshowtype_29);
end;
/
CREATE OR REPLACE PROCEDURE HrmResourceBasicInfo_Update(id_1               integer,
                                                        workcode_2         varchar2,
                                                        lastname_3         varchar2,
                                                        sex_5              char,
                                                        resoureimageid_6   integer,
                                                        departmentid_7     integer,
                                                        costcenterid_8     integer,
                                                        jobtitle_9         integer,
                                                        joblevel_10        integer,
                                                        jobactivitydesc_11 varchar2,
                                                        managerid_12       integer,
                                                        assistantid_13     integer,
                                                        status_14          char,
                                                        locationid_15      integer,
                                                        workroom_16        varchar2,
                                                        telephone_17       varchar2,
                                                        mobile_18          varchar2,
                                                        mobilecall_19      varchar2,
                                                        fax_20             varchar2,
                                                        jobcall_21         integer,
                                                        systemlanguage_22  integer,
                                                        accounttype_23     integer,
                                                        belongto_24        integer,
                                                        email_25           VARCHAR,
                                                        dsporder_26        FLOAT,
                                                        mobileshowtype_27  INT,
                                                        flag               out integer,
                                                        msg                out varchar2,
                                                        thecursor          IN OUT cursor_define.weavercursor) AS
begin
  UPDATE HrmResource_Trigger
     SET departmentid = departmentid_7, managerid = managerid_12
   WHERE id = id_1;
  UPDATE HrmResource
     SET workcode        = workcode_2,
         lastname        = lastname_3,
         sex             = sex_5,
         resourceimageid = resoureimageid_6,
         departmentid    = departmentid_7,
         costcenterid    = costcenterid_8,
         jobtitle        = jobtitle_9,
         joblevel        = joblevel_10,
         jobactivitydesc = jobactivitydesc_11,
         managerid       = managerid_12,
         assistantid     = assistantid_13,
         status          = status_14,
         locationid      = locationid_15,
         workroom        = workroom_16,
         telephone       = telephone_17,
         mobile          = mobile_18,
         mobilecall      = mobilecall_19,
         fax             = fax_20,
         jobcall         = jobcall_21,
         systemlanguage  = systemlanguage_22,
         accounttype     = accounttype_23,
         belongto        = belongto_24,
         email           = email_25 ,
         dsporder        = dsporder_26 ,
         mobileshowtype  = mobileshowtype_27
   WHERE id = id_1;
  UPDATE CRM_CustomerInfo
     SET department = departmentid_7
   WHERE manager = id_1;
end;
/
CREATE OR REPLACE PROCEDURE HrmCompanyVirtual_Select(
                                           flag         out integer,
                                           msg          out varchar2,
                                           thecursor    IN OUT cursor_define.weavercursor) AS
begin
      open thecursor for
         SELECT  * FROM   HrmCompanyVirtual ORDER BY id desc;
end;
/
CREATE OR REPLACE PROCEDURE HrmDepartmentVirtual_Select(
                                           flag         out integer,
                                           msg          out varchar2,
                                           thecursor    IN OUT cursor_define.weavercursor) AS
begin
      open thecursor for
         SELECT  * FROM   HrmDepartmentVirtual ORDER BY showorder ASC, id desc;
end;
/
CREATE OR REPLACE PROCEDURE HrmSubCompanyVirtual_Select(
                                           flag         out integer,
                                           msg          out varchar2,
                                           thecursor    IN OUT cursor_define.weavercursor) AS
begin
      open thecursor for
         SELECT  * FROM   HrmSubCompanyVirtual ORDER BY showorder ASC, id desc;
end;
/
