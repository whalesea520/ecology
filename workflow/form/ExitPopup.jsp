<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response);
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript">
function button_yes_onClick() {
	window.returnValue=1;
	window.close();
}
function button_no_onClick() {
	window.returnValue=2;
	window.close();
}

function button_cancel_onClick() {
	window.close();
}
</script>
<html>
<head><title><%=SystemEnv.getHtmlLabelName(1205, user.getLanguage())%></title></head>
<base target="_self">
<body bgcolor=#cccccc>
  <table width="100%" height="100%" cellpadding="0">
  <tr>
      <td valign="top" align="center">
        <div style="width:100%; height:100%; overflow: auto">
        <br>
        <%=SystemEnv.getHtmlLabelName(129056, user.getLanguage())%>
        </div>
      </td>
    </tr>
     <tr height="50">
      <td align="center">
        <input type=button  onclick="button_yes_onClick();" value=" <%=SystemEnv.getHtmlLabelName(163, user.getLanguage())%> ">
        <input type=button  onclick="button_no_onClick();" value=" <%=SystemEnv.getHtmlLabelName(161, user.getLanguage())%> ">
        <input type=button   onclick="button_cancel_onClick();" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>">
      </td>
    </tr>
  </table>

</body>
</html>
