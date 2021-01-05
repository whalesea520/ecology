<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<jsp:useBean id="payPlan" class="weaver.contractn.serviceImpl.PayPlanServiceImpl" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="fileHandle" class="weaver.contractn.util.FileHandle"
    scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
    JSONArray map = fileHandle.uploadFile(request);
	User usr = HrmUserVarify.getUser(request, response);
    int usrId = usr.getUID();
    //map.put("usrId",Integer.toString(usrId));
    //String message = payPlan.save(map);
    //out.print(message);
    
%>

