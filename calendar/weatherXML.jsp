
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.general.WeatherObj"%>
<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.general.WeatherData"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat"%>
<%@page import="net.sourceforge.pinyin4j.format.HanyuPinyinToneType"%>
<%@page import="net.sourceforge.pinyin4j.PinyinHelper"%><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
    
<%
	User user = HrmUserVarify.getUser (request , response) ;
	int id=user.getUID();
	String sql="select weatherCity from hrmUserSetting where resourceid='"+id+"'";
	rs.execute(sql);
	String cityName="";
	if(rs.getCounts()!=0){
		rs.next();
		cityName=rs.getString("weatherCity");
	}
	else{
		cityName="";
	}
	if("".equals(cityName.trim())||"null".equals(cityName)){
		cityName="ShangHai";
	}
	WeatherData data=new WeatherData();
	data.getWeahersByCity(cityName, user.getLanguage(), "/images");
	List nxt=data.getNext3days();
	HanyuPinyinOutputFormat outputFormat = new HanyuPinyinOutputFormat();  
	outputFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);  
	String pinyinCondition = PinyinHelper.toHanyuPinyinString(data.getCondition(), outputFormat, "");
%>
{
	"city":"<%=URLEncoder.encode(data.getCity(),"utf-8").replaceAll("\\+","%20").replaceAll("%2F","/") %>",
	"date":"<%=data.getDate() %>",
	"condition":"<%=URLEncoder.encode(data.getCondition(),"utf-8").replaceAll("\\+","%20").replaceAll("%2F","/") %>",
	"low":"<%=data.getLow() %>",
	"high":"<%=data.getHigh() %>",
	"wind":"<%=URLEncoder.encode(data.getWindcondition(),"utf-8").replaceAll("\\+","%20").replaceAll("%2F","/") %>",
	"humidity":"<%=URLEncoder.encode(data.getHumidity(),"utf-8").replaceAll("\\+","%20").replaceAll("%2F","/") %>",
	"icon":"/calendar/icon/<%=pinyinCondition %>_wev8.png",
	"forecast":[
		<%if(nxt.size()==3){ %>
		{"date":"<%=URLEncoder.encode(((WeatherObj)nxt.get(0)).getDay_of_week() ,"utf-8").replaceAll("\\+","%20").replaceAll("%2F","/") %>","low":"<%=((WeatherObj)nxt.get(0)).getLow() %>","high":"<%=((WeatherObj)nxt.get(0)).getHigh() %>","icon":"<%=((WeatherObj)nxt.get(0)).getIcon() %>"},
		{"date":"<%=URLEncoder.encode(((WeatherObj)nxt.get(1)).getDay_of_week() ,"utf-8").replaceAll("\\+","%20").replaceAll("%2F","/") %>","low":"<%=((WeatherObj)nxt.get(1)).getLow() %>","high":"<%=((WeatherObj)nxt.get(1)).getHigh() %>","icon":"<%=((WeatherObj)nxt.get(1)).getIcon() %>"},
		{"date":"<%=URLEncoder.encode(((WeatherObj)nxt.get(2)).getDay_of_week() ,"utf-8").replaceAll("\\+","%20").replaceAll("%2F","/") %>","low":"<%=((WeatherObj)nxt.get(2)).getLow() %>","high":"<%=((WeatherObj)nxt.get(2)).getHigh() %>","icon":"<%=((WeatherObj)nxt.get(2)).getIcon() %>"}
		<%} %>
	]}