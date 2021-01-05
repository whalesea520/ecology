
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
	String creater = (String)valueList.get(nameList.indexOf("creater"));
	String principalid = (String)valueList.get(nameList.indexOf("principalid"));
	String begindate = (String)valueList.get(nameList.indexOf("begindate"));
	String enddate = (String)valueList.get(nameList.indexOf("enddate"));	
%>
<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%><!--创建人--></wea:item>
<wea:item>
<INPUT type=checkbox <%if("1".equals(creater)){ %>checked<%} %> value="<%=creater %>" 
name=_creater_<%=eid%> onclick="if(this.checked){this.value='1';}else{this.value='0';}">
</wea:item>

<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(16936,user.getLanguage())%><!--责任人--></wea:item>
<wea:item>
<INPUT type=checkbox <%if("1".equals(principalid)){ %>checked<%} %> value="<%=principalid %>" 
name="_principalid_<%=eid%>" onclick="if(this.checked){this.value='1';}else{this.value='0';}">
</wea:item>

<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%><!--开始日期--></wea:item>
<wea:item>
<INPUT type=checkbox <%if("1".equals(begindate)){ %>checked<%} %> value="<%=begindate %>" 
name="_begindate_<%=eid%>" onclick="if(this.checked){this.value='1';}else{this.value='0';}">
</wea:item>

<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%><!--结束日期--></wea:item>
<wea:item>
<INPUT type=checkbox <%if("1".equals(enddate)){ %>checked<%} %> value="<%=enddate %>" 
name="_enddate_<%=eid%>" onclick="if(this.checked){this.value='1';}else{this.value='0';}">
</wea:item>
</wea:group>
</wea:layout>
