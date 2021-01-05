<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<%
// RecordSet.executeProc("Sys_Slogan_Select","");
// RecordSet.next();
String username = user.getAliasname() ;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentyear = (timestamp.toString()).substring(0,4) ;
String currentmonth = ""+Util.getIntValue((timestamp.toString()).substring(5,7)) ;
String currentdate = ""+Util.getIntValue((timestamp.toString()).substring(8,10));
String currenthour = (timestamp.toString()).substring(11,13) ;

int targetid = Util.getIntValue(request.getParameter("targetid"),0) ;
String targetidstr = "" + targetid ;
String bodybgcolor = "";
String searchlink = "" ;
String newslink = "" ;
String orglink = "" ;
String reportlink = "" ;
String maintenancelink = "" ;
String systemlink = "/system/SystemMaintenance.jsp" ;
String targetname = "" ;

switch(targetid) {
	 case 10:													// 新闻中心
		bodybgcolor = "#FFEBAD" ;
		searchlink = "" ;
		newslink = "" ;
		orglink = "" ;
		reportlink = "/datacenter/input/DataCenterInput.jsp" ;
		maintenancelink = "/datacenter/maintenance/DataCenterMaintenance.jsp" ;
		break ;
}
%>

<html>
<head>
<title>泛微协同商务系统(Weaver ecology)</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<base target="mainFrame">
<link rel="stylesheet" href="/css/frame.css" type="text/css">
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="25"><img src="/images_frame/top_left.gif"></td>
   
    <td width="145"><a href="http:\\www.siyaonline.com.cn" target=_blank><img alt="XinYa" src="/images_frame/logo.gif" border="0"></a></td>
          <td background="/images_frame/top_bg.gif" valign="bottom"> 
            <table width="85%" border="0" cellspacing="0" cellpadding="0">
              <tr>
              <td align="center" ><a href="/main.jsp?targetid=10"  target=_top><%if(targetidstr.equals("10")) {%><img src="/images_frame/top_button8_in.gif" border="0" ><%} else {%> <img src="/images_frame/top_button8.gif" border="0" ><%}%></a></td>
              </tr>
              <tr>
              <td align="center" nowrap><a href="/main.jsp?targetid=10"  target=_top <%if(targetidstr.equals("10")) {%> class="lm1" <%} else {%> class="lm" <%}%>>数据中心</a></td>
              </tr>
            </table>
          </td>
          <td width="24"> 
            <div align="right"><img src="/images_frame/top_right.gif"></div>
          </td>
        </tr>
      </table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="25"><img src="/images_frame/top_left1.gif"></td>
          <td width="471">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
              <tr>
                <td height="21" background="/images_frame/table2_bg2.gif"> 
<%if(user.getLanguage()==7||user.getLanguage()==9){%>
                  <table  border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="64"><img src="/images_frame/table2_left1.gif" height="21"></td>
                      <td background="/images_frame/table2_bg1.gif" nowrap valign="baseline" class="wenhou"><%=username%> 
                        <% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%>晚上好
						<%} else if(currenthour.compareTo("12") < 0 ) {%>上午好
						<%} else if(currenthour.compareTo("14") <= 0 ) {%>中午好
						<%} else if(currenthour.compareTo("18") < 0 ) {%>下午好<%}%>! 今天是<%=currentyear%>年<%=currentmonth%>月<%=currentdate%>日</td>
                      <td width="24"><img src="/images_frame/table2_right1.gif" width="24" height="21"></td>
                     </tr>
                  </table>
<%}else{%>
                  <table  border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="64"><img src="/images_frame/table2_left1.gif" height="21"></td>
                      <td background="/images_frame/table2_bg1.gif" nowrap valign="baseline" class="wenhou">
                        <% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%><%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
						<%} else if(currenthour.compareTo("12") < 0 ) {%><%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
						<%} else if(currenthour.compareTo("14") <= 0 ) {%><%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
						<%} else if(currenthour.compareTo("18") < 0 ) {%><%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%><%}%>! 
						  <%=username%> </td>
                      <td width="24"><img src="/images_frame/table2_right1.gif" width="24" height="21"></td>
                     </tr>
                  </table>
<%}%>
                </td>
              </tr>
              <tr>
                <td bgcolor="C1DAFF" height="10"></td>
              </tr>
              <tr>
                <td height="28"> 
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td width="169"><img src="/images_frame/table2_left2.gif" width="169" height="28"></td>
                      <td background="/images_frame/table2_bg3.gif">              
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
         <TD align="center"><A class="zlm" href="<%=reportlink%>"target="mainFrame"><%=SystemEnv.getHtmlLabelName(351,user.getLanguage())%></A></TD>
		  <TD align="center">&nbsp;</TD>
                </tr>
              </table>
			  		  </td>
                      <td width="16"><img src="/images_frame/table2_right2.gif" width="16" height="28"></td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
          <td background="/images_frame/top_bg1.gif" width="30"> </td>
          <td background="/images_frame/top_bg1.gif">
            <table border="0" cellspacing="0" cellpadding="0">
              <form name="form1" method="post" action="/system/QuickSearchOperation.jsp">
			 <tr>
                <td>&nbsp;</td>
				<td width=20></td>
                <td>&nbsp;</td>
				<td width=20></td>
                <td>&nbsp;</td>
            <td width="100" align="right"><a href="/login/Logout.jsp"><%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%></a></td>
            <td width="100" align="right"><a href="/help/index.htm">帮助</a></td> 
			</tr>
	     </form>
            </table>
          </td>
          <td width="24"><img src="/images_frame/top_right1.gif"></td>
        </tr>
      </table>	  
</body>
</html>
