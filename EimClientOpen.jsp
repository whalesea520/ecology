<%@ page import="weaver.general.Util,weaver.hrm.User,weaver.rtx.RTXConfig" %>
<%@ page import=" weaver.rsa.security.RSA"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.integration.logging.Logger"%>
<%@ page import="weaver.integration.logging.LoggerFactory"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	Logger log = LoggerFactory.getLogger();//新建日志对象
	// 由于user.getLoginid() 和数据库中longid不一致，而ocs是区分大小写的。所以采取该处理办法，仅考虑sqlserver数据库ocs单点登录情况
	String rtxlogin =Util.null2String((String)request.getSession(true).getAttribute("rtxlogin"));
	//rtx反向登陆到oa就不需要单点登录了
	if("1".equals(rtxlogin)){
		return;
	}
	RTXConfig rtxConfig = new RTXConfig();
	String login = "";
	if(!user.getLoginid().equals("sysadmin")){
		login = rtxConfig.getRtxLoginFiled(user.getUID());
	}
	String isDownload = Util.null2String(rtxConfig.getPorp(RTXConfig.RTX_ISDownload));
	
	//对password进行RSA解密-start
	String isrsaopen = Util.null2String(rs.getPropValue("openRSA","isrsaopen"));//是否RSA加密
	String password = "";
	if("1".equals(isrsaopen)){//采用RSA加密
		RSA rsa = new RSA();
		String password_new = (String)session.getAttribute("password_new");
		//log.info("===========解密前获得的password_new:"+password_new);
		//password = rsa.decrypt(request,(String)session.getAttribute("password_new"));//普通解密
		password = rsa.decrypt(request,(String)session.getAttribute("password_new"),true);//强制解密
		//log.info("===========解密后获得的password_new:"+password);
		if(!rsa.getMessage().equals("0")){//解密失败
			log.info("===========解密失败的message值:"+rsa.getMessage());
		}else{//解密成功，再二次加密
			password_new = rsa.encrypt(request,password);
			//log.info("===========再次加密后获得的password_new:"+password_new);
			session.setAttribute("password_new",password_new);
		}
	}else{//未采用RSA加密
		password = (String)session.getAttribute("password");//未处理的密码
	}
	//对password进行RSA解密-end
	
%>
<HTML>
<HEAD>
<TITLE> New Document </TITLE>
<script type="text/javascript" src="/js/EimUtil_wev8.js"></script>
<script type="text/javascript">
	function on_load(){
		<%if(rtxConfig.isSystemUser(user.getLoginid())){%>
			//top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(27462,user.getLanguage())%>');
			return;
		<%}%>
		if(EimUtil.isInstall()){
			EimUtil.engine.Runeim('<%=login%>', '<%=password%>');
		}else{
			<%if(isDownload.equals("1")){%>
				top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(27461,user.getLanguage())%>", function (){
		     	  window.open('/weaverplugin/PluginMaintenance.jsp',"","height=800,width=600,scrollbars,resizable=yes,status=yes,Minimize=yes,Maximize=yes");
		   		 }, function () {}, 320, 90);
		    <%}%>
		}
	}
</script>
</HEAD>

<BODY onLoad="on_load()">
</BODY>
</HTML>
