
<jsp:useBean id="dnc" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="rs_tabInfo" class="weaver.conn.RecordSet" scope="page" />
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
	String showtitle = (String)valueList.get(nameList.indexOf("showtitle"));
	String showauthor = (String)valueList.get(nameList.indexOf("showauthor"));
	String showpubdate = (String)valueList.get(nameList.indexOf("showpubdate"));
	String showpubtime = (String)valueList.get(nameList.indexOf("showpubtime"));
	String wordcount = (String)valueList.get(nameList.indexOf("wordcount"));
	String whereKey = (String)valueList.get(nameList.indexOf("whereKey"));
	String listType = (String)valueList.get(nameList.indexOf("listType"));
	String imagesize =(String)valueList.get(nameList.indexOf("imagesize"));
	
	String whereSrcName = "";
	if(!"".equals(whereKey))
	{
		whereSrcName = dnc.getDocNewsname(whereKey);
	}
	String userLanguageId = user.getLanguage()+"";
    rs_tabInfo.execute("select newstemplate from hpElement where id="+eid);
	
	String currentTemplateId="";
	String selected="";
	if(rs_tabInfo.next()){
		currentTemplateId = rs_tabInfo.getString("newstemplate");	
	}
	rs_tabInfo.execute("select * from pagenewstemplate where templatetype='1'");
	
	String selectStr="<select id='_newstemplate"+eid+"' >";
	selectStr+="<option value=''>"+SystemEnv.getHtmlLabelName(18214, Util.getIntValue(userLanguageId))+"</option>";
	while(rs_tabInfo.next()){
		if(rs_tabInfo.getString("id").equals(currentTemplateId)){
			selected = "selected";
		}else{
			selected="";
		}
		selectStr+="<option value='"+rs_tabInfo.getString("id")+"' "+selected+">"+rs_tabInfo.getString("templatename")+"</option>";
	}
	selectStr+="</select>";
%>

	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19495,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT type=checkbox <%if("7".equals(showtitle)){ %>checked<%} %> value="<%=showtitle %>" name=_showtitle_<%=eid%> onclick="if(this.checked){this.value='7';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>
		<BR>
		<INPUT type=checkbox <%if("8".equals(showauthor)){ %>checked<%} %> value="<%=showauthor %>" name="_showauthor_<%=eid%>" onclick="if(this.checked){this.value='8';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%>
		<BR>
		<INPUT type=checkbox <%if("9".equals(showpubdate)){ %>checked<%} %> value="<%=showpubdate %>" name="_showpubdate_<%=eid%>" onclick="if(this.checked){this.value='9';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(17883,user.getLanguage())%>
		<BR>
		<INPUT type=checkbox <%if("10".equals(showpubtime)){ %>checked<%} %> value="<%=showpubtime %>" name="_showpubtime_<%=eid%>" onclick="if(this.checked){this.value='10';}else{this.value='';}">&nbsp;<%=SystemEnv.getHtmlLabelName(1862,user.getLanguage())%>
		<BR>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT TYPE="text"  name="_imagesize_<%=eid%>" value="<%=imagesize%>" size=3 class="inputStyle" style="width:24PX">
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></wea:item>
	<wea:item>
		<select name="_listType_<%=eid%>">
			<option value=1 <%="1".equals(listType)?"selected":""%>><%=SystemEnv.getHtmlLabelName(19525,Util.getIntValue(userLanguageId))%></option>
            <option value=2 <%="2".equals(listType)?"selected":""%>><%=SystemEnv.getHtmlLabelName(19527,Util.getIntValue(userLanguageId))%></option>
            <option value=3 <%="3".equals(listType)?"selected":""%>><%=SystemEnv.getHtmlLabelName(19525,Util.getIntValue(userLanguageId))%>2</option>
		</select>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(23088,user.getLanguage())%></wea:item>
	<wea:item>
		<%=selectStr %>
	</wea:item>
</wea:group>
<wea:group context='<%=SystemEnv.getHtmlLabelName(22919,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
	
	<jsp:useBean id="pLayout" class="weaver.page.element.compatible.PageTableLayoutWhere" scope="page" />
	
	<%
	String randomValue = Util.null2String(request.getParameter("randomValue"));
	String userLanguageId = user.getLanguage()+"";
	String url = "/page/element/compatible/CompanyNewsSetting.jsp?eid="+eid+"&userLanguageId="+userLanguageId;
	String strTabSql = "select * from hpNewsTabInfo where eid="+eid +" order by orderNum ";
	
	rs_tabInfo.execute(strTabSql);

	String tableStr= pLayout.getTabTableStr(rs_tabInfo, eid, ebaseid, userLanguageId, url, randomValue, null);
	String headStr = pLayout.gettoolBarItem(eid, url, ebaseid, userLanguageId);
 %>
 		<wea:item type='groupHead'>&nbsp;<%=headStr%>&nbsp;</wea:item>
		<wea:item attributes="{\"isTableList\":\"true\"}"><%=tableStr%></wea:item>	
</wea:group>
</wea:layout>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>	
<script>
$(document).ready(function(){
	jQuery("tr.notMove").bind("mousedown", function() {
		return false;
	});
	$("#tabSetting_<%=eid%>").find("tr")
		.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
		.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
	registerDragEvent('tabSetting_','<%=eid%>');
})
</script>