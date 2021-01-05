alter table workflow_groupdetail add level2_n integer
/
CREATE or REPLACE PROCEDURE workflow_groupdetail_Insert 
(groupid_1 integer, 
type_2 integer, 
objid_3 integer, 
level_4 integer, 
level2_5 integer, 
flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor ) 
AS
begin
INSERT INTO workflow_groupdetail ( groupid, type, objid, level_n, level2_n)  VALUES 
( groupid_1, type_2, objid_3, level_4, level2_5) ;
end;
/