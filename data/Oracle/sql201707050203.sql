delete from wf_browser_config where type ='wf'
/
insert into wf_browser_config(type,clazz,description) values('-99991','com.api.browser.service.impl.WorkflowBrowserService','路径')
/
delete from wf_browser_config where type ='22'
/
insert into wf_browser_config(type,clazz,description) values('22','com.api.browser.service.impl.BudgetfeeTypeBrowserService','报销费用类型')
/
delete from wf_browser_config where type ='251'
/
insert into wf_browser_config(type,clazz,description) values('251','com.api.browser.service.impl.CostCenterBrowserService','成本中心')
/