update workflow_browserurl set browserurl='/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp',columname='departmentmark' where browserurl like '%MutiDepartmentBrowser%'
GO
update workflow_browserurl set browserurl='/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByDecOrder.jsp',columname='departmentmark' where browserurl like '%MultiDepartmentBrowserByDec%'
GO
