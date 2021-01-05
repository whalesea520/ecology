<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.ofs.bean.OfsWorkflow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
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

String syscode = Util.null2String(request.getParameter("syscode"));
String sysnames = Util.null2String(request.getParameter("sysnames"));

String sqlwhere = " where cancel = 0 ";
if(!"".equals(syscode)){	
	sqlwhere+=" and syscode like '%"+syscode+"%'";
}
if(!"".equals(sysnames)){	
	sqlwhere+=" and (sysshortname like '%"+sysnames+"%' or sysfullname like '%"+sysnames+"%')";
}
String backfields=" * " ;
String perpage="10";
String PageConstId = "Ofs_sysinfo";
String fromSql=" Ofs_sysinfo "; 

//out.print("sysnames:"+sysnames+"   select "+backfields+" "+fromSql+" "+sqlwhere);
String tableString = "<table instanceid=\"ofs_workflowTable\" tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
				" <checkboxpopedom    popedompara=\"column:workflowid\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"sysid\"  sqlprimarykey=\"sysid\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
				"       <head>"+
				"           <col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\"  column=\"syscode\" orderkey=\"syscode\" />"+
				"           <col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(399,user.getLanguage())+"\"  column=\"sysshortname\" orderkey=\"sysshortname\" />"+
				"           <col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(15767,user.getLanguage())+"\"  column=\"sysfullname\" orderkey=\"sysfullname\" />"+
				"       </head>"+
 				"</table>";
 
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="OfsInfoDetailBrowser.jsp" method="post" name="frm" id="frm" >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="e8_btn_top" onclick="doRefresh()"/>
<%--			<input type="text" class="searchInput" name="name"  value="<%=sysnames%>"/>--%>
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
			<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item><!-- 标识 -->
			<wea:item><input type="text" id="syscode" name="syscode" value='<%=syscode%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item><!-- 简称或全称 -->
			<wea:item><input type="text" id="sysnames" name="sysnames" value='<%=sysnames%>'></wea:item>
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
		names += ","+jQuery("input[checkboxId='"+ids2[i]+"']").closest('tr').find('td:eq(2)').html();
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
