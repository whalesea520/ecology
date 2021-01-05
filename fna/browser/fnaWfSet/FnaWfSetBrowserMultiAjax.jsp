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
	if("query".equals(type)){//来自于 组合查询
		String workflowname = Util.null2String(request.getParameter("workflowname"));
		//name = URLDecoder.decode(name,"utf-8");
		
		if(!"".equals(workflowname)){
			sqlWhere += " and b.workflowname like '%"+StringEscapeUtils.escapeSql(workflowname)+"%' \n";
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

spp.setBackFields(" a.id, b.workflowname ");
spp.setSqlFrom(" fnaFeeWfInfo a join workflow_base b on a.workflowid = b.id ");
spp.setSqlWhere(sqlWhere);
spp.setSqlOrderBy("b.workflowname");
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
String subcompanyid=null;

int i=0;

RecordSet rs = spu.getCurrentPageRs(pagenum, perpage);

JSONArray jsonArr = new JSONArray();
while(rs.next()) {
	id = rs.getString("id");
	name = FnaCommon.escapeHtml(Util.null2String(rs.getString("workflowname")));
	
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