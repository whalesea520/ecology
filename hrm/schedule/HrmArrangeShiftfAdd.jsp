<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<%
 if(!HrmUserVarify.checkUserRight("HrmArrangeShift:Maintance", user)){
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
 }
%>

<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<!--<jsp:useBean id = "rs" class = "weaver.conn.RecordSet" scope = "page"/>-->

<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver_wev8.js"></script>

</head>
<%
String id = Util.null2String(request.getParameter("id")) ; 
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = Util.toScreen(SystemEnv.getHtmlLabelName(83822,user.getLanguage()) , 7 , "0") + ":" + SystemEnv.getHtmlLabelName(82 , user.getLanguage()) ; 
//Util.toScreen("排班种类" , 7 , "0")代替了SystemEnv.getHtmlLabelName(6139,user.getLanguage())
String needfav = "1" ;
String needhelp = "" ;  
boolean CanAdd = HrmUserVarify.checkUserRight("HrmArrangeShift:Maintance" , user) ; 

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class = HdrProps></DIV>
<FORM id = weaver name=frmmain method=post action = "HrmArrangeShiftOperation.jsp" onsubmit = "return check_form(this,'id,shiftname,shiftbegintime,shiftendtime')">
<input type = "hidden" name = "operation" value = "insertshift">

<%if(CanAdd){ %>
<div>
<BUTTON class = btnSave accessKey = S type = "submit"><U>S</U>-<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%></BUTTON>
<%} %>
<BUTTON class = btnNew accessKey = B onclick = "javaScript:window.history.go(-1)"><U>B</U>-<%=SystemEnv.getHtmlLabelName(83823,user.getLanguage())%></BUTTON>
</div>

<table class = form>
  <colgroup>
  <col width = "15%">
  <col width = "85%">
    <tbody>
    <tr class = Section>
      <TH colSpan = 2><%=SystemEnv.getHtmlLabelName(83822,user.getLanguage())%></TH>
    </TR>
    <TR class = Separator> 
      <TD class = Sep1 colSpan = 2></TD></TR>

    <tr>
      <td><%=SystemEnv.getHtmlLabelName(82755,user.getLanguage())%></td>
      <td class=field>
        <input type = "text" name = "shiftname" maxLength = 10 onchange = "checkinput('shiftname','InvalidFlag_Description1')" size = 43 >
    	<span id="shiftamespan"><IMG src = '/images/BacoError_wev8.gif' align = absMiddle></span>
      </td>
    </tr>

    <tr>
    <td><%=SystemEnv.getHtmlLabelName(83825,user.getLanguage())%></td>
    <td class=field>
    <button class = Clock onclick="onShowTime(shiftbegintimespan,shiftbegintime)"></button>
    <span id="shiftbegintimespan"><IMG src = '/images/BacoError_wev8.gif' align = absMiddle></span>
    <input type = hidden name ="shiftbegintime" value = "">
    </td>     
    </tr>

    <tr>
    <td><%=SystemEnv.getHtmlLabelName(83826,user.getLanguage())%></td>
    <td class=field>
    <button class = Clock onclick = "onShowTime(shiftendtimespan,shiftendtime)"></button>
    <span id = "shiftendtimespan"><IMG src = '/images/BacoError_wev8.gif' align = absMiddle></span>
    <input type = hidden name = "shiftendtime" value = "">
    </td>
    </tr>
    </tbody>
</table>
</form>
</body>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
