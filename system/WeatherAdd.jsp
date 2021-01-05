<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("WeatherMaintenance:All", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(5000,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanAdd = HrmUserVarify.checkUserRight("WeatherMaintenance:All", user);
String thedate=Util.null2String(request.getParameter("thedate"));
Calendar today = Calendar.getInstance();
String nowdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
if(thedate.equals("")) thedate=nowdate;

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>
<br>
<FORM id=weaver name=frmmain method=post action="WeatherOperation.jsp" onSubmit="return check_form(this,'picid,thedate,thedesc')">
<input type="hidden" name="operation" value="insert">
<div>
<%
if(CanAdd){
%>
<BUTTON class=btnSave accessKey=S type="submit"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%}%>
</div>
<table class=form>
<colgroup>
   <col width="20%">
   <col width="80%">
   <tr>
      <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
      <td class=field><BUTTON class=Calendar id=SelectDate onclick="getDate(thedatespan,thedate)"></BUTTON>
      <SPAN id=thedatespan ><%if(!thedate.equals("")){%><%=Util.toScreen(thedate,user.getLanguage())%><%}%></SPAN>
      <input type="hidden" name="thedate" value="<%=thedate%>"></td>
    </tr>
  <tr>
	<td><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></td>
	<td><INPUT TYPE="radio" NAME="picid" value="1" checked><IMG src="../../images/sun_wev8.gif" align=absMiddle>
	<INPUT TYPE="radio" NAME="picid" value="2" ><IMG src="../../images/yun_wev8.gif" align=absMiddle>
	<INPUT TYPE="radio" NAME="picid" value="3"><IMG src="../../images/yin_wev8.gif" align=absMiddle>
	<INPUT TYPE="radio" NAME="picid" value="4"><IMG src="../../images/yu_wev8.gif" align=absMiddle>
	</td>
  </tr>
  <tr>
      <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></td>
      <td class=field><INPUT maxLength=30 onchange="checkinput('thedesc','InvalidFlag_Description')" size=30 
      name="thedesc"><SPAN id=InvalidFlag_Description><IMG src="../../images/BacoError_wev8.gif" align=absMiddle></SPAN></td>
  </tr>
  <tr>
      <td><%=SystemEnv.getHtmlLabelName(5001,user.getLanguage())%></td>
      <td class=field><INPUT maxLength=30 size=30 name="temperature"><SPAN id=InvalidFlag_Description></SPAN></td>
  </tr>
</table>
</form>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>