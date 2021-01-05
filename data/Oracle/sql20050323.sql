CREATE or REPLACE TRIGGER Tri_URole_workflow_createlist
after insert or update or delete ON HrmRoleMembers
for each row
Declare workflowid_1 integer;
        type_1 integer;
        objid_1 integer;
        level_n_1 integer;
        level2_n_1 integer;
        userid_1 integer;
        current_date char(10);
        current_time char(8);
        agenter_id integer;
        begin_date char(10);
        begin_time char(8);
        end_date char(10);
        end_time char(8);
        isbeAgent integer;

begin
    select subStr(to_char(sysdate,'hh24:mm:ss'),1,8) into current_time from dual;
    select subStr(to_char(sysdate,'yyyy-mm-dd'),1,10) into  current_date from dual;
    
    delete from workflow_createrlist where userid <> -1 and userid <> -2 and usertype = 0 ;
    
    for all_cursor in(select workflowid,type,objid,level_n,level2_n from workflow_flownode t1,workflow_nodegroup t2,workflow_groupdetail t3 where t1.nodetype='0' and t1.nodeid = t2.nodeid and t2.id = t3.groupid)
    loop
        workflowid_1 := all_cursor.workflowid ;
        type_1 := all_cursor.type ;
        objid_1 := all_cursor.objid ;
        level_n_1 := all_cursor.level_n ;
        level2_n_1 := all_cursor.level2_n ;
        if type_1=1
        then
            for detail_cursor in(select id from HrmResource where departmentid = objid_1 and seclevel >= level_n_1 and seclevel <= level2_n_1)
            loop
                userid_1 := detail_cursor.id ;
                isbeAgent:=0;
                for agent_cursor in(select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=workflowid_1 and beagenterId=userid_1 and isCreateAgenter=1)
                loop
                    agenter_id := agent_cursor.agenterId ;
                    begin_date := agent_cursor.beginDate ;
                    begin_time := agent_cursor.beginTime ;
                    end_date := agent_cursor.endDate ;
                    end_time := agent_cursor.endTime ;
                    isbeAgent:=1;
                    if (begin_date is not null) then
                        if (current_date<begin_date) then
                           isbeAgent:=0;
                        end if;
                        if (current_date=begin_date and begin_time is not null) then
                                if(current_time<begin_time) then
                                   isbeAgent:=0;
                                end if;
                        end if;
                    end if;
                    if (end_date is not null) then
                        if (current_date>end_date) then
                            isbeAgent:=0;
                        end if;
                        if (current_date=end_date and end_time is not null) then
                                if(current_time>end_time) then 
                                  isbeAgent:=0;
                                end if;
                        end if;
                    end if;
                end loop;

                if isbeAgent=1 then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id,0,1);
                end if;

                insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,userid_1,0,0);
            end loop ;
        end if;

        if type_1=2
        then
            for detail_cursor in(SELECT resourceid as id FROM HrmRoleMembers_Tri where roleid =  objid_1 and rolelevel >=level_n_1)
            loop
                userid_1 :=detail_cursor.id;
                isbeAgent :=0;
                for agent_cursor in (select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=workflowid_1 and beagenterId=userid_1 and isCreateAgenter=1)
                loop
                    agenter_id :=agent_cursor.agenterId;
                    begin_date :=agent_cursor.beginDate;
                    begin_time :=agent_cursor.beginTime;
                    end_date :=agent_cursor.endDate;
                    end_time :=agent_cursor.endTime;
                    isbeAgent:=1;
                    if (begin_date is not null) then
                        if (current_date<begin_date)then
                            isbeAgent:=0;
                        end if;
                        if (current_date=begin_date and begin_time is not null) then
                                if(current_time<begin_time) then
                                    isbeAgent:=0;
                                 end if;
                        end if;
                    end if;
                    if (end_date is not null) then
                        if (current_date>end_date) then
                           isbeAgent:=0;
                        end if;
                        if (current_date=end_date and end_time is not null) then
                            if(current_time>end_time) then
                                    isbeAgent:=0;
                            end if;
                        end if;
                    end if;
                end loop;
                if isbeAgent=1 then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id,0,1);
                end if;
                insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,userid_1,0,0);
            end loop;
        end if;

        if type_1=3
        then
            isbeAgent:=0;
            for agent_cursor in(select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=workflowid_1 and beagenterId=objid_1 and isCreateAgenter=1)
            loop
                agenter_id :=agent_cursor.agenterId;
                begin_date :=agent_cursor.beginDate;
                begin_time :=agent_cursor.beginTime;
                end_date :=agent_cursor.endDate;
                end_time :=agent_cursor.endTime;
                isbeAgent:=1;
                if (begin_date is not null) then
                    if (current_date<begin_date)then
                        isbeAgent:=0;
                    end if;
                    if (current_date=begin_date and begin_time is not null) then
                        if(current_time<begin_time) then
                           isbeAgent:=0;
                        end if;
                    end if;
                end if;
                if (end_date is not null) then
                    if (current_date>end_date) then
                        isbeAgent:=0;
                    end if;
                    if (current_date=end_date and end_time is not null) then
                         if(current_time>end_time) then
                             isbeAgent:=0;
                         end if;
                    end if;
                 end if;
            end loop;

                if isbeAgent=1 then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id,0,1);
                end if;
            insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,userid_1,0,0);
        end if;

        if type_1=30
        then
            for detail_cursor in(select id from HrmResource where subcompanyid1 = objid_1 and seclevel >= level_n_1 and seclevel <= level2_n_1)
            loop
                userid_1 :=detail_cursor.id;
                isbeAgent:=0;
                for agent_cursor in(select agenterId ,beginDate ,beginTime ,endDate ,endTime from Workflow_Agent where workflowId=workflowid_1 and beagenterId=userid_1 and isCreateAgenter=1)
                loop
                    agenter_id :=agent_cursor.agenterId;
                    begin_date :=agent_cursor.beginDate;
                    begin_time :=agent_cursor.beginTime;
                    end_date :=agent_cursor.endDate;
                    end_time :=agent_cursor.endTime;
                    isbeAgent:=1;
                    if (begin_date is not null) then
                        if (current_date<begin_date) then
                            isbeAgent:=0;
                        end if;
                        if (current_date=begin_date and begin_time is not null) then
                            if(current_time<begin_time) then
                                   isbeAgent:=0;
                            end if;
                        end if;
                    end if;
                    if (end_date is not null) then
                        if (current_date>end_date) then
                           isbeAgent:=0;
                        end if;
                        if (current_date=end_date and end_time is not null) then
                            if(current_time>end_time) then
                                isbeAgent:=0;
                            end if;
                        end if;
                    end if;
                end loop;

                if isbeAgent=1 then
                    insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,agenter_id,0,1);
                end if;
                insert into workflow_createrlist(workflowid,userid,usertype,isagenter) values(workflowid_1,userid_1,0,0);
            end loop;
        end if;
    end loop;
end;
/


CREATE or REPLACE TRIGGER Tri_Update_HrmRoleMembersShare
after insert or update or delete ON  HrmRoleMembers
FOR each row
Declare roleid_1 integer;
        resourceid_1 integer;
        oldrolelevel_1 char(1);
        rolelevel_1 char(1);
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
        oldroleid_1 integer;
        oldresourceid_1 integer;
        contractid_1	 integer;/*2003-11-06杨国生*/
        contractroleid_1 integer ;  /*2003-11-06杨国生*/
        sharelevel_Temp integer ;  /*2003-11-06杨国生*/
        workPlanId_1 integer; /* added by lupeng 2004-07-22 */ 
        m_countworkid integer;  /* 2004-10-27 dongyuqin*/
/* 某一个人加入一个角色或者在角色中的级别升高进行处理,这两种情况都是增加了共享的范围,不需要删除
原有共享信息,只需要判定增加的部分, 对于在角色中级别的降低或者删除某一个成员,只能删除全部共享细节,从作人力资源一个
人的部门或者安全级别改变的操作 */
begin
countdelete := :old.id;
countinsert := :new.id;
oldrolelevel_1 := :old.rolelevel;
oldroleid_1 :=  :old.roleid; 
oldresourceid_1 := :old.resourceid;

if countdelete is null then
    countdelete := 0 ;
else 
    if countinsert is null then
        countinsert := 0 ;
    end if ;
end if ;


if countinsert > 0 then
	roleid_1 := :new.roleid;
	resourceid_1 := :new.resourceid;
	rolelevel_1 := :new.rolelevel;
else 
	roleid_1 := :old.roleid;
	resourceid_1 := :old.resourceid;
	rolelevel_1 := :old.rolelevel;
end if;

if resourceid_1 = 1 then 
    return ;
end if ;

/* 如果有删除原有数据，则将许可表中的权限许可数减一 */
if (countdelete > 0) then
    select seclevel into seclevel_1  from hrmresource where id = oldresourceid_1 ;
    if seclevel_1 is not null then
        Doc_DirAcl_DUserP_RoleChange (oldresourceid_1, oldroleid_1, oldrolelevel_1, seclevel_1);
    end if;
end if;
/* 如果有增加新数据，则将许可表中的权限许可数加一 */
if (countinsert > 0) then
    select  seclevel into seclevel_1 from hrmresource where id = resourceid_1;
    if seclevel_1 is not null then
        Doc_DirAcl_GUserP_RoleChange (resourceid_1, roleid_1, rolelevel_1, seclevel_1);
    end if;
end if;


if ( countinsert >0 and ( countdelete = 0 or rolelevel_1  > oldrolelevel_1 ) )  then   

    select  departmentid ,  subcompanyid1 ,  seclevel INTO  departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null  then
	departmentid_1 := 0;
	end if;
    if subcompanyid_1 is null  then
	subcompanyid_1 := 0;
	end if;


    if rolelevel_1 = '2'   then    /* 新的角色级别为总部级 */
     

	/* ------- DOC 部分 ------- */

        for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
        
        loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel;
            select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then            
                insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);
            else if sharelevel_1 = 2 then            
                update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
				end if;
			end if;
        end loop;



	/* ------- CRM 部分 ------- */

		for sharecrmid_cursor IN (     select distinct relateditemid , sharelevel from CRM_ShareInfo where roleid = roleid_1 and rolelevel <= rolelevel_1 and seclevel <= seclevel_1 )
		loop
		crmid_1:=sharecrmid_cursor.relateditemid;
		sharelevel_1 := sharecrmid_cursor.sharelevel;
			select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
			if countrec = 0  then
			
				insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
			
			else if sharelevel_1 = 2  then
			
				update CrmShareDetail set sharelevel = 2 where crmid=crmid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
           /* added by lupeng 2004-07-22 for customer contact work plan */	
        
	    for ccwp_cursor in(
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
	      loop
               workPlanId_1 := ccwp_cursor.id ;
                 select count(workid) into m_countworkid  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1;
	    	 if m_countworkid  = 0 then
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			workPlanId_1, resourceid_1, 1, 1);
                 end if;
           end loop;
	   /* end */                                            
           
              
		end loop;
	   


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
	    for sharewp_cursor in(
         SELECT  DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE roleId = roleid_1 AND roleLevel <= rolelevel_1 AND securityLevel <= seclevel_1 )
         loop
         workPlanId_1 := sharewp_cursor.workPlanId;
         sharelevel_1 := sharewp_cursor.shareLevel;
       
	     SELECT COUNT(workid) into countrec FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1; 
             IF  countrec = 0 then 
                 INSERT INTO WorkPlanShareDetail VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
             ELSE IF sharelevel_1 = 2 then
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1 ;/* 共享是可以编辑, 则都修改原有记录 */   
                end if;
             end if;
          end loop;
	 /* end */
              
          
    end if;
    
        
    if rolelevel_1 = '1' then        /* 新的角色级别为分部级 */
    

	/* ------- DOC 部分 ------- */
		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2 ,
		hrmdepartment  t4 where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and
		t2.seclevel <= seclevel_1 and t1.docdepartmentid=t4.id and t4.subcompanyid1= subcompanyid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid;
			sharelevel_1 := sharedocid_cursor.sharelevel;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid = resourceid_1 and usertype = 1 ; 
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and usertype = 1  ;/* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;


	/* ------- CRM 部分 ------- */
       for sharecrmid_cursor IN (      select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 , hrmdepartment  t4 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = t4.id and t4.subcompanyid1= subcompanyid_1)
	   loop
	   crmid_1 :=sharecrmid_cursor.relateditemid;
	   sharelevel_1 :=sharecrmid_cursor.sharelevel;
            select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
              
           /* added by lupeng 2004-07-22 for customer contact work plan */	
	    for ccwp_cursor in(
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
	    loop
            workPlanId_1 := ccwp_cursor.id ;
                select count(workid) into m_countworkid  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 
			AND userid = resourceid_1 AND usertype = 1;	
                if  m_countworkid = 0 then 
		        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			workPlanId_1, resourceid_1, 1, 1);
		     end if;
        end loop;
	   /* end */      
	   end loop;

  

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
	 for sharewp_cursor in(
         SELECT DISTINCT t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = roleid_1 AND t2.roleLevel <= rolelevel_1 AND t2.securityLevel <= seclevel_1 AND t1.subcompanyId = subcompanyid_1)
         loop
         workPlanId_1 := sharewp_cursor.workPlanId;
         sharelevel_1 := sharewp_cursor.shareLevel;
	     SELECT COUNT(workid) into countrec  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1  ;
             IF (countrec = 0) then 
                 INSERT INTO WorkPlanShareDetail VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
             ELSE IF (sharelevel_1 = 2) then 
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
             end if;
             end if;
         end loop;         
      
	 /* end */ 
    end if;
        
    
    if rolelevel_1 = '0'     then     /* 为新建时候设定级别为部门级 */
    

        /* ------- DOC 部分 ------- */

		for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2
		where t1.id=t2.docid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <=
		seclevel_1 and t1.docdepartmentid= departmentid_1)
		
		loop 
			docid_1 := sharedocid_cursor.docid ;
			sharelevel_1 := sharedocid_cursor.sharelevel ;
			select  count(docid) INTO countrec  from docsharedetail where docid = docid_1 and userid =
			resourceid_1 and usertype = 1  ;
			if countrec = 0  then            
				insert into docsharedetail values(docid_1, resourceid_1, 1, sharelevel_1);            
			else if sharelevel_1 = 2  then            
				update docsharedetail set sharelevel = 2 where docid=docid_1 and userid = resourceid_1 and
				usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
			end if;
			end if;
		end loop;
	
	/* ------- CRM 部分 ------- */

		for sharecrmid_cursor IN (select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2 where t1.id=t2.relateditemid and t2.roleid = roleid_1 and t2.rolelevel <= rolelevel_1 and t2.seclevel <= seclevel_1 and t1.department = departmentid_1)
		loop
		crmid_1 :=sharecrmid_cursor.relateditemid;
		sharelevel_1 :=sharecrmid_cursor.sharelevel;
          select  count(crmid) INTO countrec  from CrmShareDetail where crmid = crmid_1 and userid = resourceid_1 and usertype = 1  ;
            if countrec = 0  then
            
                insert into CrmShareDetail values(crmid_1, resourceid_1, 1, sharelevel_1);
            
            else if sharelevel_1 = 2  then
            
                update CrmShareDetail set sharelevel = 2 where crmid = crmid_1 and userid = resourceid_1 and usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
			end if;
              
                /* added by lupeng 2004-07-22 for customer contact work plan */	
	    for ccwp_cursor in(
	    SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
	    loop
            workPlanId_1 := ccwp_cursor.id ;
            select count(workid) into m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1 
			AND userid = resourceid_1 AND usertype = 1;
            if m_countworkid =0 then
		INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
			workPlanId_1, resourceid_1, 1, 1);
	    end if;
            end loop;
	   /* end */       
 end loop;
        
  

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
	 for sharewp_cursor in (
         SELECT  t2.workPlanId, t2.shareLevel FROM WorkPlan t1, WorkPlanShare t2 WHERE t1.id = t2.workPlanId AND t2.roleId = roleid_1 AND t2.roleLevel <= rolelevel_1 AND t2.securityLevel <= seclevel_1 AND t1.deptId = departmentid_1)
         loop
         workPlanId_1 := sharewp_cursor.workPlanId;
         sharelevel_1 := sharewp_cursor.shareLevel;
	     SELECT COUNT(workid) into countrec  FROM WorkPlanShareDetail WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1  ;
             IF (countrec = 0) then 
                 INSERT INTO WorkPlanShareDetail VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
             ELSE IF (sharelevel_1 = 2) then 
                 UPDATE WorkPlanShareDetail SET sharelevel = 2 WHERE workid = workPlanId_1 AND userid = resourceid_1 AND usertype = 1 ; /* 共享是可以编辑, 则都修改原有记录 */   
            end if;
             end if;
          end loop;
	 /* end */

    end if;
       

else 

if ( countdelete > 0 and ( countinsert = 0 or rolelevel_1  < oldrolelevel_1 ) )  then 
/* 当为删除或者级别降低 */


    select  departmentid ,  subcompanyid1 ,  seclevel INTO departmentid_1 ,subcompanyid_1 ,seclevel_1 
    from hrmresource where id = resourceid_1 ;
    if departmentid_1 is null then
	departmentid_1 := 0;
    end if;
	if subcompanyid_1 is null then
	subcompanyid_1 := 0;
	end if;
	
    /* 删除原有的该人的所有文档共享信息 */
	delete from DocShareDetail where userid = resourceid_1 and usertype = 1;


    /*  将所有的信息现放到 temptablevalue 中 */
    /*  自己创建的或者是 owner 的文章可以编辑 */
    for docid_cursor IN (select distinct id from DocDetail where ( doccreaterid = resourceid_1 or ownerid = resourceid_1 ) and usertype= '1')
    
    loop 
		docid_1 := docid_cursor.id;
        insert into temptablevalue values(docid_1, 2);
    end loop;



    /* 自己下级的文档 */
    /* 查找下级 */
    managerstr_11 := concat( concat('%,' , to_char(resourceid_1)) , ',%' );

    for subdocid_cursor IN (select distinct id from DocDetail where ( doccreaterid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) or ownerid in (select distinct id from
	HrmResource where concat(',' , managerstr) like managerstr_11 ) ) and usertype= '1')
    
    loop
		docid_1 := subdocid_cursor.id;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1;
        if countrec = 0 then
		insert into temptablevalue values(docid_1, 1);
		end if;
    end loop;
         
         


    /* 由文档的共享获得的权利 , 将共享分成两个部分, 角色共享一个部分.其它一个部分,否则查询太慢*/
    for sharedocid_cursor IN (select distinct docid , sharelevel from DocShare  where  (foralluser=1 and
	seclevel<= seclevel_1 )  or ( userid= resourceid_1 ) or (departmentid= departmentid_1 and seclevel<=
	seclevel_1 ))
    
    loop 
		docid_1 :=sharedocid_cursor.docid;
		sharelevel_1 :=sharedocid_cursor.sharelevel;
        select count(docid) INTO countrec  from temptablevalue where docid = docid_1  ;
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */
        end if;
		end if;
    end loop;

    for sharedocid_cursor IN (select distinct t2.docid , t2.sharelevel from DocDetail t1 ,  DocShare  t2, 
	HrmRoleMembers_Tri  t3 , hrmdepartment t4 where t1.id=t2.docid and t3.resourceid= resourceid_1 and
	t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<= seclevel_1 and ( (t2.rolelevel=0  and
	t1.docdepartmentid= departmentid_1 ) or (t2.rolelevel=1 and t1.docdepartmentid=t4.id and t4.subcompanyid1=
	subcompanyid_1 ) or (t3.rolelevel=2) ))

    loop
		docid_1 :=sharedocid_cursor.docid ;
		sharelevel_1 := sharedocid_cursor.sharelevel ;
        select  count(docid) INTO countrec  from temptablevalue where docid = docid_1 ; 
        if countrec = 0  then        
            insert into temptablevalue values(docid_1, sharelevel_1);        
        else if sharelevel_1 = 2  then        
            update temptablevalue set sharelevel = 2 where docid=docid_1; /* 共享是可以编辑, 则都修改原有记录    */
			end if;
		end if;
    end loop ;

    /* 将临时表中的数据写入共享表 */
    for alldocid_cursor IN (select * from temptablevalue)    
    loop 
		docid_1 := alldocid_cursor.docid;
		sharelevel_1 := alldocid_cursor.sharelevel;
        insert into docsharedetail values(docid_1, resourceid_1,1,sharelevel_1);
    end loop;

    /* ------- CRM  部分 ------- */


    /* 删除原有的该人的所有客户共享信息 */
	delete from CrmShareDetail where userid = resourceid_1 and usertype = 1;



    /*  将所有的信息现放到 temptablevaluecrm 中 */
    /*  自己是 manager 的客户 2 */
    for crmid_cursor IN (   select id from CRM_CustomerInfo where manager = resourceid_1 )
	loop
	crmid_1 := crmid_cursor.id;
	insert into temptablevaluecrm values(crmid_1, 2);
	end loop;
 


    /* 自己下级的客户 3 */
    /* 查找下级 */
     
     managerstr_11 := concat(concat('%,' , to_char(resourceid_1)) , ',%' );

    for subcrmid_cursor IN (  select id from CRM_CustomerInfo where ( manager in (select distinct id from HrmResource where concat(',',managerstr) like managerstr_11 ) ))
	loop
	crmid_1 :=  subcrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0  then
		insert into temptablevaluecrm values(crmid_1, 3);
		end if;
	end loop;
  

 
    /* 作为crm管理员能看到的客户 */
    for rolecrmid_cursor IN (   select distinct t1.id from CRM_CustomerInfo  t1, HrmRoleMembers_Tri  t2  where t2.roleid=8 and t2.resourceid= resourceid_1 and (t2.rolelevel=2 or (t2.rolelevel=0 and t1.department=departmentid_1) or  (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1 )))
	loop
	crmid_1 := rolecrmid_cursor.id;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1;
        if countrec = 0 then
		insert into temptablevaluecrm values(crmid_1, 4);
		end if;
	end loop;



    /* 由客户的共享获得的权利 1 2 */
    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_ShareInfo  t2  where  ( (t2.foralluser=1 and t2.seclevel<=seclevel_1)  or ( t2.userid=resourceid_1 ) or (t2.departmentid = departmentid_1 and t2.seclevel<=seclevel_1)  ))
	loop
	crmid_1:= sharecrmid_cursor.relateditemid;
	sharelevel_1 :=sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;






    for sharecrmid_cursor IN (    select distinct t2.relateditemid , t2.sharelevel from CRM_CustomerInfo t1 ,  CRM_ShareInfo  t2,  HrmRoleMembers_Tri  t3  where  t1.id = t2.relateditemid and t3.resourceid=resourceid_1 and t3.roleid=t2.roleid and t3.rolelevel>=t2.rolelevel and t2.seclevel<=seclevel_1 and ( (t2.rolelevel=0  and t1.department = departmentid_1) or (t2.rolelevel=1 and t1.subcompanyid1=subcompanyid_1) or (t3.rolelevel=2) ) )
	loop
	crmid_1 :=sharecrmid_cursor.relateditemid;
	sharelevel_1 := sharecrmid_cursor.sharelevel;
        select  count(crmid) INTO countrec  from temptablevaluecrm where crmid = crmid_1  ;
        if countrec = 0  then
        
            insert into temptablevaluecrm values(crmid_1, sharelevel_1);
        end if;
	end loop;




    /* 将临时表中的数据写入共享表 */
    for allcrmid_cursor IN (    select * from temptablevaluecrm)
	loop
	crmid_1 :=allcrmid_cursor.crmid;
	sharelevel_1  := allcrmid_cursor.sharelevel;
        insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(crmid_1, resourceid_1,1,sharelevel_1);
	
/* added by lupeng 2004-07-22 for customer contact work plan */	
        for ccwp_cursor in(
        SELECT id FROM WorkPlan WHERE type_n = '3' AND crmid = to_char(crmid_1))
        loop
        workPlanId_1 := ccwp_cursor.id ;
            select count(workid) into m_countworkid FROM WorkPlanShareDetail WHERE workid = workPlanId_1 
			AND userid = resourceid_1 AND usertype = 1;
            if m_countworkid = 0 then
	    INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (
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
          insert into temptablevaluecontract values(contractid_1, 1);
        end loop;


    /* 删除原有的与该人员相关的所有权 */
    delete from ContractShareDetail where userid = resourceid_1 and usertype = 1;

    /* 将临时表中的数据写入共享表 */
    for allcontractid_cursor in
    (select * from temptablevaluecontract)
    loop
        insert into ContractShareDetail( contractid, userid, usertype, sharelevel) 
        values(contractid_1, resourceid_1,1,sharelevel_1);
    end loop;
    
    end if; 
    
    /* for work plan */ 
    /* added by lupeng 2004-07-22 */
    /* delete all the work plan share info of this user */
    /* DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1 */

    /* define a temporary table */
    
    /* write the data to the temporary table */
    /* a. the creater of the work plan is this user */
    for  creater_cursor in (SELECT id FROM WorkPlan WHERE createrid = resourceid_1)
    loop
         workPlanId_1 := creater_cursor.id;
        INSERT INTO TmpTableValueWP VALUES (workPlanId_1, 2);
    end loop;

     /* b. the creater of the work plan is my underling */     
    managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%' );
    for  underling_cursor in(
    SELECT id FROM WorkPlan WHERE (createrid IN (SELECT DISTINCT id FROM HrmResource WHERE concat(',', MANAGERSTR) LIKE managerstr_11)))
    loop
    workPlanId_1 := underling_cursor.id;

        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1;
        IF (countrec = 0)  then 
        INSERT INTO TmpTableValueWP VALUES (workPlanId_1, 1);
        end if;
     end loop;

     
     /* c. in the work plan share info */
    for sharewp_cursor in(
    SELECT DISTINCT workPlanId, shareLevel FROM WorkPlanShare WHERE ((forAll = 1 AND securityLevel <= seclevel_1) OR (userId = resourceid_1) OR (deptId = departmentid_1 AND securityLevel <= seclevel_1)))
    loop
    workPlanId_1 := sharewp_cursor.workPlanId;
    sharelevel_1 := sharewp_cursor.shareLevel;
        SELECT COUNT(workPlanId) into countrec   FROM TmpTableValueWP WHERE workPlanId = workPlanId_1  ;
        IF (countrec = 0) then
            INSERT INTO TmpTableValueWP VALUES (workPlanId_1, sharelevel_1);
        end if;
     end loop;

    for sharewp_cursor in(
    SELECT DISTINCT t2.workPlanId as t2workPlanId, t2.shareLevel as t2shareLevel FROM WorkPlan t1, WorkPlanShare t2, HrmRoleMembers_Tri t3 WHERE t1.id = t2.workPlanId AND t3.resourceid = resourceid_1 AND t3.roleid = t2.roleId AND t3.rolelevel >= t2.roleLevel AND t2.securityLevel <= seclevel_1 AND ((t2.roleLevel = 0  AND t1.deptId = departmentid_1) OR (t2.roleLevel = 1 AND t1.subcompanyId = subcompanyid_1) OR (t3.rolelevel = 2)))
    loop
    workPlanId_1 := sharewp_cursor.t2workPlanId;
    sharelevel_1 := sharewp_cursor.t2shareLevel;
        SELECT COUNT(workPlanId) into countrec  FROM TmpTableValueWP WHERE workPlanId = workPlanId_1 ; 
        IF (countrec = 0 ) then
            INSERT INTO TmpTableValueWP VALUES (workPlanId_1, sharelevel_1);
        end if;
    end loop;
    
  /* write the temporary table data to the share detail table */
    for  allwp_cursor in(SELECT * FROM TmpTableValueWP)
    loop
    workPlanId_1 := allwp_cursor.workPlanId;
    sharelevel_1 := allwp_cursor.shareLevel;
        INSERT INTO WorkPlanShareDetail (workid, userid, usertype, sharelevel) VALUES (workPlanId_1, resourceid_1, 1, sharelevel_1);
    end loop;
    /* end */
    
    /* 结束角色删除或者级别降低的处理 */
end if ;
end ;
/
