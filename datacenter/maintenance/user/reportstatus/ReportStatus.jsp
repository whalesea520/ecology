<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = Util.toScreen("数据中心",7,"0") ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<DIV class=HdrProps></DIV>
<TABLE class=viewform>
  <COLGROUP>
  <COL width="48%">
  <TBODY>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewform width="100%">
        <TBODY> 
        <TR class=title> 
          <TH>报表状态</TH>
        </TR>
        <TR class=spacing> 
          <TD class=line1>&nbsp;</TD>
        </TR>
		<%
        String userid = ""+user.getUID() ;
		RecordSet.executeSql("select a.* from T_InputReport a, T_InputReportCrm b where a.inprepid = b.inprepid and b.crmid = " + userid);
		while(RecordSet.next()) {
			String inprepid =  Util.null2String(RecordSet.getString("inprepid")) ;
			String inprepname = Util.toScreen(RecordSet.getString("inprepname"),user.getLanguage()) ;
            String inpreptablename = Util.toScreen(RecordSet.getString("inpreptablename"),user.getLanguage()) ;
            String inprepbugtablename = Util.null2String(RecordSet.getString("inprepbugtablename")) ;
            String inprepforecasttablename = inpreptablename + "_forecast" ;
            String inprepbudget = Util.null2String(RecordSet.getString("inprepbudget")) ;
            String inprepforecast = Util.null2String(RecordSet.getString("inprepforecast")) ;
            String inprepfrequence = Util.null2String(RecordSet.getString("inprepfrequence")) ;
            String linkurl = "" ;

            if(inprepfrequence.equals("0")) linkurl = "ReportMtiDetailCrm.jsp" ;
            else linkurl = "ReportDetailCrm.jsp" ;
		%>
	
        <tr> 
          <td  class=field><%=inprepname%>&nbsp;&nbsp;
              <a href="<%=linkurl%>?thetable=<%=inpreptablename%>&inprepid=<%=inprepid%>&crmid=<%=userid%>">实际</a>&nbsp;&nbsp;
              <% if( inprepbudget.equals("1") ) { %>
              <a href="<%=linkurl%>?thetable=<%=inprepbugtablename%>&inprepid=<%=inprepid%>&crmid=<%=userid%>">预算</a>&nbsp;&nbsp;
              <% } if( inprepforecast.equals("1") ) { %>
              <a href="<%=linkurl%>?thetable=<%=inprepforecasttablename%>&inprepid=<%=inprepid%>&crmid=<%=userid%>">预测</a>&nbsp;&nbsp;
              <% } %>
          </td>
        </tr>
        <tr> 
          <td height=10></td>
        </tr>
		<%}%>
        </TBODY> 
      </TABLE>
    </TD>
</TR></TBODY></TABLE></BODY></HTML>
