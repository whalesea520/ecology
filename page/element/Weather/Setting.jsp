
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
String weathersrc = (String)valueList.get(nameList.indexOf("weathersrc"));
String autoScroll= (String)valueList.get(nameList.indexOf("autoScroll"));
String width= (String)valueList.get(nameList.indexOf("width"));
%>
<%
if("2".equals(esharelevel)){
		%>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(15246,user.getLanguage())%><!--显示设置--></wea:item>
	<wea:item>
		<input name="weathersrc_<%=eid%>" class="InputStyle" value=<%=weathersrc %>>
		&nbsp;<img src='/images/icon_wev8.gif' title='<%=SystemEnv.getHtmlLabelName(24956,user.getLanguage()) %>' class='vtip'/><br>
		<%=SystemEnv.getHtmlLabelName(25899,user.getLanguage())%>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(24548,user.getLanguage())%><!--显示设置--></wea:item>
	<wea:item>
	    <input type="radio" name="autoScroll_<%=eid%>" value="1" <%if(autoScroll.equals("1")){%>checked=checked<%} %>><%=SystemEnv.getHtmlLabelName(24598,user.getLanguage())%>
	    <input type="radio" name="autoScroll_<%=eid%>" value="0" <%if(autoScroll.equals("0")){%>checked=checked<%} %>><%=SystemEnv.getHtmlLabelName(24599,user.getLanguage())%>
		&nbsp;
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(24561,user.getLanguage())%><!--显示设置--></wea:item>
	<wea:item>
	    <input type="text"  class="InputStyle" name="width_<%=eid%>" onkeypress="ItemCount_KeyPress(event)" value="<%=width%>">
		&nbsp;
	</wea:item>
	<%} %>
	</wea:group>
</wea:layout>
