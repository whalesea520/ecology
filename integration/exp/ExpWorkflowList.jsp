<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="workTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />


</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String typename = Util.null2String(request.getParameter("typename"));
String backto = Util.null2String(request.getParameter("backto"));
String operation = Util.null2String(request.getParameter("operation"));
String id = Util.null2String(request.getParameter("id"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
if(!"".equals(backto))
	typename = backto;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:doRefresh(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83276,user.getLanguage())+",javascript:add(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDelete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showAllLog();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
}

//String name = Util.null2String(request.getParameter("name"));
String workflowname = Util.null2String(request.getParameter("workflowname"));
String ProName = Util.null2String(request.getParameter("ProName"));
String proType = Util.null2String(request.getParameter("proType"));

String workflowtype = Util.null2String(request.getParameter("workflowtype"));
String sqlwhere = "where 1=1 ";
String tableString="";

if(!"".equals(workflowname)){	
	sqlwhere+= " and workflowid in (select id from workflow_base where workflowname like '%"+workflowname+"%')";
	//sqlwhere+=" and workflowname like '%"+workflowname+"%'";
}
if(!"".equals(workflowtype)){	
	sqlwhere+=" and workflowtype = '"+workflowtype+"'";
}
if(StringUtils.isNotBlank(workflowid)){
	sqlwhere += "  and workflowid = '"+workflowid+"' ";
}
if(StringUtils.isNotBlank(ProName)){
	sqlwhere += "  and expid in (select id from exp_ProList where ProName like '%"+ProName+"%' ) ";
}
if(StringUtils.isNotBlank(proType)){
	sqlwhere += "  and expid in (select id from exp_ProList where proType='"+proType+"' )  ";
}
String backfields=" * " ;
String perpage="10";
String PageConstId = "ExpWorkflowList";
String fromSql=" exp_workflowDetail "; 
 tableString = "<table instanceid=\"archivingLogTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\" >"+
				" <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
				"       <head>"+
				"           <col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(34067,user.getLanguage())+"\"  column=\"id\" orderkey=\"workflowname\" transmethod=\"weaver.expdoc.ExpUtil.getProNameLink\" />"+
				"           <col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"\"  column=\"workflowid\" orderkey=\"workflowtype\" transmethod=\"weaver.expdoc.ExpUtil.getWorkflowTypeName\" />"+
				"           <col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(83270,user.getLanguage())+"\"  column=\"expid\" orderkey=\"expid\" transmethod=\"weaver.expdoc.ExpUtil.getExpProName\" />"+
				"           <col width=\"*%\" text=\""+SystemEnv.getHtmlLabelName(83272,user.getLanguage())+"\"  column=\"expid\" transmethod=\"weaver.expdoc.ExpUtil.getExpProTypeName\" />"+
				"       </head>"+
		        "<operates width=\"20%\">"+
				" <popedom transmethod=\"weaver.general.SplitPageTransmethod.getOpratePopedom\" otherpara=\"3\" ></popedom> "+
				"     <operate href=\"javascript:doEditById()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"     <operate href=\"javascript:doDeleteById()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+       
				"     <operate href=\"javascript:doLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"1\"/>"+       
				"</operates>";
 tableString +="</table>";
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="/integration/exp/ExpWorkflowList.jsp" method="post" name="datalist" id="datalist" >
<input type="hidden" name="typename" value="<%=typename%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(83276 ,user.getLanguage()) %>" class="e8_btn_top" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doDelete()"/>
			<input type="text" class="searchInput" name="name"  value="<%=workflowname%>"/>
			&nbsp;&nbsp;&nbsp;
			<!-- 高级搜索-->
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			 
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>


<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(34067,user.getLanguage())%></wea:item>
			<wea:item><input   type="text" name="workflowname" value='<%=workflowname%>'></wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></wea:item><!-- 流程类型 -->
			<wea:item>
						<brow:browser viewType="0" name="workflowtype" browserValue='<%= ""+workflowtype %>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
										hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
										completeUrl="/data.jsp?type=worktypeBrowser"
										browserSpanValue='<%=workTypeComInfo.getWorkTypename(workflowtype)%>'>
							</brow:browser>
			</wea:item>
			
		    <wea:item><%=SystemEnv.getHtmlLabelName(83270,user.getLanguage())%></wea:item><!-- 归档方案 -->
			<wea:item><input   type="text" name="ProName" value='<%=ProName%>'></wea:item>
			 <wea:item><%=SystemEnv.getHtmlLabelName(83272,user.getLanguage())%></wea:item><!-- 归档方案类型 -->
			  <wea:item>
			 <select id="proType" style='width:120px!important;' name="proType" >
			  <option value=""></option>
			  <option value="0" <%if(proType.equals("0")) out.print("selected");%>>XML</option>
			   <option value="1"  <%if(proType.equals("1")) out.print("selected");%>><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%></option><!-- 数据库 -->
			</select>
			</wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_submit" id="e8_btn_submit"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
           	<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="true" mode="run" />
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
	if(dialog)
		dialog.close();
}
//新建子目录
function openDialog(url,title){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = 750;
	dialog.Height = 596;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
jQuery(document).ready(function () {
 
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
	
	var operation="<%=operation%>";
	if(operation=="addAndNext"){
	 edit();
	}
});
function resetCondtion(){
	$("#.advancedSearchDiv input[type=text]").val('');
	
	$("#proType").val('');
	 //解绑，绑定
 	$("#proType").selectbox("detach");
	__jNiceNamespace__.beautySelect("#proType");
	
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	
	//清空日期
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
}
function doRefresh(){
	var workflowname=$("input[name='name']",parent.document).val();
	$("input[name='workflowname']").val(workflowname);
	window.location = "/integration/exp/ExpWorkflowList.jsp?workflowname="+workflowname;
}
function add(){
	var url = "/integration/exp/ExpWorkflowDetailTab.jsp?urlType=1&typename=<%=typename%>&isdialog=1";
	var title = "<%=SystemEnv.getHtmlLabelName(83276,user.getLanguage()) %>";//注册流程
	openDialog(url,title);
}
function edit(){
	var url = "/integration/exp/ExpWorkflowDetailTab.jsp?urlType=2&typename=<%=typename%>&isdialog=1&id="+encodeURI(encodeURI("<%=id%>"));
	var title = "<%=SystemEnv.getHtmlLabelNames("93,33925,68",user.getLanguage()) %>";//编辑归档流程设置
	openDialog(url,title);
}
function doDelete(ids){
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	if(ids=="")	{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return ;
	}
	//alert("ids : "+ids);
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		self.location.href="/integration/exp/ExpWorkflowDetailOperation.jsp?backto=<%=typename%>&operation=delete&id="+ids;
	}, function () {}, 320, 90);	
}
function doDeleteById(id){
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		self.location.href="/integration/exp/ExpWorkflowDetailOperation.jsp?backto=<%=typename%>&operation=delete&id="+id;
	}, function () {}, 320, 90);	
}
function doEditById(id){
	if(id=="") return ;
	var url = "/integration/exp/ExpWorkflowDetailTab.jsp?urlType=2&isdialog=1&backto=<%=typename%>&id="+encodeURI(encodeURI(id));
	var title = "<%=SystemEnv.getHtmlLabelNames("93,33925,68",user.getLanguage()) %>";//编辑归档流程设置
	openDialog(url,title);
}

function doLog(id){
				doOpen("/systeminfo/SysMaintenanceLog.jsp?isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=158 and relatedid=")%>&relatedid="+id,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
function showAllLog(){
				var url = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=<%=xssUtil.put("where "+(rs.getDBType().equals("db2")?"int(operateitem)":"operateitem")+"=158")%>";
				doOpen(url,"<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
			
	var dialog = null;
	var dWidth = 500;
	var dHeight = 300;
function doOpen(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			
</script>
