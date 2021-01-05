<%@page import="weaver.conn.RecordSet"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SplitPageParaBean" %>
<%@ page import="weaver.general.SplitPageUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
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

String SqlWhere = "";
RecordSet rs =new RecordSet() ;
JSONObject json = new JSONObject();
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
	if (!check_per.equals("")) {
		if(check_per.indexOf(",")==0){
			check_per=check_per.substring(1);
		}
	} else {
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList","");
		out.println(json.toString());
		return;
	}
	//SqlWhere+=sqlWhere;
	rs.executeSql("select  t1.id, t1.name, t1.capitalspec,t1.mark,t1.blongsubcompany,t1.resourceid from cptcapital t1 where t1.id in ("+check_per+") ");
	
}else{//左侧待选择列表的sql条件
		
	String name = Util.null2String(request.getParameter("name"));
	String from = Util.null2String(request.getParameter("from"));
	String capitalspec = Util.null2String(request.getParameter("capitalspec"));
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	String mark = Util.null2String(request.getParameter("mark"));
	String blongsubcompany = Util.null2String(request.getParameter("blongsubcompany"));
	String capitalgroupid = Util.null2String(request.getParameter("capitalgroupid"));
	//String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	String sqlwhere = " where isdata='1' ";

	String resourcenames = "";
	if (!check_per.equals("")) {
		String strtmp = "select id,name,capitalspec,mark,blongsubcompany from cptcapital  where id in ("+check_per+")";
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
	if(!capitalspec.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.capitalspec like '%" + Util.fromScreen2(capitalspec,user.getLanguage()) +"%' ";
		}
		else
			sqlwhere += " and t1.capitalspec like '%" + Util.fromScreen2(capitalspec,user.getLanguage()) +"%' ";
	}
	if(!mark.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.mark like '%" + Util.fromScreen2(mark,user.getLanguage()) +"%' ";
		}
		else
			sqlwhere += " and t1.mark like '%" + Util.fromScreen2(mark,user.getLanguage()) +"%' ";
	}
	if(!resourceid.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.resourceid = "+ resourceid ;
		}
		else
			sqlwhere += " and t1.resourceid = "+ resourceid;
	}
	if(!blongsubcompany.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.blongsubcompany = "+ blongsubcompany ;
		}
		else
			sqlwhere += " and t1.blongsubcompany = "+ blongsubcompany ;
	}
	if(!capitalgroupid.equals("")){
		if(ishead==0){
			ishead = 1;
			sqlwhere += " where t1.capitalgroupid = "+ capitalgroupid ;
		}
		else
			sqlwhere += " and t1.capitalgroupid = "+ capitalgroupid ;
	}


	/**
	String permissionSql="";
	permissionSql=" ("+CommonShareManager.getPrjShareWhereByUser(user)+") ";
	if(!sqlwhere.equals("")){
		SqlWhere = sqlwhere +" and "+permissionSql;
	}else{
		SqlWhere = " where "+permissionSql ;
	}**/


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

	spp.setBackFields(" t1.id, t1.name, t1.capitalspec,t1.mark,t1.blongsubcompany ");
	spp.setSqlFrom(" cptcapital t1 ");
	spp.setSqlWhere(sqlwhere);
	spp.setSqlOrderBy("t1.name");
	spp.setPrimaryKey("t1.id");
	spp.setDistinct(true);
	spp.setSortWay(spp.ASC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);
	
	spu.setRecordCount(perpage);
	rs = spu.getCurrentPageRs(pagenum, perpage);
}




int totalPage =1;

String cptid=null;
String cptname=null;
String cptmark=null;
String cptcapitalspec=null;
String cptresourceid=null;
String cptblongsubcompany=null;

int i=0;



JSONArray jsonArr = new JSONArray();
while(rs.next()) {
	cptid = rs.getString("id");
	cptname = Util.null2String(rs.getString("name"));
	cptmark=Util.null2String(rs.getString("mark"));
	cptcapitalspec=Util.null2String(rs.getString("capitalspec"));
	cptresourceid=ResourceComInfo.getResourcename(Util.null2String(rs.getString("resourceid")));
	cptblongsubcompany=SubCompanyComInfo.getSubCompanyname(Util.null2String(rs.getString("blongsubcompany")));
	
	JSONObject tmp = new JSONObject();
	tmp.put("id",cptid);
	tmp.put("name",cptname);	
	tmp.put("mark",cptmark);	
	tmp.put("capitalspec",cptcapitalspec);	
	tmp.put("resourceid",cptresourceid);	
	tmp.put("blongsubcompany",cptblongsubcompany);	
	jsonArr.add(tmp);
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
%>