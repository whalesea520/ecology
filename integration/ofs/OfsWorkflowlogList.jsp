<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.ofs.bean.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<jsp:useBean id="OfsManager" class="weaver.ofs.manager.OfsManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
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
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("ofs:ofssetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31694,user.getLanguage());
String isDialog = Util.null2String(request.getParameter("isdialog"));//返回类型
isDialog ="1";
//System.out.println("isDialog:"+isDialog);
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String typename = Util.null2String(request.getParameter("typename"));
String backto = Util.null2String(request.getParameter("backto"));
String operation = Util.null2String(request.getParameter("operation"));
String sysid = Util.null2String(request.getParameter("sysid"));
String id = Util.null2String(request.getParameter("id"));
String requestname = Util.null2String(request.getParameter("requestname"));
if(!"".equals(backto))
	typename = backto;


//String name = Util.null2String(request.getParameter("name"));
String datatype = Util.null2String(request.getParameter("datatype"));
String opertype = Util.null2String(request.getParameter("opertype"));
String workflowname = Util.null2String(request.getParameter("workflowname"));
String isremark = Util.null2String(request.getParameter("isremark"));
String viewtype = Util.null2String(request.getParameter("viewtype"));
String creatorid = Util.null2String(request.getParameter("creatorid"));
String userid = Util.null2String(request.getParameter("userid"));

String operatedatefromdate = Util.null2String(request.getParameter("operatedatefromdate"));
String operatedatetodate = Util.null2String(request.getParameter("operatedatetodate"));

String sysshortnames = "";
List sysidList = Util.TokenizerString(sysid,",");
for(int i=0;i<sysidList.size();i++){
    OfsSysInfo ofssyssnfo = OfsManager.getOfsSysInfoOneBean(Util.getIntValue((String)sysidList.get(i)));
    sysshortnames += ","+ofssyssnfo.getSysshortname();
}
if(!sysshortnames.equals("")) sysshortnames = sysshortnames.substring(1);

String sqlwhere = "where 1=1 ";
String tableString="";
if(!"".equals(sysid)){
    sqlwhere+=" and sysid in ("+sysid+")";
}
if(!"".equals(datatype)){
    sqlwhere+=" and datatype='"+datatype+"'";
}
if(!"".equals(opertype)){
    sqlwhere+=" and opertype='"+opertype+"'";
}
if(!"".equals(userid)){
    sqlwhere+=" and userid='"+userid+"'";
}
if(!operatedatefromdate.equals("")){
	sqlwhere += " AND operatedate >= '" + operatedatefromdate + "' ";
}
if(!operatedatetodate.equals("")){
	sqlwhere += " AND operatedate <= '" + operatedatetodate + "' ";
}
String backfields=" * " ;
String perpage="10";
String PageConstId = "Ofs_log";
String fromSql=" Ofs_log  "; 
//System.out.println("select "+backfields+" "+fromSql+" "+sqlwhere);
 tableString = "<table instanceid=\"Ofs_logTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\" >"+
//				" <checkboxpopedom    popedompara=\"column:logid\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"logid\"  sqlprimarykey=\"logid\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
				"       <head>"+
				"           <col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(31694,user.getLanguage())+"\"  column=\"sysid\" orderkey=\"sysid\" transmethod=\"weaver.ofs.util.OfsDataParse.getOfsInfoName\"/>"+
				"           <col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"\"  column=\"workflowname\" orderkey=\"workflowname\" />"+
				"           <col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(125929,user.getLanguage())+"\"  column=\"dataType\" otherpara=\""+user.getLanguage()+"\" orderkey=\"dataType\" transmethod=\"weaver.ofs.util.OfsDataParse.getDataType\"/>"+
				"           <col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(15503,user.getLanguage())+"\"   column=\"operType\" orderkey=\"operType\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.ofs.util.OfsDataParse.getOperType\" />"+
				"           <col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(81420,user.getLanguage())+"\"  column=\"operResult\" orderkey=\"operResult\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.ofs.util.OfsDataParse.getOperResult\"/>"+
				"           <col width=\"*%\" text=\""+SystemEnv.getHtmlLabelName(27041,user.getLanguage())+"\"   column=\"failRemark\" orderkey=\"failRemark\" />"+
				"           <col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\"  column=\"userid\" orderkey=\"userid\" transmethod=\"weaver.splitepage.transform.SptmForPlanMode.getResourceName\" />"+
				"           <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(15502,user.getLanguage())+"\"  column=\"operatedate\"  otherpara=\"column:operatetime\" orderkey=\"operatedate, operatetime \"  transmethod=\"weaver.splitepage.transform.SptmForCrm.getTime\"/>"+
				"           <col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(125930,user.getLanguage())+"\"  column=\"requestname\" orderkey=\"requestname\" otherpara=\"column:dataid\"  transmethod=\"weaver.ofs.util.OfsDataParse.getRequestnameLink\"/>"+
				"       </head>";
 tableString +="</table>";
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="OfsWorkflowlogList.jsp" method="post" name="datalist" id="datalist" >
<input type="hidden" name="typename" value="<%=typename%>">
<input type="hidden" name="sysid" value="<%=sysid%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
<!--  		<input type="text" class="searchInput" name="name"  value="<%=requestname%>"/>-->	
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
			<wea:item><%=SystemEnv.getHtmlLabelName(31694,user.getLanguage())%></wea:item><!-- 异构系统 -->
			<wea:item>
				<brow:browser viewType='0' name='sysid' browserValue='<%=sysid%>'
					browserOnClick='' browserUrl='/integration/ofs/OfsInfoDetailTab.jsp?urlType=3'
					hasInput='false'  isSingle='false' hasBrowser = 'true' isMustInput='1'  width='200px' 
					completeUrl="" linkUrl="" 
					browserSpanValue='<%=sysshortnames%>'></brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(125929,user.getLanguage())%></wea:item><!-- 数据类型 -->
			<wea:item>
				<select id="datatype" style='width:120px!important;' name="datatype" >
				  <option value="" <%if(datatype.equals("")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="OtherSys" <%if(datatype.equals("OtherSys")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(31694,user.getLanguage())%></option><!-- 异构系统-->
				  <option value="WfType" <%if(datatype.equals("WfType")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></option><!-- 流程类型-->
				  <option value="WfData" <%if(datatype.equals("WfData")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(126871,user.getLanguage())%></option><!-- 流程数据-->
				  <option value="SetParam" <%if(datatype.equals("SetParam")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(17632,user.getLanguage())%></option><!-- 参数设置-->
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></wea:item><!-- 操作类型 -->
			<wea:item>
				<select id="opertype" style='width:120px!important;' name="opertype" >
				  <option value="" <%if(opertype.equals("")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="AutoNew" <%if(opertype.equals("AutoNew")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelNames("81855,82",user.getLanguage())%></option><!-- 自动新建-->
				  <option value="New" <%if(opertype.equals("New")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></option><!-- 新建-->
				  <option value="AutoEdit" <%if(opertype.equals("AutoEdit")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(82604,user.getLanguage())%></option><!-- 自动更新-->
				  <option value="Edit" <%if(opertype.equals("Edit")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option><!-- 编辑-->
				  <option value="Del" <%if(opertype.equals("Del")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></option><!-- 删除-->
				  <option value="Check" <%if(opertype.equals("Check")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(22011,user.getLanguage())%></option><!-- 检测-->
				  <option value="Set" <%if(opertype.equals("Set")) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></option><!-- 设置-->
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></wea:item><!-- 操作人 -->
			<wea:item>
				<brow:browser viewType='0' name='userid' browserValue='<%=userid%>'
					browserOnClick='' browserUrl='/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp'
					hasInput='true'  isSingle='true' hasBrowser = 'true' isMustInput='1'  width='200px' 
					linkUrl='javascript:openhrm($id$)' completeUrl="/data.jsp"
					browserSpanValue='<%=ResourceComInfo.getLastname(userid) %>'></brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></wea:item><!-- 操作时间 -->
			<wea:item>
					<BUTTON class=Calendar type="button" id=selectoperatedatefromdate onclick="getDate('operatedatefromdatespan','operatedatefromdate');"></BUTTON>
					<SPAN id=operatedatefromdatespan ><%=operatedatefromdate%></SPAN>－
					<BUTTON class=Calendar type="button" id=selectoperatedatetodate onclick="getDate('operatedatetodatespan','operatedatetodate');"></BUTTON>
					<SPAN id=operatedatetodatespan ><%=operatedatetodate%></SPAN>
					<input type="hidden" id=operatedatefromdate name="operatedatefromdate" value="<%=operatedatefromdate%>">
					<input type="hidden" id=operatedatetodate name="operatedatetodate" value="<%=operatedatetodate%>">
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
	$(".advancedSearchDiv input[type=text]").val('');
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
	
	
	jQuery("#operatedatefromdate").val("");
	jQuery("#operatedatetodate").val("");
	jQuery("#operatedatefromdatespan").html("");
	jQuery("#operatedatetodatespan").html("");
	
	jQuery("#opertype").selectbox("reset");
	jQuery("#datatype").selectbox("reset");
}
function doRefresh(){
	var workflowname=$("input[name='name']",parent.document).val();
	$("input[name='workflowname']").val(workflowname);
	window.location = "/integration/ofs/OfsWorkflowlogList.jsp?workflowname="+workflowname;
}

function doViewById(id){
	if(id=="") return ;
	var url = "/integration/ofs/OfsToDodataView.jsp?urlType=2&isdialog=1&backto=<%=typename%>&id="+encodeURI(encodeURI(id));
	var title = "<%=SystemEnv.getHtmlLabelNames("367,126871",user.getLanguage()) %>";//编辑归档流程设置
	openDialog(url,title);
}

function doLog(id){
				doOpen("/systeminfo/SysMaintenanceLog.jsp?isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=158 and relatedid=")%>&relatedid="+id,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
function showAllLog(){
				var _sqlwhere = "<%=rs.getDBType().equals("db2")?"int(operateitem)":"operateitem"%>";
				var url = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where "+_sqlwhere+"=158";
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
function onBack(){
	parentWin.closeDialog();
}
			
</script>
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
<%}%>