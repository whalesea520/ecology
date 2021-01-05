delete from MainMenuInfo where defaultParentId=1
/

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
    concat('/docs/news/NewsDsp.jsp?id=',To_CHAR(id)),
    'mainFrame',
    1,
    1,
    typeordernum,
    0,
    0,
    0,
    9
from DocFrontpage where isactive='1' and publishtype='1'
/

create or replace TRIGGER Tri_UMMInfo_ByDocFrontpage after  insert or update or delete ON DocFrontpage 
for each row
Declare id_1 integer;
        countdelete   integer;
        countinsert   integer;
begin
    countdelete :=:old.id;
    countinsert :=:new.id;


IF (countinsert > 0) then
id_1:= :new.id;
delete from MainMenuInfo where id=id_1*-1;  
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
    concat('/docs/news/NewsDsp.jsp?id=',To_CHAR(id_1)),
    'mainFrame',
    1,
    1,
    typeordernum,
    0,
    0,
    0,
    9
from DocFrontpage where id=id_1 and isactive='1' and publishtype=1;
END if;


IF (countinsert is null) then
    id_1 :=:old.id;
    DELETE FROM MainMenuInfo WHERE id=id_1*-1;
END if;
end;
/
