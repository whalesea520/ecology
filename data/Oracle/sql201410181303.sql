CREATE OR REPLACE PROCEDURE HrmProvince_Insert(provincename_1 varchar2,
                                               provincedesc_2 varchar2,
                                               countryid_3    integer,
                                               flag           out integer,
                                               msg            out varchar2,
                                               thecursor      IN OUT cursor_define.weavercursor) as
  maxid integer;
begin
  select max(id) into maxid from HrmProvince;
  maxid := maxid + 1;
  insert into HrmProvince
    (id, provincename, provincedesc, countryid)
  VALUES
    (maxid, provincename_1, provincedesc_2, countryid_3);
  open thecursor for
    select max(id) from HrmProvince;
end;
/