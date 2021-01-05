
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.hrm.resource.TreeNode"%>
<%@ page import="weaver.hrm.companyvirtual.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@page import="weaver.hrm.resource.MutilResourceBrowser"%>
<%@page import="java.util.Map"%>
<jsp:useBean id="MutilResourceBrowser" class="weaver.hrm.resource.MutilResourceBrowser" scope="page"/><jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page"/><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<%!
public TreeNode getSubCompanyTreeList(TreeNode companyTreeList, String subId, String virtualtype, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
	
	getDepartTreeList(companyTreeList, subId, "0", selectedids, isNoAccount, user, sqlwhere);
	
	SubCompanyVirtualComInfo rs = new SubCompanyVirtualComInfo();
	rs.setTofirstRow();
	while (rs.next()) {
		String id = rs.getSubCompanyid();
		String supsubcomid = rs.getSupsubcomid();
		String tmp_virtualtype = rs.getCompanyid();
		if(!virtualtype.equals(tmp_virtualtype))continue;
		if (supsubcomid.equals(""))supsubcomid = "0";
		if (!supsubcomid.equals(subId))continue;
			  	
		String name = rs.getSubCompanyname();
		 String canceled = rs.getCompanyiscanceled();
		
		TreeNode subCompanyNode = new TreeNode();
		subCompanyNode.setName(name);
		subCompanyNode.setId(id);
		subCompanyNode.setNodeid("subcom_"+id);
		subCompanyNode.setPid(subId);
		subCompanyNode.setIcon("/images/treeimages/Home_wev8.gif");
		subCompanyNode.setNocheck("N");
		subCompanyNode.setType("subcom");
		if(hasChild("subcompany",id)){
			subCompanyNode.setIsParent("true");
		}
		if(!"1".equals(canceled))companyTreeList.AddChildren(subCompanyNode);
	}
	return companyTreeList;
}

public TreeNode getDepartTreeList(TreeNode departTreeList, String subId, String departmentId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
    DepartmentVirtualComInfo rsDepartment = new DepartmentVirtualComInfo();
    rsDepartment.setTofirstRow();
   
    if(Util.getIntValue(departmentId)<0){
    	getResourceTreeList(departTreeList, departmentId,selectedids, isNoAccount, user, sqlwhere);
    }
    
    while (rsDepartment.next()) {
        if(departmentId.equals(rsDepartment.getDepartmentid()))continue;
        String supdepid = rsDepartment.getDepartmentsupdepid();
        if (departmentId.equals("0") && supdepid.equals(""))supdepid = "0";
        if (!(rsDepartment.getSubcompanyid1().equals(subId) && (supdepid.equals(departmentId)||(!rsDepartment.getSubcompanyid1(supdepid).equals(subId)&&departmentId.equals("0"))))) continue;

        String id = rsDepartment.getDepartmentid();
        String name = rsDepartment.getDepartmentname();
        String canceled = rsDepartment.getDeparmentcanceled();

        TreeNode departmentNode = new TreeNode();
        departmentNode.setName(name);
        departmentNode.setNocheck("Y");
        departmentNode.setId(id);
        departmentNode.setNodeid("dept_"+id);
        departmentNode.setType("dept");
        departmentNode.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
        if (hasChild("dept", id)) {
        	departmentNode.setIsParent("true");
        }
        if(!"1".equals(canceled))departTreeList.AddChildren(departmentNode);
    }

      return departTreeList;
  }

public TreeNode getResourceTreeList(TreeNode resourceTreeList, String departmentId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
    DepartmentVirtualComInfo rsDepartment = new DepartmentVirtualComInfo();
    ResourceComInfo ResourceComInfo = new ResourceComInfo();
    rsDepartment.setTofirstRow();
    
		String sql = " select hr.id, hr.loginid, hr.account, lastname, hr.pinyinlastname, hr.subcompanyid1, hr.jobtitle " 
			 				 + " from hrmresource hr " 
			         + "where 1=1 ";
	  AppDetachComInfo adci = new AppDetachComInfo();

		if(sqlwhere.length()>0)sqlwhere=" and " +sqlwhere;
		sqlwhere+=" and hr.status in (0,1,2,3)";
		if(adci.isUseAppDetach()){
			String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"",true,"resource_hr");
			String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
			sqlwhere+=tempstr;
		}
		if(sqlwhere.length()>0)sql+=sqlwhere;
		sql += "and exists (select * from hrmresourcevirtual where hr.id = resourceid and departmentid=" + departmentId + ") order by hr.dsporder ";

		RecordSet rs1 = new RecordSet();
		rs1.executeSql(sql);
		while (rs1.next()) {
			String id = rs1.getString("id");
			String loginid = rs1.getString("loginid");
			String lastname = rs1.getString("lastname");
			String pinyinlastname = rs1.getString("pinyinlastname");
			String jobtitle = rs1.getString("jobtitle");
			jobtitle = MutilResourceBrowser.getJobTitlesname(id);
			lastname="<span id='pinyinlastname' style='display:none'>"+pinyinlastname+"</span><span id='lastname'>"+lastname+"</span><span id='jobtitlename' style='color:#929390;margin-left:15px;margin-right:2px;'>"+jobtitle+"</span>";
			
			TreeNode resourceNode = new TreeNode();
			resourceNode.setName(lastname);
			resourceNode.setId(id);
			resourceNode.setNodeid("resource_"+id);
			resourceNode.setIcon(ResourceComInfo.getMessagerUrls(id));
			resourceNode.setNocheck("N");
			if(selectedids.contains(id)){
				resourceNode.setIsHidden("true");
			}
			
			if(!isNoAccount.equals("1")){
				if(loginid.length()==0)resourceNode.setIsHidden("true");
			}
			resourceNode.setType("resource");
			resourceTreeList.AddChildren(resourceNode);
		}
		return resourceTreeList;
}

/**
 * 指定节点下是否有子节点
 * @param type  com:分部;dept:部门
 * @param id   节点id
 * @return  boolean
 * @throws Exception
 */
private boolean hasChild(String type, String id) throws Exception {
	boolean hasChild = false;
  if (type.equals("subcompany")) {
		SubCompanyVirtualComInfo rs = new SubCompanyVirtualComInfo();
		rs.setTofirstRow();
		while (rs.next()) {
			if (rs.getSupsubcomid().equals(id) && !"1".equals(rs.getCompanyiscanceled()))
				hasChild = true;
		}
		DepartmentVirtualComInfo rsDepartment = new DepartmentVirtualComInfo();
		rsDepartment.setTofirstRow();
		while (rsDepartment.next()) {
			if (rsDepartment.getSubcompanyid1().equals(id) && !"1".equals(rsDepartment.getDeparmentcanceled())) {
				hasChild = true;
			}
		}
	} else if (type.equals("dept")) {
		DepartmentVirtualComInfo rsDepartment = new DepartmentVirtualComInfo();
		rsDepartment.setTofirstRow();
		while (rsDepartment.next()) {
			String str = rsDepartment.getSubcompanyid1(id);
			if (rsDepartment.getSubcompanyid1().equals(str) && rsDepartment.getDepartmentsupdepid().equals(id) && !"1".equals(rsDepartment.getDeparmentcanceled()))
				hasChild = true;
		}
		if(!hasChild){
			RecordSet rs = new RecordSet();
			rs.executeSql("select count(*) from HrmResourceVirtualView t1 where t1.status in (0,1,2,3) and t1.departmentid=" + id);
			if(rs.next()){
				if(rs.getInt(1)>0){
					hasChild=true;
				}
			}
		}
	}
	return hasChild;
}

private String getResourceNumJson(String nodeids, ArrayList selectedids, String sqlwhere)throws Exception{
	JSONArray jsonArr = new JSONArray();
	String[] arr_nodeid =Util.TokenizerString2(nodeids,",");
	for(String nodeid:arr_nodeid){
		
		String type = nodeid.split("_")[0];
		String id = nodeid.split("_")[1];
		String sql = "select count(*) from HrmResourceVirtualView hr where hr.status in (0,1,2,3) and 1=1 ";
		if(sqlwhere.length()>0)sql+=" and " +sqlwhere;	
		if(type.equals("dept")){
			sql += " and hr.departmentid in ( "+ DepartmentVirtualComInfo.getAllChildDepartId(id, id) +" )";
		}else if(type.equals("subcom")){
			sql += " and hr.subcompanyid in ( "+ SubCompanyVirtualComInfo.getAllChildSubcompanyId(id, id) +" )";
		}else if(type.equals("com")){
			sql += " and virtualtype="+id;
		}
		
		String ids = "";
		for(int i=0;selectedids!=null&&i<selectedids.size();i++){
			if(ids.length()>0)ids+=",";
			ids+=selectedids.get(i);
		}
		if(ids.length()>0)sql +=" and id not in ("+ids+")";
		RecordSet rs = new RecordSet();
		rs.executeSql(sql);
		if(rs.next()){
			JSONObject tmp = new JSONObject();
			tmp.put("nodeid",nodeid);
			tmp.put("nodenum",rs.getInt(1));
			jsonArr.add(tmp);
		}
	}
	return jsonArr.toString();
}
%>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String id=Util.null2String(request.getParameter("id"));
String type=Util.null2String(request.getParameter("type"));
String virtualtype=Util.null2String(request.getParameter("virtualtype"));
String cmd=Util.null2String(request.getParameter("cmd"));
String alllevel=Util.null2String(request.getParameter("alllevel"));
String selectedids=Util.null2String(request.getParameter("selectedids"));
String isNoAccount=Util.null2String(request.getParameter("isNoAccount"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
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
if(cmd.equals("getNum")){
	String jsonData = "";
	String nodeids=Util.null2String(request.getParameter("nodeids"));
	jsonData = getResourceNumJson(nodeids, selectList, sqlwhere);
	out.println(jsonData);
}else{
	if(id.equals("")){
		//初始化
		TreeNode root = new TreeNode();
		String companyname = CompanyComInfo.getCompanyname("1");
		root.setName(companyname);
		root.setId(virtualtype);
		root.setNodeid("com_"+virtualtype);
		root.setOpen("true");
		root.setTarget("_self"); 
	  root.setIcon("/images/treeimages/global_wev8.gif");
		root.setType("com");
		getSubCompanyTreeList(root,"0",virtualtype, selectList,isNoAccount, user, sqlwhere);
		jObject = JSONArray.fromObject(root);
	}else if(type.equals("subcom")){
		virtualtype = SubCompanyVirtualComInfo.getCompanyid(id); 
		getSubCompanyTreeList(envelope,id,virtualtype,selectList,isNoAccount, user, sqlwhere);
		ArrayList<TreeNode> lsChild = envelope.getChildren();
		jObject = JSONArray.fromObject(lsChild);		
	}else if(type.equals("dept")){
		DepartmentVirtualComInfo DepartmentComInfo = new DepartmentVirtualComInfo();
		String subId = DepartmentComInfo.getSubcompanyid1(id);
		getDepartTreeList(envelope,subId,id,selectList,isNoAccount, user, sqlwhere);
		ArrayList<TreeNode> lsChild = envelope.getChildren();
		jObject = JSONArray.fromObject(lsChild);		
	}
	out.println(jObject.toString());
}
%>
