
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.Util,weaver.general.MathUtil,weaver.general.GCONST,weaver.general.StaticObj,
                 weaver.hrm.settings.RemindSettings"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.net.*" %>

<%@ page import="weaver.hrm.settings.BirthdayReminder" %>
<%@page import="java.util.List"%>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="suc" class="weaver.system.SysUpgradeCominfo" scope="page" />
<%@page import="weaver.login.VerifyLogin"%>

<!DOCTYPE HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<SCRIPT type=text/javascript src="/wui/common/jquery/jquery.min_wev8.js"></SCRIPT>
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.cycle.all_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>


<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/jquery.qrcode_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/qrcode_wev8.js"></script>


<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>

<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>

<link href="/css/commom_wev8.css" type="text/css" rel="stylesheet">




<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 Start -->
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF">
<%String isMobileTest =Util.null2String(request.getParameter("isMobileTest"));%>

<%
int languageid = Util.getIntValue(request.getParameter("languageid"),7);

String logintype = Util.null2String(request.getParameter("logintype")) ;
String templateId = Util.null2String(request.getParameter("templateId"));
String templateType = "";
String imageId = "";
String imageId2 = "";
String loginTemplateTitle="";
String backgroundColor = "";
String backgroundUrl="";
String logo="";
String recordcode = "";
int extendloginid=0;


	String sqlLoginTemplate1 = "SELECT * FROM SystemLoginTemplateTemp WHERE loginTemplateid=?";  
	
	rs.executeQuery(sqlLoginTemplate1,templateId);
	if(rs.next()){
	    templateId=rs.getString("loginTemplateId");
	    templateType = rs.getString("templateType");
	    imageId = rs.getString("imageId");
	    imageId2 = rs.getString("imageId2");
	    loginTemplateTitle = rs.getString("loginTemplateTitle");
	    backgroundColor = rs.getString("backgroundColor");
		recordcode = rs.getString("recordcode");
	    out.println("<script language='javascript'>document.title='"+loginTemplateTitle+"';</script>");
	}else{
		sqlLoginTemplate1 = "SELECT * FROM SystemLoginTemplate WHERE loginTemplateid=?";
		rs.executeQuery(sqlLoginTemplate1,templateId);
		if(rs.next()){
		    templateId=rs.getString("loginTemplateId");
		    templateType = rs.getString("templateType");
		    imageId = rs.getString("imageId");
		    imageId2 = rs.getString("imageId2");
		    loginTemplateTitle = rs.getString("loginTemplateTitle");
		    backgroundColor = rs.getString("backgroundColor");
			recordcode = rs.getString("recordcode");
		    out.println("<script language='javascript'>document.title='"+loginTemplateTitle+"';</script>");
		}
	}


if(!"".equals(imageId))
	backgroundUrl=imageId;
else{
	backgroundUrl = "/wui/theme/ecology8/page/images/login/bg_wev8.jpg";
}
if(!"".equals(imageId2)){
	logo = imageId2;
}else{
	logo = "/wui/theme/ecology8/page/images/login/logo_wev8.png";
}
%>

<%







//String templateId="",templateType="",imageId="",loginTemplateTitle="";
//int extendloginid=0;

%>



<script type="text/javascript">
$(document).ready(function() {
    $(function() {
        
		//alert($("label.overlabel").length)
		$("label.overlabel").overlabel();

       	var iconImg="/wui/theme/ecology8/page/wui/theme/ecology8/page/images/login/s_wev8.png"
        var iconImg_over="/wui/theme/ecology8/page//wui/theme/ecology8/page/images/login/s2_wev8.png"
    
       
        
        $("#login").bind("mouseover", function() {
            $(this).removeClass("lgsm");
            $(this).addClass("lgsmMouseOver");
        });
        $("#login").bind("mouseout", function() {
            $(this).removeClass("lgsmMouseOver");
            $(this).addClass("lgsm");
        });
        
        $(".crossNav a").hover(function() {
            $(this).css("background-position", "0 -29px");
        }, function() {
            $(this).css("background-position", "0 0px");
        });
        
        //检测微软雅黑字体在客户端是否安装
        //fontDetection("sfclsid", $("input[name='fontName']").val());
        //检测用户当前浏览器及其版本
        ieVersionDetection();
        setRandomBg();
    });
    //焦点设置
    //$("input[name='loginid']").focus();
    //----------------------------------
    // form表单提交时check
    //----------------------------------
    
});


function setRandomBg() {
    var imgArray=new Array();
    var imgPath="";
    <%
    List imageId2List=Util.TokenizerString(imageId2,",");
    for(int i=0;i<imageId2List.size();i++){
    	String imgId2Temp=(String)imageId2List.get(i);
    %>
    imgArray[<%=i%>]="<%=imgId2Temp%>";	 
    <%}%>
    var discnt = <%=imageId2List.size()%>;
    
    if(discnt==0){ //系统默认图片
       imgArray=new Array("bg2_wev8.png","bg3_wev8.png");
       discnt=2;
       imgPath="/wui/theme/ecology8/page//wui/theme/ecology8/page/images/login/"
    }else          //用户自定义图片
       imgPath="/LoginTemplateFile/";
        
    var i = Math.floor(Math.random()*discnt);
    var j = Math.floor(Math.random()*discnt);
    var k = Math.floor(Math.random()*discnt);
    
    var img1="",img2="",img3="";
    if(discnt>3){
	    while (i >= discnt ) {
	        i = Math.floor(Math.random()*discnt);
	    }
	    while (j >= discnt || j == i) {
	        j = Math.floor(Math.random()*discnt);
	    }
	    while (k >= discnt || k == i || k == j) {
	        k = Math.floor(Math.random()*discnt);
	    }
	    img1=imgArray[i];
        img2=imgArray[j];
        img3=imgArray[k];
    }else if(discnt==3){
        img1=imgArray[0];
        img2=imgArray[1];
        img3=imgArray[2];
    }else if(discnt==2){
        img1=imgArray[0];
        img2=imgArray[1];
    }else if(discnt==1){
        img1=imgArray[0];
    }
    
    if(discnt>=3){
	    $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat center");
	    $("#disimg1").css("background", "url(" +imgPath+img2+ ") no-repeat center");
	    $("#disimg2").css("background", "url(" +imgPath+img3+ ") no-repeat center");
    }else if(discnt==2){
        $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat center");
	    $("#disimg1").css("background", "url(" +imgPath+img2+ ") no-repeat center");
    }else if(discnt==1){
        $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat center");
    }
}

function ieVersionDetection() {
    if(navigator.userAgent.indexOf("MSIE")>0){ //是否是IE浏览器 
        if(navigator.userAgent.indexOf("MSIE 6.0") > 0){ //6.0
            $("#ieverTips").show();
            return;
        } 
    }
    $("#ieverTips").hide();
}

function fontDetection(objectId, fontName) {
    //加载系统字体
    getSFOfStr(objectId);

    if(!isExistOTF(fontName)) {
        $("#fontTips").show();
    } else {
        $("#fontTips").hide();
    }
}

//---------------------------------------------
// System font detection.  START
//---------------------------------------------
/**
 * detection system font exists.
 * @param fontName font name
 * @return true  :Exist.
 *         false :Does not Exist
 */
function isExistOTF(fontName) {
    if (fontName == undefined 
            || fontName == null 
            || fontName.trim() == '') {
        return false;
    }
    
    if (sysfonts.indexOf(";" + fontName + ";") != -1) {
        return true;
    }
    return false;
};

/**
 * getting to the system font string.
 * @param objectId object's id
 * @return system font string.
 */
function getSFOfStr(objectId) {
    var sysFontsArray = new Array();
    sysFontsArray = getSystemFonts(objectId);
    for(var i=0; i<sysFontsArray.length; i++) {
        sysfonts += sysFontsArray[i];
        sysfonts += ';'
    }
}
//-------------------------------------------
// Save the system font string, 
// used for multiple testing.
//-------------------------------------------
var sysfonts = ';';

/**
 * getting to the system font list
 *
 * @param objectId The id of components of the system font.
 * @return fonts list
 */
function getSystemFonts(objectId) {
    var a = document.all(objectId).fonts.count;
    var fArray = new Array();
    for (var i = 1; i <= document.all(objectId).fonts.count; i++) {
        fArray[i] = document.all(objectId).fonts(i)
    }
    return fArray
}

/**
 * Returns a string, with leading and trailing whitespace
 * omitted.
 * @return  A this string with leading and trailing white
 *          space removed, or this string if it has no leading or
 *          trailing white space.
 */
String.prototype.trim = function(){
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

//---------------------------------------------
// System font detection.  END
//---------------------------------------------
</script>

<STYLE TYPE="text/css">
body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,select{        
    font-size:12px;
}


body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,select{        
    font-size:11px;
    /*font-family:"微软雅黑","宋体"!important;*/ 
}

.loginContainer{
	width:300px;
	height:330px;
	background:url(/wui/theme/ecology8/page/images/login/login-bg_wev8.png);
}

.loginTitle{
	color:#828282;
	font-weight:500px;
	font-size:18px;
	padding-top:10px;
	padding-bottom:20px;
}

/*For slide*/
.slideDivContinar { height: 436px; width: 100%; padding:0; margin:0; overflow: hidden }
.slideDiv {height:436px; width: 100%;top:0; left:0;margin:0;padding:0;}


/*For Input*/
.inputforloginbg{ width:172px;height:21px;border:none;}
.inputforloginbg input{border:none;height:15px;background:none;}

.lgsm {width:124px;height:36px;background:url(/wui/theme/ecology8/page//wui/theme/ecology8/page/images/login/btn_wev8.png) 0px 0px no-repeat; border:none;}
.lgsmMouseOver {width:124px;height:36px;background:url(/wui/theme/ecology8/page//wui/theme/ecology8/page/images/login/btn_wev8.png) 0px 0px no-repeat; border:none;}

.crossNav{width:100%;height:30px;position:absolute;margin-top:105px;padding-left:30px;padding-right:30px;}



  .input_out{
	height:36px;
	width:248px;
	line-height:36px;
  }

  .input_inner{
	height:36px;
	width:248px;
	line-height:36px;
	margin-top:1px;
	font-size:14px;
	
  }
  
</STYLE>
</head>
<body style="padding:0;margin:0;margin:0;padding:0;" scroll="no">


<div class="w-all h-all center" style="background:url('<%=backgroundUrl %>') center bottom;">
	<div class="h-150">&nbsp;</div>
	<div class="w-300 center " style="padding-left:45px;">
		<div>
			<img class=" "  style="max-width:400px;max-height:150px" src="<%=logo %>">
		</div>
		<div style="height:35px">&nbsp;</div>
		<form name="form1" action="/login/VerifyLogin.jsp" name="loginForm" method="post" onSubmit="return checkall();">
                
		<div class="h-15">
			<div class="p-l-30 font14 colorfff left w-140" id="messageDiv" style="text-align: left;">
			&nbsp;
				
			</div>
			
			<div class="last hide w-20 p-r-30" id="qrcodeDiv"><img id="qrcode" class="hand"  src="/wui/theme/ecology8/page/images/login/qrcode_wev8.png"></div>
				
			
			
		
			<div class="clear" style="height: 0px;">&nbsp;</div>
			
		</div>
		
                
		<div id="normalLogin" class="p-l-5">
			<table width="280px;" style="position: absolute;">
				
				<tr>
					<td style="background: url('/wui/theme/ecology8/page/images/login/input_wev8.png');height:45px;">
					<div class="relative " style="height:45px;">
					   <img class="absolute" style="top:10px;left:20px;" src="/wui/theme/ecology8/page/images/login/username_wev8.png">	
					   <label for="loginid" class="overlabel"><%=SystemEnv.getHtmlLabelName(2024,languageid)%></label>
					   <input class="input" name="loginid" id="loginid" value="" style="">
					 </div>
					</td>
				</tr>
				<tr>
					<td class="h-10"></td>
				</tr>
				<tr>
					<td style="background: url('/wui/theme/ecology8/page/images/login/input_wev8.png');height:45px;">
					<div class="relative " style="height:45px;">
					   <img class="absolute" style="top:10px;left:20px;" src="/wui/theme/ecology8/page/images/login/password_wev8.png">	
					   <label for="userpassword" class="overlabel"><%=SystemEnv.getHtmlLabelName(409,languageid)%></label>
					   <input class="input" style=""  name="userpassword" id="userpassword" type="password">
					 </div>
					</td>
				</tr>
				<tr>
					<td class="h-10"></td>
				</tr>
				
				
				<tr style='height:26px;display:none' id="trTokenAuthKey">
					<td id="tdTokenAuthKey" style="background: url('/wui/theme/ecology8/page/images/login/input_wev8.png');height:45px;">
						<div class="relative " style="height:45px;">
						   <img class="absolute" style="top:10px;left:20px;" src="/wui/theme/ecology8/page/images/login/password_wev8.png">	
						   <label for="tokenAuthKey" id="for_tokenAuthKey"   class="overlabel"><%=SystemEnv.getHtmlLabelName(84271,languageid)%></label>
						 </div>
					</td>
				</tr>
				<tr style="display:none">
					<td style="background: url('/wui/theme/ecology8/page/images/login/input_wev8.png');height:45px;">
					<div class="relative " style="height:45px;">
					   <img class="absolute" style="top:10px;left:20px;" src="/wui/theme/ecology8/page/images/login/password_wev8.png">	<input class="input" style=""  name="" id="" type="">
					 </div>
					</td>
				</tr>
				<tr>
					<td class="h-50">
					</td>
				</tr>
				<tr style="">
					<td >
						<input type="button" name="submit1" id="login1" value="" class="hand" tabindex="3" style="background: url('/wui/theme/ecology8/page/images/login/btn_wev8.png');height:45px;width:280px;border:0px;">
					</td>
				</tr>
			</table>
			
		</div>
		
		<div id="qrcodeLogin" class="hide">
			<div class="h-10">&nbsp;</div>
			<div class="center" >
				<div id="qrcodeImg" class="center relative"  style="padding-top:20px;padding-left:20px;width:145px;height:145px;background: url(/wui/theme/ecology8/page/images/login/qrcodebg_wev8.png);background-position: center center;background-repeat: no-repeat"></div>
			</div>
			<div class="h-10">&nbsp;</div>
			<div style="color:#D5E7E4">
				<%=SystemEnv.getHtmlLabelName(84272,languageid)%>
			</div>
			<div class="h-10">&nbsp;</div>
			<div>
				<input type="button" name="backbtn" id="backbtn" value="" class="hand"  style="background: url('/wui/theme/ecology8/page/images/login/back_wev8.png');height:36px;width:154px;border:0px;">
			</div>
		</div>
	   </form>
	</div>
	<div class="e8login-recordcode">
		<style type="text/css">
			.e8login-recordcode {
				height:60px;
				position:absolute;
				bottom:10px;
				width:100%;
				left:0;
				text-align:center;
				line-height: 60px;
			}
			.e8login-recordcode-view {
				height: 40px;
				min-width: 600px;
				text-align: center;
				line-height: 40px;
				color: #FFFFFF;
				display: inline-block;
				vertical-align: middle;
			}
			.e8login-recordcode-view a{
                color: #d5e7e4;
            }
		</style>
		<div class="e8login-recordcode-view"><%=recordcode%></div>
	</div>	
</div>

<!--detection the system font start -->
<DIV style="LEFT: 0px; POSITION: absolute; TOP: 0px;"><OBJECT ID="sfclsid" CLASSID="clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b" WIDTH="0px" HEIGHT="0px"></OBJECT></DIV>

<style type="text/css">
	html,body{
		height:100%;
	}
	.input{
		left:50px;
		top:10px;
		height:25px;
		width:210px;
		background:transparent!important;
		color:#ffffff!important;
		border:0px;
		position:absolute;
		font-size: 15px;
		outline:none;
	}
	
	
	
	
	.input1{
		left:30px;
		height:25px;
		width:210px;
		background:transparent!important;
		color:#ffffff!important;
		border:0px;
		position:absolute;
		font-size: 15px;
		outline:none;
	}
	.langOver{
		color:#797E81!important;
	}
	

	.overlabel{
		position:absolute;
		z-index:1;
		font-size:14px;
		left:50px;
		font-size:14px;
		color:#D5E7E4!important;
		line-height: 40px!important;
		
	}
	#qrcodeImg table{
		position:absolute;
		top:10px;
		left: 10px;
	}
	#syslangul{
		width:80px;
		list-style: none;
		
		background: #f3fbf9;
		z-index: 1000;
		margin: 0px;
		padding: 0px;
		top:20px;
	}
	#syslangul li{
		text-align: left;
		height:20px;
		line-height:20px;
		cursor:pointer;
		color:#646767;
		padding-left: 9px;
		
	}
	
	#syslangul .selected{
		color:#ffffff!important;
		background: #4695c4!important;
	}
	
	.selectLanOver{
		background: #ecf4f7;
		color:#646767!important;
		
		
	}
</style>
<script type="text/javascript">


jQuery(document).ready(function () {
	var fflg = "";
	$("label.overlabel").overlabel();
	
	if (fflg == 0) {
    	$("input[name='loginid']").focus();
    	$(".overlabel[for='loginid']").css( { 'text-indent': '-10000px' });
    	$("input[name='loginid']").parents("td").css("background","url('/wui/theme/ecology8/page/images/login/inputOver_wev8.png')")
	} else if (fflg == 1) {
    	$("input[name='userpassword']").focus();
    	$(".overlabel[for='userpassword']").css( { 'text-indent': '-10000px' });
    	$("input[name='userpassword']").parents("td").css("background","url('/wui/theme/ecology8/page/images/login/inputOver_wev8.png')")
	} else if (fflg == 2) {
    	$("input[name='tokenAuthKey']").focus();
    	$(".overlabel[for='tokenAuthKey']").css( { 'text-indent': '-10000px' });
    	$("input[name='tokenAuthKey']").parents("td").css("background","url('/wui/theme/ecology8/page/images/login/inputOver_wev8.png')")
	}
	
	
	
	jQuery(".input").bind("blur",function(){
    	$(this).parents("td").css("background","url('/wui/theme/ecology8/page/images/login/input_wev8.png')")
    })
    jQuery(".input").bind("focus",function(){
    	$(this).parents("td").css("background","url('/wui/theme/ecology8/page/images/login/inputOver_wev8.png')")
    })
    
    jQuery("#qrcode").hover(
    	function(){
    		$(this).attr("src","/wui/theme/ecology8/page/images/login/qrcodeOver_wev8.png")
    	},
    	function(){
    		$(this).attr("src","/wui/theme/ecology8/page/images/login/qrcode_wev8.png")
    	});
    	
    jQuery("#login").hover(
    	function(){
    		$(this).css("background","url(/wui/theme/ecology8/page/images/login/btnOver_wev8.png)")
    	},
    	function(){
    		$(this).css("background","url(/wui/theme/ecology8/page/images/login/btn_wev8.png)")
    	});
      jQuery("#backbtn").hover(
    	function(){
    		$(this).css("background","url(/wui/theme/ecology8/page/images/login/backOver_wev8.png)")
    	},
    	function(){
    		$(this).css("background","url(/wui/theme/ecology8/page/images/login/back_wev8.png)")
    	});
    jQuery("#qrcode").bind("click",function(){
    	$("#normalLogin").hide();
    	$("#messageDiv").hide();
    	$("#qrcodeDiv").hide();
    	$("#langDiv").removeClass("last").removeClass("p-r-30")
    	$("#qrcodeLogin").show();
    });
    
    jQuery("#backbtn").bind("click",function(){
    	$("#normalLogin").show();
    	$("#messageDiv").show();
    	$("#qrcodeDiv").show();
    	$("#langDiv").addClass("last").addClass("p-r-20")
    	$("#qrcodeLogin").hide();
    })
    
    $('#qrcodeImg').qrcode({
			render	: "div",
			text	: "ecologylogin:<%=session.getId() %>",
			size:125,
            background : "none",
            fill : "#424345"
		});
	loginInterval = window.setInterval(function () {
			getloginstatus("<%=session.getId() %>");
		}, 1000);	
	
	$("#selectLan").bind("click",function(event){
		var left = jQuery(this).offset().left;
    	var top = jQuery(this).offset().top+20;
		$("#syslangul").show();
		$("#syslangul").css("left",left+"px");
		$("#syslangul").css("top",top+"px");
		$(this).addClass("selectLanOver");
		event.stopPropagation();
		
	});
	$("#syslangul").find("li").hover(function(){
		$("#syslangul").find(".selected").removeClass("selected");
		$(this).addClass("selected");
	},function(){
		
	})
	
	$("#syslangul").find("li").bind("click",function(){
		$("#islanguid").val($(this).attr("lang"));
		$("#selectLan").find(".text").text($(this).text());
		$("#syslangul").hide();
		$(this).addClass("selected");
		$("#selectLan").removeClass("selectLanOver")
	})
	
	$(document).bind("click",function(){
		$("#syslangul").hide();
		$("#selectLan").removeClass("selectLanOver")
	})
	
});


function getloginstatus(key) {
		var langid = $("#islanguid").val();
		if(!$("#qrcodeLogin").is(":hidden")){
			jQuery.ajax({
	            url: "/mobile/plugin/login/QCLoginStatus.jsp?langid="+langid+"&loginkey=" + key + "&rdm=" + new Date().getTime(),
	            dataType: "text", 
	            contentType : "charset=UTF-8", 
	            error:function(ajaxrequest){}, 
	            success:function(content){
					if (jQuery.trim(content) != '0' && jQuery.trim(content) != '9') {
						//alert("Successful user login!");
						window.clearInterval(loginInterval);
						window.location.href = jQuery.trim(content);
					}
	            }
	        });
	        }
	}
  

var userUsbType="0";


jQuery(window).bind("resize",function(){
	jQuery(".overlabel-wrapper").css("position","relative");
})
</script>

</body>
</html>



