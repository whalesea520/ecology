<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("CheckGradeInfo:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18097,user.getLanguage());
String id=request.getParameter("mainid");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",GradeList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RecordSet.execute("select * from HrmPerformanceGradeDetail where gradeId="+id);
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="50%">
  <COL width="20%">
 
  <TBODY>
   <TR class=title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=3></TD>
          </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(593,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></th>
  <th  align="left"><a href="GradeDetailAdd.jsp?mainid=<%=id%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a></th>
  </tr>
 <TR class=Line><TD colspan="3" ></TD></TR> 
<%
boolean isLight = false;
	while(RecordSet.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><a href="GradeDetailEdit.jsp?id=<%=RecordSet.getString("id")%>&mainid=<%=id%>"><%=Util.toScreen(RecordSet.getString("grade"),user.getLanguage())%></a></TD>
		<TD><%=RecordSet.getString("condition1")%>&lt;<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>&lt;=<%=RecordSet.getString("condition2")%></TD>
		<TD><a  onclick="deldetail(<%=RecordSet.getString("id")%>,<%=id%>)" href="#"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>

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
<script>
function deldetail(ids,mainids)
{
if (isdel())
{
location.href="GradeOperation.jsp?id="+ids+"&type=detaildel&mainid="+mainids;
}
}
</script>
</BODY>
</HTML>