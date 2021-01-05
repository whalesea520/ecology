ALTER PROCEDURE systemright_Srightsbygroup @id int, @flag int output, @msg varchar(80) output as 
begin select a.rightid,b.detachable from systemrighttogroup a,SystemRights b where a.groupid=@id and a.rightid=b.id order by b.righttype asc,a.rightid asc end

GO
