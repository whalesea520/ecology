<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.gp.execution.AccessItemManager"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLClassLoader"%>
<%
    FileUpload fu = new FileUpload(request);
    String cycle = Util.null2String(fu.getParameter("type1"));
    String gval = Util.null2String(fu.getParameter("target"));
    String cval = Util.null2String(fu.getParameter("result"));
    String jcway = Util.null2String(fu.getParameter("jcway"));
    Map<String,Object> maps = new HashMap<String,Object>();
    maps.put("user",user);
    maps.put("cycle",cycle);
    maps.put("gval",gval);
    maps.put("cval",cval);
   	String result = "";
	String msg = "";
	double resultscore = 0;
	
	//String cuuurl =request.getSession().getServletContext().getRealPath("/")+"WebRoot/WEB-INF/classes";
	try{
		//URL[] urls = new URL[] { new URL("file:/"+ cuuurl) };
	    //URLClassLoader ul = new URLClassLoader(urls);
	    Class c = Class.forName(jcway);
        Object obj = c.newInstance();
        if(obj instanceof AccessItemManager){
        	Method method1 = c.getMethod("getAccessItemScore",Map.class);
	        resultscore = (Double)method1.invoke(obj,maps); 
	        result = "1";
	        msg = "执行成功!结果"+resultscore;
        }else{
        	result = "0";
	        msg = "没有实现weaver.gp.execution.AccessItemManager接口,请确认!";
        }
    }catch(Exception e){
    	e.printStackTrace();
    	result = "0";
    	msg = "获取评分结果异常，异常信息:"+e.toString();
    }
    JSONObject json = new JSONObject();
	json.put("result",result);
	json.put("msg",msg);
	json.put("resultscore",resultscore);
	//System.out.println(json.toString());
	out.print(json.toString());
    
%>