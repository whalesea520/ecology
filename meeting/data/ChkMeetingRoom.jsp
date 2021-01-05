<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.*"%>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="meetingSetInfo" class="weaver.meeting.Maint.MeetingSetInfo" scope="page"/>
<jsp:useBean id="MeetingRoomComInfo" class="weaver.meeting.Maint.MeetingRoomComInfo" scope="page"/>

<%
    String meetingaddress = Util.null2String(request.getParameter("address"));
	String begindate = Util.null2String(request.getParameter("begindate"));
	String begintime = Util.null2String(request.getParameter("begintime"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String endtime = Util.null2String(request.getParameter("endtime"));
	String requestid = Util.null2String(request.getParameter("requestid"));
	String meetingids=Util.null2String(request.getParameter("meetingid"));
	List<String> arr=new ArrayList();
	String returnstr = "0";
	if(meetingSetInfo.getRoomConflictChk() == 1 ){
		if(!"".equals(requestid)&&!"-1".equals(requestid)) {
		   RecordSet.executeQuery("select approveid from Bill_Meeting where requestid=?",requestid);
		   if(RecordSet.next()) {
			  meetingids = Util.null2String(RecordSet.getString("approveid"));
		   }
		}
		RecordSet.executeQuery("select address,begindate,enddate,begintime,endtime,id from meeting where meetingstatus in (1,2) and repeatType = 0 and isdecision<2 and (cancel is null or cancel<>'1') and (begindate <= ? and enddate >=?)",enddate,begindate);
		while(RecordSet.next()) {
			String begindatetmp = Util.null2String(RecordSet.getString("begindate"));
			String begintimetmp = Util.null2String(RecordSet.getString("begintime"));
			String enddatetmp = Util.null2String(RecordSet.getString("enddate"));
			String endtimetmp = Util.null2String(RecordSet.getString("endtime"));
			String addresstmp = Util.null2String(RecordSet.getString("address"));
			String mid = Util.null2String(RecordSet.getString("id"));

			String str1 = begindate+" "+begintime;
			String str2 = enddatetmp+" "+endtimetmp;
			String str3 = enddate+" "+endtime;
			String str4 = begindatetmp+" "+begintimetmp;

			String[] address=addresstmp.split(",");
			for(int i=0;i<address.length;i++){
				if(!"".equals(meetingaddress) && (","+meetingaddress+",").indexOf(","+address[i]+",")>-1 && !mid.equals(meetingids)) {
					if((str1.compareTo(str2) < 0 && str3.compareTo(str4) > 0)) {
						if(!arr.contains(address[i])){
							arr.add(address[i]);
						}
					}
				}
			}
		}
	}
	for(int i=0;i<arr.size();i++){
		String name=MeetingRoomComInfo.getMeetingRoomInfoname(arr.get(i));
		if("0".equals(returnstr)){
			returnstr="["+name+"]";
		}else{
			returnstr+="\n["+name+"]";
		}
	}
    response.setContentType("text/html;charset=utf-8");
    response.setHeader("Cache-Control", "no-cache");  
    out.write(returnstr);

%>
