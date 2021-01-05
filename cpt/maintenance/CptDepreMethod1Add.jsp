<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("CptDepreMethodAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(837,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
int wrongfunc = Util.getIntValue(request.getParameter("wrongfunc"),0);
if(wrongfunc==-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(30,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM  name=frmMain action="DepreMethod1Operation.jsp" method=post >
<DIV class=HdrProps></DIV>
<BUTTON class=btnSave accessKey=S onclick='OnSubmit()'><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=B onclick='window.history.back(-1)'><U>B</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>

  <TABLE class=form>
    <COLGROUP> <COL width="20%"> <COL width="80%"> <TBODY> 
    <TR class=Section> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(837,user.getLanguage())%></TH>
    </TR>
    <TR class=separator> 
      <TD class=Sep1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text size=30  maxlength=60 name="name" onchange='checkinput("name","nameimage")'>
        <SPAN id=nameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text size=60  maxlength=200  name="description" onchange='checkinput("description","descriptionimage")'>
        <SPAN id=descriptionimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1430,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text size=10  maxlength=18  name="timelimit" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("timelimit");checkinput("timelimit","timelimitimage")'>
        <span id=timelimitimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1431,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text size=10  maxlength=5 id=startunit name=startunit onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("startunit");checkinput("startunit","startunitimage")'>
        <span id=startunitimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1432,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text size=10  maxlength=5 id=endunit name=endunit onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("endunit");checkinput("endunit","endunitimage")'>
        <span id=endunitimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1433,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text size=60 maxlength=200 name="deprefunc" onChange='checkinput("deprefunc","deprefuncimage")'>
        <span id=deprefuncimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span></td>
    </tr>
    <input type="hidden" name=operation value=add>
    </TBODY> 
  </TABLE>
 </form>
  <SCRIPT LANGUAGE="JavaScript">
function OnSubmit(){
    if(check_form(this,'name,description,timelimit,startunit,endunit,deprefunc'))
	{	
		if(((document.all("startunit").value)>0)&&((document.all("startunit").value)<=1)&&((document.all("endunit").value)>=0)&&((document.all("endunit").value)<1)&&((document.all("startunit").value)>=(document.all("endunit").value))){
			document.frmMain.submit();
		}
		else{
		 alert("<%=SystemEnv.getHtmlLabelName(15319,user.getLanguage())%>");
		}
	}
}
 </SCRIPT>
</BODY></HTML>
