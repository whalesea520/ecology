
Alter  TRIGGER Tri_CRM_CustomerInfoShare ON CRM_CustomerInfo WITH ENCRYPTION
FOR UPDATE
AS
Declare 
    @crmid_1 int,
    @oldmanagerstr_1 varchar(200),
    @managerstr_1 varchar(200)       

select  @crmid_1  = id from deleted
select  @oldmanagerstr_1 = manager from deleted
select @managerstr_1 = manager from inserted
   

if (  @managerstr_1 <> @oldmanagerstr_1 ) 
begin   
    begin
        update shareinnerdoc set content=@managerstr_1 where srcfrom=-81 and opuser=@crmid_1 
    end          
end   

GO


