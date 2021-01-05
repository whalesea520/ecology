<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OfsWorkflowService" class="weaver.ofs.service.OfsWorkflowService" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
//FileUpload fu = new FileUpload(request);
String isDialog = Util.null2String(request.getParameter("isdialog"));//返回类型
String backto = Util.null2String(request.getParameter("backto"));//返回类型
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String sysid = Util.fromScreen(request.getParameter("sysid"),user.getLanguage());
String workflowid = Util.fromScreen(request.getParameter("id"),user.getLanguage());

String wftypename = Util.fromScreen(request.getParameter("workflowname"),user.getLanguage());
int receivewfdata = Util.getIntValue(request.getParameter("receivewfdata"),0);
String cancel= Util.fromScreen(request.getParameter("cancel"),user.getLanguage());

String creator= user.getUID()+"";

String createdate = TimeUtil.getCurrentDateString();
String createtime= TimeUtil.getOnlyCurrentTimeString();
String modifier= user.getUID()+"";
String modifydate= TimeUtil.getCurrentDateString();
String modifytime = TimeUtil.getOnlyCurrentTimeString();

char separator = Util.getSeparator() ;

String maxId=workflowid;

Map<String,String> ofswftype = new HashMap<String,String>() ;

ofswftype.put("workflowid",workflowid);
ofswftype.put("sysid",sysid);
ofswftype.put("workflowname",wftypename);
ofswftype.put("receivewfdata",String.valueOf(receivewfdata));
ofswftype.put("cancel",cancel);
ofswftype.put("creator",creator);
ofswftype.put("createdate",createdate);
ofswftype.put("createtime",createtime);
ofswftype.put("modifier",modifier);
ofswftype.put("modifydate",modifydate);
ofswftype.put("modifytime",modifytime);

if(operation.equals("add")){
	boolean istrue = OfsWorkflowService.insert(ofswftype);
	String para = sysid + separator + wftypename + separator + receivewfdata + separator + 
	cancel+ separator + creator;
	if(istrue){
	     RecordSet.executeSql("select workflowid from ofs_workflow where sysid='"+sysid+"'");
	     RecordSet.next();
	     maxId = RecordSet.getString(1);
		 SysMaintenanceLog.resetParameter();
	     SysMaintenanceLog.setRelatedId(Util.getIntValue(sysid));
	     SysMaintenanceLog.setRelatedName(wftypename);
	     SysMaintenanceLog.setOperateType("1");
	     SysMaintenanceLog.setOperateDesc(maxId+",ofs_workflow_Insert,"+para);
	     SysMaintenanceLog.setOperateItem("165");
	     SysMaintenanceLog.setOperateUserid(user.getUID());
	     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	     SysMaintenanceLog.setSysLogInfo();
	}
	
}else if(operation.equals("edit")){
	boolean istrue = OfsWorkflowService.update(ofswftype);
	if(istrue){
		String para = sysid + separator + wftypename + separator + receivewfdata + separator + 
		cancel+ separator + creator;
		
		 SysMaintenanceLog.resetParameter();
		 SysMaintenanceLog.setRelatedId(Util.getIntValue(sysid));
		 SysMaintenanceLog.setRelatedName(wftypename);
		 SysMaintenanceLog.setOperateType("2");
		 SysMaintenanceLog.setOperateDesc(workflowid+",ofs_workflow_Update,"+para);
		 SysMaintenanceLog.setOperateItem("165");
		 SysMaintenanceLog.setOperateUserid(user.getUID());
		 SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		 SysMaintenanceLog.setSysLogInfo();
	}
 }
else if(operation.equals("delete")){
	List ids = Util.TokenizerString(workflowid,",");
	if(null!=ids&&ids.size()>0)	{
		for(int i = 0;i<ids.size();i++){
			String tempid = Util.null2String((String)ids.get(i));
			if(!"".equals(tempid)){
				 SysMaintenanceLog.resetParameter();
			     SysMaintenanceLog.setRelatedId(Util.getIntValue(sysid));
			     SysMaintenanceLog.setRelatedName(OfsWorkflowService.getOneBean(Util.getIntValue(tempid)).getWorkflowname());
			     SysMaintenanceLog.setOperateType("3");
			     SysMaintenanceLog.setOperateDesc(tempid+",ofs_workflow_delete");
			     SysMaintenanceLog.setOperateItem("165");
			     SysMaintenanceLog.setOperateUserid(user.getUID());
			     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			     SysMaintenanceLog.setSysLogInfo();
				 OfsWorkflowService.delete(Util.getIntValue(tempid));
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
	parentWin.location.href="/integration/ofs/OfsInfoWorkflowList.jsp?urlType=2&backto=<%=backto%>&operation=<%=operation%>&sysid=<%=sysid%>";
	parentWin.closeDialog();
}
catch(e){
}
</script>
<%
}
else
response.sendRedirect("/integration/ofs/OfsInfoWorkflowList.jsp?urlType=2&backto="+backto+"&operation="+operation+"&sysid="+sysid);
%>