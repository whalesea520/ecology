create or replace procedure MailResourceContentUpdate(
mailid_1 integer,
content_1 clob,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
as
begin
update MailResource set hasHtmlImage='1',content=content_1 where id=mailid_1;
end;
/