ALTER TRIGGER Tri_mobile_getpinyin ON HrmResource
FOR INSERT,UPDATE 
AS 
DECLARE @pinyinlastname VARCHAR(50) 
DECLARE @id_1 int 
begin 
SELECT @id_1 = id,@pinyinlastname = lower(dbo.getPinYin(lastname)) FROM inserted 
update HrmResource set pinyinlastname = @pinyinlastname where id = @id_1 
end

GO