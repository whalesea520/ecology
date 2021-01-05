CREATE OR REPLACE PROCEDURE HrmCityTwo_Insert(cityname_1      varchar2,
                                              citylongitude_1 number,
                                              citylatitude_1  number,
                                              cityid_1        integer,
                                              flag            out integer,
                                              msg             out varchar2,
                                              thecursor       IN OUT cursor_define.weavercursor) as
  citypid_1 integer;
begin
   select ( nvl(max(id),0)+ 1) into citypid_1 from HrmCityTwo;
  insert into HrmCityTwo
    (id, cityname, citylongitude, citylatitude, cityid)
  VALUES
    (citypid_1, cityname_1, citylongitude_1, citylatitude_1, cityid_1);
  open thecursor for
    select citypid_1 from HrmCityTwo;
end;
/