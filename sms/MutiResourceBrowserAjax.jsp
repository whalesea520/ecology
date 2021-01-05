
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String systemIds = Util.null2String(request.getParameter("systemIds"));
if(systemIds.trim().startsWith(",")){
	systemIds = systemIds.substring(1);
}
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
String sqlWhere = " where 1=1 ";
JSONObject json = new JSONObject();
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
	if (!systemIds.equals("")) {
		sqlWhere += " and id in ("+systemIds+")";
		
		SplitPageParaBean spp = new SplitPageParaBean();
	
		spp.setBackFields(" HrmResource.id, lastname, departmentid, subcompanyid1, jobtitle, dsporder,mobile ");
		spp.setSqlFrom(" HrmResource ");
		spp.setSqlWhere(sqlWhere);
		spp.setSqlOrderBy("dsporder,lastname");
		spp.setPrimaryKey("id");
		spp.setDistinct(true);
		spp.setSortWay(spp.ASC);
		SplitPageUtil spu = new SplitPageUtil();
		spu.setSpp(spp);
	
		String id=null;
		String mobile=null;
		String departmentname=null;
		String subcompanyname=null;
		
		rs = spu.getAllRs();
	
		JSONArray jsonArr = new JSONArray();
		while(rs.next()) {
			id = rs.getString("id");
			mobile=rs.getString("mobile");
			departmentname = DepartmentComInfo.getDepartmentName(rs.getString("departmentid"));
			subcompanyname = SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid1"));
	
			JSONObject tmp = new JSONObject();
			tmp.put("id",id);
			tmp.put("lastname",rs.getString("lastname"));
			tmp.put("mobile",mobile);
			tmp.put("departmentname",departmentname);
			//tmp.put("subcompanyname",subcompanyname);
			jsonArr.add(tmp);
		}
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
		return;
		
	} else {
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList","");
		out.println(json.toString());
		return;
	}
}else{//左侧待选择列表的sql条件
		Calendar today = Calendar.getInstance();
		String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
						 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
						 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
						 
		String tabId=Util.null2String(request.getParameter("tabId"));
		
		String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
		String departmentid = Util.null2String(request.getParameter("departmentid"));
		String lastname = Util.null2String(request.getParameter("lastname"));
		String jobtitle = Util.null2String(request.getParameter("jobtitle"));
		String status = Util.null2String(request.getParameter("status"));
		String roleid = Util.null2String(request.getParameter("roleid"));
		String groupid = Util.null2String(request.getParameter("groupid"));
		
		String resourcetype = Util.null2String(request.getParameter("resourcetype"));
		String resourcestatus = Util.null2String(request.getParameter("resourcestatus"));
		String firstname = Util.null2String(request.getParameter("firstname"));
		String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());    
		
		sqlWhere =" where 1=1 ";
		
		if(departmentid.equals("0"))    departmentid="";
		if(subcompanyid.equals("0"))    subcompanyid="";
		if(status.equals("-1")) status = "";
		
		if("".equals(tabId)||"1".equals(tabId)||"2".equals(tabId)||"3".equals(tabId)){//有效tab页签
			if(!lastname.equals("")){
			sqlWhere += " and( lastname like '%" + Util.fromScreen2(lastname,user.getLanguage()) +"%' or pinyinlastname like '%"+Util.fromScreen2(lastname,user.getLanguage()).toLowerCase()+"%')";
			}
			if(!firstname.equals("")){
				sqlWhere += " and firstname like '%" + Util.fromScreen2(firstname,user.getLanguage()) +"%' ";
			}
			if(!seclevelto.equals("")){
				sqlWhere += " and HrmResource.seclevel <= '"+ seclevelto + "' ";
			}
			if(!resourcetype.equals("")){
				sqlWhere += " and resourcetype = '"+ resourcetype + "' ";
			}
	
			if(!jobtitle.equals("")){
				sqlWhere += " and jobtitle in(select id from HrmJobTitles where jobtitlename like '%" + Util.fromScreen2(jobtitle,user.getLanguage()) +"%') ";
			}
			if(!departmentid.equals("")){
				sqlWhere += " and departmentid =" + departmentid +" " ;
			}
			if(departmentid.equals("")&&!subcompanyid.equals("")){
				sqlWhere += " and subcompanyid1 =" + subcompanyid +" " ;
			}
			if(!status.equals("")&&!status.equals("9")){
				sqlWhere += " and status =" + status +" " ;
			}
			if(status.equals("")){
				sqlWhere += " and (status =0 or status = 1 or status = 2 or status = 3) ";
			}
			if(!roleid.equals("")){
				sqlWhere += " and    HrmResource.ID in (select t1.ResourceID from hrmrolemembers t1,hrmroles t2 where t1.roleid = t2.ID and t2.ID="+roleid+" ) " ;
			}
			if(!groupid.equals("")){
				sqlWhere += " and    HrmResource.ID in (select h2.id from hrmgroupmembers h1,HrmResource h2 where h1.userid=h2.id and groupid="+groupid+" ) " ;
			}
		}else{
			sqlWhere+=" and 1=2 ";
		}
		
		if(!systemIds.equals("")){
			sqlWhere += " and  HrmResource.ID not in ("+systemIds+") " ;
		}

		String moduleManageDetach= Util.null2String(request.getParameter("moduleManageDetach"));//(模块管理分权-分权管理员专用)
		
		String moduleManageDetachSQL="";
		if(moduleManageDetach!=null && "1".equals(moduleManageDetach)){

		//根据分权管理员id查询其所管辖的分部（分权管理员设置页面有设置其分权管理员管理的分部）
		String subcompanyidsStr=""; 
		List subcompanyidsList = new ArrayList();
		String sql1 = "select * from HrmResourceManager where  id='"+user.getUID()+"'  ";
			
		rs.executeSql(sql1);
		if(rs.next()){
			subcompanyidsStr=rs.getString("subcompanyids");
		}
		if(subcompanyidsStr!=null&&!"".equals(subcompanyidsStr)){
			moduleManageDetachSQL= " and subcompanyid1 in(" + subcompanyidsStr +") " ;
		}
	}
	sqlWhere=sqlWhere+("1".equals(moduleManageDetach)?moduleManageDetachSQL:"");
	
	SplitPageParaBean spp = new SplitPageParaBean();
	
	spp.setBackFields(" HrmResource.id, lastname, departmentid, subcompanyid1, jobtitle, dsporder,mobile ");
	spp.setSqlFrom(" HrmResource ");
	spp.setSqlWhere(sqlWhere);
	spp.setSqlOrderBy("dsporder,lastname");
	spp.setPrimaryKey("id");
	spp.setDistinct(true);
	spp.setSortWay(spp.ASC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);

	int RecordSetCounts = spu.getRecordCount();
	int totalPage = RecordSetCounts/perpage;
	if(totalPage%perpage>0||totalPage==0){
		totalPage++;
	}

	String id=null;
	String mobile=null;
	String departmentname=null;
	String subcompanyname=null;
	
	rs = spu.getCurrentPageRs(pagenum, perpage);

	JSONArray jsonArr = new JSONArray();
	while(rs.next()) {
		id = rs.getString("id");
		mobile=rs.getString("mobile");
		departmentname = DepartmentComInfo.getDepartmentName(rs.getString("departmentid"));
		subcompanyname = SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid1"));

		JSONObject tmp = new JSONObject();
		tmp.put("id",id);
		tmp.put("lastname",rs.getString("lastname"));
		tmp.put("mobile",mobile);
		tmp.put("departmentname",departmentname);
		//tmp.put("subcompanyname",subcompanyname);
		jsonArr.add(tmp);
	}
	json.put("currentPage", pagenum);
	json.put("totalPage", totalPage);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
	//System.out.println(json.toString());
	}
%>
				