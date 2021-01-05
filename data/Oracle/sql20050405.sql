CREATE or replace PROCEDURE DocShare_DeleteByDocidUserid 
(docid_1   integer ,
userid_2    integer,
flag	out integer,
msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin
delete from docshare where docid=docid_1 and userid=userid_2;
end;
/