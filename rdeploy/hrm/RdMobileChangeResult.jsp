<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.User"%>
<%@page import="ln.LN"%>
<%@page import="org.codehaus.xfire.client.Client"%>
<%@page import="java.net.URL"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="RdeployHrmSetting" class="weaver.rdeploy.hrm.RdeployHrmSetting" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<meta name="viewport" content="width=device-width, initial-scale=0.45,maximum-scale=0.45, minimum-scale=0.45" />
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
	.inbtn:hover{
	  background-color: #325fd4!important;
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
				//new Object[] { ln.getCid()});
				new Object[] { 306});
		//System.out.println(results.toString());
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

//User user =(User) request.getSession().getAttribute("_rdverifyloginuser");
//if(user == null){
//    response.sendRedirect("/rdeploy/hrm/RdMobileLogin.jsp");
//}

//int uid= user.getUID();

//String comname = CompanyComInfo.getCompanyname("1");

//int language= user.getLanguage();

String id = Util.null2String(request.getAttribute("uid"));

String language = ResourceComInfo.getSystemLanguage(id);

int languageid= 7;

if(!"".equals(language)){
    languageid = Util.getIntValue(language,7);
}

String reUrl = request.getRequestURL().toString();

String invUrl =reUrl.substring(0,reUrl.indexOf("/rdeploy/hrm/RdMobileChangeResult.jsp"));

boolean getadd = true;
String hostadd = RdeployHrmSetting.getSettingInfo("hostadd");


String address = QueryString("",hostadd);

if("{}".equals(address)|| "0".equals(address)|| "".equals(address)){
    address=" "+SystemEnv.getHtmlLabelName(125259,languageid);
    getadd =false;
}

%>
<BODY style="padding: 0 0 0 0;margin: 0 0 0 0;">


<input name="language" type="hidden" value="<%=language %>">
<div style="width: 100%;padding: 0 0 0 0;text-align: center;height: 100%;">	
<center>
<div style="background-color: #FFFFFF; height: 100%;">
<table width="100%" >
  <tr>
   <td align="center" colspan="3"  style="padding: 27px 0 0px 0; color: #000000;font-size: 30px; ">
   	 <span style="margin: 0 10px 0 0;padding-left: 5px; "><%=SystemEnv.getHtmlLabelName(125260 ,languageid)%></span> 
   </td>
 </tr>
  <tr>
   <td align="center" colspan="3"  style="padding: 7px 0 20px 0; color: #000000;font-size: 30px; border-bottom: 2px solid #dddddd;">
   	 <span style="margin: 0 10px 0 0;padding-left: 5px; "><%=SystemEnv.getHtmlLabelName(125261 ,languageid)%></span> 
   </td>
 </tr>
  <tr>
   <td align="center" colspan="3"  style="padding: 37px 0 0px 0; color: #000000;font-size: 30px; ">
     	<img src="/rdeploy/assets/img/hrm/computer.png"  align="absMiddle" >
   </td>
 </tr>
  <tr>
   <td align="center" colspan="3"  style="padding: 27px 0 0px 0; color: #000000;font-size: 20px; ">
     	<span style="margin: 0 10px 0 0;padding-left: 5px; "><%=SystemEnv.getHtmlLabelName(125262 ,languageid)%></span> 
   </td>
 </tr>
  <tr>
   <td align="center" colspan="3"  style="padding: 17px 0 0px 0; color: #7b7b7b;font-size: 20px; ">
     	<span style="margin: 0 10px 0 0;padding-left: 5px; "><%=invUrl %></span> 
   </td>
 </tr>
  <tr>
   <td align="center" colspan="3"  style="padding: 17px 0 20px 0; color: #000000;font-size: 20px; border-bottom: 2px solid #dddddd;">
     	<span style="margin: 0 10px 0 0;padding-left: 5px; "><%=SystemEnv.getHtmlLabelName(125263 ,languageid)%></span> 
   </td>
 </tr>
   <tr>
   <td align="center" colspan="3"  style="padding: 37px 0 0px 0; color: #000000;font-size: 30px; ">
     	<img src="/rdeploy/assets/img/hrm/phone.png"  align="absMiddle" >
   </td>
 </tr>
  <tr>
   <td align="center" colspan="3"  style="padding: 27px 0 0px 0; color: #000000;font-size: 20px; ">
     	<div  id="dosubmit" onclick="doAdd()"   style="background-color:white;padding:5px 0 0 0;width: 163px;text-align: center;height: 40px;font-size: 25px;;color: 41b4f2;cursor:pointer;border: 1px solid #cccccc;">
			 <%=SystemEnv.getHtmlLabelName(125264 ,languageid)%>
		</div>
   </td>
     <tr>
   <td align="center" colspan="3"  style="padding: 17px 0 10px 0; color: #000000;font-size: 20px;">
     	<%=SystemEnv.getHtmlLabelName(125265 ,languageid)%><span style="margin: 0 10px 0 0;padding-left: 1px; color: #7b7b7b;"><%=address %></span> 
   </td>
 </tr>
     <tr>
   <td align="center" colspan="3"  style="padding: 10px 0 40px 0; color: #000000;font-size: 20px; ">
     	<%=SystemEnv.getHtmlLabelName(125266 ,languageid)%> 
   </td>
 </tr>
 </tr>
</table>
</div>
</center>
</div> 
<script language=javascript>

function doAdd(){
	var url = "http://itunes.apple.com/app/id963113126";
	if(/android/i.test(navigator.userAgent)){
		url="http://emobile.e-nature.cn/android/EMobile5.7.6.apk";//这是Android平台下浏览器
	}
	if(/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)){
		url="http://itunes.apple.com/app/id963113126";;//这是iOS平台下浏览器
	}
	window.location.href= url;
}

</script>




</BODY>
</HTML>

