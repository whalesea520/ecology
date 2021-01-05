
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RightComInfo" class="weaver.systeminfo.systemright.RightComInfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
String operationtype = Util.null2String(request.getParameter("operationType"));
String roleId = Util.null2String(request.getParameter("id"));
if(operationtype.equals("Delete")){
	String[] ids = request.getParameterValues("ids");
	String[] rightid = request.getParameterValues("rightid");
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
			
			String rightId = "";
			rs.executeSql("select * from systemrightroles where id="+id);
			while(rs.next()){
				rightId = rs.getString("rightid");
			}
			
			rs.execute("SystemRightRoles_Delete",id);
			//CheckUserRight.deleteRoleRightdetail(roleId , rightId) ;
		}
    CheckUserRight.removeRoleRightdetailCache();
	}
	response.sendRedirect("HrmRolesFucRightSet.jsp?id="+roleId);
}
%>