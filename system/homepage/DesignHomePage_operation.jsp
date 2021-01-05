<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<% 	
	int userid=user.getUID();
	String ids=Util.null2String(request.getParameter("formfields"));	
	String rqs[] = Util.TokenizerString2(ids,",");
	char separator = Util.getSeparator() ;
	String para = "";
	RecordSet.executeProc("PersonalHPDesign_Update1",""+userid);
	int i = 1 ;
	for(int j=0;j<rqs.length;j++) {		
		para = "" + userid;
		para += separator + "" + Util.getIntValue(rqs[j]); 
		para += separator + "" + i;
		RecordSet.executeProc("PersonalHPDesign_Update2",para);
		i += 1;
	}

	response.sendRedirect("/system/HomePage.jsp");  	
  
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">