<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ExpWorkflowManager" class="weaver.expdoc.ExpWorkflowManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />	
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

</head>
<BODY>
<% 
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(83255,user.getLanguage());//归档日志
String needfav ="1";
String needhelp ="";
boolean isoracle = (rs.getDBType()).equals("oracle") ;
String isDialog = "1";
%>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(125748,user.getLanguage())+",javascript:reExpAll(),_self} " ;//重新归档
	RCMenuHeight += RCMenuHeightStep ;
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(),_self} " ;//搜索 qc:281264 去掉多余搜索功能按钮
	//RCMenuHeight += RCMenuHeightStep ;//搜索 qc:281264 去掉多余搜索功能按钮
}
String id = Util.null2String(request.getParameter("id")); //注册流程明细id
String requestname = Util.null2String(request.getParameter("requestname"));
String status = Util.null2String(request.getParameter("status"));
String exptype = Util.null2String(request.getParameter("exptype"));
String operation = Util.null2String(request.getParameter("operation"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
if(!id.equals("")){
	rs.executeSql("select * from exp_workflowDetail where id="+id);
	if(rs.next()){
		workflowid=Util.null2String(rs.getString("workflowid"));
	}
}
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String dateselect =Util.fromScreen(request.getParameter("dateselect"),user.getLanguage());
if(!dateselect.equals("") && !dateselect.equals("0")&& !dateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(dateselect,"0");
	todate = TimeUtil.getDateByOption(dateselect,"1");
}
if(dateselect.equals("") || dateselect.equals("0")){
	fromdate = "";
	todate = "";
}

if("exp".equals(operation)){
	String requestidstr = Util.null2String(request.getParameter("ids"));
	ExpWorkflowManager.doSendDoc(requestidstr, user.getUID()+"",id);
}
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
if(perpage<=1 )	perpage=10;
String PageConstId = "ExpWorkflowLogList";
String sqlWhere = " where  t1.currentnodetype = '3' and exists (select 1 from exp_workflowDetail where exp_workflowDetail.workflowid=t1.workflowid) ";
String backfields = " t1.requestid as requestid,t1.requestname as requestname,t1.workflowid as  workflowid,t2.status as status,t2.reason as reason,t2.type as type,t2.senddate as senddate,t2.sendtime";
String fromSql  = " from workflow_requestbase t1 LEFT JOIN exp_logdetail t2 on t1.requestid=t2.requestid  ";
if(StringUtils.isNotBlank(requestname)){
	sqlWhere += "  and t1.requestname like '%"+requestname+"%' ";
}
if(StringUtils.isNotBlank(status)){
	if(!"2".equals(status)){
		sqlWhere += "  and t2.status = '"+status+"' ";
	}else{
		sqlWhere += "  and ( t2.status is null or t2.status='') ";
	}
}
if(StringUtils.isNotBlank(exptype)){
	sqlWhere += "  and t2.type = '"+exptype+"' ";
}
if(StringUtils.isNotBlank(workflowid)){
	sqlWhere += "  and t1.workflowid = '"+workflowid+"' ";
}
if(!fromdate.equals("")&&fromdate!=null){
	sqlWhere += " AND t2.senddate >= '" + fromdate + "' ";
}
if(!todate.equals("")&&todate!=null){
	sqlWhere += " AND t2.senddate <= '" + todate + "' ";
}

//流程标题 所属路径 归档状态 失败原因 归档类型 归档时间 重新归档
String tableString = "<table instanceid=\"archivingLogTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\" >"+
					" <checkboxpopedom    popedompara=\"column:requestid\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
					" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\"t1.requestid\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
					"       <head>"+
					"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(26876,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" transmethod=\"\"  otherpara=\"column:requestid\" href=\"/workflow/request/ViewRequest.jsp\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" />"+
					"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(125749,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\"/>"+
					"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15112,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.expdoc.ExpUtil.getFtpLogStatus\"/>"+
					"           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(27041,user.getLanguage())+"\" column=\"reason\" orderkey=\"reason\" />"+
					"           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(125750,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" transmethod=\"weaver.expdoc.ExpUtil.getFtpLogType\"/>"+
					"           <col width=\"*\"  text=\""+SystemEnv.getHtmlLabelName(125751,user.getLanguage())+"\" column=\"senddate\"  otherpara=\"column:sendtime\" orderkey=\"senddate, sendtime \"  transmethod=\"weaver.splitepage.transform.SptmForCrm.getTime\"/>"+ 
					"       </head>"+
				   	"<operates width=\"20%\">"+
				  	"	<operate href=\"javascript:reExpById();\" index=\"1\" text=\""+SystemEnv.getHtmlLabelName(125748,user.getLanguage())+"\" />"+
				    "</operates>";
tableString +="</table>";

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="ExpWorkflowLogList.jsp" name="archivingLogForm" id="archivingLogForm">
<input class=inputstyle type=hidden name=operation id=operation>
<input class=inputstyle type=hidden name=id id=id value = <%=id%>>
<input class=inputstyle type=hidden name=ids id=ids>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(125748,user.getLanguage())%>" class="e8_btn_top" onclick="reExpAll()"/><!-- 重新归档 -->
			<input type="text" class="searchInput" name="lastname" value="<%=requestname%>"/>
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
	<wea:layout type="fourCol">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(26876,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(26876,user.getLanguage())%></wea:item>
			<wea:item><input  type="text" name=requestname value='<%=requestname%>'></wea:item>
		
			<wea:item><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></wea:item>
			<wea:item>
			<select style='width:120px!important;' id="status1" name="status">
				<option value="" <%if(status.equals("")) out.println("selected"); %>><%= SystemEnv.getHtmlLabelName(82857,user.getLanguage())%></option><!-- 全部 -->
				<option value="2" <%if(status.equals("2")) out.println("selected"); %>><%= SystemEnv.getHtmlLabelName(17999,user.getLanguage())%></option><!-- 未归档 -->
				<option value="1" <%if(status.equals("1")) out.println("selected"); %>><%= SystemEnv.getHtmlLabelName(18800,user.getLanguage())%></option><!-- 已归档 -->
				<option value="0" <%if(status.equals("0")) out.println("selected"); %>><%= SystemEnv.getHtmlLabelName(125752,user.getLanguage())%></option><!-- 归档失败 -->
			</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(125750,user.getLanguage())%></wea:item><!-- 归档类型 -->
			<wea:item>
			<select style='width:120px!important;' id="exptype" name="exptype">
				<option value="" <%if(exptype.equals("")) out.println("selected"); %>></option>
				<option value="0" <%if(exptype.equals("0")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(81855,user.getLanguage())%></option><!-- 自动 -->
				<option value="1" <%if(exptype.equals("1")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(125582,user.getLanguage())%></option><!-- 手动 -->
			</select>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(3000,user.getLanguage())%></wea:item><!-- 归档日期 -->
						  <wea:item>
						    	<span>
									<select name="dateselect" id="dateselect" onchange="changeDate(this,'spanfromdate');">
										<option value="0" <%=dateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
										<option value="1" <%=dateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
										<option value="2" <%=dateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
										<option value="3" <%=dateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
										<option value="4" <%=dateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
										<option value="5" <%=dateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
										<option value="6" <%=dateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
									</select>
								</span>
								<span id=spanfromdate style="<%=dateselect.equals("6")?"":"display:none;" %>">
									<BUTTON class=Calendar type="button" id=selectfromdate onclick="getDate('fromdatespan','fromdate');"></BUTTON>
									<SPAN id=fromdatespan ><%=fromdate%></SPAN>－
									<BUTTON class=Calendar type="button" id=selecttodate onclick="getDate('todatespan','todate');"></BUTTON>
									<SPAN id=todatespan ><%=todate%></SPAN>
								</span>
								<input type="hidden" id=fromdate name="fromdate" value="<%=fromdate%>">
								<input type="hidden" id=todate name="todate" value="<%=todate%>">
						</wea:item>
			
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
					<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_submit"/>
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

<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>

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
function resetCondtion(){
	$("#.advancedSearchDiv input[type=text]").val('');
	$("#exptype").val('');
	 //解绑，绑定
 	$("#exptype").selectbox("detach");
	__jNiceNamespace__.beautySelect("#exptype");
		//281287[80][90]流程归档集成-归档日志以及归档日志Tab页面中，高级搜索中点击【重置】，应该只重置查询条件的内容，而不会刷新同步日志列表
	$("#status1").val('');
	 	$("#status1").selectbox("detach");
	__jNiceNamespace__.beautySelect("#status1");
	$("#dateselect").val('0');
	 	$("#dateselect").selectbox("detach");
	__jNiceNamespace__.beautySelect("#dateselect");
	
	
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	
	//清空日期
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery("#fromdate").val("");
	jQuery("#todate").val("");
	jQuery("#fromdatespan").html("");
	jQuery("#todatespan").html("");
	jQuery("#spanfromdate").css("display","none");
}
function doRefresh(){
	var requestname=$("input[name='lastname']",parent.document).val();
	$("input[name='requestname']").val(requestname);
	window.location = "/integration/exp/ExpWorkflowLogList.jsp?requestname="+requestname+"&id=<%=id%>";
	}
function reExpAll(ids){	
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	if(ids=="")	{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125753,user.getLanguage())%>");//请选择需要归档的流程
		return ;
	}
	//是否批量归档
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(125754,user.getLanguage())%>", function (){
		 $("#operation").val('exp');
		 $("#ids").val(ids);
		 $("#archivingLogForm").submit(); 
		//self.location.href="/interface/outter/OutterSysOperation1.jsp?operation=delete&sysid="+ids;
	}, function () {}, 320, 90);	
}
function reExpById(id){
	 $("#operation").val('exp');
	 $("#ids").val(id);
	 $("#archivingLogForm").submit();
	//doOpen("/hrm/HrmDialogTab.jsp?_fromURL=archivingLog.jsp&method=LdapUserMerge&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(33269,user.getLanguage())%>");
}

function changeDate(obj,formatedate){
	var dateval = jQuery(obj).val();
	if(dateval == "6"){
		jQuery("#fromdate").val("");
		jQuery("#todate").val("");
		jQuery("#fromdatespan").html("");
		jQuery("#todatespan").html("");
		jQuery("#spanfromdate").css("display","");
	}else{
		jQuery("#spanfromdate").css("display","none");
	}
}

function onBack(){
	parentWin.closeDialog();
}
</script>
