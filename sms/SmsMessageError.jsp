<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,
                 java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
</script>
</HEAD>
<%
    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(2220, user.getLanguage());
    String needfav = "1";
    String needhelp = "";
	int noback = Util.getIntValue(request.getParameter("noback"), 0);
	String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(noback != 1 && isDialog.length()==0){
    RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/sms/SmsMessageEdit.jsp,_self} ";
    RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<DIV id=wait style="height:100%; width:100%">
				<div id="showDiv" style="width:400px;height:300px;position:absolute;left:50%;top:50%;margin:-150px 0 0 -200px;">
					<div style="float:left;margin-left:30px;"><img width="127px" height="127px" src='images/sms_error_wev8.png'></div>
					<div style="float:left;color:#242424;line-height: 127px;font-size: 18pt;"><%=SystemEnv.getHtmlLabelName(24544, user.getLanguage())%></div>
				</div>	
			</DIV>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</FORM>
 <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
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
</BODY>
</HTML>