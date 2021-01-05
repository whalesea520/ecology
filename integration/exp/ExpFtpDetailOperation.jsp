<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>

<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
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
String adress = Util.fromScreen(fu.getParameter("adress"),user.getLanguage());
String port = Util.fromScreen(fu.getParameter("port"),user.getLanguage());
String path = Util.fromScreen(fu.getParameter("path"),user.getLanguage());
String ftpuser = Util.fromScreen(fu.getParameter("ftpuser"),user.getLanguage());
String ftppwd = Util.fromScreen(fu.getParameter("ftppwd"),user.getLanguage());
String createdate = TimeUtil.getCurrentTimeString();
int userid = user.getUID();
char separator = Util.getSeparator() ;
/*QC295960 [80][90]流程归档集成-解决归档配置中FTP配置名称可重复的问题 start */
int sum=0;
String queryString=request.getQueryString();
String oldname = Util.fromScreen(fu.getParameter("oldname"),user.getLanguage());
/*QC295960 [80][90]流程归档集成-解决归档配置中FTP配置名称可重复的问题 end */
if(operation.equals("add")){
	/*QC295960 [80][90]流程归档集成-解决归档配置中FTP配置名称可重复的问题 start */
   rs.executeSql("select * from exp_ftpdetail where name = '" + name+"'");
   if(rs.next()){
      response.sendRedirect("ExpFtpDetailAdd.jsp?"+queryString+"&name="+name+"&backto="+backto+"&isDialog="+isDialog);
   
   }else{
	RecordSet.executeSql("insert into exp_ftpdetail(name,adress,port,path,ftpuser,ftppwd,createdate,creator) values('"+name+"','"+adress+"','"+port+"','"+path+"','"+ftpuser+"','"+ftppwd+"','"+createdate+"',"+userid+")");

	
	int maxid=0;
	RecordSet.executeSql("select  max(id) from exp_ftpdetail");
	if(RecordSet.next()){
	maxid = RecordSet.getInt(1);
	}

	String para = name +separator+ adress +separator + port +separator + path +separator + ftpuser  +separator+ ftppwd  +separator+ 
	createdate+ separator+ userid;
	 SysMaintenanceLog.resetParameter();
     SysMaintenanceLog.setRelatedId(maxid);
     SysMaintenanceLog.setRelatedName(name);
     SysMaintenanceLog.setOperateType("1");
     SysMaintenanceLog.setOperateDesc("exp_ftpdetail_Insert,"+para);
     SysMaintenanceLog.setOperateItem("159");
     SysMaintenanceLog.setOperateUserid(user.getUID());
     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
     SysMaintenanceLog.setSysLogInfo();
	} 
   /*QC295960 [80][90]流程归档集成-解决归档配置中FTP配置名称可重复的问题 end */
}
else if(operation.equals("edit")){
	/*QC295960 [80][90]流程归档集成-解决归档配置中FTP配置名称可重复的问题 start */
     rs.executeSql("select * from exp_ftpdetail where name = '" + name+"' and name <> '"+oldname+"'");
  
    if(rs.next()){
       sum+=1;
    }
    if(sum!=0){
        response.sendRedirect("ExpFtpDetailEdit.jsp?"+queryString+"&id="+id+"&backto="+backto+"&sum="+sum+"&name="+name);
		return;
    }
    /*QC295960 [80][90]流程归档集成-解决归档配置中FTP配置名称可重复的问题 end */
	RecordSet.execute("update exp_ftpdetail set createdate = '"+createdate+"',name = '"+name+"',adress = '"+adress+"',port = '"+port+"',path = '"+path+"',ftpuser = '"+ftpuser+"',ftppwd = '"+ftppwd+"',creator = "+userid+" where id= "+id);
	String para = id+separator+name +separator+ adress +separator + port +separator + path +separator + ftpuser  +separator+ ftppwd  +separator+ 
	createdate+ separator+ userid;
	  SysMaintenanceLog.resetParameter();
     SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
     SysMaintenanceLog.setRelatedName(name);
     SysMaintenanceLog.setOperateType("2");
     SysMaintenanceLog.setOperateDesc("exp_ftpdetail_Update,"+para);
     SysMaintenanceLog.setOperateItem("159");
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
			RecordSet.execute("select *  from exp_ftpdetail where id = "+tempsysid);
			if(RecordSet.next()){
				tempworkflowname=Util.null2String(RecordSet.getString("name")) ;
			}
			
			if(!"".equals(tempsysid))			{
				RecordSet.execute("delete from exp_ftpdetail where id = "+tempsysid);
				 String para =""+tempsysid;
				 SysMaintenanceLog.resetParameter();
			     SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
			     SysMaintenanceLog.setRelatedName(tempworkflowname);
			     SysMaintenanceLog.setOperateType("3");
			     SysMaintenanceLog.setOperateDesc("exp_ftpdetail_delete,"+para);
			     SysMaintenanceLog.setOperateItem("159");
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
	parentWin.location.href="ExpFtpDetail.jsp?backto=<%=backto%>";
	parentWin.closeDialog();
}
catch(e){
}
</script>
<%
}
else
response.sendRedirect("ExpFtpDetail.jsp?backto="+backto);
%>