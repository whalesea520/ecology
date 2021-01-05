
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
if(! HrmUserVarify.checkUserRight("email:templateSetting", user)) { 
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(16218,user.getLanguage());
String needfav ="1";
String needhelp ="";


int userId = Util.getIntValue(request.getParameter("userid"));
if(userId==-1){
	userId = user.getUID();
}
String searchName = Util.null2String(request.getParameter("searchName"));
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

function editInfo(id){
	location.href = "MailTemplateEdit.jsp?id="+id;
}

function deleteInfo(id){
	if(confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>")){
		location.href="MailTemplateOperation.jsp?id="+id;
	}
}

function redirect(){
	location.href="/email/MailTemplateAdd.jsp?userid=<%=user.getUID()%>";
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
	var url = "/email/maint/DocMouldAdd.jsp";
	dialog.Title = "新建模板";
	dialog.Width = 800;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function editInfo(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/email/maint/DocMouldEdit.jsp?id="+id;
	dialog.Title = "编辑模板";
	dialog.Width = 800;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function viewInfo(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/email/maint/DocMouldDsp.jsp?id="+id;
	dialog.Title = "预览模板";
	dialog.Width = 800;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function deleteInfo(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
		jQuery.post("UploadDoc.jsp",{"operation":"delete","ids":id},function(){
			_table.reLoad();
		});
	});
}

function batchDelete(){
	var id = _xtable_CheckedCheckboxId();
   	if(!id){
		window.top.Dialog.alert("请选择要删除的记录!");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	deleteInfo(id);

}

function searchName(){
	var searchName = jQuery("#searchName").val();
	location.href = "MailTemplateFrame.jsp?searchName="+searchName;
}

$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:searchName});
	jQuery("#hoverBtnSpan").hoverBtn();
				
});
</script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addInfo(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%

int perpage = 10;
String backFields = "t.*";
String orderBy = "t.mouldname";
String sqlFrom = "DocMailMould t";
String sqlwhere = "1=1";
if(!searchName.equals("")){
	sqlwhere +=" and mouldname like '%"+searchName+"%'";
}
String operateString= "<operates width=\"15%\">";
       operateString+=" <popedom transmethod=\"weaver.email.MailMaintTransMethod.getTemplateOperatePopedom\" column=\"tempType\"></popedom> ";
       operateString+="     <operate href=\"javascript:editInfo()\" otherpara = \"column:tempType\" target=\"_self\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
   	   operateString+="     <operate href=\"javascript:viewInfo()\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>";
	   operateString+="     <operate href=\"javascript:deleteInfo()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>";
	   operateString+="</operates>";
String tableString="<table  pageId=\""+PageIdConst.Email_TemplateManage+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_TemplateManage,user.getUID(),PageIdConst.EMAIL)+"\" tabletype=\"checkbox\">";
       tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"ASC\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
       tableString+="<head>";
       tableString+="<col width=\"30%\"  target=\"_self\" text=\""+ SystemEnv.getHtmlLabelName(18151,user.getLanguage()) +"\" column=\"mouldname\""+
       				" otherpara = \"column:id\"  transmethod=\"weaver.email.MailMaintTransMethod.getTemplateName\" />";
       tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(85,user.getLanguage()) +"\" column=\"mouldDesc\" transmethod=\"weaver.email.MailMaintTransMethod.getTemplateMould\"/>";
       tableString+="<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(20622,user.getLanguage()) +"\" column=\"id\" transmethod=\"weaver.email.MailMaintTransMethod.getTemplateType\"/>";
       tableString+="</head>"+operateString;
       tableString+="</table>";
%>


<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33447,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="addInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>"/>
			<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
			<input type="text" class="searchInput"  id="searchName" name="searchName" value="<%=searchName %>"/>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form id="fMailTemplate" method="post" action="MailTemplateOperation.jsp">
<input type="hidden" name="operation" value="default" />
<input type="hidden" name="templateType" value="" />
<input type="hidden" name="defaultTemplateId" value="" />

</form>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_TemplateManage%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body>
</html>
