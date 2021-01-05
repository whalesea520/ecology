<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.ofs.bean.OfsSysInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OfsSysInfoService" class="weaver.ofs.service.OfsSysInfoService" scope="page" />

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
if(!HrmUserVarify.checkUserRight("ofs:ofssetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(31694,user.getLanguage());
String isDialog = Util.null2String(request.getParameter("isdialog"));//返回类型
isDialog = "1";
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

//编辑流程类型为关闭
OfsSysInfo  ofs = OfsSysInfoService.getOneBean(Util.getIntValue(sysid));
String edittype = ofs.getEditwftype();

if(!"".equals(backto))
	typename = backto;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197 ,user.getLanguage())+",javascript:doRefresh(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("ofs:ofssetting", user)){
	if("1".equals(edittype)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(31691,user.getLanguage())+",javascript:add(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDelete(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showAllLog();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
}

String workflowname = Util.null2String(request.getParameter("workflowname"));
String receivewfdata = Util.null2String(request.getParameter("receivewfdata"));
String sqlwhere = "where cancel = 0 and sysid = "+sysid;
String tableString="";

if(!"".equals(workflowname)){	
	sqlwhere+=" and workflowname like '%"+workflowname+"%'";
}
if(!"".equals(receivewfdata)){	
	sqlwhere+=" and receivewfdata ="+receivewfdata;
}

String backfields=" * " ;
String perpage="10";
String PageConstId = "ofs_workflow";
String fromSql=" ofs_workflow ";

 tableString = "<table instanceid=\"ofs_workflowTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\" >"+
				" <checkboxpopedom    popedompara=\"column:workflowid\" showmethod=\"weaver.general.SplitPageTransmethod.getWFCheckBox\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"workflowid\"  sqlprimarykey=\"workflowid\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
				"       <head>"+
				"           <col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"\"  column=\"workflowname\" orderkey=\"workflowid\" transmethod=\"weaver.ofs.util.OfsDataParse.getOfsInfoEdit\" otherpara=\"column:workflowid\"/>"+
				"           <col width=\"50%\" text=\""+SystemEnv.getHtmlLabelNames("18526,18015",user.getLanguage())+"\"  column=\"receivewfdata\" orderkey=\"receivewfdata\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.ofs.util.OfsDataParse.getOpenName\"/>"+
				"       </head>"+
		        "<operates width=\"20%\">"+
			 	"<popedom transmethod=\"weaver.general.SplitPageTransmethod.getWFOpratePopedom\" otherpara=\""+edittype+"\" ></popedom> "+
				"    <operate href=\"javascript:doEditById()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"    <operate href=\"javascript:doDeleteById()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+
				"    <operate href=\"javascript:doViewById()\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
 				"    <operate href=\"javascript:doLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"3\"/>"+       
				"</operates>";
 tableString +="</table>";
 
 
String relatedidsql = " relatedid='"+sysid+"'";
/**
rs.executeSql("select workflowid from ofs_workflow "+sqlwhere);
while(rs.next()){
    if(relatedidsql.equals("")){
        relatedidsql = "relatedid = "+rs.getString(1);
    }else{
        relatedidsql += " or relatedid="+rs.getString(1);
    }
}**/

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="OfsInfoWorkflowList.jsp" method="post" name="datalist" id="datalist" >
<input type="hidden" name="typename" value="<%=typename%>">
<input type="hidden" name="sysid" value="<%=sysid%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if("1".equals(edittype)){%>.
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31691 ,user.getLanguage()) %>" class="e8_btn_top" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doDelete()"/>
			<%}%>
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
			<wea:item><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></wea:item>
			<wea:item><input   type="text" name="workflowname" value='<%=workflowname%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("18526,18015",user.getLanguage())%></wea:item>
			<wea:item>
				<select id="receivewfdata" style='width:120px!important;' name="receivewfdata" >
				  <option value="" <%if(receivewfdata.equals("")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option><!-- 全部-->
				  <option value="1" <%if(receivewfdata.equals("1")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是-->
				  <option value="0" <%if(receivewfdata.equals("0")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否-->
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
        	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId%>"/>
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
	
	//$("#proType").val('');
 	//$("#proType").selectbox("detach");
	//__jNiceNamespace__.beautySelect("#proType");
	
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	
	//清空日期
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery("#receivewfdata").selectbox("reset");
}
function doRefresh(){
	var workflowname=$("input[name='name']",parent.document).val();
	$("input[name='workflowname']").val(workflowname);
	window.location = "/integration/ofs/OfsInfoWorkflowList.jsp?sysid=<%=sysid%>&workflowname="+workflowname;
}
function add(){
	var url = "/integration/ofs/OfsInfoWorkflowTab.jsp?urlType=1&typename=<%=typename%>&isdialog=1&id="+encodeURI(encodeURI("<%=sysid%>"));
	var title = "<%=SystemEnv.getHtmlLabelNames("31691,16579",user.getLanguage()) %>"; //"注册流程类型" 
	openDialog(url,title);
}
function edit(){
	var url = "/integration/ofs/OfsInfoWorkflowTab.jsp?urlType=2&typename=<%=typename%>&isdialog=1&id="+encodeURI(encodeURI("<%=sysid%>"));
	var title = "<%=SystemEnv.getHtmlLabelNames("26473,31694",user.getLanguage()) %>";//编辑归档流程设置
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
		self.location.href="/integration/ofs/OfsInfoWorkflowOperation.jsp?backto=<%=typename%>&operation=delete&sysid=<%=sysid%>&id="+ids;
	}, function () {}, 320, 90);	
}
function doDeleteById(id){
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		self.location.href="/integration/ofs/OfsInfoWorkflowOperation.jsp?backto=<%=typename%>&operation=delete&sysid=<%=sysid%>&id="+id;
	}, function () {}, 320, 90);	
}

function doEditById(id){
	if(<%=edittype.equals("0")%>){
		doViewById(id);
		return;
	}
	if(id=="") return ;
	var url = "/integration/ofs/OfsInfoWorkflowTab.jsp?edittype=<%=edittype%>&urlType=2&isdialog=1&backto=<%=typename%>&sysid=<%=sysid%>&id="+id;
	var title = "<%=SystemEnv.getHtmlLabelNames("93,16579",user.getLanguage()) %>";
	openDialog(url,title);
}

function doViewById(id){
	if(id=="") return ;
	var url = "/integration/ofs/OfsInfoWorkflowTab.jsp?edittype=0&urlType=2&isdialog=1&backto=<%=typename%>&sysid=<%=sysid%>&id="+id;
	var title = "<%=SystemEnv.getHtmlLabelNames("367,16579",user.getLanguage()) %>";
	openDialog(url,title);
}

function doLog(id){
				var url ="/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+escape("where operateitem=165 and operatedesc like '"+id+",%'");
				doOpen(url,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
function showAllLog(){
				var _sqlwhere = "<%=rs.getDBType().equals("db2")?"int(operateitem)":"operateitem"%>";
				var url = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where "+_sqlwhere+"=165 and (<%=relatedidsql%>)";
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