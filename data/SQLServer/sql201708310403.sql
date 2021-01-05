ALTER PROCEDURE updateconfigFileManager @labelid int,@type int,@filename varchar(200),@filepath varchar(200),@fileinfo varchar(500),
@qcnumber varchar(15),@KBversion varchar(30)  AS
BEGIN
if exists (SELECT 1 from configFileManager where labelid=@labelid)
update configFileManager set 
filetype=@type,
filename=@filename,
filepath=@filepath,
qcnumber=@qcnumber,
fileinfo=@fileinfo,
kbversion=@KBversion,
createdate=convert(varchar(10),getdate(),120),
createtime=convert(varchar(8),getdate(),114)
WHERE labelid=@labelid
else
INSERT INTO configFileManager(labelid,filetype,filename,filepath,qcnumber,fileinfo,kbversion,createdate,createtime) VALUES(@labelid,@type,@filename,@filepath,@qcnumber,@fileinfo,@KBversion,convert(varchar(10),getdate(),120),convert(varchar(8),getdate(),114))
END
GO
ALTER PROCEDURE updatePropertiesFile @propdetailid_t int,@labelid_t int,@attrname_t varchar(500),@attrvalue_t varchar(1000),@attrnotes_t varchar(500),@requisite_t int,@isdelete_t int
AS
BEGIN
	declare @mainid_t int
	
	if exists (SELECT 1 from configFileManager where labelid=@labelid_t)
		begin
		set @mainid_t = (select id from configFileManager where labelid=@labelid_t)
		if exists(select 1 from configPropertiesFile where propdetailid=@propdetailid_t)
		 update configPropertiesFile set configfileid=@mainid_t,propdetailid=@propdetailid_t,attrvalue=@attrvalue_t,attrname=@attrname_t,attrnotes=@attrnotes_t,
		 createdate=convert(varchar(10),getdate(),120),createtime=convert(varchar(8),getdate(),114),issystem=1,requisite=@requisite_t,isdelete=@isdelete_t 
          	 where propdetailid=@propdetailid_t;
		else
		 insert into  configPropertiesFile(propdetailid,configfileid,attrname,attrvalue,attrnotes,createdate,createtime,issystem,requisite,isdelete)
	 	 values (@propdetailid_t,@mainid_t,@attrname_t,@attrvalue_t,@attrnotes_t,convert(varchar(10),getdate(),120),convert(varchar(8),getdate(),114),1,@requisite_t,@isdelete_t);
		end
END
GO
ALTER PROCEDURE updateXmlFile 
@xmldetailid int,@labelid int,@attrvalue varchar(2000),@xpath varchar(500),@attrnotes varchar(500),@requisite int,@isdelete int
AS
BEGIN
	declare @mainid int
	
	if exists (SELECT 1 from configFileManager where labelid=@labelid)
		begin
		set @mainid = (select id from configFileManager where labelid=@labelid)
		if exists(select 1 from configXmlFile where xmldetailid=@xmldetailid)
			update configXmlFile set configfileid=@mainid,xmldetailid=@xmldetailid,attrvalue=@attrvalue,xpath=@xpath,attrnotes=@attrnotes,createdate=convert(varchar(10),getdate(),120),
			createtime=convert(varchar(8),getdate(),114),issystem=1,requisite=@requisite,isdelete=@isdelete where xmldetailid=@xmldetailid
		else
			insert INTO  configXmlFile(configfileid,xmldetailid,attrvalue,xpath,attrnotes,createdate,createtime,issystem,requisite,isdelete)
			VALUES (@mainid,@xmldetailid,@attrvalue,@xpath,@attrnotes,convert(varchar(10),getdate(),120),convert(varchar(8),getdate(),114),1,@requisite,@isdelete)
		end
END
GO