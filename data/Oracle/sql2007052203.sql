alter table workflow_groupdetail add  
signorder char(1)
/

update workflow_groupdetail set signorder=level_n where type in (5,42,43,49)
/

CREATE or REPLACE PROCEDURE workflow_groupdetail_Insert
(
groupid_1 integer, 
type_2 	integer, 
objid_3 	integer, 
level_4 	integer, 
level2_5 	integer,
conditions varchar2,
conditioncn varchar2,
orders varchar2,
signorder char, 
flag out integer  , 
msg out varchar2  ,
thecursor IN OUT cursor_define.weavercursor) 
AS 
begin 
INSERT INTO workflow_groupdetail (groupid, type, objid, level_n, level2_n,conditions,conditioncn,orders,signorder)  
VALUES (groupid_1, type_2, objid_3, level_4, level2_5,conditions,conditioncn,orders,signorder);
end;
/
