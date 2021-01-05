/* FOR ID:4 人力资源管理员的角色页面不能显示权限项 BY 刘煜 */
CREATE or REPLACE PROCEDURE HrmRoles_SystemRight 
  (roleid_1 integer, 
  flag out integer, 
  msg out varchar2, 
thecursor IN OUT cursor_define.weavercursor)
as
 rightid_1 integer ; 
 rolelevel_1 varchar(8);
 rightgroupname_1 varchar(80); 
 countgroupid_1 integer ; 
begin 
for right_cursor1 in(select rightid,rolelevel from systemrightroles where roleid= roleid_1)
loop
    rightid_1 :=right_cursor1.rightid ;
    rolelevel_1 :=right_cursor1.rolelevel ;
    insert into TM_HrmRoles_SystemRight(rightid,rightlevel) values( rightid_1, rolelevel_1) ;
    rightgroupname_1 := '' ;
    countgroupid_1 := 0 ;
    select count(rightgroupname) into countgroupid_1 from Systemrightgroups a, SystemRightToGroup b where rightid =  rightid_1 and a.id=b.groupid ;
    if countgroupid_1 = 1 then
        select rightgroupname into rightgroupname_1 from Systemrightgroups a, SystemRightToGroup b where rightid =  rightid_1 and a.id=b.groupid ;
    else
        if countgroupid_1 > 1 then
            select rightgroupname into rightgroupname_1 from (select  distinct rightgroupname from Systemrightgroups a, SystemRightToGroup b where rightid =  rightid_1 and a.id=b.groupid ) where rownum<2 ;
        end if ;
    end if ;
    update TM_HrmRoles_SystemRight set rightgroup =  rightgroupname_1 where rightid =  rightid_1;
end loop;
open thecursor for
select rightgroup,rightlevel,rightid from TM_HrmRoles_SystemRight order by rightgroup ;

 end;
/

/*for id=69 by 王金永*/
update SystemRightsLanguage set rightdesc='分部的新建、编辑、显示、删除、查看日志' where id=18 and languageid=7
/

/*
BUG 79 具有职务类别权限的用户，没有权限查看职务类别的日志信息.但是系统管理员可以查看日志信息-黄煜
*/
Delete From SystemRightDetail Where rightid = 126
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (426,'职务类别添加','HrmJobGroupsAdd:Add',126) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (427,'职务类别编辑','HrmJobGroupsEdit:Edit',126) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (428,'职务类别删除','HrmJobGroupsEdit:Delete',126) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (429,'职务类别日志查看','HrmJobGroups:Log',126) 
/

/*bug:92 修改112号权限的默认设置 by hy */
DELETE FROM SystemRights WHERE id = 112
/
DELETE FROM SystemRightsLanguage WHERE id = 112
/
DELETE FROM SystemRightDetail WHERE rightid = 112
/
insert into SystemRights (id,rightdesc,righttype) values (112,'其他信息维护','3') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (112,8,'other info maintenance','other info maintenance') 
/
insert into SystemRightsLanguage (id,languageid,rightname,rightdesc) values (112,7,'其他信息维护','其他信息维护') 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (391,'其他信息添加','HrmOtherInfoTypeAdd:Add',112) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (392,'其他信息编辑','HrmOtherInfoTypeEdit:Edit',112) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (393,'其他信息删除','HrmOtherInfoTypeEdit:Delete',112) 
/
insert into SystemRightDetail (id,rightdetailname,rightdetail,rightid) values (394,'其它信息日志查看','HrmOtherInfoType:Log',112) 
/
/*更改默认权限为人力资源的总部级别*/
DELETE FROM systemrighttogroup WHERE GroupID = 3 and rightid=112
/
INSERT INTO systemrighttogroup (GroupID,RightID) VALUES (3,112)
/
DELETE FROM SystemRightRoles WHERE RightID = 112 and RoleID = 4
/
INSERT INTO SystemRightRoles (RightID,RoleID,RoleLevel) VALUES (112,4,2)
/
