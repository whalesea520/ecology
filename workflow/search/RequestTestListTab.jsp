<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="testWorkflowCheck" class="weaver.workflow.workflow.TestWorkflowCheck" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />	
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script type='text/javascript' src='/album/js/common_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<script type="text/javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();			
});

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
	$("input[name='requestname']").val(typename);
	window.location="/workflow/search/RequestTestListTab.jsp?requestname="+typename;
}
</script>
</head>
<%
if (!HrmUserVarify.checkUserRight("Delete:TestRequest", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28056,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

String workflowid = "" ;
String fromdate ="" ;
String todate ="" ;
String creatertype ="" ;
String createrid ="" ;
String requestname = "";
String fromself = Util.null2String(request.getParameter("fromself"));
String isfirst = Util.null2String(request.getParameter("isfirst"));
String opttype = Util.null2String(request.getParameter("opttype"));
if("delete".equals(opttype)){
	String multisubids = Util.null2String(request.getParameter("multisubids"));
	//out.println("multisubids = " + multisubids);
	testWorkflowCheck.deleteTestRequest(multisubids, user, request);
}
if(fromself.equals("1")) {
	workflowid = Util.null2String(request.getParameter("workflowid"));
	fromdate = Util.null2String(request.getParameter("fromdate"));
	todate = Util.null2String(request.getParameter("todate"));
	creatertype = Util.null2String(request.getParameter("creatertype"));
	createrid = Util.null2String(request.getParameter("createrid"));
	requestname = Util.null2String(request.getParameter("requestname"));
}
String newsql = "";
if(fromself.equals("1")) {
	if(!workflowid.equals("") && !workflowid.equals("0")){
		newsql+=" and t1.workflowid in("+workflowid+")" ;
	}

	if(!fromdate.equals("")){
		newsql += " and t1.createdate>='"+fromdate+"'";
	}
	if(!todate.equals("")){
		newsql += " and t1.createdate<='"+todate+"'";
	}
	if(!createrid.equals("")){
		newsql += " and t1.creater='"+createrid+"'";
		newsql += " and t1.creatertype= '"+creatertype+"' ";
	}
	
	if(!"".equals(requestname)){
		newsql += " and t1.requestname like '%"+requestname+"%'";
	}
}

String userID = String.valueOf(user.getUID());
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2")) usertype= 1;

String sqlwhere=" where t1.workflowid=t2.id and (t1.deleted=1 and (t2.isvalid='2' or t2.isvalid='0') )";

String orderby = "t1.requestid";

sqlwhere +=" "+newsql ;


int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
String sql="";
int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);

int perpage = 10;
RecordSet.executeProc("workflow_RUserDefault_Select",""+user.getUID());
if(RecordSet.next()){
	perpage = RecordSet.getInt("numperpage");
}else{
	RecordSet.executeProc("workflow_RUserDefault_Select","1");
	if(RecordSet.next()){
		perpage = RecordSet.getInt("numperpage");
	}
}
if(perpage <=2){
	perpage = 10;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;

%>

<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<form id="frmmain" name="frmmain" method="post" action="/workflow/search/RequestTestListTab.jsp">
		<input type="hidden" id="fromself" name="fromself" value="1">
		<input type="hidden" id="isfirst" name="isfirst" value="<%=isfirst%>">
		<input type="hidden" id="opttype" name="opttype" value="">
		<input type="hidden" id="multisubids" name="multisubids" value="">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="doDelete()"/>
			<input type="text" class="searchInput" name="flowTitle" value="<%=requestname%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
<wea:layout type="fourCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
	    <wea:item>
			<brow:browser name="workflowid" viewType="0" hasBrowser="true" hasAdd="false" 
               	browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
                completeUrl="/data.jsp?type=workflowBrowser"  width="150px" browserValue='<%=workflowid%>' browserSpanValue='<%=WorkflowComInfo.getWorkflowname(workflowid)%>'/>
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
    	<wea:item>
			<select class="Inputstyle" name="creatertype" id="creatertype" style="float: left;width: 150px;">
			<%if(!user.getLogintype().equals("2")){%>
				<%if(isgoveproj==0){%>
					<option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				<%}else{%>
					<option value="0"<% if(creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
				<%}%>
			<%}%>
			<%if(isgoveproj==0){%>
					<option value="1"<% if(creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
			<%}%>
			</select>
			<% 
				String tempresource = "";
				if(creatertype.equals("0")){
					tempresource = ResourceComInfo.getResourcename(createrid);
				}else if(creatertype.equals("1")){
			 		tempresource = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(createrid),user.getLanguage());
				}
			%>
			<brow:browser name="createrid" viewType="0" hasBrowser="true" hasAdd="false" 
			   			  getBrowserUrlFn="onChangeResource"
            			  isMustInput="1" isSingle="true" hasInput="true"
             			  completeUrl="javascript:getajaxurl()"  width="150px" browserValue='<%=createrid%>' browserSpanValue='<%=tempresource %>'/>
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></wea:item>
    	<wea:item><input type="text" name="requestname" value='<%=requestname%>'></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
    	<wea:item>
    		<BUTTON type="button" class=calendar id=SelectDate  onclick="gettheDate(fromdate,fromdatespan)"></BUTTON>
			<SPAN id=fromdatespan ><%=fromdate%></SPAN>
			-&nbsp;&nbsp;
			<BUTTON type="button" class=calendar id=SelectDate2 onclick="gettheDate(todate,todatespan)"></BUTTON>
			<SPAN id=todatespan ><%=todate%></SPAN>
			<input type="hidden" name="fromdate" value="<%=fromdate%>"><input type="hidden" name="todate" value="<%=todate%>">
    	</wea:item>
    </wea:group>
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage()) %>"/>
    		<input class="e8_btn_cancel" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage()) %>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
<input name="start" id="start" type="hidden" value="<%=start%>">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_SEARCH_REQUESTTESTLISTTAB %>"/>
</div>	
</form>
		
		
		<TABLE width="100%" cellspacing=0>
			<tr>
				<td valign="top">																					
				<%
					String tableString = "";						 
					String backfields = " t1.requestid, t1.createdate, t1.createtime,t1.creater, t1.creatertype, t1.workflowid, t1.requestname, t1.status,t1.requestlevel,t1.currentnodeid ";
					String fromSql  = " from workflow_requestbase t1,workflow_base t2 ";
					String sqlWhere = sqlwhere;
					//out.println("select "+backfields+"&nbsp;"+fromSql+"&nbsp;"+sqlWhere);
					tableString =  "<table instanceid=\"workflowRequestListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_SEARCH_REQUESTTESTLISTTAB,user.getUID())+"\" >"+ 
								   "	<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
								   "			<head>";
					tableString += "				<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
					tableString += "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
					tableString += "				<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
					tableString += "				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>";
					tableString += "				<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\" />";
					tableString += "				<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"t1.status\" />";
					tableString += "			</head>";
					tableString += "            <operates>";
					tableString += "                <operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>";
					tableString += "            </operates>";    			
					tableString += "</table>";
				%>
					<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
				</td>
			</tr>
		</TABLE>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
		</td>
		</tr>
		</TABLE>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>

<script type="text/javascript">
function getajaxurl() {
	var tmpval = $("#creatertype").val();
	var url = "";	
	if (tmpval == "0") {
		url = "/data.jsp";
	}else {
		url = "/data.jsp?type=18";
	}	
	return url;
}
function onChangeResource(inputename,tdname){
	var tmpval = $("#creatertype").val();
	var tempurl1 = "";
	if (tmpval == "0") {
		tempurl1 = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	}else {
		tempurl1 = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
	}
	return tempurl1;
}

function disModalDialog(url, inputobj,spanobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.html("<A href='" + curl+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>");
			} else {
				spanobj.html(wuiUtil.getJsonValueByIndex(id, 1));
			}
			inputobj.val(wuiUtil.getJsonValueByIndex(id, 0));
		} else {
			spanobj.html(need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "");
			inputobj.val("");
		}
	}
}

function onShowResource() {
	var tmpval = $GetEle("creatertype").value;
	var id = null;
	if (tmpval == "0") {
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	}else {
		id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	}
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			resourcespan.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			$GetEle("createrid").value=wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			resourcespan.innerHTML = "";
			$GetEle("createrid").value="";
		}
	}

}
function onShowDepartment(tdname,inputename) {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + $GetEle(inputename).value, "", "dialogWidth:550px;dialogHeight:550px;")
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			$GetEle(tdname).innerHTML = wuiUtil.getJsonValueByIndex(id, 1).substr(1);
			$GetEle(inputename).value= wuiUtil.getJsonValueByIndex(id, 0).substr(1);
		} else {
			$GetEle(tdname).innerHTML = "";
			$GetEle(inputename).value="";
		}
	}
}
</script>

<SCRIPT language="javascript">

function OnChangePage(start){
		$GetEle("start").value = start;
		$GetEle("frmmain").submit();
}

function OnSearch(){
	$GetEle("fromself").value="1";
	$GetEle("isfirst").value="1";
	$GetEle("frmmain").submit();
}
function doDelete(){
	var ids = "";
	$("input[name='chkInTableTag']").each(function(){
	if($(this).attr("checked"))			
		ids = ids +$(this).attr("checkboxId")+",";
	});
	
	$GetEle("multisubids").value = ids;
	if($GetEle("multisubids").value == ""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>");
		return;
	}
	
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){	
								$GetEle("fromself").value="1";
								$GetEle("isfirst").value="1";
								$GetEle("opttype").value="delete";
								$GetEle("frmmain").submit();
						}, function () {}, 320, 90,true);
}

function onDel(id){
	var idtmp = id+",";
	$GetEle("multisubids").value =idtmp;
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){	
								$GetEle("fromself").value="1";
								$GetEle("isfirst").value="1";
								$GetEle("opttype").value="delete";
								$GetEle("frmmain").submit();
						}, function () {}, 320, 90,true);
}

function CheckAll(haschecked) {

	len = document.weaver1.elements.length;
	var i=0;
	for( i=0; i<len; i++) {
		if (document.weaver1.elements[i].name.substring(0,13)=='multi_submit_') {
			document.weaver1.elements[i].checked=(haschecked==true?true:false);
		}
	}

}


var showTableDiv  = $GetEle('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
	showTableDiv.style.display='';
	var message_Div = document.createElement("div");
	 message_Div.id="message_Div";
	 message_Div.className="xTable_message";
	 showTableDiv.appendChild(message_Div);
	 var message_Div1  = $GetEle("message_Div");
	 message_Div1.style.display="inline";
	 message_Div1.innerHTML=content;
	 var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
	 var pLeft= document.body.offsetWidth/2-50;
	 message_Div1.style.position="absolute"
	 message_Div1.style.top=pTop;
	 message_Div1.style.left=pLeft;

	 message_Div1.style.zIndex=1002;

	 oIframe.id = 'HelpFrame';
	 showTableDiv.appendChild(oIframe);
	 oIframe.frameborder = 0;
	 oIframe.style.position = 'absolute';
	 oIframe.style.top = pTop;
	 oIframe.style.left = pLeft;
	 oIframe.style.zIndex = message_Div1.style.zIndex - 1;
	 oIframe.style.width = parseInt(message_Div1.offsetWidth);
	 oIframe.style.height = parseInt(message_Div1.offsetHeight);
	 oIframe.style.display = 'block';
}
function displaydiv_1(){
	if(WorkFlowDiv.style.display == ""){
		WorkFlowDiv.style.display = "none";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
	}
	else{
		WorkFlowDiv.style.display = "";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";

	}
}

function ajaxinit(){
	var ajax=false;
	try {
		ajax = new ActiveXObject("Msxml2.XMLHTTP");
	} catch (e) {
		try {
			ajax = new ActiveXObject("Microsoft.XMLHTTP");
		} catch (E) {
			ajax = false;
		}
	}
	if (!ajax && typeof XMLHttpRequest!='undefined') {
	ajax = new XMLHttpRequest();
	}
	return ajax;
}
function showallreceived(requestid,returntdid){
	showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
	var ajax=ajaxinit();
	ajax.open("POST", "WorkflowUnoperatorPersons.jsp", true);
	ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	ajax.send("requestid="+requestid+"&returntdid="+returntdid);
	//获取执行状态

	//alert(ajax.readyState);
	//alert(ajax.status);
	ajax.onreadystatechange = function() {
		//如果执行状态成功，那么就把返回信息写到指定的层里

		if (ajax.readyState==4&&ajax.status == 200) {
			try{
				 $GetEle(returntdid).innerHTML = ajax.responseText;
				 $GetEle(returntdid).parentElement.title = ajax.responseText.replace(/[\r\n]/gm, "");
			}catch(e){}
				showTableDiv.style.display='none';
				oIframe.style.display='none';
		} 
	} 
}

function onShowWorkFlow(inputname, spanname) {
	onShowWorkFlowBase(inputname, spanname, false);
}

function onShowWorkFlowNeeded(inputname, spanname) {
	onShowWorkFlowBase(inputname, spanname, true);
}

function onShowWorkFlowBase(inputname, spanname, needed) {
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	if (retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
			$GetEle(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$GetEle(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
		} else { 
			$GetEle(inputname).value = "";
			if (needed) {
				$GetEle(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			} else {
				$GetEle(spanname).innerHTML = "";
			}
		}
	}
}
</script>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</html>
