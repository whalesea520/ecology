
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
String userid = user.getUID()+"";
char flag = 2;
String ProcPara = "";

String method = Util.null2String(request.getParameter("method"));
String questionid = Util.null2String(request.getParameter("questionid"));
String votingid = Util.null2String(request.getParameter("votingid"));
String subject = Util.null2String(request.getParameter("subject"));
String desc = Util.null2String(request.getParameter("desc"));
String ismulti = Util.null2String(request.getParameter("ismulti"));
String ismultino = Util.null2String(request.getParameter("ismultino"));
String showorder = Util.null2String(request.getParameter("showorder"));

if(ismulti.equals(""))  ismulti="0";
if("".equals(ismultino)) ismultino = "0";
String isother = Util.null2String(request.getParameter("isother"));
if(isother.equals(""))  isother="0";

if(method.equals("add")){
    int nodesnum=Util.getIntValue(request.getParameter("nodesnum"));
    String questioncount = "0" ;
    for(int i=0;i<nodesnum;i++){
        subject = Util.null2String(request.getParameter("subject_"+i));
        if(subject.equals(""))  
            continue;
        desc = Util.null2String(request.getParameter("desc_"+i));
        ismulti = Util.null2String(request.getParameter("ismulti_"+i));
        ismultino = Util.null2String(request.getParameter("ismultino_"+i));
        showorder = Util.null2String(request.getParameter("showorder_"+i));
        if(ismulti.equals(""))  ismulti="0";
        if("".equals(ismultino)) ismultino = "0";
        isother = Util.null2String(request.getParameter("isother_"+i));
        if(isother.equals(""))  isother="0";
        ProcPara = votingid + flag + subject + flag + desc + flag + ismulti + flag + isother + flag + questioncount + flag + ismultino + flag + showorder;
        RecordSet.executeProc("VotingQuestion_Insert",ProcPara);
    }
}
if(method.equals("edit")){
    ProcPara = questionid + flag + votingid + flag + subject + flag + desc + flag + ismulti + flag + isother + flag + ismultino;
    RecordSet.executeProc("VotingQuestion_Update",ProcPara);
    if(!"".equals(showorder)) {
		RecordSet.executeSql("update votingquestion set showorder = "+showorder+" where id="+questionid);
	}
}
if(method.equals("delete")){
    RecordSet.executeProc("VotingQuestion_Delete",questionid);
}
%>
<script type="text/javascript">
	window.parent.returnValue = {id:"", name:""};
	window.parent.close();
</script>