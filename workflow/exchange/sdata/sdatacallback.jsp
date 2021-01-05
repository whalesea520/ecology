<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.StaticObj,weaver.workflow.exchange.ExchangeUtil"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="GetFormDetailInfo" class="weaver.workflow.automatic.GetFormDetailInfo" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("WFEC:SETTING", user))
{
	response.sendRedirect("/notice/noright.jsp");    	
	return;
}
boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
int tempsubcomid = -1 ;
if(isUseWfManageDetach){
    RecordSet.executeSql("select wfdftsubcomid from SystemSet");
    RecordSet.next();
    tempsubcomid = Util.getIntValue(RecordSet.getString(1),0);
}
int detachable = Util.getIntValue(request.getParameter("detachable"),0);
int operatelevel = -1  ;
if(isUseWfManageDetach){
    detachable = 1 ;
}
if(detachable==1){
    int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
    if(request.getParameter("subcompanyid")==null){
        subcompanyid=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),0);
    }
    if(subcompanyid == -1){
        subcompanyid = user.getUserSubCompany1();
    }
    operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),ExchangeUtil.WFEC_SETTING_RIGHTSTR,subcompanyid);
    if(operatelevel < 0 ){
        response.sendRedirect("/notice/noright.jsp");       
        return;
    }
}
%>
<%
String viewid = Util.null2String(request.getParameter("viewid"));
String workflowid = Util.null2String(request.getParameter("workFlowId"));
String operate = Util.null2String(request.getParameter("operate"));
int iscallback = 0;
int periodvalue = 0;
RecordSet.executeSql("select iscallback,periodvalue from wfec_indatawfset where id="+viewid);
if(RecordSet.next()){
	iscallback = Util.getIntValue(RecordSet.getString(1),0);
	periodvalue = Util.getIntValue(RecordSet.getString(2),0);
}
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
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body id='setbody'>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="sdataOperation.jsp">
<input type="hidden" name="operate" id="operate" value="cbsetting"/>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" id="submitData" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<input type="hidden" id="operate" name="operate" value="edit">
<input type="hidden" id="viewid" name="viewid" value="<%=viewid%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(84680,user.getLanguage()) %>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  		<wea:item><%=SystemEnv.getHtmlLabelName(84681,user.getLanguage()) %></wea:item>
			<wea:item>
				<INPUT type="checkbox" tzCheckbox="true" class=InputStyle id="iscallback" name="iscallback" value="1" <%if(iscallback==1){%> checked <%} %>>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(84682,user.getLanguage()) %></wea:item>
			<wea:item>
				<input type="text" size="10" class="inputstyle" style='width:60px!important;' id="periodvalue" name="periodvalue" value="<%=periodvalue %>" OnKeyPress="ItemCount_KeyPress()"> <%=SystemEnv.getHtmlLabelName(15049,user.getLanguage()) %>(<%=SystemEnv.getHtmlLabelName(84683,user.getLanguage()) %>)
			</wea:item>
			</wea:group>
	</wea:layout>
</form>
</body>
</html>
<script language="javascript">
function onBackUrl(url)
{
	jQuery($GetEle("setbody")).attr("onbeforeunload", "");
	document.location.href=url;
}

function submitData(){
	$GetEle("frmmain").submit();
}
</script>
