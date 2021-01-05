delete from cus_treeform where id=-1
GO
insert into cus_treeform (scope, formlabel,id,parentid,viewtype,scopeorder)
values ('HrmCustomFieldByInfoType','基本信息',-1,0,1,0)
GO