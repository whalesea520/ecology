<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="HrmOutInterface" class="weaver.hrm.outinterface.HrmOutInterface" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%
 	String operation = Util.null2String(request.getParameter("operation"));
	String id = Util.null2String(request.getParameter("id"));
	String lastname = Util.null2String(request.getParameter("lastname"));
	String loginid = Util.null2String(request.getParameter("loginid"));
	String mobile = Util.null2String(request.getParameter("mobile"));
	String email = Util.null2String(request.getParameter("email"));
	String seclevel = Util.null2String(request.getParameter("seclevel"));
	if(seclevel.length()==0)seclevel="-10";
	String password = Util.null2String(request.getParameter("password"));
	String password2 = Util.null2String(request.getParameter("password2"));
	String isoutmanager = Util.null2String(request.getParameter("isoutmanager"));
	String wxname = Util.null2String(request.getParameter("wxname"));
	String wxopenid = Util.null2String(request.getParameter("wxopenid"));
	String wxuuid = Util.null2String(request.getParameter("wxuuid"));
	String country = Util.null2String(request.getParameter("country"));
	String province = Util.null2String(request.getParameter("province"));
	String city = Util.null2String(request.getParameter("city"));
	String customid = Util.null2String(request.getParameter("customid"));
	String customfrom = Util.null2String(request.getParameter("customfrom"));

	Map<String,String> params = new HashMap<String,String>();
	Map<String,String> result = new HashMap<String,String>();
	if(operation.equals("add")){
		if(password.length()>0)password = Util.getEncrypt(password);
		params.put("crmid",customid);
		params.put("lastname",lastname);
		params.put("loginid",loginid);
		params.put("password",password);
		params.put("seclevel",seclevel);
		params.put("mobile",mobile);
		params.put("email",email);
		params.put("isoutmanager",isoutmanager);
		params.put("wxname",wxname);
		params.put("wxopenid",wxopenid);
		params.put("wxuuid",wxuuid);
		params.put("country",country);
		params.put("province",province);
		params.put("city",city);
		params.put("customfrom",customfrom);
		HrmOutInterface.createResource4Card(params);
		response.sendRedirect("/hrm/outinterface/outresourceList.jsp?crmid="+customid);
	}else if(operation.equals("edit")){
		if(!password2.equals("aaaaaa"))password = Util.getEncrypt(password);
		params.put("id",id);
		params.put("crmid",customid);
		params.put("lastname",lastname);
		params.put("loginid",loginid);
		params.put("password",password);
		params.put("seclevel",seclevel);
		params.put("mobile",mobile);
		params.put("email",email);
		params.put("isoutmanager",isoutmanager);
		params.put("wxname",wxname);
		params.put("wxopenid",wxopenid);
		params.put("wxuuid",wxuuid);
		params.put("country",country);
		params.put("province",province);
		params.put("city",city);
		params.put("customfrom",customfrom);
		
		HrmOutInterface.updateResourceById4Card(params);
		response.sendRedirect("/hrm/outinterface/outresourceView.jsp?id="+id);
	}else if(operation.equals("delete")){
		HrmOutInterface.delete(id);
		response.sendRedirect("/hrm/outinterface/outresourceList.jsp?id="+id);
	}else if(operation.equals("outresourceAssignSet")){
		String customids = Util.null2String(request.getParameter("customids"));
		String custommanager = Util.null2String(request.getParameter("custommanager"));
		HrmOutInterface.customManagerAssign(customids,custommanager);
		response.sendRedirect("/hrm/outinterface/outresourceAssignSet.jsp?isclose=1");
	}
%>