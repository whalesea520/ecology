
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.file.Prop" %>
<%@ page import="weaver.hrm.*,weaver.hrm.common.*" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
	String src = Util.null2String(request.getParameter("src"));
	String type = Util.null2String(request.getParameter("type"),"query");
	String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));
	String check_per = Util.null2String(request.getParameter("systemIds"));
	if(check_per.trim().startsWith(",")){
		check_per = check_per.substring(1);
	}
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;

	String sqlWhere = " where 1=1 ";
	JSONObject json = new JSONObject();
	if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
		if (!check_per.equals("")) {
			if(check_per.indexOf(",")==0){
				check_per=check_per.substring(1);
			}
			sqlWhere += " and a.id in ("+check_per+")";
		} else {
			json.put("currentPage", 1);
			json.put("totalPage", 1);
			json.put("mapList","");
			out.println(json.toString());
			return;
		}
	}else{//左侧待选择列表的sql条件
		String name = Tools.getURLDecode(request.getParameter("name"));
		sqlWhere = Util.null2String(request.getParameter("sqlWhere"));
		if(sqlWhere.length()==0)
			sqlWhere =" where 1=1 ";
		//sqlWhere += " and a.careerplanid = 0";
		if(name.length() > 0){
			sqlWhere += " and b.jobtitlename like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
		}
		if( Util.null2String(check_per).length()>0 )sqlWhere += " and a.id not in( "+check_per+" ) ";
		SplitPageParaBean spp = new SplitPageParaBean();
		spp.setBackFields(" a.id,a.careername,b.jobtitlename,a.createdate ");
		spp.setSqlFrom(" from HrmCareerInvite a left join HrmJobTitles b on a.careername = b.id ");
		spp.setSqlWhere(sqlWhere);
		spp.setSqlOrderBy("a.createdate");
		spp.setPrimaryKey("a.id");
		spp.setDistinct(true);
		spp.setSortWay(spp.DESC);
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
			tmp.put("jobtitlename",rs.getString("jobtitlename"));
			tmp.put("code",weaver.hrm.HrmTransMethod.getCode(rs.getString("id"),"12"));
			jsonArr.add(tmp);
		}
		json.put("currentPage", pagenum);
		json.put("totalPage", totalPage);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
	}
%>