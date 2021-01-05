<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.rdeploy.portal.PortalUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}

//门户编辑权限验证
if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}

String modename = "门户";
String modeurl = "/homepage/maint/HomepageManit.jsp";

String sql = "select * from hpinfo ORDER by isuse desc ";
RecordSet rs = new RecordSet();
rs.executeSql(sql);
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
  	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
	<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
  	<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
  	<script type="text/javascript">
  		$(function () {
  			//鼠标移到图标上触发事件，显示设置和启用图标
  			$(".item .itemico img").hover(function (e) {
  				//var imgobj = $(this).children();
  				if (!!$(this).closest(".additem")[0]) {
  					$(this).attr("src", "/rdeploy/assets/img/new_slt.png");
  				} else {
  					$(this).attr("src", "/rdeploy/assets/img/portal/portal_slt.png");
  					$(this).closest(".item").find(".itemoperation").show();
  					$(this).closest(".item").find(".itemclose").show();	
  				}
  			});
  			//只有鼠标移除整个item范围才会隐藏图标
  			$(".item").hover(null, function () {
  				var imgobj = $(this).children(".itemico").find("img");
  				if (!!$(this).closest(".additem")[0]) {
  					imgobj.attr("src", "/rdeploy/assets/img/new.png");
  				} else {
	  				var status = 1;
	  				try {
	  					status = parseInt($(this).find(".operationspan").attr("status"));
	  				} catch (e) {}
	  				
	  				if (status == 1) {
	  					imgobj.attr("src", "/rdeploy/assets/img/portal/portal.png");
	  				} else {
	  					imgobj.attr("src", "/rdeploy/assets/img/portal/portal_dis.png");
	  				}
	  				
	  				$(this).find(".itemoperation").hide();
	  				$(this).find(".itemclose").hide();
  				}
  			});
  			
  			$(".item .itemclose img").hover(function (e) {
  				$(this).attr("src", "/rdeploy/assets/img/close_slt.png");
  			}, function () {
  				$(this).attr("src", "/rdeploy/assets/img/close.png");
  			});
  			
  			$(".item .itemclose img").bind("click", function (e) {
  				var hpid = $(this).closest(".item").find("input[name=hpinfoid]").val();
				var subCompanyId = $(this).closest(".item").find("input[name=subcompanyid]").val();
				top.Dialog.confirm("确定要删除吗?",function(){
					jQuery.post("/homepage/maint/HomepageMaintOperate.jsp?method=delhp&hpid="+hpid,
					function(data){if(data.indexOf("OK")!=-1) location.reload();});
				});
  			});
  			
  			//是否启用
  			$(".operationspan").bind("click", function () {
  				var status = 1;
  				try {
  					status = parseInt($(this).attr("status"));
  				} catch (e) {}
  				
  				if (status == 1) {
					//$(this).css("backgroundImage", "url('/rdeploy/assets/img/wf/stop.png')");
					$(this).addClass("operationspan2");
					$(this).attr("status", "0");
  				} else {
  					//$(this).css("backgroundImage", "url('/rdeploy/assets/img/wf/start.png')");
  					$(this).removeClass("operationspan2");
  					$(this).attr("status", "1");
  				}
  				
  				var hpid = $(this).closest(".item").find("input[name=hpinfoid]").val();
  				try {
  					status = parseInt($(this).attr("status"));
  					var btntitle = (status==0 ? "点击启用" : "点击禁用");
  					$(this).attr("title", btntitle); 
  				} catch (e) {}
  				
  				var imgobj = $(this).closest(".item").find(".itemclose").children();
  				$.ajax({
  					url : "/rdeploy/portal/portalUseOperate.jsp?isuse=" + status + "&infoid=" + hpid,
  					contentType : "charset=UTF-8", 
			        type : "GET", 
			        error:function(ajaxrequest){
					}, 
			        success:function(content) {
			        	var isdel = $.trim(content);
			        	if (isdel == '1') {
							imgobj.show();
			        	} else {
			        		imgobj.hide();
			        	}
					} 
  				});
  				
  			});
  			
  			//弹出设置界面
  			$(".item .itemico img").bind("click", function () {
  				var hpid = $(this).closest(".item").find("input[name=hpinfoid]").val();
  				var subcompanyid = $(this).closest(".item").find("input[name=subcompanyid]").val();
				var dialog = new window.top.Dialog();
  				dialog.currentWindow = window;
  				if (!!$(this).closest(".additem")[0]) {
  					dialog.URL = "/rdeploy/portal/newportal.jsp";
  					dialog.Title = "新建门户";
  					dialog.Width = 515;
  					dialog.Height = 200;
  					dialog.normalDialog = false;
  				} else {
  					//
  					/*
  					RSS阅读器：1
  					文档中心：7
  					流程中心：8
  					未读文档：6
  					消息提醒：9
  					文档内容：25
  					公告栏元素：notice
  					图片元素：picture
  					幻灯片：Slide
  					天气元素：weather
  					便签元素：scratchpad
  					
  					个人数据：DataCenter
  					日历日程：MyCalendar
  					通讯录：contacts
  					新建流程：addwf
  					图片幻灯片：imgSlide
  					公告：newNotice
  					old:7,8,9,DataCenter,MyCalendar,scratchpad,Slide,notice
  					new:1,7,8,6,9,25,notice,picture,Slide,weather,scratchpad,DataCenter,MyCalendar,contacts,addwf
  					new:2015-07-31:
  					    7,8,6,25,DataCenter,MyCalendar,contacts,addwf
  					*/
	  				dialog.URL = "/homepage/maint/HomepageTabs.jsp?_fromURL=ElementSetting&isSetting=true&hpid=" + hpid + "&from=setElement&pagetype=&opt=edit&subCompanyId=" + subcompanyid +"&isshowelemflag=1"+"&elemids=7,8,6,25,DataCenter,MyCalendar,contacts,addwf,imgSlide,newNotice";
	  				dialog.Title = "设置元素";
	  				dialog.maxiumnable = true;
	  				dialog.Width = window.top.window.document.body.offsetWidth*0.9 ;
	  				dialog.Height = window.top.window.document.body.offsetHeight*0.8 ;;
				}
  				
				dialog.callbackfun = function (paramobj, id1) {
				};
				dialog.Drag = true;
				dialog.show();
  			});
  		});
  		
  	</script>
  </head>
  <body>
  	<!-- 顶部 -->
	<jsp:include page="/rdeploy/indexTop.jsp" flush="false">
		<jsp:param name="modename" value="<%=modename %>"/>
		<jsp:param name="modeurl" value="<%=modeurl %>"/>
	</jsp:include>  
  	<div class="content">
  	
 		<%
 		while (rs.next()) {
 		    String infoid = rs.getString("id");
 		    String infoname = rs.getString("infoname");
 		    int isuse = Util.getIntValue(Util.null2String(rs.getString("isUse")), 0);
 		    String subcompanyid = rs.getString("Subcompanyid");
 		    
 		    
 		    boolean isdel = PortalUtil.isdelhp(infoid);
 		    
 		%>
 		<!-- item block -->
  		<div class="item">
  			<div class="itemtitle">
  				<%=infoname %>
  			</div>
  			<div class="itemico">
  				<img src="/rdeploy/assets/img/portal/portal<%=isuse==0 ? "_dis" : "" %>.png" title="点击进入详细设置">
  			</div>
  			<div class="itemoperation">
  				<span class="operationspan <%=isuse==0 ? "operationspan2" : "" %>" status="<%=isuse %>" title="<%=isuse==0 ? "点击启用" : "点击禁用" %>"></span>
  			</div>
  			
  			<div class="itemclose" title="删除">
  				<%
  				String imgstyle = "";
  				if (!isdel) {
  				  imgstyle = " style='display:none;' ";
  				}
  				%>
  				<img src="/rdeploy/assets/img/close.png" width="25px" height="25px" <%=imgstyle %>>
  			</div>
  			<input type="hidden" name="hpinfoid" value="<%=infoid %>">
  			<input type="hidden" name="subcompanyid" value="<%=subcompanyid %>">
  		</div>
 		<%
 		}
 		%>
 		
 		<!-- add item block -->
  		<div class="item additem">
  			<div class="itemtitle">
  				新建门户
  			</div>
  			<div class="itemico">
  				<img src="/rdeploy/assets/img/new.png">
  			</div>
  			<!-- 
  			<div class="itemoperation">
  				<span class="operationspan" status="1"></span>
  			</div>
  			
  			<div class="itemclose">
  				<img src="/rdeploy/assets/img/close.png" width="25px" height="25px">
  			</div>
  			 -->
  		</div>
  	</div>
  
  </body>
</html>
