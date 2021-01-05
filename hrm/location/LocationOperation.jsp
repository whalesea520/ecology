<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String locationname = Util.fromScreen(request.getParameter("locationname"),user.getLanguage());
String locationdesc = Util.fromScreen(request.getParameter("locationdesc"),user.getLanguage());
String address1 = Util.fromScreen(request.getParameter("address1"),user.getLanguage());
String address2 = Util.fromScreen(request.getParameter("address2"),user.getLanguage());
String locationcity = Util.fromScreen(request.getParameter("cityid"),user.getLanguage());
String postcode = Util.fromScreen(request.getParameter("postcode"),user.getLanguage());
String countryid = Util.fromScreen(request.getParameter("countryid"),user.getLanguage());
String telephone = Util.fromScreen(request.getParameter("telephone"),user.getLanguage());
String fax = Util.fromScreen(request.getParameter("fax"),user.getLanguage());
double showOrder = Util.getDoubleValue(request.getParameter("showOrder"),0);


if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("HrmLocationsAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;

//	String para = locationname + separator + locationdesc + separator +
//		address1 + separator + address2 + separator +
//		locationcity + separator + postcode + separator +
//		countryid + separator + telephone + separator +
//		fax;
	String para = locationname + separator + locationdesc + separator +
		address1 + separator + address2 + separator +
		locationcity + separator + postcode + separator +
		countryid + separator + telephone + separator +
		fax + separator +showOrder;
	RecordSet.executeProc("HrmLocations_Insert",para);
	int id=0;
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
		out.print("id"+id);
	}
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(locationname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmLocations_Insert,"+para);
      SysMaintenanceLog.setOperateItem("23");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	LocationComInfo.removeLocationCache();
 	response.sendRedirect("HrmLocationAdd.jsp?isclose=1");
 }

else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("HrmLocationsEdit: Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
//	String para = ""+id + separator + locationname + separator + locationdesc + separator +
//		address1 + separator + address2 + separator +
//		locationcity + separator + postcode + separator +
//		countryid + separator + telephone + separator +
//		fax;
	String para = ""+id + separator + locationname + separator + locationdesc + separator +
		address1 + separator + address2 + separator +
		locationcity + separator + postcode + separator +
		countryid + separator + telephone + separator +
		fax + separator + showOrder;
	RecordSet.executeProc("HrmLocations_Update",para);

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(locationname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmLocations_Update,"+para);
      SysMaintenanceLog.setOperateItem("23");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

		LocationComInfo.removeLocationCache();
 	    response.sendRedirect("HrmLocationEdit.jsp?isclose=1&id="+id);
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("HrmLocationsEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
     char separator = Util.getSeparator() ;
  	int id = Util.getIntValue(request.getParameter("id"));
	String lName = "";
	RecordSet.executeSql("select locationname from HrmLocations where id = "+id);
	if(RecordSet.next()){
		lName = Util.null2String(RecordSet.getString("locationname"));
	}
	String para = ""+id;
	RecordSet.executeProc("HrmLocations_Delete",para);
	//td1519,xiaofeng
	int flag=RecordSet.getFlag();
	
        if(flag==2){
        response.sendRedirect("/hrm/location/HrmLocationEdit.jsp?id="+id+"&msgid=42");
        return;
        }
	

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(lName);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmLocations_Delete,"+para);
      SysMaintenanceLog.setOperateItem("23");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	LocationComInfo.removeLocationCache();
 	response.sendRedirect("HrmLocation.jsp");
 }
%>
