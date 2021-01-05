drop PROCEDURE CptShareInfo_Insert_dft
go
CREATE PROCEDURE CptShareInfo_Insert_dft (@relateditemid_1 [int], @sharetype_2 [tinyint], @seclevel_3 [tinyint], @rolelevel_4 [tinyint], @sharelevel_5 [tinyint], @userid_6 [int], @departmentid_7 [int], @roleid_8 [int], @foralluser_9 [tinyint],@subcompanyid_10 [int],@sharefrom_11 [int], @flag integer output, @msg varchar(80) output)  
AS 
INSERT INTO [CptCapitalShareInfo] ( [relateditemid], [sharetype], [seclevel], [rolelevel], [sharelevel], [userid], [departmentid], [roleid], [foralluser],[subcompanyid],[sharefrom],[isdefault])  VALUES ( @relateditemid_1, @sharetype_2, @seclevel_3, @rolelevel_4, @sharelevel_5, @userid_6, @departmentid_7, @roleid_8, @foralluser_9,@subcompanyid_10,@sharefrom_11,1)  select max(id)  id from CptCapitalShareInfo 
go