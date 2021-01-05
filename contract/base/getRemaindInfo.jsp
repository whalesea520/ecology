<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<jsp:useBean id="remaind" class="weaver.contractn.serviceImpl.RemaindServiceImpl" scope="page" />
<jsp:useBean id="dynamic" class="weaver.contractn.serviceImpl.DynamicServiceImpl" scope="page" />
<jsp:useBean id="pay" class="weaver.contractn.entity.PayPlanVo" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
   User usr = HrmUserVarify.getUser(request, response);
   int author = usr.getUID(); 
   String action = request.getParameter("action");
   pay.setUser(usr);
   if("total".equals(action)){
       out.println(remaind.queryCount(pay,author));
   }else if("detail".equals(action)){
       JSONObject obj = new JSONObject();
       obj.put("remaindList",remaind.queryRemaindInfo(pay));
       obj.put("dynamicList",dynamic.queryDynamicOfMine(author));
       out.print(obj.toString());
   }else if("deleteDynamic".equals(action)){
	   out.print(dynamic.deleteDynamic(author,"dynamic"));
   }else if("deleteComment".equals(action)){
	   out.print(dynamic.deleteDynamic(author,"commentOfMine"));
   }
%>



