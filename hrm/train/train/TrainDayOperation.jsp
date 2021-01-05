<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
  String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
  char separator = Util.getSeparator() ;
  String para = "";
  int userid = user.getUID();   
  Date newdate = new Date() ;
  long datetime = newdate.getTime() ;
  Timestamp timestamp = new Timestamp(datetime) ;
  String nowdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
  
  String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());  
  String trainid = Util.fromScreen(request.getParameter("trainid"),user.getLanguage());  
  String day = Util.fromScreen(request.getParameter("day"),user.getLanguage()); 
  String starttime = Util.fromScreen(request.getParameter("starttime"),user.getLanguage()); 
  String endtime = Util.fromScreen(request.getParameter("endtime"),user.getLanguage()); 
  String content = Util.fromScreen(request.getParameter("content"),user.getLanguage());
  String aim = Util.fromScreen(request.getParameter("aim"),user.getLanguage());  
  String actor = Util.fromScreen(request.getParameter("actor"),user.getLanguage());  
  String effect = Util.fromScreen(request.getParameter("effect"),user.getLanguage());
  String plain = Util.fromScreen(request.getParameter("plain"),user.getLanguage());
  
  if(operation.equals("edit")){ 
  para = day+separator+starttime+separator+endtime+separator+content+separator+aim+separator+effect+separator+plain+separator+id;  
  rs.executeProc("HrmTrainDay_Update",para);
  rs.executeProc("HrmTrainActor_UpdateReset",id);
  String[] actors = request.getParameterValues("actor");
  if(actors != null){
      for(int i = 0;i<actors.length;i++){
       actor = actors[i];
       para = id + separator + actor;
       out.println(rs.executeProc("HrmTrainActor_Update",para));
      } 
  }
   response.sendRedirect("HrmTrainDayEdit.jsp?isclose=1&id="+id+"&trainid="+trainid);
  }
  else if(operation.equals("editActorList")){
    //rs.executeProc("HrmTrainActor_UpdateReset",id);
    String allactor = Util.null2String(request.getParameter("actor"));
    String[] actors = allactor.split(",");
    for(int i = 0;actors!=null&&i<actors.length;i++){
     actor = actors[i];
     para = id + separator + actor;
     rs.executeProc("HrmTrainActor_Update",para);
    } 
  	response.sendRedirect("HrmTrainDayActorList.jsp?isclose=1&id="+id);
  }
  
  if(operation.equals("add")){ 
	  para = trainid+separator+day+separator+starttime+separator+endtime+separator+content+separator+aim;
	  rs.executeProc("HrmTrainDay_Insert",para);
	  rs.next();
	  id = ""+rs.getInt(1);  
	  ArrayList al = Util.TokenizerString(actor,",");
	  for(int i = 0;i<al.size();i++){
	    String man = (String)al.get(i);
	    para = id+ separator + man;
	    rs.executeProc("HrmTrainActor_Insert",para);       
	  }
	  response.sendRedirect("HrmTrainDayAdd.jsp?isclose=1&id="+id+"&trainid="+trainid);
  }
  
  if(operation.equals("delete")){ 
    para = ""+id;  
    rs.executeProc("HrmTrainDay_Delete",para);
    response.sendRedirect("HrmTrainSchedule.jsp?id="+trainid);
  }
%>