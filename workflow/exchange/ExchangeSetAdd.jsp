<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.exchange.ExchangeUtil"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
// if(!HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user)){
//    		response.sendRedirect("/notice/noright.jsp");
//    		return;
//	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String dialog = Util.null2String(request.getParameter("dialog"));
String isclose = Util.null2String(request.getParameter("isclose"));

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82659,user.getLanguage());
String needfav ="1";
String needhelp ="";

String wfid = Util.null2String(request.getParameter("wfid"));
String wftypeid = Util.null2String(request.getParameter("wftypeid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
boolean isUseWfManageDetach = Util.null2String(request.getParameter("isUseWfManageDetach")).equals("true")?true:false;
String rightstr = ExchangeUtil.WFEC_SETTING_RIGHTSTR ;
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if("1".equals(dialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:submitData1(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep;
}%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%}%>
<FORM id="weaver" name="frmMain" action="ExchangeSetOperation.jsp" method=post>
<input type="hidden" name="wfid" id="wfid" value="<%=wfid  %>" />
<input type="hidden" name="wftypeid" id="wftypeid" value="<%=wftypeid %>" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage()) %>" id="zd_btn_submit"  class="e8_btn_top" onclick="submitData1()">
	    	<!--
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()">				
			-->
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(82504,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<wea:required id="titleimage" required="true">
	    		<input type="text" size="30" class="Inputstyle" name="title" onchange='checkinput("title","titleimage")' style="width:60%;">
	    	</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18077,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="workflowid" viewType="0" hasBrowser="true" hasAdd="false" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp?isTemplate=0&iswfec=1" 
					isMustInput="2" isSingle="true" hasInput="true"
 					completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0&iswfec=1" 
 					width="300px" browserValue="" browserSpanValue="" /> 
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(82505,user.getLanguage())%></wea:item>
		<wea:item >
			<wea:required id="typeimage" required="true">
			<select name="type" onchange='checkinput("type","typeimage")'>
				<option value=""></option>
				<option value="0"><%=SystemEnv.getHtmlLabelName(84587,user.getLanguage())%></option>
				<option value="1"><%=SystemEnv.getHtmlLabelName(84586,user.getLanguage())%></option>
			</select>
			</wea:required>
		</wea:item>
		<%if(isUseWfManageDetach){ %>
		<wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="subcompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
                  browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr="+rightstr+"&isedit=1" %>' 
                  isMustInput="2" 
                  isSingle="true" 
                  hasInput="true"
                  completeUrl="/data.jsp?type=164"  width="300px" 
                  browserValue='<%=String.valueOf(subcompanyid)%>' 
                  browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid))%>'/> 
		</wea:item>
		<%} %>
    </wea:group>
</wea:layout>
<input type="hidden" id="operation" name="operation" value="add" />
<input type="hidden" id="dialog" name="dialog" value="<%=dialog%>" />
<input type="hidden" name="subcompanyid" id="subcompanyid" value="0" />
<input type="hidden" id="tosetting" name="tosetting" value="0" />
 </form>
 <%if("1".equals(dialog)){ %>
 <jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
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
<%} %>
 <script language="javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);
function btn_cancle(){
	parentWin.closeDialog();
}

if("<%=isclose%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/workflow/exchange/managelist.jsp?reflush=1&wftypeid=<%=wftypeid%>";
	parentWin.closeDialog();	
}
	
function submitData()
{
	var ckfds = 'title,workflowid,type';
	<%
	if(isUseWfManageDetach){
	%>
		ckfds += ",subcompanyid"
	<%	
	}
	%>
	if (check_form(weaver,ckfds)){
		if("<%=dialog%>"!="1"){
			enableAllmenu();
		}
		weaver.submit();
    }
}

function submitData1(){
	jQuery("#tosetting").val("1");
	submitData();
}
function doback(){
	if("<%=dialog%>"!="1"){
		enableAllmenu();
	}
    location.href="/workflow/exchange/managelist.jsp";
}

$("#zd_btn_submit").hover(function(){
	$(this).addClass("zd_btn_submit_hover");
},function(){
	$(this).removeClass("zd_btn_submit_hover");
});

$("#zd_btn_cancle").hover(function(){
	$(this).addClass("zd_btn_cancleHover");
},function(){
	$(this).removeClass("zd_btn_cancleHover");
});
</script>
</BODY></HTML>
