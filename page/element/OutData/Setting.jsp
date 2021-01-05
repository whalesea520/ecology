
<%@page import="java.util.ArrayList"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.lang.reflect.Constructor" %>
<%@ page import="java.lang.reflect.Method" %>
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
String nums = (String)valueList.get(nameList.indexOf("nums"));
String randomValue = Util.null2String(request.getParameter("randomValue"));//为什么要有一个randomValue？
String maxTabId="0";
String url = "/page/element/OutData/SettingBrowser.jsp?eid="+eid;
if("2".equals(esharelevel)){ 
%>


		
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(30643,user.getLanguage())%></wea:item>
	<wea:item>
		<input type="InputStyle" 
		style="WIDTH: 50px" id="nums_<%=eid %>" name="nums_<%=eid %>" value="<%=nums %>"></input>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(22970,user.getLanguage())%></wea:item>
	<wea:item>
	
	<a align=right href="javascript:addTab('<%=eid %>','<%=url %>','<%=ebaseid %>')"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %></a></wea:item>
	<div id="tabdiv">
	
	<wea:item>
	</wea:item>
	<wea:item>
	<table id="tabtable">
	<%
		strSql = "select * from hpOutDataTabSetting where eid="+eid +" order by tabId";
		rs_common.execute(strSql);
		
		while(rs_common.next())
		{
			if(Util.getIntValue(rs_common.getString("tabId"))>Util.getIntValue(maxTabId))
			{
				maxTabId = rs_common.getString("tabId");
			}
						
		%>
	<tr>
	<td><span id = 'tab_<%=eid+"_"+rs_common.getString("tabId") %>' tabId='<%=rs_common.getString("tabId") %>' tabTitle='<%=rs_common.getString("title") %>'><%=rs_common.getString("title") %></span>
	</td><td>
	<a href="javascript:deleTab(<%=eid %>,<%=rs_common.getString("tabId") %>,'<%=ebaseid %>')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %></a>
		&nbsp;&nbsp;
	<a href="javascript:editTab(<%=eid %>,<%=rs_common.getString("tabId") %>,'<%=ebaseid %>')"><%=SystemEnv.getHtmlLabelName(22250,user.getLanguage()) %></a>
	</td></tr>
	<%} %>
	</table>
	</wea:item>
	
	<wea:item><div id='tabDiv_<%=eid %>_<%=randomValue %>' tabCount='<%=maxTabId %>' url='<%=url %>' ><iframe id='dialogIframe_<%=eid %>_<%=randomValue %>' BORDER=0 FRAMEBORDER='no' NORESIZE=NORESIZE width='100%' height='100%'  scrolling='NO' ></iframe></div></wea:item>
	<%} else { %>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(30643,user.getLanguage())%></wea:item>
	<wea:item><input type="InputStyle" 
		style="WIDTH: 50px" id="nums_<%=eid %>" name="nums_<%=eid %>" value="<%=nums %>"></input>
	</wea:item>
	<wea:item></wea:item>
	<%} %>
	</wea:group>
</wea:layout>

