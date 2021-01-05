CREATE or REPLACE PROCEDURE SequenceIndex_SelectNextID 
	(indexdesc_1 	varchar2,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)

AS
  currentid_1  integer ;
  currentid_count integer;
  begin
select count(currentid) INTO  currentid_count   from SequenceIndex where indexdesc = indexdesc_1;
if currentid_count>0 then

select currentid INTO  currentid_1   from SequenceIndex where indexdesc = indexdesc_1 for update;
end if;
update SequenceIndex set currentid = currentid_1 +1 where indexdesc= indexdesc_1;
open thecursor for
select currentid_1 from dual;
end;
/