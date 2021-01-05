alter trigger AddTargetToMain ON HrmPerformanceTargetDetail FOR INSERT AS DECLARE @id tinyint select @id=targetId from inserted update hrmPerformanceTargetType set num=num+1 where id=@id 
GO
alter trigger CommunicateLog_trigger ON CommunicateLog FOR INSERT AS DECLARE @relatedid int DECLARE @relatedname varchar(4000) DECLARE @operateuserid int DECLARE @operateusertype int DECLARE @operatetype int DECLARE @operatedesc varchar(4000) DECLARE @operateitem varchar(4000) DECLARE @operatedate char(10) DECLARE @operatetime char(8) DECLARE @operatesmalltype int DECLARE @clientaddress char(15) DECLARE @istemplate int select @relatedid=relatedid, @relatedname=relatedname, @operateuserid=operateuserid , @operateusertype=operateusertype, @operatetype=operatetype, @operatedesc=operatedesc, @operateitem =operateitem, @operatedate=operatedate, @operatetime=operatetime, @operatesmalltype=operatesmalltype, @clientaddress=clientaddress, @istemplate=0 from inserted  begin EXECUTE  SysMaintenanceLog_proc @relatedid , @relatedname , @operateuserid , @operateusertype , @operatetype , @operatedesc , @operateitem , @operatedate , @operatetime , @operatesmalltype , @clientaddress , @istemplate ; end
GO

alter trigger CptCapital_getpinyin ON CptCapital FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(name)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](name)) FROM inserted update CptCapital set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger CRM_CustomerContacter_getpinyin ON CRM_CustomerContacter FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(fullname)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](fullname)) FROM inserted update CRM_CustomerContacter set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger CRM_CustomerInfo_getpinyin ON CRM_CustomerInfo FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(name)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](name)) FROM inserted update CRM_CustomerInfo set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO

alter trigger  delCheckStd ON HrmPerformanceCheckDetail FOR  DELETE AS DECLARE @id int select @id=id from deleted delete from  hrmPerformanceCheckStd   where checkDetailId=@id 
GO
alter trigger deletecontent ON HrmPerformanceSchemeContent FOR DELETE  AS declare @id tinyint select @id=id from deleted delete from HrmPerformanceSchemeDetail where contentId=@id 
GO
alter trigger deleteItem ON HrmPerformanceSchemeDetail FOR DELETE  AS declare @id tinyint select @id=id from deleted delete from HrmPerformanceSchemePercent where itemId=@id 
GO
alter trigger  delTargetToMain ON HrmPerformanceTargetDetail FOR  DELETE AS DECLARE @id tinyint select @id=targetId from deleted update hrmPerformanceTargetType set num=num-1 where id=@id 
GO
alter trigger docdetail_getpinyin ON docdetail FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(docsubject)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](docsubject)) FROM inserted update docdetail set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO

alter trigger DocSecCategory_getpinyin ON DocSecCategory FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(categoryname)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](categoryname)) FROM inserted update DocSecCategory set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger DocTreeDocField_getpinyin ON DocTreeDocField FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(treeDocFieldName)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](treeDocFieldName)) FROM inserted update DocTreeDocField set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger HrmCompanyTimesTamp_trigger ON HrmCompany FOR INSERT, DELETE, UPDATE AS BEGIN if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmCompany' end else begin if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.companyname,' ')=ISNULL(del.companyname,' ')) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmCompany' end end END 
GO
alter trigger hrmdepartment_getpinyin ON hrmdepartment FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(departmentname)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](departmentname)) FROM inserted update hrmdepartment set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger HrmDepartmentTimesTamp_trigger ON HrmDepartment FOR INSERT, DELETE, UPDATE AS BEGIN if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmDepartment' end else begin if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.departmentname,' ')=ISNULL(del.departmentname,' ') and ISNULL(ins.supdepid,0)=ISNULL(del.supdepid,0) and ISNULL(ins.subcompanyid1,0)=ISNULL(del.subcompanyid1,0)) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmDepartment' end end END 
GO
alter trigger HrmGroupMemberTimesTamp_trigger ON HrmGroupMembers FOR INSERT, DELETE, UPDATE AS BEGIN if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmGroupMember' end else begin if not exists(select 1 from inserted as ins,deleted as del where ISNULL(ins.groupid,0)=ISNULL(del.groupid,0) and ISNULL(ins.userid,0)=ISNULL(del.userid,0)) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmGroupMember' end end END 
GO
alter trigger hrmjobtitles_getpinyin ON hrmjobtitles FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(jobtitlename)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](jobtitlename)) FROM inserted update hrmjobtitles set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger hrmresource_getpinyin ON hrmresource FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(lastname)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](lastname)) FROM inserted update HrmResource set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger HrmResourceTimesTamp_trigger ON HrmResource FOR INSERT, DELETE, UPDATE AS BEGIN if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmResource' end else begin if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.lastname,' ')=ISNULL(del.lastname,' ') and ISNULL(ins.pinyinlastname,' ')=ISNULL(del.pinyinlastname,' ') and ISNULL(ins.messagerurl,' ')=ISNULL(del.messagerurl,' ') and ISNULL(ins.subcompanyid1,0)=ISNULL(del.subcompanyid1,0) and ISNULL(ins.departmentid,0)=ISNULL(del.departmentid,0) and ISNULL(ins.mobile,' ')=ISNULL(del.mobile,' ') and ISNULL(ins.telephone,' ')=ISNULL(del.telephone,' ') and ISNULL(ins.email,' ')=ISNULL(del.email,' ') and ISNULL(ins.jobtitle,' ')=ISNULL(del.jobtitle,' ') and ISNULL(ins.managerid,' ')=ISNULL(del.managerid,' ') and ISNULL(ins.status,0)=ISNULL(del.status,0) and ISNULL(ins.loginid,0)=ISNULL(del.loginid,0) and ISNULL(ins.account,0)=ISNULL(del.account,0)) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmResource' end end END 
GO
alter trigger HrmRoles_getpinyin ON HrmRoles FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(rolesname)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](rolesname)) FROM inserted update HrmRoles set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger hrmsubcompany_getpinyin ON hrmsubcompany FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(subcompanyname)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](subcompanyname)) FROM inserted update hrmsubcompany set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger HrmSubCompanyTimesTamp_trigger ON HrmSubCompany FOR INSERT, DELETE, UPDATE AS BEGIN if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmSubCompany' end else begin if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.subcompanyname,' ')=ISNULL(del.subcompanyname,' ') and ISNULL(ins.supsubcomid,0)=ISNULL(del.supsubcomid,0) and ISNULL(ins.companyid,0)=ISNULL(del.companyid,0)) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='HrmSubCompany' end end END 
GO
alter trigger labelManageLog_trigger ON labelManageLog FOR INSERT,UPDATE AS DECLARE @relatedid int DECLARE @relatedname varchar(4000) DECLARE @operateuserid int DECLARE @operateusertype int DECLARE @operatetype int DECLARE @operatedesc varchar(4000) DECLARE @operateitem varchar(4000) DECLARE @operatedate char(10) DECLARE @operatetime char(8) DECLARE @operatesmalltype int DECLARE @clientaddress char(15) DECLARE @istemplate int select @relatedid=relatedid, @relatedname=relatedname, @operateuserid=operateuserid , @operateusertype=operateusertype, @operatetype=operatetype, @operatedesc=operatedesc, @operateitem =operateitem, @operatedate=operatedate, @operatetime=operatetime, @operatesmalltype=1, @clientaddress=clientaddress, @istemplate=0 from inserted  begin EXECUTE  SysMaintenanceLog_proc @relatedid , @relatedname , @operateuserid , @operateusertype , @operatetype , @operatedesc , @operateitem , @operatedate , @operatetime , @operatesmalltype , @clientaddress , @istemplate ; end 
GO

alter trigger Meeting_Type_getpinyin ON Meeting_Type FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(name)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](name)) FROM inserted update Meeting_Type set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger MeetingLog_trigger ON MeetingLog FOR INSERT AS DECLARE @relatedid int DECLARE @relatedname varchar(4000) DECLARE @operateuserid int DECLARE @operateusertype int DECLARE @operatetype int DECLARE @operatedesc varchar(4000) DECLARE @operateitem varchar(4000) DECLARE @operatedate char(10) DECLARE @operatetime char(8) DECLARE @operatesmalltype int DECLARE @clientaddress char(15) DECLARE @istemplate int select @relatedid=relatedid, @relatedname=relatedname, @operateuserid=operateuserid , @operateusertype=operateusertype, @operatetype=operatetype, @operatedesc=operatedesc, @operateitem =operateitem, @operatedate=operatedate, @operatetime=operatetime, @operatesmalltype=operatesmalltype, @clientaddress=clientaddress, @istemplate=0 from inserted  begin EXECUTE  SysMaintenanceLog_proc @relatedid , @relatedname , @operateuserid , @operateusertype , @operatetype , @operatedesc , @operateitem , @operatedate , @operatetime , @operatesmalltype , @clientaddress , @istemplate ; end
GO
alter trigger OverWorkPlanTimesTamp_trigger ON OverWorkPlan FOR INSERT, DELETE, UPDATE AS BEGIN if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkPlanType' end else begin if not exists(select 1 from inserted as ins,deleted as del where ISNULL(ins.wavailable,0)=ISNULL(del.wavailable,0) and ISNULL(ins.workplancolor,' ')=ISNULL(del.workplancolor,' ')) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkPlanType' end end END 
GO
alter trigger Prj_ProjectInfo_getpinyin ON Prj_ProjectInfo FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(name)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](name)) FROM inserted update Prj_ProjectInfo set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO

alter trigger T_AlbumSubcompanyIns on HrmSubcompany for insert,delete as declare @countdelete int,@countinsert int,@id int  select @countdelete=count(*) from deleted select @countinsert=count(*) from inserted  if @countdelete=0 and @countinsert>0 begin select @id=id from inserted insert into AlbumSubcompany (subcompanyId,albumSize,albumSizeUsed) values (@id,1000000,0) end  if @countinsert=0 begin select @id=id from deleted delete from AlbumSubcompany where subcompanyId=@id end 
GO
alter trigger T_UpdatePhotoCount on AlbumPhotos for insert,delete as declare @countdelete int,@countinsert int,@id int,@parentId int,@subcompanyId int,@photoCount int,@isFolder char(1),@photoSize int  select @countdelete=count(*) from deleted select @countinsert=count(*) from inserted  if @countdelete=0 and @countinsert>0 begin select @parentid=parentId,@isFolder=isFolder,@photoSize=photoSize,@subcompanyId=subcompanyId from inserted if @isFolder<>'1' begin update AlbumPhotos set photoCount=(select count(id) from AlbumPhotos where parentId=@parentId and isFolder<>'1') where id=@parentId exec AlbumPhotos_U_Size @subcompanyId end end  if @countinsert=0 begin select @parentid=parentId,@isFolder=isFolder,@photoSize=photoSize,@subcompanyId=subcompanyId from deleted if @isFolder<>'1' begin update AlbumPhotos set photoCount=(select count(id) from AlbumPhotos where parentId=@parentId and isFolder<>'1') where id=@parentId delete from AlbumPhotoReview where photoId=@id exec AlbumPhotos_U_Size @subcompanyId end end
GO
alter trigger task_cowork_log ON cowork_discuss FOR INSERT,DELETE AS DECLARE @userid INT,@workdate CHAR(10),@taskid INT,@logid INT if exists(select 1 from inserted) BEGIN select @userid=discussant,@workdate=createdate,@taskid=coworkid,@logid=id from inserted insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype) VALUES(@userid,@workdate,5,@taskid,@logid,CONVERT(CHAR(10),GETDATE(),23),CONVERT(CHAR(10),GETDATE(),24),1) END ELSE if exists(select 1 from deleted) BEGIN select @userid=discussant,@workdate=createdate,@taskid=coworkid,@logid=id from deleted DELETE FROM task_operateLog WHERE userid=@userid AND tasktype=5 AND taskid=@taskid END
GO
alter trigger task_crm_log ON WorkPlan FOR INSERT, DELETE AS DECLARE @userid INT ,@workdate CHAR (10) ,@taskid varchar(4000) ,@logid INT IF EXISTS ( SELECT 1 FROM inserted WHERE type_n = 3 ) BEGIN SELECT @userid = createrid ,@workdate = createdate ,@taskid = crmid ,@logid = id FROM inserted INSERT INTO task_operateLog ( userid, workdate, tasktype, taskid, logid, createdate, createtime, logtype ) SELECT @userid ,@workdate, 9, id ,@logid, CONVERT (CHAR(10), GETDATE(), 23), CONVERT (CHAR(10), GETDATE(), 24), 1 FROM CRM_CustomerInfo WHERE ',' +@taskid + ',' LIKE '%,' + CONVERT (varchar(4000), id) + ',%' END ELSE  IF EXISTS ( SELECT 1 FROM deleted WHERE type_n = 3 ) BEGIN SELECT @userid = createrid ,@workdate = createdate ,@taskid = crmid ,@logid = id FROM deleted DELETE FROM task_operateLog WHERE logid =@logid END
GO
alter trigger task_tm_log ON TM_TaskFeedback FOR INSERT,DELETE AS DECLARE @userid INT,@workdate CHAR(10),@taskid INT,@logid INT if exists(select 1 from inserted) BEGIN select @userid=hrmid,@workdate=createdate,@taskid=taskid,@logid=id from inserted insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype) VALUES(@userid,@workdate,1,@taskid,@logid,CONVERT(CHAR(10),GETDATE(),23),CONVERT(CHAR(10),GETDATE(),24),1) END ELSE if exists(select 1 from deleted) BEGIN select @userid=hrmid,@workdate=createdate,@taskid=taskid,@logid=id from deleted DELETE FROM task_operateLog WHERE userid=@userid AND tasktype=1 AND taskid=@taskid END
GO
alter trigger task_workflow_log ON workflow_requestlog FOR INSERT,DELETE AS DECLARE @userid INT,@workdate CHAR(10),@taskid INT,@logid INT if exists(select 1 from inserted) BEGIN select @userid=operator,@workdate=operatedate,@taskid=requestid,@logid=logid from inserted insert into task_operateLog(userid,workdate,tasktype,taskid,logid,createdate,createtime,logtype) VALUES(@userid,@workdate,2,@taskid,@logid,CONVERT(CHAR(10),GETDATE(),23),CONVERT(CHAR(10),GETDATE(),24),1) END ELSE if exists(select 1 from deleted) BEGIN select @userid=operator,@workdate=operatedate,@taskid=requestid,@logid=logid from deleted DELETE FROM task_operateLog WHERE userid=@userid AND tasktype=2 AND taskid=@taskid END
GO
alter trigger trg_cptshr6_upd on cptcapital after update as if update(resourceid) begin declare @new_resourceid int; declare @old_resourceid int; declare @isdata int; declare @newid int; declare my_cursor cursor for select inserted.resourceid,inserted.isdata,inserted.id,deleted.resourceid from inserted,deleted where inserted.id=deleted.id; open my_cursor fetch next from my_cursor into @new_resourceid,@isdata,@newid,@old_resourceid; while @@fetch_status=0 begin if @isdata=1 fetch next from my_cursor into @new_resourceid,@isdata,@newid,@old_resourceid; if @isdata is null fetch next from my_cursor into @new_resourceid,@isdata,@newid,@old_resourceid; if @new_resourceid=@old_resourceid fetch next from my_cursor into @new_resourceid,@isdata,@newid,@old_resourceid;  if @new_resourceid>0 begin DELETE FROM CptCapitalShareInfo WHERE relateditemid=@newid AND sharetype=6 ; INSERT INTO [CptCapitalShareInfo] ( [relateditemid], [sharetype], [seclevel], [rolelevel], [sharelevel], [userid], [departmentid], [roleid], [foralluser],[subcompanyid],[isdefault]) VALUES ( @newid, 6, 0, null, 2, @new_resourceid, null, null, null,null,1); end fetch next from my_cursor into @new_resourceid,@isdata,@newid,@old_resourceid; end CLOSE my_cursor; DEALLOCATE my_cursor; end
GO
alter trigger trg_prjmembers_update on Prj_ProjectInfo after insert,update,delete as declare @prjid int; declare @members varchar(4000); declare @isblock int; declare @idx int; declare @userid int;  begin select @members=members+',',@prjid=id,@isblock=isblock from inserted; delete from prj_members where relateditemid=@prjid;  if @isblock!=1 return; if @members='' return; if @members is null return;  set @idx=CHARINDEX(',',@members) while @idx>0 begin set @userid=convert(int, SUBSTRING(@members,0,@idx)); insert into prj_members(relateditemid,userid) values(@prjid,@userid); set @members=SUBSTRING(@members,@idx+1,LEN(@members)); set @idx=CHARINDEX(',',@members); end  end
GO
alter trigger Tri_D_DirAccessControlList on DirAccessControlList FOR DELETE AS declare @id integer; declare @detail_del_cursor cursor; set @detail_del_cursor = cursor FORWARD_ONLY static for select mainid from deleted OPEN @detail_del_cursor fetch next from @detail_del_cursor INTO @id while @@FETCH_STATUS = 0 begin delete from DirAccessControlDetail where srcfrom=@id FETCH NEXT FROM @detail_del_cursor INTO @id end CLOSE @detail_del_cursor DEALLOCATE @detail_del_cursor
GO
alter trigger Tri_I_DeptKPICheckFlow ON HrmDepartment FOR INSERT AS Declare @deptid 	int, @countdelete   	int, @countinsert   	int  SELECT @countdelete = count(*) FROM deleted SELECT @countinsert = count(*) FROM inserted   IF (@countinsert>0 AND @countdelete=0) BEGIN SELECT @deptid=id FROM inserted INSERT INTO HrmPerformanceCheckFlow (objId,objType) VALUES (@deptid,'2') INSERT INTO HrmPerformanceCheckFlow (objId,objType) VALUES (@deptid,'3') END
GO
alter trigger Tri_I_DirAccessControlList on DirAccessControlList for insert as declare  @id_1         integer; declare  @dirid_1         integer; declare  @dirtype_1      integer; declare  @seclevel_1     integer declare  @departmentid_1      integer; declare  @subcompanyid_1      integer; declare  @userid_1            integer; declare  @usertype_1        integer; declare  @sharelevel_1       integer; declare  @roleid_1            integer; declare  @rolelevel_1         integer; declare  @permissiontype_1  integer; declare  @operationcode_1 integer; declare  @docSecCategoryTemplateId_1 integer; declare @sourceid_1           integer; declare  @type_1		    integer; declare  @content_1		    integer; declare  @sourcetype_1        integer; declare  @srcfrom_1        integer; declare  @detail_insert_cursor cursor; if EXISTS(SELECT 1 FROM inserted) begin set @detail_insert_cursor = cursor FORWARD_ONLY static for select mainid, dirid,dirtype,seclevel,userid,subcompanyid,departmentid,usertype,roleid,rolelevel,operationcode,permissiontype,DocSecCategoryTemplateId from inserted OPEN @detail_insert_cursor fetch next from @detail_insert_cursor INTO @id_1 , @dirid_1,@dirtype_1,@seclevel_1,@userid_1,@subcompanyid_1,@departmentid_1,@usertype_1,@roleid_1,@rolelevel_1,@operationcode_1,@permissiontype_1,@docSecCategoryTemplateId_1 while @@FETCH_STATUS = 0 begin begin set	@srcfrom_1 = @id_1; set	@sourceid_1= @dirid_1; set	@sourcetype_1= @dirtype_1; set	@type_1= @permissiontype_1; set	@sharelevel_1 = @operationcode_1;  if @type_1=1          set @content_1 = @departmentid_1; else if @type_1=2    set @content_1 =  convert( integer,( convert(varchar(4000),@roleid_1) + convert(varchar(4000),@rolelevel_1))); else if @type_1=3    begin set @seclevel_1 = @seclevel_1; set @content_1 = 0; end else if @type_1=4     set  @content_1 = @usertype_1; else if @type_1=5     begin set  @content_1 = @userid_1; set  @seclevel_1 = 0; end else if @type_1=6     set @content_1 = @subcompanyid_1;  insert into DirAccessControlDetail ( sourceid, type, content, seclevel, sharelevel, sourcetype, srcfrom )values( @sourceid_1, @type_1, @content_1, @seclevel_1, @sharelevel_1, @sourcetype_1, @srcfrom_1 )  if @rolelevel_1 = 0  begin  set @content_1=convert( integer,( convert(varchar(4000),@roleid_1) + convert(varchar(4000),1))); insert into DirAccessControlDetail ( sourceid, type, content, seclevel, sharelevel, sourcetype, srcfrom )values( @sourceid_1, @type_1, @content_1, @seclevel_1, @sharelevel_1, @sourcetype_1, @srcfrom_1 ) set @content_1=convert( integer,( convert(varchar(4000),@roleid_1) + convert(varchar(4000),2))); insert into DirAccessControlDetail ( sourceid, type, content, seclevel, sharelevel, sourcetype, srcfrom )values( @sourceid_1, @type_1, @content_1, @seclevel_1, @sharelevel_1, @sourcetype_1, @srcfrom_1 ) end else if @rolelevel_1>0   begin  set @content_1=convert( integer,( convert(varchar(4000),@roleid_1) + convert(varchar(4000),2))); insert into DirAccessControlDetail ( sourceid, type, content, seclevel, sharelevel, sourcetype, srcfrom )values( @sourceid_1, @type_1, @content_1, @seclevel_1, @sharelevel_1, @sourcetype_1, @srcfrom_1 ) end end FETCH NEXT FROM @detail_insert_cursor INTO @id_1 , @dirid_1,@dirtype_1,@seclevel_1,@userid_1,@subcompanyid_1,@departmentid_1,@usertype_1,@roleid_1,@rolelevel_1,@operationcode_1,@permissiontype_1,@docSecCategoryTemplateId_1 end CLOSE @detail_insert_cursor DEALLOCATE @detail_insert_cursor end
GO
alter trigger Tri_I_SubComKPICheckFlow ON HrmSubCompany FOR INSERT AS Declare @subcompid 	int, @countdelete   	int, @countinsert   	int  SELECT @countdelete = count(*) FROM deleted SELECT @countinsert = count(*) FROM inserted   IF (@countinsert>0 AND @countdelete=0) BEGIN SELECT @subcompid=id FROM inserted INSERT INTO HrmPerformanceCheckFlow (objId,objType) VALUES (@subcompid,'1') END
GO
alter trigger Tri_importexpense ON fnaaccountlog FOR INSERT AS declare @relatedcrm_1 int, @relatedprj_1 int, @organizationid_1 int, @occurdate_1 char(10), @amount_1 decimal(15,3), @subject_1 int, @requestid_1 int, @iscontract int, @description_1 varchar(4000) SELECT @iscontract = iscontractid FROM inserted if(@iscontract=0 or @iscontract is null) begin select @subject_1 = feetypeid,@organizationid_1 = resourceid,@relatedcrm_1 = crmid,@relatedprj_1 = projectid,@occurdate_1 = occurdate,@amount_1 = amount,@requestid_1 = releatedid FROM inserted insert into fnaexpenseinfo(subject,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,status,type,description) values(@subject_1,3,@organizationid_1,@relatedcrm_1,@relatedprj_1,@amount_1,@occurdate_1,@requestid_1,1,2,@description_1) end
GO
alter trigger Tri_importloan ON fnaloanlog FOR INSERT AS declare @relatedcrm_1 int, @relatedprj_1 int, @organizationid_1 int, @occurdate_1 char(10), @amount_1 decimal(15,3), @subject_1 int, @requestid_1 int, @description_1 varchar(4000), @loantype_1 int, @debitremark_1 varchar(4000), @processorid_1 int select @loantype_1=loantypeid,@organizationid_1=resourceid,@relatedcrm_1=crmid,@relatedprj_1=projectid,@amount_1=amount,@occurdate_1=occurdate,@requestid_1=releatedid,@description_1=description,@debitremark_1=credenceno,@processorid_1=dealuser FROM inserted if(@loantype_1=1) insert into fnaloaninfo(loantype,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,remark,debitremark,processorid) values(@loantype_1,3,@organizationid_1,@relatedcrm_1,@relatedprj_1,@amount_1,@occurdate_1,@requestid_1,@description_1,@debitremark_1,@processorid_1)
GO
alter trigger Tri_message_userinfoupdate ON HrmResource AFTER UPDATE AS  DECLARE @newid   int, @ucount   int BEGIN SELECT @newid = id   FROM inserted SELECT @ucount = count(*) from ofUserInfoUpdate where username = @newid and updatestate =1 if(@ucount<1) insert into ofUserInfoUpdate values(@newid,1) END
GO
alter trigger Tri_mobile_getpinyin ON HrmResource FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin SELECT @id_1 = id,@pinyinlastname = lower(dbo.getPinYin(lastname)) FROM inserted update HrmResource set pinyinlastname = @pinyinlastname where id = @id_1 end 
GO
alter trigger Tri_UHrmPGoal_ByStatus ON BPMGoalGroup FOR INSERT, UPDATE AS Declare @status 	char(1), @groupid 	int, @countdelete   	int, @countinsert   	int  SELECT @countdelete = count(*) FROM deleted SELECT @countinsert = count(*) FROM inserted       IF (@countinsert>0 AND @countdelete=0) BEGIN SELECT @groupid=id , @status=status FROM inserted UPDATE HrmPerformanceGoal SET status=@status WHERE groupid=@groupid END   IF (@countinsert>0 AND @countdelete>0) BEGIN SELECT @groupid=id , @status=status FROM inserted UPDATE HrmPerformanceGoal SET status=@status WHERE groupid=@groupid END 
GO
alter trigger Tri_ULeftMenuConfig_ByInfo ON LeftMenuInfo FOR INSERT, UPDATE, DELETE AS Declare @id_1 int, @defaultIndex_1 int, @countdelete   int, @countinsert   int, @userId int, @isCustom char(1), @useCustomName char(1), @customName varchar(4000)   SELECT @countdelete = count(*) FROM deleted SELECT @countinsert = count(*) FROM inserted       IF (@countinsert > 0 AND @countdelete = 0) BEGIN  SELECT @id_1 = id,@defaultIndex_1 = defaultIndex,@isCustom=isCustom,@useCustomName=useCustomName,@customName=customName FROM inserted  if(@isCustom = 0 OR @isCustom IS NULL) BEGIN   DECLARE hrmCompany_cursor CURSOR FOR SELECT id FROM HrmCompany order by id  OPEN hrmCompany_cursor FETCH NEXT FROM hrmCompany_cursor INTO @userId  WHILE @@FETCH_STATUS = 0 BEGIN  INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,@id_1,1,@defaultIndex_1,@userId,'1',0,0,@useCustomName,@customName)  FETCH NEXT FROM hrmCompany_cursor INTO @userId END CLOSE hrmCompany_cursor DEALLOCATE hrmCompany_cursor   DECLARE hrmSubCompany_cursor CURSOR FOR SELECT id FROM HrmSubCompany order by id  OPEN hrmSubCompany_cursor FETCH NEXT FROM hrmSubCompany_cursor INTO @userId  WHILE @@FETCH_STATUS = 0 BEGIN INSERT INTO LeftMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,@id_1,1,@defaultIndex_1,@userId,'2',0,0,@useCustomName,@customName) FETCH NEXT FROM hrmSubCompany_cursor INTO @userId END CLOSE hrmSubCompany_cursor DEALLOCATE hrmSubCompany_cursor   end END   IF (@countinsert = 0) BEGIN  SELECT @id_1 = id FROM deleted  DELETE FROM LeftMenuConfig WHERE infoId = @id_1 END 
GO
alter trigger Tri_UMailByCRMContacter ON CRM_CustomerContacter FOR UPDATE AS DECLARE @userid int, @email varchar(4000), @countDeleted int, @countInserted int  SELECT @countDeleted=COUNT(*) FROM DELETED SELECT @countInserted=COUNT(*) FROM INSERTED  IF @countInserted>0 BEGIN SELECT @userid=id,@email=email FROM INSERTED UPDATE MailUserAddress SET mailaddress=@email WHERE mailUserDesc=CAST(@userid AS varchar(4000)) AND mailUserType='3' END
GO
alter trigger Tri_UMailByHrmResource ON HrmResource FOR UPDATE AS DECLARE @userid int, @email varchar(4000), @countDeleted int, @countInserted int  SELECT @countDeleted=COUNT(*) FROM DELETED SELECT @countInserted=COUNT(*) FROM INSERTED  IF @countInserted>0 BEGIN SELECT @userid=id,@email=email FROM INSERTED UPDATE MailUserAddress SET mailaddress=@email WHERE mailUserDesc=CAST(@userid AS varchar(4000)) AND mailUserType='2' END
GO
alter trigger Tri_UMainMenuConfig_ByInfo ON MainMenuInfo FOR INSERT, UPDATE, DELETE AS Declare @id_1 int, @defaultIndex_1 int, @countdelete   int, @countinsert   int, @userId int, @isCustom char(1), @useCustomName char(1), @customName varchar(4000)   SELECT @countdelete = count(*) FROM deleted SELECT @countinsert = count(*) FROM inserted   IF (@countinsert > 0 AND @countdelete = 0) BEGIN  SELECT @id_1 = id,@defaultIndex_1 = defaultIndex,@isCustom=isCustom,@useCustomName=useCustomName,@customName=customName FROM inserted  if(@isCustom = 0 OR @isCustom IS NULL) BEGIN   DECLARE hrmCompany_cursor CURSOR FOR SELECT id FROM HrmCompany order by id  OPEN hrmCompany_cursor FETCH NEXT FROM hrmCompany_cursor INTO @userId  WHILE @@FETCH_STATUS = 0 BEGIN  INSERT INTO MainMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,@id_1,1,@defaultIndex_1,@userId,'1',0,0,@useCustomName,@customName)  FETCH NEXT FROM hrmCompany_cursor INTO @userId END CLOSE hrmCompany_cursor DEALLOCATE hrmCompany_cursor  DECLARE hrmSubCompany_cursor CURSOR FOR SELECT id FROM HrmSubCompany order by id  OPEN hrmSubCompany_cursor FETCH NEXT FROM hrmSubCompany_cursor INTO @userId  WHILE @@FETCH_STATUS = 0 BEGIN INSERT INTO MainMenuConfig (userId,infoId,visible,viewIndex,resourceid,resourcetype,locked,lockedById,useCustomName,customName) VALUES(0,@id_1,1,@defaultIndex_1,@userId,'2',0,0,@useCustomName,@customName) FETCH NEXT FROM hrmSubCompany_cursor INTO @userId END CLOSE hrmSubCompany_cursor DEALLOCATE hrmSubCompany_cursor   end END   IF (@countinsert = 0) BEGIN  SELECT @id_1 = id FROM deleted  DELETE FROM MainMenuConfig WHERE infoId = @id_1 END
GO
alter trigger Tri_UMMInfo_ByDocFrontpage ON DocFrontpage FOR INSERT, UPDATE, DELETE AS Declare @id_1 int, @countdelete int, @countinsert int SELECT @countdelete = count(*) FROM deleted SELECT @countinsert = count(*) FROM inserted  IF (@countinsert>0) BEGIN select @id_1=id from inserted delete from MainMenuInfo where id=@id_1*-1 insert into MainMenuInfo ( id, menuName , linkAddress , parentFrame , defaultParentId , defaultLevel , defaultIndex , needRightToVisible , needRightToView , needSwitchToVisible , relatedModuleId, parentId ) select id*-1, frontpagename, '/docs/news/NewsDsp.jsp?id='+cast(id as varchar(4000)), 'mainFrame', 1, 1, typeordernum, 0, 0, 0, 9, 1 from DocFrontpage where id=@id_1 and isactive='1' and publishtype='1' END  IF (@countinsert = 0) BEGIN SELECT @id_1 = id FROM deleted DELETE FROM MainMenuInfo WHERE id=@id_1*-1 END 
GO
alter trigger workflow_base_getpinyin ON workflow_base FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(workflowname)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](workflowname)) FROM inserted update workflow_base set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger workflow_nodebase_getpinyin ON workflow_nodebase FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(nodename)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](nodename)) FROM inserted update workflow_nodebase set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger workflow_nodelink_getpinyin ON workflow_nodelink FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(linkname)) begin SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](linkname)) FROM inserted update workflow_nodelink set ecology_pinyin_search= @pinyinlastname where id = @id_1 end end
GO
alter trigger workflow_requestbase_getpinyin ON workflow_requestbase FOR INSERT,UPDATE AS DECLARE @pinyinlastname varchar(4000) DECLARE @id_1 int begin if (update(requestname)) begin SELECT @id_1 = requestid,@pinyinlastname = lower([dbo].[getPinYin](requestname)) FROM inserted update workflow_requestbase set ecology_pinyin_search= @pinyinlastname where requestid = @id_1 end end
GO
alter trigger WorkFlowBaseTimesTamp_trigger ON workflow_base FOR INSERT, DELETE, UPDATE AS BEGIN if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkFlowType' end else begin if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.workflowname,' ')=ISNULL(del.workflowname,' ') and ins.workflowtype=del.workflowtype and ISNULL(ins.isvalid,'0')=ISNULL(del.isvalid,'0') and ISNULL(ins.isbill,'0')=ISNULL(del.isbill,'0')) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkFlowType' end end END 
GO
alter trigger WorkFlowTypeTimesTamp_trigger ON workflow_type FOR INSERT, DELETE, UPDATE AS BEGIN if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkFlowType' end else begin if not exists(select 1 from inserted as ins,deleted as del where ins.id=del.id and ISNULL(ins.typename,' ')=ISNULL(del.typename,' ') and ins.dsporder=del.dsporder) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkFlowType' end end END 
GO

alter trigger WorkPlanTypeTimesTamp_trigger ON WorkPlanType FOR INSERT, DELETE, UPDATE AS BEGIN if not exists(select 1 from inserted) or not exists(select 1 from deleted) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkPlanType' end else begin if not exists(select 1 from inserted as ins,deleted as del where ins.workPlanTypeID=del.workPlanTypeID and ISNULL(ins.workPlanTypeName,' ')=ISNULL(del.workPlanTypeName,' ') and ISNULL(ins.workPlanTypeColor,' ')=ISNULL(del.workPlanTypeColor,' ') and ISNULL(ins.available,'0')=ISNULL(del.available,'0') and ISNULL(ins.displayOrder,0)=ISNULL(del.displayOrder,0)) begin update mobileSyncInfo set syncLastTime=DATEDIFF(ss, '1970-01-01', GETDATE()) where syncTable='WorkPlanType' end end END 
GO
alter trigger workplanviewlog_trigger ON workplanviewlog FOR INSERT AS DECLARE @relatedid int DECLARE @relatedname varchar(4000) DECLARE @operateuserid int DECLARE @operateusertype int DECLARE @operatetype int DECLARE @operatedesc varchar(4000) DECLARE @operateitem varchar(4000) DECLARE @operatedate char(10) DECLARE @operatetime char(8) DECLARE @operatesmalltype int DECLARE @clientaddress char(15) DECLARE @istemplate int select @relatedid=workPlanId, @operateuserid=userId , @operateusertype=usertype, @operatetype=viewType, @operatedesc='日程前台操作', @operateitem ='91', @operatedate=logDate, @operatetime=logTime, @operatesmalltype=1, @clientaddress=ipAddress, @istemplate=0 from inserted select @relatedname=name from workplan where id=@relatedid  begin EXECUTE  SysMaintenanceLog_proc @relatedid , @relatedname , @operateuserid , @operateusertype , @operatetype , @operatedesc , @operateitem , @operatedate , @operatetime , @operatesmalltype , @clientaddress , @istemplate ; end
GO