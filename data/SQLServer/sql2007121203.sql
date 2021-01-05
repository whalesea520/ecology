alter  table HrmTrainPlanRange add seclevel int
go

alter procedure HrmTrainPlanRange_Insert
(@planid_1 int,
 @type_2 int,
 @resourceid_3 int,
 @seclevel_4 int,
 @flag int output, @msg varchar(60) output)
as insert into HrmTrainPlanRange
(planid,
 type_n,
 resourceid,
 seclevel)
values
(@planid_1,
 @type_2,
 @resourceid_3,
 @seclevel_4)
update HrmTrainPlan set openrange = 1 
where 
 id = @planid_1

GO