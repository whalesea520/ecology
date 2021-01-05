ALTER procedure workflow_Rbase_UpdateLevel
@requestid              int, 
@level_n        int,
@flag integer output , 
@msg varchar(4000) output
AS 
  if @level_n is null or @level_n = '' 
  begin
    Update workflow_requestbase
       set requestlevel = 0
     where requestid = @requestid;
  end;
  else
  begin
    Update workflow_requestbase
       set requestlevel = @level_n
     where requestid = @requestid;
  end
GO