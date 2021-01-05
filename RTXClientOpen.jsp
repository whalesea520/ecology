<%@ page import="weaver.general.Util,weaver.hrm.User,
                 weaver.rtx.RTXConfig" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RTXExtCom" class="weaver.rtx.RTXExtCom" scope="page" />
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<TITLE> New Document </TITLE>
<META NAME="Generator" CONTENT="EditPlus">
<META NAME="Author" CONTENT="">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">
<%
	RTXConfig rtxConfig = new RTXConfig();
	String rtxlogin =Util.null2String((String)request.getSession(true).getAttribute("rtxlogin"));
	//rtx反向登陆到oa就不需要单点登录了
	if("1".equals(rtxlogin)){
		return;
	}
	String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
	if("OTHER".equals(RtxOrElinkType)){
		response.sendRedirect("/OtherIMClientOpen.jsp");
		return;
	}
    String notify = Util.null2String(request.getParameter("notify"));
    String rtxname = rtxConfig.getRtxLoginFiled(user.getUID());
    String sessionKey = RTXExtCom.getSessionKey(rtxname);
    
    String serverUrl="";
    
    String serverUrl_in = rtxConfig.getPorp(RTXConfig.RTX_SERVER_IP); 
    String serverUrl_out = rtxConfig.getPorp(RTXConfig.RTX_SERVER_OUT_IP);
    String isDownload = rtxConfig.getPorp(RTXConfig.RTX_ISDownload);
	String rtxConnServer = Util.null2String(rtxConfig.getPorp(RTXConfig.RTX_ConnServer));
    if("".equals(rtxConnServer)) rtxConnServer = "8000";
    String strIsaIp=Util.null2String(rtxConfig.getPorp("ISAIP"));
    String strRemoteIp=Util.null2String(request.getRemoteHost());


    out.println("strIsaIp:"+strIsaIp);
    out.println("remoteAddr2:"+strRemoteIp);

    if(!strIsaIp.equals("")){
	if(strRemoteIp.equals(strIsaIp)){
		serverUrl=serverUrl_out;
	} else {
		serverUrl=serverUrl_in;
	}
    } else {
	try{
	    String[]  aryRemote=Util.TokenizerString2(strRemoteIp,".");  
	    String[]  aryAddr_in=Util.TokenizerString2(serverUrl_in,".");  
	   
	    if(aryRemote[0].equals(aryAddr_in[0]) || aryRemote[0].equals("127")){
	    	serverUrl=serverUrl_in;
	    } else {
	    	serverUrl=serverUrl_out;
	    }
         }catch(Exception ex){
    	   serverUrl=serverUrl_out;
	 }
    }

%>
<script type="text/javascript">
	function on_body_load()
	{
		
			try{
				var RTXAX = document.getElementById("RTXCLIENT");
				var objProp = RTXAX.GetObject("Property")
				objProp.value("RTXUsername") = "<%=rtxname%>";
				objProp.value("LoginSessionKey")= "<%=sessionKey%>";
				objProp.value("ServerAddress") = "<%=serverUrl%>";
				objProp.value("ServerPort") = "<%=rtxConnServer%>";
				RTXAX.call(2,objProp);
			}catch(e){
			   on_load();
			   return;
			}
		
	}
	function on_load(){
		<%if(isDownload.equals("1")){%>
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83595,user.getLanguage())%>", function (){
		       window.open('/weaverplugin/PluginMaintenance.jsp',"","height=800,width=600,scrollbars,resizable=yes,status=yes,Minimize=yes,Maximize=yes");
		    }, function () {}, 320, 90);
		<%}%>
	}
</script>
</HEAD>

<%if(sessionKey != null && !sessionKey.equals("")){%>
<BODY onLoad="on_body_load()">
<OBJECT classid=clsid:5EEEA87D-160E-4A2D-8427-B6C333FEDA4D id=RTXCLIENT>　</OBJECT>
</BODY>
<%}%>
</HTML>
