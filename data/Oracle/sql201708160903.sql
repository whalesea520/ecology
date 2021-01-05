CREATE OR REPLACE PROCEDURE updateconfigFileManager(labelid_t int,type_t int,filename_t varchar,filepath_t varchar,fileinfo_t varchar,
qcnumber_t varchar,KBversion_t varchar)  AS
countnum INTEGER :=0;
BEGIN
BEGIN
  select count(1) into countnum from configFileManager where labelid=labelid_t;
END;
if countnum != 0 then
    update configFileManager set
    filetype=type_t,
    filename=filename_t,
    filepath=filepath_t,
    qcnumber=qcnumber_t,
    fileinfo=fileinfo_t,
    kbversion=KBversion_t,
    createdate=to_char(sysdate,'YYYY-MM-DD'),
    createtime=to_char(sysdate,'hh:mi:ss')
    WHERE labelid=labelid_t;
else
  INSERT INTO configFileManager(labelid,filetype,filename,filepath,qcnumber,fileinfo,kbversion,createdate,createtime) VALUES(labelid_t,type_t,filename_t,filepath_t,qcnumber_t,fileinfo_t,KBversion_t,to_char(sysdate,'YYYY-MM-DD'),to_char(sysdate,'hh:mi:ss'));
end if;
END;
/
CREATE OR REPLACE  PROCEDURE updatePropertiesFile 
(labelid_t int,attrname_t varchar,attrvalue_t varchar,attrnotes_t varchar,requisite_t int)
AS
countnum INTEGER :=0;
mainid_t int;
BEGIN
  delete from configPropertiesFile where issystem='1' and attrname=attrname_t and configfileid in(select id from configFileManager where labelid=labelid_t);
  BEGIN
  select count(1) into countnum from configFileManager where labelid=labelid_t;
  END;
  if countnum != 0 then
    select id into mainid_t from configFileManager where labelid=labelid_t;
    insert INTO  configPropertiesFile(configfileid,attrname,attrvalue,attrnotes,createdate,createtime,issystem,requisite)
    VALUES (mainid_t,attrname_t,attrvalue_t,attrnotes_t,to_char(sysdate,'YYYY-MM-DD'),to_char(sysdate,'hh:mi:ss'),1,requisite_t);
  end if;
END;
/
CREATE OR REPLACE PROCEDURE updateXmlFile (xmldetailid_t int,labelid_t int,attrvalue_t varchar,xpath_t varchar,attrnotes_t varchar,requisite_t int,isdelete_t int)
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
            select count(1)  into countnum_o from configXmlFile where xmldetailid=xmldetailid_t;
        END;
        if countnum_o != 0 then
          update configXmlFile set 
          configfileid=mainid_t,
          xmldetailid=xmldetailid_t,
          attrvalue=attrvalue_t,
          xpath=xpath_t,
          attrnotes=attrnotes_t,
          createdate=to_char(sysdate,'YYYY-MM-DD'),
          createtime=to_char(sysdate,'hh:mi:ss'),
          issystem=1,
          requisite=requisite_t,
          isdelete=isdelete_t 
          where xmldetailid=xmldetailid_t;
        else
          insert INTO  configXmlFile(configfileid,xmldetailid,attrvalue,xpath,attrnotes,createdate,createtime,issystem,requisite,isdelete)
          VALUES (mainid_t,xmldetailid_t,attrvalue_t,xpath_t,attrnotes_t,to_char(sysdate,'YYYY-MM-DD'),to_char(sysdate,'hh:mi:ss'),1,requisite_t,isdelete_t);
        end if;
        end;
     end if;
END;
/