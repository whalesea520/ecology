CREATE OR REPLACE PROCEDURE SequenceIndex_SelectFileid
	(flag	out integer,
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)

AS 
begin
open thecursor for 
select currentid from SequenceIndex where indexdesc='imagefileid' for update;
update SequenceIndex set currentid = currentid+1 where indexdesc='imagefileid';
end;
/