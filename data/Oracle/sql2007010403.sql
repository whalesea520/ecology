create or replace PROCEDURE CRM_Info_SelectCountByResource
(
 id_1 	integer, 
 flag out  integer ,
 msg out  varchar2,
 thecursor IN OUT cursor_define.weavercursor
 ) 

 AS

begin
open thecursor for 
 select count(*) from CRM_CustomerInfo where (deleted is null or deleted<>1) and manager = id_1; 
end; 
/
