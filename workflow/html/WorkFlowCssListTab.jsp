<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="cssFileManager" class="weaver.workflow.html.CssFileManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
</HEAD>
<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = "CSS"+SystemEnv.getHtmlLabelName(633,user.getLanguage());
String needfav ="1";
String needhelp ="";

String cssname = Util.null2String(request.getParameter("cssname"));
int csstype = Util.getIntValue(request.getParameter("csstype"));
String sqlwhere = "";

String backFields = "id, cssname, type";
String sqlFrom = "workflow_crmcssfile";
String orderBy = "id";
String sqlWhere = " 1=1 ";
if(!cssname.equals("")) {
	sqlWhere += " and cssname like '%"+cssname+"%' ";
}
if(csstype > 0){
	sqlWhere += " and type="+csstype+" ";
}
String opttype = Util.null2String(request.getParameter("opttype"));
if("delete".equals(opttype)){
	String multicssid = Util.null2String(request.getParameter("multicssid"));
	int retInt = cssFileManager.deleteCssFiles(multicssid);
	if(retInt == 1){
%>
	<script language="javascript">
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20461,user.getLanguage())%>");
	</script>
<%
	
	}
}

String colString = "";
colString +="<col width=\"50%\" orderkey=\"cssname\" text=\"CSS"+SystemEnv.getHtmlLabelName(17517,user.getLanguage())+"\" column=\"cssname\" otherpara=\"column:type+column:id\" transmethod=\"weaver.workflow.html.CssFileManager.getCssName4Link\" />";
colString +="<col width=\"45%\" orderkey=\"type\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"type\"  otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.html.CssFileManager.getTypeStr\"/>";
String tableString="<table  pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_HTML_WORKFLOWCSSLISTTAB,user.getUID())+"\" tabletype=\"checkbox\">";
		tableString+="<checkboxpopedom popedompara=\"column:id+column:type\" showmethod=\"weaver.workflow.html.CssFileManager.getCanDeleteCheckBox\" />";
		tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"Desc\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlisdistinct=\"false\" />";
		tableString+="<head>"+colString+"</head>";
		tableString+="<operates>";
		tableString+="<popedom column=\"cssname\"  otherpara=\"column:type+column:id\" otherpara2=\"column:id+column:type\" transmethod=\"weaver.workflow.html.CssFileManager.getCanDelEditList\"></popedom> ";
        tableString+="<operate href=\"/workflow/html/WorkFlowCssEdit.jsp\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" linkvaluecolumn=\"id\" linkkey=\"id\" target=\"_parent\" index=\"0\"/>";
		tableString+="<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>";
		tableString+="</operates>";		
		tableString+="</table>";

%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(82, user.getLanguage())+",javascript:onCreate(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<TABLE class=Shadow>
			<tr>
			<td valign="top">
			<form id="frmmain" name="frmmain" action="WorkFlowCssListTab.jsp" method="post">
			<input type="hidden" id="multicssid" name="multicssid" value="">
			<input type="hidden" id="opttype" name="opttype" value="">
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_HTML_WORKFLOWCSSLISTTAB %>"/>
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					</td>
					<td class="rightSearchSpan" style="text-align:right; width:500px!important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%>" class="e8_btn_top" onclick="onCreate()"/>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="onDelete()"/>
						<input type="text" class="searchInput" name="flowTitle" value="<%=cssname%>"/>
						&nbsp;&nbsp;&nbsp;
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		
		<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv">	
<wea:layout type="fourCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
    	<wea:item>CSS<%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%></wea:item>
    	<wea:item><input type="text" class="inputstyle" id="cssname" name="cssname" size="40" value='<%=cssname%>'></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
	    <wea:item>
			<select id="csstype" name="csstype">
				<option value="0"></option>
				<option value="1" <%if(csstype==1){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(28120,user.getLanguage())%></option>
				<option value="2" <%if(csstype==2){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(28119,user.getLanguage())%></option>
				<option value="3" <%if(csstype==3){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(28121,user.getLanguage())%></option>
			</select>
	    </wea:item>
    </wea:group>
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>"/>
    		<input class="e8_btn_cancel" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
		</form>
			<TABLE width="100%" cellspacing=0>
			<tr>
				<td valign="top" style="padding: 0px;">
					<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
				</td>
			</tr>
			</table>
			</td>
			</tr>
			</TABLE>
</body>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});
function newDialog(){
	var diag_vote = new Dialog();
	diag_vote.Width = 400;
	diag_vote.Height = 200;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(124848,user.getLanguage())%>";
	diag_vote.URL = "";
	diag_vote.show();
}
		
function onDel(id){
	document.getElementById("multicssid").value = id+",";
	if(document.getElementById("multicssid").value==null || document.getElementById("multicssid").value==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>");
		return;
	}
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			document.getElementById("opttype").value = "delete";
			window.location.href="/workflow/html/WorkFlowCssListTab.jsp?opttype=delete&multicssid="+id+",";
			}, function () {}, 320, 90,true);	
}	

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']").val();
	$("input[name='cssname']").val(typename);
	window.location="/workflow/html/WorkFlowCssListTab.jsp?cssname="+typename;
}	
</script>
</html>
<script language="javascript">
function onSearch(){
	document.getElementById("opttype").value = "search";
	frmmain.submit();
}
function onCreate(){
	parent.location.href = "/workflow/html/WorkFlowCssEdit.jsp?opttype=add";
}
function onDelete(){
	var typeids = "";
	$("input[name='chkInTableTag']").each(function(){
	if($(this).attr("checked"))			
		typeids = typeids +$(this).attr("checkboxId")+",";
	});
	document.getElementById("multicssid").value = typeids;
	if(document.getElementById("multicssid").value==null || document.getElementById("multicssid").value==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24244,user.getLanguage())%>");
		return;
	}
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			document.getElementById("opttype").value = "delete";
			window.location.href="/workflow/html/WorkFlowCssListTab.jsp?opttype=delete&multicssid="+typeids;
			}, function () {}, 320, 90,true);
}
</script>
