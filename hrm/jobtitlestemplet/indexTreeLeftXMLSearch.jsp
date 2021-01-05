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
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" /><jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" /><jsp:useBean id="JobTitlesTempletComInfo" class="weaver.hrm.job.JobTitlesTempletComInfo" scope="page" />
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
		weaver.hrm.job.JobTitlesTempletComInfo JobTitlesTempletComInfo = new weaver.hrm.job.JobTitlesTempletComInfo();
		JobTitlesTempletComInfo.setTofirstRow();
		while(JobTitlesTempletComInfo.next()){
			if(JobTitlesTempletComInfo.getJobactivityid().equals(id)){
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
System.out.println("前台传过来的参数：" + condition);//输出结果：来自前台我不是乱码

%>
<%
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

StringBuffer treeStr = new StringBuffer();
JSONArray jObject = null;

//第三级
Map tree3 = new HashMap();
JobTitlesTempletComInfo.setTofirstRow();
while(JobTitlesTempletComInfo.next()){
	treeStr = new StringBuffer();
	
	String name=JobTitlesTempletComInfo.getJobTitlesmark();
	String id = JobTitlesTempletComInfo.getJobTitlesid();
	String jobactivityid = JobTitlesTempletComInfo.getJobactivityid();
	
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
System.out.println("tree3>>>"+tree3);

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
System.out.println("tree2>>>"+tree2);

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

System.out.println("tree1>>>"+tree1);

weaver.common.util.string.StringUtil.parseXml(out, envelope);
%>