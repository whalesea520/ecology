<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String cmd = Util.null2String(request.getParameter("cmd"));
	String id = Util.null2String(request.getParameter("id"));
	//String companyname = Util.fromScreen(request.getParameter("companyname"),user.getLanguage());
	//String companydesc = Util.fromScreen(request.getParameter("companydesc"),user.getLanguage());
	String virtualtype = Util.fromScreen(request.getParameter("virtualtype"),user.getLanguage());
	String virtualtypedesc = Util.fromScreen(request.getParameter("virtualtypedesc"),user.getLanguage());
	String companyname = virtualtype;
	String companydesc = virtualtype;
	int showorder = Util.getIntValue(request.getParameter("showorder"),0);
	String sql = "";
	
	if(cmd.equals("edit")){
		sql = " update HrmCompanyVirtual set companyname='"+companyname+"', companydesc='"+companydesc+"',"+
					" virtualtype='"+virtualtype+"', virtualtypedesc='"+virtualtypedesc+"', showorder='"+showorder+"' "+
					" where id = "+id;
		rs.executeSql(sql);
		
	  SysMaintenanceLog.resetParameter();
	  SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	  SysMaintenanceLog.setRelatedName(companyname);
	  SysMaintenanceLog.setOperateType("2");
	  SysMaintenanceLog.setOperateDesc(sql);
	  SysMaintenanceLog.setOperateItem("412");
	  SysMaintenanceLog.setOperateUserid(user.getUID());
	  SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	  SysMaintenanceLog.setSysLogInfo();
		CompanyVirtualComInfo.removeCompanyCache();
	 	response.sendRedirect("HrmCompanyEdit.jsp?isclose=1&id="+id);
	}else	if(cmd.equals("save")){
		sql = " insert into HrmCompanyVirtual (companyname, companydesc, virtualtype,virtualtypedesc, showorder)"+
					" values('"+companyname+"','"+companydesc+"','"+virtualtype+"','"+virtualtypedesc+"',"+showorder+")";
		rs.executeSql(sql);
	  
		sql="select min(id) as id from HrmCompanyVirtual ";
		rs.executeSql(sql);
		if(rs.next()){
			id=rs.getString("id");
		}
		
		SysMaintenanceLog.resetParameter();
	  SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	  SysMaintenanceLog.setRelatedName(companyname);
	  SysMaintenanceLog.setOperateType("1");
	  SysMaintenanceLog.setOperateDesc(sql);
	  SysMaintenanceLog.setOperateItem("412");
	  SysMaintenanceLog.setOperateUserid(user.getUID());
	  SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	  SysMaintenanceLog.setSysLogInfo();
		CompanyVirtualComInfo.removeCompanyCache();
	 	response.sendRedirect("HrmCompanyAdd.jsp?isclose=1&id="+id);
	}else if(cmd.equals("del")){
		sql = " select companyname from HrmCompanyVirtual where id = "+id;
		rs.executeSql(sql);
		if(rs.next()){
			companyname = rs.getString("companyname");
		}
		
		sql = " delete from HrmCompanyVirtual where id = "+id;
		rs.executeSql(sql);
		
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
		SysMaintenanceLog.setRelatedName(companyname);
		SysMaintenanceLog.setOperateType("3");
		SysMaintenanceLog.setOperateDesc(sql);
		SysMaintenanceLog.setOperateItem("412");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
		CompanyVirtualComInfo.removeCompanyCache();
		response.sendRedirect("HrmCompanyDsp.jsp?cmd=del");
	}

%>