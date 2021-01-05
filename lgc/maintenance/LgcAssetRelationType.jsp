<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(706,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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
<DIV style="display:none">
<%
if(HrmUserVarify.checkUserRight("LgcAssetRelationTypeAdd:Add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:location='LgcAssetRelationTypeAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON 
class=BtnNew id=AddNew accessKey=N onclick="location='LgcAssetRelationTypeAdd.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<%}
if(HrmUserVarify.checkUserRight("LgcAssetRelationType:Log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =46',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnLog accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =46'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
<%}
%> 
</DIV>
<TABLE class=ListStyle cellspacing=1>
  <THEAD>
  <COLGROUP>
  <COL width="40%" align=left>
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TR class=header>
    <TH colspan=4><%=SystemEnv.getHtmlLabelName(706,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
    <TH>名称</TH>
	<TH>类型</TH>
	<TH>购物建议</TH>
	<TH>合同限制</TH>
	</TR>
    <TR class=Line><TD colSpan=4></TD></TR>
    </THEAD>
<%
int i= 0;
RecordSet.executeProc("LgcAssetRelationType_Select","");
while(RecordSet.next()) {
	String id = RecordSet.getString("id") ;
	String typename = Util.toScreen(RecordSet.getString("typename"),user.getLanguage()) ;
	String typekind = Util.null2String(RecordSet.getString("typekind")) ;
	String shopadvice = Util.null2String(RecordSet.getString("shopadvice")) ;
	String contractlimit = Util.null2String(RecordSet.getString("contractlimit")) ;
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
    <TD><A 
      href="LgcAssetRelationTypeEdit.jsp?id=<%=id%>"><%=typename%></A></TD>
    <TD>
	<% if(typekind.equals("1")) {%>强制
	<%}else if(typekind.equals("2")) {%>必选其一
	<%}else if(typekind.equals("3")) {%>可选
	<%}else if(typekind.equals("4")) {%>可选其一
	<%}else if(typekind.equals("5")) {%>排除 <%}%>
	</TD>
	<TD><% if(shopadvice.equals("1")) {%><IMG src="/images/BacoCheck_wev8.gif" border=0><%}%></TD>
	<TD><% if(contractlimit.equals("1")) {%><IMG src="/images/BacoCheck_wev8.gif" border=0><%}%></TD>
	</TR>
<%}%>
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
