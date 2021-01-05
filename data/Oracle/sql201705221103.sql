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
insert into wf_browser_config(type,clazz,description) values('262','com.api.browser.service.impl.LocationBrowserService','�칫�ص�')
/
insert into wf_browser_config(type,clazz,description) values('260','com.api.browser.service.impl.JobCallBrowserService','ְ��')
/
insert into wf_browser_config(type,clazz,description) values('doccategory','com.api.browser.service.impl.DocCategoryService','�ĵ�Ŀ¼')
/
insert into wf_browser_config(type,clazz,description) values('58','com.api.browser.service.impl.CityBrowserService','����')
/
insert into wf_browser_config(type,clazz,description) values('cusstatus','com.api.browser.service.impl.CustomerStatusService','�ͻ�״̬')
/
insert into wf_browser_config(type,clazz,description) values('137','com.api.browser.service.impl.CarInfoBrowserService','����')
/
insert into wf_browser_config(type,clazz,description) values('55','com.api.browser.service.impl.DocNumberBrowserService','�����ֺ�')
/
insert into wf_browser_config(type,clazz,description) values('35','com.api.browser.service.impl.ContractBrowserService','ҵ���ͬ')
/
insert into wf_browser_config(type,clazz,description) values('36','com.api.browser.service.impl.ContractTypeBrowserService','��ͬ����')
/
insert into wf_browser_config(type,clazz,description) values('33','com.api.browser.service.impl.HrmScheduleDiffBrowserService','�Ӱ�����')
/
insert into wf_browser_config(type,clazz,description) values('wf','com.api.browser.service.impl.WorkflowBrowserService','·��')
/
insert into wf_browser_config(type,clazz,description) values('wftype','com.api.browser.service.impl.WorkflowTypeBrowserService','·������')
/
insert into wf_browser_config(type,clazz,description) values('119','com.api.browser.service.impl.SpecialityBrowserService','רҵ')
/
insert into wf_browser_config(type,clazz,description) values('245','com.api.browser.service.impl.WorkTypeService','��������')
/
insert into wf_browser_config(type,clazz,description) values('244','com.api.browser.service.impl.ProjectTypeService','��Ŀ����')
/
insert into wf_browser_config(type,clazz,description) values('62','com.api.browser.service.impl.CustomerSizeService','�ͻ���С')
/
insert into wf_browser_config(type,clazz,description) values('63','com.api.browser.service.impl.SectorInfoService','��ҵ')
/
insert into wf_browser_config(type,clazz,description) values('60','com.api.browser.service.impl.CustomerTypeService','�ͻ�����')
/
insert into wf_browser_config(type,clazz,description) values('87','com.api.browser.service.impl.MeetingRoomBrowserService','������')
/
insert into wf_browser_config(type,clazz,description) values('61','com.api.browser.service.impl.CustomerDescService','�ͻ�����')
/
insert into wf_browser_config(type,clazz,description) values('251','com.api.browser.service.impl.FccBrowserService','�ɱ�����')
/
insert into wf_browser_config(type,clazz,description) values('69','com.api.browser.service.impl.LgcAssetUnitBrowserService','������λ')
/
insert into wf_browser_config(type,clazz,description) values('16','com.api.browser.service.impl.RequestBrowserService','����')
/
insert into wf_browser_config(type,clazz,description) values('152','com.api.browser.service.impl.RequestBrowserService','������')
/
insert into wf_browser_config(type,clazz,description) values('171','com.api.browser.service.impl.RequestBrowserService','�鵵����')
/
insert into wf_browser_config(type,clazz,description) values('23','com.api.browser.service.impl.CapitalBrowserService','�ʲ�')
/
insert into wf_browser_config(type,clazz,description) values('24','com.api.browser.service.impl.JobTitlesBrowserService','��λ')
/
insert into wf_browser_config(type,clazz,description) values('278','com.api.browser.service.impl.JobTitlesBrowserService','���λ')
/
insert into wf_browser_config(type,clazz,description) values('25','com.api.browser.service.impl.CptAssortmentBrowserService','�ʲ���')
/
insert into wf_browser_config(type,clazz,description) values('129','com.api.browser.service.impl.ProjectTempletBrowserService','��Ŀģ��')
/
insert into wf_browser_config(type,clazz,description) values('274','com.api.browser.service.impl.ContactLogBrowserService','�̻���Դ')
/
insert into wf_browser_config(type,clazz,description) values('28','com.api.browser.service.impl.MeetingBrowserService','����')
/
insert into wf_browser_config(type,clazz,description) values('country','com.api.browser.service.impl.CountryBrowserService','����')
/
insert into wf_browser_config(type,clazz,description) values('182','com.api.browser.service.impl.VotingInfoBrowserService','�����ϵ���')
/
insert into wf_browser_config(type,clazz,description) values('18','com.api.browser.service.impl.CustomerBrowserService','�ͻ�')
/
insert into wf_browser_config(type,clazz,description) values('7','com.api.browser.service.impl.CustomerBrowserService','�ͻ�')
/
insert into wf_browser_config(type,clazz,description) values('32','com.api.browser.service.impl.HrmTrainPlanBrowserService','��ѵ����')
/
insert into wf_browser_config(type,clazz,description) values('267','com.api.browser.service.impl.RoleBrowserService','��ɫ')
/
insert into wf_browser_config(type,clazz,description) values('52','com.api.browser.service.impl.DocKindBrowserService','��������')
/
insert into wf_browser_config(type,clazz,description) values('9','com.api.browser.service.impl.DocBrowserService','�ĵ�')
/
insert into wf_browser_config(type,clazz,description) values('37','com.api.browser.service.impl.DocBrowserService','���ĵ�')
/
insert into wf_browser_config(type,clazz,description) values('53','com.api.browser.service.impl.DocInstancyLevelBrowserService','�����̶�')
/
insert into wf_browser_config(type,clazz,description) values('259','com.api.browser.service.impl.LanguageBrowserService','����')
/
insert into wf_browser_config(type,clazz,description) values('54','com.api.browser.service.impl.DocSecretLevelBrowserService','���ܵȼ�')
/
insert into wf_browser_config(type,clazz,description) values('8','com.api.browser.service.impl.ProjectBrowserService','��Ŀ')
/
insert into wf_browser_config(type,clazz,description) values('89','com.api.browser.service.impl.MeetingTypeBrowserService','��������')
/
insert into wf_browser_config(type,clazz,description) values('12','com.api.browser.service.impl.CurrencyBrowserService','����')
/
insert into wf_browser_config(type,clazz,description) values('13','com.api.browser.service.impl.LgcAssortmentBrowserService','��Ʒ���')
/
insert into wf_browser_config(type,clazz,description) values('27','com.api.browser.service.impl.MutiCareerBrowserService','ӦƸ��')
/
insert into wf_browser_config(type,clazz,description) values('29','com.api.browser.service.impl.AwardTypeBrowserService','��������')
/
insert into wf_browser_config(type,clazz,description) values('30','com.api.browser.service.impl.EduLevelBrowserService','ѧ��')
/
insert into wf_browser_config(type,clazz,description) values('31','com.api.browser.service.impl.UseKindBrowserService','�ù�����')
/
insert into wf_browser_config(type,clazz,description) values('59','com.api.browser.service.impl.ContacterTitleBrowserService','�ƺ�')
/
insert into wf_browser_config(type,clazz,description) values('160','com.api.browser.service.impl.RoleResourceBrowserService','��ɫ��Ա')
/
insert into wf_browser_config(type,clazz,description) values('161','com.api.browser.service.impl.CommonBrowserService','�Զ��嵥ѡ')
/
insert into wf_browser_config(type,clazz,description) values('162','com.api.browser.service.impl.MutilCommomBrowserService','�Զ����ѡ')
/
insert into wf_browser_config(type,clazz,description) values('166','com.api.browser.service.impl.MutiResourceBrowserDecService','��Ȩ��������Դ')
/
insert into wf_browser_config(type,clazz,description) values('17','com.api.browser.service.impl.ResourceBrowserService','��������Դ')
/
insert into wf_browser_config(type,clazz,description) values('1','com.api.browser.service.impl.ResourceBrowserService','��������Դ')
/
insert into wf_browser_config(type,clazz,description) values('270','com.api.browser.service.impl.MeetingServiceOperationBrowserService','������Ŀ')
/
insert into wf_browser_config(type,clazz,description) values('178','com.api.browser.service.impl.YearBrowserService','���')
/
insert into wf_browser_config(type,clazz,description) values('4','com.api.browser.service.impl.OrganizationBrowserService','����')
/
insert into wf_browser_config(type,clazz,description) values('164','com.api.browser.service.impl.OrganizationBrowserService','�ֲ�')
/
insert into wf_browser_config(type,clazz,description) values('57','com.api.browser.service.impl.OrganizationBrowserService','�ಿ��')
/
insert into wf_browser_config(type,clazz,description) values('194','com.api.browser.service.impl.OrganizationBrowserService','��ֲ�')
/
insert into wf_browser_config(type,clazz,description) values('280','com.api.browser.service.impl.ScheduleShiftsBrowserService','���')
/
insert into wf_browser_config(type,clazz,description) values('38','com.api.browser.service.impl.LgcProductBrowserService','��ز�Ʒ')
/
insert into wf_browser_config(type,clazz,description) values('279','com.api.browser.service.impl.HrmContractBrowserService','��ͬ')
/
insert into wf_browser_config(type,clazz,description) values('65','com.api.browser.service.impl.MutiRolesBrowserService','���ɫ')
/