
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
								 weaver.hrm.settings.ChgPasswdReminder,
                 weaver.hrm.settings.RemindSettings," %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
out.clear();
String cmd = Util.null2String(request.getParameter("cmd"));
ChgPasswdReminder reminder=new ChgPasswdReminder();
RemindSettings settings=reminder.getRemindSettings();
if(cmd.equals("synusbsetdefault")){
	//设置动态USB
	int needusb = Util.getIntValue(request.getParameter("needusb"),0);
	String needusbdefault=request.getParameter("needusbdefault");
	settings.setNeedusbdefault(needusbdefault);
	rs.executeSql("update HrmResource set needusb="+needusb+",usbstate="+Util.getIntValue(needusbdefault,0));
} else if(cmd.equals("synusbsetdefaultHt")){
	//海泰key
	int needusbHt = Util.getIntValue(request.getParameter("needusbHt"),0);
	String needusbdefaultHt = Util.null2String(request.getParameter("needusbdefaultHt"));
	settings.setNeedusbdefaultHt(needusbdefaultHt);
	//2015-02-04 modify by lvyi 增加 批量启用海泰key 只启用之前使用过海泰的限制 and serial is not null and serial<>'' 
	rs.executeSql("update HrmResource set needusb="+needusbHt+",usbstate="+Util.getIntValue(needusbdefaultHt,0)+" where userUsbType = 2 and serial is not null and serial<>'' ");
	rs.executeSql("update HrmResourceManager set usbstate="+Util.getIntValue(needusbdefaultHt,0)+" where userUsbType = 2 and serial is not null and serial<>'' ");
} else if(cmd.equals("synusbsetdefaultDt")){
	//动态令牌
	//2015-02-04 modify by lvyi 增加 批量启用动态令牌 只启用之前使用过动态令牌的限制 and tokenkey is not null and tokenkey<>'' 
	int needusbDt = Util.getIntValue(request.getParameter("needusbDt"),0);
	String needusbdefaultDt = Util.null2String(request.getParameter("needusbdefaultDt"));
	settings.setNeedusbdefaultDt(needusbdefaultDt);
	rs.executeSql("update HrmResource set needusb="+needusbDt+",usbstate="+Util.getIntValue(needusbdefaultDt,0)+" where userUsbType = 3 and tokenkey is not null and tokenkey<>'' ");
	rs.executeSql("update HrmResourceManager set usbstate="+Util.getIntValue(needusbdefaultDt,0)+" where userUsbType = 3 and tokenkey is not null and tokenkey<>'' ");
} else if(cmd.equals("syndynapassdefault")){
	//设置动态密码
	int needdynapass = Util.getIntValue(request.getParameter("needdynapass"),0);
	int needdynapassdefault=Util.getIntValue(request.getParameter("needdynapassdefault"),0);
	settings.setNeeddynapassdefault(needdynapassdefault);
	rs.executeSql("update HrmResource set needdynapass="+needdynapass+", usbstate="+needdynapassdefault+", passwordstate="+needdynapassdefault+" where (userUsbType = 4 or needdynapass = 1 )");
	rs.executeSql("update HrmResourceManager set usbstate="+needdynapassdefault+" where userUsbType = 4");
} else if(cmd.equals("SynMobileShowSet")){
	//更新默认值
	String mobileShowTypeDefault=Util.null2String(request.getParameter("mobileShowTypeDefault"),"0");
	settings.setMobileShowTypeDefault(mobileShowTypeDefault);
	rs.executeSql("update HrmResource set mobileShowType="+Util.getIntValue(mobileShowTypeDefault));
	ResourceComInfo resourceComInfo = new ResourceComInfo();
	resourceComInfo.removeResourceCache();
} else if(cmd.equals("synusbsetdefaultCA")){
	//设置CA
	String needCA = Util.null2String(request.getParameter("needCA"));
	String needCADefault=Util.null2String(request.getParameter("needCADefault"));
	settings.setNeedcadefault(needCADefault) ;
	rs.executeSql("update HrmResource set needusb="+needCA+",usbstate="+needCADefault+" where userUsbType = 21 and serial is not null and serial<>'' ");
	rs.executeSql("update HrmResourceManager set usbstate="+needCADefault+" where userUsbType = 21 and serial is not null and serial<>'' ");
}
reminder.setRemindSettings(settings);
application.setAttribute("hrmsettings",settings);
%>
	