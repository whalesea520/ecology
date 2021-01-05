CREATE OR REPLACE PROCEDURE SysFavourite_Insert(userid_1        integer,
                                                adddate_2       varchar,
                                                pagename_3      varchar,
                                                url_4           long,
                                                importlevel_5   integer,
                                                favouritetype_6 integer,
                                                flag            out integer,
                                                msg             out varchar2,
                                                thecursor       IN OUT cursor_define.weavercursor) AS
begin
  insert into sysfavourite
    (resourceid, adddate, pagename, url, importlevel, favouritetype)
  VALUES
    (userid_1,
     adddate_2,
     pagename_3,
     url_4,
     importlevel_5,
     favouritetype_6);
  commit;
  open thecursor for
    select max(id) as id from sysfavourite;
end;
/