<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<%
String resourceid = Util.null2String(request.getParameter("resourceid"));
String departmentid = Util.null2String(request.getParameter("departmentid"));
String fromdate = Util.null2String(request.getParameter("fromdate")) ; // 从
String todate = Util.null2String(request.getParameter("todate")) ; // 到
String isself = Util.null2String(request.getParameter("isself")) ; 


String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16734 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15413,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmTimeCardWarpList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmmain name=frmmain method=post action="HrmTimeCardWarpOperation.jsp">
<input class=inputstyle type="hidden" name="operation" value="recreate">
<input class=inputstyle type="hidden" name="resourceid" value="<%=resourceid%>">
<input class=inputstyle type="hidden" name="departmentid" value="<%=departmentid%>">
<input class=inputstyle type="hidden" name="fromdate" value="<%=fromdate%>">
<input class=inputstyle type="hidden" name="todate" value="<%=todate%>">
<input class=inputstyle type="hidden" name="isself" value="<%=isself%>">

<table class=Viewform>
  <colgroup>
  <col width="15%">
  <col width="85%">    
  <tbody>
    <tr class=Title>
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16735 , user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing style="height:2px"> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
      <td class=field>
         <BUTTON class=Calendar type="button" id=selectstartdate onclick="getDate(startdatespan,startdate)"></BUTTON> 
         <SPAN id=startdatespan ><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
         <input type="hidden" id="startdate" name="startdate" value="">
      </td>
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
      <td class=field>
        <BUTTON class=Calendar type="button" id=selectenddate onclick="getDate(enddatespan,enddate)"></BUTTON> 
         <SPAN id=enddatespan ><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN> 
          <input type="hidden" id="enddate" name="enddate" value="">
      </td>  
    </tr>
    <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
  </tbody>
</table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
<script language=javascript>  
function submitData(obj) {
    if(check_form(frmmain,'startdate,enddate')){
         obj.disabled = true ;
         frmmain.submit();
     }
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>