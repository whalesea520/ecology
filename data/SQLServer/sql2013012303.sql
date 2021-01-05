ALTER procedure HrmResource_DepUpdate
(
@id_1 int, 
@departmentid_2 int, 
@joblevel_3 int, 
@costcenterid_4 int, 
@jobtitle_5 int, 
@newmanagerid_1 int, 
@flag int output,
@msg varchar(60) output
) 
as 
update HrmResource set departmentid = @departmentid_2, joblevel = @joblevel_3, costcenterid = @costcenterid_4, jobtitle = @jobtitle_5, managerid = @newmanagerid_1 
where id = @id_1 

update CRM_CustomerInfo set department= @departmentid_2 where manager = @id_1

GO
ALTER PROCEDURE HrmResourceBasicInfo_Update
(
@id_1 int, 
@workcode_2 varchar(60), 
@lastname_3 varchar(60), 
@sex_5 char(1), 
@resoureimageid_6 int, 
@departmentid_7 int, 
@costcenterid_8 int, 
@jobtitle_9 int, 
@joblevel_10 int, 
@jobactivitydesc_11 varchar(200), 
@managerid_12 int, 
@assistantid_13 int, 
@status_14 char(1), 
@locationid_15 int, 
@workroom_16 varchar(60), 
@telephone_17 varchar(60), 
@mobile_18 varchar(60), 
@mobilecall_19 varchar(30) , 
@fax_20 varchar(60), 
@jobcall_21 int, 
@systemlanguage_22 int, 
@accounttype_23 int, 
@belongto_24 int, 
@flag int output, 
@msg varchar(60) output
) 
AS 
UPDATE HrmResource SET workcode =   @workcode_2, lastname =  @lastname_3, sex =   @sex_5, resourceimageid =   @resoureimageid_6, departmentid =   @departmentid_7, costcenterid =   @costcenterid_8, jobtitle =   @jobtitle_9, joblevel =   @joblevel_10, jobactivitydesc =   @jobactivitydesc_11, managerid =   @managerid_12, assistantid =   @assistantid_13, status =   @status_14, locationid =   @locationid_15, workroom =   @workroom_16, telephone =   @telephone_17, mobile =   @mobile_18, mobilecall =   @mobilecall_19, fax =   @fax_20, jobcall = @jobcall_21, systemlanguage = @systemlanguage_22, accounttype= @accounttype_23, belongto= @belongto_24 
WHERE id =  @id_1

UPDATE CRM_CustomerInfo SET department = @departmentid_7 WHERE manager = @id_1 

GO