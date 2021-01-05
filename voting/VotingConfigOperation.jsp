
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%

	String doc=Util.null2String(request.getParameter("doc"));
	String flow=Util.null2String(request.getParameter("flow"));
	String customer=Util.null2String(request.getParameter("customer"));
	String project=Util.null2String(request.getParameter("project"));
	String annex=Util.null2String(request.getParameter("annex"));
	String annexcatalogpath=Util.null2String(request.getParameter("annexcatalogpath"));
	String mainid=Util.null2String(request.getParameter("mainid"));
	String subid=Util.null2String(request.getParameter("subid"));
	String seccateid=Util.null2String(request.getParameter("seccateid"));
	String votingid=Util.null2String(request.getParameter("votingid"));
	
	RecordSet.executeSql("update votingconfig set doc='"+doc+"',flow='"+flow+"',customer='"+customer+"',project='"+project+"',annex='"+annex+"',"+
			" annexcatalogpath='"+annexcatalogpath+"', mainid='"+mainid+"', subid='"+subid+"', seccateid='"+seccateid+"' where id=0");

    
   response.sendRedirect("/voting/VotingConfig.jsp");

%>
