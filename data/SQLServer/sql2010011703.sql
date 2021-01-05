alter table HRMSTATUSHISTORY add oldmanagerid int
GO
alter table HRMSTATUSHISTORY add newmanagerid int
GO

alter procedure HrmResource_DepUpdate
(@id_1 int,
 @departmentid_2 int,
 @joblevel_3 int,
 @costcenterid_4 int,
 @jobtitle_5 int,
 @newmanagerid_1 int,
 @flag int output,@msg varchar(60) output)
as update HrmResource set
  departmentid = @departmentid_2,
  joblevel = @joblevel_3,
  costcenterid = @costcenterid_4,
  jobtitle = @jobtitle_5,
  managerid = @newmanagerid_1
where
  id = @id_1

GO

alter PROCEDURE HrmResource_Redeploy (@id_1 int, @changedate_2 char(10), @changereason_4 text, @oldjobtitleid_7 int, @oldjoblevel_8 int, @newjobtitleid_9 int, @newjoblevel_10 int, @infoman_6 varchar(255), @type_n_11 int, @ischangesalary_12 int,@oldmanagerid_1 int,@newmanagerid_1 int, @flag int output, @msg varchar(60) output) AS INSERT INTO HrmStatusHistory (resourceid, changedate, changereason, oldjobtitleid, oldjoblevel, newjobtitleid, newjoblevel, infoman, type_n, ischangesalary,oldmanagerid,newmanagerid) VALUES (@id_1, @changedate_2, @changereason_4, @oldjobtitleid_7, @oldjoblevel_8, @newjobtitleid_9, @newjoblevel_10, @infoman_6, @type_n_11, @ischangesalary_12,@oldmanagerid_1,@newmanagerid_1)
GO
