
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CarTypeComInfo" class="weaver.car.CarTypeComInfo" scope="page"/>

<%

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
String usefee = Util.fromScreen(request.getParameter("usefee"),user.getLanguage());
String dialog = Util.null2String(request.getParameter("dialog"),"0");

if(operation.equals("add")){
    char separator = Util.getSeparator() ;
	String para = name + separator + description + separator + usefee;
	RecordSet.executeProc("CarType_Insert",para); 
	CarTypeComInfo.removeCarTypeCache();
	//response.sendRedirect("/cpt/car/CarTypeEdit.jsp?id="+id+"&dialog="+dialog);
	response.sendRedirect("/cpt/car/CarTypeAdd.jsp?isclosed=1");
	return;
}

else if(operation.equals("addAndNew")){
    char separator = Util.getSeparator() ;
	String para = name + separator + description + separator + usefee;
	RecordSet.executeProc("CarType_Insert",para); 
	CarTypeComInfo.removeCarTypeCache();
	response.sendRedirect("/cpt/car/CarTypeAdd.jsp?dialog="+dialog);
	return;
}
 
else if(operation.equals("edit")){
    char separator = Util.getSeparator() ;
  	String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
	String para = id + separator + name + separator + description + separator + usefee;
	RecordSet.executeProc("CarType_Update",para);
	CarTypeComInfo.removeCarTypeCache(); 
	response.sendRedirect("/cpt/car/CarTypeEdit.jsp?id="+id+"&dialog="+dialog);	
	//response.sendRedirect("/cpt/car/CarTypeEdit.jsp?id="+id+"&isclosed=1");
	return;
}

else if(operation.equals("delete")){
    char separator = Util.getSeparator() ;
  	String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
//    RecordSet.executeSql("select count(*) from CarDriverData where cartypeid ="+id);
//    RecordSet.next();
//    int count=RecordSet.getInt(1);
//    if(count>0){
//        response.sendRedirect("CarTypeEdit.jsp?CanDelete=1&id="+id);
//    }else{
//        String para = id;
//        RecordSet.executeProc("CarType_Delete",para);
//    }
    int count=0;
    RecordSet.executeSql("select count(*) from CarDriverData where cartypeid ="+id);
	if(RecordSet.next()){
		count=RecordSet.getInt(1);
		if(count>0){
			response.sendRedirect("/cpt/car/CarTypeEdit.jsp?CanDelete=1&id="+id+"&dialog="+dialog);
			return ;
		}
	}

    RecordSet.executeSql("select count(1) from CarInfo where carType="+id);
	if(RecordSet.next()){
		count=RecordSet.getInt(1);
		if(count>0){
			response.sendRedirect("/cpt/car/CarTypeEdit.jsp?CanDelete=1&id="+id+"&dialog="+dialog);
			return ;
		}
	}

    String para = id;
    RecordSet.executeProc("CarType_Delete",para);
	CarTypeComInfo.removeCarTypeCache();
	if (dialog.equals("1")) {
		response.sendRedirect("/cpt/car/CarTypeEdit.jsp?id="+id+"&isclosed=1");
		return;
	} 	
}
response.sendRedirect("CarTypeListIframe.jsp");
//if (dialog.equals("1")){
	//out.print("<script>parent.closePrtDlgARfsh();</script>");
//} else {
	//response.sendRedirect("CarTypeListIframe.jsp");
//}
%>
