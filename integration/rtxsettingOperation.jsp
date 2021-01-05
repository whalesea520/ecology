
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,weaver.rtx.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("intergration:rtxsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String method = Util.fromScreen(request.getParameter("method"),user.getLanguage());
RTXConfig rtxconfig = new RTXConfig();

int isusedtx = Util.getIntValue(Util.null2String(request.getParameter("isusedtx")),0);
String rtxserverurl = Util.null2String(request.getParameter("rtxserverurl"));
String rtxserverouturl = Util.null2String(request.getParameter("rtxserverouturl"));
String rtxserverport = Util.null2String(request.getParameter("rtxserverport"));
String rtxOrElinkType = Util.null2String(request.getParameter("rtxOrElinkType"));
String rtxVersion = Util.null2String(request.getParameter("rtxVersion"));
String rtxOnload = Util.null2String(request.getParameter("rtxOnload"));
String rtxDenyHrm = Util.null2String(request.getParameter("rtxDenyHrm"));
String rtxAlert = Util.null2String(request.getParameter("rtxAlert"));
String domainName = Util.null2String(request.getParameter("domainName"));
String rtxConnServer = Util.null2String(request.getParameter("rtxConnServer"));
String userattr = Util.fromScreen(request.getParameter("userattr1"),user.getLanguage());
String rtxLoginToOA = Util.null2String(request.getParameter("rtxLoginToOA"));
String impwd = Util.null2String(request.getParameter("impwd"));
String uuid = Util.null2String(request.getParameter("uuid"));
String isDownload = Util.null2String(request.getParameter("isDownload"));
int fromProcessBar = Util.getIntValue(Util.null2String(request.getParameter("fromProcessBar")),0);

if(fromProcessBar != 1){
	//删除前先取出短信服务配置
	String CurSmsServer = Util.null2String(rtxconfig.getPorp(RTXConfig.CUR_SMS_SERVER));
  String curSmsServerIsValid = Util.null2String(rtxconfig.getPorp(RTXConfig.CUR_SMS_SERVER_IS_VALID));
	rs.executeSql("delete from RTXSetting");
	String sql = "";
	sql = "insert into RTXSetting (RTXServerIP,RTXServerOutIP ,RTXServerPort,DomainName,RTXVersion,RtxOrOCSType,RtxOnload,RtxDenyHrm,IsusedRtx,RtxAlert,rtxConnServer,CurSmsServer,cursmsserverisvalid,rtxLoginToOA,userattr,impwd,isDownload) values ('"+rtxserverurl+"','"+rtxserverouturl+"' ,'"+rtxserverport+"','"+domainName+"','"+rtxVersion+"','"+rtxOrElinkType+"','"+rtxOnload+"','"+rtxDenyHrm+"','"+isusedtx+"','"+rtxAlert+"','"+rtxConnServer+"','"+CurSmsServer+"','"+curSmsServerIsValid+"','"+rtxLoginToOA+"','"+userattr+"','"+impwd+"','"+isDownload+"')";
	rs.execute(sql);
	rtxconfig.removeRTXComInfoCache();
	
	rtxOnload=rtxOnload.equals("1")?"1":"0";
	rs.execute("update HrmUserSetting set rtxOnload="+rtxOnload);
	
	//删除用户设置缓存数据
	HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
	userSetting.removeHrmUserSettingComInfoCache();
}

if("test".equals(method)){
	String value = "";
	if("1".equals(rtxOrElinkType)){
		EimServiceManager.resetSingleton();
		EimServiceImpl ocscline = new EimServiceImpl();
		if(!ocscline.isValid()){
			value = "-1";
		}
	}else if("2".equals(rtxOrElinkType)){
		value = new weaver.interfaces.hrm.HrmSynDAO().GetTestValue();
	}else{
		RTXClientCom rtxcline = new RTXClientCom();
		value = rtxcline.getSessionKey("test");
	}
	if(value.equals("-1")){
		response.sendRedirect("/integration/rtxsetting.jsp?test=1");
	}else{
		response.sendRedirect("/integration/rtxsetting.jsp?test=2");
	}
}else if("syn".equals(method)){
	if("2".equals(rtxOrElinkType)){
		new weaver.interfaces.hrm.HrmSynTask().synTask();
	}else{
		OrganisationCom orgcom = new OrganisationCom();
		if(orgcom.initAllDepartmant(request, uuid)){
			response.sendRedirect("/integration/rtxsetting.jsp?test=3");
		}else{
			response.sendRedirect("/integration/rtxsetting.jsp?test=4");
		}
	}
	
}else{
	response.sendRedirect("/integration/rtxsetting.jsp");
}
rtxconfig.removeRTXComInfoCache();
%>