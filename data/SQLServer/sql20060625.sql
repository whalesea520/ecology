update  MAINMENUINFO set LINKADDRESS='/docs/report/DocRpSum.jsp?optional=t1.doccreaterid'  WHERE LINKADDRESS = '/docs/report/DocRpCreaterSum.jsp'
GO

update  MAINMENUINFO set LINKADDRESS='/docs/report/DocRpSum.jsp?optional=t1.crmid'  WHERE LINKADDRESS = '/docs/report/DocRpCrmSum.jsp'
GO

update  MAINMENUINFO set LINKADDRESS='/docs/report/DocRpSum.jsp?optional=t1.hrmresid'  WHERE LINKADDRESS = '/docs/report/DocRpResourceSum.jsp'
GO

update  MAINMENUINFO set LINKADDRESS='/docs/report/DocRpSum.jsp?optional=t1.projectid'  WHERE LINKADDRESS = '/docs/report/DocRpProjectSum.jsp'
GO

update  MAINMENUINFO set LINKADDRESS='/docs/report/DocRpSum.jsp?optional=t1.docdepartmentid'  WHERE LINKADDRESS = '/docs/report/DocRpDepartmentSum.jsp'
GO

update  MAINMENUINFO set LINKADDRESS='/docs/report/DocRpSum.jsp?optional=t1.doclangurage'  WHERE LINKADDRESS = '/docs/report/DocRpLanguageSum.jsp'
GO