<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){
		response.sendRedirect("/workrelate/goal/util/Message.jsp");
		return;
	}

	String sql = "";
	String operation = Util.null2String(request.getParameter("operation")); 
	String goalmaint = Util.null2String(request.getParameter("goalmaint"));  
	if(!goalmaint.equals("") && !goalmaint.startsWith(",")) goalmaint = "," + goalmaint;
	if(!goalmaint.equals("") && !goalmaint.endsWith(",")) goalmaint = goalmaint + ",";
	String isself = Util.getIntValue(request.getParameter("isself"),0)+"";         
	String iscgoal = Util.getIntValue(request.getParameter("iscgoal"),0)+""; 
	String docsecid = Util.null2String(request.getParameter("docsecid"));
	if("".equals(docsecid)){
		docsecid = "0";
	}
	//保存
	if(operation.equals("save")){
		rs.executeSql("delete from GM_BaseSetting");
		sql = "insert into GM_BaseSetting(goalmaint,iscgoal,isself,docsecid)"
			+" values "
			+"('"+goalmaint+"',"+iscgoal+","+isself+","+docsecid+")";
		rs.executeSql(sql);
	}
	
	
	response.sendRedirect("BaseSetting.jsp");
%>
