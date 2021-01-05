
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<script language=javascript src="/js/weaver_wev8.js"></script>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17534,user.getLanguage());
String needfav ="1";
String needhelp ="";
String birthremindids=Util.null2String((String)request.getAttribute("birthremindids"));
if(birthremindids.endsWith(","))
	birthremindids = birthremindids.substring(0,birthremindids.length()-1);
int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;
String[] arr_birthremindids=Util.TokenizerString2(birthremindids,",");
for(int i=0;i<arr_birthremindids.length;i++){
PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,2,(logintype).equals("1") ? "0" : "1",Util.getIntValue(arr_birthremindids[i],0));
}

%>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
		
		<table class=liststyle cellspacing=1  >
     	<COLGROUP>
     	<!--COL width=10-->
     	<COL width="40%">
        <COL width="20%">
        <COL width="20%">
        <TR class="Header">
    	  <TH colSpan=5><%=SystemEnv.getHtmlLabelName(17534,user.getLanguage())%></TH></TR>

        <tr class=header>

          <td><%=SystemEnv.getHtmlLabelName(18352,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(784,user.getLanguage())%></td>
        </tr><TR class=Line><TD colspan="5" ></TD></TR>
          <%          
              int linecolor=0;
              if(!birthremindids.equals(""))
              RecordSet.executeSql("SELECT title,resources,reminddate FROM HrmBirthRemindMsg where id in ("+birthremindids+")");

              while(!birthremindids.equals("")&&RecordSet.next()){
                  String title=Util.null2String(RecordSet.getString("title"));
                  String birthers=Util.null2String(RecordSet.getString("resources"));
                  String[] arr_birthers=Util.TokenizerString2(birthers,",");
                  StringBuffer buffer=new StringBuffer();
                  for(int i=0;i<arr_birthers.length;i++){
                      buffer.append("<a href=/hrm/resource/HrmResource.jsp?id=" + arr_birthers[i] + ">" + ResourceComInfo.getResourcename(arr_birthers[i]) + "</a>&nbsp;");
                  }
                  String reminddate=Util.null2String(RecordSet.getString("reminddate"));

          %>
          <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >

            <td><%=title%></td>
            <td><%=buffer.toString()%></td>
            <td><%=reminddate%></td>
          </tr>
          <%
          	if(linecolor==0)	linecolor=1;
          	else	linecolor=0;
          }
          %>


      </table>
		
				
		
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>


<body>
</html>