<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<%
// RecordSet.executeProc("Sys_Slogan_Select","");
// RecordSet.next();
String username = user.getUsername() ;
String logintype = Util.null2String(user.getLogintype()) ;
String Customertype = Util.null2String(""+user.getType()) ;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentyear = (timestamp.toString()).substring(0,4) ;
String currentmonth = ""+Util.getIntValue((timestamp.toString()).substring(5,7)) ;
String currentdate = ""+Util.getIntValue((timestamp.toString()).substring(8,10));
String currenthour = (timestamp.toString()).substring(11,13) ;

int targetid = Util.getIntValue(request.getParameter("targetid"),0) ;
if(targetid==0) targetid=1;
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
	case 1:													// 文档  - 新闻
		bodybgcolor = "#e7e3bd" ;
		searchlink = "/docs/search/DocSearch.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=1" ;
		orglink = "/org/OrgChart.jsp?charttype=D" ;
		reportlink = "/docs/report/DocRp.jsp" ;
		maintenancelink = "/docs/DocMaintenance.jsp" ;
		break ;
	case 2:													// 人力资源 - 新闻
		bodybgcolor = "#FFDFAF" ;
		searchlink = "/hrm/search/HrmResourceSearch.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=2" ;
		orglink = "/org/OrgChart.jsp?charttype=H" ;
		reportlink = "/hrm/report/HrmRp.jsp" ;
		maintenancelink = "/hrm/HrmMaintenance.jsp" ;
		break ;
	case 3:													// 财务 - 组织结构
		bodybgcolor = "#BEE0DE" ;
		searchlink = "" ;
		newslink = "/docs/news/NewsDsp.jsp?id=3" ;
		orglink = "/org/OrgChart.jsp?charttype=F" ;
		reportlink = "/fna/report/FnaReport.jsp" ;
		maintenancelink = "/fna/FnaMaintenance.jsp" ;
		break ;
	case 4:													// 物品 - 搜索页面
		bodybgcolor = "#FFEBAD" ;
		searchlink = "/lgc/search/LgcSearch.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=4" ;
		orglink = "/org/OrgChart.jsp?charttype=I" ;
		reportlink = "/lgc/report/LgcRp.jsp" ;
		maintenancelink = "/lgc/LgcMaintenance.jsp" ;
		break ;
	case 5:													// CRM - 我的客户
		bodybgcolor = "#CEEBFF" ;
		searchlink = "/CRM/search/SearchSimple.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=5" ;
		orglink = "/org/OrgChart.jsp?charttype=C" ;
		reportlink = "/CRM/CRMReport.jsp" ;
		maintenancelink = "/CRM/CRMMaintenance.jsp" ;
		break ;
	case 6:													// 项目 - 我的项目
		bodybgcolor = "#FDDACA" ;
		searchlink = "/proj/search/Search.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=6" ;
		orglink = "/org/OrgChart.jsp?charttype=R" ;
		reportlink = "/proj/ProjReport.jsp" ;
		maintenancelink = "/proj/ProjMaintenance.jsp" ;
		break ;
	case 7:													// 工作流 - 我的工作流
		bodybgcolor = "#EADCC5" ;
		searchlink = "/workflow/search/WFSearch.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=7" ;
		orglink = "" ;
		reportlink = "/workflow/WFReport.jsp" ;
		maintenancelink = "/workflow/WFMaintenance.jsp" ;
		break ;
	case 9:													// 资产-搜索页面
		bodybgcolor = "#FFEBAD" ;
		searchlink = "/Cpt/search/CptSearch.jsp" ;
		newslink = "/docs/news/NewsDsp.jsp?id=4" ;
		orglink = "/org/OrgChart.jsp?charttype=P" ;
		reportlink = "/cpt/report/CptRp.jsp" ;
		maintenancelink = "/cpt/CptMaintenance.jsp" ;
		break ;
}
%>

<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(16641,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<base target="mainFrame">
<link rel="stylesheet" href="/css/frame_wev8.css" type="text/css">
</head>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="25"><img src="/images_frame/top_left_wev8.gif"></td>
   
    <td width="145"><a href="http:\\www.weaver.com.cn" target=_blank><img alt="Weaver" src="/images_frame/logo_wev8.gif" border="0"></a></td>
          <td background="/images_frame/top_bg_wev8.gif" valign="bottom"> 
            <table width="85%" border="0" cellspacing="0" cellpadding="0">
              <tr> 
                <td align="center" ><a href="/main.jsp?targetid=1"  target=_top><%if(targetidstr.equals("1")) {%><img src="/images_frame/top_button1_in_wev8.gif" border="0" ><%} else {%> <img src="/images_frame/top_button1_wev8.gif" border="0" ><%}%></a></td>
			<%if(!logintype.equals("2")){%>
                <td align="center" ><a href="/main.jsp?targetid=2"  target=_top><%if(targetidstr.equals("2")) {%><img src="/images_frame/top_button2_in_wev8.gif" border="0" ><%} else {%> <img src="/images_frame/top_button2_wev8.gif" border="0" ><%}%></a></td>
			<%}%>
			<%if(!logintype.equals("2")){%>
				 <td align="center" ><a href="/main.jsp?targetid=9"  target=_top><%if(targetidstr.equals("9")) {%><img src="/images_frame/top_button3_in_wev8.gif" border="0" ><%} else {%> <img src="/images_frame/top_button3_wev8.gif" border="0" ><%}%></a></td>
			<%}%>
			<%if(!logintype.equals("2")){%>
                <!-- td align="center" ><a href="/main.jsp?targetid=4"  target=_top><%if(targetidstr.equals("4")) {%><img src="/images_frame/top_button3_in_wev8.gif" border="0" ><%} else {%> <img src="/images_frame/top_button3_wev8.gif" border="0" ><%}%></a></td -->
			<%}%>
			<%if(!logintype.equals("2")){%>
                <td align="center" ><a href="/main.jsp?targetid=3"  target=_top><%if(targetidstr.equals("3")) {%><img src="/images_frame/top_button4_in_wev8.gif" border="0" ><%} else {%> <img src="/images_frame/top_button4_wev8.gif" border="0" ><%}%></a></td>
			<%}%>
                <td align="center" ><a href="/main.jsp?targetid=5"  target=_top><%if(targetidstr.equals("5")) {%><img src="/images_frame/top_button5_in_wev8.gif" border="0" ><%} else {%> <img src="/images_frame/top_button5_wev8.gif" border="0" ><%}%></a></td>
                <td align="center" ><a href="/main.jsp?targetid=6"  target=_top><%if(targetidstr.equals("6")) {%><img src="/images_frame/top_button7_in_wev8.gif" border="0" ><%} else {%> <img src="/images_frame/top_button7_wev8.gif" border="0" ><%}%></a></td>
                <td align="center" ><a href="/main.jsp?targetid=7"  target=_top><%if(targetidstr.equals("7")) {%><img src="/images_frame/top_button6_in_wev8.gif" border="0" ><%} else {%> <img src="/images_frame/top_button6_wev8.gif" border="0" ><%}%></a></td>
			<%if(!logintype.equals("2")){%>
                <td align="center" ><a href="/main.jsp?targetid=8"  target=_top><%if(targetidstr.equals("8")) {%><img src="/images_frame/top_button8_in_wev8.gif" border="0" ><%} else {%> <img src="/images_frame/top_button8_wev8.gif" border="0" ><%}%></a></td>
			<%}%>
              </tr>
              <tr height="20"> 
                <td align="center" nowrap><a href="/main.jsp?targetid=1"  target=_top <%if(targetidstr.equals("1")) {%> class="lm1" <%} else {%> class="lm" <%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></a></td>
			<%if(!logintype.equals("2")){%>
                <td align="center" nowrap><a href="/main.jsp?targetid=2"  target=_top <%if(targetidstr.equals("2")) {%> class="lm1" <%} else {%> class="lm" <%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></a></td>
			<%}%>
			<%if(!logintype.equals("2")){%>
				<td align="center" nowrap><a href="/main.jsp?targetid=9"  target=_top <%if(targetidstr.equals("9")) {%> class="lm1" <%} else {%> class="lm" <%}%>><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></a></td>
			<%}%>
			<%if(!logintype.equals("2")){%>
                <!-- td align="center" nowrap><a href="/main.jsp?targetid=4"  target=_top <%if(targetidstr.equals("4")) {%> class="lm1" <%} else {%> class="lm" <%}%>>产&nbsp;品</a></td -->
			<%}%>
			<%if(!logintype.equals("2")){%>
                <td align="center" nowrap><a href="/main.jsp?targetid=3"  target=_top <%if(targetidstr.equals("3")) {%> class="lm1" <%} else {%> class="lm" <%}%>><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></a></td>
			<%}%>
                <td align="center" nowrap><a href="/main.jsp?targetid=5"  target=_top <%if(targetidstr.equals("5")) {%> class="lm1" <%} else {%> class="lm" <%}%>>CRM</a></td>
          
				<td align="center" nowrap><a href="/main.jsp?targetid=6"  target=_top <%if(targetidstr.equals("6")) {%> class="lm1" <%} else {%> class="lm" <%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></a></td>

                <td align="center" nowrap><a href="/main.jsp?targetid=7"  target=_top <%if(targetidstr.equals("7")) {%> class="lm1" <%} else {%> class="lm" <%}%>><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></a></td>
			<%if(!logintype.equals("2")){%>
                <td align="center" nowrap><a href="/main.jsp?targetid=8"  target=_top <%if(targetidstr.equals("8")) {%> class="lm1" <%} else {%> class="lm" <%}%>><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></a></td>
			<%}%>
	
              </tr>
            </table>
          </td>
          <td width="24"> 
            <div align="right"><img src="/images_frame/top_right_wev8.gif"></div>
          </td>
        </tr>
      </table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="25"><img src="/images_frame/top_left1_wev8.gif"></td>
          <td width="471">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
              <tr>
                <td height="21" background="/images_frame/table2_bg2_wev8.gif"> 
<%if(user.getLanguage()==7||user.getLanguage()==9){%>
                  <table  border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="64"><img src="/images_frame/table2_left1_wev8.gif" height="21"></td>
                      <td background="/images_frame/table2_bg1_wev8.gif" nowrap valign="baseline" class="wenhou"><%=username%> 
                        <% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%><%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
						<%} else if(currenthour.compareTo("12") < 0 ) {%><%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
						<%} else if(currenthour.compareTo("14") <= 0 ) {%><%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
						<%} else if(currenthour.compareTo("18") < 0 ) {%><%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%><%}%>! <%=SystemEnv.getHtmlLabelName(16645,user.getLanguage())+" "+currentyear+"/"+currentmonth+"/"+currentdate%></td>
                      <td width="24"><img src="/images_frame/table2_right1_wev8.gif" width="24" height="21"></td>
                     </tr>
                  </table>
<%}else{%>
                  <table  border="0" cellspacing="0" cellpadding="0">
                    <tr> 
                      <td width="64"><img src="/images_frame/table2_left1_wev8.gif" height="21"></td>
                      <td background="/images_frame/table2_bg1_wev8.gif" nowrap valign="baseline" class="wenhou">
                        <% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%><%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
						<%} else if(currenthour.compareTo("12") < 0 ) {%><%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
						<%} else if(currenthour.compareTo("14") <= 0 ) {%><%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
						<%} else if(currenthour.compareTo("18") < 0 ) {%><%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%><%}%>! 
						  <%=username%> </td>
                      <td width="24"><img src="/images_frame/table2_right1_wev8.gif" width="24" height="21"></td>
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
                      <td width="169"><img src="/images_frame/table2_left2_wev8.gif" width="169" height="28"></td>
                      <td background="/images_frame/table2_bg3_wev8.gif">              
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
	<%if(!(targetid==5 && logintype.equals("2") && !Customertype.equals("3") && !Customertype.equals("4"))){%>
          <% if(!searchlink.equals("")) {%>
          <TD align="center"><A class=zlm href="<%=searchlink%>" target="mainFrame"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></A></TD>
          <TD width="1" class="shuxian">|</TD>
		  <%}%>
		  <% if(!newslink.equals("")) {%>
          <TD align="center"><A class=zlm href="<%=newslink%>" target="mainFrame"><%=SystemEnv.getHtmlLabelName(316,user.getLanguage())%></A></TD>
          <TD width="1" class="shuxian">|</TD>
		  <%}%>
	<%}%>
	<%if(!logintype.equals("2")){%>
		  <% if(!orglink.equals("")) {%>
          <TD align="center"><A class=zlm href="<%=orglink%>" target="mainFrame"><%=SystemEnv.getHtmlLabelName(376,user.getLanguage())%></A></TD>
          <TD width="1" class="shuxian">|</TD>
		  <%}%>
	<%}%>
	<%if(!(targetid==5 && logintype.equals("2") && !Customertype.equals("3") && !Customertype.equals("4"))){%>
		  <% if(!reportlink.equals("")) {%>
         <%if(targetid!=1||logintype.equals("1")){%> <TD align="center"><A class="zlm" href="<%=reportlink%>"target="mainFrame"><%=SystemEnv.getHtmlLabelName(351,user.getLanguage())%></A></TD>
          <TD  width="1" class="shuxian">|</TD>
		  <%}}%>
	<%}%>
	<%if(!logintype.equals("2")){%>
		  <% if(!maintenancelink.equals("")) {%>
          <TD align="center"><A class=zlm href="<%=maintenancelink%>" target="mainFrame"><%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%></A></TD>
          <TD width="1" class="shuxian">|</TD>
		  <%}%>
	<%}%>
	<%if(!logintype.equals("2")){%>
		  <% if(!systemlink.equals("")) {%>
          <TD align="center"><A class=zlm href="<%=systemlink%>" target="mainFrame"><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></A></TD>
		  <%}%>
	<%}%>
		  <TD align="center">&nbsp;</TD>
                </tr>
              </table>
			  		  </td>
                      <td width="16"><img src="/images_frame/table2_right2_wev8.gif" width="16" height="28"></td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </td>
          <td background="/images_frame/top_bg1_wev8.gif" width="30"> </td>
          <td background="/images_frame/top_bg1_wev8.gif">
            <table border="0" cellspacing="0" cellpadding="0">
              <form name="form1" method="post" action="/system/QuickSearchOperation.jsp">
			 <tr>
                <td>         
              <select name="searchtype" >
                <option value=1><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>	
	<%if(!logintype.equals("2")){%>				
                <option value=2><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
	<%}%>
	<%if(Customertype.equals("3") || Customertype.equals("4") || !logintype.equals("2") ){%>	
                <option value=3>CRM</option>
	<%}%>
	<%if((!logintype.equals("2")) && software.equals("ALL")){%>	
                <option value=4><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
	<%}%>
                <option value=5><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></option>

                <option value=6><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>

              </select>
                </td>
				<td width=20></td>
                <td><input type="text" name="searchvalue" class="submit" size="15"></td>
				<td width=20></td>
                <td>
                <img alt="<%=SystemEnv.getHtmlLabelName(16646,user.getLanguage())%>" src="/images_frame/search_dot_wev8.gif" border="0" onclick="form1.submit()" style="CURSOR:HAND"></td>
				
            <td width="100" align="right"><a href="/login/Logout.jsp"><%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%></a></td>
            <td width="100" align="right">
				<%if(!logintype.equals("2")){%>
					<!--a href="/help/help-user.doc">帮助</a -->
				<%}%>
			</td> 
			</tr>
	     </form>
            </table>
          </td>
          <td width="24"><img src="/images_frame/top_right1_wev8.gif"></td>
        </tr>
      </table>	  
</body>
</html>
