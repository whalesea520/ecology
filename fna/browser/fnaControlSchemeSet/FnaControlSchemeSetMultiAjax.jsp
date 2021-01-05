<%@page import="weaver.fna.general.FnaCommon"%>
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

int fnaControlSchemeId=Util.getIntValue(request.getParameter("fnaControlSchemeId"), 0);

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
		sqlWhere += " and a.id in ("+check_per+")";
	} else {
		json.put("currentPage", 1);
		json.put("totalPage", 1);
		json.put("mapList","");
		out.println(json.toString());
		return;
	}
}else{//左侧待选择列表的sql条件
	if("query".equals(type)){//来自于 结构树
		String name = Util.null2String(request.getParameter("name"));
		String code = Util.null2String(request.getParameter("code"));
		
		if(!"".equals(name)){
			sqlWhere += " and a.name like '%"+StringEscapeUtils.escapeSql(name)+"%' \n";
		}
		if(!"".equals(code)){
			sqlWhere += " and a.code like '%"+StringEscapeUtils.escapeSql(code)+"%' \n";
		}
	}

	if (check_per.equals("")) {
		check_per = Util.null2String(request.getParameter("excludeId"));
	}
	if (!check_per.equals("")) {
		if(check_per.indexOf(',')==0){
			check_per=check_per.substring(1);
		}
		sqlWhere += " and a.id not in ("+check_per+")";
	}
}

//new BaseBean().writeLog("select a.id, a.name, a.supsubject, a.feelevel from FnaBudgetfeeType a "+sqlWhere);

SplitPageParaBean spp = new SplitPageParaBean();

spp.setBackFields(" a.id, a.name, a.code ");
spp.setSqlFrom(" fnaControlScheme a ");
spp.setSqlWhere(sqlWhere);
spp.setSqlOrderBy("a.name, a.code");
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

String id=null;
String name=null;
String code=null;

int i=0;

RecordSet rs = spu.getCurrentPageRs(pagenum, perpage);

JSONArray jsonArr = new JSONArray();
while(rs.next()) {
	id = rs.getString("id");
	name = FnaCommon.escapeHtml(Util.null2String(rs.getString("name")));
	code = FnaCommon.escapeHtml(Util.null2String(rs.getString("code")));
	
	//new BaseBean().writeLog("id="+id+";name="+name);
	
	JSONObject tmp = new JSONObject();
	tmp.put("id",id);
	tmp.put("name",name);	
	tmp.put("code",code);	
	jsonArr.add(tmp);
}
json.put("currentPage", pagenum);
json.put("totalPage", totalPage);
json.put("mapList",jsonArr.toString());
out.println(json.toString());
%>