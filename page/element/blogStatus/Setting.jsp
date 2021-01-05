
<%@page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs_Setting" class="weaver.conn.RecordSet" scope="page" />
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%
	String  blog_showNum="10";
    String 	blog_isCreatedate="1";
    String 	blog_isRelatedName="1";
	String sql="select name,value from hpelementsetting where eid='"+eid+"'";
	rs_Setting.execute(sql);
	while(rs_Setting.next()){
		String name=rs_Setting.getString("name");
		if(name.equals("blog_showNum"))
			blog_showNum=rs_Setting.getString("value");
		else if(name.equals("blog_isCreatedate"))
			blog_isCreatedate=rs_Setting.getString("value");
		else if(name.equals("blog_isRelatedName"))
			blog_isRelatedName=rs_Setting.getString("value");
	}
%>
<%
if("2".equals(esharelevel)){
		%>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19493,user.getLanguage())%></wea:item>
	<wea:item>
		<input name="blog_showNum_<%=eid %>" class="inputStyle" style="width:120px" value='<%=blog_showNum %>'></input>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19495,user.getLanguage())%></wea:item>
	<wea:item>
	  <input name="blog_isRelatedName_<%=eid %>" type="checkbox" <%=blog_isRelatedName.equals("1")?"checked=checked":""%> value='1'></input>&nbsp;<%=SystemEnv.getHtmlLabelName(792,user.getLanguage())%>
	  <br>
	  <input name="blog_isCreatedate_<%=eid %>" type="checkbox" <%=blog_isCreatedate.equals("1")?"checked=checked":""%>  value='1'></input>&nbsp;<%=SystemEnv.getHtmlLabelName(784,user.getLanguage())%>
	</wea:item>
<%} %>
	</wea:group>
</wea:layout>