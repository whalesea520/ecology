CREATE TABLE secCreaterDocPope (
    id  integer  NOT NULL,
	secid integer NOT NULL ,  /*子目录的ID 此数字和分目录表的ID相关连*/ 
	PCreater integer NOT NULL ,   /*创建人的权限*/
	PCreaterManager integer NOT NULL , /*创建人的直接上级的权限*/
	PCreaterJmanager integer NOT NULL , /*创建人的间接上级的权限*/
	PCreaterDownOwner integer NOT NULL , /*创建人的下属的权限*/
	PCreaterSubComp integer NOT NULL , /*创建人的分部的权限*/
	PCreaterDepart integer NOT NULL , /*创建人的部门的默认的权限*/
	PCreaterDownOwnerLS integer NOT NULL , /*创建人的下属的安全级别开始数*/
	PCreaterSubCompLS integer NOT NULL , /*创建人的分部的安全级别开始数*/	
	PCreaterDepartLS integer NOT NULL , /*创建人的部门的安全级别开始数*/

    PCreaterW integer NOT NULL ,   /*外部创建人的权限*/
	PCreaterManagerW integer NOT NULL , /*外部创建人的经理的权限*/
	PCreaterJmanagerW integer NOT NULL  /*外部创建人的经理的上级的权限*/
)
/
create sequence secCreDocPop_id
start with 1
increment by 1
nomaxvalue
nocycle
/
create or replace trigger secCreDocPop_Trigger
before insert on secCreaterDocPope
for each row
begin
select secCreDocPop_id.nextval into :new.id from dual;
end;
/

/*是否允许修改其内部人员创立文档时的原默认共享 1:允许  0:不允许*/
alter table DocSecCategory add allownModiMShareL integer 
/

 /*是否允许修改其外部人员创立文档时的原默认共享 1:允许  0:不允许*/
alter table DocSecCategory add allownModiMShareW integer
/

/*初始化以前文档共享表中的数据*/
update docsharedetail set sharelevel=3 where sharelevel=2
/
update docshare set sharetype=3 where sharetype=2
/
alter table docshare add  isSecDefaultShare char(1)/*此权限是否是目录的默认权限  1:是 0:不是*/
/