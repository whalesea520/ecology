<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="multiAclManager" class="weaver.rdeploy.doc.MultiAclManagerNew" scope="page" />
<jsp:useBean id="privateSeccategoryManager" class="weaver.rdeploy.doc.PrivateSeccategoryManager" scope="page" />
<jsp:useBean id="privateSearchManager" class="weaver.rdeploy.doc.PrivateSearchManager" scope="page" />
<jsp:useBean id="shareSearchManager" class="weaver.rdeploy.doc.ShareSearchManager" scope="page" />
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.Map,java.util.HashMap,java.util.List" %>
<%@ page import="net.sf.json.JSONArray" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String categoryid = Util.null2String(request.getParameter("categoryid"));
	String foldertype = Util.null2String(request.getParameter("foldertype"));
	String orderby = Util.null2String(request.getParameter("orderby"));
	String txt = Util.null2String(request.getParameter("txt"));
	txt = txt.replaceAll("'","''");
	Map<String,String> params = new HashMap<String,String>();
	params.put("txt",txt);
	String result = "";
	
	
	if(foldertype.equals("publicAll"))
	{
	    result = multiAclManager.getPermittedTree(user,categoryid);
	}
	else if(foldertype.equals("privateAll"))
	{
	    if(txt.isEmpty()){
		    int sid = 0;
		    if(categoryid.isEmpty()){
		        sid = privateSeccategoryManager.getUserPrivateCategoryId(user);
		    }
		    else{
		        sid = Integer.parseInt(categoryid);
		        if(sid <= 0){
		            sid = privateSeccategoryManager.getUserPrivateCategoryId(user);
		        }
		    }
		    orderby = orderby.equals("name") ? "name" : "";
		    List<Map<String, String>> dataList = privateSearchManager.getFolderAndDocsForPrivateByCategoryid(sid,orderby,"desc");
		    result = JSONArray.fromObject(dataList).toString();
	    }else{
	        int pagesize = Util.getIntValue(request.getParameter("pagesize"),1);
	        int pagecount = Util.getIntValue(request.getParameter("pagecount"),10);;
	        List<Map<String, String>> dataList = privateSearchManager.searchPrivateDocsByKeyword(user,txt,pagesize,pagecount,orderby,"desc");
		    result = JSONArray.fromObject(dataList).toString(); 
	    }
	    
	}else if(foldertype.equals("myShare") || foldertype.equals("shareMy")){
	    int sid = Util.getIntValue(categoryid,0);
       orderby = orderby.equals("name") ? "name" : "";
	    if(sid > 0 && txt.isEmpty()){
	       List<Map<String, String>> dataList = privateSearchManager.getFolderAndDocsForPrivateByCategoryid(sid,orderby,"desc");
		   result = JSONArray.fromObject(dataList).toString();
	    }else{
	       List<Map<String, String>> dataList = shareSearchManager.getShareForFolderAndDocs(user,foldertype.toLowerCase(),txt,orderby,"desc");
		   result = JSONArray.fromObject(dataList).toString();
	    }
	}
	out.println(result);
%>
