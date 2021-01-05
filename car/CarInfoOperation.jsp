
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CarInfoComInfo" class="weaver.car.CarInfoComInfo" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
String dialog = Util.null2String(request.getParameter("dialog"),"0");

String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
String carNo = Util.fromScreen(request.getParameter("carNo"),user.getLanguage());
String carType = Util.fromScreen(request.getParameter("carType"),user.getLanguage());
String usefee = Util.null2String(request.getParameter("usefee"));
String factoryNo = Util.fromScreen(request.getParameter("factoryNo"),user.getLanguage());
String price = Util.fromScreen(request.getParameter("price"),user.getLanguage());
String buyDate = Util.fromScreen(request.getParameter("buyDate"),user.getLanguage());
String engineNo = Util.fromScreen(request.getParameter("engineNo"),user.getLanguage());
String driver = Util.fromScreen(request.getParameter("driver"),user.getLanguage());
String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());
String subCompanyId = Util.fromScreen(request.getParameter("subCompanyId"),user.getLanguage());
String addtype = Util.null2String(request.getParameter("addtype"));

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;

if(operation.equals("add")){
	String createDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
	String createTime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
	int creater = user.getUID();
	String insertsql = "insert into CarInfo(";
	String valuessql = "values(";
	if(!carNo.equals("")){
		insertsql += "carNo";
		valuessql += "'"+carNo+"'";
	}
	if(!carType.equals("")){
		insertsql += ",carType";
		valuessql += ","+carType+"";
	}
	if(!"".equals(usefee)){
		insertsql += ",usefee";
		valuessql += ","+usefee+"";
	}
	if(!factoryNo.equals("")){
		insertsql += ",factoryNo";
		valuessql += ",'"+factoryNo+"'";
	}
	if(!price.equals("")){
		insertsql += ",price";
		valuessql += ","+price+"";
	}
	if(!buyDate.equals("")){
		insertsql += ",buyDate";
		valuessql += ",'"+buyDate+"'";
	}
	if(!engineNo.equals("")){
		insertsql += ",engineNo";
		valuessql += ",'"+engineNo+"'";
	}
	if(!driver.equals("")){
		insertsql += ",driver";
		valuessql += ","+driver+"";
	}
	if(!remark.equals("")){
		insertsql += ",remark";
		valuessql += ",'"+remark+"'";
	}
	if(!subCompanyId.equals("")){
		insertsql += ",subCompanyId";
		valuessql += ","+subCompanyId+"";
	}
	String sql = insertsql+") "+valuessql+")";
	//System.out.println("sql:"+sql);
	RecordSet.executeSql(sql);
	if (addtype.equals("addAndNew")) {
		response.sendRedirect("/car/CarInfoAdd.jsp?subCompanyId="+subCompanyId+"&dialog="+dialog);
	} else {
		response.sendRedirect("/car/CarInfoAdd.jsp?isclosed=1");
	}
}else if(operation.equals("edit")){
	if(!id.equals("")){
		String sql = "update CarInfo set";
		if(!carNo.equals("")){
			sql += " carNo='"+carNo+"'";
		}
		if(!carType.equals("")){
			sql += ",carType="+carType+"";
		}
		if(!"".equals(usefee)){
			sql += ",usefee="+usefee+"";
		}
		if(!factoryNo.equals("")){
			sql += ",factoryNo='"+factoryNo+"'";
		}

		if(price.equals(""))price="null";
		sql += ",price="+price+"";;
		sql += ",buyDate='"+buyDate+"'";
		sql += ",engineNo='"+engineNo+"'";
		sql += ",driver='"+driver+"'";
		sql += ",remark='"+remark+"'";
		sql += ",subCompanyId='"+subCompanyId+"'";
		sql+= " where id="+id;
		//System.out.println("sql:"+sql);
		RecordSet.executeSql(sql);
	}
	response.sendRedirect("/car/CarInfoEdit.jsp?id="+id+"&isclosed=1");
}else if(operation.equals("del")){
	if(!id.equals("")){
		String sql = "delete from CarInfo where id="+id;
		//System.out.println("sql:"+sql);
		RecordSet.executeSql(sql);
	}
	if (dialog.equals("1")) {
		response.sendRedirect("/car/CarInfoEdit.jsp?id="+id+"&isclosed=1");
		return;
	}
	response.sendRedirect("/car/CarInfoMaintenanceIframe.jsp?subCompanyId="+subCompanyId);
}
%>