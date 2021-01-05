
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfoRight" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<tree>
<%
User user = HrmUserVarify.getUser (request , response);
if(user == null)  return ;
response.setHeader("Pragma","No-cache"); 
response.setHeader("Cache-Control","no-cache"); 
response.setDateHeader("Expires", 0);
String workflowType = Util.null2String(request.getParameter("workflowType"));
int infoid = Util.getIntValue(request.getParameter("infoid"),0);
int subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"),0);
int typeid = Util.getIntValue(request.getParameter("typeid"),0);
String detachablestr = request.getParameter("detachable");
int detachable = 0;
if(null==detachablestr)
{
	boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
	if(isUseWfManageDetach){
		detachable = 1;
	}
}
else
{
	detachable = Util.getIntValue(detachablestr,0);
}
int[] subcomids1= null;
//subcomids1=CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"WorkflowMonitor:All");
if(detachable==1)
	subcomids1=CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"WorkflowMonitor:All",1);
else
	subcomids1=CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"WorkflowMonitor:All");
out.println(WorkflowComInfo.getWFTreeXMLByType2(workflowType,""+infoid,subcomids1,""+user.getUID(),typeid,subcompanyid,detachable));

%>
</tree>