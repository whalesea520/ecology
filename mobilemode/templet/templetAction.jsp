<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.data.types.FormModelType"%>
<%@page import="weaver.servicefiles.DataSourceXML"%>
<%@page import="com.weaver.formmodel.mobile.mec.model.FormData"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>

<%@page import="weaver.file.FileUpload"%>
<%@page import="com.weaver.formmodel.mobile.utils.MobileUpload"%>

<%@page import="com.weaver.formmodel.mobile.utils.MobileCommonUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.weaver.formmodel.mobile.MobileFileUpload"%>

<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="weaver.formmode.dao.ModelInfoDao"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="weaver.general.Util"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.formmode.setup.CodeBuild"%>
<%@page import="weaver.formmode.setup.ModeRightInfo"%>
<%@page import="weaver.conn.RecordSet"%>

<%
//此模版为：移动建模表单控件服务端业务处理的页面，仅供参考。
FileUpload fileUpload = new MobileFileUpload(request,"UTF-8",false);
MobileUpload mobileUpload = new MobileUpload(request);
out.clear();
String action=StringHelper.null2String(fileUpload.getParameter("action"));//需要在表单控件提交URL中传递action的值
if("savedata".equalsIgnoreCase(action)||StringHelper.isEmpty(action)){
	JSONObject result = new JSONObject();
	try{
		String datasource = StringHelper.null2String(fileUpload.getParameter("datasource"));//数据源名称
		String tablename = StringHelper.null2String(fileUpload.getParameter("tablename"));//表名
		String keyname = StringHelper.null2String(fileUpload.getParameter("keyname"));//主键字段
		String actiontype = StringHelper.null2String(fileUpload.getParameter("actiontype"));
		boolean isCreate = actiontype.equals("0");//是否新建 
		String billid = StringHelper.null2String(fileUpload.getParameter("billid"));
		
		int status = 0;//  状态码：  0:失败     1:成功
		String errMsg = "您的请求未被服务端处理";
		
		//***********自定义业务逻辑代码区域，仅供参考***********
		
		/*
		String title = StringHelper.null2String(fileUpload.getParameter("fieldname_title"));//获取title字段的值
		RecordSet rs = new RecordSet();
		String sql = "insert into  "+tablename+"(字段名1,字段名2...)  values(字段值1,字段值2...)";
		boolean flag = rs.executeSql(sql);
		if(flag){
			status = 1;//业务执行成功，必须把此状态改为1
			errMsg = "";
		}else{
			status = 0;//失败
			errMsg = "sql语句出现错误";//错误信息
		}
		*/
		
		//***********自定义业务逻辑代码区域，仅供参考***********
		
		result.put("status", status);//必须返回状态码
		if(status==0){//执行失败时，必须同时返回对应的错误信息
			errMsg = URLEncoder.encode(errMsg, "UTF-8");
			errMsg = errMsg.replaceAll("\\+","%20");
			result.put("errMsg", errMsg);
		}
	}catch(Exception ex){
		ex.printStackTrace();
		result.put("status", "0");//失败
		String errMsg = Util.null2String(ex.getMessage());//错误信息
		errMsg = URLEncoder.encode(errMsg, "UTF-8");
		errMsg = errMsg.replaceAll("\\+","%20");
		result.put("errMsg", errMsg);
	}
	
	result.put("fbuttonId", fileUpload.getParameter("fbuttonId"));// 提交按钮id
	out.print("<script type=\"text/javascript\">parent.Mobile_NS.formResponse("+result.toString()+");</script>");
}

out.flush();
out.close();
%>