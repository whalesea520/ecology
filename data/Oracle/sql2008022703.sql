 CREATE or REPLACE PROCEDURE CRM_CustomerInfo_Delete 
 (id_1 		integer,
 deleted_1  smallint,
 flag out integer ,
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)  
 AS
 begin
 UPDATE CRM_CustomerInfo  SET  deleted = deleted_1 WHERE ( id = id_1);
 delete from CRM_Contract where ( crmId	 = id_1);
end;
/

delete from CRM_Contract where crmId in(select id  from CRM_CustomerInfo where deleted  = 1)
/
