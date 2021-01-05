<%@page import="org.json.JSONObject"%>
<%@page import="java.lang.reflect.Method"%>
<%@page import="weaver.systeminfo.systemright.CheckUserRight"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%

	String param = request.getParameter("param");	

	if("1".equals(param)){
	
	try{
		Class  clazz_LabelComInfo=Class.forName("weaver.systeminfo.label.LabelComInfo");
		Class  clazz_CompanyComInfo=Class.forName("weaver.hrm.company.CompanyComInfo");
		Class  clazz_ResourceComInfo=Class.forName("weaver.hrm.resource.ResourceComInfo");
		Class  clazz_ResourceVirtualComInfo=Class.forName("weaver.hrm.companyvirtual.ResourceVirtualComInfo");
		Class  clazz_CompanyVirtualComInfo=Class.forName("weaver.hrm.companyvirtual.CompanyVirtualComInfo");
		Class  clazz_DepartmentVirtualComInfo=Class.forName("weaver.hrm.companyvirtual.DepartmentVirtualComInfo");
		Class  clazz_DepartmentComInfo=Class.forName("weaver.hrm.company.DepartmentComInfo");
		Class  clazz_SubCompanyComInfo=Class.forName("weaver.hrm.company.SubCompanyComInfo");
		Class  clazz_JobTitlesComInfo=Class.forName("weaver.hrm.job.JobTitlesComInfo");
		Class  clazz_JobTitlesOldComInfo=Class.forName("weaver.hrm.job.JobTitlesOldComInfo");
		Class  clazz_JobTitlesTempletComInfo=Class.forName("weaver.hrm.job.JobTitlesTempletComInfo");
		Class  clazz_SubCompanyVirtualComInfo=Class.forName("weaver.hrm.companyvirtual.SubCompanyVirtualComInfo");
		Class  clazz_LocationComInfo=Class.forName("weaver.hrm.location.LocationComInfo");
		Class  clazz_JobActivitiesComInfo=Class.forName("weaver.hrm.job.JobActivitiesComInfo");
		Class  clazz_HrmSettingsComInfo=Class.forName("weaver.hrm.settings.HrmSettingsComInfo");
		Class  clazz_RolesComInfo=Class.forName("weaver.hrm.roles.RolesComInfo");
		Class  clazz_ResourceBelongtoComInfo=Class.forName("weaver.hrm.resource.ResourceBelongtoComInfo");
		Class  clazz_UseKindComInfo=Class.forName("weaver.hrm.job.UseKindComInfo");
		Class  clazz_SpecialityComInfo=Class.forName("weaver.hrm.job.SpecialityComInfo");
		Class  clazz_AppDetachComInfo=Class.forName("weaver.hrm.appdetach.AppDetachComInfo");
		Class  clazz_CitytwoComInfo=Class.forName("weaver.hrm.city.CitytwoComInfo");
		Class  clazz_HrmKqSystemComInfo=Class.forName("weaver.hrm.schedule.HrmKqSystemComInfo");
		Class  clazz_CountryComInfo=Class.forName("weaver.hrm.country.CountryComInfo");
		Class  clazz_ManageDetachComInfo=Class.forName("weaver.hrm.moduledetach.ManageDetachComInfo");
		Class  clazz_ProvinceComInfo=Class.forName("weaver.hrm.province.ProvinceComInfo");
		Class  clazz_HrmFieldComInfo=Class.forName("weaver.hrm.definedfield.HrmFieldComInfo");
		Class  clazz_HrmFieldGroupComInfo=Class.forName("weaver.hrm.definedfield.HrmFieldGroupComInfo");
		
		Object object_LabelComInfo=clazz_LabelComInfo.newInstance();
		Object object_CompanyComInfo=clazz_CompanyComInfo.newInstance();
		Object object_ResourceComInfo=clazz_ResourceComInfo.newInstance();
		Object object_ResourceVirtualComInfo=clazz_ResourceVirtualComInfo.newInstance();
		Object object_CompanyVirtualComInfo=clazz_CompanyVirtualComInfo.newInstance();
		Object object_DepartmentVirtualComInfo=clazz_DepartmentVirtualComInfo.newInstance();
		Object object_DepartmentComInfo=clazz_DepartmentComInfo.newInstance();
		Object object_SubCompanyComInfo=clazz_SubCompanyComInfo.newInstance();
		Object object_JobTitlesComInfo=clazz_JobTitlesComInfo.newInstance();
		Object object_JobTitlesOldComInfo=clazz_JobTitlesOldComInfo.newInstance();
		Object object_JobTitlesTempletComInfo= clazz_JobTitlesTempletComInfo.newInstance();
		Object object_SubCompanyVirtualComInfo=clazz_SubCompanyVirtualComInfo.newInstance();
		Object object_LocationComInfo=clazz_LocationComInfo.newInstance();
		Object object_JobActivitiesComInfo=clazz_JobActivitiesComInfo.newInstance();
		Object object_HrmSettingsComInfo=clazz_HrmSettingsComInfo.newInstance();
		Object object_RolesComInfo=clazz_RolesComInfo.newInstance();
		Object object_ResourceBelongtoComInfo=clazz_ResourceBelongtoComInfo.newInstance();
		Object object_UseKindComInfo=clazz_UseKindComInfo.newInstance();
		Object object_SpecialityComInfo=clazz_SpecialityComInfo.newInstance();
		Object object_AppDetachComInfo=clazz_AppDetachComInfo.newInstance();
		Object object_CitytwoComInfo=clazz_CitytwoComInfo.newInstance();
		Object object_HrmKqSystemComInfo=clazz_HrmKqSystemComInfo.newInstance();
		Object object_CountryComInfo=clazz_CountryComInfo.newInstance();
		Object object_ManageDetachComInfo=clazz_ManageDetachComInfo.newInstance();
		Object object_ProvinceComInfo=clazz_ProvinceComInfo.newInstance();
		Object object_HrmFieldComInfo=clazz_HrmFieldComInfo.newInstance();
		Object object_HrmFieldGroupComInfo=clazz_HrmFieldGroupComInfo.newInstance();
		
		Method method_LabelComInfo=clazz_LabelComInfo.getMethod("removeLabelCache", new Class[0]);
		method_LabelComInfo.invoke(object_LabelComInfo, null);
		
		Method method_CompanyComInfo=clazz_CompanyComInfo.getMethod("removeCompanyCache", new Class[0]);
		method_CompanyComInfo.invoke(object_CompanyComInfo, null);
		
		Method method_ResourceComInfo=clazz_ResourceComInfo.getMethod("removeResourceCache", new Class[0]);
		method_ResourceComInfo.invoke(object_ResourceComInfo, null);
		
		Method method_ResourceVirtualComInfo=clazz_ResourceVirtualComInfo.getMethod("removeResourceVirtualCache", new Class[0]);
		method_ResourceVirtualComInfo.invoke(object_ResourceVirtualComInfo, null);
		
		Method method_CompanyVirtualComInfo=clazz_CompanyVirtualComInfo.getMethod("removeCompanyCache", new Class[0]);
		method_CompanyVirtualComInfo.invoke(object_CompanyVirtualComInfo, null);
		
		Method method_DepartmentVirtualComInfo=clazz_DepartmentVirtualComInfo.getMethod("removeDepartmentCache", new Class[0]);
		method_DepartmentVirtualComInfo.invoke(object_DepartmentVirtualComInfo, null);
		
		Method method_DepartmentComInfo=clazz_DepartmentComInfo.getMethod("removeCompanyCache", new Class[0]);
		method_DepartmentComInfo.invoke(object_DepartmentComInfo, null);
		
		Method method_SubCompanyComInfo=clazz_SubCompanyComInfo.getMethod("removeCompanyCache", new Class[0]);
		method_SubCompanyComInfo.invoke(object_SubCompanyComInfo, null);
		
		Method method_JobTitlesComInfo=clazz_JobTitlesComInfo.getMethod("removeJobTitlesCache", new Class[0]);
		method_JobTitlesComInfo.invoke(object_JobTitlesComInfo, null);
		
		Method method_JobTitlesOldComInfo=clazz_JobTitlesOldComInfo.getMethod("removeJobTitlesOldCache", new Class[0]);
		method_JobTitlesOldComInfo.invoke(object_JobTitlesOldComInfo, null);
		
		Method method_JobTitlesTempletComInfo=clazz_JobTitlesTempletComInfo.getMethod("removeJobTitlesTempletCache", new Class[0]);
		method_JobTitlesTempletComInfo.invoke(object_JobTitlesTempletComInfo, null);
		
		Method method_SubCompanyVirtualComInfo=clazz_SubCompanyVirtualComInfo.getMethod("removeSubCompanyCache", new Class[0]);
		method_SubCompanyVirtualComInfo.invoke(object_SubCompanyVirtualComInfo, null);
		
		Method method_LocationComInfo=clazz_LocationComInfo.getMethod("removeLocationCache", new Class[0]);
		method_LocationComInfo.invoke(object_LocationComInfo, null);
		
		Method method_JobActivitiesComInfo=clazz_JobActivitiesComInfo.getMethod("removeJobActivitiesCache", new Class[0]);
		method_JobActivitiesComInfo.invoke(object_JobActivitiesComInfo, null);
		
		Method method_HrmSettingsComInfo=clazz_HrmSettingsComInfo.getMethod("removeHrmSettingsCache", new Class[0]);
		method_HrmSettingsComInfo.invoke(object_HrmSettingsComInfo, null);
		
		Method method_UseKindComInfo=clazz_UseKindComInfo.getMethod("removeUseKindCache", new Class[0]);
		method_UseKindComInfo.invoke(object_UseKindComInfo, null);
		
		Method method_SpecialityComInfo=clazz_SpecialityComInfo.getMethod("removeSpecialityCache", new Class[0]);
		method_SpecialityComInfo.invoke(object_SpecialityComInfo, null);
		
		
		Method method_AppDetachComInfo=clazz_AppDetachComInfo.getMethod("resetAppDetachInfo", new Class[0]);
		method_AppDetachComInfo.invoke(object_AppDetachComInfo, null);
		
		Method method_CitytwoComInfo=clazz_CitytwoComInfo.getMethod("removeCityCache", new Class[0]);
		method_CitytwoComInfo.invoke(object_CitytwoComInfo, null);
		
		Method method_HrmKqSystemComInfo=clazz_HrmKqSystemComInfo.getMethod("removeSystemCache", new Class[0]);
		method_HrmKqSystemComInfo.invoke(object_HrmKqSystemComInfo, null);
		
		Method method_CountryComInfo=clazz_CountryComInfo.getMethod("removeCountryCache", new Class[0]);
		method_CountryComInfo.invoke(object_CountryComInfo, null);
		
		Method method_ManageDetachComInfo=clazz_ManageDetachComInfo.getMethod("removeManageDetachCache", new Class[0]);
		method_ManageDetachComInfo.invoke(object_ManageDetachComInfo, null);
		
		Method method_ProvinceComInfo=clazz_ProvinceComInfo.getMethod("removeProvinceCache", new Class[0]);
		method_ProvinceComInfo.invoke(object_ProvinceComInfo, null);
		
		Method method_HrmFieldComInfo=clazz_HrmFieldComInfo.getMethod("removeFieldCache", new Class[0]);
		method_HrmFieldComInfo.invoke(object_HrmFieldComInfo, null);
		
		Method method_HrmFieldGroupComInfo=clazz_HrmFieldGroupComInfo.getMethod("removeCache", new Class[0]);
		method_HrmFieldGroupComInfo.invoke(object_HrmFieldGroupComInfo, null);
		
		CheckUserRight cur = new CheckUserRight();
		cur.removeMemberRoleCache();
		cur.removeRoleRightdetailCache();
		}catch(Exception e){
			System.out.println(e.getMessage());
		}
	}	
%>

	<wea:layout type="2col">
	    <wea:group context='重置人力资源相关缓存设置' attributes="{'itemAreaDisplay':'display'}">
			<wea:item>刷新所有人力资源相关缓存</wea:item>
			<wea:item>			
			<img src="refresh.png"  title="刷新" style="cursor: pointer;" onclick="doRefresh(1)" /><br/>
			</wea:item>
	    </wea:group>
	    
	</wea:layout>
	
