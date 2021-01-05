<%--
@Version 2004-7-13
@Author Charoes Huang
@Description For bug 183
--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />

<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
  String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
  String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
  int type = Util.getIntValue(request.getParameter("type"),1);
  String fare = Util.fromScreen(request.getParameter("fare"),user.getLanguage());
  String time = Util.fromScreen(request.getParameter("time"),user.getLanguage());
  String memo = Util.fromScreen(request.getParameter("memo"),user.getLanguage());

  String operation  = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
  String sql = "";
  String para = "";
  char separator = Util.getSeparator() ;

  if(operation.equals("add")){
    para = name +separator+ type +separator+ fare + separator+time + separator+memo;
    boolean issuccess = rs.executeProc("HrmTrainRes_Insert",para);

	if(issuccess){
	  sql = "Select Max(ID) as ID FROM HrmTrainResource";	
	  rs.executeSql(sql);
	  String maxID ="";
	  if(rs.next()){
		maxID = rs.getString("ID");
	  }
	  SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(maxID));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmTrainRes_Insert,"+para);
      SysMaintenanceLog.setOperateItem("68");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	}

  
    response.sendRedirect("HrmTrainResourceAdd.jsp?isclose=1");
    return;
  }

  if(operation.equals("edit")){
    para = name +separator+ type +separator+ fare + separator+time + separator+memo+separator+id;
    rs.executeProc("HrmTrainRes_Update",para);

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmTrainRes_Update,"+para);
      SysMaintenanceLog.setOperateItem("68");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

    response.sendRedirect("HrmTrainResourcetEditDo.jsp?isclose=1&id="+id);
    return;
  }

  if(operation.equals("delete")){
      boolean canDelete =true;
      if(!id.equals("")){
          String sqlstr ="Select count(ID) as Count FROM HrmTrainPlan WHERE planresource = "+id;
          rs.executeSql(sqlstr);
          rs.next();
          if(rs.getInt("Count") > 0 ){
              canDelete = false;
          }
      }
      
      boolean canDeleteTrainAct =true;
      if(!id.equals("")){
          String sqlstr ="select 1 from HrmTrain where resource_n = "+id;
          rs.executeSql(sqlstr);
          if(rs.next()) {
       	   canDeleteTrainAct = false;
          }
      }

    if(canDelete && canDeleteTrainAct){
        para = ""+id;
        name = TrainResourceComInfo.getResourcename(id);
        rs.executeProc("HrmTrainRes_Delete",para);

          SysMaintenanceLog.resetParameter();
          SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
          SysMaintenanceLog.setRelatedName(name);
          SysMaintenanceLog.setOperateType("3");
          SysMaintenanceLog.setOperateDesc("HrmTrainRes_Delete,"+para);
          SysMaintenanceLog.setOperateItem("68");
          SysMaintenanceLog.setOperateUserid(user.getUID());
          SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
          SysMaintenanceLog.setSysLogInfo();
    }
    response.sendRedirect("HrmTrainResource.jsp");
    return;
  }
%>