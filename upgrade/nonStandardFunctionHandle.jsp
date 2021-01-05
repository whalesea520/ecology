<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@page import="net.sf.json.JSONObject" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.lang.reflect.Method" %>
<jsp:useBean id="fu" class="com.weaver.upgrade.FunctionUpgrade" scope="page"/>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" />

<%
    String method = Util.null2String(request.getParameter("method"));
    String ids = Util.null2String(request.getParameter("ids"));
    Map<String, List<Map<String, String>>> data = new HashMap<String, List<Map<String, String>>>();
    //启用和停用前先检查FunctionUpgrade.class版本，是否包含最新的启用和停用逻辑
    Class checkClass = Class.forName("com.weaver.upgrade.FunctionUpgrade");
    Method[] methods=checkClass.getDeclaredMethods();
    //文件版本判断
    boolean isTrueVersion=false;
    //通过反射获取FunctionUpgrade.class所有类名继而判断这个类中是否含有scanningXml这个方法，从而判断文件版本
    for(Method singleMethod:methods){
        String methodName=singleMethod.getName();
//        baseBean.writeLog("FunctionUpgrade方法名:"+methodName);
            if("scanningXml".equals(methodName)){
            isTrueVersion=true;
                break;
        }
    }
    if(isTrueVersion) {
        if ("stop".equals(method)) {
            data = fu.stopUpgrade(ids);
        } else {
            data = fu.startUpgrade(ids);
        }
    }
    response.setContentType("application/json; charset=UTF-8");
    java.io.PrintWriter writer = response.getWriter();
    JSONObject jsonObject = JSONObject.fromObject(data);
    writer.write(jsonObject.toString());
    writer.flush();
    writer.close();
%>