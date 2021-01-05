<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CityTwoComInfo" class="weaver.hrm.city.CitytwoComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String cityname = Util.fromScreen(request.getParameter("cityname"),user.getLanguage());
String citylongitude = Util.fromScreen(request.getParameter("citylongitude"),user.getLanguage());
String citylatitude = Util.fromScreen(request.getParameter("citylatitude"),user.getLanguage());
String cityid = Util.fromScreen(request.getParameter("cityid"),user.getLanguage());
if(citylongitude.length()==0){
	citylongitude = "0";
}
if(citylatitude.length()==0){
	citylatitude = "0";
}
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	
     rs.executeSql("select id from HrmCityTwo where cityname='"+cityname+"' and cityid='"+cityid+"'");
     if(rs.next()){
         session.setAttribute("cityname",cityname);
         session.setAttribute("citylongitude",citylongitude);
         session.setAttribute("citylatitude",citylatitude);
         response.sendRedirect("/hrm/area/HrmCityAddTwo.jsp?isdialog=1&msgid=178&cityid="+cityid);
         return;
     }
	String para = cityname + separator + citylongitude + separator + citylatitude + separator + cityid ;
	//System.out.print(para);
	RecordSet.executeProc("HrmCityTwo_Insert",para);
	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
		out.print("id"+id);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(cityname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmCityTwo_Insert,"+para);
      SysMaintenanceLog.setOperateItem("61");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CityTwoComInfo.removeCityCache();
 	response.sendRedirect("HrmCityAddTwo.jsp?isclose=1&cityid="+cityid);
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmCityEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
  	 rs.executeSql("select id from HrmCityTwo where id<>"+id+" and cityname='"+cityname+"' and cityid='"+cityid+"'");
     if(rs.next()){
         session.setAttribute("cityname",cityname);
         session.setAttribute("citylongitude",citylongitude);
         session.setAttribute("citylatitude",citylatitude);
         response.sendRedirect("/hrm/area/HrmCityEditTwo.jsp?isdialog=1&msgid=178&cityid="+cityid+"&id="+id);
         return;
     }
	String para = ""+id + separator + cityname + separator + citylongitude + separator + citylatitude + separator + cityid  ;
	RecordSet.executeProc("HrmCityTwo_Update",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(cityname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmCityTwo_Update,"+para);
      SysMaintenanceLog.setOperateItem("61");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		CityTwoComInfo.removeCityCache();
 	response.sendRedirect("HrmCityEditTwo.jsp?isclose=1&cityid="+cityid);
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmCityEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	RecordSet.executeProc("HrmCitytwo_Delete",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(cityname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmCity_Delete,"+para);
      SysMaintenanceLog.setOperateItem("61");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CityTwoComInfo.removeCityCache();
 	response.sendRedirect("HrmCityTwo.jsp?cityid="+cityid);
 }
%>