/*新闻中心 子菜单 BEGIN*/
create or replace PROCEDURE NewPageInfo_Insert_All

AS
        id_1 integer;
        frontpagename_1 varchar2(100);
        defaultIndex_1 integer;
begin
	defaultIndex_1 := 1;
    FOR docFrontpage_cursor in( 
     SELECT id, frontpagename 
       FROM DocFrontpage 
      WHERE isactive = 1 and publishtype = 1 
      ORDER BY id)
    /*主菜单信息表 插入记录 新闻中心子菜单*/
    loop
		id_1 := docFrontpage_cursor.id;
		frontpagename_1 := docFrontpage_cursor.frontpagename;
		INSERT INTO MainMenuInfo (id,menuName,linkAddress,parentFrame,defaultLevel,defaultParentId,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(-id_1,frontpagename_1,Concat('/docs/news/NewsDsp.jsp?id=',TO_CHAR(id_1)),'mainFrame',1,1,defaultIndex_1,0,0,0,9);
         defaultIndex_1:= defaultIndex_1+1;
    END loop;
    /*新闻中心 子菜单 新闻设置*/
		INSERT INTO MainMenuInfo (id,labelId,linkAddress,parentFrame,defaultParentId,defaultLevel,defaultIndex,needRightToVisible,needRightToView,needSwitchToVisible,relatedModuleId) VALUES(-id_1-1,16390,'/docs/news/DocNews.jsp','mainFrame',1,1,defaultIndex_1,0,0,0,9); 
end;
/
drop TRIGGER Tri_ULeftMenuConfig_ByInfo
/
/*由于 LeftMenuInfo 表的更改，更新所有用户 LeftMenuConfig 配置信息*/
CREATE or replace TRIGGER Tri_ULeftMenuConfig_ByInfo after  insert or update or delete ON LeftMenuInfo 
for each row
Declare 
        id_1 integer;
        defaultIndex_1 integer;
        countdelete   integer;
        countinsert   integer;
        userId integer;
begin
    countdelete := :old.id;
    countinsert := :new.id;
    /*插入时 countinsert >0 AND countdelete is null */
    /*删除时 countinsert is null */
    /*更新时 countinsert >0 AND countdelete > 0 */

    /*插入*/
    IF (countinsert > 0 AND countdelete is null) then
        id_1 := :new.id;
        defaultIndex_1 := :new.defaultIndex;
          /*系统管理员*/
        INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(1,id_1,1,defaultIndex_1);
        /*用户*/    
        FOR hrmResource_cursor in( 
        SELECT id FROM HrmResource order by id)   
        loop
            userId:=hrmResource_cursor.id;
            INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex) VALUES(userId,id_1,1,defaultIndex_1);
        END loop;
    END if;

    /*删除*/
    IF (countinsert is null) then
       id_1 := :old.id;            
       DELETE FROM LeftMenuConfig WHERE infoId = id_1;
    END if;
end;
/

CREATE or replace procedure Crm_ExcelToDB (
  name_1 varchar2,
  engname_2 varchar2,
  address1_3 varchar2, 
  zipcode_4 varchar2,
  phone_5 varchar2, 
  fax_6 varchar2,
  email_7 varchar2,
  country_8  varchar2, 
  type_9 integer,
  description_10 integer,
  size_11 integer,
  sector_12 integer,
  creditamount_13 varchar2,
  credittime_14 integer,
  website_15 varchar2, 
  city_16 integer,
  province_17 integer ,
  manager_18 integer, 
  flag out integer,
  msg out varchar2,
  thecursor IN OUT cursor_define.weavercursor )
  as
  maxid integer;
  begin
	  insert into Crm_CustomerInfo (
		  name,engname,address1,zipcode,phone,fax,email,country,type,description , size_n,sector,creditamount,credittime,deleted,status,rating,website,source,manager,city,province,language) values (name_1,engname_2,address1_3,zipcode_4,phone_5,fax_6,email_7,country_8,type_9,description_10, size_11, sector_12,TO_NUMBER(creditamount_13),credittime_14,'0','2','1',website_15,'9',manager_18,city_16,province_17,'7'); 
	  select max(id) into maxid from Crm_CustomerInfo;
	  insert into CrmShareDetail (crmid,userid,usertype,sharelevel) values(maxid,'1','1','2');
end;
/
