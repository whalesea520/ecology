
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User,
                 weaver.hrm.report.schedulediff.HrmScheduleDiffUtil"%>

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
		    	if (isWorkTime == "true" && !confirm('<%=SystemEnv.getHtmlLabelName(26273, user.getLanguage())%>')) {
		            return;
		        }
		    	writeSignStatus(signType);
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
		//jQuery("#searchBlockUl iframe").css("height", jQuery("#searchBlockUl").height());
		//console.log(jQuery("#searchBlockUl").height());
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
		jQuery("#toolbarMoreTD").css({"right":"19px","top":"40px"})
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
	//var chasm = screen.availWidth;
    //var mount = screen.availHeight;
    //if(chasm<600) chasm=600;
    //if(mount<500) mount=500;
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
var title = "关于e-cology";
dlg.currentWindow = window;
dlg.Model=true;
dlg.Width=630;//定义长度
dlg.Height=400;
dlg.URL=url;
dlg.Title=title;
dlg.show();
}

function clearVal(obj){
	if(obj.value=='请输入关键词搜索'){
		obj.value="";
	}
	//jQuery(obj).css("color","#fff");
}

function recoverVal(obj){
	if(obj.value==''||obj.value==null){
		obj.value="请输入关键词搜索";
	 	//jQuery(obj).css("color","#429ce1");
	}
}




//-->
</script>

<iframe id="downLoadReg" style="display: none;"></iframe>
<div>
<table align="right" style="height:50px;"  cellpadding="0px" cellspacing="0px" >
	<tr width="100%">
       
		<td width="100%">
    	    <TABLE style="height:100%;" cellpadding="0px" cellspacing="0px"  width="100%" align="right">
    	    	<tr align="left">
    	    		<!-- 主页 -->
			       <!-- <td onClick1="javascript:dymlftenu(this);" title="<%=SystemEnv.getHtmlLabelName(227,user.getLanguage())%>">
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
			        <%
			        boolean havaMobile = false;
			        if(Prop.getPropValue("EMobile4","serverUrl")!=null&&!Prop.getPropValue("EMobile4","serverUrl").equals("")){
			        	havaMobile = true;
			        }
			        boolean showDownload = Prop.getPropValue("EMobileDownload","showDownload").equalsIgnoreCase("1");
			        String version = Prop.getPropValue("EMobileVersion","version");

			        %>
			       
					
			       
			        
			         <%if(havaMobile){%>	
			        <!-- emessage -->
			        <td onClick1="window.open('http://emobile.weaver.com.cn/customerproduce.do?serverVersion=<%=version %>')" title="E-Mobile"  class="emobile"  style="width:40px;background:url(/wui/theme/ecology8/page/images/info_wev8.png) no-repeat scroll center 50%;"  class="backgroundPosition"  >
			        	<span style="display:block;" class="tbItm"></span>
			        </td>
			       
					<%}%>
					
					<%if(canMessager){%>	
			        <!-- emessage -->
			        <td onClick1="javascript:window.open('/messager/installm3/emessageproduce.jsp','mainFrame')" title="E-Message"  class="emessage"  style="width:40px;background:url(/wui/theme/ecology8/page/images/info_wev8.png) no-repeat scroll center 50%;"  class="backgroundPosition"  >
			        	<span style="display:block;" class="tbItm"></span>
			        </td>
			         
					<%}%>
					
			        
			        <!-- 收藏夹 -->
			        <td class="fav" onClick1=""  title="<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>" style="width:40px;background:url(/wui/theme/ecology8/page/images/favorite_wev8.png) no-repeat scroll center 50%;" class="backgroundPosition">
			        	 <span><ul id="navFav"> </ul></span>
			        </td>
			       
			        <!-- 帮助 -->
			        <!--<td onClick1="alert('帮助')" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>" >
			        	<span style="background-position:-25 0;display:block;" class="tbItm">帮助</span>
			        </td>-->
			       

                     <%if(rtxClient.isValidOfRTX()){
						 RTXConfig rtxConfig = new RTXConfig();
						 String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
						%>
						<td>
			        	
			        </td>
						<%
						 if("ELINK".equals(RtxOrElinkType) && !"sysadmin".equals(user.getLoginid())){ 
					 %>
					<td class="elink" onClick1="javascript:openEimClient()" title="<%=SystemEnv.getHtmlLabelName(27463,user.getLanguage())%>" style="width:40px;background:url(/wui/theme/ecology8/page/images/elink_wev8.png) no-repeat scroll center 50%;" class="backgroundPosition">
			        	<span style="display:block;" class="tbItm"></span>
			        </td>
			      
					<%} else if(!"sysadmin".equals(user.getLoginid())){%>
					<td class="rtx" onClick1="javascript:openRtxClient()" title="<%=SystemEnv.getHtmlLabelName(83530,user.getLanguage())%>" style="width:40px;background:url(/wui/theme/ecology8/page/images/rtx_wev8.png) no-repeat scroll center 50%;" class="backgroundPosition">
			        	<span style="background-position:-395 0;display:block;" class="tbItm"></span>
			        </td>					
					<%}
					%>
					 
					<%
                     }%>
			        
			        <!--<td style="width:10px;height:20px;" align="center">
			        	<table cellpadding="0px" cellspacing="0px"><tr><td width="2px">
			        		<span style="margin-right:7px;display:block;width:2px;height:20px;background-position:0 -50;" class="toolbarSplitLine"></span>
			        	</td></tr></table>
			        </td>-->
			        
			        <td id="toolbarMoreBtn" class="toolbarmore" onClick1="javascript:toolbarMore();" title="<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>" style="width:40px;background:url(/wui/theme/ecology8/page/images/more_wev8.png) no-repeat scroll center 50%;position:relative;"> 
			        	<span style="display:block;" class="tbItm"></span>
				   </td>
					<td style="position:absolute;right:19px;top:40px;" id="toolbarMoreTD">
					<!--background-image:url(/wui/theme/ecology8/skins/<%=skin %>/page/top/toolbarMoreTop_wev8.png);-->
						<div id="toolbarMore" class="moreBtn">
			        		<div id="toolbarMoreBlockTop" style="background-repeat:no-repeat;height:11px;overflow:hidden;width:184px;"></div>
			        		<%--<TABLE  cellpadding="10" cellspacing="3px" align="center" width="182px" style="background-image:url(/wui/theme/ecology8/page/images/toolbar/morebg_wev8.png);margin:0;background-repeat:no-repeat;">
			        			<tr><td colspan="5" height="5px"></td></tr>
				    	    	<tr align="center">
								<!--后退-->
									<td onClick1="mainFrame.history.go(-1);" title="<%=SystemEnv.getHtmlLabelName(15122,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/back_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm back"></span>
							        </td>
							        <!--前进-->
							        <td onClick1="mainFrame.history.go(1);" title="<%=SystemEnv.getHtmlLabelName(15123,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/forward_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm"></span>
							        </td>
									<!--刷新-->
									<td onClick1="document.getElementById('mainFrame').contentWindow.document.location.reload();" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/refresh_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm"></span>
							        </td>
									<!--上部隐藏-->
									<td onClick1="topBlockContractionOrExpand();" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/top_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm"></span>
							        </td>
									<!--左部隐藏-->
				    	    		<td onClick1="leftBlockContractionOrExpand();" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/left_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm"></span>
							        </td>
							        <!--插件下载-->
							        <td onClick1="javascript:goopenWindow('/weaverplugin/PluginMaintenance.jsp')" title="<%=SystemEnv.getHtmlLabelName(7171,user.getLanguage())%>">
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/plugin_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							       
							    </tr>
							    <tr align="center">
								<!--显示版本-->
								 <td onClick1="javascript:showVersion()" title="<%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>">
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/version_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
									<!--新建流程
				    	    		<td onClick1="window.open('/workflow/request/RequestType.jsp?needPopupNewPage=true','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%>">
										<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/workflow_wev8.png) no-repeat;;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>-->
									<!--新建文档
									<td onClick1="window.open('/docs/docs/DocList.jsp?isuserdefault=1','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>">
										<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/doc_wev8.png) no-repeat;;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>-->
									<!--日程
							        <td onClick1="window.open('/workplan/data/WorkPlan.jsp?resourceid=<%=user.getUID()%>','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(18480,user.getLanguage())%>">
										<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/date_wev8.png) no-repeat;;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>-->
									<!--ecology控件设置-->
							        <td title="Ecology<%=SystemEnv.getHtmlLabelName(28422,user.getLanguage())%>" onClick1="setSafeSite()">
							            <span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/activeXSetting_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td></td>
							    </tr>
							    <tr><td colspan="5" height="5px"></td></tr>
			        		</TABLE>
			        		<TABLE cellpadding="0px" cellspacing="0px" height="5px" width="100%" style="background-repeat: no-repeat;"><tr><td height="5px"></td></tr></TABLE>
						<iframe src="javascript:false" style="filter:alpha(opacity=0);opacity:0;position: absolute; visibility: inherit; top: 0px; left: 0px; width: 184px; height: 200px; z-index: -1; filter='progid:dximagetransform.microsoft.alpha(style=0,opacity=0)';" > 
    </iframe>  --%>		<!-- modified by wcd 2014-09-24 -->
    					<div class="moreBtn_option" style="margin-top:-5px;"  onClick1="javascript:goUrl('/hrm/HrmTab.jsp?_fromURL=OrgChartHRM')">
							<span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/com_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(562,user.getLanguage()) %></span>
							</div>
							<div class="moreBtn_option" style=""  onClick1="javascript:goopenWindow('<%=SystemEnv.getHtmlLabelName(83543,user.getLanguage())%>','/weaverplugin/PluginMaintenance.jsp')">
							<span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/download_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(83543,user.getLanguage())%></span>
							</div>
							<div class="moreBtn_option" onClick1="javascript:setSafeSite()">
							<span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/plugin_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(28422,user.getLanguage())%></span></div>
							<div class="moreBtn_option" onClick1="javascript:goopenWindow('<%=SystemEnv.getHtmlLabelName(18014,user.getLanguage())%>','/hrm/HrmTab.jsp?_fromURL=licenseInfo')">
							<span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/license_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(18014,user.getLanguage())%></span></div>
							<div class="moreBtn_option" onClick1="javascript:showVersion()">
							<span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/version_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></span></div>
						</div>
					</td>
						
			        <td  class="logout" style="width:40px;background:url(/wui/theme/ecology8/page/images/more_wev8.png) no-repeat scroll center 50%;" onClick1="javascript:if(window.confirm('<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>')) {window.location='/login/Logout.jsp';}" title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>" >
			        	<div  class="tbItm f12 <%=isNeedSign?"":"quit"%>" >
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




