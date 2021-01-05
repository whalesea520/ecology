
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<% 
if(!HrmUserVarify.checkUserRight("intergration:automaticsetting",user)) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
%>
<%
String typename = Util.null2String(request.getParameter("typename"));
String setname = Util.null2String(request.getParameter("setname"));
String workFlowId = Util.null2String(request.getParameter("workFlowId"));
String workFlowName = Util.null2String(WorkflowComInfo.getWorkflowname(""+workFlowId));
String isbill = Util.null2String(WorkflowComInfo.getIsBill(workFlowId));
String formID = Util.null2String(WorkflowComInfo.getFormId(workFlowId));
int detailcount = 0;
if(!formID.equals("")){
    if(isbill.equals("0")){
        RecordSet.executeSql("select count(distinct groupid) from workflow_formfield where formid="+formID);
        if(RecordSet.next()){
            detailcount = RecordSet.getInt(1);
        }
    }else if(isbill.equals("1")){
        RecordSet.executeSql("select count(tablename) from Workflow_billdetailtable where billid="+formID);
        if(RecordSet.next()){
            detailcount = RecordSet.getInt(1);
        }
        if(detailcount==0){
            //没有记录不代表没有明细,单据对应的明细表可能没有写进Workflow_billdetailtable中
            //但此时可以确定该单据即使有明细，也只有一个明细。
            RecordSet.executeSql("select count(distinct viewtype) from workflow_billfield where viewtype=1 and billid="+formID);   
            if(RecordSet.next()){
                detailcount = RecordSet.getInt(1);
            }
        }
    }
}
//out.println("detailcount=="+detailcount);
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(82,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",automaticsetting.jsp?typename="+typename+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="automaticOperation.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<input type="hidden" id="operate" name="operate" value="add">
<input type="hidden" id="detailcount" name="detailcount" value="<%=detailcount%>">
<input name="typename" value="<%=typename %>" type="hidden" />
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  <wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="setnamespan" required="true" value='<%=setname %>'>
				<input type=text size=35 style='width:280px!important;' class=inputstyle style='' id="setname" name="setname" value="<%=setname%>" onChange="checkinput('setname','setnamespan')">
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></wea:item>
			<wea:item>
				<!-- input id="workFlowId" class="wuiBrowser" name="workFlowId" _url="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp" _scroll="no" _callBack="" value="<%=workFlowId %>" _displayText="<%=workFlowName %>" _displayTemplate="" _required="yes"/ -->
				<brow:browser name="workFlowId" viewType="0" hasBrowser="true" hasAdd="false" 
					browserUrl="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkflowBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
 					completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0" width="200px" browserValue="" browserSpanValue=""/>    	    	
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="datasourceidspan" required="true" value="">
				<select id="datasourceid" style='width:120px!important;' name="datasourceid" onchange="ChangeDatasource(this,datasourceidspan)">
					<option></option>
					<%
					ArrayList pointArrayList = DataSourceXML.getPointArrayList();
					for(int i=0;i<pointArrayList.size();i++){
					    String pointid = (String)pointArrayList.get(i);
					%>
					<option value="<%=pointid%>"><%=pointid%></option>
					<%    
					}
					%>
				</select>
				</wea:required>
			</wea:item>
		<%if(!workFlowId.equals("")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="outermaintablespan" required="true" value="">
				<input type=text size=35 class=inputstyle style='width:280px!important;' id="outermaintable" name="outermaintable" onChange="checkinput('outermaintable','outermaintablespan')">
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
			<wea:item>
				<textarea id="outermainwhere" name="outermainwhere" style='width:280px!important;' cols=100 rows=4></textarea>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(23107,user.getLanguage())%></wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(23108,user.getLanguage())%>:<br>
				<textarea id="successback" name="successback" style='width:280px!important;' cols=100 rows=4></textarea><br>
				<%=SystemEnv.getHtmlLabelName(23109,user.getLanguage())%>:<br>
				<textarea id="failback" name="failback" style='width:280px!important;' cols=100 rows=4></textarea>
			</wea:item>
		<%for(int i=0;i<detailcount;i++){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%></wea:item>
			<wea:item><input type=text size=35 class=inputstyle style='width:280px!important;' id="outerdetailname<%=i%>" name="outerdetailname<%=i%>"></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
			<wea:item>
				<textarea id="outerdetailwhere<%=i%>" style='width:280px!important;' name="outerdetailwhere<%=i%>" cols=100 rows=4></textarea>
			</wea:item>
		<%}%>
		<%}%>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'none'}">
		<wea:item attributes="{'colspan':'2'}">
			<font style="word-break:break-all;">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1:<%=SystemEnv.getHtmlLabelName(23111,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23154,user.getLanguage())%><BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2:<%=SystemEnv.getHtmlLabelName(23110,user.getLanguage())%><BR>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3:<%=SystemEnv.getHtmlLabelName(23152,user.getLanguage())%><BR>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4:<%=SystemEnv.getHtmlLabelName(31318,user.getLanguage())%><br>
			</font>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</body>
</html>
<script language="javascript">
$(document).ready(function(){
	wuiform.init();
});
function submitData(){
    if(check_form($GetEle("frmmain"),"setname,workFlowId,datasourceid,outermaintable")){
    	$GetEle("frmmain").submit();
    }
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	});
});
function onBack()
{
	document.location.href='/workflow/automaticwf/automaticsetting.jsp?typename=<%=typename%>';
}
function ChangeDatasource(obj,datasourceidspan){
    if(obj.value!=""&&obj.value!=null) datasourceidspan.innerHTML = "";
    else datasourceidspan.innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
}
</script>

<script type="text/javascript">
function disModalDialog(url, spanobj, inputobj, need, curl) {

	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}



function onShowWorkFlowSerach(inputename, tdname) {
	disModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp"
			, $GetEle(tdname)
			, $GetEle(inputename)
			, true);
}
</script>
