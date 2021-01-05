
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.ldap.LdapUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</head>
<BODY>
<% 
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33267,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean isoracle = (rs.getDBType()).equals("oracle") ;
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("intergration:ldapsetting", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

String account = Util.null2String(request.getParameter("account"));
String lastname = Util.null2String(request.getParameter("lastname"));

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
rs.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(rs.next()){
	perpage =Util.getIntValue(rs.getString(36),-1);
}
if(perpage<=1 )	perpage=10;

String backfields = " id,loginid,lastname  ";
String fromSql  = " from HrmResource ";
String sqlWhere = " status<4 and departmentid is null and subcompanyid1 is null and isADAccount = '1' and loginid is not null "+(isoracle?"":" and loginid !='' ")  ;
if(StringUtils.isNotBlank(account)){
	sqlWhere += "  and loginid like '%"+account+"%' ";
}
if(StringUtils.isNotBlank(lastname)){
	sqlWhere += "  and lastname like '%"+lastname+"%' ";
}
String PageConstId = "LdapUserList";
String tableString = "<table instanceid=\"outterSysTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" >"+
"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"    sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
"			<head>";
tableString +="<col width=\"40%\"   text=\""+SystemEnv.getHtmlLabelName(33268,user.getLanguage())+"\" column=\"loginid\" orderkey=\"loginid\"/>"+
	"	<col width=\"30%\"   text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\"  />";
tableString +=	"</head><operates width=\"30%\">"+
   "	<operate href=\"javascript:openLadp();\" index=\"1\" text=\""+SystemEnv.getHtmlLabelName(216,user.getLanguage())+"\" />"+
   "</operates>";
tableString +="</table>";

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="LdapUserList.jsp" name="LdapUserListForm" id="LdapUserListForm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" name="namesimple" value="<%=lastname%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=SystemEnv.getHtmlLabelName(33267 ,user.getLanguage()) %></span>
</div>
	
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(33268,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(33268,user.getLanguage())%></wea:item>
			<wea:item><input  type="text" name="account" value='<%=account%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
			<wea:item><input   type="text" name="lastname" value='<%=lastname%>'></wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
					<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_submit"/> <!--270805  [80][90]LDAP集成-调整高级搜索中按钮样式，以保持统一-->
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	

<TABLE width="100%" id="datatable">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
           	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
</form>
</BODY></HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script>
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
});

function resetCondtion()
{
    $("#advancedSearchDiv").find(":text").val("");
}
function doRefresh()
{
	var lastname=$("input[name='namesimple']",parent.document).val();
	$("input[name='lastname']").val(lastname);
	window.location="/hrm/resource/LdapUserList.jsp?lastname="+lastname;
	//$("#LdapUserListForm").submit(); 
}
function openLadp(id){
	doOpen("/hrm/HrmDialogTab.jsp?_fromURL=LdapUserList&method=LdapUserMerge&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(33269,user.getLanguage())%>");
}
function delLine(id){//弹出框调用，用于删除已经合并的行
	$("#datatable input[id='checkboxId="+id+"']").closest("tr").remove();
}

var dWidth = 500;
var dHeight = 300;
function doOpen(url,title,_dWidth,_dHeight){
	if(typeof dialog  == 'undefined' || dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width =  _dWidth || 500;
	dialog.Height =  _dHeight || 300;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}
</script>
