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