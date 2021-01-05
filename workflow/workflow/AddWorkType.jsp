<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16579,user.getLanguage());
String needfav ="1";
String needhelp ="";
String dialog = Util.null2String(request.getParameter("dialog"));
String isclose = Util.null2String(request.getParameter("isclose"));
%>
<body scroll="no">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if("1".equals(dialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btn_cancle(),_top} " ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_top} " ;
}
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%}%>
<FORM id=weaver action="WorkTypeOperation.jsp" method=post style="width:100%;">
  <input type="hidden" name="method" value="add">
  <input type="hidden" name="dialog" value="<%=dialog%>">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
		    	<!--<input type="button" value="取消" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()">  -->				
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>  
		<wea:layout type="twoCol">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			    <wea:item>
			    	<wea:required id="typeimage" required="true">
			    		<input class=Inputstyle maxLength=50 size=50 name="type" onchange='checkinput("type","typeimage")'>
			    	</wea:required>			    	
			    </wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<wea:required id="descimage" required="true" value="">
			    		<input class=Inputstyle maxLength=150 size=50 name="desc" onchange='checkinput("desc","descimage")' value="">
			    	</wea:required>
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		    	<wea:item><input class=Inputstyle maxLength=3 size=50 name="dsporder" value="0" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this)"></wea:item>
		    </wea:group>
		</wea:layout>		
<iframe id="checkType" src="" style="display: none"></iframe>
</FORM>
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
if("<%=dialog%>"==1){	
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	function btn_cancle(){
		parentWin.closeDialog();
	}
}
if("<%=isclose%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/workflow/workflow/ListWorkTypeTab.jsp";
	parentWin.closeDialog();	
}
function submitData()
{
	if (check_form(weaver,'type,desc')){
	    //通过iframe验证类型名称是否重复
		document.getElementById("checkType").src="/workflow/workflow/WorkTypeOperation.jsp?method=valRepeat&type="+myescapecode(document.all("type").value);
    }
}
function onReturn(){
	location="/workflow/workflow/ListWorkTypeTab.jsp";
}

//类型名称已经存在
function typeExist(){
    alert("<%=SystemEnv.getHtmlLabelName(24256,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>");
    return ;
}

//提交表单
function submitForm(){
    weaver.submit();
}
</script>
</BODY>
</HTML>
