<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,
                 java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
	String type = Util.null2String(request.getParameter("type"));
	String msg="微信发送失败";
	if("success".equals(type)){
		msg="微信已成功加入发送队列";
	}
    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(32904, user.getLanguage());//微信提醒(QC:98106)
    String needfav = "1";
    String needhelp = "";
	int noback = Util.getIntValue(request.getParameter("noback"), 0);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(noback != 1){
    RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/wechat/sendWechat.jsp,_self} ";
    RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

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

			<DIV id=wait style="filter:alpha(opacity=30); height:100%; width:100%">
			<TABLE width="100%" height="100%">
				<TR><TD align=center style="font-size: 36pt;"><%=msg %></TD></TR>
			</TABLE>
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

</BODY>
</HTML>
