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

<% if("2".equals(esharelevel)){
		Object showsub  = valueList.get(nameList.indexOf("showsub"));
		String showsubChecked = "1".equals(showsub) ? "checked" :"";
%>
		<wea:item><%=SystemEnv.getHtmlLabelName(83783,user.getLanguage())%></wea:item>
     	<wea:item>
      	 	<INPUT type="checkbox"  name="showsub_<%=eid %>" <%=showsubChecked %> value="1" />
      	</wea:item>
  <%}%>    	
	</wea:group>
</wea:layout>
	
