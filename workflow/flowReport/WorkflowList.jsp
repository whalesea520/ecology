
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%> <!--added by xwj  for td2903  20051019-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" /><!--added by xwj  for td2903  20051019-->
<jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /><!--added by xwj  for td2903  20051019-->

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<title><%=SystemEnv.getHtmlLabelName(21913,user.getLanguage())%></title>
</head>

<%----xwj for td3665 20060301 begin---%>
<%
String info = (String)request.getParameter("infoKey");
%>
<script language="JavaScript">
<%if(info!=null && !"".equals(info)){

  if("ovfail".equals(info)){%>
 alert(<%=SystemEnv.getHtmlLabelName(18566,user.getLanguage())%>)
 <%}
 else if("rbfail".equals(info)){%>
 alert(<%=SystemEnv.getHtmlLabelName(18567,user.getLanguage())%>)
 <%}
 else{
 
 }
 }%> 
</script>
<%----xwj for td3665 20060301 end---%>


<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(21913,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="workflow" />
	<jsp:param name="navName" value="<%=titlename%>" />
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align: right;">
			<input type="text" class="searchInput" name="flowTitle" value="<%=Util.null2String(request.getParameter("requestName"))%>" />
				&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<FORM id=weaver name=weaver method=get action="WorkflowMonitor.jsp"><%--xwj for td2978 20051108--%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_FLOWREPORT_WORKFLOWLIST %>"/>
<input type=hidden name=fromself value="1">
<input type=hidden name=operation>
<div style="display:none">
<BUTTON class=btnRefresh accessKey=R type="button" onclick="OnChangePage(1)"><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON>
<BUTTON type='button' class=btnDelete accessKey=D onclick="deleteWorkflow()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<BUTTON type='button' class=btn accessKey=R onClick="location.href='/system/SystemMaintenance.jsp'"><U>R</U>-<%=SystemEnv.getHtmlLabelName(1290, user.getLanguage())%></BUTTON>
</div>

<%
String CurrentUser = Util.null2String((String)session.getAttribute("RequestViewResource")) ;
String logintype = ""+user.getLogintype();
int usertype = 0;

if(CurrentUser.equals("")) {
	CurrentUser = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
}

String sqlwhere=Util.null2String(request.getParameter("sql")); 
String fromSql  =Util.null2String(request.getParameter("fromsql")); 
String workflowtypeid  =Util.null2String(request.getParameter("workflowtypeid")); 
String workflowids  =Util.null2String(request.getParameter("workflowid")); 
String requestName = Util.null2String(request.getParameter("requestName"));
if (!"".equals(requestName)) {
	sqlwhere += " and a.requestname like '%" + Util.StringReplace(Util.toHtml(requestName), "'", "''") + "%'";
}
if (!workflowtypeid.equals("")) sqlwhere+=" and workflow_currentoperator.workflowtype="+workflowtypeid;
if (!workflowids.equals("")) sqlwhere+=" and a.workflowid in ("+WorkflowVersion.getAllVersionStringByWFIDs(workflowids) + ")";

String orderby=" a.createdate ,a.createtime ";

int start=Util.getIntValue(Util.null2String(request.getParameter("start")),1);

String tableString = "";                                 
String backfields = " a.requestid, a.currentnodeid, a.createdate, a.createtime,a.lastoperatedate, a.lastoperatetime,a.creater, a.creatertype, a.workflowid, a.requestname, a.status, a.requestlevel";
String sqlWhere = sqlwhere;
//System.out.println("select "+backfields + "from "+fromSql+" where "+sqlWhere);

String sql = "select distinct a.workflowid from "+fromSql+" "+sqlWhere;

RecordSet.executeSql(sql);
String tempwoflid = "";
while(RecordSet.next()){
    String theworkflowid = Util.null2String(RecordSet.getString("workflowid"));
 
    theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);

    if (!WorkflowComInfo.getIsValid(theworkflowid).equals("1")) {
		if(tempwoflid.indexOf(theworkflowid) == -1){
			tempwoflid += "," + theworkflowid;
		}
            
    }
}
if(tempwoflid.indexOf(",") == 0){
    tempwoflid=tempwoflid.substring(1);
}

//把无效状态对应的多个历史版本取出来
String sqlwx = "select distinct id,workflowname from workflow_base where activeversionid in (select activeversionid from workflow_base where id in ("+tempwoflid+"))";
RecordSet1.executeSql(sqlwx);

String wxworkflowid = ""; 
String tmpwxworkflowid = ""; 

while(RecordSet1.next()){
	wxworkflowid = Util.null2String(RecordSet1.getString("id"));
	tmpwxworkflowid += "," + wxworkflowid;
}

//去掉最前面的逗号
if(tmpwxworkflowid.indexOf(",") == 0){
    tmpwxworkflowid=tmpwxworkflowid.substring(1);
}

String tempwxworkflowid = "";

//判断是否有id存在
if(tempwoflid.length() != 0){
	if(tmpwxworkflowid.length() != 0){
		tempwxworkflowid = tempwoflid + "," + tmpwxworkflowid;
	}else{
		tempwxworkflowid = tempwoflid;
	}
    sqlWhere = sqlWhere + " and a.workflowid not in (" + tempwxworkflowid + ")";
	//sqlWhere = sqlWhere + " and a.workflowid not in (" + tempwoflid + ")";
}


String para4=user.getLanguage()+"+"+user.getUID();
tableString =   " <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_FLOWREPORT_WORKFLOWLIST,user.getUID())+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.requestid\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" transmethod=\"weaver.general.WorkFlowTransMethod.getFlowPendingLink\"  otherpara=\"column:requestid\" />"+
                "           <col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"a.workflowid,requestname\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+
                "           <col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"a.creater\" otherpara=\"creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />"+
                "           <col width=\"17%\"   text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\"  orderkey=\"a.createdate,a.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />"+
                "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18564,user.getLanguage())+"\" column=\"currentnodeid\" orderkey=\"currentnodeid\"  transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\" />"+
                "           <col width=\"13%\"  text=\""+SystemEnv.getHtmlLabelName(18565,user.getLanguage())+"\" column=\"requestid\"  otherpara=\""+para4+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators2\" />"+
                "           <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"status\" />"+
               
                "       </head>"+
                " </table>";
%>

<input name=start type=hidden value="<%=start%>">
<input type=hidden name=multiRequestIds value="">
<TABLE width="100%">
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
</form>

<FORM id=frmmain name=frmmain method=post action="WorkflowList.jsp">
	<input type="hidden" name="requestName" value="" />
	<input type="hidden" name="sql" value="<%=xssUtil.put(request.getParameter("sql"))%>" />
	<input type="hidden" name="fromsql" value="<%=request.getParameter("fromsql")%>" />
	<input type="hidden" name="workflowtypeid" value="<%=workflowtypeid %>" />
	<input type="hidden" name="workflowid" value="<%=workflowids %>" />
</FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>

<SCRIPT language="javascript">
jQuery("#topTitle").topMenuTitle({searchFn:searchTitle});

function searchTitle() {
	jQuery('#frmmain input[name="requestName"]').val(jQuery('#topTitle input[name="flowTitle"]').val());
	$GetEle("frmmain").submit();
}

function OnChangePage(start){
        document.weaver.start.value = start;
		document.weaver.submit();
}

function deleteWorkflow(){
	if(isdel()) {
        document.weaver.multiRequestIds.value = _xtable_CheckedCheckboxId();
        document.weaver.operation.value='deleteworkflow';
        document.weaver.action='/system/systemmonitor/MonitorOperation.jsp';
        document.weaver.submit();
	}
}



var showTableDiv  = document.getElementById('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("div");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = document.getElementById("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.posTop=pTop;
     message_Div1.style.posLeft=pLeft;

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
function displaydiv_1()
{
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
	
    ajax.open("POST", "/workflow/search/WorkflowUnoperatorPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&returntdid="+returntdid);
    //获取执行状态

    //alert(ajax.readyState);
	//alert(ajax.status);
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState==4&&ajax.status == 200) {
            try{
            document.all(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        } 
    } 
}
</script>
</body>
</html>
