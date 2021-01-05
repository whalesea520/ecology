alter procedure HrmContract_UpdateByHrm
(@id_1 int,
 @contracttypeid_2 int,
 @startdate_3 char(10),
 @enddate_4 char(10),
 @proenddate_5 char(10),
 @flag int output, @msg varchar(60) output)
as update HrmContract set
 contractstartdate = @startdate_3,
 contractenddate = @enddate_4,
 proenddate = @proenddate_5
where
 contractman = @id_1 and contracttypeid = @contracttypeid_2

GO
