
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
int parentid = Util.getIntValue(request.getParameter("parentid"),0);
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
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
	<FORM id=weaver action="HrmCustomFieldOperation.jsp" method=post>
		<input type="hidden" name="method" value="add"> <input
			type="hidden" name="parentid" value="<%=parentid%>">

		<table width=100% height=100% border="0" cellspacing="0"
			cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">

								<TABLE class="viewform">
									<COLGROUP>
										<COL width="100%">
									<TBODY>
										<TR>
											<TD vAlign=top>
												<TABLE class="viewform">
													<COLGROUP>
														<COL width="20%">
														<COL width="80%">
													<TBODY>
														<TR class="Title">
															<TH><%=SystemEnv.getHtmlLabelName(61, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87, user.getLanguage())%></TH>
														</TR>
														<TR class="Spacing" style="height:1px;">
															<TD class="Line1" colSpan=2></TD>
														</TR>
														<TR>
															<TD><%=SystemEnv.getHtmlLabelName(17549, user.getLanguage())%></TD>
															<TD class=Field><INPUT class=Inputstyle maxLength=50
																size=20 name="formlabel"
																onchange='checkinput("formlabel","formlabelimage")'><SPAN
																id=formlabelimage><IMG
																	src="/images/BacoError_wev8.gif" align=absMiddle> </SPAN></TD>
														</TR>
														<TR class="Spacing" style="height:1px;">
															<TD class="Line" colSpan=2></TD>
														</TR>
														<input type=hidden name="viewtype" value="1">
														<TR>
															<TD><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></TD>
															<TD class=Field><INPUT class=Inputstyle maxLength=3
																size=20 name="scopeorder" value="0"
																onKeyPress="ItemNum_KeyPress()"
																onBlur='checknumber1(this)'></TD>
														</TR>
														<TR class="Spacing" style="height:1px;">
															<TD class="Line" colSpan=2></TD>
														</TR>
													</TBODY>
												</TABLE></TD>
										</TR>
									</TBODY>
								</TABLE>
	</FORM>
	 <%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;" colspan="3">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitData();">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
	    	<input type="hidden" value="1" name="isdialog">
	    </td></tr>
	</table>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
	<script language="javascript">
		function submitData() {
				weaver.submit();
		}
	</script>
</BODY>
</HTML>
