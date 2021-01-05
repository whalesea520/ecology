<jsp:useBean id="dnc" class="weaver.docs.news.DocNewsComInfo" scope="page" />
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
	String ftitle = (String)valueList.get(nameList.indexOf("ftitle"));
	String ftype = (String)valueList.get(nameList.indexOf("ftype"));
	String flevel = (String)valueList.get(nameList.indexOf("flevel"));
	String fdate = (String)valueList.get(nameList.indexOf("fdate"));	
	String wordcount = (String)valueList.get(nameList.indexOf("wordcount"));
%>
<%
if("2".equals(esharelevel)){
		%>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19495,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT type=checkbox <%if("7".equals(ftitle)){ %>checked<%} %> value="<%=ftitle %>" name=_ftitle_<%=eid%> onclick="if(this.checked){this.value='7';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>&nbsp;
		<BR>
		<INPUT type=checkbox <%if("8".equals(ftype)){ %>checked<%} %> value="<%=ftype %>" name="_ftype_<%=eid%>" onclick="if(this.checked){this.value='8';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(22256,user.getLanguage())%>
		<BR>
		<INPUT type=checkbox <%if("9".equals(flevel)){ %>checked<%} %> value="<%=flevel %>" name="_flevel_<%=eid%>" onclick="if(this.checked){this.value='9';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(18178,user.getLanguage())%>
		<BR>
		<INPUT type=checkbox <%if("10".equals(fdate)){ %>checked<%} %> value="<%=fdate %>" name="_fdate_<%=eid%>" onclick="if(this.checked){this.value='10';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(24951,user.getLanguage())%>
		<BR>
	</wea:item>	
	<%} %>	
	</wea:group>
</wea:layout>
