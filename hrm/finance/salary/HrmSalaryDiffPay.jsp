<%@ page import="weaver.general.Util,java.math.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ScheduleDiffComInfo" class="weaver.hrm.schedule.HrmScheduleDiffComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(503,user.getLanguage());
String needfav ="1";
String needhelp ="";


String payid = Util.null2String(request.getParameter("payid"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String itemid = Util.null2String(request.getParameter("itemid"));
String currentdate = Util.null2String(request.getParameter("currentdate"));

String sql = "select * from HrmSalaryDiffDetail where payid = " + payid + " and resourceid = " + resourceid + " and itemid = " + itemid + " order by startdate ";

String backurl = "" ;
if( !currentdate.equals("") ) backurl = "HrmSalaryPay.jsp?currentdate=" + currentdate ;

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>

<div>
<BUTTON class=BtnReset type=button accessKey=R onclick="location.href='<%=backurl%>'"><U>R</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>
</div>
<br>

<table class=listshort>
<colgroup>
  <col width="17%">
  <col width="10%">
  <col width="15%">
  <col width="10%">
  <col width="15%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
<tbody>
<tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(15880, user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(16055, user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(24978, user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1323, user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(16056, user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(16739, user.getLanguage())%></td>
</tr>
<%

  double thecountpay = 0 ;
  boolean isLight = false;
  RecordSet.executeSql(sql);	
  while(RecordSet.next()){
    String diffid = Util.null2String(RecordSet.getString("diffid"));
    String difftypeid = Util.null2String(RecordSet.getString("difftypeid"));
    String diffname = ScheduleDiffComInfo.getDiffname(difftypeid);
    String resourceidrs = Util.null2String(RecordSet.getString("resourceid"));
    String startdate =   Util.null2String(RecordSet.getString("startdate"));    
    String enddate =   Util.null2String(RecordSet.getString("enddate"));
    int realcounttime =   Util.getIntValue(RecordSet.getString("realcounttime"),0);
    double realcountpay =   Util.getDoubleValue(RecordSet.getString("realcountpay"),0);

    thecountpay += realcountpay ;

    int realdiffhour = realcounttime/60 ;
    int realdiffmin = realcounttime - realdiffhour*60 ;
    String realdifftimestr = Util.add0(realdiffhour,2) + ":" + Util.add0(realdiffmin,2) ;

    isLight = !isLight ;
%>
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
      <td>
        <!--a href="/hrm/schedule/HrmScheduleMaintanceView.jsp?id=<%=diffid%>"--><%=diffname%><!--/a-->
      </td>
      <td><%=ResourceComInfo.getResourcename(resourceidrs)%></td>
      <td><%=startdate%></td>
      <td><%=enddate%></td>
      <td><%=realdifftimestr%></td>
      <td><%=realcountpay%></td>
    </tr>
<%
}

BigDecimal  thecountpaydob = new BigDecimal( thecountpay ) ;
thecountpaydob = thecountpaydob.divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ) ;
thecountpay =  thecountpaydob.doubleValue() ;
%>
<tr CLASS=Total STYLE="COLOR:RED;FONT-WEIGHT:BOLD">
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td><%=thecountpay%></td>
 </tr>
</tbody>
</table>

</body>
</html>