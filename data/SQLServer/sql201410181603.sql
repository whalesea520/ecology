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
/* �����ڽ�ɫ�����ӳ�Ա���Ȩ�޷������ */
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
            IF @rolelevel_1 = '2'       /* �µĽ�ɫ����Ϊ�ܲ��� */ 
                BEGIN    /* ------- CRM ���� ----��ɫ�仯��Ӱ��ͻ����ճ̵Ĺ�������������ɫ��Զ���--- */


                    DECLARE roleids_cursor CURSOR
                    FOR
                        SELECT  roleid
                        FROM    SystemRightRoles
                        WHERE   rightid = 396 /*396Ϊ�ͻ���ͬ����Ȩ��*/
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
                IF @rolelevel_1 = '1'          /* �µĽ�ɫ����Ϊ�ֲ��� */ 
                    BEGIN 
                        /* ------- �ͻ���ͬ���� �ֲ� 2003-11-06�����------- */
                        DECLARE roleids_cursor CURSOR
                        FOR
                            SELECT  roleid
                            FROM    SystemRightRoles
                            WHERE   rightid = 396 /*396Ϊ�ͻ���ͬ����Ȩ��*/
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
                    IF @rolelevel_1 = '0'          /* Ϊ�½�ʱ���趨����Ϊ���ż� */ 
                        BEGIN  
                            /* ------- �ͻ���ͬ���� ���� 2003-11-06�����------- */
                            DECLARE roleids_cursor CURSOR
                            FOR
                                SELECT  roleid
                                FROM    SystemRightRoles
                                WHERE   rightid = 396 /*396Ϊ�ͻ���ͬ����Ȩ��*/
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
           ) /* ��Ϊɾ�����߼��𽵵� */ 
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
                 

                /* ------- �ͻ���ͬ����2003-11-06����� ------- */  /* ������ʱ������ */
                DECLARE @temptablevaluecontract TABLE
                    (
                      contractid INT ,
                      sharelevel INT
                    )  
                
                /*  �����е���Ϣ�ַŵ� @temptablevaluecontract �� */  /* �Լ��¼��Ŀͻ���ͬ 3 */
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
                
                /*  �Լ��� manager �Ŀͻ���ͬ 2 */
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
                
                /* ��Ϊ�ͻ���ͬ����Ա�ܿ����� */
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
                
                /* �ɿͻ���ͬ�Ĺ�����õ�Ȩ�� 1 2 */
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
                
                /* �Լ��¼��Ŀͻ���ͬ  (�ͻ�������������)*/
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
                
                
                /*  �Լ��� manager �Ŀͻ� (�ͻ�������������) */
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
                
                /* ɾ��ԭ�е������Ա��ص�����Ȩ */
                DELETE  FROM ContractShareDetail
                WHERE   userid = @resourceid_1
                        AND usertype = 1  
                        
                /* ����ʱ���е�����д�빲���� */
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
                  
    /* ������ɫɾ�����߼��𽵵͵Ĵ��� */     
    
    
    GO     