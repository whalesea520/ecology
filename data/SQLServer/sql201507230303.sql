insert into DocSecCategoryShare 
(seccategoryid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,downloadlevel,orgGroupId,operategroup,orgid,includesub,isolddate,seclevelmax)
select secid,4,PCreaterSubCompLS,0,PCreaterSubComp,0,0,0,0,0,0,PCreaterSubCompDL,0,1,0,0,1,100 from secCreaterDocPope where PCreaterSubComp>1 or PCreaterSubComp=1 
GO

insert into DocSecCategoryShare 
(seccategoryid,sharetype,seclevel,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,downloadlevel,orgGroupId,operategroup,orgid,includesub,isolddate,seclevelmax)
select secid,5,PCreaterDepartLS,0,PCreaterDepart,0,0,0,0,0,0,PCreaterDepartDL,0,1,0,0,1,100 from secCreaterDocPope where PCreaterDepart>1 or PCreaterDepart=1 
GO