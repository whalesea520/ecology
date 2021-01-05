CREATE OR REPLACE 
PROCEDURE updateconfigFileManager(labelid_t int,type_t int,configtype_t int,filename_t varchar,filepath_t varchar,fileinfo_t varchar,
qcnumber_t varchar,KBversion_t varchar,isdelete_t int)  AS
countnum INTEGER := 0;
BEGIN
  BEGIN
    select count(1) into countnum from configFileManager where labelid=labelid_t;
  END;
if countnum != 0 then
    update configFileManager set
    filetype=type_t,
    configtype=configtype_t,
    filename=filename_t,
    filepath=filepath_t,
    qcnumber=qcnumber_t,
    fileinfo=fileinfo_t,
    kbversion=KBversion_t,
    isdelete=isdelete_t,
    createdate=to_char(sysdate,'YYYY-MM-DD'),
    createtime=to_char(sysdate,'hh:mi:ss')
    WHERE labelid=labelid_t;
else
  INSERT INTO configFileManager(labelid,filetype,configtype,filename,filepath,qcnumber,fileinfo,kbversion,isdelete,createdate,createtime) VALUES(labelid_t,type_t,configtype_t,filename_t,filepath_t,qcnumber_t,fileinfo_t,KBversion_t,isdelete_t,to_char(sysdate,'YYYY-MM-DD'),to_char(sysdate,'hh:mi:ss'));
end if;
END;
/
