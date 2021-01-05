CREATE OR REPLACE PROCEDURE updatePropertiesFile (propdetailid_t int, labelid_t int,attrname_t varchar,attrvalue_t varchar,attrnotes_t varchar,requisite_t int,isdelete_t int)
AS
countnum int :=0;
countnum_o int :=0;
mainid_t int;
BEGIN   
    BEGIN
      select count(1) into countnum from configFileManager where labelid=labelid_t;
    END;
    if countnum != 0 then
      begin                 
        select id into mainid_t from configFileManager where labelid=labelid_t;
        BEGIN
            select count(1)  into countnum_o from configPropertiesFile where propdetailid=propdetailid_t;
        END;
        if countnum_o != 0 then
          update configPropertiesFile set 
          configfileid=mainid_t,
          propdetailid=propdetailid_t,	  
          attrvalue=attrvalue_t,
	  attrname=attrname_t,
          attrnotes=attrnotes_t,
          createdate=to_char(sysdate,'YYYY-MM-DD'),
          createtime=to_char(sysdate,'hh:mi:ss'),
          issystem=1,
          requisite=requisite_t,
          isdelete=isdelete_t 
          where propdetailid=propdetailid_t;
        else
	  insert into  configPropertiesFile(propdetailid,configfileid,attrname,attrvalue,attrnotes,createdate,createtime,issystem,requisite,isdelete)
	  values (propdetailid_t,mainid_t,attrname_t,attrvalue_t,attrnotes_t,to_char(sysdate,'YYYY-MM-DD'),to_char(sysdate,'hh:mi:ss'),1,requisite_t,isdelete_t);
        end if;
        end;
     end if;
END;
/