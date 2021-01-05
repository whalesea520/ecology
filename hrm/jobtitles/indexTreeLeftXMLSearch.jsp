<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.common.util.string.StringUtil"%>
<%@page import="weaver.docs.category.MultiCategoryTree"%>
<%@page import="weaver.docs.category.security.MultiAclManager"%>
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" /><jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" /><jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<%!
private boolean hasChild(String id, String cmd) throws Exception {
	boolean hasChild = false;
	if(cmd.equals("jobgroup")){
		weaver.hrm.job.JobActivitiesComInfo JobActivitiesComInfo = new weaver.hrm.job.JobActivitiesComInfo();
		JobActivitiesComInfo.setTofirstRow();
		while(JobActivitiesComInfo.next()){
			if(JobActivitiesComInfo.getJobgroupid().equals(id)){
				hasChild = true;
				break;
			}
		}
	}else if(cmd.equals("jobactivites")){
		weaver.hrm.job.JobTitlesComInfo JobTitlesComInfo = new weaver.hrm.job.JobTitlesComInfo();
		JobTitlesComInfo.setTofirstRow();
		while(JobTitlesComInfo.next()){
			if(JobTitlesComInfo.getJobactivityid().equals(id)){
				hasChild = true;
				break;
			}
		}
	}
	return hasChild;
}
%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

String condition=Util.null2String(request.getParameter("condition"));

condition = condition==null?"":URLDecoder.decode(condition,"UTF-8");

%>
<%
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

StringBuffer treeStr = new StringBuffer();
JSONArray jObject = null;

//第三级
Map tree3 = new HashMap();
JobTitlesComInfo.setTofirstRow();
while(JobTitlesComInfo.next()){
	treeStr = new StringBuffer();
	
	String name=JobTitlesComInfo.getJobTitlesmark();
	String id = JobTitlesComInfo.getJobTitlesid();
	String jobactivityid = JobTitlesComInfo.getJobactivityid();
	
	if(!name.contains(condition)){
		continue;
	}
	
	tree3.put(jobactivityid,jobactivityid);
	TreeNode node=new TreeNode();
	node.setTitle(name);
	node.setValue(id);
	node.setNodeId("jobtitlestemplet_"+id);
	node.setHref("javascript:onClickJobGroup(" + id + ")");
	node.setTarget("_self");
	//envelope.addTreeNode(node);
}

//第二级
Map tree2 = new HashMap();
JobActivitiesComInfo.setTofirstRow();

while(JobActivitiesComInfo.next()){
	treeStr = new StringBuffer();
		
   String curgroupid = JobActivitiesComInfo.getJobgroupid();
       
	String name=JobActivitiesComInfo.getJobActivitiesname();
	String id = JobActivitiesComInfo.getJobActivitiesid();
	String jobgroupid = JobActivitiesComInfo.getJobgroupid();
	
	if(!name.contains(condition)){
		if(tree3.get(id) == null){
				continue;
		}
	}
	
	tree2.put(jobgroupid,jobgroupid);
	TreeNode node=new TreeNode();
	node.setTitle(name);
	node.setValue(id);
	node.setNodeId("jobactivities_"+id);
	node.setHref("javascript:onClickJobGroup(" + id + ")");
	node.setTarget("_self");
  	if (hasChild(id, "jobactivites")) {
  		node.setNodeXmlSrc("indexTreeLeftXML.jsp?jobactivite=" + id);
   }
	//envelope.addTreeNode(node);
}

Map tree1 = new HashMap();
JobGroupsComInfo.setTofirstRow();
while(JobGroupsComInfo.next()){
	String name=JobGroupsComInfo.getJobGroupsname();
	String id = JobGroupsComInfo.getJobGroupsid();
	
	if(!name.contains(condition)){
		if(tree2.get(id) == null){
				continue;
		}
	}
	
	tree1.put(id,id);
	TreeNode node=new TreeNode();
	node.setTitle(name);
	node.setValue(id);
	node.setNodeId("jobgroup_"+id);
	node.setHref("javascript:onClickJobGroup(" + id + ")");
	node.setTarget("_self");
	 	if (hasChild(id, "jobgroup")) {
	 		node.setNodeXmlSrc("indexTreeLeftXML.jsp?jobgroup=" + id);
	  }
	envelope.addTreeNode(node);
}

weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>