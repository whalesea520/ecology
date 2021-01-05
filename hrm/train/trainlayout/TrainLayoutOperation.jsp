<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="srwf" class="weaver.system.SysRemindWorkflow" scope="page" />
<%
  Calendar todaycal = Calendar.getInstance ();
  String today = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
                 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
                 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
                 
  String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
  char separator = Util.getSeparator() ;
  String para = "";
  int userid = user.getUID();
  
  String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
  String name = Util.fromScreen(request.getParameter("layoutname"),user.getLanguage());
  String typeid = Util.fromScreen(request.getParameter("typeid"),user.getLanguage());
  String startdate = Util.fromScreen(request.getParameter("layoutstartdate"),user.getLanguage());
  String enddate = Util.fromScreen(request.getParameter("layoutenddate"),user.getLanguage());
  String content = Util.fromScreen(request.getParameter("layoutcontent"),user.getLanguage());
  String aim = Util.fromScreen(request.getParameter("layoutaim"),user.getLanguage());
  String testdate = Util.fromScreen(request.getParameter("layouttestdate"),user.getLanguage());
  String assessor = Util.fromScreen(request.getParameter("layoutassessor"),user.getLanguage());
  
  if(operation.equals("add")){
    para = name+separator+typeid+separator+startdate+separator+enddate+separator+content+separator+aim+separator+testdate+separator+assessor;    
    rs.executeProc("HrmTrainLayout_Insert",para);
    rs.executeSql(" select max(id) from  HrmTrainLayout");
	if(rs.next()){
		id = rs.getString(1);
	}
    
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmTrainLayout_Insert,"+para);
      SysMaintenanceLog.setOperateItem("67");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
    
    if(today.equals(testdate)){    
        String accepter="";
        String title="";
        String remark="";
        String submiter="";
        String subject="";

        subject= SystemEnv.getHtmlLabelName(16162,user.getLanguage()) ;
        subject+=":"+name;
        accepter = assessor;
        title =  SystemEnv.getHtmlLabelName(16162,user.getLanguage()) ;
        title += ":"+name;
        title += ":System Remind ";
        title += "-"+today;
        remark="<a href=/hrm/train/trainlayout/HrmTrainLayoutEdit.jsp?id="+id+">"+Util.fromScreen2(subject,7)+"</a>";
        submiter="0";
        srwf.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);
    }
    response.sendRedirect("HrmTrainLayoutAdd.jsp?isclose=1");
  }
  
  
  if(operation.equals("edit")){
    para = name+separator+typeid+separator+startdate+separator+enddate+separator+content+separator+aim+separator+testdate+separator+assessor+separator+id;
    out.println(para);
    rs.executeProc("HrmTrainLayout_Update",para);
    
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmTrainLayout_Update,"+para);
      SysMaintenanceLog.setOperateItem("67");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
      
    response.sendRedirect("HrmTrainLayoutEditDo.jsp?isclose=1&id="+id);    
  }

if(operation.equals("info")){ 
        String sql = "select layoutname,layoutassessor from HrmTrainLayout where id = "+id;
        rs.executeSql(sql);
        rs.next();
        name = Util.null2String(rs.getString("layoutname"));        
        assessor = Util.null2String(rs.getString("layoutassessor"));
        
        String accepter="";
        String title="";
        String remark="";
        String submiter="";
        String subject="";

        subject= SystemEnv.getHtmlLabelName(16162,user.getLanguage()) ;
        subject+=":"+name;
        accepter = assessor;
        title =  SystemEnv.getHtmlLabelName(16162,user.getLanguage()) ;
        title += ":"+name;
        title += ":System Remind ";
        title += "-"+today;
        remark="<a href=/hrm/train/trainlayout/HrmTrainLayoutEdit.jsp?id="+id+">"+Util.fromScreen2(subject,7)+"</a>";
        submiter="0";
        srwf.setPrjSysRemind(title,0,Util.getIntValue(submiter),accepter,remark);

        response.sendRedirect("HrmTrainLayout.jsp");
}
  
  if(operation.equals("delete")){
    /*Add By Huang Yu ,Check is this record can be delete*/
   boolean canDelete =true;
   
   if(!id.equals("")){
       String sqlstr ="Select count(ID) as Count FROM HrmTrainPlan WHERE layoutid = "+id;
       rs.executeSql(sqlstr);
       rs.next();
       if(rs.getInt("Count") > 0 ){
           canDelete = false;
       }
       
       sqlstr ="Select layoutname FROM HrmTrainLayout WHERE id = "+id;
       rs.executeSql(sqlstr);
       if(rs.next()){
      	 name = rs.getString("layoutname"); 
       }
   }
   
  
    if(canDelete){
        para = ""+id;
        rs.executeProc("HrmTrainLayout_Delete",para);

        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
        SysMaintenanceLog.setRelatedName(name);
        SysMaintenanceLog.setOperateType("3");
        SysMaintenanceLog.setOperateDesc("HrmTrainLayout_Delete,"+para);
        SysMaintenanceLog.setOperateItem("67");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
    }
    response.sendRedirect("HrmTrainLayout.jsp");
  } 
  
  if(operation.equals("addAssess")){
    String assessdate = Util.fromScreen(request.getParameter("assessdate"),user.getLanguage());
    String implement  = Util.fromScreen(request.getParameter("implement"),user.getLanguage());    
    String explain = Util.fromScreen(request.getParameter("explain"),user.getLanguage());
    String advice = Util.fromScreen(request.getParameter("advice"),user.getLanguage());
    
    para = ""+id+separator+userid+separator+assessdate+separator+implement+separator+explain+separator+advice;
    out.println(para);
    rs.executeProc("TrainLayoutAssess_Insert",para);
    response.sendRedirect("TrainLayoutAssessAdd.jsp?isclose=1&id="+id);
  } 

%>