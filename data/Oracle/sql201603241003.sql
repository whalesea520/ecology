CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx2(dirid_1         integer,
                                                          dirtype_1       integer,
                                                          userid_1        integer,
                                                          usertype_1      integer,
                                                          seclevel_1      integer,
                                                          operationcode_1 integer,
                                                          departmentid_1  varchar2,
                                                          subcompanyid_1  varchar2,
                subcompanyidsub_1  varchar2,
                      departmentidsub_1  varchar2,
                                                          roleid_1        varchar2,
                              jobids_1      varchar2,
                                                          flag            out integer,
                                                          msg             out varchar2,
                                                          thecursor       IN OUT cursor_define.weavercursor) AS
  result_1    integer;
  mainid_1    integer;
  fatherid_1  integer;
  fatherid1_1 integer;
begin
  Doc_DirAcl_CheckPermissionEx1(dirid_1,
                                dirtype_1,
                                userid_1,
                                usertype_1,
                                seclevel_1,
                                operationcode_1,
                                departmentid_1,
                                subcompanyid_1,
        subcompanyidsub_1,
                                departmentidsub_1,
                                roleid_1,
                jobids_1,
                                result_1);
  if result_1 <> 1 then
    if dirtype_1 = 1 then
      select parentid
        into fatherid_1
        from DocSecCategory
       where id = dirid_1;
    elsif dirtype_1 = 2 then
      select parentid
        into fatherid_1
        from DocSecCategory
       where id = dirid_1;
      if fatherid_1 is null then
        fatherid_1 := -1;
      end if;
      if fatherid_1 = 0 then
        fatherid_1 := -1;
      end if;
    else
      fatherid_1 := -1;
    end if;
    if dirtype_1 = 1 then
      select parentid into mainid_1 from DocSecCategory where id = dirid_1;
      Doc_DirAcl_CheckPermissionEx1(mainid_1,
                                    2,
                                    userid_1,
                                    usertype_1,
                                    seclevel_1,
                                    operationcode_1,
                                    departmentid_1,
                                    subcompanyid_1,
            subcompanyidsub_1,
                                    departmentidsub_1,
                                    roleid_1,
                  jobids_1,
                                    result_1);
      if result_1 = 1 then
        fatherid_1 := -1;
      end if;
    elsif dirtype_1 = 2 and fatherid_1 <> -1 then
      select parentid
        into mainid_1
        from DocSecCategory
       where id = fatherid_1;
      Doc_DirAcl_CheckPermissionEx1(mainid_1,
                                    2,
                                    userid_1,
                                    usertype_1,
                                    seclevel_1,
                                    operationcode_1,
                                    departmentid_1,
                                    subcompanyid_1,
            subcompanyidsub_1,
                                    departmentidsub_1,
                                    roleid_1,
                  jobids_1,
                                    result_1);
      if result_1 = 1 then
        fatherid_1 := -1;
      end if;
      while fatherid_1 <> -1 loop
        Doc_DirAcl_CheckPermissionEx1(fatherid_1,
                                      2,
                                      userid_1,
                                      usertype_1,
                                      seclevel_1,
                                      operationcode_1,
                                      departmentid_1,
                                      subcompanyid_1,
              subcompanyidsub_1,
                                      departmentidsub_1,
                                      roleid_1,
                    jobids_1,
                                      result_1);
        if result_1 <> 1 then
          select parentid
            into fatherid1_1
            from DocSecCategory
           where id = fatherid_1;
          fatherid_1 := fatherid1_1;
          if fatherid_1 is null then
            fatherid_1 := -1;
          end if;
          if fatherid_1 = 0 then
            fatherid_1 := -1;
          end if;
        else
          fatherid_1 := -1;
        end if;
      end loop;
    end if;
  end if;
  open thecursor for
    select result_1 result from dual;
end;
/