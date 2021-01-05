
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.meeting.MeetingShareUtil"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>
<jsp:useBean id="mtr" class="weaver.meeting.Maint.MeetingForTypeReport" scope="page"/>
<jsp:useBean id="SptmForMeeting" class="weaver.splitepage.transform.SptmForMeeting" scope="page"/>

<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" /> 


<%!
public String formatText(String str, int len){
	return str.length() > len?str.substring(0,len)+"...":str;
}
%>

<%
User user = HrmUserVarify.getUser(request,response);
int userSub = user.getUserSubCompany1(); 
Calendar calendar = Calendar.getInstance();
boolean isUseMtiManageDetach=ManageDetachComInfo.isUseMtiManageDetach();
int detachable=0;
if(isUseMtiManageDetach){
	detachable=1;
   session.setAttribute("detachable","1");
   session.setAttribute("meetingdetachable","1");
}else{
	detachable=0;
   session.setAttribute("detachable","0");
   session.setAttribute("meetingdetachable","0");
}
    
char flag=2;
String userid=user.getUID()+"" ;

Calendar today = Calendar.getInstance();
int currentyear=today.get(Calendar.YEAR);

String sqlwhere = "";

ArrayList meetingTypeids = new ArrayList() ;
Map meetingTypenames = new HashMap() ;

int year = Util.getIntValue(request.getParameter("year"),currentyear);
String types = Util.null2String(request.getParameter("types"));
if(!"".equals(types)){
	sqlwhere += " and a.id in ("+types+") ";
}

String sql = "select a.id, a.name from Meeting_Type a where 1=1 " + MeetingShareUtil.getTypeShareSql(user) + sqlwhere + " order by id";
//System.out.println("sql2233:"+sql);
RecordSet.executeSql(sql);
while(RecordSet.next()){
    String tmpmeetingroomid=RecordSet.getString(1);
    String tmpmeetingroomname=RecordSet.getString(2);
    meetingTypeids.add(tmpmeetingroomid) ;
    meetingTypenames.put(tmpmeetingroomid, tmpmeetingroomname) ;
}

mtr.setYear(year);

Map dataMap = mtr.getReportDate();

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15881,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
  <table class=MI id=AbsenceCard  cellSpacing=0 cellPadding=0>
		<tr>	
			<td style="BORDER-TOP: 0px; BORDER-LEFT: 0px;">
				<table width="100%" border=0 cellspacing=0 cellpadding=0 Style="width:100%; font-size:8pt;table-layout:fixed">
				    <tr  bgcolor="#f7f7f7"  >
						<td width=28% style="border-bottom:1px solid #59b0f2"  height="25px" align=center >
						<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage())%>
						</td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;" align="center"><%=SystemEnv.getHtmlLabelName(1492,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1493,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1494,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1495,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1496,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1497,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1498,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1499,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1800,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1801,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1802,user.getLanguage())%></td>
						<td width="6%" style="border-bottom:1px solid #59b0f2;border-left:0px;" align="center"><%=SystemEnv.getHtmlLabelName(1803,user.getLanguage())%></td>
				    </tr>
				   <% 			
				    for(int k=0;k<meetingTypeids.size();k++){
				        int tmptypeid=Util.getIntValue(meetingTypeids.get(k)==null?"-1":meetingTypeids.get(k).toString());
				        if(tmptypeid == -1) continue;
				        String tmpname = meetingTypenames.get(String.valueOf(tmptypeid)) == null?" ":meetingTypenames.get(String.valueOf(tmptypeid)).toString();
				   %>
				        <tr class="selectable">
							<%if(k==0) {%>
					            <td class="roomnames" style="BORDER-TOP: 0px" width=28% title="<%=tmpname%>" >&nbsp;<%=Util.forHtml(Util.toScreen(tmpname,user.getLanguage()))%></td>
					        <%}else{%>
								<td class="roomnames" width=28% title="<%=tmpname%>" >&nbsp;<%=Util.forHtml(Util.toScreen(tmpname,user.getLanguage()))%></td>
							<%}%>
							<%					        
					       
			            	if (!dataMap.containsKey(tmptypeid) || dataMap.get(tmptypeid) == null) { 
			            		for (int p=0 ;p<12;p++) {
			            			if(k==0) {
			            				out.println("<td  style=\"color:#fff;BORDER-TOP: 0px\" >&nbsp;</td>");
			            			}else{
			            				out.println("<td  style=\"color:#fff\" >&nbsp;</td>");
			            			}
			            		}
			            		continue;
			            	};	
			            	Integer[] dataArry = (Integer[])dataMap.get(tmptypeid);
			            	for(int i = 0; i < 12; i++){
			            		int dt = dataArry[i];
			            		if(dt > 0){
			            		 %>
									<%if(k==0) {%>
										<td bgcolor="#fdfbfa" style="BORDER-TOP: 0px" align=center onclick="showTypeMeetingList(<%=year %>,<%=i+1 %>,<%=tmptypeid %>,event)" ><%=dt %></td>
									<%}else{%>
										<td bgcolor="#fdfbfa" align=center onclick="showTypeMeetingList(<%=year %>,<%=i+1 %>,<%=tmptypeid %>,event)" ><%=dt %></td>
									<%}%>
								<%
					        	} else {
					        	%>
									<%if(k==0) {%>
										<td bgcolor="#fdfbfa" style="BORDER-TOP: 0px" align=center >&nbsp;</td>
									<%}else{%>
										<td bgcolor="#fdfbfa" align=center >&nbsp;</td>
									<%}%>
					        	<%
					        	}
			            	}
			            	%>
						</tr>
				<%}%>
			</table>
		</td>
	</tr>
</table>