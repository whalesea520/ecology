
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%><%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
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
<%
User user = HrmUserVarify.getUser(request,response);

int feeperiod=Util.getIntValue(request.getParameter("feeperiod"), 0);
int supsubject=Util.getIntValue(request.getParameter("supsubject"), 0);

String src = Util.null2String(request.getParameter("src"));
String type = Util.null2String(request.getParameter("type"));

String check_per = Util.null2String(request.getParameter("systemIds"));
if(check_per.trim().startsWith(",")){
	check_per = check_per.substring(1);
}
int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
if(src.equalsIgnoreCase("dest")){
	perpage = 99999;
}
int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;

String sqlWhere = " where 1=1 ";
JSONObject json = new JSONObject();
if(src.equalsIgnoreCase("dest")){//右侧已选择列表的sql条件
	if (!check_per.equals("")) {
		if(check_per.indexOf(",")==0){
			check_per=check_per.substring(1);
		}
		sqlWhere+=" and (1=2 ";
		List<String> check_perSqlContList = FnaCommon.initData1(check_per.split(","));
		int check_perSqlContList_len = check_perSqlContList.size();
		for (int i = 0; i < check_perSqlContList_len; i++) {
			String check_perSqlCont = check_perSqlContList.get(i);
			sqlWhere+=" or a.id in ("+check_perSqlCont+") ";
		}
		sqlWhere+=" ) ";
	} else {
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList","");
		out.println(json.toString());
		return;
	}
}else{//左侧待选择列表的sql条件
	if("tree".equals(type)){//来自于 结构树
		if(supsubject > 0){
			sqlWhere += "and a.allSupSubjectIds like '"+StringEscapeUtils.escapeSql(new BudgetfeeTypeComInfo().getAllSupSubjectIds(supsubject+""))+"%' ";
		}
	}else if("query".equals(type)){//来自于 组合查询
		String name = Util.null2String(request.getParameter("name"));
		//name = URLDecoder.decode(name,"utf-8");
		String description = Util.null2String(request.getParameter("description"));
		//description = URLDecoder.decode(description,"utf-8");
		
		if(!"".equals(name)){
			sqlWhere += " and a.name like '%"+StringEscapeUtils.escapeSql(name)+"%' \n";
		}
		if(!"".equals(description)){
			sqlWhere += " and a.description like '%"+StringEscapeUtils.escapeSql(description)+"%' \n";
		}
	}
	if(feeperiod>0){
		sqlWhere += " and a.feeperiod = "+feeperiod+" ";
	}
	sqlWhere += " and (a.Archive is null or a.Archive = 0) ";
	sqlWhere += " and (a.GROUPCTRLID > 0 or a.isEditFeeType > 0) ";

	if (check_per.equals("")) {
		check_per = Util.null2String(request.getParameter("excludeId"));
	}
	if (!check_per.equals("")) {
		if(check_per.indexOf(',')==0){
			check_per=check_per.substring(1);
		}
		sqlWhere+=" and (1=1 ";
		List<String> check_perSqlContList = FnaCommon.initData1(check_per.split(","));
		int check_perSqlContList_len = check_perSqlContList.size();
		for (int i = 0; i < check_perSqlContList_len; i++) {
			String check_perSqlCont = check_perSqlContList.get(i);
			sqlWhere+=" and a.id not in ("+check_perSqlCont+") ";
		}
		sqlWhere+=" ) ";
	}
}

new BaseBean().writeLog("select a.id, a.name, a.supsubject, a.feelevel from FnaBudgetfeeType a "+sqlWhere);

SplitPageParaBean spp = new SplitPageParaBean();

spp.setBackFields(" a.displayOrder, a.id, a.name, a.codename, a.supsubject, a.feelevel ");
spp.setSqlFrom(" FnaBudgetfeeType a ");
spp.setSqlWhere(sqlWhere);
spp.setSqlOrderBy("a.displayOrder,a.codeName,a.name");
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
String name=null;
String subcompanyid=null;

int i=0;

RecordSet rs = spu.getCurrentPageRs(pagenum, perpage);

JSONArray jsonArr = new JSONArray();
while(rs.next()) {
	id = rs.getString("id");
	name = FnaCommon.escapeHtml(Util.null2String(rs.getString("name")));
	
	//new BaseBean().writeLog("id="+id+";name="+name);
	
	JSONObject tmp = new JSONObject();
	tmp.put("id",id);
	tmp.put("name",name);	
	jsonArr.add(tmp);
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
%>