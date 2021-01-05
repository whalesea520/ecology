<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OrganisationCom" class="weaver.rtx.OrganisationCom" scope="page" />
<%


if(!HrmUserVarify.checkUserRight("HrmCompanyEdit:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");
	return  ;
}


int id = Util.getIntValue(request.getParameter("id"));
String companyname = Util.fromScreen(request.getParameter("companyname"),user.getLanguage());
String companydesc = Util.fromScreen(request.getParameter("companydesc"),user.getLanguage());
String companyweb = Util.fromScreen(request.getParameter("companyweb"),user.getLanguage());

       char separator = Util.getSeparator();

	String para = ""+id + separator + companyname+separator+companydesc+separator+companyweb;
	out.println(para);
	out.println(rs.executeProc("HrmCompany_Update",para));

    //add by wjy
    //同步RTX总部信息
    OrganisationCom.editCompany(id);

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(id);
      SysMaintenanceLog.setRelatedName(companyname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmCompany_Update,"+para);
      SysMaintenanceLog.setOperateItem("10");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	CompanyComInfo.removeCompanyCache();
 	response.sendRedirect("HrmCompanyEdit.jsp?isclose=1");
%>