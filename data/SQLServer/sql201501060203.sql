ALTER TRIGGER Tri_mobile_getpinyin
 ON HrmResource FOR INSERT,UPDATE AS 
 DECLARE @pinyinlastname VARCHAR(50) 
 DECLARE @id_1 int ,
      @lastname char(400),
      @lastname1 char(400)
      select @lastname=lastname from inserted
      select @lastname1=lastname from deleted
 begin 
 if (@lastname!=@lastname1)
begin
 SELECT @id_1 = id,@pinyinlastname = lower(dbo.getPinYin(lastname)) 
 FROM inserted 
 
 update HrmResource set pinyinlastname = @pinyinlastname where id = @id_1
 end
 end 
GO