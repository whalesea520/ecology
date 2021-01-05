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

/* FOR ID:66 自定义工作流报表无法加入正确的字段显示项 BY 王金永 */
CREATE or REPLACE PROCEDURE Workflow_ReportDspField_ByRp 
	(id_1 	integer,
	 language_2 	integer,
flag out integer ,
 msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS
 isbill_3 char(1);
 isbill_count integer;
 begin
select  count(isbill) INTO   isbill_count  from workflow_base a , Workflow_Report b 
where b.id = id_1 and a.id = b.reportwfid;
if isbill_count>0 then
    select  isbill INTO   isbill_3  from workflow_base a , Workflow_Report b 
    where b.id = id_1 and a.id = b.reportwfid;
end if;

if isbill_3 = '0' then
    open thecursor for
    select a.id , b.fieldlable , a.dsporder , a.isstat ,a.dborder 
    from Workflow_ReportDspField a , workflow_fieldlable b ,Workflow_Report c , workflow_base d 
    where a.reportid = c.id and a.fieldid= b.fieldid and c.reportwfid = d.id and d.formid = b.formid 
    and c.id = id_1 and  b.langurageid = language_2 order by a.dsporder;
else 
    open thecursor for
    select a.id , d.labelname , a.dsporder , a.isstat ,a.dborder  
    from Workflow_ReportDspField a , workflow_billfield b ,Workflow_Report c ,HtmlLabelInfo d 
    where a.reportid = c.id and a.fieldid= b.id and c.id = id_1 and b.fieldlabel = d.indexid and 
    d.languageid = language_2  order by a.dsporder;
end if;
end;
/
/*td: 198  客户卡片的联系人页面，输入的备注信息和备注文档都无法保存*/
ALTER TABLE CRM_CustomerContacter drop column  remarkDoc 
/
ALTER TABLE CRM_CustomerContacter ADD  remarkDoc integer /*备注文档*/
/