<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.rdeploy.portal.PortalUtil"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    
    /*用户验证*/
    User user = HrmUserVarify.getUser (request , response) ;
    if(user==null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">

		<title></title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
		<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<style type="text/css">
			.head {
				background:#4a79ef;height:50px;width:100%;font-family:'Microsoft YaHei';
			}
			.logocolor {
				width:100%; 
				height:100%;
				line-height:50px;
				font-family: '华文细黑';
				font-size:24px;
				color:#fff;
				text-align:center;
			}
			.center {
				position:relative;
				float:left;
				height:100%;
				width:560px;
				font-size:14px;
				color:#fff;
			}
			.center .item {
				width:140px;
				height:100%;
				text-align:center;
				height:50px;
				line-height:50px;
				float:left;
				cursor:pointer;
			}
			
			.center .itemhov {
				background:#4472e5;
			}
			
			.center .itembg {
				background:#4a79ef;
			}
			
			.center .itembgslt {
				background:#3462d4;
			}
			
			.center .item .itemioc {
				display:inline-block;
				height:18px;
				width:18px;
			}
			
			.center .item .itemioc img {
				vertical-align:middle;margin-top:-5px;
				height:18px;
				width:18px;
			}
			.zDialogTitleTRClass td {
		  		font-family:'微软雅黑';
		  		height:45px!important;
		  		background:#5d9ffe!important;
		  	}
		</style>
		
		<script>
			$(function () {
				$(".center .item").hover(function () {
					if (!($(this).hasClass("itembgslt"))) {
						$(this).addClass("itemhov").removeClass("itembg");
					}
				}, function () {
					$(this).removeClass("itemhov").addClass("itembg");
				});
				
				$(".center .item").bind("click", function () {
					$("#mainFrame").attr("src", "/rdeploy/" + $(this).attr("_src") + "/index.jsp");
					var imgs = $(".center .itembgslt img");
					$(".center .itembgslt").removeClass("itembgslt").removeClass("itemhov").addClass("itembg");
					$(imgs[1]).hide();
					$(imgs[0]).show();
					//添加选中样式
					$(this).addClass("itembgslt").removeClass("itemhov").removeClass("itembg");
					imgs = $(this).find("img");
					$(imgs[0]).hide();
					$(imgs[1]).show();
				});
				
				window.onresize = function () {
					resize();
				};
				resize();
				
				
				$("#logoutdiv").hover(function () {
					$(this).find("img").attr("src", "/rdeploy/assets/img/logout_slt.png");
				}, function () {
					$(this).find("img").attr("src", "/rdeploy/assets/img/logout.png");
				});
			})
			
			function resize() {
				//window.console.log($("#content").width());
				if ($(document.body).width() < 1100) {
					$("#content").css("width", "1100px");
				} else {
					$("#content").css("width", "100%");
				}
				//window.console.log($(document.body).width());
			}
			
			function logout(){
				top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>",function(){
					window.location='/login/Logout.jsp';
				})
			}
		</script>
	</head>

	<body style="margin:0px;padding:0px;">
		<div id="content" style="position:absolute;width:100%;height:100%;">
	
		<div class="head">
			<div class="logocolor" style="float:left;width:225px;height:100%;">
				<div class="logoArea" style="height:100%;">
					<!-- <span>e-cology</span>  -->
					&nbsp;
					<span style="height:100px;width:30px;">
						<img src="/rdeploy/assets/img/logo.png" width="100px" height="30px" align="AbsMiddle">
					</span>&nbsp;
				</div>
			</div>
			
			<div class="center">
				<div class="item itembgslt" _src="hrm">
					<span class="itemioc">
						<img src="/rdeploy/assets/img/hrm.png" height="18px" width="18px" style="display:none;">
						<img src="/rdeploy/assets/img/hrm_slt.png" height="18px" width="18px">
					</span>
					成员管理
				</div>
				
				<div class="item itembg" _src="wf">
					<span class="itemioc">
						<img src="/rdeploy/assets/img/wf.png" height="18px" width="18px">
						<img src="/rdeploy/assets/img/wf_slt.png" height="18px" width="18px" style="display:none;">
					</span>
					流程管理
				</div>
				
				<div class="item itembg" _src="doc">
					<span class="itemioc">
						<img src="/rdeploy/assets/img/doc.png" height="18px" width="18px">
						<img src="/rdeploy/assets/img/doc_slt.png" height="18px" width="18px" style="display:none;">
					</span>
					文档目录
				</div>
				
				<div class="item itembg" _src="portal">
					<span class="itemioc">
						<img src="/rdeploy/assets/img/port.png" height="18px" width="18px">
						<img src="/rdeploy/assets/img/port_slt.png" height="18px" width="18px" style="display:none;">
					</span>
					门户管理
				</div>
			</div>
			<div style="position:absolute;right:0px;height:50px;font-size:14px;">
				<div style="float:right;height:100%;line-height:50px;color:#fff;cursor:pointer;margin-right:5px;" id="logoutdiv" onclick="logout();"  title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>" >
					<span style="height:18px;width:18px;">
						<img src="/rdeploy/assets/img/logout.png" height="18px" width="18px" align="AbsMiddle">
					</span>
					&nbsp;
				</div>
			    
			    <div style="float:right;height:100%;line-height:50px;color:#fff;cursor:pointer;width:1px!important;background:#456fda;margin:0px 15px;" onclick="">
				</div>
				
				<div style="float:right;height:100%;padding:0px 0px 0px 40px;line-height:50px;color:#fff;cursor:pointer;" onclick="javascript:window.location.href='/middlecenter/index.jsp';">
					<span style="height:18px;width:18px;">
						<img src="/rdeploy/assets/img/setting.png" height="18px" width="18px" align="AbsMiddle">
					</span>
					后端引擎应用中心
				</div>
				<div style="float:right;height:100%;line-height:50px;color:#fff;cursor:pointer;" onclick="window.open('/hrm/HrmTab.jsp?_fromURL=HrmResource')">
					<span style="height:18px;width:18px;">
						<img src="/rdeploy/assets/img/mgr.png" height="18px" width="18px" align="AbsMiddle">
					</span>
					<%=user.getLastname() %><%=user.getUID() == 1 ?  "" : (PortalUtil.isAdmin(user) ? "（管理员）":"")%>
				</div>
			</div>
			<div style="clear:both;"></div>
		</div>
		<div style="width:100%;position:absolute;top:50px;bottom:0px;"> 
			<iframe name="mainFrame" id="mainFrame" border="0" frameborder="no" noresize="noresize" 
			width="100%" height="100%" scrolling="auto" src="/rdeploy/hrm/index.jsp" style="overflow-y:hidden;"></iframe> 
		</div>
		
		</div>
	</body>
</html>
