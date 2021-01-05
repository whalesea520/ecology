CREATE TABLE XmlReport (
	id int IDENTITY (1, 1) NOT NULL,	/*修改日志字段id，自增长*/
	rptType varchar(1) NULL,	/*报表类型 0:日报;1:周报;2:月报;3:季报;4:半年报;5:年报*/
	rptFlag varchar(250) NULL,
	rptDate varchar(10) NULL,	/*报表日期*/
	rptTitle varchar(250)  NULL ,	/*报表名称*/
	rptName varchar(250)  NULL ,	/*报表名称*/
	updateDate varchar(10)  NULL		/*修改人日期*/
)
GO
CREATE TABLE XmlReport_ShareInfo
(
  ID            int IDENTITY (1, 1) NOT NULL,
  RELATEDITEMID varchar(250),
  SHARETYPE     int,
  SECLEVEL      int,
  ROLELEVEL     int,
  SHARELEVEL    int,
  USERID        int,
  DEPARTMENTID  int,
  ROLEID        int,
  FORALLUSER    int,
  CRMID         int default 0
)
GO
CREATE PROCEDURE XmlReport_ShareInfo_Insert (@relateditemid varchar(250), @sharetype tinyint, @seclevel  tinyint, @rolelevel tinyint, @sharelevel tinyint, @userid int, @departmentid int, @roleid int, @foralluser tinyint, @flag integer output, @msg varchar(80) output ) AS INSERT INTO XmlReport_ShareInfo ( relateditemid, sharetype, seclevel, rolelevel, sharelevel, userid, departmentid, roleid, foralluser ) VALUES ( @relateditemid , @sharetype , @seclevel , @rolelevel , @sharelevel, @userid, @departmentid, @roleid, @foralluser  ) set @flag=1 set @msg='ok'
GO
CREATE PROCEDURE XmlReport_ShareInfo_Delete (@id int, @flag integer output, @msg varchar(80) output ) AS DELETE from XmlReport_ShareInfo  WHERE ( id = @id) set @flag=1 set @msg='ok'
GO
CREATE PROCEDURE XmlReport_ShareInfo_SbyRid (@relateditemid varchar(250) , @flag integer output , @msg varchar(80) output ) AS select * from XmlReport_ShareInfo where ( relateditemid = @relateditemid ) order by sharetype set  @flag = 1 set  @msg = 'ok'
GO
