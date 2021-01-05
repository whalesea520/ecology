
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSetTrans" %>
<%@ page import="weaver.conn.WeaverThreadPool" %>
<%@ page import="java.util.*"%>

<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="Record" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordS" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetDB" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportShare" class="weaver.workflow.report.ReportShare" scope="page"/>
<%
String operationtype=Util.null2String(request.getParameter("operationType"));
String employeeID=Util.null2String(request.getParameter("employeeID"));
String roleID=Util.null2String(request.getParameter("roleID"));
String _level2 = "";

if(roleID.length()==0 || operationtype.equals("Delete")){
	String id=Util.null2String(request.getParameter("id"));
	if(id.length()>0){
		rs.executeSql(" select * from HrmRoleMembers where id= "+id);
		if(rs.next()){
			roleID=Util.null2String(rs.getString("roleid"));
			
			employeeID=Util.null2String(rs.getString("resourceid"));
			_level2=Util.null2String(rs.getString("rolelevel"));
		}
	}
}
String resourcename = ResourceComInfo.getResourcename(employeeID);
String rolename = RolesComInfo.getRolesRemark(roleID) ;

boolean isoracle = (rs.getDBType()).equals("oracle") ;
boolean isdb2 = (rs.getDBType()).equals("db2") ;
char flag=Util.getSeparator();
String para="";
String seclevel="";
String seclevelmax="";

if(operationtype.equals("New")){

if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	ArrayList resourceids = new ArrayList() ;
	String sharetype = Util.null2String(request.getParameter("sharetype"));
	String relatedshareid = Util.null2String(request.getParameter("relatedshareid"));
	if(relatedshareid.startsWith(",")){
		relatedshareid = relatedshareid.substring(1);
	}
	seclevel = Util.null2String(request.getParameter("seclevel"));
	seclevelmax = Util.null2String(request.getParameter("seclevelmax"));
	String rolelevel = Util.null2String(request.getParameter("rolelevel"));
	if(sharetype.equals("1") || sharetype.equals("6") || sharetype.equals("7")){
	    String tmpresourceid = relatedshareid ;
	    List resources=Util.TokenizerString(tmpresourceid,",");
	    for(int i=0;i<resources.size();i++){
	      resourceids.add(resources.get(i));
	    }
	}

   	//modify by zhouquan 
    if(sharetype.equals("3")){
        String tmpdepartmentid = relatedshareid ;
        String tmpsql="select * from Hrmresource where departmentid in ("+tmpdepartmentid +") and (seclevel between "+seclevel + " and "+seclevelmax+") and (status = 0 or status = 1 or status = 2 or status = 3) " ;
        rs.executeSql(tmpsql);
        while(rs.next()){
            String tmpresourceid = rs.getString("id");
            resourceids.add(tmpresourceid);
        }
    }
    if(sharetype.equals("4")){
        String tmproleid = relatedshareid ;
        String tmpsql="select * from HrmRoleMembers where roleid in ("+tmproleid +") and rolelevel >="+rolelevel ;
        rs.executeSql(tmpsql);
        while(rs.next()){
            String tmpresourceid = rs.getString("resourceid");
            resourceids.add(tmpresourceid);
        }
    }
	
    //modify by zhouquan 
    if(sharetype.equals("5")) {
        String tmpsql="select * from hrmresource where (seclevel between "+seclevel + " and "+seclevelmax+") and (status = 0 or status = 1 or status = 2 or status = 3) " ;
        //out.print(tmpsql);
        rs.executeSql(tmpsql);
        while(rs.next()){
            String tmpresourceid = rs.getString("id");
            resourceids.add(tmpresourceid);
        }
    }

    for (int i=0; i<resourceids.size(); i++){
	    String level=Util.null2String(request.getParameter("level"));
	    employeeID=(String)resourceids.get(i);
	    String cmd=employeeID+flag+roleID+flag+level;
        int id= 0 ;
		resourcename = ResourceComInfo.getLastname(employeeID);
		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{
			if(isoracle) rst.executeProc("HrmRoleMembers_Tri_In", cmd);
			if(isdb2) rst.executeProc("HrmRoleMembers_Tri_In", cmd);
			rst.executeProc("HrmRoleMembers_Insert",cmd);

			//System.out.println(cmd+flag+"0"+flag+"0");
			//rst.executeProc("HrmRoleMembersShare",cmd+flag+"0"+flag+"0");
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}

	    if(rs.next()) id = rs.getInt(1);

/*      int id= 1 ;*/
    	SysMaintenanceLog.resetParameter();
    	SysMaintenanceLog.setRelatedId(Util.getIntValue(roleID));
    	SysMaintenanceLog.setRelatedName(rolename+":"+resourcename);
    	SysMaintenanceLog.setOperateType("1");
    	SysMaintenanceLog.setOperateDesc("hrmroles_insertMember,"+cmd);
    	SysMaintenanceLog.setOperateItem("32");
    	SysMaintenanceLog.setOperateUserid(user.getUID());
    	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    	SysMaintenanceLog.setSysLogInfo();

	    //CheckUserRight.updateMemberRole(employeeID , roleID , level) ;
        //ReportShare.setReportShareByHrm(employeeID);
        //CheckUserRight.removeMemberRoleCache();
	    //CheckUserRight.removeRoleRightdetailCache();
     }
    CheckUserRight.removeMemberRoleCache();
    CheckUserRight.removeRoleRightdetailCache();
	 //RecordSetDB.executeProc("URole_workflow_createlist",""+roleID);
	 response.sendRedirect("/hrm/roles/HrmRolesMembersAdd.jsp?isclose=1&roleID="+roleID);
}else if(operationtype.equals("Edit")){
	if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	String id=Util.null2String(request.getParameter("id"));
	String level=Util.null2String(request.getParameter("level"));
    String level2=Util.null2String(request.getParameter("rolelevel2"));

    if(!level.equals(level2)) {
        String cmd=employeeID+flag+roleID+flag+level;

		RecordSetTrans rst=new RecordSetTrans();
		rst.setAutoCommit(false);
		try{
			if(isoracle) rst.execute("HrmRoleMembers_Tri_Up",cmd);
			if(isdb2) rst.execute("HrmRoleMembers_Tri_Up",cmd);
			cmd=id+flag+level ;
			rst.execute("HrmRoleMembers_Update",cmd);

			//System.out.println(employeeID+flag+roleID+flag+level+flag+level2+flag+"1");
			//rst.executeProc("HrmRoleMembersShare",employeeID+flag+roleID+flag+level+flag+level2+flag+"1");
			rst.commit();
		}catch(Exception e){
			rst.rollback();
			e.printStackTrace();
		}

        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(roleID));
        SysMaintenanceLog.setRelatedName(rolename+":"+resourcename);
        SysMaintenanceLog.setOperateType("2");
        SysMaintenanceLog.setOperateDesc("HrmRoleMembers_Update,"+cmd);
        SysMaintenanceLog.setOperateItem("32");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
        //CheckUserRight.updateMemberRole(employeeID , roleID , level) ;
        //ReportShare.setReportShareByHrm(employeeID);
        CheckUserRight.removeMemberRoleCache();
	    CheckUserRight.removeRoleRightdetailCache();
    }
	//RecordSetDB.executeProc("URole_workflow_createlist",""+roleID);
	response.sendRedirect("/hrm/roles/HrmRolesMembersEdit.jsp?isclose=1&id="+roleID);
}else if(operationtype.equals("Delete")){
	if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String id=Util.null2String(request.getParameter("id"));
  
	String cmd=employeeID+flag+roleID ;

	RecordSetTrans rst=new RecordSetTrans();
	rst.setAutoCommit(false);
	try{
		if(isoracle) rst.execute("HrmRoleMembers_Tri_De",cmd);
		if(isdb2) rst.execute("HrmRoleMembers_Tri_De",cmd);
		rst.execute("HrmRoleMembers_Delete",id);
		//rst.executeProc("HrmRoleMembersShare",employeeID+flag+roleID+flag+"0"+flag+_level2+flag+"2");
		rst.commit();
	}catch(Exception e){
		rst.rollback();
		e.printStackTrace();
	}

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(roleID));
	SysMaintenanceLog.setRelatedName(rolename+":"+resourcename);
	SysMaintenanceLog.setOperateType("3");
	SysMaintenanceLog.setOperateDesc("HrmRoleMembers_Delete,"+id);
	SysMaintenanceLog.setOperateItem("32");
	SysMaintenanceLog.setOperateUserid(user.getUID());
	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setSysLogInfo();
	//CheckUserRight.deleteMemberRole(employeeID , roleID) ;
    //ReportShare.setReportShareByHrm(employeeID);
    CheckUserRight.removeMemberRoleCache();
    CheckUserRight.removeRoleRightdetailCache();
	//RecordSetDB.executeProc("URole_workflow_createlist",""+roleID);
	
	String _cmd = Util.null2String(request.getParameter("cmd"));
	if(_cmd.equals("closeDialog")){
		response.sendRedirect("/hrm/roles/HrmRolesMembersEdit.jsp?isclose=1&id="+id);
		return;
	}
	String topagetmp = Util.null2String(request.getParameter("topagetmp"));
	if("hrmsingle".equals(topagetmp)) {
		response.sendRedirect("/hrm/roles/HrmResourceNewRoles.jsp?resourceid="+employeeID);
		return;
	} else {
		response.sendRedirect("HrmRolesMembers.jsp?id="+roleID);
		return;
	}
}else if(operationtype.equals("MutiDelete")){
	if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	String[] ids = request.getParameterValues("ids");
	String[] ids1 = request.getParameterValues("ids1");
	String[] ids2 = request.getParameterValues("ids2");
		int len0 = 0;
		int len1 = 0;
		int len2 = 0;
		int len = 0;
		if(ids != null){
			len = ids.length;
			len0 = ids.length;
		}
		if(ids1 != null){
			len += ids1.length;
			len1 = ids1.length;
		}
		if(ids2 != null){
			len += ids2.length;
			len2 = ids2.length;
		}
		for(int i=0; i<len; i++){
			int id = 0;
			try{
				id = Util.getIntValue(ids[i],0);
			}catch(Exception e){
				try{
					id = Util.getIntValue(ids1[(i-len0)],0);
				}catch(Exception e1){
					try{
						id = Util.getIntValue(ids2[(i-len0-len1)],0);
					}catch(Exception e2){
					}
				}
			}
			if(id == 0){
				continue;
			}
			rs.execute("HrmRoleMembers_SelectByID",""+id);
			String level2="";
			while(rs.next()){
				employeeID = rs.getString("resourceid");
				roleID = rs.getString("roleid");
				level2 = rs.getString("rolelevel");
			}
	
		    String cmd=employeeID+flag+roleID ;
			resourcename = ResourceComInfo.getLastname(employeeID);
			RecordSetTrans rst=new RecordSetTrans();
			rst.setAutoCommit(false);
			try{

				if(isoracle) rst.execute("HrmRoleMembers_Tri_De",cmd);
				if(isdb2) rst.execute("HrmRoleMembers_Tri_De",cmd);
				rst.execute("HrmRoleMembers_Delete",""+id);

				//System.out.println(employeeID+flag+roleID+flag+"0"+flag+level2+flag+"2");
				//rst.executeProc("HrmRoleMembersShare",employeeID+flag+roleID+flag+"0"+flag+level2+flag+"2");
				rst.commit();
			}catch(Exception e){
				rst.rollback();
				e.printStackTrace();
			}
		
			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(Util.getIntValue(roleID));
			SysMaintenanceLog.setRelatedName(rolename+":"+resourcename);
			SysMaintenanceLog.setOperateType("3");
			SysMaintenanceLog.setOperateDesc("HrmRoleMembers_Delete,"+id);
			SysMaintenanceLog.setOperateItem("32");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
			
			//CheckUserRight.deleteMemberRole(employeeID , roleID) ;
            //ReportShare.setReportShareByHrm(employeeID);
            //CheckUserRight.removeMemberRoleCache();
    	    //CheckUserRight.removeRoleRightdetailCache();
		}
    CheckUserRight.removeMemberRoleCache();
    CheckUserRight.removeRoleRightdetailCache();
	//}
	//RecordSetDB.executeProc("URole_workflow_createlist",""+roleID); 
	response.sendRedirect("HrmRolesMembers.jsp?operationType=MutiDelete&id="+roleID);
} else if("newRoles".equals(operationtype)) {
	if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String rolesid = Util.null2String(request.getParameter("rolesid"));
	ArrayList temprolesid = Util.TokenizerString(rolesid,",");
	String resourceid = Util.null2String(request.getParameter("employeeID"));
    String rolelevel = Util.null2String(request.getParameter("rolelevel"));
    
    if(!"".equals(rolesid)){
	    for (int i=0; i<temprolesid.size(); i++){	    
		    String roleIDss = (String)temprolesid.get(i);		    
		    String cmd = resourceid+flag+roleIDss+flag+rolelevel;
		    RecordSetTrans rst=new RecordSetTrans();
			rst.setAutoCommit(false);
			try{ 					
			    if(isoracle) rst.executeProc("HrmRoleMembers_Tri_In", cmd);
			    rst.executeProc("HrmRoleMembers_Insert",cmd);	
			    //rst.executeProc("HrmRoleMembersShare",cmd+flag+"0"+flag+"0");
			    rst.commit();
				//此处处理角色人员流程创建相关问题
				//RecordSetDB.executeProc("URole_workflow_createlist",""+roleIDss);
			}catch(Exception e){
				e.printStackTrace();
			}
			
			SysMaintenanceLog.resetParameter();
	    	SysMaintenanceLog.setRelatedId(Util.getIntValue(roleIDss));
	    	SysMaintenanceLog.setRelatedName(RolesComInfo.getRolesRemark(roleIDss)+":"+ResourceComInfo.getResourcename(resourceid));
	    	SysMaintenanceLog.setOperateType("1");
	    	SysMaintenanceLog.setOperateDesc("hrmroles_insertMember,"+cmd);
	    	SysMaintenanceLog.setOperateItem("32");
	    	SysMaintenanceLog.setOperateUserid(user.getUID());
	    	SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	    	SysMaintenanceLog.setSysLogInfo();
        }
    }
    CheckUserRight.removeMemberRoleCache();
	CheckUserRight.removeRoleRightdetailCache();
    response.sendRedirect("/hrm/roles/HrmResourceNewRoles.jsp?resourceid="+resourceid);
}else if("allDelete".equals(operationtype)){
	if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String idtmps=Util.null2String(request.getParameter("idtmps"));
	String roleIDtmps=Util.null2String(request.getParameter("roleIDtmps"));
	String rolelevel2tmps=Util.null2String(request.getParameter("rolelevel2tmps"));
	String[] idtmpsarr = idtmps.split("[,]");
	String[] roleIDtmpsarr = roleIDtmps.split("[,]");
	String[] rolelevel2tmpsarr = rolelevel2tmps.split("[,]");
	
	for(int i=0;i<idtmpsarr.length;i++){
		if("".equals(idtmpsarr[i])){
			continue;
		}else{
			String id=Util.null2String(idtmpsarr[i]);
			roleID = Util.null2String(roleIDtmpsarr[i]);
			rolename = RolesComInfo.getRolesRemark(roleID) ;
		    resourcename = ResourceComInfo.getResourcename(employeeID);
		    String cmd=employeeID+flag+roleID ;
			RecordSetTrans rst=new RecordSetTrans();
			rst.setAutoCommit(false);
			try{
				if(isoracle) rst.execute("HrmRoleMembers_Tri_De",cmd);
				if(isdb2) rst.execute("HrmRoleMembers_Tri_De",cmd);
				rst.execute("HrmRoleMembers_Delete",id);
				//String level2=Util.null2String(rolelevel2tmpsarr[i]);
				//System.out.println("idtmpsarr"+i+":"+idtmpsarr[i]);
				//System.out.println("roleIDtmpsarr"+i+":"+roleIDtmpsarr[i]);
				//System.out.println("rolelevel2tmpsarr"+i+":"+rolelevel2tmpsarr[i]);
				//System.out.println(employeeID+flag+roleID+flag+"0"+flag+level2+flag+"2");
				//rst.executeProc("HrmRoleMembersShare",employeeID+flag+roleID+flag+"0"+flag+level2+flag+"2");
				rst.commit();
			}catch(Exception e){
				rst.rollback();
				e.printStackTrace();
			}

			SysMaintenanceLog.resetParameter();
			SysMaintenanceLog.setRelatedId(Util.getIntValue(roleID));
			SysMaintenanceLog.setRelatedName(rolename+":"+resourcename);
			SysMaintenanceLog.setOperateType("3");
			SysMaintenanceLog.setOperateDesc("HrmRoleMembers_Delete,"+id);
			SysMaintenanceLog.setOperateItem("32");
			SysMaintenanceLog.setOperateUserid(user.getUID());
			SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			SysMaintenanceLog.setSysLogInfo();
			//CheckUserRight.deleteMemberRole(employeeID , roleID) ;
		    //ReportShare.setReportShareByHrm(employeeID);
		    //CheckUserRight.removeMemberRoleCache();
		    //CheckUserRight.removeRoleRightdetailCache();
			//RecordSetDB.executeProc("URole_workflow_createlist",""+roleID);
		}
	}
  CheckUserRight.removeMemberRoleCache();
  CheckUserRight.removeRoleRightdetailCache();
	String topagetmp = Util.null2String(request.getParameter("topagetmp"));
	if("hrmsingle".equals(topagetmp)) {
		response.sendRedirect("/hrm/roles/HrmResourceNewRoles.jsp?resourceid="+employeeID);
		return;
	} else {
		response.sendRedirect("HrmRolesMembers.jsp?id="+roleID);
		return;
	}
}
%>
