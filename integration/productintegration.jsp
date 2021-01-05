
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=SystemEnv.getHtmlLabelName(32300,user.getLanguage())%></title><!-- 产品集成 -->
<style type="text/css">
html,body,ul,li,ol,dl,dd,dt,form,table,tr,td,p,b,span,a,img,h1,h2,h3,h4,h5,h6,em,input,select,option,textarea,div{margin:0;padding:0;}
body{font-family:Microsoft Yahei; font-size:12px;background:#f7f7fa;background-color: #f7f7fa;}
h1,h2,h3,h4,h5,h6{line-height:100%;}
a{ color:#666; text-decoration:none;}
.fl{ float:left}
.fr{ float:right;}
li{list-style:none;}
img{border:none;}  
.clear{clear:both;}
p{ font-size:12px; color:#666;}
.lable th{ width:70px; text-align:right;}

.contenta{height:180px; width:100%;margin:0px auto;text-align:center;}
.contentadiv{height:180px; width:963px;margin:0px auto;text-align:center;}
ul li{
	cursor:hand;
	width:201px; height:110px;
	float:left;
	margin-top:10px;margin-left: 10px;
}
.content{
cursor:hand;
height:110px;
text-align:left;
vertical-align:bottom;
font-family:"微软雅黑"!important; 
font-size:14px;
color:white;
font-weight:bold;
position:relative;
}
.content span{
 cursor:hand;
 width:100%;
 height:24px;
 vertical-align:bottom;
 text-align:center;
 bottom:0px; 
 padding:5px 0px 0px 0px; 
 margin:0px;
 color:white;
 position:absolute; 
}
</style>
</head>


<body onload='resetDiv();'>
<div id='content' style="margin:auto; width:100%;text-align:center;position:absolute;">
	<div style="margin:auto; width:660px; height:324px; padding:10px;text-align:center;">
		<ul style="width:660px;">
			<li style="background:url(images/a1_wev8.png) no-repeat center;background-color:#019AAC;" onclick="toSetting(12);"><div class="content"><span>SAP集成</span></div></li>
			<li style="background:url(images/a3_wev8.png) no-repeat center;background-color:#2C84EE;" onclick="toSetting(13);">
				<div class="content"><span><%=SystemEnv.getHtmlLabelName(33721,user.getLanguage())%><!-- NC集成 --></span></div>
			</li>
			<li style="background:url(images/a8_wev8.png) no-repeat center;background-color:#623DBE;" onclick="toSetting(15);">
				<div class="content"><span><%=SystemEnv.getHtmlLabelName(33723,user.getLanguage())%><!-- U8集成 --></span></div>
			</li>
			<li style="background:url(images/a10_wev8.png) no-repeat center;background-color:#BE1E4A;" onclick="toSetting(14);">
				<div class="content"><span><%=SystemEnv.getHtmlLabelName(33722,user.getLanguage())%><!-- EAS集成 --></span></div>
			</li>
			<li style="background:url(images/a9_wev8.png) no-repeat center;background-color:#009F00;" onclick="toSetting(16);">
				<div class="content"><span><%=SystemEnv.getHtmlLabelName(33724,user.getLanguage())%><!-- K3集成 --></span></div>
			</li>
			<li style="background: url(images/a21_wev8.png) no-repeat center; background-color: #019AAC;" onclick="toSetting(21);">
				<div class="content">
					<span><%=SystemEnv.getHtmlLabelName(129787, user.getLanguage())%><!-- CoreMail集成 --></span>
				</div>
			</li>
			<li style="background:url(/images/ecology8/images/logo_wev8.png) no-repeat center;background-color:#DA542E;">
				<div class="content"><span>&nbsp;</span></div>
			</li>
		</ul>
	</div>
</div>

	


</body>
</html>
<script language="javascript">
function resetDiv()
{
	 var height = document.body.clientHeight;
	 if(height>320)
	 {
	 	document.getElementById("content").style.top = (height-320)/2+"px";
	 }
}
function toSetting(type)
{
	var tourl = "";
	if("1"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=3";
	}
	else if("2"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=9";
	}
	else if("3"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=8";
	}
	else if("4"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=6";
	}
	else if("5"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=6&type=1";
	}
	else if("6"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=10";
	}
	else if("7"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=2";
	}
	else if("8"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=7";
	}
	else if("9"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=10";
	}
	else if("10"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=4";
	}
	else if("11"==type)
	{
		tourl = "http://www.baidu.com";
	}
	else if("12"==type)
	{
		tourl = "/integration/icontent.jsp?type=1&showtype=1";
	}
	else if("13"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=2&type=1";
	}
	else if("14"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=3&type=1";
	}
	else if("15"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=4&type=1";
	}
	else if("16"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=5&type=1";
	}
	else if("21"==type)
	{
		tourl = "/integration/icontent.jsp?showtype=21&type=1";
	}
	document.location = tourl;
}
</script>