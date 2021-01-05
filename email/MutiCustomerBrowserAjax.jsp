
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
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
String check_per = Util.null2String(request.getParameter("systemIds"));

int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
JSONObject json = new JSONObject();
if("src".equals(src)){
	
	String name = Util.null2String(request.getParameter("name"));
	String engname = Util.null2String(request.getParameter("engname"));
	String type = Util.null2String(request.getParameter("type"));
	String city = Util.null2String(request.getParameter("City"));
	String customerSector = Util.null2String(request.getParameter("CustomerSector"));
	String country1 = Util.null2String(request.getParameter("country1"));
	String departmentid = Util.null2String(request.getParameter("departmentid"));

	String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
 	String sqlwhere=" where 1=1 and t1.id != 0";
	if(!"".equals(check_per)){
		sqlwhere+=" and t3.id not in("+check_per+")";
	}
	String table="";
	if(user.getLogintype().equals("1")){
		table="CRM_CustomerInfo  t1, "+leftjointable+" t2, CRM_CustomerContacter t3";
		sqlwhere+=" and t1.id = t2.relateditemid and t3.customerid=t1.id and t1.deleted <>1 ";
	}else{
		table="CRM_CustomerInfo  t1, CRM_CustomerContacter t3";
		sqlwhere+=" and t1.deleted <>1 and t3.customerid=t1.id  and t1.agent="+user.getUID() + " ";
	}
	//查询条件
	if(!name.equals("")){
		sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	if(!engname.equals("")){
			sqlwhere += " and t1.engname like '%" + Util.fromScreen2(engname,user.getLanguage()) +"%' ";
	}
	if(!type.equals("")){
			sqlwhere += " and t1.type = "+ type;
	}
	if(!city.equals("")){
			sqlwhere += " and t1.city = " + city ;
	}
	if(!customerSector.equals("")){
			sqlwhere += " and t1.Sector = " + customerSector ;
	}
	if(!country1.equals("")){
			sqlwhere += " and t1.country = "+ country1;
	}
	if(!departmentid.equals("")){
			sqlwhere += " and t1.department =" + departmentid +" " ;
	}
	
	SplitPageParaBean spp = new SplitPageParaBean();
	spp.setBackFields(" t3.id,t1.name,t3.jobtitle,t3.fullname,t3.email ");
	spp.setSqlFrom(table);
	spp.setSqlWhere(sqlwhere);
	spp.setSqlOrderBy("t3.id");
	spp.setPrimaryKey("t3.id");
	spp.setDistinct(true);
	spp.setSortWay(spp.ASC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);
 
 
	int RecordSetCounts = spu.getRecordCount();
	int totalPage = RecordSetCounts/perpage;
	if(totalPage%perpage>0||totalPage==0){
		totalPage++;
	}

	rs = spu.getCurrentPageRs(pagenum, perpage);
	JSONArray jsonArr = new JSONArray();
	while(rs.next()) {
		JSONObject tmp = new JSONObject();
		tmp.put("id",rs.getString("id"));
		tmp.put("fullname",rs.getString("fullname"));
		tmp.put("email",rs.getString("email"));
		jsonArr.add(tmp);
	}
	json.put("currentPage", pagenum);
	json.put("totalPage", totalPage);
	json.put("mapList",jsonArr.toString());
	out.println(json.toString());
	return;
}else if("dest".equals(src)){
	if(!"".equals(check_per)){
		String sqlWhere="where t3.customerid=t1.id and t3.id in ("+check_per+")";
		SplitPageParaBean spp = new SplitPageParaBean();
		spp.setBackFields(" t3.id,t1.name,t3.jobtitle,t3.fullname,t3.email ");
		spp.setSqlFrom(" CRM_CustomerInfo  t1,CRM_CustomerContacter t3 ");
		spp.setSqlWhere(sqlWhere);
		spp.setSqlOrderBy("t3.id");
		spp.setPrimaryKey("t3.id");
		spp.setDistinct(true);
		spp.setSortWay(spp.ASC);
		SplitPageUtil spu = new SplitPageUtil();
		spu.setSpp(spp);
	
		rs = spu.getAllRs();
	
		JSONArray jsonArr = new JSONArray();
		while(rs.next()) {
			JSONObject tmp = new JSONObject();
			tmp.put("id",rs.getString("id"));
			tmp.put("fullname",rs.getString("fullname"));
			tmp.put("email",rs.getString("email"));
			jsonArr.add(tmp);
		}
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
		return;		
	}else{
		json.put("currentPage", 1);
		json.put("totalPage", 0);
		json.put("mapList","");
		out.println(json.toString());
		return;
	}
}

%>