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
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmWorkTimeWarpList.jsp,_self} " ;
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
<FORM id=frmmain name=frmmain method=post action="HrmWorkTimeWarpOperation.jsp" onsubmit="return check_form(this,'startdate,enddate')">
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