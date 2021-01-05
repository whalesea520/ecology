<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
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
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18112,user.getLanguage());
String name="";
String sort="";
String headers="";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",PlanList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String mainid=Util.null2String(request.getParameter("id"));
rs.execute("select * from HrmPerformancePlanKind where id="+mainid);
if (rs.next())
{
name=Util.null2String(rs.getString("planName"));
sort=Util.null2String(rs.getString("sort"));
headers=Util.null2String(rs.getString("headers"));

}

rsd.execute("select * from HrmPerformancePlanKindDetail where planId="+mainid+" order by sort");
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

<FORM name=resource id=resource action="PlanOperation.jsp" method=post>
<input type=hidden name=edittype value=basic>
<input type=hidden name=mainid value=<%=mainid%>>
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="50%"> 
    <COL width="50%"> 
    <TBODY> 
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=70%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing  style="height:1px;"> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=30 size=30 
            name=headers  onchange='checkinput("headers","headersimage")' value=<%=headers%>>
			<SPAN id=headersimage>
			<%if (headers.equals("")) {%> <IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN>
            </TD>
          </TR>
        <TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR>
            <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=30 size=30 
            name=planName  onchange='checkinput("planName","nameimage")' value=<%=name%> >
			<SPAN id=nameimage>
			<%if (name.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN>
            </TD>
          </TR>
        <TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD> 
              <TD class=Field>
              <input class=inputstyle name=sort value="<%=sort%>" maxLength=2 size=2 onchange='checknumber("sort")'>
            
            </TD>
          </TR>
          <TR  style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
             </TBODY> 
        </TABLE>
      </TD>
  </FORM>
</td>
</tr>
<tr></tr><td valign="top">
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
            <TH colSpan=4><%=SystemEnv.getHtmlLabelName(18078,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing  style="height:1px;"> 
            <TD class=line1 colSpan=4 style="padding:0;"></TD>
          </TR>
   <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></th>
  <th  align="left"><a href="PlanDetailAdd.jsp?mainid=<%=mainid%>&from=1"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a></th>
  </tr>
 <TR class=Line><TD colspan="4" style="padding:0;"></TD></TR> 
<%
boolean isLight = false;
	while(rsd.next())
	{
		if(isLight = !isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
		<TD><%=rsd.getString("headers")%></TD>
		<TD><a href="PlanDetailEdit.jsp?id=<%=rsd.getString("id")%>&mainid=<%=mainid%>&from=1"><%=Util.toScreen(rsd.getString("planName"),user.getLanguage())%></a></TD>
		<TD><%=rsd.getString("sort")%></TD>
		<TD><a  onclick="deldetail(<%=rsd.getString("id")%>,<%=mainid%>)" href="#"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>

	</TR>
<%
	}
%>
 </TABLE>
</td>
</tr>
</TABLE>

</td></tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>



<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.resource,"headers,planName"))
	{	
		document.resource.submit();
		enablemenu();
	}
}
function deldetail(ids,mainids)
{
if (isdel())
{
location.href="PlanOperation.jsp?type=detaildel&id="+ids+"&type=detaildel&mainid="+mainids+"&from=1";
}
}
</script>
</BODY>
</HTML>