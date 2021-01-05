ALTER PROCEDURE SystemSet_DftSCUpdate
    (
      @dftsubcomid INT ,
      @hrmdftsubcomid INT ,
      @wfdftsubcomid INT ,
      @docdftsubcomid INT ,
      @portaldftsubcomid INT ,
      @cptdftsubcomid INT ,
      @mtidftsubcomid INT ,
      @flag INT OUTPUT ,
      @msg VARCHAR(80) OUTPUT 
    )
AS 
    UPDATE  HrmRoles
    SET     subcompanyid = @dftsubcomid
    WHERE   subcompanyid IS NULL
            OR subcompanyid = 0
            OR subcompanyid = -1
            OR subcompanyid NOT IN ( SELECT id
                                     FROM   hrmsubcompany )
    UPDATE  HrmContractTemplet
    SET     subcompanyid = @dftsubcomid
    WHERE   subcompanyid IS NULL
            OR subcompanyid = 0
            OR subcompanyid = -1
            OR subcompanyid NOT IN ( SELECT id
                                     FROM   hrmsubcompany )
    UPDATE  HrmContractType
    SET     subcompanyid = @dftsubcomid
    WHERE   subcompanyid IS NULL
            OR subcompanyid = 0
            OR subcompanyid = -1
            OR subcompanyid NOT IN ( SELECT id
                                     FROM   hrmsubcompany )
    UPDATE  HrmCareerApply
    SET     subCompanyId = @dftsubcomid
    WHERE   subCompanyId IS NULL
            OR subCompanyId = 0
            OR subCompanyId = -1
            OR subCompanyId NOT IN ( SELECT id
                                     FROM   hrmsubcompany )
    UPDATE  workflow_formdict
    SET     subcompanyid = @wfdftsubcomid
    WHERE   subcompanyid IS NULL
            OR subcompanyid = 0
            OR subcompanyid = -1
            OR subcompanyid NOT IN ( SELECT id
                                     FROM   hrmsubcompany )
    UPDATE  workflow_formdictdetail
    SET     subcompanyid = @wfdftsubcomid
    WHERE   subcompanyid IS NULL
            OR subcompanyid = 0
            OR subcompanyid = -1
            OR subcompanyid NOT IN ( SELECT id
                                     FROM   hrmsubcompany )
    UPDATE  workflow_formbase
    SET     subcompanyid = @wfdftsubcomid
    WHERE   subcompanyid IS NULL
            OR subcompanyid = 0
            OR subcompanyid = -1
            OR subcompanyid NOT IN ( SELECT id
                                     FROM   hrmsubcompany )
    UPDATE  workflow_base
    SET     subcompanyid = @wfdftsubcomid
    WHERE   subcompanyid IS NULL
            OR subcompanyid = 0
            OR subcompanyid = -1
            OR subcompanyid NOT IN ( SELECT id
                                     FROM   hrmsubcompany )
    UPDATE  cptcapital
    SET     blongsubcompany = @cptdftsubcomid
    WHERE   blongsubcompany IS NULL
            OR blongsubcompany = 0
            OR blongsubcompany = -1
            OR blongsubcompany NOT IN ( SELECT  id
                                        FROM    hrmsubcompany )
    UPDATE  MeetingRoom
    SET     subcompanyId = @mtidftsubcomid
    WHERE   subcompanyId IS NULL
            OR subcompanyId = 0
            OR subcompanyId = -1
            OR subcompanyid NOT IN ( SELECT id
                                     FROM   hrmSubcompany )
    UPDATE  Meeting_Type
    SET     subcompanyId = @mtidftsubcomid
    WHERE   subcompanyId IS NULL
            OR subcompanyId = 0
            OR subcompanyId = -1
            OR subcompanyid NOT IN ( SELECT id
                                     FROM   hrmSubcompany ) 
GO