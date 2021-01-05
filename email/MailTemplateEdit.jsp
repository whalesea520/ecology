
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(16218,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));

String templateName = "", templateDescription = "", templateSubject = "", templateContent = "";
int id = Util.getIntValue(request.getParameter("id"));
String sql = "SELECT * FROM MailTemplate WHERE id="+id+"";
rs.executeSql(sql);
if(rs.next()){
	templateName = rs.getString("templateName");
	templateDescription = rs.getString("templateDescription");
	templateSubject = rs.getString("templateSubject");
	templateContent = rs.getString("templateContent");
}
%>

<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/imgupload_wev8.js"></script>

<%@ include file="/cowork/uploader.jsp" %>
<jsp:include page="MailUtil.jsp"></jsp:include>

<script type="text/javascript">

$(document).ready(function(){
	highEditor("mouldtext");
});


function doSubmit(){
	if(check_form(fMailTemplate,'templateName')){
	with(document.getElementById("fMailTemplate")){
		
		changeImgToEmail("mouldtext");
		var remarkValue=getRemarkHtml("mouldtext");
		$("textarea[name=mouldtext]").val(remarkValue);
		
		document.fMailTemplate.submit();
	}}
}


function onHtml(){
	if(document.fMailTemplate.mouldtext.style.display==''){
		text = document.fMailTemplate.mouldtext.value;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML=text;
		document.fMailTemplate.mouldtext.style.display='none';
		divifrm.style.display='';
	}else{
		text = document.frames("dhtmlFrm").document.tbContentElement.DocumentHTML;
		text = text.replace("Microsoft DHTML Editing Control","Weaver DHTML Editing Control");
		document.fMailTemplate.mouldtext.value=text;
		document.fMailTemplate.mouldtext.style.display='';
		divifrm.style.display='none';
	}
}

</script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
</head>
<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(222,user.getLanguage())+",javascript:CkeditorExt.switchEditMode(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16218,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="doSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailTemplateOperation.jsp" id="fMailTemplate" name="fMailTemplate">
<input type="hidden" name="operation" value="update" />
<input type="hidden" name="id" value="<%=id%>" />
<input type="hidden" name="userid" value="<%=user.getUID()%>" />
<%
int oldpicnum = 0;
/*
int pos = templateContent.indexOf("<img alt=\"");
while(pos!=-1){
	pos = templateContent.indexOf("?fileid=",pos);
	if(pos==-1) continue;
	int endpos = templateContent.indexOf("\"",pos);
	String tmpid = templateContent.substring(pos+8,endpos);
	int startpos = templateContent.lastIndexOf("\"",pos);
	String servername = request.getHeader("host");
	String tmpcontent = templateContent.substring(0,startpos+1);
	//tmpcontent += "http://"+servername;
	tmpcontent += templateContent.substring(startpos+1);
	templateContent = tmpcontent;
%>
<input type=hidden name=olddocimages<%=oldpicnum%> value="<%=tmpid%>">
<%
	pos = templateContent.indexOf("<img alt=\"",endpos);
	oldpicnum += 1;
}*/
%>
<input type=hidden name=olddocimagesnum value="<%=oldpicnum%>">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="templateNameSpan">
				<input type="text" name="templateName" class="inputstyle" style="width:30%" value="<%=templateName%>"
					 onChange="checkinput('templateName','templateNameSpan')" />
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="templateDescription" class="inputstyle" style="width:30%" value="<%=templateDescription%>" />
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19853,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="templateSubject" class="inputstyle" style="width:30%" value="<%=templateSubject%>" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></wea:item>
		<wea:item>
			<div style="width:98%">
			 	<textarea id="mouldtext" _editorid="mouldtext" _editorName="mouldtext" style="width:100%;height:300px;border:1px solid #C7C7C7;"><%=templateContent%></textarea>
			</div>
		</wea:item>
	</wea:group>
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</form>
</body>
</html>
