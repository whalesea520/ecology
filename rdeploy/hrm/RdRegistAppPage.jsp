<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="org.codehaus.xfire.client.Client"%>
<%@page import="java.net.URL"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RdeployHrmSetting" class="weaver.rdeploy.hrm.RdeployHrmSetting" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.cycle.all_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/jquery.qrcode_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/qrcode_wev8.js"></script>
  	<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<style>
	.e8_os{
	  height:35px; 
	}
	.e8_innerShowContent{
	  height: 30px;
	  padding: 7px 0 0 7px;
	}
	
	.e8_spanFloat{
	  padding: 5px 0 0 0;
	}
	.e8_browflow{
		
	}
	.back:hover{
	  background-color: #325fd4;
	}
	.inbtn:hover{
	  background-color: #325fd4!important;
	}
	.thisBack{
  			background-color: #eef2f5;
  			border: 1px solid #e0e6ec;
  		}
  		.thisBack:hover{
  			background-color: #e2e9f0;
  			border: 1px solid #ced7e0;
  		}
</style>
</head>
<%! 

public String QueryString(String ip,String host) {
	String ret = "{}";
	String url = "http://" + host + "/services/HrmService?wsdl";
	try {
	    LN ln = new LN();
		Client client = new Client(new URL(url));
		Object[] results = client.invoke("getMobileHost",
				new Object[] { ln.getCid()});
		ret = (String) results[0];
	} catch (Exception e) {
	    //e.printStackTrace();
		//writeLog("调用webservice接口发生异常:url="+url+e.getMessage());
		return "{}";
	}
	return ret;
}
%>
<%
String uid= Util.null2String(request.getParameter("uid"));

String uname = ResourceComInfo.getResourcename(uid);
String comname = CompanyComInfo.getCompanyname("1");
String reUrl = request.getRequestURL().toString();
String invUrl =reUrl.substring(0,reUrl.indexOf("/rdeploy/hrm/RdRegistAppPage.jsp"));

int id = user.getUID();
boolean getadd = true;
String hostadd = RdeployHrmSetting.getSettingInfo("hostadd");


String address = QueryString("",hostadd);

if("{}".equals(address)|| "0".equals(address)){
    address= SystemEnv.getHtmlLabelName(125259, user.getLanguage());
    getadd =false;
}
%>
<BODY style="background-color:#F1F5F8; ">
<div style="width: 100%;height: 60px;background-color: #4A79EF;text-align: center;">
<center>
  <div style="width: 380px;">
	<div  style="height:50px; width: 100px;padding: 15px 30px 0 50px;position: relative;float: left;">
		<span style="height:100px;width:30px;">
			<img width="100px" height="30px" align="AbsMiddle" src="/rdeploy/assets/img/logo.png" />
		</span>
	</div>
	<div style=" font-size: 17px;color: #FFFFFF;height:42px;padding: 18px 10px 0 0;position: relative;float: left;">
	  <%=SystemEnv.getHtmlLabelName(125273, user.getLanguage())%>
	</div>
	</div>
</center>
</div>
<div style="width: 100%;padding: 60px 0 0 0;text-align: center;">	
<center>
<div style="background-color: #FFFFFF;width:1070px;height: 509px; ">
<table >
  <tr>
   <td  align="center" style="padding: 30px 0 10px 0; color: #4A79EF;font-size: 56px;">
   	 <img src="/rdeploy/assets/img/hrm/logo.png" width="218px" height="60px" align="absMiddle" >
   </td>
 </tr>
   <tr>
     <td align="center">
     	<div style="width: 425px;height: 28px; padding: 3px 0 0 0;font-size: 16px;color: #797979;">
     		<%=SystemEnv.getHtmlLabelName(125295, user.getLanguage())%><span style="padding-left: 15px;"><%=SystemEnv.getHtmlLabelName(125296, user.getLanguage())%></span>
     	</div>
     </td>
   </tr>
   <tr>
     <td align="left">
       <div style="padding: 10px 0 20px 0; ">
		 <div style="width: 425px;height: 28px; padding: 7px 0 0 80px;font-size: 14px;color: #797979;"><%=SystemEnv.getHtmlLabelName(125297, user.getLanguage())%></div>
		 <div style="width: auto;height: 28px; padding: 7px 0 0 80px;font-size: 14px;color: #797979;">
		 <%=SystemEnv.getHtmlLabelName(125298, user.getLanguage())%>
		 <%if(getadd){ %>
		 <%=address %>
		 <span class="dbtn thisBack" id="inadvancedmode" style="margin: -8px 0 0 0;color: #797979;padding:0px 10px;font-size: 13px;" onclick="sendToMobile()">
			  	<%=SystemEnv.getHtmlLabelName(125299, user.getLanguage())%>
	     </span>
	     <% }else{%>
	        <span style="color: #4A79EF;"><%=address %></span>
	     <%} %>
		 </div>
		 <div style="width: 425px;height: 28px; padding: 7px 0 0 80px;font-size: 14px;color: #797979;"><%=SystemEnv.getHtmlLabelName(125300, user.getLanguage())%></div>
	   </div>
     </td>
   </tr>
</table>
</div>
</center>
</div> 
<script language=javascript>

function go(){
 window.location.href="/login/Login.jsp?logintype=1";
}
var send = true;
function sendToMobile(){
  if(send){
    $.ajax({
		 data:{"id":"<%=id%>","method":"sendMsg","content":"<%=SystemEnv.getHtmlLabelName(129300, user.getLanguage())%>:<%=address %>"},
		 type: "post",
		 cache:false,
		 url:"RdResourceOptAjax.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		 	if(data.result){
				jQuery("#sendBefore").hide();
				jQuery("#sendAfter").show();
		 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(129301, user.getLanguage())%>！',null,null,null,null,{_autoClose:3});
		 	}else{
		 		if(data.reason =="1"){
			 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(129301, user.getLanguage())%>！',null,null,null,null,{_autoClose:3});
			 		jQuery("#sendBefore").hide();
				    jQuery("#sendAfter").show();
		 		}else{
			 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125307, user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 		}
		 	}
		}	
	   });
  }
}


</script>




</BODY>
</HTML>

