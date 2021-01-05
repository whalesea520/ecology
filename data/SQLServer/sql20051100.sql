CREATE TABLE secCreaterDocPope (
    id  int identity(1,1) NOT NULL,
	secid int NOT NULL ,  /*子目录的ID 此数字和分目录表的ID相关连*/ 
	PCreater int NOT NULL ,   /*创建人的权限*/
	PCreaterManager int NOT NULL , /*创建人的直接上级的权限*/
	PCreaterJmanager int NOT NULL , /*创建人的间接上级的权限*/
	PCreaterDownOwner int NOT NULL , /*创建人的下属的权限*/
	PCreaterSubComp int NOT NULL , /*创建人的分部的权限*/
	PCreaterDepart int NOT NULL , /*创建人的部门的默认的权限*/
	PCreaterDownOwnerLS int NOT NULL , /*创建人的下属的安全级别开始数*/
	PCreaterSubCompLS int NOT NULL , /*创建人的分部的安全级别开始数*/	
	PCreaterDepartLS int NOT NULL , /*创建人的部门的安全级别开始数*/

    PCreaterW int NOT NULL ,   /*外部创建人的权限*/
	PCreaterManagerW int NOT NULL , /*外部创建人的经理的权限*/
	PCreaterJmanagerW int NOT NULL  /*外部创建人的经理的上级的权限*/
)
GO

/*是否允许修改其内部人员创立文档时的原默认共享 1:允许  0:不允许*/
alter table DocSecCategory add allownModiMShareL int 
GO

 /*是否允许修改其外部人员创立文档时的原默认共享 1:允许  0:不允许*/
alter table DocSecCategory add allownModiMShareW int
go


/*初始化以前文档共享表中的数据*/
update docsharedetail set sharelevel=3 where sharelevel=2
go

update docshare set sharetype=3 where sharetype=2
go
alter table docshare add  isSecDefaultShare char(1)/*此权限是否是目录的默认权限  1:是 0:不是*/
go