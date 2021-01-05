CREATE or REPLACE PROCEDURE CptCapital_SCountByDataType 
(datatype_1 	integer, 
	flag out integer ,
	 msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor )
 AS 
 begin
 open thecursor for
select max(mark) from CptCapital where  datatype =  datatype_1 and isdata='2';
end;
/
