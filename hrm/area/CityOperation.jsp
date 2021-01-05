<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String cityname = Util.fromScreen(request.getParameter("cityname"),user.getLanguage());
String citylongitude = Util.fromScreen(request.getParameter("citylongitude"),user.getLanguage());
if(citylongitude.length()==0){
	citylongitude = "0";
}
String citylatitude = Util.fromScreen(request.getParameter("citylatitude"),user.getLanguage());
if(citylatitude.length()==0){
	citylatitude = "0";
}
String provinceid = Util.fromScreen(request.getParameter("provinceid"),user.getLanguage());
String countryid = Util.fromScreen(request.getParameter("countryid"),user.getLanguage());
if("".equals(countryid)){
	rs.executeSql("select countryid from HrmProvince where id="+provinceid);
	if(rs.next()){
		countryid=rs.getString("countryid");
	}
}
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmCityAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
     rs.executeSql("select id from HrmCity where cityname='"+cityname+"' and countryid='"+countryid+"' and provinceid='"+provinceid+"'");
     if(rs.next()){
         session.setAttribute("cityname",cityname);
         session.setAttribute("citylongitude",citylongitude);
         session.setAttribute("citylatitude",citylatitude);
         response.sendRedirect("/hrm/area/HrmCityAdd.jsp?isdialog=1&msgid=178&provinceid="+provinceid);
         return;
     }
	String para = cityname + separator + citylongitude + separator + citylatitude + separator + provinceid + separator + countryid ;
	RecordSet.executeProc("HrmCity_Insert",para);
	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
		out.print("id"+id);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(cityname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmCity_Insert,"+para);
      SysMaintenanceLog.setOperateItem("61");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CityComInfo.removeCityCache();
 	response.sendRedirect("HrmCityAdd.jsp?isclose=1");
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmCityEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
  	int id = Util.getIntValue(request.getParameter("id"));
	rs.executeSql("select id from HrmCity where id<>"+id+" and cityname='"+cityname+"' and countryid='"+countryid+"' and provinceid='"+provinceid+"'");
    if(rs.next()){
        session.setAttribute("cityname",cityname);
        response.sendRedirect("/hrm/area/HrmCityEdit.jsp?isdialog=1&msgid=178&provinceid="+provinceid+"&id="+id);
        return;
    }
     char separator = Util.getSeparator() ;
	String para = ""+id + separator + cityname + separator + citylongitude + separator + citylatitude + separator + provinceid + separator + countryid ;
	RecordSet.executeProc("HrmCity_Update",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(cityname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmCity_Update,"+para);
      SysMaintenanceLog.setOperateItem("61");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		CityComInfo.removeCityCache();
 	response.sendRedirect("HrmCityEdit.jsp?isclose=1");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmCityEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	cityname = CityComInfo.getCityname(String.valueOf(id));
	String para = ""+id;
	RecordSet.executeProc("HrmCity_Delete",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(cityname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmCity_Delete,"+para);
      SysMaintenanceLog.setOperateItem("61");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CityComInfo.removeCityCache();
 	response.sendRedirect("HrmCity.jsp");
 }
%>