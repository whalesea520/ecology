CREATE TABLE hrmcitytwo
    (
      id INT NOT NULL ,
      cityname VARCHAR(60) NULL ,
      citylongitude DECIMAL(8, 3) NULL ,
      citylatitude DECIMAL(8, 3) NULL ,
      cityid INT NULL
    )
/
CREATE OR REPLACE PROCEDURE HrmCityTwo_Insert(cityname_1      varchar2,
                                           citylongitude_1 number,
                                           citylatitude_1  number,
                                           flag            out integer,

                                           msg             out varchar2,
                                           thecursor       IN OUT cursor_define.weavercursor) as
  citypid_1 integer;
begin
  select (max(id) + 1) into citypid_1 from HrmCityTwo;
  insert into HrmCityTwo
    (id, cityname, citylongitude, citylatitude,cityid)
  VALUES
    (citypid_1,
     cityname_1,
     citylongitude_1,
     citylatitude_1,
     citypid_1 );
  open thecursor for
    select citypid_1 from HrmCityTwo;
end;
/
CREATE OR REPLACE PROCEDURE HrmCityTwo_Update(id_1            integer,
                                           cityname_1      varchar2,
                                           citylongitude_1 number,
                                           citylatitude_1  number,
                                           citypid_1    integer,
                                           flag            out integer,
                                           msg             out varchar2,
                                           thecursor       IN OUT cursor_define.weavercursor) as
begin
  update HrmCityTwo
     SET cityname      = cityname_1,
         citylongitude = citylongitude_1,
         citylatitude  = citylatitude_1,
         cityid = citypid_1
   WHERE (id = id_1);
end;
/
CREATE OR REPLACE PROCEDURE HrmCityTwo_Delete(id_1      integer,
                                           flag      out integer,
                                           msg       out varchar2,
                                           thecursor IN OUT cursor_define.weavercursor) as
begin
  delete HrmCityTwo WHERE (id = id_1);
end;
/


