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
<%@page import="java.util.Map"%>
<jsp:useBean id="MutilResourceBrowser" class="weaver.hrm.resource.MutilResourceBrowser" scope="page" /><jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" /><jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%!
public TreeNode getSubCompanyTreeList(TreeNode companyTreeList, String subId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
	getDepartTreeList(companyTreeList, subId, "0",selectedids,isNoAccount, user, sqlwhere);
	
  	AppDetachComInfo adci = new AppDetachComInfo(user);
  	//adci.resetAppDetachInfo();
  	String alllowsubcompanystr = Util.null2String(adci.getAlllowsubcompanystr());
  	String alllowsubcompanyviewstr = Util.null2String(adci.getAlllowsubcompanyviewstr());
	//Map subMap = adci.getAllDetachSubcompanyInfo(String.valueOf(user.getUID()));
	SubCompanyComInfo rs = new SubCompanyComInfo();
	rs.setTofirstRow();
	while (rs.next()) {
		String id = rs.getSubCompanyid();
		String supsubcomid = rs.getSupsubcomid();
		if (supsubcomid.equals(""))supsubcomid = "0";
		if (!supsubcomid.equals(subId))continue;
			  	
		if(adci.isUseAppDetach() && (alllowsubcompanystr.length()>0 || alllowsubcompanyviewstr.length()>0)){
			if((","+alllowsubcompanystr+",").indexOf(","+id+",")==-1&&
				(","+alllowsubcompanyviewstr+",").indexOf(","+id+",")==-1) continue;
		}
		
		String name = rs.getSubCompanyname();
		 String canceled = rs.getCompanyiscanceled();
		
		TreeNode subCompanyNode = new TreeNode();
		subCompanyNode.setName(name);
		subCompanyNode.setId(id);
		subCompanyNode.setNodeid("subcom_"+id);
		subCompanyNode.setPid(subId);
		subCompanyNode.setIcon("/images/treeimages/Home_wev8.gif");
		subCompanyNode.setNocheck("N");
		if(hasChild("subcompany",id)){
			subCompanyNode.setIsParent("true");
		}
		subCompanyNode.setType("subcom");
		if(!"1".equals(canceled))companyTreeList.AddChildren(subCompanyNode);
		//getSubCompanyTreeList(subCompanyNode, id);
	}
	return companyTreeList;
}

public TreeNode getDepartTreeList(TreeNode departTreeList, String subId, String departmentId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
    DepartmentComInfo rsDepartment = new DepartmentComInfo();
    rsDepartment.setTofirstRow();
   
    if(departmentId.length()>0){
    	getResourceTreeList(departTreeList, departmentId,selectedids, isNoAccount, user, sqlwhere);
    }
    
  	AppDetachComInfo adci = new AppDetachComInfo(user);
  	//adci.resetAppDetachInfo();
	//Map deptMap = adci.getAllDetachDepartmentInfo(String.valueOf(user.getUID()));
	String alllowdepartmentstr = Util.null2String(adci.getAlllowdepartmentstr());
	String alllowdepartmentviewstr = Util.null2String(adci.getAlllowdepartmentviewstr());
    while (rsDepartment.next()) {
        if(departmentId.equals(rsDepartment.getDepartmentid()))continue;
        String supdepid = rsDepartment.getDepartmentsupdepid();
        if (departmentId.equals("0") && supdepid.equals(""))supdepid = "0";
        if (!(rsDepartment.getSubcompanyid1().equals(subId) && (supdepid.equals(departmentId)||(!rsDepartment.getSubcompanyid1(supdepid).equals(subId)&&departmentId.equals("0"))))) continue;

        String id = rsDepartment.getDepartmentid();
        String name = rsDepartment.getDepartmentname();
        String canceled = rsDepartment.getDeparmentcanceled();
        
        if(adci.isUseAppDetach() && (alllowdepartmentstr.length()>0||alllowdepartmentviewstr.length()>0) ){
    			if((","+alllowdepartmentstr+",").indexOf(","+id+",")==-1&&
    					(","+alllowdepartmentviewstr+",").indexOf(","+id+",")==-1) continue;
    		}
		
        TreeNode departmentNode = new TreeNode();
        departmentNode.setName(name);
        departmentNode.setNocheck("Y");
        departmentNode.setId(id);
        departmentNode.setNodeid("dept_"+id);
        departmentNode.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
        if (hasChild("dept", id)) {
        	departmentNode.setIsParent("true");
        }
        departmentNode.setType("dept");
        if(!"1".equals(canceled))departTreeList.AddChildren(departmentNode);
    }

      return departTreeList;
  }

public TreeNode getResourceTreeList(TreeNode resourceTreeList, String departmentId, ArrayList selectedids, String isNoAccount, User user, String sqlwhere) throws Exception {
    DepartmentComInfo rsDepartment = new DepartmentComInfo();
    ResourceComInfo ResourceComInfo = new ResourceComInfo();
    rsDepartment.setTofirstRow();
    
		String sql = "select hr.id, lastname, hr.pinyinlastname, hr.subcompanyid1, hr.jobtitle, loginid, account " 
							 + "from hrmresource hr, hrmdepartment t2 " 
							 + "where hr.departmentid=t2.id and t2.id=" + departmentId ;
	  AppDetachComInfo adci = new AppDetachComInfo();

		if(sqlwhere.length()>0)sqlwhere=" and " +sqlwhere;
		sqlwhere+=" and hr.status in (0,1,2,3)";
		if(adci.isUseAppDetach()){
			String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"",true,"resource_hr");
			String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
			sqlwhere+=tempstr;
		}
		if(sqlwhere.length()>0)sql+=sqlwhere;
		sql += " order by hr.dsporder ";
		//System.out.println(sql);
		RecordSet rs1 = new RecordSet();
		rs1.executeSql(sql);
		while (rs1.next()) {
			String id = rs1.getString("id");
			String lastname = rs1.getString("lastname");
			String pinyinlastname = rs1.getString("pinyinlastname");
			String jobtitle = rs1.getString("jobtitle");
			String loginid = rs1.getString("loginid");
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
		SubCompanyComInfo rs = new SubCompanyComInfo();
		rs.setTofirstRow();
		while (rs.next()) {
			if (rs.getSupsubcomid().equals(id) && !"1".equals(rs.getCompanyiscanceled()))
				hasChild = true;
		}
		DepartmentComInfo rsDepartment = new DepartmentComInfo();
		rsDepartment.setTofirstRow();
		while (rsDepartment.next()) {
			if (rsDepartment.getSubcompanyid1().equals(id) && !"1".equals(rsDepartment.getDeparmentcanceled())) {
				hasChild = true;
			}
		}
	} else if (type.equals("dept")) {
		DepartmentComInfo rsDepartment = new DepartmentComInfo();
		rsDepartment.setTofirstRow();
		while (rsDepartment.next()) {
			String str = rsDepartment.getSubcompanyid1(id);
			if (rsDepartment.getSubcompanyid1().equals(str) && rsDepartment.getDepartmentsupdepid().equals(id) && !"1".equals(rsDepartment.getDeparmentcanceled()))
				hasChild = true;
		}
		if(!hasChild){
			ResourceComInfo rsResource = new ResourceComInfo();
			rsResource.setTofirstRow();
			while (rsResource.next()) {
				String str = rsResource.getDepartmentID();
				if (str.equals(id))
					hasChild = true;
			}
		}
	}
	return hasChild;
}

private String getResourceNumJson(String nodeids, ArrayList selectedids, String isNoAccount, String sqlwhere)throws Exception{
	JSONArray jsonArr = new JSONArray();
	String[] arr_nodeid =Util.TokenizerString2(nodeids,",");
	RecordSet rs = new RecordSet();
	for(String nodeid:arr_nodeid){
		
		String type = nodeid.split("_")[0];
		String id = nodeid.split("_")[1];
		String sql = "select count(*) from hrmresource hr where 1=1 ";
		if(type.equals("dept")){
			sql += " and departmentid in ( "+ DepartmentComInfo.getAllChildDepartId(id, id) +" )";
		}else if(type.equals("subcom")){
			sql += " and subcompanyid1 in ( "+ SubCompanyComInfo.getAllChildSubcompanyId(id, id) +" )";
		}else if(type.equals("com")){
			
		}
		if(sqlwhere.length()>0)sql+=" and " +sqlwhere;
		String noAccountSql="";
	 	if(!isNoAccount.equals("1")){
			noAccountSql=" and loginid is not null "+(rs.getDBType().equals("oracle")?"":" and loginid<>'' ");
	 	}
	 	sql += noAccountSql;
		String ids = "";
		for(int i=0;selectedids!=null&&i<selectedids.size();i++){
			if(ids.length()>0)ids+=",";
			ids+=selectedids.get(i);
		}
		if(ids.length()>0)sql +=" and id not in ("+ids+")";
		rs.executeSql(sql);
		if(rs.next()){
			JSONObject tmp = new JSONObject();
			tmp.put("nodeid",nodeid);
			tmp.put("nodenum",rs.getInt(1));
			//System.out.println(rs.getInt(1));
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
String selectedids=Util.null2String(request.getParameter("selectedids"));
String alllevel=Util.null2String(request.getParameter("alllevel"));
String isNoAccount=Util.null2String(request.getParameter("isNoAccount"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String cmd=Util.null2String(request.getParameter("cmd"));

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
if(cmd.equals("getVirtualType")){
	if(CompanyVirtualComInfo.getCompanyNum()>0){
		TreeNode root = new TreeNode();
		TreeNode node = new TreeNode();
		if(CompanyComInfo.getCompanyNum()>0){
			CompanyComInfo.setTofirstRow();
			while(CompanyComInfo.next()){
				node = new TreeNode();
				String dfvirtualtypename = CompanyComInfo.getCompanyname();
				node.setId(CompanyComInfo.getCompanyid());
				node.setName(dfvirtualtypename.length()>4?dfvirtualtypename.substring(0,4):dfvirtualtypename);
				root.AddChildren(node);
			}
		}
		if(CompanyVirtualComInfo.getCompanyNum()>0){
			CompanyVirtualComInfo.setTofirstRow();
			while(CompanyVirtualComInfo.next()){
				node = new TreeNode();
				String dfvirtualtypename = CompanyVirtualComInfo.getVirtualType();
				node.setId(CompanyVirtualComInfo.getCompanyid());
				node.setName(dfvirtualtypename.length()>4?dfvirtualtypename.substring(0,4):dfvirtualtypename);
				root.AddChildren(node);
			}
		}
		jObject = JSONArray.fromObject(root.getChildren());	
		out.println(jObject.toString());
	}
}else if(cmd.equals("getNum")){
	String jsonData = "";
	String nodeids=Util.null2String(request.getParameter("nodeids"));
	jsonData = getResourceNumJson(nodeids, selectList,isNoAccount, sqlwhere);
	out.println(jsonData);
}else{
	if(id.equals("")){
		//初始化
		TreeNode root = new TreeNode();
		String companyname = CompanyComInfo.getCompanyname("1");
		root.setNodeid("com_"+1);
		root.setName(companyname);
		root.setId("0");
		root.setOpen("true");
		root.setTarget("_self"); 
	  root.setIcon("/images/treeimages/global_wev8.gif");
		root.setType("com");
		getSubCompanyTreeList(root,"0",selectList,isNoAccount, user, sqlwhere);
		jObject = JSONArray.fromObject(root);
	}else if(type.equals("subcom")){
		getSubCompanyTreeList(envelope,id,selectList,isNoAccount, user, sqlwhere);
		ArrayList<TreeNode> lsChild = envelope.getChildren();
		jObject = JSONArray.fromObject(lsChild);		
	}else if(type.equals("dept")){
		DepartmentComInfo DepartmentComInfo = new DepartmentComInfo();
		String subId = DepartmentComInfo.getSubcompanyid1(id);
		getDepartTreeList(envelope,subId,id,selectList,isNoAccount, user, sqlwhere);
		ArrayList<TreeNode> lsChild = envelope.getChildren();
		jObject = JSONArray.fromObject(lsChild);		
	}
	//System.out.println(jObject.toString());
	out.println(jObject.toString());
}
%>
