<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="workflowcominfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
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
String changetype = Util.null2String(request.getParameter("changetype"));
String tosetting = Util.null2String(request.getParameter("tosetting"));
String id = Util.null2String(request.getParameter("id"));

String wftypeid = Util.null2String(request.getParameter("wftypeid"));
String wfid = Util.null2String(request.getParameter("wfid"));
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"));

String tempwhere = "wfid="+wfid+"&wftypeid="+wftypeid+"&subcompanyid="+subcompanyid ;

String _title = "";
String _type = "";
String _wfid = "";
String _status = "";
String _subcomid = "";

if(!id.equals("")){
	rs.executeSql("select * from wfex_view where type="+changetype+" and id="+id);
	if(rs.next()){
		_title = rs.getString("name");
		_type = rs.getString("type");
		_wfid = rs.getString("workflowid");
		_subcomid = rs.getString("subcompanyid");
	}
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82506,user.getLanguage());
String needfav ="1";
String needhelp ="";
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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
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
<input type="hidden" name="changetype" id="changetype" value="<%=changetype %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage()) %>" id="zd_btn_submit"  class="e8_btn_top" onclick="submitData1()">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()">				
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(82504,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<wea:required id="titleimage">
	    		<input type="text" size="30" class="Inputstyle" value="<%=_title %>" name="title" onchange='checkinput("title","titleimage")' style="width:60%;">
	    	</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18077,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="workflowid" viewType="0" hasBrowser="true" hasAdd="false" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser_frm.jsp" 
					isMustInput="2" isSingle="true" hasInput="true"
 					completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0" 
 					width="300px" browserValue='<%=_wfid %>' browserSpanValue='<%=workflowcominfo.getWorkflowname(_wfid) %>' /> 
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(82505,user.getLanguage())%></wea:item>
		<wea:item >
			<wea:required id="typeimage">
			<select name="type_sel" onchange='checkinput("type","typeimage")' disabled="disabled">
				<option value=""></option>
				<option value="0" <% if(_type.equals("0")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(84587, user.getLanguage())%></option>
				<option value="1" <% if(_type.equals("1")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(84586, user.getLanguage())%></option>
			</select>
			</wea:required>
		</wea:item>
    </wea:group>
</wea:layout>
<input type="hidden" name="operation" value="edit" />
<input type="hidden" name="dialog" value="<%=dialog%>" />
<input type="hidden" name="id" id="id" value="<%=id %>" />
<input type="hidden" name="subcompanyid" id="subcompanyid" value="<%=_subcomid %>" />
<input type="hidden" id="tosetting" name="tosetting" value="0" />
<input type="hidden" id="type" name="type" value="<%=_type %>" />
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
	parentWin.location="/workflow/exchange/managelist.jsp";
	parentWin.closeDialog();	
}
if("<%=tosetting%>"==1){
	 
	 var dialog = parent.getDialog(window);
	 var parentWin = parent.getParentWindow(window);
	 parentWin.location="/workflow/exchange/managelist.jsp?1=1&<%=tempwhere %>";
	 newDialog(<%=id%>,<%=changetype%>);
	 parentWin.closeDialog()
	 
}
function newDialog(id,type){
	var title = "<%=SystemEnv.getHtmlLabelName(84606,user.getLanguage())%>";
	var url = "";
	if(type==0){
		url="/workflow/exchange/ExchangeSetTab.jsp?dialog=1&mainid="+id;
	}else{
		url="/workflow/exchange/ExchangeSetTab1.jsp?dialog=1&mainid="+id;
	}
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = jQuery(top.window).width()-330;
	diag_vote.Height = jQuery(top.window).height()-330;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.isIframe=false;
	diag_vote.show();
}
	
function submitData()
{
	if (check_form(weaver,'title,workflowid,type')){
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
