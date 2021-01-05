create or replace procedure HrmResourceShare(resourceid_1      integer,
                                             departmentid_1    integer,
                                             subcompanyid_1    integer,
                                             managerid_1       integer,
                                             seclevel_1        integer,
                                             managerstr_1      varchar2,
                                             olddepartmentid_1 integer,
                                             oldsubcompanyid_1 integer,
                                             oldmanagerid_1    integer,
                                             oldseclevel_1     integer,
                                             oldmanagerstr_1   varchar2,
                                             flag_1            integer,
                                             flag              out integer,
                                             msg               out varchar2,
                                             thecursor         IN OUT cursor_define.weavercursor) AS
  supresourceid_1        integer;
  docid_1                integer;
  crmid_1                integer;
  prjid_1                integer;
  cptid_1                integer;
  sharelevel_1           integer;
  countrec               integer;
  managerstr_11          varchar2(500);
  mainid_1               integer;
  subid_1                integer;
  secid_1                integer;
  members_1              varchar2(200);
  contractid_1           integer;
  contractroleid_1       integer;
  sharelevel_Temp        integer;
  workPlanId_1           integer;
  m_countworkid          integer;
  docid_2                integer;
  sharelevel_2           integer;
  countrec_2             integer;
  managerId_2s_2         varchar2(50);
  sepindex_2             integer;
  managerId_2            varchar2(200);
  tempDownOwnerId_2      integer;
  oldsubcompanyid_1_this integer;
begin
  if oldsubcompanyid_1 is null then
    oldsubcompanyid_1_this := 0;
  else
    oldsubcompanyid_1_this := oldsubcompanyid_1;
  end if;
  if (seclevel_1 <> oldseclevel_1) then
    update HrmResource_Trigger
       set seclevel = seclevel_1
     where id = resourceid_1;
  end if;
  if (departmentid_1 <> olddepartmentid_1) then
    update HrmResource_Trigger
       set departmentid = departmentid_1
     where id = resourceid_1;
  end if;
  if (managerstr_1 <> oldmanagerstr_1) then
    update HrmResource_Trigger
       set managerstr = managerstr_1
     where id = resourceid_1;
  end if;
  if (subcompanyid_1 <> oldsubcompanyid_1_this) then
    update HrmResource_Trigger
       set subcompanyid1 = subcompanyid_1
     where id = resourceid_1;
  end if;
  
  if ((flag_1 = 1 and (departmentid_1 <> olddepartmentid_1 or
     oldsubcompanyid_1_this <> subcompanyid_1 or
     seclevel_1 <> oldseclevel_1)) or flag_1 = 0) then
    


    managerstr_11 := Concat('%,', Concat(to_char(resourceid_1), ',%'));
    for subcontractid_cursor in (select id
                                   from CRM_Contract
                                  where (manager in
                                        (select distinct id
                                            from HrmResource_Trigger
                                           where concat(',', managerstr) like
                                                 managerstr_11))) loop
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract values (contractid_1, 3);
      end if;
    end loop;
    
    for contractid_cursor in (select id
                                from CRM_Contract
                               where manager = resourceid_1) loop
      contractid_1 := contractid_cursor.id;
      insert into temptablevaluecontract values (contractid_1, 2);
    end loop;
    
    for roleids_cursor in (select roleid
                             from SystemRightRoles
                            where rightid = 396) loop
      for rolecontractid_cursor in (select distinct t1.id
                                      from CRM_Contract   t1,
                                           hrmrolemembers t2
                                     where t2.roleid = contractroleid_1
                                       and t2.resourceid = resourceid_1
                                       and (t2.rolelevel = 2 or
                                           (t2.rolelevel = 0 and
                                           t1.department = departmentid_1) or
                                           (t2.rolelevel = 1 and
                                           t1.subcompanyid1 =
                                           subcompanyid_1))) loop
        contractid_1 := rolecontractid_cursor.id;
        select count(contractid)
          into countrec
          from temptablevaluecontract
         where contractid = contractid_1;
        if countrec = 0 then
          insert into temptablevaluecontract values (contractid_1, 2);
        else
          select sharelevel
            into sharelevel_1
            from ContractShareDetail
           where contractid = contractid_1
             and userid = resourceid_1
             and usertype = 1;
          if sharelevel_1 = 1 then
            update ContractShareDetail
               set sharelevel = 2
             where contractid = contractid_1
               and userid = resourceid_1
               and usertype = 1;
          end if;
        end if;
      end loop;
    end loop;
    
    for sharecontractid_cursor in (select distinct t2.relateditemid,
                                                   t2.sharelevel
                                     from Contract_ShareInfo t2
                                    where ((t2.foralluser = 1 and
                                          t2.seclevel <= seclevel_1) or
                                          (t2.userid = resourceid_1) or
                                          (t2.departmentid = departmentid_1 and
                                          t2.seclevel <= seclevel_1))) loop
      contractid_1 := sharecontractid_cursor.relateditemid;
      sharelevel_1 := sharecontractid_cursor.sharelevel;
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract
        values
          (contractid_1, sharelevel_1);
      else
        select sharelevel
          into sharelevel_Temp
          from temptablevaluecontract
         where contractid = contractid_1;
        if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
          update temptablevaluecontract
             set sharelevel = sharelevel_1
           where contractid = contractid_1;
        end if;
      end if;
    end loop;
    
    for sharecontractid_cursor in (select distinct t2.relateditemid,
                                                   t2.sharelevel
                                     from CRM_Contract       t1,
                                          Contract_ShareInfo t2,
                                          HrmRoleMembers     t3
                                    where t1.id = t2.relateditemid
                                      and t3.resourceid = resourceid_1
                                      and t3.roleid = t2.roleid
                                      and t3.rolelevel >= t2.rolelevel
                                      and t2.seclevel <= seclevel_1
                                      and ((t2.rolelevel = 0 and
                                          t1.department = departmentid_1) or
                                          (t2.rolelevel = 1 and
                                          t1.subcompanyid1 =
                                          subcompanyid_1) or
                                          (t3.rolelevel = 2))) loop
      contractid_1 := sharecontractid_cursor.relateditemid;
      sharelevel_1 := sharecontractid_cursor.sharelevel;
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract
        values
          (contractid_1, sharelevel_1);
      else
        select sharelevel
          into sharelevel_Temp
          from temptablevaluecontract
         where contractid = contractid_1;
        if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
          update temptablevaluecontract
             set sharelevel = sharelevel_1
           where contractid = contractid_1;
        end if;
      end if;
    end loop;
    
    managerstr_11 := concat('%,', concat(to_char(resourceid_1), ',%'));
    for subcontractid_cursor in (select t2.id
                                   from CRM_CustomerInfo t1, CRM_Contract t2
                                  where (t1.manager in
                                        (select distinct id
                                            from HrmResource_Trigger
                                           where concat(',', managerstr) like
                                                 managerstr_11))
                                    and (t2.crmId = t1.id)) loop
      contractid_1 := subcontractid_cursor.id;
      select count(contractid)
        into countrec
        from temptablevaluecontract
       where contractid = contractid_1;
      if countrec = 0 then
        insert into temptablevaluecontract values (contractid_1, 1);
      end if;
    end loop;
    
    for contractid_cursor in (select t2.id
                                from CRM_CustomerInfo t1, CRM_Contract t2
                               where (t1.manager = resourceid_1)
                                 and (t2.crmId = t1.id)) loop
      contractid_1 := contractid_cursor.id;
      insert into temptablevaluecontract values (contractid_1, 1);
    end loop;
    
    delete from ContractShareDetail
     where userid = resourceid_1
       and usertype = 1;
       
    for allcontractid_cursor in (select * from temptablevaluecontract) loop
      contractid_1 := allcontractid_cursor.contractid;
      sharelevel_1 := allcontractid_cursor.sharelevel;
      insert into ContractShareDetail
        (contractid, userid, usertype, sharelevel)
      values
        (contractid_1, resourceid_1, 1, sharelevel_1);
    end loop;
    
    
    
    for creater_cursor in (SELECT id
                             FROM WorkPlan
                            WHERE createrid = resourceid_1) loop
      workPlanId_1 := creater_cursor.id;
      INSERT INTO TmpTableValueWP
        (workPlanId, shareLevel)
      VALUES
        (workPlanId_1, 2);
    end loop;
    managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%');
    for underling_cursor in (SELECT id
                               FROM WorkPlan
                              WHERE (createrid IN
                                    (SELECT DISTINCT id
                                        FROM HrmResource_Trigger
                                       WHERE concat(',', MANAGERSTR) LIKE
                                             managerstr_11))) loop
      workPlanId_1 := underling_cursor.id;
      SELECT COUNT(workPlanId)
        into countrec
        FROM TmpTableValueWP
       WHERE workPlanId = workPlanId_1;
      IF (countrec = 0) then
        INSERT INTO TmpTableValueWP
          (workPlanId, shareLevel)
        VALUES
          (workPlanId_1, 1);
      end if;
    end loop;

  end if;
  
  
  
  if (flag_1 = 1 and managerstr_1 <> oldmanagerstr_1 and
     length(managerstr_1) > 1) then
     
    managerId_2 := concat(',', managerstr_1);
    update shareinnerdoc
       set content = managerid_1
     where srcfrom = 81
       and opuser = resourceid_1;
       



    for supuserid_cursor in (select distinct t1.id id_1, t2.id id_2
                               from HrmResource_Trigger t1, CRM_Contract t2
                              where managerId_2 like
                                    concat('%,',
                                           concat(to_char(t1.id), ',%'))
                                and t2.manager = resourceid_1) loop
      supresourceid_1 := supuserid_cursor.id_1;
      contractid_1    := supuserid_cursor.id_2;
      select count(contractid)
        into countrec
        from ContractShareDetail
       where contractid = contractid_1
         and userid = supresourceid_1
         and usertype = 1;
      if countrec = 0 then
        insert into ContractShareDetail
          (contractid, userid, usertype, sharelevel)
        values
          (contractid_1, supresourceid_1, 1, 3);
      end if;
    end loop;
    
    for supuserid_cursor in (select distinct t1.id id_1, t3.id id_2
                               from HrmResource_Trigger t1,
                                    CRM_CustomerInfo    t2,
                                    CRM_Contract        t3
                              where managerId_2 like
                                    concat('%,',
                                           concat(to_char(t1.id), ',%'))
                                and t2.manager = resourceid_1
                                and t2.id = t3.crmId) loop
      supresourceid_1 := supuserid_cursor.id_1;
      contractid_1    := supuserid_cursor.id_2;
      select count(contractid)
        into countrec
        from ContractShareDetail
       where contractid = contractid_1
         and userid = supresourceid_1
         and usertype = 1;
      if countrec = 0 then
        insert into ContractShareDetail
          (contractid, userid, usertype, sharelevel)
        values
          (contractid_1, supresourceid_1, 1, 1);
      end if;
    end loop;
    
  end if;
end;
/
create or replace procedure HrmRoleMembersShare(resourceid_1 integer,
                                                roleid_1     integer,
                                                rolelevel_1  integer,
                                                rolelevel_2  integer,
                                                flag_1       integer,
                                                flag         out integer,
                                                msg          out varchar2,
                                                thecursor    IN OUT cursor_define.weavercursor) AS
  oldrolelevel_1   char(1);
  oldresourceid_1  integer;
  oldroleid_1      integer;
  docid_1          integer;
  crmid_1          integer;
  prjid_1          integer;
  cptid_1          integer;
  sharelevel_1     integer;
  departmentid_1   integer;
  subcompanyid_1   integer;
  seclevel_1       integer;
  countrec         integer;
  countdelete      integer;
  countinsert      integer;
  managerstr_11    varchar2(500);
  contractid_1     integer;
  contractroleid_1 integer;
  sharelevel_Temp  integer;
  workPlanId_1     integer;
  m_countworkid    integer;
  tempresourceid   integer; /* 某一个人加入一个角色或者在角色中的级别升高进行处理,这两种情况都是增加了共享的范围,不需要删除 原有共享信息,只需要判定增加的部分 */
begin
  oldrolelevel_1  := rolelevel_2;
  oldroleid_1     := roleid_1;
  oldresourceid_1 := resourceid_1; /* flag_1: 0: new 1:update 2:delete */ /*if resource is manager , return */
  select count(id)
    into tempresourceid
    from hrmresourcemanager
   where id = resourceid_1;
  if tempresourceid > 0 then
    return;
  end if;
  if (flag_1 = 0 or (flag_1 = 1 and rolelevel_1 > rolelevel_2)) then
    select departmentid, subcompanyid1, seclevel
      INTO departmentid_1, subcompanyid_1, seclevel_1
      from hrmresource
     where id = resourceid_1;
    if departmentid_1 is null then
      departmentid_1 := 0;
    end if;
    if subcompanyid_1 is null then
      subcompanyid_1 := 0;
    end if;
    if seclevel_1 is null then
      seclevel_1 := 0;
    end if;
    if rolelevel_1 = '2' then
      /* 新的角色级别为总部级 */ 
     
      /* ------- 客户合同部分 总部 2003-11-06杨国生------- */
      for roleids_cursor in (select roleid
                               from SystemRightRoles
                              where rightid = 396) /*396为客户合同管理权限*/
       loop
        for rolecontractid_cursor in (select distinct t1.id
                                        from CRM_Contract       t1,
                                             HrmRoleMembers_Tri t2
                                       where t2.roleid = contractroleid_1
                                         and t2.resourceid = resourceid_1
                                         and t2.rolelevel = 2) loop
          contractid_1 := rolecontractid_cursor.id;
          select count(contractid)
            into countrec
            from ContractShareDetail
           where contractid = contractid_1
             and userid = resourceid_1
             and usertype = 1;
          if countrec = 0 then
            insert into ContractShareDetail
            values
              (contractid_1, resourceid_1, 1, 2);
          else
            select sharelevel
              into sharelevel_1
              from ContractShareDetail
             where contractid = contractid_1
               and userid = resourceid_1
               and usertype = 1;
            if sharelevel_1 = 1 then
              update ContractShareDetail
                 set sharelevel = 2
               where contractid = contractid_1
                 and userid = resourceid_1
                 and usertype = 1;
            end if;
          end if;
        end loop;
      end loop; 
    end if;
    
    
    if rolelevel_1 = '1' then
      /* 新的角色级别为分部级 */ 
       
      /* ------- 客户合同部分 分部 2003-11-06杨国生------- */
      for roleids_cursor in (select roleid
                               from SystemRightRoles
                              where rightid = 396) /*396为客户合同管理权限*/
       loop
        for rolecontractid_cursor in (select distinct t1.id
                                        from CRM_Contract       t1,
                                             HrmRoleMembers_Tri t2
                                       where t2.roleid = contractroleid_1
                                         and t2.resourceid = resourceid_1
                                         and (t2.rolelevel = 1 and
                                             t1.subcompanyid1 =
                                             subcompanyid_1)) loop
          contractid_1 := rolecontractid_cursor.id;
          select count(contractid)
            into countrec
            from ContractShareDetail
           where contractid = contractid_1
             and userid = resourceid_1
             and usertype = 1;
          if countrec = 0 then
            insert into ContractShareDetail
            values
              (contractid_1, resourceid_1, 1, 2);
          else
            select sharelevel
              into sharelevel_1
              from ContractShareDetail
             where contractid = contractid_1
               and userid = resourceid_1
               and usertype = 1;
            if sharelevel_1 = 1 then
              update ContractShareDetail
                 set sharelevel = 2
               where contractid = contractid_1
                 and userid = resourceid_1
                 and usertype = 1;
            end if;
          end if;
        end loop;
      end loop; 
    end if;
    
    if rolelevel_1 = '0' then
      /* 为新建时候设定级别为部门级 */ 
      
      /* ------- 客户合同部分 部门 2003-11-06杨国生------- */
      for roleids_cursor in (select roleid
                               from SystemRightRoles
                              where rightid = 396) /*396为客户合同管理权限*/
       loop
        for rolecontractid_cursor in (select distinct t1.id
                                        from CRM_Contract       t1,
                                             HrmRoleMembers_Tri t2
                                       where t2.roleid = contractroleid_1
                                         and t2.resourceid = resourceid_1
                                         and (t2.rolelevel = 0 and
                                             t1.department = departmentid_1)) loop
          contractid_1 := rolecontractid_cursor.id;
          select count(contractid)
            into countrec
            from ContractShareDetail
           where contractid = contractid_1
             and userid = resourceid_1
             and usertype = 1;
          if countrec = 0 then
            insert into ContractShareDetail
            values
              (contractid_1, resourceid_1, 1, 2);
          else
            select sharelevel
              into sharelevel_1
              from ContractShareDetail
             where contractid = contractid_1
               and userid = resourceid_1
               and usertype = 1;
            if sharelevel_1 = 1 then
              update ContractShareDetail
                 set sharelevel = 2
               where contractid = contractid_1
                 and userid = resourceid_1
                 and usertype = 1;
            end if;
          end if;
        end loop;
      end loop; 
    end if;
  else
    if (flag_1 = 2 or (flag_1 = 1 and rolelevel_1 < rolelevel_2)) then
      /* ------- CRM  部分 ------- */ 


      /* ------- 客户合同部分2003-11-06杨国生 ------- */ /* 自己下级的客户合同 3 */
      managerstr_11 := concat('%,', concat(to_char(resourceid_1), ',%'));
      for subcontractid_cursor in (select id
                                     from CRM_Contract
                                    where (manager in
                                          (select distinct id
                                              from HrmResource
                                             where concat(',', managerstr) like
                                                   managerstr_11))) loop
        select count(contractid)
          into countrec
          from temptablevaluecontract
         where contractid = contractid_1;
        if countrec = 0 then
          insert into temptablevaluecontract values (contractid_1, 3);
        end if;
      end loop; /*  自己是 manager 的客户合同 2 */
      for contractid_cursor in (select id
                                  from CRM_Contract
                                 where manager = resourceid_1) loop
        contractid_1 := contractid_cursor.id;
        insert into temptablevaluecontract values (contractid_1, 2);
      end loop; /* 作为客户合同管理员能看到的 */
      for roleids_cursor in (select roleid
                               from SystemRightRoles
                              where rightid = 396) loop
        for rolecontractid_cursor in (select distinct t1.id
                                        from CRM_Contract       t1,
                                             HrmRoleMembers_Tri t2
                                       where t2.roleid = contractroleid_1
                                         and t2.resourceid = resourceid_1
                                         and (t2.rolelevel = 2 or
                                             (t2.rolelevel = 0 and
                                             t1.department =
                                             departmentid_1) or
                                             (t2.rolelevel = 1 and
                                             t1.subcompanyid1 =
                                             subcompanyid_1))) loop
          contractid_1 := rolecontractid_cursor.id;
          select count(contractid)
            into countrec
            from temptablevaluecontract
           where contractid = contractid_1;
          if countrec = 0 then
            insert into temptablevaluecontract values (contractid_1, 2);
          else
            select sharelevel
              into sharelevel_1
              from ContractShareDetail
             where contractid = contractid_1
               and userid = resourceid_1
               and usertype = 1;
            if sharelevel_1 = 1 then
              update ContractShareDetail
                 set sharelevel = 2
               where contractid = contractid_1
                 and userid = resourceid_1
                 and usertype = 1;
            end if;
          end if;
        end loop;
      end loop; /* 由客户合同的共享获得的权利 1 2 */
      for sharecontractid_cursor in (select distinct t2.relateditemid,
                                                     t2.sharelevel
                                       from Contract_ShareInfo t2
                                      where ((t2.foralluser = 1 and
                                            t2.seclevel <= seclevel_1) or
                                            (t2.userid = resourceid_1) or
                                            (t2.departmentid =
                                            departmentid_1 and
                                            t2.seclevel <= seclevel_1))) loop
        contractid_1 := sharecontractid_cursor.relateditemid;
        sharelevel_1 := sharecontractid_cursor.sharelevel;
        select count(contractid)
          into countrec
          from temptablevaluecontract
         where contractid = contractid_1;
        if countrec = 0 then
          insert into temptablevaluecontract
          values
            (contractid_1, sharelevel_1);
        else
          select sharelevel
            into sharelevel_Temp
            from temptablevaluecontract
           where contractid = contractid_1;
          if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
            update temptablevaluecontract
               set sharelevel = sharelevel_1
             where contractid = contractid_1;
          end if;
        end if;
      end loop;
      for sharecontractid_cursor in (select distinct t2.relateditemid,
                                                     t2.sharelevel
                                       from CRM_Contract       t1,
                                            Contract_ShareInfo t2,
                                            HrmRoleMembers_Tri t3
                                      where t1.id = t2.relateditemid
                                        and t3.resourceid = resourceid_1
                                        and t3.roleid = t2.roleid
                                        and t3.rolelevel >= t2.rolelevel
                                        and t2.seclevel <= seclevel_1
                                        and ((t2.rolelevel = 0 and
                                            t1.department = departmentid_1) or
                                            (t2.rolelevel = 1 and
                                            t1.subcompanyid1 =
                                            subcompanyid_1) or
                                            (t3.rolelevel = 2))) loop
        contractid_1 := sharecontractid_cursor.relateditemid;
        sharelevel_1 := sharecontractid_cursor.sharelevel;
        select count(contractid)
          into countrec
          from temptablevaluecontract
         where contractid = contractid_1;
        if countrec = 0 then
          insert into temptablevaluecontract
          values
            (contractid_1, sharelevel_1);
        else
          select sharelevel
            into sharelevel_Temp
            from temptablevaluecontract
           where contractid = contractid_1;
          if ((sharelevel_Temp = 1) and (sharelevel_1 = 2)) then
            update temptablevaluecontract
               set sharelevel = sharelevel_1
             where contractid = contractid_1;
          end if;
        end if;
      end loop; /* 自己下级的客户合同  (客户经理及经理线)*/
      managerstr_11 := concat('%,', concat(to_char(resourceid_1), ',%'));
      for subcontractid_cursor in (select t2.id
                                     from CRM_CustomerInfo t1,
                                          CRM_Contract     t2
                                    where (t1.manager in
                                          (select distinct id
                                              from HrmResource
                                             where concat(',', managerstr) like
                                                   managerstr_11))
                                      and (t2.crmId = t1.id)) loop
        contractid_1 := subcontractid_cursor.id;
        select count(contractid)
          into countrec
          from temptablevaluecontract
         where contractid = contractid_1;
        if countrec = 0 then
          insert into temptablevaluecontract values (contractid_1, 1);
        end if;
      end loop; /*  自己是 manager 的客户 (客户经理及经理线) */
      for contractid_cursor in (select t2.id
                                  from CRM_CustomerInfo t1, CRM_Contract t2
                                 where (t1.manager = resourceid_1)
                                   and (t2.crmId = t1.id)) loop
        contractid_1 := contractid_cursor.id;
        insert into temptablevaluecontract values (contractid_1, 1);
      end loop; /* 删除原有的与该人员相关的所有权 */
      delete from ContractShareDetail
       where userid = resourceid_1
         and usertype = 1; /* 将临时表中的数据写入共享表 */
      for allcontractid_cursor in (select * from temptablevaluecontract) loop
        contractid_1 := allcontractid_cursor.contractid;
        sharelevel_1 := allcontractid_cursor.sharelevel;
        insert into ContractShareDetail
          (contractid, userid, usertype, sharelevel)
        values
          (contractid_1, resourceid_1, 1, sharelevel_1);
      end loop;
    end if; /* for work plan */ /* added by lupeng 2004-07-22 */ /* delete all the work plan share info of this user */ /* DELETE WorkPlanShareDetail WHERE userid = resourceid_1 AND usertype = 1 */
    for creater_cursor in (SELECT id
                             FROM WorkPlan
                            WHERE createrid = resourceid_1) loop
      workPlanId_1 := creater_cursor.id;
      INSERT INTO TmpTableValueWP VALUES (workPlanId_1, 2);
    end loop; /* b. the creater of the work plan is my underling */
    managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%');
    for underling_cursor in (SELECT id
                               FROM WorkPlan
                              WHERE (createrid IN
                                    (SELECT DISTINCT id
                                        FROM HrmResource
                                       WHERE concat(',', MANAGERSTR) LIKE
                                             managerstr_11))) loop
      workPlanId_1 := underling_cursor.id;
      SELECT COUNT(workPlanId)
        into countrec
        FROM TmpTableValueWP
       WHERE workPlanId = workPlanId_1;
      IF (countrec = 0) then
        INSERT INTO TmpTableValueWP VALUES (workPlanId_1, 1);
      end if;
    end loop; /* c. in the work plan share info */
    for sharewp_cursor in (SELECT DISTINCT workPlanShare.workPlanId,
                                           workPlanShare.shareLevel
                             FROM WorkPlanShare workPlanShare
                            WHERE ( /* 所有人 */
                                   (workPlanShare.forAll = 1 AND
                                   workPlanShare.securityLevel <= seclevel_1) /* 人力资源 */
                                   OR
                                   (workPlanShare.userId LIKE
                                   '%,' ||
                                   cast(resourceid_1 as varchar2(10)) || ',%') /* 部门 */
                                   OR
                                   (workPlanShare.deptId LIKE
                                   '%,' ||
                                   cast(departmentid_1 as varchar2(10)) || ',%' AND
                                   workPlanShare.securityLevel <= seclevel_1) /* 分部 */
                                   OR
                                   (workPlanShare.subCompanyId LIKE
                                   '%,' ||
                                   cast(subcompanyid_1 as varchar2(10)) || ',%' AND
                                   workPlanShare.securityLevel <= seclevel_1))) loop
      workPlanId_1 := sharewp_cursor.workPlanId;
      sharelevel_1 := sharewp_cursor.shareLevel;
      SELECT COUNT(workPlanId)
        into countrec
        FROM TmpTableValueWP
       WHERE workPlanId = workPlanId_1;
      IF (countrec = 0) then
        INSERT INTO TmpTableValueWP VALUES (workPlanId_1, sharelevel_1);
      end if;
    end loop;
    for sharewp_cursor in (SELECT DISTINCT workPlanShare.workPlanId,
                                           workPlanShare.shareLevel
                             FROM WorkPlan           workPlan,
                                  WorkPlanShare      workPlanShare,
                                  HrmRoleMembers_Tri hrmRoleMembers_Tri
                            WHERE ( /* 角色 */
                                   workPlan.id = workPlanShare.workPlanId AND
                                   workPlanShare.roleId =
                                   hrmRoleMembers_Tri.roleId AND hrmRoleMembers_Tri.resourceid =
                                   resourceid_1 AND hrmRoleMembers_Tri.rolelevel >=
                                   workPlanShare.roleLevel AND
                                   workPlanShare.securityLevel <= seclevel_1)) loop
      workPlanId_1 := sharewp_cursor.workPlanId;
      sharelevel_1 := sharewp_cursor.shareLevel;
      SELECT COUNT(workPlanId)
        into countrec
        FROM TmpTableValueWP
       WHERE workPlanId = workPlanId_1;
      IF (countrec = 0) then
        INSERT INTO TmpTableValueWP VALUES (workPlanId_1, sharelevel_1);
      end if;
    end loop; /* write the temporary table data to the share detail table */
    for allwp_cursor in (SELECT * FROM TmpTableValueWP) loop
      workPlanId_1 := allwp_cursor.workPlanId;
      sharelevel_1 := allwp_cursor.shareLevel;
      SELECT COUNT(workid)
        into countrec
        FROM WorkPlanShareDetail
       WHERE workid = workPlanId_1
         AND userid = resourceid_1
         AND usertype = 1;
      IF (countrec = 0) then
              INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where 1=2;
      /*
        INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
        VALUES
          (workPlanId_1, resourceid_1, 1, sharelevel_1);*/
      ELSE
        IF (sharelevel_1 = 2) then
          UPDATE WorkPlanShareDetail
             SET sharelevel = 2
           WHERE workid = workPlanId_1
             AND userid = resourceid_1
             AND usertype = 1; /* 共享是可以编辑, 则都修改原有记录 */
        end if;
      end if;
    end loop;
  end if;
end;
/
