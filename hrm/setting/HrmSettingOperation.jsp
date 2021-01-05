
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.file.FileUpload"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
                 weaver.hrm.settings.ChgPasswdReminder,
                 weaver.hrm.settings.RemindSettings,
                 weaver.login.AuthenticUtil,java.io.*" %>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.usb.UsbKeyProxy"%>
<jsp:useBean id="VerifyPasswdCheck" class="weaver.login.VerifyPasswdCheck" scope="page" />
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

char separator = Util.getSeparator() ;
FileUpload fu = new FileUpload(request);
String cmd = Util.null2String(fu.getParameter("cmd"));
//更新字段
ChgPasswdReminder reminder=new ChgPasswdReminder();
RemindSettings settings=reminder.getRemindSettings();

if(!HrmUserVarify.checkUserRight("OtherSettings:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");
	return  ;
}

if(cmd.equals("birthSave")){
	String birthremindperiod = Util.fromScreen(fu.getParameter("birthremindperiod"),user.getLanguage());
	String birthvalid = Util.fromScreen(fu.getParameter("birthvalid"),user.getLanguage());
	String congratulation = Util.fromScreen(fu.getParameter("congratulation"),user.getLanguage());
	String congratulation1 = Util.fromScreen(fu.getParameter("congratulation1"),user.getLanguage());
	String birthremindmode = Util.fromScreen(fu.getParameter("birthremindmode"),user.getLanguage());
	String birthdialogstyle = Util.fromScreen(fu.getParameter("birthdialogstyle"),user.getLanguage());
	
	String[] birthshowfields = fu.getParameterValues("birthshowfield");
	String brithalarmscope = Util.fromScreen(fu.getParameter("brithalarmscope"),user.getLanguage());
	String birthvalidadmin = Util.fromScreen(fu.getParameter("birthvalidadmin"),user.getLanguage());
	
	settings.setBirthremindperiod(birthremindperiod);
	settings.setBirthvalid(birthvalid);
	settings.setCongratulation(congratulation);
	settings.setCongratulation1(congratulation1);
	settings.setBirthremindmode(birthremindmode);
	settings.setBirthdialogstyle(birthdialogstyle);
	String birthshowfield = "";
	for(int i=0;birthshowfields!=null&&i<birthshowfields.length;i++){
		if(birthshowfield.length()>0)birthshowfield+=",";
		birthshowfield+=birthshowfields[i];
	}
	settings.setBirthshowfield(birthshowfield);
	settings.setBrithalarmscope(brithalarmscope);
	settings.setBirthvalidadmin(birthvalidadmin);
}
if(cmd.equals("contractSave")){
	String contractvalid = Util.fromScreen(fu.getParameter("contractvalid"),user.getLanguage());
	String contractremindperiod = Util.fromScreen(fu.getParameter("contractremindperiod"),user.getLanguage());
	String statusWithContract = Util.fromScreen(fu.getParameter("statusWithContract"),user.getLanguage());
	settings.setContractvalid(contractvalid);
	settings.setContractremindperiod(contractremindperiod);
	settings.setStatusWithContract(statusWithContract);
}
 
if(cmd.equals("enterSave")){
	String entervalid = Util.fromScreen(fu.getParameter("entervalid"),user.getLanguage());
	settings.setEntervalid(entervalid);
}
if(cmd.equals("SecurityAdSave")){
	String needusb = Util.fromScreen(fu.getParameter("needusb"),user.getLanguage());
	String needusbdefault = Util.fromScreen(fu.getParameter("needusbdefault"),user.getLanguage());
	String needusbnetwork = Util.fromScreen(fu.getParameter("needusbnetwork"),user.getLanguage());//是否启用usb网段策略
	String usbType = Util.fromScreen(fu.getParameter("usbType"),user.getLanguage());
	String firmcode = Util.fromScreen(fu.getParameter("firmcode"),user.getLanguage());
	String usercode = Util.fromScreen(fu.getParameter("usercode"),user.getLanguage());
	
	int needdynapass=Util.getIntValue(fu.getParameter("needdynapass"),0);
	int needdynapassdefault=Util.getIntValue(fu.getParameter("needdynapassdefault"),0);
	int dynapasslen=Util.getIntValue(fu.getParameter("dynapasslen"),0);
	String dypadcon=Util.fromScreen(fu.getParameter("dypadcon"),user.getLanguage());//动态密码内容
	String validitySec = Util.fromScreen(fu.getParameter("validitySec"),user.getLanguage());
	
	String needusbHt = Util.fromScreen(fu.getParameter("needusbHt"),user.getLanguage());
	String needusbdefaultHt = Util.fromScreen(fu.getParameter("needusbdefaultHt"),user.getLanguage());
	String needusbDt = Util.fromScreen(fu.getParameter("needusbDt"),user.getLanguage());
	String needusbdefaultDt = Util.fromScreen(fu.getParameter("needusbdefaultDt"),user.getLanguage());
	
	String needCa =  Util.fromScreen(fu.getParameter("needCA"),user.getLanguage());
	String needCADefault =  Util.fromScreen(fu.getParameter("needCADefault"),user.getLanguage());
	String cetificatePath =  Util.fromScreen(fu.getParameter("cetificatePath"),user.getLanguage());
	
	settings.setNeeddynapass(needdynapass);
	settings.setNeeddynapassdefault(needdynapassdefault);
	settings.setDynapasslen(dynapasslen);
	settings.setDypadcon(dypadcon);    
	settings.setValiditySec(validitySec);
	settings.setNeedusbHt(needusbHt);
	settings.setNeedusbdefaultHt(needusbdefaultHt);
	settings.setNeedusbDt(needusbDt);
	settings.setNeedusbdefaultDt(needusbdefaultDt);
	
	settings.setNeedca(needCa) ;
	settings.setNeedcadefault(needCADefault) ;
	settings.setCetificatePath(cetificatePath) ;

	// 若开启动态密码保护，则更新人力资源表中所有在职人员的状态
	//modify by lvyi 2017-11-20,人员表状态只有在点击同步按钮时才能同步，保存设置不需要同步
	//RecordSet.executeUpdate("Update Hrmresource set needdynapass=? where status in(0,1,2,3)", needdynapass);
	if(needusb==null||!needusb.equals("1")){
		RemindSettings old_settings=(RemindSettings)application.getAttribute("hrmsettings");
		settings.setNeedusb(needusb);
		settings.setNeedusbdefault(old_settings.getNeedusbdefault());
		settings.setUsbType(old_settings.getUsbType());
		settings.setFirmcode(old_settings.getFirmcode());
		settings.setUsercode(old_settings.getUsercode());
		settings.setNeedusbnetwork(old_settings.getNeedusbnetwork());
	}else{
		settings.setNeedusb(needusb);
		settings.setNeedusbdefault(needusbdefault);
		settings.setUsbType(usbType);
		settings.setFirmcode(firmcode);
		settings.setUsercode(usercode);
		settings.setNeedusbnetwork(needusbnetwork);
	}
	long l_firmcode=0;
	long l_usercode=0;

	if(needusb!=null&&needusb.equals("1") && usbType!=null && "1".equals(usbType)){
	try{
		l_firmcode=Long.parseLong(firmcode);
		l_usercode=Long.parseLong(usercode);
	}catch(Exception e){%>
	<script>
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23267,user.getLanguage())%>!");
		window.location = "advancedSet.jsp";
	</script>
	<%return;}
	boolean usbinstalled;
	try {
		String usbserver = Prop.getPropValue(GCONST.getConfigFile(), "usbserver.ip");
		if(usbserver!=null&&!usbserver.equals("")) {
						  UsbKeyProxy proxy=new UsbKeyProxy(usbserver);
						  usbinstalled=proxy.checkusb(l_firmcode,l_usercode);
						 }else
						  usbinstalled= AuthenticUtil.checkusb(l_firmcode,l_usercode);
	} catch (Throwable e) {
		usbinstalled=false;
	}
	if(usbinstalled){
		//在更新前清空所有数据
		reminder.setRemindSettings(settings);
	%>
	<script>
	  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16746,user.getLanguage())%>");
	  window.location = "advancedSet.jsp";
	</script>
	<%
	application.setAttribute("hrmsettings",settings);
	return;}else{%>
	<script>
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23268,user.getLanguage())%>!");
	  window.location = "advancedSet.jsp";
	</script>
	<%return;}}
	reminder.setRemindSettings(settings);
	application.setAttribute("hrmsettings",settings);
	%>
	<script>
		window.location = "advancedSet.jsp";
	</script>
<%
} else if(cmd.endsWith("SecuritySave")){
	
	String remindperiod = Util.fromScreen(fu.getParameter("remindperiod"),user.getLanguage());
	String valid = Util.fromScreen(fu.getParameter("valid"),user.getLanguage());
	String relogin = Util.fromScreen(fu.getParameter("relogin"),user.getLanguage());
	//System.out.println("o usbType = " + usbType);
	//add by sean.yang 2006-02-09 for TD3609
	int needvalidate=Util.getIntValue(fu.getParameter("needvalidate"),0);
	int validatetype=Util.getIntValue(fu.getParameter("validatetype"),0);
	int validatenum=Util.getIntValue(fu.getParameter("validatenum"),0);
	int numvalidatewrong=Util.getIntValue(fu.getParameter("numvalidatewrong"),0);
	//td5709,xiaofeng
	int minpasslen=Util.getIntValue(fu.getParameter("minpasslen"),0);
	String needdactylogram=Util.fromScreen(fu.getParameter("needdactylogram"),user.getLanguage());//是否需要使用维尔指纹验证设备登录认证功能
	String canmodifydactylogram=Util.fromScreen(fu.getParameter("canmodifydactylogram"),user.getLanguage());//是否允许客户端修改指纹

	String checkUnJob=Util.fromScreen(fu.getParameter("checkUnJob"),user.getLanguage());//非在职人员信息查看控制 启用后，只有有“离职人员查看”权限的用户才能检索非在职人员
	String checkSysValidate=Util.fromScreen(fu.getParameter("checkSysValidate"),user.getLanguage());//系统信息批量设置验证码控制 启用后，系统信息批量设置保存的时候需要输入验证码
	
	int ChangePasswordDays=Util.getIntValue(fu.getParameter("ChangePasswordDays"),7);
	int DaysToRemind=Util.getIntValue(fu.getParameter("DaysToRemind"),3);
	int PasswordChangeReminder=Util.getIntValue(fu.getParameter("PasswordChangeReminder"),0);
	//密码锁定
	int openPasswordLock = Util.getIntValue(Util.null2String(fu.getParameter("openPasswordLock")),0);
	//锁定密码错误次数
	int sumPasswordLock = Util.getIntValue(Util.null2String(fu.getParameter("sumPasswordLock")),3);
	String checkkey = Util.null2String(fu.getParameter("checkkey"));
	//密码复杂度
	int passwordComplexity = Util.getIntValue(Util.null2String(fu.getParameter("passwordComplexity")),0);
	
	String mobileShowSet = Util.null2String(fu.getParameter("mobileShowSet"));
	String mobileShowType[] = fu.getParameterValues("mobileShowType");
	String mobileShowTypeDefault = Util.null2String(fu.getParameter("mobileShowTypeDefault"));
	String mobileShowTypes = "";
	for(int i=0;mobileShowType!=null&&i<mobileShowType.length;i++){
		if(mobileShowTypes.length()>0)mobileShowTypes+=",";
		mobileShowTypes+=mobileShowType[i];
	}
	
	String loginMustUpPswd = Util.fromScreen(fu.getParameter("loginMustUpPswd"),user.getLanguage());
	String forbidLogin = Util.fromScreen(fu.getParameter("forbidLogin"),user.getLanguage());
	settings.setLoginMustUpPswd(loginMustUpPswd);
	settings.setForbidLogin(forbidLogin);
	settings.setChangePasswordDays(ChangePasswordDays+"");
	settings.setDaysToRemind(DaysToRemind+"");
	settings.setPasswordChangeReminder(PasswordChangeReminder+"");
	settings.setOpenPasswordLock(openPasswordLock+"");
	settings.setSumPasswordLock(sumPasswordLock+"");
	settings.setPasswordComplexity(passwordComplexity+"");

	settings.setRemindperiod(remindperiod);
	settings.setValid(valid);

	settings.setRelogin(relogin);

	//add by sean.yang 2006-02-09 for TD3609
	settings.setNeedvalidate(needvalidate);
	settings.setValidatetype(validatetype);
	settings.setValidatenum(validatenum);
	settings.setNumvalidatewrong(numvalidatewrong);
	//td5709,xiaofeng
	settings.setMinPasslen(minpasslen);
	

	settings.setNeedDactylogram(needdactylogram);
	settings.setCanModifyDactylogram(canmodifydactylogram);
	settings.setMobileShowSet(mobileShowSet);
	settings.setMobileShowType(mobileShowTypes);
	settings.setMobileShowTypeDefault(mobileShowTypeDefault);
	settings.setCheckkey(checkkey);
	settings.setCheckUnJob(checkUnJob);
	settings.setCheckSysValidate(checkSysValidate);
	
	//在更新前清空所有数据
	VerifyPasswdCheck.initPasswordLock(openPasswordLock,sumPasswordLock,passwordComplexity);
	
	reminder.setRemindSettings(settings);
	application.setAttribute("hrmsettings",settings);
%>
<script>
window.location = "HrmSecuritySetting.jsp";
</script>
<%
}else{

	//密码锁定
	int openPasswordLock = Util.getIntValue(Util.null2String(fu.getParameter("openPasswordLock")),0);
	//锁定密码错误次数
	int sumPasswordLock = Util.getIntValue(Util.null2String(fu.getParameter("sumPasswordLock")),3);
	//密码复杂度
	int passwordComplexity = Util.getIntValue(Util.null2String(fu.getParameter("passwordComplexity")),0);
	
	settings.setOpenPasswordLock(openPasswordLock+"");
	settings.setSumPasswordLock(sumPasswordLock+"");
	settings.setPasswordComplexity(passwordComplexity+"");
	
	//在更新前清空所有数据
	VerifyPasswdCheck.initPasswordLock(openPasswordLock,sumPasswordLock,passwordComplexity);
	reminder.setRemindSettings(settings);
	application.setAttribute("hrmsettings",settings);
	%>
<script>
    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16746,user.getLanguage())%>");
   	<%if(cmd.equals("birthSave")){%>
   	window.location = "BirthdaySetting.jsp";
   	<%}else if(cmd.equals("contractSave")){%>
   	window.location = "ContractSetting.jsp";
  	<%}else if(cmd.equals("enterSave")){%>
   	window.location = "EnterSetting.jsp";
   	<%}%>
</script>
<%}%>

