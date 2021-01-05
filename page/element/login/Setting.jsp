
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
String width = (String)valueList.get(nameList.indexOf("width"));
String height = (String)valueList.get(nameList.indexOf("height"));
String actionpage = (String)valueList.get(nameList.indexOf("actionpage"));
String userparamname = (String)valueList.get(nameList.indexOf("userparamname"));
String userparampass = (String)valueList.get(nameList.indexOf("userparampass"));
%>

	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT class="inputstyle" type="hidden"
			title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
			style="WIDTH: 24px" name="width_<%=eid%>"
			value="<%=width %>" />
		<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:
		<INPUT class="inputstyle"
			title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
			style="WIDTH: 24px" name="height_<%=eid %>"
			value="<%=height %>" />
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(24963,user.getLanguage())%></wea:item>
	<wea:item>
		<input title="<%=SystemEnv.getHtmlLabelName(24963,user.getLanguage())%>" style="width:80%;"name="actionpage_<%=eid %>" id="actionpage_<%=eid %>" class="inputstyle" type="text" value="<%=actionpage %>" />
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(24463,user.getLanguage())%></wea:item>
	<wea:item>
		<input title="<%=SystemEnv.getHtmlLabelName(22911,user.getLanguage())%>" style="width:80%;"name="userparamname_<%=eid %>" id="userparamname_<%=eid %>" class="inputstyle" type="text" value="<%=userparamname %>" />
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(24464,user.getLanguage())%></wea:item>
	<wea:item>
		<input title="<%=SystemEnv.getHtmlLabelName(22911,user.getLanguage())%>" style="width:80%;"name="userparampass_<%=eid %>" id="userparampass_<%=eid %>" class="inputstyle" type="text" value="<%=userparampass %>" />
	</wea:item>
	</wea:group>
</wea:layout>
