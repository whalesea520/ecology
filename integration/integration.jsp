
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title><%=SystemEnv.getHtmlLabelName(32269 ,user.getLanguage())%></title><!--集成中心-->
		<link href="css/integration_wev8.css" type="text/css" rel="stylesheet" />

	</head>
	<body>
		<div style="width: 100%;margin: 0px auto; height: 100%;overflow:auto;">
			<div class="contenta">
				<DIV class="contentadiv"></DIV>
			</div>
			<div class="contentb">
				<ul>
					<li style="background: url(images/a1_wev8.gif) no-repeat left center;" onclick="toSetting(1);"> <!--设置和各种类型的数据库、文件，接口的数据连接方式--><%=SystemEnv.getHtmlLabelName(32275 ,user.getLanguage())%></li>
					<li style="background: url(images/a2_wev8.gif) no-repeat left center; margin-left: 40px;" onclick="toSetting(2);"><!--轻松实现异构直接触发ECOLOGY审批流程--><%=SystemEnv.getHtmlLabelName(32276 ,user.getLanguage())%></li>
					<li style="background: url(images/a3_wev8.gif) no-repeat left center; margin-left: 40px;" onclick="toSetting(3);"><!--ECOLOGY财务流程自动生成主流财务系统凭证--><%=SystemEnv.getHtmlLabelName(32277 ,user.getLanguage())%></li>
				</ul>
				<ul>
					<li style="background: url(images/a4_wev8.gif) no-repeat left center;" onclick="toSetting(4);"><!--一键登陆其他B/S系统的设置--><%=SystemEnv.getHtmlLabelName(32278 ,user.getLanguage())%></li>
					<li style="background: url(images/a5_wev8.gif) no-repeat left center; margin-left: 40px;" onclick="toSetting(5);"><!--ECOLOGY审批流程审批过程随时出发异构系统业务逻辑--><%=SystemEnv.getHtmlLabelName(32279 ,user.getLanguage())%></li>
					<li style="background: url(images/a6_wev8.gif) no-repeat left center; margin-left: 40px;" onclick="toSetting(6);"><!--ECOLOGY和异构系统的流程数据交换--><%=SystemEnv.getHtmlLabelName(32280 ,user.getLanguage())%></li>
				</ul>
				<ul>
					<li style="background: url(images/a7_wev8.gif) no-repeat left center;" onclick="toSetting(7);"><!--可视化配置LDAP同步设置--><%=SystemEnv.getHtmlLabelName(32281 ,user.getLanguage())%></li>
					<li style="background: url(images/a8_wev8.gif) no-repeat left center; margin-left: 40px;" onclick="toSetting(8);"><!--快速定义定时执行的脚本，动作--><%=SystemEnv.getHtmlLabelName(32282 ,user.getLanguage())%></li>
					<li style="background: url(images/a9_wev8.gif) no-repeat left center; margin-left: 40px;" onclick="toSetting(9);"><!--零代码快速展现异构系统数据--><%=SystemEnv.getHtmlLabelName(32283 ,user.getLanguage())%></li>
				</ul>
				<ul>
					<li style="background: url(images/a10_wev8.gif) no-repeat left center;" onclick="toSetting(10);"><!--可视化配置与外部人力资源系统同步设置--><%=SystemEnv.getHtmlLabelName(32284 ,user.getLanguage())%></li>
					<li style="background: url(images/a17_wev8.gif) no-repeat left center; margin-left: 40px;" onclick="toSetting(17);"><!--可视化配置与外部人力资源系统同步设置-->WebService<%=SystemEnv.getHtmlLabelName(31691 ,user.getLanguage())%></li>
				</ul>
			</div>
			<div class="contentc" style="">
				<img src="images/a1a_wev8.gif" onclick="toSetting(11);"/>
				<img src="images/a2a_wev8.gif" onclick="toSetting(12);" style="margin-left: 44px;" />
				<img src="images/b3_wev8.gif" onclick="toSetting(13);" style="margin-left: 44px;" />
				<img src="images/a4a_wev8.gif" onclick="toSetting(14);" style="margin-left: 44px;" />
				<img src="images/a5a_wev8.gif" onclick="toSetting(15);" style="margin-left: 44px;" />
				<img src="images/a6a_wev8.gif" onclick="toSetting(16);" style="margin-left: 44px;" />
			</div>
		</div>
	</body>
</html>
<script language="javascript">
$(document).ready(function(){
	//$(window.parent.document).find("#leftmenuTD").hide();
});
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
		tourl = "/integration/icontent.jsp?showtype=11";
	}
	else if("10"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=4";
	}
	else if("11"==type)
	{
		tourl = "/integration/productintegration.jsp";
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
	else if("17"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=1";
	}
	else if("18"==type)
	{
		tourl = "/integration/integrationTab.jsp?urlType=18";
	}
	//$(window.parent.document).find("#leftmenuTD").show();
	document.location = tourl;
}
</script>