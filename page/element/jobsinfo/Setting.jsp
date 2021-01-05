<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<%@ include file ="common.jsp" %>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>

<%
	if("2".equals(esharelevel)){
		%>
			
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%><!--显示类别--></wea:item>
	<wea:item>
		
		<INPUT type="checkbox" value="1" <% if(valueList.get(nameList.indexOf("workflow")).equals("1")) out.print("checked"); else out.print(""); %> name="workflow_<%=eid%>" />
		<%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%>
		&nbsp;&nbsp;&nbsp;&nbsp;
		
		<INPUT type="checkbox" value="1" <% if(valueList.get(nameList.indexOf("meeting")).equals("1")) out.print("checked"); else out.print(""); %> name="meeting_<%=eid%>" />
		<%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>
		&nbsp;&nbsp;&nbsp;&nbsp;
		
		<INPUT type="checkbox" value="1" <% if(valueList.get(nameList.indexOf("workplan")).equals("1")) out.print("checked"); else out.print(""); %> name="workplan_<%=eid%>" />
		<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>
		&nbsp;&nbsp;&nbsp;&nbsp;
		
		<INPUT type="checkbox" value="1" <% if(valueList.get(nameList.indexOf("mail")).equals("1")) out.print("checked"); else out.print(""); %> name="mail_<%=eid%>" />
		<%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%>
		&nbsp;&nbsp;&nbsp;&nbsp;
	</wea:item>
	
		<%
		
	}
%>		

	</wea:group>
</wea:layout>
	
