<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OfsSettingService" class="weaver.ofs.service.OfsSettingService" scope="page" />
<%
char separator = Util.getSeparator() ;
String isDialog = Util.null2String(request.getParameter("isdialog"));
String backto = Util.null2String(request.getParameter("backto"));//返回类型
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());

String isuse = Util.null2String(Util.getIntValue(request.getParameter("isuse"),0));//是否启用
String showsysname = Util.null2String(request.getParameter("showsysname"));//显示系统名称
String showdone = Util.null2String(request.getParameter("showdone"));//显示已办

String remindoa = Util.null2String(request.getParameter("remindoa"));//提醒到手机版
String remindim = Util.null2String(request.getParameter("remindim"));//提醒到IM
String remindapp = Util.null2String(request.getParameter("remindapp"));//提醒到手机版
int messagetypeid = Util.getIntValue(request.getParameter("messagetypeid"),0);//手机版消息类型

String oashortname = Util.null2String(request.getParameter("oashortname"));//提醒到手机版
String oafullname = Util.null2String(request.getParameter("oafullname"));//提醒到手机版

String remindemessage = Util.null2String(request.getParameter("remindemessage"));//提醒到emessage
String remindebridge = Util.null2String(request.getParameter("remindebridge"));//提醒到云桥
String remindebridgetemplate = Util.null2String(request.getParameter("remindebridgetemplate"));//提醒到云桥消息模板号

String modifier = user.getUID()+"";
String modifydate = TimeUtil.getCurrentDateString();
String modifytime = TimeUtil.getOnlyCurrentTimeString();

String sql = "";
HashMap<String,String> ofsparam = new HashMap();
ofsparam.put("isuse",isuse);
ofsparam.put("oashortname",oashortname);
ofsparam.put("oafullname",oafullname);
ofsparam.put("showsysname",showsysname);
ofsparam.put("showdone",showdone);
ofsparam.put("remindoa",remindoa);
ofsparam.put("remindim",remindim);
ofsparam.put("remindapp",remindapp);
ofsparam.put("messagetypeid",messagetypeid+"");
ofsparam.put("remindemessage",remindemessage);
ofsparam.put("remindebridge",remindebridge);
ofsparam.put("remindebridgetemplate",remindebridgetemplate);
ofsparam.put("creator",modifier);
ofsparam.put("createdate",modifydate);
ofsparam.put("createtime",modifytime);
ofsparam.put("modifier",modifier);
ofsparam.put("modifydate",modifydate);
ofsparam.put("modifytime",modifytime);
rs.execute("select * from  ofs_setting");
if(rs.next()){
	OfsSettingService.update(ofsparam);
}else{
	OfsSettingService.insert(ofsparam);
}
rs.execute(sql);

String para = isuse + separator + oashortname + separator + oafullname + separator + 
			showsysname+ separator + showdone + separator + remindoa + separator + 
			remindim+ separator + remindapp + separator + messagetypeid + separator + modifier + separator + 
			remindemessage + separator + remindebridge + separator + remindebridgetemplate + separator + 
			modifydate+ separator + modifytime + separator + modifier ;

SysMaintenanceLog.resetParameter();
SysMaintenanceLog.setRelatedId(0);
SysMaintenanceLog.setRelatedName(oashortname);
SysMaintenanceLog.setOperateType("2");
SysMaintenanceLog.setOperateDesc("Ofs_setting,"+para);
SysMaintenanceLog.setOperateItem("169");
SysMaintenanceLog.setOperateUserid(user.getUID());
SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
SysMaintenanceLog.setSysLogInfo();

if(!"1".equals(isDialog)){
response.sendRedirect("/integration/ofs/OfsSetting.jsp?backto="+backto);
}
else{
%>
<script language=javascript >
try{
	//var parentWin = parent.getParentWindow(window);
	var parentWin = parent.parent.getParentWindow(parent);
	parentWin.location.href="/integration/ofs/OfsSetting.jsp?backto=<%=backto%>";
	parentWin.closeDialog();
}
catch(e){
}
</script>
<%
}
%>