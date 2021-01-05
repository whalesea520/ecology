
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17088,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    int parentid = Util.getIntValue(request.getParameter("parentid"),0);
    RecordSet.executeSql("select * from cus_treeform where scope='HrmCustomFieldByInfoType' and parentid="+parentid +" order by scopeorder asc");
%>

<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",AddHrmCustomField.jsp?parentid="+parentid+",_self}" ;
//RCMenuHeight += RCMenuHeightStep ;
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr style="height:1px;">
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">


<TABLE class=liststyle cellspacing=1  >
  <COLGROUP>
  <COL width="100%">
  <%--<COL width="30%">--%>
  <%--<COL width="60%">--%>
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(17549,user.getLanguage())%></th>
  <%--<th>类型</th>--%>
  <%--<th>顺序</th>--%>
  </tr>
<%
    boolean isLight = false;
	while(RecordSet.next()){
		if(isLight = !isLight){%>
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="EditHrmCustomField.jsp?id=<%=RecordSet.getString("id")%>"><%=RecordSet.getString("formlabel")%></a></TD>
		<%--<TD><%=RecordSet.getString("viewtype").equals("0")?SystemEnv.getHtmlLabelName(83589,user.getLanguage():SystemEnv.getHtmlLabelName(83655,user.getLanguage()%></TD>--%>
		<%--<TD><%=Util.getIntValue(RecordSet.getString("scopeorder"),0)%></TD>--%>
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
	<td height="0" colspan="3"></td>
</tr>
</table>

</BODY>
</HTML>
