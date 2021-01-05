<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="resource" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%// if (!Rights.getRights("","","","")){//х╗очеп╤о
	//response.sendRedirect("/notice/noright.jsp") ;
	//return ;
  // }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<STYLE>
	.vis1	{ visibility:"visible" }
	.vis2	{ visibility:"hidden" }
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
//GeneratePro.createAll("workPlan");
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18200,user.getLanguage());
String id=Util.null2String(request.getParameter("id")); 
String did=Util.null2String(request.getParameter("did"));   
String needfav ="1";
String needhelp ="";
String keyName="";
String viewSort="";
String planDate=Util.null2String(request.getParameter("planDate"));
String type=Util.null2String(request.getParameter("type"));
rs1.execute("select * from HrmPerformancePlanKey where id="+did);
if (rs1.next())
{
keyName=Util.toScreen(rs1.getString("keyName"),user.getLanguage());
viewSort=Util.toScreen(rs1.getString("viewSort"),user.getLanguage());
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15033,user.getLanguage())+",javaScript:window.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
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
<input type=hidden name=operationType value="KeyEdit" >
<input type=hidden name=id value=<%=id%> >
<input type=hidden name=did value=<%=did%> >
<input type=hidden name=type value=<%=type%> >
<input type=hidden name=planDate value=<%=planDate%> >
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="50%"> 
    <COL width="50%"> 
    <TBODY> 
  
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=10%> <COL width=70%> <TBODY> 
       
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=50 size=50 
            name=keyName  onchange='checkinput("keyName","nameimage")' value=<%=keyName%> >
			<SPAN id=nameimage>
			<%if (keyName.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN>
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
        <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=3 size=3 
            name=viewSort  onchange='checknumber("viewSort");checkinput("viewSort","vnameimage")' value=<%=viewSort%>>
			<SPAN id=vnameimage>
			<%if (viewSort.equals("")) {%><IMG src='/images/BacoError.gif' align=absMiddle><%}%>
			</SPAN>
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
</table>

<SCRIPT language="javascript">
function OnSubmit(){
    
    if(check_form(document.resource,"keyName,viewSort"))
	{	
		document.resource.submit();
		for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++)
		{
		window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
		}
		//window.frames["rightMenuIframe"].window.event.srcElement.disabled=true;
	}
}

</script>
</BODY>
</HTML>