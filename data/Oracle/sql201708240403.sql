CREATE OR REPLACE PROCEDURE docReadTag_AddByUser(docid_1    integer,
                                                 userid_2   integer,
                                                 userType_3 integer,
                                                 flag       out integer,
                                                 msg        out varchar2,
                                                 thecursor  IN OUT cursor_define.weavercursor) 
AS ifhaveread integer;readcount2 integer;
begin
  select count(userid)
    into ifhaveread
    from docReadTag
   where docid = docid_1
     and userid = userid_2
     and userType = userType_3;
   select to_number(readcount)+1
    into readcount2
    from docReadTag
   where docid = docid_1
     and userid = userid_2
     and userType = userType_3;
  if ifhaveread is not null and ifhaveread > 0 then    
    update DocReadTag
       set readcount = readcount2
     where docid = docid_1
       and userid = userid_2
       and userType = userType_3;
  else
    insert into DocReadTag
      (docid, userid, readcount, usertype)
    values
      (docid_1, userid_2, 1, userType_3);
  end if;
end;
/