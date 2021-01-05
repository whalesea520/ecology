<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%

if(!HrmUserVarify.checkUserRight("CptCapital:InStock", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String capitalid = request.getParameter("capitalid");
String sptcount = request.getParameter("sptcount");
String capitalnum = request.getParameter("capitalnum");
String instockdate = request.getParameter("instockdate");
String departmentid = request.getParameter("departmentid");
String costcenterid = request.getParameter("costcenterid");
String resourceid = request.getParameter("resourceid");
String userequest = request.getParameter("userequest");
String location = request.getParameter("location");
String remark = request.getParameter("remark");
//for check mark
String forcheck ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<FORM id=weaver name=frmain method=post onSubmit="onSubmit()">
<DIV class=HdrProps></DIV>
<BUTTON type="button" class=btnSave accessKey=S onclick="onSubmit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(1375,user.getLanguage())%></BUTTON>
<BUTTON type="button" class=btn accessKey=B onclick='window.history.back(-1)'><U>B</U>-<%=SystemEnv.getHtmlLabelName(1390,user.getLanguage())%></BUTTON>
  <TABLE class=form>
    <COLGROUP> <COL width="10%"> <COL width="90%"> <TBODY> 
      <%
      int tempcount = Util.getIntValue(capitalnum);
      for(int i=0;i<tempcount;i++){
      %>
     <TR>
      <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%><%=i%></TD>
      <TD class=Field> 
        <input type=text size=30 maxlength=60 name="mark_<%=i%>" onChange='checkinput("mark_<%=i%>","mark_<%=i%>image")'>
        <SPAN id="mark_<%=i%>image"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
     </TD>
     </TR>
     <%
      forcheck +=",mark_"+i;
      }
      //remove first semicolon
      forcheck=forcheck.substring(1);
    %>
   
    <input type="hidden" name=capitalid value=<%=capitalid%>>
    <input type="hidden" name=sptcount value=<%=sptcount%>>
    <input type="hidden" name=capitalnum value=<%=capitalnum%>>
    <input type="hidden" name=instockdate value=<%=instockdate%>>
    <input type="hidden" name=departmentid value=<%=departmentid%>>
    <input type="hidden" name=costcenterid value=<%=costcenterid%>>
    <input type="hidden" name=resourceid value=<%=resourceid%>>
    <input type="hidden" name=userequest value=<%=userequest%>>
    <input type="hidden" name=location value=<%=location%>>
    <input type="hidden" name=remark value=<%=remark%>>
    </TBODY> 
  </TABLE>
 </form>
 <script language="javascript">
 function onSubmit(){
 	if(check_form(document.frmain,'<%=forcheck%>')){
		document.frmain.action="CapitalInStockOperation.jsp"
		document.frmain.submit();
	}
 }
 </script>
</BODY></HTML>
