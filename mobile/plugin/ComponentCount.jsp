
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.docs.news.*"%>
<%@ page import="org.apache.commons.lang.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.mobile.plugin.ecology.service.DocumentService"%>

<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");

FileUpload fu = new FileUpload(request);

String module = Util.null2String(fu.getParameter("module"));
String scope = Util.null2String(fu.getParameter("scope"));
String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String setting = Util.null2String(fu.getParameter("setting"));
String mconfig = Util.null2String(fu.getParameter("config"));

if(ps.verify(sessionkey)) {

	List conditions = new ArrayList();
	
	if(StringUtils.isNotEmpty(setting)) {
		if(module.equals("1")||module.equals("7")||module.equals("8")||module.equals("9")||module.equals("10")) {
			String condition = "";
			String cfgstr = setting;
			cfgstr = cfgstr.startsWith(",")?cfgstr.substring(1):cfgstr;
			if(StringUtils.isNotEmpty(cfgstr)) {
				String strSubClause = Util.getSubINClause(WorkflowVersion.getAllVersionStringByWFIDs(cfgstr), "t1.workflowid", "IN");
				if("".equals(condition)){
					 condition += strSubClause;
				} else {
					 condition += " or " + strSubClause;
				}
				if (condition != null && !"".equals(condition)) {
					condition = " (" + condition + ") ";
				}
				conditions.add(condition);
			}
		} else if(module.equals("2")||module.equals("3")) {
			String where =DocumentService.getWheresBySettings(setting);
			if(where!=null&&!where.trim().equals("")){
				conditions.add(where);
			}
		}
	}
	
	int unread = 0;
	int count = 0;
	if(module.equals("1")||module.equals("7")||module.equals("8")||module.equals("9")||module.equals("10")) {
		Map result = (Map) ps.getWorkflowCount(Util.getIntValue(module), Util.getIntValue(scope), conditions, sessionkey);
		if(result!=null) {
			unread = Util.getIntValue(Util.null2String((String)result.get("unread")), 0);
			count = Util.getIntValue(Util.null2String((String)result.get("count")), 0);
		}
	}
	if(module.equals("2")||module.equals("3")) {
		Map result = ps.getDocumentCount(conditions, sessionkey);
		if(result!=null) {
			unread = Util.getIntValue(Util.null2String((String)result.get("unread")), 0);
			count = Util.getIntValue(Util.null2String((String)result.get("count")), 0);
		}
	}
	if(module.equals("4")) {
		Map result = ps.getScheduleCount(conditions, sessionkey);
		if(result!=null) {
			unread = Util.getIntValue(Util.null2String((String)result.get("unread")), 0);
			count = Util.getIntValue(Util.null2String((String)result.get("count")), 0);
		}
	}
	if(module.equals("5")) {
		Map result = ps.getMeetingCount(conditions, sessionkey);
		if(result!=null) {
			unread = Util.getIntValue(Util.null2String((String)result.get("unread")), 0);
			count = Util.getIntValue(Util.null2String((String)result.get("count")), 0);
		}
	}
	Map result = new HashMap();
	
	result.put("count", count+"");
	result.put("unread", unread+"");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
%>