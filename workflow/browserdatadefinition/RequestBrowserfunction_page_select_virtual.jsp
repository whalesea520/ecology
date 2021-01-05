
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionFieldConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.SelectItemConfig" %>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField" %>

<%@ page import="java.util.List" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.User" %>

<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />

<%
	User bdfUser = (User) request.getAttribute("bdfUser");
	ConditionField field = (ConditionField) request.getAttribute("bdfField");
	ConditionFieldConfig conf = field.getConfig();
	String valueType = field.getValueType();
	String valueTypeIdOrName = conf.getFieldSign() + "ValueType";
	//数据自定义-多维组织
	////////多维组织option
	String VirtualOrganization = "";
	if(CompanyComInfo.getCompanyNum()>0){
		CompanyComInfo.setTofirstRow();
		while(CompanyComInfo.next()){
			VirtualOrganization +="<option value="+CompanyComInfo.getCompanyid() +">"+SystemEnv.getHtmlLabelName(83179,bdfUser.getLanguage())+"</option>";
		}
	}
	if(CompanyVirtualComInfo.getCompanyNum()>0){
		CompanyVirtualComInfo.setTofirstRow();
		while(CompanyVirtualComInfo.next()){
			String virtualid = CompanyVirtualComInfo.getCompanyid();
			String virtualselected = "";
			if(valueType.equals(virtualid)){
				virtualselected = "selected='selected'";
			}
			VirtualOrganization +=" <option value='"+CompanyVirtualComInfo.getCompanyid() +"' "+ virtualselected + " > " +
						(CompanyVirtualComInfo.getVirtualType().length()>4?CompanyVirtualComInfo.getVirtualType():CompanyVirtualComInfo.getVirtualType()) +
						" </option> ";
		}
	}
	////////
%>
<select class=inputstyle name="<%=valueTypeIdOrName%>" id="<%=valueTypeIdOrName%>" style="float:left;"><%=VirtualOrganization%></select>