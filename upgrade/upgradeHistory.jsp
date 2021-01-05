
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.ldap.LdapUtil"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><head>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script>
function changeDate(obje,e){
    var typevalue=obje.value;
	if(obje.value==6){
	$("#"+e).css("display","");  
	}else{
	$("#"+e).css("display", "none"); 
	}
}

</script>
</head>
<BODY>


<% 


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33728,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(125595,user.getLanguage())+",javascript:exportExcel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

int lan = user.getLanguage();
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);

String content = Util.null2String(request.getParameter("content"));
String content1 = Util.null2String(request.getParameter("content1"));
String versionno = Util.null2String(request.getParameter("versionno"));
String operatedatefrom = Util.null2String(request.getParameter("operatedatefrom"));
String operatedateto = Util.null2String(request.getParameter("operatedateto"));
String operatedateselect = Util.null2String(request.getParameter("operatedateselect"));
rs.executeProc("HrmUserDefine_SelectByID",""+user.getUID());
if(rs.next()){
	perpage =Util.getIntValue(rs.getString(36),-1);
}
if(perpage<=1 )	perpage=10;

String backfields = " t1.* ";
String fromSql  = " from ecologyuplist t1 ";
String sqlWhere = " where t1.label is not null ";
if(!"".equals(content)) {
	sqlWhere = sqlWhere + " and content like '%"+content+"%'";
}
if(!"".equals(content1)) {
	sqlWhere = sqlWhere + " and content like '%"+content1+"%'";
}
if(!"".equals(versionno)) {
	sqlWhere = sqlWhere + " and versionNo like '%"+versionno+"%'";
}
if("0".equals(operatedateselect) || "".equals(operatedateselect)) {//全部
	
} else if("1".equals(operatedateselect)){//今天
	String date = TimeUtil.getDateByOption(""+operatedateselect,"0");
	sqlWhere = sqlWhere + " and operationdate like '%"+date+"%'";		
} else if("6".equals(operatedateselect)) {
	sqlWhere = sqlWhere + " and operationdate >= '"+operatedatefrom+"' and operationdate <= '"+operatedateto+"'";	
} else {
	operatedatefrom = TimeUtil.getDateByOption(""+operatedateselect,"0");
	operatedateto = TimeUtil.getDateByOption(""+operatedateselect,"1");
	sqlWhere = sqlWhere + " and operationdate >= '"+operatedatefrom+"' and operationdate <= '"+operatedateto+"'";	
}

String PageConstId = "upgradeList"; 
String tableString = "<table instanceid=\"designateTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID())+"\" >"+
"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"    sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
"			<head>";
tableString += "<col width=\"10%\"   text=\""+"ID"+"\" column=\"id\" orderkey=\"t1.id\"/>"+
    "	<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(25458,user.getLanguage())+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"label\" orderkey=\"t1.label\" />"+
	"	<col width=\"20%\"   text=\""+SystemEnv.getHtmlLabelName(125604,user.getLanguage())+"\" column=\"versionNo\" orderkey=\"t1.versionNo\" />"+
	"	<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(17530,user.getLanguage())+SystemEnv.getHtmlLabelName(33368,user.getLanguage())+"\" column=\"content\" transmethod=\"weaver.system.SysUpgradeCominfo.getUpgradeMessage\" otherpara=\"column:id+1+"+lan+"\" target=\"_self\" />"+
	"	<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(724,user.getLanguage())+"\" column=\"configcontent\" transmethod=\"weaver.system.SysUpgradeCominfo.getUpgradeMessage\" otherpara=\"column:id+2+"+lan+"\" target=\"_self\" />"+	
	"	<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(21663,user.getLanguage())+"\" column=\"operationdate\" orderkey=\"operationdate\" />"+
	"	<col width=\"10%\"   text=\""+SystemEnv.getHtmlLabelName(15502,user.getLanguage())+"\" column=\"operationtime\" />";
tableString +="</head></table>";

String sql = "select * from ecologyuplist t1 "+sqlWhere+" order by id";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<iframe name="excels" id="excels" src="" style="display:none" ></iframe> 
<form action="upgradeHistory.jsp" name="upgradeHistory" id="upgradeHistory">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" id="content1" name="content1" value="<%=content %>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch" onclick="clicksearch()"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
		</td>
	</tr>
</table>
<div id="tabDiv" >
	 <span style="font-size:14px;font-weight:bold;"></span> 
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context="<%= SystemEnv.getHtmlLabelName(347,user.getLanguage())%>">
			<wea:item><%= SystemEnv.getHtmlLabelNames("25458,21663",user.getLanguage())%></wea:item>
			<wea:item>
			  		    	<span style='float:left;display:inline-block;'>
                        	<select name="operatedateselect" id="operatedateselect" onchange="changeDate(this,'operatedate');" class="inputstyle" size=1>
                        		<option value="0" <% if(operatedateselect.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage()) %></option>
                        		<option value="1" <% if(operatedateselect.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage()) %></option>
                        		<option value="2" <% if(operatedateselect.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage()) %></option>
                        		<option value="3" <% if(operatedateselect.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage()) %></option>
                        		<option value="4" <% if(operatedateselect.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage()) %></option>
                        		<option value="5" <% if(operatedateselect.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage()) %></option>
                        		<option value="6" <% if(operatedateselect.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage()) %></option>
                        	</select>
                       		</span>
							<span style='float:left;margin-left: 10px;padding-top: 5px;'>
                          	<span id="operatedate" style="display:<%if(!operatedateselect.equals("6")) {%>none<%} %>">
							<button type="button" class="calendar" id="SelectDate" onclick="getDate('operatedatefromspan','operatedatefrom')"></button>&nbsp;
							<span id="operatedatefromspan"><%=operatedatefrom %></span>
							-&nbsp;&nbsp;<button type="button" class="calendar" id="SelectDate1" onclick="getDate('operatedatetospan','operatedateto')"></button>&nbsp;
							<span id="operatedatetospan"><%=operatedateto %></span>
							</span>
							<input type="hidden" name="operatedatefrom" value="<%=operatedatefrom %>">
							<input type="hidden" name="operatedateto" value="<%=operatedateto %>">
							
							</span>
			</wea:item>
			<wea:item><%= SystemEnv.getHtmlLabelName(125604,user.getLanguage())%></wea:item>
			<wea:item><input   type="text" name="versionno" value="<%=versionno %>"></wea:item>
			<wea:item><%= SystemEnv.getHtmlLabelNames("17530,33368",user.getLanguage())%></wea:item>
			<wea:item><input   type="text" name="content" value="<%=content %>"></wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
					<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="zd_btn_submit"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>	
<%
String maxlabel = ""+SystemEnv.getHtmlLabelName(83519 ,user.getLanguage());
String message = "";
int count = 0;
String continuously = "0";
String s = "select label from ecologyuplist order by label desc";
rs.execute(s);
if(rs.next()) {
	maxlabel = rs.getString("label");
	count = rs.getCounts();
	//判断升级是否连续
	if(count > 0) {
		int maxl = Integer.parseInt(maxlabel);
		if(maxl == count) {
			continuously = "1";
		}
	}
}
if(count > 0) {
	if("1".equals(continuously)) {
		message = "升级包编号连续，升级操作规范，请继续保持。";
	} else {
		message = "升级包编号不连续，升级过程可能存在问题，请联系供应商进行检查。";
	}
}

%>
<wea:layout type="1col">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
	<wea:item><span style="margin-right:30px;"><span style="font-weight:bold">当前系统已升级的最大序号：</span><span style="font-size:20px;color:#1C86EE;"><%=maxlabel %></span></span>
	
	<% if("1".equals(continuously)) {%>
	<span style="color:#C7C7C7;"><%=message %></span>
	<%} else { %>
	<span style="color:#CD4F39;font-weight:bold"><%=message %></span>
	<%} %>
	</wea:item>
	</wea:group>
</wea:layout>
<TABLE width="100%" id="datatable">
 <tr>
     <td valign="top">  
     	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
        	<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
        </td>
    </tr>
</TABLE>	
</form>
</BODY></HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script>
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
});

function clicksearch() {

	$("#content1").val("");
}
function resetCondtion()
{
	$("#upgradeHistory input[type=text]").val('');
	$("input[name='operatedatefrom']").val("");
	$("input[name='operatedateto']").val("");
	$("#operatedatefromspan").html("");
	$("#operatedatetospan").html("");
	try {
		$('#operatedateselect').selectbox("reset");
	} catch(e){
		$("select[name='operatedateselect']").val("0");
		$("select[name='operatedateselect']").text("<%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>");
		$('#operatedateselect').trigger("change");
		
		
		
	}

	
}
function doRefresh()
{
	$("#upgradeHistory").submit(); 
}

function delLine(id){//弹出框调用，用于删除已经合并的行
	//$("#datatable input[id='checkboxId="+id+"']").closest("tr").remove();
}
var flage;
function openMessage(id,flage) {
	var v = flage;
	if(v=="1") {
		doOpen("/upgrade/detail.jsp?message=content&id="+id,"<%=SystemEnv.getHtmlLabelName(17530,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(33368,user.getLanguage())%>");
	} else {
		doOpen("/upgrade/detail.jsp?message=config&id="+id,"<%=SystemEnv.getHtmlLabelName(724,user.getLanguage())%>");
	}
	
}

var dWidth = 600;
var dHeight = 500;
function doOpen(url,title){
	if(typeof dialog  == 'undefined' || dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width =  dWidth || 500;
	dialog.Height =  dWidth || 300;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	
	dialog.show();
}

function exportExcel() {
	document.getElementById("excels").src = "/upgrade/upgradeHistoryExcel.jsp?sql=<%=xssUtil.put(sql)%>";
}

</script>
