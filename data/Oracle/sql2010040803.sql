CREATE or REPLACE PROCEDURE CptCapital_SelectByDataType 
(datatype_1 	integer, 
 departmentid_1  integer,
flag out integer, 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
)
 AS 
 begin
  open thecursor for
select * from CptCapital where (datatype = datatype_1) and (blongdepartment = departmentid_1);
end;
/
