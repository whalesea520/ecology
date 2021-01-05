<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%
boolean canIn = true;

if(!canIn){
  response.sendRedirect("/notice/noright.jsp");
  return;
}

String id = request.getParameter("id");
String errmsg = Util.null2String(request.getParameter("errmsg"));
String usercode = Util.toScreen(request.getParameter("usercode"),7,"0");

if( usercode.equals("") ) {
    String sql = "select usercode from HrmTimecardUser where resourceid ="+id;
    rs.executeSql(sql); 
    if(rs.next()) usercode = Util.null2String(rs.getString("usercode"));  
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16724 , user.getLanguage()) ; 
String needfav ="1";
String needhelp ="";

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmTimecardUser.jsp,_self} " ;
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

<% if(errmsg.equals("1")){ %>
<DIV><font color=red size=2><%=SystemEnv.getHtmlLabelName(16726,user.getLanguage())%></font> </div>
<% } %>

<FORM  name=frmMain action="HrmTimecardUserOperation.jsp" method=post >
<TABLE class=Viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16727,user.getLanguage())%></TH></TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
            <%=ResourceComInfo.getResourcename(id)%>  
            <input class=inputstyle type=hidden name=id value="<%=id%>">        
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>            
             <%=DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(id))%>      
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16728,user.getLanguage())%></td>
          <td class=Field >            
            <%=id%>
          </td>
        </tr>  
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16702,user.getLanguage())%></td>
          <td class=Field>
            <input class=inputstyle type=text name=usercode value="<%=usercode%>" onChange='checkinput("usercode","usercodespan")'>            
            <span id=usercodespan></span>
          </td>
        </tr>        
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR> 
 </TBODY>
 </TABLE>
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
function submitData() {
    frmMain.submit();
}
</script>
</BODY>
</HTML>