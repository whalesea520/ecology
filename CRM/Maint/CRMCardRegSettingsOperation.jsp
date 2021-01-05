<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.conn.ConnStatement"%> 
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.crm.card.*"%>
<%@ page import="org.eclipse.swt.graphics.GC" %>
<%@ page import="weaver.general.GCONST" %>

<%
    User user=HrmUserVarify.getUser(request, response);
    if(user==null){
        return;
    }
	
    if (!HrmUserVarify.checkUserRight("Customer:Settings", user)) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
	
    String method = Util.null2String(request.getParameter("method"));
    //应用设置
    if(method.equals("settings")) {
        String isopen = Util.null2String(request.getParameter("isopen"),"0");
        String url = Util.null2String(request.getParameter("url"));
        String loginid = Util.null2String(request.getParameter("loginid"));
        String password = Util.null2String(request.getParameter("password"));
       
        
        StringBuilder sb=new StringBuilder();
        sb.append(" update CRM_CardRegSettings")
        .append(" set isopen='"+isopen+"'");
        if("1".equals(isopen)){
        	sb.append(" ,modifydate='"+TimeUtil.getCurrentDateString()+"'")
	        .append(" ,modifytime='"+TimeUtil.getOnlyCurrentTimeString()+"'")
	        .append(" ,modifyuser='"+user.getUID()+"'")
	        .append(" ,url='"+url+"'")
	        .append(" ,loginid='"+loginid+"'")
	        .append(" ,password='"+password+"'");
        }
        sb.append(" where id=1");
        RecordSet.executeSql(sb.toString());
        response.sendRedirect("CRMCardRegSettingsInner.jsp");
    }else if(method.equals("validate")){
        //验证接口是否可用
        JSONObject resultObj = new JSONObject();
        CardManager card = new CardManager();
        String url = Util.null2String(request.getParameter("url"));
        String loginid = Util.null2String(request.getParameter("loginid"));
        String password = Util.null2String(request.getParameter("password"));
        JSONObject obj = card.cardRecognize(GCONST.getRootPath()+"CRM"+File.separator+"card"+File.separator+"images"+File.separator+"init.jpg",url,loginid,password);
        out.print(obj);
    }
    
    
%>
