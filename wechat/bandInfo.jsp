
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="java.util.*,weaver.wechat.util.*,java.net.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%
String id=request.getParameter("id");
String userid=request.getParameter("userid");
String usertype=request.getParameter("usertype");
String target=request.getParameter("target");
String name="";
if("1".equals(usertype)){
	name=ResourceComInfo.getLastname(userid);
}else{
	name=CustomerContacterComInfo.getCustomerContactername(userid);
}

//获取手机web地址
String mobileurl=WechatPropConfig.getMobileUrl();
//判断mobileurl是否配置
if(mobileurl!=null&&!"".equals(mobileurl)){
	rs.execute("select * from wechat_band where id="+id);
	if(rs.next()){
		String publicid=rs.getString("publicid");
		String openid=rs.getString("openid");
		//此时生成token
		String token=WechatUtil.createToken(userid,publicid,openid);
		//获取用户登录id
		String loginid=ResourceComInfo.getLoginID(userid);
		//进入手机界面
		if(!"".equals(target)){
			target= BaseBean.getPropValue("wechat","target."+target);
		}
		target="".equals(target)?"/home.do":target;
		target=URLEncoder.encode(target,"UTF-8");
		response.sendRedirect(mobileurl+"/weixin.jsp?loginid="+URLEncoder.encode(loginid,"UTF-8")+"&password="+token+"&tokenpass=_wechat&target="+target);	
	}
}

 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title></title>
<link rel="stylesheet" href="css/jquery.mobile-1.1.1.min_wev8.css" />
<link rel="stylesheet" href="css/my_wev8.css" />
<style>/* App custom styles */</style>
<script	src="js/jquery-1.7.1.min_wev8.js"></script>
<script	src="js/custom-jqm-mobileinit_wev8.js"></script>
<script	src="js/jquery.mobile-1.1.1.min_wev8.js"></script>
<script src="js/my_wev8.js"></script>
</head>
	<body>
        <br><br><!-- Home -->
		<div data-role="page" id="page1">
		    <div data-role="content">
		        <form action="bandOperate.jsp" method="POST">
	                <input name="id" id="id" value="<%=id %>" type="hidden">
	                <input name="operate" id="operate" value="cancelBand" type="hidden">
		            <ul data-role="listview" data-divider-theme="" data-inset="true">
		            <li data-theme="">
		                <%=name %>
		            </li>
		        </ul>
		        <input type="submit" data-theme="a" value="解绑">
		        </form>
		    </div>
		</div>
		<div data-role="page" id="page2">
		    <div data-role="content">
		        已经绑定
		    </div>
		</div>
    </body>
     <script>
		
	function chagePage(){
     	$.mobile.changePage( $('#page2'), {
							transition: "slide",
							changeHash: false
							} );
	}	
     
     
      //App custom javascript
      $(document).ready(function() {
       
	     
      });
      </script>
</html>