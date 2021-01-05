<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="multiAclManager" class="weaver.rdeploy.doc.MultiAclManagerNew" scope="page" />
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="privateSeccategoryManager" class="weaver.rdeploy.doc.PrivateSeccategoryManager" scope="page" />
<%@ page import="java.util.Map,java.util.HashMap" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	String categoryid = Util.null2String(request.getParameter("categoryid"));
	int type = Util.getIntValue(request.getParameter("type"));
	int searchType = Util.getIntValue(request.getParameter("searchType"),0);
	String createrid = Util.null2String(request.getParameter("createrid"));
	String departmentid = Util.null2String(request.getParameter("departmentid"));
	String seccategory = Util.null2String(request.getParameter("seccategory"));
	String createdatefrom = Util.null2String(request.getParameter("createdatefrom"));
	String createdateto = Util.null2String(request.getParameter("createdateto"));
	String txt = Util.null2String(request.getParameter("txt"));
	txt = txt.replaceAll("'","''");
    Map<String,String> params = new HashMap<String,String>();
	params.put("createrid",createrid);
	params.put("departmentid",departmentid);
	if(searchType==1){
		params.put("seccategory",seccategory);
	}else{
		params.put("seccategory",categoryid);
	}
	params.put("createdatefrom",createdatefrom);
	params.put("createdateto",createdateto);
	params.put("searchtype", "adv");
    params.put("docvestin", "0");
	params.put("doctitle", txt);
	
	
	
	int pageCount = Util.getIntValue(request.getParameter("pageCount"));
	int pageSize = Util.getIntValue(request.getParameter("pageSize"));
	String loadfoldertype = Util.null2String(request.getParameter("loadfoldertype"));
	String orderby = Util.null2String(request.getParameter("orderby"));
	String result = "";
	
    
	if(true)
	{
	    if(type < 1)
	    {
	        result = multiAclManager.getDoctailsBySecId_new(user,pageSize,pageCount,params);
	    }
	    else if(type == 1)
	    {	
	        if(categoryid.indexOf("user") > -1){
	            params.put("flag","user");
	            categoryid = categoryid.substring(4);
	        }else if(categoryid.indexOf("group") > -1){
	            params.put("flag","group");
	            params.put("targetid",categoryid.substring(5));
	            categoryid = "-1";
	        }else{
	            params.put("flag","category");	            
	        }
	        
	        result = privateSeccategoryManager.getDoctailsBySecId(user,Integer.parseInt(categoryid),pageSize,pageCount,loadfoldertype,orderby,params);
	    }else if (type == 2){
			result = multiAclManager.getDocSubscribeList(user,Util.getIntValue(categoryid),pageSize,pageCount);
		}
	}
	out.println(result);
%>
