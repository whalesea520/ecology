<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.templetecheck.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@page import="weaver.general.GCONST"%>
<%
	String attrname = Util.null2String(request.getParameter("attrname"));//属性名
String attrvalue = Util.null2String(request.getParameter("attrvalue"));//属性值
String attrinfo = Util.null2String(request.getParameter("attrinfo"));//注释
String operate = Util.null2String(request.getParameter("operate"));//0 --新增 1--编辑  2--删除
String filepath =  Util.null2String(request.getParameter("filepath"));

//判断是否来自于配置文件信息维护 检测配置
String from = Util.null2String(request.getParameter("from"));
ConfigBakUtil fileBakUtil = new ConfigBakUtil();
PropertiesFileOperation proFileOpera = new PropertiesFileOperation();
if("checkconfig".equals(from)) {
	String detailid = Util.null2String(request.getParameter("detailid"));
	String resultData = proFileOpera.updatePropConfig(detailid,operate);
	out.print(resultData);
	return;
}else{
	PropertiesUtil prop = new PropertiesUtil();
	prop.load(filepath);
	if(attrinfo!=null){
		if(attrinfo.startsWith("#")) {
		} else {
			attrinfo = "".equals(attrinfo) ? "":"#"+attrinfo;
		}
	}

	String attrinfo_temp = attrinfo.equals("")?"":(attrinfo);
	
	if ("0".equals(operate)) {//新增
		prop.put(attrname, attrvalue, attrinfo_temp);
	} else if ("1".equals(operate)) {//编辑
		prop.put(attrname, attrvalue, attrinfo_temp);
	} else {
		String[] namearr = attrname.split(",");
		for (int i = 0; i < namearr.length; i++) {
			prop.remove(namearr[i]);
		}
	}
	
	//保存
	boolean status = prop.store(filepath);
	if (status) {
		out.print("{\"status\":\"ok\"}");
	} else {
		out.print("{\"status\":\"error\"}");
	}
}

%>