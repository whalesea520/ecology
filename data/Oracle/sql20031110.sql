CREATE or REPLACE PROCEDURE DocShare_Delete 
	( id_1	integer,
	 flag	out integer,
	 msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as 
begin 


	delete from DocShare where id= id_1;

 end;
/