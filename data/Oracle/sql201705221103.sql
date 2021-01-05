 declare
    v_count number;
   begin
     select count(1) into v_count from user_tables t where t.TABLE_NAME='WF_BROWSER_CONFIG';
    if v_count>0 then
     execute immediate'drop table wf_browser_config';
    end if;
     execute immediate 'create table wf_browser_config (
      type varchar2(100) not null,
      clazz varchar2(2000) not null,
      description varchar2(100),
      label INTEGER,
      isSingle char(1)
)';
end;
/
insert into wf_browser_config(type,clazz,description) values('262','com.api.browser.service.impl.LocationBrowserService','办公地点')
/
insert into wf_browser_config(type,clazz,description) values('260','com.api.browser.service.impl.JobCallBrowserService','职称')
/
insert into wf_browser_config(type,clazz,description) values('doccategory','com.api.browser.service.impl.DocCategoryService','文档目录')
/
insert into wf_browser_config(type,clazz,description) values('58','com.api.browser.service.impl.CityBrowserService','城市')
/
insert into wf_browser_config(type,clazz,description) values('cusstatus','com.api.browser.service.impl.CustomerStatusService','客户状态')
/
insert into wf_browser_config(type,clazz,description) values('137','com.api.browser.service.impl.CarInfoBrowserService','车辆')
/
insert into wf_browser_config(type,clazz,description) values('55','com.api.browser.service.impl.DocNumberBrowserService','发文字号')
/
insert into wf_browser_config(type,clazz,description) values('35','com.api.browser.service.impl.ContractBrowserService','业务合同')
/
insert into wf_browser_config(type,clazz,description) values('36','com.api.browser.service.impl.ContractTypeBrowserService','合同性质')
/
insert into wf_browser_config(type,clazz,description) values('33','com.api.browser.service.impl.HrmScheduleDiffBrowserService','加班类型')
/
insert into wf_browser_config(type,clazz,description) values('wf','com.api.browser.service.impl.WorkflowBrowserService','路径')
/
insert into wf_browser_config(type,clazz,description) values('wftype','com.api.browser.service.impl.WorkflowTypeBrowserService','路径类型')
/
insert into wf_browser_config(type,clazz,description) values('119','com.api.browser.service.impl.SpecialityBrowserService','专业')
/
insert into wf_browser_config(type,clazz,description) values('245','com.api.browser.service.impl.WorkTypeService','工作类型')
/
insert into wf_browser_config(type,clazz,description) values('244','com.api.browser.service.impl.ProjectTypeService','项目类型')
/
insert into wf_browser_config(type,clazz,description) values('62','com.api.browser.service.impl.CustomerSizeService','客户大小')
/
insert into wf_browser_config(type,clazz,description) values('63','com.api.browser.service.impl.SectorInfoService','行业')
/
insert into wf_browser_config(type,clazz,description) values('60','com.api.browser.service.impl.CustomerTypeService','客户类型')
/
insert into wf_browser_config(type,clazz,description) values('87','com.api.browser.service.impl.MeetingRoomBrowserService','会议室')
/
insert into wf_browser_config(type,clazz,description) values('61','com.api.browser.service.impl.CustomerDescService','客户描述')
/
insert into wf_browser_config(type,clazz,description) values('251','com.api.browser.service.impl.FccBrowserService','成本中心')
/
insert into wf_browser_config(type,clazz,description) values('69','com.api.browser.service.impl.LgcAssetUnitBrowserService','计量单位')
/
insert into wf_browser_config(type,clazz,description) values('16','com.api.browser.service.impl.RequestBrowserService','请求')
/
insert into wf_browser_config(type,clazz,description) values('152','com.api.browser.service.impl.RequestBrowserService','多请求')
/
insert into wf_browser_config(type,clazz,description) values('171','com.api.browser.service.impl.RequestBrowserService','归档流程')
/
insert into wf_browser_config(type,clazz,description) values('23','com.api.browser.service.impl.CapitalBrowserService','资产')
/
insert into wf_browser_config(type,clazz,description) values('24','com.api.browser.service.impl.JobTitlesBrowserService','岗位')
/
insert into wf_browser_config(type,clazz,description) values('278','com.api.browser.service.impl.JobTitlesBrowserService','多岗位')
/
insert into wf_browser_config(type,clazz,description) values('25','com.api.browser.service.impl.CptAssortmentBrowserService','资产组')
/
insert into wf_browser_config(type,clazz,description) values('129','com.api.browser.service.impl.ProjectTempletBrowserService','项目模板')
/
insert into wf_browser_config(type,clazz,description) values('274','com.api.browser.service.impl.ContactLogBrowserService','商机来源')
/
insert into wf_browser_config(type,clazz,description) values('28','com.api.browser.service.impl.MeetingBrowserService','会议')
/
insert into wf_browser_config(type,clazz,description) values('country','com.api.browser.service.impl.CountryBrowserService','国家')
/
insert into wf_browser_config(type,clazz,description) values('182','com.api.browser.service.impl.VotingInfoBrowserService','单网上调查')
/
insert into wf_browser_config(type,clazz,description) values('18','com.api.browser.service.impl.CustomerBrowserService','客户')
/
insert into wf_browser_config(type,clazz,description) values('7','com.api.browser.service.impl.CustomerBrowserService','客户')
/
insert into wf_browser_config(type,clazz,description) values('32','com.api.browser.service.impl.HrmTrainPlanBrowserService','培训安排')
/
insert into wf_browser_config(type,clazz,description) values('267','com.api.browser.service.impl.RoleBrowserService','角色')
/
insert into wf_browser_config(type,clazz,description) values('52','com.api.browser.service.impl.DocKindBrowserService','公文种类')
/
insert into wf_browser_config(type,clazz,description) values('9','com.api.browser.service.impl.DocBrowserService','文档')
/
insert into wf_browser_config(type,clazz,description) values('37','com.api.browser.service.impl.DocBrowserService','多文档')
/
insert into wf_browser_config(type,clazz,description) values('53','com.api.browser.service.impl.DocInstancyLevelBrowserService','紧急程度')
/
insert into wf_browser_config(type,clazz,description) values('259','com.api.browser.service.impl.LanguageBrowserService','语言')
/
insert into wf_browser_config(type,clazz,description) values('54','com.api.browser.service.impl.DocSecretLevelBrowserService','秘密等级')
/
insert into wf_browser_config(type,clazz,description) values('8','com.api.browser.service.impl.ProjectBrowserService','项目')
/
insert into wf_browser_config(type,clazz,description) values('89','com.api.browser.service.impl.MeetingTypeBrowserService','会议类型')
/
insert into wf_browser_config(type,clazz,description) values('12','com.api.browser.service.impl.CurrencyBrowserService','币种')
/
insert into wf_browser_config(type,clazz,description) values('13','com.api.browser.service.impl.LgcAssortmentBrowserService','产品类别')
/
insert into wf_browser_config(type,clazz,description) values('27','com.api.browser.service.impl.MutiCareerBrowserService','应聘人')
/
insert into wf_browser_config(type,clazz,description) values('29','com.api.browser.service.impl.AwardTypeBrowserService','奖惩种类')
/
insert into wf_browser_config(type,clazz,description) values('30','com.api.browser.service.impl.EduLevelBrowserService','学历')
/
insert into wf_browser_config(type,clazz,description) values('31','com.api.browser.service.impl.UseKindBrowserService','用工性质')
/
insert into wf_browser_config(type,clazz,description) values('59','com.api.browser.service.impl.ContacterTitleBrowserService','称呼')
/
insert into wf_browser_config(type,clazz,description) values('160','com.api.browser.service.impl.RoleResourceBrowserService','角色人员')
/
insert into wf_browser_config(type,clazz,description) values('161','com.api.browser.service.impl.CommonBrowserService','自定义单选')
/
insert into wf_browser_config(type,clazz,description) values('162','com.api.browser.service.impl.MutilCommomBrowserService','自定义多选')
/
insert into wf_browser_config(type,clazz,description) values('166','com.api.browser.service.impl.MutiResourceBrowserDecService','分权多人力资源')
/
insert into wf_browser_config(type,clazz,description) values('17','com.api.browser.service.impl.ResourceBrowserService','多人力资源')
/
insert into wf_browser_config(type,clazz,description) values('1','com.api.browser.service.impl.ResourceBrowserService','单人力资源')
/
insert into wf_browser_config(type,clazz,description) values('270','com.api.browser.service.impl.MeetingServiceOperationBrowserService','服务项目')
/
insert into wf_browser_config(type,clazz,description) values('178','com.api.browser.service.impl.YearBrowserService','年份')
/
insert into wf_browser_config(type,clazz,description) values('4','com.api.browser.service.impl.OrganizationBrowserService','部门')
/
insert into wf_browser_config(type,clazz,description) values('164','com.api.browser.service.impl.OrganizationBrowserService','分部')
/
insert into wf_browser_config(type,clazz,description) values('57','com.api.browser.service.impl.OrganizationBrowserService','多部门')
/
insert into wf_browser_config(type,clazz,description) values('194','com.api.browser.service.impl.OrganizationBrowserService','多分部')
/
insert into wf_browser_config(type,clazz,description) values('280','com.api.browser.service.impl.ScheduleShiftsBrowserService','班次')
/
insert into wf_browser_config(type,clazz,description) values('38','com.api.browser.service.impl.LgcProductBrowserService','相关产品')
/
insert into wf_browser_config(type,clazz,description) values('279','com.api.browser.service.impl.HrmContractBrowserService','合同')
/
insert into wf_browser_config(type,clazz,description) values('65','com.api.browser.service.impl.MutiRolesBrowserService','多角色')
/