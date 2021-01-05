create or replace procedure hrmcity_insert(cityname_1      varchar2,
                                           citylongitude_1 number,
                                           citylatitude_1  number,
                                           provinceid_1    integer,
                                           countryid_1     integer,
                                           flag            out integer,
                                           msg             out varchar2,
                                           thecursor       in out cursor_define.weavercursor) as
  cityid_1 integer;
begin
  select (nvl(max(id),0) + 1) into cityid_1 from hrmcity;
  insert into hrmcity
    (id, cityname, citylongitude, citylatitude, provinceid, countryid)
  values
    (cityid_1,
     cityname_1,
     citylongitude_1,
     citylatitude_1,
     provinceid_1,
     countryid_1);
  open thecursor for
    select cityid_1 from hrmcity;
end;
