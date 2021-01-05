ALTER TABLE hrmdepartment ADD ecology_pinyin_search varchar(300) 
GO
ALTER TABLE CRM_CustomerInfo ADD ecology_pinyin_search varchar(300)
GO
ALTER TABLE DocTreeDocField ADD ecology_pinyin_search varchar(300) 
GO
ALTER TABLE HrmRoles ADD ecology_pinyin_search varchar(300) 
GO
ALTER TABLE hrmsubcompany ADD ecology_pinyin_search varchar(300)
GO 
ALTER TABLE CptCapital ADD ecology_pinyin_search varchar(300)
GO
ALTER TABLE Prj_ProjectInfo ADD ecology_pinyin_search varchar(300)
GO 
ALTER TABLE docdetail ADD ecology_pinyin_search varchar(300)
GO   
ALTER TABLE Meeting_Type ADD ecology_pinyin_search varchar(300)
GO
ALTER TABLE workflow_nodebase ADD ecology_pinyin_search varchar(300)
GO
ALTER TABLE workflow_base ADD ecology_pinyin_search varchar(300)
GO 
ALTER TABLE workflow_requestbase ADD ecology_pinyin_search varchar(300)
GO
ALTER TABLE DocSecCategory ADD ecology_pinyin_search varchar(300)
GO
ALTER TABLE CRM_CustomerContacter ADD ecology_pinyin_search varchar(300)
GO 
ALTER TABLE hrmresource ADD ecology_pinyin_search varchar(300)
GO
ALTER TABLE hrmjobtitles ADD ecology_pinyin_search varchar(300)
GO
ALTER TABLE workflow_nodelink ADD ecology_pinyin_search varchar(300)
GO

CREATE    TRIGGER hrmdepartment_getpinyin 
 ON hrmdepartment FOR INSERT,UPDATE AS
 DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(departmentname))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](departmentname))
 FROM inserted 
 update hrmdepartment set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
CREATE    TRIGGER CRM_CustomerInfo_getpinyin 
 ON CRM_CustomerInfo FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(name))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](name))
 FROM inserted 
 update CRM_CustomerInfo set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
 go

go
CREATE    TRIGGER hrmsubcompany_getpinyin 
 ON hrmsubcompany FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(subcompanyname))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](subcompanyname))
 FROM inserted 
 update hrmsubcompany set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
CREATE    TRIGGER CptCapital_getpinyin 
 ON CptCapital FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(name))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](name))
 FROM inserted 
 update CptCapital set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
CREATE    TRIGGER Prj_ProjectInfo_getpinyin 
 ON Prj_ProjectInfo FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(name))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](name))
 FROM inserted 
 update Prj_ProjectInfo set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
CREATE    TRIGGER docdetail_getpinyin 
 ON docdetail FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(docsubject))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](docsubject))
 FROM inserted 
 update docdetail set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
CREATE    TRIGGER Meeting_Type_getpinyin 
 ON Meeting_Type FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(name))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](name))
 FROM inserted 
 update Meeting_Type set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
CREATE    TRIGGER workflow_base_getpinyin 
 ON workflow_base FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(workflowname))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](workflowname))
 FROM inserted 
 update workflow_base set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
CREATE    TRIGGER DocSecCategory_getpinyin 
 ON DocSecCategory FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(categoryname))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](categoryname))
 FROM inserted 
 update DocSecCategory set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
 CREATE    TRIGGER DocTreeDocField_getpinyin 
 ON DocTreeDocField FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(treeDocFieldName))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](treeDocFieldName))
 FROM inserted 
 update DocTreeDocField set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
 CREATE    TRIGGER HrmRoles_getpinyin 
 ON HrmRoles FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(rolesname))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](rolesname))
 FROM inserted 
 update HrmRoles set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
 CREATE    TRIGGER workflow_nodebase_getpinyin 
 ON workflow_nodebase FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(nodename))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](nodename))
 FROM inserted 
 update workflow_nodebase set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
 CREATE    TRIGGER hrmjobtitles_getpinyin 
 ON hrmjobtitles FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(jobtitlename))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](jobtitlename))
 FROM inserted 
 update hrmjobtitles set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end 
go

go
CREATE    TRIGGER workflow_requestbase_getpinyin 
 ON workflow_requestbase FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(requestname))
begin
 SELECT @id_1 = requestid,@pinyinlastname = lower([dbo].[getPinYin](requestname)) 
 FROM inserted 
 update workflow_requestbase set ecology_pinyin_search= @pinyinlastname where requestid = @id_1
 end
 end
go

go
CREATE    TRIGGER CRM_CustomerContacter_getpinyin 
 ON CRM_CustomerContacter FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(fullname))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](fullname))
 FROM inserted 
 update CRM_CustomerContacter set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end
go

go
CREATE    TRIGGER hrmresource_getpinyin 
 ON hrmresource FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(lastname))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](lastname))
 FROM inserted 
 update HrmResource set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end
go

CREATE    TRIGGER workflow_nodelink_getpinyin 
 ON workflow_nodelink FOR INSERT,UPDATE AS
  DECLARE @pinyinlastname VARCHAR(300) 
 DECLARE @id_1 int 
 begin 
 if (update(linkname))
begin
 SELECT @id_1 = id,@pinyinlastname = lower([dbo].[getPinYin](linkname))
 FROM inserted 
 update workflow_nodelink set ecology_pinyin_search= @pinyinlastname where id = @id_1
 end
 end
go