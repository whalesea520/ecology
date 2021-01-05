
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
String optionid = Util.null2String(request.getParameter("optionid"));
String questionid = Util.null2String(request.getParameter("questionid"));
String votingid = Util.null2String(request.getParameter("votingid"));
String desc = Util.null2String(request.getParameter("desc"));
String showorder = Util.null2String(request.getParameter("showorder"));

if(method.equals("add")){
    int nodesnum=Util.getIntValue(request.getParameter("nodesnum"));
    String optioncount = "0" ;
    for(int i=0;i<nodesnum;i++){
        desc = Util.null2String(request.getParameter("desc_"+i));
        showorder = Util.null2String(request.getParameter("showorder_"+i));
        if(desc.equals(""))  
            continue;
        ProcPara = votingid + flag + questionid + flag + desc + flag + optioncount + flag + showorder;
        RecordSet.executeProc("VotingOption_Insert",ProcPara);
    }
}
if(method.equals("edit")){
    ProcPara = optionid + flag + votingid + flag + questionid + flag + desc;
    RecordSet.executeProc("VotingOption_Update",ProcPara);
    if(!"".equals(showorder)) {
		RecordSet.executeSql("update VotingOption set showorder = "+showorder+" where id="+optionid);
	}
}
if(method.equals("delete")){
    RecordSet.executeProc("VotingOption_Delete",optionid);
    response.sendRedirect("VotingView.jsp?votingid="+votingid);
    return;
}
%>
<script type="text/javascript">
	window.parent.returnValue = {id:"", name:""};
	window.parent.close();
</script>
