
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String titlename  = "";
%>
<html>
  <head>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles_wev8.css">
	-->
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
  </head>
  <body>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %> 
    <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td width="160px">					
			</td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				&nbsp;&nbsp;&nbsp;
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<div class="advancedSearchDiv" id="advancedSearchDiv"></div>
	
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr style="background-color: #F6F9FF;">
			<td width="33%" style="vertical-align: top;" align="center">
				<img src="/admincenter/img/xzmb_wev8.png" />
			</td>
			<td width="33%" style="vertical-align: top;" align="center">
				<img src="/admincenter/img/yskf_wev8.png" />
			</td>
			<td width="33%" style="vertical-align: top;" align="center">
				<img src="/admincenter/img/yszc_wev8.png" />
			</td>
		</tr>
		<tr style="background-color: #F6F9FF;">
			<td style="vertical-align: top;background: url(/admincenter/img/dian1_wev8.png) repeat-y center;" align="center" height="30px">
				&nbsp;
			</td>
			<td style="vertical-align: top;background: url(/admincenter/img/dian1_wev8.png) repeat-y center;" align="center" height="30px">
				&nbsp;
			</td>
			<td style="vertical-align: top;background: url(/admincenter/img/dian1_wev8.png) repeat-y center;;" align="center" height="30px">
				&nbsp;
			</td>
		</tr>
		<tr style="background-color: #F6F9FF;">
			<td style="vertical-align: top;background-image: url(/admincenter/img/dian_wev8.png);background-repeat: repeat-x;background-position: 10px;" align="center">
				<img src="/admincenter/img/1_wev8.png" style="margin-top: 3px;" />
			</td>
			<td style="vertical-align: top;background-image: url(/admincenter/img/dian_wev8.png);background-repeat: repeat-x;background-position: 10px;" align="center">
				<img src="/admincenter/img/jiantou_wev8.png" style="float: left;margin-top: 3px;" />
				<img src="/admincenter/img/2_wev8.png" style="margin-top: 3px;" />
				<img src="/admincenter/img/jiantou_wev8.png" style="float: right;margin-top: 3px;" />
			</td>
			<td style="vertical-align: top;background-image: url(/admincenter/img/dian_wev8.png);background-repeat: repeat-x;background-position: 10px;" align="center">
				<img src="/admincenter/img/3_wev8.png" style="margin-top: 3px;" />
			</td>
		</tr>
		<tr style="background-color: #F6F9FF;">
			<td style="vertical-align: middle;" align="center">
				<p style="color: #324263;margin-top: 15px;font-weight: bold;"><%=SystemEnv.getHtmlLabelName(28576,user.getLanguage())%></p><!--下载模板-->
				<p style="color: #9BA6CC;margin-top: 15px;font-weight: bold;margin-bottom: 30px;cursor: pointer;" 
					onclick="dlFile();"><%=SystemEnv.getHtmlLabelName(124798,user.getLanguage())%></p><!--点击下载模板-->
			</td>
			<td style="vertical-align: middle;" align="center">
				<p style="color: #324263;margin-top: 15px;font-weight: bold;"><%=SystemEnv.getHtmlLabelName(33464,user.getLanguage())%></p><!--元素开发-->
				<p style="color: #9BA6CC;margin-top: 15px;font-weight: bold;margin-bottom: 30px;"><%=SystemEnv.getHtmlLabelName(124800,user.getLanguage())%></p><!--按照开发指南进行具体页面的开发-->
			</td>
			<td style="vertical-align: middle;;" align="center">
				<p style="color: #324263;margin-top: 15px;font-weight: bold;"><%=SystemEnv.getHtmlLabelName(33465,user.getLanguage())%></p><!--元素注册-->
				<p style="color: #9BA6CC;margin-top: 15px;font-weight: bold;margin-bottom: 30px;cursor: pointer;" 
					onclick="parent.document.location.href='/homepage/maint/HomepageTabs.jsp?_fromURL=ElementRegister'"><%=SystemEnv.getHtmlLabelName(124801,user.getLanguage())%></p><!--上传开发好的文件包-->
			</td>
		</tr>
		<tr>
			<td style="vertical-align: middle;background-color: #EBF0F9;" align="center" height="56px;" colspan="3">
				<p style="color: #324263;font-weight: bold;"><%=SystemEnv.getHtmlLabelName(124802,user.getLanguage())%></p><!--元素XML结构说明-->
			</td>
		</tr>
		<tr>
			<td style="" align="center" colspan="3">
				<table border="0" cellpadding="0" cellspacing="0" style="margin: 0px;padding: 0px;width: 920px;height: 285px;padding-top: 25px;padding-bottom: 25px;border-bottom-style: dotted;border-bottom-width: 2px;border-bottom-color: #D9E3ED;" align="center">
					<tr>
						<td>
							<img id="jcxx" src="/admincenter/img/jcxx_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;margin-right: 45px;" />
						</td>
						<td id="tdTable1">
							<img id="jcxx1" src="/admincenter/img/icon-1-normal_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
							<img id="jcxx2" src="/admincenter/img/icon-2-normal_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
							<img id="jcxx3" src="/admincenter/img/icon-3-normal_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
						</td>
						<td width="318">
							<img id="jcxxTips" src="" border="0" style="border: 0px;margin: 0px;padding: 0px;display: none;" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td style="" align="center" colspan="3">
				<table border="0" cellpadding="0" cellspacing="0" style="margin: 0px;padding: 0px;width: 925px;height: 325px;padding-top: 25px;padding-bottom: 25px;border-bottom-style: dotted;border-bottom-width: 2px;border-bottom-color: #D9E3ED;" align="center">
					<tr>
						<td width="323">
							<img id="xszdTips" src="" border="0" style="border: 0px;margin: 0px;padding: 0px;display: none;margin-right: 5px;" />
						</td>
						<td id="tdTable2">
							<img id="xszd1" src="/admincenter/img/xszd1_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
							<img id="xszd2" src="/admincenter/img/xszd2_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
							<img id="xszd3" src="/admincenter/img/xszd3_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
							<img id="xszd4" src="/admincenter/img/xszd4_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
						</td>
						<td>
							<img id="xszd" src="/admincenter/img/xszd_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;margin-right: 40px;" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td style="" align="center" colspan="3">
				<table border="0" cellpadding="0" cellspacing="0" style="margin: 0px;padding: 0px;width: 920px;height: 370px;padding-top: 10px;" align="center">
					<tr>
						<td>
							<img id="xsnr" src="/admincenter/img/xsnr_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;margin-right: 45px;" />
						</td>
						<td id="tdTable3">
							<img id="xsnr1" src="/admincenter/img/xsnr1_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
							<img id="xsnr2" src="/admincenter/img/xsnr2_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
							<img id="xsnr3" src="/admincenter/img/xsnr3_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
							<img id="xsnr4" src="/admincenter/img/xsnr4_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
							<img id="xsnr5" src="/admincenter/img/xsnr5_wev8.png" border="0" style="border: 0px;margin: 0px;padding: 0px;float: left;" />
						</td>
						<td width="318">
							<img id="xsnrTips" src="" border="0" style="border: 0px;margin: 0px;padding: 0px;display: none;" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td style="" align="center" colspan="3">
				<table border="0" cellpadding="0" cellspacing="0" style="width: 220px;height: 45px;margin: 0px;padding: 0px;padding-top: 10px;padding-bottom: 45px;" align="center">
					<tr>
						<td>
							<span onclick="dlFile();" style="background: url(/admincenter/img/btn1L_wev8.png);float: left;height: 45px;width: 5px;cursor: pointer;"></span>
							<button onclick="dlFile();" 
								style="background: url(/admincenter/img/btn1C_wev8.png);float: left;height: 45px;width: 210px;cursor: pointer;color: #FFF;text-align: center;vertical-align: middle;">
									<font size="2" style="font-weight: bold;">
										<%=SystemEnv.getHtmlLabelName(124805,user.getLanguage())%><!--点击下载范本元素的配置文件-->
									</font>
							</button>
							<span onclick="dlFile();" style="background: url(/admincenter/img/btn1R_wev8.png);float: left;height: 45px;width: 5px;cursor: pointer;"></span>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<div style="display: none;">
		<%=SystemEnv.getHtmlLabelName(124823,user.getLanguage())%>:
		<!--鼠标坐标：-->
		X:<span id="mX"></span>；
		Y:<span id="mY"></span>；
		img src:<span id="imgSrc"></span>；
	</div>
	
<script type="text/javascript">
var _breakFlag = false;
(function(){
    var addEvent = (function(){
             if (window.addEventListener) {
                return function(el, sType, fn, capture) {
                    el.addEventListener(sType, fn, (capture));
                };
            } else if (window.attachEvent) {
                return function(el, sType, fn, capture) {
                    el.attachEvent("on" + sType, fn);
                };
            } else {
                return function(){};
            }
        })();
        
        
	var _objArray = jQuery('html, body, .content');
    for(var i=0;i<_objArray.length;i++){
	    // IE6/IE7/IE8/Opera 10+/Safari5+
	    addEvent(_objArray[i], 'mousewheel', function(event){
	    	_breakFlag = true;
	    }, false);
	    
	    // Firefox 3.5+
	    addEvent(_objArray[i], 'DOMMouseScroll',  function(event){
	    	_breakFlag = true;
	    }, false);
    }
})();


var changeTipsIdx = 0;
var intervalTdTable=null;

function windowScrolling(_toScrollBy){
	if(!_breakFlag && intervalTdTable!=null){
		jQuery('html, body, .content').animate({scrollTop: _toScrollBy}, 1000); 
	}
}

function dlFile(){
	document.location.href='/admincenter/portalEngine/hpElTemplate.zip';
}

function changeImgSrcTdTable1(_tdTable1_x, _tdTable1_y){
	var toScrollBy = jQuery("#tdTable1").offset().top;
	if((_tdTable1_x >= 10 && _tdTable1_x <= 40 && _tdTable1_y >= 11 && _tdTable1_y <= 38) || (_tdTable1_x==null && _tdTable1_y==null && changeTipsIdx==1)){
		//jQuery(document).scrollTop(toScrollBy);
		windowScrolling(toScrollBy);
		jQuery("#jcxx1").attr("src", "/admincenter/img/icon-1-normal-hot-icon_wev8.png");
		jQuery("#jcxx2").attr("src", "/admincenter/img/icon-2-normal_wev8.png");
		jQuery("#jcxx3").attr("src", "/admincenter/img/icon-3-normal_wev8.png");
		jQuery("#jcxxTips").show();
		jQuery("#jcxxTips").attr("src", "/admincenter/img/tips01_wev8.png");
	}else if((_tdTable1_x >= 45 && _tdTable1_x <= 78 && _tdTable1_y >= 11 && _tdTable1_y <= 38) || (_tdTable1_x==null && _tdTable1_y==null && changeTipsIdx==2)){
		//jQuery(document).scrollTop(toScrollBy);
		windowScrolling(toScrollBy);
		jQuery("#jcxx1").attr("src", "/admincenter/img/icon-1-normal-hot-renyuan_wev8.png");
		jQuery("#jcxx2").attr("src", "/admincenter/img/icon-2-normal_wev8.png");
		jQuery("#jcxx3").attr("src", "/admincenter/img/icon-3-normal_wev8.png");
		jQuery("#jcxxTips").show();
		jQuery("#jcxxTips").attr("src", "/admincenter/img/tips02_wev8.png");
	}else if((_tdTable1_x >= 453 && _tdTable1_x <= 483 && _tdTable1_y >= 11 && _tdTable1_y <= 38) || (_tdTable1_x==null && _tdTable1_y==null && changeTipsIdx==3)){
		//jQuery(document).scrollTop(toScrollBy);
		windowScrolling(toScrollBy);
		jQuery("#jcxx1").attr("src", "/admincenter/img/icon-1-normal-hot-more_wev8.png");
		jQuery("#jcxx2").attr("src", "/admincenter/img/icon-2-normal_wev8.png");
		jQuery("#jcxx3").attr("src", "/admincenter/img/icon-3-normal_wev8.png");
		jQuery("#jcxxTips").show();
		jQuery("#jcxxTips").attr("src", "/admincenter/img/tips03_wev8.png");
	}else if((_tdTable1_x >= 88 && _tdTable1_x <= 443 && _tdTable1_y >= 105 && _tdTable1_y <= 151) || (_tdTable1_x==null && _tdTable1_y==null && changeTipsIdx==4)){
		//jQuery(document).scrollTop(toScrollBy);
		windowScrolling(toScrollBy);
		jQuery("#jcxx1").attr("src", "/admincenter/img/icon-1-normal_wev8.png");
		jQuery("#jcxx2").attr("src", "/admincenter/img/icon-2-normal-hot-c_wev8.png");
		jQuery("#jcxx3").attr("src", "/admincenter/img/icon-3-normal_wev8.png");
		jQuery("#jcxxTips").show();
		jQuery("#jcxxTips").attr("src", "/admincenter/img/tips04_wev8.png");
	}else if((_tdTable1_x >= 88 && _tdTable1_x <= 443 && _tdTable1_y >= 155 && _tdTable1_y <= 243) || (_tdTable1_x==null && _tdTable1_y==null && changeTipsIdx==5)){
		//jQuery(document).scrollTop(toScrollBy);
		windowScrolling(toScrollBy);
		jQuery("#jcxx1").attr("src", "/admincenter/img/icon-1-normal_wev8.png");
		jQuery("#jcxx2").attr("src", "/admincenter/img/icon-2-normal_wev8.png");
		jQuery("#jcxx3").attr("src", "/admincenter/img/icon-3-normal-hot-c_wev8.png");
		jQuery("#jcxxTips").show();
		jQuery("#jcxxTips").attr("src", "/admincenter/img/tips05_wev8.png");
	}else{
		jQuery("#jcxxTips").hide();
		jQuery("#jcxx1").attr("src", "/admincenter/img/icon-1-normal_wev8.png");
		jQuery("#jcxx2").attr("src", "/admincenter/img/icon-2-normal_wev8.png");
		jQuery("#jcxx3").attr("src", "/admincenter/img/icon-3-normal_wev8.png");
	}
}


function changeImgSrcTdTable2(_tdTable1_x, _tdTable1_y){
	var toScrollBy = jQuery("#tdTable2").offset().top;
	if((_tdTable1_x >= 60 && _tdTable1_x <= 320 && _tdTable1_y >= 105 && _tdTable1_y <= 145) || (_tdTable1_x==null && _tdTable1_y==null && changeTipsIdx==6)){
		//jQuery(document).scrollTop(toScrollBy);
		windowScrolling(toScrollBy);
		jQuery("#xszd1").attr("src", "/admincenter/img/xszd1_wev8.png");
		jQuery("#xszd2").attr("src", "/admincenter/img/xszd2hot_wev8.png");
		jQuery("#xszd3").attr("src", "/admincenter/img/xszd3_wev8.png");
		jQuery("#xszd4").attr("src", "/admincenter/img/xszd4_wev8.png");
		jQuery("#xszdTips").show();
		jQuery("#xszdTips").attr("src", "/admincenter/img/xszd_tips01_wev8.png");
	}else if((_tdTable1_x >= 60 && _tdTable1_x <= 320 && _tdTable1_y >= 162 && _tdTable1_y <= 200) || (_tdTable1_x==null && _tdTable1_y==null && changeTipsIdx==7)){
		//jQuery(document).scrollTop(toScrollBy);
		windowScrolling(toScrollBy);
		jQuery("#xszd1").attr("src", "/admincenter/img/xszd1_wev8.png");
		jQuery("#xszd2").attr("src", "/admincenter/img/xszd2_wev8.png");
		jQuery("#xszd3").attr("src", "/admincenter/img/xszd3hot_wev8.png");
		jQuery("#xszd4").attr("src", "/admincenter/img/xszd4_wev8.png");
		jQuery("#xszdTips").show();
		jQuery("#xszdTips").attr("src", "/admincenter/img/xszd_tips02_wev8.png");
	}else{
		jQuery("#xszdTips").hide();
		jQuery("#xszd1").attr("src", "/admincenter/img/xszd1_wev8.png");
		jQuery("#xszd2").attr("src", "/admincenter/img/xszd2_wev8.png");
		jQuery("#xszd3").attr("src", "/admincenter/img/xszd3_wev8.png");
		jQuery("#xszd4").attr("src", "/admincenter/img/xszd4_wev8.png");
	}
}


function changeImgSrcTdTable3(_tdTable1_x, _tdTable1_y){
	var toScrollBy = jQuery("#tdTable3").offset().top;
	if((_tdTable1_x >= 130 && _tdTable1_x <= 320 && _tdTable1_y >= 100+25 && _tdTable1_y <= 135+25) || (_tdTable1_x==null && _tdTable1_y==null && changeTipsIdx==8)){
		//jQuery(document).scrollTop(toScrollBy);
		windowScrolling(toScrollBy);
		jQuery("#xsnr2").attr("src", "/admincenter/img/xsnr2hot_wev8.png");
		jQuery("#xsnr3").attr("src", "/admincenter/img/xsnr3_wev8.png");
		jQuery("#xsnr4").attr("src", "/admincenter/img/xsnr4_wev8.png");
		jQuery("#xsnr5").attr("src", "/admincenter/img/xsnr5_wev8.png");
		jQuery("#xsnrTips").show();
		jQuery("#xsnrTips").attr("src", "/admincenter/img/xsnr2tips_wev8.png");
	}else if((_tdTable1_x >= 130 && _tdTable1_x <= 320 && _tdTable1_y >= 150+25 && _tdTable1_y <= 176+25) || (_tdTable1_x==null && _tdTable1_y==null && changeTipsIdx==9)){
		//jQuery(document).scrollTop(toScrollBy);
		windowScrolling(toScrollBy);
		jQuery("#xsnr2").attr("src", "/admincenter/img/xsnr2_wev8.png");
		jQuery("#xsnr3").attr("src", "/admincenter/img/xsnr3hot_wev8.png");
		jQuery("#xsnr4").attr("src", "/admincenter/img/xsnr4_wev8.png");
		jQuery("#xsnr5").attr("src", "/admincenter/img/xsnr5_wev8.png");
		jQuery("#xsnrTips").show();
		jQuery("#xsnrTips").attr("src", "/admincenter/img/xsnr3tips_wev8.png");
	}else if((_tdTable1_x >= 130 && _tdTable1_x <= 320 && _tdTable1_y >= 194+25 && _tdTable1_y <= 220+25) || (_tdTable1_x==null && _tdTable1_y==null && changeTipsIdx==10)){
		//jQuery(document).scrollTop(toScrollBy);
		windowScrolling(toScrollBy);
		jQuery("#xsnr2").attr("src", "/admincenter/img/xsnr2_wev8.png");
		jQuery("#xsnr3").attr("src", "/admincenter/img/xsnr3_wev8.png");
		jQuery("#xsnr4").attr("src", "/admincenter/img/xsnr4hot_wev8.png");
		jQuery("#xsnr5").attr("src", "/admincenter/img/xsnr5_wev8.png");
		jQuery("#xsnrTips").show();
		jQuery("#xsnrTips").attr("src", "/admincenter/img/xsnr4tips_wev8.png");
	}else if((_tdTable1_x >= 130 && _tdTable1_x <= 320 && _tdTable1_y >= 231+25 && _tdTable1_y <= 272+25) || (_tdTable1_x==null && _tdTable1_y==null && changeTipsIdx==11)){
		//jQuery(document).scrollTop(toScrollBy);
		windowScrolling(toScrollBy);
		jQuery("#xsnr2").attr("src", "/admincenter/img/xsnr2_wev8.png");
		jQuery("#xsnr3").attr("src", "/admincenter/img/xsnr3_wev8.png");
		jQuery("#xsnr4").attr("src", "/admincenter/img/xsnr4_wev8.png");
		jQuery("#xsnr5").attr("src", "/admincenter/img/xsnr5hot_wev8.png");
		jQuery("#xsnrTips").show();
		jQuery("#xsnrTips").attr("src", "/admincenter/img/xsnr5tips_wev8.png");
	}else{
		jQuery("#xsnrTips").hide();
		jQuery("#xsnr2").attr("src", "/admincenter/img/xsnr2_wev8.png");
		jQuery("#xsnr3").attr("src", "/admincenter/img/xsnr3_wev8.png");
		jQuery("#xsnr4").attr("src", "/admincenter/img/xsnr4_wev8.png");
		jQuery("#xsnr5").attr("src", "/admincenter/img/xsnr5_wev8.png");
	}
}

function changeImgSrcTdTableAll(){
	changeTipsIdx++;
	if(!(changeTipsIdx>=1 && changeTipsIdx<=11)){
		changeTipsIdx = 1;
	}
	changeImgSrcTdTable1();
	changeImgSrcTdTable2();
	changeImgSrcTdTable3();
}

function runTdTableAll(){
	intervalTdTable = setInterval("changeImgSrcTdTableAll()", "2500");
}

jQuery(document).ready(function(){
	//windowScrolling();
	setTimeout("runTdTableAll()", "2500");
	
	jQuery("#tdTable1").mousemove(function(_evt){ 
		var tdTable1_x = _evt.pageX - jQuery(this).offset().left; 
		var tdTable1_y = _evt.pageY - jQuery(this).offset().top; 
		changeImgSrcTdTable1(tdTable1_x, tdTable1_y);
	}).mouseleave(function(){
		runTdTableAll();
    }).mouseenter(function(_evt){
		jQuery("#xszdTips").hide();
		jQuery("#xszd1").attr("src", "/admincenter/img/xszd1_wev8.png");
		jQuery("#xszd2").attr("src", "/admincenter/img/xszd2_wev8.png");
		jQuery("#xszd3").attr("src", "/admincenter/img/xszd3_wev8.png");
		jQuery("#xszd4").attr("src", "/admincenter/img/xszd4_wev8.png");

		jQuery("#xsnrTips").hide();
		jQuery("#xsnr2").attr("src", "/admincenter/img/xsnr2_wev8.png");
		jQuery("#xsnr3").attr("src", "/admincenter/img/xsnr3_wev8.png");
		jQuery("#xsnr4").attr("src", "/admincenter/img/xsnr4_wev8.png");
		jQuery("#xsnr5").attr("src", "/admincenter/img/xsnr5_wev8.png");
		
    	clearTimeout(intervalTdTable);//关闭定时器
    	intervalTdTable=null;
    });

	jQuery("#tdTable2").mousemove(function(_evt){ 
		var tdTable1_x = _evt.pageX - jQuery(this).offset().left; 
		var tdTable1_y = _evt.pageY - jQuery(this).offset().top; 
		changeImgSrcTdTable2(tdTable1_x, tdTable1_y);
	}).mouseleave(function(){
		runTdTableAll();
    }).mouseenter(function(_evt){
		jQuery("#jcxxTips").hide();
		jQuery("#jcxx1").attr("src", "/admincenter/img/icon-1-normal_wev8.png");
		jQuery("#jcxx2").attr("src", "/admincenter/img/icon-2-normal_wev8.png");
		jQuery("#jcxx3").attr("src", "/admincenter/img/icon-3-normal_wev8.png");

		jQuery("#xsnrTips").hide();
		jQuery("#xsnr2").attr("src", "/admincenter/img/xsnr2_wev8.png");
		jQuery("#xsnr3").attr("src", "/admincenter/img/xsnr3_wev8.png");
		jQuery("#xsnr4").attr("src", "/admincenter/img/xsnr4_wev8.png");
		jQuery("#xsnr5").attr("src", "/admincenter/img/xsnr5_wev8.png");
		
    	clearTimeout(intervalTdTable);//关闭定时器
    	intervalTdTable=null;
    });

	jQuery("#tdTable3").mousemove(function(_evt){ 
		var tdTable1_x = _evt.pageX - jQuery(this).offset().left; 
		var tdTable1_y = _evt.pageY - jQuery(this).offset().top; 
		changeImgSrcTdTable3(tdTable1_x, tdTable1_y);
		//jQuery("#mX").text(tdTable1_x);
		//jQuery("#mY").text(tdTable1_y);
	}).mouseleave(function(){
		runTdTableAll();
    }).mouseenter(function(_evt){
		jQuery("#jcxxTips").hide();
		jQuery("#jcxx1").attr("src", "/admincenter/img/icon-1-normal_wev8.png");
		jQuery("#jcxx2").attr("src", "/admincenter/img/icon-2-normal_wev8.png");
		jQuery("#jcxx3").attr("src", "/admincenter/img/icon-3-normal_wev8.png");
		
		jQuery("#xszdTips").hide();
		jQuery("#xszd1").attr("src", "/admincenter/img/xszd1_wev8.png");
		jQuery("#xszd2").attr("src", "/admincenter/img/xszd2_wev8.png");
		jQuery("#xszd3").attr("src", "/admincenter/img/xszd3_wev8.png");
		jQuery("#xszd4").attr("src", "/admincenter/img/xszd4_wev8.png");
		
    	clearTimeout(intervalTdTable);//关闭定时器
    	intervalTdTable=null;
    });
});
</script>
	
	<div style="display: none;">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33668,user.getLanguage())+" Q&A"%>' attributes="{'itemAreaDisplay':'display'}">
			<wea:item>
			</wea:item>
	    </wea:group>
	</wea:layout>
	</div>
  </body>
</html>
<!-- for zDialog -->
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css"type="text/css"/>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript"> 
</script> 
