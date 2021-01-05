DROP PROCEDURE HrmCheckPost_Insert;
GO
/* 2003-4-25建立针对的岗位存储过程 ; 2014-10-21修改存储过程，增加部门、分部 by wcd*/ 
CREATE PROCEDURE HrmCheckPost_Insert (@checktypeid_2 int, @jobid_3 int,  @deptid_4 int,  @subcid_5 int, @flag int output, @msg varchar(60) output) AS insert into HrmCheckPost (checktypeid,jobid,deptid,subcid) values (@checktypeid_2,@jobid_3,@deptid_4,@subcid_5)
GO