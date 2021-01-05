
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.User"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<% 
if(!HrmUserVarify.checkUserRight("intergration:automaticsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<html>
<head>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
</head>
<%
String needDoEditDetailById = Util.null2String(request.getParameter("needDoEditDetailById"));
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33720,user.getLanguage());
String needfav ="1";
String needhelp ="";
String typename = Util.null2String(request.getParameter("typename"));
String backto = Util.null2String(request.getParameter("backto"));
if(!"".equals(backto))
	typename = backto;
String deteteviewid = Util.null2String(request.getParameter("deteteviewid"));
List idlist = Util.TokenizerString(deteteviewid,",");
if(null!=idlist&&idlist.size()>0)
{
	for(int i = 0;i<idlist.size();i++)
	{
		String tempid = Util.null2String((String)idlist.get(i));
		if(!"".equals(tempid))
		{
			RecordSet.executeSql("delete from outerdatawfset where id="+tempid);
    		RecordSet.executeSql("delete from outerdatawfsetdetail where mainid="+tempid);
		}
	}
}
String setname = Util.null2String(request.getParameter("setname"));
String namesimple = Util.null2String(request.getParameter("namesimple"));
String workflowname = Util.null2String(request.getParameter("workflowname"));
String sqlwhere = "where a.workflowid=b.id ";
if(!"".equals(typename))
	sqlwhere += " and a.typename like '%"+typename+"%'";
if(!"".equals(setname))
	sqlwhere += " and a.setname like '%"+setname+"%'";
if(!"".equals(namesimple))
	sqlwhere += " and a.setname like '%"+namesimple+"%'";
String tableString="";
if(!"".equals(workflowname))
{	
	sqlwhere+=" and b.workflowname like '%"+workflowname+"%'";
}
String backfields=" a.*,b.workflowname " ;
String urlType="10";
//String PageConstId = "AutomaticSetting_gxh";
String fromSql=" outerdatawfset a,workflow_base b "; 
tableString =  " <table instanceid=\"ListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_AUTOMATICWF_AUTOMATICSETTING,user.getUID())+"\" >";
tableString += " <checkboxpopedom popedompara=\"column:a.id\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
		 " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"a.id\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
         "       <head>"+
         "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(195 ,user.getLanguage())+"\" column=\"setname\" orderkey=\"setname\" transmethod=\"weaver.general.SplitPageTransmethod.getIntegrationCenterEdit\" otherpara=\"column:id\" target=\"_self\" />"+
		 "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(2079 ,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\"/>"+
         "       </head>"+
         "<operates width=\"20%\">"+
		 " <popedom transmethod=\"weaver.general.SplitPageTransmethod.getOpratePopedom\" otherpara=\"2\" ></popedom> "+
		 "     <operate href=\"javascript:doEditById()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
		 "     <operate href=\"javascript:doDeleteById()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+       
		 "</operates>"+
         " </table>";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="automaticsetting.jsp">
<input type="hidden" id="deteteviewid" name="deteteviewid" value="">
<input name="typename" value="<%=typename %>" type="hidden" />
<input name="backto" value="<%=typename %>" type="hidden" />
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_AUTOMATICWF_AUTOMATICSETTING%>"/>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top" onclick="del()"/>
			
			<input type="text" class="searchInput" name="namesimple" value="<%=setname%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=SystemEnv.getHtmlLabelName(32366,user.getLanguage()) %></span> <!-- 流程触发集成列表 -->
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
<wea:layout type="4col">
	<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	  <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	  <wea:item><input  type="text" name="setname" value='<%=setname%>'></wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></wea:item>
	  <wea:item><input   type="text" name="workflowname" value='<%=workflowname%>'></wea:item>
    </wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_submit" id="zd_btn_submit"/><!--270806   [80][90]流程触发集成-调整高级搜索中按钮样式，以保持统一-->
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="zd_btn_cancle" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</div>

<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_AUTOMATICWF_AUTOMATICSETTING %>"/>
           	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
</form>
</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
	if(""!="<%=needDoEditDetailById%>"){
		doEditDetailById('<%=needDoEditDetailById%>',1);
	}
});
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

function doRefresh()
{
	//document.frmmain.action = "/workflow/automaticwf/automaticsetting.jsp?backto=<%=typename%>&typename=<%=typename%>";
	//document.frmmain.submit();
	var setname=$("input[name='namesimple']",parent.document).val();
	$("input[name='setname']").val(setname);
	window.location="/workflow/automaticwf/automaticsetting.jsp?backto=<%=typename%>&typename=<%=typename%>&setname="+setname;
}
function setdetail()
{
	document.location = "/workflow/automaticwf/automaticperiodsetting.jsp";
}
function add()
{
	var url = "/workflow/automaticwf/automaticsettingTab.jsp?isdialog=1&_fromURL=1&backto=<%=typename%>&typename=<%=typename%>";
	var title = "<%=SystemEnv.getHtmlLabelNames("365,33720",user.getLanguage())%>";
	openDialog(url,title);
}
function doEditById(id)
{
	if(id=="") return ;
	var url = "/workflow/automaticwf/automaticsettingTab.jsp?isdialog=1&_fromURL=2&backto=<%=typename%>&typename=<%=typename%>&viewid="+id;
	var title = "<%=SystemEnv.getHtmlLabelNames("93,33720",user.getLanguage())%>";
	openDialog(url,title);
}
function doEditDetailById(id,tabid)
{
	if(id=="") return ;
	var url = "/workflow/automaticwf/automaticsettingTab.jsp?isdialog=1&_fromURL=2&backto=<%=typename%>&typename=<%=typename%>&viewid="+id+"&tabid="+tabid;
	var title = "<%=SystemEnv.getHtmlLabelNames("93,33720",user.getLanguage())%>";
	openDialog(url,title);
}
function resetCondtion()
{
	frmmain.setname.value = "";
	frmmain.workflowname.value = "";
	frmmain.namesimple.value = "";
}

function doDeleteById(id)
{
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.frmmain.action = "/workflow/automaticwf/automaticsetting.jsp";
		document.frmmain.deteteviewid.value = id;
		document.frmmain.submit();
	}, function () {}, 320, 90,true);	
}
function del()
{
	var ids = "";
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	//alert("ids : "+ids);
	if(ids=="")
   	{
   		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return ;
   	}
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.frmmain.action = "/workflow/automaticwf/automaticsetting.jsp";
		document.frmmain.deteteviewid.value = ids;
		document.frmmain.submit();
	}, function () {}, 320, 90,true);		
}
</script>
