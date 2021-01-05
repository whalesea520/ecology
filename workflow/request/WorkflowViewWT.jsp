
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.*,java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="recordSet_requestbase" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int userid = Util.getIntValue(request.getParameter("userid"), 0);
int usertype = Util.getIntValue(request.getParameter("usertype"), 0);
int languageid = Util.getIntValue(request.getParameter("languageid"), 7);
String sql = "";
sql = "select * from worktask_requestbase where deleted=0 and sourceworkflowid="+requestid;
recordSet_requestbase.execute(sql);
if(recordSet_requestbase.next()){
	Hashtable worktaskStatus_hs = new Hashtable();
	sql = "select * from SysPubRef where masterCode='WorkTaskStatus' and flag=1";
	rs.execute(sql);
	while(rs.next()){
		String detailCode_tmp = ""+Util.getIntValue(rs.getString("detailCode"), 0);
		String worktaskStatusName_tmp = Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("detailLabel")), languageid));
		worktaskStatus_hs.put("worktaskstatus_"+detailCode_tmp, worktaskStatusName_tmp);
	}
	recordSet_requestbase.beforFirst();
	session.setAttribute("sourceworkflowid", ""+requestid);
%>
<br>
<table class="ListStyle">
	<colgroup>
	<col width="5%">
	<col width="30%">
	<col width="50%">
	<col width="15%">
	<tr class="HeaderForWF">
		<th colspan="4"><%=SystemEnv.getHtmlLabelName(22175, languageid)%></th>
	</tr>
	<tr class="HeaderForWF">
		<td align="center"><%=SystemEnv.getHtmlLabelName(15486, languageid)%></td>
		<td align="center"><%=SystemEnv.getHtmlLabelName(16936, languageid)%></td>
		<td align="center"><%=SystemEnv.getHtmlLabelName(22134, languageid)%></td>
		<td align="center"><%=SystemEnv.getHtmlLabelName(22074, languageid)%></td>
	</tr>
	<tr><td class="Line2" colSpan="4"></td></tr>
	<%
		int count = 0;
		String classStr = " class=\"datalight\" ";
		while(recordSet_requestbase.next()){
			String liableperson = Util.null2String(recordSet_requestbase.getString("liableperson"));
			if("".equals(liableperson)){
				continue;
			}
			count++;
			int wt_requestid = Util.getIntValue(recordSet_requestbase.getString("requestid"), 0);
			String taskcontent = Util.null2String(recordSet_requestbase.getString("taskcontent"));
			int status = Util.getIntValue(recordSet_requestbase.getString("status"), 1);
			String showName = "";
			String[] liablepersons = Util.TokenizerString2(liableperson, ",");
			for(int i=0; i<liablepersons.length; i++){
				int liableperson_tmp = Util.getIntValue(liablepersons[i]);
				String name = resourceComInfo.getLastname(""+liableperson_tmp);
				if(!"".equals(name)){
					showName += ("<a href=\"javaScript:openFullWindowHaveBar('/hrm/resource/HrmResource.jsp?id="+liableperson_tmp+"')\">"+name+"</a>&nbsp;");
				}
			}
			String status_name = Util.null2String((String)worktaskStatus_hs.get("worktaskstatus_"+status));
			out.println("<tr"+classStr+"><td align=\"center\">"+count+"</td>");
			out.println("<td>"+showName+"</td>");
			out.println("<td><a href=\"javaScript:openFullWindowHaveBar('/worktask/request/ViewWorktask.jsp?isfromworkflow=1&deswtrequestcount="+count+"&requestid="+wt_requestid+"')\">"+taskcontent+"</a></td>");
			out.println("<td align=\"center\">"+status_name+"</td></td>");
			out.println("<tr><td class=\"Line2\" colSpan=3></td></tr>");
			session.setAttribute("deswtrequestid"+count, ""+wt_requestid);
			if(count%2 == 0){
				classStr = " class=\"datalight\" ";
			}else{
				classStr = " class=\"datadark\" ";
			}
		}
	%>
</table>
<br>
<%}%>



