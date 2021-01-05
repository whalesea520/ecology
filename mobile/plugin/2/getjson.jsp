<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="org.apache.commons.lang.*" %>

<jsp:useBean id="documentService" class="weaver.mobile.plugin.ecology.service.DocumentService" scope="page"/>
<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map<String, Object> result = new HashMap<String, Object>();
	//未登录或登录超时
	result.put("error", "200001");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

response.setContentType("application/json;charset=UTF-8");

FileUpload fu = new FileUpload(request);

int module = Util.getIntValue(fu.getParameter("module"));
int scope = Util.getIntValue(fu.getParameter("scope"));
int pageindex = Util.getIntValue(fu.getParameter("pageindex"), 1);
int pagesize = Util.getIntValue(fu.getParameter("pagesize"), 10);

String func = fu.getParameter("func");

int columnid = Util.getIntValue(fu.getParameter("columnid"));

String docsubject = fu.getParameter("docsubject");
int createrid = Util.getIntValue(fu.getParameter("createrid"));
int createrdept = Util.getIntValue(fu.getParameter("createrdept"));
int ownerid = Util.getIntValue(fu.getParameter("ownerid"));
int ownerdept = Util.getIntValue(fu.getParameter("ownerdept"));
int createdate = Util.getIntValue(fu.getParameter("createdate"));
String startdate = fu.getParameter("startdate");
String enddate = fu.getParameter("enddate");
int seccategory = Util.getIntValue(fu.getParameter("seccategory"));

Map<String, Object> result = new HashMap<String, Object>();

if("getcolumn".equals(func)) {
	result = documentService.getColumnList(scope);
} else if("search".equals(func)) {
	List<String> conditions = new ArrayList<String>();
	if(StringUtils.isNotBlank(docsubject)) conditions.add("t1.docsubject like '%"+docsubject+"%'");
	if(createrid > 0) conditions.add("t1.doccreaterid="+createrid);
	if(createrdept > 0) conditions.add("t1.doccreaterid in (select id from HrmResource where departmentid="+createrdept+")");
	if(ownerid > 0) conditions.add("t1.ownerid="+ownerid);
	if(ownerdept > 0) conditions.add("t1.docdepartmentid="+ownerdept);
	if(seccategory > 0) conditions.add("t1.seccategory="+seccategory);
	
	if(createdate >= 1 && createdate <= 6) {
		if(createdate == 1) {//今天
			startdate = TimeUtil.getCurrentDateString();
			enddate = TimeUtil.getCurrentDateString();
		} else if(createdate == 2) {//本周
			startdate = TimeUtil.getFirstDayOfWeek();
			enddate = StringUtils.substring(TimeUtil.getLastDayOfWeek(), 0, 10);
		} else if(createdate == 3) {//本月
			startdate = TimeUtil.getFirstDayOfMonth();
			enddate = StringUtils.substring(TimeUtil.getLastDayOfMonth(), 0, 10);
		} else if(createdate == 4) {//本季
			startdate = TimeUtil.getFirstDayOfSeason();
			enddate = StringUtils.substring(TimeUtil.getLastDayDayOfSeason(), 0, 10);
		} else if(createdate == 5) {//本年
			startdate = TimeUtil.getFirstDayOfTheYear();
			enddate = StringUtils.substring(TimeUtil.getLastDayOfYear(), 0, 10);
		} else if(createdate == 6) {//指定范围
			try {
				if(StringUtils.isNotBlank(startdate)) startdate = TimeUtil.SetDateFormat(startdate, "yyyy-MM-dd");
			} catch(Exception e) {
				startdate = "";
			}
			try {
				if(StringUtils.isNotBlank(enddate)) enddate = TimeUtil.SetDateFormat(enddate, "yyyy-MM-dd");
			} catch(Exception e) {
				enddate = "";
			}
		}
		
		if(StringUtils.isNotBlank(startdate)) conditions.add("t1.doccreatedate >= '"+startdate+"'");
		if(StringUtils.isNotBlank(enddate)) conditions.add("t1.doccreatedate <= '"+enddate+"'");
	}

	if(scope>0){
		String where =documentService.getWheresByScope(scope);
		if(where!=null&&!where.trim().equals("")){
			conditions.add(where);
		}
	}	
	result = documentService.getDocumentList2(3, user, pageindex, pagesize, 0, conditions);
} else if("favorite".equals(func)) {
	List<String> conditions = new ArrayList<String>();
	conditions.add("exists(select 1 from SysFavourite where favouriteObjId=t1.id and favouritetype=1 and Resourceid="+user.getUID()+")");
	if(StringUtils.isNotBlank(docsubject)) conditions.add("t1.docsubject like '%"+docsubject+"%'");
	/*
	 *  收藏的文档，不需要按照设置的权限来过滤
	if(scope>0){
		String where =documentService.getWheresByScope(scope);
		if(where!=null&&!where.trim().equals("")){
			conditions.add(where);
		}
	}
	*/
	result = documentService.getDocumentList2(3, user, pageindex, pagesize, 0, conditions);
} else if("gethome".equals(func) || module == 2) {//默认搜索，放在最后
	List<String> conditions = new ArrayList<String>();
	if(StringUtils.isNotBlank(docsubject)) conditions.add("t1.docsubject like '%"+docsubject+"%'");
	if(scope>0&&columnid<=0){
		String where =documentService.getWheresByScope(scope);
		if(where!=null&&!where.trim().equals("")){
			conditions.add(where);
		}
	}
	result = documentService.getDocumentList2(module, user, pageindex, pagesize, columnid, conditions);
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>