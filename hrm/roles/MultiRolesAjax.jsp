
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
	String check_per = Util.null2String(request.getParameter("selectids"));
	if(check_per.equals(",")){
		check_per = "";
	}
	if(check_per.equals("")){
		check_per = Util.null2String(request.getParameter("systemIds"));
	}
	Map markMap = new HashMap();
	Map nameMap = new HashMap();
	if(check_per.trim().startsWith(",")){
		check_per = check_per.substring(1);
	}
	if(!check_per.equals("")){
		try{
			String strtmp = "select id,rolesmark,rolesname from HrmRoles where id in ("+check_per+")";
			rs.executeSql(strtmp);
			while(rs.next()){
				markMap.put(rs.getString("id"),rs.getString("rolesmark"));
				nameMap.put(rs.getString("id"),rs.getString("rolesname"));
			}
		}catch(Exception e){}
	}
	StringTokenizer st = new StringTokenizer(check_per,",");
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
	String sqlWhere = " where 1=1 ";
	JSONObject json = new JSONObject();
	if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
		JSONArray jsonArr = new JSONArray();
		String id=null;
		String rolesmark=null;
		String rolesname=null;
		if(st!=null){
			while(st.hasMoreTokens()){
				id = st.nextToken();
				rolesmark = markMap.containsKey(id)?String.valueOf(markMap.get(id)):"";
				rolesname = nameMap.containsKey(id)?String.valueOf(nameMap.get(id)):"";
				JSONObject tmp = new JSONObject();
				tmp.put("id",id);
				tmp.put("rolesmark",rolesmark);
				tmp.put("rolesname",rolesname);
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
		return;
	}else{//左侧待选择列表的sql条件
		String rolesname = Tools.getURLDecode(request.getParameter("rolesname"));
		String rolesmark = Tools.getURLDecode(request.getParameter("rolesmark"));
		sqlWhere = Util.null2String(request.getParameter("sqlwhere"));
		if(sqlWhere.length()==0)
			sqlWhere =" where 1=1 ";

		if(rolesname.length() > 0){
			sqlWhere += " and a.rolesname like '%" + Util.fromScreen2(rolesname,user.getLanguage()) +"%' ";
		}
		if(rolesmark.length() > 0){
			sqlWhere += " and a.rolesmark like '%" + Util.fromScreen2(rolesmark,user.getLanguage()) +"%' ";
		}
		String excludeId = Util.null2String(request.getParameter("excludeId"));
		if(excludeId.length()==0)excludeId=check_per;
		if(excludeId.length()>0){
			sqlWhere += " and a.id not in ("+excludeId+")";
		}
	
		SplitPageParaBean spp = new SplitPageParaBean();
		spp.setBackFields(" a.id,a.rolesname,a.rolesmark ");
		spp.setSqlFrom(" from HrmRoles a ");
		spp.setSqlWhere(sqlWhere);
		spp.setSqlOrderBy("");
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
			tmp.put("rolesmark",rs.getString("rolesmark"));
			tmp.put("rolesname",rs.getString("rolesname"));
			jsonArr.add(tmp);
		}
		json.put("currentPage", pagenum);
		json.put("totalPage", totalPage);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
	}
%>