<%@ page import="weaver.docs.docs.DocComInfo" %>
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
String noticeImg = (String)valueList.get(nameList.indexOf("noticeimg"));
String noticeTitle = (String)valueList.get(nameList.indexOf("noticetitle"));
String noticeContent = (String) valueList.get(nameList.indexOf("noticecontent"));
String direction = (String) valueList.get(nameList.indexOf("direction"));
String scrollDelay = (String) valueList.get(nameList.indexOf("scrollDelay"));
String onlytext = (String) valueList.get(nameList.indexOf("onlytext"));

String selectLeft="";
String selectRight="";
if(direction.equals("left")){
	selectLeft = "selected";
}else if(direction.equals("right")){
	selectRight = "selected";
}
String selectNo="",selectYes="";
if("no".equals(onlytext)){
	selectNo = "selected";
}else if("yes".equals(onlytext)){
	selectYes = "selected";
}
DocComInfo dci=new DocComInfo();
String strSrcContentName=dci.getMuliDocName2(noticeContent);
%>
<%
if("2".equals(esharelevel)){
		%>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT style="width:98%" TYPE="text" class=filetree title=<%=SystemEnv.getHtmlLabelName(22969,user.getLanguage())%> value="<%=noticeImg %>" name="_noticeimg_<%=eid%>" >
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT style="width:98%" TYPE="text" class=inputstyle title=<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%> value="<%=noticeTitle %>" name="_noticetitle_<%=eid%>" id="_noticetitle_<%=eid%>">
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
	<wea:item>
		<BUTTON class=Browser type="button" onclick=onShowDoc(_noticecontent_<%=eid%>,spandocids_<%=eid %>,<%=eid %>)></BUTTON>
		<input type='hidden' id="_noticecontent_<%=eid%>"  name="_noticecontent_<%=eid%>" value="<%=noticeContent %>" />
	 	<SPAN ID=spandocids_<%=eid %>><%=strSrcContentName%></SPAN>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(20281,user.getLanguage())%></wea:item>
	<wea:item>
		<select name="_direction_<%=eid%>">
			<option value='left'  <%=selectLeft %>><%=SystemEnv.getHtmlLabelName(20282,user.getLanguage())%></option>
			<option value='right' <%=selectRight %>><%=SystemEnv.getHtmlLabelName(20283,user.getLanguage())%></option>
		</select>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(22927,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT class=inputstyle title=<%=SystemEnv.getHtmlLabelName(22927,user.getLanguage())%> style="WIDTH: 30px" value="<%=scrollDelay %>" name="_scrollDelay_<%=eid%>" onkeypress="ItemCount_KeyPress()" > ms
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19111,user.getLanguage())%></wea:item>
	<wea:item>
		<select name="_onlytext_<%=eid %>">
			<option value='no' <%=selectNo %>><%=SystemEnv.getHtmlLabelName(82676,user.getLanguage())%></option>
			<option value='yes' <%=selectYes %>><%=SystemEnv.getHtmlLabelName(82677,user.getLanguage())%></option>
		</select>
	</wea:item>
<%} %>
	</wea:group>
</wea:layout>
<script type="text/javascript">
	function onchanges(eid){
		var v = document.getElementById("_noticetitle_"+eid).value;
		document.getElementById("_noticetitle_"+eid).value = v.replace(/'/g,"\\'");
	}
	
</script>
