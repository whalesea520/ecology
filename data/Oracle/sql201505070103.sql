CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermission(dirid_1         integer,
                                                       dirtype_1       integer,
                                                       userid_1        integer,
                                                       usertype_1      integer,
                                                       seclevel_1      integer,
                                                       operationcode_1 integer,
                                                       departmentid_1  varchar2,
                                                       subcompanyid_1  varchar2,
                                                       roleid_1        varchar2,
                                                       flag            out integer,
                                                       msg             out varchar2,
                                                       thecursor       IN OUT cursor_define.weavercursor) AS
  count_1   integer;
  result    integer;
  count_num integer;
begin
  result := 0;
  if usertype_1 = 0 then
    select count(sourceid)
      into count_num
      from DirAccessControlDetail
     where sourceid = dirid_1
       and sourcetype = dirtype_1
       and sharelevel = operationcode_1
       and ((type = 1 and content in
           (select * from TABLE(CAST(SplitStr(departmentid_1, ',') AS mytable))) and
           seclevel <= seclevel_1) or
           (type = 2 and
           content in
           (select * from TABLE(CAST(SplitStr(roleid_1, ',') AS mytable))) and
           seclevel <= seclevel_1) or
           (type = 3 and seclevel <= seclevel_1) or
           (type = 4 and content = usertype_1 and seclevel <= seclevel_1) or
           (type = 5 and content = userid_1) or
           (type = 6 and content in (select * from TABLE(CAST(SplitStr(subcompanyid_1, ',') AS mytable))) and
           seclevel <= seclevel_1));
    if (count_num > 0) then
      count_1 := 1;
    else
      count_1 := 0;
    end if;
  else
    select count(mainid)
      into count_1
      from DirAccessControlList
     where dirid = dirid_1
       and dirtype = dirtype_1
       and operationcode = operationcode_1
       and ((permissiontype = 3 and seclevel <= seclevel_1) or
           (permissiontype = 4 and usertype = usertype_1 and
           seclevel <= seclevel_1));
  end if;
  if (count_1 > 0) then
    result := 1;
  end if;
  open thecursor for
    select result result from dual;
end;
/

CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx(dirid_1         integer,
                                                         dirtype_1       integer,
                                                         userid_1        integer,
                                                         usertype_1      integer,
                                                         seclevel_1      integer,
                                                         operationcode_1 integer,
                                                         departmentid_1  varchar2,
                                                         subcompanyid_1  varchar2,
                                                         roleid_1        varchar2,
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
                                roleid_1,
                                result_1);
  if result_1 <> 1 then
    if dirtype_1 = 1 then
      select subcategoryid
        into fatherid_1
        from DocSubCategory
       where id = dirid_1;
    elsif dirtype_1 = 2 then
      select subcategoryid
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
      select maincategoryid
        into mainid_1
        from DocSubCategory
       where id = dirid_1;
      Doc_DirAcl_CheckPermissionEx1(mainid_1,
                                    0,
                                    userid_1,
                                    usertype_1,
                                    seclevel_1,
                                    operationcode_1,
                                    departmentid_1,
                                    subcompanyid_1,
                                    roleid_1,
                                    result_1);
      if result_1 = 1 then
        fatherid_1 := -1;
      end if;
    elsif dirtype_1 = 2 and fatherid_1 <> -1 then
      select maincategoryid
        into mainid_1
        from DocSubCategory
       where id = fatherid_1;
      Doc_DirAcl_CheckPermissionEx1(mainid_1,
                                    0,
                                    userid_1,
                                    usertype_1,
                                    seclevel_1,
                                    operationcode_1,
                                    departmentid_1,
                                    subcompanyid_1,
                                    roleid_1,
                                    result_1);
      if result_1 = 1 then
        fatherid_1 := -1;
      end if;
      while fatherid_1 <> -1 loop
        Doc_DirAcl_CheckPermissionEx1(fatherid_1,
                                      1,
                                      userid_1,
                                      usertype_1,
                                      seclevel_1,
                                      operationcode_1,
                                      departmentid_1,
                                      subcompanyid_1,
                                      roleid_1,
                                      result_1);
        if result_1 <> 1 then
          select subcategoryid
            into fatherid1_1
            from DocSubCategory
           where id = fatherid_1;
          fatherid_1 := fatherid1_1;
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

CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx1(dirid_1         integer,
                                                          dirtype_1       integer,
                                                          userid_1        integer,
                                                          usertype_1      integer,
                                                          seclevel_1      integer,
                                                          operationcode_1 integer,
                                                          departmentid_1  varchar2,
                                                          subcompanyid_1  varchar2,
                                                          roleid_1        varchar2,
                                                          haspermission_1 in out integer) AS
  count_1 integer;
  result  integer;
begin
  result := 0;
  if usertype_1 = 0 then
    select count(sourceid)
      into count_1
      from DirAccessControlDetail
     where sharelevel = operationcode_1
       and sourceid = dirid_1
       and sourcetype = dirtype_1
       and ((type = 1 and content in (select * from TABLE(CAST(SplitStr(departmentid_1, ',') AS mytable)))  and
           seclevel <= seclevel_1) or
           (type = 2 and
           content in
           (select * from TABLE(CAST(SplitStr(roleid_1, ',') AS mytable))) and
           seclevel <= seclevel_1) or
           (type = 3 and seclevel <= seclevel_1) or
           (type = 4 and content = usertype_1 and seclevel <= seclevel_1) or
           (type = 5 and content = userid_1) or
           (type = 6 and content in (select * from TABLE(CAST(SplitStr(subcompanyid_1, ',') AS mytable))) and
           seclevel <= seclevel_1));
  else
    select count(mainid)
      into count_1
      from DirAccessControlList
     where dirid = dirid_1
       and dirtype = dirtype_1
       and operationcode = operationcode_1
       and ((permissiontype = 3 and seclevel <= seclevel_1) or
           (permissiontype = 4 and usertype = usertype_1 and
           seclevel <= seclevel_1));
  end if;
  if count_1 is not null and count_1 > 0 then
    result := 1;
  end if;
  haspermission_1 := result;
end;
/

CREATE OR REPLACE PROCEDURE Doc_DirAcl_CheckPermissionEx2(dirid_1         integer,
                                                          dirtype_1       integer,
                                                          userid_1        integer,
                                                          usertype_1      integer,
                                                          seclevel_1      integer,
                                                          operationcode_1 integer,
                                                          departmentid_1  varchar2,
                                                          subcompanyid_1  varchar2,
                                                          roleid_1        varchar2,
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
                                roleid_1,
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
                                    roleid_1,
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
                                    roleid_1,
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
                                      roleid_1,
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
