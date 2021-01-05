<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
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
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18097,user.getLanguage())+ SystemEnv.getHtmlLabelName(455,user.getLanguage());
String name="";
String memo="";
String status="";
String source="";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",GradeList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String mainid=Util.null2String(request.getParameter("id"));
rs.execute("select * from HrmPerformanceGrade where id="+mainid);
if (rs.next())
{
name=Util.null2String(rs.getString("gradeName"));
memo=Util.null2String(rs.getString("memo"));
status=Util.null2String(rs.getString("status"));
source=Util.null2String(rs.getString("source"));
}

rsd.execute("select * from HrmPerformanceGradeDetail where gradeId="+mainid);
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

<FORM name=resource id=resource action="GradeOperation.jsp" method=post>
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
          <TR class=spacing style="height:1px" > 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=30 size=30 
            name=gradeName  onchange='checkinput("gradeName","nameimage")' value="<%=name%>">
			<SPAN id=nameimage>
			<%if (name.equals("")){%>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			<%}%></SPAN>
            </TD>
          </TR>
        <TR style="height:1px" ><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD> <!--??-->
              <TD class=Field>
              <input class=inputstyle name=memo maxLength=50 size=50 value="<%=memo%>">
            </TD>
          </TR>
          <TR style="height:1px" ><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD><!--?? ??/??-->
             <TD class=Field> 
               <input class=inputstyle type="checkbox"  value="0" name="status" <%if (status.equals("0")) {%>checked <%}%>>
             <!-- ÊÇ·ñÆðÓÃ-->
            </TD>
            
          </TR>
          <TR style="height:1px" ><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></TD> <!--???-->
           <TD class=Field> 
              <select class=inputStyle id=source 
              name=source>
                <option value=0 <%if (source.equals("0")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18053,user.getLanguage())%></option><!--????-->
                <option value=1 <%if (source.equals("1")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18054,user.getLanguage())%></option><!--??????-->
                <option value=2 <%if (source.equals("2")) {%>selected <%}%>><%=SystemEnv.getHtmlLabelName(18055,user.getLanguage())%></option><!--?????-->
              </select>
            </TD>
          </TR>
   
          <TR style="height:1px" ><TD class=Line colSpan=2></TD></TR> 
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
  <COL width="30%">
  <COL width="50%">
  <COL width="20%">
 
  <TBODY>
   <TR class=title> 
            <TH colSpan=3><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing  style="height:1px" > 
            <TD class=line1 colSpan=3 style="padding:0"></TD>
          </TR>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(593,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></th>
  <th  align="right"><a href="GradeDetailAdd.jsp?mainid=<%=mainid%>&from=1"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a></th>
  </tr>
 <TR class=Line style="height:1px;"><TD colspan="3" style="padding:0;"></TD></TR> 
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
		<TD><a href="GradeDetailEdit.jsp?id=<%=rsd.getString("id")%>&mainid=<%=mainid%>&from=1"><%=Util.toScreen(rsd.getString("grade"),user.getLanguage())%></a></TD>
		<TD><%=rsd.getString("condition1")%>&lt;<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>&lt;=<%=rsd.getString("condition2")%></TD>
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
    if(check_form(document.resource,"gradeName"))
	{	
		document.resource.submit();
		enablemenu();
	}
}
function deldetail(ids,mainids)
{
if (isdel())
{
location.href="GradeOperation.jsp?type=detaildel&id="+ids+"&type=detaildel&mainid="+mainids+"&from=1";
}
}
</script>
</BODY>
</HTML>