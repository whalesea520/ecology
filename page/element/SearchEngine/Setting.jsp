<jsp:useBean id="dnc" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="rs_setting" class="weaver.conn.RecordSet" scope="page" />
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<%@ include file="common.jsp" %>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%
String newsId = (String)valueList.get(nameList.indexOf("newsid"));
String newsTemplate = (String) valueList.get(nameList.indexOf("newstemplate"));
String newsName = "";
if(!"".equals(newsId))
{
	newsName = dnc.getDocNewsname(newsId);
}
String userLanguageId = user.getLanguage()+"";
String selected="";

rs_setting.execute("select * from pagenewstemplate where templatetype='1'");

String selectStr="<select id='_newstemplate_"+eid+"' name='_newstemplate_"+eid+"'>";
selectStr+="<option value=''>"+SystemEnv.getHtmlLabelName(18214, Util.getIntValue(userLanguageId))+"</option>";
while(rs_setting.next()){
	if(rs_setting.getString("id").equals(newsTemplate)){
		selected = "selected";
	}else{
		selected="";
	}
	selectStr+="<option value='"+rs_setting.getString("id")+"' "+selected+">"+rs_setting.getString("templatename")+"</option>";
}
selectStr+="</select>";
%>
<%
if("2".equals(esharelevel)){
		%>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(22919,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT id="_newsid_<%=eid%>" type=hidden value="<%=newsId %>" name="_newsid_<%=eid%>">
		<BUTTON class=Browser type="button" onclick=onShowNewNews(_newsid_<%=eid%>,spannews_<%=eid%>,<%=eid%>,0)></BUTTON>
		<SPAN id=spannews_<%=eid%>>
			<%
			if(!"".equals(newsName))
			{
			%>
			<a href="/docs/news/NewsDsp.jsp?id=<%=newsId %>" target='_blank'><%=newsName %></a>
			<%
			}
			%>
		</SPAN>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(23088,user.getLanguage())%></wea:item>
	<wea:item>
		<%=selectStr%>
	</wea:item>
	<%} %>
	</wea:group>
</wea:layout>
