<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CustomerDeputizeBrandComInfo" class="weaver.crm.channel.CustomerDeputizeBrandComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
char separator = Util.getSeparator() ;

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
if(operation.equals("add")){
	if(!HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Add", user)){
    	response.sendRedirect("/notice/noright.jsp");
    	return;
	}
	RecordSet.executeSql("select 1 from CRM_CustomerDeputizeBrand where name='"+name+"' and description='"+description+"'");
	if(!RecordSet.next()){
		RecordSet.executeSql("insert into CRM_CustomerDeputizeBrand (name,description) values ('"+name+"','"+description+"')");
		int id=0;
		RecordSet.executeSql("Select max(ID) as ID From CRM_CustomerDeputizeBrand");
		if(RecordSet.next()){
			id = RecordSet.getInt(1);
		}
	     
		SysMaintenanceLog.resetParameter();
	    SysMaintenanceLog.setRelatedId(id);
	    SysMaintenanceLog.setRelatedName(name);
	    SysMaintenanceLog.setOperateType("1");
	    SysMaintenanceLog.setOperateDesc("CRM_CustomerDeputizeBrand_Insert," + name + separator + description);
	    SysMaintenanceLog.setOperateItem("150");
	    SysMaintenanceLog.setOperateUserid(user.getUID());
	    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	    SysMaintenanceLog.setSysLogInfo();

	    CustomerDeputizeBrandComInfo.removeCache();
	}
 	response.sendRedirect("CustomerDeputizeBrandList.jsp");
 }
 
else if(operation.equals("edit")){
	if(!HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Edit", user)){
    	response.sendRedirect("/notice/noright.jsp");
    	return;
	}
  	int id = Util.getIntValue(request.getParameter("id"));
	
  	RecordSet.executeSql("select 1 from CRM_CustomerDeputizeBrand where name='"+name+"' and description='"+description+"' and id <>"+id);
  	if(!RecordSet.next()){
  		RecordSet.executeSql("update CRM_CustomerDeputizeBrand set name='"+name+"',description='"+description+"' where id="+id);
  		
  		String para = ""+id + separator + name + separator + description;
  		SysMaintenanceLog.resetParameter();
  	    SysMaintenanceLog.setRelatedId(id);
  	    SysMaintenanceLog.setRelatedName(name);
  	    SysMaintenanceLog.setOperateType("2");
  	    SysMaintenanceLog.setOperateDesc("CRM_CustomerDeputizeBrand_Update,"+para);
  	    SysMaintenanceLog.setOperateItem("150");
  	    SysMaintenanceLog.setOperateUserid(user.getUID());
  	    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
  	    SysMaintenanceLog.setSysLogInfo();  

  	  CustomerDeputizeBrandComInfo.removeCache();
  	}
	
 	response.sendRedirect("CustomerDeputizeBrandList.jsp");
 }
 else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("CustomerChannelBaseMaint:Delete", user)){
    	response.sendRedirect("/notice/noright.jsp");
    	return;
	}
  	int id = Util.getIntValue(request.getParameter("id"));
	
  	RecordSet.executeSql("select 1 from  CRM_CustomerChannelInfo where deputizeBrandId = "+id);
  	if(RecordSet.next()){
  		response.sendRedirect("CustomerIntentEdit.jsp?id=" + id + "&msgid=37");
		return;
  	}else{
  		RecordSet.executeSql("delete from CRM_CustomerDeputizeBrand where id = "+id);
  		
  		SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(id);
        SysMaintenanceLog.setRelatedName(name);
        SysMaintenanceLog.setOperateType("3");
        SysMaintenanceLog.setOperateDesc("CRM_CustomerDeputizeBrand_Delete,"+id);
        SysMaintenanceLog.setOperateItem("150");
        SysMaintenanceLog.setOperateUserid(user.getUID());
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();
        
        CustomerDeputizeBrandComInfo.removeCache();
        response.sendRedirect("CustomerDeputizeBrandList.jsp");
        return;
  	}
 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">