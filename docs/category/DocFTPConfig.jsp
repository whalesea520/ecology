
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 


<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(20518,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%
if(HrmUserVarify.checkUserRight("DocFTPConfigAdd:Add", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='DocFTPConfigAdd.jsp',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
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

 <TABLE class=liststyle cellspacing=1  >
  <COLGROUP>
  <COL width="10%">
  <COL width="35%">
  <COL width="40%">
  <COL width="15%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></th>
  </tr>
  <tr class=Line><th></th><th></th><th ></th></tr>
<%
	int id=0;
    String FTPConfigName=null;
	String FTPConfigDesc=null;
	String showOrder=null;

    RecordSet.executeSql("SELECT * from DocFTPConfig order by showOrder asc,id asc");

    boolean isLight = false;
	while(RecordSet.next()){
		id=Util.getIntValue(RecordSet.getString("id"));
		FTPConfigName=Util.null2String(RecordSet.getString("FTPConfigName"));
		FTPConfigDesc=Util.null2String(RecordSet.getString("FTPConfigDesc"));
		showOrder=Util.null2String(RecordSet.getString("showOrder"));
		if(isLight = !isLight)
		{%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>

		<TD>
		    <a href="DocFTPConfigDsp.jsp?id=<%=id%>"><%=id%></a>
		</TD>
		<TD>
		    <a href="DocFTPConfigDsp.jsp?id=<%=id%>"><%=FTPConfigName%></a>
		</TD>
		<TD>
			<%=FTPConfigDesc%>
		</TD>
		<TD>
			<%=showOrder%>
		</TD>
	</TR>
<%
	}
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

 </BODY></HTML>
