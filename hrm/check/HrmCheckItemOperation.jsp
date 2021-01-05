<%@ page import="java.security.*,weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-27 [E7 to E8] -->
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckItemComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<%

String operation = Util.null2String(request.getParameter("operation")); 
String id = Util.null2String(request.getParameter("id"));  
String checkitemname = Util.fromScreen(request.getParameter("checkitemname"),user.getLanguage());/*奖惩标题*/
String checkitemexplain =    Util.fromScreen(request.getParameter("checkitemexplain"),user.getLanguage());/*员工id*/

char separator = Util.getSeparator() ;  
String para = "" ;  
   
if(operation.equalsIgnoreCase("add")){   
    para =checkitemname + separator + checkitemexplain ;
    
    rs.executeProc("HrmCheckItem_Insert",para);
    
     String sql="select max(id) from HrmCheckItem ";
	  rs.executeSql(sql) ;
	  rs.next();
	  id = rs.getString(1);
    CheckItemComInfo.removeCheckCache() ;
	SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(checkitemname);
      SysMaintenanceLog.setOperateType("1");
      SysMaintenanceLog.setOperateDesc("HrmCheckItem_Insert"+para);
      SysMaintenanceLog.setOperateItem("96");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	  response.sendRedirect("HrmCheckItemAdd.jsp?isclose=1");    
      return;
}
else if(operation.equals("edit")){
    if(!HrmUserVarify.checkUserRight("HrmCheckItemEdit:Edit", user)){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
 
    para =""+id + separator + checkitemname + separator + checkitemexplain ;
 
    RecordSet.executeProc("HrmCheckItem_Update",para);
    CheckItemComInfo.removeCheckCache() ;
	SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(checkitemname);
      SysMaintenanceLog.setOperateType("2");
      SysMaintenanceLog.setOperateDesc("HrmCheckItem_Update"+para);
      SysMaintenanceLog.setOperateItem("96");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();
	  response.sendRedirect("HrmCheckItemEdit.jsp?isclose=1");
	  return;
}
else if(operation.equals("delete")){
    if(!HrmUserVarify.checkUserRight("HrmCheckItemEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	String sql2="select COUNT(*) AS Nums from HrmCheckKindItem where checkitemid="+id;
  	rs.executeSql(sql2);
	int existNums=0;      
	if(rs.next()){
		existNums=Util.getIntValue(rs.getString(1),0);
	}
	if(existNums>0){
	
		response.sendRedirect("HrmCheckItemEdit.jsp?isDelete=no&id="+id);
		return;
	}else{
	
		rs.executeSql("select checkitemname from HrmCheckItem where id = "+id);
		if(rs.next()){
			checkitemname = Util.null2String(rs.getString("checkitemname"));
		}
		para = ""+id;
		rs.executeProc("HrmCheckItem_Delete",para);
    para = ""+id;
	RecordSet.executeProc("HrmCheckItem_Delete",para);
	CheckItemComInfo.removeCheckCache() ;
	SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
      SysMaintenanceLog.setRelatedName(checkitemname);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("HrmCheckItem_Delete"+para);
      SysMaintenanceLog.setOperateItem("96");
      SysMaintenanceLog.setOperateUserid(user.getUID());
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	  response.sendRedirect("HrmCheckItem.jsp");
	  return;
	}
}

CheckItemComInfo.removeCheckCache() ;
response.sendRedirect("/hrm/check/HrmCheckItem.jsp");
%>