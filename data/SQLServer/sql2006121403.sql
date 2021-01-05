delete from MainMenuInfo where defaultParentId=1
go

insert into MainMenuInfo(
    id,
    menuName , 
    linkAddress , 
    parentFrame ,
    defaultParentId ,
    defaultLevel , 
    defaultIndex , 
    needRightToVisible , 
    needRightToView , 
    needSwitchToVisible , 
    relatedModuleId
)
select 
    id*-1,
    frontpagename,
    '/docs/news/NewsDsp.jsp?id='+cast(id as varchar(12)),
    'mainFrame',
    1,
    1,
    typeordernum,
    0,
    0,
    0,
    9
from DocFrontpage where isactive='1' and publishtype='1'
go


Alter TRIGGER Tri_UMMInfo_ByDocFrontpage ON DocFrontpage
FOR INSERT, UPDATE, DELETE 
AS
Declare @id_1 int, @countdelete int, @countinsert int
SELECT @countdelete = count(*) FROM deleted
SELECT @countinsert = count(*) FROM inserted

IF (@countinsert>0) BEGIN
select @id_1=id from inserted
delete from MainMenuInfo where id=@id_1*-1
insert into MainMenuInfo (
    id,
    menuName , 
    linkAddress , 
    parentFrame ,
    defaultParentId ,
    defaultLevel , 
    defaultIndex , 
    needRightToVisible , 
    needRightToView , 
    needSwitchToVisible , 
    relatedModuleId
)
select 
    id*-1,
    frontpagename,
    '/docs/news/NewsDsp.jsp?id='+cast(id as varchar(12)),
    'mainFrame',
    1,
    1,
    typeordernum,
    0,
    0,
    0,
    9
from DocFrontpage where id=@id_1 and isactive='1' and publishtype='1'
END

IF (@countinsert = 0) BEGIN
    SELECT @id_1 = id FROM deleted    
    DELETE FROM MainMenuInfo WHERE id=@id_1*-1
END

GO

