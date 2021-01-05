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
                    
            DECLARE @temptablevaluecrm TABLE
                (
                  crmid INT ,
                  sharelevel INT
                )
          
            DECLARE @managerstr_11 VARCHAR(200)
            
            SET @managerstr_11 = '%,' + CONVERT(VARCHAR(5), @resourceid_1)
                + ',%'


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
                   
                END
            ELSE 
                IF @rolelevel_1 = '1'          /* 新的角色级别为分部级 */ 
                    BEGIN 
                        /* ------- 客户合同部分 分部 2003-11-06杨国生------- */
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
                        DEALLOCATE roleids_cursor  
                        
 
                    END
                ELSE 
                    IF @rolelevel_1 = '0'          /* 为新建时候设定级别为部门级 */ 
                        BEGIN  
                            /* ------- 客户合同部分 部门 2003-11-06杨国生------- */
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
                            DEALLOCATE roleids_cursor  
                            
                            

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
                    SET @subcompanyid_1 = 0       
                 

                /* ------- 客户合同部分2003-11-06杨国生 ------- */  /* 定义临时表变量 */
                DECLARE @temptablevaluecontract TABLE
                    (
                      contractid INT ,
                      sharelevel INT
                    )  
                
                /*  将所有的信息现放到 @temptablevaluecontract 中 */  /* 自己下级的客户合同 3 */
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
                
                /*  自己是 manager 的客户合同 2 */
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
                
                /* 作为客户合同管理员能看到的 */
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
                
                /* 由客户合同的共享获得的权利 1 2 */
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
                
                /* 自己下级的客户合同  (客户经理及经理线)*/
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
                
                
                /*  自己是 manager 的客户 (客户经理及经理线) */
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
                
                /* 删除原有的与该人员相关的所有权 */
                DELETE  FROM ContractShareDetail
                WHERE   userid = @resourceid_1
                        AND usertype = 1  
                        
                /* 将临时表中的数据写入共享表 */
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
                
            END  
                  
    /* 结束角色删除或者级别降低的处理 */     
    
    
    GO     
