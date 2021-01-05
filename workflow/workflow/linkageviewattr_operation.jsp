
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WfLinkageInfo" class="weaver.workflow.workflow.WfLinkageInfo" scope="page"/>
<%
    int wfid = Util.getIntValue(Util.null2String(request.getParameter("wfid")), 0);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
    if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
    String ajax = Util.null2String(request.getParameter("ajax"));
    int formid = Util.getIntValue(request.getParameter("formid"), 0);
    int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
    WfLinkageInfo.LinkageSave(request,wfid);
    if (!ajax.equals("1"))
        response.sendRedirect("LinkageViewAttr.jsp?wfid=" + wfid + "&formid=" + formid + "&isbill=" + isbill);
    else
        response.sendRedirect("LinkageViewAttr.jsp?ajax=1&wfid=" + wfid + "&formid=" + formid + "&isbill=" + isbill);
    return;
%>