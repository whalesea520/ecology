
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
int parentid = Util.getIntValue(request.getParameter("parentid"),0);
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.itemchange=true;
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17088,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%


RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	<FORM id=weaver name=weaver action="HrmCustomFieldOperation.jsp" method=post>
		<input type="hidden" name="method" value="addFieldTree"> 
		<input type="hidden" name="parentid" value="<%=parentid%>">
		<input type=hidden name="viewtype" value="1">
		<input type="hidden" value="1" name="isdialog">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(17549, user.getLanguage())%></wea:item>
		<wea:item><INPUT class=Inputstyle maxLength=50 size=20 name="formlabel" onchange='checkinput("formlabel","formlabelimage")'><SPAN id=formlabelimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle> </SPAN></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></wea:item>
		<wea:item><INPUT class=Inputstyle maxLength=3 size=20 name="scopeorder" value="0" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'></wea:item>
	</wea:group>
</wea:layout>
	 <%if("1".equals(isDialog)){ %>
	 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
		<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
		</wea:item>
	</wea:group>
</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
	</FORM>
	<script language="javascript">
		function submitData() {
			if(check_form(weaver,'formlabel')){
				weaver.submit();
				}
		}
	</script>
</BODY>
</HTML>