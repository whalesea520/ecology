
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*,weaver.file.Prop,weaver.hrm.*,weaver.hrm.common.*" %>
<%@ page import="java.util.*,net.sf.json.JSONArray,net.sf.json.JSONObject" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String mode=Prop.getPropValue(GCONST.getConfigFile() , "authentic");
	String src = Util.null2String(request.getParameter("src"));
	String type = Util.null2String(request.getParameter("type"),"query");
	String isNoAccount = Util.null2String(request.getParameter("isNoAccount"));
	String check_per = Util.null2String(request.getParameter("selectids"));
	if(check_per.equals(""))check_per = Util.null2String(request.getParameter("systemIds"));
	if(check_per.trim().startsWith(","))check_per = check_per.substring(1);
	Map nameMap = new HashMap();
	Map markMap = new HashMap();
	if(!check_per.equals("")){
		try{
			rs.executeSql("select id,orgGroupName,orgGroupDesc from HrmOrgGroup where id in ("+check_per+")");
			while(rs.next()){
				nameMap.put(rs.getString("id"),rs.getString("orgGroupName"));
				markMap.put(rs.getString("id"),rs.getString("orgGroupDesc"));
			}
		}catch(Exception e){}
	}
	StringTokenizer st = new StringTokenizer(check_per,",");
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
	JSONObject json = new JSONObject();
	if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
		JSONArray jsonArr = new JSONArray();
		String id=null;
		String orgGroupName=null;
		String orgGroupDesc=null;
		if(st!=null){
			while(st.hasMoreTokens()){
				id = st.nextToken();
				orgGroupName = nameMap.containsKey(id)?String.valueOf(nameMap.get(id)):"";
				orgGroupDesc = markMap.containsKey(id)?String.valueOf(markMap.get(id)):"";
				JSONObject tmp = new JSONObject();
				tmp.put("id",id);
				tmp.put("orgGroupName",orgGroupName);
				tmp.put("orgGroupDesc",orgGroupDesc);
				jsonArr.add(tmp);
			}
		}
	
		int totalPage = jsonArr.size();
		if(totalPage%perpage>0||totalPage==0){
			totalPage++;
		}
	
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
	}else{//左侧待选择列表的sql条件
		String orgGroupDesc = Tools.getURLDecode(request.getParameter("orgGroupDesc"));
		String orgGroupName = Tools.getURLDecode(request.getParameter("orgGroupName"));
		String sqlWhere = Util.null2String(request.getParameter("sqlwhere"));
		if(sqlWhere.length()==0)sqlWhere =" where 1=1 ";

		if(orgGroupDesc.length() > 0){
			sqlWhere += " and a.orgGroupDesc like '%" + Util.fromScreen2(orgGroupDesc,user.getLanguage()) +"%' ";
		}
		if(orgGroupName.length() > 0){
			sqlWhere += " and a.orgGroupName like '%" + Util.fromScreen2(orgGroupName,user.getLanguage()) +"%' ";
		}
		String excludeId = Util.null2String(request.getParameter("excludeId"));
		if(excludeId.length()==0)excludeId=check_per;
		if(excludeId.length()>0){
			sqlWhere += " and a.id not in ("+excludeId+")";
		}
		
		sqlWhere += " and (a.isDelete is null or a.isDelete='0') ";
	
		SplitPageParaBean spp = new SplitPageParaBean();
		spp.setBackFields(" a.id,a.orgGroupDesc,a.orgGroupName,a.showorder ");
		spp.setSqlFrom(" from HrmOrgGroup a ");
		spp.setSqlWhere(sqlWhere);
		spp.setSqlOrderBy("a.showOrder");
		spp.setPrimaryKey("a.id");
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
			tmp.put("orgGroupName",rs.getString("orgGroupName"));
			tmp.put("orgGroupDesc",rs.getString("orgGroupDesc"));
			jsonArr.add(tmp);
		}
		json.put("currentPage", pagenum);
		json.put("totalPage", totalPage);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
	}
%>