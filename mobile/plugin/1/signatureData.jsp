<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@page import="net.sf.json.JSONObject"%>

<%
	response.setContentType("text/html;charset=UTF-8");
	User user = HrmUserVarify.getUser (request , response) ;
	
	List signtures = new ArrayList();
	
	List lstSigns = weaver.docs.docs.SignatureManager.getSignatureList(user.getUID() + "");
	for(int i = 0; i<lstSigns.size() ; i++){
		String[] signture = (String[])lstSigns.get(i);
		
		Map signtureMap = new HashMap();
		signtureMap.put("signtureID", signture[0]);
		signtureMap.put("signtureName", signture[1]);
		signtures.add(signtureMap);
	}
	
	JSONObject jo = JSONObject.fromObject(signtures);
	//System.out.println(jo.toString());
	out.println(jo);
	
%>