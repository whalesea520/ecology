create or replace TRIGGER Tri_UMMInfo_ByDocFrontpage after  insert or update or delete ON DocFrontpage 
for each row
Declare id_1 integer;
	frontpagename_1 varchar2(200);
        isactive_1 char(1);
        publishtype_1 integer;
        linkAddress_1 varchar2(100);
        defaultIndex_1 integer;
        countdelete   integer;
        countinsert   integer;
        updateId integer;
        updateIndex integer;

begin
countdelete :=:old.id;
countinsert :=:new.id;

/*insert*/
IF (countinsert > 0 and countdelete is null) then
   id_1:= :new.id;
   frontpagename_1:= :new.frontpagename;
   isactive_1:= :new.isactive;
   publishtype_1:= :new.publishtype;
   defaultIndex_1 := :new.typeordernum;       

	IF (isactive_1 = 1 AND publishtype_1 = 1) then
		linkAddress_1 := concat('/docs/news/NewsDsp.jsp?id=',To_CHAR(id_1));
		INSERT INTO MainMenuInfo (
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
			relatedModuleId,
			defaultParentId
		)
		VALUES (
			id_1*-1,
			frontpagename_1,
			linkAddress_1,
			'mainFrame',
			1,
			1,
			defaultIndex_1,
			0,
			0,
			0,
			9,
			1
		);
	END if;
END if;


/*update*/
IF (countinsert > 0 and  countdelete >0) then
  id_1:= :new.id;
  frontpagename_1:= :new.frontpagename;
  isactive_1:= :new.isactive;
  publishtype_1:= :new.publishtype;
  defaultIndex_1 := :new.typeordernum;
   
  linkAddress_1 := concat('/docs/news/NewsDsp.jsp?id=',To_CHAR(id_1));
  update MainMenuInfo set menuName=frontpagename_1,linkAddress=linkAddress_1,defaultIndex=defaultIndex_1 where id = id_1*-1;      
END if;


/*delete*/
IF (countinsert is null) then
    id_1 :=:old.id;
    DELETE FROM MainMenuInfo WHERE id=id_1*-1;
END if;
end;
/

update mainmenuinfo set parentid=defaultparentid where (parentid is null or parentid='') and defaultparentid=1
/
