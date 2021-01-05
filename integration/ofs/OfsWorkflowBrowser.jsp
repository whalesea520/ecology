<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.ofs.bean.OfsWorkflow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="OfsSysInfoService" class="weaver.ofs.service.OfsSysInfoService" scope="page" />
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
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh();,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

String sysid = Util.null2String(request.getParameter("sysid"));
String workflowname = Util.null2String(request.getParameter("workflowname"));
String receivewfdata = Util.null2String(request.getParameter("receivewfdata"));

String sqlwhere = " where cancel = 0 ";
if(!"".equals(sysid)){
    sqlwhere+=" and sysid ='"+sysid+"'";
}
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

//out.print("select "+backfields+" "+fromSql+" "+sqlwhere);
String tableString = "<table instanceid=\"ofs_workflowTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
				" <checkboxpopedom    popedompara=\"column:workflowid\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"sysid,workflowid\"  sqlprimarykey=\"workflowid\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
				"       <head>"+
				"           <col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"\"  column=\"workflowname\" orderkey=\"workflowid\" />"+
				"           <col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(31694,user.getLanguage())+"\"  column=\"sysid\" orderkey=\"sysid\" transmethod=\"weaver.ofs.util.OfsDataParse.getOfsInfoName\"/>"+
				"           <col width=\"30%\" text=\""+SystemEnv.getHtmlLabelNames("18526,18015",user.getLanguage())+"\"  column=\"receivewfdata\" orderkey=\"receivewfdata\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.ofs.util.OfsDataParse.getOpenName\"/>"+
				"       </head>"+
 				"</table>";
 
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="OfsWorkflowBrowser.jsp" method="post" name="frm" id="frm" >
<input type=hidden name=sysid id=sysid value="<%=sysid %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doRefresh()"/>
<%--			<input type="text" class="searchInput" name="name"  value="<%=workflowname%>"/>--%>
			<!-- 高级搜索-->
<%--			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;--%>
			 
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<div class="zDialog_div_content">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></wea:item>
			<wea:item><input type="text" id="workflowname" name="workflowname" value='<%=workflowname%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("18526,18015",user.getLanguage())%></wea:item>
			<wea:item>
			<% //System.out.println("receivewfdata="+receivewfdata);%>
				<select id="receivewfdata" style='width:120px!important;' name="receivewfdata" >
				  <option value="" <%if(receivewfdata.equals("")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option><!-- 全部-->
				  <option value="1" <%if(receivewfdata.equals("1")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><!-- 是-->
				  <option value="0" <%if(receivewfdata.equals("0")) out.print("selected"); %>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><!-- 否-->
				</select>
		</wea:item>
		</wea:group>
	
		<wea:group context='<%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%>' >
			<wea:item attributes="{'isTableList':'true'}">
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="true" mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" class="zd_btn_cancle" onclick="doSubmit();" style="width: 50px!important;">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" class="zd_btn_cancle" onclick="submitClear();" style="width: 50px!important;">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="closeDialog();" style="width: 50px!important;">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</form>
</BODY>
</HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
var dialog = window.parent.parent.getDialog(parent);
function closeDialog(){
	if(dialog){
		dialog.close();
	}
}
function submitClear(){
	var returnjson = {id:"",name:""};
	returnValue(returnjson);
}

jQuery(document).ready(function () {
 
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
});
function returnjson(){
	var ids = _xtable_CheckedCheckboxId();
	var names = "";
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	var ids2 = ids.split(",");
	for(var i=0;i<ids2.length;i++){
		names += ","+jQuery("input[checkboxId='"+ids2[i]+"']").closest('tr').find('td:eq(1)').html();
	}
	if(names != "") names = names.substring(1);
	return {id:ids,name:names};
}
function doSubmit(){
	returnValue(returnjson());
}
function returnValue(returnjson){
	if(dialog){
		try{
		    dialog.callback(returnjson);
		}catch(e){}
		try{
		   dialog.close(returnjson);
		}catch(e){}
	}else{ 
		window.parent.parent.returnValue  = returnjson;
		window.parent.parent.close();
	}
}
function doRefresh(){
	frm.submit();
	//window.location = "/integration/ofs/OfsWorkflowBrowser.jsp?workflowname="+workflowname;
}
</script>
