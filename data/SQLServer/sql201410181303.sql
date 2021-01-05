drop PROCEDURE HrmProvince_Insert
GO
CREATE PROCEDURE HrmProvince_Insert (@provincename_1  [varchar](60), @provincedesc_2  [varchar](200), @countryid_3 [int], @flag integer output, @msg varchar(80) output ) AS 
  declare @maxid int select @maxid=max(id)+1 from HrmProvince 
  INSERT INTO [HrmProvince] ([provincename], [provincedesc],[countryid]) 
  VALUES (@provincename_1, @provincedesc_2, @countryid_3) 
  select max(id) from [HrmProvince] if @@error<>0 begin set @flag=1 set @msg='插入储存过程失败' return end else begin set @flag=0 set @msg='插入储存过程成功' return end  
GO