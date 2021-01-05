

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
	String planType = (String)valueList.get(nameList.indexOf("planType"));
	String begindate = (String)valueList.get(nameList.indexOf("begindate"));
	String enddate = (String)valueList.get(nameList.indexOf("enddate"));	
	String planWeek = (String)valueList.get(nameList.indexOf("planWeek"));	
	String planMonth = (String)valueList.get(nameList.indexOf("planMonth"));
	String planDay = (String)valueList.get(nameList.indexOf("planDay"));
%>
<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(455,user.getLanguage())%><!--分类--></wea:item>
<wea:item>
<INPUT type=checkbox <%if("1".equals(planType)){ %>checked<%} %> value="<%=planType %>" 
name=_planType_<%=eid%> onclick="if(this.checked){this.value='1';}else{this.value='0';}">
</wea:item>

<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(22168,user.getLanguage())%><!--计划开始日期--></wea:item>
<wea:item>
<INPUT type=checkbox <%if("1".equals(begindate)){ %>checked<%} %> value="<%=begindate %>" 
name="_begindate_<%=eid%>" onclick="if(this.checked){this.value='1';}else{this.value='0';}">
</wea:item>

<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(22170,user.getLanguage())%><!--计划结束日期--></wea:item>
<wea:item>
<INPUT type=checkbox <%if("1".equals(enddate)){ %>checked<%} %> value="<%=enddate %>" 
name="_enddate_<%=eid%>" onclick="if(this.checked){this.value='1';}else{this.value='0';}">
</wea:item>

<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(33625,user.getLanguage())%><!--计划天数--></wea:item>
<wea:item>
<INPUT type=checkbox <%if("1".equals(planDay)){ %>checked<%} %> value="<%=planDay %>" 
name="_planDay_<%=eid%>" onclick="if(this.checked){this.value='1';}else{this.value='0';}">
</wea:item>

<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(20619,user.getLanguage())%><!--周报--></wea:item>
<wea:item>
<INPUT type=checkbox <%if("1".equals(planWeek)){ %>checked<%} %> value="<%=planWeek %>" 
name=_planWeek_<%=eid%> onclick="if(this.checked){this.value='1';}else{this.value='0';}">
</wea:item>

<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(20617,user.getLanguage())%><!--月报--></wea:item>
<wea:item>
<INPUT type=checkbox <%if("1".equals(planMonth)){ %>checked<%} %> value="<%=planMonth %>" 
name="_planMonth_<%=eid%>" onclick="if(this.checked){this.value='1';}else{this.value='0';}">
</wea:item>
</wea:group>
</wea:layout>
