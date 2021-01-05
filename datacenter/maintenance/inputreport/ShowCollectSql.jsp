<%@ page contentType="text/html;charset=GBK" language="java" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.datacenter.InputCollect" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
  <head><title></title>
      <link href="/css/Weaver.css" type="text/css" rel="stylesheet" />
<script language="JavaScript" src="/js/weaver.js" type="text/javascript"></script>
  </head>
<%
String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(20769,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
  <body>
  <%@ include file="/systeminfo/TopTitle.jsp" %>
  <%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
  <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10"/>
<col width=""/>
<col width="10"/>
</colgroup>
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<table class="Shadow" width="100%">
<tr>
<td valign="top">
    <table Class=ListStyle  width="100%">
      <tr class=header>
          <td width="3%"><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></td>
          <td width="97%">SQL</td>
      </tr>
      <%
          Calendar today = Calendar.getInstance();
          String currentyear = Util.add0(today.get(Calendar.YEAR), 4);
          String currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2);
          String currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
          String currentdate = currentyear + "-" + currentmonth + "-" + currentday;
          int inprepid = Util.getIntValue(request.getParameter("inprepid"));
          int id = Util.getIntValue(request.getParameter("id"));
          String sql = "SELECT a.hrmid,b.inpreptablename FROM T_InputReportHrm a,t_inputreport b where a.inprepid=b.inprepid and a.id=" + id;
          rs.executeSql(sql);
          if (rs.next()) {
              InputCollect collect = new InputCollect();
              collect.setInprepid(inprepid);
              collect.setHrmid(rs.getInt("hrmid"));
              collect.setTablename(rs.getString("inpreptablename"));
              collect.setYear(currentyear);
              collect.setMonth(currentmonth);
              collect.setReportdate(currentdate);
              Hashtable ht = collect.getCollectSql();
              ArrayList sqls = (ArrayList) ht.get("sqls");
              for (int i = 0; i < sqls.size(); i++) {
      %>
      <tr <%if((i+1)%2==0){%>bgcolor="#f5f5f5"<%}else{%>bgcolor="#efefef"<%}%>>
          <td width="3%"><%=i+1%></td>
          <td width="97%" style="word-break:break-all; word-wrap:break-word;"><%=sqls.get(i)%></td>
      </tr>
      <%
              }
          }
      %>
  </table>
</td>
</tr>
</table>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
  </body>
</html>