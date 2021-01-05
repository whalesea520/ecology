<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="com.weaver.file.FileOperation"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
int num = 0;
String process = Util.null2String(request.getParameter("process"));
%>
<HTML>
<HEAD>
<script type="text/javascript">
try{
	parent.setTabObjName("");
}catch(e){
	if(window.console)console.log(e+"");
}
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.getParentWindow(parent);
	dialog = parent.getDialog(window);
}catch(e){}

function cover() {
	$.ajax({
		"url":'/coverfiles.do',
		"type":'post',
		"success":function(data){
			var res = data.result;
			if("ok"==res) {
				
				window.location.href="/jsp/upgradefiles.jsp?process=<%=process%>";
			}
		}
	});
}

function exportExcel() {
	document.getElementById("excels").src = "/jsp/errorFilesExcel.jsp";
}
</script>
</HEAD>
<%

HashMap<String,String> files = FileOperation.getErrorfiles();
Iterator<Map.Entry<String,String>> it  = files.entrySet().iterator();
%>

<BODY>
<jsp:include page="/jsp/systeminfo/commonTabHead.jsp?step=3">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="本地升级" />
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<input id="process" value="<%=process%>" type="hidden"></input>
<div style="width:24%;height:100%;float:left;background:#fcfcfc;">
<jsp:include page="step.jsp?"></jsp:include>
</div>
<div style="width:75%;height:100%;float:right">
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31260,user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:cover(),_self"/>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:exportExcel(),_self"/>
		</td>
		
		
	</tr>
	</table>
<%
RCMenu += "{"+""+SystemEnv.getHtmlLabelName(31260,user.getLanguage())+",javascript:cover(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+""+SystemEnv.getHtmlLabelName(28343,user.getLanguage())+",javascript:exportExcel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<wea:layout attributes="{'cols':'2','cws':'5%,95%'}">
<wea:group context="<%=SystemEnv.getHtmlLabelName(22045,user.getLanguage()) %>">
<%while(it.hasNext()) {
	Map.Entry<String,String> map = it.next();
	String filename = map.getValue();
%>
<wea:item><%=++num %></wea:item>
<wea:item><%=filename %></wea:item>
<%} %>
</wea:group>

</wea:layout>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe name="excels" id="excels" src="" style="display:none" ></iframe> 
</BODY>
</HTML>

