<%@page import="weaver.proj.Maint.ProjectTypeComInfo"%>
<%@page import="weaver.proj.Maint.ProjectStatusComInfo"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.conn.RecordSet"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SplitPageParaBean" %>
<%@ page import="weaver.general.SplitPageUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.proj.Maint.WorkTypeComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);


String src = Util.null2String(request.getParameter("src"));

String check_per = Util.null2String(request.getParameter("systemIds"));
String resourceids = Util.null2String(request.getParameter("resourceids"));

if(check_per.trim().startsWith(",")){
	check_per = check_per.substring(1);
}
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;

String sqlWhere = " where 1=1 ";
String SqlWhere = "";
RecordSet rs =new RecordSet() ;
JSONObject json = new JSONObject();
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
	if (!check_per.equals("")) {
		if(check_per.indexOf(",")==0){
			check_per=check_per.substring(1);
		}
		sqlWhere += " and t1.id in ("+check_per+")";
	} else {
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList","");
		out.println(json.toString());
		return;
	}
	//SqlWhere+=sqlWhere;
	rs.executeSql("select  t1.id, t1.name, t1.status,t1.prjtype,t1.worktype,t1.manager from Prj_ProjectInfo t1 where t1.id in ("+check_per+") ");
	
}else{//左侧待选择列表的sql条件
		
	String name = Util.null2String(request.getParameter("name"));
	String from = Util.null2String(request.getParameter("from"));
	String description = Util.null2String(request.getParameter("description"));
	String prjtype = Util.null2String(request.getParameter("prjtype"));
	String worktype = Util.null2String(request.getParameter("worktype"));
	String manager = Util.null2String(request.getParameter("manager"));
	String status = Util.null2String(request.getParameter("status"));
	String statusAll = Util.null2String(request.getParameter("statusAll"));
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

	String resourcenames = "";
	if (!check_per.equals("")) {
		String strtmp = "select id,name from Prj_ProjectInfo  where id in ("+check_per+")";
		RecordSet.executeSql(strtmp);
		Hashtable ht = new Hashtable();
		while (RecordSet.next()) {
			ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("name")));
		}
		try{
			StringTokenizer st = new StringTokenizer(check_per,",");

			while(st.hasMoreTokens()){
				String s = st.nextToken();
				resourceids +=","+s;
				resourcenames += ","+ht.get(s).toString();
			}
		}catch(Exception e){
			resourceids ="";
			resourcenames ="";
		}
	}

	int ishead = 0;
	if(!sqlwhere.equals("")) ishead = 1;
	if(!name.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
		}
		else 
			sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	if(!description.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
		}
		else
			sqlwhere += " and t1.description like '%" + Util.fromScreen2(description,user.getLanguage()) +"%' ";
	}
	if(!prjtype.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.prjtype = "+ prjtype ;
		}
		else
			sqlwhere += " and t1.prjtype = "+ prjtype;
	}
	if(!worktype.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.worktype = "+ worktype ;
		}
		else
			sqlwhere += " and t1.worktype = "+ worktype ;
	}
	if(!manager.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.manager = "+ manager ;
		}
		else
			sqlwhere += " and t1.manager = "+ manager;
	}
	if(!status.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.status =" + status +" " ;
		}
		else
			sqlwhere += " and t1.status =" + status +" " ;
	}
	if(!statusAll.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.status in (" + statusAll +") " ;
		}
		else
			sqlwhere += " and t1.status in (" + statusAll +") " ;
	}



	
	String permissionSql="";
	if("prjtskimp".equalsIgnoreCase(from) ){
		permissionSql=" ("+CommonShareManager.getPrjShareWhereByUserCanEdit(user)+") ";
	}else{
		permissionSql=" ("+CommonShareManager.getPrjShareWhereByUser(user)+") ";
	}
	
	if(!sqlwhere.equals("")){
		SqlWhere = sqlwhere +" and "+permissionSql;
	}else{
		SqlWhere = " where "+permissionSql ;
	}


	if (check_per.equals("")) {
		//check_per = Util.null2String(request.getParameter("excludeId"));
	}
	if (!check_per.equals("")) {
		if(check_per.indexOf(',')==0){
			check_per=check_per.substring(1);
		}
		//SqlWhere += " and t1.id not in ("+check_per+")";
	}
	
	SplitPageParaBean spp = new SplitPageParaBean();

	spp.setBackFields(" t1.id, t1.name, t1.status,t1.prjtype,t1.worktype,t1.manager ");
	spp.setSqlFrom(" Prj_ProjectInfo t1 ");
	spp.setSqlWhere(SqlWhere);
	spp.setSqlOrderBy("t1.id");
	spp.setPrimaryKey("t1.id");
	spp.setDistinct(true);
	spp.setSortWay(spp.DESC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);
	
	spu.setRecordCount(perpage);
	rs = spu.getCurrentPageRs(pagenum, perpage);
}




int totalPage =1;
/**
int RecordSetCounts = spu.getRecordCount();
totalPage = RecordSetCounts/perpage;
if(totalPage%perpage>0||totalPage==0){
	totalPage++;
}
**/

String id=null;
String prjname=null;
String prjstatus=null;
String prjtype=null;
String prjworktype=null;
String prjmanager=null;

int i=0;



JSONArray jsonArr = new JSONArray();
while(rs.next()) {
	id = rs.getString("id");
	prjname = Util.null2String(rs.getString("name"));
	prjstatus=ProjectStatusComInfo.getProjectStatusdesc( Util.null2String(rs.getString("status")));
	prjtype=ProjectTypeComInfo.getProjectTypename(Util.null2String(rs.getString("prjtype")));
	prjworktype=WorkTypeComInfo.getWorkTypename(Util.null2String(rs.getString("worktype")));
	prjmanager=ResourceComInfo.getResourcename(Util.null2String(rs.getString("manager")));
	JSONObject tmp = new JSONObject();
	tmp.put("id",id);
	tmp.put("name",prjname);	
	tmp.put("status",prjstatus);	
	tmp.put("prjtype",prjtype);	
	tmp.put("prjworktype",prjworktype);	
	tmp.put("prjmanager",prjmanager);	
	jsonArr.add(tmp);
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
%>