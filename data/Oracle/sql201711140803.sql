CREATE OR REPLACE PROCEDURE HrmResource_UpdateLoginDate(id_1            integer,
                                                        lastlogindate_1 char,
                                                        flag            out integer,
                                                        msg             out varchar2,
                                                        thecursor       IN OUT cursor_define.weavercursor) as
begin
  update HrmResource set lastlogindate = lastlogindate_1 where id = id_1;
  commit;
end;
/