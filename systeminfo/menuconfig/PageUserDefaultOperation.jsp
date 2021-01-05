
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>


<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%

	int isshowleftmenu = Util.getIntValue(request.getParameter("isshowleftmenu"),0);
	int isRemember = Util.getIntValue(request.getParameter("isRemeberTab"),0);	
	//System.out.println("isRemember:"+isRemember);

	int userid = user.getUID();
	
	rs.executeSql("select isshowleftmenu from PageUserDefault where userid="+userid);
	String sql = "insert into PageUserDefault (isshowleftmenu,isremembertab,userid) values (?,?,?)"; 
	if(rs.next()){
		sql = "update PageUserDefault set isshowleftmenu=?,isremembertab=? where userid=?";
	}
	rs.executeUpdate(sql,new Object[]{isshowleftmenu,isRemember,userid});
	response.sendRedirect("/systeminfo/menuconfig/MenuMaintenanceManage.jsp");
	
%>	
