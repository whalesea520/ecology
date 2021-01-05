<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.workflowbill.WorkFlowBillUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="bci" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<%
  WorkFlowBillUtil wf = new WorkFlowBillUtil();
  char separator = Util.getSeparator();
  String operation = Util.null2String(request.getParameter("operation"));  
  String sql = "";
  String para="";
//serach  
  if(operation.equalsIgnoreCase("search")){    
    String indexdesc = Util.fromScreen(request.getParameter("searchcon"),user.getLanguage()); 
    para = indexdesc;        
    rs.executeProc("WorkFlow_Browser_Search",para);
    int id = 0;      
    while(rs.next()){
      id = Util.getIntValue(rs.getString("id"),0);
    }
    bci.removeBrowserCache();
    response.sendRedirect("ViewWorkflowbrowser.jsp?id="+id);    
    return;
  }
//add browser  
  if(operation.equalsIgnoreCase("addWorkflowbrowser")){
    int id = Util.getIntValue(Util.fromScreen(request.getParameter("id"),user.getLanguage()),0);
    String label = Util.fromScreen(request.getParameter("label"),user.getLanguage());
//    int labelid = wf.getLabelIdbyLabelName(label);    
    int labelid = Util.getIntValue(Util.fromScreen(request.getParameter("labelid"),user.getLanguage()),0);    
/*    if(labelidget != labelid&&labelidget > 0&&labelid > 0){
      bci.removeBrowserCache();
      response.sendRedirect("ManageWorkflowbrowser.jsp");    
      return;
    }
    if(labelid == 0 && labelidget >0){
      labelid = labelidget;
    } */
    String dbtype = Util.fromScreen(request.getParameter("dbtype"),user.getLanguage());
    String url = Util.fromScreen(request.getParameter("url"),user.getLanguage());
    String table = Util.fromScreen(request.getParameter("table"),user.getLanguage());
    String colum = Util.fromScreen(request.getParameter("colum"),user.getLanguage());
    String keycolum = Util.fromScreen(request.getParameter("keycolum"),user.getLanguage());
    String linkurl = Util.fromScreen(request.getParameter("linkurl"),user.getLanguage());
    para=""+id+separator +labelid+separator+dbtype+separator+url+separator+table+separator+colum+separator+keycolum+separator+linkurl;        
    out.println(para);
    rs.executeProc("WorkFlow_BrowserUrl_Insert",para);
    bci.removeBrowserCache();
    response.sendRedirect("ManageWorkflowbrowser.jsp");    
    return;
  }
//edit  
  if(operation.equalsIgnoreCase("editWorkflowbrowser")){    
     int id = Util.getIntValue(Util.fromScreen(request.getParameter("id"),user.getLanguage()),0);
    String label = Util.fromScreen(request.getParameter("label"),user.getLanguage());
    int labelid = wf.getLabelIdbyLabelName(label);
    int labelidget = Util.getIntValue(Util.fromScreen(request.getParameter("labelid"),user.getLanguage()),0);    
    if(labelidget != labelid&&labelidget > 0&&labelid > 0){
      bci.removeBrowserCache();
      response.sendRedirect("ManageWorkflowbrowser.jsp");    
      return;
    }
    if(labelid == 0 && labelidget >0){
      labelid = labelidget;
    }
    String dbtype = Util.fromScreen(request.getParameter("dbtype"),user.getLanguage());
    String url = Util.fromScreen(request.getParameter("url"),user.getLanguage());
    String table = Util.fromScreen(request.getParameter("table"),user.getLanguage());
    String colum = Util.fromScreen(request.getParameter("colum"),user.getLanguage());
    String keycolum = Util.fromScreen(request.getParameter("keycolum"),user.getLanguage());
    String linkurl = Util.fromScreen(request.getParameter("linkurl"),user.getLanguage());    
    para=""+id+separator+labelid+separator+dbtype+separator+url+separator+table+separator+colum+separator+keycolum+separator+linkurl;            
    rs.executeProc("WorkFlow_BrowserUrl_Update",para);
    bci.removeBrowserCache();
    response.sendRedirect("ManageWorkflowbrowser.jsp");    
    return;
  }
//delete  
  if(operation.equalsIgnoreCase("delete")){
    int id = Util.getIntValue(request.getParameter("id"),0);
    para = ""+id;    
    out.println(para);
    out.println(rs.executeProc("WorkFlow_BrowserUrl_Delete",para));
    bci.removeBrowserCache();
    response.sendRedirect("Manageworkflowbrowser.jsp");
    return;
  }
%>