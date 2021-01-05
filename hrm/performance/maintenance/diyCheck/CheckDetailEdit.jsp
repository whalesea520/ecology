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
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18097,user.getLanguage());
String id=request.getParameter("id");
String mainid=request.getParameter("mainid");
String needfav ="1";
String needhelp ="";
String grade="";
String condition1="";
String condition2="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
session.setAttribute("from",Util.null2String(request.getParameter("from")));
RecordSet.execute("select * from HrmPerformanceGradeDetail where Id="+id);
if (RecordSet.next())
{
grade=Util.null2String(RecordSet.getString("grade"));
condition1=Util.null2String(RecordSet.getString("condition1"));
condition2=Util.null2String(RecordSet.getString("condition2"));
}
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
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM name=resource id=resource action="GradeOperation.jsp" method=post>
<input type=hidden name=edittype value=detail>
<input type=hidden name=mainid value=<%=mainid%>>
<input type=hidden name=id value=<%=id%>>
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
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(593,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=30 size=30 
            name=grade   onchange='checkinput("grade","nameimage")' value="<%=grade%>" >
			<SPAN id=nameimage>
			<%if (grade.equals(""))
			{%>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			<%}%>
			</SPAN>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></TD> 
              <TD class=Field>
              <input class=inputstyle name=condition1 value="<%=condition1%>" onchange='checknumber("condition1")'>&lt;<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>&lt;=
              <input class=inputstyle name=condition2 value="<%=condition2%>" onchange='checknumber("condition2")'>
            </TD>
          </TR>
   
          <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
  </FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.resource,"grade,condition1,condition2"))
	{	if (change2input(document.resource.condition1.value,document.resource.condition2.value))
	     {
	     alert("<%=SystemEnv.getHtmlNoteName(18098,user.getLanguage())%>");
	     return;
	     }
		document.resource.submit();
		enablemenu();
	}
}
</script>

</BODY>
</HTML>