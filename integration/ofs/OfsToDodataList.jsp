<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.ofs.bean.OfsWorkflow"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="OfsManager" class="weaver.ofs.manager.OfsManager" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
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
</head>
<%
if(!HrmUserVarify.checkUserRight("ofs:ofssetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31694,user.getLanguage());
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
String requestname = Util.null2String(request.getParameter("requestname"));
if(!"".equals(backto))
	typename = backto;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:doRefresh(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("ofs:ofssetting", user)){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(31691,user.getLanguage())+",javascript:add(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDelete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showAllLog();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
}

//String name = Util.null2String(request.getParameter("name"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
List wfids = Util.TokenizerString(workflowid,",");
String workflowname = "";
for(int i=0;i<wfids.size();i++){
    OfsWorkflow ofswf = OfsManager.getOfsWorkflowOneBean(Util.getIntValue((String)wfids.get(i)));
    workflowname += ","+ofswf.getWorkflowname();
}
workflowname = !workflowname.equals("") ? workflowname.substring(1) : "";

String isremark = Util.null2String(request.getParameter("isremark"));
String viewtype = Util.null2String(request.getParameter("viewtype"));
String creatorid = Util.null2String(request.getParameter("creatorid"));
String userid = Util.null2String(request.getParameter("userid"));

String createdatefromdate = Util.null2String(request.getParameter("createdatefromdate"));
String createdatetodate = Util.null2String(request.getParameter("createdatetodate"));
String receivedatefromdate = Util.null2String(request.getParameter("receivedatefromdate"));
String receivedateodate = Util.null2String(request.getParameter("receivedateodate"));

String sqlwhere = "where 1=1 ";
String tableString="";

if(!"".equals(workflowid)){	
	sqlwhere+=" and workflowid in("+workflowid+")";
}
if(!"".equals(isremark)){	
	sqlwhere+=" and isremark = '"+isremark+"'";
}
if(!"".equals(viewtype)){	
	sqlwhere+=" and viewtype = '"+viewtype+"'";
}
if(StringUtils.isNotBlank(requestname)){
	sqlwhere += "  and requestname like '%"+requestname+"%'";
}
if(StringUtils.isNotBlank(creatorid)){
	sqlwhere += "  and creatorid = '"+creatorid+"'";
}
if(StringUtils.isNotBlank(userid)){
	sqlwhere += "  and userid = '"+userid+"'";
}
if(!createdatefromdate.equals("")&&createdatefromdate!=null){
	sqlwhere += " AND createdate >= '" + createdatefromdate + "' ";
}
if(!createdatetodate.equals("")&&createdatetodate!=null){
	sqlwhere += " AND createdate <= '" + createdatetodate + "' ";
}
if(!receivedatefromdate.equals("")&&receivedatefromdate!=null){
	sqlwhere += " AND receivedate >= '" + receivedatefromdate + "' ";
}
if(!receivedateodate.equals("")&&receivedateodate!=null){
	sqlwhere += " AND receivedate <= '" + receivedateodate + "' ";
}
//out.println(sqlwhere);
String backfields=" * " ;
String perpage="10";
String PageConstId = "Ofs_todo_data";
String fromSql=" Ofs_todo_data "; 
 tableString = "<table instanceid=\"Ofs_todo_dataTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\" >"+
				" <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
				"       <head>"+
				"           <col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(31694,user.getLanguage())+"\"  column=\"sysid\" orderkey=\"sysid\" transmethod=\"weaver.ofs.util.OfsDataParse.getOfsInfoName\"/>"+
				"           <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"\"  column=\"workflowname\" orderkey=\"workflowname\" />"+
				"           <col width=\"*%\" text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\"  column=\"requestname\" orderkey=\"requestname\" otherpara=\"column:id\"  transmethod=\"weaver.ofs.util.OfsDataParse.getRequestnameLink\"/>"+
				"           <col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(126645,user.getLanguage())+"\"   column=\"isremark\" orderkey=\"isremark\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.ofs.util.OfsDataParse.getIsremark\"/>"+
				"           <col width=\"6%\" text=\""+SystemEnv.getHtmlLabelNames("367,602",user.getLanguage())+"\"  column=\"viewtype\" orderkey=\"viewtype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.ofs.util.OfsDataParse.getViewType\"/>"+
				"           <col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\"   column=\"Creatorid\" orderkey=\"Creatorid\" transmethod=\"weaver.splitepage.transform.SptmForPlanMode.getResourceName\" />"+
				"           <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\"  column=\"createdate\"  otherpara=\"column:createtime\" orderkey=\"createdate, createtime \"  transmethod=\"weaver.splitepage.transform.SptmForCrm.getTime\"/>"+
				"           <col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(896,user.getLanguage())+"\"  column=\"userid\" orderkey=\"userid\" transmethod=\"weaver.splitepage.transform.SptmForPlanMode.getResourceName\" />"+
				"           <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(18002,user.getLanguage())+"\"  column=\"receivedate\" otherpara=\"column:receivetime\" orderkey=\"receivedate, receivetime \"  transmethod=\"weaver.splitepage.transform.SptmForCrm.getTime\"/>"+
				"       </head>"+
		        "<operates width=\"20%\">"+
				" <popedom transmethod=\"weaver.general.SplitPageTransmethod.getOpratePopedom\" otherpara=\"2\" ></popedom> "+
				"     <operate href=\"javascript:doViewById()\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"     <operate href=\"javascript:doDeleteById()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+       
				"</operates>";
 tableString +="</table>";
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="OfsToDodataList.jsp" method="post" name="datalist" id="datalist" >
<input type="hidden" name="typename" value="<%=typename%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doDelete()"/>
			<input type="text" class="searchInput" name="name"  value="<%=requestname%>"/>
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
			<wea:item><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType='0' name='workflowid' browserValue='<%=workflowid%>'
					browserOnClick='' browserUrl='/integration/ofs/OfsInfoWorkflowTab.jsp?urlType=4'
					hasInput='true'  isSingle='false' hasBrowser = 'true' isMustInput='1'  width='200px' 
					completeUrl="" linkUrl="" 
					browserSpanValue='<%=workflowname%>'></brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
			<wea:item><input   type="text" name="requestname" value='<%=requestname%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(126645,user.getLanguage())%></wea:item>
			<wea:item>
				<select id="isremark" style='width:120px!important;' name="isremark" >
				  <option value="" <%if(isremark.equals("")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="0" <%if(isremark.equals("0")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%></option><!-- 待办-->
				  <option value="2" <%if(isremark.equals("2")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(24627,user.getLanguage())%></option><!-- 已办-->
				  <option value="4" <%if(isremark.equals("4")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(22487,user.getLanguage())%></option><!-- 办结-->
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("367,602",user.getLanguage())%></wea:item>
			<wea:item>
				<select id="viewtype" style='width:120px!important;' name="viewtype" >
				  <option value="" <%if(viewtype.equals("")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="0" <%if(viewtype.equals("0")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(18007,user.getLanguage())%></option><!-- 未查看-->
				  <option value="1" <%if(viewtype.equals("1")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(18006,user.getLanguage())%></option><!-- 已查看-->
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType='0' name='creatorid' browserValue='<%=creatorid%>'
					browserOnClick='' browserUrl='/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp'
					hasInput='true'  isSingle='true' hasBrowser = 'true' isMustInput='1'  width='200px' linkUrl='#'
					completeUrl="/data.jsp"
					browserSpanValue='<%=ResourceComInfo.getLastname(creatorid) %>'></brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
			<wea:item>
					<BUTTON class=Calendar type="button" id=selectcreatedatefromdate onclick="getDate('createdatefromdatespan','createdatefromdate');"></BUTTON>
					<SPAN id=createdatefromdatespan ><%=createdatefromdate%></SPAN>－
					<BUTTON class=Calendar type="button" id=selectcreatedatetodate onclick="getDate('createdatetodatespan','createdatetodate');"></BUTTON>
					<SPAN id=createdatetodatespan ><%=createdatetodate%></SPAN>
					<input type="hidden" id=createdatefromdate name="createdatefromdate" value="<%=createdatefromdate%>">
					<input type="hidden" id=createdatetodate name="createdatetodate" value="<%=createdatetodate%>">
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(896,user.getLanguage())%></wea:item>
			<wea:item>
					<brow:browser viewType='0' name='userid' browserValue='<%=userid%>'
						browserOnClick='' browserUrl='/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp'
						hasInput='true'  isSingle='true' hasBrowser = 'true' isMustInput='1'  width='200px' linkUrl='#'
						completeUrl="/data.jsp"
						browserSpanValue='<%=ResourceComInfo.getLastname(userid) %>'></brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(17994,user.getLanguage())%></wea:item>
			<wea:item>
			    	<BUTTON class=Calendar type="button" id=selectreceivedatefromdate onclick="getDate('receivedatefromdatespan','receivedatefromdate');"></BUTTON>
					<SPAN id=receivedatefromdatespan ><%=receivedatefromdate%></SPAN>－
					<BUTTON class=Calendar type="button" id=selectreceivedateodate onclick="getDate('receivedateodatespan','receivedateodate');"></BUTTON>
					<SPAN id=receivedateodatespan ><%=receivedateodate%></SPAN>
					<input type="hidden" id=receivedatefromdate name="receivedatefromdate" value="<%=receivedatefromdate%>">
					<input type="hidden" id=receivedateodate name="receivedateodate" value="<%=receivedateodate%>">
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
/*
 * QC:270812  [80][90]统一待办中心集成-流程数据-高级搜索中点击【重置】，应该只重置查询条件的内容，而不会刷新同步日志列表
 * resetCondtion在init_wev8.js(中有已经写好的公用方法)
 *这个自定义方法写的有问题，具体问题原因不清楚，会造成页面展现框上多出两个选择空白框，按照QC269817的方式修改会有一个选择空白框
 * 
function resetCondtion(){
	$("#datalist input[type=text]").val('');
	 //解绑，绑定
	$("#isremark").val('');
 	$("#isremark").selectbox("detach");
	__jNiceNamespace__.beautySelect("#isremark");
	 //解绑，绑定
	$("#viewtype").val('');
 	$("#viewtype").selectbox("detach");
	__jNiceNamespace__.beautySelect("#viewtype");
	
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	
	//清空日期
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
	
	
	jQuery("#createdatefromdate").val("");
	jQuery("#createdatetodate").val("");
	jQuery("#createdatefromdatespan").html("");
	jQuery("#createdatetodatespan").html("");
	
	jQuery("#receivedatefromdate").val("");
	jQuery("#receivedateodate").val("");
	jQuery("#receivedatefromdatespan").html("");
	jQuery("#receivedateodatespan").html("");
}
 */
function doRefresh(){
	var requestname=$("input[name='name']",parent.document).val();
	$("input[name='requestname']").val(requestname);
	//window.location = "/integration/ofs/OfsToDodataList.jsp?requestname="+requestname;
	datalist.submit();
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
		self.location.href="/integration/ofs/OfsToDodataOperation.jsp?backto=<%=typename%>&operation=delete&id="+ids;
	}, function () {}, 320, 90);	
}
function doDeleteById(id){
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		self.location.href="/integration/ofs/OfsToDodataOperation.jsp?backto=<%=typename%>&operation=delete&id="+id;
	}, function () {}, 320, 90);	
}
function doViewById(id){
	if(id=="") return ;
	var url = "/integration/ofs/OfsInfoWorkflowTab.jsp?urlType=3&isdialog=1&backto=<%=typename%>&id="+encodeURI(encodeURI(id));
	var title = "<%=SystemEnv.getHtmlLabelNames("367,126871",user.getLanguage()) %>";//编辑归档流程设置
	openDialog(url,title);
}

function doLog(id){
				doOpen("/systeminfo/SysMaintenanceLog.jsp?isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=158 and relatedid=")%>&relatedid="+id,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
function showAllLog(){
				var _sqlwhere = "<%=rs.getDBType().equals("db2")?"int(operateitem)":"operateitem"%>";
				var url = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=<%=xssUtil.put("where operateitem=168")%>";
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
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>