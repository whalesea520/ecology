
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.GCONST" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<script language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</head>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18759,user.getLanguage());
String needfav ="1";
String needhelp ="";

String isOpenWorkflowStopOrCancel=GCONST.getWorkflowStopOrCancel();//是否开启流程暂停或取消配置

String infoid = Util.null2String(request.getParameter("infoid"));
int typeid = Util.getIntValue(request.getParameter("typeid"),0);
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
int operatelevel=0;
String inputt11 = Util.null2String(request.getParameter("inputt11"));
String operatedate = Util.null2String(request.getParameter("operatedate"));
String operatedateend = Util.null2String(request.getParameter("operatedateend"));

boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
int detachable = isUseWfManageDetach?1:0;
//按钮权限
if (isUseWfManageDetach){
        operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowMonitor:All", subcompanyid);
        if(operatelevel < 0){
            response.sendRedirect("/notice/noright.jsp") ;
            return ;
        }
}else{
    if (HrmUserVarify.checkUserRight("WorkflowMonitor:All", user)){
        operatelevel = 2;
    }
}


%>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel > 0){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+SystemEnv.getHtmlLabelName(665,user.getLanguage())+",javascript:deltype(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value='<%=Monitor.getWorkflowMonitor3(infoid,user.getLanguage()+"") %>'/>
</jsp:include>
<form id="formSearchg" name="formSearchg" method="post" action="/system/systemmonitor/workflow/systemMonitorDetail.jsp">
<INPUT type="hidden" name="infoid"  id ="infoid" value=<%=infoid%>>
<INPUT type="hidden" name="typeid"  id ="typeid" value=<%=typeid%>>
<INPUT type="hidden" name="subcompanyid"  id ="subcompanyid" value=<%=subcompanyid%>>
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<%if(operatelevel > 0){ %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top"  onclick="doSave()">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())+SystemEnv.getHtmlLabelName(665,user.getLanguage()) %>" class="e8_btn_top" onclick="deltype()"/>
					<%} %>
					<input type="text" class="searchInput" name="flowTitle"  value="<%=inputt11 %>" onchange="reSetInputt1()" />
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
					<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>

			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				
					<wea:layout type="fourCol">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
							<wea:item><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></wea:item>
							<wea:item>
	              					<input type="text" name="inputt11" class=inputstyle  value="<%=inputt11%>"/> 
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></wea:item>
							<wea:item>
									<span class="wuiDateSpan" selectId="operatedatespan" selectValue="">
										<input class=wuiDateSel type="hidden" name="operatedate" value="<%=operatedate%>">
										<input class=wuiDateSel type="hidden" name="operatedateend" value="<%=operatedateend%>">
									</span>
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
				
			</div>


<%
int perpage=20;
String tableString = "";
if(perpage <2) perpage=10;                                 
String backfields = " a.workflowid, "+
	                "b.workflowname, "+
	                "b.subcompanyid,"+
	                "max(a.operatordate) as operatordate, "+
	                "max(a.operatortime) as operatortime, "+
	                "sum(convert(INT,isnull(a.isview,0))) as isview, "+
	                "sum(convert(INT,isnull(a.isintervenor,0))) as isintervenor, "+
	                "sum(convert(INT,isnull(a.isdelete,0))) as isdelete, "+
	                "sum(convert(INT,isnull(a.isForceDrawBack,0))) as isForceDrawBack, "+
	                "sum(convert(INT,isnull(a.isForceOver,0))) as isForceOver, "+
	                "sum(convert(INT,isnull(a.issooperator,0))) as issooperator ";
if(RecordSet.getDBType().equals("oracle"))
{
	backfields = " a.workflowid, "+
	                "b.workflowname, "+
	                "b.subcompanyid,"+
	                "max(a.operatordate) as operatordate, "+
	                "max(a.operatortime) as operatortime, "+
	                "sum(to_number(nvl(a.isview,0))) as isview, "+
	                "sum(to_number(nvl(a.isintervenor,0))) as isintervenor, "+
	                "sum(to_number(nvl(a.isdelete,0))) as isdelete, "+
	                "sum(to_number(nvl(a.isForceDrawBack,0))) as isForceDrawBack, "+
	                "sum(to_number(nvl(a.isForceOver,0))) as isForceOver, "+
	                "sum(to_number(nvl(a.issooperator,0))) as issooperator ";
}
String fromSql  = " workflow_monitor_detail a,workflow_base b,workflow_monitor_info c ";
String sqlWhere = "where a.workflowid = b.id and a.infoid = c.id and c.id = " + infoid ;
if(detachable==1)
{
	if(subcompanyid<1)
	{
		operatelevel = 2;
	}
}

if(RecordSet.getDBType().equals("oracle")){
	sqlWhere += " and nvl(a.monitortype,0) = "+typeid;
}
else{
	sqlWhere += " and isnull(a.monitortype,0) = "+typeid;
}

if(!"".equals(inputt11)){
	sqlWhere += " and  b.workflowname like '%"+inputt11+"%'  ";
}
if(!"".equals(operatedate)){
	sqlWhere += " and a.operatordate >=  '"+operatedate+"' ";
}
if(!"".equals(operatedateend)){
	sqlWhere += " and a.operatordate <=  '"+operatedateend+"' ";
}

//if(detachable == 1 && user.getUID() != 1){
//    sqlWhere += " and b.subcompanyid = "+subcompanyid;
//}

String editSubs=SubCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowMonitor:All",0);
String para2=infoid+"+column:workflowid+"+detachable+"+column:subcompanyid+"+user.getUID()+"+"+operatelevel+"+"+editSubs;
String para3=infoid+"+column:workflowid+"+user.getLanguage()+"+"+user.getUID()+"+"+operatelevel+"+"+detachable+"+"+subcompanyid;

String orderby=" b.subcompanyid,b.workflowname";
String sqlgroupby = " a.workflowid,b.workflowname,b.subcompanyid ";
boolean wfintervenor= GCONST.getWorkflowIntervenorByMonitor();
tableString =   " <table instanceid=\"workflowMoniterListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_SYSTEM_MONITOR_DETAIL,user.getUID())+"\" >"+
				" 		<checkboxpopedom  id=\"checkbox\" popedompara=\"column:subcompanyid+"+ user.getUID()+"+"+detachable+"+"+operatelevel+"\" showmethod=\"weaver.workflow.monitor.Monitor.getDetailCheckBox\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\" sqlgroupby=\""+sqlgroupby+"\"  sqlprimarykey=\"workflowid\" sqlsortway=\"Desc\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                "           <col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(18104,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\" />"+
                "           <col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"operatordate\" orderkey=\"operatordate,operatortime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" otherpara=\"column:operatortime\" />"+
                "        <col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(82770,user.getLanguage())+"\" column=\"isview\" orderkey=\"isview\" otherpara=\"1+"+para2+"\" transmethod=\"weaver.workflow.monitor.Monitor.getMonitorWFCompetence\" />";
if(wfintervenor) tableString+="        <col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(82771,user.getLanguage())+"\" column=\"isintervenor\" orderkey=\"isintervenor\" otherpara=\"2+"+para2+"\" transmethod=\"weaver.workflow.monitor.Monitor.getMonitorWFCompetence\" />";
   tableString+="        <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(20307,user.getLanguage())+"\" column=\"isdelete\" orderkey=\"isdelete\" otherpara=\"3+"+para2+"\" transmethod=\"weaver.workflow.monitor.Monitor.getMonitorWFCompetence\" />"+
                "        <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(82772,user.getLanguage())+"\" column=\"isForceDrawBack\" orderkey=\"isForceDrawBack\" otherpara=\"4+"+para2+"\" transmethod=\"weaver.workflow.monitor.Monitor.getMonitorWFCompetence\" />"+
                "        <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(82773,user.getLanguage())+"\" column=\"isForceOver\" orderkey=\"isForceOver\" otherpara=\"5+"+para2+"\" transmethod=\"weaver.workflow.monitor.Monitor.getMonitorWFCompetence\" />";
if(isOpenWorkflowStopOrCancel.equals("1")){ 
   //是否开启流程暂停或取消配置	
   tableString+="        <col width=\"14%\"  text=\""+SystemEnv.getHtmlLabelName(82774,user.getLanguage())+"\" column=\"issooperator\" orderkey=\"issooperator\" otherpara=\"6+"+para2+"\" transmethod=\"weaver.workflow.monitor.Monitor.getMonitorWFCompetence\" />";
}
   tableString+= "       </head></table>";
%>
<TABLE width="100%">
    <tr>
        <td valign="top">
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
            <input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_SYSTEM_MONITOR_DETAIL %>"/>
        </td>
    </tr>
</TABLE>
</form>

<iframe  id="frmmain" name="frmmain" src="systemMonitorOperation.jsp" frameborder="0" style="height:0px;"></iframe>
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script language="JavaScript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	
	
	jQuery('input[type=checkbox]').each(function(){
		alert(1);
		jQuery(this).trigger('disabled',false);
	});		
});

function doSubmit(type) {
	document.formSearchg.submit();
}

function  test(rtnVal, e) {  
}

function onBtnSearchClick(){
	document.formSearchg.submit();
}
var dialog = parent.getDialog(window);
function doSave(){
	dialog.closeByHand()
}

function deltype(){
	var id = "";
	$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked"))	{	
			id += $(this).attr("checkboxId")+"A";
		}
	});
	if(id==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		return false;
	}
	top.Dialog.confirm("确定要取消监控吗？", function (){
		window.location = "/system/systemmonitor/workflow/systemMonitorOperation.jsp?actionKey=upallcontrol&flowid="+id+"&infoid=<%=infoid%>&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
		var parentWin = null;
		try{
			 parentWin = parent.getParentWindow(window);
			 parentWin.location="/system/systemmonitor/workflow/systemMonitorStatic.jsp";
			}catch(e){}
			
	}, function () {}, 320, 90,true);
	
}

var showTableDiv  = document.getElementById('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("<div>");
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
function setisview(obj,ohrmid,oworkflowid,oisview){

	if(obj.checked)
		oisview = 1;
	else{
		oisview = 0;
	}
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=upview&isview="+oisview+"&flowid="+oworkflowid+"&infoid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}

function setisIntervenor(obj,ohrmid,oworkflowid,oisintervenor){
	if(obj.checked)
		oisintervenor = 1;
	else
		oisintervenor = 0;
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=upintervenor&isintervenor="+oisintervenor+"&flowid="+oworkflowid+"&infoid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}
function setisDel(obj,ohrmid,oworkflowid,oisdelete){
	if(obj.checked)
		oisdelete = 1;
	else
		oisdelete = 0;
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=updel&isdelete="+oisdelete+"&flowid="+oworkflowid+"&infoid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}
function setisFB(obj,ohrmid,oworkflowid,oisForceDrawBack){
	if(obj.checked)
		oisForceDrawBack = 1;
	else
		oisForceDrawBack = 0;
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=upfb&isForceDrawBack="+oisForceDrawBack+"&flowid="+oworkflowid+"&infoid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}
function setisFO(obj,ohrmid,oworkflowid,oisForceOver){
	if(obj.checked)
		oisForceOver = 1;
	else
		oisForceOver = 0;
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=upfo&isForceOver="+oisForceOver+"&flowid="+oworkflowid+"&infoid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}
function setisSO(obj,ohrmid,oworkflowid,oissooperator){
	if(obj.checked)
		oissooperator = 1;
	else
		oissooperator = 0;
    document.all("frmmain").src="systemMonitorOperation.jsp?actionKey=upso&issooperator="+oissooperator+"&flowid="+oworkflowid+"&infoid="+ohrmid+"&typeid=<%=typeid%>&subcompanyid=<%=subcompanyid%>&detachable=<%=detachable%>";
}
function hiddenreceiviedPopup(){
    showTableDiv.style.display='none';
    oIframe.style.display='none';
}
function changecolor(obj,color){
    obj.style.color=color;
}
function afterDoWhenLoaded(){
	jQuery("input[type=checkbox]").each(function(){
	  if(jQuery(this).attr("tzCheckbox")=="true"){
	   	jQuery(this).tzCheckbox({labels:['','']});
	   	//如果禁用,则修改开关CSS
	   	if(jQuery(this).attr('disabled')){
			jQuery(this).next().attr("class",jQuery(this).next().attr('class').replace('tzCheckBox','tzCheckBox_disabled'));
			jQuery(this).next().find('.tzCBPart').attr('class','tzCBPart_disabled');
	   	}
	  }
	 });
}

function reSetInputt1(){
	var typename=$("input[name='flowTitle']").val();
	$("input[name='inputt11']").val(typename);
}
</script>

</BODY>
</HTML>
