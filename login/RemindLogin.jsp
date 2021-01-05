
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.settings.ChgPasswdReminder,weaver.hrm.settings.RemindSettings" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<!-- Modified by wcd 2014-12-23 [强制密码修改提醒更改为模态窗口、新增首次登录系统必须修改密码] -->
<%
	User user = HrmUserVarify.getUser (request , response) ;
%>
<html> 
	<head>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<SCRIPT language="javascript" type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></SCRIPT>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.cycle.all_wev8.js"></script>
		<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/jquery.qrcode_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/qrcode_wev8.js"></script>
		<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
		<link href="/css/commom_wev8.css" type="text/css" rel="stylesheet">
		<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
	</head>
<body> 
<%
	
	ChgPasswdReminder reminder=new ChgPasswdReminder();
	RemindSettings settings=reminder.getRemindSettings();
	String RedirectFile = Util.null2String(request.getParameter("RedirectFile")) ;
	String gopage = Util.null2String(request.getParameter("gopage")) ;
	
	if(!"".equals(gopage)){
		RedirectFile = RedirectFile+ "&gopageOrientation="+gopage+"&gopage="+gopage;
	}
	String loginMustUpPswd = Util.null2String(settings.getLoginMustUpPswd());
	String PasswordChangeReminderstr = Util.null2String(settings.getPasswordChangeReminder());
	boolean PasswordChangeReminder = false;
	if("1".equals(PasswordChangeReminderstr)){
		PasswordChangeReminder = true;
	}
	int passwdReminder = 0;
	if(PasswordChangeReminder){
		passwdReminder = 1;
	}
	String ChangePasswordDays = settings.getChangePasswordDays();
	String DaysToRemind = settings.getDaysToRemind();
	int id = user.getUID();
	String passwdchgdate = "";
	int passwdchgeddate = 0;
	int passwdreminddatenum = 0;
	int passwdelse = 0;
	String passwdreminddate = "";
	String canpass = "0";
	String canremind = "0";
	
	boolean isUpPswd = false;
	if("1".equals(loginMustUpPswd)){
		RecordSet.executeSql("select COUNT(id) from HrmSysMaintenanceLog where relatedid = "+id+" and operatetype = 6 and operateitem = 60 and exists (select 1 from HrmResource where id = "+id+") and CAST(operatedesc as varchar"+(RecordSet.getDBType().equals("oracle")?"2":"")+"(100)) = 'y'");
		if(RecordSet.next()) isUpPswd = RecordSet.getInt(1) <= 0;
	}
	if(user.isAdmin()){
		response.sendRedirect(RedirectFile);
		return;
	}
	String isadaccount="";
	RecordSet.executeSql("select isadaccount from HrmResource where id = "+id);
	if(RecordSet.next()){
		isadaccount=Util.null2String(RecordSet.getString("isadaccount"));
	}
	if(isadaccount.equals("1")){  //ad用户 不用提醒
		response.sendRedirect(RedirectFile);
		return;
	}
	
	if(!isUpPswd){
		if(PasswordChangeReminder){
			RecordSet.executeSql("select passwdchgdate from hrmresource where id = "+id);
			if(RecordSet.next()){
				passwdchgdate = RecordSet.getString(1);
				passwdchgeddate = TimeUtil.dateInterval(passwdchgdate,TimeUtil.getCurrentDateString());
				
				if(passwdchgeddate<Integer.parseInt(ChangePasswordDays)){
					canpass = "1";
				}
				passwdreminddate = TimeUtil.dateAdd(passwdchgdate,Integer.parseInt(ChangePasswordDays)-Integer.parseInt(DaysToRemind));
				try {
					passwdreminddatenum = TimeUtil.dateInterval(passwdreminddate,TimeUtil.getCurrentDateString());
				} catch(Exception ex) {
					passwdreminddatenum = 0;
				}
				passwdelse = Integer.parseInt(DaysToRemind) - passwdreminddatenum;
				if(passwdreminddatenum>=0){
					canremind = "1";
				}
			}else{
				response.sendRedirect(RedirectFile);
				return;
			}
		}else{
			response.sendRedirect(RedirectFile);
			return;
		}
	}
	
%>
</body>
</html>
<script language="javascript">
var passwdReminder = <%=passwdReminder%>;
var canpass = <%=canpass%>;
var canremind = <%=canremind%>;
var passwdelse = <%=passwdelse%>;
var isUpPswd = "<%=isUpPswd%>";
var dialog;
var common = new MFCommon();
if(isUpPswd == "true"){
	Dialog.alert("<%=SystemEnv.getHtmlLabelName(81626,user.getLanguage())%>", function(){
		common.initDialog({width:600,height:400,showClose:false,cancelEvent:function(){
			closeDialog();
		}});
		dialog = common.showDialog("/hrm/password/commonTab.jsp?fromUrl=hrmResourcePassword&languageid=<%=user.getLanguage() %>&showClose=true&RedirectFile=<%=RedirectFile%>", "<%=SystemEnv.getHtmlLabelName(17993,user.getLanguage())%>");
	});
} else {
	if(passwdReminder==1){
		if(canpass==1){
			if(canremind==1){
				Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23988,user.getLanguage())+passwdelse+SystemEnv.getHtmlLabelName(1925,user.getLanguage())+SystemEnv.getHtmlLabelName(23989,user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(23990,user.getLanguage())+"？"%>",
					function(){
						common.initDialog({width:600,height:400,cancelEvent:function(){
							closeDialog("<%=RedirectFile%>");
						}});
						dialog = common.showDialog("/hrm/password/commonTab.jsp?fromUrl=hrmResourcePassword&showClose=true&canpass=1&RedirectFile=<%=RedirectFile%>", "<%=SystemEnv.getHtmlLabelName(17993,user.getLanguage())%>");
					},
					function(){
						window.location = "<%=RedirectFile%>";
					}
				);
			}else{
				window.location = "<%=RedirectFile%>";
			}
		}else{
			Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23997,user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(23998,user.getLanguage())+"！"%>",
				function(){
					common.initDialog({width:600,height:400,cancelEvent:function(){
						closeDialog();
					}});
					dialog = common.showDialog("/hrm/password/commonTab.jsp?fromUrl=hrmResourcePassword&showClose=true&RedirectFile=<%=RedirectFile%>", "<%=SystemEnv.getHtmlLabelName(17993,user.getLanguage())%>");
				},
				function(){
					window.location = "/login/Logout.jsp";
				}
			);
		}
	}
}

function closeDialog(fw){
	if(dialog) dialog.close();
	parent.window.location = fw ? fw : "/login/Login.jsp";
}
</script>