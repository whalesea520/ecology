
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
	if(check_per.equals("")){
		check_per = Util.null2String(request.getParameter("systemIds"));
	}
	if(check_per.trim().startsWith(",")){
		check_per = check_per.substring(1);
	}
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;

	JSONObject json = new JSONObject();
	StringTokenizer st = new StringTokenizer(check_per,",");
	if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
		Map nameMap = new HashMap();
		Map markMap = new HashMap();
		if(!check_per.equals("")){
			try{
				String strtmp = "select a.id,b.rightname,b.rightdesc,a.righttype from SystemRights a left join SystemRightsLanguage b on a.id = b.id and b.languageid = "+user.getLanguage()+" where a.id in ("+check_per+")";
				rs.executeSql(strtmp);
				while(rs.next()){
					nameMap.put(rs.getString("id"),rs.getString("rightname"));
					markMap.put(rs.getString("id"),rs.getString("rightdesc"));
				}
			}catch(Exception e){}
		}
		JSONArray jsonArr = new JSONArray();
		String id=null;
		String rightname=null;
		String rightdesc=null;
		if(st!=null){
			while(st.hasMoreTokens()){
				id = st.nextToken();
				rightname = nameMap.containsKey(id)?String.valueOf(nameMap.get(id)):"";
				rightdesc = markMap.containsKey(id)?String.valueOf(markMap.get(id)):"";
				JSONObject tmp = new JSONObject();
				tmp.put("id",id);
				tmp.put("rightname",rightname);
				tmp.put("rightdesc",rightdesc);
				jsonArr.add(tmp);
			}
		}
	
		int totalPage = jsonArr.size();
		if(totalPage%perpage>0||totalPage==0){
			totalPage++;
		}
	
		json.put("currentPage", 1);
		json.put("totalPage", totalPage);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
	}else{//左侧待选择列表的sql条件
		String rightname = Tools.getURLDecode(request.getParameter("rightname"));
		String rightdesc = Tools.getURLDecode(request.getParameter("rightdesc"));
		String righttype = Tools.getURLDecode(request.getParameter("righttype"));
		String sqlWhere = Util.null2String(request.getParameter("sqlWhere"));
		if(sqlWhere.length()==0)
			sqlWhere =" where 1=1 ";

		if(rightname.length() > 0){
			sqlWhere += " and b.rightname like '%" + Util.fromScreen2(rightname,user.getLanguage()) +"%' ";
		}
		if(rightdesc.length() > 0){
			sqlWhere += " and b.rightdesc like '%" + Util.fromScreen2(rightdesc,user.getLanguage()) +"%' ";
		}
		if(righttype.length() > 0){
			sqlWhere += " and a.righttype = " + righttype;
		}
		String excludeId = Util.null2String(request.getParameter("excludeId"));
		if(excludeId.length()==0)excludeId=check_per;
		if(excludeId.length()>0){
			sqlWhere += " and a.id not in ("+excludeId+")";
		}
		SplitPageParaBean spp = new SplitPageParaBean();
		spp.setBackFields(" a.id,b.rightname,b.rightdesc,a.righttype ");
		spp.setSqlFrom(" from SystemRights a left join SystemRightsLanguage b on a.id = b.id and b.languageid = "+user.getLanguage());
		spp.setSqlWhere(sqlWhere);
		spp.setSqlOrderBy("a.righttype , a.id");
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
			tmp.put("rightname",rs.getString("rightname"));
			tmp.put("rightdesc",rs.getString("rightdesc"));
			jsonArr.add(tmp);
		}
		json.put("currentPage", pagenum);
		json.put("totalPage", totalPage);
		json.put("mapList",jsonArr.toString());
		out.println(json.toString());
	}
%>