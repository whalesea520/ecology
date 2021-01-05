
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@page import="weaver.hrm.common.Tools"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.file.Prop"%>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@ include file="/times.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />	
<jsp:useBean id="signRs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rtxClient" class="weaver.rtx.RTXClientCom" scope="page" />
<jsp:useBean id="MouldStatusCominfo" class="weaver.systeminfo.MouldStatusCominfo" scope="page" />


<%
    /*用户验证*/
    User user = HrmUserVarify.getUser(request, response);
    if (user == null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
    
  //判断是否有微搜功能
	boolean microSearch=weaver.fullsearch.util.RmiConfig.isOpenMicroSearch();
  
  
    StaticObj staticobj = null;
    staticobj = StaticObj.getInstance();
    String software = (String)staticobj.getObject("software") ;
    if(software == null) software="ALL";

    int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
    String Customertype = Util.null2String(""+user.getType()) ;
    String logintype = Util.null2String(user.getLogintype()) ;
    
    
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
	String signWeekBg = getWeekBg(user);
    
%>
<%!
private String getWeekBg(User user) {
	String strWeek = "";
    java.util.GregorianCalendar g=new java.util.GregorianCalendar();
    int week = g.get(java.util.Calendar.DAY_OF_WEEK);
    switch(week) {
    case 1:
    	strWeek = SystemEnv.getHtmlLabelName(24626,user.getLanguage());
        break;
    case 2:
    	strWeek = SystemEnv.getHtmlLabelName(392,user.getLanguage());
        break;
    case 3:
    	strWeek = SystemEnv.getHtmlLabelName(393,user.getLanguage());
        break;
    case 4:
    	strWeek = SystemEnv.getHtmlLabelName(394,user.getLanguage());
        break;
    case 5:
    	strWeek = SystemEnv.getHtmlLabelName(395,user.getLanguage());
        break;
    case 6:
    	strWeek = SystemEnv.getHtmlLabelName(396,user.getLanguage());
        break;
    case 7:
    	strWeek = SystemEnv.getHtmlLabelName(397,user.getLanguage());
        break;
    default:
    	break;
    }
    
    return strWeek;
}
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
	    var ajaxUrl = "/wui/theme/ecology7/page/getSystemTime.jsp";
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
        jQuery(".tbItm").live({ mouseenter: function () {//鼠标移入事件
			/** by zfh 2011-09-20
			*由于IE用jQuery无法获取background-position的值，支持background-position-y，background-position-x，
			*而Safri，firefox，chrome正好相反，先使用下面方法获取background-position的值
			*/
        	var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				jQuery(jQuery(this)[0]).css("background-position-y","-25px");
			}else{
				bp=bp.split(" ","1")[0];
				jQuery(jQuery(this)[0]).css("background-position",bp+"  -25px");
			}
        }, mouseleave: function () {//鼠标移出事件
            var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				jQuery(jQuery(this)[0]).css("background-position-y","0px");
			}else{
				bp=bp.split(" ","1")[0];
				jQuery(jQuery(this)[0]).css("background-position",bp+" 0px");
			}
        }});
        
        jQuery(".dropdown img.flag").addClass("flagvisibility");

        jQuery(".selectTile a").click(function() {
            jQuery(".selectContent ul").toggle();
        });
                    
        jQuery(".selectContent ul li a").click(function() {
            var text = jQuery(this).children("span").html();
            jQuery(".selectTile a").children("span").html(text);
            jQuery("input[name='searchtype']").val(jQuery(this).children("span").attr("searchType"));
            jQuery(".selectContent ul").hide();
        });
                    
        function getSelectedValue(id) {
            return jQuery("#" + id).find("selectContent a span.value").html();
        }

        jQuery(document).bind('click', function(e) {
            var $clicked = jQuery(e.target);
            if (! $clicked.parents().hasClass("dropdown"))
                jQuery(".selectContent ul").hide();
        });


        jQuery("#flagSwitcher").click(function() {
            jQuery(".dropdown img.flag").toggleClass("flagvisibility");
        });
        
        jQuery("#searchbt").live({ mouseenter: function () {//鼠标移入事件
			var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				jQuery(jQuery(this)[0]).css("background-position-x","-27px");
			}else{
				bp=bp.split(" ","2")[1];
				jQuery(jQuery(this)[0]).css("background-position","-27px "+bp);
			}
        }, mouseleave: function () {//鼠标移出事件
            var bp=jQuery(jQuery(this)[0]).css("background-position");
			if(bp===undefined  ){
				jQuery(jQuery(this)[0]).css("background-position-x","-0px");
			}else{
				bp=bp.split(" ","2")[1];
				jQuery(jQuery(this)[0]).css("background-position","-0px "+bp);
			}
        }});
        
        //更多按钮
        jQuery(".toolbarMore").bind("click", function() {
        	jQuery("#toolbarMore").hide();
        });
        
        jQuery("#toolbarMore").live({ mouseenter: function () {//鼠标移入事件
        }, mouseleave: function () {//鼠标移出事件
        	jQuery("#toolbarMore").hide();
        }});
        
        //为了兼容ie6，收藏夹iframe动态载入
        //jQuery("#navFav").css("position", "relative");
		 //jQuery("#navFav").load("/wui/theme/ecology7/page/FavouriteShortCut.jsp?data="+new Date().getTime());
		 jQuery("#navFav").bind("click",function(){
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
		jQuery("#searchBlockUl iframe").css("height", jQuery("#searchBlockUl").height());
		
		jQuery("#searchBlockUl").live({ mouseenter: function () {//鼠标移入事件
		}, mouseleave: function () {//鼠标移出事件
			jQuery("#searchBlockUl").hide();
		}});
		jQuery(".selectTile").live({ mouseenter: function () {//鼠标移入事件
		}, mouseleave: function () {//鼠标移出事件
			var clientx = event.clientX;
			var clienty = event.clientY;
			
			var elex = jQuery(this).offset().left;
			var eley = jQuery(this).offset().top;
		
			if (clientx < elex || elex > jQuery(this).offset().right || clienty < eley) {
				jQuery("#searchBlockUl").hide();
			} else {
				return;
			}
		}});
		
    });
    
function toolbarMore() {
	jQuery("#toolbarMore").toggle();
}

function goopenWindow(url){
    var chasm = screen.availWidth;
    var mount = screen.availHeight;
    if(chasm<650) chasm=650;
    if(mount<700) mount=700;
    window.open(url,"PluginCheck","scrollbars=yes,resizable=no,width=690,Height=650,top="+(mount-700)/2+",left="+(chasm-650)/2);
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

function showVersion(){	
	var dlg=new window.top.Dialog();//定义Dialog对象
	var url = "/systeminfo/version.jsp";
	var title = "<%=SystemEnv.getHtmlLabelName(16900,user.getLanguage())%>e-cology";
	dlg.currentWindow = window;
	dlg.Model=true;
	dlg.Width=630;//定义长度
	dlg.Height=400;
	dlg.URL=url;
	dlg.Title=title;
	dlg.show();
} 

function logout(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>",function(){
		window.location='/login/Logout.jsp';
	})
}

//-->
</script>


<STYLE TYPE="text/css">
    .tbItm{
        cursor:pointer;
        background-position: left center;
        height:20px;
        width:20px;
        background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg_wev8.png);
    }
    
    .toolbarItemSelected{
        filter:alpha(opacity=99);-moz-opacity:0.99;
    }

	.searchkeywork {line-height:30px;width: 67px;font-size: 12px;height:23px !important;margin-top:1px;margin-left:-2px;background:none;border:none !important;color:#333 ;font-family:"微软雅黑"!important;}
	.dropdown {margin-left:5px; font-size:11px; color:#000;height:23px;}
	.selectContent, .selectTile, .dropdown ul { margin:0px; padding:0px; }
	.selectContent { position:relative;z-index:6; }
	.dropdown a, .dropdown a:visited { color:#816c5b; text-decoration:none; outline:none;}
	.dropdown a:hover { color:#5d4617;}
	.selectTile a:hover { color:#5d4617;}
	.selectTile a {background:none; display:block;width:40px;margin-left:4px;margin-top:1px;}
	.selectTile a span {cursor:pointer; display:block; padding:6 0 0 0;background:none;height:25px;}
	.selectContent ul { background:#fff none repeat scroll 0 0; border:1px solid #828790; color:#C5C0B0; display:none;left:0px; position:absolute; top:2px; width:auto; min-width:50px; list-style:none;}
	.dropdown span.value { display:none;}
	.selectContent ul li{text-align:left;}
	.selectContent ul li a { padding:2px 0 2px 2px; display:block;margin:0;width:60px;}
	.selectContent ul li a:hover { background-color:#3399FF;}
	.selectContent ul li a img {border:none;vertical-align:middle;margin-left:2px;}
	.selectContent ul li a span {margin-left:5px;}
	.flagvisibility { display:none;}
</STYLE>
<iframe id="downLoadReg" style="display: none;"></iframe>
<div>
<table width="242px" align="right">
	<tr width="100%">
        <td align="right" stylt="top:0;">
            <TABLE id="toolBarTable" cellpadding="0px" cellspacing="0px" height="29px;" width="<%=isNeedSign ? "256px" : "215px" %>" align="right" style="margin-right:2px;">
                <tr height="100%">
                    <td style="">
						<div class="searchBlockBgDiv" style="float:left;padding-top:20px;width:140px;height:29px;background-image: url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg_wev8.png);background-position: 0px -75px ;background-repeat:no-repeat;margin:0;padding:0;">
						
							<form name="searchForm" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
								<input type="hidden" name="searchtype" value="<%=microSearch?9:2%>">
									<div id="sample" class="dropdown" style="float:left;">
										<div class="selectTile">
											<a href="#">
												<span style="text-align:left;line-height:31px; float:left;width:32px;display:block;overflow:hidden;text-overflow:ellipsis;">
												<%=microSearch?
												SystemEnv.getHtmlLabelName(31953,user.getLanguage()):
												SystemEnv.getHtmlLabelName(30042,user.getLanguage())%></span>
												<div style="float:right;display: block; width:8px;height:18px;*height:18px;background: url(/wui/theme/ecology7/skins/default/page/ecologyShellImg_wev8.png);background-repeat: no-repeat; background-position: -262px  -62px;"></div>
											</a>
										</div>
										<div class="selectContent" style="margin-top:26px;*margin-top:20px;_margin-top:0px;">
											<ul id="searchBlockUl">
												<iframe src="" style="filter:alpha(opacity=0);opacity:0;position:absolute; visibility:inherit; top:0px; left:0px; width:100%; height:100%; z-index:-1; filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';" >
												</iframe>
												<% if(microSearch){ %>
												<li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/ws_wev8.png"/><span searchType="9"><%=SystemEnv.getHtmlLabelName(31953,user.getLanguage())%></span></a></li>
												<%}%>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/hr_wev8.png"/><span searchType="2"><%=SystemEnv.getHtmlLabelName(30042,user.getLanguage())%></span></a></li>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/wl_wev8.png"/><span searchType="5"><%=SystemEnv.getHtmlLabelName(30045,user.getLanguage())%></span></a></li>
												
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/doc_wev8.gif"/><span searchType="1"><%=SystemEnv.getHtmlLabelName(30041,user.getLanguage())%></span></a></li>
											<%if(isgoveproj==0){%>
												<%if((Customertype.equals("3") || Customertype.equals("4") || !logintype.equals("2"))&&("1".equals(MouldStatusCominfo.getStatus("crm"))||"".equals(MouldStatusCominfo.getStatus("crm")))){%> 
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/crm_wev8.gif"/><span searchType="3"><%=SystemEnv.getHtmlLabelName(30043,user.getLanguage())%></span></a></li>
												<%
												}
											}
												%>
												<%if("1".equals(MouldStatusCominfo.getStatus("cwork"))||"".equals(MouldStatusCominfo.getStatus("cwork"))) {%>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/xz_wev8.gif"/><span searchType="8"><%=SystemEnv.getHtmlLabelName(30047,user.getLanguage())%></span></a></li>
											<%} %>
											
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/mail_wev8.gif"/><span searchType="7"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></span></a></li>
											
											<%
											if(isgoveproj==0&&("1".equals(MouldStatusCominfo.getStatus("proj"))||"".equals(MouldStatusCominfo.getStatus("proj")))){%>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/p_wev8.gif"/><span searchType="6"><%=SystemEnv.getHtmlLabelName(30046,user.getLanguage())%></span></a></li>
											<%
											}
											%>
											<%
											if((!logintype.equals("2")) && software.equals("ALL")&&("1".equals(MouldStatusCominfo.getStatus("cpt"))||"".equals(MouldStatusCominfo.getStatus("cpt")))){%>
												<li><a href="#"><img src="/wui/theme/ecology7/page/images/toolbar/zc_wev8.gif"/><span searchType="4"><%=SystemEnv.getHtmlLabelName(30044,user.getLanguage())%></span></a></li>
											<%
											}
											%>
											
											
											</ul>
										</div>
									</div>
									
									<div style="float:left;">
										<input type="text" name="searchvalue" onMouseOver="this.select()" class="searchkeywork"/>
									</div>
									<div style="float:left;margin-top:5px;">
										<div  onclick="searchForm.submit()" id="searchbt" style="cursor:pointer;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg_wev8.png);background-position: 0px -129px;background-repeat: no-repeat; display:block;width:21px;height:19px;margin-left:4px;"></div>
									</div>
									
							 </form>
						</div>
						
						<div id='divSignInfo' style="float:left;">
								<div style="float:left">
									<div class="topBlockDateBlock" style="float:left;cursor:pointer;font-weight:bold;color:#003366;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg_wev8.png);background-position: -148px -75px;background-repeat: no-repeat;width:54px;height:29px;line-height:32px;text-align:center;overflow:hidden;" >
										<%=signWeekBg %>
									</div>
								</div>
									<div id="tdSignInfo" <%=isNeedSign?"":"style='display: none'" %> style="float:left;">
										<div onclick="signInOrSignOut(jQuery(this).attr('_signFlag'))" style="float:left;cursor:pointer;color:#fff;font-weight:bold;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg_wev8.png) ;background-repeat: no-repeat;background-position:-207px -75px;display:block;width:40px;height:29px;text-align:center;line-height:29px;overflow:hidden;text-overflow:ellipsis;" _signFlag="<%=sign_flag %>" id="sign_dispan">
										<%="1".equals(sign_flag) ? SystemEnv.getHtmlLabelName(20032,user.getLanguage()) : SystemEnv.getHtmlLabelName(20033,user.getLanguage()) %>
										</div>
									</div>
								<div style="float:left;display:block;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg_wev8.png);background-position: -252px -75px;background-repeat: no-repeat;width:6px;height:29px;" class="toolbarTopRight">
								</div>
						</div>
                    </td>           
                </tr>
            </TABLE>
        </td>
    </tr>
    
	<tr>
		<td height="2px;"></td>
	</tr>
	
    <tr style="" width="100%" align="bottom">
    	<td width="100%">
    	    <TABLE cellpadding="0px" cellspacing="0px" style="margin-top:5px;" width="100%" align="right">
    	    	<tr align="left">
    	    		<!-- 主页 -->
			        <td onClick="javascript:dymlftenu(this);" title="<%=SystemEnv.getHtmlLabelName(31753,user.getLanguage())%>">
						<span style="background-position:0px 0px;display:block;" class="tbItm"></span>
			        </td>
			         <td style="width:10px;height:20px;" align="center">
			        	<table cellpadding="0px" cellspacing="0px"><tr><td width="2px">
			        		<span style="margin-right:7px;display:block;width:2px;height:20px;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg_wev8.png);background-position:0px -50px;" class="toolbarSplitLine"></span>
			        	</td></tr></table>
			        </td>
					<!-- 收藏夹 -->
			        <td onClick=""  title="<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>">
			        	 <span id="navFav" style="background-position:-250px 0px;display:block;" class="tbItm"></span>
			        </td>
			        <!-- Line -->
			        <td style="width:10px;height:20px;" align="center">
			        	<table cellpadding="0px" cellspacing="0px"><tr><td width="2px">
			        		<span style="margin-right:7px;display:block;width:2px;height:20px;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg_wev8.png);background-position:0px -50px;" class="toolbarSplitLine"></span>
			        	</td></tr></table>
			        </td>
					<!-- 刷新 -->
			        <td onClick="document.getElementById('mainFrame').contentWindow.document.location.reload()" title="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%>" >
			        	<span style="background-position:-25px 0px;display:block;" class="tbItm"></span>
			        </td>
			        <!-- 后退 -->
			        <td onClick="mainFrame.history.go(-1)" title="<%=SystemEnv.getHtmlLabelName(15122,user.getLanguage())%>">
			        	<span style="background-position:-50px 0px;display:block;" class="tbItm"></span>
			        </td>
			        <!-- 前进 -->
			        <td onClick="mainFrame.history.go(1)" title="<%=SystemEnv.getHtmlLabelName(15123,user.getLanguage())%>">
			        	<span style="background-position:-75px 0px;display:block;" class="tbItm"></span>
			        </td>
			        
			       

                     <%if(rtxClient.isValidOfRTX()){
						 RTXConfig rtxConfig = new RTXConfig();
						 String RtxOrElinkType = (Util.null2String(rtxConfig.getPorp(RTXConfig.RtxOrElinkType))).toUpperCase();
						 if("ELINK".equals(RtxOrElinkType) && !RTXConfig.isSystemUser(user.getLoginid())){ 
					 %>
					<td onClick="javascript:openEimClient()" title="<%=SystemEnv.getHtmlLabelName(27463,user.getLanguage())%>">
			        	<span style="background-position:-370px 0px;display:block;" class="tbItm"></span>
			        </td>
					<%} else if(!RTXConfig.isSystemUser(user.getLoginid())){%>
					<td onClick="javascript:openRtxClient()" title="<%=SystemEnv.getHtmlLabelName(83530,user.getLanguage())%>">
			        	<span style="background-position:-395px 0px;display:block;" class="tbItm"></span>
			        </td>					
					<%}}%>
			        
			        <td style="width:10px;height:20px;" align="center">
			        	<table cellpadding="0px" cellspacing="0px"><tr><td width="2px">
			        		<span style="margin-right:7px;display:block;width:2px;height:20px;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg_wev8.png);background-position:0px -50px;" class="toolbarSplitLine"></span>
			        	</td></tr></table>
			        </td>
			        
			        <td onclick="javascript:toolbarMore();" title="<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>" style="position:relative;"> 
			        	<span style="background-position:-270px 0px;display:block;" class="tbItm"></span>
				   </td>
					<td style="position:relative;;">
						<div id="toolbarMore" style="display:none;position:absolute;width:184px;right:0;top:22px;">
			        		<div id="toolbarMoreBlockTop" style="background-image:url(/wui/theme/ecology7/skins/<%=skin %>/page/top/toolbarMoreTop_wev8.png);background-repeat:no-repeat;height:11px;overflow:hidden;width:184px;"></div>
			        		<TABLE  cellpadding="10" cellspacing="3px" align="center" width="100%" style="margin:0;background-image:url(/wui/theme/ecology7/skins/<%=skin %>/page/top/toolbarMoreCenter_wev8.jpg);background-repeat:repeat-y;">
			        			<tr><td colspan="5" height="5px"></td></tr>
				    	    	<tr align="center">
				    	    		<td onclick="leftBlockContractionOrExpand();" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="background-position:-295px 0px;display:block;" class="tbItm"></span>
							        </td>
							        
							        <td onclick="topBlockContractionOrExpand();" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" style="position:relative;"> 
							        	<span style="background-position:-320px 0px;display:block;" class="tbItm"></span>
							        </td>
							        <td onclick="window.open('/systeminfo/menuconfig/CustomSetting.jsp','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(22250,user.getLanguage())%>">
							        	<span style="background-position:-150px 0px;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td onclick="javascript:goopenWindow('/weaverplugin/PluginMaintenance.jsp')" title="<%=SystemEnv.getHtmlLabelName(7171,user.getLanguage())%>">
							        	<span style="background-position:-175px 0px;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td onclick="javascript:showVersion()" title="<%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%>">
							        	<span style="background-position:-200px 0px;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							    </tr>
							    <tr align="center">
				    	    		<td onclick="window.open('/workflow/request/RequestType.jsp?needPopupNewPage=true','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%>">
										<span style="background-position:-100px 0px;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
									<td onclick="window.open('/docs/docs/DocList.jsp?isuserdefault=1','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>">
										<span style="background-position:-125px 0px;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td onclick="window.open('/workplan/data/WorkPlan.jsp?resourceid=<%=user.getUID()%>','mainFrame')" title="<%=SystemEnv.getHtmlLabelName(18480,user.getLanguage())%>">
										<span style="background-position:-345px 0px;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td title="Ecology<%=SystemEnv.getHtmlLabelName(28422,user.getLanguage())%>" onclick="setSafeSite()">
							            <span style="background-position:-420px 0px;display:block;" class="tbItm" class="toolbarMore"></span>
							        </td>
							        <td></td>
							    </tr>
							    <tr><td colspan="5" height="5px"></td></tr>
			        		</TABLE>
			        		<TABLE cellpadding="0px" cellspacing="0px" height="5px" width="100%" style="background:url(/wui/theme/ecology7/skins/<%=skin %>/page/top/toolbarMoreBottom_wev8.png);background-repeat: no-repeat;"><tr><td height="5px"></td></tr></TABLE>
						<iframe src="javascript:false" style="filter:alpha(opacity=0);opacity:0;position: absolute; visibility: inherit; top: 0px; left: 0px; width: 184px; height: 200px; z-index: -1; filter='progid:dximagetransform.microsoft.alpha(style=0,opacity=0)';" > 
    </iframe> 
						</div>
					</td>
			        <td style="width:10px;height:20px;" align="center">
			        	<table cellpadding="0px" cellspacing="0px"><tr><td width="2px">
			        		<span style="margin-right:7px;display:block;width:2px;height:20px;background:url(/wui/theme/ecology7/skins/<%=skin %>/page/ecologyShellImg_wev8.png);background-position:0px -50px;" class="toolbarSplitLine"></span>
			        	</td></tr></table>
			        </td>
			        <td onclick="logout()" title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>"> 
			        	<span style="background-position:-225px 0px;display:block;" class="tbItm"></span>
			        </td>
    	    	</tr>
    		</TABLE> 
    	</td>
        
    </tr>
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
				diag_vote.Modal = false;
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
	if("2".equals(isTimeOutLogin)){
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
						jQuery("#toolBarTable").width(256);
						jQuery("#divSignInfo").width(100);
						jQuery("#tdSignInfo").show();
					},function(){
						needRemind = false;
					  try{
					  		jQuery("#toolBarTable").width(256);
					  		jQuery("#divSignInfo").width(100);
					  		jQuery("#tdSignInfo").show();
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



