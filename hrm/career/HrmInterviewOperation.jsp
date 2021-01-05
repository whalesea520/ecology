<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
int userid = user.getUID();                     

String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;
String para = "";
String planid = Util.fromScreen(request.getParameter("planid"),user.getLanguage());

if(operation.equals("plan")){
  String resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
  String step = Util.fromScreen(request.getParameter("step"),user.getLanguage());
  String date = Util.fromScreen(request.getParameter("date"),user.getLanguage());
  String time = Util.fromScreen(request.getParameter("time"),user.getLanguage());
  String address = Util.fromScreen(request.getParameter("address"),user.getLanguage());
  String notice = Util.fromScreen(request.getParameter("notice"),user.getLanguage());
  String interviewer = Util.fromScreen(request.getParameter("interviewer"),user.getLanguage());
  
  para = ""+resourceid+separator+step;  
  rs.executeProc("HrmInterview_Delete",para);
  para = resourceid + separator + step + separator + date + separator + time + separator + address + separator + notice + separator + interviewer;  
  rs.executeProc("HrmInterview_Insert",para);
  /*if(planid.equals("")){
    response.sendRedirect("HrmCareerApplyEdit.jsp?applyid="+resourceid);
  }else{
    response.sendRedirect("HrmInterviewPlan.jsp?isclose=1&id="+resourceid+"&planid="+planid);
  }*/
  response.sendRedirect("HrmInterviewPlan.jsp?isclose=1&id="+resourceid+"&planid="+planid);
}

if(operation.equals("plandelete")){
  String resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
  String step = Util.fromScreen(request.getParameter("step"),user.getLanguage());
  
  para = ""+resourceid+separator+step;  
  rs.executeProc("HrmInterview_Delete",para);
  if(planid.equals("")){
    response.sendRedirect("HrmCareerApplyEdit.jsp?applyid="+resourceid);
  }else{
    response.sendRedirect("HrmCareerApplyList.jsp?id="+planid);
  }
}

if(operation.equals("assess")){
  String resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
  String step = Util.fromScreen(request.getParameter("step"),user.getLanguage());
  String result = Util.fromScreen(request.getParameter("result"),user.getLanguage());
  String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());  
  
  para = ""+resourceid+separator+step+separator+""+userid;  
  rs.executeProc("HrmInterviewAssess_Delete",para);
  para = resourceid + separator + step + separator + result + separator + remark + separator + userid + separator + currentdate ;
  rs.executeProc("HrmInterviewAssess_Insert",para);
  /*if(planid.equals("")){
    response.sendRedirect("HrmCareerApplyEdit.jsp?applyid="+resourceid);
  }else{
    response.sendRedirect("HrmCareerApplyList.jsp?id="+planid);
  }*/
  response.sendRedirect("HrmInterviewAssess.jsp?isclose=1&id="+resourceid+"&planid="+planid);
}

if(operation.equals("inform")){  
  String[] actors = request.getParameterValues("actor");  
  if(actors != null){
      for(int i = 0;i<actors.length;i++){
       String actor = actors[i];       
       para = actor;
       rs.executeProc("HrmCareerApply_Inform",para);
      } 
  }
  response.sendRedirect("HrmCareerApplyList.jsp?id="+planid);  
}  
%>