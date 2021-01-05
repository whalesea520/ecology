UPDATE hrm_formfield SET type=2 WHERE fieldid IN (47,48,49,50)
/
alter table HrmUserDefine
add virtualdepartment char
/
CREATE OR REPLACE PROCEDURE HrmUserDefine_Insert(userid_1                 integer,
                                                 hasresourceid_2          char,
                                                 hasresourcename_3        char,
                                                 hasjobtitle_4            char,
                                                 hasactivitydesc_5        char,
                                                 hasjobgroup_6            char,
                                                 hasjobactivity_7         char,
                                                 hascostcenter_8          char,
                                                 hascompetency_9          char,
                                                 hasresourcetype_10       char,
                                                 hasstatus_11             char,
                                                 hassubcompany_12         char,
                                                 hasdepartment_13         char,
                                                 haslocation_14           char,
                                                 hasmanager_15            char,
                                                 hasassistant_16          char,
                                                 hasroles_17              char,
                                                 hasseclevel_18           char,
                                                 hasjoblevel_19           char,
                                                 hasworkroom_20           char,
                                                 hastelephone_21          char,
                                                 hasstartdate_22          char,
                                                 hasenddate_23            char,
                                                 hascontractdate_24       char,
                                                 hasbirthday_25           char,
                                                 hassex_26                char,
                                                 projectable_27           char,
                                                 crmable_28               char,
                                                 itemable_29              char,
                                                 docable_30               char,
                                                 workflowable_31          char,
                                                 subordinateable_32       char,
                                                 trainable_33             char,
                                                 budgetable_34            char,
                                                 fnatranable_35           char,
                                                 dspperpage_36            smallint,
                                                 hasage_37                char,
                                                 hasworkcode_38           char,
                                                 hasjobcall_39            char,
                                                 hasmobile_40             char,
                                                 hasmobilecall_41         char,
                                                 hasfax_42                char,
                                                 hasemail_43              char,
                                                 hasfolk_44               char,
                                                 hasregresidentplace_45   char,
                                                 hasnativeplace_46        char,
                                                 hascertificatenum_47     char,
                                                 hasmaritalstatus_48      char,
                                                 haspolicy_49             char,
                                                 hasbememberdate_50       char,
                                                 hasbepartydate_51        char,
                                                 hasislabouunion_52       char,
                                                 haseducationlevel_53     char,
                                                 hasdegree_54             char,
                                                 hashealthinfo_55         char,
                                                 hasheight_56             char,
                                                 hasweight_57             char,
                                                 hasresidentplace_58      char,
                                                 hashomeaddress_59        char,
                                                 hastempresidentnumber_60 char,
                                                 hasusekind_61            char,
                                                 hasbankid1_62            char,
                                                 hasaccountid1_63         char,
                                                 hasaccumfundaccount_64   char,
                                                 hasloginid_65            char,
                                                 hassystemlanguage_66     char,
                                                 hasaccounttype_67        char,
                                                 workplanable1_68         char,
                                                 hasvirtualdepartment_69  char,
                                                 flag                     out integer,
                                                 msg                      out varchar2,
                                                 thecursor                IN OUT cursor_define.weavercursor) AS
  recordercount integer;
begin
  Select count(userid)
    INTO recordercount
    from HrmUserDefine
   where userid = to_number(userid_1);
  if recordercount = 0 then
    INSERT INTO HrmUserDefine
      (userid,
       hasresourceid,
       hasresourcename,
       hasjobtitle,
       hasactivitydesc,
       hasjobgroup,
       hasjobactivity,
       hascostcenter,
       hascompetency,
       hasresourcetype,
       hasstatus,
       hassubcompany,
       hasdepartment,
       haslocation,
       hasmanager,
       hasassistant,
       hasroles,
       hasseclevel,
       hasjoblevel,
       hasworkroom,
       hastelephone,
       hasstartdate,
       hasenddate,
       hascontractdate,
       hasbirthday,
       hassex,
       projectable,
       crmable,
       itemable,
       docable,
       workflowable,
       subordinateable,
       trainable,
       budgetable,
       fnatranable,
       dspperpage,
       hasage,
       hasworkcode,
       hasjobcall,
       hasmobile,
       hasmobilecall,
       hasfax,
       hasemail,
       hasfolk,
       hasregresidentplace,
       hasnativeplace,
       hascertificatenum,
       hasmaritalstatus,
       haspolicy,
       hasbememberdate,
       hasbepartydate,
       hasislabouunion,
       haseducationlevel,
       hasdegree,
       hashealthinfo,
       hasheight,
       hasweight,
       hasresidentplace,
       hashomeaddress,
       hastempresidentnumber,
       hasusekind,
       hasbankid1,
       hasaccountid1,
       hasaccumfundaccount,
       hasloginid,
       hassystemlanguage,
       hasaccounttype,
       workplanable,
       virtualdepartment)
    VALUES
      (userid_1,
       hasresourceid_2,
       hasresourcename_3,
       hasjobtitle_4,
       hasactivitydesc_5,
       hasjobgroup_6,
       hasjobactivity_7,
       hascostcenter_8,
       hascompetency_9,
       hasresourcetype_10,
       hasstatus_11,
       hassubcompany_12,
       hasdepartment_13,
       haslocation_14,
       hasmanager_15,
       hasassistant_16,
       hasroles_17,
       hasseclevel_18,
       hasjoblevel_19,
       hasworkroom_20,
       hastelephone_21,
       hasstartdate_22,
       hasenddate_23,
       hascontractdate_24,
       hasbirthday_25,
       hassex_26,
       projectable_27,
       crmable_28,
       itemable_29,
       docable_30,
       workflowable_31,
       subordinateable_32,
       trainable_33,
       budgetable_34,
       fnatranable_35,
       dspperpage_36,
       hasage_37,
       hasworkcode_38,
       hasjobcall_39,
       hasmobile_40,
       hasmobilecall_41,
       hasfax_42,
       hasemail_43,
       hasfolk_44,
       hasregresidentplace_45,
       hasnativeplace_46,
       hascertificatenum_47,
       hasmaritalstatus_48,
       haspolicy_49,
       hasbememberdate_50,
       hasbepartydate_51,
       hasislabouunion_52,
       haseducationlevel_53,
       hasdegree_54,
       hashealthinfo_55,
       hasheight_56,
       hasweight_57,
       hasresidentplace_58,
       hashomeaddress_59,
       hastempresidentnumber_60,
       hasusekind_61,
       hasbankid1_62,
       hasaccountid1_63,
       hasaccumfundaccount_64,
       hasloginid_65,
       hassystemlanguage_66,
       hasaccounttype_67,
       workplanable1_68,
       hasvirtualdepartment_69);
  else
    UPDATE HrmUserDefine
       SET hasresourceid         = hasresourceid_2,
           hasresourcename       = hasresourcename_3,
           hasjobtitle           = hasjobtitle_4,
           hasactivitydesc       = hasactivitydesc_5,
           hasjobgroup           = hasjobgroup_6,
           hasjobactivity        = hasjobactivity_7,
           hascostcenter         = hascostcenter_8,
           hascompetency         = hascompetency_9,
           hasresourcetype       = hasresourcetype_10,
           hasstatus             = hasstatus_11,
           hassubcompany         = hassubcompany_12,
           hasdepartment         = hasdepartment_13,
           haslocation           = haslocation_14,
           hasmanager            = hasmanager_15,
           hasassistant          = hasassistant_16,
           hasroles              = hasroles_17,
           hasseclevel           = hasseclevel_18,
           hasjoblevel           = hasjoblevel_19,
           hasworkroom           = hasworkroom_20,
           hastelephone          = hastelephone_21,
           hasstartdate          = hasstartdate_22,
           hasenddate            = hasenddate_23,
           hascontractdate       = hascontractdate_24,
           hasbirthday           = hasbirthday_25,
           hassex                = hassex_26,
           projectable           = projectable_27,
           crmable               = crmable_28,
           itemable              = itemable_29,
           docable               = docable_30,
           workflowable          = workflowable_31,
           subordinateable       = subordinateable_32,
           trainable             = trainable_33,
           budgetable            = budgetable_34,
           fnatranable           = fnatranable_35,
           dspperpage            = dspperpage_36,
           hasage                = hasage_37,
           hasworkcode           = hasworkcode_38,
           hasjobcall            = hasjobcall_39,
           hasmobile             = hasmobile_40,
           hasmobilecall         = hasmobilecall_41,
           hasfax                = hasfax_42,
           hasemail              = hasemail_43,
           hasfolk               = hasfolk_44,
           hasregresidentplace   = hasregresidentplace_45,
           hasnativeplace        = hasnativeplace_46,
           hascertificatenum     = hascertificatenum_47,
           hasmaritalstatus      = hasmaritalstatus_48,
           haspolicy             = haspolicy_49,
           hasbememberdate       = hasbememberdate_50,
           hasbepartydate        = hasbepartydate_51,
           hasislabouunion       = hasislabouunion_52,
           haseducationlevel     = haseducationlevel_53,
           hasdegree             = hasdegree_54,
           hashealthinfo         = hashealthinfo_55,
           hasheight             = hasheight_56,
           hasweight             = hasweight_57,
           hasresidentplace      = hasresidentplace_58,
           hashomeaddress        = hashomeaddress_59,
           hastempresidentnumber = hastempresidentnumber_60,
           hasusekind            = hasusekind_61,
           hasbankid1            = hasbankid1_62,
           hasaccountid1         = hasaccountid1_63,
           hasaccumfundaccount   = hasaccumfundaccount_64,
           hasloginid            = hasloginid_65,
           hassystemlanguage     = hassystemlanguage_66,
           hasaccounttype        = hasaccounttype_67,
           workplanable          = workplanable1_68,
           virtualdepartment  = hasvirtualdepartment_69
     WHERE (userid = userid_1);
  end if;
end;
/