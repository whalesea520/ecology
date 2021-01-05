<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:webserivcesetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33717,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String namesimple = Util.null2String(request.getParameter("namesimple"));
String customname = Util.null2String(request.getParameter("customname"));
String webserviceurl = Util.null2String(request.getParameter("webserviceurl"));

String sqlwhere = "where 1=1 ";
//if(!"".equals(namesimple))
//	sqlwhere += " and customname like '%"+namesimple+"%'";
if(!"".equals(customname))
	sqlwhere += " and customname like '%"+customname+"%'";
String tableString="";
if(!"".equals(webserviceurl))
{
	sqlwhere +=" and webserviceurl like '%"+webserviceurl+"%'";
}
String backfields=" *" ;
String perpage="10";
String sqlorderby = "customname";
String PageConstId = "WebserivcesettingList_gxh";
String fromSql=" wsregiste "; 
tableString =  " <table instanceid=\"ListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\" >";
tableString += " <checkboxpopedom popedompara=\"column:id\" showmethod=\"weaver.general.SplitPageTransmethod.getWebserviceCheckBox\" />"+
		 " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
         "       <head>"+
         "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(195 ,user.getLanguage())+"\" column=\"customname\" orderkey=\"customname\" transmethod=\"weaver.general.SplitPageTransmethod.getIntegrationCenterEdit\" otherpara=\"column:id\" target=\"_self\" />"+
		 "           <col width=\"60%\"  text=\"WEBSERVICE "+SystemEnv.getHtmlLabelName(110,user.getLanguage())+"\" column=\"webserviceurl\" orderkey=\"webserviceurl\" />"+
		 "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(125628 ,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.general.SplitPageTransmethod.getWebserviceReferenceInfo\" otherpara=\""+user.getLanguage()+"\"/>"+
		 "       </head>"+
		 "<operates width=\"20%\">"+
		 " <popedom transmethod=\"weaver.general.SplitPageTransmethod.getWebservicePopedom\" ></popedom> "+
		 "     <operate href=\"javascript:doEditById()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
		 "     <operate href=\"javascript:doDeleteById()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+       
		 "</operates>"+
         " </table>";
 if(HrmUserVarify.checkUserRight("intergration:webserivcesetting", user))
{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82 ,user.getLanguage())+",javascript:add(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91 ,user.getLanguage())+",javascript:del(),_self} " ;//删除
	RCMenuHeight += RCMenuHeightStep ;
}

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="/integration/webserivcesettingList.jsp" method="post" name="frmmain" id="frmmain">
<input name="id" value="" type="hidden" />
<input type="hidden" id="operator" name="operator" value="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:630px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %>" class="e8_btn_top" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="del()"/><!-- 删除 -->
			<input type="text" class="searchInput" name="namesimple" value="<%=customname%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename %></span> 
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		    <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		    <wea:item><input  type="text" name="customname" value='<%=customname%>'></wea:item>
		    <wea:item>WEBSERVICE <%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></wea:item>
		    <wea:item><input   type="text" name="webserviceurl" value='<%=webserviceurl%>'></wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_submit" id="zd_btn_submit"/><!--270803 [80][90]WebService注册-调整高级搜索中按钮样式，以保持统一-->
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="zd_btn_cancle" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
           	<wea:SplitPageTag isShowTopInfo="true" tableString='<%=tableString%>' mode="run" />
           	
        </td>
    </tr>
</TABLE>
</form>
</BODY>
</HTML>

<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
var dialog = null;
function closeDialog(){
	if(dialog){
		dialog.close();
	}
}

function openDialog(url,title){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = 750;
	dialog.Height = 596;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.maxiumnable=true;//允许最大化
	dialog.show();
}

function add()
{
	//document.location = "/integration/webserivcesetting.jsp";
	var url = "/integration/webserivcesettingTab.jsp?urlType=1&isdialog=1";
	var title = "<%=SystemEnv.getHtmlLabelNames("365,33717",user.getLanguage())%>";
	openDialog(url,title);
}
function doEditById(id)
{
	if(id=="") return ;
	var url = "/integration/webserivcesettingTab.jsp?urlType=2&isdialog=1&id="+encodeURI(encodeURI(id));
	var title = "<%=SystemEnv.getHtmlLabelNames("93,33717",user.getLanguage())%>";
	openDialog(url,title);
}
function resetCondtion()
{
	frmmain.customname.value = "";
	frmmain.webserviceurl.value = "";
	frmmain.namesimple.value = "";
}
function del()
{
	var ids = "";
	$("input[name='chkInTableTag']").each(function(){
	if($(this).attr("checked"))			
		ids += (ids=="")? $(this).attr("checkboxId"):(","+$(this).attr("checkboxId"));
	});
	if(ids=="")
   	{
   		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return ;
   	}
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.frmmain.action = "/integration/WSsettingOperation.jsp";
		document.frmmain.id.value = ids;
		document.frmmain.operator.value = "delete";
		document.frmmain.submit();
	}, function () {}, 320, 90);			
}

function doDeleteById(id)
{
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.frmmain.action = "/integration/WSsettingOperation.jsp";
		document.frmmain.id.value = id;
		document.frmmain.operator.value = "delete";
		document.frmmain.submit();
	}, function () {}, 320, 90);	
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
});
function doRefresh()
{
	//document.frmmain.action = "/integration/webserivcesettingList.jsp";
	//$("#frmmain").submit(); 
	var customname=$("input[name='namesimple']",parent.document).val();
	$("input[name='customname']").val(customname);
	window.location = "/integration/webserivcesettingList.jsp?customname="+customname;
}
</script>
