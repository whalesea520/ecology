
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageElementCominfo"></jsp:useBean>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />
<%
	String hpid = "";
	String ebaseid = Util.null2String(request.getParameter("ebaseid"));
	String eid = Util.null2String(request.getParameter("eid"));
	if(null==request.getParameter("hpid")){
		hpid = hpc.getHpid(eid);
	}else{
		hpid = Util.null2String(request.getParameter("hpid"));
	}
	
	String wfid = Util.null2String(request.getParameter("wfid"));
	baseBean.writeLog("wfid:"+wfid);
	String from = Util.null2String(request.getParameter("from"));
	String tabid = Util.null2String(request.getParameter("tabid"));
	String subcompanyid = Util.null2String(request.getParameter("subCompanyId"));
	String stype = Util.null2String(request.getParameter("stype"));
	String spagetype = Util.null2String(request.getParameter("spagetype"));
	String saddpage = Util.null2String(request.getParameter("saddpage"));
	baseBean.writeLog("stype:"+stype+";spagetype:"+spagetype+";saddpage:"+saddpage);
	String url = "/synergy/maintenance/SynergyElementSet4ParamFrame.jsp" +
			"?sbaseid=" + hpid + 
			"&ebaseid="+ ebaseid + 
			"&eid=" + eid +
			"&tabid=" + tabid +
			"&from=" + from +
			"&subcompanyid=" + subcompanyid +
			"&stype=" + stype +
			"&spagetype=" + spagetype +
			"&saddpage=" + saddpage+
			"&wfid=" + wfid;
	if(ebaseid.equals("reportForm"))
		url = "/synergy/maintenance/SynergyElementSet4ReportParamFrame.jsp" +
		"?sbaseid=" + hpid + 
		"&ebaseid="+ ebaseid + 
		"&eid=" + eid +
		"&from=" + from +
		"&tabid=" + tabid +
		"&subcompanyid=" + subcompanyid +
		"&stype=" + stype +
		"&spagetype=" + spagetype +
		"&saddpage=" + saddpage +
		"&wfid=" + wfid;
%>

<style type="text/css">
    html{
	   height:100%;
	}
    body{
        margin: 0px;
		height:100%;
		overflow:hidden;
    }

	
</style>

<IFRAME name=sepframe_<%=eid %> id=sepframe_<%=eid %> src="<%=url %>" width="100%" height="100%" frameborder=no scrolling=no>
		<%=SystemEnv.getHtmlLabelName(83722,user.getLanguage()) %></IFRAME>