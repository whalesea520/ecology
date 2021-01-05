<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("CptCapitalAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
String urltarget=Util.null2String(request.getParameter("urltarget"));
if( urltarget.equals("")) urltarget = "/cpt/capital/CptCapitalUse.jsp" ;
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6050,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%//@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
/*RCMenu += "{"+SystemEnv.getHtmlLabelName(886,user.getLanguage())+",javascript:doSubmit(1),CptManageIframe} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(883,user.getLanguage())+",javascript:doSubmit(2),CptManageIframe} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6051,user.getLanguage())+",javascript:doSubmit(4),CptManageIframe} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6054,user.getLanguage())+",javascript:doSubmit(5),CptManageIframe} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6052,user.getLanguage())+",javascript:doSubmit(6),CptManageIframe} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6053,user.getLanguage())+",javascript:doSubmit(7),CptManageIframe} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(6055,user.getLanguage())+",javascript:doSubmit(8),CptManageIframe} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15305,user.getLanguage())+",javascript:doSubmit(9),CptManageIframe} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15306,user.getLanguage())+",javascript:doSubmit(12),CptManageIframe} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15307,user.getLanguage())+",javascript:doSubmit(11),CptManageIframe} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;*/
%>
<%//@ include file="/systeminfo/RightClickMenu.jsp" %>
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

			<FORM name=frmain id=frmain method=post action="/cpt/capital/CptCapitalManage.jsp">
			<input type="hidden" name="urltarget">
			<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
					<iframe NAME=CptManageIframe BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE height=100% width=100% SCROLLING=AUTO SRC="<%=urltarget%>"></iframe>
					</td>
				</tr>
			</table>
			</FORM>

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

<script language=javascript>
function doSubmit(getValue)
{
  if (getValue=="1") document.frmain.urltarget.value="/cpt/capital/CptCapitalUse.jsp";//资产领用
  if (getValue=="2") document.frmain.urltarget.value="/cpt/capital/CptCapitalMove.jsp";//资产调拨
  if (getValue=="3") document.frmain.urltarget.value="/workflow/request/RequestType.jsp";//资产申购
  if (getValue=="4") document.frmain.urltarget.value="/cpt/capital/CptCapitalLend.jsp";//资产借用
  if (getValue=="5") document.frmain.urltarget.value="/cpt/capital/CptCapitalLoss.jsp";//资产减损
  if (getValue=="6") document.frmain.urltarget.value="/cpt/capital/CptCapitalDiscard.jsp";//资产报废
  if (getValue=="7") document.frmain.urltarget.value="/cpt/capital/CptCapitalMend.jsp";//资产维修
  if (getValue=="8") document.frmain.urltarget.value="/cpt/capital/CptCapitalModifyOperation.jsp?isdata=2";//资产变更
  if (getValue=="9") document.frmain.urltarget.value="/cpt/capital/CptCapitalBack.jsp";//资产退回
  if (getValue=="10") document.frmain.urltarget.value="/cpt/report/CptRpCapitalCheckStock.jsp";//资产盘点
  if (getValue=="11") document.frmain.urltarget.value="/cpt/search/CptInstockSearch.jsp";//资产验收
  if (getValue=="12") document.frmain.urltarget.value="/cpt/capital/CptCapitalInstock1.jsp";//资产入库
  document.frmain.submit();
}
</script>
<script language="javascript">
function back()
{
	window.history.back(-1);
}
</script>
</BODY>
</HTML>
