CREATE or replace PROCEDURE CRM_ContactLog_WorkPlan (
    flag out integer  , 
    msg out varchar2,
    thecursor IN OUT cursor_define.weavercursor)
AS 
m_logid integer;
m_customerid integer;
m_resourceid integer;
m_subject varchar2(100);
m_contactdate char(10);
m_contacttime char(8);
m_enddate char(10);
m_endtime char(10);
m_contactinfo varchar2(4000);
m_documentid integer;
m_submitdate char(10);
m_submittime char(8);
m_isfinished smallint;
m_isprocessed smallint;
m_agentid integer;
m_status char(1);
m_workid integer;
m_userid integer;
m_usertype integer;
m_deptId integer;
m_subcoId integer;
m_id integer;
begin
for  all_cursor  in(
SELECT id, customerid, resourceid, subject, contactdate, 
contacttime, enddate, endtime, contactinfo, documentid, 
submitdate, submittime, isfinished, isprocessed, agentid FROM CRM_ContactLog)
loop
   m_logid := all_cursor.id;
   m_customerid := all_cursor.customerid;
   m_resourceid := all_cursor.resourceid;
   m_subject := all_cursor.subject;
   m_contactdate := all_cursor.contactdate; 
   m_contacttime := all_cursor.contacttime; 
   m_enddate := all_cursor.enddate;
   m_endtime := all_cursor.endtime; 
   m_contactinfo := all_cursor.contactinfo; 
   m_documentid := all_cursor.documentid;
   m_submitdate := all_cursor.submitdate;
   m_submittime := all_cursor.submittime;
   m_isfinished := all_cursor.isfinished;
   m_isprocessed := all_cursor.isprocessed;
   m_agentid := all_cursor.agentid;
IF (m_subject <> 'Create') then

  IF m_isfinished = 0 then
     m_status := '0';
  elsif m_isprocessed = 0 then 
           m_status := '1';
  ELSE
     m_status := '2';
  end if;

  INSERT INTO WorkPlan (
  type_n, urgentLevel, crmid, resourceid, name, begindate, begintime, enddate, endtime, description, 
  docid, createdate, createtime,agentId, status, createrid) VALUES ('3', '1', m_customerid, m_resourceid, m_subject, 
  m_contactdate, m_contacttime,m_enddate, m_endtime, m_contactinfo, m_documentid, m_submitdate, m_submittime, m_agentid, 
  m_status, m_resourceid);
  
  SELECT MAX(id) into m_workid  FROM WorkPlan;

  select count(id) into m_id FROM CRM_SellChance WHERE comefromid = m_logid;
  if m_id <> 0 then
  UPDATE CRM_SellChance SET comefromid = m_workid WHERE comefromid = m_logid;
  end if;

  SELECT departmentid, subcompanyid1 into m_deptId  , m_subcoId  FROM HrmResource WHERE id = 
  m_resourceid;
  UPDATE WorkPlan SET deptId = m_deptId, subcompanyId = m_subcoId where id = m_workid;

  INSERT INTO WorkPlanShare (workPlanId,shareType,userId,deptId,roleId,forAll,roleLevel,securityLevel,shareLevel,isdefault) 
  SELECT m_workid,sharetype,seclevel,rolelevel,userid,departmentid,roleid,foralluser,0,1 FROM CRM_ShareInfo WHERE relateditemid = m_customerid;
end if;
end loop;
end;
/

CREATE or replace PROCEDURE CRM_Share_WorkPlan (
crmId_1 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor)
AS 
  m_workid integer;
  m_userid integer;
  m_usertype integer;
  m_countId integer ;
  
  t_sharetype integer;
  t_seclevel integer;
  t_rolelevel integer;
  t_userid integer;
  t_departmentid integer;
  t_roleid integer;
  t_foralluser char(1);

  begin
FOR all_cursor in( 
SELECT id FROM WorkPlan WHERE type_n = '3' AND concat(concat(',',crmid),',') LIKE concat(concat('%,',crmId_1),',%'))
loop
  m_workid := all_cursor.id;
  for  m_cursor in
     (SELECT sharetype,seclevel,rolelevel,userid,departmentid,roleid,foralluser FROM CRM_ShareInfo WHERE relateditemid = crmId_1)
         loop
              t_sharetype := m_cursor.sharetype;
              t_seclevel := m_cursor.seclevel;
              t_rolelevel := m_cursor.rolelevel;
              t_userid := m_cursor.userid;
              t_departmentid := m_cursor.departmentid;
              t_roleid := m_cursor.roleid;
              t_foralluser := m_cursor.foralluser;
         SELECT count(workPlanId)  into m_countId FROM WorkPlanShare WHERE workPlanId = m_workid 
                AND shareType = t_sharetype AND securityLevel = t_seclevel 
                AND roleLevel = t_rolelevel AND userId = t_userid 
                AND deptId = t_departmentid AND roleId = t_roleid AND forAll = t_foralluser
                AND shareLevel=0 AND isdefault=1;
                if m_countId = 0 then                     
                    INSERT INTO WorkPlanShare (workPlanId,shareType,userId,deptId,roleId,forAll,roleLevel,securityLevel,shareLevel,isdefault) 
                    VALUES (m_workid, t_sharetype, t_userid, t_departmentid, t_roleid, t_foralluser, t_rolelevel, t_seclevel, 0, 1) ;
   end if;
   end loop;
   end loop;
  end ;
/

create or replace procedure HrmRoleMembersShare(resourceid_1 integer,
                                                roleid_1     integer,
                                                rolelevel_1 integer,
						rolelevel_2 integer,
						flag_1 integer,
						flag out integer, 
						msg out varchar2,
						thecursor IN OUT cursor_define.weavercursor
) AS
    oldrolelevel_1 char(1);
    oldresourceid_1 integer;
    oldroleid_1 integer;
    docid_1	 integer;
    crmid_1	 integer;
    prjid_1	 integer;
    cptid_1	 integer;
    sharelevel_1  integer;
    departmentid_1 integer;
    subcompanyid_1 integer;
    seclevel_1	 integer;
    countrec      integer;
    countdelete   integer;
    countinsert   integer;
    managerstr_11 varchar2(200);
    contractid_1	 integer;
    contractroleid_1 integer;
    sharelevel_Temp integer;
    workPlanId_1 integer;
    m_countworkid integer;
    tempresourceid integer;
/* 某一个人加入一个角色或者在角色中的级别升高进行处理,这两种情况都是增加了共享的范围,不需要删除
原有共享信息,只需要判定增加的部分 */
begin

oldrolelevel_1 := rolelevel_2;
oldroleid_1 :=  roleid_1;
oldresourceid_1 := resourceid_1;

/*
flag_1:
0: new
1:update
2:delete
*/
/*if resource is manager , return */
	select count(id) into tempresourceid  from hrmresourcemanager where id = resourceid_1 ;
	if tempresourceid >0 then
		return ;
	end if ;

/* 如果有删除原有数据，则将许可表中的权限许可数减一 */
   if flag_1 = 2 then
    select seclevel into seclevel_1  from hrmresource where id = oldresourceid_1 ;
    if seclevel_1 is not null then
        Doc_DirAcl_DUserP_RoleChange (oldresourceid_1, oldroleid_1, oldrolelevel_1, seclevel_1);
    end if;
	end if;

	/* 如果有增加新数据，则将许可表中的权限许可数加一 */
	if flag_1 = 0 then
    select seclevel into seclevel_1 from hrmresource where id = resourceid_1;
    if seclevel_1 is not null then
        Doc_DirAcl_GUserP_RoleChange (resourceid_1, roleid_1, rolelevel_1, seclevel_1);
    end if;
    end if;



if ( flag_1=0 or (flag_1=1 and rolelevel_1>rolelevel_2) )  then

    select  departmentid ,  subcompanyid1 ,  seclevel INTO  departmentid_1 ,subcompanyid_1 ,seclevel_1
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null  then
	departmentid_1 := 0;
	end if;
    if subcompanyid_1 is null  then
	subcompanyid_1 := 0;
	end if;


    if rolelevel_1 = '2'   then    /* 新的角色级别为总部级 */


	/* ------- CRM 部分 ------- */
	/* ------- PROJ 部分 ------- */

		for shareprjid_cursor IN (      select distinct relateditemid , sharelevel from Prj_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then

                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);

            else if sharelevel_1 = 2  then

                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */
            end if;
			end if;
		end loop;





	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (select distinct relateditemid , sharelevel from CptCapitalShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select count(cptid) INTO  countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then

                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);

            else if sharelevel_1 = 2 then

                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1;  /* 共享是可以编辑, 则都修改原有记录 */
            end if;
			end if;
		end loop;

        /* ------- 客户合同部分 总部 2003-11-06杨国生------- */

        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396) /*396为客户合同管理权限*/
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 and t2.rolelevel=2)
            loop
	       contractid_1 := rolecontractid_cursor.id;
               select count(contractid) into countrec from ContractShareDetail
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0 then
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else
                    select sharelevel into sharelevel_1 from ContractShareDetail
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    end if;
                end if;
            end loop;
        end loop;
           /* for work plan */
	 /* added by lupeng 2004-07-22 */
	 /* end */


    end if;


    if rolelevel_1 = '1' then        /* 新的角色级别为分部级 */


	/* ------- CRM 部分 ------- */

	/* ------- PRJ 部分 ------- */

		for shareprjid_cursor IN (        select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		prjid_1 := shareprjid_cursor.relateditemid;
		sharelevel_1 :=shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then

                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);

            else if sharelevel_1 = 2  then

                update PrjShareDetail set sharelevel = 2 where prjid=prjid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */
            end if;
			end if;

		end loop;


	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		loop
		cptid_1 :=sharecptid_cursor.relateditemid;
		sharelevel_1 :=sharecptid_cursor.sharelevel;
            select  count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then

                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);

            else if sharelevel_1 = 2  then

                update CptShareDetail set sharelevel = 2 where cptid=cptid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */
            end if;
			end if;
		end loop;

         /* ------- 客户合同部分 分部 2003-11-06杨国生------- */
        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396) /*396为客户合同管理权限*/
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1
            and (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 ))
            loop
	       contractid_1 := rolecontractid_cursor.id;
               select count(contractid) into countrec from ContractShareDetail
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0 then
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else
                    select sharelevel into sharelevel_1 from ContractShareDetail
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1  ;
                    end if;
                end if;
            end loop;
        end loop;


         /* for work plan */
	 /* added by lupeng 2004-07-22 */

	 /* end */
    end if;


    if rolelevel_1 = '0'     then     /* 为新建时候设定级别为部门级 */



	/* ------- CRM 部分 ------- */

	/* ------- PRJ 部分 ------- */

		for shareprjid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department= departmentid_1)
		loop
		prjid_1 :=shareprjid_cursor.relateditemid;
		sharelevel_1 := shareprjid_cursor.sharelevel;
            select  count(prjid) INTO countrec  from PrjShareDetail where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then

                insert into PrjShareDetail values(prjid_1, resourceid_1, 1, sharelevel_1);

            else if sharelevel_1 = 2  then

                update PrjShareDetail set sharelevel = 2 where prjid = prjid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */
            end if;
			end if;
		end loop;



	/* ------- CPT 部分 ------- */

		for sharecptid_cursor IN (       select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.departmentid= departmentid_1)
		loop
		 cptid_1 :=sharecptid_cursor.relateditemid;
		 sharelevel_1 := sharecptid_cursor.sharelevel;
            select count(cptid) INTO countrec  from CptShareDetail where cptid = cptid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then

                insert into CptShareDetail values(cptid_1, resourceid_1, 1, sharelevel_1);

            else if sharelevel_1 = 2  then

                update CptShareDetail set sharelevel = 2 where cptid = cptid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */
            end if;
			end if;
		end loop;

        /* ------- 客户合同部分 部门 2003-11-06杨国生------- */
        for roleids_cursor in
        (select roleid from SystemRightRoles where rightid = 396) /*396为客户合同管理权限*/
        loop
            for rolecontractid_cursor in
            (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2
            where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1 and
            (t2.rolelevel=0 and t1.department=departmentid_1 ))
            loop
	       contractid_1 := rolecontractid_cursor.id;
               select count(contractid) into countrec from ContractShareDetail
               where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                if countrec = 0  then
                    insert into ContractShareDetail values(contractid_1, resourceid_1, 1, 2);
                else
                    select sharelevel into sharelevel_1 from ContractShareDetail
                    where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    if sharelevel_1 = 1 then
                         update ContractShareDetail set sharelevel = 2
                         where contractid = contractid_1 and userid = resourceid_1 and usertype = 1;
                    end if;
                end if;
            end loop;

        end loop;

     /* for work plan */
	 /* added by lupeng 2004-07-22 */
	 /* end */

    end if;


else

if (  flag_1=2 or (flag_1=1 and rolelevel_1<rolelevel_2)  )  then
/* 当为删除或者级别降低 */


    select  departmentid ,  subcompanyid1 ,  seclevel INTO departmentid_1 ,subcompanyid_1 ,seclevel_1
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null then
	departmentid_1 := 0;
    end if;
	if subcompanyid_1 is null then
	subcompanyid_1 := 0;
	end if;

    

    /* ------- CRM  部分 ------- */


    /* ------- PROJ 部分 ------- */



    /*  将所有的信息现放到 temptablevaluePrj 中 */
    /*  自己的项目2 */
    for prjid_cursor IN (select id from Prj_ProjectInfo where manager = resourceid_1 )
	loop
	prjid_1 := prjid_cursor.id;
      insert into temptablevaluePrj values(prjid_1, 2);
	end loop;



    /* 自己下级的项目3 */
    /* 查找下级 */

     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subprjid_cursor IN (    select id from Prj_ProjectInfo where ( manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	prjid_1 :=subprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 3);
		end if;
	end loop;



    /* 作为项目管理员能看到的项目4 */
    for roleprjid_cursor IN (   select distinct t1.id from Prj_ProjectInfo  t1, HrmRoleMembers_Tri  t2  where t2.roleid=9 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	prjid_1:=roleprjid_cursor.id;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1;
        if countrec = 0 then
		insert into temptablevaluePrj values(prjid_1, 4);
		end if;
	end loop;




    /* 由项目的共享获得的权利 1 2 */
    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 :=  shareprjid_cursor.sharelevel;
        select count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0  then

            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;



    for shareprjid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from Prj_ProjectInfo t1 ,  Prj_ShareInfo  t2,  HrmRoleMembers_Tri  t3  where  t1.id = t2.relateditemid and  t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department=departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) )

	)
	loop
	prjid_1 := shareprjid_cursor.relateditemid;
	sharelevel_1 := shareprjid_cursor.sharelevel;
        select  count(prjid) INTO countrec from temptablevaluePrj where prjid = prjid_1  ;
        if countrec = 0 then

            insert into temptablevaluePrj values(prjid_1, sharelevel_1);
        end if;
	end loop;



    /* 项目成员5 (内部用户) */
    for inuserprjid_cursor IN (    SELECT distinct t2.id FROM Prj_TaskProcess  t1,Prj_ProjectInfo  t2 WHERE  t1.hrmid =resourceid_1 and t2.id=t1.prjid and t1.isdelete<>'1' and t2.isblock='1' )
	loop
	prjid_1 :=inuserprjid_cursor.id;
        select  count(prjid) INTO countrec  from temptablevaluePrj where prjid = prjid_1 ;
        if countrec = 0  then

            insert into temptablevaluePrj values(prjid_1, 5);
        end if;
	end loop;



    /* 删除原有的与该人员相关的所有项目权 */
    delete from PrjShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allprjid_cursor IN (select * from temptablevaluePrj)
	loop
	prjid_1 := allprjid_cursor.prjid;
	sharelevel_1 := allprjid_cursor.sharelevel;
        insert into PrjShareDetail( prjid, userid, usertype, sharelevel) values(prjid_1, resourceid_1,1,sharelevel_1);
	end loop;




    /* ------- CPT 部分 ------- */


    /*  将所有的信息现放到 temptablevalueCpt 中 */
    /*  自己的资产2 */
    for cptid_cursor IN (    select id from CptCapital where resourceid = resourceid_1 )
	loop
	cptid_1 := cptid_cursor.id;
	  insert into temptablevalueCpt values(cptid_1, 2);
	end loop;





    /* 自己下级的资产1 */
    /* 查找下级 */

     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)), ',%' );

    for subcptid_cursor IN ( select id from CptCapital where ( resourceid in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	cptid_1 := subcptid_cursor.id;
        select  count(cptid) INTO countrec  from temptablevalueCpt where cptid = cptid_1;
        if countrec = 0 then
		insert into temptablevalueCpt values(cptid_1, 1);
		end if;
	end loop;



    /* 由资产的共享获得的权利 1 2 */
    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapitalShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then

            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end if;
	end loop;




    for sharecptid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CptCapital t1 ,  CptCapitalShareInfo  t2,  HrmRoleMembers_Tri  t3 , hrmdepartment  t4 where t1.id=t2.relateditemid and t3.resourceid= resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and t1.departmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.departmentid=t4.id and t4.subcompanyid1= subcompanyid_1 ) or (t3.rolelevel=2) ))
	loop
	cptid_1 := sharecptid_cursor.relateditemid;
	sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid) INTO countrec from temptablevalueCpt where cptid = cptid_1  ;
        if countrec = 0  then

            insert into temptablevalueCpt values(cptid_1, sharelevel_1);
        end    if;
	end loop;




    /* 删除原有的与该人员相关的所有资产权 */
    delete from CptShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcptid_cursor IN (select * from temptablevalueCpt)
	loop
	cptid_1 :=allcptid_cursor.cptid;
	sharelevel_1 :=allcptid_cursor.sharelevel;
        insert into CptShareDetail( cptid, userid, usertype, sharelevel) values(cptid_1, resourceid_1,1,sharelevel_1);
	end loop;




    /* ------- 客户合同部分2003-11-06杨国生 ------- */

    /* 自己下级的客户合同 3 */

    managerstr_11:=concat('%,',concat(to_char(resourceid_1), ',%' ));
    for subcontractid_cursor in
    (select id from CRM_Contract
    where (manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
    loop
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0  then
            insert into temptablevaluecontract values(contractid_1, 3);
        end if;
    end loop;

 /*  自己是 manager 的客户合同 2 */
    for contractid_cursor in
    (select id from CRM_Contract where manager = resourceid_1)
    loop
        contractid_1 := contractid_cursor.id;
        insert into temptablevaluecontract values(contractid_1, 2);
    end loop;

    /* 作为客户合同管理员能看到的 */
    for roleids_cursor in
    (select roleid from SystemRightRoles where rightid = 396)
    loop

       for rolecontractid_cursor in
       (select distinct t1.id from CRM_Contract  t1, HrmRoleMembers_Tri  t2
       where t2.roleid=contractroleid_1 and t2.resourceid=resourceid_1
       and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1 )
       or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))

         loop
	    contractid_1 := rolecontractid_cursor.id;
            select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
            if countrec = 0 then
                insert into temptablevaluecontract values(contractid_1, 2);
            else
                select sharelevel into sharelevel_1 from ContractShareDetail where contractid = contractid_1
                and userid = resourceid_1 and usertype = 1;
                if sharelevel_1 = 1 then
                     update ContractShareDetail
                     set sharelevel = 2 where contractid = contractid_1
                     and userid = resourceid_1 and usertype = 1;
                end if;
            end if;
         end loop;

    end loop;

      /* 由客户合同的共享获得的权利 1 2 */
    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel from Contract_ShareInfo  t2
     where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)
     or ( t2.userid=resourceid_1 ) or (t2.departmentid=departmentid_1 and t2.seclevel<=seclevel_1)))
    loop
        contractid_1 := sharecontractid_cursor.relateditemid;
        sharelevel_1 := sharecontractid_cursor.sharelevel;
        select count(contractid) into countrec from temptablevaluecontract where contractid = contractid_1;
        if countrec = 0 then
            insert into temptablevaluecontract values(contractid_1, sharelevel_1);
        else
            select sharelevel into sharelevel_Temp from temptablevaluecontract
            where contractid = contractid_1;
            if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
               update temptablevaluecontract set sharelevel = sharelevel_1
               where contractid = contractid_1;
            end if;
         end if;
    end loop;



    for sharecontractid_cursor in
    (select distinct t2.relateditemid , t2.sharelevel
    from CRM_Contract t1 ,  Contract_ShareInfo  t2,  HrmRoleMembers_Tri  t3
    where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1
    and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel
    and t2.seclevel<=seclevel_1
    and ( (t2.rolelevel=0  and t1.department=departmentid_1)
    or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ))

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

    managerstr_11:= concat('%,',concat(to_char(resourceid_1),',%'));


    for subcontractid_cursor in
    (select t2.id from CRM_CustomerInfo t1, CRM_Contract t2 where ( t1.manager in
    (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11) )
    and (t2.crmId = t1.id))
    loop
        contractid_1 := subcontractid_cursor.id;
        select count(contractid) into countrec from temptablevaluecontract
        where contractid = contractid_1;
        if countrec = 0  then
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

    end if;

end if ;
end;
/
