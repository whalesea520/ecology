CREATE OR REPLACE PROCEDURE HrmSubCompany_Update(id_1             integer,
                                                 subcompanyname_2 varchar2,
                                                 subcompanydesc_3 varchar2,
                                                 companyid_4      smallint,
                                                 supsubcomid_5    integer,
                                                 url_6            varchar2,
                                                 showorder_7      integer,
                                                 flag             out integer,
                                                 msg              out varchar2,
                                                 thecursor        IN OUT cursor_define.weavercursor) AS
  count0 integer;
  count1 integer;
begin
  select count(*)
    into count0
    from HrmSubCompany
   where subcompanyname = subcompanyname_2
     and id != id_1
     and supsubcomid = supsubcomid_5;
  select count(*)
    into count1
    from HrmSubCompany
   where subcompanydesc = subcompanydesc_3
     and id != id_1
     and supsubcomid = supsubcomid_5;
  if count0 > 0 then
    flag := 2;
    msg  := '该分部简称已经存在，不能保存！';
    return;
  end if;
  if count1 > 0 then
    flag := 3;
    msg  := '该分部全称已经存在，不能保存！';
    return;
  end if;
  UPDATE HrmSubCompany
     SET subcompanyname = subcompanyname_2,
         subcompanydesc = subcompanydesc_3,
         companyid      = companyid_4,
         supsubcomid    = supsubcomid_5,
         url            = url_6,
         showorder      = showorder_7
   WHERE (id = id_1);
end;
/
CREATE OR REPLACE PROCEDURE HrmSubCompany_Insert(subcompanyname_1 varchar2,
                                                 subcompanydesc_2 varchar2,
                                                 companyid_3      smallint,
                                                 supsubcomid_4    integer,
                                                 url_5            varchar2,
                                                 showorder_6      integer,
                                                 flag             out integer,
                                                 msg              out varchar2,
                                                 thecursor        IN OUT cursor_define.weavercursor) AS
  count0 integer;
  count1 integer;
begin
  select count(*)
    into count0
    from HrmSubCompany
   where subcompanyname = subcompanyname_1
   and supsubcomid = supsubcomid_4;
  select count(*)
    into count1
    from HrmSubCompany
    where subcompanydesc = subcompanydesc_2
    and supsubcomid = supsubcomid_4;
  if count0 > 0 then
    flag := 2;
    msg  := '该分部简称已经存在，不能保存！';
    return;
  end if;
  if count1 > 0 then
    flag := 3;
    msg  := '该分部全称已经存在，不能保存！';
    return;
  end if;
  INSERT INTO HrmSubCompany
    (subcompanyname,
     subcompanydesc,
     companyid,
     supsubcomid,
     url,
     showorder)
  VALUES
    (subcompanyname_1,
     subcompanydesc_2,
     companyid_3,
     supsubcomid_4,
     url_5,
     showorder_6);
  open thecursor for
    select (max(id)) from HrmSubCompany;
end;
/

