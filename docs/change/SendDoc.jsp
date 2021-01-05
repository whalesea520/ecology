
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/ecology8/docs/docExt_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:doRefresh});
		jQuery("#hoverBtnSpan").hoverBtn();
	});
</script>
<%
if(!HrmUserVarify.checkUserRight("DocChange:Send", user)){
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23024,user.getLanguage());
String needfav ="1";
String needhelp ="";

String status = Util.null2String(request.getParameter("status"));
if(status.equals("")) status = "0";
String title = Util.null2String(request.getParameter("title"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String enddate = Util.null2String(request.getParameter("enddate"));

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
int timeText = 18961;
if(status.equals("0")) {
	timeText = 18002;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doRefresh(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(status.equals("0")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(2083,user.getLanguage())+",javascript:doSend(null,null,this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<LINK href="../css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(status.equals("0")) { %>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2083,user.getLanguage())%>" class="e8_btn_top" onclick="doSend(null,null,this);"/>
			<%} %>
			<input type="text" class="searchInput" id="flowTitle" name="flowTitle" onchange="setKeyword('flowTitle','title','frmmain');"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<FORM name="frmmain" id="frmmain" action="/docs/change/SendDocOpterator.jsp" method="post">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
	    <wea:item><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></wea:item>
	    <wea:item>
			<select id="status" name="status" onChange="statusChange(this)">
			<option value="0" <%if(status.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22347,user.getLanguage())%></option>
			<option value="1" <%if(status.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19558,user.getLanguage())%></option>
			<option value="2" <%if(status.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22946,user.getLanguage())%></option>
			<option value="3" <%if(status.equals("3")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21983,user.getLanguage())%></option>
			</select>
		</wea:item>
	     <wea:item><div id="StatusDIV0" <%if(!status.equals("0")){%>style="display:none"<%}%>><%=SystemEnv.getHtmlLabelName(18002,user.getLanguage())%></div><div id="StatusDIV1" <%if(status.equals("0")){%>style="display:none"<%}%>><%=SystemEnv.getHtmlLabelName(18961,user.getLanguage())%></div></wea:item>
	    <wea:item>
	    	<span class="wuiDateSpan" selectId="doccreatedateselect">
		       <input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
		       <input class=wuiDateSel  type="hidden" name="enddate" value="<%=enddate%>">
		   </span>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(23038,user.getLanguage())%></wea:item>
	    <wea:item><INPUT class="InputStyle" id="title" name=title value='<%=title%>'></wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="button" onclick="doRefresh(this)" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>

<input name=start type=hidden value="<%=start%>">
<input name=requestids type=hidden value="">
</FORM>
</div>
<%
String statusText = "22347";
if(status.equals("0")) {
	statusText = "22347";
}
if(status.equals("1")) statusText = "19558";
if(status.equals("2")) statusText = "22946";
if(status.equals("3")) statusText = "21983";

String sqlwhere = " t1.requestid=t2.requestid and t1.currentnodeid = t2.nodeid and t2.userid="+user.getUID();
sqlwhere += " and t1.requestid > 0 and t1.currentnodetype='3' and t1.workflowid in(select workflowid from DocChangeWorkflow)";
if(status.equals("0")) {
	//取未发送的
	sqlwhere += " and t1.requestid not in (select requestid from DocChangeSend)";
	if(!fromdate.equals("")) sqlwhere += " and t2.receivedate>='"+fromdate+"' ";
	if(!enddate.equals("")) sqlwhere += " and t2.receivedate<='"+enddate+"' ";
}
else {
	String strStatus = "0,1";
	if(status.equals("2") || status.equals("3")) strStatus = status;
	//sqlwhere += " and t1.requestid in (select requestid from DocChangeSend)";
	sqlwhere += " and t1.requestid in (select distinct requestid from DocChangeSendDetail where status in(" + strStatus + ") )";
	//被退回
	//被拒收
}
if(!title.equals("")) sqlwhere += " and t1.requestname like '%"+title+"%'";

int totalcounts = Util.getIntValue(Util.null2String(request.getParameter("totalcounts")),0);
String tableString = "";
String  operateString= "";
if(status.equals("0")) {
	operateString = "<operates width=\"20%\">";
	operateString+=" <popedom isalwaysshow=\"true\"></popedom> ";
	operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:doSend();\" text=\""+SystemEnv.getHtmlLabelName(2083,user.getLanguage())+"\" index=\"0\"/>";
	operateString+="</operates>";
}else{
	operateString = "<operates width=\"20%\">";
	operateString+=" <popedom isalwaysshow=\"true\"></popedom> ";
	operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:doDetail();\" text=\""+SystemEnv.getHtmlLabelNames("20217,33361",user.getLanguage())+"\" index=\"0\"/>";
	operateString+="</operates>";
}	                               
String backfields = " t1.requestid,t1.workflowid,t1.requestname,t2.receivedate,t2.receivetime ";
String fromSql  = " workflow_requestbase t1, workFlow_CurrentOperator t2 ";
//out.print("select "+backfields + "from "+fromSql+" where "+sqlwhere);
tableString =   " <table instanceid=\"sendDocListTable\" tabletype=\"checkbox\" pageId=\""+PageIdConst.OWF_SENDDOC+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.OWF_SENDDOC,user.getUID(),PageIdConst.DOC)+"\" >"+
                //" <checkboxpopedom    popedompara=\"column:requestid\" showmethod=\"\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\"t2.receivedate,t2.receivetime\"  sqlprimarykey=\"t1.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                operateString+
                "       <head>"+
                 "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(23038,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" transmethod=\"\"  otherpara=\"column:requestid\" href=\"/workflow/request/ViewRequest.jsp\" linkkey=\"requestid\" linkvaluecolumn=\"requestid\" />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(timeText,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"receivedate,receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
//if(!status.equals("0"))
//tableString +=  "           <col width=\"80\"   text=\""+SystemEnv.getHtmlLabelName(20217,user.getLanguage())+"\" column=\"requestid\"  orderkey=\"\" otherpara=\"2121,"+user.getLanguage()+"\" transmethod=\"weaver.general.SplitPageTransmethod.getDocChangeCompanyDetail\" />";
tableString +=  "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(1929,user.getLanguage())+"\" column=\"requestid\" orderkey=\"\" otherpara=\""+statusText+","+user.getLanguage()+"\" transmethod=\"weaver.general.SplitPageTransmethod.getFieldname\" />"+
                "       </head>"+
                " </table>";
%>
<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.OWF_SENDDOC %>"/>
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>

<script>

jQuery(document).ready(function(){
	parent.registerClickEventForSendDoc(null,document,window);
});
//刷新动作
function doRefresh(obj) {
	document.frmmain.action = 'SendDoc.jsp';
	document.frmmain.submit();
	if(obj)
		obj.disabled = true;
}

//发送动作
function doSend(id,param,obj) {
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id) { 
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>');
	}
	else {
		document.frmmain.requestids.value = id; 
		document.frmmain.submit();
		obj.disabled = true;
	}
}
function statusChange(obj) {
	if(obj.value=='0') {
		document.getElementById('StatusDIV0').style.display = '';
		document.getElementById('StatusDIV1').style.display = 'none';
	}
	else {
		document.getElementById('StatusDIV0').style.display = 'none';
		document.getElementById('StatusDIV1').style.display = '';
	}
	doRefresh(obj);
}

//收文单位详细信息
function doDetail(requestid){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(!requestid){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83408,user.getLanguage())%>");
		return;
	}
	dialog.checkDataChange = false;
	var url = "/systeminfo/BrowserMain.jsp?mouldID=offical&url=/docs/change/ChangeDetailBrowser.jsp?requestid="+requestid;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("33564,20217,33361",user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 500;
	dialog.maxiumnable = true;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
