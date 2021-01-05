<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML>
<HEAD>
	<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
	<style>
	#loading{
	    position:absolute;
	    left:45%;
	    background:#ffffff;
	    top:40%;
	    padding:8px;
	    z-index:20001;
	    height:auto;
	    border:1px solid #ccc;
	}
	</style>
</head>
<%
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(24771,user.getLanguage());//"流程导入";24771
	String needfav = "1";
	String needhelp = "";
	
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	String importtype = Util.null2String(request.getParameter("importtype"));
	String type = Util.null2String(request.getParameter("type"));
	String checkresult = Util.null2String(request.getParameter("checkresult"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%		
	RCMenu += "{"+SystemEnv.getHtmlLabelName(25649,user.getLanguage())+",javascript:importwf(),_top}" ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33659,user.getLanguage()) %>"/>
</jsp:include>
<div id="loading">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
	<!-- 数据导入中，请稍等... -->
	<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(28210,user.getLanguage())%></span>
</div>
<div id="content">
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post enctype="multipart/form-data">
<%
	if(checkresult.equals("1")){//流程类型不相等
		out.println("<span><font color=red>"+SystemEnv.getHtmlLabelName(28211,user.getLanguage())+"</font></span>");
		out.println("<br/>");
	}else if(checkresult.equals("2")){//
		out.println("<span><font color=red>"+SystemEnv.getHtmlLabelName(28212,user.getLanguage())+"</font></span>");
		out.println("<br/>"); 
	}
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		    <input type="button" value="<%=SystemEnv.getHtmlLabelName(25649,user.getLanguage())%>" class="e8_btn_top" onclick="importwf();"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(24863,user.getLanguage())%></wea:item>
    	<wea:item>
			<select id="importtype" name="importtype" class="inputstyle" onchange="importTypeChange(this)" style="width: 150px;">
				<option value="0" <%if(importtype.equals("0")) out.println("selected");%>>
					<%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())%>
				</option>
				<option value="1" <%if(importtype.equals("1")) out.println("selected");%>>
					<%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%>
				</option>
			</select>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(25646,user.getLanguage())%></wea:item>
    	<wea:item>
			<select id="type" name="type" class="inputstyle" style="width:150px;">
				<option value="0" <%if(type.equals("0")) out.println("selected");%>>
					<%=SystemEnv.getHtmlLabelName(25647,user.getLanguage())%>
				</option>
				<option value="1" <%if(type.equals("1")) out.println("selected");%>>
					<%=SystemEnv.getHtmlLabelName(25648,user.getLanguage())%>
				</option>
			</select>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(33807,user.getLanguage())%></wea:item>
    	<wea:item attributes="{'id':'workflow_td'}">
  			<brow:browser name="workflowid" viewType="0" hasBrowser="true" hasAdd="false" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp" isMustInput="2" isSingle="true" hasInput="true"
 					completeUrl="/data.jsp?type=workflowBrowser" width="300px" browserValue='<%=workflowid%>' browserSpanValue='<%=WorkflowComInfo.getWorkflowname(workflowid) %>'/>    	
    	</wea:item>
    	<wea:item>XML<%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%></wea:item>
    	<wea:item>
			<input class=InputStyle  type=file size=40 name="filename" id="filename" onChange="checkinput('filename','filenamespan')">
			<span id="filenamespan"><img src="/images/BacoError_wev8.gif" align=absmiddle></span>     	
    	</wea:item>
    </wea:group>
    <wea:group attributes="{'itemAreaDisplay':'block'}" context='<%=SystemEnv.getHtmlLabelName(33803,user.getLanguage()) %>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(25650,user.getLanguage()) %></wea:item>
    </wea:group>
    <wea:group attributes="{'itemAreaDisplay':'block'}" context='<%=SystemEnv.getHtmlLabelName(33804,user.getLanguage()) %>'>
    	<wea:item>
			1、<!-- 系统一致性--><%=SystemEnv.getHtmlLabelName(25646,user.getLanguage())%>/<!--系统一致--><%=SystemEnv.getHtmlLabelName(25647,user.getLanguage())%>：
			<!-- 流程xml文件导出的系统与xml文件导入的系统完全一致(人员，组织结构，角色等一致)-->
			<%=SystemEnv.getHtmlLabelName(25651,user.getLanguage())%>
			<BR>
			2、<!-- 系统一致性--><%=SystemEnv.getHtmlLabelName(25646,user.getLanguage())%>/<!--系统不一致--><%=SystemEnv.getHtmlLabelName(25648,user.getLanguage())%>：
			<!--流程xml文件导出的系统与流程xml文件导入的系统可能不一致(人员，组织结构，角色等不一致)。不一致的情况下，流程操作者，出口条件,以及与其他模块相关功能(比如高级设置，联动设置等)将不会导入，需要重新设置-->
			<%=SystemEnv.getHtmlLabelName(25652,user.getLanguage())%>
			<BR>
			3、<!-- 导入类型--><%=SystemEnv.getHtmlLabelName(24863,user.getLanguage())%>/<!--新增--><%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())%>：
			<%=SystemEnv.getHtmlLabelName(28213,user.getLanguage())%>
			<BR>
			4、<!-- 导入类型--><%=SystemEnv.getHtmlLabelName(24863,user.getLanguage())%>/<!--更新--><%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%>：
			<%=SystemEnv.getHtmlLabelName(28214,user.getLanguage())%>
			<BR>
    	</wea:item>
    </wea:group>
</wea:layout>
</FORM>
</div>
</BODY>
	
<script type="text/javascript">
function importTypeChange(obj){
	if(obj.value=="1"){			//更新
		$("#type").selectbox("detach").val('0').selectbox("attach").selectbox("disable");
		$("#workflow_td").parent().show().next().show();		
	}else{						//新增，需要把流程类型的数据清空
		$("#type").selectbox("enable")
	    $("#workflow_td").parent().hide().next().hide();
	    $("#workflowid").val("");
		$("#workflowidspan").html("");
	}
}

jQuery(document).ready(function(){
	importTypeChange($GetEle("importtype"));
	jQuery("#loading").hide();
})

function importwf(){
	var parastr="filename";				
	var filename = document.frmMain.filename.value;
	//如果导入类型为
	if($GetEle("importtype").value=="1"){
		if(!check_form(document.frmMain,"workflowid")){
			return;
		}
		document.frmMain.action = "/workflow/import/WfUpdateOperation.jsp";
	}else{
		document.frmMain.action = "/workflow/import/WfImportOperation.jsp";
	}

	if(check_form(document.frmMain,parastr)){
		var pos = filename.length-4;
		if(filename.lastIndexOf(".xml")==pos){
			jQuery("#type").attr("disabled",false);
			jQuery("#loading").show();
			jQuery("#content").hide();
			document.frmMain.submit();
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(25644,user.getLanguage())%>");//选择文件格式不正确,请选择xml文件25644
			return;
		}
	}
}
</script>
</HTML>
