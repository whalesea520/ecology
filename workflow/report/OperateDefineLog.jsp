<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
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

<script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']",parent.document).val();
	$("input[name='requestname']").val(typename);
	jQuery("#frmmain").submit();
}

function onShowResource() {
	var id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) !=  "") {
			$G("viewerspan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id=" + wuiUtil.getJsonValueByIndex(id, 0) + "'>" + wuiUtil.getJsonValueByIndex(id, 1) + "</A>";
			$G("viewer").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else { 
			$G("viewerspan").innerHTML = ""
			$G("viewer").value=""
		}
	}
}
function submitData()
{
	if (check_form(frmmain,''))
		frmmain.submit();
}

function submitClear()
{
	btnclear_onclick();
}

function changeDate(obj,formatedate){
	var dateval = jQuery(obj).val();
	if(dateval == "6"){
		jQuery("#spanfromdate").css("display","");
		
	}else{
		jQuery("#spanfromdate").css("display","none");
	}
}

</script>
</head>
<%
if(!HrmUserVarify.checkUserRight("LogView:View", user))  {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }

int userid=user.getUID();
String titlename = SystemEnv.getHtmlLabelName(730,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(679,user.getLanguage());

String workflowname = Util.null2String(request.getParameter("workflowname"));
String requestname = Util.null2String(request.getParameter("requestname"));
String operatetype = Util.null2String(request.getParameter("operatetype"));
String operator = Util.null2String(request.getParameter("operator"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String dateselect =Util.fromScreen(request.getParameter("dateselect"),user.getLanguage());

if(!dateselect.equals("") && !dateselect.equals("0")&& !dateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(dateselect,"0");
	todate = TimeUtil.getDateByOption(dateselect,"1");
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%
//String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String backfields = "t1.clientip, t1.logtype,t1.operatedate,t1.operatetime,t1.workflowid,t1.operator,t1.requestid, t2.creater, t2.requestname ";
String sqlfrom = " workflow_requestLog t1,workflow_requestbase t2 ";
String sqlwhere = " t1.requestid=t2.requestid  ";
String sqlorderby = " t1.operatedate desc,t1.operatetime desc ";
/*********************/

/*********************/
if(!workflowname.equals("")&&workflowname!=null){
	sqlwhere += " AND t1.workflowid = '"+ workflowname +"' ";
}
if(!requestname.equals("")&&requestname!=null){
	sqlwhere += " AND t2.requestname LIKE '%"+ requestname +"%' ";
}
if(!operator.equals("")&&operator!=null){
	sqlwhere += " AND t1.operator = '"+ operator +"' ";
}


if(!fromdate.equals("")&&fromdate!=null){
	sqlwhere += " AND t1.operatedate >= '" + fromdate + "' ";
}
if(!todate.equals("")&&todate!=null){
	sqlwhere += " AND t1.operatedate <= '" + todate + "' ";
}
if(!operatetype.equals("")&&operatetype!=null){
	sqlwhere += " AND t1.logtype = '"+ operatetype +"' ";
}
/*********************/

%>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" id="frmmain" method=post action="OperateDefineLog.jsp">
<TABLE class=Shadow>
	<tr>
		<td valign="top">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="text" class="searchInput" name="flowTitle"  value='' onchange="reSetInputt1()"/>
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
					<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>

			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<form id="formSearchg" name="formSearchg" method="post" action="/system/systemmonitor/workflow/systemMonitorStatic.jsp">
					<wea:layout type="fourCol">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
							<wea:item><%=SystemEnv.getHtmlLabelName(30585,user.getLanguage())+SystemEnv.getHtmlLabelName(33569,user.getLanguage())%></wea:item>
							<wea:item>
	              					<input type="text" name="requestname" class=inputstyle  value=""/> 
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(33476,user.getLanguage())+SystemEnv.getHtmlLabelName(18499,user.getLanguage())%></wea:item>
							<wea:item>
	              				<brow:browser viewType="0" name="workflowname" browserValue='<%= ""+workflowname %>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WFTypeBrowserContenter.jsp"
										hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
										completeUrl="/data.jsp?type=workflowBrowser" 
										browserSpanValue='<%=WorkflowComInfo.getWorkflowname(workflowname)%>'>
								</brow:browser>
							</wea:item>
							
							<wea:item><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></wea:item>
						    <wea:item>
							    <brow:browser viewType="0" name="operator" browserValue='<%= ""+operator %>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
										hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
										completeUrl="/data.jsp" 
										browserSpanValue='<%=ResourceComInfo.getResourcename(operator)%>'>
								</brow:browser>
						    </wea:item>
						    <wea:item><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></wea:item>
						    <wea:item>
						    	<span>
									<select name="dateselect" id="dateselect" onchange="changeDate(this,'spanfromdate');">
										<option value="0" <%=dateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
										<option value="1" <%=dateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
										<option value="2" <%=dateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
										<option value="3" <%=dateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
										<option value="4" <%=dateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
										<option value="5" <%=dateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
										<option value="6" <%=dateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
									</select>
								</span>
								<span id=spanfromdate style="<%=dateselect.equals("6")?"":"display:none;" %>">
									<BUTTON class=Calendar type="button" id=selectfromdate onclick="getDate('fromdatespan','fromdate')"></BUTTON>
									<SPAN id=fromdatespan ><%=fromdate%></SPAN>－

									<BUTTON class=Calendar type="button" id=selecttodate onclick="getDate('todatespan','todate')"></BUTTON>
									<SPAN id=todatespan ><%=todate%></SPAN>
								</span>
								<input type="hidden" id=fromdate name="fromdate" value="<%=fromdate%>">
								<input type="hidden" id=todate name="todate" value="<%=todate%>">
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage())%></wea:item>
						<wea:item>
							   <select name="operatetype" id="operatetype"">
										<option value="" <%=operatetype.equals("")?"selected":"" %>></option>
										<option value="1" <%=operatetype.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></option>
										<option value="2" <%=operatetype.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></option>
										<option value="3" <%=operatetype.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></option>
										<option value="4" <%=operatetype.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></option>
										<option value="5" <%=operatetype.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></option>
										<option value="6" <%=operatetype.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(737,user.getLanguage())%></option>
										<option value="7" <%=operatetype.equals("7")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></option>
										<option value="9" <%=operatetype.equals("9")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%></option>
										<option value="0" <%=operatetype.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
										<option value="e" <%=operatetype.equals("e")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18360,user.getLanguage())%></option>
										<option value="t" <%=operatetype.equals("t")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%></option>
										<option value="s" <%=operatetype.equals("s")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21223,user.getLanguage())%></option>
									</select>
						 </wea:item>
						</wea:group>
						<wea:group context="" attributes="{'groupDisplay':'none'}">
							<wea:item type="toolbar">
								<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="doSubmit(2);"/>
								<span class="e8_sep_line">|</span>
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
								<span class="e8_sep_line">|</span>
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
							</wea:item>
						</wea:group>
					</wea:layout>
					<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_HANDLElOG %>"/>
				</form>
			</div>
<%
String tableString = "";                                
tableString =   " <table tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_HANDLElOG,user.getUID(),PageIdConst.DOC)+"\" >"+
                "       <sql  backfields=\""+backfields+"\" sqlform=\""+sqlfrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(99,user.getLanguage())+"\" column=\"operator\" orderkey=\"operator\" transmethod=\"weaver.workflow.report.ViewReportLog.getViewReportViewer\"  />   "+
                " 			<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15503,user.getLanguage())+"\" column=\"logtype\" orderkey=\"logtype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.report.ViewReportLog.getLogType\" />"+
                " 			<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15502,user.getLanguage())+"\" column=\"operatedate\" orderkey=\"operatedate\" otherpara=\"column:operatetime\" transmethod=\"weaver.workflow.report.ViewReportLog.getViewReportDateTime\" />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(30585,user.getLanguage())+SystemEnv.getHtmlLabelName(33569,user.getLanguage())+"\" column=\"requestname\"  orderkey=\"requestname\" otherpara=\"column:requestid\" transmethod=\"weaver.workflow.report.ViewReportLog.getViewReportRequest\"  />"+
                " 			<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(33476,user.getLanguage())+SystemEnv.getHtmlLabelName(18499,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"workflowid\"  transmethod=\"weaver.workflow.report.ViewReportLog.getViewReportWorkflowName\" />"+
                " 			<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17484,user.getLanguage())+"\" column=\"clientip\" orderkey=\"clientip\" />"+
                "       </head>"+
                " </table>";
%>
			<TABLE width="100%" cellspacing=0>
			    <tr>
			        <td valign="top">  
			            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			        </td>
			    </tr>
			</TABLE>
		</td>
	</tr>
</TABLE>
</form>
</body>
</html>
