
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-24 [E7 to E8] -->
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<%
	String operationType=request.getParameter("operationType");
	int groupID=Util.getIntValue(request.getParameter("groupID"),0);
	char separator = Util.getSeparator() ;
	if(operationType.equals("save") || operationType.equals("next")){
		String mark=Util.fromScreen(request.getParameter("mark"),user.getLanguage());
		String description=Util.fromScreen(request.getParameter("description"),user.getLanguage());
		String notes=Util.fromScreen(request.getParameter("notes"),user.getLanguage());
		
		String sql = "select count(id) as result from SystemRightGroups where rightgroupname = '"+description+"'";
		rs.executeSql(sql);
		boolean hasRecord = false;
		if(rs.next()){
			hasRecord = rs.getInt("result") > 0;
		}
		if(hasRecord){
			out.println("<script>");
			out.println("window.top.Dialog.alert('"+SystemEnv.getHtmlLabelName(17567,user.getLanguage())+"');");
			out.println("parent.location = '/hrm/HrmDialogTab.jsp?_fromURL=systemRightGroup&method=add';");
			out.println("</script>");
		}else{
			String para=mark+separator+description+separator+notes;
			rs.execute("SystemRightGroups_Insert",para);
			rs.next();
			groupID = rs.getInt(1);
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(groupID);
			SysMaintenanceLog.setRelatedName(description);
			SysMaintenanceLog.setOperateType("1");
			SysMaintenanceLog.setOperateDesc("SystemRightGroups_Insert,"+para);
			SysMaintenanceLog.setOperateItem("28");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
			response.sendRedirect("SystemRightGroupAdd.jsp?groupID="+groupID+"&isclose="+(operationType.equals("next") ? 2 : 1)); 
		}
	}else if(operationType.equals("edit")){
		String mark=Util.fromScreen(request.getParameter("mark"),user.getLanguage());
		String description=Util.fromScreen(request.getParameter("description"),user.getLanguage());
		String notes=Util.fromScreen(request.getParameter("notes"),user.getLanguage());
		
		String sql = "select count(id) as result from SystemRightGroups where id != "+groupID+" and rightgroupname = '"+description+"'";
		rs.executeSql(sql);
		boolean hasRecord = false;
		if(rs.next()){
			hasRecord = rs.getInt("result") > 0;
		}
		if(hasRecord){
			out.println("<script>");
			out.println("alert('"+SystemEnv.getHtmlLabelName(17567,user.getLanguage())+"');");
			out.println("parent.location = '/hrm/HrmDialogTab.jsp?_fromURL=systemRightGroup&method=edit&id="+groupID+"';");
			out.println("</script>");
		}else{
			String para=groupID+""+separator+mark+separator+description+separator+notes;
			rs.execute("SystemRightGroup_Update",para);
			
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(groupID);
			SysMaintenanceLog.setRelatedName(description);
			SysMaintenanceLog.setOperateType("2");
			SysMaintenanceLog.setOperateDesc("SystemRightGroup_Update,"+para);
			SysMaintenanceLog.setOperateItem("28");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
			response.sendRedirect("SystemRightGroupEdit.jsp?isclose=1");
		}
	}else if(operationType.equals("delete")){
		rs.execute("SystemRightGroup_Delete",""+groupID);
		rs.next();
		String description=rs.getString(1);

		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(groupID);
		SysMaintenanceLog.setRelatedName(description);
		SysMaintenanceLog.setOperateType("3");
		SysMaintenanceLog.setOperateDesc("SystemRightGroup_Delete,"+groupID);
		SysMaintenanceLog.setOperateItem("28");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
		response.sendRedirect("SystemRightGroup.jsp");
	}else if(operationType.equals("deleteright")){
		String rightid=request.getParameter("rightid");
		String para= ""+groupID+separator+rightid ;
		rs.execute("SystemRightToGroup_Delete",para);
		response.sendRedirect("SystemRightAuthority.jsp?isdialog=1&id="+groupID);
	}else if(operationType.equals("addright")){
		String rightid=request.getParameter("rightid");
		String[] rIds = rightid.split(",");
		for(String rId : rIds){
			String para=""+groupID+separator+rId;
			rs.execute("SystemRightToGroup_Insert",para);	
		}
		response.sendRedirect("SystemRightAuthority.jsp?isdialog=1&id="+groupID);
	}else if(operationType.equals("addrightroles")){
		String rightid=request.getParameter("rightid");
		String roleid=request.getParameter("roleid"); 
		String rolelevel=request.getParameter("rolelevel");
		String para=rightid+separator+roleid+separator+rolelevel;
		rs.execute("SystemRightRoles_Insert",para);
		//CheckUserRight.updateRoleRightdetail(roleid , rightid , rolelevel) ;
		CheckUserRight.removeRoleRightdetailCache();
		response.sendRedirect("SystemRightRolesAdd.jsp?isclose=1&id="+rightid+"&groupID="+groupID);
	}else if(operationType.equals("editrightroles")){
		String id=request.getParameter("id");
		String rightid=request.getParameter("rightid");
		String roleid=request.getParameter("roleid"); 
		String rolelevel=request.getParameter("rolelevel");
		String para=id+separator+rolelevel;
		rs.execute("SystemRightRoles_Update",para);
		//CheckUserRight.updateRoleRightdetail(roleid , rightid , rolelevel) ;
		CheckUserRight.removeRoleRightdetailCache();
		response.sendRedirect("SystemRightRolesEdit.jsp?isclose=1&id="+id+"&groupID="+groupID);
	}else if(operationType.equals("deleterightroles")){
		String id=request.getParameter("id");
		String rightid=request.getParameter("rightid");
		String roleid=request.getParameter("roleid"); 
		rs.execute("SystemRightRoles_Delete",id);
		//CheckUserRight.deleteRoleRightdetail(roleid , rightid) ;
		CheckUserRight.removeRoleRightdetailCache();
		response.sendRedirect("SystemRightRoles.jsp?id="+rightid+"&groupID="+groupID);
	}
%>