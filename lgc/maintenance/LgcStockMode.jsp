<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(712,user.getLanguage());
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
		<td valign="top"><DIV style="display:none">
<%
if(HrmUserVarify.checkUserRight("LgcStockModeAdd:Add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:location='LgcStockModeAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON 
class=BtnNew id=AddNew accessKey=N onclick="location='LgcStockModeAdd.jsp'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<%}
if(HrmUserVarify.checkUserRight("LgcStockMode:Log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =50',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=BtnLog accessKey=L name=button2 onclick="location='/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem =50'"><U>L</U>-<%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></BUTTON>
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
    <TH colspan=4 ><%=SystemEnv.getHtmlLabelName(712,user.getLanguage())%></TH>
 </TR>
<TR class=header>
    <TH>名称</TH>
	<TH>类型</TH>
	<TH>活跃</TH>
	</TR>
<TR class=Line><TD colSpan=3></TD></TR>
    </THEAD>
<%
int i= 0;
RecordSet.executeProc("LgcStockMode_Select","");
while(RecordSet.next()) {
	String id = RecordSet.getString("id") ;
	String modename = Util.toScreen(RecordSet.getString("modename"),user.getLanguage()) ;
	String modetype = Util.null2String(RecordSet.getString("modetype")) ;
	String modestatus = Util.null2String(RecordSet.getString("modestatus")) ;
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
      href="LgcStockModeEdit.jsp?id=<%=id%>"><%=modename%></A></TD>
    <TD>
	<% if(modetype.equals("1")) {%>入库
	<%}else if(modetype.equals("2")) {%>出库 <%}%>
	</TD>
	<TD><% if(modestatus.equals("1") || modestatus.equals("2")) {%><IMG src="/images/BacoCheck_wev8.gif" border=0><%}%></TD>
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
