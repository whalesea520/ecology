<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</HEAD>

<%
if(!HrmUserVarify.checkUserRight("DocChange:Setting", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22876,user.getLanguage());
String needfav ="1";
String needhelp ="";

String workflowname = Util.null2String(request.getParameter("workflowname"));
String sqlwhere = "where d.workflowid=b.id ";
String tableString="";
if(!"".equals(workflowname))
{
	sqlwhere+=" and b.workflowname like '%"+workflowname+"%'";
}
String backfields=" d.*,b.workflowtype,b.workflowname " ;
String perpage="10";
String fromSql=" DocChangeWorkflow d,workflow_base b "; 
tableString =  " <table instanceid=\"ListTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >";
tableString += " <checkboxpopedom    popedompara=\"column:d.id\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
         "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"d.id\"  sqlprimarykey=\"d.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
         "       <head>"+
         "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(1339 ,user.getLanguage())+"\" column=\"createdate\" transmethod=\"weaver.general.SplitPageTransmethod.getDataAndTime\" otherpara=\"column:createtime\"/>"+
		 "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(15433 ,user.getLanguage())+"\" column=\"workflowtype\" transmethod=\"weaver.workflow.workflow.WorkTypeComInfo.getWorkTypename\" />"+
		 "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(2079 ,user.getLanguage())+"\" column=\"workflowname\"   />"+
		 "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(23025 ,user.getLanguage())+"\" column=\"id\" transmethod=\"weaver.general.SplitPageTransmethod.getDocChangEditStr\" otherpara=\"column:workflowid\" />"+
         "       </head>"+
         "<operates width=\"20%\">"+
		 " <popedom transmethod=\"weaver.general.SplitPageTransmethod.getOpratePopedom\" otherpara=\"2\" ></popedom> "+
		 "     <operate href=\"javascript:doDeleteById()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+       
		 "</operates>"+
         " </table>";
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:add(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<LINK href="../css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<FORM name="frmmain" action="/docs/change/DocChangeOpterator.jsp" method="post" id="datalist">
<input name="method" value="del" type="hidden" />
<input name="ids" value="" type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" class="e8_btn_top" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top" onclick="del()"/>
			
			<input type="text" class="searchInput" name="workflowname" value="<%=workflowname %>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<TABLE width="100%">
    <tr>
        <td valign="top">  
           	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>

</FORM>
</BODY>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});
</script>
</html>
<script>
function doRefresh()
{
	document.frmmain.action = "/docs/change/DocChangeSettingTab.jsp";
	$("#datalist").submit(); 
}
//编辑字段
function editField(wfid,cid) {
	location.href = 'DocChangeField.jsp?wfid='+wfid+'&docchangeid='+cid;
}
//字段对应
function assField(wfid,cid) {
	location.href = 'WorkflowFieldConfig.jsp?wfid='+wfid+'&isView=true';
}

function add() {
	location.href = '/docs/change/WorkflowSelect.jsp';
}
function del(){
	var ids = "";
	$("input[name='chkInTableTag']").each(function(){
	if($(this).attr("checked"))			
		ids = ids +$(this).attr("checkboxId")+",";
	});
	if(ids=="") return ;
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			window.location="/docs/change/DocChangeOpterator.jsp?method=del&ids="+ids;
	}, function () {}, 320, 90,false);
}

function onDel(id){
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
						window.location="/docs/change/DocChangeOpterator.jsp?method=del&ids="+id+",";
	}, function () {}, 320, 90,false);		
}
function doDeleteById(id)
{
	if(id=="") return ;
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		window.location="/docs/change/DocChangeOpterator.jsp?method=del&ids="+id+",";
	}, function () {}, 320, 90,false);	
}
</script>
