<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %> 
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<% if(!HrmUserVarify.checkUserRight("TargetTypeInfo:Maintenance",user)) {
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
String titlename = SystemEnv.getHtmlLabelName(86,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18091,user.getLanguage());
String mainid=Util.null2String(request.getParameter("mainid")); //主表id
String id=Util.null2String(request.getParameter("id"));  //std表id
String tid=Util.null2String(request.getParameter("tid")); //detail表id
String needfav ="1";
String needhelp ="";
String stdName="";
String point="";
rs.execute("select * from HrmPerformanceTargetStd where id="+id);
if (rs.next())
{
stdName=rs.getString("stdName");
point=rs.getString("point");

}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",TargetDetailEdit.jsp?id="+tid+"&mainid="+mainid+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
session.setAttribute("from",Util.null2String(request.getParameter("from")));

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
<FORM name=resource id=resource action="TargetTypeOperation.jsp" method=post>
<input type=hidden name=edittype value=std>
<input type=hidden name=mainid value=<%=mainid%> >
<input type=hidden name=id value=<%=id%> >
<input type=hidden name=tid value=<%=tid%> >
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
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(18091,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18092,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=50 size=50 
            name=stdName  value="<%=Util.toScreen(stdName,user.getLanguage())%>" onchange='checkinput("stdName","nameimage")'>
			<SPAN id=nameimage>
			<%if (stdName.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN>
            </TD>
          </TR>
        <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18093,user.getLanguage())%></TD> 
              <TD class=Field>
              <input class=inputstyle value="<%=Util.toScreen(point,user.getLanguage())%>" name=point maxLength=3 size=3 onchange='checkinput("point","conimage1");checknumber("point")'>
             <SPAN id=conimage1> <%if (point.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></SPAN>
            </TD>
          </TR>
   
          <TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
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
    if(check_form(document.resource,"stdName,point"))
	{	
		document.resource.submit();
		enablemenu();
	}
}
</script>

</BODY>
</HTML>