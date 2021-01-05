
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<%
if(!HrmUserVarify.checkUserRight("HrmSalaryComponentAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2220,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<FORM id=weaver action="/sms/SmsOperation_set.jsp" method=post onsubmit='return onCheckForm1("collectionnum")'>
<DIV>
	<BUTTON class=btnSave accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
</DIV>
  <input type="hidden" name="method" value="add">
<TABLE class=form>
  <COLGROUP>
  <COL width="100%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=Form>
      <COLGROUP>
  	<COL width="30%">
  	<COL width="70%">
        <TBODY>
        <TR class=Section>
            <TH></TH>
          </TR>
        <TR class=separator>
          <TD class=Sep1 colSpan=2></TD></TR>
		<TR>
          <TD>系统允许一次发送的短信条数</TD>
          <TD class=Field><INPUT class=saveHistory maxLength=50 size=30 name="collectionnum" onchange='checkinput("collectionnum","collectionnumimage")'><SPAN id=collectionnum><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
          <input type=hidden name="collectionnum" value="">
        </TR>  
   
        </TBODY></TABLE></TD>
    </TR></TBODY></TABLE>
</FORM>
<script>
function onCheckForm1(objectname0)
{ 
  if(document.all(objectname0).value=="0"){
           
               alert ("不能为0！") ;     
               return false;
           }   
           else
               return true;
  
}
</script>
</BODY>
</HTML>
