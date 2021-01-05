<%@ page import="weaver.general.Util,weaver.general.ExportExcelUtil" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("System:LabelManage", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String isclose = Util.null2String(request.getParameter("isclose"));
String msg = Util.null2String(request.getParameter("message"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/characterConv_wev8.js"></script>
<script language=javascript >
<%if("error".equals(msg)){%>
	top.Dialog.alert("<%=ExportExcelUtil.errorMsg%>");
<%ExportExcelUtil.errorMsg = "";}%>
function onSave(){
	if(check_form(weaver,"file")){
		document.getElementById("weaver").submit();
	}
}
function onBack(){
	parent.location.href='/systeminfo/errormsg/ManageErrorMsg.jsp'
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(81486,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(32935,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32935,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id="weaver" name="weaver" action="ErrorMsgOperation.jsp" method=post enctype="multipart/form-data">
<wea:layout>
		<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item>
				<%=SystemEnv.getHtmlLabelNames("82694",user.getLanguage())%>
			</wea:item>
			<wea:item>
				<wea:required id="filespan">
					<input type="file" name="file" id="file"/>
				</wea:required>
			</wea:item>
		</wea:group>
		<%if("success".equals(msg)){ %>
			<wea:group context='<%= SystemEnv.getHtmlLabelName(82341,user.getLanguage())%>'>
				<wea:item attributes="{'isTableList':'true'}">
					<wea:layout type="table" needImportDefaultJsAndCss="true" attributes="{'cols':2,'cws':'30%,70%'}">
						<wea:group context="" attributes="{'groupDisplay':'none'}">
							<wea:item type="thead">ID</wea:item>
							<wea:item type="thead"><%= SystemEnv.getHtmlLabelName(33368,user.getLanguage())%></wea:item>
							<%if(SystemEnv.errors.isEmpty()){ %>
								<wea:item attributes="{'colspan':'full'}">Success</wea:item>
							<%}else{ 
								Iterator iter = SystemEnv.errors.entrySet().iterator();
								while(iter.hasNext()){
									Map.Entry entry = (Map.Entry) iter.next();
									int key = Util.getIntValue(Util.null2String(entry.getKey()));
					  				String val = Util.null2String(entry.getValue());
					  		%>
					  			<wea:item><%=key%></wea:item>
					  			<wea:item><%=val%></wea:item>
					  		<%
								}
								SystemEnv.errors.clear();
							} %>
						</wea:group>
					</wea:layout>
				</wea:item>
			</wea:group>
		<%} %>
	</wea:layout>
          <input type=hidden value="import" name="operation">
</FORM>
</BODY></HTML>
