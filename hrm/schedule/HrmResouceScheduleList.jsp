<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(369,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanAdd = HrmUserVarify.checkUserRight("HrmResouceScheduleAdd:Add", user);

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanAdd){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/schedule/HrmResouceScheduleAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmResouceScheduleAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",/hrm/schedule/HrmResouceScheduleCopy.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmResouceScheduleList:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+15+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
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
<%
	RecordSet.executeProc("HrmSchedule_Select_ResouceAll","");
	ArrayList resouce_ids = new ArrayList();
	ArrayList ids = new ArrayList();
	int Resouce_id=0;
	String dept_id="";
	String Resouce_name="";
	int needdept=1;
	while(RecordSet.next()){
		resouce_ids.add(RecordSet.getString(2));
		ids.add(RecordSet.getString(1));
	}
	while(DepartmentComInfo.next()){
		for(int i=0;i<resouce_ids.size();i++){
			Resouce_id=Util.getIntValue((String)resouce_ids.get(i),0);
			dept_id=ResourceComInfo.getDepartmentID(Resouce_id+"");
			Resouce_name=Util.toScreen(ResourceComInfo.getResourcename(Resouce_id+""),user.getLanguage());
			if(dept_id.equals(DepartmentComInfo.getDepartmentid())){
				if(needdept==1){
		%>		
		<UL><LI><%=DepartmentComInfo.getDepartmentmark()%>-<%=DepartmentComInfo.getDepartmentname()%>
				<%}%>
		    <UL><LI><a href="HrmResouceSchedule2.jsp?id=<%=(String)ids.get(i)%>"><%=Resouce_name%></a></UL></LI>	  
		<%
				needdept=0;
				continue;
				}
		
		}
		if(needdept==0){
		%>
			</UL></LI>
		<%
			needdept=1;
		}
	}
%>
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