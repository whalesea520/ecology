
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
//是否分权系统，如不是，则不显示框架，直接转向到列表页面
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("meetingdetachable")),0);
int subid=Util.getIntValue(request.getParameter("subCompanyId"));
if(subid<0){
        subid=user.getUserSubCompany1();
}
String roomid = Util.null2String(request.getParameter("roomid"));
String startdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String starttime = Util.null2String(request.getParameter("starttime"));
String endtime = Util.null2String(request.getParameter("endtime"));
ArrayList subcompanylist=SubCompanyComInfo.getRightSubCompany(user.getUID(),"MeetingType:Maintenance");
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2104,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
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
<TABLE class=ListStyle cellspacing=1 >
<TBODY>
<%
if(detachable==1){
    String subcompanys=SubCompanyComInfo.getRightSubCompanyStr1(""+subid,subcompanylist);
    if(subcompanys.length()>0){
        RecordSet.executeSql("select * from meeting_type where subcompanyid in("+subcompanys+")");
    }else{
    	
    		RecordSet.executeSql("select * from meeting_type where subcompanyid="+user.getUserSubCompany1());
    	
    }
}else{
    RecordSet.executeProc("Meeting_Type_SelectAll","");
}
boolean isLight = false;
while(RecordSet.next())
{
	String id = Util.null2String(RecordSet.getString("id"));
    String name = Util.null2String(RecordSet.getString("name"));
		if(isLight)
		{%>	
	<TR CLASS=DataDark>
<%		}else{%>
	<TR CLASS=DataLight>
<%		}%>
<td><a href='NewMeetingTab.jsp?meetingtype=<%=id %>&meetingname=<%=name%>&roomid=<%=roomid%>&startdate=<%=startdate%>&enddate=<%=enddate%>&starttime=<%=starttime%>&endtime=<%=endtime%>'><%=Util.forHtml(RecordSet.getString("name"))%></a></td>
    </tr>
<%	
	isLight = !isLight;
}%>
</TBODY>
</TABLE>
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


