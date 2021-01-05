<%@ page import="weaver.general.Util" %><%@ page import="weaver.common.util.xtree.TreeNode" %><%@ page import="weaver.hrm.*" %><%@ page language="java" contentType="text/xml ; charset=UTF-8" %><%
int filterlevel = Util.getIntValue(request.getParameter("level"),0);
int filterfeetype = Util.getIntValue(request.getParameter("feetype"),0);%><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
%><jsp:useBean id="subjectComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" /><%
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String init=Util.null2String(request.getParameter("init"));
String displayarchive=Util.null2String(request.getParameter("displayarchive"));//是否显示封存科目
String fromWfFnaBudgetChgApply=Util.null2String(request.getParameter("fromWfFnaBudgetChgApply")).trim();//=1：来自系统表单预算变更申请单
int fromFnaRequest = Util.getIntValue(request.getParameter("fromFnaRequest"),-1);
int orgType = Util.getIntValue(request.getParameter("orgType"),-1);
int orgId = Util.getIntValue(request.getParameter("orgId"),-1);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
int fieldid = Util.getIntValue(request.getParameter("fieldid"),-1);
int billid = Util.getIntValue(request.getParameter("billid"),-1);

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

if(!init.equals("")&&id.equals("")){

subjectComInfo.getSubjectTreeList(envelope, type,"0",2,filterlevel,filterfeetype,displayarchive, fromWfFnaBudgetChgApply, orgType, orgId, fromFnaRequest, workflowid, fieldid, billid);

}else{
    subjectComInfo.getSubjectTreeList(envelope,type,id,1,filterlevel,filterfeetype,displayarchive, fromWfFnaBudgetChgApply, orgType, orgId, fromFnaRequest, workflowid, fieldid, billid);
}

envelope.marshal(out);
%>
