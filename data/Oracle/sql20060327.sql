DECLARE
minLeftMenuId integer;
count_1 integer;
begin
SELECT nvl(MIN(id) -1,-1) into minLeftMenuId FROM LeftMenuInfo WHERE id<0;
INSERT INTO SequenceIndex (indexdesc,currentid) VALUES ('leftmenuid',minLeftMenuId);
end;
/


/*»ñÈ¡×ó²Ëµ¥SequenceID*/
CREATE or replace  PROCEDURE LeftMenuSequenceId_Get(
 flag out integer, 
 msg out varchar2,
 thecursor IN OUT cursor_define.weavercursor)
AS 
id_1 integer;
count_1 integer;
begin
SELECT count(*) into count_1 FROM SequenceIndex WHERE indexdesc='leftmenuid';
if count_1 >0 then
	SELECT currentid into id_1 FROM SequenceIndex WHERE indexdesc='leftmenuid';
end if;
UPDATE SequenceIndex SET currentid=currentid-1 WHERE indexdesc='leftmenuid';
open thecursor for
SELECT id_1 from dual;
end;
/
