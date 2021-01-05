
<%@page import="com.weaver.formmodel.mobile.skin.SkinManager"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ page import="weaver.conn.BatchRecordSet"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.sms.SMSManager,weaver.rtx.RTXConfig" %>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<jsp:useBean id="AppDetachComInfo" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="EmailEncoder" class="weaver.email.EmailEncoder" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

<%
boolean canedit = HrmUserVarify.checkUserRight("SystemSetEdit:Edit", user) ;
if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
char separator = Util.getSeparator() ;

String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());

String pop3server = Util.fromScreen(request.getParameter("pop3server"),user.getLanguage());
String emailserver = Util.fromScreen(request.getParameter("emailserver"),user.getLanguage());
String debugmode = Util.null2String(request.getParameter("debugmode"));
String logleaveday = ""+Util.getIntValue(request.getParameter("logleaveday"),0);
String defmailuser = Util.null2String(request.getParameter("defmailuser"));
String defmailpassword = Util.null2String(request.getParameter("defmailpassword"));
defmailpassword = EmailEncoder.EncoderPassword(defmailpassword);

String picPath = Util.fromScreen(request.getParameter("picPath"),user.getLanguage());
String filesystem = Util.fromScreen(request.getParameter("filesystem"),user.getLanguage());
String filesystembackup = Util.fromScreen(request.getParameter("filesystembackup"),user.getLanguage());
String filesystembackuptime = Util.null2String(request.getParameter("filesystembackuptime"));
String needzip = Util.null2String(request.getParameter("needzip"));
String needzipencrypt = Util.null2String(request.getParameter("needzipencrypt"));
String defmailserver = Util.null2String(request.getParameter("defmailserver"));
String defneedauth = Util.null2String(request.getParameter("defneedauth"));
String defmailfrom = Util.null2String(request.getParameter("defmailfrom"));
String smsserver = Util.null2String(request.getParameter("smsserver"));
String rtxServer = Util.null2String(request.getParameter("rtxServer"));
String rtxServerOut = Util.null2String(request.getParameter("rtxServerOut"));
String serverType = Util.null2String(request.getParameter("serverType"));
String isDownLineNotify = Util.null2String(request.getParameter("isDownLineNotify"));
String detachable = Util.null2String(request.getParameter("detachable"));
if(detachable.equals("")) detachable="0";
String hrmdetachable= Util.null2String(request.getParameter("hrmdetachable"));
if(hrmdetachable.equals("")) hrmdetachable="0";
String wfdetachable= Util.null2String(request.getParameter("wfdetachable"));
if(wfdetachable.equals("")) wfdetachable="0";
String docdetachable= Util.null2String(request.getParameter("docdetachable"));
if(docdetachable.equals("")) docdetachable="0";
String portaldetachable= Util.null2String(request.getParameter("portaldetachable"));
if(portaldetachable.equals("")) portaldetachable="0";
String cptdetachable= Util.null2String(request.getParameter("cptdetachable"));
if(cptdetachable.equals("")) cptdetachable="0";
String mtidetachable= Util.null2String(request.getParameter("mtidetachable"));
if(mtidetachable.equals("")) mtidetachable="0";
String wcdetachable= Util.null2String(request.getParameter("wcdetachable"));
if(wcdetachable.equals("")) wcdetachable="0";
String fmdetachable= Util.null2String(request.getParameter("fmdetachable"));
if(fmdetachable.equals("")) fmdetachable="0";
String mmdetachable= Util.null2String(request.getParameter("mmdetachable"));
if(mmdetachable.equals("")) mmdetachable="0";
String carsdetachable= Util.null2String(request.getParameter("carsdetachable"));
if(carsdetachable.equals("")) carsdetachable="0";

String appdetachable = Util.null2String(request.getParameter("appdetachable"));
String appdetachinit = Util.null2String(request.getParameter("appdetachinit"));
if(appdetachable.equals("")) appdetachable="0";
if(appdetachinit.equals("")) appdetachinit="0";
String dftsubcomid = Util.null2String(request.getParameter("dftsubcomid"));
String hrmdftsubcomid = Util.null2String(request.getParameter("hrmdftsubcomid"));
String wfdftsubcomid = Util.null2String(request.getParameter("wfdftsubcomid"));
String docdftsubcomid = Util.null2String(request.getParameter("docdftsubcomid"));
String portaldftsubcomid = Util.null2String(request.getParameter("portaldftsubcomid"));
String cptdftsubcomid = Util.null2String(request.getParameter("cptdftsubcomid"));
String mtidftsubcomid = Util.null2String(request.getParameter("mtidftsubcomid"));
String wcdftsubcomid = Util.null2String(request.getParameter("wcdftsubcomid"));
String fmdftsubcomid = Util.null2String(request.getParameter("fmdftsubcomid"));
String mmdftsubcomid = Util.null2String(request.getParameter("mmdftsubcomid"));
String carsdftsubcomid = Util.null2String(request.getParameter("carsdftsubcomid"));

String receiveProtocolType = String.valueOf(Util.getIntValue(request.getParameter("receiveProtocolType"),0));

String licenseRemind = Util.null2String(request.getParameter("licenseRemind"));
String remindUsers = Util.null2String(request.getParameter("remindUsers"));
String remindDays = Util.null2String(request.getParameter("remindDays"));
String defUseNewHomepage= Util.null2String(request.getParameter("defUseNewHomepage"));
String mailAutoCloseLeft= Util.null2String(request.getParameter("mailAutoCloseLeft"));
String rtxAlert= Util.null2String(request.getParameter("rtxAlert"));
String emlsavedays = String.valueOf(Util.getIntValue(request.getParameter("emlsavedays"),0));
String emlpath = Util.null2String(request.getParameter("emlpath"));

String refreshTime = Util.null2String(request.getParameter("refreshTime"));
String needRefresh = Util.null2String(request.getParameter("needRefresh"));
String scan = Util.null2String(request.getParameter("scan"));
String rsstype = Util.null2String(request.getParameter("rsstype"));
String isUseOldWfMode = Util.null2o(request.getParameter("isUseOldWfMode"));
String oaaddress = Util.null2String(request.getParameter("oaaddress"));
String messageprefix = Util.null2String(request.getParameter("messageprefix"));
int emailfilesize = Util.getIntValue(request.getParameter("emailfilesize"),0);


String needSSL = Util.null2String(request.getParameter("needssl"));
String smtpServerPort = Util.null2String(request.getParameter("smtpServerPort"));
String isaesencrypt  = Util.null2String(request.getParameter("isaesencrypt"));


if(!(needRefresh != null && "1".equals(needRefresh))){
	needRefresh = "0";
}
if(licenseRemind.equals("")){
	remindUsers="";
	remindDays="";
}
    SMSManager smsManager = new SMSManager();
    RTXConfig rtxConfig = new RTXConfig();
    boolean isValid = true;
    if(!operation.equals("detachmanagement")){
    rtxConfig.setProp(RTXConfig.RTX_SERVER_IP,rtxServer);
    rtxConfig.setProp(RTXConfig.RTX_SERVER_OUT_IP,rtxServerOut);
    rtxConfig.setProp(RTXConfig.IS_DOWN_LINE_NOTIFY,isDownLineNotify);

    String smsServerMsg = "";
    //isValid = smsManager.changeServerType(serverType);
    }else{}

if(debugmode.equals("")) debugmode = "0" ;

if(operation.equals("detachmanagement")){
    String para = ""+detachable + separator + dftsubcomid+ separator + hrmdetachable+ separator + hrmdftsubcomid+ separator + wfdetachable+ separator + wfdftsubcomid+ separator + docdetachable+ separator + docdftsubcomid+ separator + portaldetachable+ separator + portaldftsubcomid+ separator + cptdetachable+ separator + cptdftsubcomid+ separator + mtidetachable+ separator + mtidftsubcomid;

    RecordSet.executeProc("SystemDMSet_Update",para);
    String wcSQL="update SystemSet set wcdetachable='"+wcdetachable+"',wcdftsubcomid='"+wcdftsubcomid+"' where 1=1 ";//增加微信分权
    RecordSet.executeSql(wcSQL);
    String fmSQL="update SystemSet set fmdetachable='"+fmdetachable+"',fmdftsubcomid='"+fmdftsubcomid+"' where 1=1 ";//增加表单建模分权
    RecordSet.executeSql(fmSQL);
    String mmSQL="update SystemSet set mmdetachable='"+mmdetachable+"',mmdftsubcomid='"+mmdftsubcomid+"' where 1=1 ";//增加移动建模分权
    RecordSet.executeSql(mmSQL);
    String carsSQL="update SystemSet set carsdetachable='"+carsdetachable+"',carsdftsubcomid='"+carsdftsubcomid+"' where 1=1 ";//增加表单建模分权
    RecordSet.executeSql(carsSQL);

   //if(detachable.equals("1") && !dftsubcomid.equals("0")){
     //RecordSet.executeProc("SystemSet_DftSCUpdate",""+dftsubcomid);
   if(detachable.equals("1") && !dftsubcomid.equals("0")){
  	 //保存默认值
     RecordSet.executeSql("update SystemSet set dftsubcomid="+dftsubcomid);
   }
   if(detachable.equals("1")){
        RecordSet.executeProc("SystemSet_DftSCUpdate",""+dftsubcomid+ separator + hrmdftsubcomid+ separator + wfdftsubcomid+ separator + docdftsubcomid+ separator + portaldftsubcomid+ separator + cptdftsubcomid+ separator + mtidftsubcomid);
        RecordSet.executeSql("update hrm_att_proc_set set field004 = "+dftsubcomid+" where field004 = 0 OR field004 = -1 OR field004 NOT IN ( select id from  HrmSubCompany )");
		RecordSet.executeSql("update hrm_schedule_shifts_set set field002 = "+dftsubcomid+" where field002 = 0 OR field002 = -1 OR field002 NOT IN ( select id from  HrmSubCompany )");
		if(!wfdftsubcomid.equals("")){//设置流程权限默认分部
            RecordSet.executeSql("update workflow_bill set subcompanyid="+wfdftsubcomid+" where subcompanyid = '' or subcompanyid is null");
            RecordSet.executeSql("update workflow_monitor_bound set subcompanyid=(select subcompanyid from workflow_base where id = workflow_monitor_bound.workflowid)");
            if(RecordSet.getDBType().equals("oracle"))
            	RecordSet.executeSql("update workflow_custom set subcompanyid="+wfdftsubcomid+" where nvl(subcompanyid,0) = 0");
            else
            	RecordSet.executeSql("update workflow_custom set subcompanyid="+wfdftsubcomid+" where isnull(subcompanyid,0) = 0");
            
            if(RecordSet.getDBType().equals("oracle"))
            	RecordSet.executeSql("update Workflow_Report set subcompanyid="+wfdftsubcomid+" where nvl(subcompanyid,0) = 0");
            else
            	RecordSet.executeSql("update Workflow_Report set subcompanyid="+wfdftsubcomid+" where isnull(subcompanyid,0) = 0");
        } 
		if(!docdftsubcomid.equals("")){//设置文档权限默认分部
       	 	if(RecordSet.getDBType().equals("oracle"))//主目录
          	RecordSet.executeSql("update DocSecCategory set subcompanyid="+docdftsubcomid+" where nvl(parentid,0) <= 0 and nvl(subcompanyid,0) <= 0");
          else{
        	  RecordSet.executeSql("update DocSecCategory set subcompanyid="+docdftsubcomid+" where isnull(parentid,0) <= 0 and isnull(subcompanyid,0) <= 0");
          }
        	
       	 	if(RecordSet.getDBType().equals("oracle"))//显示模板
         		RecordSet.executeSql("update DocMould set subcompanyid="+docdftsubcomid+" where nvl(subcompanyid,0) <= 0");
         	else
         		RecordSet.executeSql("update DocMould set subcompanyid="+docdftsubcomid+" where isnull(subcompanyid,0) <= 0");
       	 	
       	 	if(RecordSet.getDBType().equals("oracle"))//编辑模板
          	RecordSet.executeSql("update DocMouldFile set subcompanyid="+docdftsubcomid+" where nvl(subcompanyid,0) <= 0");
          else
          	RecordSet.executeSql("update DocMouldFile set subcompanyid="+docdftsubcomid+" where isnull(subcompanyid,0) <= 0");
        	
       	 	if(RecordSet.getDBType().equals("oracle"))//新闻页
         		RecordSet.executeSql("update DocFrontpage set subcompanyid="+docdftsubcomid+" where nvl(subcompanyid,0) <= 0");
         	else
         		RecordSet.executeSql("update DocFrontpage set subcompanyid="+docdftsubcomid+" where isnull(subcompanyid,0) <= 0");
       	 
       	 	if(RecordSet.getDBType().equals("oracle"))//期刊
         		RecordSet.executeSql("update WebMagazineType set subcompanyid="+docdftsubcomid+" where nvl(subcompanyid,0) <= 0");
         	else
         		RecordSet.executeSql("update WebMagazineType set subcompanyid="+docdftsubcomid+" where isnull(subcompanyid,0) <= 0");

       	 	SecCategoryComInfo.removeMainCategoryCache();
        }
		if(!hrmdftsubcomid.equals("")){//设置人力资源权限默认分部 modify by zhh 2016-11-11
            RecordSet.executeSql("update HrmContractTemplet set subcompanyid="+hrmdftsubcomid+" where subcompanyid = '' or subcompanyid is null");//设置合同模板默认分部
        }else{
        	RecordSet.executeSql("update HrmContractTemplet set subcompanyid="+dftsubcomid+" where subcompanyid = '' or subcompanyid is null");//设置合同模板默认分部
        } 
		
		if(mmdetachable.equals("1") && !mmdftsubcomid.equals("")){//移动建模应用设置默认值
			RecordSet.executeSql("update mobileAppBaseInfo set subcompanyid="+mmdftsubcomid+" where subcompanyid is null or subcompanyid =-1 or subcompanyid =0 or subcompanyid = ''");
			SkinManager skinManager = new SkinManager();
			skinManager.updateAllSkinBySubCompanyId(mmdftsubcomid);
		}
    }
    
   
    ManageDetachComInfo.removeManageDetachCache();
    
}else if(operation.equals("appdetachmanagement")){
	RecordSet.executeSql("update SystemSet set appdetachable = "+appdetachable+",appdetachinit = "+appdetachinit);
	AppDetachComInfo.initSubDepAppData();
	//AppDetachComInfo.resetAppDetachInfo();
}else{
    /*
    String para = emailserver + separator + debugmode + separator + logleaveday + separator + defmailuser + separator + defmailpassword + separator + pop3server + separator + filesystem + separator + filesystembackup + separator + filesystembackuptime + separator + needzip + separator + needzipencrypt + separator + defmailserver + separator + defmailfrom + separator + defneedauth + separator + smsserver + separator + licenseRemind + separator + remindUsers + separator + remindDays + separator+ emailfilesize;

    RecordSet.executeProc("SystemSet_Update",para);
    RecordSet.executeSql("update SystemSet set receiveProtocolType='" + receiveProtocolType + "'");    
    //RecordSet.executeSql("update SystemSet set defUseNewHomepage='" + defUseNewHomepage + "'");    
	RecordSet.executeSql("update SystemSet set picturePath='" + picPath + "'");
	RecordSet.executeSql("update SystemSet set mailAutoCloseLeft='" + mailAutoCloseLeft + "',rtxAlert='"+rtxAlert+"'");
	//RecordSet.executeSql("update SystemSet set needRefresh='" + needRefresh + "'");
	//RecordSet.executeSql("update SystemSet set refreshMins='" + refreshTime + "'");
    RecordSet.executeSql("update SystemSet set emlsavedays='" + emlsavedays + "'");
    RecordSet.executeSql("update SystemSet set scan='" + scan + "'"); 
    //RecordSet.executeSql("update SystemSet set rsstype=" + rsstype + ""); 
    //RecordSet.executeSql("update SystemSet set isUseOldWfMode='" + isUseOldWfMode + "'"); 
	RecordSet.executeSql("update SystemSet set oaaddress = '" + oaaddress + "'"); 
	RecordSet.executeSql("update SystemSet set emlpath = '" + emlpath + "'");
	RecordSet.executeSql("update SystemSet set emailfilesize = '" + emailfilesize + "'"); 
	RecordSet.executeSql("update SystemSet set encryption = 1");
	RecordSet.executeSql("update SystemSet set messageprefix = '" + messageprefix + "'");

	RecordSet.executeSql("update SystemSet set needssl = '" + needSSL + "'"); 
	RecordSet.executeSql("update SystemSet set smtpServerPort = '" + smtpServerPort + "'"); 
	RecordSet.executeSql("update SystemSet set isaesencrypt = '" + isaesencrypt + "'");
    */
    
    RecordSet.executeSql("update SystemSet set oaaddress='" + oaaddress + "'");
    RecordSet.executeSql("update SystemSet set licenseRemind='" + licenseRemind + "'");
    RecordSet.executeSql("update SystemSet set remindUsers='" + remindUsers + "'");
    RecordSet.executeSql("update SystemSet set remindDays='" + remindDays + "'");
    RecordSet.executeSql("update SystemSet set picturePath='" + picPath + "'");
    RecordSet.executeSql("update SystemSet set filesystem='" + filesystem + "'");
    RecordSet.executeSql("update SystemSet set filesystembackup='" + filesystembackup + "'");
    RecordSet.executeSql("update SystemSet set filesystembackuptime='" + filesystembackuptime + "'");
    RecordSet.executeSql("update SystemSet set needzip='" + needzip + "'");
    RecordSet.executeSql("update SystemSet set isaesencrypt='" + isaesencrypt + "'");
}

SystemComInfo.removeSystemCache() ;
//System.out.println("SystemComInfo = " + SystemComInfo.getSmsserver());
%>
<script>
    
    <%if(operation.equals("detachmanagement")){%>
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16746,user.getLanguage())%>");
        window.location = "/system/DetachMSetEditInner.jsp";
    <%}else if(operation.equals("appdetachmanagement")){%>
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16746,user.getLanguage())%>");
        window.location = "/system/AppDetachMSetEditInner.jsp";
    <%}else{%>
        <%if(!isValid){%>
        	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23270,user.getLanguage())%>!");
        <%}%>
       // parent.window.location = "/system/SystemSetEdit.jsp";
       window.location = "/system/SystemSetEdit.jsp";
    <%}%>
</script>

