ALTER PROCEDURE HrmResourceDateCheck
    (
      @today_1 CHAR(10) ,
      @flag INT OUTPUT ,
      @msg VARCHAR(4000) OUTPUT
    )
AS 
    DELETE  FROM hrmrolemembers
    WHERE   resourceid IN ( SELECT  id
                            FROM    HrmResource
                            WHERE   ( status = 0
                                      OR status = 1
                                      OR status = 2
                                      OR status = 3
                                    )
                                    AND enddate < @today_1
                                    AND enddate <> ''
                                    AND enddate IS NOT NULL )
    DELETE  FROM PluginLicenseUser
    WHERE   plugintype = 'mobile'
            AND sharetype = '0'
            AND sharevalue IN ( SELECT  id
                                FROM    HrmResource
                                WHERE   ( status = 0
                                          OR status = 1
                                          OR status = 2
                                          OR status = 3
                                        )
                                        AND enddate < @today_1
                                        AND enddate <> ''
                                        AND enddate IS NOT NULL )
    UPDATE  HrmResource
    SET     status = 7 ,
            loginid = '' ,
            password = '' ,
            account = '' ,
            lastmoddate = @today_1
    WHERE   ( status = 0
              OR status = 1
              OR status = 2
              OR status = 3
            )
            AND enddate < @today_1
            AND enddate <> ''
            AND enddate IS NOT NULL
    UPDATE  HrmResource
    SET     status = 3
    WHERE   status = 0
            AND probationenddate < @today_1
            AND probationenddate <> ''
            AND probationenddate IS NOT NULL
    UPDATE  HrmResource
    SET     status = 0
    WHERE   status = 3
            AND ( probationenddate >= @today_1
                  OR probationenddate = ''
                  OR probationenddate IS NULL
                )
GO
