CREATE TABLE DocPrivateSecCategory (
id int NOT NULL IDENTITY(1,1) ,
categoryname varchar(1000) NULL ,
ecology_pinyin_search varchar(1000) NULL ,
parentid int NULL 
)
GO

ALTER TABLE DocPrivateSecCategory ADD PRIMARY KEY (id)
GO

CREATE TRIGGER DocPrivateSec_getpinyin
ON DocPrivateSecCategory
AFTER INSERT, UPDATE
AS
DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int 
begin 
if (update(categoryname)) 
begin 
SELECT @id_1 = id,@pinyinlastname = lower(dbo.getPinYin(categoryname)) FROM inserted update DocPrivateSecCategory set ecology_pinyin_search= @pinyinlastname where id = @id_1 
end 
end

GO