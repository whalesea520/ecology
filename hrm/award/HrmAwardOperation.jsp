<%@ page import="java.security.*,weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AwardComInfo" class="weaver.hrm.award.AwardComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

String operation = Util.null2String(request.getParameter("operation")); 
String id = Util.null2String(request.getParameter("id"));  
String rptitle = Util.fromScreen(request.getParameter("rptitle"),user.getLanguage());/*奖惩标题*/
String resourceid =    Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());/*员工id*/
String rptypeid = Util.fromScreen(request.getParameter("rptypeid"),user.getLanguage());/* 奖惩种类*/
String rpdate = Util.fromScreen(request.getParameter("rpdate"),user.getLanguage()) ;       /*奖惩日期*/	
String rpexplain = Util.fromScreen(request.getParameter("rpexplain"),user.getLanguage()) ;	/*说明*/
String rptransact = Util.fromScreen(request.getParameter("rptransact"),user.getLanguage()) ;

char separator = Util.getSeparator() ;  
String para = "" ;  
  
if(operation.equalsIgnoreCase("add")){   
    para =rptitle + separator + resourceid + separator + rptypeid + separator + rpdate + separator + rpexplain + separator + rptransact;
    
     rs.executeProc("HrmAwardInfo_Insert",para);
     rs.executeSql(" select * from HrmAwardInfo");
     rs.last();
     int idd=rs.getInt(1);

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(idd);
      SysMaintenanceLog.setRelatedName(rptitle);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmAwardInfo_Insert,"+para);
      SysMaintenanceLog.setOperateItem("93");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

     AwardComInfo.removeAwardCache();
    response.sendRedirect("HrmAwardAdd.jsp?isclose=1");
}

if(operation.equals("edit")){
    if(!HrmUserVarify.checkUserRight("HrmResourceRewardsRecordEdit:Edit", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
 
    para =""+id + separator + rptitle + separator + resourceid + separator + rptypeid
    + separator + rpdate + separator + rpexplain + separator + rptransact ;
 
    RecordSet.executeProc("HrmAwardInfo_Update",para);
  
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Integer.parseInt(id));
      SysMaintenanceLog.setRelatedName(rptitle);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmAwardInfo_Update,"+para);
      SysMaintenanceLog.setOperateItem("93");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

    AwardComInfo.removeAwardCache();
    response.sendRedirect("/hrm/award/HrmAwardEdit.jsp?id="+id+"&isclose=1");
}
 else if(operation.equals("delete")){
    if(!HrmUserVarify.checkUserRight("HrmResourceRewardsRecordEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	RecordSet.executeSql("select rptitle from HrmAwardInfo where id = "+id);
	if(RecordSet.next()){
		rptitle = Util.null2String(RecordSet.getString("rptitle"));
	}
    para = ""+id;
	RecordSet.executeProc("HrmAwardInfo_Delete",para);

      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Integer.parseInt(id));
      SysMaintenanceLog.setRelatedName(rptitle);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmAwardInfo_Delete,"+para);
      SysMaintenanceLog.setOperateItem("93");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

    AwardComInfo.removeAwardCache();
	response.sendRedirect("HrmAward.jsp");  
 }
%>