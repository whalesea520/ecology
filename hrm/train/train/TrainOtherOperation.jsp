<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
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
  String actor = Util.fromScreen(request.getParameter("actor"),user.getLanguage()); 
  String startdate = Util.fromScreen(request.getParameter("startdate_"),user.getLanguage()); 
  String enddate = Util.fromScreen(request.getParameter("enddate_"),user.getLanguage()); 
  String result = Util.fromScreen(request.getParameter("result"),user.getLanguage()); 
  String explain = Util.fromScreen(request.getParameter("explain"),user.getLanguage()); 
  
  if(operation.equals("addactor")){
    if(startdate.trim().equals("")||enddate.trim().equals("")){
    	startdate=nowdate;
    	enddate=nowdate;
    } 
   // String sql = "select id,traindate from HrmTrainDay where trainid = "+trainid +" and traindate in ('"+startdate+"','"+enddate+"')"; 
    String sql = "select id,traindate from HrmTrainDay where trainid = "+ trainid +" and traindate >= '"+ startdate +"' and traindate <= '"+ enddate +"'"; 
    rs.executeSql(sql);
    while(rs.next()){
      String traindayid = rs.getString("id");
      ArrayList al = Util.TokenizerString(actor,",");
      for(int i =0;i<al.size();i++){
        String man = (String)al.get(i);
        sql = "select count(*) from HrmTrainActor where resourceid = "+man+" and traindayid = "+traindayid;
        rs2.executeSql(sql);
        rs2.next();
        if(rs2.getInt(1) == 0){
          para = traindayid + separator + man;
          rs2.executeProc("HrmTrainActor_Insert",para);
        }
      }
    }

    
    response.sendRedirect("HrmTrainActorAdd.jsp?isclose=1&trainid="+trainid);
    return;
  }
  
  if(operation.equals("addtest")){
    ArrayList al = Util.TokenizerString(actor,",");
      for(int i =0;i<al.size();i++){
        String man = (String)al.get(i);                                
        para = trainid + separator + man+separator+nowdate+separator+result+separator+explain+separator+userid;
        rs.executeProc("HrmTrainTest_Insert",para);
      }
    response.sendRedirect("HrmTrainTestAdd.jsp?isclose=1&trainid="+trainid);
    return;   
  }
  if(operation.equals("edittest")){
		para = trainid + separator + actor+separator+nowdate+separator+result+separator+explain+separator+userid+separator+id;
        rs.executeProc("HrmTrainTest_Update",para);
		
		response.sendRedirect("HrmTrainTestEdit.jsp?isclose=1&id="+trainid);
        return;
  }
  if(operation.equals("addassess")){
  	startdate = request.getParameter("day");
    para = trainid + separator + userid + separator + startdate + separator + result + separator + explain;
    rs.executeProc("HrmTrainAssess_Insert",para);
    response.sendRedirect("HrmTrainAssessAdd.jsp?isclose=1&trainid="+trainid);
    return;   
  }
  
  if(operation.equals("editassess")){
  	startdate = request.getParameter("day");
    para = trainid + separator + userid + separator + startdate + separator + result + separator + explain +separator+id;
    rs.executeProc("HrmTrainAssess_Update",para);
    response.sendRedirect("HrmTrainAssessEdit.jsp?isclose=1&id="+trainid);
    return;   
  }
%>