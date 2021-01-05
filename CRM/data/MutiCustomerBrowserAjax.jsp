
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String check_per = Util.null2String(request.getParameter("resourceids"));
if(check_per.equals("")){
	check_per = Util.null2String(request.getParameter("systemIds"));
	if(check_per.equals(""))
		check_per="''";
}

if("dest".equals(src)){
	
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	if(!"".equals(check_per)){
		JSONArray array = new JSONArray();
		JSONObject json = new JSONObject();
		rs.execute("select * from CRM_CustomerInfo where id in ("+check_per+")");
		while(rs.next()){
			JSONObject child = new JSONObject();
			child.put("id", rs.getString("id"));
			child.put("name", rs.getString("name"));
			child.put("type", CustomerTypeComInfo.getCustomerTypename(rs.getString("type")));
			child.put("city", CityComInfo.getCityname(rs.getString("city")));
			array.add(child);
		}
		/*
		int RecordSetCounts = rs.getCounts();
		int totalPage = RecordSetCounts/perpage;
		if(totalPage%perpage>0||totalPage==0){
			totalPage++;
		}
		*/
		json.put("currentPage", 1);
		//json.put("totalPage", totalPage);
		json.put("mapList",array.toString());
		out.println(json.toString());
		
	}else{
		JSONObject json = new JSONObject();
		json.put("currentPage", 1);
		json.put("totalPage", 0);
		json.put("mapList",null);
		out.println(json.toString());
		
	}
}else{
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	
	String name = Util.null2String(request.getParameter("name"));
	String crmcode = Util.null2String(request.getParameter("crmcode"));
	String type = Util.null2String(request.getParameter("type"));
	String city = Util.null2String(request.getParameter("City"));
	String country1 = Util.null2String(request.getParameter("country1"));
	String departmentid = Util.null2String(request.getParameter("departmentid"));
	String crmManager = Util.null2String(request.getParameter("crmManager"));
	String sectorInfo = Util.null2String(request.getParameter("sectorInfo"));
	String customerStatus = Util.null2String(request.getParameter("customerStatus"));
	String customerDesc = Util.null2String(request.getParameter("customerDesc"));
	String customerSize = Util.null2String(request.getParameter("customerSize"));
	
	if(sqlwhere.equals("")){
		sqlwhere = " where t1.deleted<>1";
	}else{
		sqlwhere += " and t1.deleted<>1 " ;
	}
	
	if(user.getLogintype().equals("1")){
		sqlwhere +=" and t1.id = t2.relateditemid";
	}else{
		sqlwhere +=" and t1.deleted<>1 and t1.agent="+user.getUID();
	}
	
	if(!name.equals("")){
			sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	if(!crmcode.equals("")){
			sqlwhere += " and t1.crmcode like '%" + Util.fromScreen2(crmcode,user.getLanguage()) +"%' ";
	}
	if(!type.equals("")){
			sqlwhere += " and t1.type = "+ type;
	}
	if(!city.equals("")){
			sqlwhere += " and t1.city = " + city ;
	}
	if(!country1.equals("")){
			sqlwhere += " and t1.country = "+ country1;
	}
	if(!departmentid.equals("")){
			sqlwhere += " and t1.department =" + departmentid +" " ;
	}
	if(!crmManager.equals("")){
			sqlwhere += " and t1.manager =" + crmManager +" " ;
	}
	if(!sectorInfo.equals("")){
			sqlwhere += " and t1.sector = "+ sectorInfo;
	}
	if(!customerStatus.equals("")){
			sqlwhere += " and t1.status = "+ customerStatus;
	}else{
			//sqlwhere += " and t1.status <> 1 ";   
	}
	if(!customerDesc.equals("")){
			sqlwhere += " and t1.description = "+ customerDesc;
	}
	if(!customerSize.equals("")){
			sqlwhere += " and t1.size_n = "+ customerSize;
	}

	String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

	//添加判断权限的内容--new*/
	String sqlfrom = "";
	if(user.getLogintype().equals("1")){
		sqlfrom = "CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid";
	}else{
		sqlfrom = "CRM_CustomerInfo t1";
	}
	
	if (check_per.equals("")) {
		check_per = Util.null2String(request.getParameter("excludeId"));
	}
	if (!check_per.equals("")) {
		/*
		if(check_per.indexOf(',')==0){
			check_per=check_per.substring(1);
		}
		if(!check_per.equals(""))
			sqlwhere += " and t1.id not in ("+check_per+")";
		*/
	}
	
	SplitPageParaBean spp = new SplitPageParaBean();
	spp.setBackFields(" t1.id,t1.name,t1.crmcode,t1.type,t1.city,t1.country,t1.department ");
	spp.setSqlFrom(sqlfrom);
	spp.setSqlWhere(sqlwhere);
	spp.setPrimaryKey("t1.id");
	spp.setDistinct(true);
	spp.setSortWay(spp.DESC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);
	spu.setRecordCount(perpage);

	rs = spu.getCurrentPageRs(pagenum, perpage);
	
	JSONArray array = new JSONArray();
	JSONObject json = new JSONObject();
	while(rs.next()){
		JSONObject child = new JSONObject();
		child.put("id", rs.getString("id"));
		child.put("name", rs.getString("name"));
		child.put("type", CustomerTypeComInfo.getCustomerTypename(rs.getString("type")));
		child.put("city", CityComInfo.getCityname(rs.getString("city")));
		array.add(child);
	}
	json.put("currentPage", pagenum);
	json.put("mapList",array.toString());
	out.println(json.toString());
}



%>