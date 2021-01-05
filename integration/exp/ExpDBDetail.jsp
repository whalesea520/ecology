<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
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
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span style="display:none" id="innerCorner" title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
String backto = Util.null2String(request.getParameter("backto"));
if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(125788,user.getLanguage())+",javascript:add(),_self} " ;//注册归档数据库
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDelete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showAllLog();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

String sysid = Util.null2String(request.getParameter("id"));
String name = Util.null2String(request.getParameter("name"));

String sqlwhere = "where 1=1 ";
String tableString="";
if(!"".equals(sysid)){	
	sqlwhere+=" and id="+sysid;
}
if(!"".equals(name)){	
	sqlwhere+=" and name like '%"+name+"%'";
}
String backfields=" * " ;
String perpage="10";
String PageConstId = "ExpDBDetail";
String fromSql=" exp_dbdetail "; 
tableString =  " <table instanceid=\"ListTable\" tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\" >";
tableString += " <checkboxpopedom    popedompara=\"column:id+2\" showmethod=\"weaver.expdoc.ExpUtil.getShowmethod\"  />"+
		 " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
         "       <head>"+
         "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" transmethod=\"weaver.expdoc.ExpUtil.getNameLink\"  otherpara=\"column:id\" />"+
		 "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(18076 ,user.getLanguage())+"\" column=\"resoure\" orderkey=\"resoure\" />"+
         "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+"\" column=\"maintable\" orderkey=\"maintable\" />"+
		 "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(19325 ,user.getLanguage())+"\" column=\"detailtable\" orderkey=\"detailtable\" />"+
         "       </head>"+
         "<operates width=\"20%\">"+
		 " <popedom column=\"id\" otherpara=\"2\" transmethod=\"weaver.expdoc.ExpUtil.getPopedomValue\"  ></popedom> "+
		 "     <operate href=\"javascript:doEditById()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
		 "     <operate href=\"javascript:doDeleteById()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+       
		 "     <operate href=\"javascript:doLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>"+
		 "</operates>"+
         " </table>";
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="ExpDBDetail.jsp" method="post" name="datalist" id="datalist" >

<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
			<wea:item><input  type="text" name="sysid" value='<%=sysid%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item><input   type="text" name="name" value='<%=name%>'></wea:item>
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
});
function resetCondtion(){
	datalist.sysid.value = "";
	datalist.name.value = "";
	datalist.namesimple.value = "";
}
function doRefresh(){
	$("#datalist").submit(); 
}
function add(){
	var url = "/integration/exp/ExpDBDetailTab.jsp?urlType=1&backto=<%=backto%>&isdialog=1";
	var title = "<%=SystemEnv.getHtmlLabelName(125788,user.getLanguage())%>";//注册归档数据库
	openDialog(url,title);
}
function doDelete(ids){
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	if(ids=="")
	{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return ;
	}
	//alert("ids : "+ids);
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		self.location.href="/integration/exp/ExpDBDetailOperation.jsp?backto=<%=backto%>&operation=delete&id="+ids;
	}, function () {}, 320, 90);	
}
function doDeleteById(id)
{
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		self.location.href="/integration/exp/ExpDBDetailOperation.jsp?backto=<%=backto%>&operation=delete&id="+id;
	}, function () {}, 320, 90);	
}
function doEditById(id){
	if(id=="") return ;
	var url = "/integration/exp/ExpDBDetailTab.jsp?urlType=2&isdialog=1&backto=<%=backto%>&id="+encodeURI(encodeURI(id));
	var title = "<%=SystemEnv.getHtmlLabelName(125789,user.getLanguage())%>";//编辑归档数据库
	openDialog(url,title);
}
function doLog(id){
				doOpen("/systeminfo/SysMaintenanceLog.jsp?isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=161 and relatedid=")%>&relatedid="+id,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
function showAllLog(){
				var _sqlwhere = "<%=rs.getDBType().equals("db2")?"int(operateitem)":"operateitem"%>";
				var url = "/systeminfo/SysMaintenanceLog.jsp?sqlwhere=<%=xssUtil.put("where "+(rs.getDBType().equals("db2")?"int(operateitem)":"operateitem")+"=161")%>";
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
