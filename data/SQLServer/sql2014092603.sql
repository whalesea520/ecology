update hrmdepartment  set ecology_pinyin_search= [dbo].[getPinYin](departmentname);
GO
update CRM_CustomerInfo set ecology_pinyin_search= [dbo].[getPinYin](name);
GO
update hrmsubcompany set ecology_pinyin_search= [dbo].[getPinYin](subcompanyname);
GO
update CptCapital set ecology_pinyin_search= [dbo].[getPinYin](name);
GO
update Prj_ProjectInfo set ecology_pinyin_search= [dbo].[getPinYin](name);
GO
update docdetail set ecology_pinyin_search= [dbo].[getPinYin](docsubject);
GO
update Meeting_Type set ecology_pinyin_search= [dbo].[getPinYin](name);
GO
update workflow_base set ecology_pinyin_search= [dbo].[getPinYin](workflowname);
GO
update DocSecCategory set ecology_pinyin_search= [dbo].[getPinYin](categoryname);
GO
update DocTreeDocField set ecology_pinyin_search= [dbo].[getPinYin](treeDocFieldName);
GO
update HrmRoles set ecology_pinyin_search= [dbo].[getPinYin](rolesname);
GO
update workflow_nodebase set ecology_pinyin_search= [dbo].[getPinYin](nodename);
GO
update hrmjobtitles set ecology_pinyin_search= [dbo].[getPinYin](jobtitlename);
GO
update workflow_requestbase set ecology_pinyin_search= [dbo].[getPinYin](requestname);
GO
update CRM_CustomerContacter set ecology_pinyin_search= [dbo].[getPinYin](fullname);
GO
update hrmresource set ecology_pinyin_search= [dbo].[getPinYin](lastname);
GO
update workflow_nodelink set ecology_pinyin_search= [dbo].[getPinYin](linkname);
GO
