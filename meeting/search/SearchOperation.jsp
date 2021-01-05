
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="MeetingSearchComInfo" class="weaver.meeting.search.SearchComInfo" scope="session" />
<%
MeetingSearchComInfo.resetSearchInfo();

String msg=Util.null2String(request.getParameter("msg"));
String from=Util.null2String(request.getParameter("from"));
if(msg.equals("report")){
}

String destination = Util.null2String(request.getParameter("destination"));
if(destination.equals("myMeeting"))
{
}

String meetingtypes[]=request.getParameterValues("meetingtype");
String meetingtype="";
if(meetingtypes != null)
{
	for(int i=0;i<meetingtypes.length;i++)
	{
		meetingtype +=","+meetingtypes[i];
	}
	meetingtype = meetingtype.substring(1);
}

//added by Charoes Huang On July 29,2004
String meetingstatusArray[]=request.getParameterValues("meetingstatus");
String meetingstatus="";
String mstatus1="";//用来区分会议状态：正常和结束
String mstatus2="";
if(meetingstatusArray != null)
{
	for(int i=0;i<meetingstatusArray.length;i++)
	{
	   if(!meetingstatusArray[i].equals("5")){
		meetingstatus +=","+meetingstatusArray[i];
	     if(meetingstatusArray[i].equals("2"))
	        mstatus2=meetingstatusArray[i];
	  }else{ 
	   	meetingstatus +=","+2;
		mstatus1=meetingstatusArray[i];
		}
	}
	if(!"".equals(meetingstatus)){
		meetingstatus = meetingstatus.substring(1);
	}
}


MeetingSearchComInfo.setmeetingtype(meetingtype);
MeetingSearchComInfo.setname(Util.null2String(request.getParameter("name")));
MeetingSearchComInfo.setaddress(Util.null2String(request.getParameter("address")));
MeetingSearchComInfo.setcallers(Util.null2String(request.getParameter("callers")));
MeetingSearchComInfo.setcontacters(Util.null2String(request.getParameter("contacters")));
MeetingSearchComInfo.setcreaters(Util.null2String(request.getParameter("creaters")));
MeetingSearchComInfo.sethrmids(Util.null2String(request.getParameter("hrmids")));
MeetingSearchComInfo.setcrmids(Util.null2String(request.getParameter("crmids")));
MeetingSearchComInfo.setbegindate(Util.null2String(request.getParameter("begindate")));
MeetingSearchComInfo.setenddate(Util.null2String(request.getParameter("enddate")));

MeetingSearchComInfo.setprojectid(Util.null2String(request.getParameter("projectid")));
MeetingSearchComInfo.setmeetingstatus(meetingstatus);
//out.print(request.getParameter("projectid"));

if ("monitor".equals(from)) 
{
    response.sendRedirect("/meeting/Maint/MeetingMonitor.jsp?mstatus1="+mstatus1+"&mstatus2="+mstatus2);
    return;
}
response.sendRedirect("/meeting/search/SearchResult.jsp?start=1&perpage=10&mstatus1="+mstatus1+"&mstatus2="+mstatus2);

%>
