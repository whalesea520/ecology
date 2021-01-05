<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
	.inbtn:hover{
	  background-color: #325fd4!important;
	}
</style>
</head>

<%
String uid= Util.null2String(request.getParameter("uid"));

String uname = ResourceComInfo.getResourcename(uid);
String comname = CompanyComInfo.getCompanyname("1");

String language = Util.null2String(request.getParameter("lg"));

int languageid= 7;

if(!"".equals(language)){
    languageid = Util.getIntValue(language,7);
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
	  <%=SystemEnv.getHtmlLabelName(125273 ,languageid)%>
	</div>
	</div>
</center>
</div>
<div style="width: 100%;padding: 60px 0 0 0;text-align: center;">	
<center>
<div style="background-color: #FFFFFF;width:1070px;height: 509px; ">
<table >
  <tr>
   <td align="center" style="padding: 100px 0 10px 0; color: #797979;font-size: 14px;">
   	 <img width="85px" height="60px" align="AbsMiddle" src="/rdeploy/assets/img/hrm/letter.png" />
   </td>
  </tr>
  <tr>
   <td  align="center" style="padding: 20px 0 10px 0; color: #797979;font-size: 16px;">
   	 <%=uname %><%=SystemEnv.getHtmlLabelName(125274 ,languageid)%>
   	  <span style="color: #487bec;font-size: 18px;"><%= comname%></span>
   </td>
 </tr>
   <tr>
     <td align="center">
     
     </td>
   </tr>
   <tr>
     <td align="center">
       <div style="padding: 10px 0 40px 0; ">
		 <div style="width: 495px;height: 28px; padding: 13px 0 0 0;font-size: 16px;color: #797979;"><%=SystemEnv.getHtmlLabelName(125275 ,languageid)%></div>
	   </div>
     </td>
   </tr>
   <tr>
     <td align="center">
       <div  id="inadvancedmode" class="inbtn" onclick="go()"  style="background-color:#4A79EF;margin: 7px;width: 280px;text-align: center;height: 31px;font-size: 14px;padding-top: 12px;color: white;cursor:pointer;">
			 <%=SystemEnv.getHtmlLabelName(125276 ,languageid)%>
		</div>
     </td>
   </tr>
</table>
</div>
</center>
</div> 
<script language=javascript>

function go(){
 window.location.href="RdRegistResourceFill.jsp?lg=<%=language%>";
}

</script>




</BODY>
</HTML>
