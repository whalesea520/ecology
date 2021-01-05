CREATE OR REPLACE PROCEDURE docReadTag_AddByUser 
 (docid_1 	integer ,
  userid_2 	integer ,
  userType_3	integer ,
  flag out integer ,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor )  
AS 
 readcount integer;
 begin

 select   count(userid)  into readcount  from docReadTag 
 where docid = docid_1 and userid = userid_2 and userType = userType_3;
if readcount is not null and readcount > 0
then
    update DocReadTag set readcount = readcount+1 
    where docid = docid_1 and userid = userid_2 and userType = userType_3;
else 
    insert into  DocReadTag (docid,userid,readcount,usertype) 
    values(docid_1, userid_2, 1, userType_3);
end if;
end;
/