
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="MeetingViewer" class="weaver.meeting.MeetingViewer" scope="page"/>

<%

	RecordSet.executeSql("select id from Meeting order by id");
    while(RecordSet.next()){
    MeetingViewer.setMeetingShareById(RecordSet.getString("id"));
    }

out.print("Change OK!");
%>
