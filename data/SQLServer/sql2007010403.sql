ALTER PROCEDURE CRM_Info_SelectCountByResource (@id_1 	[int], @flag                             integer output, @msg                             varchar(80) output ) AS select count(*) from CRM_CustomerInfo where (deleted is null or deleted<>1) and manager = @id_1 if @@error<>0 begin set @flag=1 set @msg='查询人力资源文档总数信息成功' return end else begin set @flag=0 set @msg='查询人力资源文档总数信息失败' return end
GO
