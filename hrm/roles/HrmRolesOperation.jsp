<%@ page import="weaver.general.Util,weaver.conn.RecordSet,java.io.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-27 [E7 to E8] -->
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%
RecordSet rs=new RecordSet();
String operationtype=Util.null2String(request.getParameter("operationType"));
String id=Util.null2String(request.getParameter("id"));
int roleaddin =0;
	if(operationtype.equals("Add") || operationtype.equals("next")){
		if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
		}
		//String idname=Util.convertInput2DB(Util.null2String(request.getParameter("idname")));
		//String description=Util.convertInput2DB(Util.null2String(request.getParameter("description")));
		String idname=Util.fromScreen(Util.null2String(request.getParameter("idname")),user.getLanguage());
		String description=Util.fromScreen(Util.null2String(request.getParameter("description")),user.getLanguage());			
		int docid=Util.getIntValue(request.getParameter("docid"),0);	
        int type=Util.getIntValue(request.getParameter("roletype"),0);	
        String structureid=Util.null2String(request.getParameter("structureid"));
        //角色名称重复判断
        String checkSql = "select count(id) from HrmRoles where  rolesmark ='"+idname+"'";
        RecordSet.executeSql(checkSql);
        if(RecordSet.next()){
            if(RecordSet.getInt(1)>0){
				out.println("<script>");
				out.println("window.top.Dialog.alert('"+SystemEnv.getHtmlLabelName(17567,user.getLanguage())+"');");
				out.println("parent.location = '/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesAdd&isdialog=1';");
				out.println("</script>");
                return;
            }
        }
		char flag=Util.getSeparator();
		String cmd=idname+flag+description+flag+docid+flag+type+flag+structureid;
		rs.execute("HrmRoles_insert_name",cmd);
		if(rs.next()){
			roleaddin =rs.getInt("id");
		}
		
        SysMaintenanceLog.resetParameter();
		
		SysMaintenanceLog.setRelatedId(roleaddin);
		SysMaintenanceLog.setRelatedName(idname);
		SysMaintenanceLog.setOperateType("1");
		SysMaintenanceLog.setOperateDesc("HrmRoles_insert,"+cmd);
		SysMaintenanceLog.setOperateItem("16");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
		RolesComInfo.removeRolesCache();
		response.sendRedirect("HrmRolesAdd.jsp?id="+roleaddin+"&isclose="+(operationtype.equals("next") ? 2 : 1));
	}else if(operationtype.equals("Edit")){
		if(!HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
		}
		//String idname=Util.convertInput2DB3(Util.null2String(request.getParameter("idname")));
		//String description=Util.convertInput2DB3(Util.null2String(request.getParameter("description")));
		String idname=Util.fromScreen(Util.null2String(request.getParameter("idname")),user.getLanguage());
		String description=Util.fromScreen(Util.null2String(request.getParameter("description")),user.getLanguage());			
		int docid=Util.getIntValue(request.getParameter("docid"),0);	
		String oldname= RolesComInfo.getRolesRemark(""+id);
	    int type=Util.getIntValue(request.getParameter("roletype"),0);	
	    int structureid=Util.getIntValue(request.getParameter("structureid"),0);	
    	//角色名称重复判断
        String checkSql = "select count(id) from HrmRoles where id != "+id+" and rolesmark ='"+idname+"'";
        RecordSet.executeSql(checkSql);
        if(RecordSet.next() && RecordSet.getInt(1)>0){
            out.println("<script>");
			out.println("window.top.Dialog.alert('"+SystemEnv.getHtmlLabelName(17567,user.getLanguage())+"');");
			out.println("parent.location = '/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesEdit&isdialog=1&id="+id+"';");
			out.println("</script>");
			return;
        }
		char flag=Util.getSeparator();
		String cmd=id+flag+idname+flag+description+flag+docid+flag+type+flag+structureid;
		rs.execute("HrmRoles_update",cmd);
	
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
		SysMaintenanceLog.setRelatedName(idname);
		SysMaintenanceLog.setOperateType("2");
		SysMaintenanceLog.setOperateDesc("HrmRoles_update,"+cmd);
		SysMaintenanceLog.setOperateItem("16");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
		RolesComInfo.removeRolesCache();

		response.sendRedirect("/hrm/roles/HrmRolesEdit.jsp?isclose=1&id="+id);
		return;
	}else if(operationtype.equals("Delete")){
		if(!HrmUserVarify.checkUserRight("HrmRolesEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
		}
		rs.execute("select id from workflow_groupdetail where type=2 and objid='"+id+"'");
		if(rs.next()){
	    	response.sendRedirect("HrmRolesEdit.jsp?flag="+"12"+"&id="+id);
	    	return;
		}
		rs.execute("select id from HrmGroupShare where sharetype=4 and roleid='"+id+"'");
		if(rs.next()){
	    	response.sendRedirect("HrmRolesEdit.jsp?flag="+"12"+"&id="+id);
	    	return;
		}
		rs.execute("select id from VotingShare where sharetype=4 and roleid='"+id+"'");
		if(rs.next()){
	    	response.sendRedirect("HrmRolesEdit.jsp?flag="+"12"+"&id="+id);
	    	return;
		}
		rs.execute("select id  from OfUserRoleExp where (sharetype=3 and  sharevalue='"+id+"') or  (tosharetype=3 and  tosharevalue=1081) union select id from OfUserRole where (sharetype=3 and  sharevalue=8) or  (tosharetype=3 and  tosharevalue='"+id+"')");
		if(rs.next()){
	    	response.sendRedirect("HrmRolesEdit.jsp?flag="+"12"+"&id="+id);
	    	return;
		}
		rs.execute("select id from WorkPlanShareSet   where sharetype=4 and roleid='"+id+"'");
		if(rs.next()){
	    	response.sendRedirect("HrmRolesEdit.jsp?flag="+"12"+"&id="+id);
	    	return;
		}
		rs.execute("select id from coworkshare  where type=4 and content='"+id+"'");
		if(rs.next()){
	    	response.sendRedirect("HrmRolesEdit.jsp?flag="+"12"+"&id="+id);
	    	return;
		}
		rs.execute("select id from PluginLicenseUser where sharetype=3 and sharevalue='"+id+"'");
		if(rs.next()){
	    	response.sendRedirect("HrmRolesEdit.jsp?flag="+"12"+"&id="+id);
	    	return;
		}
		rs.execute("HrmRoles_deleteSingle",id);
		String _cmd = Util.null2String(request.getParameter("cmd"));
        //String idname = Util.null2String(request.getParameter("idname"));
        //String description = Util.null2String(request.getParameter("description"));
		    String idname=Util.fromScreen(Util.null2String(request.getParameter("idname")),user.getLanguage());
		    String description=Util.fromScreen(Util.null2String(request.getParameter("description")),user.getLanguage());	        
        int type = Util.getIntValue(request.getParameter("roletype"), 0);
        int structureid = Util.getIntValue(request.getParameter("structureid"), 0);
        int docid=Util.getIntValue(request.getParameter("docid"),0);
        char separator=Util.getSeparator();
        SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
        String cmd=id+separator+idname+separator+description+separator+docid+separator+type+separator+structureid;
        SysMaintenanceLog.setRelatedName(idname);
		SysMaintenanceLog.setOperateType("3");
		SysMaintenanceLog.setOperateDesc("HrmRoles_delete,"+cmd);
		SysMaintenanceLog.setOperateItem("16");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
        rs.next();
		int flag=rs.getInt(1);
		if(_cmd.equals("closeDialog")){
			response.sendRedirect("/hrm/roles/HrmRolesEdit.jsp?isclose=1&id="+id);
			return;
		}else if(flag==11){
			response.sendRedirect("HrmRolesEdit.jsp?flag="+flag+"&id="+id);
		}
	%>
		<script>window.parent.opener._table.reLoad(); 
	            window.parent.open('','_self');
				window.parent.close();</script>
	<%
		RolesComInfo.removeRolesCache();
	}
%>