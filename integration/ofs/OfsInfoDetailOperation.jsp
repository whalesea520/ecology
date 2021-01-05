<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OfsSysInfoService" class="weaver.ofs.service.OfsSysInfoService" scope="page" />
<jsp:useBean id="OfsWorkflowService" class="weaver.ofs.service.OfsWorkflowService" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
//FileUpload fu = new FileUpload(request);
String isDialog = Util.null2String(request.getParameter("isdialog"));//返回类型
String backto = Util.null2String(request.getParameter("backto"));//返回类型
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String sysid = Util.fromScreen(request.getParameter("id"),user.getLanguage());

String syscode = Util.fromScreen(request.getParameter("syscode"),user.getLanguage());
String sysshortname= Util.fromScreen(request.getParameter("sysshortname"),user.getLanguage());
String sysfullname= Util.fromScreen(request.getParameter("sysfullname"),user.getLanguage());
String pcprefixurl= Util.fromScreen(request.getParameter("pcprefixurl"),user.getLanguage());
String appprefixurl= Util.fromScreen(request.getParameter("appprefixurl"),user.getLanguage());
String securityip= Util.fromScreen(request.getParameter("securityip"),user.getLanguage());
int autocreatewftype= Util.getIntValue(request.getParameter("autocreatewftype"),0);
int editwftype= Util.getIntValue(request.getParameter("editwftype"),0);
int receivewfdata= Util.getIntValue(request.getParameter("receivewfdata"),0);
int hrmtransrule= Util.getIntValue(request.getParameter("hrmtransrule"),0);
String hrmtransfiled = "id";
if(hrmtransrule == 0){
	hrmtransfiled = "id";
}else if(hrmtransrule == 1){
	hrmtransfiled = "loginid";
}else if(hrmtransrule == 2){
	hrmtransfiled = "workcode";
}else if(hrmtransrule == 3){
	hrmtransfiled = "idnum";
}else if(hrmtransrule == 4){
	hrmtransfiled = "email";
}
String cancel= "0";

String creator= user.getUID()+"";

String createdate = TimeUtil.getCurrentDateString();
String createtime= TimeUtil.getOnlyCurrentTimeString();
String modifier= user.getUID()+"";
String modifydate= TimeUtil.getCurrentDateString();
String modifytime = TimeUtil.getOnlyCurrentTimeString();

char separator = Util.getSeparator();

String tempOperation="";
String maxId=sysid;
if(operation.equals("addAndNext")){
	tempOperation=operation;
}
Map<String,String> ofsinfo = new HashMap<String,String>() ;
ofsinfo.put("sysid",sysid);
ofsinfo.put("syscode",syscode);
ofsinfo.put("sysshortname",sysshortname);
ofsinfo.put("sysfullname",sysfullname);
ofsinfo.put("securityip",securityip);
ofsinfo.put("pcprefixurl",pcprefixurl);
ofsinfo.put("appprefixurl",appprefixurl);
ofsinfo.put("autocreatewftype",String.valueOf(autocreatewftype));
ofsinfo.put("editwftype",String.valueOf(editwftype));
ofsinfo.put("receivewfdata",String.valueOf(receivewfdata));
ofsinfo.put("hrmtransrule",hrmtransfiled);
ofsinfo.put("cancel",cancel);
ofsinfo.put("creator",creator);
ofsinfo.put("createdate",createdate);
ofsinfo.put("createtime",createtime);
ofsinfo.put("modifier",modifier);
ofsinfo.put("modifydate",modifydate);
ofsinfo.put("modifytime",modifytime);

if(operation.equals("addAndNext") || operation.equals("add")){
	boolean istrue = OfsSysInfoService.insert(ofsinfo);
	if(istrue){
		RecordSet.execute("select sysid from ofs_sysinfo where syscode = '"+syscode+"'");
		if(RecordSet.next()){
			maxId = RecordSet.getString(1);
		}
		String para = syscode + separator + sysshortname + separator + sysfullname + separator + 
		pcprefixurl+ separator + appprefixurl + separator + securityip + separator + autocreatewftype + separator + 
		editwftype+ separator + receivewfdata + separator + hrmtransfiled + separator + 
		cancel+ separator + creator + separator + createdate + separator + 
		createtime+ separator + modifier + separator + modifydate + separator + modifytime;
		
		 SysMaintenanceLog.resetParameter();
	     SysMaintenanceLog.setRelatedId(Util.getIntValue(maxId));
	     SysMaintenanceLog.setRelatedName(sysshortname);
	     SysMaintenanceLog.setOperateType("1");
	     SysMaintenanceLog.setOperateDesc("Ofs_sysinfo_Insert,"+para);
	     SysMaintenanceLog.setOperateItem("164");
	     SysMaintenanceLog.setOperateUserid(user.getUID());
	     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	     SysMaintenanceLog.setSysLogInfo();
	}
	
}else if(operation.equals("edit")){
		boolean istrue = OfsSysInfoService.update(ofsinfo);
		if(receivewfdata == 0){//关闭接收流程数据将连带关系流程类型中所有配置
		    RecordSet.executeSql("update ofs_workflow set receivewfdata='0' where sysid="+sysid);
		}
		if(istrue){
			String para = syscode + separator + sysshortname + separator + sysfullname + separator + 
			pcprefixurl+ separator + appprefixurl + separator + securityip + separator + autocreatewftype + separator + 
			editwftype+ separator + receivewfdata + separator + hrmtransfiled + separator + 
			cancel+ separator + creator + separator + createdate + separator + 
			createtime+ separator + modifier + separator + modifydate + separator + modifytime;
			
			 SysMaintenanceLog.resetParameter();
		     SysMaintenanceLog.setRelatedId(Util.getIntValue(maxId));
		     SysMaintenanceLog.setRelatedName(sysshortname);
		     SysMaintenanceLog.setOperateType("2");
		     SysMaintenanceLog.setOperateDesc("Ofs_sysinfo_update,"+para);
		     SysMaintenanceLog.setOperateItem("164");
		     SysMaintenanceLog.setOperateUserid(user.getUID());
		     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		     SysMaintenanceLog.setSysLogInfo();
		}
		
}
else if(operation.equals("delete")){
	List ids = Util.TokenizerString(sysid,",");
	if(null!=ids&&ids.size()>0)	{
		for(int i = 0;i<ids.size();i++){
			String tempid = Util.null2String((String)ids.get(i));
			if(!"".equals(tempid)){
				 String tempworkflowname="";
				 
				 String para =""+tempid;
				 SysMaintenanceLog.resetParameter();
			     SysMaintenanceLog.setRelatedId(Util.getIntValue(tempid));
			     SysMaintenanceLog.setRelatedName(OfsSysInfoService.getOneBean(Util.getIntValue(tempid)).getSysshortname());
			     SysMaintenanceLog.setOperateType("3");
			     SysMaintenanceLog.setOperateDesc("Ofs_sysinfo_delete,"+para);
			     SysMaintenanceLog.setOperateItem("164");
			     SysMaintenanceLog.setOperateUserid(user.getUID());
			     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			     SysMaintenanceLog.setSysLogInfo();
			     OfsSysInfoService.delete(Util.getIntValue(tempid));
			     OfsWorkflowService.deletebysysid(Util.getIntValue(tempid));
			}
		}
	}
}else if(operation.equals("checkinput")){
	String field = Util.fromScreen(request.getParameter("field"),user.getLanguage());
	String values = Util.fromScreen(request.getParameter("values"),user.getLanguage());
	out.println("123");
}
if("1".equals(isDialog)){
%>
<script language=javascript >
try{
	//var parentWin = parent.getParentWindow(window);
	var parentWin = parent.parent.getParentWindow(parent);
	parentWin.location.href="/integration/ofs/OfsInfoList.jsp?backto=<%=backto%>&operation=<%=tempOperation%>&id=<%=maxId%>";
	parentWin.closeDialog();
}
catch(e){
}
</script>
<%
}
else
response.sendRedirect("/integration/ofs/OfsInfoList.jsp?backto="+backto+"&operation="+tempOperation+"&id="+maxId);
%>