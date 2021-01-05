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
  tempresourceid   integer; /* ĳһ���˼���һ����ɫ�����ڽ�ɫ�еļ������߽��д���,������������������˹����ķ�Χ,����Ҫɾ�� ԭ�й�����Ϣ,ֻ��Ҫ�ж����ӵĲ��� */
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
      /* �µĽ�ɫ����Ϊ�ܲ��� */ /* ------- CRM ���� ------- */
      if roleid_1 = 8 then
        INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where 1=2;
      /*
        INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where type_n = '3';*/
      else
        for sharecrmid_cursor IN (select distinct relateditemid, sharelevel
                                    from CRM_ShareInfo
                                   where roleid = roleid_1
                                     and rolelevel <= rolelevel_1
                                     and seclevel <= seclevel_1) loop
          crmid_1      := sharecrmid_cursor.relateditemid;
          sharelevel_1 := sharecrmid_cursor.sharelevel;
          select count(crmid)
            INTO countrec
            from CrmShareDetail
           where crmid = crmid_1
             and userid = resourceid_1
             and usertype = 1;
          if countrec = 0 then
            insert into CrmShareDetail
            values
              (crmid_1, resourceid_1, 1, sharelevel_1);
          else
            if sharelevel_1 = 2 then
              update CrmShareDetail
                 set sharelevel = 2
               where crmid = crmid_1
                 and userid = resourceid_1
                 and usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
            end if;
          end if; /* added by lupeng 2004-07-22 for customer contact work plan */
          for ccwp_cursor in (SELECT id
                                FROM WorkPlan
                               WHERE type_n = '3'
                                 AND ',' || crmid || ',' like
                                     '%,' || to_char(crmid_1) || ',%') loop
            workPlanId_1 := ccwp_cursor.id;
            select count(workid)
              into m_countworkid
              FROM WorkPlanShareDetail
             WHERE workid = workPlanId_1
               AND userid = resourceid_1
               AND usertype = 1;
            if m_countworkid = 0 then
           INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where 1=2;
            /*
              INSERT INTO WorkPlanShareDetail
                (workid, userid, usertype, sharelevel)
              VALUES
                (workPlanId_1, resourceid_1, 1, 1);*/
            end if;
          end loop; /* end */
        end loop;
      end if; /* ------- PROJ ���� ------- */
      for shareprjid_cursor IN (select distinct relateditemid, sharelevel
                                  from Prj_ShareInfo
                                 where roleid = roleid_1
                                   and rolelevel <= rolelevel_1
                                   and seclevel <= seclevel_1) loop
        prjid_1      := shareprjid_cursor.relateditemid;
        sharelevel_1 := shareprjid_cursor.sharelevel;
        select count(prjid)
          INTO countrec
          from PrjShareDetail
         where prjid = prjid_1
           and userid = resourceid_1
           and usertype = 1;
        if countrec = 0 then
          insert into PrjShareDetail
          values
            (prjid_1, resourceid_1, 1, sharelevel_1);
        else
          if sharelevel_1 = 2 then
            update PrjShareDetail
               set sharelevel = 2
             where prjid = prjid_1
               and userid = resourceid_1
               and usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
          end if;
        end if;
      end loop; /* ------- CPT ���� ------- */
      for sharecptid_cursor IN (select distinct relateditemid, sharelevel
                                  from CptCapitalShareInfo
                                 where roleid = roleid_1
                                   and rolelevel <= rolelevel_1
                                   and seclevel <= seclevel_1) loop
        cptid_1 := sharecptid_cursor.relateditemid;
        sharelevel_1 := sharecptid_cursor.sharelevel;

        select count(cptid)
          INTO countrec
          from CptShareDetail
         where cptid = cptid_1
           and userid = resourceid_1
           and usertype = 1;
        if countrec = 0 then
          insert into CptShareDetail
          values
            (cptid_1, resourceid_1, 1, sharelevel_1);
        else
          if sharelevel_1 = 2 then
            update CptShareDetail
               set sharelevel = 2
             where cptid = cptid_1
               and userid = resourceid_1
               and usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
          end if;
        end if;
      end loop; /* ------- �ͻ���ͬ���� �ܲ� 2003-11-06�����------- */
      for roleids_cursor in (select roleid
                               from SystemRightRoles
                              where rightid = 396) /*396Ϊ�ͻ���ͬ����Ȩ��*/
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
      end loop; /* for work plan */ /* added by lupeng 2004-07-22 */
      for sharewp_cursor in (SELECT DISTINCT workPlanId, shareLevel
                               FROM WorkPlanShare
                              WHERE roleId = roleid_1
                                AND roleLevel <= rolelevel_1
                                AND securityLevel <= seclevel_1) loop
        workPlanId_1 := sharewp_cursor.workPlanId;
        sharelevel_1 := sharewp_cursor.shareLevel;
        SELECT COUNT(workid)
          into countrec
          FROM WorkPlanShareDetail
         WHERE workid = workPlanId_1
           AND userid = resourceid_1
           AND usertype = 1;
        IF countrec = 0 then
        /*
          INSERT INTO WorkPlanShareDetail
            (workid, userid, usertype, sharelevel)
          VALUES
            (workPlanId_1, resourceid_1, 1, sharelevel_1);*/
                    INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where 1=2;
        ELSE
          IF sharelevel_1 = 2 then
            UPDATE WorkPlanShareDetail
               SET sharelevel = 2
             WHERE workid = workPlanId_1
               AND userid = resourceid_1
               AND usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
          end if;
        end if;
      end loop; /* end */
    end if;
    if rolelevel_1 = '1' then
      /* �µĽ�ɫ����Ϊ�ֲ��� */ /* ------- CRM ���� ------- */
      for sharecrmid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from CRM_CustomerInfo t1,
                                       CRM_ShareInfo    t2,
                                       hrmdepartment    t4
                                 where t1.id = t2.relateditemid
                                   and t2.roleid = roleid_1
                                   and t2.rolelevel <= rolelevel_1
                                   and t2.seclevel <= seclevel_1
                                   and t1.department = t4.id
                                   and t4.subcompanyid1 = subcompanyid_1) loop
        crmid_1      := sharecrmid_cursor.relateditemid;
        sharelevel_1 := sharecrmid_cursor.sharelevel;
        select count(crmid)
          INTO countrec
          from CrmShareDetail
         where crmid = crmid_1
           and userid = resourceid_1
           and usertype = 1;
        if countrec = 0 then
          insert into CrmShareDetail
          values
            (crmid_1, resourceid_1, 1, sharelevel_1);
        else
          if sharelevel_1 = 2 then
            update CrmShareDetail
               set sharelevel = 2
             where crmid = crmid_1
               and userid = resourceid_1
               and usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
          end if;
        end if; /* added by lupeng 2004-07-22 for customer contact work plan */
        for ccwp_cursor in (SELECT id
                              FROM WorkPlan
                             WHERE type_n = '3'
                               AND ',' || crmid || ',' like
                                   '%,' || to_char(crmid_1) || ',%') loop
          workPlanId_1 := ccwp_cursor.id;
          select count(workid)
            into m_countworkid
            FROM WorkPlanShareDetail
           WHERE workid = workPlanId_1
             AND userid = resourceid_1
             AND usertype = 1;
          if m_countworkid = 0 then
                  INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where 1=2;
          /*
            INSERT INTO WorkPlanShareDetail
              (workid, userid, usertype, sharelevel)
            VALUES
              (workPlanId_1, resourceid_1, 1, 1);*/
          end if;
        end loop; /* end */
      end loop; /* ------- PRJ ���� ------- */
      for shareprjid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from Prj_ProjectInfo t1,
                                       Prj_ShareInfo   t2,
                                       hrmdepartment   t4
                                 where t1.id = t2.relateditemid
                                   and t2.roleid = roleid_1
                                   and t2.rolelevel <= rolelevel_1
                                   and t2.seclevel <= seclevel_1
                                   and t1.department = t4.id
                                   and t4.subcompanyid1 = subcompanyid_1) loop
        prjid_1      := shareprjid_cursor.relateditemid;
        sharelevel_1 := shareprjid_cursor.sharelevel;
        select count(prjid)
          INTO countrec
          from PrjShareDetail
         where prjid = prjid_1
           and userid = resourceid_1
           and usertype = 1;
        if countrec = 0 then
          insert into PrjShareDetail
          values
            (prjid_1, resourceid_1, 1, sharelevel_1);
        else
          if sharelevel_1 = 2 then
            update PrjShareDetail
               set sharelevel = 2
             where prjid = prjid_1
               and userid = resourceid_1
               and usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
          end if;
        end if;
      end loop; /* ------- CPT ���� ------- */
      for sharecptid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from CptCapital          t1,
                                       CptCapitalShareInfo t2,
                                       hrmdepartment       t4
                                 where t1.id = t2.relateditemid
                                   and t2.roleid = roleid_1
                                   and t2.rolelevel <= rolelevel_1
                                   and t2.seclevel <= seclevel_1
                                   and t1.departmentid = t4.id
                                   and t4.subcompanyid1 = subcompanyid_1) loop
        cptid_1      := sharecptid_cursor.relateditemid;
        sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid)
          INTO countrec
          from CptShareDetail
         where cptid = cptid_1
           and userid = resourceid_1
           and usertype = 1;
        if countrec = 0 then
          insert into CptShareDetail
          values
            (cptid_1, resourceid_1, 1, sharelevel_1);
        else
          if sharelevel_1 = 2 then
            update CptShareDetail
               set sharelevel = 2
             where cptid = cptid_1
               and userid = resourceid_1
               and usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
          end if;
        end if;
      end loop; /* ------- �ͻ���ͬ���� �ֲ� 2003-11-06�����------- */
      for roleids_cursor in (select roleid
                               from SystemRightRoles
                              where rightid = 396) /*396Ϊ�ͻ���ͬ����Ȩ��*/
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
      end loop; /* for work plan */ /* added by lupeng 2004-07-22 */
      for sharewp_cursor in (SELECT DISTINCT t2.workPlanId, t2.shareLevel
                               FROM WorkPlan t1, WorkPlanShare t2
                              WHERE t1.id = t2.workPlanId
                                AND t2.roleId = roleid_1
                                AND t2.roleLevel <= rolelevel_1
                                AND t2.securityLevel <= seclevel_1
                                AND t1.subcompanyId = subcompanyid_1) loop
        workPlanId_1 := sharewp_cursor.workPlanId;
        sharelevel_1 := sharewp_cursor.shareLevel;
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
               AND usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
          end if;
        end if;
      end loop; /* end */
    end if;
    if rolelevel_1 = '0' then
      /* Ϊ�½�ʱ���趨����Ϊ���ż� */ /* ------- CRM ���� ------- */
      for sharecrmid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from CRM_CustomerInfo t1, CRM_ShareInfo t2
                                 where t1.id = t2.relateditemid
                                   and t2.roleid = roleid_1
                                   and t2.rolelevel <= rolelevel_1
                                   and t2.seclevel <= seclevel_1
                                   and t1.department = departmentid_1) loop
        crmid_1      := sharecrmid_cursor.relateditemid;
        sharelevel_1 := sharecrmid_cursor.sharelevel;
        select count(crmid)
          INTO countrec
          from CrmShareDetail
         where crmid = crmid_1
           and userid = resourceid_1
           and usertype = 1;
        if countrec = 0 then
          insert into CrmShareDetail
          values
            (crmid_1, resourceid_1, 1, sharelevel_1);
        else
          if sharelevel_1 = 2 then
            update CrmShareDetail
               set sharelevel = 2
             where crmid = crmid_1
               and userid = resourceid_1
               and usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
          end if;
        end if; /* added by lupeng 2004-07-22 for customer contact work plan */
        for ccwp_cursor in (SELECT id
                              FROM WorkPlan
                             WHERE type_n = '3'
                               AND ',' || crmid || ',' like
                                   '%,' || to_char(crmid_1) || ',%') loop
          workPlanId_1 := ccwp_cursor.id;
          select count(workid)
            into m_countworkid
            FROM WorkPlanShareDetail
           WHERE workid = workPlanId_1
             AND userid = resourceid_1
             AND usertype = 1;
          if m_countworkid = 0 then
                  INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where 1=2;
          /*
            INSERT INTO WorkPlanShareDetail
              (workid, userid, usertype, sharelevel)
            VALUES
              (workPlanId_1, resourceid_1, 1, 1);*/
          end if;
        end loop; /* end */
      end loop; /* ------- PRJ ���� ------- */
      for shareprjid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from Prj_ProjectInfo t1, Prj_ShareInfo t2
                                 where t1.id = t2.relateditemid
                                   and t2.roleid = roleid_1
                                   and t2.rolelevel <= rolelevel_1
                                   and t2.seclevel <= seclevel_1
                                   and t1.department = departmentid_1) loop
        prjid_1      := shareprjid_cursor.relateditemid;
        sharelevel_1 := shareprjid_cursor.sharelevel;
        select count(prjid)
          INTO countrec
          from PrjShareDetail
         where prjid = prjid_1
           and userid = resourceid_1
           and usertype = 1;
        if countrec = 0 then
          insert into PrjShareDetail
          values
            (prjid_1, resourceid_1, 1, sharelevel_1);
        else
          if sharelevel_1 = 2 then
            update PrjShareDetail
               set sharelevel = 2
             where prjid = prjid_1
               and userid = resourceid_1
               and usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
          end if;
        end if;
      end loop; /* ------- CPT ���� ------- */
      for sharecptid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from CptCapital t1, CptCapitalShareInfo t2
                                 where t1.id = t2.relateditemid
                                   and t2.roleid = roleid_1
                                   and t2.rolelevel <= rolelevel_1
                                   and t2.seclevel <= seclevel_1
                                   and t1.departmentid = departmentid_1) loop
        cptid_1      := sharecptid_cursor.relateditemid;
        sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid)
          INTO countrec
          from CptShareDetail
         where cptid = cptid_1
           and userid = resourceid_1
           and usertype = 1;
        if countrec = 0 then
          insert into CptShareDetail
          values
            (cptid_1, resourceid_1, 1, sharelevel_1);
        else
          if sharelevel_1 = 2 then
            update CptShareDetail
               set sharelevel = 2
             where cptid = cptid_1
               and userid = resourceid_1
               and usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
          end if;
        end if;
      end loop; /* ------- �ͻ���ͬ���� ���� 2003-11-06�����------- */
      for roleids_cursor in (select roleid
                               from SystemRightRoles
                              where rightid = 396) /*396Ϊ�ͻ���ͬ����Ȩ��*/
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
      end loop; /* for work plan */ /* added by lupeng 2004-07-22 */
      for sharewp_cursor in (SELECT t2.workPlanId, t2.shareLevel
                               FROM WorkPlan t1, WorkPlanShare t2
                              WHERE t1.id = t2.workPlanId
                                AND t2.roleId = roleid_1
                                AND t2.roleLevel <= rolelevel_1
                                AND t2.securityLevel <= seclevel_1
                                AND t1.deptId like
                                    concat(concat('%,',
                                                  to_char(departmentid_1)),
                                           ',%')) loop
        workPlanId_1 := sharewp_cursor.workPlanId;
        sharelevel_1 := sharewp_cursor.shareLevel;
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
               AND usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
          end if;
        end if;
      end loop; /* end */
    end if;
  else
    if (flag_1 = 2 or (flag_1 = 1 and rolelevel_1 < rolelevel_2)) then
      /* ��Ϊɾ�����߼��𽵵� */
      select departmentid, subcompanyid1, seclevel
        INTO departmentid_1, subcompanyid_1, seclevel_1
        from hrmresource
       where id = resourceid_1;
      if departmentid_1 is null then
        departmentid_1 := 0;
      end if;
      if subcompanyid_1 is null then
        subcompanyid_1 := 0;
      end if; /* ------- CRM  ���� ------- */ /*  �����е���Ϣ�ַŵ� temptablevaluecrm �� */ /*  �Լ��� manager �Ŀͻ� 2 */
      for crmid_cursor IN (select id
                             from CRM_CustomerInfo
                            where manager = resourceid_1) loop
        crmid_1 := crmid_cursor.id;
        insert into temptablevaluecrm values (crmid_1, 2);
      end loop; /* �Լ��¼��Ŀͻ� 3 */ /* �����¼� */
      managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%');
      for subcrmid_cursor IN (select id
                                from CRM_CustomerInfo
                               where (manager in
                                     (select distinct id
                                         from HrmResource
                                        where concat(',', managerstr) like
                                              managerstr_11))) loop
        crmid_1 := subcrmid_cursor.id;
        select count(crmid)
          INTO countrec
          from temptablevaluecrm
         where crmid = crmid_1;
        if countrec = 0 then
          insert into temptablevaluecrm values (crmid_1, 3);
        end if;
      end loop; /* ��Ϊcrm����Ա�ܿ����Ŀͻ� */
      for rolecrmid_cursor IN (select distinct t1.id
                                 from CRM_CustomerInfo   t1,
                                      HrmRoleMembers_Tri t2
                                where t2.roleid = 8
                                  and t2.resourceid = resourceid_1
                                  and (t2.rolelevel = 2 or
                                      (t2.rolelevel = 0 and
                                      t1.department = departmentid_1) or
                                      (t2.rolelevel = 1 and
                                      t1.subcompanyid1 = subcompanyid_1))) loop
        crmid_1 := rolecrmid_cursor.id;
        select count(crmid)
          INTO countrec
          from temptablevaluecrm
         where crmid = crmid_1;
        if countrec = 0 then
          insert into temptablevaluecrm values (crmid_1, 4);
        end if;
      end loop; /* �ɿͻ��Ĺ�����õ�Ȩ�� 1 2 */
      for sharecrmid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from CRM_ShareInfo t2
                                 where ((t2.foralluser = 1 and
                                       t2.seclevel <= seclevel_1) or
                                       (t2.userid = resourceid_1) or
                                       (t2.departmentid = departmentid_1 and
                                       t2.seclevel <= seclevel_1))) loop
        crmid_1      := sharecrmid_cursor.relateditemid;
        sharelevel_1 := sharecrmid_cursor.sharelevel;
        select count(crmid)
          INTO countrec
          from temptablevaluecrm
         where crmid = crmid_1;
        if countrec = 0 then
          insert into temptablevaluecrm values (crmid_1, sharelevel_1);
        end if;
      end loop;
      for sharecrmid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from CRM_CustomerInfo   t1,
                                       CRM_ShareInfo      t2,
                                       HrmRoleMembers_Tri t3
                                 where t1.id = t2.relateditemid
                                   and t3.resourceid = resourceid_1
                                   and t3.roleid = t2.roleid
                                   and t3.rolelevel >= t2.rolelevel
                                   and t2.seclevel <= seclevel_1
                                   and ((t2.rolelevel = 0 and
                                       t1.department = departmentid_1) or
                                       (t2.rolelevel = 1 and
                                       t1.subcompanyid1 = subcompanyid_1) or
                                       (t3.rolelevel = 2))) loop
        crmid_1      := sharecrmid_cursor.relateditemid;
        sharelevel_1 := sharecrmid_cursor.sharelevel;
        select count(crmid)
          INTO countrec
          from temptablevaluecrm
         where crmid = crmid_1;
        if countrec = 0 then
          insert into temptablevaluecrm values (crmid_1, sharelevel_1);
        end if;
      end loop; /* ����ʱ���е�����д�빲���� */
      for allcrmid_cursor IN (select * from temptablevaluecrm) loop
        crmid_1      := allcrmid_cursor.crmid;
        sharelevel_1 := allcrmid_cursor.sharelevel;
        insert into CrmShareDetail
          (crmid, userid, usertype, sharelevel)
        values
          (crmid_1, resourceid_1, 1, sharelevel_1); /* added by lupeng 2004-07-22 for customer contact work plan */
        for ccwp_cursor in (SELECT id
                              FROM WorkPlan
                             WHERE type_n = '3'
                               AND ',' || crmid || ',' like
                                   '%,' || to_char(crmid_1) || ',%') loop
          workPlanId_1 := ccwp_cursor.id;
          select count(workid)
            into m_countworkid
            FROM WorkPlanShareDetail
           WHERE workid = workPlanId_1
             AND userid = resourceid_1
             AND usertype = 1;
          if m_countworkid = 0 then
                  INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where 1=2;
          /*
            INSERT INTO WorkPlanShareDetail
              (workid, userid, usertype, sharelevel)
            VALUES
              (workPlanId_1, resourceid_1, 1, 1);*/
          end if;
        end loop; /* end */
      end loop; /* ------- PROJ ���� ------- */ /*  �����е���Ϣ�ַŵ� temptablevaluePrj �� */ /*  �Լ�����Ŀ2 */
      for prjid_cursor IN (select id
                             from Prj_ProjectInfo
                            where manager = resourceid_1) loop
        prjid_1 := prjid_cursor.id;
        insert into temptablevaluePrj values (prjid_1, 2);
      end loop; /* �Լ��¼�����Ŀ3 */ /* �����¼� */
      managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%');
      for subprjid_cursor IN (select id
                                from Prj_ProjectInfo
                               where (manager in
                                     (select distinct id
                                         from HrmResource
                                        where concat(',', managerstr) like
                                              managerstr_11))) loop
        prjid_1 := subprjid_cursor.id;
        select count(prjid)
          INTO countrec
          from temptablevaluePrj
         where prjid = prjid_1;
        if countrec = 0 then
          insert into temptablevaluePrj values (prjid_1, 3);
        end if;
      end loop; /* ��Ϊ��Ŀ����Ա�ܿ�������Ŀ4 */
      for roleprjid_cursor IN (select distinct t1.id
                                 from Prj_ProjectInfo    t1,
                                      HrmRoleMembers_Tri t2
                                where t2.roleid = 9
                                  and t2.resourceid = resourceid_1
                                  and (t2.rolelevel = 2 or
                                      (t2.rolelevel = 0 and
                                      t1.department = departmentid_1) or
                                      (t2.rolelevel = 1 and
                                      t1.subcompanyid1 = subcompanyid_1))) loop
        prjid_1 := roleprjid_cursor.id;
        select count(prjid)
          INTO countrec
          from temptablevaluePrj
         where prjid = prjid_1;
        if countrec = 0 then
          insert into temptablevaluePrj values (prjid_1, 4);
        end if;
      end loop; /* ����Ŀ�Ĺ�����õ�Ȩ�� 1 2 */
      for shareprjid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from Prj_ShareInfo t2
                                 where ((t2.foralluser = 1 and
                                       t2.seclevel <= seclevel_1) or
                                       (t2.userid = resourceid_1) or
                                       (t2.departmentid = departmentid_1 and
                                       t2.seclevel <= seclevel_1))) loop
        prjid_1      := shareprjid_cursor.relateditemid;
        sharelevel_1 := shareprjid_cursor.sharelevel;
        select count(prjid)
          INTO countrec
          from temptablevaluePrj
         where prjid = prjid_1;
        if countrec = 0 then
          insert into temptablevaluePrj values (prjid_1, sharelevel_1);
        end if;
      end loop;
      for shareprjid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from Prj_ProjectInfo    t1,
                                       Prj_ShareInfo      t2,
                                       HrmRoleMembers_Tri t3
                                 where t1.id = t2.relateditemid
                                   and t3.resourceid = resourceid_1
                                   and t3.roleid = t2.roleid
                                   and t3.rolelevel >= t2.rolelevel
                                   and t2.seclevel <= seclevel_1
                                   and ((t2.rolelevel = 0 and
                                       t1.department = departmentid_1) or
                                       (t2.rolelevel = 1 and
                                       t1.subcompanyid1 = subcompanyid_1) or
                                       (t3.rolelevel = 2))) loop
        prjid_1      := shareprjid_cursor.relateditemid;
        sharelevel_1 := shareprjid_cursor.sharelevel;
        select count(prjid)
          INTO countrec
          from temptablevaluePrj
         where prjid = prjid_1;
        if countrec = 0 then
          insert into temptablevaluePrj values (prjid_1, sharelevel_1);
        end if;
      end loop; /* ��Ŀ��Ա5 (�ڲ��û�) */
      for inuserprjid_cursor IN (SELECT distinct t2.id
                                   FROM Prj_TaskProcess t1,
                                        Prj_ProjectInfo t2
                                  WHERE t1.hrmid = resourceid_1
                                    and t2.id = t1.prjid
                                    and t1.isdelete <> '1'
                                    and t2.isblock = '1') loop
        prjid_1 := inuserprjid_cursor.id;
        select count(prjid)
          INTO countrec
          from temptablevaluePrj
         where prjid = prjid_1;
        if countrec = 0 then
          insert into temptablevaluePrj values (prjid_1, 5);
        end if;
      end loop; /* ɾ��ԭ�е������Ա��ص�������ĿȨ */
      delete from PrjShareDetail
       where userid = resourceid_1
         and usertype = 1; /* ����ʱ���е�����д�빲���� */
      for allprjid_cursor IN (select * from temptablevaluePrj) loop
        prjid_1      := allprjid_cursor.prjid;
        sharelevel_1 := allprjid_cursor.sharelevel;
        insert into PrjShareDetail
          (prjid, userid, usertype, sharelevel)
        values
          (prjid_1, resourceid_1, 1, sharelevel_1);
      end loop; /* ------- CPT ���� ------- */ /*  �����е���Ϣ�ַŵ� temptablevalueCpt �� */ /*  �Լ����ʲ�2 */
      for cptid_cursor IN (select id
                             from CptCapital
                            where resourceid = resourceid_1) loop
        cptid_1 := cptid_cursor.id;
        insert into temptablevalueCpt values (cptid_1, 2);
      end loop; /* �Լ��¼����ʲ�1 */ /* �����¼� */
      managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%');
      for subcptid_cursor IN (select id
                                from CptCapital
                               where (resourceid in
                                     (select distinct id
                                         from HrmResource
                                        where concat(',', managerstr) like
                                              managerstr_11))) loop
        cptid_1 := subcptid_cursor.id;
        select count(cptid)
          INTO countrec
          from temptablevalueCpt
         where cptid = cptid_1;
        if countrec = 0 then
          insert into temptablevalueCpt values (cptid_1, 1);
        end if;
      end loop; /* ���ʲ��Ĺ�����õ�Ȩ�� 1 2 */
      for sharecptid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from CptCapitalShareInfo t2
                                 where ((t2.foralluser = 1 and
                                       t2.seclevel <= seclevel_1) or
                                       (t2.userid = resourceid_1) or
                                       (t2.departmentid = departmentid_1 and
                                       t2.seclevel <= seclevel_1))) loop
        cptid_1      := sharecptid_cursor.relateditemid;
        sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid)
          INTO countrec
          from temptablevalueCpt
         where cptid = cptid_1;
        if countrec = 0 then
          insert into temptablevalueCpt values (cptid_1, sharelevel_1);
        end if;
      end loop;
      for sharecptid_cursor IN (select distinct t2.relateditemid,
                                                t2.sharelevel
                                  from CptCapital          t1,
                                       CptCapitalShareInfo t2,
                                       HrmRoleMembers_Tri  t3,
                                       hrmdepartment       t4
                                 where t1.id = t2.relateditemid
                                   and t3.resourceid = resourceid_1
                                   and t3.roleid = t2.roleid
                                   and t3.rolelevel >= t2.rolelevel
                                   and t2.seclevel <= seclevel_1
                                   and ((t2.rolelevel = 0 and
                                       t1.departmentid = departmentid_1) or
                                       (t2.rolelevel = 1 and
                                       t1.departmentid = t4.id and
                                       t4.subcompanyid1 = subcompanyid_1) or
                                       (t3.rolelevel = 2))) loop
        cptid_1      := sharecptid_cursor.relateditemid;
        sharelevel_1 := sharecptid_cursor.sharelevel;
        select count(cptid)
          INTO countrec
          from temptablevalueCpt
         where cptid = cptid_1;
        if countrec = 0 then
          insert into temptablevalueCpt values (cptid_1, sharelevel_1);
        end if;
      end loop; /* ɾ��ԭ�е������Ա��ص������ʲ�Ȩ */
      delete from CptShareDetail
       where userid = resourceid_1
         and usertype = 1; /* ����ʱ���е�����д�빲���� */
      for allcptid_cursor IN (select * from temptablevalueCpt) loop
        cptid_1      := allcptid_cursor.cptid;
        sharelevel_1 := allcptid_cursor.sharelevel;
        insert into CptShareDetail
          (cptid, userid, usertype, sharelevel)
        values
          (cptid_1, resourceid_1, 1, sharelevel_1);
      end loop; /* ------- �ͻ���ͬ����2003-11-06����� ------- */ /* �Լ��¼��Ŀͻ���ͬ 3 */
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
      end loop; /*  �Լ��� manager �Ŀͻ���ͬ 2 */
      for contractid_cursor in (select id
                                  from CRM_Contract
                                 where manager = resourceid_1) loop
        contractid_1 := contractid_cursor.id;
        insert into temptablevaluecontract values (contractid_1, 2);
      end loop; /* ��Ϊ�ͻ���ͬ����Ա�ܿ����� */
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
      end loop; /* �ɿͻ���ͬ�Ĺ�����õ�Ȩ�� 1 2 */
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
      end loop; /* �Լ��¼��Ŀͻ���ͬ  (�ͻ�������������)*/
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
      end loop; /*  �Լ��� manager �Ŀͻ� (�ͻ�������������) */
      for contractid_cursor in (select t2.id
                                  from CRM_CustomerInfo t1, CRM_Contract t2
                                 where (t1.manager = resourceid_1)
                                   and (t2.crmId = t1.id)) loop
        contractid_1 := contractid_cursor.id;
        insert into temptablevaluecontract values (contractid_1, 1);
      end loop; /* ɾ��ԭ�е������Ա��ص�����Ȩ */
      delete from ContractShareDetail
       where userid = resourceid_1
         and usertype = 1; /* ����ʱ���е�����д�빲���� */
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
                            WHERE ( /* ������ */
                                   (workPlanShare.forAll = 1 AND
                                   workPlanShare.securityLevel <= seclevel_1) /* ������Դ */
                                   OR
                                   (workPlanShare.userId LIKE
                                   '%,' ||
                                   cast(resourceid_1 as varchar2(10)) || ',%') /* ���� */
                                   OR
                                   (workPlanShare.deptId LIKE
                                   '%,' ||
                                   cast(departmentid_1 as varchar2(10)) || ',%' AND
                                   workPlanShare.securityLevel <= seclevel_1) /* �ֲ� */
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
                            WHERE ( /* ��ɫ */
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
             AND usertype = 1; /* �����ǿ��Ա༭, ���޸�ԭ�м�¼ */
        end if;
      end if;
    end loop;
  end if;
end;
/
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
    delete from DocUserCategory
     where userid = resourceid_1
       and usertype = '0';
    for all_cursor in (select distinct t1.id t1id
                         from docseccategory      t1,
                              HrmResource_Trigger t2,
                              hrmrolemembers      t5
                        where t1.cusertype = '0'
                          and t2.id = resourceid_1
                          and ((t2.seclevel >= t1.cuserseclevel) or
                              (t2.seclevel >= t1.cdepseclevel1 and
                              t2.departmentid = t1.cdepartmentid1) or
                              (t2.seclevel >= t1.cdepseclevel2 and
                              t2.departmentid = t1.cdepartmentid2) or
                              (t5.roleid = t1.croleid1 and
                              t5.rolelevel = t1.crolelevel1 and
                              t2.id = t5.resourceid) or
                              (t5.roleid = t1.croleid2 and
                              t5.rolelevel = t1.crolelevel2 and
                              t2.id = t5.resourceid) or
                              (t5.roleid = t1.croleid3 and
                              t5.rolelevel = t1.crolelevel3 and
                              t2.id = t5.resourceid))) loop
      secid_1 := all_cursor.t1id;
      select subcategoryid
        INTO subid_1
        from docseccategory
       where id = secid_1;
      select maincategoryid
        INTO mainid_1
        from docsubcategory
       where id = subid_1;
      insert into docusercategory
        (secid, mainid, subid, userid, usertype)
      values
        (secid_1, mainid_1, subid_1, resourceid_1, '0');
    end loop;
    if ((flag_1 = 1 and departmentid_1 <> olddepartmentid_1) or flag_1 = 0) then
      update shareinnerdoc
         set content = departmentid_1
       where type = 3
         and srcfrom = 85
         and opuser = resourceid_1;
    end if;
    if ((flag_1 = 1 and subcompanyid_1 <> oldsubcompanyid_1_this) or
       flag_1 = 0) then
      update shareinnerdoc
         set content = subcompanyid_1
       where type = 2
         and srcfrom = 84
         and opuser = resourceid_1;
    end if;
    for crmid_cursor IN (select id
                           from CRM_CustomerInfo
                          where manager = resourceid_1) loop
      crmid_1 := crmid_cursor.id;
      insert into temptablevaluecrm values (crmid_1, 2);
    end loop;
    managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%');
    for subcrmid_cursor IN (select id
                              from CRM_CustomerInfo
                             where (manager in
                                   (select distinct id
                                       from HrmResource_Trigger
                                      where concat(',', managerstr) like
                                            managerstr_11))) loop
      crmid_1 := subcrmid_cursor.id;
      select count(crmid)
        INTO countrec
        from temptablevaluecrm
       where crmid = crmid_1;
      if countrec = 0 then
        insert into temptablevaluecrm values (crmid_1, 3);
      end if;
    end loop;
                             
    for rolecrmid_cursor IN (select distinct t1.id
                               from CRM_CustomerInfo t1, hrmrolemembers t2
                              where t2.roleid = 8 
                              and t2.resourceid = resourceid_1 
                              and (t2.rolelevel = 2 or (t2.rolelevel = 0 and t1.department = departmentid_1) 
                                   or (t2.rolelevel = 1 and t1.subcompanyid1 = subcompanyid_1)
                                   )
                             ) loop                                     
                                     
      crmid_1 := rolecrmid_cursor.id;
      select count(crmid)
        INTO countrec
        from temptablevaluecrm
       where crmid = crmid_1;
      if countrec = 0 then
        insert into temptablevaluecrm values (crmid_1, 4);
      end if;
    end loop;
    for sharecrmid_cursor IN (select distinct t2.relateditemid,
                                              t2.sharelevel
                                from CRM_ShareInfo t2
                               where ((t2.foralluser = 1 and
                                     t2.seclevel <= seclevel_1) or
                                     (t2.userid = resourceid_1) or
                                     (t2.departmentid = departmentid_1 and
                                     t2.seclevel <= seclevel_1))) loop
      crmid_1      := sharecrmid_cursor.relateditemid;
      sharelevel_1 := sharecrmid_cursor.sharelevel;
      select count(crmid)
        INTO countrec
        from temptablevaluecrm
       where crmid = crmid_1;
      if countrec = 0 then
        insert into temptablevaluecrm values (crmid_1, sharelevel_1);
      end if;
    end loop;
    for sharecrmid_cursor IN (select distinct t2.relateditemid,
                                              t2.sharelevel
                                from CRM_CustomerInfo t1,
                                     CRM_ShareInfo    t2,
                                     HrmRoleMembers   t3
                               where t1.id = t2.relateditemid
                                 and t3.resourceid = resourceid_1
                                 and t3.roleid = t2.roleid
                                 and t3.rolelevel >= t2.rolelevel
                                 and t2.seclevel <= seclevel_1
                                 and ((t2.rolelevel = 0 and
                                     t1.department = departmentid_1) or
                                     (t2.rolelevel = 1 and
                                     t1.subcompanyid1 = subcompanyid_1) or
                                     (t3.rolelevel = 2))) loop
      crmid_1      := sharecrmid_cursor.relateditemid;
      sharelevel_1 := sharecrmid_cursor.sharelevel;
      select count(crmid)
        INTO countrec
        from temptablevaluecrm
       where crmid = crmid_1;
      if countrec = 0 then
        insert into temptablevaluecrm values (crmid_1, sharelevel_1);
      end if;
    end loop;
    for allcrmid_cursor IN (select * from temptablevaluecrm) loop
      crmid_1      := allcrmid_cursor.crmid;
      sharelevel_1 := allcrmid_cursor.sharelevel;
      for ccwp_cursor in (SELECT id
                            FROM WorkPlan
                           WHERE type_n = '3'
                             AND ',' || crmid || ',' like
                                 '%,' || to_char(crmid_1) || ',%') loop
        workPlanId_1 := ccwp_cursor.id;
        select count(workid)
          into m_countworkid
          FROM WorkPlanShareDetail
         WHERE workid = workPlanId_1
           AND userid = resourceid_1
           AND usertype = 1;
        if m_countworkid = 0 then
                INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where 1=2;
          /*
          INSERT INTO WorkPlanShareDetail
            (workid, userid, usertype, sharelevel)
          VALUES
            (workPlanId_1, resourceid_1, 1, 1);*/
        end if;
      end loop;
    end loop;
    for prjid_cursor IN (select id
                           from Prj_ProjectInfo
                          where manager = resourceid_1) loop
      prjid_1 := prjid_cursor.id;
      insert into temptablevaluePrj values (prjid_1, 2);
    end loop;
    managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%');
    for subprjid_cursor IN (select id
                              from Prj_ProjectInfo
                             where (manager in
                                   (select distinct id
                                       from HrmResource_Trigger
                                      where concat(',', managerstr) like
                                            managerstr_11))) loop
      prjid_1 := subprjid_cursor.id;
      select count(prjid)
        INTO countrec
        from temptablevaluePrj
       where prjid = prjid_1;
      if countrec = 0 then
        insert into temptablevaluePrj values (prjid_1, 3);
      end if;
    end loop;
    for roleprjid_cursor IN (select distinct t1.id
                               from Prj_ProjectInfo t1, hrmrolemembers t2
                              where t2.roleid = 9
                                and t2.resourceid = resourceid_1
                                and (t2.rolelevel = 2 or
                                    (t2.rolelevel = 0 and
                                    t1.department = departmentid_1) or
                                    (t2.rolelevel = 1 and
                                    t1.subcompanyid1 = subcompanyid_1))) loop
      prjid_1 := roleprjid_cursor.id;
      select count(prjid)
        INTO countrec
        from temptablevaluePrj
       where prjid = prjid_1;
      if countrec = 0 then
        insert into temptablevaluePrj values (prjid_1, 4);
      end if;
    end loop;
    for shareprjid_cursor IN (select distinct t2.relateditemid,
                                              t2.sharelevel
                                from Prj_ShareInfo t2
                               where ((t2.foralluser = 1 and
                                     t2.seclevel <= seclevel_1) or
                                     (t2.userid = resourceid_1) or
                                     (t2.departmentid = departmentid_1 and
                                     t2.seclevel <= seclevel_1))) loop
      prjid_1      := shareprjid_cursor.relateditemid;
      sharelevel_1 := shareprjid_cursor.sharelevel;
      select count(prjid)
        INTO countrec
        from temptablevaluePrj
       where prjid = prjid_1;
      if countrec = 0 then
        insert into temptablevaluePrj values (prjid_1, sharelevel_1);
      end if;
    end loop;
    for shareprjid_cursor IN (select distinct t2.relateditemid,
                                              t2.sharelevel
                                from Prj_ProjectInfo t1,
                                     Prj_ShareInfo   t2,
                                     HrmRoleMembers  t3
                               where t1.id = t2.relateditemid
                                 and t3.resourceid = resourceid_1
                                 and t3.roleid = t2.roleid
                                 and t3.rolelevel >= t2.rolelevel
                                 and t2.seclevel <= seclevel_1
                                 and ((t2.rolelevel = 0 and
                                     t1.department = departmentid_1) or
                                     (t2.rolelevel = 1 and
                                     t1.subcompanyid1 = subcompanyid_1) or
                                     (t3.rolelevel = 2))) loop
      prjid_1      := shareprjid_cursor.relateditemid;
      sharelevel_1 := shareprjid_cursor.sharelevel;
      select count(prjid)
        INTO countrec
        from temptablevaluePrj
       where prjid = prjid_1;
      if countrec = 0 then
        insert into temptablevaluePrj values (prjid_1, sharelevel_1);
      end if;
    end loop;
    members_1 := concat(concat('%,', to_char(resourceid_1)), ',%');
    for inuserprjid_cursor IN (SELECT id
                                 FROM Prj_ProjectInfo
                                WHERE (concat(concat(',', members), ',') LIKE
                                      members_1)
                                  and isblock = '1') loop
      prjid_1 := inuserprjid_cursor.id;
      select count(prjid)
        INTO countrec
        from temptablevaluePrj
       where prjid = prjid_1;
      if countrec = 0 then
        insert into temptablevaluePrj values (prjid_1, 5);
      end if;
    end loop;
    delete from PrjShareDetail
     where userid = resourceid_1
       and usertype = 1;
    for allprjid_cursor IN (select * from temptablevaluePrj) loop
      prjid_1      := allprjid_cursor.prjid;
      sharelevel_1 := allprjid_cursor.sharelevel;
      insert into PrjShareDetail
        (prjid, userid, usertype, sharelevel)
      values
        (prjid_1, resourceid_1, 1, sharelevel_1);
    end loop;
    for cptid_cursor IN (select id
                           from CptCapital
                          where resourceid = resourceid_1) loop
      cptid_1 := cptid_cursor.id;
      insert into temptablevalueCpt values (cptid_1, 2);
    end loop;
    for cptid_cursor IN (select id
                           from CptCapital
                          where lastmoderid = resourceid_1) loop
      cptid_1 := cptid_cursor.id;
      insert into temptablevalueCpt values (cptid_1, 1);
    end loop;
    managerstr_11 := concat(concat('%,', to_char(resourceid_1)), ',%');
    for subcptid_cursor IN (select id
                              from CptCapital
                             where (resourceid in
                                   (select distinct id
                                       from HrmResource_Trigger
                                      where concat(',', managerstr) like
                                            managerstr_11))) loop
      cptid_1 := subcptid_cursor.id;
      select count(cptid)
        INTO countrec
        from temptablevalueCpt
       where cptid = cptid_1;
      if countrec = 0 then
        insert into temptablevalueCpt values (cptid_1, 1);
      end if;
    end loop;
    for sharecptid_cursor IN (select distinct t2.relateditemid,
                                              t2.sharelevel
                                from CptCapitalShareInfo t2
                               where ((t2.foralluser = 1 and
                                     t2.seclevel <= seclevel_1) or
                                     (t2.userid = resourceid_1) or
                                     (t2.departmentid = departmentid_1 and
                                     t2.seclevel <= seclevel_1))) loop
      cptid_1      := sharecptid_cursor.relateditemid;
      sharelevel_1 := sharecptid_cursor.sharelevel;
      select count(cptid)
        into countrec
        from temptablevalueCpt
       where cptid = cptid_1;
      if countrec = 0 then
        insert into temptablevalueCpt values (cptid_1, sharelevel_1);
      end if;
    end loop;
    for sharecptid_cursor IN (select distinct t2.relateditemid,
                                              t2.sharelevel
                                from CptCapital          t1,
                                     CptCapitalShareInfo t2,
                                     HrmRoleMembers      t3,
                                     hrmdepartment       t4
                               where t1.id = t2.relateditemid
                                 and t3.resourceid = resourceid_1
                                 and t3.roleid = t2.roleid
                                 and t3.rolelevel >= t2.rolelevel
                                 and t2.seclevel <= seclevel_1
                                 and ((t2.rolelevel = 0 and
                                     t1.departmentid = departmentid_1) or
                                     (t2.rolelevel = 1 and
                                     t1.departmentid = t4.id and
                                     t4.subcompanyid1 = subcompanyid_1) or
                                     (t3.rolelevel = 2))) loop
      cptid_1      := sharecptid_cursor.relateditemid;
      sharelevel_1 := sharecptid_cursor.sharelevel;
      select count(cptid)
        INTO countrec
        from temptablevalueCpt
       where cptid = cptid_1;
      if countrec = 0 then
        insert into temptablevalueCpt values (cptid_1, sharelevel_1);
      end if;
    end loop;
    delete from CptShareDetail
     where userid = resourceid_1
       and usertype = 1;
    for allcptid_cursor IN (select * from temptablevalueCpt) loop
      cptid_1      := allcptid_cursor.cptid;
      sharelevel_1 := allcptid_cursor.sharelevel;
      insert into CptShareDetail
        (cptid, userid, usertype, sharelevel)
      values
        (cptid_1, resourceid_1, 1, sharelevel_1);
    end loop;
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
    for sharewp_cursor1 in (SELECT DISTINCT workPlanId, shareLevel
                              FROM WorkPlanShare
                             WHERE ((forAll = 1 AND
                                   securityLevel <= seclevel_1) OR
                                   (userId like
                                   '%,' || resourceid_1 || ',%') OR
                                   (deptId like concat(concat('%,',
                                                               to_char(departmentid_1)),
                                                        ',%') AND
                                   securityLevel <= seclevel_1))) loop
      workPlanId_1 := sharewp_cursor1.workPlanId;
      sharelevel_1 := sharewp_cursor1.shareLevel;
      SELECT count(workPlanId)
        into countrec
        FROM TmpTableValueWP
       WHERE workPlanId = workPlanId_1;
      IF (countrec = 0) then
        INSERT INTO TmpTableValueWP
          (workPlanId, shareLevel)
        VALUES
          (workPlanId_1, sharelevel_1);
      end if;
    end loop;
    for sharewp_cursor2 in (SELECT DISTINCT t2.workPlanId as t2workPlanId,
                                            t2.shareLevel as t2shareLevel
                              FROM WorkPlan       t1,
                                   WorkPlanShare  t2,
                                   HrmRoleMembers t3
                             WHERE t1.id = t2.workPlanId
                               AND t3.resourceid = resourceid_1
                               AND t3.roleid = t2.roleId
                               AND t3.rolelevel >= t2.roleLevel
                               AND t2.securityLevel <= seclevel_1
                               AND ((t2.roleLevel = 0 AND
                                   t1.deptId = departmentid_1) OR
                                   (t2.roleLevel = 1 AND
                                   t1.subcompanyId = subcompanyid_1) OR
                                   (t3.rolelevel = 2))) loop
      workPlanId_1 := sharewp_cursor2.t2workPlanId;
      sharelevel_1 := sharewp_cursor2.t2shareLevel;
      SELECT COUNT(workPlanId)
        into countrec
        FROM TmpTableValueWP
       WHERE workPlanId = workPlanId_1;
      IF (countrec = 0) then
        INSERT INTO TmpTableValueWP
          (workPlanId, shareLevel)
        VALUES
          (workPlanId_1, sharelevel_1);
      end if;
    end loop;
    for allwp_cursor in (SELECT * FROM TmpTableValueWP) loop
      workPlanId_1 := allwp_cursor.workPlanId;
      sharelevel_1 := allwp_cursor.shareLevel;
              INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where 1=2;
          /*
      INSERT INTO WorkPlanShareDetail
        (workid, userid, usertype, sharelevel)
      VALUES
        (workPlanId_1, resourceid_1, 1, sharelevel_1);*/
    end loop;
  end if;
  if (flag_1 = 1 and managerstr_1 <> oldmanagerstr_1 and
     length(managerstr_1) > 1) then
    managerId_2 := concat(',', managerstr_1);
    update shareinnerdoc
       set content = managerid_1
     where srcfrom = 81
       and opuser = resourceid_1;
    for supuserid_cursor IN (select distinct t1.id id_1, t2.id id_2
                               from HrmResource_Trigger t1,
                                    CRM_CustomerInfo    t2
                              where managerId_2 like
                                    concat(concat('%,', to_char(t1.id)),
                                           ',%')
                                and t2.manager = resourceid_1) loop
      supresourceid_1 := supuserid_cursor.id_1;
      crmid_1         := supuserid_cursor.id_2;
      select count(crmid)
        INTO countrec
        from CrmShareDetail
       where crmid = crmid_1
         and userid = supresourceid_1
         and usertype = 1;
      if countrec = 0 then
        insert into CrmShareDetail
          (crmid, userid, usertype, sharelevel)
        values
          (crmid_1, supresourceid_1, 1, 3);
      end if;
      for ccwp_cursor in (SELECT id
                            FROM WorkPlan
                           WHERE type_n = '3'
                             AND ',' || crmid || ',' like
                                 '%,' || to_char(crmid_1) || ',%') loop
        workPlanId_1 := ccwp_cursor.id;
        select count(workid)
          into m_countworkid
          FROM WorkPlanShareDetail
         WHERE workid = workPlanId_1
           AND userid = resourceid_1
           AND usertype = 1;
        if m_countworkid = 0 then
                INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where 1=2;
          /*
          INSERT INTO WorkPlanShareDetail
            (workid, userid, usertype, sharelevel)
          VALUES
            (workPlanId_1, resourceid_1, 1, 1);*/
        end if;
      end loop;
    end loop;
    for supuserid_cursor IN (select distinct t1.id id_1, t2.id id_2
                               from HrmResource_Trigger t1,
                                    Prj_ProjectInfo     t2
                              where managerId_2 like
                                    concat(concat('%,', to_char(t1.id)),
                                           ',%')
                                and t2.manager = resourceid_1) loop
      supresourceid_1 := supuserid_cursor.id_1;
      prjid_1         := supuserid_cursor.id_2;
      select count(prjid)
        INTO countrec
        from PrjShareDetail
       where prjid = prjid_1
         and userid = supresourceid_1
         and usertype = 1;
      if countrec = 0 then
        insert into PrjShareDetail
          (prjid, userid, usertype, sharelevel)
        values
          (prjid_1, supresourceid_1, 1, 3);
      end if;
    end loop;
    for supuserid_cursor IN (select distinct t1.id id_1, t2.id id_2
                               from HrmResource_Trigger t1, CptCapital t2
                              where managerId_2 like
                                    concat(concat('%,', to_char(t1.id)),
                                           ',%')
                                and t2.resourceid = resourceid_1) loop
      supresourceid_1 := supuserid_cursor.id_1;
      cptid_1         := supuserid_cursor.id_2;
      select count(cptid)
        INTO countrec
        from CptShareDetail
       where cptid = cptid_1
         and userid = supresourceid_1
         and usertype = 1;
      if countrec = 0 then
        insert into CptShareDetail
          (cptid, userid, usertype, sharelevel)
        values
          (cptid_1, supresourceid_1, 1, 1);
      end if;
    end loop;
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
    for supuserid_cursor in (SELECT DISTINCT t1.id id_1, t2.id id_2
                               FROM HrmResource_Trigger t1, WorkPlan t2
                              WHERE managerId_2 LIKE
                                    concat(concat('%,', to_char(t1.id)),
                                           ',%')
                                AND t2.createrid = resourceid_1) loop
      supresourceid_1 := supuserid_cursor.id_1;
      workPlanId_1    := supuserid_cursor.id_2;
      SELECT COUNT(workid)
        into countrec
        FROM WorkPlanShareDetail
       WHERE workid = workPlanId_1
         AND userid = supresourceid_1
         AND usertype = 1;
      IF (countrec = 0) then
              INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
          select id, resourceid_1, 1, 0 from WorkPlan where 1=2;
          /*
        INSERT INTO WorkPlanShareDetail
          (workid, userid, usertype, sharelevel)
        values
          (workPlanId_1, supresourceid_1, 1, 1);*/
      end if;
    end loop;
  end if;
end;
/