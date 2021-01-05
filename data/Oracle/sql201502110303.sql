CREATE OR REPLACE PROCEDURE HrmResourceContactInfo_Update(id_1              integer,
                                                          locationid_15     integer,
                                                          workroom_16       varchar2,
                                                          telephone_17      varchar2,
                                                          mobile_18         varchar2,
                                                          mobilecall_19     varchar2,
                                                          fax_20            varchar2,
                                                          systemlanguage_21 integer,
                                                          email_22          varchar2,
                                                          mobileshowtype_23 varchar2,
                                                          flag              out integer,
                                                          msg               out varchar2,
                                                          thecursor         IN OUT cursor_define.weavercursor) AS
begin
  UPDATE HrmResource
     SET locationid     = locationid_15,
         workroom       = workroom_16,
         telephone      = telephone_17,
         mobile         = mobile_18,
         mobileshowtype = mobileshowtype_23,
         mobilecall     = mobilecall_19,
         fax            = fax_20,
         email          = email_22,
         systemlanguage = systemlanguage_21
   WHERE id = id_1;
end;
/