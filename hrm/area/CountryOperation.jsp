<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String getcountryname = Util.fromScreen(request.getParameter("countryname"),user.getLanguage()).trim();
String getcountrydesc = Util.fromScreen(request.getParameter("countrydesc"),user.getLanguage()).trim();
String countryname=Util.toHtmltextarea(getcountryname);
String countrydesc=Util.toHtmltextarea(getcountrydesc);
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmCountriesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	
    rs.executeSql("select id from HrmCountry where countryname='"+countryname+"'");
    if(rs.next()){
        session.setAttribute("countryname",countryname);
        session.setAttribute("countrydesc",countrydesc);
        response.sendRedirect("/hrm/area/HrmCountriesAdd.jsp?isdialog=1&msgid=178");
        return;
    }
    rs.executeSql("select id from HrmCountry where countrydesc='"+countrydesc+"'");
    if(rs.next()){
        session.setAttribute("countryname",countryname);
        session.setAttribute("countrydesc",countrydesc);
        response.sendRedirect("/hrm/area/HrmCountriesAdd.jsp?isdialog=1&msgid=179");
        return;
    }
     
	String para = countryname + separator + countrydesc;
	RecordSet.executeProc("HrmCountry_Insert",para);
	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
		out.print("id"+id);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(countryname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmCountry_Insert,"+para);
      SysMaintenanceLog.setOperateItem("22");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CountryComInfo.removeCountryCache();
 	response.sendRedirect("/hrm/area/HrmCountriesAdd.jsp?isclose=1");
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmCountriesEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
  	
  	rs.executeSql("select id from HrmCountry where id<>"+id+" and countryname='"+countryname+"'");
    if(rs.next()){
        session.setAttribute("countryname",countryname);
        session.setAttribute("countrydesc",countrydesc);
        response.sendRedirect("/hrm/area/HrmCountriesEdit.jsp?isdialog=1&msgid=178&id="+id);
        return;
    }
    rs.executeSql("select id from HrmCountry where id<>"+id+" and countrydesc='"+countrydesc+"'");
    if(rs.next()){
        session.setAttribute("countryname",countryname);
        session.setAttribute("countrydesc",countrydesc);
        response.sendRedirect("/hrm/area/HrmCountriesEdit.jsp?isdialog=1&msgid=179&id="+id);
        return;
    }
  	
	String para = ""+id + separator + countryname + separator + countrydesc;
	RecordSet.executeProc("HrmCountry_Update",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(countryname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmCountry_Update,"+para);
      SysMaintenanceLog.setOperateItem("22");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		CountryComInfo.removeCountryCache();
 	response.sendRedirect("/hrm/area/HrmCountriesEdit.jsp?isclose=1");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmCountriesEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;
	RecordSet.executeProc("HrmCountry_Delete",para);
	
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(CountryComInfo.getCountryname(String.valueOf(id)));
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmCountry_Delete,"+para);
      SysMaintenanceLog.setOperateItem("22");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CountryComInfo.removeCountryCache();
 	response.sendRedirect("HrmCountry.jsp");
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">