CREATE OR REPLACE procedure HrmResourceShare(
	resourceid_1 integer,
	departmentid_1 integer,
	subcompanyid_1 integer,
	managerid_1 integer,
	seclevel_1 integer,
	managerstr_1 varchar2,
	olddepartmentid_1 integer,
	oldsubcompanyid_1 integer,
	oldmanagerid_1 integer,
	oldseclevel_1 integer,
	oldmanagerstr_1 varchar2,
	flag_1 integer,
	flag out integer,
	msg out varchar2,
	thecursor IN OUT cursor_define.weavercursor
	)  AS
	supresourceid_1 integer;
	docid_1     integer;
	crmid_1     integer;
	prjid_1     integer;
	cptid_1     integer;
	sharelevel_1  integer;
	countrec      integer;
	managerstr_11 varchar2(500);
	mainid_1    integer;
	subid_1    integer;
	secid_1    integer;
	members_1 varchar2(200);
	contractid_1     integer;
	contractroleid_1 integer;
	sharelevel_Temp integer;

	workPlanId_1 integer;
	m_countworkid integer;

	docid_2 integer;
	sharelevel_2  integer;
	countrec_2 integer;
	managerId_2s_2 varchar2(50);
	sepindex_2 integer;
	managerId_2 varchar2(200);
	tempDownOwnerId_2 integer;
	oldsubcompanyid_1_this integer;
begin

if oldsubcompanyid_1 is null then
    oldsubcompanyid_1_this := 0;
else
    oldsubcompanyid_1_this := oldsubcompanyid_1;
end if;

if (seclevel_1 <> oldseclevel_1) then
update HrmResource_Trigger set
seclevel =seclevel_1
where id =resourceid_1;
end if;


if ( departmentid_1 <> olddepartmentid_1 ) then
update HrmResource_Trigger set
departmentid =departmentid_1
where id =resourceid_1;
end if;

if ( managerstr_1 <> oldmanagerstr_1 ) then
update HrmResource_Trigger set
managerstr =managerstr_1
where id =resourceid_1;
end if;

if (subcompanyid_1 <> oldsubcompanyid_1_this) then
update HrmResource_Trigger set
subcompanyid1 =subcompanyid_1
where id =resourceid_1;
end if;


/* 如果部门和安全级别信息被修改(在新建的时候这两个信息肯定被修改) */

if((flag_1 = 1 and (departmentid_1<>olddepartmentid_1 or oldsubcompanyid_1_this<>subcompanyid_1 or seclevel_1<>oldseclevel_1) ) or flag_1 = 0) then


    /* 修改目录许可表 */
    if (flag_1 = 1 and ((olddepartmentid_1 <> departmentid_1) or (oldseclevel_1 <> seclevel_1) or (oldsubcompanyid_1_this<>subcompanyid_1))) then
        Doc_DirAcl_DUserP_BasicChange (resourceid_1, olddepartmentid_1, oldsubcompanyid_1_this, oldseclevel_1);
    end if;
    if ((flag_1 = 0) or (olddepartmentid_1 <> departmentid_1) or (oldseclevel_1 <> seclevel_1) or (oldsubcompanyid_1_this<>subcompanyid_1)) then
        Doc_DirAcl_GUserP_BasicChange (resourceid_1, departmentid_1, subcompanyid_1, seclevel_1);
    end if;

    /* 该人新建文档目录的列表 */

    delete from DocUserCategory where userid= resourceid_1 and usertype= '0';

    for all_cursor in(
    select distinct t1.id t1id from docseccategory t1,HrmResource_Trigger t2,hrmrolemembers t5
    where t1.cusertype='0' and t2.id= resourceid_1
    and(( t2.seclevel>= t1.cuserseclevel)
    or( t2.seclevel >= t1.cdepseclevel1 and t2.departmentid=t1.cdepartmentid1)
    or( t2.seclevel >= t1.cdepseclevel2 and t2.departmentid=t1.cdepartmentid2)
    or( t5.roleid=t1.croleid1 and t5.rolelevel=t1.crolelevel1 and t2.id=t5.resourceid )
    or( t5.roleid=t1.croleid2 and t5.rolelevel=t1.crolelevel2 and t2.id=t5.resourceid )
    or( t5.roleid=t1.croleid3 and t5.rolelevel=t1.crolelevel3 and t2.id=t5.resourceid ))
    )
    loop
        secid_1 := all_cursor.t1id;
        select  subcategoryid INTO subid_1 from docseccategory where id=secid_1;
        select  maincategoryid INTO mainid_1 from docsubcategory where id=subid_1;
        insert into  docusercategory (secid,mainid,subid,userid,usertype)
        values (secid_1,mainid_1,subid_1,resourceid_1,'0');
    end loop;

   /* ------- DOC 部分 -------  */
   /*如果部门做了更换 需要把文档共享表中的同部门记录做修改*/
	if ((flag_1 = 1 and departmentid_1 <>olddepartmentid_1) or flag_1=0 ) then
		update shareinnerdoc set content=departmentid_1 where type=3 and  srcfrom=85 and opuser=resourceid_1;
	end if;

	/*如果分部做了变化，需要把文档共享表中的同分部相关的记录做修改*/
	if ((flag_1 = 1 and subcompanyid_1<>oldsubcompanyid_1_this) or flag_1 = 0) then
		update shareinnerdoc set content=subcompanyid_1 where type=2 and srcfrom=84 and opuser=resourceid_1;
	end if;




    /* ------- CRM  部分 ------- */
    /*  将所有的信息现放到 temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    for crmid_cursor IN (select id from CRM_CustomerInfo where manager = resourceid_1 )
    loop
    crmid_1 :=crmid_cursor.id;
    insert into temptablevaluecrm values(crmid_1, 2);
    end loop;


    /* 自己下级的客户 3 */
    /* 查找下级 */
    managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%' );

    for subcrmid_cursor IN (select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
    crmid_1 :=subcrmid_cursor.id;
        select count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
        insert into temptablevaluecrm values(crmid_1, 3);
        end if;
    end loop;



    /* 作为crm管理员能看到的客户 */
    for rolecrmid_cursor IN (   select distinct t1.id from CRM_CustomerInfo  t1, hrmrolemembers  t2  where t2.roleid=8 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
    loop
    crmid_1:=rolecrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
        insert into temptablevaluecrm values(crmid_1, 4);
        end if;
    end loop;

    /* 由客户的共享获得的权利 1 2 */
    for sharecrmid_cursor IN (select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
    crmid_1 := sharecrmid_cursor.relateditemid;
     sharelevel_1:=sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1 ;
        if countrec = 0  then

            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
    end loop;

    for sharecrmid_cursor IN (   select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) )
    )
    loop
    crmid_1 :=sharecrmid_cursor.relateditemid;
    sharelevel_1 :=sharecrmid_cursor.sharelevel;
        select count(crmid) INTO countrec from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then

            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
    end loop;

    /* 将临时表中的数据写入共享表 */
    for allcrmid_cursor IN (select * from temptablevaluecrm)
    loop
    crmid_1 :=allcrmid_cursor.crmid;
    sharelevel_1 := allcrmid_cursor.sharelevel;

    /* added by lupeng 2004-07-22 for customer contact work plan */
        for ccwp_cursor in(
        SELECT id FROM WorkPlan WHERE type_n = '3' AND ','||crmid||',' like '%,'||to_char(crmid_1)||',%') 
        loop
        workPlanId_1 := ccwp_cursor.id;
        select count(workid)     into  m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1
            AND userid = resourceid_1 AND usertype = 1;
        if m_countworkid  = 0 then
        INSERT INTO WorkPlanShareDetail(workid, userid, usertype, sharelevel) VALUES (
            workPlanId_1, resourceid_1, 1, 1);
        end if;
        end loop;
    /* end */

    end loop;
    
    /* ------- PROJ 部分 ------- */

    /*  将所有的信息现放到 temptablevaluePrj 中 */
    /*  自己的项目2 */
    for prjid_cursor IN (select id from Prj_ProjectInfo where manager = resourceid_1 )
    loop
    prjid_1:=prjid_cursor.id;
    insert into temptablevaluePrj values(prjid_1, 2);
    end loop;


    /* 自己下级的项目3 */
    /* 查找下级 */

     managerstr_11 :=  concat(concat('%,' , to_char(resourceid_1)) , ',%' );

    for subprjid_cursor IN (select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
    prjid_1 :=subprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
        insert into temptablevaluePrj values(prjid_1, 3);
        end if;
    end loop;

    /* 作为项目管理员能看到的项目4 */
    for roleprjid_cursor IN (   select distinct t1.id from Prj_ProjectInfo  t1, hrmrolemembers  t2  where t2.roleid=9 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
    loop
    prjid_1 :=roleprjid_cursor.id;
        select count(prjid) INTO  countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
        insert into temptablevaluePrj values(prjid_1, 4);
        end if;
    end loop;

    /* 由项目的共享获得的权利 1 2 */
    for shareprjid_cursor IN ( select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
    prjid_1 :=shareprjid_cursor.relateditemid;
    sharelevel_1 :=shareprjid_cursor.sharelevel;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
    end loop;

    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers  t3  where  t1.id = t2.relateditemid and  t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) )
    )
    loop
     prjid_1 :=shareprjid_cursor.relateditemid;
     sharelevel_1:=shareprjid_cursor.sharelevel;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0 then
            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
    end loop;


    /* 项目成员5 (内部用户) */
    members_1 := concat(concat('%,' , to_char(resourceid_1)), ',%' );
    for inuserprjid_cursor IN (  SELECT  id FROM Prj_ProjectInfo   WHERE  ( concat(concat(',',members),',')  LIKE  members_1)  and isblock='1'  )
    loop
    prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then

            insert into temptablevaluePrj values(prjid_1, 5);
        end if;
    end loop;




    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allprjid_cursor IN (select * from temptablevaluePrj)
    loop
    prjid_1 :=allprjid_cursor.prjid;
    sharelevel_1 :=allprjid_cursor.sharelevel;
       insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1, resourceid_1,1,sharelevel_1);
    end loop;

    /* ------- CPT 部分 ------- */

    /*  将所有的信息现放到 temptablevalueCpt 中 */
    /*  自己的资产2 */
    for cptid_cursor IN (select id from CptCapital where resourceid = resourceid_1 )
    loop
    cptid_1 :=cptid_cursor.id;
    insert into temptablevalueCpt values(cptid_1, 2);
    end loop;

    /*  资产最后的修改者 */
    for cptid_cursor IN (select id from CptCapital where lastmoderid = resourceid_1 )
    loop
    cptid_1 :=cptid_cursor.id;
    insert into temptablevalueCpt values(cptid_1, 1);
    end loop;

    /* 自己下级的资产1 */
    /* 查找下级 */

     managerstr_11 := concat(concat( '%,' , to_char(resourceid_1)),',%');

    for subcptid_cursor IN (
    select id from CptCapital where ( resourceid in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
    cptid_1 := subcptid_cursor.id;
        select  count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0  then
        insert into temptablevalueCpt values(cptid_1, 1);
        end if;
    end loop;

    /* 由资产的共享获得的权利 1 2 */
    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
    cptid_1 :=sharecptid_cursor.relateditemid;
    sharelevel_1 := sharecptid_cursor.sharelevel;
        select  count(cptid) into  countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end if;
    end loop;

    for  sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
    loop
    cptid_1:= sharecptid_cursor.relateditemid;
    sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0 then
            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end  if;
    end loop;

    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcptid_cursor IN (select * from temptablevalueCpt)
    loop
    cptid_1 :=allcptid_cursor.cptid;
    sharelevel_1 := allcptid_cursor.sharelevel;
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1, resourceid_1,1,sharelevel_1);
    end loop;
     /* ------- 客户合同部分2003-11-06杨国生 ------- */

    /* 定义临时表变量 */
    /*Declare temptablevalueCpt  table(contractid integer,sharelevel integer)*/

    /*  将所有的信息现放到 temptablevalueCpt 中 */

    /* 自己下级的客户合同 3 */

    /*set managerstr_11 = '%,' + convert(varchar2(5),resourceid_1) + ',%' */
    managerstr_11:=Concat ('%,' ,Concat(to_char(resourceid_1),',%'));

    for subcontractid_cursor in(
    select id from CRM_Contract where ( manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) ))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0  then
            insert into temptablevaluecontract values(contractid_1, 3);
        end if;
    end loop;

     /*  自己是 manager 的客户合同 2 */
    for contractid_cursor in
    (select id from CRM_Contract where manager = resourceid_1 )
    loop
        contractid_1 := contractid_cursor.id;
        insert into temptablevaluecontract values(contractid_1, 2);
    end loop;

       /* 作为客户合同管理员能看到的 */
    for roleids_cursor in
    (select roleid from SystemRightRoles where rightid = 396)
    loop

       for rolecontractid_cursor in
 (select distinct t1.id from CRM_Contract  t1, hrmrolemembers  t2
 where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1
 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1 )
 or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))

      loop
            contractid_1 := rolecontractid_cursor.id;
            select count(contractid) into countrec from temptablevaluecontract
            where contractid = contractid_1;
            if countrec = 0  then
                insert into temptablevaluecontract values(contractid_1, 2);
            else
                select sharelevel into sharelevel_1 from ContractShareDetail where
                contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if sharelevel_1 = 1 then
                     update ContractShareDetail set sharelevel = 2
                     where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                end if;
            end if;
        end loop;

    end loop;

    /* 由客户合同的共享获得的权利 1 2 */
    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2
    where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 )
    or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
    loop
        contractid_1 := sharecontractid_cursor.relateditemid;
        sharelevel_1 := sharecontractid_cursor.sharelevel;
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
                update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1;
            end if;
        end if;
    end loop;



    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel from
    CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers  t3
    where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and
    t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and
    ( (t2.rolelevel=0  and t1.department=departmentid_1) or
    (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ))
    loop
        contractid_1 := sharecontractid_cursor.relateditemid;
        sharelevel_1 := sharecontractid_cursor.sharelevel;
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
                update temptablevaluecontract set sharelevel = sharelevel_1 where contractid = contractid_1;
            end if;
        end if;
    end loop;

    /* 自己下级的客户合同  (客户经理及经理线)*/

    managerstr_11:=concat( '%,',concat(to_char(resourceid_1),',%'));

    for subcontractid_cursor in
    (select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2
    where ( t1.manager in (select distinct id from HrmResource_Trigger where concat(',',managerstr) like managerstr_11 ) )
    and (t2.crmId = t1.id))
    loop
        contractid_1 := subcontractid_cursor.id;
        select count(contractid)  into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, 1);
        end if;
    end loop;
    /*  自己是 manager 的客户 (客户经理及经理线) */
    for contractid_cursor in
    (select t2.id from CRM_CustomerInfo t1 , CRM_Contract t2
    where (t1.manager = resourceid_1 ) and (t2.crmId = t1.id))
    loop
        contractid_1 := contractid_cursor.id;
        insert into temptablevaluecontract values(contractid_1, 1);
    end loop;

    /* 删除原有的与该人员相关的所有权 */
    delete from ContractShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcontractid_cursor in
    (select * from temptablevaluecontract)
    loop
        contractid_1 := allcontractid_cursor.contractid;
        sharelevel_1 := allcontractid_cursor.sharelevel;
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
        values(contractid_1, resourceid_1,1,sharelevel_1);
    end loop;


    /* for work plan */
    /* added by lupeng 2004-07-22 */
    /* delete all the work plan share info of this user */
    /* DELETE WorkPlanShareDetail WHERE userid = resourceid_1 AND usertype = 1 */
    for creater_cursor in(
    SELECT id FROM WorkPlan WHERE createrid = resourceid_1)
    loop
    workPlanId_1 := creater_cursor.id;
        INSERT INTO TmpTableValueWP( workPlanId , shareLevel ) VALUES (workPlanId_1, 2);
    end loop;

       /* b. the creater of the work plan is my underling */
    managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );
    for underling_cursor in(
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource_Trigger WHERE concat(',' , MANAGERSTR) LIKE managerstr_11)))
    loop
         workPlanId_1 := underling_cursor.id;
        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1;
        IF (countrec = 0) then
        INSERT INTO TmpTableValueWP(workPlanId , shareLevel) VALUES (workPlanId_1, 1);
        end if;
   end loop;


      /* c. in the work plan share info */
   for sharewp_cursor1 in(
    SELECT DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE ((forAll = 1 AND securityLevel <= seclevel_1) OR (userId like '%,'||resourceid_1||',%') OR (deptId like  concat( concat('%,' , to_char(departmentid_1)) , ',%' ) AND securityLevel <= seclevel_1)))
    loop
        workPlanId_1 := sharewp_cursor1.workPlanId;
        sharelevel_1 := sharewp_cursor1.shareLevel;
        SELECT count(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1 ;
        IF (countrec = 0) then
            INSERT INTO TmpTableValueWP( workPlanId , shareLevel ) VALUES (workPlanId_1, sharelevel_1);
        end if;
    end loop;


     for  sharewp_cursor2 in(
    SELECT DISTINCT t2.workPlanId as t2workPlanId, t2.shareLevel as t2shareLevel FROM WorkPlan t1, WorkPlanShare t2, HrmRoleMembers t3 WHERE t1.id = t2.workPlanId AND t3.resourceid = resourceid_1 AND t3.roleid = t2.roleId AND t3.rolelevel >= t2.roleLevel AND t2.securityLevel <= seclevel_1 AND ((t2.roleLevel = 0  AND t1.deptId = departmentid_1) OR (t2.roleLevel = 1 AND t1.subcompanyId = subcompanyid_1) OR (t3.rolelevel = 2)) )
    loop
        workPlanId_1 := sharewp_cursor2.t2workPlanId;
        sharelevel_1 := sharewp_cursor2.t2shareLevel;
        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1;
        IF (countrec = 0 ) then
            INSERT INTO TmpTableValueWP( workPlanId , shareLevel ) VALUES (workPlanId_1, sharelevel_1);
       end if;
    end loop;
    
    for allwp_cursor in (SELECT * FROM TmpTableValueWP)
    loop
    workPlanId_1 := allwp_cursor.workPlanId;
    sharelevel_1 := allwp_cursor.shareLevel;
        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
    end loop;

    /* write the data to the temporary table */
    /* a. the creater of the work plan is this user */
    
    /* end */


end if;       /* 结束修改了部门和安全级别的情况 */



/* 对于修改了经理字段,新的所有上级增加对该下级的文档共享,共享级别为可读 */
if ( flag_1 = 1 and managerstr_1 <> oldmanagerstr_1 and length(managerstr_1) > 1)  then /* 新建人力资源时候对经理字段的改变不考虑 */

         managerId_2 := concat( ',' , managerstr_1);

    /* ------- DOC 部分 ------- */
    /*只需要把docshareinner表中相应的经理做改动就可以了 81：表创建者上级*/
    update shareinnerdoc set content = managerid_1 where srcfrom = 81 and opuser = resourceid_1;

    /* ------- CRM 部分 ------- */
        for supuserid_cursor IN (select distinct t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, CRM_CustomerInfo t2 where managerId_2 like concat(concat('%,',to_char(t1.id)),',%') and  t2.manager = resourceid_1  )
        loop
        supresourceid_1:= supuserid_cursor.id_1;
        crmid_1 := supuserid_cursor.id_2;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0 then

                insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1,supresourceid_1,1,3);
            end if;

 /* added by lupeng 2004-07-22 for customer contact work plan */
        for ccwp_cursor in(
        SELECT id FROM WorkPlan WHERE type_n = '3' AND ','||crmid||',' like '%,'||to_char(crmid_1)||',%')
        loop
           workPlanId_1 := ccwp_cursor.id;
               select count(workid) into m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1
            AND userid = resourceid_1 AND usertype = 1;
              if m_countworkid  = 0 then
              INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
            workPlanId_1, resourceid_1, 1, 1);
              end if;
         end loop;
        /* end */

        end loop;



    /* ------- PROJ 部分 ------- */
        for supuserid_cursor IN (    select distinct t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, Prj_ProjectInfo t2 where managerId_2 like concat(concat('%,',to_char(t1.id)),',%')  and  t2.manager = resourceid_1 )
        loop
        supresourceid_1:= supuserid_cursor.id_1;
        prjid_1 :=supuserid_cursor.id_2;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then

                insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1,supresourceid_1,1,3);
            end if;
        end loop;



    /* ------- CPT 部分 ------- */
        for supuserid_cursor IN (select distinct  t1.id  id_1, t2.id id_2 from HrmResource_Trigger t1, CptCapital t2 where managerId_2 like concat(concat('%,',to_char(t1.id)),',%') and  t2.resourceid = resourceid_1  )
        loop
        supresourceid_1:=supuserid_cursor.id_1;
        cptid_1:=supuserid_cursor.id_2;
            select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then
                insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1,supresourceid_1,1,1);
            end if;
        end loop;

         /* ------- 客户合同部分 经理改变 2003-11-06杨国生------- */
        for supuserid_cursor in
        (select distinct t1.id id_1, t2.id id_2 from HrmResource_Trigger t1, CRM_Contract t2
        where managerId_2 like concat('%,',concat(to_char(t1.id),',%')) and  t2.manager = resourceid_1)
        loop
            supresourceid_1 := supuserid_cursor.id_1;
            contractid_1 := supuserid_cursor.id_2;
            select count(contractid) into countrec from ContractShareDetail where contractid = contractid_1 and
            userid= supresourceid_1 and usertype=1;
            if countrec = 0  then
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
                values(contractid_1,supresourceid_1,1,3);
            end if;
        end loop;

        for supuserid_cursor in
        (select distinct t1.id id_1, t3.id id_2 from HrmResource_Trigger t1, CRM_CustomerInfo t2 ,CRM_Contract t3 where managerId_2
        like concat('%,',concat(to_char(t1.id),',%')) and  t2.manager = resourceid_1  and t2.id = t3.crmId)
        loop
            supresourceid_1 := supuserid_cursor.id_1;
            contractid_1 := supuserid_cursor.id_2;
            select count(contractid) into countrec from ContractShareDetail
            where contractid = contractid_1 and userid= supresourceid_1 and usertype= 1;
            if countrec = 0  then
                insert into ContractShareDetail( contractid, userid, usertype, sharelevel)
                values(contractid_1,supresourceid_1,1,1);
            end if;
        end loop;

      /* for work plan */
    /* added by lupeng 2004-07-22 */
       for  supuserid_cursor in(
        SELECT DISTINCT t1.id  id_1, t2.id  id_2 FROM HrmResource_Trigger t1, WorkPlan t2 WHERE managerId_2 LIKE concat(concat('%,' , to_char(t1.id)) ,',%') AND t2.createrid = resourceid_1)
        loop
        supresourceid_1 := supuserid_cursor.id_1;
        workPlanId_1 := supuserid_cursor.id_2;
            SELECT COUNT(workid) into countrec  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = supresourceid_1 AND usertype = 1;
            IF (countrec = 0) then
                INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) values(workPlanId_1, supresourceid_1, 1, 1);
            end if;
       end loop;
    /* end */

    end  if;           /* 有上级经理判定结束 */

end;
/
