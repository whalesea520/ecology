<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="srwf" class="weaver.system.SysRemindWorkflow" scope="page" />
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
  String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
  String planid = Util.fromScreen(request.getParameter("planid"),user.getLanguage());
  String organizer = Util.fromScreen(request.getParameter("organizer"),user.getLanguage());
  String startdate = Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
  String enddate = Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
  String content = Util.fromScreen(request.getParameter("content"),user.getLanguage());
  String aim = Util.fromScreen(request.getParameter("aim"),user.getLanguage());
  String address = Util.fromScreen(request.getParameter("address"),user.getLanguage());
  String resource = Util.fromScreen(request.getParameter("resource"),user.getLanguage());
  String testdate = Util.fromScreen(request.getParameter("testdate"),user.getLanguage());
  String fare = Util.fromScreen(request.getParameter("fare"),user.getLanguage());
  String faretype = Util.fromScreen(request.getParameter("faretype"),user.getLanguage());
  String advice = Util.fromScreen(request.getParameter("advice"),user.getLanguage());
  
if(operation.equals("edit")){ 
  para = name     + separator + planid  + separator + organizer + separator + startdate +separator+
         enddate  + separator + content + separator + aim       + separator + address   +separator+
         resource + separator + testdate+ separator + id;   
  rs.executeProc("HrmTrain_Update",para);
  
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmTrain_Update,"+para);
      SysMaintenanceLog.setOperateItem("83");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
      
   response.sendRedirect("HrmTrainEditDo.jsp?isclose=1&id="+id);
  }

if(operation.equals("info")){ 
        String sql = "select name,organizer from HrmTrain where id = "+id;
        rs.executeSql(sql);
        rs.next();
        name = Util.null2String(rs.getString("name"));
        organizer = Util.null2String(rs.getString("organizer"));
        
        String assessor = TrainComInfo.getActor(id)+organizer+","+userid;
        
        String accepter="";
        String title="";
        String remark="";
        String submiter="";
        String subject="";

        subject= SystemEnv.getHtmlLabelName(16156,user.getLanguage()) ;
        subject+=":"+name;
        accepter = assessor;
        title =  SystemEnv.getHtmlLabelName(16156,user.getLanguage()) ;
        title += ":"+name;
        title += ":System Remind ";
        title += "-"+nowdate;
        remark="<a href=/hrm/train/train/HrmTrainEdit.jsp?id="+id+">"+Util.fromScreen2(subject,7)+"</a>";
        submiter=""+userid;
        srwf.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);

        response.sendRedirect("HrmTrain.jsp");
}
  
if(operation.equals("add")){ 
  para = name+separator+planid+separator+organizer+separator+startdate+separator+enddate+
         separator+content+separator+aim+separator+address+separator+resource+separator+
         userid+separator+testdate;  
  rs.executeProc("HrmTrain_Insert",para);
 	rs.executeSql("select max(id) from HrmTrain ");
  if(rs.next())id = ""+rs.getInt(1);
   

  String sql = "select * from HrmTrainPlanDay where planid="+planid;

  rs.executeSql(sql);
  while(rs.next()){
    String day = Util.null2String(rs.getString("plandate"));
    content = Util.null2String(rs.getString("plandaycontent"));
    aim = Util.null2String(rs.getString("plandayaim"));
    String starttime = Util.null2String(rs.getString("starttime"));
    String endtime = Util.null2String(rs.getString("endtime"));
    para = id+separator+day +separator+starttime +separator+endtime + separator +content +separator+aim ;
	//System.out.println("HrmTrainDay_Insert para = "+para);
    rs2.executeProc("HrmTrainDay_Insert",para);       
  }
  sql = "select planactor from HrmTrainPlan where id = "+planid;  
  rs.executeSql(sql);
  rs.next();
  String actor = Util.null2String(rs.getString("planactor"));
  ArrayList al = Util.TokenizerString(actor,",");
  ArrayList a_trainDay = new ArrayList();
  sql = "select id from HrmTrainDay WHERE trainid = "+id;
  rs.executeSql(sql);
  while(rs.next()){
	a_trainDay.add(rs.getString("id"));
  }
  for(int i = 0;i<al.size();i++){
    String man = (String)al.get(i);
  
     for(int j=0;j<a_trainDay.size();j++){
      String dayid = (String)a_trainDay.get(j);
      para = dayid + separator+man;
      //System.out.println("HrmTrainActor_Insert para"+para);
      rs2.executeProc("HrmTrainActor_Insert",para);
    }
  }
  
	  //System.out.println("id = "+id); 
  if(nowdate.equals(testdate)){
        String assessor = TrainComInfo.getActor(id)+organizer+","+userid;
        
        String accepter="";
        String title="";
        String remark="";
        String submiter="";
        String subject="";

        subject= SystemEnv.getHtmlLabelName(16156,user.getLanguage()) ;
        subject+=":"+name;
        accepter = assessor;
        title =  SystemEnv.getHtmlLabelName(16156,user.getLanguage()) ;
        title += ":"+name;
        title += ":System Remind ";
        title += "-"+nowdate;
        remark="<a href=/hrm/train/train/HrmTrainEdit.jsp?id="+id+">"+Util.fromScreen2(subject,7)+"</a>";
        submiter=""+userid;
        srwf.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
  }
  
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmTrain_Insert,");
      SysMaintenanceLog.setOperateItem("83");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
      
  response.sendRedirect("HrmTrainAdd.jsp?isclose=1&id="+id);
  }
  
if(operation.equals("delete")){ 
    para = ""+id;  
    name = TrainComInfo.getTrainname(id);
    rs.executeProc("HrmTrain_Delete",para);
    
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmTrain_Delete,");
      SysMaintenanceLog.setOperateItem("83");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
      
    response.sendRedirect("HrmTrain.jsp");
  }
  
if(operation.equals("finish")){ 
    para = ""+id+separator+userid+separator+nowdate+separator+fare+separator+faretype+separator+advice;      
    rs.executeProc("HrmTrain_Finish",para);
    
    String sql = "select startdate,enddate,resource_n from HrmTrain where id="+id;    
    rs.executeSql(sql);
    rs.next();
    startdate = Util.null2String(rs.getString("startdate"));
    enddate = Util.null2String(rs.getString("enddate"));
    resource = Util.null2String(rs.getString("resource_n"));
    
    String actors = Util.null2String(TrainComInfo.getActor(id));    
    ArrayList al = new ArrayList();
    al = Util.TokenizerString(actors,",");    
    for(int i = 0;i<al.size();i++){
      String actor = (String)al.get(i);
      sql = "select implement from HrmTrainAssess where resourceid = "+actor+ " and trainid = "+id;       
      rs.executeSql(sql);
      rs.next(); 
      String trainassess = Util.null2String(rs.getString("implement"));     
      sql = "select result from HrmTrainTest where resourceid = "+actor+ " and  trainid = "+id;      
      rs.executeSql(sql);            
      rs.next(); 
      String trainresult = Util.null2String(rs.getString("result"));
      String tsult = "0";
	  if(!"".equals(trainresult)){
	    tsult = trainresult;
	  }
      para = ""+actor+separator+startdate+separator+enddate+separator+""+id+separator+trainassess+separator+tsult+separator+resource;    
      rs.executeProc("HrmTrainRecord_Insert",para);
    }    
    response.sendRedirect("HrmTrainFinish.jsp?isclose=1");
  }
%>