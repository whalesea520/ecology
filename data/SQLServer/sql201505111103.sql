CREATE procedure   init_monitor as
begin
  declare @n_infoid INTEGER
  declare @n_hrmid          INTEGER
  declare @monitortype      integer
  declare @n_jktype         INTEGER
  declare @n_count          INTEGER
  declare @n_count2         INTEGER
  declare @n_typeid_defaule integer

  DELETE FROM workflow_monitor_info
  DELETE FROM workflow_monitor_detail
  select @n_typeid_defaule = min(id) from workflow_monitortype

  update workflow_monitor_bound set monitortype = @n_typeid_defaule  where (monitortype is null or monitortype = '')
  
 
  DECLARE MyCursor CURSOR FOR SELECT monitorhrmid, monitortype
       FROM workflow_monitor_bound where exists (select 1 from workflow_base where workflow_monitor_bound.workflowid = workflow_base.id)
          GROUP BY monitorhrmid, monitortype
	
  OPEN MyCursor

	FETCH NEXT FROM  MyCursor INTO @n_hrmid,@monitortype
WHILE @@FETCH_STATUS =0
	BEGIN
		set @n_count2 = 0
		select @n_count2 = COUNT(1) FROM hrmresource WHERE id = @n_hrmid
		IF (@n_count2 > 0) 
		  begin
			set @n_jktype = 1
		  end
		ELSE
		  begin
			set @n_jktype = 3
		  end

	select @n_infoid = (isnull(max(id),0) + 1) from workflow_monitor_info

  select @n_count = count(1) from (select workflowid from workflow_monitor_bound where monitorhrmid = @n_hrmid and monitortype = @monitortype and exists (select 1 from workflow_base where workflow_monitor_bound.workflowid = workflow_base.id) group by workflowid) t
		  
	INSERT INTO workflow_monitor_info
      (id,
       monitortype,
       flowcount,
       operatordate,
       operatortime,
       operator,
       subcompanyid,
       jktype,
       jkvalue,
       fwtype,
       fwvalue)
    VALUES
      (@n_infoid,
       @monitortype,
       @n_count,
       convert(char(10),getdate(),20),
       convert(char(8),getdate(),108),
       1,
       0,
       @n_jktype,
       @n_hrmid,
       1,
       '')
	   
	  insert into workflow_monitor_detail
      (INFOID,
       workflowid,
       operatordate,
       operatortime,
       isview,
       isedit,
       isintervenor,
       isdelete,
       isforcedrawback,
       isforceover,
       operator,
       monitortype,
       issooperator)
      select @n_infoid,
             workflowid,
             convert(char(10),getdate(),20),
             convert(char(8),getdate(),108),
             max(isnull(isview,0)),
             '0',
             max(isnull(isintervenor,0)),
             max(isnull(isdelete,0)),
             max(isnull(isforcedrawback,0)),
             max(isnull(isforceover,0)),
             1,
             @monitortype,
             max(isnull(issooperator,0))
        from workflow_monitor_bound a
       where MONITORTYPE = @monitortype
         and monitorhrmid = @n_hrmid
         and exists (select 1 from workflow_base where a.workflowid = workflow_base.id)
         group by workflowid
		
		FETCH NEXT FROM  MyCursor INTO @n_hrmid,@monitortype
	END	
CLOSE MyCursor
DEALLOCATE MyCursor
END 
GO
exec init_monitor
GO