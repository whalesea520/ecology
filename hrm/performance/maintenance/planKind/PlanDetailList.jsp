<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("PlanKindInfo:Maintenance",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18078,user.getLanguage());
String id=request.getParameter("mainid");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",PlanList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RecordSet.execute("select * from HrmPerformancePlanKindDetail where planId="+id+" order by sort ");
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
 <COL width="15%">
  <COL width="45%">
  <COL width="30%">
  <COL width="10%">
  <TBODY>
   <TR class=title> 
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(18113,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=4></TD>
          </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></th>
  <th  align="left"><a href="PlanDetailAdd.jsp?mainid=<%=id%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a></th>
  </tr>
 <TR class=Line><TD colspan="4" ></TD></TR> 
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
	   <TD><%=RecordSet.getString("headers")%></TD>
		<TD><a href="PlanDetailEdit.jsp?id=<%=RecordSet.getString("id")%>&mainid=<%=id%>"><%=Util.toScreen(RecordSet.getString("planName"),user.getLanguage())%></a></TD>
		<TD><%=RecordSet.getString("sort")%></TD>
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
location.href="PlanOperation.jsp?id="+ids+"&type=detaildel&mainid="+mainids;
}
}
</script>
</BODY>
</HTML>