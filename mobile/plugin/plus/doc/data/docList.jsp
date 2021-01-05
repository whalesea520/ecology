<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<jsp:useBean id="ds" class="weaver.mobile.plugin.ecology.service.DocumentService" scope="page" />
<%
out.clearBuffer();
request.setCharacterEncoding("UTF-8");
response.setContentType("application/json;charset=UTF-8");
String operation = Util.null2String(request.getParameter("operation"));
JSONObject json = new JSONObject();
String msg = "";
if(operation.equals("getDataList")){
	try{
		int pageSize = Util.getIntValue(request.getParameter("pagesize"),10);
		int pageIndex = Util.getIntValue(request.getParameter("pageindex"),1);
		String docsubject = Util.null2String(request.getParameter("docsubject"));//标题
		int createid = Util.getIntValue(Util.null2String(request.getParameter("createid")), 0);//创建人
		String createdatestart = Util.null2String(request.getParameter("createdatestart"));//创建开始日期
		String createdateend = Util.null2String(request.getParameter("createdateend"));//创建结束日期
		String setting = Util.null2String(request.getParameter("setting"));//模块设置中选择的文档目录
		String workflowid = Util.null2String(request.getParameter("workflowid"));//查询页面中选择的文档目录
		int module = Util.getIntValue(request.getParameter("module"),0);
		List conditions = new ArrayList();
		if(!docsubject.equals("")) {//标题
			conditions.add(" docsubject like '%" + docsubject + "%'");
		}
		if (createid > 0) {//创建人
		    conditions.add(" doccreaterid=" + createid );
		}
		if (!"".equals(createdatestart)) {//创建起始日期
		    conditions.add(" doccreatedate>='" + createdatestart + "' ");
		}
		if (!"".equals(createdateend)) {//创建结束日期
		    conditions.add(" doccreatedate<='" + createdateend + "' ");
		}
		if(!setting.equals("")){
			String where =ds.getWheresBySettings(setting);
			if(where!=null&&!where.trim().equals("")){
				conditions.add(where);
			}
		}
		if (!"".equals(workflowid)) {//查询页面选择的文档目录
		    conditions.add(" seccategory in (" + workflowid + ")");
		}
		
		Map docMap =  ds.getDocumentList(conditions, pageIndex,pageSize,user);
		List<Map<String,Object>> list = (List<Map<String,Object>>) docMap.get("list");
		JSONArray js = new JSONArray();
		if(null!=list&&list.size()>0){
			for(Map<String,Object> d:list){
				JSONObject newdata = new JSONObject();
				String time = Util.null2String((String) d.get("modifytime"),"");
				String image = Util.null2String((String) d.get("docimg"),"");
				String id = Util.null2String((String) d.get("docid"),"");
				String isnew = Util.null2String((String) d.get("isnew"),"");
				String subject = Util.null2String((String) d.get("docsubject"),"");
				String description = Util.null2String((String) d.get("owner"),"")+" "+Util.null2String((String)d.get("createtime"),"");
				newdata.put("time", time);
				newdata.put("image", image);
				newdata.put("id", id);
				newdata.put("isnew", isnew);
				newdata.put("subject", subject);
				newdata.put("description", description);
				js.add(newdata);
			}
		}
		json.put("pageindex", pageIndex);
		json.put("pagesize", pageSize);
		json.put("ishavepre", docMap.get("ishavepre"));
		json.put("ishavenext", docMap.get("ishavenext"));
		json.put("count", docMap.get("count"));
		json.put("pagecount", docMap.get("pagecount"));
		json.put("list", js);
	}catch(Exception e){
		e.printStackTrace();
		msg = e.getMessage();
	}
}
json.put("error", msg);
//System.out.println(json.toString());
out.print(json.toString());
%>