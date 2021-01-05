<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RdeployHrmSetting" class="weaver.rdeploy.hrm.RdeployHrmSetting" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<%
String id= Util.null2String(request.getParameter("id"));

String adminId = Util.null2String(RdeployHrmSetting.getSettingInfo("admin"));
out.clearBuffer();
//String sqlWhere = "";

String success = "0";
String mobileExist = "0";
if(!"".equals(id)){
    
    RecordSet.executeSql("SELECT id FROM HrmRoles WHERE rolesmark=rolesname AND rolesname='云部署角色'");
    String roleid ="";
	if(RecordSet.next()) {
		roleid = RecordSet.getString("id");
		if(!"".equals(roleid)){
		    String tempSql = "update HrmRoleMembers set resourceid="+id+"   WHERE roleid="+roleid+" AND resourceid="+adminId;
			RecordSet.executeSql(tempSql);
			String tempSql2 = "update rdeployhrmsetting set setvalue = '"+id+"' where setname ='admin'";
			RecordSet.executeSql(tempSql2);
			CheckUserRight.removeMemberRoleCache();
			CheckUserRight.removeRoleRightdetailCache();
			RdeployHrmSetting.changeSettingInfo();
			success ="1";
		}
	}
	
}
out.println("{\"success\":\""+success+"\",\"mobileExist\":\""+mobileExist+"\"}");
%>