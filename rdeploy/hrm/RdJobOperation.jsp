<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%
HttpServletRequest fu = request;
String deptid = Util.null2String(fu.getParameter("deptid"));
String jobname = Util.null2String(fu.getParameter("jobname"));
String jobactivitId = Util.null2String(fu.getParameter("jobactivitId"));
char separator = Util.getSeparator() ;

String para = jobname + separator + jobname + separator + 
deptid + separator + jobactivitId + separator + 
""+ separator + "" + separator + 
"";

RecordSet.executeProc("HrmJobTitles_Insert",para);

int id=-1;

if(RecordSet.next()){
   id = RecordSet.getInt(1);
}
JobTitlesComInfo.removeJobTitlesCache();
%>

	<SCRIPT LANGUAGE='JavaScript'>
		parent.getParentWindow(window).setJobId('<%=id%>','<%=jobname%>');
		//parent.getParentWindow(window).setJobId('<%=id%>','11111');
		window.parent.Dialog.close();
	</SCRIPT>