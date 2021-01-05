<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.fullsearch.LocationUtils"%>
<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "200001");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

int userLanguage = user.getLanguage();
userLanguage = (userLanguage == 0) ? 7:userLanguage;

response.setContentType("application/json;charset=UTF-8");
FileUpload fu = new FileUpload(request);

Map result = new HashMap();
String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String type = Util.null2String(fu.getParameter("type"));
String key="fbe499c6f3d6d39af9fea6ff9971a7c8";
if("geo".equals(type)){//地址转经纬度
	String city = Util.null2String(fu.getParameter("city"));
	String address = Util.null2String(fu.getParameter("address"));
	result=LocationUtils.getGeocoderLatitude(key,city,address);
	if(result.containsKey("count")&&"0".equals(result.get("count"))){
		String currentCity = Util.null2String(fu.getParameter("currentCity"));
		if(!"".equals(currentCity)){
			result=LocationUtils.getGeocoderLatitude(key,currentCity,address);
		}
	}
}else if("regeo".equals(type)){//经纬度转地址
	String lng = Util.null2String(fu.getParameter("lng"));//经度
	String lat = Util.null2String(fu.getParameter("lat"));//维度
	result=LocationUtils.getGeocoderAddress(key,lng,lat);
}else if("getPlaceList".equals(type)){//通过关键字查询地址
	String city = Util.null2String(fu.getParameter("city"));
	String address = Util.null2String(fu.getParameter("address"));
	result=LocationUtils.getPlaceList(key,city,address);
	if(result.containsKey("count")&&"0".equals(result.get("count"))){
		String currentCity = Util.null2String(fu.getParameter("currentCity")); 
		if(!"".equals(currentCity)){
			result=LocationUtils.getPlaceList(key,currentCity,address);
		}
	}
	
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo.toString());
%>