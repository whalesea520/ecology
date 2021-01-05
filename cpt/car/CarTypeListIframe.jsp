
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
</head>
<% 
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17630,user.getLanguage());
String needfav ="1";
String needhelp ="";
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int	perpage=10;
String searchName=Util.null2String(request.getParameter("searchName"));
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" >
<tr>
	<td></td>
	<td class="rightSearchSpan">
	<%//if(subCompanyId!=0){
		//if(operatelevel>0){%>
			<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" onclick="javascript:doAdd()"/>				
		<%//}%>
	<%//}%>
		<input type="text" class="searchInput" value="<%=searchName%>" id="flowTitle" name="flowTitle"/>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
	</td>
</tr>
<form id="frmmain" NAME="frmmain" STYLE="margin-bottom:0" action="/cpt/car/CarTypeListIframe.jsp" method=post>
	<input type="hidden" id="searchName" name="searchName" value="<%=searchName%>" />
</form>
</table>
<%
	String backfields = " id,name,description,usefee ";
	String fromSql = " from cartype ";
	String sqlWhere = "";
	if (!searchName.equals("")) sqlWhere = " where name like '%" +searchName+ "%'"; 
	String orderby = " id ";
	String tableString = "<table instanceid=\"CarTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
		                 "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\"/>"+
		                 "	 <head>"+
		                 "		<col width=\"17%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" />"+
		                 "		<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"description\"/>"+
		                 "		<col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(1491,user.getLanguage())+"\" column=\"usefee\"/>"+
		                 "	 </head>"+
						 "	 <operates width=\"15%\">";
					     //  if(operatelevel>0){
						         tableString +=	"<operate href=\"javascript:doEdit()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>";
					     //  }
					     //  if(operatelevel>1){
								 tableString +=	"<operate href=\"javascript:doDel()\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\"  index=\"1\"/>";
					     //  }
		  tableString += "</operates></table>";
%>
    <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
</BODY>
<script language=javascript>
var diag_vote;
<%--function doAdd(){
	document.frmmain.action="CarTypeAdd.jsp";
	document.frmmain.submit();
}
function doEdit(id){
	document.frmmain.action="CarTypeEdit.jsp?id="+id;
	document.frmmain.submit();
}--%>
function doDel(id){
	var str = "<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>";
	Dialog.confirm(
		str, 
		function(){
			document.frmmain.action="CarTypeOperation.jsp?operation=delete&id="+id;
			document.frmmain.submit();
		}, 
		function(){
			return;
		}, 
		200, 
		80
	);
}
function closeDlgARfsh(){
	diag_vote.close();
	doSearchsubmit();
}

function doSearchsubmit(){
	document.frmmain.submit();
}
function onBtnSearchClick(){
	document.frmmain.searchName.value = jQuery("#flowTitle").val();
	document.frmmain.submit();
}
function closeDialog(){
	//diag_vote.close();
	diag_vote.close();
}
function doAdd(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 350;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())+""+SystemEnv.getHtmlLabelName(17630,user.getLanguage())%>";
	diag_vote.URL = "/cpt/car/CarTypeAddTab.jsp?dialog=1";
	diag_vote.show();
}
function doEdit(id){
    url = "/cpt/car/CarTypeEditTab.jsp?dialog=1&id="+id;
	showDialog(url);
}
function showDialog(url){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 350;
	diag_vote.Modal = true;
	diag_vote.checkDataChange = false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+""+SystemEnv.getHtmlLabelName(17630,user.getLanguage())%>";
	diag_vote.maxiumnable = true;
	diag_vote.URL = url;
	diag_vote.show();
}
</script>
</HTML>
