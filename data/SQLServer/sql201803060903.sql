DROP PROCEDURE Cptuseloginstock_insert
GO

CREATE  PROCEDURE [dbo].[Cptuseloginstock_insert] (@capitalid_1       [INT],
                                                 @usedate_2         [CHAR](10),
                                                 @usedeptid_3       [INT],
                                                 @useresourceid_4   [INT],
                                                 @checkerid         [INT],
                                                 @usecount_5        [DECIMAL](18, 3),
                                                 @useaddress_6      VARCHAR(4000),
                                                 @userequest_7      [INT],
                                                 @maintaincompany_8 VARCHAR(4000),
                                                 @fee_9             [DECIMAL](18, 3),
                                                 @usestatus_10      VARCHAR(4000),
                                                 @remark_11         [TEXT],
                                                 @mark              VARCHAR(4000),
                                                 @datatype          [INT],
                                                 @startdate         [CHAR](10),
                                                 @enddate           [CHAR](10),
                                                 @deprestartdate    [CHAR](10),
                                                 @depreenddate      [CHAR](10),
                                                 @manudate          [CHAR](10),
                                                 @lastmoderid       [INT],
                                                 @lastmoddate       [CHAR](10),
                                                 @lastmodtime       [CHAR](8),
                                                 @inprice           [DECIMAL](18, 3),
                                                 @crmid             [INT],
                                                 @counttype         [CHAR](1),
                                                 @isinner           [CHAR](1),
                                                 @flag              INTEGER output,
                                                 @msg               VARCHAR(4000) output)
AS
    IF @usestatus_10 = '2'
      BEGIN
          INSERT INTO [CptUseLog]
                      ([capitalid],
                       [usedate],
                       [usedeptid],
                       [useresourceid],
                       [usecount],
                       [useaddress],
                       [userequest],
                       [maintaincompany],
                       [fee],
                       [usestatus],
                       [remark])
          VALUES      ( @capitalid_1,
                        @usedate_2,
                        @usedeptid_3,
                        @checkerid,
                        @usecount_5,
                        @useaddress_6,
                        @userequest_7,
                        @maintaincompany_8,
                        @fee_9,
                        '1',
                        @remark_11)
      END
    INSERT INTO [CptUseLog]
                ([capitalid],
                 [usedate],
                 [usedeptid],
                 [useresourceid],
                 [usecount],
                 [useaddress],
                 [userequest],
                 [maintaincompany],
                 [fee],
                 [usestatus],
                 [remark])
    VALUES      ( @capitalid_1,
                  @usedate_2,
                  @usedeptid_3,
                  @useresourceid_4,
                  @usecount_5,
                  @useaddress_6,
                  @userequest_7,
                  @maintaincompany_8,
                  @fee_9,
                  @usestatus_10,
                  @remark_11)
    DECLARE @num DECIMAL(18, 3)
    SELECT @num = capitalnum
    FROM   CptCapital
    WHERE  id = @capitalid_1
    IF @usestatus_10 = '1'
      BEGIN
          SET @useresourceid_4 = 0
      END
    IF @usedeptid_3 = 0
      BEGIN
          SET @usedeptid_3 = NULL
      END
    UPDATE CptCapital
    SET    mark = @mark,
           capitalnum = @usecount_5 + @num,
           location = @useaddress_6,
           departmentid = @usedeptid_3,
           resourceid = @useresourceid_4,
           stateid = @usestatus_10,
           datatype = @datatype,
           isdata = '2',
           startdate = @startdate,
           enddate = @enddate,
           deprestartdate = @deprestartdate,
           depreenddate = @depreenddate,
           manudate = @manudate,
           [lastmoderid] = @lastmoderid,
           [lastmoddate] = @lastmoddate,
           [lastmodtime] = @lastmodtime,
           [startprice] = @inprice,
           [customerid] = @crmid,
           [counttype] = @counttype,
           [isinner] = @isinner
    WHERE  id = @capitalid_1 
GO