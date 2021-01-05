
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="DocShare" class="weaver.docs.DocShare" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;

	int docid = Util.getIntValue(request.getParameter("docid"),-1);
	int star = Util.getIntValue(request.getParameter("start"),-1);
	int limit = Util.getIntValue(request.getParameter("limit"),-1);
	
	int userLanguage = user.getLanguage();

	

	
	ArrayList dataList=new ArrayList();
	ArrayList dataList2=new ArrayList();
    
	//生成Json
	//1
	dataList.addAll(DocShare.getShareList(1,docid,"true",userLanguage));
	dataList.addAll(DocShare.getShareList(2,docid,"true",userLanguage));
	dataList.addAll(DocShare.getShareList(3,docid,"true",userLanguage));
	dataList.addAll(DocShare.getShareList(4,docid,"true",userLanguage));
	dataList.addAll(DocShare.getShareList(5,docid,"true",userLanguage));
	
	int dataSize=dataList.size();
	for(int i=0;i<limit;i++){
		
		if(star+i>=dataSize) break;
		
		dataList2.add(dataList.get(star+i));
		
	}	
	JSONArray arrayJson=new JSONArray(dataList2) ;
	JSONObject oJson= new JSONObject();
	oJson.put("totalCount",dataSize);
	oJson.put("data",arrayJson);
	out.println(oJson.toString());
	//2

	//3

	//4

	//5

	
%>