<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}
FileUpload fu = new FileUpload(request);
String isDialog = Util.null2String(fu.getParameter("isdialog"));
String backto = Util.null2String(fu.getParameter("backto"));//返回类型
String operation = Util.fromScreen(fu.getParameter("operation"),user.getLanguage());
String id = Util.fromScreen(fu.getParameter("id"),user.getLanguage());
String name = Util.fromScreen(fu.getParameter("name"),user.getLanguage());
String path = Util.fromScreen(fu.getParameter("path"),user.getLanguage());
int userid = user.getUID();
String createdate = TimeUtil.getCurrentTimeString();
char separator = Util.getSeparator() ;
if(operation.equals("add")){
	RecordSet.executeSql("insert into exp_localdetail(name,path,createdate,creator) values('"+name+"','"+path+"','"+createdate+"',"+userid+")");
	
	int maxid=0;
	RecordSet.executeSql("select  max(id) from exp_localdetail");
	if(RecordSet.next()){
	maxid = RecordSet.getInt(1);
	}

	String para = name +separator+ path +separator + createdate +separator + userid ;
	 SysMaintenanceLog.resetParameter();
     SysMaintenanceLog.setRelatedId(maxid);
     SysMaintenanceLog.setRelatedName(name);
     SysMaintenanceLog.setOperateType("1");
     SysMaintenanceLog.setOperateDesc("exp_localdetail_Insert,"+para);
     SysMaintenanceLog.setOperateItem("160");
     SysMaintenanceLog.setOperateUserid(user.getUID());
     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
     SysMaintenanceLog.setSysLogInfo();
}
else if(operation.equals("edit")){
	RecordSet.execute("update exp_localdetail set createdate = '"+createdate+"',name = '"+name+"',path = '"+path+"',creator = "+userid+" where id= "+id);

	String para = id+separator+name +separator+ path +separator + createdate +separator + userid ;
	  SysMaintenanceLog.resetParameter();
     SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
     SysMaintenanceLog.setRelatedName(name);
     SysMaintenanceLog.setOperateType("2");
     SysMaintenanceLog.setOperateDesc("exp_localdetail_Update,"+para);
     SysMaintenanceLog.setOperateItem("160");
     SysMaintenanceLog.setOperateUserid(user.getUID());
     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
     SysMaintenanceLog.setSysLogInfo();
}
else if(operation.equals("delete")){
	List ids = Util.TokenizerString(id,",");
	if(null!=ids&&ids.size()>0)	{
		for(int i = 0;i<ids.size();i++)		{
			String tempsysid = Util.null2String((String)ids.get(i));
			String tempworkflowname="";
			RecordSet.execute("select *  from exp_localdetail where id = "+tempsysid);
			if(RecordSet.next()){
				tempworkflowname=Util.null2String(RecordSet.getString("name")) ;
			}
			if(!"".equals(tempsysid))			
			{
				RecordSet.execute("delete from exp_localdetail where id = "+tempsysid);
				 String para =""+tempsysid;
				 SysMaintenanceLog.resetParameter();
			     SysMaintenanceLog.setRelatedId(Util.getIntValue(tempsysid));
			     SysMaintenanceLog.setRelatedName(tempworkflowname);
			     SysMaintenanceLog.setOperateType("3");
			     SysMaintenanceLog.setOperateDesc("exp_localdetail_delete,"+para);
			     SysMaintenanceLog.setOperateItem("160");
			     SysMaintenanceLog.setOperateUserid(user.getUID());
			     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			     SysMaintenanceLog.setSysLogInfo();
			}
		}
	}
}
if("1".equals(isDialog)){
%>
<script language=javascript >
try{
	//var parentWin = parent.getParentWindow(window);
	var parentWin = parent.parent.getParentWindow(parent);
	parentWin.location.href="ExpLocalDetail.jsp?backto=<%=backto%>";
	parentWin.closeDialog();
}
catch(e){
}
</script>
<%
}
else
response.sendRedirect("ExpLocalDetail.jsp?backto="+backto);
%>