
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">	
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>

<%
	String imagefilename = "";
	String titlename = SystemEnv.getHtmlLabelName(16539,user.getLanguage());
	String needfav = "1";
	String needhelp = "";
	int isfromrdeploy=Util.getIntValue(request.getParameter("isfromrdeploy"),0);//来自快速部署
	String workid = "" + Util.getIntValue(request.getParameter("workid"),0);
	String add = "" + Util.getIntValue(request.getParameter("add"),0);
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	//AllManagers.getAll(resourceid);
	if("".equals(resourceid)){
		resourceid = ""+user.getUID();
	}
	boolean isSelf		=	false;
	boolean isManager	=	false;
	//RecordSet.executeProc("HrmResource_SelectByID",resourceid);
	//String departmentid = "";
	//if(RecordSet.next()){
	//    departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/
	//}
	//if (resourceid.equals(""+user.getUID()) ){
	//		isSelf = true;
	//	}
	//while(AllManagers.next()){
	//	String tempmanagerid = AllManagers.getManagerID();
	//	if (tempmanagerid.equals(""+user.getUID())) {
	//		isManager = true;
	//	}
	//}
	//if(!((isSelf || isManager || HrmUserVarify.checkUserRight("HrmResource:Plan",user,departmentid))) ){
	//	response.sendRedirect("/notice/noright.jsp") ;
	//}
	
	// added by lupeng 2004-07-07
	String crmId = Util.null2String(request.getParameter("crmid"));
	String docId = Util.null2String(request.getParameter("docid"));
	String exchanged = Util.null2String(request.getParameter("exchanged"));
	// end
	
	if (resourceid.equals(""))
	{
		resourceid = "" + user.getUID();
	}
	
	String srcStr = "";
	if (workid.equals("0"))
	{
		srcStr = "WorkPlanView.jsp?isfromrdeploy="+isfromrdeploy+"&selectUser=" + resourceid +"&exchanged=" + exchanged+"#rushHour";
	}
	else
	{ 
		srcStr = "WorkPlanDetail.jsp?workid=" + workid;
	}
	
	if (add.equals("1"))
	{
		srcStr = "WorkPlanEdit.jsp?from=2&resourceid=" + resourceid + "&crmid=" + crmId + "&docid=" + docId;
	}
%>

<iframe name="workplanLeft" scrolling="no" noresize src="<%=srcStr%>" style="width: 100%;height: 99.5%" frameborder="NO" border="0" framespacing="0"></iframe>

<!--
<FRAMESET cols="*" frameborder="NO" border="0" framespacing="0" rows="*" id="workplan" name="workplan"> 
	<FRAME name="workplanLeft" scrolling="no" noresize src="<%=srcStr%>">
</FRAMESET>

<NOFRAMES>
	<BODY>
		<%//@ include file="/systeminfo/TopTitle.jsp" %>
		<%// response.sendRedirect(srcStr); %>
	</BODY>
</NOFRAMES>
-->
</HTML>