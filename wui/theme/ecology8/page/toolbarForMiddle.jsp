
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.file.Prop" %>

<%@ include file="/times.jsp" %>
<jsp:useBean id="signRs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rtxClient" class="weaver.rtx.RTXClientCom" scope="page" />
<jsp:useBean id="hrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />

<%
    /*用户验证*/
    User user = HrmUserVarify.getUser(request, response);
    if (user == null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }

	 String skin = (String)request.getAttribute("REQUEST_SKIN_FOLDER");
	//------------------------------------
	//签到部分 Start
	//------------------------------------
	String[] signInfo = HrmScheduleDiffUtil.getSignInfo(user);
	boolean isNeedSign = Boolean.parseBoolean(signInfo[0]);
	String sign_flag = signInfo[1];
	String signType = signInfo[2];
	//------------------------------------
	//签到部分 End
	//------------------------------------
    
int userId=user.getUID();
boolean canMessager=false;
boolean isHaveEMessager=Prop.getPropValue("Messager2","IsUseEMessager").equalsIgnoreCase("1");
boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1");
int isHaveMessagerRight = PluginUserCheck.checkPluginUserRight("messager",userId+"");
if((isHaveMessager&&userId!=1&&isHaveMessagerRight==1)||isHaveEMessager){
	canMessager=true;
}

%>
<%!
private String formatDate(String format, Date date) {
	SimpleDateFormat sdf = new SimpleDateFormat(format);
	Calendar calendar = Calendar.getInstance();
	if (date == null) {
		date = new Date();
	}
	calendar.setTime(date);
    return sdf.format(calendar.getTime());
}
%>

<script language=javascript>
function signInOrSignOut(signType){
    if(signType != 1){
	    var ajaxUrl = "/wui/theme/ecology8/page/getSystemTime.jsp";
		ajaxUrl += "?field=";
		ajaxUrl += "HH";
		ajaxUrl += "&token=";
		ajaxUrl += new Date().getTime();
		
		jQuery.ajax({
		    url: ajaxUrl,
		    dataType: "text", 
		    contentType : "charset=UTF-8", 
		    error:function(ajaxrequest){}, 
		    success:function(content){
		    	var isWorkTime = jQuery.trim(content);
		    	if (isWorkTime == "true") {
		       window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(26273, user.getLanguage())%>',function(){
		       	writeSignStatus(signType);
		       },function(){
		       	return;
		       })     
		      }else{
		      	writeSignStatus(signType);
		      }
		    }  
	    });
    } else {
    	writeSignStatus(signType);
    }
}

function writeSignStatus(signType) {
	var ajax=ajaxInit();
    ajax.open("POST", "/hrm/schedule/HrmScheduleSignXMLHTTP.jsp?t="+Math.random(), true); 
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("signType="+signType);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            	jQuery("#sign_dispan").text("<%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%>");
                
                jQuery("#sign_dispan").prev().attr("src","/wui/theme/ecology8/page/images/signOut_wev8.png")
             
                showPromptForShowSignInfo(ajax.responseText, signType);
                jQuery("#sign_dispan").attr("_signFlag", 2);
                if(navigator.userAgent.indexOf("MSIE")>0 && navigator.userAgent.indexOf("MSIE 6.0") > 0){  
					DD_belatedPNG.fix('.tbItm,#toolbarMoreBlockTop,.searchBlockBgDiv,#sign_dispan,.topBlockDateBlock,.toolbarTopRight,background');
				}
            }catch(e){
            }
        }
    }
}

//type  1:显示提示信息
//      2:显示返回的历史动态情况信息
function showPromptForShowSignInfo(content, signType){
    var targetSrc = "";
	content = jQuery.trim(content).replace(/&nbsp;/g, "");
	var confirmContent = "<div style=\"margin-left:5px;margin-right:5px;\">" + content.substring(content.toUpperCase().indexOf('<TD VALIGN="TOP">') + 17, content.toUpperCase().indexOf("<BUTTON"));
	
    var checkday="";
	if(signType==1) checkday="prevWorkDay";
	if(signType==2) checkday="today";
	jQuery.post("/blog/blogOperation.jsp?operation=signCheck&checkday="+checkday,"",function(data){
		var dataJson=eval("("+data+")");
		if (dataJson.isSignRemind==1){
		    if(!dataJson.prevWorkDayHasBlog&&signType==1){
				confirmContent += "<br><br><span style=\"color:red;\"><%=SystemEnv.getHtmlLabelName(26987,user.getLanguage())%></span>";
				targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
			}else if(!dataJson.todayHasBlog&&signType==2){
				confirmContent += "<br><br><span style=\"color:red;\"><%=SystemEnv.getHtmlLabelName(26983,user.getLanguage())%></span>";
				targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
			}
			
			confirmContent += "</div>";
			if (targetSrc != undefined && targetSrc != null && targetSrc != "") {
				Dialog.confirm(
					confirmContent, function (){
						window.open(targetSrc);
					}, function () {}, 520, 90,false
			    );
			} else {
				Dialog.alert(confirmContent, function() {}, 520, 60,false);
			}
			
		    return ;
		}
		confirmContent += "</div>";
		Dialog.alert(confirmContent, function() {}, 520, 60,false);
    });
}


function onCloseDivShowSignInfo(){
    var showTableDiv  = document.getElementById('divShowSignInfo');
    var oIframe = document.createElement('iframe');
    
    divShowSignInfo.style.display='none';
    message_Div.style.display='none';
    if (document.all.HelpFrame && document.all.HelpFrame.style) {
        document.all.HelpFrame.style.display='none'
    }
}

function ajaxInit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function getNowTime(){
        //取得当前时间
        var now= new Date();
        var hour=now.getHours();
        
        if (hour < 18) {
            return false;
        }
        return true;
}
</script>


<script type="text/javascript">
<!--
    jQuery(document).ready(function() {
    	//Added by wcd 2014-10-16
    	/*if("<%=String.valueOf(isNeedSign && "1".equals(signType))%>" == "true"){
			Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21415,user.getLanguage())%>",function(){
				signInOrSignOut(<%=signType%>);
			});
		}*/
        /*jQuery(".tbItm").hover(function() {
			/** by zfh 2011-09-20
			*由于IE用jQuery无法获取background-position的值，支持background-position-y，background-position-x，
			*而Safri，firefox，chrome正好相反，先使用下面方法获取background-position的值
			*//*
        	var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				jQuery(jQuery(this)[0]).css("background-position-y","-25px");
			}else{
				bp=bp.split(" ","1")[0];
				jQuery(jQuery(this)[0]).css("background-position",bp+"  -25px");
			}
        }, function() {
            var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				jQuery(jQuery(this)[0]).css("background-position-y","0px");
			}else{
				bp=bp.split(" ","1")[0];
				jQuery(jQuery(this)[0]).css("background-position",bp+" 0px");
			}
        });*/
        
        jQuery(".dropdown img.flag").addClass("flagvisibility");

        jQuery(".selectTile a").click(function() {
            jQuery(".selectContent ul").toggle();
            if(jQuery(".selectContent ul").css("display")=="none"){
            	jQuery(this).closest("div#sample").removeClass("sampleSelected");
            }else{
            	jQuery(this).closest("div#sample").addClass("sampleSelected");
            }
        });
                    
        jQuery(".selectContent ul li a").click(function() {
            var text = jQuery(this).children("span").html();
            jQuery(".selectTile a").children("span").html(text);
            jQuery("input[name='searchtype']").val(jQuery(this).children("span").attr("searchType"));
            jQuery(".selectContent ul").hide();
            jQuery(this).closest("div#sample").removeClass("sampleSelected");
        });
                    
        function getSelectedValue(id) {
            return jQuery("#" + id).find("selectContent a span.value").html();
        }

        jQuery(document).bind('click', function(e) {
            var $clicked = jQuery(e.target);
            if (! $clicked.parents().hasClass("dropdown")){
                jQuery(".selectContent ul").hide();
				jQuery(".selectContent ul").closest("div#sample").removeClass("sampleSelected");
			}
        });


        jQuery("#flagSwitcher").click(function() {
            jQuery(".dropdown img.flag").toggleClass("flagvisibility");
        });
        
        jQuery("#searchbt").hover(function() {
			var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				//jQuery(jQuery(this)[0]).css("background-position-x","-27px");
			}else{
				bp=bp.split(" ","2")[1];
				//jQuery(jQuery(this)[0]).css("background-position","-27px "+bp);
			}
        }, function() {
            var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				jQuery(jQuery(this)[0]).css("background-position-x","-0px");
			}else{
				bp=bp.split(" ","2")[1];
				jQuery(jQuery(this)[0]).css("background-position","-0px "+bp);
			}
        });
        
        //更多按钮
        jQuery(".toolbarMore").bind("click", function() {
        	jQuery("#toolbarMore").hide();
        });
        
        jQuery("#toolbarMoreBtn").hover(function(){
        },function(){
        	window.setTimeout(function(){
        		if(jQuery("#toolbarMoreBtn").data("isOpen")){
        			jQuery("#toolbarMore").hide();
        			jQuery("#toolbarMoreBtn").removeClass("moreBtnSel");
        			jQuery("#toolbarMoreBtn").data("isOpen",false);
        		}
        	},600);
        });
        
        jQuery("#toolbarMore").hover(function() {
        	jQuery("#toolbarMoreBtn").data("isOpen",false);
        }, function() {
        	jQuery("#toolbarMore").hide();
        	jQuery("#toolbarMoreBtn").removeClass("moreBtnSel");
        	jQuery("#toolbarMoreBtn").data("isOpen",false);
        });
        
        jQuery(".moreBtn_option").hover(function(){
		 	jQuery(this).addClass("moreBtn_optionSelect");
		 },function(){
		 	jQuery(this).removeClass("moreBtn_optionSelect");
		 });
        
        //为了兼容ie6，收藏夹iframe动态载入
        jQuery("#navFav").css("position", "relative");
		 jQuery("#navFav").load("/wui/theme/ecology8/page/FavouriteShortCut.jsp")
		//ie6下下拉菜单被select遮盖
		jQuery("#searchBlockUl iframe").css("height", jQuery("#searchBlockUl").height());
		
		jQuery("#searchBlockUl").hover(function () {
		}, function () {
			jQuery("#searchBlockUl").hide();
			jQuery("#searchBlockUl").closest("div#sample").removeClass("sampleSelected");
		});
		
		jQuery("#searchBlockUl li a").hover(function(){
			var src = jQuery(this).find("img").attr("src");
			src = src.replace(/\.png$/,"_sel_wev8.png");
			jQuery(this).find("img").attr("src",src);
		},function(){
			var src = jQuery(this).find("img").attr("src");
			src = src.replace(/_sel\.png$/,".png");
			jQuery(this).find("img").attr("src",src);
		});
		
		jQuery(".selectTile").hover(function () {
		}, function () {
			var clientx = event.clientX;
			var clienty = event.clientY;
			
			var elex = jQuery(this).offset().left;
			var eley = jQuery(this).offset().top;
		
			if (clientx < elex || elex > jQuery(this).offset().right || clienty < eley) {
				jQuery("#searchBlockUl").hide();
				jQuery("#searchBlockUl").closest("div#sample").removeClass("sampleSelected");
			} else {
				return;
			}
		});
		
    });
    
function toolbarMore() {
	jQuery("#toolbarMore").toggle();
	if(jQuery("#toolbarMore").css("display")=="none"){
		jQuery("#toolbarMoreBtn").removeClass("moreBtnSel");
		jQuery("#toolbarMoreBtn").data("isOpen",false);
	}else{
		jQuery("#toolbarMoreBtn").addClass("moreBtnSel");
		jQuery("#toolbarMoreBtn").data("isOpen",true);
	}
}

//function goopenWindow(url){
//    var chasm = screen.availWidth;
//    var mount = screen.availHeight;
//    if(chasm<650) chasm=650;
//    if(mount<700) mount=700;
//    window.open(url,"PluginCheck","scrollbars=yes,resizable=no,width=690,Height=650,top="+(mount-700)/2+",left="+(chasm-650)/2);
//}

function goopenWindow(title,url){
	var dlg=new window.top.Dialog();//定义Dialog对象
	var title = title;
	dlg.currentWindow = window;
	dlg.Model=true;
	dlg.Width=730;//定义长度
	dlg.Height=600;
	dlg.URL=url;
	dlg.Title=title;
	dlg.show();
	}

function goUrl(url){
	document.getElementById("mainFrame").src = url;
}

function showCalendarDialog(){
	var diag_xx = new Dialog();
	diag_xx.Width = 600;
	diag_xx.Height = 387;
	
	diag_xx.ShowCloseButton=true;
	diag_xx.Title = "<%=SystemEnv.getHtmlLabelName(490,user.getLanguage())%>";
	diag_xx.Modal = false;

	diag_xx.URL = "/calendar/wnl2.jsp";
	diag_xx.show();
}

function setSafeSite(){
  jQuery("#downLoadReg").attr("src","/weaverplugin/EcologyPlugin.zip");
}
//-->
</script>

<script type="text/javascript">
<!--
function toolbarSearchIframeOnload(_this) {
}
//function showVersion(){
//	 about=window.showModalDialog("/systeminfo/version.jsp","","dialogHeight:460px;dialogwidth:660px;help:no");
//}

function showVersion(){	
	var dlg=new window.top.Dialog();//定义Dialog对象
	var url = "/systeminfo/version.jsp";
	var title = "<%=SystemEnv.getHtmlLabelName(16900,user.getLanguage()) %>e-cology";
	dlg.currentWindow = window;
	dlg.Model=true;
	dlg.Width=630;//定义长度
	dlg.Height=400;
	dlg.URL=url;
	dlg.Title=title;
	dlg.show();
}

function clearVal(obj){
	var temp = '<%=SystemEnv.getHtmlLabelName(84128,user.getLanguage()) %>';
	if(obj.value== temp){
		obj.value="";
	}
	jQuery(obj).css("color","#fff");
}

function recoverVal(obj){
	if(obj.value==''||obj.value==null){
		obj.value="<%=SystemEnv.getHtmlLabelName(84128,user.getLanguage()) %>";
	 	jQuery(obj).css("color","#429ce1");
	}
}




//-->
</script>


<STYLE TYPE="text/css">
    .tbItm{
        cursor:pointer;
        background-position: left center;
        height:20px;
        width:30px;
		color:#fff;
		font-size:14px;
		color:rgb(205,205,205);
       /* background:url(/wui/theme/ecology8/skins/<%=skin %>/page/ecologyShellImg_wev8.png);*/
    }
    
    .tbItmNav{
    	 cursor:pointer;
    	 width:106px;
    	 color:#fff;
    }
    
    .toolbarItemSelected{
        filter:alpha(opacity=99);-moz-opacity:0.99;
    }

	.searchkeywork {width: 112px;font-size: 12px;height:32px !important;margin-top:1;background:none;border:none !important;color:#333 ;line-height:30px;}
	.dropdown {
		padding-left:5px; 
		font-size:11px; 
		color:#000;
		height:35px;
		border-left:1px solid transparent;
		border-top:1px solid transparent;
		border-right:1px solid transparent;
	}
	.selectContent, .selectTile, .dropdown ul { margin:0px; padding:0px;}
	.selectContent { position:relative;z-index:6; }
	.dropdown a, .dropdown a:visited { color:#666666; text-decoration:none; outline:none;}
	.dropdown a:hover { color:#5d4617;}
	.selectTile a:hover { color:#5d4617;}
	.selectTile a {background:none; display:block;width:40px;margin-left:4px;margin-top:1px;}
	.selectTile a span {cursor:pointer; display:block; padding:6 0 0 0;background:none;height:25px;font-size:14px; }
	.selectContent ul { 
		background:#fff none repeat scroll 0 0; 
		border-left:1px solid rgb(170,210,242); 
		border-right:1px solid rgb(170,210,242); 
		border-bottom:1px solid rgb(170,210,242); 
		color:#C5C0B0; 
		display:none;
		left:-6px; 
		position:absolute; 
		top:8px; 
		width:66px; 
		min-width:50px; 
		list-style:none;}
	.dropdown span.value { display:none;}
	.selectContent ul li{list-style:none;!important;height:25px;}
	.selectContent ul li a { padding:2px 0 2px 0px; display:block;margin:0;width:66px;height:21px;font-size:14pt; }
	.selectContent ul li a:hover { background-color:#218bde;color:#fff!important;}
	.selectContent ul li a img {border:none;vertical-align:middle;}
	.selectContent ul li a span {margin-left:5px;}
	.flagvisibility { display:none;}
	.sampleSelected{
		background-color:#fff;
		border-left:1px solid rgb(170,210,242);
		border-top:1px solid rgb(170,210,242);
		border-right:1px solid rgb(170,210,242);
	}
	.sampleSelected .selectTile a span{
		color:#228cdf!important;
	}
	.sampleSelected .selectTile a div{
		color:#fff!important;
	}
	.sampleSelected .e8_dropdown{
		background-image:url(/wui/theme/ecology8/page/images/toolbar/up_wev8.png)!important;
	}
	.dropdown .e8_dropdown{
		background-image:url(/wui/theme/ecology8/page/images/toolbar/down_wev8.png);
		width:12px;
		height:12px;
		float:left;
		margin-top:10px;
		background-position:50% 50%;
	}

</STYLE>
<iframe id="downLoadReg" style="display: none;"></iframe>
<div class="absolute" style="top:0px;right:0px;">
<table align="right" style="height:50px;"  cellpadding="0px" cellspacing="0px" >
	<tr width="100%">
       
		<td width="100%">
    	    <TABLE style="height:100%;" cellpadding="0px" cellspacing="0px"  width="100%" align="right">
    	    	<tr align="left">
    	    		<!-- 主页 -->
			       <!-- <td onClick="javascript:dymlftenu(this);" title="<%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%>">
						<span style="background-position:0 0;display:block;" class="tbItm"></span>
			        </td>-->
			         <!--<td style="width:10px;height:20px;" align="center">
			        	<table cellpadding="0px" cellspacing="0px"><tr><td width="2px">-->
						<!--background:url(/wui/theme/ecology8/skins/<%//=skin %>/page/ecologyShellImg_wev8.png);-->
			        	<!--	<span style="margin-right:7px;display:block;width:2px;height:20px;background-position:0 -50;" class="toolbarSplitLine"></span>
			        	</td></tr></table>
			        </td>-->
					
			        <!-- Line -->
			        <!--<td style="width:10px;height:20px;" align="center">
			        	<table cellpadding="0px" cellspacing="0px"><tr><td width="2px">
			        		<span style="background:url(/wui/theme/ecology8/skins/<%//=skin %>/page/ecologyShellImg_wev8.png);margin-right:7px;display:block;width:2px;height:20px;background-position:0 -50;" class="toolbarSplitLine"></span>
			        	</td></tr></table>
			        </td>-->
					 <!-- 待办 
			        <td style="background:url(/wui/theme/ecology8/page/images/unhandlerequest_wev8.png) no-repeat scroll center top;"  class="backgroundPosition"  title="<%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%>">
			        	<a style="display:block;" class="tbItm" href="/workflow/request/RequestView.jsp" target="mainFrame" ></a>
			        </td>-->
					<%if(false && canMessager){%>	
			        <!-- 信息中心 -->
			        <td onClick="mainFrame.history.go(1)"  style="background:url(/wui/theme/ecology8/page/images/info_wev8.png) no-repeat scroll center center;"  class="backgroundPosition"  >
			        	<span style="display:block;" class="tbItm"></span>
			        </td>
					<%}%>
					
					   <%
						if (isNeedSign) {
							int tdWidth=60;
							if(user.getLanguage()==8){
								tdWidth = 75;
							}
						%>	
						<td >
						<div style="position: relative;width:<%=tdWidth %>px;height: 40px;cursor: pointer;">
							<img onclick="jQuery(this).next().trigger('click')" src="/wui/theme/ecology8/page/images/signIn_wev8.png" style="position:absolute;left:0px;top:13px;cursor:pointer;">
							<div class="leftColor" onclick="signInOrSignOut(jQuery(this).attr('_signFlag'))" style="position:absolute;left:15px!important;top:13px;color:#C8C8C8;overflow:hidden;text-overflow:ellipsis;cursor:pointer;" _signFlag="<%=sign_flag %>" id="sign_dispan">
							<%="1".equals(sign_flag) ? SystemEnv.getHtmlLabelName(20032,user.getLanguage()) : SystemEnv.getHtmlLabelName(20033,user.getLanguage()) %>
							</div>
						</div>
						</td>
						<td >
							<div style="width: 1px;background: #ffffff;opacity:0.2;margin-top:10px;margin-bottom: 10px;height: 20px">
							</div>
						</td>
						
						<%
						}
						%>
			        
			        <td id="toolbarMoreBtn" onclick="javascript:toolbarMore();" title="<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>" style="width:40px;background:url(/wui/theme/ecology8/page/images/moremiddle_wev8.png) no-repeat scroll center center;position:relative;"> 
			        	<span style="display:block;" class="tbItm"></span>
				   </td>
					<td style="position:absolute;right:20px!important;top:40px;">
					<!--background-image:url(/wui/theme/ecology8/skins/<%=skin %>/page/top/toolbarMoreTop_wev8.png);-->
						<div id="toolbarMore" class="moreBtn" style="z-index: 999px">
			        		<div id="toolbarMoreBlockTop" style="background-repeat:no-repeat;height:11px;overflow:hidden;width:184px;"></div>
							<div class="moreBtn_option" style="margin-top:-11px;background-color: #d7d7d7;color:#6e7171;"  onclick="javascript:window.open('/wui/main.jsp')">
								<span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/frontend_wev8.png" style="vertical-align:middle;"></span>
								<span><%=SystemEnv.getHtmlLabelName(83516,user.getLanguage()) %></span>
							</div>
							
							<div class="moreBtn_option" style=""  onclick="javascript:goopenWindow('<%=SystemEnv.getHtmlLabelName(7171,user.getLanguage()) %>','/weaverplugin/PluginMaintenance.jsp')">
							<span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/download_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(7171,user.getLanguage()) %></span>
							</div>
							<div class="moreBtn_option" onclick="javascript:setSafeSite()">
							<span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/plugin_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(28422,user.getLanguage()) %></span></div>
							<div class="moreBtn_option" onclick="javascript:goopenWindow('<%=SystemEnv.getHtmlLabelName(18014,user.getLanguage()) %>','/hrm/HrmTab.jsp?_fromURL=licenseInfo')">
							<span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/license_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(18014,user.getLanguage()) %></span></div>
							<div class="moreBtn_option" onclick="javascript:goopenWindow('<%=SystemEnv.getHtmlLabelName(774,user.getLanguage()) %>','/docs/tabs/DocCommonTab.jsp?_fromURL=52')">
							<span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/syssetting_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(774,user.getLanguage()) %></span></div>
							<div class="moreBtn_option" onclick="javascript:showVersion()">
							<span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/version_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(567,user.getLanguage()) %></span></div>
						</div>
					</td>
					 
			        <td style="" onclick="logout()" title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>" >
			        	<div style="display:block;background:url(/wui/theme/ecology8/page/images/quitmiddle_wev8.png) no-repeat scroll center center;"class="tbItm f12 <%=isNeedSign?"":"quit"%>" >
			        	</div>
					</td>
    	    	</tr>
    		</TABLE> 
    	</td>
    </tr>
    
	<!--<tr>
		<td height="2px;"></td>
	</tr>-->
	
</table>
</div>
<script type="text/javascript">

function logout(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>",function(){
		window.location='/login/Logout.jsp';
	})
}

</script>

