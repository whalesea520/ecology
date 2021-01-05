
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.system.*"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="PluginLicense" class="weaver.license.PluginLicenseForInterface" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "Mobile " + SystemEnv.getHtmlLabelName(18014,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean canEdit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) ;

String type=request.getParameter("type");  //type 表示插件种类  mobile代表手机版 

Map license = PluginLicense.getLicenseInfo(type);

String companyName = (String)license.get("companyname");
String licenseCode = (String)license.get("licensecode");
String hrmNum = (String)license.get("hrmnum");
int licensenum = Util.getIntValue((String)license.get("usercount"),0); //已使用的license数量
int unusedlice = Util.getIntValue(hrmNum)-licensenum ;//license数量
unusedlice = (unusedlice<0)?0:unusedlice;
if(hrmNum.equals("9999"))hrmNum=SystemEnv.getHtmlLabelName(18637,user.getLanguage());
String expireDate = (String)license.get("expiredate");
if(expireDate.equals("9999-99-99"))expireDate=SystemEnv.getHtmlLabelName(18638,user.getLanguage());
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canEdit){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18640,user.getLanguage())+",javascript:location='/system/InPluginLicense.jsp?type="+type+"',_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id=weaver name=frmmain method=post style="MARGIN-TOP: 0px">
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
			<table class="ViewForm">
				<COLGROUP>
				<COL width="20%">
				<COL width="80%">
				<TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18014,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(16898,user.getLanguage())%></td>
					<td class=Field><%=Util.toScreen(companyName,user.getLanguage())%></td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(18639,user.getLanguage())%></td>
					<td class=Field><%=Util.toScreen(licenseCode,user.getLanguage())%></td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(15029,user.getLanguage())%></td>
					<td class=Field><%=Util.toScreen(hrmNum,user.getLanguage())%></td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
					<td class=Field><%=Util.toScreen(expireDate,user.getLanguage())%></td>
				</tr>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(21519,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<%if(hrmNum.equals("9999")){%>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(21522,user.getLanguage())%></td>
					<td class=Field><%=Util.toScreen(hrmNum,user.getLanguage())%></td>
				</tr>
				<%}else{%>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(21522,user.getLanguage())%></td>
					<td class=Field><%=licensenum%></td>
				</tr>
				<%}%>
				<%if(hrmNum.equals("9999")){%>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(21523,user.getLanguage())%></td>
					<td class=Field><%=Util.toScreen(hrmNum,user.getLanguage())%></td>
				</tr>
				<%}else{%>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(21523,user.getLanguage())%></td>
					<td class=Field><%=unusedlice%></td>
				</tr>
				<%}%>
				</TBODY>
			</table>
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
</form>
</BODY>
</HTML>