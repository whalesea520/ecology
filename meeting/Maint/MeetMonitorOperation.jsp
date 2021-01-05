
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="meetingLog" class="weaver.meeting.MeetingLog" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("meetingmonitor:Edit", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
    String operation = request.getParameter("operation");
    String meetingids = Util.null2String(request.getParameter("meetingids")) ;
	String ip=Util.getIpAddr(request);
    if (operation.equals("delMeeting")){   //点击删除时的操作
          //save data
          ArrayList idS = Util.TokenizerString(meetingids,",");
          for (int j=0 ;j<idS.size();j++){
        	  rs.executeSql("select * from meeting  where id ="+idS.get(j));
        	  if(rs.next()){
        		  meetingLog.resetParameter();
        		  meetingLog.insSysLogInfo(user,rs.getInt("id"),rs.getString("name"),"会议监控删除","303","3",1,ip);
        	  }
              rs.executeSql("delete from meeting  where id ="+idS.get(j));
              rs.executeSql("delete from Meeting_ShareDetail where meetingid="+idS.get(j));
              rs.executeSql("delete from Meeting_View_Status where meetingid="+idS.get(j));
			  rs.executeSql("DELETE FROM WorkPlan WHERE meetingId = '"+idS.get(j)+"'");
          }
          //redirect
          response.sendRedirect("MeetingMonitor.jsp");          
    }
%>

