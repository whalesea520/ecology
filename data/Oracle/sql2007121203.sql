alter  table HrmTrainPlanRange add seclevel integer
/

CREATE or REPLACE PROCEDURE HrmTrainPlanRange_Insert
(planid_1 integer,
 type_2 integer,
 resourceid_3 integer,
 seclevelusid_4 integer,
flag out integer  , 
msg out varchar2,
thecursor IN OUT cursor_define.weavercursor
) 
as 
begin
insert into HrmTrainPlanRange
(planid,
 type_n,
 resourceid,
 seclevel)
values
(planid_1,
 type_2,
 resourceid_3,
 seclevelusid_4);
update HrmTrainPlan set openrange = 1 
where 
 id = planid_1;
end;
/