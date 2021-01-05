ALTER PROCEDURE HrmResourceShare
    (
      @resourceid_1 INT ,
      @departmentid_1 INT ,
      @subcompanyid_1 INT ,
      @managerid_1 INT ,
      @seclevel_1 INT ,
      @managerstr_1 VARCHAR(500) ,
      @olddepartmentid_1 INT ,
      @oldsubcompanyid_1 INT ,
      @oldmanagerid_1 INT ,
      @oldseclevel_1 INT ,
      @oldmanagerstr_1 VARCHAR(500) ,
      @flag_1 INT ,
      @flag INT OUTPUT ,
      @msg VARCHAR(80) OUTPUT
    )
AS 
    DECLARE @supresourceid_1 INT ,
        @docid_1 INT ,
        @crmid_1 INT ,
        @prjid_1 INT ,
        @cptid_1 INT ,
        @sharelevel_1 INT ,
        @countrec INT ,
        @countdelete INT ,
        @contractid_1 INT ,
        @contractroleid_1 INT ,
        @sharelevel_Temp INT ,
        @workPlanId_1 INT
    IF ( ( @flag_1 = 1
           AND ( @departmentid_1 <> @olddepartmentid_1
                 OR @oldsubcompanyid_1 <> @subcompanyid_1
                 OR @seclevel_1 <> @oldseclevel_1
                 OR @oldseclevel_1 IS NULL
               )
         )
         OR @flag_1 = 0
       ) 
        BEGIN
            EXEC DocUserCategory_InsertByUser @resourceid_1, '0', '', ''
            IF ( ( @flag_1 = 1
                   AND @departmentid_1 <> @olddepartmentid_1
                 )
                 OR @flag_1 = 0
               ) 
                BEGIN
                    UPDATE  shareinnerdoc
                    SET     content = @departmentid_1
                    WHERE   type = 3
                            AND srcfrom = 85
                            AND opuser = @resourceid_1
                END
            IF ( ( @flag_1 = 1
                   AND @subcompanyid_1 <> @oldsubcompanyid_1
                 )
                 OR @flag_1 = 0
               ) 
                BEGIN
                    UPDATE  shareinnerdoc
                    SET     content = @subcompanyid_1
                    WHERE   type = 2
                            AND srcfrom = 84
                            AND opuser = @resourceid_1
                END
            DELETE  WorkPlanShareDetail
            WHERE   userid = @resourceid_1
                    AND usertype = 1
            DECLARE @temptablevaluecrm TABLE
                (
                  crmid INT ,
                  sharelevel INT
                )
            DECLARE crmid_cursor CURSOR
            FOR
                SELECT  id
                FROM    CRM_CustomerInfo
                WHERE   manager = @resourceid_1
            OPEN crmid_cursor
            FETCH NEXT FROM crmid_cursor INTO @crmid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    INSERT  INTO @temptablevaluecrm
                    VALUES  ( @crmid_1, 2 )
                    FETCH NEXT FROM crmid_cursor INTO @crmid_1
                END
            CLOSE crmid_cursor
            DEALLOCATE crmid_cursor
            DECLARE @managerstr_11 VARCHAR(200)
            SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                + ',%'
            DECLARE subcrmid_cursor CURSOR
            FOR
                SELECT  id
                FROM    CRM_CustomerInfo
                WHERE   ( manager IN (
                          SELECT DISTINCT
                                    id
                          FROM      HrmResource
                          WHERE     ',' + managerstr LIKE @managerstr_11 ) )
            OPEN subcrmid_cursor
            FETCH NEXT FROM subcrmid_cursor INTO @crmid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(crmid)
                    FROM    @temptablevaluecrm
                    WHERE   crmid = @crmid_1
                    IF @countrec = 0 
                        INSERT  INTO @temptablevaluecrm
                        VALUES  ( @crmid_1, 3 )
                    FETCH NEXT FROM subcrmid_cursor INTO @crmid_1
                END
            CLOSE subcrmid_cursor
            DEALLOCATE subcrmid_cursor
            DECLARE rolecrmid_cursor CURSOR
            FOR
                SELECT DISTINCT
                        t1.id
                FROM    CRM_CustomerInfo t1 ,
                        hrmrolemembers t2
                WHERE   t2.roleid = 8
                        AND t2.resourceid = @resourceid_1
                        AND ( t2.rolelevel = 2
                              OR ( t2.rolelevel = 0
                                   AND t1.department = @departmentid_1
                                 )
                              OR ( t2.rolelevel = 1
                                   AND t1.subcompanyid1 = @subcompanyid_1
                                 )
                            )
            OPEN rolecrmid_cursor
            FETCH NEXT FROM rolecrmid_cursor INTO @crmid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(crmid)
                    FROM    @temptablevaluecrm
                    WHERE   crmid = @crmid_1
                    IF @countrec = 0 
                        INSERT  INTO @temptablevaluecrm
                        VALUES  ( @crmid_1, 4 )
                    FETCH NEXT FROM rolecrmid_cursor INTO @crmid_1
                END
            CLOSE rolecrmid_cursor
            DEALLOCATE rolecrmid_cursor
            DECLARE sharecrmid_cursor CURSOR
            FOR
                SELECT DISTINCT
                        t2.relateditemid ,
                        t2.sharelevel
                FROM    CRM_ShareInfo t2
                WHERE   ( ( t2.foralluser = 1
                            AND t2.seclevel <= @seclevel_1
                          )
                          OR ( t2.userid = @resourceid_1 )
                          OR ( t2.departmentid = @departmentid_1
                               AND t2.seclevel <= @seclevel_1
                             )
                        )
            OPEN sharecrmid_cursor
            FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1, @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(crmid)
                    FROM    @temptablevaluecrm
                    WHERE   crmid = @crmid_1
                    IF @countrec = 0 
                        BEGIN
                            INSERT  INTO @temptablevaluecrm
                            VALUES  ( @crmid_1, @sharelevel_1 )
                        END
                    FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1,
                        @sharelevel_1
                END
            CLOSE sharecrmid_cursor
            DEALLOCATE sharecrmid_cursor
            DECLARE sharecrmid_cursor CURSOR
            FOR
                SELECT DISTINCT
                        t2.relateditemid ,
                        t2.sharelevel
                FROM    CRM_CustomerInfo t1 ,
                        CRM_ShareInfo t2 ,
                        HrmRoleMembers t3
                WHERE   t1.id = t2.relateditemid
                        AND t3.resourceid = @resourceid_1
                        AND t3.roleid = t2.roleid
                        AND t3.rolelevel >= t2.rolelevel
                        AND t2.seclevel <= @seclevel_1
                        AND ( ( t2.rolelevel = 0
                                AND t1.department = @departmentid_1
                              )
                              OR ( t2.rolelevel = 1
                                   AND t1.subcompanyid1 = @subcompanyid_1
                                 )
                              OR ( t3.rolelevel = 2 )
                            )
            OPEN sharecrmid_cursor
            FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1, @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(crmid)
                    FROM    @temptablevaluecrm
                    WHERE   crmid = @crmid_1
                    IF @countrec = 0 
                        BEGIN
                            INSERT  INTO @temptablevaluecrm
                            VALUES  ( @crmid_1, @sharelevel_1 )
                        END
                    FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1,
                        @sharelevel_1
                END
            CLOSE sharecrmid_cursor
            DEALLOCATE sharecrmid_cursor
            DECLARE allcrmid_cursor CURSOR
            FOR
                SELECT  *
                FROM    @temptablevaluecrm
            OPEN allcrmid_cursor
            FETCH NEXT FROM allcrmid_cursor INTO @crmid_1, @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    DECLARE ccwp_cursor CURSOR
                    FOR
                        SELECT  id
                        FROM    WorkPlan
                        WHERE   type_n = '3'
                                AND ',' + crmid + ',' LIKE '%,'
                                + CONVERT(VARCHAR(100), @crmid_1) + ',%'
                    OPEN ccwp_cursor
                    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                    WHILE ( @@FETCH_STATUS = 0 ) 
                        BEGIN
                            IF NOT EXISTS ( SELECT  workid
                                            FROM    WorkPlanShareDetail
                                            WHERE   workid = @workPlanId_1
                                                    AND userid = @resourceid_1
                                                    AND usertype = 1 ) 
                                                    SELECT COUNT(*) FROM WorkPlanShareDetail
                                                    /*
                                INSERT  INTO WorkPlanShareDetail
                                        ( workid ,
                                          userid ,
                                          usertype ,
                                          sharelevel
                                        )
                                VALUES  ( @workPlanId_1 ,
                                          @resourceid_1 ,
                                          1 ,
                                          1
                                        )*/
                            FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                        END
                    CLOSE ccwp_cursor
                    DEALLOCATE ccwp_cursor
                    FETCH NEXT FROM allcrmid_cursor INTO @crmid_1,
                        @sharelevel_1
                END
            CLOSE allcrmid_cursor
            DEALLOCATE allcrmid_cursor
            DECLARE @temptablevaluePrj TABLE
                (
                  prjid INT ,
                  sharelevel INT
                )
            DECLARE prjid_cursor CURSOR
            FOR
                SELECT  id
                FROM    Prj_ProjectInfo
                WHERE   manager = @resourceid_1
            OPEN prjid_cursor
            FETCH NEXT FROM prjid_cursor INTO @prjid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    INSERT  INTO @temptablevaluePrj
                    VALUES  ( @prjid_1, 2 )
                    FETCH NEXT FROM prjid_cursor INTO @prjid_1
                END
            CLOSE prjid_cursor
            DEALLOCATE prjid_cursor
            SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                + ',%'
            DECLARE subprjid_cursor CURSOR
            FOR
                SELECT  id
                FROM    Prj_ProjectInfo
                WHERE   ( manager IN (
                          SELECT DISTINCT
                                    id
                          FROM      HrmResource
                          WHERE     ',' + managerstr LIKE @managerstr_11 ) )
            OPEN subprjid_cursor
            FETCH NEXT FROM subprjid_cursor INTO @prjid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(prjid)
                    FROM    @temptablevaluePrj
                    WHERE   prjid = @prjid_1
                    IF @countrec = 0 
                        INSERT  INTO @temptablevaluePrj
                        VALUES  ( @prjid_1, 3 )
                    FETCH NEXT FROM subprjid_cursor INTO @prjid_1
                END
            CLOSE subprjid_cursor
            DEALLOCATE subprjid_cursor
            DECLARE roleprjid_cursor CURSOR
            FOR
                SELECT DISTINCT
                        t1.id
                FROM    Prj_ProjectInfo t1 ,
                        hrmrolemembers t2
                WHERE   t2.roleid = 9
                        AND t2.resourceid = @resourceid_1
                        AND ( t2.rolelevel = 2
                              OR ( t2.rolelevel = 0
                                   AND t1.department = @departmentid_1
                                 )
                              OR ( t2.rolelevel = 1
                                   AND t1.subcompanyid1 = @subcompanyid_1
                                 )
                            )
            OPEN roleprjid_cursor
            FETCH NEXT FROM roleprjid_cursor INTO @prjid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(prjid)
                    FROM    @temptablevaluePrj
                    WHERE   prjid = @prjid_1
                    IF @countrec = 0 
                        INSERT  INTO @temptablevaluePrj
                        VALUES  ( @prjid_1, 4 )
                    FETCH NEXT FROM roleprjid_cursor INTO @prjid_1
                END
            CLOSE roleprjid_cursor
            DEALLOCATE roleprjid_cursor
            DECLARE shareprjid_cursor CURSOR
            FOR
                SELECT DISTINCT
                        t2.relateditemid ,
                        t2.sharelevel
                FROM    Prj_ShareInfo t2
                WHERE   ( ( t2.foralluser = 1
                            AND t2.seclevel <= @seclevel_1
                          )
                          OR ( t2.userid = @resourceid_1 )
                          OR ( t2.departmentid = @departmentid_1
                               AND t2.seclevel <= @seclevel_1
                             )
                        )
            OPEN shareprjid_cursor
            FETCH NEXT FROM shareprjid_cursor INTO @prjid_1, @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(prjid)
                    FROM    @temptablevaluePrj
                    WHERE   prjid = @prjid_1
                    IF @countrec = 0 
                        BEGIN
                            INSERT  INTO @temptablevaluePrj
                            VALUES  ( @prjid_1, @sharelevel_1 )
                        END
                    FETCH NEXT FROM shareprjid_cursor INTO @prjid_1,
                        @sharelevel_1
                END
            CLOSE shareprjid_cursor
            DEALLOCATE shareprjid_cursor
            DECLARE shareprjid_cursor CURSOR
            FOR
                SELECT DISTINCT
                        t2.relateditemid ,
                        t2.sharelevel
                FROM    Prj_ProjectInfo t1 ,
                        Prj_ShareInfo t2 ,
                        HrmRoleMembers t3
                WHERE   t1.id = t2.relateditemid
                        AND t3.resourceid = @resourceid_1
                        AND t3.roleid = t2.roleid
                        AND t3.rolelevel >= t2.rolelevel
                        AND t2.seclevel <= @seclevel_1
                        AND ( ( t2.rolelevel = 0
                                AND t1.department = @departmentid_1
                              )
                              OR ( t2.rolelevel = 1
                                   AND t1.subcompanyid1 = @subcompanyid_1
                                 )
                              OR ( t3.rolelevel = 2 )
                            )
            OPEN shareprjid_cursor
            FETCH NEXT FROM shareprjid_cursor INTO @prjid_1, @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(prjid)
                    FROM    @temptablevaluePrj
                    WHERE   prjid = @prjid_1
                    IF @countrec = 0 
                        BEGIN
                            INSERT  INTO @temptablevaluePrj
                            VALUES  ( @prjid_1, @sharelevel_1 )
                        END
                    FETCH NEXT FROM shareprjid_cursor INTO @prjid_1,
                        @sharelevel_1
                END
            CLOSE shareprjid_cursor
            DEALLOCATE shareprjid_cursor
            DECLARE @members_1 VARCHAR(200)
            SET @members_1 = '%,' + CONVERT(VARCHAR(5), @resourceid_1) + ',%'
            DECLARE inuserprjid_cursor CURSOR
            FOR
                SELECT  id
                FROM    Prj_ProjectInfo
                WHERE   ( ',' + members + ',' LIKE @members_1 )
                        AND isblock = '1'
            OPEN inuserprjid_cursor
            FETCH NEXT FROM inuserprjid_cursor INTO @prjid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(prjid)
                    FROM    @temptablevaluePrj
                    WHERE   prjid = @prjid_1
                    IF @countrec = 0 
                        BEGIN
                            INSERT  INTO @temptablevaluePrj
                            VALUES  ( @prjid_1, 5 )
                        END
                    FETCH NEXT FROM inuserprjid_cursor INTO @prjid_1
                END
            CLOSE inuserprjid_cursor
            DEALLOCATE inuserprjid_cursor
            DELETE  FROM PrjShareDetail
            WHERE   userid = @resourceid_1
                    AND usertype = 1
            DECLARE allprjid_cursor CURSOR
            FOR
                SELECT  *
                FROM    @temptablevaluePrj
            OPEN allprjid_cursor
            FETCH NEXT FROM allprjid_cursor INTO @prjid_1, @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    INSERT  INTO PrjShareDetail
                            ( prjid ,
                              userid ,
                              usertype ,
                              sharelevel
                            )
                    VALUES  ( @prjid_1 ,
                              @resourceid_1 ,
                              1 ,
                              @sharelevel_1
                            )
                    FETCH NEXT FROM allprjid_cursor INTO @prjid_1,
                        @sharelevel_1
                END
            CLOSE allprjid_cursor
            DEALLOCATE allprjid_cursor
            DECLARE @temptablevalueCpt TABLE
                (
                  cptid INT ,
                  sharelevel INT
                )
            DECLARE cptid_cursor CURSOR
            FOR
                SELECT  id
                FROM    CptCapital
                WHERE   resourceid = @resourceid_1
            OPEN cptid_cursor
            FETCH NEXT FROM cptid_cursor INTO @cptid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    INSERT  INTO @temptablevalueCpt
                    VALUES  ( @cptid_1, 2 )
                    FETCH NEXT FROM cptid_cursor INTO @cptid_1
                END
            CLOSE cptid_cursor
            DEALLOCATE cptid_cursor
            DECLARE cptid_cursor CURSOR
            FOR
                SELECT  id
                FROM    CptCapital
                WHERE   lastmoderid = @resourceid_1
            OPEN cptid_cursor
            FETCH NEXT FROM cptid_cursor INTO @cptid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    INSERT  INTO @temptablevalueCpt
                    VALUES  ( @cptid_1, 1 )
                    FETCH NEXT FROM cptid_cursor INTO @cptid_1
                END
            CLOSE cptid_cursor
            DEALLOCATE cptid_cursor
            SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                + ',%'
            DECLARE subcptid_cursor CURSOR
            FOR
                SELECT  id
                FROM    CptCapital
                WHERE   ( resourceid IN (
                          SELECT DISTINCT
                                    id
                          FROM      HrmResource
                          WHERE     ',' + managerstr LIKE @managerstr_11 ) )
            OPEN subcptid_cursor
            FETCH NEXT FROM subcptid_cursor INTO @cptid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(cptid)
                    FROM    @temptablevalueCpt
                    WHERE   cptid = @cptid_1
                    IF @countrec = 0 
                        INSERT  INTO @temptablevalueCpt
                        VALUES  ( @cptid_1, 1 )
                    FETCH NEXT FROM subcptid_cursor INTO @cptid_1
                END
            CLOSE subcptid_cursor
            DEALLOCATE subcptid_cursor
            DECLARE sharecptid_cursor CURSOR
            FOR
                SELECT DISTINCT
                        t2.relateditemid ,
                        t2.sharelevel
                FROM    CptCapitalShareInfo t2
                WHERE   ( ( t2.foralluser = 1
                            AND t2.seclevel <= @seclevel_1
                          )
                          OR ( t2.userid = @resourceid_1 )
                          OR ( t2.departmentid = @departmentid_1
                               AND t2.seclevel <= @seclevel_1
                             )
                        )
            OPEN sharecptid_cursor
            FETCH NEXT FROM sharecptid_cursor INTO @cptid_1, @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(cptid)
                    FROM    @temptablevalueCpt
                    WHERE   cptid = @cptid_1
                    IF @countrec = 0 
                        BEGIN
                            INSERT  INTO @temptablevalueCpt
                            VALUES  ( @cptid_1, @sharelevel_1 )
                        END
                    FETCH NEXT FROM sharecptid_cursor INTO @cptid_1,
                        @sharelevel_1
                END
            CLOSE sharecptid_cursor
            DEALLOCATE sharecptid_cursor
            DECLARE sharecptid_cursor CURSOR
            FOR
                SELECT DISTINCT
                        t2.relateditemid ,
                        t2.sharelevel
                FROM    CptCapital t1 ,
                        CptCapitalShareInfo t2 ,
                        HrmRoleMembers t3 ,
                        hrmdepartment t4
                WHERE   t1.id = t2.relateditemid
                        AND t3.resourceid = @resourceid_1
                        AND t3.roleid = t2.roleid
                        AND t3.rolelevel >= t2.rolelevel
                        AND t2.seclevel <= @seclevel_1
                        AND ( ( t2.rolelevel = 0
                                AND t1.departmentid = @departmentid_1
                              )
                              OR ( t2.rolelevel = 1
                                   AND t1.departmentid = t4.id
                                   AND t4.subcompanyid1 = @subcompanyid_1
                                 )
                              OR ( t3.rolelevel = 2 )
                            )
            OPEN sharecptid_cursor
            FETCH NEXT FROM sharecptid_cursor INTO @cptid_1, @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(cptid)
                    FROM    @temptablevalueCpt
                    WHERE   cptid = @cptid_1
                    IF @countrec = 0 
                        BEGIN
                            INSERT  INTO @temptablevalueCpt
                            VALUES  ( @cptid_1, @sharelevel_1 )
                        END
                    FETCH NEXT FROM sharecptid_cursor INTO @cptid_1,
                        @sharelevel_1
                END
            CLOSE sharecptid_cursor
            DEALLOCATE sharecptid_cursor
            DELETE  FROM CptShareDetail
            WHERE   userid = @resourceid_1
                    AND usertype = 1
            DECLARE allcptid_cursor CURSOR
            FOR
                SELECT  *
                FROM    @temptablevalueCpt
            OPEN allcptid_cursor
            FETCH NEXT FROM allcptid_cursor INTO @cptid_1, @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    INSERT  INTO CptShareDetail
                            ( cptid ,
                              userid ,
                              usertype ,
                              sharelevel
                            )
                    VALUES  ( @cptid_1 ,
                              @resourceid_1 ,
                              1 ,
                              @sharelevel_1
                            )
                    FETCH NEXT FROM allcptid_cursor INTO @cptid_1,
                        @sharelevel_1
                END
            CLOSE allcptid_cursor
            DEALLOCATE allcptid_cursor
            DECLARE @temptablevaluecontract TABLE
                (
                  contractid INT ,
                  sharelevel INT
                )
            SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                + ',%'
            DECLARE subcontractid_cursor CURSOR
            FOR
                SELECT  id
                FROM    CRM_Contract
                WHERE   ( manager IN (
                          SELECT DISTINCT
                                    id
                          FROM      HrmResource
                          WHERE     ',' + managerstr LIKE @managerstr_11 ) )
            OPEN subcontractid_cursor
            FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(contractid)
                    FROM    @temptablevaluecontract
                    WHERE   contractid = @contractid_1
                    IF @countrec = 0 
                        INSERT  INTO @temptablevaluecontract
                        VALUES  ( @contractid_1, 3 )
                    FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
                END
            CLOSE subcontractid_cursor
            DEALLOCATE subcontractid_cursor
            DECLARE contractid_cursor CURSOR
            FOR
                SELECT  id
                FROM    CRM_Contract
                WHERE   manager = @resourceid_1
            OPEN contractid_cursor
            FETCH NEXT FROM contractid_cursor INTO @contractid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    INSERT  INTO @temptablevaluecontract
                    VALUES  ( @contractid_1, 2 )
                    FETCH NEXT FROM contractid_cursor INTO @contractid_1
                END
            CLOSE contractid_cursor
            DEALLOCATE contractid_cursor
            DECLARE roleids_cursor CURSOR
            FOR
                SELECT  roleid
                FROM    SystemRightRoles
                WHERE   rightid = 396
            OPEN roleids_cursor
            FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    DECLARE rolecontractid_cursor CURSOR
                    FOR
                        SELECT DISTINCT
                                t1.id
                        FROM    CRM_Contract t1 ,
                                hrmrolemembers t2
                        WHERE   t2.roleid = @contractroleid_1
                                AND t2.resourceid = @resourceid_1
                                AND ( t2.rolelevel = 2
                                      OR ( t2.rolelevel = 0
                                           AND t1.department = @departmentid_1
                                         )
                                      OR ( t2.rolelevel = 1
                                           AND t1.subcompanyid1 = @subcompanyid_1
                                         )
                                    );
                        OPEN rolecontractid_cursor
                    FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
                    WHILE @@fetch_status = 0 
                        BEGIN
                            SELECT  @countrec = COUNT(contractid)
                            FROM    @temptablevaluecontract
                            WHERE   contractid = @contractid_1
                            IF @countrec = 0 
                                BEGIN
                                    INSERT  INTO @temptablevaluecontract
                                    VALUES  ( @contractid_1, 2 )
                                END
                            ELSE 
                                BEGIN
                                    SELECT  @sharelevel_1 = sharelevel
                                    FROM    ContractShareDetail
                                    WHERE   contractid = @contractid_1
                                            AND userid = @resourceid_1
                                            AND usertype = 1
                                    IF @sharelevel_1 = 1 
                                        BEGIN
                                            UPDATE  ContractShareDetail
                                            SET     sharelevel = 2
                                            WHERE   contractid = @contractid_1
                                                    AND userid = @resourceid_1
                                                    AND usertype = 1
                                        END
                                END
                            FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
                        END
                    CLOSE rolecontractid_cursor
                    DEALLOCATE rolecontractid_cursor
                    FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
                END
            CLOSE roleids_cursor
            DEALLOCATE roleids_cursor
            DECLARE sharecontractid_cursor CURSOR
            FOR
                SELECT DISTINCT
                        t2.relateditemid ,
                        t2.sharelevel
                FROM    Contract_ShareInfo t2
                WHERE   ( ( t2.foralluser = 1
                            AND t2.seclevel <= @seclevel_1
                          )
                          OR ( t2.userid = @resourceid_1 )
                          OR ( t2.departmentid = @departmentid_1
                               AND t2.seclevel <= @seclevel_1
                             )
                        )
            OPEN sharecontractid_cursor
            FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1,
                @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(contractid)
                    FROM    @temptablevaluecontract
                    WHERE   contractid = @contractid_1
                    IF @countrec = 0 
                        BEGIN
                            INSERT  INTO @temptablevaluecontract
                            VALUES  ( @contractid_1, @sharelevel_1 )
                        END
                    ELSE 
                        BEGIN
                            SELECT  @sharelevel_Temp = sharelevel
                            FROM    @temptablevaluecontract
                            WHERE   contractid = @contractid_1
                            IF ( ( @sharelevel_Temp = 1 )
                                 AND ( @sharelevel_1 = 2 )
                               ) 
                                UPDATE  @temptablevaluecontract
                                SET     sharelevel = @sharelevel_1
                                WHERE   contractid = @contractid_1
                        END
                    FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1,
                        @sharelevel_1
                END
            CLOSE sharecontractid_cursor
            DEALLOCATE sharecontractid_cursor
            DECLARE sharecontractid_cursor CURSOR
            FOR
                SELECT DISTINCT
                        t2.relateditemid ,
                        t2.sharelevel
                FROM    CRM_Contract t1 ,
                        Contract_ShareInfo t2 ,
                        HrmRoleMembers t3
                WHERE   t1.id = t2.relateditemid
                        AND t3.resourceid = @resourceid_1
                        AND t3.roleid = t2.roleid
                        AND t3.rolelevel >= t2.rolelevel
                        AND t2.seclevel <= @seclevel_1
                        AND ( ( t2.rolelevel = 0
                                AND t1.department = @departmentid_1
                              )
                              OR ( t2.rolelevel = 1
                                   AND t1.subcompanyid1 = @subcompanyid_1
                                 )
                              OR ( t3.rolelevel = 2 )
                            )
            OPEN sharecontractid_cursor
            FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1,
                @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(contractid)
                    FROM    @temptablevaluecontract
                    WHERE   contractid = @contractid_1
                    IF @countrec = 0 
                        BEGIN
                            INSERT  INTO @temptablevaluecontract
                            VALUES  ( @contractid_1, @sharelevel_1 )
                        END
                    ELSE 
                        BEGIN
                            SELECT  @sharelevel_Temp = sharelevel
                            FROM    @temptablevaluecontract
                            WHERE   contractid = @contractid_1
                            IF ( ( @sharelevel_Temp = 1 )
                                 AND ( @sharelevel_1 = 2 )
                               ) 
                                UPDATE  @temptablevaluecontract
                                SET     sharelevel = @sharelevel_1
                                WHERE   contractid = @contractid_1
                        END
                    FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1,
                        @sharelevel_1
                END
            CLOSE sharecontractid_cursor
            DEALLOCATE sharecontractid_cursor
            SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                + ',%'
            DECLARE subcontractid_cursor CURSOR
            FOR
                SELECT  t2.id
                FROM    CRM_CustomerInfo t1 ,
                        CRM_Contract t2
                WHERE   ( t1.manager IN (
                          SELECT DISTINCT
                                    id
                          FROM      HrmResource
                          WHERE     ',' + managerstr LIKE @managerstr_11 ) )
                        AND ( t2.crmId = t1.id )
            OPEN subcontractid_cursor
            FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    SELECT  @countrec = COUNT(contractid)
                    FROM    @temptablevaluecontract
                    WHERE   contractid = @contractid_1
                    IF @countrec = 0 
                        INSERT  INTO @temptablevaluecontract
                        VALUES  ( @contractid_1, 1 )
                    FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
                END
            CLOSE subcontractid_cursor
            DEALLOCATE subcontractid_cursor
            DECLARE contractid_cursor CURSOR
            FOR
                SELECT  t2.id
                FROM    CRM_CustomerInfo t1 ,
                        CRM_Contract t2
                WHERE   ( t1.manager = @resourceid_1 )
                        AND ( t2.crmId = t1.id )
            OPEN contractid_cursor
            FETCH NEXT FROM contractid_cursor INTO @contractid_1
            WHILE @@fetch_status = 0 
                BEGIN
                    INSERT  INTO @temptablevaluecontract
                    VALUES  ( @contractid_1, 1 )
                    FETCH NEXT FROM contractid_cursor INTO @contractid_1
                END
            CLOSE contractid_cursor
            DEALLOCATE contractid_cursor
            DELETE  FROM ContractShareDetail
            WHERE   userid = @resourceid_1
                    AND usertype = 1
            DECLARE allcontractid_cursor CURSOR
            FOR
                SELECT  *
                FROM    @temptablevaluecontract
            OPEN allcontractid_cursor
            FETCH NEXT FROM allcontractid_cursor INTO @contractid_1,
                @sharelevel_1
            WHILE @@fetch_status = 0 
                BEGIN
                    INSERT  INTO ContractShareDetail
                            ( contractid ,
                              userid ,
                              usertype ,
                              sharelevel
                            )
                    VALUES  ( @contractid_1 ,
                              @resourceid_1 ,
                              1 ,
                              @sharelevel_1
                            )
                    FETCH NEXT FROM allcontractid_cursor INTO @contractid_1,
                        @sharelevel_1
                END
            CLOSE allcontractid_cursor
            DEALLOCATE allcontractid_cursor
            DECLARE @TmpTableValueWP TABLE
                (
                  workPlanId INT ,
                  shareLevel INT
                )
            DECLARE creater_cursor CURSOR
            FOR
                SELECT  id
                FROM    WorkPlan
                WHERE   createrId = @resourceid_1
            OPEN creater_cursor
            FETCH NEXT FROM creater_cursor INTO @workPlanId_1
            WHILE ( @@FETCH_STATUS = 0 ) 
                BEGIN
                    INSERT  INTO @TmpTableValueWP
                    VALUES  ( @workPlanId_1, 2 )
                    FETCH NEXT FROM creater_cursor INTO @workPlanId_1
                END
            CLOSE creater_cursor
            DEALLOCATE creater_cursor
            SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                + ',%'
            DECLARE underling_cursor CURSOR
            FOR
                SELECT  id
                FROM    WorkPlan
                WHERE   ( createrid IN (
                          SELECT DISTINCT
                                    id
                          FROM      HrmResource
                          WHERE     ',' + MANAGERSTR LIKE @managerstr_11 ) )
            OPEN underling_cursor
            FETCH NEXT FROM underling_cursor INTO @workPlanId_1
            WHILE ( @@FETCH_STATUS = 0 ) 
                BEGIN
                    SELECT  @countrec = COUNT(workPlanId)
                    FROM    @TmpTableValueWP
                    WHERE   workPlanId = @workPlanId_1
                    IF ( @countrec = 0 ) 
                        INSERT  INTO @TmpTableValueWP
                        VALUES  ( @workPlanId_1, 1 )
                    FETCH NEXT FROM underling_cursor INTO @workPlanId_1
                END
            CLOSE underling_cursor
            DEALLOCATE underling_cursor
            DECLARE sharewp_cursor CURSOR
            FOR
                SELECT DISTINCT
                        workPlanShare.workPlanId ,
                        workPlanShare.shareLevel
                FROM    WorkPlanShare workPlanShare
                WHERE   ( ( workPlanShare.forAll = 1
                            AND workPlanShare.securityLevel <= @seclevel_1
                          )
                          OR ( workPlanShare.userId LIKE '%,'
                               + CAST(@resourceid_1 AS VARCHAR(10)) + ',%' )
                          OR ( workPlanShare.deptId LIKE '%,'
                               + CAST(@departmentid_1 AS VARCHAR(10)) + ',%'
                               AND workPlanShare.securityLevel <= @seclevel_1
                             )
                          OR ( workPlanShare.subCompanyId LIKE '%,'
                               + CAST(@subcompanyid_1 AS VARCHAR(10)) + ',%'
                               AND workPlanShare.securityLevel <= @seclevel_1
                             )
                        )
            OPEN sharewp_cursor
            FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
            WHILE ( @@FETCH_STATUS = 0 ) 
                BEGIN
                    SELECT  @countrec = COUNT(workPlanId)
                    FROM    @TmpTableValueWP
                    WHERE   workPlanId = @workPlanId_1
                    IF ( @countrec = 0 ) 
                        BEGIN
                            INSERT  INTO @TmpTableValueWP
                            VALUES  ( @workPlanId_1, @sharelevel_1 )
                        END
                    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1,
                        @sharelevel_1
                END
            CLOSE sharewp_cursor
            DEALLOCATE sharewp_cursor
            DECLARE sharewp_cursor CURSOR
            FOR
                SELECT DISTINCT
                        workPlanShare.workPlanId ,
                        workPlanShare.shareLevel
                FROM    WorkPlan workPlan ,
                        WorkPlanShare workPlanShare ,
                        HrmRoleMembers hrmRoleMembers
                WHERE   ( workPlan.id = workPlanShare.workPlanId
                          AND workPlanShare.roleId = hrmRoleMembers.roleId
                          AND hrmRoleMembers.resourceid = @resourceid_1
                          AND hrmRoleMembers.rolelevel >= workPlanShare.roleLevel
                          AND workPlanShare.securityLevel <= @seclevel_1
                        )
            OPEN sharewp_cursor
            FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
            WHILE ( @@FETCH_STATUS = 0 ) 
                BEGIN
                    SELECT  @countrec = COUNT(workPlanId)
                    FROM    @TmpTableValueWP
                    WHERE   workPlanId = @workPlanId_1
                    IF ( @countrec = 0 ) 
                        BEGIN
                            INSERT  INTO @TmpTableValueWP
                            VALUES  ( @workPlanId_1, @sharelevel_1 )
                        END
                    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1,
                        @sharelevel_1
                END
            CLOSE sharewp_cursor
            DEALLOCATE sharewp_cursor
            DECLARE allwp_cursor CURSOR
            FOR
                SELECT  *
                FROM    @TmpTableValueWP
            OPEN allwp_cursor
            FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
            WHILE ( @@FETCH_STATUS = 0 ) 
                BEGIN
                	SELECT COUNT(*) FROM WorkPlanShareDetail
                	/*
                    INSERT  INTO WorkPlanShareDetail
                            ( workId ,
                              userId ,
                              userType ,
                              shareLevel
                            )
                    VALUES  ( @workPlanId_1 ,
                              @resourceid_1 ,
                              1 ,
                              @sharelevel_1
                            )*/
                    FETCH NEXT FROM allwp_cursor INTO @workPlanId_1,
                        @sharelevel_1
                END
            CLOSE allwp_cursor
            DEALLOCATE allwp_cursor
        END
    IF ( @flag_1 = 1
         AND @managerid_1 <> @oldmanagerid_1
       ) 
        BEGIN
            UPDATE  shareinnerdoc
            SET     content = @managerid_1
            WHERE   srcfrom = 81
                    AND opuser = @resourceid_1
        END
    IF ( ( @flag_1 = 1
           AND @managerstr_1 <> @oldmanagerstr_1
         )
         OR @flag_1 = 0
       ) 
        BEGIN
            IF ( @managerstr_1 IS NOT NULL
                 AND LEN(@managerstr_1) > 1
               ) 
                BEGIN
                    SET @managerstr_1 = ',' + @managerstr_1
                    DECLARE supuserid_cursor CURSOR
                    FOR
                        SELECT DISTINCT
                                t1.id ,
                                t2.id
                        FROM    HrmResource t1 ,
                                CRM_CustomerInfo t2
                        WHERE   @managerstr_1 LIKE '%,'
                                + CONVERT(VARCHAR(5), t1.id) + ',%'
                                AND t2.manager = @resourceid_1;
                        OPEN supuserid_cursor
                    FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                        @crmid_1
                    WHILE @@fetch_status = 0 
                        BEGIN
                            DECLARE ccwp_cursor CURSOR
                            FOR
                                SELECT  id
                                FROM    WorkPlan
                                WHERE   type_n = '3'
                                        AND ',' + crmid + ',' LIKE '%,'
                                        + CONVERT(VARCHAR(100), @crmid_1)
                                        + ',%'
                            OPEN ccwp_cursor
                            FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                            WHILE ( @@FETCH_STATUS = 0 ) 
                                BEGIN
                                    IF NOT EXISTS ( SELECT  workid
                                                    FROM    WorkPlanShareDetail
                                                    WHERE   workid = @workPlanId_1
                                                            AND userid = @resourceid_1
                                                            AND usertype = 1 ) 
                                                            SELECT COUNT(*) FROM WorkPlanShareDetail
                                                            /*
                                        INSERT  INTO WorkPlanShareDetail
                                                ( workid ,
                                                  userid ,
                                                  usertype ,
                                                  sharelevel
                                                )
                                        VALUES  ( @workPlanId_1 ,
                                                  @resourceid_1 ,
                                                  1 ,
                                                  1
                                                )*/
                                    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                                END
                            CLOSE ccwp_cursor
                            DEALLOCATE ccwp_cursor
                            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                                @crmid_1
                        END
                    CLOSE supuserid_cursor
                    DEALLOCATE supuserid_cursor
                    DECLARE supuserid_cursor CURSOR
                    FOR
                        SELECT DISTINCT
                                t1.id ,
                                t2.id
                        FROM    HrmResource t1 ,
                                Prj_ProjectInfo t2
                        WHERE   @managerstr_1 LIKE '%,'
                                + CONVERT(VARCHAR(5), t1.id) + ',%'
                                AND t2.manager = @resourceid_1;
                        OPEN supuserid_cursor
                    FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                        @prjid_1
                    WHILE @@fetch_status = 0 
                        BEGIN
                            SELECT  @countrec = COUNT(prjid)
                            FROM    PrjShareDetail
                            WHERE   prjid = @prjid_1
                                    AND userid = @supresourceid_1
                                    AND usertype = 1
                            IF @countrec = 0 
                                BEGIN
                                    INSERT  INTO PrjShareDetail
                                            ( prjid, userid, usertype,
                                              sharelevel )
                                    VALUES  ( @prjid_1, @supresourceid_1, 1, 3 )
                                END
                            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                                @prjid_1
                        END
                    CLOSE supuserid_cursor
                    DEALLOCATE supuserid_cursor
                    DECLARE supuserid_cursor CURSOR
                    FOR
                        SELECT DISTINCT
                                t1.id ,
                                t2.id
                        FROM    HrmResource t1 ,
                                CptCapital t2
                        WHERE   @managerstr_1 LIKE '%,'
                                + CONVERT(VARCHAR(5), t1.id) + ',%'
                                AND t2.resourceid = @resourceid_1;
                        OPEN supuserid_cursor
                    FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                        @cptid_1
                    WHILE @@fetch_status = 0 
                        BEGIN
                            SELECT  @countrec = COUNT(cptid)
                            FROM    CptShareDetail
                            WHERE   cptid = @cptid_1
                                    AND userid = @supresourceid_1
                                    AND usertype = 1
                            IF @countrec = 0 
                                BEGIN
                                    INSERT  INTO CptShareDetail
                                            ( cptid, userid, usertype,
                                              sharelevel )
                                    VALUES  ( @cptid_1, @supresourceid_1, 1, 1 )
                                END
                            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                                @cptid_1
                        END
                    CLOSE supuserid_cursor
                    DEALLOCATE supuserid_cursor
                    DECLARE supuserid_cursor CURSOR
                    FOR
                        SELECT DISTINCT
                                t1.id ,
                                t2.id
                        FROM    HrmResource t1 ,
                                CRM_Contract t2
                        WHERE   @managerstr_1 LIKE '%,'
                                + CONVERT(VARCHAR(5), t1.id) + ',%'
                                AND t2.manager = @resourceid_1;
                        OPEN supuserid_cursor
                    FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                        @contractid_1
                    WHILE @@fetch_status = 0 
                        BEGIN
                            SELECT  @countrec = COUNT(contractid)
                            FROM    ContractShareDetail
                            WHERE   contractid = @contractid_1
                                    AND userid = @supresourceid_1
                                    AND usertype = 1
                            IF @countrec = 0 
                                BEGIN
                                    INSERT  INTO ContractShareDetail
                                            ( contractid ,
                                              userid ,
                                              usertype ,
                                              sharelevel
                                            )
                                    VALUES  ( @contractid_1 ,
                                              @supresourceid_1 ,
                                              1 ,
                                              3
                                            )
                                END
                            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                                @contractid_1
                        END
                    CLOSE supuserid_cursor
                    DEALLOCATE supuserid_cursor
                    DECLARE supuserid_cursor CURSOR
                    FOR
                        SELECT DISTINCT
                                t1.id ,
                                t3.id
                        FROM    HrmResource t1 ,
                                CRM_CustomerInfo t2 ,
                                CRM_Contract t3
                        WHERE   @managerstr_1 LIKE '%,'
                                + CONVERT(VARCHAR(5), t1.id) + ',%'
                                AND t2.manager = @resourceid_1
                                AND t2.id = t3.crmId;
                        OPEN supuserid_cursor
                    FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                        @contractid_1
                    WHILE @@fetch_status = 0 
                        BEGIN
                            SELECT  @countrec = COUNT(contractid)
                            FROM    ContractShareDetail
                            WHERE   contractid = @contractid_1
                                    AND userid = @supresourceid_1
                                    AND usertype = 1
                            IF @countrec = 0 
                                BEGIN
                                    INSERT  INTO ContractShareDetail
                                            ( contractid ,
                                              userid ,
                                              usertype ,
                                              sharelevel
                                            )
                                    VALUES  ( @contractid_1 ,
                                              @supresourceid_1 ,
                                              1 ,
                                              1
                                            )
                                END
                            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                                @contractid_1
                        END
                    CLOSE supuserid_cursor
                    DEALLOCATE supuserid_cursor
                    DECLARE supuserid_cursor CURSOR
                    FOR
                        SELECT DISTINCT
                                t1.id ,
                                t2.id
                        FROM    HrmResource t1 ,
                                WorkPlan t2
                        WHERE   @managerstr_1 LIKE '%,'
                                + CONVERT(VARCHAR(5), t1.id) + ',%'
                                AND t2.createrid = @resourceid_1
                    OPEN supuserid_cursor
                    FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                        @workPlanId_1
                    WHILE ( @@FETCH_STATUS = 0 ) 
                        BEGIN
                            SELECT  @countrec = COUNT(workid)
                            FROM    WorkPlanShareDetail
                            WHERE   workid = @workPlanId_1
                                    AND userid = @supresourceid_1
                                    AND usertype = 1
                            IF ( @countrec = 0 ) 
                                BEGIN
                                	SELECT COUNT(*) FROM WorkPlanShareDetail
                                	/*
                                    INSERT  INTO WorkPlanShareDetail
                                            ( workid ,
                                              userid ,
                                              usertype ,
                                              sharelevel
                                            )
                                    VALUES  ( @workPlanId_1 ,
                                              @supresourceid_1 ,
                                              1 ,
                                              1
                                            )*/
                                END
                            FETCH NEXT FROM supuserid_cursor INTO @supresourceid_1,
                                @workPlanId_1
                        END
                    CLOSE supuserid_cursor
                    DEALLOCATE supuserid_cursor
                END
        END
GO

  /* 处理在角色中添加成员后的权限分配操作 */
ALTER PROCEDURE HrmRoleMembersShare
    (
      @resourceid_1 INT ,
      @roleid_1 INT ,
      @rolelevel_1 INT ,
      @rolelevel_2 INT ,
      @flag_1 INT ,
      @flag INTEGER OUTPUT ,
      @msg VARCHAR(80) OUTPUT
    )
AS 
    DECLARE @docid_1 INT ,
        @crmid_1 INT ,
        @prjid_1 INT ,
        @cptid_1 INT ,
        @sharelevel_1 INT ,
        @departmentid_1 INT ,
        @subcompanyid_1 INT ,
        @seclevel_1 INT ,
        @countrec INT ,
        @countdelete INT ,
        @countinsert INT ,
        @contractid_1 INT ,
        @contractroleid_1 INT ,
        @sharelevel_Temp INT ,
        @workPlanId_1 INT ,
        @managerstr_11 CHAR(500)
    IF ( @flag_1 = 0
         OR ( @flag_1 = 1
              AND @rolelevel_1 > @rolelevel_2
            )
       ) 
        BEGIN
            SELECT  @departmentid_1 = departmentid ,
                    @subcompanyid_1 = subcompanyid1 ,
                    @seclevel_1 = seclevel
            FROM    hrmresource
            WHERE   id = @resourceid_1
            IF @departmentid_1 IS NULL 
                SET @departmentid_1 = 0
            IF @subcompanyid_1 IS NULL 
                SET @subcompanyid_1 = 0
            IF @seclevel_1 IS NULL 
                SET @seclevel_1 = 0
            IF @rolelevel_1 = '2'       /* 新的角色级别为总部级 */ 
                BEGIN    /* ------- CRM 部分 ----角色变化不影响客户和日程的共享，共享跟角色相对独立--- */
                    IF ( @roleid_1 = 8 ) 
                        BEGIN
                        	 SELECT COUNT(*) FROM WorkPlanShareDetail
                        	 /*
                            INSERT  INTO WorkPlanShareDetail
                                    ( workid ,
                                      userid ,
                                      usertype ,
                                      sharelevel
                                    )
                                    SELECT  id ,
                                            @resourceid_1 ,
                                            1 ,
                                            0
                                    FROM    WorkPlan
                                    WHERE   type_n = '3'*/
                        END
                    ELSE 
                        BEGIN
                            DECLARE sharecrmid_cursor CURSOR
                            FOR
                                SELECT DISTINCT
                                        relateditemid ,
                                        sharelevel
                                FROM    CRM_ShareInfo
                                WHERE   contents = @roleid_1
                                        AND rolelevel <= @rolelevel_1
                                        AND seclevel <= @seclevel_1
                            OPEN sharecrmid_cursor
                            FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1,
                                @sharelevel_1
                            WHILE @@fetch_status = 0 
                                BEGIN  /* added by lupeng 2004-07-22 for customer contact work plan */
                                    DECLARE ccwp_cursor CURSOR
                                    FOR
                                        SELECT  id
                                        FROM    WorkPlan
                                        WHERE   type_n = '3'
                                                AND ',' + crmid + ',' LIKE '%,'
                                                + CONVERT(VARCHAR(100), @crmid_1)
                                                + ',%'
                                    OPEN ccwp_cursor
                                    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                                    WHILE ( @@FETCH_STATUS = 0 ) 
                                        BEGIN
                                            IF NOT EXISTS ( SELECT
                                                              workid
                                                            FROM
                                                              WorkPlanShareDetail
                                                            WHERE
                                                              workid = @workPlanId_1
                                                              AND userid = @resourceid_1
                                                              AND usertype = 1 ) 
                                                SELECT COUNT(*) FROM WorkPlanShareDetail
                                                /*
                                                 INSERT  INTO WorkPlanShareDetail
                                                        ( workid ,
                                                          userid ,
                                                          usertype ,
                                                          sharelevel
                                                        )
                                                VALUES  ( @workPlanId_1 ,
                                                          @resourceid_1 ,
                                                          1 ,
                                                          0
                                                        )
                                                */
                                               
                                            FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                                        END
                                    CLOSE ccwp_cursor
                                    DEALLOCATE ccwp_cursor /* end */
                                    FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1,
                                        @sharelevel_1
                                END
                            CLOSE sharecrmid_cursor
                            DEALLOCATE sharecrmid_cursor
                        END  /* ------- PROJ 部分 ------- */
                    DECLARE shareprjid_cursor CURSOR
                    FOR
                        SELECT DISTINCT
                                relateditemid ,
                                sharelevel
                        FROM    Prj_ShareInfo
                        WHERE   roleid = @roleid_1
                                AND rolelevel <= @rolelevel_1
                                AND seclevel <= @seclevel_1
                    OPEN shareprjid_cursor
                    FETCH NEXT FROM shareprjid_cursor INTO @prjid_1,
                        @sharelevel_1
                    WHILE @@fetch_status = 0 
                        BEGIN
                            SELECT  @countrec = COUNT(prjid)
                            FROM    PrjShareDetail
                            WHERE   prjid = @prjid_1
                                    AND userid = @resourceid_1
                                    AND usertype = 1
                            IF @countrec = 0 
                                BEGIN
                                    INSERT  INTO PrjShareDetail
                                    VALUES  ( @prjid_1, @resourceid_1, 1,
                                              @sharelevel_1 )
                                END
                            ELSE 
                                IF @sharelevel_1 = 2 
                                    BEGIN
                                        UPDATE  PrjShareDetail
                                        SET     sharelevel = 2
                                        WHERE   prjid = @prjid_1
                                                AND userid = @resourceid_1
                                                AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */
                                    END
                            FETCH NEXT FROM shareprjid_cursor INTO @prjid_1,
                                @sharelevel_1
                        END
                    CLOSE shareprjid_cursor
                    DEALLOCATE shareprjid_cursor   /* ------- CPT 部分 ------- */
                    DECLARE sharecptid_cursor CURSOR
                    FOR
                        SELECT DISTINCT
                                relateditemid ,
                                sharelevel
                        FROM    CptCapitalShareInfo
                        WHERE   roleid = @roleid_1
                                AND rolelevel <= @rolelevel_1
                                AND seclevel <= @seclevel_1
                    OPEN sharecptid_cursor
                    FETCH NEXT FROM sharecptid_cursor INTO @cptid_1,
                        @sharelevel_1
                    WHILE @@fetch_status = 0 
                        BEGIN
                            SELECT  @countrec = COUNT(cptid)
                            FROM    CptShareDetail
                            WHERE   cptid = @cptid_1
                                    AND userid = @resourceid_1
                                    AND usertype = 1
                            IF @countrec = 0 
                                BEGIN
                                    INSERT  INTO CptShareDetail
                                    VALUES  ( @cptid_1, @resourceid_1, 1,
                                              @sharelevel_1 )
                                END
                            ELSE 
                                IF @sharelevel_1 = 2 
                                    BEGIN
                                        UPDATE  CptShareDetail
                                        SET     sharelevel = 2
                                        WHERE   cptid = @cptid_1
                                                AND userid = @resourceid_1
                                                AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */
                                    END
                            FETCH NEXT FROM sharecptid_cursor INTO @cptid_1,
                                @sharelevel_1
                        END
                    CLOSE sharecptid_cursor
                    DEALLOCATE sharecptid_cursor   /* ------- 客户合同部分 总部 2003-11-06杨国生------- */
                    DECLARE roleids_cursor CURSOR
                    FOR
                        SELECT  roleid
                        FROM    SystemRightRoles
                        WHERE   rightid = 396 /*396为客户合同管理权限*/
                    OPEN roleids_cursor
                    FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
                    WHILE @@fetch_status = 0 
                        BEGIN
                            DECLARE rolecontractid_cursor CURSOR
                            FOR
                                SELECT DISTINCT
                                        t1.id
                                FROM    CRM_Contract t1 ,
                                        hrmrolemembers t2
                                WHERE   t2.roleid = @contractroleid_1
                                        AND t2.resourceid = @resourceid_1
                                        AND t2.rolelevel = 2;
                                OPEN rolecontractid_cursor
                            FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
                            WHILE @@fetch_status = 0 
                                BEGIN
                                    SELECT  @countrec = COUNT(contractid)
                                    FROM    ContractShareDetail
                                    WHERE   contractid = @contractid_1
                                            AND userid = @resourceid_1
                                            AND usertype = 1
                                    IF @countrec = 0 
                                        BEGIN
                                            INSERT  INTO ContractShareDetail
                                            VALUES  ( @contractid_1,
                                                      @resourceid_1, 1, 2 )
                                        END
                                    ELSE 
                                        BEGIN
                                            SELECT  @sharelevel_1 = sharelevel
                                            FROM    ContractShareDetail
                                            WHERE   contractid = @contractid_1
                                                    AND userid = @resourceid_1
                                                    AND usertype = 1
                                            IF @sharelevel_1 = 1 
                                                BEGIN
                                                    UPDATE  ContractShareDetail
                                                    SET     sharelevel = 2
                                                    WHERE   contractid = @contractid_1
                                                            AND userid = @resourceid_1
                                                            AND usertype = 1
                                                END
                                        END
                                    FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
                                END
                            CLOSE rolecontractid_cursor
                            DEALLOCATE rolecontractid_cursor
                            FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
                        END
                    CLOSE roleids_cursor
                    DEALLOCATE roleids_cursor  /* for work plan */ /* added by lupeng 2004-07-22 */
                    DECLARE sharewp_cursor CURSOR
                    FOR
                        SELECT DISTINCT
                                workPlanId ,
                                shareLevel
                        FROM    WorkPlanShare
                        WHERE   roleId = @roleid_1
                                AND roleLevel <= @rolelevel_1
                                AND securityLevel <= @seclevel_1
                    OPEN sharewp_cursor
                    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1,
                        @sharelevel_1
                    WHILE ( @@FETCH_STATUS = 0 ) 
                        BEGIN
                            SELECT  @countrec = COUNT(workid)
                            FROM    WorkPlanShareDetail
                            WHERE   workid = @workPlanId_1
                                    AND userid = @resourceid_1
                                    AND usertype = 1
                            IF ( @countrec = 0 ) 
                                BEGIN
                                	  SELECT COUNT(*) FROM WorkPlanShareDetail
                                   /*
                                    INSERT  INTO WorkPlanShareDetail
                                            ( workid ,
                                              userid ,
                                              usertype ,
                                              sharelevel
                                            )
                                    VALUES  ( @workPlanId_1 ,
                                              @resourceid_1 ,
                                              1 ,
                                              @sharelevel_1
                                            )*/
                                END
                            ELSE 
                                IF ( @sharelevel_1 = 2 ) 
                                    BEGIN
                                        UPDATE  WorkPlanShareDetail
                                        SET     sharelevel = 2
                                        WHERE   workid = @workPlanId_1
                                                AND userid = @resourceid_1
                                                AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */
                                    END
                            FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1,
                                @sharelevel_1
                        END
                    CLOSE sharewp_cursor
                    DEALLOCATE sharewp_cursor  /* end */
                END
            ELSE 
                IF @rolelevel_1 = '1'          /* 新的角色级别为分部级 */ 
                    BEGIN /* ------- CRM 部分 ----角色变化不影响客户和日程的共享，共享跟角色相对独立--- */
                        DECLARE sharecrmid_cursor CURSOR
                        FOR
                            SELECT DISTINCT
                                    t2.relateditemid ,
                                    t2.sharelevel
                            FROM    CRM_CustomerInfo t1 ,
                                    CRM_ShareInfo t2 ,
                                    hrmdepartment t4
                            WHERE   t1.id = t2.relateditemid
                                    AND t2.contents = @roleid_1
                                    AND t2.rolelevel <= @rolelevel_1
                                    AND t2.seclevel <= @seclevel_1
                                    AND t1.department = t4.id
                                    AND t4.subcompanyid1 = @subcompanyid_1
                        OPEN sharecrmid_cursor
                        FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1,
                            @sharelevel_1
                        WHILE @@fetch_status = 0 
                            BEGIN  /* added by lupeng 2004-07-22 for customer contact work plan */
                                DECLARE ccwp_cursor CURSOR
                                FOR
                                    SELECT  id
                                    FROM    WorkPlan
                                    WHERE   type_n = '3'
                                            AND ',' + crmid + ',' LIKE '%,'
                                            + CONVERT(VARCHAR(100), @crmid_1)
                                            + ',%'
                                OPEN ccwp_cursor
                                FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                                WHILE ( @@FETCH_STATUS = 0 ) 
                                    BEGIN
                                        IF NOT EXISTS ( SELECT
                                                              workid
                                                        FROM  WorkPlanShareDetail
                                                        WHERE workid = @workPlanId_1
                                                              AND userid = @resourceid_1
                                                              AND usertype = 1 ) 
                                            SELECT COUNT(*) FROM WorkPlanShareDetail
                                            /*
                                            INSERT  INTO WorkPlanShareDetail
                                                    ( workid ,
                                                      userid ,
                                                      usertype ,
                                                      sharelevel
                                                    )
                                            VALUES  ( @workPlanId_1 ,
                                                      @resourceid_1 ,
                                                      1 ,
                                                      0
                                                    )*/
                                        FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                                    END
                                CLOSE ccwp_cursor
                                DEALLOCATE ccwp_cursor /* end */
                                FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1,
                                    @sharelevel_1
                            END
                        CLOSE sharecrmid_cursor
                        DEALLOCATE sharecrmid_cursor  /* ------- PRJ 部分 ------- */
                        DECLARE shareprjid_cursor CURSOR
                        FOR
                            SELECT DISTINCT
                                    t2.relateditemid ,
                                    t2.sharelevel
                            FROM    Prj_ProjectInfo t1 ,
                                    Prj_ShareInfo t2 ,
                                    hrmdepartment t4
                            WHERE   t1.id = t2.relateditemid
                                    AND t2.roleid = @roleid_1
                                    AND t2.rolelevel <= @rolelevel_1
                                    AND t2.seclevel <= @seclevel_1
                                    AND t1.department = t4.id
                                    AND t4.subcompanyid1 = @subcompanyid_1
                        OPEN shareprjid_cursor
                        FETCH NEXT FROM shareprjid_cursor INTO @prjid_1,
                            @sharelevel_1
                        WHILE @@fetch_status = 0 
                            BEGIN
                                SELECT  @countrec = COUNT(prjid)
                                FROM    PrjShareDetail
                                WHERE   prjid = @prjid_1
                                        AND userid = @resourceid_1
                                        AND usertype = 1
                                IF @countrec = 0 
                                    BEGIN
                                        INSERT  INTO PrjShareDetail
                                        VALUES  ( @prjid_1, @resourceid_1, 1,
                                                  @sharelevel_1 )
                                    END
                                ELSE 
                                    IF @sharelevel_1 = 2 
                                        BEGIN
                                            UPDATE  PrjShareDetail
                                            SET     sharelevel = 2
                                            WHERE   prjid = @prjid_1
                                                    AND userid = @resourceid_1
                                                    AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */
                                        END
                                FETCH NEXT FROM shareprjid_cursor INTO @prjid_1,
                                    @sharelevel_1
                            END
                        CLOSE shareprjid_cursor
                        DEALLOCATE shareprjid_cursor  /* ------- CPT 部分 ------- */
                        DECLARE sharecptid_cursor CURSOR
                        FOR
                            SELECT DISTINCT
                                    t2.relateditemid ,
                                    t2.sharelevel
                            FROM    CptCapital t1 ,
                                    CptCapitalShareInfo t2 ,
                                    hrmdepartment t4
                            WHERE   t1.id = t2.relateditemid
                                    AND t2.roleid = @roleid_1
                                    AND t2.rolelevel <= @rolelevel_1
                                    AND t2.seclevel <= @seclevel_1
                                    AND t1.departmentid = t4.id
                                    AND t4.subcompanyid1 = @subcompanyid_1
                        OPEN sharecptid_cursor
                        FETCH NEXT FROM sharecptid_cursor INTO @cptid_1,
                            @sharelevel_1
                        WHILE @@fetch_status = 0 
                            BEGIN
                                SELECT  @countrec = COUNT(cptid)
                                FROM    CptShareDetail
                                WHERE   cptid = @cptid_1
                                        AND userid = @resourceid_1
                                        AND usertype = 1
                                IF @countrec = 0 
                                    BEGIN
                                        INSERT  INTO CptShareDetail
                                        VALUES  ( @cptid_1, @resourceid_1, 1,
                                                  @sharelevel_1 )
                                    END
                                ELSE 
                                    IF @sharelevel_1 = 2 
                                        BEGIN
                                            UPDATE  CptShareDetail
                                            SET     sharelevel = 2
                                            WHERE   cptid = @cptid_1
                                                    AND userid = @resourceid_1
                                                    AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */
                                        END
                                FETCH NEXT FROM sharecptid_cursor INTO @cptid_1,
                                    @sharelevel_1
                            END
                        CLOSE sharecptid_cursor
                        DEALLOCATE sharecptid_cursor    /* ------- 客户合同部分 分部 2003-11-06杨国生------- */
                        DECLARE roleids_cursor CURSOR
                        FOR
                            SELECT  roleid
                            FROM    SystemRightRoles
                            WHERE   rightid = 396 /*396为客户合同管理权限*/
                        OPEN roleids_cursor
                        FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
                        WHILE @@fetch_status = 0 
                            BEGIN
                                DECLARE rolecontractid_cursor CURSOR
                                FOR
                                    SELECT DISTINCT
                                            t1.id
                                    FROM    CRM_Contract t1 ,
                                            hrmrolemembers t2
                                    WHERE   t2.roleid = @contractroleid_1
                                            AND t2.resourceid = @resourceid_1
                                            AND ( t2.rolelevel = 1
                                                  AND t1.subcompanyid1 = @subcompanyid_1
                                                );
                                    OPEN rolecontractid_cursor
                                FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
                                WHILE @@fetch_status = 0 
                                    BEGIN
                                        SELECT  @countrec = COUNT(contractid)
                                        FROM    ContractShareDetail
                                        WHERE   contractid = @contractid_1
                                                AND userid = @resourceid_1
                                                AND usertype = 1
                                        IF @countrec = 0 
                                            BEGIN
                                                INSERT  INTO ContractShareDetail
                                                VALUES  ( @contractid_1,
                                                          @resourceid_1, 1, 2 )
                                            END
                                        ELSE 
                                            BEGIN
                                                SELECT  @sharelevel_1 = sharelevel
                                                FROM    ContractShareDetail
                                                WHERE   contractid = @contractid_1
                                                        AND userid = @resourceid_1
                                                        AND usertype = 1
                                                IF @sharelevel_1 = 1 
                                                    BEGIN
                                                        UPDATE
                                                              ContractShareDetail
                                                        SET   sharelevel = 2
                                                        WHERE contractid = @contractid_1
                                                              AND userid = @resourceid_1
                                                              AND usertype = 1
                                                    END
                                            END
                                        FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
                                    END
                                CLOSE rolecontractid_cursor
                                DEALLOCATE rolecontractid_cursor
                                FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
                            END
                        CLOSE roleids_cursor
                        DEALLOCATE roleids_cursor  /* for work plan */ /* added by lupeng 2004-07-22 */
                        DECLARE sharewp_cursor CURSOR
                        FOR
                            SELECT DISTINCT
                                    t2.workPlanId ,
                                    t2.shareLevel
                            FROM    WorkPlan t1 ,
                                    WorkPlanShare t2
                            WHERE   t1.id = t2.workPlanId
                                    AND t2.roleId = @roleid_1
                                    AND t2.roleLevel <= @rolelevel_1
                                    AND t2.securityLevel <= @seclevel_1
                                    AND t1.subcompanyId = @subcompanyid_1
                        OPEN sharewp_cursor
                        FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1,
                            @sharelevel_1
                        WHILE ( @@FETCH_STATUS = 0 ) 
                            BEGIN
                                SELECT  @countrec = COUNT(workid)
                                FROM    WorkPlanShareDetail
                                WHERE   workid = @workPlanId_1
                                        AND userid = @resourceid_1
                                        AND usertype = 1
                                IF ( @countrec = 0 ) 
                                    BEGIN
                                    	SELECT COUNT(*) FROM WorkPlanShareDetail
                                    	/*
                                        INSERT  INTO WorkPlanShareDetail
                                                ( workid ,
                                                  userid ,
                                                  usertype ,
                                                  sharelevel
                                                )
                                        VALUES  ( @workPlanId_1 ,
                                                  @resourceid_1 ,
                                                  1 ,
                                                  @sharelevel_1
                                                )*/
                                    END
                                ELSE 
                                    IF ( @sharelevel_1 = 2 ) 
                                        BEGIN
                                            UPDATE  WorkPlanShareDetail
                                            SET     sharelevel = 2
                                            WHERE   workid = @workPlanId_1
                                                    AND userid = @resourceid_1
                                                    AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */
                                        END
                                FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1,
                                    @sharelevel_1
                            END
                        CLOSE sharewp_cursor
                        DEALLOCATE sharewp_cursor /* end */
                    END
                ELSE 
                    IF @rolelevel_1 = '0'          /* 为新建时候设定级别为部门级 */ 
                        BEGIN    /* ------- CRM 部分 ---角色变化不影响客户和日程的共享，共享跟角色相对独立---- */
                            DECLARE sharecrmid_cursor CURSOR
                            FOR
                                SELECT DISTINCT
                                        t2.relateditemid ,
                                        t2.sharelevel
                                FROM    CRM_CustomerInfo t1 ,
                                        CRM_ShareInfo t2
                                WHERE   t1.id = t2.relateditemid
                                        AND t2.contents = @roleid_1
                                        AND t2.rolelevel <= @rolelevel_1
                                        AND t2.seclevel <= @seclevel_1
                                        AND t1.department = @departmentid_1
                            OPEN sharecrmid_cursor
                            FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1,
                                @sharelevel_1
                            WHILE @@fetch_status = 0 
                                BEGIN  /* added by lupeng 2004-07-22 for customer contact work plan */
                                    DECLARE ccwp_cursor CURSOR
                                    FOR
                                        SELECT  id
                                        FROM    WorkPlan
                                        WHERE   type_n = '3'
                                                AND ',' + crmid + ',' LIKE '%,'
                                                + CONVERT(VARCHAR(100), @crmid_1)
                                                + ',%'
                                    OPEN ccwp_cursor
                                    FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                                    WHILE ( @@FETCH_STATUS = 0 ) 
                                        BEGIN
                                            IF NOT EXISTS ( SELECT
                                                              workid
                                                            FROM
                                                              WorkPlanShareDetail
                                                            WHERE
                                                              workid = @workPlanId_1
                                                              AND userid = @resourceid_1
                                                              AND usertype = 1 ) 
                                                SELECT COUNT(*) FROM WorkPlanShareDetail
                                                /*
                                                INSERT  INTO WorkPlanShareDetail
                                                        ( workid ,
                                                          userid ,
                                                          usertype ,
                                                          sharelevel
                                                        )
                                                VALUES  ( @workPlanId_1 ,
                                                          @resourceid_1 ,
                                                          1 ,
                                                          0
                                                        )*/
                                            FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                                        END
                                    CLOSE ccwp_cursor
                                    DEALLOCATE ccwp_cursor /* end */
                                    FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1,
                                        @sharelevel_1
                                END
                            CLOSE sharecrmid_cursor
                            DEALLOCATE sharecrmid_cursor  /* ------- PRJ 部分 ------- */
                            DECLARE shareprjid_cursor CURSOR
                            FOR
                                SELECT DISTINCT
                                        t2.relateditemid ,
                                        t2.sharelevel
                                FROM    Prj_ProjectInfo t1 ,
                                        Prj_ShareInfo t2
                                WHERE   t1.id = t2.relateditemid
                                        AND t2.roleid = @roleid_1
                                        AND t2.rolelevel <= @rolelevel_1
                                        AND t2.seclevel <= @seclevel_1
                                        AND t1.department = @departmentid_1
                            OPEN shareprjid_cursor
                            FETCH NEXT FROM shareprjid_cursor INTO @prjid_1,
                                @sharelevel_1
                            WHILE @@fetch_status = 0 
                                BEGIN
                                    SELECT  @countrec = COUNT(prjid)
                                    FROM    PrjShareDetail
                                    WHERE   prjid = @prjid_1
                                            AND userid = @resourceid_1
                                            AND usertype = 1
                                    IF @countrec = 0 
                                        BEGIN
                                            INSERT  INTO PrjShareDetail
                                            VALUES  ( @prjid_1, @resourceid_1,
                                                      1, @sharelevel_1 )
                                        END
                                    ELSE 
                                        IF @sharelevel_1 = 2 
                                            BEGIN
                                                UPDATE  PrjShareDetail
                                                SET     sharelevel = 2
                                                WHERE   prjid = @prjid_1
                                                        AND userid = @resourceid_1
                                                        AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */
                                            END
                                    FETCH NEXT FROM shareprjid_cursor INTO @prjid_1,
                                        @sharelevel_1
                                END
                            CLOSE shareprjid_cursor
                            DEALLOCATE shareprjid_cursor  /* ------- CPT 部分 ------- */
                            DECLARE sharecptid_cursor CURSOR
                            FOR
                                SELECT DISTINCT
                                        t2.relateditemid ,
                                        t2.sharelevel
                                FROM    CptCapital t1 ,
                                        CptCapitalShareInfo t2
                                WHERE   t1.id = t2.relateditemid
                                        AND t2.roleid = @roleid_1
                                        AND t2.rolelevel <= @rolelevel_1
                                        AND t2.seclevel <= @seclevel_1
                                        AND t1.departmentid = @departmentid_1
                            OPEN sharecptid_cursor
                            FETCH NEXT FROM sharecptid_cursor INTO @cptid_1,
                                @sharelevel_1
                            WHILE @@fetch_status = 0 
                                BEGIN
                                    SELECT  @countrec = COUNT(cptid)
                                    FROM    CptShareDetail
                                    WHERE   cptid = @cptid_1
                                            AND userid = @resourceid_1
                                            AND usertype = 1
                                    IF @countrec = 0 
                                        BEGIN
                                            INSERT  INTO CptShareDetail
                                            VALUES  ( @cptid_1, @resourceid_1,
                                                      1, @sharelevel_1 )
                                        END
                                    ELSE 
                                        IF @sharelevel_1 = 2 
                                            BEGIN
                                                UPDATE  CptShareDetail
                                                SET     sharelevel = 2
                                                WHERE   cptid = @cptid_1
                                                        AND userid = @resourceid_1
                                                        AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */
                                            END
                                    FETCH NEXT FROM sharecptid_cursor INTO @cptid_1,
                                        @sharelevel_1
                                END
                            CLOSE sharecptid_cursor
                            DEALLOCATE sharecptid_cursor   /* ------- 客户合同部分 部门 2003-11-06杨国生------- */
                            DECLARE roleids_cursor CURSOR
                            FOR
                                SELECT  roleid
                                FROM    SystemRightRoles
                                WHERE   rightid = 396 /*396为客户合同管理权限*/
                            OPEN roleids_cursor
                            FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
                            WHILE @@fetch_status = 0 
                                BEGIN
                                    DECLARE rolecontractid_cursor CURSOR
                                    FOR
                                        SELECT DISTINCT
                                                t1.id
                                        FROM    CRM_Contract t1 ,
                                                hrmrolemembers t2
                                        WHERE   t2.roleid = @contractroleid_1
                                                AND t2.resourceid = @resourceid_1
                                                AND ( t2.rolelevel = 0
                                                      AND t1.department = @departmentid_1
                                                    );
                                        OPEN rolecontractid_cursor
                                    FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
                                    WHILE @@fetch_status = 0 
                                        BEGIN
                                            SELECT  @countrec = COUNT(contractid)
                                            FROM    ContractShareDetail
                                            WHERE   contractid = @contractid_1
                                                    AND userid = @resourceid_1
                                                    AND usertype = 1
                                            IF @countrec = 0 
                                                BEGIN
                                                    INSERT  INTO ContractShareDetail
                                                    VALUES  ( @contractid_1,
                                                              @resourceid_1, 1,
                                                              2 )
                                                END
                                            ELSE 
                                                BEGIN
                                                    SELECT  @sharelevel_1 = sharelevel
                                                    FROM    ContractShareDetail
                                                    WHERE   contractid = @contractid_1
                                                            AND userid = @resourceid_1
                                                            AND usertype = 1
                                                    IF @sharelevel_1 = 1 
                                                        BEGIN
                                                            UPDATE
                                                              ContractShareDetail
                                                            SET
                                                              sharelevel = 2
                                                            WHERE
                                                              contractid = @contractid_1
                                                              AND userid = @resourceid_1
                                                              AND usertype = 1
                                                        END
                                                END
                                            FETCH NEXT FROM
                                                rolecontractid_cursor INTO @contractid_1
                                        END
                                    CLOSE rolecontractid_cursor
                                    DEALLOCATE rolecontractid_cursor
                                    FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
                                END
                            CLOSE roleids_cursor
                            DEALLOCATE roleids_cursor  /* for work plan */ /* added by lupeng 2004-07-22 */
                            DECLARE sharewp_cursor CURSOR
                            FOR
                                SELECT DISTINCT
                                        t2.workPlanId ,
                                        t2.shareLevel
                                FROM    WorkPlan t1 ,
                                        WorkPlanShare t2
                                WHERE   t1.id = t2.workPlanId
                                        AND t2.roleId = @roleid_1
                                        AND t2.roleLevel <= @rolelevel_1
                                        AND t2.securityLevel <= @seclevel_1
                                        AND t1.deptId LIKE '%,'
                                        + CAST(@departmentid_1 AS VARCHAR(10))
                                        + ',%'
                            OPEN sharewp_cursor
                            FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1,
                                @sharelevel_1
                            WHILE ( @@FETCH_STATUS = 0 ) 
                                BEGIN
                                    SELECT  @countrec = COUNT(workid)
                                    FROM    WorkPlanShareDetail
                                    WHERE   workid = @workPlanId_1
                                            AND userid = @resourceid_1
                                            AND usertype = 1
                                    IF ( @countrec = 0 ) 
                                        BEGIN
                                        	SELECT COUNT(*) FROM WorkPlanShareDetail
                                        	/*
                                            INSERT  INTO WorkPlanShareDetail
                                                    ( workid ,
                                                      userid ,
                                                      usertype ,
                                                      sharelevel
                                                    )
                                            VALUES  ( @workPlanId_1 ,
                                                      @resourceid_1 ,
                                                      1 ,
                                                      @sharelevel_1
                                                    )*/
                                        END
                                    ELSE 
                                        IF ( @sharelevel_1 = 2 ) 
                                            BEGIN
                                                UPDATE  WorkPlanShareDetail
                                                SET     sharelevel = 2
                                                WHERE   workid = @workPlanId_1
                                                        AND userid = @resourceid_1
                                                        AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */
                                            END
                                    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1,
                                        @sharelevel_1
                                END
                            CLOSE sharewp_cursor
                            DEALLOCATE sharewp_cursor /* end */
                        END
        END
    ELSE 
        IF ( @flag_1 = 2
             OR ( @flag_1 = 1
                  AND @rolelevel_1 < @rolelevel_2
                )
           ) /* 当为删除或者级别降低 */ 
            BEGIN
                SELECT  @departmentid_1 = departmentid ,
                        @subcompanyid_1 = subcompanyid1 ,
                        @seclevel_1 = seclevel
                FROM    hrmresource
                WHERE   id = @resourceid_1
                IF @departmentid_1 IS NULL 
                    SET @departmentid_1 = 0
                IF @subcompanyid_1 IS NULL 
                    SET @subcompanyid_1 = 0       /* ------- CRM  部分 ----角色变化不影响客户和日程的共享，共享跟角色相对独立--- */   /* 删除原有的该人的所有客户共享信息 delete from CrmShareDetail where userid = @resourceid_1 and usertype = 1*/  /* delete the work plan share info of this user */ /* 该delete语句在角色删除时引起共享的日程数据丢失，日程跟客户关系似乎并无联系，通过与oracle语句对比oracle已经去掉该段，此处暂做注释 by60427*/ /* DELETE WorkPlanShareDetail WHERE userid = @resourceid_1 AND usertype = 1 */   /* 定义临时表变量 */
                DECLARE @temptablevaluecrm TABLE
                    (
                      crmid INT ,
                      sharelevel INT
                    )  /*  将所有的信息现放到 @temptablevaluecrm 中 */ /*  自己是 manager 的客户 2 */
                DECLARE crmid_cursor CURSOR
                FOR
                    SELECT  id
                    FROM    CRM_CustomerInfo
                    WHERE   manager = @resourceid_1
                OPEN crmid_cursor
                FETCH NEXT FROM crmid_cursor INTO @crmid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        INSERT  INTO @temptablevaluecrm
                        VALUES  ( @crmid_1, 2 )
                        FETCH NEXT FROM crmid_cursor INTO @crmid_1
                    END
                CLOSE crmid_cursor
                DEALLOCATE crmid_cursor   /* 自己下级的客户 3 */ /* 查找下级 */
                SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                    + ',%'
                DECLARE subcrmid_cursor CURSOR
                FOR
                    SELECT  id
                    FROM    CRM_CustomerInfo
                    WHERE   ( manager IN (
                              SELECT DISTINCT
                                        id
                              FROM      HrmResource
                              WHERE     ',' + managerstr LIKE @managerstr_11 ) )
                OPEN subcrmid_cursor
                FETCH NEXT FROM subcrmid_cursor INTO @crmid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(crmid)
                        FROM    @temptablevaluecrm
                        WHERE   crmid = @crmid_1
                        IF @countrec = 0 
                            INSERT  INTO @temptablevaluecrm
                            VALUES  ( @crmid_1, 3 )
                        FETCH NEXT FROM subcrmid_cursor INTO @crmid_1
                    END
                CLOSE subcrmid_cursor
                DEALLOCATE subcrmid_cursor  /* 作为crm管理员能看到的客户 */
                DECLARE rolecrmid_cursor CURSOR
                FOR
                    SELECT DISTINCT
                            t1.id
                    FROM    CRM_CustomerInfo t1 ,
                            hrmrolemembers t2
                    WHERE   t2.roleid = 8
                            AND t2.resourceid = @resourceid_1
                            AND ( t2.rolelevel = 2
                                  OR ( t2.rolelevel = 0
                                       AND t1.department = @departmentid_1
                                     )
                                  OR ( t2.rolelevel = 1
                                       AND t1.subcompanyid1 = @subcompanyid_1
                                     )
                                )
                OPEN rolecrmid_cursor
                FETCH NEXT FROM rolecrmid_cursor INTO @crmid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(crmid)
                        FROM    @temptablevaluecrm
                        WHERE   crmid = @crmid_1
                        IF @countrec = 0 
                            INSERT  INTO @temptablevaluecrm
                            VALUES  ( @crmid_1, 4 )
                        FETCH NEXT FROM rolecrmid_cursor INTO @crmid_1
                    END
                CLOSE rolecrmid_cursor
                DEALLOCATE rolecrmid_cursor   /* 由客户的共享获得的权利 1 2 */
                DECLARE sharecrmid_cursor CURSOR
                FOR
                    SELECT DISTINCT
                            t2.relateditemid ,
                            t2.sharelevel
                    FROM    CRM_ShareInfo t2
                    WHERE   ( ( t2.foralluser = 1
                                AND t2.seclevel <= @seclevel_1
                              )
                              OR ( t2.userid = @resourceid_1 )
                              OR ( t2.departmentid = @departmentid_1
                                   AND t2.seclevel <= @seclevel_1
                                 )
                            )
                OPEN sharecrmid_cursor
                FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1, @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(crmid)
                        FROM    @temptablevaluecrm
                        WHERE   crmid = @crmid_1
                        IF @countrec = 0 
                            BEGIN
                                INSERT  INTO @temptablevaluecrm
                                VALUES  ( @crmid_1, @sharelevel_1 )
                            END
                        FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1,
                            @sharelevel_1
                    END
                CLOSE sharecrmid_cursor
                DEALLOCATE sharecrmid_cursor
                DECLARE sharecrmid_cursor CURSOR
                FOR
                    SELECT DISTINCT
                            t2.relateditemid ,
                            t2.sharelevel
                    FROM    CRM_CustomerInfo t1 ,
                            CRM_ShareInfo t2 ,
                            HrmRoleMembers t3
                    WHERE   t1.id = t2.relateditemid
                            AND t3.resourceid = @resourceid_1
                            AND t3.roleid = t2.roleid
                            AND t3.rolelevel >= t2.rolelevel
                            AND t2.seclevel <= @seclevel_1
                            AND ( ( t2.rolelevel = 0
                                    AND t1.department = @departmentid_1
                                  )
                                  OR ( t2.rolelevel = 1
                                       AND t1.subcompanyid1 = @subcompanyid_1
                                     )
                                  OR ( t3.rolelevel = 2 )
                                )
                OPEN sharecrmid_cursor
                FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1, @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(crmid)
                        FROM    @temptablevaluecrm
                        WHERE   crmid = @crmid_1
                        IF @countrec = 0 
                            BEGIN
                                INSERT  INTO @temptablevaluecrm
                                VALUES  ( @crmid_1, @sharelevel_1 )
                            END
                        FETCH NEXT FROM sharecrmid_cursor INTO @crmid_1,
                            @sharelevel_1
                    END
                CLOSE sharecrmid_cursor
                DEALLOCATE sharecrmid_cursor   /* 将临时表中的数据写入共享表 */
                DECLARE allcrmid_cursor CURSOR
                FOR
                    SELECT  *
                    FROM    @temptablevaluecrm
                OPEN allcrmid_cursor
                FETCH NEXT FROM allcrmid_cursor INTO @crmid_1, @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN /*insert into CrmShareDetail( crmid, userid, usertype, sharelevel) values(@crmid_1, @resourceid_1,1,@sharelevel_1)*/  /* added by lupeng 2004-07-22 for customer contact work plan */
                        DECLARE ccwp_cursor CURSOR
                        FOR
                            SELECT  id
                            FROM    WorkPlan
                            WHERE   type_n = '3'
                                    AND crmid = CONVERT(VARCHAR(100), @crmid_1)
                        OPEN ccwp_cursor
                        FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                        WHILE ( @@FETCH_STATUS = 0 ) 
                            BEGIN
                                IF NOT EXISTS ( SELECT  workid
                                                FROM    WorkPlanShareDetail
                                                WHERE   workid = @workPlanId_1
                                                        AND userid = @resourceid_1
                                                        AND usertype = 1 )
                                                        SELECT COUNT(*) FROM WorkPlanShareDetail
                                                        /* 
                                    INSERT  INTO WorkPlanShareDetail
                                            ( workid ,
                                              userid ,
                                              usertype ,
                                              sharelevel
                                            )
                                    VALUES  ( @workPlanId_1 ,
                                              @resourceid_1 ,
                                              1 ,
                                              1
                                            )*/
                                FETCH NEXT FROM ccwp_cursor INTO @workPlanId_1
                            END
                        CLOSE ccwp_cursor
                        DEALLOCATE ccwp_cursor /* end */
                        FETCH NEXT FROM allcrmid_cursor INTO @crmid_1,
                            @sharelevel_1
                    END
                CLOSE allcrmid_cursor
                DEALLOCATE allcrmid_cursor  /* ------- PROJ 部分 ------- */  /* 定义临时表变量 */
                DECLARE @temptablevaluePrj TABLE
                    (
                      prjid INT ,
                      sharelevel INT
                    )  /*  将所有的信息现放到 @temptablevaluePrj 中 */ /*  自己的项目2 */
                DECLARE prjid_cursor CURSOR
                FOR
                    SELECT  id
                    FROM    Prj_ProjectInfo
                    WHERE   manager = @resourceid_1
                OPEN prjid_cursor
                FETCH NEXT FROM prjid_cursor INTO @prjid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        INSERT  INTO @temptablevaluePrj
                        VALUES  ( @prjid_1, 2 )
                        FETCH NEXT FROM prjid_cursor INTO @prjid_1
                    END
                CLOSE prjid_cursor
                DEALLOCATE prjid_cursor   /* 自己下级的项目3 */ /* 查找下级 */
                SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                    + ',%'
                DECLARE subprjid_cursor CURSOR
                FOR
                    SELECT  id
                    FROM    Prj_ProjectInfo
                    WHERE   ( manager IN (
                              SELECT DISTINCT
                                        id
                              FROM      HrmResource
                              WHERE     ',' + managerstr LIKE @managerstr_11 ) )
                OPEN subprjid_cursor
                FETCH NEXT FROM subprjid_cursor INTO @prjid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(prjid)
                        FROM    @temptablevaluePrj
                        WHERE   prjid = @prjid_1
                        IF @countrec = 0 
                            INSERT  INTO @temptablevaluePrj
                            VALUES  ( @prjid_1, 3 )
                        FETCH NEXT FROM subprjid_cursor INTO @prjid_1
                    END
                CLOSE subprjid_cursor
                DEALLOCATE subprjid_cursor  /* 作为项目管理员能看到的项目4 */
                DECLARE roleprjid_cursor CURSOR
                FOR
                    SELECT DISTINCT
                            t1.id
                    FROM    Prj_ProjectInfo t1 ,
                            hrmrolemembers t2
                    WHERE   t2.roleid = 9
                            AND t2.resourceid = @resourceid_1
                            AND ( t2.rolelevel = 2
                                  OR ( t2.rolelevel = 0
                                       AND t1.department = @departmentid_1
                                     )
                                  OR ( t2.rolelevel = 1
                                       AND t1.subcompanyid1 = @subcompanyid_1
                                     )
                                )
                OPEN roleprjid_cursor
                FETCH NEXT FROM roleprjid_cursor INTO @prjid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(prjid)
                        FROM    @temptablevaluePrj
                        WHERE   prjid = @prjid_1
                        IF @countrec = 0 
                            INSERT  INTO @temptablevaluePrj
                            VALUES  ( @prjid_1, 4 )
                        FETCH NEXT FROM roleprjid_cursor INTO @prjid_1
                    END
                CLOSE roleprjid_cursor
                DEALLOCATE roleprjid_cursor   /* 由项目的共享获得的权利 1 2 */
                DECLARE shareprjid_cursor CURSOR
                FOR
                    SELECT DISTINCT
                            t2.relateditemid ,
                            t2.sharelevel
                    FROM    Prj_ShareInfo t2
                    WHERE   ( ( t2.foralluser = 1
                                AND t2.seclevel <= @seclevel_1
                              )
                              OR ( t2.userid = @resourceid_1 )
                              OR ( t2.departmentid = @departmentid_1
                                   AND t2.seclevel <= @seclevel_1
                                 )
                            )
                OPEN shareprjid_cursor
                FETCH NEXT FROM shareprjid_cursor INTO @prjid_1, @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(prjid)
                        FROM    @temptablevaluePrj
                        WHERE   prjid = @prjid_1
                        IF @countrec = 0 
                            BEGIN
                                INSERT  INTO @temptablevaluePrj
                                VALUES  ( @prjid_1, @sharelevel_1 )
                            END
                        FETCH NEXT FROM shareprjid_cursor INTO @prjid_1,
                            @sharelevel_1
                    END
                CLOSE shareprjid_cursor
                DEALLOCATE shareprjid_cursor
                DECLARE shareprjid_cursor CURSOR
                FOR
                    SELECT DISTINCT
                            t2.relateditemid ,
                            t2.sharelevel
                    FROM    Prj_ProjectInfo t1 ,
                            Prj_ShareInfo t2 ,
                            HrmRoleMembers t3
                    WHERE   t1.id = t2.relateditemid
                            AND t3.resourceid = @resourceid_1
                            AND t3.roleid = t2.roleid
                            AND t3.rolelevel >= t2.rolelevel
                            AND t2.seclevel <= @seclevel_1
                            AND ( ( t2.rolelevel = 0
                                    AND t1.department = @departmentid_1
                                  )
                                  OR ( t2.rolelevel = 1
                                       AND t1.subcompanyid1 = @subcompanyid_1
                                     )
                                  OR ( t3.rolelevel = 2 )
                                )
                OPEN shareprjid_cursor
                FETCH NEXT FROM shareprjid_cursor INTO @prjid_1, @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(prjid)
                        FROM    @temptablevaluePrj
                        WHERE   prjid = @prjid_1
                        IF @countrec = 0 
                            BEGIN
                                INSERT  INTO @temptablevaluePrj
                                VALUES  ( @prjid_1, @sharelevel_1 )
                            END
                        FETCH NEXT FROM shareprjid_cursor INTO @prjid_1,
                            @sharelevel_1
                    END
                CLOSE shareprjid_cursor
                DEALLOCATE shareprjid_cursor    /* 项目成员5 (内部用户) */
                DECLARE inuserprjid_cursor CURSOR
                FOR
                    SELECT DISTINCT
                            t2.id
                    FROM    Prj_TaskProcess t1 ,
                            Prj_ProjectInfo t2
                    WHERE   t1.hrmid = @resourceid_1
                            AND t2.id = t1.prjid
                            AND t1.isdelete <> '1'
                            AND t2.isblock = '1'
                OPEN inuserprjid_cursor
                FETCH NEXT FROM inuserprjid_cursor INTO @prjid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(prjid)
                        FROM    @temptablevaluePrj
                        WHERE   prjid = @prjid_1
                        IF @countrec = 0 
                            BEGIN
                                INSERT  INTO @temptablevaluePrj
                                VALUES  ( @prjid_1, 5 )
                            END
                        FETCH NEXT FROM inuserprjid_cursor INTO @prjid_1
                    END
                CLOSE inuserprjid_cursor
                DEALLOCATE inuserprjid_cursor   /* 删除原有的与该人员相关的所有项目权 */
                DELETE  FROM PrjShareDetail
                WHERE   userid = @resourceid_1
                        AND usertype = 1  /* 将临时表中的数据写入共享表 */
                DECLARE allprjid_cursor CURSOR
                FOR
                    SELECT  *
                    FROM    @temptablevaluePrj
                OPEN allprjid_cursor
                FETCH NEXT FROM allprjid_cursor INTO @prjid_1, @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        INSERT  INTO PrjShareDetail
                                ( prjid ,
                                  userid ,
                                  usertype ,
                                  sharelevel
                                )
                        VALUES  ( @prjid_1 ,
                                  @resourceid_1 ,
                                  1 ,
                                  @sharelevel_1
                                )
                        FETCH NEXT FROM allprjid_cursor INTO @prjid_1,
                            @sharelevel_1
                    END
                CLOSE allprjid_cursor
                DEALLOCATE allprjid_cursor   /* ------- CPT 部分 ------- */  /* 定义临时表变量 */
                DECLARE @temptablevalueCpt TABLE
                    (
                      cptid INT ,
                      sharelevel INT
                    )  /*  将所有的信息现放到 @temptablevalueCpt 中 */ /*  自己的资产2 */
                DECLARE cptid_cursor CURSOR
                FOR
                    SELECT  id
                    FROM    CptCapital
                    WHERE   resourceid = @resourceid_1
                OPEN cptid_cursor
                FETCH NEXT FROM cptid_cursor INTO @cptid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        INSERT  INTO @temptablevalueCpt
                        VALUES  ( @cptid_1, 2 )
                        FETCH NEXT FROM cptid_cursor INTO @cptid_1
                    END
                CLOSE cptid_cursor
                DEALLOCATE cptid_cursor   /* 自己下级的资产1 */ /* 查找下级 */
                SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                    + ',%'
                DECLARE subcptid_cursor CURSOR
                FOR
                    SELECT  id
                    FROM    CptCapital
                    WHERE   ( resourceid IN (
                              SELECT DISTINCT
                                        id
                              FROM      HrmResource
                              WHERE     ',' + managerstr LIKE @managerstr_11 ) )
                OPEN subcptid_cursor
                FETCH NEXT FROM subcptid_cursor INTO @cptid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(cptid)
                        FROM    @temptablevalueCpt
                        WHERE   cptid = @cptid_1
                        IF @countrec = 0 
                            INSERT  INTO @temptablevalueCpt
                            VALUES  ( @cptid_1, 1 )
                        FETCH NEXT FROM subcptid_cursor INTO @cptid_1
                    END
                CLOSE subcptid_cursor
                DEALLOCATE subcptid_cursor   /* 由资产的共享获得的权利 1 2 */
                DECLARE sharecptid_cursor CURSOR
                FOR
                    SELECT DISTINCT
                            t2.relateditemid ,
                            t2.sharelevel
                    FROM    CptCapitalShareInfo t2
                    WHERE   ( ( t2.foralluser = 1
                                AND t2.seclevel <= @seclevel_1
                              )
                              OR ( t2.userid = @resourceid_1 )
                              OR ( t2.departmentid = @departmentid_1
                                   AND t2.seclevel <= @seclevel_1
                                 )
                            )
                OPEN sharecptid_cursor
                FETCH NEXT FROM sharecptid_cursor INTO @cptid_1, @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(cptid)
                        FROM    @temptablevalueCpt
                        WHERE   cptid = @cptid_1
                        IF @countrec = 0 
                            BEGIN
                                INSERT  INTO @temptablevalueCpt
                                VALUES  ( @cptid_1, @sharelevel_1 ) /*2004-8-3 路碰 -- 角色改变时，资产的权限共享不起作用。*/
                            END
                        FETCH NEXT FROM sharecptid_cursor INTO @cptid_1,
                            @sharelevel_1
                    END
                CLOSE sharecptid_cursor
                DEALLOCATE sharecptid_cursor
                DECLARE sharecptid_cursor CURSOR
                FOR
                    SELECT DISTINCT
                            t2.relateditemid ,
                            t2.sharelevel
                    FROM    CptCapital t1 ,
                            CptCapitalShareInfo t2 ,
                            HrmRoleMembers t3 ,
                            hrmdepartment t4
                    WHERE   t1.id = t2.relateditemid
                            AND t3.resourceid = @resourceid_1
                            AND t3.roleid = t2.roleid
                            AND t3.rolelevel >= t2.rolelevel
                            AND t2.seclevel <= @seclevel_1
                            AND ( ( t2.rolelevel = 0
                                    AND t1.departmentid = @departmentid_1
                                  )
                                  OR ( t2.rolelevel = 1
                                       AND t1.departmentid = t4.id
                                       AND t4.subcompanyid1 = @subcompanyid_1
                                     )
                                  OR ( t3.rolelevel = 2 )
                                )
                OPEN sharecptid_cursor
                FETCH NEXT FROM sharecptid_cursor INTO @cptid_1, @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(cptid)
                        FROM    @temptablevalueCpt
                        WHERE   cptid = @cptid_1
                        IF @countrec = 0 
                            BEGIN
                                INSERT  INTO @temptablevalueCpt
                                VALUES  ( @cptid_1, @sharelevel_1 )
                            END
                        FETCH NEXT FROM sharecptid_cursor INTO @cptid_1,
                            @sharelevel_1
                    END
                CLOSE sharecptid_cursor
                DEALLOCATE sharecptid_cursor    /* 删除原有的与该人员相关的所有资产权 */
                DELETE  FROM CptShareDetail
                WHERE   userid = @resourceid_1
                        AND usertype = 1  /* 将临时表中的数据写入共享表 */
                DECLARE allcptid_cursor CURSOR
                FOR
                    SELECT  *
                    FROM    @temptablevalueCpt
                OPEN allcptid_cursor
                FETCH NEXT FROM allcptid_cursor INTO @cptid_1, @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        INSERT  INTO CptShareDetail
                                ( cptid ,
                                  userid ,
                                  usertype ,
                                  sharelevel
                                )
                        VALUES  ( @cptid_1 ,
                                  @resourceid_1 ,
                                  1 ,
                                  @sharelevel_1
                                )
                        FETCH NEXT FROM allcptid_cursor INTO @cptid_1,
                            @sharelevel_1
                    END
                CLOSE allcptid_cursor
                DEALLOCATE allcptid_cursor    /* ------- 客户合同部分2003-11-06杨国生 ------- */  /* 定义临时表变量 */
                DECLARE @temptablevaluecontract TABLE
                    (
                      contractid INT ,
                      sharelevel INT
                    )  /*  将所有的信息现放到 @temptablevaluecontract 中 */  /* 自己下级的客户合同 3 */
                SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                    + ',%'
                DECLARE subcontractid_cursor CURSOR
                FOR
                    SELECT  id
                    FROM    CRM_Contract
                    WHERE   ( manager IN (
                              SELECT DISTINCT
                                        id
                              FROM      HrmResource
                              WHERE     ',' + managerstr LIKE @managerstr_11 ) )
                OPEN subcontractid_cursor
                FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(contractid)
                        FROM    @temptablevaluecontract
                        WHERE   contractid = @contractid_1
                        IF @countrec = 0 
                            INSERT  INTO @temptablevaluecontract
                            VALUES  ( @contractid_1, 3 )
                        FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
                    END
                CLOSE subcontractid_cursor
                DEALLOCATE subcontractid_cursor   /*  自己是 manager 的客户合同 2 */
                DECLARE contractid_cursor CURSOR
                FOR
                    SELECT  id
                    FROM    CRM_Contract
                    WHERE   manager = @resourceid_1
                OPEN contractid_cursor
                FETCH NEXT FROM contractid_cursor INTO @contractid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        INSERT  INTO @temptablevaluecontract
                        VALUES  ( @contractid_1, 2 )
                        FETCH NEXT FROM contractid_cursor INTO @contractid_1
                    END
                CLOSE contractid_cursor
                DEALLOCATE contractid_cursor    /* 作为客户合同管理员能看到的 */
                DECLARE roleids_cursor CURSOR
                FOR
                    SELECT  roleid
                    FROM    SystemRightRoles
                    WHERE   rightid = 396
                OPEN roleids_cursor
                FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        DECLARE rolecontractid_cursor CURSOR
                        FOR
                            SELECT DISTINCT
                                    t1.id
                            FROM    CRM_Contract t1 ,
                                    hrmrolemembers t2
                            WHERE   t2.roleid = @contractroleid_1
                                    AND t2.resourceid = @resourceid_1
                                    AND ( t2.rolelevel = 2
                                          OR ( t2.rolelevel = 0
                                               AND t1.department = @departmentid_1
                                             )
                                          OR ( t2.rolelevel = 1
                                               AND t1.subcompanyid1 = @subcompanyid_1
                                             )
                                        );
                            OPEN rolecontractid_cursor
                        FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
                        WHILE @@fetch_status = 0 
                            BEGIN
                                SELECT  @countrec = COUNT(contractid)
                                FROM    @temptablevaluecontract
                                WHERE   contractid = @contractid_1
                                IF @countrec = 0 
                                    BEGIN
                                        INSERT  INTO @temptablevaluecontract
                                        VALUES  ( @contractid_1, 2 )
                                    END
                                ELSE 
                                    BEGIN
                                        SELECT  @sharelevel_1 = sharelevel
                                        FROM    ContractShareDetail
                                        WHERE   contractid = @contractid_1
                                                AND userid = @resourceid_1
                                                AND usertype = 1
                                        IF @sharelevel_1 = 1 
                                            BEGIN
                                                UPDATE  ContractShareDetail
                                                SET     sharelevel = 2
                                                WHERE   contractid = @contractid_1
                                                        AND userid = @resourceid_1
                                                        AND usertype = 1
                                            END
                                    END
                                FETCH NEXT FROM rolecontractid_cursor INTO @contractid_1
                            END
                        CLOSE rolecontractid_cursor
                        DEALLOCATE rolecontractid_cursor
                        FETCH NEXT FROM roleids_cursor INTO @contractroleid_1
                    END
                CLOSE roleids_cursor
                DEALLOCATE roleids_cursor   /* 由客户合同的共享获得的权利 1 2 */
                DECLARE sharecontractid_cursor CURSOR
                FOR
                    SELECT DISTINCT
                            t2.relateditemid ,
                            t2.sharelevel
                    FROM    Contract_ShareInfo t2
                    WHERE   ( ( t2.foralluser = 1
                                AND t2.seclevel <= @seclevel_1
                              )
                              OR ( t2.userid = @resourceid_1 )
                              OR ( t2.departmentid = @departmentid_1
                                   AND t2.seclevel <= @seclevel_1
                                 )
                            )
                OPEN sharecontractid_cursor
                FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1,
                    @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(contractid)
                        FROM    @temptablevaluecontract
                        WHERE   contractid = @contractid_1
                        IF @countrec = 0 
                            BEGIN
                                INSERT  INTO @temptablevaluecontract
                                VALUES  ( @contractid_1, @sharelevel_1 )
                            END
                        ELSE 
                            BEGIN
                                SELECT  @sharelevel_Temp = sharelevel
                                FROM    @temptablevaluecontract
                                WHERE   contractid = @contractid_1
                                IF ( ( @sharelevel_Temp = 1 )
                                     AND ( @sharelevel_1 = 2 )
                                   ) 
                                    UPDATE  @temptablevaluecontract
                                    SET     sharelevel = @sharelevel_1
                                    WHERE   contractid = @contractid_1
                            END
                        FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1,
                            @sharelevel_1
                    END
                CLOSE sharecontractid_cursor
                DEALLOCATE sharecontractid_cursor
                DECLARE sharecontractid_cursor CURSOR
                FOR
                    SELECT DISTINCT
                            t2.relateditemid ,
                            t2.sharelevel
                    FROM    CRM_Contract t1 ,
                            Contract_ShareInfo t2 ,
                            HrmRoleMembers t3
                    WHERE   t1.id = t2.relateditemid
                            AND t3.resourceid = @resourceid_1
                            AND t3.roleid = t2.roleid
                            AND t3.rolelevel >= t2.rolelevel
                            AND t2.seclevel <= @seclevel_1
                            AND ( ( t2.rolelevel = 0
                                    AND t1.department = @departmentid_1
                                  )
                                  OR ( t2.rolelevel = 1
                                       AND t1.subcompanyid1 = @subcompanyid_1
                                     )
                                  OR ( t3.rolelevel = 2 )
                                )
                OPEN sharecontractid_cursor
                FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1,
                    @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(contractid)
                        FROM    @temptablevaluecontract
                        WHERE   contractid = @contractid_1
                        IF @countrec = 0 
                            BEGIN
                                INSERT  INTO @temptablevaluecontract
                                VALUES  ( @contractid_1, @sharelevel_1 )
                            END
                        ELSE 
                            BEGIN
                                SELECT  @sharelevel_Temp = sharelevel
                                FROM    @temptablevaluecontract
                                WHERE   contractid = @contractid_1
                                IF ( ( @sharelevel_Temp = 1 )
                                     AND ( @sharelevel_1 = 2 )
                                   ) 
                                    UPDATE  @temptablevaluecontract
                                    SET     sharelevel = @sharelevel_1
                                    WHERE   contractid = @contractid_1
                            END
                        FETCH NEXT FROM sharecontractid_cursor INTO @contractid_1,
                            @sharelevel_1
                    END
                CLOSE sharecontractid_cursor
                DEALLOCATE sharecontractid_cursor   /* 自己下级的客户合同  (客户经理及经理线)*/
                SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                    + ',%'
                DECLARE subcontractid_cursor CURSOR
                FOR
                    SELECT  t2.id
                    FROM    CRM_CustomerInfo t1 ,
                            CRM_Contract t2
                    WHERE   ( t1.manager IN (
                              SELECT DISTINCT
                                        id
                              FROM      HrmResource
                              WHERE     ',' + managerstr LIKE @managerstr_11 ) )
                            AND ( t2.crmId = t1.id )
                OPEN subcontractid_cursor
                FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        SELECT  @countrec = COUNT(contractid)
                        FROM    @temptablevaluecontract
                        WHERE   contractid = @contractid_1
                        IF @countrec = 0 
                            INSERT  INTO @temptablevaluecontract
                            VALUES  ( @contractid_1, 1 )
                        FETCH NEXT FROM subcontractid_cursor INTO @contractid_1
                    END
                CLOSE subcontractid_cursor
                DEALLOCATE subcontractid_cursor   /*  自己是 manager 的客户 (客户经理及经理线) */
                DECLARE contractid_cursor CURSOR
                FOR
                    SELECT  t2.id
                    FROM    CRM_CustomerInfo t1 ,
                            CRM_Contract t2
                    WHERE   ( t1.manager = @resourceid_1 )
                            AND ( t2.crmId = t1.id )
                OPEN contractid_cursor
                FETCH NEXT FROM contractid_cursor INTO @contractid_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        INSERT  INTO @temptablevaluecontract
                        VALUES  ( @contractid_1, 1 )
                        FETCH NEXT FROM contractid_cursor INTO @contractid_1
                    END
                CLOSE contractid_cursor
                DEALLOCATE contractid_cursor   /* 删除原有的与该人员相关的所有权 */
                DELETE  FROM ContractShareDetail
                WHERE   userid = @resourceid_1
                        AND usertype = 1  /* 将临时表中的数据写入共享表 */
                DECLARE allcontractid_cursor CURSOR
                FOR
                    SELECT  *
                    FROM    @temptablevaluecontract
                OPEN allcontractid_cursor
                FETCH NEXT FROM allcontractid_cursor INTO @contractid_1,
                    @sharelevel_1
                WHILE @@fetch_status = 0 
                    BEGIN
                        INSERT  INTO ContractShareDetail
                                ( contractid ,
                                  userid ,
                                  usertype ,
                                  sharelevel
                                )
                        VALUES  ( @contractid_1 ,
                                  @resourceid_1 ,
                                  1 ,
                                  @sharelevel_1
                                )
                        FETCH NEXT FROM allcontractid_cursor INTO @contractid_1,
                            @sharelevel_1
                    END
                CLOSE allcontractid_cursor
                DEALLOCATE allcontractid_cursor
            END        /* 结束角色删除或者级别降低的处理 */     /*================== 处理日程 ==================*/
    DECLARE @TmpTableValueWP TABLE
        (
          workPlanId INT ,
          shareLevel INT
        )  /* 调整人本人日程 */
    DECLARE creater_cursor CURSOR
    FOR
        SELECT  id
        FROM    WorkPlan
        WHERE   createrId = @resourceid_1
    OPEN creater_cursor
    FETCH NEXT FROM creater_cursor INTO @workPlanId_1
    WHILE ( @@FETCH_STATUS = 0 ) 
        BEGIN
            INSERT  INTO @TmpTableValueWP
            VALUES  ( @workPlanId_1, 2 )
            FETCH NEXT FROM creater_cursor INTO @workPlanId_1
        END
    CLOSE creater_cursor
    DEALLOCATE creater_cursor  /* 可以看到调整人下级日程 */
    SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1) + ',%'
    DECLARE underling_cursor CURSOR
    FOR
        SELECT  id
        FROM    WorkPlan
        WHERE   ( createrid IN ( SELECT DISTINCT
                                        id
                                 FROM   HrmResource
                                 WHERE  ',' + MANAGERSTR LIKE @managerstr_11 ) )
    OPEN underling_cursor
    FETCH NEXT FROM underling_cursor INTO @workPlanId_1
    WHILE ( @@FETCH_STATUS = 0 ) 
        BEGIN
            SELECT  @countrec = COUNT(workPlanId)
            FROM    @TmpTableValueWP
            WHERE   workPlanId = @workPlanId_1
            IF ( @countrec = 0 ) 
                INSERT  INTO @TmpTableValueWP
                VALUES  ( @workPlanId_1, 1 )
            FETCH NEXT FROM underling_cursor INTO @workPlanId_1
        END
    CLOSE underling_cursor
    DEALLOCATE underling_cursor   /* 可以看到日程共享设置中的日程 */
    DECLARE sharewp_cursor CURSOR
    FOR
        SELECT DISTINCT
                workPlanShare.workPlanId ,
                workPlanShare.shareLevel
        FROM    WorkPlanShare workPlanShare
        WHERE   ( /* 所有人 */ ( workPlanShare.forAll = 1
                              AND workPlanShare.securityLevel <= @seclevel_1
                            ) /* 人力资源 */
                  OR ( workPlanShare.userId LIKE '%,'
                       + CAST(@resourceid_1 AS VARCHAR(10)) + ',%' ) /* 部门 */
                  OR ( workPlanShare.deptId LIKE '%,'
                       + CAST(@departmentid_1 AS VARCHAR(10)) + ',%'
                       AND workPlanShare.securityLevel <= @seclevel_1
                     ) /* 分部 */
                  OR ( workPlanShare.subCompanyId LIKE '%,'
                       + CAST(@subcompanyid_1 AS VARCHAR(10)) + ',%'
                       AND workPlanShare.securityLevel <= @seclevel_1
                     )
                )
    OPEN sharewp_cursor
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    WHILE ( @@FETCH_STATUS = 0 ) 
        BEGIN
            SELECT  @countrec = COUNT(workPlanId)
            FROM    @TmpTableValueWP
            WHERE   workPlanId = @workPlanId_1
            IF ( @countrec = 0 ) 
                BEGIN
                    INSERT  INTO @TmpTableValueWP
                    VALUES  ( @workPlanId_1, @sharelevel_1 )
                END
            FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
        END
    CLOSE sharewp_cursor
    DEALLOCATE sharewp_cursor  /* 角色 */
    DECLARE sharewp_cursor CURSOR
    FOR
        SELECT DISTINCT
                workPlanShare.workPlanId ,
                workPlanShare.shareLevel
        FROM    WorkPlan workPlan ,
                WorkPlanShare workPlanShare ,
                HrmRoleMembers hrmRoleMembers
        WHERE   ( workPlan.id = workPlanShare.workPlanId
                  AND workPlanShare.roleId = hrmRoleMembers.roleId
                  AND hrmRoleMembers.resourceid = @resourceid_1
                  AND hrmRoleMembers.rolelevel >= workPlanShare.roleLevel
                  AND workPlanShare.securityLevel <= @seclevel_1
                )
    OPEN sharewp_cursor
    FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
    WHILE ( @@FETCH_STATUS = 0 ) 
        BEGIN
            SELECT  @countrec = COUNT(workPlanId)
            FROM    @TmpTableValueWP
            WHERE   workPlanId = @workPlanId_1
            IF ( @countrec = 0 ) 
                BEGIN
                    INSERT  INTO @TmpTableValueWP
                    VALUES  ( @workPlanId_1, @sharelevel_1 )
                END
            FETCH NEXT FROM sharewp_cursor INTO @workPlanId_1, @sharelevel_1
        END
    CLOSE sharewp_cursor
    DEALLOCATE sharewp_cursor   /* 由临时表写入明细表 */
    DECLARE allwp_cursor CURSOR
    FOR
        SELECT  *
        FROM    @TmpTableValueWP
    OPEN allwp_cursor
    FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
    WHILE ( @@FETCH_STATUS = 0 ) 
        BEGIN
            SELECT  @countrec = COUNT(workid)
            FROM    WorkPlanShareDetail
            WHERE   workid = @workPlanId_1
                    AND userid = @resourceid_1
                    AND usertype = 1
            IF ( @countrec = 0 ) 
                BEGIN
                	SELECT COUNT(*) FROM WorkPlanShareDetail
                	/*
                    INSERT  INTO WorkPlanShareDetail
                            ( workid ,
                              userid ,
                              usertype ,
                              sharelevel
                            )
                    VALUES  ( @workPlanId_1 ,
                              @resourceid_1 ,
                              1 ,
                              @sharelevel_1
                            )*/
                END
            ELSE 
                IF ( @sharelevel_1 = 2 ) 
                    BEGIN
                        UPDATE  WorkPlanShareDetail
                        SET     sharelevel = 2
                        WHERE   workid = @workPlanId_1
                                AND userid = @resourceid_1
                                AND usertype = 1  /* 共享是可以编辑, 则都修改原有记录 */
                    END
            FETCH NEXT FROM allwp_cursor INTO @workPlanId_1, @sharelevel_1
        END
    CLOSE allwp_cursor
    DEALLOCATE allwp_cursor  /* 日程共享结束 */     
    GO