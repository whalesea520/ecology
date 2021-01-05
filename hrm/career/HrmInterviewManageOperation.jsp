<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
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
String resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String step = Util.fromScreen(request.getParameter("step"),user.getLanguage());
String remark = Util.fromScreen(request.getParameter("remark"),user.getLanguage());
  
if(operation.equals("pass")){
  int result = 1;  
  para = resourceid + separator + step + separator + result + separator + remark + separator + userid + separator + currentdate ;  
  rs.executeProc("HrmInterviewResult_Insert",para);
  
  String nextstep = CareerApplyComInfo.getNextStep(resourceid);
  if(nextstep.equals("")){
    nextstep = step;
  }
  para = ""+resourceid+separator+nextstep;  
  rs.executeProc("HrmCareerApply_Pass",para);
  /*if(planid.equals("")){
    response.sendRedirect("HrmCareerApplyEdit.jsp?applyid="+resourceid);
  }else{
  response.sendRedirect("HrmCareerApplyList.jsp?id="+planid);
  }*/
	response.sendRedirect("HrmInterviewResult.jsp?isclose=1&id="+resourceid+"&planid="+planid);  
}

if(operation.equals("backup")){ 
  int result = 2;
  para = resourceid + separator + step + separator + result + separator + remark + separator + userid + separator + currentdate ;  
  rs.executeProc("HrmInterviewResult_Insert",para); 
  para = ""+resourceid;  
  rs.executeProc("HrmCareerApply_Backup",para);
  /*if(planid.equals("")){
    response.sendRedirect("HrmCareerApplyEdit.jsp?applyid="+resourceid);
  }else{
  response.sendRedirect("HrmCareerApplyList.jsp?id="+planid);
  }*/
  response.sendRedirect("HrmInterviewResult.jsp?isclose=1&id="+resourceid+"&planid="+planid);  
}

if(operation.equals("delete")){  
  para = ""+resourceid;  
  rs.executeProc("HrmCareerApply_Delete",para);
  /*if(planid.equals("")){
    response.sendRedirect("HrmCareerApply.jsp");
  }else{  
  response.sendRedirect("HrmCareerApplyList.jsp?id="+planid);
  }*/
  response.sendRedirect("HrmInterviewResult.jsp?isclose=1&id="+resourceid+"&planid="+planid);  
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