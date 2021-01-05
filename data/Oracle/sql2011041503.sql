CREATE or REPLACE PROCEDURE workflow_NodeLink_Select 
 (
  nodeid1 integer, 
  isreject1 char ,
  requestid1 integer, 
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor )
  AS 
  begin
if isreject1 = '1' then 
  open thecursor for
  select * from workflow_nodelink where nodeid=nodeid1 and isreject='1' order by nodepasstime ,id;
else 
  open thecursor for
  select * from (select * from workflow_nodelink where nodeid=nodeid1 and (isreject is null or isreject !='1' ) and EXISTS (select 1 from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and ((b.requestid=requestid1 and b.IsFreeNode='1') or (b.IsFreeNode is null or b.IsFreeNode!='1')))) order by nodepasstime ,id;
end if;
end;
/
