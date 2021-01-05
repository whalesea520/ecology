
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23141,user.getLanguage());
String needfav ="1";
String needhelp ="";

int userId = 0;
userId = user.getUID();
if(!HrmUserVarify.checkUserRight("LoginPageMaint", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmMain" id="frmMain" method="post" action="loginTemplateOperation.jsp">
<input type="hidden" name="operationType" id="operationType" value="selectLoginTemplate"/>
<input type ="hidden" name="templateid" id="templateid" value=""/>
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="75px">
								
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="doDelAll();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="checkSubmit();" />
				<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
		
<%
	//得到pageNum 与 perpage
	int perpage =10;
	//设置好搜索条件
	String tableString="<table  pagesize=\""+perpage+"\" tabletype=\"checkbox\" valign=\"top\" >"
	  + "<checkboxpopedom popedompara=\"column:logintemplateid+column:isCurrent\"  showmethod=\"weaver.splitepage.transform.SptmForLoginTemplate.getTemplateDel\"/>"
	  + "<sql backfields=\" * \" sqlform=\" from SystemLoginTemplate \" sqlorderby=\"logintemplateid\"  sqlprimarykey=\"logintemplateid\" sqlsortway=\"desc\" sqlwhere=\"\" sqlisdistinct=\"false\" />"+
		"<head >"+
			"<col width=\"10\"   text=\"ID\"   column=\"logintemplateid\" />"+

			"<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(32533,user.getLanguage())+"\"   column=\"logintemplatename\" otherpara=\"column:logintemplateid+column:templateType+column:extendloginid\" transmethod=\"weaver.splitepage.transform.SptmForLoginTemplate.getTemplateName\"/>"+
			"<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\"   column=\"logintemplateid\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.splitepage.transform.SptmForLoginTemplate.getTemplateType\"/>"+
			"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(18095,user.getLanguage())+"\"   column=\"logintemplateid\" otherpara=\"column:iscurrent\" transmethod=\"weaver.splitepage.transform.SptmForLoginTemplate.getTemplateSelectStr\"/>"+
			"<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(19520,user.getLanguage())+"\"   column=\"lasteditdate\"/>"+

		"</head>"
		 + "<operates><popedom otherpara=\"column:isCurrent\" transmethod=\"weaver.splitepage.transform.SptmForLoginTemplate.getOperate\"></popedom> "
		 + "<operate href=\"javascript:doPreview();\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"0\"/>"
		 + "<operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_blank\"  index=\"1\"/>"
		 + "<operate href=\"javascript:doSaveAs();\" text=\""+SystemEnv.getHtmlLabelName(350,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>"
		 + "<operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"3\"/>"
		 + "</operates></table>";						
	%>
<TABLE width="100%">
	<TR>
		<TD valign="top">
			<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"   />
		</TD>
	</TR>
</TABLE>

<div id="saveAsTable" style="display:none">
<wea:layout type="2Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"none\"}">
    <wea:item><%=SystemEnv.getHtmlLabelName(32533,user.getLanguage()) %>:</wea:item>
	<wea:item>
		<input type="text" class="inputstyle" name="saveAsName" id ="saveAsName" style="width:90% !important" onchange="checkinput('saveAsName','saveAsNameSpan')">
			
        <span id="saveAsNameSpan"><img src="/images/BacoError_wev8.gif" align="absMiddle"></span>
	</wea:item>
	</wea:group>
</wea:layout>
</div>
</form>
</body>
</html>
<script language="javascript">
jQuery(document).ready(function(){
	
})

function checkSubmit(){
	document.frmMain.submit();
	window.frames["rightMenuIframe"].event.srcElement.disabled = true;
}


function doDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>",function(){
		$("#operationType").val("delete")
		$("#templateid").val(id);
		document.frmMain.submit();
		
	})
}

function doDelAll(){
	if(isdel()){
		$("#operationType").val("delete")
		//alert(_xtable_CheckedCheckboxId())
		$("#templateid").val(_xtable_CheckedCheckboxId());
		document.frmMain.submit();
		
	}
}

function getDialogWidth(){
	return top.document.body.clientWidth;
}

function getDialogHeight(){
	return top.document.body.clientHeight;
}

function doPreview(id){
	var type = $("#template_"+id).attr("templatetype");
	var extendurl = $("#template_"+id).attr("extendurl");
	var url="";
	if(type=="E"){
		url="/"+extendurl+"index.jsp"; 
	} else if(type="E8") {
		url='/systeminfo/template/loginTemplatePreview.jsp?loginTemplateId='+id;
	}	
	var menuStyle_dialog = new window.top.Dialog();
	menuStyle_dialog.currentWindow = window;   //传入当前window
 	menuStyle_dialog.Width = getDialogWidth();
 	menuStyle_dialog.Height = getDialogHeight();
 	menuStyle_dialog.maxiumnable=true;
 	menuStyle_dialog.Modal = true;
 	menuStyle_dialog.Title = "<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"; 
 	menuStyle_dialog.URL = url
 	menuStyle_dialog.show();
}

function doEdit(id){
	var menuStyle_dialog = new window.top.Dialog();
	menuStyle_dialog.currentWindow = window;   //传入当前window
 	menuStyle_dialog.Width = getDialogWidth();
 	menuStyle_dialog.Height = getDialogHeight();
 	menuStyle_dialog.maxiumnable=true;
 	menuStyle_dialog.Modal = true;
 	menuStyle_dialog.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"; 
 	//menuStyle_dialog.URL = "/systeminfo/template/loginTemplateEdit.jsp?id="+id;
 	menuStyle_dialog.URL = "/systeminfo/template/loginTemplateTabs.jsp?id="+id;
 	menuStyle_dialog.show();
	
}
//var dialog = parent.getDialog(window);
//var parentWin = parent.getParentWindow(window);
function doSaveAs(id){
	var menuStyle_dialog = new window.top.Dialog();
	menuStyle_dialog.currentWindow = window;   //传入当前window
 	menuStyle_dialog.Width = 400;
 	menuStyle_dialog.Height = 150;
 	menuStyle_dialog.maxiumnable=false;
 	menuStyle_dialog.Modal = true;
 	menuStyle_dialog.Title = "<%=SystemEnv.getHtmlLabelName(350,user.getLanguage())%>"; 
 	menuStyle_dialog.URL = "/systeminfo/template/loginTemplateSaveAs.jsp?templateid="+id;
 	menuStyle_dialog.show();
}

</script>
