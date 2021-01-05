<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : " + SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="1";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>

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
		<td valign="top"><table width=100% class=ViewForm>


<TABLE class=ListStyle cellspacing=1>
	<TR class=header>
		<TH colSpan=2>资产名</TH>
	</TR>
<%
int i=0;
while(AssetComInfo.next()){
	String assetid   = AssetComInfo.getAssetId();
	String assetmark = AssetComInfo.getAssetMark();
	String assetname = AssetComInfo.getAssetName();
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<TD><%=assetmark%></TD>
	<TD><A HREF="LgcAsset.jsp?paraid=<%=assetid%>"><%=assetname%></A></TD>
</TR>
<%}
%>
</TABLE>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
