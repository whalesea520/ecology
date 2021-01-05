<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.hrm.resource.TreeNode"%>
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.company.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@page import="weaver.hrm.resource.MutilResourceBrowser"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="weaver.hrm.country.CountryComInfo"%>
<%@page import="weaver.hrm.province.ProvinceComInfo"%>
<%@page import="weaver.hrm.city.CityComInfo"%>
<%@page import="weaver.hrm.city.CitytwoComInfo"%>
<%@page import="weaver.hrm.job.JobGroupsComInfo"%>
<%@page import="weaver.hrm.job.JobActivitiesComInfo"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.alibaba.fastjson.JSON"%>
<%@page import="java.net.URLDecoder"%>
<jsp:useBean id="MutilResourceBrowser" class="weaver.hrm.resource.MutilResourceBrowser" scope="page" /><jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%!
public  TreeNode getCountryTreeList(TreeNode treeList,String searchStr) throws Exception{

	List<String> jcid = new ArrayList<String>();
	List<String> jcName = new ArrayList<String>();
	
	List<String> rsid = new ArrayList<String>();
	List<String> rsName = new ArrayList<String>();
	List<String> rsSubId = new ArrayList<String>();
	
	JobGroupsComInfo jc = new JobGroupsComInfo();
	JobActivitiesComInfo rs = new JobActivitiesComInfo();

	RecordSet recordSet = new RecordSet();
    
	recordSet.executeSql("select * from HrmJobActivities where jobactivityname like   '%"+searchStr+"%'");
    while(recordSet.next()){
    	rsid.add(recordSet.getString("id"));
    	rsName.add(recordSet.getString("jobactivityname"));
    	rsSubId.add(recordSet.getString("jobgroupid"));
    }
    
	recordSet = new RecordSet();
	recordSet.executeSql("select * from HrmJobGroups where jobgroupname like   '%"+searchStr+"%'");
    while(recordSet.next()){
    	jcid.add(recordSet.getString("id"));
    	jcName.add(recordSet.getString("jobgroupname"));
    }
    
	recordSet = new RecordSet();
    for(String subid : rsSubId){
		recordSet.executeSql("select * from HrmJobGroups where id='"+subid+"'");
		while(recordSet.next()){
			if(!jcid.contains(recordSet.getString("id"))){
		    	jcid.add(recordSet.getString("id"));
		    	jcName.add(recordSet.getString("jobgroupname"));
			}
    	}
    }
	
	
	 Map<String,TreeNode> counMap = new HashMap<String,TreeNode>();
	 
	for(int n = 0;n<rsid.size();n++){
		TreeNode counNode = new TreeNode();
    	counNode.setId(rsid.get(n));
    	counNode.setNodeid("province_"+rsid.get(n));
    	counNode.setPid(rsSubId.get(n));
		counNode.setType("province");
		counNode.setName(rsName.get(n));
		counMap.put(""+rsSubId.get(n),counNode);
	}
	
	for(int n = 0;n<jcid.size();n++){
		TreeNode counNode = new TreeNode();
    	counNode.setId(jcid.get(n));
    	counNode.setNodeid("country_"+jcid.get(n));
    	counNode.setPid("0");
		counNode.setType("country");
		counNode.setName(jcName.get(n));
		if(counMap.get(jcid.get(n)+"") != null){
   			counNode.setOpen("true");
      		counNode.AddChildren(counMap.get(jcid.get(n)+""));
		}else{
   			counNode.setOpen("false");
		}
        treeList.AddChildren(counNode);
	}
	return treeList;
}


public TreeNode getCountryTreeList(TreeNode companyTreeList, String subId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
	//getDepartTreeList(companyTreeList, subId, "0",selectedids,isNoAccount, user, sqlwhere);
	
	JobGroupsComInfo jc = new JobGroupsComInfo();
	jc.setTofirstRow();
	
 	while(jc.next()){
		String id = jc.getJobGroupsid();
		String name = jc.getJobGroupsname();
		TreeNode jobGroupsNode = new TreeNode();
		jobGroupsNode.setId(id);
		jobGroupsNode.setNodeid("country_"+id);
		jobGroupsNode.setPid(subId);
		jobGroupsNode.setNocheck("N");
		int childNum= hasChild(id);
		if(childNum>0){
			jobGroupsNode.setIsParent("true");
			jobGroupsNode.setName(name+"("+childNum+")");
		}else{
			jobGroupsNode.setName(name);
		}
		jobGroupsNode.setType("country");
		companyTreeList.AddChildren(jobGroupsNode);
 	
 	}
 	
	return companyTreeList;
}

public TreeNode getProvinceTreeList(TreeNode departTreeList, String subId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
	JobActivitiesComInfo rs = new JobActivitiesComInfo();
	rs.setTofirstRow();
   
    while (rs.next()) {
    	String curgroupid = rs.getJobgroupid();
    	if(!curgroupid.equals(subId))continue;

 		String name=rs.getJobActivitiesname();
 		String id = rs.getJobActivitiesid();
 		
        TreeNode jobActivitiesNode = new TreeNode();
        jobActivitiesNode.setNocheck("Y");
        jobActivitiesNode.setId(id);
        jobActivitiesNode.setNodeid("province_"+id);
        jobActivitiesNode.setPid(subId);
		jobActivitiesNode.setName(name);
        jobActivitiesNode.setType("province");
       	departTreeList.AddChildren(jobActivitiesNode);
    }

      return departTreeList;
  }


/**
 * 指定节点下是否有子节点
 * @param type  com:分部;dept:部门
 * @param id   节点id
 * @return  boolean
 * @throws Exception
 */
private int hasChild(String id) throws Exception {
	int hasChild = 0;

  JobActivitiesComInfo rs = new JobActivitiesComInfo();
	rs.setTofirstRow();
	while (rs.next()) {
		if (rs.getJobgroupid().equals(id))
			hasChild++;
	}
	return hasChild;
}

%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String id=Util.null2String(request.getParameter("id"));
if(id.equals("0")) id="";

String type=Util.null2String(request.getParameter("type"));
String virtualtype=Util.null2String(request.getParameter("virtualtype"));
String selectedids=Util.null2String(request.getParameter("selectedids"));
String alllevel=Util.null2String(request.getParameter("alllevel"));
String isNoAccount=Util.null2String(request.getParameter("isNoAccount"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String cmd=Util.null2String(request.getParameter("cmd"));
String searchStr=URLDecoder.decode(Util.null2String(request.getParameter("searchStr")),"UTF-8");

selectedids = MutilResourceBrowser.getExcludeSqlWhere(selectedids,alllevel,isNoAccount,user, sqlwhere);

ArrayList selectList = new ArrayList();
if(selectedids.length()>0){
	String[] tmp_selectedids = selectedids.split(",");
	for(String selectedid:tmp_selectedids){
		selectList.add(selectedid);
	}
}
JSONArray jObject = null;
TreeNode envelope=new TreeNode();
if(!searchStr.equals("")){
	TreeNode root1 = new TreeNode();
	String titleName=SystemEnv.getHtmlLabelNames("332,357",user.getLanguage());
	root1.setNodeid("country_"+0);
	root1.setName(titleName);
	root1.setId("0");
	root1.setOpen("true");
	root1.setTarget("_self"); 
  	//root1.setIcon("/images/treeimages/global_wev8.gif");
  	root1.setIconClose("y");
	root1.setType("country");
	//root.AddChildren(root1);
	try{
		getCountryTreeList(root1,searchStr);
		if(root1.getChildren().size() == 0){
			out.println("[]");
		}else{
		
			out.println(JSON.toJSONString(root1));
		}
	}catch(Exception e){
		e.printStackTrace();
	}
}else{
	if("".equals(id)){
		//初始化
		//TreeNode root = new TreeNode();
		TreeNode root1 = new TreeNode();
		//String companyname = CompanyComInfo.getCompanyname("1");
		String titleName=SystemEnv.getHtmlLabelNames("332,357",user.getLanguage());
		root1.setNodeid("country_"+0);
		root1.setName(titleName);
		root1.setId("0");
		root1.setOpen("true");
		root1.setTarget("_self"); 
	  	//root1.setIcon("/images/treeimages/global_wev8.gif");
	  	root1.setIconClose("y");
		root1.setType("country");
		//root.AddChildren(root1);
		getCountryTreeList(root1,"0",selectList,isNoAccount, user, sqlwhere);
		jObject = JSONArray.fromObject(root1);
	}  else if(!"".equals(id)){
		getProvinceTreeList(envelope,id,selectList,isNoAccount, user, sqlwhere);
		ArrayList<TreeNode> lsChild = envelope.getChildren();
		jObject = JSONArray.fromObject(lsChild);		
	}
	out.println(jObject.toString());
}
%>