<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.formmode.service.CustomResourceService"%>
<%@page import="weaver.formmode.service.LogService"%>
<%@page import="weaver.formmode.Module"%>
<%@page import="weaver.formmode.log.LogType"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
User user = HrmUserVarify.getUser (request , response) ;
LogService logService = new LogService();
logService.setUser(user);
if(operation.equals("getFieldsBySearchId")){
	String customSearchId = Util.null2String(request.getParameter("customSearchId"));
	JSONArray array = new JSONArray();
	String sql = "select f.id,f.fieldname,f.fielddbtype,f.fieldhtmltype,f.type,l.indexdesc,s.modeid,s.formid from mode_customsearch s, workflow_billfield f, htmllabelindex l "+
		"where s.formid=f.billid and f.fieldlabel=l.id and s.id="+customSearchId;
	 if(RecordSet.getDBType().equalsIgnoreCase("oracle")){
        sql+=" and f.detailtable is null ";
    }else{
        sql+=" and f.detailtable ='' ";
    }
	RecordSet.executeSql(sql);
	String modeid = "";
	String formid = "";
	while(RecordSet.next()){
		JSONObject object = new JSONObject();
		
		String id = Util.null2String(RecordSet.getString("id"));
		String fieldname = Util.null2String(RecordSet.getString("fieldname"));
		String fielddbtype = Util.null2String(RecordSet.getString("fielddbtype"));
		String fieldhtmltype = Util.null2String(RecordSet.getString("fieldhtmltype"));
		String type = Util.null2String(RecordSet.getString("type"));
		String indexdesc = Util.null2String(RecordSet.getString("indexdesc"));
		
		modeid = Util.null2String(RecordSet.getString("modeid"));
		formid = Util.null2String(RecordSet.getString("formid"));
		
		object.put("fieldid", id);
		object.put("fieldname", fieldname);
		object.put("fielddbtype", fielddbtype);
		object.put("fieldhtmltype", fieldhtmltype);
		object.put("type", type);
		object.put("indexdesc", indexdesc);
		
		array.add(object);
	}
	JSONObject objectresult = new JSONObject();
    objectresult.put("result", array);
    objectresult.put("modeid", modeid);
    objectresult.put("formid", formid);
    response.getWriter().print(objectresult.toString());
}else if(operation.equals("getFieldsByResourceId")){
	String resourceId = Util.null2String(request.getParameter("resourceId"));
	String browsername = "";
	JSONArray array = new JSONArray();
	String sql = "select fielddbtype from workflow_billfield where id="+resourceId;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		browsername = Util.null2String(RecordSet.getString(1));
		browsername = browsername.replace("browser.", "");//去掉前面的browser.
	}
	
	if(!browsername.equals("")){
		sql = "select distinct f.*,l.indexdesc from datashowset d,mode_custombrowser b,workflow_billfield f,htmllabelindex l "+
			"where d.customid=b.id and b.formid=f.billid and f.fieldlabel=l.id and showname='"+browsername+"'";
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			JSONObject object = new JSONObject();
			
			String id = Util.null2String(RecordSet.getString("id"));
			String fieldname = Util.null2String(RecordSet.getString("fieldname"));
			String fielddbtype = Util.null2String(RecordSet.getString("fielddbtype"));
			String fieldhtmltype = Util.null2String(RecordSet.getString("fieldhtmltype"));
			String type = Util.null2String(RecordSet.getString("type"));
			String indexdesc = Util.null2String(RecordSet.getString("indexdesc"));
			
			object.put("fieldid", id);
			object.put("fieldname", fieldname);
			object.put("fielddbtype", fielddbtype);
			object.put("fieldhtmltype", fieldhtmltype);
			object.put("type", type);
			object.put("indexdesc", indexdesc);
			
			array.add(object);
		}
		JSONObject objectresult = new JSONObject();
	    objectresult.put("result", array);
	    response.getWriter().print(objectresult.toString());
	}
}else if(operation.equals("saveorupdate")){
	String id = Util.null2String(request.getParameter("id"));
	String appid = Util.null2String(request.getParameter("appid"));
	String resourceName = Util.null2String(request.getParameter("resourceName"));
	String customSearchId = Util.null2String(request.getParameter("customSearchId"));
	String titleFieldId = Util.null2String(request.getParameter("titleFieldId"));
	String startDateFieldId = Util.null2String(request.getParameter("startDateFieldId"));
	String endDateFieldId = Util.null2String(request.getParameter("endDateFieldId"));
	String startTimeFieldId = Util.null2String(request.getParameter("startTimeFieldId"));
	String endTimeFieldId = Util.null2String(request.getParameter("endTimeFieldId"));
	String contentFieldId = Util.null2String(request.getParameter("contentFieldId"));
	String resourceFieldId = Util.null2String(request.getParameter("resourceFieldId"));
	String resourceShowFieldId = Util.null2String(request.getParameter("resourceShowFieldId"));
	String description = Util.null2String(request.getParameter("description"));
	String dsporder = Util.null2String(request.getParameter("dsporder"));
	String createUrl = Util.null2String(request.getParameter("createUrl"));
	
	String sql = "";
	if(id.equals("0")){
		sql = "insert into mode_customResource"+
			"(appid,resourceName,customSearchId,titleFieldId,startDateFieldId,endDateFieldId,startTimeFieldId,endTimeFieldId,contentFieldId,resourceFieldId,resourceShowFieldId,description,dsporder,createUrl) "+
			"values ("+appid+",'"+resourceName+"','"+customSearchId+"','"+titleFieldId+"','"+startDateFieldId+"','"+endDateFieldId+"','"+startTimeFieldId+"','"+endTimeFieldId+"','"+contentFieldId+"','"+resourceFieldId+"','"+resourceShowFieldId+"','"+description+"','"+dsporder+"','"+createUrl+"')";
		RecordSet.executeSql(sql);
		
		RecordSet.executeSql("select max(id) from mode_customResource");
		if(RecordSet.next()){
			id = Util.null2String(RecordSet.getString(1));
		}
		logService.log(id, Module.RESOURCE, LogType.ADD);
	}else{
		sql = "update mode_customResource set "+
			"resourceName='"+resourceName+"',"+
			"customSearchId='"+customSearchId+"',"+
			"titleFieldId='"+titleFieldId+"',"+
			"startDateFieldId='"+startDateFieldId+"',"+
			"endDateFieldId='"+endDateFieldId+"',"+
			"startTimeFieldId='"+startTimeFieldId+"',"+
			"endTimeFieldId='"+endTimeFieldId+"',"+
			"contentFieldId='"+contentFieldId+"',"+
			"resourceFieldId='"+resourceFieldId+"',"+
			"resourceShowFieldId='"+resourceShowFieldId+"',"+
			"description='"+description+"',"+
			"dsporder='"+dsporder+"', "+
			"createUrl='"+createUrl+"' "+
			"where id="+id;
		RecordSet.executeSql(sql);
		logService.log(id, Module.RESOURCE, LogType.EDIT);
	}
	
	response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshCustomResource("+id+");</script>");
}else if(operation.equals("getCustomResourceByModeIdWithJSONDetach")){
	int appid = Util.getIntValue(Util.null2String(request.getParameter("appid")),-1);
	int subCompanyId = Util.getIntValue(Util.null2String(request.getParameter("subCompanyId")),-1);
	String fmdetachable = Util.null2String(request.getParameter("fmdetachable"));
	
	CustomResourceService customResourceService = new CustomResourceService();
	JSONArray resourceCustomtreeArr = new JSONArray();
	if(fmdetachable.equals("1")){
		resourceCustomtreeArr = customResourceService.getCustomResourceByModeIdWithJSONDetach(appid,subCompanyId);
	}else{
		resourceCustomtreeArr = customResourceService.getCustomResourceByModeIdWithJSONDetach(appid);
	}
	out.print(resourceCustomtreeArr.toString());
	out.flush();
	out.close();
	return;
}else if(operation.equals("delete")){
	CustomResourceService customResourceService = new CustomResourceService();
	String id = Util.null2String(request.getParameter("id"));
	int appid = Util.getIntValue(request.getParameter("appid"));
	customResourceService.deleteCustomResource(Util.getIntValue(id));
	
	logService.log(id, Module.RESOURCE, LogType.DELETE);
	
	List<Map<String,Object>> list = customResourceService.getCustomResourceByModeIds(appid, -1);
	
	String firstId = "";
	if(list != null && list.size()>0){
		firstId = Util.null2String(list.get(0).get("id"));
	}
	response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshCustomResource("+firstId+");</script>");
}
%>