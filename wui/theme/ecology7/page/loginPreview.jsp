
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

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<SCRIPT type=text/javascript src="/wui/common/jquery/jquery_wev8.js"></SCRIPT>
<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.cycle.all_wev8.js"></script>
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>

<!-- QRCode -->
<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/jquery.qrcode_wev8.js"></script>
<script type="text/javascript" src="/wui/common/jquery/plugin/qrcode/qrcode_wev8.js"></script>

<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>

<link href="/css/commom_wev8.css" type="text/css" rel="stylesheet">

<link href="/wui/theme/ecology7/page/softkey/softkey_wev8.css" type="text/css" rel="stylesheet">

<script type="text/javascript" src="/wui/theme/ecology7/page/softkey/Keyboard_wev8.js"></script>


<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 Start -->
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF">
<%String isMobileTest =Util.null2String(request.getParameter("isMobileTest"));%>


<%
int languageid = Util.getIntValue(request.getParameter("languageid"),7);

String dlflg = request.getParameter("dlflg");
if (dlflg != null && "true".equals(dlflg)) {
    String fontFileName = "USBkeyTool.rar";
    String fontFilePath = "wui/theme/ecology7/page/resources/";
    
    BufferedInputStream bis = null;
    BufferedOutputStream bos = null;
    try {
    	String projectPath = this.getServletConfig().getServletContext().getRealPath("/");
		if (projectPath.lastIndexOf("/") != (projectPath.length() - 1) && projectPath.lastIndexOf("\\") != (projectPath.length() - 1)) {
			projectPath += "/";
		}
        String filepath = projectPath + fontFilePath + fontFileName;

        response.reset();
        response.setHeader("Pragma", "No-cache");
        response.setHeader("Cache-Control", "no-cache");
        response.setDateHeader("Expires", 0);
        response.setContentType("application/octet-stream;charset=UTF-8");
        response.setHeader("Content-disposition", "attachment;filename=\"" + fontFileName + "\"");
        
        bis = new BufferedInputStream(new FileInputStream(filepath));
        bos = new BufferedOutputStream(response.getOutputStream());
        
        byte[] buff = new byte[2048];
        int bytesRead;
        while ((bytesRead = bis.read(buff, 0, buff.length)) != -1) {
            bos.write(buff, 0, bytesRead);
        }
        bos.flush();
        //out.clear();
        out = pageContext.pushBody();
    } catch(IOException e) {
        e.printStackTrace();
    } finally {
        if (bis != null) {
            try {
                bis.close();
                bis = null;
            } catch (IOException e) {
            }
        }
        
        if (bos != null) {
            try {
                bos.close();
                bos = null;
            } catch (IOException e) {
            }
        }
    }
    return;
}

String logintype = Util.null2String(request.getParameter("logintype")) ;
String templateId = Util.null2String(request.getParameter("templateId"));
String templateType = "";
String imageId = "";
String imageId2 = "";
String loginTemplateTitle="";
String backgroundColor = "";
String backgroundUrl="/wui/theme/ecology7/page/images/login/login_cbg"+((logintype != null && logintype.trim().equals("2")) ? "2" : "")+".png";
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
		    out.println("<script language='javascript'>document.title='"+loginTemplateTitle+"';</script>");
	}
}

if(imageId.indexOf("/")==-1&&!"".equals(imageId)){
	backgroundUrl = "/LoginTemplateFile/"+imageId;
}else if(imageId.indexOf("/")>-1){
	backgroundUrl =imageId;
}
%>


<script language="javascript"> 

function addCssByStyle(cssString){
	var doc=document;
	var style=doc.createElement("style");
	style.setAttribute("type", "text/css");

	if(style.styleSheet){// IE
		style.styleSheet.cssText = cssString;
	} else {// w3c
		var cssText = doc.createTextNode(cssString);
		style.appendChild(cssText);
	}

	var heads = doc.getElementsByTagName("head");
	if(heads.length) {
		heads[0].appendChild(style);
	} else {
		doc.documentElement.appendChild(style);
	}
}

//alert( window.navigator.userAgent+"%%%"+jQuery.client.version +"%%%"+jQuery.client.browser+"%%%"+$.client.os+"&&&&&"+jQuery.client.getOsVersion())
var osV = jQuery.client.version; 
var isIE = jQuery.client.browser=="Explorer"?"true":"false";

if (osV < 6) {
	document.getElementById('FONT2SYSTEMF').href = "/wui/common/css/notW7AVFont_wev8.css";
	addCssByStyle("input { Line-height:100%!important;}");
}
</script> 
<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 End -->

<!--[if IE 6]>
	<script type='text/javascript' src='/wui/common/jquery/plugin/8a-min_wev8.js'></script>
<![endif]-->

<!--超时跳转,跳出iframe黄宝2011/5/25-->

<script language="JavaScript">
function click(e) {
	if($.browser.msie){
		if (event.button == 2 || event.button == 3){
			alert('<%=SystemEnv.getHtmlLabelName(16641,languageid)%>')
			return false;
		}
	}else{
		if (e.which == 2 || e.which == 3){
			alert('<%=SystemEnv.getHtmlLabelName(16641,languageid)%>')
			return false;
		}
	} 
   
}
document.onmousedown=click
</script>
<script type="text/javascript">
$(document).ready(function() {
    $(function() {
        
		//alert($("label.overlabel").length)
		$("label.overlabel").overlabel();

        var iconImg="/wui/theme/ecology7/page/images/login/graypoint_wev8.png"
        var iconImg_over="/wui/theme/ecology7/page/images/login/redpoint1_wev8.png"
    
        $('#slideshow').cycle({
            fx:      'scrollHorz',
            timeout:  7000,
            prev:    '#crossPrev',
            next:    '#crossNext', 
            pager:   '#nav',
            pagerAnchorBuilder: pagerFactory,
            before:  function(currSlideElement, nextSlideElement, options, forwardFlag) {  
			        	if($.browser.msie){
							if($.browser.version=="6.0") {
								DD_belatedPNG.fix('a,div,img,background,span');
							}
						}
			

                        var curIndex=$(currSlideElement).attr("index");
                        var curSlidnavtitle=$($("#slideDemo .slidnavtitle")[curIndex]);
                        if(curSlidnavtitle!=null){
                            curSlidnavtitle.css("background","url('"+iconImg+"') center center no-repeat");
                           // curSlidnavtitle.css("zindex",9999999);
                        }
    
                        var nextIndex=$(nextSlideElement).attr("index");
    
                        var nextSlidnavtitle=$($("#slideDemo .slidnavtitle")[nextIndex]);
                        if(nextSlidnavtitle!=null){
                            var tesy = "url('"+iconImg_over+"') no-repeat";
                            var tempInt = parseInt(nextIndex)  + 1;
                            nextSlidnavtitle.css("background","url('/wui/theme/ecology7/page/images/login/redpoint" + tempInt + ".png') center center  no-repeat");
                            //nextSlidnavtitle.css("zindex",999);
                        }
                    }                       
        }); 
        function pagerFactory(idx, slide) {
            var s = idx > 20 ? ' style="display:none"' : '';
            //alert((idx==0?iconImg_over:iconImg)
            return ' <span class="m-t-5  slidnavtitle hand"  style="background:url('+(idx==0?iconImg_over:iconImg)+') center center no-repeat;position:relative;height:32px;width:32px;z-index:99999">&nbsp;</span>';
        };
        
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
       imgArray=new Array("lg_bg1_wev8.jpg","lg_bg2_wev8.jpg","lg_bg3_wev8.jpg","lg_bg4_wev8.jpg","lg_bg5_wev8.jpg","lg_bg6_wev8.jpg");
       discnt=6;
       imgPath="/wui/theme/ecology7/page/images/login/"
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
     	if(img1.indexOf("/")>-1){
    		 $("#disimg0").css("background", "url("+img1+ ") no-repeat");
    	}else{
    		 $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat");
    	}
    	if(img2.indexOf("/")>-1){
    		 $("#disimg1").css("background", "url("+img2+ ") no-repeat");
    	}else{
    		 $("#disimg1").css("background", "url(" +imgPath+img2+ ") no-repeat");
    	}
	   
	   if(img3.indexOf("/")>-1){
    		 $("#disimg2").css("background", "url("+img3+ ") no-repeat");
    	}else{
    		 $("#disimg2").css("background", "url(" +imgPath+img3+ ") no-repeat");
    	}
    }else if(discnt==2){
       if(img1.indexOf("/")>-1){
    		 $("#disimg0").css("background", "url("+img1+ ") no-repeat");
    	}else{
    		 $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat");
    	}
    	if(img2.indexOf("/")>-1){
    		 $("#disimg1").css("background", "url("+img2+ ") no-repeat");
    	}else{
    		 $("#disimg1").css("background", "url(" +imgPath+img2+ ") no-repeat");
    	}
    }else if(discnt==1){
       if(img1.indexOf("/")>-1){
    		 $("#disimg0").css("background", "url("+img1+ ") no-repeat");
    	}else{
    		 $("#disimg0").css("background", "url(" +imgPath+img1+ ") no-repeat");
    	}
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

/*For slide*/
.slideDivContinar { height: 260px; width: 920px; padding:0; margin:0; overflow: hidden }
.slideDiv {height:260px; width: 920px;top:0; left:0;margin:0;padding:0;}


/*For Input*/
.inputforloginbg{ width:172px;height:21px;border:none;}
.inputforloginbg input{border:none;height:15px;background:none;}

.lgsm {width:76px;height:35px;background:url(/wui/theme/ecology7/page/images/login/lg_login_sbmt_wev8.png) 0px 0px no-repeat; border:none;}
.lgsmMouseOver {width:76px;height:35px;background:url(/wui/theme/ecology7/page/images/login/lg_login_sbmt_hover_wev8.png) 0px 0px no-repeat; border:none;}

.lgen {width:76px;height:35px;background:url(/wui/theme/ecology7/page/images/login/lg_login_sbmt_en_wev8.png) 0px 0px no-repeat; border:none;}
.lgenMouseOver {width:76px;height:35px;background:url(/wui/theme/ecology7/page/images/login/lg_login_sbmt_en_hover_wev8.png) 0px 0px no-repeat; border:none;}


.crossNav{width:100%;height:30px;position:absolute;margin-top:105px;padding-left:30px;padding-right:30px;}
</STYLE>


</head>
<body style="padding:0;margin:0;background:<%="".equals(backgroundColor) ? "#e8ebef" :  backgroundColor%>;margin:0;padding:0;" scroll="auto">
<TABLE width="100%" height="100%" cellpadding="0px" cellspacing="0px">
    <TR>
        <TD align="center">
            <TABLE width="100%" height="610px"   cellpadding="0px"  cellspacing="0px">
                <TR>
                    <TD width="*">&nbsp;</TD>
                    <TD height="610px" valign="top" id="lgcontenttbl" style="width:990px">
                        <form name="form1" action="/login/VerifyLogin.jsp" name="loginForm"  onSubmit="return false;">
                            <table border="0" width="990px" height="610px" align="center" cellpadding="0px" cellspacing="0px" style="background:url(<%=backgroundUrl%>) no-repeat;">
                                <tr>
                                    <td colspan="2" height="123px">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" valign="top" style="padding-top:0px">
                                        <div id="slideDemo" style="overflow:hidden;width:990px;height:260px;">
                                            <div id="slideshow" class="slideDivContinar" style="margin-left:34;clear:left;top:0px;">
                                            <%
                                             int imgSize=imageId2List.size()>=3||imageId2List.size()==0?3:imageId2List.size();
                                             for(int i=0;i<imgSize&&i<3;i++){
                                            %>
                                             <div id="disimg<%=i%>" class='slideDiv' index='<%=i%>'  style='cursor: pointer;'></div>
                                            <%} %>
                                            </div>
                                            <DIV style="position:relative;height:32px;top:-38;margin-left:34;width:920px;margin-top:0;overflow:hidden;">
                                                <table border="0" width="920px" align="center" cellpadding="0px" cellspacing="0px">
                                                    <tr>
                                                        <td align="center">
                                                            <DIV style="position:relative" align="center" id="nav"></DIV>
                                                        </td>
                                                    </tr>
                                                </table>
                                                
                                            </DIV>
                                        </div>
                                       <div style="width:100%;height:220px;">
                                       		<div style="width:710px;height:100%;float:left;position:relative;">
                                       			
                                       			<table  style="margin-top:100px;margin-left:30px;">
														<tr width="100%">
                                                            <td style="width:10px">
                                                            </td>

                                                            <td style="font-size:11px;position:relative;z-index:1000">
																<style>
																	a{color:#123885;}
																</style>
                                                            </td>
                                                        </tr>
                                                        <tr width="100%">
                                                            <td style="width:10px">
                                                            </td>
                                                            <td style="font-size:11px;">
                                                                <span id="ieverTips" style="display:none;color:red;"><%=SystemEnv.getHtmlLabelName(127947,languageid)%><a href="http://windows.microsoft.com/zh-CN/internet-explorer/downloads/ie-8" style="color:red;"><%=SystemEnv.getHtmlLabelName(17530,languageid)%></a></span>
                                                            </td>
                                                        </tr>
                                                        <tr width="100%">
                                                            <td style="width:10px">
                                                            </td>
                                                            <td style="font-size:11px;">
                                                                <span id="fontTips" style="display:none"><%=SystemEnv.getHtmlLabelName(127948,languageid)%><a href="/wui/theme/ecology7/page/login.jsp?dlflg=true" style="color:red;"><%=SystemEnv.getHtmlLabelName(258,languageid)%></a></span>
                                                            </td>
                                                        </tr>
                                                    </table>
                                       		</div>
                                       		<div style="width:275px;height:100%;float:right;">
                                       			<div id="AccountLoginBlock">
                                       			<div style="margin-left:4px;height:40px;margin-top:6px;width:226px;overflow:hidden;">
                                                     
                                                </div>
                                                <div  style="padding-left:30px;">
                                                	<style>
														label.overlabel {
															position:absolute;
															top:3px;
															left:5px;
															z-index:1;
															color:#999;
														  }

														  .input_out{
															height:21px;
															width:172px;
															background:url('/wui/theme/ecology7/page/images/login/input_bg_login_wev8.gif') no-repeat;position:relative;
														  }

														  .input_inner{
															height:19px;
															width:166px;
															margin-left:3px;
															margin-top:1px;
															border:0px solid red;
															font-size:12px;
														  }

													</style>
                                                	<table width="172px" height="130px">
														<!-- 用户名 -->
														<tr style='height:26px'><td> 	
															<div class="input_out">
																<label for="loginid" id="for_loginid" class="overlabel"><%=SystemEnv.getHtmlLabelName(2072,languageid)%>:</label>
																<input  type="text" name="loginid"  id="loginid" class="input_inner"  value="" >
															</div>												
														</td></tr>

																												
														<!-- 密码 -->
														<tr style='height:26px'><td> 	
															<div class="input_out">
																<label for="userpassword" id="for_userpassword"  class="overlabel"><%=SystemEnv.getHtmlLabelName(409,languageid)%>:</label>
																<input  type="password" name="userpassword"  id="userpassword"   class="input_inner">
															</div>												
														</td></tr>

														<!-- 提交 -->
														<tr><td> 	
															<input type="submit" name="submit" id="login" value="" class="lgsm" tabindex="3" style="margin-left:0px;cursor:pointer;">										
														</td></tr>
													                  	
													</table>
                                                </div>
                                                
                                                
                                                </div>
                                                
                                       		</div>
                                       </div>  
                                    </td>
                                </tr>
                         
                                <tr>
                                    <td width="100%">
                                        <div style="border-style:none none none none;border-color:#c6c6c6;border-width:1px 0 0 0;"></divs>
                                    </td>
                                </tr>
                                
                            </table>
                        </form>
                    </TD>
                    <TD width="*">&nbsp;</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>

<!--detection the system font start -->
<DIV style="LEFT: 0px; POSITION: absolute; TOP: 0px;"><OBJECT ID="sfclsid" CLASSID="clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b" WIDTH="0px" HEIGHT="0px"></OBJECT></DIV>

</body>
</html>



