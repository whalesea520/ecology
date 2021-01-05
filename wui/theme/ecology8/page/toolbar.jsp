
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
<%@page import="weaver.hrm.common.Tools"%>
<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@page import="weaver.rdeploy.portal.PortalUtil"%>
<%@page import="weaver.hrm.schedule.HrmScheduleKqUtil"%>
<%@page import="weaver.hrm.schedule.HrmKqSystemComInfo"%>
<%@page import="weaver.common.StringUtil"%>

<%@ include file="/times.jsp" %>

<jsp:useBean id="signRs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rtxClient" class="weaver.rtx.RTXClientCom" scope="page" />
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />		
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
	String _signType = signInfo.length >= 4 ? signInfo[3] : "1";
	String _signStartTime = signInfo.length >= 5 ? signInfo[4] : "";
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
        	hideOtherHoverDiv('search');
		 	
            jQuery(".selectContent ul").toggle();
            if(jQuery(".selectContent ul").css("display")=="none"){
            	jQuery(this).closest("div#sample").removeClass("sampleSelected");
            }else{
            	jQuery(this).closest("div#sample").addClass("sampleSelected");
            }
        });
                    
        jQuery(".selectContent ul li a").click(function() {
            //获得元素信息
            var sibling = jQuery(this).nextAll();
            if(sibling.length > 0){
	            for(var i=0; i<sibling.length;i++){
	                if($(sibling[i]).attr("name") == "mainid"){
	                    $("#mainid").val($(sibling[i]).html());
	                }else if($(sibling[i]).attr("name") == "stype"){
	                    $("#stype").val($(sibling[i]).html());
	                }else{
	                    $("#fieldname").val($(sibling[i]).html());
	                }
	            }
            }
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
        //jQuery("#navFav").css("position", "relative");
		//jQuery("#navFav").load("/wui/theme/ecology8/page/FavouriteShortCut.jsp")
		 	/**页面加载时不加载菜单，改为点击时才加载，以保证每次打开都是最新的收藏夹快捷菜单*/
		jQuery("td.fav").css("cursor","pointer").bind("click",function(){
			/*
			 var subMenus = $mt("subMenusContainer");  //下拉菜单
			 if(subMenus)   //已存在，先销毁
			 {
			     subMenus.destroy();
			 }
			 jQuery("#navFav").load("/wui/theme/ecology8/page/FavouriteShortCut.jsp?t=" + Math.random(),function(){
			 	 if(myMenu)
			 	 {
			 	 	 $mt(myMenu.options.subMenusContainerId).getFirst().fireEvent('show');  //默认展开第一级菜单
			 	 }	
			 })*/
			 var url = "/favourite/MyFavourite.jsp";
			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(18030,user.getLanguage())%>";
			dialog.Width = 657;
			dialog.Height = 565;
			dialog.Drag = true;
			dialog.URL = url;
			dialog.show();
		});
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
			src = src.replace(/\_wev8.png$/,"_sel_wev8.png");
			jQuery(this).find("img").attr("src",src);
		},function(){
			var src = jQuery(this).find("img").attr("src");
			src = src.replace(/_sel_wev8\.png$/,"_wev8.png");
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
	hideOtherHoverDiv('toolbar');
	
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
	if(obj.value=='<%=SystemEnv.getHtmlLabelName(84128,user.getLanguage()) %>'){
		obj.value="";
	}
	//jQuery(obj).css("color","#fff");
}

function recoverVal(obj){
	if(obj.value==''||obj.value==null){
		obj.value="<%=SystemEnv.getHtmlLabelName(84128,user.getLanguage()) %>";
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
			        <%
			        boolean havaMobile = false;
			        if(Prop.getPropValue("EMobile4","serverUrl")!=null&&!Prop.getPropValue("EMobile4","serverUrl").equals("")){
			        	havaMobile = true;
			        }
			        boolean showDownload = Prop.getPropValue("EMobileDownload","showDownload").equalsIgnoreCase("1");
			        String version = Prop.getPropValue("EMobileVersion","version");

			        %>
			       
					<!-- 邮件 -->
				<%
				int tdWidth=60;
				if(user.getLanguage()==8){
					tdWidth = 75;
				}
				%>
				<td id="tdSignInfo" <%=isNeedSign?"":"style='display: none'" %> >
				<div style="position: relative;width:<%=tdWidth %>px;height: 40px;cursor: pointer;">
					<img onclick="jQuery(this).next().trigger('click')" src="/wui/theme/ecology8/page/images/signIn_wev8.png" style="position:absolute;left:0px;top:13px;cursor:pointer;">
					<div class="leftColor" onclick="signInOrSignOut(jQuery(this).attr('_signFlag'))" style="position:absolute;left:25px;top:13px;overflow:hidden;text-overflow:ellipsis;cursor:pointer;" _signFlag="<%=sign_flag %>" id="sign_dispan">
					<%="1".equals(sign_flag) ? SystemEnv.getHtmlLabelName(20032,user.getLanguage()) : SystemEnv.getHtmlLabelName(20033,user.getLanguage()) %>
					</div>
				</div>
				</td>
				<td id="tdSignInfoLine" <%=isNeedSign?"":"style='display: none'" %>>
					<div style="width: 1px;background: #ffffff;opacity:0.2;margin-top:10px;margin-bottom: 10px;height: 20px">
					</div>
				</td>
			       
				<%if(PortalUtil.isShowToMsgPage()) {%>
                        <td onClick="window.location.href='/rdeploy/chatproject/main.jsp';" title="<%=SystemEnv.getHtmlLabelName(127956,user.getLanguage()) %>" id="imAddress" style="width:40px;background:url(/rdeploy/assets/img/cproj/chatPortal.png) no-repeat scroll center 50%;"  class="backgroundPosition"  >
                            <span style="display:block;" class="tbItm"></span>
                        </td>
                    <%}%>
                   
			         <%if(showDownload && havaMobile){%>	
			        <!-- emessage -->
			        <td onClick="window.open('http://emobile.weaver.com.cn/customerproduce.do?serverVersion=<%=version %>')" title="E-Mobile"  class="emobile"  style="width:40px;background:url(/wui/theme/ecology8/page/images/info_wev8.png) no-repeat scroll center 50%;"  class="backgroundPosition"  >
			        	<span style="display:block;" class="tbItm"></span>
			        </td>
			        
					<%}%>
					
					<%if(canMessager){%>	
			        <!-- emessage -->
			        <td onClick="javascript:window.open('/messager/installm3/emessageproduce.jsp')" title="E-Message"  class="emessage"  style="width:40px;background:url(/wui/theme/ecology8/page/images/info_wev8.png) no-repeat scroll center 50%;"  class="backgroundPosition"  >
			        	<span style="display:block;" class="tbItm"></span>
			        </td>
			       
					<%}%>
					
			        
			        <!-- 收藏夹 -->
			        <td class="fav" onClick=""  title="<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>" style="width:40px;background:url(/wui/theme/ecology8/page/images/favorite_wev8.png) no-repeat scroll center 50%;" class="backgroundPosition">
			        	 <span><ul id="navFav"> </ul></span>
			        </td>
			       
                     <%if(rtxClient.isValidOfRTX()){
						 RTXConfig rtxConfig = new RTXConfig();
						 String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
						%>
						<td>
			        	
			        </td>
						<%
						 if("ELINK".equals(RtxOrElinkType) && !RTXConfig.isSystemUser(user.getLoginid())){ 
					 %>
					<td class="elink" onClick="javascript:openEimClient()" title="<%=SystemEnv.getHtmlLabelName(27463,user.getLanguage())%>" style="width:40px;background:url(/wui/theme/ecology8/page/images/elink_wev8.png) no-repeat scroll center 50%;" class="backgroundPosition">
			        	<span style="display:block;" class="tbItm"></span>
			        </td>
			      
					<%} else if(!RTXConfig.isSystemUser(user.getLoginid())){%>
					<td class="rtx" onClick="javascript:openRtxClient()" title="<%=SystemEnv.getHtmlLabelName(83530,user.getLanguage())%>" style="width:40px;background:url(/wui/theme/ecology8/page/images/rtx_wev8.png) no-repeat scroll center 50%;" class="backgroundPosition">
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
			         
			        <td id="toolbarMoreBtn" class="toolbarmore" onclick="javascript:toolbarMore();" title="<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>" style="width:40px;background:url(/wui/theme/ecology8/page/images/more_wev8.png) no-repeat scroll center 50%;position:relative;"> 
			        	<span style="display:block;" class="tbItm"></span>
				   </td>
					<td style="position:absolute;right:15px!important;top:40px;" id="toolbarMoreTD">
					<!--background-image:url(/wui/theme/ecology8/skins/<%=skin %>/page/top/toolbarMoreTop_wev8.png);-->
						<div id="toolbarMore" class="moreBtn">
			        		<div id="toolbarMoreBlockTop" style="background-repeat:no-repeat;height:11px;overflow:hidden;width:184px;"></div>
			        		<%--<TABLE  cellpadding="10" cellspacing="3px" align="center" width="182px" style="background-image:url(/wui/theme/ecology8/page/images/toolbar/morebg_wev8.png);margin:0;background-repeat:no-repeat;">
			        			<tr><td colspan="5" height="5px"></td></tr>
				    	    	<tr align="center">
								<!--后退-->
									<td onclick="mainFrame.history.go(-1);" title="<%=SystemEnv.getHtmlLabelName(15122,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/back_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm back"></span>
							        </td>
							        <!--前进-->
							        <td onclick="mainFrame.history.go(1);" title="<%=SystemEnv.getHtmlLabelName(15123,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/forward_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm"></span>
							        </td>
									<!--刷新-->
									<td onclick="document.getElementById('mainFrame').contentWindow.document.location.reload();" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/refresh_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm"></span>
							        </td>
									<!--上部隐藏-->
									<td onclick="topBlockContractionOrExpand();" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/top_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm"></span>
							        </td>
									<!--左部隐藏-->
				    	    		<td onclick="leftBlockContractionOrExpand();" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/left_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm"></span>
							        </td>
							        <!--插件下载-->
							        <td onclick="javascript:goopenWindow('/weaverplugin/PluginMaintenance.jsp')" title="<%=SystemEnv.getHtmlLabelName(7171,user.getLanguage())%>">
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/plugin_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							       
							    </tr>
							    <tr align="center">
								<!--显示版本-->
								 <td onclick="javascript:showVersion()" title="<%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>">
							        	<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/version_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
									<!--新建流程
				    	    		<td onclick="window.open('/workflow/request/RequestType.jsp?needPopupNewPage=true','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%>">
										<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/workflow_wev8.png) no-repeat;;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>-->
									<!--新建文档
									<td onclick="window.open('/docs/docs/DocList.jsp?isuserdefault=1','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>">
										<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/doc_wev8.png) no-repeat;;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>-->
									<!--日程
							        <td onclick="window.open('/workplan/data/WorkPlan.jsp?resourceid=<%=user.getUID()%>','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(18480,user.getLanguage())%>">
										<span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/date_wev8.png) no-repeat;;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>-->
									<!--ecology控件设置-->
							        <td title="Ecology<%=SystemEnv.getHtmlLabelName(28422,user.getLanguage())%>" onclick="setSafeSite()">
							            <span style="margin-top:5px;width:20px;background:url(/wui/theme/ecology8/page/images/toolbar/activeXSetting_wev8.png)  no-repeat scroll center 50%;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td></td>
							    </tr>
							    <tr><td colspan="5" height="5px"></td></tr>
			        		</TABLE>
			        		<TABLE cellpadding="0px" cellspacing="0px" height="5px" width="100%" style="background-repeat: no-repeat;"><tr><td height="5px"></td></tr></TABLE>
						<iframe src="javascript:false" style="filter:alpha(opacity=0);opacity:0;position: absolute; visibility: inherit; top: 0px; left: 0px; width: 184px; height: 200px; z-index: -1; filter='progid:dximagetransform.microsoft.alpha(style=0,opacity=0)';" > 
    </iframe>  --%>		<!-- modified by wcd 2014-09-24 -->
    					<%
    					if (PortalUtil.isuserdeploy()) {
    					%>
    					<div class="moreBtn_option" style="margin-top:-11px;background-color: #d5ecff;color:#228ade;"  onclick="javascript:window.open('/rdeploy/main.jsp')">
							<span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/back-end_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(633,user.getLanguage())%></span>
						</div>
						
						<%} else { %>
						<div class="moreBtn_option" style="margin-top:-11px;background-color: #d5ecff;color:#228ade;"  onclick="javascript:window.open('/middlecenter/index.jsp')">
							<span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/back-end_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(83541,user.getLanguage())%></span>
						</div>
						<%} %>
    					<div class="moreBtn_option" style=""  onclick="javascript:goUrl('/hrm/HrmTab.jsp?_fromURL=OrgChartHRM')">
							<span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/com_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(562,user.getLanguage()) %></span>
							</div>
							
							<div class="moreBtn_option" style=""  onclick="javascript:goopenWindow('<%=SystemEnv.getHtmlLabelName(83543,user.getLanguage()) %>','/weaverplugin/PluginMaintenance.jsp')">
							<span class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/download_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(83543,user.getLanguage()) %></span>
							</div>
							<div class="moreBtn_option" onclick="javascript:setSafeSite()">
							<span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/plugin_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(28422,user.getLanguage()) %></span></div>
							<div class="moreBtn_option" onclick="javascript:goopenWindow('<%=SystemEnv.getHtmlLabelName(18014,user.getLanguage()) %>','/hrm/HrmTab.jsp?_fromURL=licenseInfo')">
							<span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/license_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(18014,user.getLanguage()) %></span></div>
							<div class="moreBtn_option" onclick="javascript:showVersion()">
							<span  class="moreBtn_optionSpan"><img width="17" src="/wui/theme/ecology8/page/images/version_wev8.png" style="vertical-align:middle;"></span>
							<span><%=SystemEnv.getHtmlLabelName(567,user.getLanguage()) %></span></div>
						</div>
					</td>
						
			        <td  class="logout" style="width:40px;background:url(/wui/theme/ecology8/page/images/more_wev8.png) no-repeat scroll center 50%;" onclick="logout()" title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>" >
			        	<div  class="tbItm f12 quit" >
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

<SCRIPT LANGUAGE="javascript">
var voteids = "";//网上调查的id
var voteshows = "";//网上调查是否弹出
var votefores = "";//网上调查---> 强制调查
</SCRIPT>


<%

    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
	String belongtoids = user.getBelongtoids();
	String account_type = user.getAccount_type();

boolean isSys=true;
RecordSet.executeSql("select 1 from hrmresource where id="+user.getUID());
if(RecordSet.next()){
	isSys=false;
}	

Date votingnewdate = new Date() ;
long votingdatetime = votingnewdate.getTime() ;
Timestamp votingtimestamp = new Timestamp(votingdatetime) ;
String votingCurrentDate = (votingtimestamp.toString()).substring(0,4) + "-" + (votingtimestamp.toString()).substring(5,7) + "-" +(votingtimestamp.toString()).substring(8,10);
String votingCurrentTime = (votingtimestamp.toString()).substring(11,13) + ":" + (votingtimestamp.toString()).substring(14,16);
String votingsql=""; 
if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
belongtoids +=","+user.getUID();

votingsql="select distinct t1.id,t1.autoshowvote,t1.forcevote from voting t1 where t1.status=1 "+ 
        " and (t1.beginDate<'"+votingCurrentDate+"' or (t1.beginDate='"+votingCurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+votingCurrentTime+"'))) "; 
	votingsql +=" and (";
	
  String[] votingshareids=Util.TokenizerString2(belongtoids,",");
	for(int i=0;i<votingshareids.length;i++){
		User tmptUser=VotingManager.getUser(Util.getIntValue(votingshareids[i]));
		String seclevel=tmptUser.getSeclevel();
		int subcompany1=tmptUser.getUserSubCompany1();
		int department=tmptUser.getUserDepartment();
		String  jobtitles=tmptUser.getJobtitle();
	     	
		String tmptsubcompanyid=subcompany1+"";
		String tmptdepartment=department+"";
		RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+tmptUser.getUID());
		while(RecordSet.next()){
			tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
			tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
		}
		
		if(i==0){
			votingsql += " ( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
			" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )) )";	
		} else {
			votingsql += " or ( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
			" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )) )";	
		}
		
		  		
	}
	votingsql +=")";

}else{
	String seclevel=user.getSeclevel();
	int subcompany1=user.getUserSubCompany1();
	int department=user.getUserDepartment();
	String  jobtitles=user.getJobtitle();
	  		
	String tmptsubcompanyid=subcompany1+"";
	String tmptdepartment=department+"";
	RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+user.getUID());
	while(RecordSet.next()){
		tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
		tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
	}
	
	votingsql="select distinct t1.id,t1.autoshowvote,t1.forcevote from voting t1 where t1.status=1 "+
	" and t1.id not in (select distinct votingid from VotingRemark where resourceid ="+user.getUID()+")"+
	" and (t1.beginDate<'"+votingCurrentDate+"' or (t1.beginDate='"+votingCurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+votingCurrentTime+"')))"+
	" and t1.id in(select votingid from VotingShare t where ((sharetype=1 and resourceid="+user.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles='"+jobtitles+"' ) or (joblevel=1 and jobtitles='"+jobtitles+"' and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles='"+jobtitles+"' and jobdepartment in("+tmptdepartment+") )) )  or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t.roleid and rolelevel>=t.rolelevel and resourceid="+user.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) ))"; 
}
if(isSys){
	votingsql +=" and 1=2";
}
//signRs.writeLog("###abc:"+votingsql);
signRs.executeSql(votingsql);
while(signRs.next()){ 
String votingid = signRs.getString("id");
String voteshow = signRs.getString("autoshowvote"); 
String forcevote = signRs.getString("forcevote"); 

%>

<script language=javascript>  
   if(voteids == ""){
      voteids = '<%=votingid%>';
      voteshows = '<%=voteshow%>';
      forcevotes = '<%=forcevote%>';
   }else{
      voteids =voteids + "," +  '<%=votingid%>';
      voteshows =voteshows + "," +  '<%=voteshow%>';
      forcevotes =forcevotes + "," +  '<%=forcevote%>';
   }

</script> 
<%
}
//------------------------------------
//网上调查部分 End
//------------------------------------
%> 

<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
<script language=javascript>  

function showVote(){
     if(voteids !=""){
	     var arr = voteids.split(",");
	     var autoshowarr = voteshows.split(",");
	     var forcevotearr = forcevotes.split(",");
		 for(i=0;i<arr.length;i++){
		    //判断是否弹出调查
		    if(autoshowarr[i] !='' || forcevotearr[i] !=''){//弹出
			    var diag_vote = new Dialog();
				diag_vote.Width = 960;
				diag_vote.Height = 800;
				diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(17599,user.getLanguage())%>";
				diag_vote.URL = "/voting/VotingPoll.jsp?votingid="+arr[i];
				if(forcevotearr[i] !=''){//强制调查
				  diag_vote.ShowCloseButton=false; 
				}
				diag_vote.show();
			}
		 }
	 }
  }
  
  var _signType = "<%=_signType%>";
	var _signStartTime = "<%=_signStartTime%>";
	var common = new MFCommon();
	function uper() {
	<%
	String isTimeOutLogin = Prop.getPropValue("Others","isTimeOutLogin");
	//增加是否开启在线签到判断
	boolean hasSchedule = HrmScheduleKqUtil.hasHrmSchedule(user);
	HrmKqSystemComInfo kqSystem = null;
	if(hasSchedule){
		kqSystem = new HrmKqSystemComInfo(user);
	}else{
		kqSystem = new HrmKqSystemComInfo();
	}
	boolean isSignInOrSignOut = StringUtil.vString(kqSystem.getNeedsign(), "0").equals("1");// 是否启用签到签退功能
	if("2".equals(isTimeOutLogin)||!isSignInOrSignOut){
	%>
	return false;
	<%}%>
		common.ajax("cmd=compareTime&arg0="+_signType+"&arg1="+_signStartTime, false, function(result){
			changeSignInfo(result);
			window.setTimeout(uper, 1000 * 60);
		});
	}
	function changeSignInfo(sType) {
		if(sType != 1 && sType != 2) {
			jQuery("#tdSignInfo").hide();
			jQuery("#tdSignInfoLine").hide();
		} else {
			jQuery("#tdSignInfo").show();
			jQuery("#tdSignInfoLine").show();
			jQuery("#sign_dispan").attr("_signFlag", sType);
			if(sType == 1) {
				jQuery("#sign_dispan").text("<%=SystemEnv.getHtmlLabelName(20032,user.getLanguage())%>");
			} else {
				jQuery("#sign_dispan").text("<%=SystemEnv.getHtmlLabelName(20033,user.getLanguage())%>");
				jQuery("#sign_dispan").prev().attr("src","/wui/theme/ecology8/page/images/signOut_wev8.png");
			}
			try{
				if(navigator.userAgent.indexOf("MSIE")>0 && navigator.userAgent.indexOf("MSIE 6.0") > 0) {
					DD_belatedPNG.fix('.tbItm,#toolbarMoreBlockTop,.searchBlockBgDiv,#sign_dispan,.topBlockDateBlock,.toolbarTopRight,background');
				}
			}catch(e){}
		}
	}

var needRemind = true;
function canSign(){
	if(!needRemind)return;
	try{
		jQuery.ajax({
			url:"/hrm/ajaxData.jsp",
			type:"POST",
			dataType:"json",
			async:false,
			data:{
				cmd:"isNeedSign",
			},
			success:function(data){
				if(data.isNeedSign){
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21415,user.getLanguage())%>",function(){
						signInOrSignOut(data.signType);
						needRemind = false;
						jQuery("#tdSignInfo").show();
						jQuery("#tdSignInfoLine").show();
					},function(){
						needRemind = false;
					  try{
					  	jQuery("#tdSignInfo").show();
					  	jQuery("#tdSignInfoLine").show();
            	jQuery("#sign_dispan").text("<%=SystemEnv.getHtmlLabelName(20032,user.getLanguage())%>");
                showPromptForShowSignInfo(ajax.responseText, signType);
                jQuery("#sign_dispan").attr("_signFlag", 1);
                if(navigator.userAgent.indexOf("MSIE")>0 && navigator.userAgent.indexOf("MSIE 6.0") > 0){  
									DD_belatedPNG.fix('.tbItm,#toolbarMoreBlockTop,.searchBlockBgDiv,#sign_dispan,.topBlockDateBlock,.toolbarTopRight,background');
								}
            }catch(e){}
					})
				}else{
					setTimeout('canSign()', 60*5*1000);
				}
			}
		});
	}catch(e){}
}
</script> 


<script language=javascript>  
jQuery(document).ready(function() {
	showVote();
	var isNeedSign = "<%=isNeedSign%>";
	var signType = "<%=signType%>";
	if(isNeedSign == "true" && signType == "1") {
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21415,user.getLanguage())%>",function(){
			signInOrSignOut(<%=signType%>);
		}, function() {
			setTimeout('canSign()', 60*5*1000);
		});
	}
	setTimeout('uper()', 60*1000);
});

function logout(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>",function(){
		window.location='/login/Logout.jsp';
	})
}
</script> 

