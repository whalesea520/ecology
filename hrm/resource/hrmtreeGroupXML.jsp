<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="net.sf.json.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.resource.TreeNode"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="java.util.ArrayList"%>
<%@page import="weaver.hrm.resource.MutilResourceBrowser"%>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<jsp:useBean id="MutilResourceBrowser" class="weaver.hrm.resource.MutilResourceBrowser" scope="page"/>
<%!
public String getGroupTree(User user, ArrayList selectedids, String isNoAccount, String sqlwhere)throws Exception {
	RecordSet rs = new RecordSet();
	String sql = "";
	TreeNode root = new TreeNode();
	TreeNode node = null;
	root.setId("-1");
	root.setNodeid("group_-1");
	root.setName(SystemEnv.getHtmlLabelName(17620, user.getLanguage()));
	root.setOpen("true");
	root.setType("group");
	root.setIcon("/images/treeimages/Home_wev8.gif");
	
	node = new TreeNode();
	node.setId("-2");
	node.setNodeid("group_-2");
	node.setName(SystemEnv.getHtmlLabelName(17619, user.getLanguage()));
	node.setOpen("true");
	node.setIcon("/images/treeimages/Home_wev8.gif");
	node.setType("group");
	root.AddChildren(node);

	sql = " select * from (select distinct t1.id,t1.name,t1.type,t1.sn from HrmGroup t1 , HrmGroupShare t2  where t1.id=t2.groupid and (t2.userid=" + user.getUID()+
		    " or (t2.departmentid=" + user.getUserDepartment() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
		    " or (t2.subcompanyid=" + user.getUserSubCompany1() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
		    " or (t2.foralluser=1 and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + "))" +
		    " union select distinct t1.id,t1.name,t1.type,t1.sn from  HrmGroup t1,HrmGroupShare t2 , HrmRoleMembers t3  where ("+
		    " t1.type=1 and "+
		    " t3.resourceid=" + user.getUID() + "  and t2.groupid=t1.id and t2.roleid=t3.roleid  and t2.rolelevel<=t3.rolelevel)"+
		    " union select distinct t1.id,t1.name,t1.type,t1.sn from HrmGroup t1,HrmGroupShare t2 , HrmJobTitles t3  where (t1.id = t2.groupid AND t2.jobtitleid = t3.id and t3.id='" + user.getJobtitle()+ "' " + 
		    " and (t2.jobtitlelevel=0 OR (t2.jobtitlelevel=1 AND t2.scopeid like '%,"+user.getUserDepartment()+",%') or(t2.jobtitlelevel=2 AND t2.scopeid like '%,"+user.getUserSubCompany1()+",%')))) tt "+
		    " order by tt.type,tt.sn ";
	rs.executeSql(sql);
   while (rs.next()) {
   	String id = rs.getString("id");
    TreeNode childnode = new TreeNode();
    childnode.setId(id);
    childnode.setNodeid("group_"+id);
    childnode.setType("group");
    int num = getResourceNum(id,null,user, isNoAccount, sqlwhere);
    childnode.setName(Util.toHtmlForSplitPage(rs.getString("name")));
    childnode.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
    if(num>0){
			childnode.setIsParent("true");
		}
    node.AddChildren(childnode);
   }
   
   
    //以下处理私人组
    node = new TreeNode();
  	node.setId("-3");
  	node.setNodeid("group_-3");
    node.setName(SystemEnv.getHtmlLabelName(17618, user.getLanguage()));
  	node.setOpen("true");
  	node.setType("group");
  	node.setIcon("/images/treeimages/Home_wev8.gif");
  	root.AddChildren(node);
		sql = " select id,name from HrmGroup where owner=" + user.getUID() + " and type=0 "+
    			" order by type,sn ";
    rs.executeSql(sql);
    while (rs.next()) {
    	String id = rs.getString("id");
      TreeNode	childnode = new TreeNode();
      int num = getResourceNum(id,null,user, isNoAccount, sqlwhere);
      childnode.setId(id);
      childnode.setNodeid("group_"+id);
      childnode.setType("group");
      childnode.setName(Util.toHtmlForSplitPage(rs.getString("name")));
      childnode.setIcon("/images/treeimages/subCopany_Colse_wev8.gif");
  		if(num>0){
  			childnode.setIsParent("true");
  		}
      node.AddChildren(childnode);
    }
    JSONArray jObject = JSONArray.fromObject(root);	
	return jObject.toString();
}

public JSONArray getResourceByGroupid(JSONArray jsonArr ,User user, String groupid, ArrayList selectedids, String isNoAccount, String sqlwhere, String virtualtype) throws Exception {
  ResourceComInfo ResourceComInfo = new ResourceComInfo();
  AppDetachComInfo adci = new AppDetachComInfo();
	RecordSet rs = new RecordSet();
	String sql = "";
	//包含子节点
	if(groupid.equals("-1"))
	{
		groupid = "";
		sql = " select distinct t1.id,t1.name from HrmGroup t1 , HrmGroupShare t2  where t1.id=t2.groupid and (t2.userid=" + user.getUID()+
    " or (t2.departmentid=" + user.getUserDepartment() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
    " or (t2.subcompanyid=" + user.getUserSubCompany1() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
    " or (t2.foralluser=1 and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + "))" +
    " union select distinct t1.id,t1.name from  HrmGroup t1,HrmGroupShare t2 , HrmRoleMembers t3  where ("+
    " t1.type=1 and "+
    " t3.resourceid=" + user.getUID() + " and  t2.groupid=t1.id and t2.roleid=t3.roleid  and t2.rolelevel<=t3.rolelevel)"+
    " union select distinct t1.id,t1.name from HrmGroup t1,HrmGroupShare t2 , HrmJobTitles t3  where (t1.id = t2.groupid AND t2.jobtitleid = t3.id and t3.id='" + user.getJobtitle()+ "' "+
    " and (t2.jobtitlelevel=0 OR (t2.jobtitlelevel=1 AND t2.scopeid like '%,"+user.getUserDepartment()+",%') or(t2.jobtitlelevel=2 AND t2.scopeid like '%,"+user.getUserSubCompany1()+",%'))) ";
		rs.executeSql(sql);
		while (rs.next()) {
			if(groupid.length()>0)groupid+=",";
			groupid+=rs.getString("id");
			}
		
		sql = "select id,name from HrmGroup where owner=" + user.getUID() + " and type=0 ";
		rs.executeSql(sql);
		while (rs.next()) {
			if(groupid.length()>0)groupid+=",";
			groupid+=rs.getString("id");
			}
	}else if(groupid.equals("-2")){
		sql = " select distinct t1.id,t1.name from HrmGroup t1 , HrmGroupShare t2  where t1.id=t2.groupid and (t2.userid=" + user.getUID()+
		    " or (t2.departmentid=" + user.getUserDepartment() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
		    " or (t2.subcompanyid=" + user.getUserSubCompany1() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
		    " or (t2.foralluser=1 and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + "))" +
		    " union select distinct t1.id,t1.name from  HrmGroup t1,HrmGroupShare t2 , HrmRoleMembers t3  where ("+
		    " t1.type=1 and "+
		    " t3.resourceid=" + user.getUID() + " and  t2.groupid=t1.id and t2.roleid=t3.roleid  and t2.rolelevel<=t3.rolelevel)"+
		    " union select distinct t1.id,t1.name from HrmGroup t1,HrmGroupShare t2 , HrmJobTitles t3  where (t1.id = t2.groupid AND t2.jobtitleid = t3.id and t3.id='" + user.getJobtitle()+ "' "+
		    " and (t2.jobtitlelevel=0 OR (t2.jobtitlelevel=1 AND t2.scopeid like '%,"+user.getUserDepartment()+",%') or(t2.jobtitlelevel=2 AND t2.scopeid like '%,"+user.getUserSubCompany1()+",%'))) ";
		rs.executeSql(sql);
		while (rs.next()) {
			if(groupid.length()>0)groupid+=",";
			groupid+=rs.getString("id");
			}
	}else if(groupid.equals("-3")){
		sql = "select id,name from HrmGroup where owner=" + user.getUID() + " and type=0 ";
		rs.executeSql(sql);
		while (rs.next()) {
			if(groupid.length()>0)groupid+=",";
			groupid+=rs.getString("id");
			}
	}
	
	String fromSql = "hrmresource";
	if(Util.getIntValue(virtualtype)<-1)fromSql = "HrmResourcevirtualview";
	sql = "select hr.id, lastname, hr.pinyinlastname, hr.subcompanyid1, hr.jobtitle " 
		  + " from "+fromSql+" hr, HrmGroupMembers t2 " 
		  + " where hr.id= userid and groupid in (" + groupid +")";
	if(Util.getIntValue(virtualtype)<-1)sql+=" and hr.virtualtype="+virtualtype;
	String ids = "";
	for(int i=0;selectedids!=null&&i<selectedids.size();i++){
		if(ids.length()>0)ids+=",";
		ids+=selectedids.get(i);
	}
	if(ids.length()>0)sql +=" and userid not in ("+ids+")";
	if(sqlwhere.length()>0)sqlwhere=" and " +sqlwhere;
	sqlwhere += " and status in(0,1,2,3) " ;
	if(adci.isUseAppDetach()){
		String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"",true,"resource_hr");
		String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
		sqlwhere+=tempstr;
	}
	if(sqlwhere.length()>0)sql+=sqlwhere;
	
	String noAccountSql="";
 	if(!isNoAccount.equals("1")){
		noAccountSql=" and loginid is not null "+(rs.getDBType().equals("oracle")?"":" and loginid<>'' ");
 	}
 	sql += noAccountSql;
 	
 	sql += " order by t2.dsporder";
 	//System.out.println(sql);
	rs.executeSql(sql);
	while (rs.next()) {
		String id = rs.getString("id");
		if(ids.length()>0)ids+=",";
		ids+=id;
		String lastname = rs.getString("lastname");
		String pinyinlastname = rs.getString("pinyinlastname");
		String jobtitle = rs.getString("jobtitle");
		jobtitle = MutilResourceBrowser.getJobTitlesname(id);
		lastname="<span id='pinyinlastname' style='display:none'>"+pinyinlastname+"</span><span id='lastname'>"+lastname+"</span><span id='jobtitlename' style='color:#929390;margin-left:15px;margin-right:2px;'>"+jobtitle+"</span>";
		
		JSONObject tmp = new JSONObject();
		tmp.put("messagerurl",ResourceComInfo.getMessagerUrls(id));
		tmp.put("id",id);
		tmp.put("nodeid","resource_"+id);
		tmp.put("type","resource");
		tmp.put("lastname",rs.getString("lastname"));
		tmp.put("pinyinlastname",rs.getString("pinyinlastname"));
		tmp.put("jobtitlename",MutilResourceBrowser.getJobTitlesname(id));
		jsonArr.add(tmp);
	}
	return jsonArr;
}

public String getResourceTree(String groupid, ArrayList selectedids, String isNoAccount, User user, String sqlwhere, String virtualtype) throws Exception {
  ResourceComInfo ResourceComInfo = new ResourceComInfo();
	TreeNode root = new TreeNode();
	RecordSet rs = new RecordSet();
  
  String fromSql = "hrmresource";
  if(Util.getIntValue(virtualtype)<-1)fromSql = "HrmResourcevirtualview";
	String sql = "select hr.id, lastname, hr.pinyinlastname, hr.subcompanyid1, hr.jobtitle, hr.loginid, hr.account " 
		  + " from "+fromSql+" hr, HrmGroupMembers t2 " 
		  + " where hr.id= userid and groupid in (" + groupid +")";
	if(Util.getIntValue(virtualtype)<-1)sql+=" and hr.virtualtype="+virtualtype;
	
  AppDetachComInfo adci = new AppDetachComInfo();
	if(sqlwhere.length()>0)sqlwhere=" and "+sqlwhere;
	sqlwhere += " and status in(0,1,2,3) " ;
	if(adci.isUseAppDetach()){
		String appdetawhere = adci.getScopeSqlByHrmResourceSearch(user.getUID()+"",true,"resource_hr");
		String tempstr= (appdetawhere!=null&&!"".equals(appdetawhere)?(" and " + appdetawhere):"");
		sqlwhere+=tempstr;
	}
	if(sqlwhere.length()>0)sql+=sqlwhere;
	String noAccountSql="";
 	if(!isNoAccount.equals("1")){
			noAccountSql=" and loginid is not null "+(rs.getDBType().equals("oracle")?"":" and loginid<>'' ");
 	}
 	sql += noAccountSql;
 	
  sql += " order by t2.dsporder";
	//System.out.println(sql);
	rs.executeSql(sql);
	while (rs.next()) {
		String id = rs.getString("id");
		String loginid = rs.getString("loginid");
		String lastname = rs.getString("lastname");
		String pinyinlastname = rs.getString("pinyinlastname");
		String jobtitle = rs.getString("jobtitle");
		jobtitle = MutilResourceBrowser.getJobTitlesname(id);
		lastname="<span id='pinyinlastname' style='display:none'>"+pinyinlastname+"</span><span id='lastname'>"+lastname+"</span><span id='jobtitlename' style='color:#929390;margin-left:15px;margin-right:2px;'>"+jobtitle+"</span>";
		
		TreeNode resourceNode = new TreeNode();
		resourceNode.setName(lastname);
		resourceNode.setId(id);
		resourceNode.setNodeid("resource_"+id);
		resourceNode.setIcon(ResourceComInfo.getMessagerUrls(id));
		resourceNode.setNocheck("N");
		//if(selectedids.contains(id)||adci.checkUserAppDetach(id,"1",user)==0){
		if(selectedids.contains(id)){
			resourceNode.setIsHidden("true");
		}
		if(!isNoAccount.equals("1")){
			if(loginid.length()==0)resourceNode.setIsHidden("true");
		}
		resourceNode.setType("resource");
		root.AddChildren(resourceNode);
	}
  JSONArray jObject = JSONArray.fromObject(root.getChildren());	
	return jObject.toString();
}

private int getResourceNum(String groupid, ArrayList selectedids, User user, String isNoAccount, String sqlwhere)throws Exception{
	int num = 0;
	if(groupid.equals("-1")||groupid.equals("-2")||groupid.equals("-3")){
		RecordSet rs = new RecordSet();
		String sql = "";
		//包含子节点
		if(groupid.equals("-1"))
		{
			groupid = "";
			sql = " select distinct t1.id,t1.name from HrmGroup t1 , HrmGroupShare t2  where t1.id=t2.groupid and (t2.userid=" + user.getUID()+
	    " or (t2.departmentid=" + user.getUserDepartment() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
	    " or (t2.subcompanyid=" + user.getUserSubCompany1() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
	    " or (t2.foralluser=1 and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + "))" +
	    " union select distinct t1.id,t1.name from  HrmGroup t1,HrmGroupShare t2 , HrmRoleMembers t3  where ("+
	    " t1.type=1 and "+
	    " t3.resourceid=" + user.getUID() + " and  t2.groupid=t1.id and t2.roleid=t3.roleid  and t2.rolelevel<=t3.rolelevel)"+
	    " union select distinct t1.id,t1.name from HrmGroup t1,HrmGroupShare t2 , HrmJobTitles t3  where (t1.id = t2.groupid AND t2.jobtitleid = t3.id and t3.id='" + user.getJobtitle()+ "' "+
	    " and (t2.jobtitlelevel=0 OR (t2.jobtitlelevel=1 AND t2.scopeid like '%,"+user.getUserDepartment()+",%') or(t2.jobtitlelevel=2 AND t2.scopeid like '%,"+user.getUserSubCompany1()+",%'))) ";
			rs.executeSql(sql);
			while (rs.next()) {
				if(groupid.length()>0)groupid+=",";
				groupid+=rs.getString("id");
 			}
			
			sql = "select id,name from HrmGroup where owner=" + user.getUID() + " and type=0 ";
			rs.executeSql(sql);
			while (rs.next()) {
				if(groupid.length()>0)groupid+=",";
				groupid+=rs.getString("id");
 			}
		}else if(groupid.equals("-2")){
			sql = " select distinct t1.id,t1.name from HrmGroup t1 , HrmGroupShare t2  where t1.id=t2.groupid and (t2.userid=" + user.getUID()+
			    " or (t2.departmentid=" + user.getUserDepartment() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
			    " or (t2.subcompanyid=" + user.getUserSubCompany1() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
			    " or (t2.foralluser=1 and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + "))" +
			    " union select distinct t1.id,t1.name from  HrmGroup t1,HrmGroupShare t2 , HrmRoleMembers t3  where ("+
			    " t1.type=1 and "+
			    " t3.resourceid=" + user.getUID() + " and  t2.groupid=t1.id and t2.roleid=t3.roleid  and t2.rolelevel<=t3.rolelevel)"+
			    " union select distinct t1.id,t1.name from HrmGroup t1,HrmGroupShare t2 , HrmJobTitles t3  where (t1.id = t2.groupid AND t2.jobtitleid = t3.id and t3.id='" + user.getJobtitle()+ "' "+
			    " and (t2.jobtitlelevel=0 OR (t2.jobtitlelevel=1 AND t2.scopeid like '%,"+user.getUserDepartment()+",%') or(t2.jobtitlelevel=2 AND t2.scopeid like '%,"+user.getUserSubCompany1()+",%'))) ";
			rs.executeSql(sql);
			while (rs.next()) {
				if(groupid.length()>0)groupid+=",";
				groupid+=rs.getString("id");
 			}
		}else if(groupid.equals("-3")){
			sql = "select id,name from HrmGroup where owner=" + user.getUID() + " and type=0 ";
			rs.executeSql(sql);
			while (rs.next()) {
				if(groupid.length()>0)groupid+=",";
				groupid+=rs.getString("id");
 			}
		}
	}
	
	RecordSet rs = new RecordSet();
	String sql = "select count(*) from hrmgroupmembers, hrmresource hr where userid=hr.id ";
	if(sqlwhere.length()>0)sqlwhere+=" and "+sqlwhere;
	sqlwhere += " and status in(0,1,2,3) " ;
	
	if(Util.null2String(groupid).length()>0){
		sql += " and groupid in("+groupid+")";
	}
 	
	String ids = "";
	for(int i=0;selectedids!=null&&i<selectedids.size();i++){
		if(ids.length()>0)ids+=",";
		ids+=selectedids.get(i);
	}
	if(ids.length()>0)sql +=" and userid not in ("+ids+")";
	String noAccountSql="";
 	if(!isNoAccount.equals("1")){
			noAccountSql=" and loginid is not null "+(rs.getDBType().equals("oracle")?"":" and loginid<>'' ");
 	}
 	sql += noAccountSql;
 	
	rs.executeSql(sql);
	if(rs.next()){
		num = rs.getInt(1);
	}
	return num;
}


private String getResourceJson(String groupids, ArrayList selectedids, User user, String isNoAccount, String sqlwhere)throws Exception{
	String[] arr_groupid =Util.TokenizerString2(groupids,",");
	JSONArray jsonArr = new JSONArray();
	for(String groupid:arr_groupid){
		String nodeid = groupid;
		if(groupid.equals("-1")||groupid.equals("-2")||groupid.equals("-3")){
			RecordSet rs = new RecordSet();
			String sql = "";
			//包含子节点
			if(groupid.equals("-1"))
			{
				groupid = "";
				sql = " select distinct t1.id,t1.name from HrmGroup t1 , HrmGroupShare t2  where t1.id=t2.groupid and (t2.userid=" + user.getUID()+
		    " or (t2.departmentid=" + user.getUserDepartment() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
		    " or (t2.subcompanyid=" + user.getUserSubCompany1() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
		    " or (t2.foralluser=1 and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + "))" +
		    " union select distinct t1.id,t1.name from  HrmGroup t1,HrmGroupShare t2 , HrmRoleMembers t3  where ("+
		    " t1.type=1 and "+
		    " t3.resourceid=" + user.getUID() + " and  t2.groupid=t1.id and t2.roleid=t3.roleid  and t2.rolelevel<=t3.rolelevel)"+
		    " union select distinct t1.id,t1.name from HrmGroup t1,HrmGroupShare t2 , HrmJobTitles t3  where (t1.id = t2.groupid AND t2.jobtitleid = t3.id and t3.id='" + user.getJobtitle()+ "' "+
		    " and (t2.jobtitlelevel=0 OR (t2.jobtitlelevel=1 AND t2.scopeid like '%,"+user.getUserDepartment()+",%') or(t2.jobtitlelevel=2 AND t2.scopeid like '%,"+user.getUserSubCompany1()+",%'))) ";
				rs.executeSql(sql);
				while (rs.next()) {
					if(groupid.length()>0)groupid+=",";
					groupid+=rs.getString("id");
	 			}
				
				sql = "select id,name from HrmGroup where owner=" + user.getUID() + " and type=0 ";
				rs.executeSql(sql);
				while (rs.next()) {
					if(groupid.length()>0)groupid+=",";
					groupid+=rs.getString("id");
	 			}
			}else if(groupid.equals("-2")){
				sql = " select distinct t1.id,t1.name from HrmGroup t1 , HrmGroupShare t2  where t1.id=t2.groupid and (t2.userid=" + user.getUID()+
				    " or (t2.departmentid=" + user.getUserDepartment() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
				    " or (t2.subcompanyid=" + user.getUserSubCompany1() + " and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + ") " +
				    " or (t2.foralluser=1 and t2.seclevel<=" + Util.getIntValue(user.getSeclevel()) + " and t2.seclevelto>=" + Util.getIntValue(user.getSeclevel()) + "))" +
				    " union select distinct t1.id,t1.name from  HrmGroup t1,HrmGroupShare t2 , HrmRoleMembers t3  where ("+
				    " t1.type=1 and "+
				    " t3.resourceid=" + user.getUID() + " and  t2.groupid=t1.id and t2.roleid=t3.roleid  and t2.rolelevel<=t3.rolelevel)"+
				    " union select distinct t1.id,t1.name from HrmGroup t1,HrmGroupShare t2 , HrmJobTitles t3  where (t1.id = t2.groupid AND t2.jobtitleid = t3.id and t3.id='" + user.getJobtitle()+ "' "+
				    " and (t2.jobtitlelevel=0 OR (t2.jobtitlelevel=1 AND t2.scopeid like '%,"+user.getUserDepartment()+",%') or(t2.jobtitlelevel=2 AND t2.scopeid like '%,"+user.getUserSubCompany1()+",%'))) ";
				rs.executeSql(sql);
				while (rs.next()) {
					if(groupid.length()>0)groupid+=",";
					groupid+=rs.getString("id");
	 			}
			}else if(groupid.equals("-3")){
				sql = "select id,name from HrmGroup where owner=" + user.getUID() + " and type=0 ";
				rs.executeSql(sql);
				while (rs.next()) {
					if(groupid.length()>0)groupid+=",";
					groupid+=rs.getString("id");
	 			}
			}
		}
		
		String sql = "select count(*) from hrmgroupmembers, hrmresource hr where userid=hr.id ";
		if(sqlwhere.length()>0)sqlwhere+=" and "+sqlwhere;
		
		if(Util.null2String(groupid).length()>0){
			sql += " and groupid in("+groupid+")";
		}else{
			
		}
		
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
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String alllevel=Util.null2String(request.getParameter("alllevel"));
String selectedids=Util.null2String(request.getParameter("selectedids"));
String isNoAccount=Util.null2String(request.getParameter("isNoAccount"));
String virtualtype=Util.null2String(request.getParameter("virtualtype"));
String cmd=Util.null2String(request.getParameter("cmd"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
selectedids = MutilResourceBrowser.getExcludeSqlWhere(selectedids,alllevel,isNoAccount,user, sqlwhere);
String jsonData = null;
JSONArray jsonArr = new JSONArray();
ArrayList selectList = new ArrayList();
if(selectedids.length()>0){
	String[] tmp_selectedids = selectedids.split(",");
	for(String selectedid:tmp_selectedids){
		selectList.add(selectedid);
	}
}
if(cmd.equals("getComDeptResource")){
	String comdeptnodeids = Util.null2String(request.getParameter("comdeptnodeids"));
	String[] groupids = Util.TokenizerString2(comdeptnodeids,",");
	for(String groupid :groupids){
		getResourceByGroupid(jsonArr,user,groupid, selectList, isNoAccount, sqlwhere, virtualtype);
	}
	jsonData = jsonArr.toString();
}
else if(cmd.equals("getAll")){
	jsonArr = getResourceByGroupid(jsonArr,user,"-1", selectList, isNoAccount, sqlwhere, virtualtype);
	jsonData = jsonArr.toString();
}else if(cmd.equals("getNum")){
	String nodeids=Util.null2String(request.getParameter("nodeids"));
	jsonData = getResourceJson(nodeids, selectList,user, isNoAccount, sqlwhere);
}else{
	if(id.length()==0){
		//init
		jsonData = getGroupTree(user,selectList, isNoAccount, sqlwhere);
	}else{
		jsonData = getResourceTree(id,selectList,isNoAccount, user, sqlwhere, virtualtype);
	}
}
out.println(jsonData);
%>
