CREATE PROCEDURE updateconfigFileManager @labelid int,@type int,@filename varchar(200),@filepath varchar(200),@fileinfo varchar(500),
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

CREATE PROCEDURE updatePropertiesFile 
@labelid int,@attrname varchar(200),@attrvalue varchar(200),@attrnotes varchar(500)
AS
BEGIN
	declare @mainid int
	delete from configPropertiesFile where issystem='1' and attrname=@attrname
	if exists (SELECT 1 from configFileManager where labelid=@labelid)
		begin
		set @mainid = (select id from configFileManager where labelid=@labelid)
		insert INTO  configPropertiesFile(configfileid,attrname,attrvalue,attrnotes,createdate,createtime,issystem)
		VALUES (@mainid,@attrname,@attrvalue,@attrnotes,convert(varchar(10),getdate(),120),convert(varchar(8),getdate(),114),1)
		end
END
GO


CREATE PROCEDURE updateXmlFile 
@labelid int,@attrvalue varchar(1000),@attrnotes varchar(500)
AS
BEGIN
	declare @mainid int
	delete from configXmlFile where issystem='1' and attrvalue=@attrvalue
	if exists (SELECT 1 from configFileManager where labelid=@labelid)
		begin
		set @mainid = (select id from configFileManager where labelid=@labelid)
		insert INTO  configXmlFile(configfileid,attrvalue,attrnotes,createdate,createtime,issystem)
		VALUES (@mainid,@attrvalue,@attrnotes,convert(varchar(10),getdate(),120),convert(varchar(8),getdate(),114),1)
		end
END
GO