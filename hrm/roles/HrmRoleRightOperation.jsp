
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page" />

<%
	/**get parameter*/
	String operationType = request.getParameter("operationType");
	String roleId = request.getParameter("roleId");
	String rightId = request.getParameter("rightId");

	/**separator for sql procedure param*/
	char separator = Util.getSeparator();
	
	if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp");
		return  ;
	}

	if(operationType.equals("addRoleRight")){
		String roleLevel = request.getParameter("roleLevel");
        int rightcount = Util.getIntValue(request.getParameter("rightcount"),0);
		
        for(int i=0; i<rightcount; i++){
            String ischecked=request.getParameter("chk_"+i);
            if(ischecked!=null && ischecked.equals("1")){
                String rightid_tmp=request.getParameter("rightid_"+i);
				String rightname_tmp=request.getParameter("rightname_"+i);

                //rs.execute("SystemRightRoles_Delete",rightid_tmp);
                String para=rightid_tmp+separator+roleId+separator+roleLevel;
                rs.execute("SystemRightRoles_Insert",para);

                SysMaintenanceLog.resetParameter();
                SysMaintenanceLog.setRelatedId(Util.getIntValue(roleId));
                SysMaintenanceLog.setRelatedName(RolesComInfo.getRolesRemark(roleId)+":"+rightname_tmp);
                SysMaintenanceLog.setOperateType("1");
                SysMaintenanceLog.setOperateDesc("SystemRightRoles_Insert,"+para);
                SysMaintenanceLog.setOperateItem("102");
                SysMaintenanceLog.setOperateUserid(user.getUID());
                SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
                SysMaintenanceLog.setSysLogInfo();

                //CheckUserRight.updateRoleRightdetail(roleId , rightid_tmp , roleLevel) ;
            }
        }
        CheckUserRight.removeMemberRoleCache();
        CheckUserRight.removeRoleRightdetailCache();


        response.sendRedirect("HrmRolesAdd.jsp?isclose=1&id="+roleId);
	}else if(operationType.equals("editRoleRight")){
		
		String id=request.getParameter("id");//roleRightId in table systemrightroles;
		String roleLevel = request.getParameter("roleLevel");

		String para=id+separator+roleLevel;
		rs.execute("SystemRightRoles_Update",para);

		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(roleId));
		SysMaintenanceLog.setRelatedName(RolesComInfo.getRolesRemark(roleId));
		SysMaintenanceLog.setOperateType("2");
		SysMaintenanceLog.setOperateDesc("SystemRightRoles_Update,"+para);
		SysMaintenanceLog.setOperateItem("16");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();

		//CheckUserRight.updateRoleRightdetail(roleId , rightId , roleLevel) ;
		CheckUserRight.removeMemberRoleCache();
        CheckUserRight.removeRoleRightdetailCache();
		response.sendRedirect("HrmRolesEdit.jsp?isclose=1&id="+roleId);
	}else if(operationType.equals("deleteRoleRight")){
		String cmd = Util.null2String(request.getParameter("cmd"));
		String[] rightid = request.getParameterValues("rightId");
		String[] ids = null;
		if(cmd.equals("selectId")){
			ids = new String[1];
			rs.executeSql("select id from systemrightroles where roleid = "+roleId+" and rightid = "+rightid[0]);
			if(rs.next()){
				ids[0] = Util.null2String(rs.getString("id"));
			}
		}else{
			ids = request.getParameterValues("id");
		}
		if(ids!=null){
			for(int i=0;i<ids.length;i++){
				String id = ids[i];//roleRightId in table systemrightroles;
				String rightnameid = rightid[i];
				String rightname_tmp=Util.toScreen(RightComInfo.getRightname(rightnameid,""+user.getLanguage()),user.getLanguage());
				SysMaintenanceLog.resetParameter();
				SysMaintenanceLog.setRelatedId(Util.getIntValue(roleId));
				SysMaintenanceLog.setRelatedName(RolesComInfo.getRolesRemark(roleId)+":"+rightname_tmp);
				SysMaintenanceLog.setOperateType("3");
				SysMaintenanceLog.setOperateDesc("SystemRightRoles_Delete");
				SysMaintenanceLog.setOperateItem("102");
				SysMaintenanceLog.setOperateUserid(user.getUID());
				SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
				SysMaintenanceLog.setSysLogInfo();
				rs.executeSql("select * from systemrightroles where id="+id); 
				while(rs.next()){
					rightId = rs.getString("rightid");
				}
				rs.execute("SystemRightRoles_Delete",id);
				//CheckUserRight.deleteRoleRightdetail(roleId , rightId) ;
			}
      CheckUserRight.removeRoleRightdetailCache();
		}
		response.sendRedirect("HrmRolesEdit.jsp?isclose=1&id="+roleId);
	}


%>