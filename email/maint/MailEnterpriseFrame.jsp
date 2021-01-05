
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<%
if(! HrmUserVarify.checkUserRight("email:enterpriseSetting", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(16218,user.getLanguage());
String needfav ="1";
String needhelp ="";

String showTop = Util.null2String(request.getParameter("showTop"));

int userId = Util.getIntValue(request.getParameter("userid"));
if(userId==-1){
	userId = user.getUID();
}
%>

<html> 
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
<head>
<script type="text/javascript">

function doSubmit(){
	var radios = document.getElementsByName("isDefault");
	for(var i=0;i<radios.length;i++){
		if(radios[i].checked){
			fMailTemplate.templateType.value = radios[i].getAttribute("templateType");
			fMailTemplate.defaultTemplateId.value = radios[i].value;
			break;
		}
	}
	document.forms[0].submit();
}


var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
	_table.reLoad();
}

function addInfo(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/email/maint/AddEnterprise.jsp";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(129995, user.getLanguage()) %>"; //新建企业邮箱
	dialog.Width = 600;
	dialog.Height = 430;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function editInfo(DOMAIN_ID){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/email/maint/AddEnterprise.jsp?DOMAIN_ID="+DOMAIN_ID;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(129996, user.getLanguage()) %>";  //编辑企业邮箱
	dialog.Width = 600;
	dialog.Height = 430;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();

}

function deleteInfo(DOMAIN_ID){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
		jQuery.post("MailMaintOperation.jsp",{"method":"delEnterprise","DOMAIN_IDS":DOMAIN_ID},function(){
			_table.reLoad();
		});
	});
}

function batchDelete(){
	var id = _xtable_CheckedCheckboxId();
   	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568, user.getLanguage()) %>");//请选择要删除的记录!
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	deleteInfo(id);

}

function searchDOMAIN(){
	var searchDOMAIN = jQuery("#searchDOMAIN").val();
	location.href = "MailEnterpriseFrame.jsp?searchDOMAIN="+searchDOMAIN;
}

$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:searchDOMAIN});
	jQuery("#hoverBtnSpan").hoverBtn();
});
</script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<style type="text/css">.href{color:blue;text-decoration:underline;cursor:hand}</style>
</head>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addInfo(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:batchDelete(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%

String searchDOMAIN = Util.null2String(request.getParameter("searchDOMAIN"));

int perpage = 10;
String backFields = "*";
String sqlFrom = "webmail_domain";
String sqlwhere = " DOMAIN like '%"+searchDOMAIN+"%'";
String operateString= "<operates width=\"15%\">";
       operateString+=" <popedom transmethod=\"weaver.email.MailMaintTransMethod.getWebmailOpreatePopedom\" column=\"DOMAIN_ID\"></popedom> ";
       operateString+="     <operate href=\"javascript:editInfo()\"  target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
   	   operateString+="     <operate href=\"javascript:deleteInfo()\" target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"   index=\"1\"/>";
	   operateString+="</operates>";
String tableString="<table  pageId=\""+PageIdConst.Email_EnterpriseMail+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_EnterpriseMail,user.getUID(),PageIdConst.EMAIL)+"\" tabletype=\"checkbox\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\"  sqlsortway=\"desc\" sqlprimarykey=\"DOMAIN_ID\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
       tableString+="<head>";
       tableString+="<col width=\"30%\"  target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(129997,user.getLanguage())+"\" column=\"DOMAIN\" otherpara=\"column:DOMAIN_ID\""+
          " transmethod=\"weaver.email.MailMaintTransMethod.getEmailDomainTitle\"/>"; //企业邮箱名称
       tableString+="<col width=\"30%\"  target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"IS_POP\" transmethod=\"weaver.email.MailMaintTransMethod.getWebmailType\"/>";
       tableString+="<col width=\"30%\"  target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(18526,user.getLanguage())+SystemEnv.getHtmlLabelName(2058,user.getLanguage())+"\" column=\"POP_SERVER\"/>";
       tableString+="<col width=\"30%\"  target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(2083,user.getLanguage())+SystemEnv.getHtmlLabelName(2058,user.getLanguage())+"(SMTP)\" column=\"SMTP_SERVER\"/>";
       tableString+="</head>"+operateString;
       tableString+="</table>";
%>
<body>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33449,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="addInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>"/>
			<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
			<input type="text" class="searchInput"  id="searchDOMAIN" name="searchDOMAIN" value="<%=searchDOMAIN %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>

<form id="fMailTemplate" method="post" action="MailTemplateOperation.jsp">
<input type="hidden" name="operation" value="default" />
<input type="hidden" name="templateType" value="" />
<input type="hidden" name="defaultTemplateId" value="" />
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_EnterpriseMail%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 
</form>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
</html>
