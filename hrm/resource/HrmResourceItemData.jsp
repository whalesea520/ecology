
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="net.sf.json.*"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<%@page import="weaver.workflow.search.WorkflowRequestUtil"%>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page"/>
<jsp:useBean id="SearchComInfo" class="weaver.proj.search.SearchComInfo" scope="page"/>
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page"/>
<jsp:useBean id="BlogShareManager" class="weaver.blog.BlogShareManager" scope="page"/>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;

//问题1
TestWorkflowCheck twc=new TestWorkflowCheck();
if(twc.checkURI(session,request.getRequestURI(),request.getQueryString())){
  return;
}

String resourceid = request.getParameter("resourceid");
String currentUserId = "" + user.getUID();

JSONArray json = new JSONArray();
JSONObject data = new JSONObject();

int wf_count = new WorkflowRequestUtil().getRequestCount(user,resourceid);
//流程
data.put("name","item_workflow");
data.put("value",wf_count);
data.put("url","/workflow/request/RequestView.jsp?resourceid="+resourceid+"&isfromtab=true");
json.add(data);

//文档
Object[] docInfo = DocSearchComInfo.getDocCount4Hrm(resourceid,user);
data.put("name","item_word");
data.put("value",docInfo[1]);
data.put("url",docInfo[0]);
json.add(data);

//客户
String[] crmInfo = CrmShareBase.getCrmCount4Hrm(resourceid,currentUserId);
data.put("name","item_custom");
data.put("value",crmInfo[1]);
data.put("url",crmInfo[0]);
json.add(data);

//项目
String[] prjInfo = SearchComInfo.getPrjCount4Hrm(resourceid,user);
data.put("name","item_project");
data.put("value",prjInfo[1]);
data.put("url",prjInfo[0]);
json.add(data);

//资产
String[] cptInfo = CptSearchComInfo.getCptCount4Hrm(resourceid,user);
data.put("name","item_cpt");
data.put("value",cptInfo[1]);
data.put("url",cptInfo[0]);
json.add(data);
	 
//协作
String[] coworkInfo = CoworkShareManager.getCoworkCount4Hrm(resourceid,currentUserId);
data.put("name","item_cowork");
data.put("value",coworkInfo[1]);
data.put("url",coworkInfo[0]);
json.add(data);

//微博
String[] weiboInfo = BlogShareManager.getBlogCount4Hrm(resourceid);
data.put("name","item_weibo");
data.put("value",weiboInfo[1]);
data.put("url",weiboInfo[0]);
json.add(data);

out.print(json.toString());
%>