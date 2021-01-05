
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.JSONArray"%>
<%@page import="weaver.social.rdeploy.address.AddressHrmOrgTree"%>
<%@page import="java.io.PrintWriter"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%
	String userid =""+user.getUID();
    FileUpload fu = new FileUpload(request);
	String operation=Util.null2String(fu.getParameter("operation"));
	AddressHrmOrgTree hrmOrg=new AddressHrmOrgTree(request,response);
	response.setContentType("application/x-json; charset=UTF-8");
	PrintWriter outPrint = response.getWriter();
	//获取组织下所有成员
	if(operation.equals("getAllPersonList")){		
		String root = Util.null2String(fu.getParameter("root"));
		String target = Util.null2String(fu.getParameter("target"));
		JSONArray ja = null;
		if(target.equals("hrmOrg")){
			ja = hrmOrg.getTreeDataLeafs(root); 
		}else if(target.equals("hrmGroup")){
			ja = hrmOrg.getTreeDataLeafs2(root,user.getUID()+""); 
		}
		outPrint.println(ja);
	}
	
%>