
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUploadToPath" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SynOrganization" class="weaver.hrm.synorg.SynOrganization" scope="page"/>

<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<%
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

    FileUploadToPath fu = new FileUploadToPath(request) ;
    String msg=SynOrganization.ImportData(fu,user);
    String flag = System.currentTimeMillis() + "_DataBatchImport";
    session.setAttribute(flag,msg);
    
    try{
	    CompanyComInfo.removeCompanyCache();
	    SubCompanyComInfo.removeCompanyCache();
	    DepartmentComInfo.removeCompanyCache();
	    ResourceComInfo.removeResourceCache();
	    JobTitlesComInfo.removeJobTitlesCache();
	    RolesComInfo.removeRolesCache();
    }catch(Exception e){
    	e.printStackTrace();
    }
    
	response.sendRedirect("/hrm/synorg/SynOrganization.jsp?flag="+flag);
%>