delete from wf_browser_config where type ='wf'
GO
insert into wf_browser_config(type,clazz,description) values('-99991','com.api.browser.service.impl.WorkflowBrowserService','路径')
GO
delete from wf_browser_config where type ='22'
GO
insert into wf_browser_config(type,clazz,description) values('22','com.api.browser.service.impl.BudgetfeeTypeBrowserService','报销费用类型')
GO
delete from wf_browser_config where type ='251'
GO
insert into wf_browser_config(type,clazz,description) values('251','com.api.browser.service.impl.CostCenterBrowserService','成本中心')
GO