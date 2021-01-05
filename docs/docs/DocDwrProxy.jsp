
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj,
                 weaver.general.Util" %>
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page" />                 
                 
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
%>
<%
	
	String method = Util.null2String(request.getParameter("method"));
	String paras = Util.null2String(request.getParameter("paras"));
	
	if(method.equals("DocCheckInOutUtil.whetherCanDelete")){
		String paraArray[]=Util.TokenizerString2(paras,",");		
		String msg=DocCheckInOutUtil.whetherCanDeleteNODwr(paraArray[0],paraArray[1],paraArray[2],paraArray[3]);
		out.println(msg);
		return;	
	}
	
	if(method.equals("DocCheckInOutUtil.docCheckIn")){
		DocCheckInOutUtil.setUserbeleons(user);
		String msg=DocCheckInOutUtil.docCheckInNODwr(paras,request);
		out.println(msg);
		return;	
		
	}	
	
%>