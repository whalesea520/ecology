<%@page import="weaver.fna.general.FnaCommon"%>
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

int supFccId=Util.getIntValue(request.getParameter("fccId"), 0);

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

String sqlWhere = " where "+FnaCostCenter.getDbUserName()+"getFccArchive1(a.id) = 0 ";
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
	if("tree".equals(type)){//来自于 结构树
		if(supFccId != 0){
			sqlWhere += " and (a.supFccId = "+supFccId+" or a.id = "+supFccId+")";
		}
	}else if("query".equals(type)){//来自于 组合查询
		String name = Util.null2String(request.getParameter("name"));
		//name = URLDecoder.decode(name,"utf-8");
		String code = Util.null2String(request.getParameter("code"));
		//code = URLDecoder.decode(code,"utf-8");
		
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

//out.println("select a.id, a.name, a.supFccId, a.code from FnaCostCenter a "+sqlWhere+" order by a.code,a.name");
//new BaseBean().writeLog("select a.id, a.name, a.supFccId, a.code from FnaCostCenter a "+sqlWhere+" order by a.code,a.name");

SplitPageParaBean spp = new SplitPageParaBean();

spp.setBackFields(" a.id, a.name, a.supFccId, a.code, a.type ");
spp.setSqlFrom(" FnaCostCenter a ");
spp.setSqlWhere(sqlWhere);
spp.setSqlOrderBy("a.type,a.code,a.name");
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

int i=0;

RecordSet rs = spu.getCurrentPageRs(pagenum, perpage);

JSONArray jsonArr = new JSONArray();
while(rs.next()) {
	String id = rs.getString("id");
	String name = FnaCommon.escapeHtml(Util.null2String(rs.getString("name")));
	String code = FnaCommon.escapeHtml(Util.null2String(rs.getString("code")));
	
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