
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>

<%
String userid =""+user.getUID();

/*权限判断,资产管理员以及其所有上级*/
boolean canView = false;
ArrayList allCanView = new ArrayList();
String sql = "select resourceid from HrmRoleMembers where roleid = 7 ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String tempid = RecordSet.getString("resourceid");
	allCanView.add(tempid);
	AllManagers.getAll(tempid);
	while(AllManagers.next()){
		allCanView.add(AllManagers.getManagerID());
	}
}// end while

for (int i=0;i<allCanView.size();i++){
	if(userid.equals((String)allCanView.get(i))){
		canView = true;
	}
}

if(!canView) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
String ProcPara = "";
char flag = 2;

int driver = Util.getIntValue(request.getParameter("driver"),0);
String begindate = Util.null2String(request.getParameter("begindate"));
String enddate = Util.null2String(request.getParameter("enddate"));
if(begindate.equals(""))
	begindate = currentdate;
if(enddate.equals(""))
	enddate = currentdate;
	
String beginyear = begindate.substring(0,4);
String beginmontd = begindate.substring(5,7);
String beginday = begindate.substring(8,10);
String endyear = enddate.substring(0,4);
String endmontd = enddate.substring(5,7);
String endday = enddate.substring(8,10);

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15352,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>


<TABLE class=ListShort width=100%>

<tr>
<td colspan=2 align=center>
<img src="/weaver/weaver.cpt.report.ShowCptFee?startdate=<%=begindate%>&enddate=<%=enddate%>" border=0>
</td>
</tr>
<tr>
<td colspan=2 align=center>
<font size = 4><b> <%=SystemEnv.getHtmlLabelName(15354,user.getLanguage())%> </b></font>
</td>
</tr>
<TR class=Section>
<th width=60%><%=SystemEnv.getHtmlLabelName(15332,user.getLanguage())%>:</th>
<th width=35%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%=beginyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=beginmontd%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=beginday%><%=SystemEnv.getHtmlLabelName(15333,user.getLanguage())%><%=endyear%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%><%=endmontd%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%><%=endday%><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></th>
</tr>

</table>


</body>
</html>
