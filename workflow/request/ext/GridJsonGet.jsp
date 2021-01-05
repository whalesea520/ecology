
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="DocDsp" class="weaver.docs.docs.DocDsp" scope="page"/>
<%
	String paras = Util.null2String(request.getParameter("paras"));
	//System.out.println(paras);
	

	JSONObject oJson= new JSONObject();	
	JSONArray table=new JSONArray();
	

	
	for(int i=0;i<30;i++){
		JSONObject row=new JSONObject();
		row.put("id",""+i);
		row.put("createdate","2008-07-03 16:11:25");
		row.put("creator","<A href='#'>曾东平</a>");
		row.put("workflow",""+SystemEnv.getHtmlLabelName(33624,user.getLanguage()));
		row.put("level",""+SystemEnv.getHtmlLabelName(25397,user.getLanguage()));
		row.put("title","<A href='javascript:openWfToTab("+i+")' title='SystemEnv.getHtmlLabelName(84499,user.getLanguage())"+i+"'>SystemEnv.getHtmlLabelName(84499,user.getLanguage())"+i+"</a>");
		row.put("receivedate","2008-07-03 16:11:25");
		
		table.put(row);	
	}	
	oJson.put("totalCount",200);
	oJson.put("data",table);
    out.print(oJson.toString());
%>