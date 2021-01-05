
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<script language=javascript src="/js/weaver_wev8.js"></script>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(17497,user.getLanguage());
String needfav ="1";
String needhelp ="";
String contractRemindIds=Util.null2String((String)request.getAttribute("contractRemindIds"));
int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;


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
</colgroup>
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
        </COLGROUP>
        <TR class="Header">
    	  <TH colSpan=5><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(614,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(17497,user.getLanguage())%></TH></TR>

        <tr class=header>

          <td><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(784,user.getLanguage())%></td>
          <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
        </tr><TR class=Line><TD colspan="5" ></TD></TR>
          <%          
              int linecolor=0;
              if(!contractRemindIds.equals(""))
              RecordSet.executeSql("SELECT id,remindtype,resourceid,reminddate,relatedid FROM HrmRemindMsg where remindtype<5 and id in ("+contractRemindIds+") order by remindtype,reminddate");

              while(!contractRemindIds.equals("")&&RecordSet.next()){
                  String id=RecordSet.getString("id");
                  String typeid=RecordSet.getString("remindtype");
                  String type="";
                  String resourceid=RecordSet.getString("resourceid");
                  String contractid=RecordSet.getString("relatedid");
                  String resource="<a href=/hrm/resource/HrmResource.jsp?id=" + resourceid + ">" + ResourceComInfo.getResourcename(resourceid) + "</a>&nbsp;";
                  String reminddate=RecordSet.getString("reminddate");
                  StringBuffer operation=new StringBuffer();
                  if(typeid.equals("1")){
                  type=SystemEnv.getHtmlLabelName(18884,user.getLanguage())+SystemEnv.getHtmlLabelName(17497,user.getLanguage());
                  operation.append("<a href=/hrm/contract/contract/HrmContractView.jsp?id=" + contractid + ">" + SystemEnv.getHtmlLabelName(367,user.getLanguage())+SystemEnv.getHtmlLabelName(614,user.getLanguage()) + "</a>&nbsp;"+
                  "<a href=/hrm/resource/HrmResourceHire.jsp?id=" + resourceid + ">" + SystemEnv.getHtmlLabelName(6088,user.getLanguage()) + "</a>");
                  }
                  else if(typeid.equals("2")){
                  type=SystemEnv.getHtmlLabelName(18884,user.getLanguage())+SystemEnv.getHtmlLabelName(17497,user.getLanguage());
                  operation.append("<a href=/hrm/resource/HrmResourceHire.jsp?id=" + resourceid + ">" + SystemEnv.getHtmlLabelName(6088,user.getLanguage()) + "</a>");
                  }
                  else if(typeid.equals("3")){
                  type=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(17497,user.getLanguage());
                  operation.append("<a href=/hrm/contract/contract/HrmContractView.jsp?id=" + contractid + ">" + SystemEnv.getHtmlLabelName(367,user.getLanguage())+SystemEnv.getHtmlLabelName(614,user.getLanguage()) + "</a>&nbsp;"+
                  "<a href=/hrm/resource/HrmResourceExtend.jsp?id=" + resourceid + ">" +SystemEnv.getHtmlLabelName(6089,user.getLanguage()) + "</a>");
                  }
                  else if(typeid.equals("4")){                  
                  type=SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(17497,user.getLanguage());
                  operation.append("<a href=/hrm/resource/HrmResourceExtend.jsp?id=" + resourceid + ">" + SystemEnv.getHtmlLabelName(6089,user.getLanguage()) + "</a>");
                  }

          %>
          <tr <%if(linecolor==0){%> class=datalight <%} else {%> class=datadark <%}%> >

            <td><%=type%></td>
            <td><%=resource%></td>
            <td><%=reminddate%></td>
            <td><%=operation%></td>
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


</body>
</html>