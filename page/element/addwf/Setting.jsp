
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<%@ include file="common.jsp"%>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
	<%
	String displayLayout = (String)valueList.get(nameList.indexOf("displayLayout"));
	String select1 = "";
	String select2 = "";
	if(displayLayout.equals("1")){
		select1 = "selected";
	}else{
		select2 = "selected";
	}
	
if("2".equals(esharelevel)){
		%>
	<wea:item>
		&nbsp;<%=SystemEnv.getHtmlLabelName(82134,user.getLanguage())%><!--显示布局-->
	</wea:item>
	<wea:item>
		<select id="displayLayout_<%=eid%>" name="displayLayout_<%=eid%>">
      	 	  
				<option value="1" <%=select1 %>>
				1 <%=SystemEnv.getHtmlLabelName(18621,user.getLanguage())%></option><!--1列-->
              
				<option value="2" <%=select2 %>>
				2 <%=SystemEnv.getHtmlLabelName(18621,user.getLanguage())%></option><!--2列-->
			</select>
	</wea:item>

<%} %>
		</wea:group>
</wea:layout>	
