<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.common.util.xtree.TreeNode" %>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.hrm.job.JobTitlesComInfo"%>
<%@page import="weaver.hrm.job.JobActivitiesComInfo"%>
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


private Map getTree3(String condition) throws Exception {

	Map tree3 = new HashMap();
	//第三级
	JobTitlesComInfo templet = new JobTitlesComInfo();
	templet.setTofirstRow();
	while(templet.next()){
    	String curjobactiviteid = templet.getJobactivityid();
 		String name=templet.getJobTitlesmark();
 		String id = templet.getJobTitlesid();
		
		if(!name.contains(condition)){
			continue;
		}
	
		tree3.put(curjobactiviteid,curjobactiviteid);
	}
	return tree3;
}

private Map getTree2(String condition) throws Exception {

	Map tree2 = new HashMap();
	//第二级
	JobActivitiesComInfo activities = new JobActivitiesComInfo();
	activities.setTofirstRow();
	while(activities.next()){
 		
    	String curgroupid = activities.getJobgroupid();
 		String name=activities.getJobActivitiesname();
 		String id = activities.getJobActivitiesid();
		
		if(!name.contains(condition)){
			continue;
		}
		
		tree2.put(curgroupid,curgroupid);
	}
	return tree2;
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

String jobgroup=Util.null2String(request.getParameter("jobgroup"));
if(jobgroup.equals("0")) jobgroup="";
String jobactivite=Util.null2String(request.getParameter("jobactivite"));
if(jobactivite.equals("0")) jobactivite="";
%>
<%
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

StringBuffer treeStr = new StringBuffer();
JSONArray jObject = null;
Map tree3 = new HashMap();
Map tree2 = new HashMap();
Map tree1 = new HashMap();
if(!"".equals(jobactivite)){
	//第三级
	JobTitlesComInfo.setTofirstRow();
	while(JobTitlesComInfo.next()){
 		treeStr = new StringBuffer();
 		
    String curjobactiviteid = JobTitlesComInfo.getJobactivityid();
    if(!curjobactiviteid.equals(jobactivite))continue;
        
 		String name=JobTitlesComInfo.getJobTitlesmark();
 		String id = JobTitlesComInfo.getJobTitlesid();
		
		if(!name.contains(condition)){
			continue;
		}
	
		tree3.put(curjobactiviteid,curjobactiviteid);
 		TreeNode node=new TreeNode();
		node.setTitle(name);
		node.setValue(id);
		node.setNodeId("jobtitles_"+id);
		node.setHref("javascript:onClickJobGroup(" + id + ")");
		node.setTarget("_self");
		envelope.addTreeNode(node);
	}
}else if(!"".equals(jobgroup)){
	//第二级
	JobActivitiesComInfo.setTofirstRow();
	
	while(JobActivitiesComInfo.next()){
 		treeStr = new StringBuffer();
 		
    String curgroupid = JobActivitiesComInfo.getJobgroupid();
    if(!curgroupid.equals(jobgroup))continue;
        
 		String name=JobActivitiesComInfo.getJobActivitiesname();
 		String id = JobActivitiesComInfo.getJobActivitiesid();
		
		if(!name.contains(condition)){
			if(tree3.isEmpty()){
				tree3 = getTree3(condition);
			}
			if(tree3.get(id) == null){
				continue;
			}
		}
		
		tree2.put(curgroupid,curgroupid);
 		TreeNode node=new TreeNode();
		node.setTitle(name);
		node.setValue(id);
		node.setNodeId("jobactivities_"+id);
		node.setHref("javascript:onClickJobGroup(" + id + ")");
		node.setTarget("_self");
   	if (hasChild(id, "jobactivites")) {
   		node.setNodeXmlSrc("indexTreeLeftXML.jsp?jobactivite=" + id);
    }
		envelope.addTreeNode(node);
	}
}else if("".equals(jobgroup)){
	
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
}
if(tree3.isEmpty() && tree2.isEmpty() && tree1.isEmpty()){
}else{
	weaver.common.util.string.StringUtil.parseXml(out, envelope);
}
%>