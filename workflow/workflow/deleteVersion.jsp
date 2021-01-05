
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="WFMainManager" class="weaver.workflow.workflow.WFMainManager" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<%
	String wfid = Util.null2String(request.getParameter("dwfid"));
	String ajax=Util.null2String(request.getParameter("dajax"));
	String activeWfid = WorkflowVersion.getActiveVersionWFID(wfid);
	//删除工作流日志
	if (!"".equals(wfid)) {
		WorkflowVersion.deleteVersion(wfid, user.getUID(), request.getRemoteAddr());
	} else {
		activeWfid = wfid;
	}
	
	if(!ajax.equals("1")){
    response.sendRedirect("/workflow/workflow/managewf.jsp");
    }else{
        %> 
        <script type="text/javascript">
        	window.parent.location='/workflow/workflow/addwf.jsp?src=editwf&wfid=<%=activeWfid%>&isTemplate=0';
        </script>
        <%
    //response.sendRedirect("/workflow/workflow/addwf.jsp?src=editwf&wfid=" + activeWfid + "&isTemplate=0");
    }
%>
