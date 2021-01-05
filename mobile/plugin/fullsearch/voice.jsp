<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.fullsearch.util.ECommonUtil"%>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");
User user = HrmUserVarify.checkUser(request , response);
if(user == null){
	out.println("{\"errorno\":\"0005\",\"error\":\"无效用户信息，请杀进程重新进入\"}");
	return;
}

String userid=user.getUID()+"";
String username=user.getLastname();
FileUpload fu = new FileUpload(request);
String viewmodule = Util.null2String(fu.getParameter("viewmodule"));
String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
String fixedInst = Util.null2String(fu.getParameter("fixedInstId"));//是否指定加载滚屏提示
boolean reload = "1".equals(Util.null2String((String)fu.getParameter("reload")));
boolean isFullE = "1".equals(Util.null2String(fu.getParameter("isFullE")));//是否全屏小e
RecordSet rs=new RecordSet();
//返回时间与提示. 通过异步请求, 会导致手机获取不到参数,改成在头部获取
String sKey="";
String sValue="";
String maskTime="0";//返回等待时间
String maskTips="";//返回提示信息
String fullDebugPeople="";//数据库加载获取全屏小e调试人员, (空值或者没有记录,全部开启全屏小e)
String style="blue";
rs.execute("select sKey,sValue from FullSearch_EAssistantSet where sKey='FullEMaskTime' or sKey='FullEMaskTips' or sKey='FullEDebugPeople' or sKey='EStyle'");
while(rs.next()){
	sKey=rs.getString("sKey");
	sValue=Util.null2String(rs.getString("sValue"));
	if("FullEMaskTime".equalsIgnoreCase(sKey)){
		maskTime=Util.getIntValue(sValue,0)+"";
	}else if("FullEMaskTips".equalsIgnoreCase(sKey)){
		maskTips=sValue;
	}else if("FullEDebugPeople".equalsIgnoreCase(sKey)){
		fullDebugPeople=sValue;
	}else if("EStyle".equalsIgnoreCase(sKey)){
		if(!"".equals(sValue)){
			style=sValue;
		}
	}   
}

if(isFullE){//开启全屏. 未指定全部开启
	isFullE=ECommonUtil.isDebugPeople(fullDebugPeople,user);
}


//自选样式
String topColor="";
if("blue".equals(style)){
	topColor="#053E73";
}else if("red".equals(style)){
	topColor="#711f1a";
}else{//其他样式,没有找到,默认蓝色
	if(!"".equals(style)){
		style="blue";
		topColor="#053E73";
	}
}
if(!"".equals(style)){
	style+="/";
}

//获取版本信息.用于更新js和css资源..
String version="v1.0.58";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,height=device-height, initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="format-detection" content="telephone=no">

<title>小e助手</title>
<link rel="stylesheet" href="/mobile/plugin/fullsearch/permanent/css/jquery.mobile-1.1.1.min_wev8.css" />
<link rel="stylesheet" href="/mobile/plugin/fullsearch/permanent/css/animate.min.css" />
<link rel="stylesheet" href="/mobile/plugin/fullsearch/permanent/css/toast_wev8.css" />
<link rel="stylesheet" href="/mobile/plugin/fullsearch/css/<%=style %>voice_wev8.css?v=<%=version %>" />
</head>
	<body style="background-color:<%=topColor %> ">
		<div data-role="page" id="main">
			<!-- 消息展示DIV -->
		    <div id="msgContentDiv" class="contentDiv" data-role="content" class="ui-content" role="main" style="text-align: center;display:none;overflow-y: auto;" >
				<div id="msgContentChild">
				</div>
			</div>
			
			<div id="help" class="contentDiv" data-role="content" class="ui-content" role="main" style="text-align: center;display:none" >
				<div id="helpTip" class="helpTip">您可以这样问我</div>
				<div id="helpContent" style=" overflow-y: auto;"></div>
			</div>
			
			<div id="helpDetail" class="contentDiv" data-role="content" class="ui-content" role="main" style="text-align: center;display:none;" >
				<div id="detailTip"></div>
			</div>
			
			<div id="scrollHelpContent" class="contentDiv" data-role="content" class="ui-content" role="main" style="text-align: center;display:none;" >
				<div id="scrollHelpTip" class="helpTip scrollTip">您可以这样问我</div>
				<div id="scrollHelpDetail" class="scroll" >
					<ul id="scrollHelpDetail_ul">	
					</ul>
				</div>
			</div>	
			
		    <div id="contentDiv" class="contentDiv" data-role="content" class="ui-content" role="main" style="text-align: center;overflow-y:auto;overflow-x:hidden " >
		    	<div id="hideLocation" style="display:none"></div>
			    <div style="display:none" id="startTarget">
					<div class="ask askCurrent"></div>
			       	<div  class='anser anserCurrent'></div>
			       	<div class='split splitCurrent'></div>
			    </div>
		    </div>
		    
		    <!-- 消息窗口隐藏加载自定义头像 -->
		    <div id="customMsgImg" style="display:none"></div>
		    
		    <!-- 麦克风输入 -->
			<div id="voiceInputDiv" class="voicefooter" style="height: 80px;">
				<div id="debugInfo"></div>
			    <!-- 声波 -->
			    <div id="WaveContainer" class="WaveContainer"></div>
			    <!-- 键盘切换 -->
				<div class="keyboardChangeDiv" onclick="changeInputType()" style="display:none;"></div>
				
				<div id="intoFaqDiv" class="intoFaqDiv" onclick="intoFAQ()" style="left: 20px;display:none;"></div>
				<!-- mic输入 -->
				<div style="width:70px;margin: auto;">
					<div class="microphone minMic"></div>
				</div>
				<div class="help" onclick="help()" ></div>
				
				<!-- faq Tip提示 -->
				<div id="faqDivTip" style="display: none" >
					<div class="faqDivBg" style="left: 15px;bottom: 60px;">当前结果不满意?<br>请点击这里</div> 
					<div class="faqTriangleDown" style="left: 27px;bottom: 50px;"></div>
				</div>
				
				<!-- 其它操作,默认客服提交 -->
				<div id="otherOperateDiv1" class="otherOperateDiv" style="display:none;">
						<div class="upArrowDiv"></div>
						<div id="intoFaqDiv1" class="intoFaqDiv" style="display:none;"></div> 
				</div>
				
				<!-- 更多其他操作div -->	
				<div id="moreOtherOperateDiv" class="moreOtherOperateDiv">
					<div class="moreOtherOperateChildDiv" style="height: 90px;">
						<div class="moreHelpBtn"></div>
						<div class="moreFaqBtn"></div>
					</div>
				</div>
			</div>
			
			<!-- 文本输入 -->
			<div id="textInputDiv" class="voicefooter" style="height: 80px;display:none;">
				<div class="textInputDivChild">
					<div class="textVoiceChangeDiv" onclick="changeInputType()"></div>
					<div id="textSendInput" class="textSendInput">
						<div class="textSendInputDiv" contenteditable="true"></div>
						<div class="textSendInputBtn"></div>
					</div>
				</div>
				
			</div>
			
		</div>
		<div id="toastDiv"></div>	
    </body>
</html>   

<script	type="text/javascript" src="/mobile/plugin/fullsearch/permanent/js/jquery-1.7.1.min_wev8.js"></script>
<script	type="text/javascript" src="/mobile/plugin/fullsearch/permanent/js/jquery.mobile-1.1.1.min_wev8.js"></script>
<script type="text/javascript" src="/mobile/plugin/fullsearch/permanent/js/siriwave_wev8.js"></script>
<script type="text/javascript" src="/mobile/plugin/fullsearch/permanent/js/jquery.scrollTo.js"></script>
<script type="text/javascript" src="/mobile/plugin/fullsearch/permanent/js/script_wev8.js"></script>

<script type="text/javascript" src="/mobile/plugin/fullsearch/js/action_wev8.js?v=<%=version %>"></script>

     <script type="text/javascript">
	//整体抓取异常. 防止初始化报错. 
	try{
	
    //window.localStorage.clear();
	var storage = window.localStorage;
	var userid="<%=userid%>";
	var username="<%=username%>";
	var pageStyle="<%=style%>";
	var clientType="<%=clienttype%>";
	
	var hasCS=false;
	var es_version="ES1.0";
	var goPageObj={};
	var degbugPeople="";
	var recordInstruction=false;
	var noauth="WKP,COW,EMAIL,PRJ,CPT";
	var viewmodule="<%=viewmodule%>";
	var isFullE="true"=="<%=isFullE%>";//是否全屏小e
	var isShowFAQTips=true;
	var maskTime="<%=maskTime%>";//返回等待时间
	var maskTips="<%=maskTips%>";//返回提示信息
	
	var es_version1="ES1.0";
	var es_version2="ES2.0";
	var hasVoiceMonitor=false;
	var immediatelyWKP=true;//立即到日程新建页面(默认有时间).
	var siriWave;
	var pageTime=new Date().getTime(); 
	var today=new Date();
    var week = {"0" : "周日","1" : "周一","2" : "周二","3" : "周三", "4" : "周四","5" : "周五","6" : "周六"};
			   
	var isrun=false;
	var isHelp=false;
	var isScrollHelp=true;
	var footerH=$('.voicefooter').height();//底部高度
    var wH=$(window).height();//窗体高度
    var wW=$(window).width();
    var now=new Date();
	var nowDateStr=now.getFullYear()+"-"+((now.getMonth()+1)>9?"":"0")+(now.getMonth()+1)+"-"+(now.getDate()>9?"":"0")+now.getDate();
    var yesterday=DateAdd('d',-1,today);
    var yesterdayStr=yesterday.getFullYear()+"-"+((yesterday.getMonth()+1)>9?"":"0")+(yesterday.getMonth()+1)+"-"+(yesterday.getDate()>9?"":"0")+yesterday.getDate();
    var tomorrow=DateAdd('d',1,today);
    var tomorrowStr=tomorrow.getFullYear()+"-"+((tomorrow.getMonth()+1)>9?"":"0")+(tomorrow.getMonth()+1)+"-"+(tomorrow.getDate()>9?"":"0")+tomorrow.getDate();
    var lastmonth=DateAdd("m",-1,today);
	var noScroll=true;//对话确认框时,进行输入框时是否允许滚动
    var rscTag="RSC:2";
    var rscTag4="RSC:4";//姓名+标签+全文
    
    //考勤用-start
    var fixPostionTimeTag="";//当前定位的交互时间.
    var currentSigntype="";//签到类型
    //考勤用-end
    
    var currentTimeTag="";//记录当前时间戳.
    //是否显示FAQ 闪动效果提示
    var needShowFaqHelp=true;
    var showFaqTimeTlag="";//控制每天一次
    
    var retResultStr=['这个问题，小e也不知道答案呢','这个问题好难，我还需要努力学习','俗话说“三人行，必有我师”，这个问题，我要请教老师去'];
	//网盘分享调用
	var fileMap={};
	
	var retResultStrNoData=['等我学习一下再来回答你哦，你可以继续问其他问题。','我要学习一下再来回答你哦，你先问其他问题吧。','这个问题，我需要学习一下再回来告诉你哦~你先问其他的吧。','这个我要想一想再告诉你，你先问其他问题吧。','容我先想想再告诉你答案，你先问其他问题吧。','这个问题等我想好了再告诉你哦~你先问其他的吧。','恭喜你成功问倒我了，待我充个电再来回答你，先问其他问题吧。']; 
	var lastDealTimeTag="";
	
    if(window.screen.availHeight<wH){
    	wH=window.screen.availHeight;
    }
	 	
    var addWf_width=wW-30;
    var ul_li_div_width=wW-5-65;
    var voice_text_input_width=wW-130-4;
    
    //消息相关变量
    //是否有新消息
    var needLoadNewMsg=false;
    var firstLoadMsg=true;//首次加载
    var readTimeInterval=1;//消息读取间隔
    var loadMsgInterval;//消息定时读取
    var msgCurrentPage=1;//当前加载页
    var msgPageSize=30;//每页30条数据.
	var isEnd=false;
	var isLoading=false;
	var msgSessionId="";//已存在的会话ID.防止重复
	var newMsgSessindId=",";//本次新增加的会话ID
	var msgDivHeight=wH-footerH;
	var onlyFirstPage=true;//超出第一屏
	var isMsgDiv=false;//是否显示消息Div.
	var tapLock=false;//tap点击锁
	var lastLoadMsgTime;//上一次加载消息的时间
	var currentPageTime;//当前页面时间
	//消息相关变量
	
	//文字输入,多个操作相关变量start
	var showInputType=1;//交互输入方式.1语音 2文本
	var isShowMoreOpDiv=0;//展示更多操作图标0 不展示 1展示
	//文字输入,多个操作相关变量end
	
	var siriWaveInterval;
	//改变麦克风的效果
	function voice(state,release){
		if(state==1){
			try{
				if(siriWave){
					siriWave.start();
					if(!hasVoiceMonitor){
						siriWaveInterval=setInterval(function(){
							if(!hasVoiceMonitor){
								var v=Math.random();
								if(v==0){
									v=0.1;
								}
								siriWave.setAmplitude(v);
							}
						},500);
					}
				}
			}catch(e){}
		
			isrun=true;
			//延迟100毫秒出现波纹,防止第一个字录音不全
			//setTimeout(function(){
				$('.microphone').addClass("microphonepressed");
				$('.WaveContainer').css("bottom","80px");
				$('.wave').show();
			//},100);
		}else{
			isrun=false;
			$('.wave').hide();
			$('.WaveContainer').css("bottom","-200px");
			$('.microphone').removeClass("microphonepressed");
			try{
				if(siriWave){
					siriWave.stop();
				}
			}catch(e){}
			if(siriWaveInterval){
	    		try{
	    			clearInterval(siriWaveInterval);
	    		}catch(e){}
	    	}
		}
	}
	
	//点击录音或停止	
	function record() {
		var tapStartTime=0;
     	var tapEndTime=0;
		$(".microphone").off("touchstart touchend");
		var presstimeout = undefined;
		$(".microphone").on("touchstart",function(){
			tapStartTime=new Date().getTime();
			if(!isrun){
			 	presstimeout = setTimeout(function(){
						location = "emobile:speechUnderstand:voiceBackUnderstand:voiceBackErr"; 
					voice(1);
			 	}, 250);
			}
		}).on("touchend",function(){
			clearTimeout(presstimeout);
			tapEndTime=new Date().getTime();
			if(tapEndTime-tapStartTime<200){//结束小于200,认为是单次点击
				if(!isrun){
	     			location = "emobile:speechUnderstand:voiceBackUnderstand:voiceBackErr:1600"; 
					isrun=true;
					voice(1);
		     	}else{
			     	stopVoice();
			     	changePage();
			     	voice(0);
			     	isrun=false;
		     	}
			}else{
	     		if(isrun){
		     		stopVoice();
		     		changePage();
	     		}
	     		voice(0);
			}
     	});
	}
	
	//停止语音
	function stopVoice(){
		setTimeout(function(){
			location="emobile:stopVoice";
		},200);
	}
	
     	
	//播放语音
	function play(sayWhat){
		hideToast();
		if(sayWhat!=""){
			sayWhat=sayWhat.replaceAll("</?[^>]+>", "");
			if(sayWhat.length<50){
				var url ="emobile:palyVoice:"+sayWhat;
				location = url; 
			}
		}
	}
	
	//播放语音
	function playAll(sayWhat){
		hideToast();
		if(sayWhat!=""){
			sayWhat=sayWhat.replaceAll("</?[^>]+>", "");
			var url ="emobile:palyVoice:"+sayWhat;
			location = url; 
		}
	}
	
	//注册文本输入框焦点事件
	function registInput(){
		//输入框增加焦点事件
		$('.textSendInputDiv').unbind("focus").unbind("blur");
		$('.textSendInputDiv').focus(function(){
			noScroll=false;
			$('#contentDiv').css("margin-bottom",(footerH+20));
			$('#textInputDiv').css("position","absolute");
			
			var edit=this;
			window.setTimeout(function () {
	            var sel, range;
	            if (window.getSelection && document.createRange) {
	              range = document.createRange();
	              range.selectNodeContents(edit);
	              range.collapse(true);
	              range.setEnd(edit, edit.childNodes.length);
	              range.setStart(edit, edit.childNodes.length);
	              sel = window.getSelection();
	              sel.removeAllRanges();
	              sel.addRange(range);
	            } else if (document.body.createTextRange) {
	              range = document.body.createTextRange();
	              range.moveToElementText(edit);
	              range.collapse(true);
	              range.select();
	            }
	        }, 10);
	        
	        var cnt = 0;
	        var timerId=setInterval(function(){
				if (cnt < 5) {
			      cnt++;
			    } else {
			      clearInterval(timerId);
			      timerId = null;
			      return;
			    }
			    edit.scrollIntoView(true);
			},100);
			
		}).blur(function(){
			$('#contentDiv').css("margin-bottom",(wH-footerH+20));
			if(!noScroll && $('#contentDiv').css("display")=='block'){
				$.scrollTo('.askCurrent');
			}
			$('#textInputDiv').css("position","");
			noScroll=true;
			
		}).bind('keypress', function (event) { 
			//监听回车 13
			if(event.keyCode==13){
				//sendVoiceText();
			}
		});
		
		//改变外部高度<60|80>.
		$('.textSendInputDiv').keyup(function() {
			if($(this).height()>25){
				$('.textInputDivChild').css("height","80px");
			}else{
				$('.textInputDivChild').css("height","60px");
			}
		});
		
		//滑动失去输入框焦点.隐藏键盘
		$("#main").on("touchmove",function(){
			if(showInputType==2){//有键盘输入的时候
				var className=$(event.target).attr("class");
				if(className=="textInputDivChild"||className=="textVoiceChangeDiv"||className=="textSendInput"||className=="textSendInputDiv"||className=="textSendInputBtn"){
				
				}else{
					$('.textSendInputDiv').blur();
				}
			}
		});
		
		//发送文字内容 
		$('.textSendInputBtn').on("tap",function(){
			sendVoiceText();
			return false;
		});
		
		
		//键盘图标 点击与上划事件处理
		var startY;
		var moveEndY;
		var tapStartTime=0;
     	var tapEndTime=0;
		var presstimeout = undefined;
		$(".otherOperateDiv").off("touchstart touchend");
		$(".otherOperateDiv").on("touchstart",function(e){
		    startY = e.originalEvent.targetTouches[0].pageY;
			tapStartTime=new Date().getTime();
		 	presstimeout = setTimeout(function(){
				showMoreOpDiv();
		 	}, 250);
		}).on("touchend",function(e){
			clearTimeout(presstimeout);
		    moveEndY = e.originalEvent.changedTouches[0].pageY,
		    Y = moveEndY - startY;
		    if( Y < 0 ) {//上滑
		        showMoreOpDiv();    
		    }else{//其他划动都认为点击
			    tapEndTime=new Date().getTime();
				if(tapEndTime-tapStartTime<220){//结束小于200,认为是单次点击
					 intoFAQ();
				}
		    }
		    return false;
     	});
     	
		//对更多操作页面点击后, 隐藏操作div
		$("#moreOtherOperateDiv").on("tap",function(){
			var className=$(event.target).attr("class");
			if(className=='moreFaqBtn'){
				intoFAQ();
			}else if(className=='moreHelpBtn'){
				help();
			}
			hideMoreOpDiv();
			return false;
		})
	}
	
	//语音输入和文字输入切换
	function changeInputType(){
		if(showInputType==1){
			showInputType=2;
			stopVoice();
			voice(0);
			$('#voiceInputDiv').hide();
			$('#textInputDiv').show();
		}else if(showInputType==2){
			showInputType=1;
			$('#textInputDiv').hide();
			$('#voiceInputDiv').show();
		}
	}
	
	//展示多个操作功能图标div
	function showMoreOpDiv(){
		isShowMoreOpDiv=1;
		$('#moreOtherOperateDiv').show();//slideDown();
	}
	//隐藏多个操作功能图标div
	function hideMoreOpDiv(){
		isShowMoreOpDiv=0;
		$('#moreOtherOperateDiv').hide();//slideUp();
	}
	
	//发送语音文字内容
	function sendVoiceText(){
		var newText=$('.textSendInputDiv').html().replaceAll("</?[^>]+>", "");
		$('.textSendInputDiv').blur();
		$('.textSendInputDiv').html("");
		$('.textInputDivChild').css("height","60px");
		if(newText!=""){
			location = "emobile:textUnderStand:sendTextBackUnderstand:textBackErr::"+newText; 
		}
	}
	
	
	
	//语音识别异常回调
	function voiceBackErr(data){
		changePage();
		voice(0);
		var obj = eval("("+data+")");
		if(obj.errorCode==10118){
			play(obj.description);
			var timestamp = new Date().getTime();
			$('#contentDiv').append("<div id='anser"+timestamp+"' ts='"+timestamp+"' class='anser' style='padding:5px'>"+obj.description+"</div>");
			$('#contentDiv').append("<div class='split '></div>");
			$.scrollTo('#anser'+timestamp,500); 
		}
	}
	
	function textBackErr(str,ts){
		//文字识别错误,忽略
	}
	
	//输入内容回调
	function sendTextBackUnderstand(str,ts){
		changePage();
    	//时间戳
    	var timestamp = new Date().getTime();
		checkNeesForecast(str,timestamp,true);
	}
	
	
	//语音识别回调
    function voiceBackUnderstand(str){
    	changePage();
    	//时间戳
    	var timestamp = new Date().getTime();
		checkNeesForecast(str,timestamp,true);
    }
   	
   	/*
	*文本语义识别回调
	*/
	function textBackUnderstand(str,ts){
		checkNeesForecast(str,ts,false);
	} 
	
	/**
	* 检查是否需要意图预测
	*/
	function checkNeesForecast(str,timestamp,needTrim){
		voice(0);//上时间不说话后台自动停止.
		//每次响应需要检测时间,防止小e长时间停留,跨天
		try{
			refreshTime();
		}catch(e){}
		var isDebugPeople=degbugPeople.indexOf(","+userid+",")>-1;
		//切换到主页面
    	hideHelp();
    	ToastLoading("加载中...");
    	
    	//解析json
    	var obj = eval("("+str+")");
		if(obj.text=="*#999#*"){//查看错误指令
			obj.service="FW_CMD";
			obj.rc="0";
			var slots={};
			slots.type="ShowErrInfo";
			var semantic={};
			semantic.slots=slots;
			obj.semantic=semantic;
			backUnderstand(JSON.stringify(obj),timestamp,needTrim);
		}else{
	    	if(obj.rc=="0" && (obj.service=="FW_COMMON"||obj.service=="continue"||obj.service=="NativeAction"||obj.service=="chooseRsc"||obj.service=="chooseCrm"||obj.service=="SelectFeeType"||obj.service=="SelectAddress")){
	    		if(isDebugPeople){
	    			alert(str); 
	    		}
	    		backUnderstand(str,timestamp,needTrim);
	    	}else{
		    	$.ajax({
		            url: "/mobile/plugin/fullsearch/ForecastAjax.jsp?type=forecast&random="+Math.random(),
		            type: "POST",
		            dataType : 'json',  
		            data: {"iFly_json":str},
		            success: function (data) {
	            		try{
	            			var dataStr=JSON.stringify(data);
	            			delete data.resultData;//删除比较值
	            			var changeDataStr=JSON.stringify(data);
	            			if(data.text){
	            				if(isDebugPeople){
	            					if(str!=changeDataStr){
								    	alert(str+"\n转化后\n"+dataStr); 
	            					}else{
	            						alert(dataStr); 
	            					}
								}
		            			backUnderstand(dataStr,timestamp,needTrim);
	            			}else{
	            				if(isDebugPeople){
							    	alert(str); 
								}
	            				backUnderstand(str,timestamp,needTrim);
	            			}
	            		}catch(e){
	            			if(isDebugPeople){
						    	alert(str); 
							}
	            			backUnderstand(str,timestamp,needTrim);
	            		}
		            },
		            error:function(data){
		            	if(isDebugPeople){
					    	alert(str); 
						}
		            	backUnderstand(str,timestamp,needTrim);
		            }
		        });
	    	}
    	}
	}
	
	
	/**
	* 对返回结果进行处理
	*/
	function backUnderstand(str,timestamp,needTrim){
    	//解析json
    	var obj = eval("("+str+")");
    	//进入后直接查询返回的值
    	var resultData;
    	if(obj.resultData){
    		resultData=obj.resultData;
    		delete obj.resultData;
    	}
    	//开启记录日志,且返回指令,用于统计常用指令模块
    	if(recordInstruction){
    		var logObj={};
			$.extend(logObj,obj);
			var ignoreLog=false;
			if(obj.rc==0){
	    		if(logObj.service=="weather"){
	    			delete logObj.data;
	    			delete logObj.webPage;
	    		}else if(logObj.service=="FW_CMD_ES"||logObj.service=="FW_CMD"){
	    			if(obj.semantic.slots.type&&!logObj.operation){
	    				logObj.operation=obj.semantic.slots.type;
	    			}
	    		}else if(logObj.service=="FW_REPORT"){
	    			if(obj.semantic.slots.reportType){
	    				logObj.operation=obj.semantic.slots.reportType;
	    			}
	    		}else if(logObj.service=="FW_COMMON"){
	    			if(obj.semantic.slots.instruct){
	    				logObj.operation=obj.semantic.slots.instruct;
	    			}
	    		}else if(obj.service=="continue"||obj.service=="NativeAction"||obj.service=="chooseRsc"||obj.service=="chooseCrm"||obj.service=="SelectFeeType"||obj.service=="SelectAddress"){
	    			ignoreLog=true;
	    		}
			}else{
				logObj.service="NO_SERVICE";
				logObj.operation="NO";
			}
    		if(!ignoreLog){
	    		logObj.type="mobileVoice";
				logObj.timestamp=new Date().getTime();
				logObj.userid=userid;
	    		var logArray=[];
	    		logArray.push(logObj);
	    		$.ajax({
		            url: "/mobile/plugin/fullsearch/ajaxVoice.jsp?type=saveTrackInfo&random="+Math.random(),
		            type: "POST",
		            dataType : 'json',  
		            data: {"trackJson":JSON.stringify(logArray)},
		            success: function (data) {}
		        });
    		}
    	}
    	var searchKey="";
    	var needES=false;//是否需要微搜
    	var schema="ALL";//搜索模块
		var afterLoad=false;//后续加载简单操作
		var isQA=false;//加载智能问答
		var moreInstruct=false;//进一步指令 
		var InstructObj={};
		var pageSemantic={};
		var currentInstruct=false;
		var cancel=false;
		var showUrl=false;
		var afterDoFunction=false;
		var doFunction;
		var afterDoFunctionStandard=false;
		var deepFunction;
		var nativeAction=false;
		var nativeJson={};
		var CanEdit=true;
		var isWeather=false;
		
		var needHideToast=true;
		
		//页面传递参数
		var msg="";
		var othermsg="";//不需要读取
		
		var otherJson={};//微搜指定特殊字段筛选
		
		var jsonDate={};//用于load_SP_Data 传递参数
		var baseJson={};//触发某个交互指令时,初始化参数
		
		var isShowReport=false;//展示报表
		
	    //获取是否有标准进一步查询,如果有进一步查询.... 忽略本次解析
	    var lastKey="";
	    var lastOtherJson={};
	    var lastSchema="";
	    var moreSearch=false;
	    if($('.currentAskTip')&&$('.currentAskTip').length>0){
	    	lastKey=$('.currentAskTip').attr("lastKey");
	    	lastSchema=$('.currentAskTip').attr("lastSchema");
	    	lastOtherJson=JSON.parse($('.currentAskTip').attr("lastOtherJson"));
	    }
	    //是否进一步指令
	    if($('.currentInstructTip')&&$('.currentInstructTip').length>0){
	    	//当前指令.识别的是时间,退出,取消之类,进行继续操作.不退出指令
	    	if(obj.rc=="0" && (obj.service=="FW_COMMON"||obj.service=="continue")){
	    		//继续指令操作.
	    		currentInstruct=true;
		    	InstructObj=JSON.parse($('.currentInstructTip').attr("obj"));
		    	if($('.currentInstructTip').attr("baseJson")){
			    	baseJson=JSON.parse($('.currentInstructTip').attr("baseJson"));
		    	}
	    	}else{
		    	//判断当前交互指令和当时交互时间. 相差60s以上,自动移除上一次交互指令
		    	var lastTs=$('.currentInstructTip').attr("target");
		    	if(timestamp-lastTs<=60*1000){
			    	currentInstruct=true;
			    	InstructObj=JSON.parse($('.currentInstructTip').attr("obj"));
			    	if($('.currentInstructTip').attr("baseJson")){
				    	baseJson=JSON.parse($('.currentInstructTip').attr("baseJson"));
			    	}
		    	}
	    	}
	    }
	    //左右去除空格
	    if(needTrim&&obj.text){
	    	obj.text=obj.text.ltrim().rtrim();
	    }
	    
	    //获取页面识别的语义
	    if($('#ask'+timestamp)&&$('#ask'+timestamp).length>0){
	    	var keyDiv=$('#ask'+timestamp).find(".keyDiv");
	    	if($(keyDiv).attr("semantic")){
	    		pageSemantic=JSON.parse($(keyDiv).attr("semantic"));
	    		$.extend(InstructObj,pageSemantic);
	    	}
	    }
	    
	    //判断当前是否有确认框
	    if($('.confirm_div')&&$('.confirm_div').length>0){
	    	if(obj.rc=="0"&&obj.service!="continue"){//继续指令标识
		    	if(obj.rc=="0" && obj.service=="FW_COMMON" && obj.semantic && obj.semantic.slots && obj.semantic.slots.type && obj.semantic.slots.type=="instruct" ){
	 					if(obj.semantic.slots.instruct && obj.semantic.slots.instruct=="cancel"){
	 						$($(".confirm_div").find(".cancelBtn")[0]).trigger("tap");
	 						return;
	 					}else if(obj.semantic.slots.instruct && obj.semantic.slots.instruct=="ok"){
	 						 $($(".confirm_div").find(".OkBtn")[0]).trigger("tap");
	 						return;
	 					}else{
	 						//移除确认框
							clearConfirm();
	 					}
	 			}else{
	 				//判断当前是否是微博填报
	 				if($('.blog_confirm_div')&&$('.blog_confirm_div').length>0){
	 					var content=$('.blog_confirm_div').find(".blog_title_str").html();
	 					content+="</br>"+obj.text;
	 					$('.blog_confirm_div').find(".blog_title_str").html(content);
	 					$('.blog_confirm_div').find(".blog_title_str")[0].scrollTop=$('.blog_confirm_div').find(".blog_title_str")[0].scrollHeight;
	 					hideToast();
	 					return;
	 				}else if($('.crmContact_confirm_div')&&$('.crmContact_confirm_div').length>0){
	 					var content=$('.crmContact_confirm_div').find(".crmContact_title_str").html();
	 					content+="</br>"+obj.text;
	 					$('.crmContact_confirm_div').find(".crmContact_title_str").html(content);
	 					$('.crmContact_confirm_div').find(".crmContact_title_str")[0].scrollTop=$('.crmContact_confirm_div').find(".crmContact_title_str")[0].scrollHeight;
	 					hideToast();
	 					return;
	 				}else{
		 				//移除确认框
						clearConfirm();
	 				}
	 			}
	    	}else{
	    		//移除确认框
				clearConfirm();
	    	}
	    }
	    //输入内容不允许编辑
	    if(obj.CannotEdit){
  			CanEdit=false;
 		}
	    if(lastKey!=""||Object.keys(lastOtherJson).length>0){//进一步查询
	    	needES=true;
	    	moreSearch=true;
	    	//继承上一次的查询类型
	    	if(lastSchema!=""&&lastSchema!="ALL"){
	    		schema=lastSchema;
	    	}else{
		    	if(obj.rc=="0"){
		    		if(obj.service=="FW_CMD_ES"){
			    		if(lastSchema==""||lastSchema=="ALL"){
		  					schema=obj.semantic.slots.type;
		  				}
		    		}
		    	}
	    	}
	    	
 		}else if(currentInstruct){//进一步指令操作.
 			if(obj.rc=="0" && obj.service=="FW_COMMON" && obj.semantic && obj.semantic.slots && obj.semantic.slots.type && obj.semantic.slots.type=="instruct" && obj.semantic.slots.instruct && obj.semantic.slots.instruct=="cancel"){
 					moreInstruct=true;
 					cancel=true;
 					msg="已退出";
 			}else{
	 			if(InstructObj.type=="WKP"){//日程进一步
	 				if(!InstructObj.time){//获取时间
		 				if(obj.rc=="0" && obj.semantic && obj.semantic.slots && obj.semantic.slots.instruct && (obj.semantic.slots.instruct=="WKP"||obj.semantic.slots.instruct=="datetime") ){
	 							var content="";
			    				if(obj.semantic.slots.content){
			    					content=obj.semantic.slots.content;
			    				}
			    				var date="";
			    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
			    					date=obj.semantic.slots.datetime.date;
			    				}
			    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date&&obj.semantic.slots.datetime.date_orig){
			    					if(date!=""){
			    						date=getDateByOrig(obj.semantic.slots.datetime.date_orig,date);
			    					}
		    					}
			    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date_orig){
			    					InstructObj.date_orig=true;
			    				}
			    				var time="";
			    				var needEndTime=true;
			    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.time){
			    					time=obj.semantic.slots.datetime.time;
			    					needEndTime=false;
			    				}
			    				var timeEnd="";
			    				if(obj.semantic.slots.timeEnd&&needEndTime){
			    					timeEnd=obj.semantic.slots.timeEnd.replaceAll(":","-");
			    				}
			    				//确认的时间.不需要转换
			    				if(obj.semantic.slots.cft&&obj.semantic.slots.cft=="confirmTime"){
			    					InstructObj.cft=true;
			    				}
		      					//时间本身解析成功
			    				if(time==""){
			    					if(obj.semantic.slots.time){
			    						time=obj.semantic.slots.time;
			    					}
			    				}else{
			    					var addTime=0;
			      					if(obj.semantic.slots.addTime){
			      						addTime=obj.semantic.slots.addTime;
			      					}
			      					var times=time.split(":");
			      					var newHours=parseInt(times[0])+parseInt(addTime);
			      					if(newHours<24){
			      						time=(newHours>9?newHours:"0"+newHours)+":"+times[1]+":"+times[2];
			      					}
			    				}
		    					time=time.replaceAll(":","-");
		    					InstructObj=timeAnalysis(obj,InstructObj);
		    					
		    					if(date!=""){
		      						InstructObj.date=date;
		      					}
		      					if(time!=""){
		      						InstructObj.time=time;
		      					}
		      					if(timeEnd!=""){
		      						InstructObj.timeEnd=timeEnd;
		      					}
		      					if(content!=""){
		      						InstructObj.content=content;
		      					}
		      					InstructObj=validateDate(InstructObj);
	 					}
	 				}else{//有时间,其他都是内容.
	 					InstructObj.content=obj.text;
	 				}
					if(!InstructObj.time){
						moreInstruct=true;
						msg='我不太明白您的意思，请告知下这个事件的日期和时间，比如明天下午3点。如需取消创建日程，请说“退出”';
					}else if(!InstructObj.content){
						moreInstruct=true;
						msg='好的，将为您创建日程，请告诉我日程主题，比如“开会”。';
						if(InstructObj.name){
							msg='好的，将为'+InstructObj.name+'创建日程，请告诉我日程主题，比如“开会”。';
						}
						
					}else{//指令完全识别成功.进入新建操作
						moreInstruct=true;
						InstructObj.action="ok";
					}
	 			}else if(InstructObj.type=="CALL"){
	 				moreInstruct=true;
	 				InstructObj.action="ok";
	 			}else if(InstructObj.type=="WF"){
	 				if(InstructObj.wftype=="Leave"){//请假
	 					if(!InstructObj.leaveType){//请假类别
	 						var leaveType=obj.text.replaceAll("请","");
	 						if(leaveType!="假"){//请假类型
								var leaveTypeId=baseJson.LeaveTypeMap[leaveType]
								if(baseJson.LeaveTypeMap[leaveType] != undefined){
									InstructObj.leaveType=leaveTypeId;
									InstructObj.leaveTypeName=leaveType;
								}
							}
							var days=0;
							if(InstructObj.days){
								days=InstructObj.days;
							}
							if(InstructObj.leaveType){
								if(baseJson.checkLeaveType.indexOf(","+InstructObj.leaveType+",")>-1){//需要检查的请假类型
									var leaveObj=baseJson["levave_"+InstructObj.leaveType];
									if(parseFloat(leaveObj.real)>0){
										if(days>parseFloat(leaveObj.real)){
											moreInstruct=true;
											msg='对不起，'+InstructObj.leaveTypeName+'剩余'+leaveObj.show+'天，请选择其他请假类型.比如“事假”。如需取消，请说“退出”';
										}
									}else{
										moreInstruct=true;
										msg='对不起，您没有可用'+InstructObj.leaveTypeName+'，请选择其他请假类型.比如“事假”。如需取消，请说“退出”';
									}
								}
								//假別 识别失败
								if(moreInstruct){
									delete InstructObj.leaveType;
								}
							}else{
								moreInstruct=true;
								msg='我不太明白您的意思，您需要请什么类型的假？比如“事假”。如需取消，请说“退出”';
								//othermsg=baseJson.allLeaveTypeName;
							}
	 					}else if(!InstructObj.begintime){
	 						if(obj.rc=="0" && obj.semantic && obj.semantic.slots){
	 							InstructObj=timeAnalysis(obj,InstructObj);
 								if(!InstructObj.begintime){
 									moreInstruct=true;
									msg='我不太明白您的意思，请告诉我请假的开始日期和时间。比如明天上午9点。如需取消，请说“退出”';
 								}
	 						}else{
	 							moreInstruct=true;
								msg='我不太明白您的意思，请告诉我请假的开始日期和时间。比如明天上午9点。如需取消，请说“退出”';
	 						}
	 					
	 					}else if(!InstructObj.endtime){
	 						if(obj.rc=="0" && obj.semantic && obj.semantic.slots){
		 						var dateTimes=simpleTimeAnalysis(obj)
 								var date=dateTimes[0];
		    					var time=dateTimes[1];
								//写入结束时间.
								if(time!=""){
									InstructObj.enddate=date
									InstructObj.endtime=time;
								}else{
									moreInstruct=true;
									msg='我不太明白您的意思，请告诉我请假的结束日期和时间。比如明天下午6点。如需取消，请说“退出”';
								}
							}else{
	 							moreInstruct=true;
								msg='我不太明白您的意思，请告诉我请假的结束日期和时间。比如明天下午6点。如需取消，请说“退出”';
	 						}
	 					}else{
	 						if(!InstructObj.content){
		 						InstructObj.content=obj.text;
	 						}
	 					}
						
						if(InstructObj.needComfirmTime){
     						//初始2个时间都识别. 进入时间确认界面.
     						afterDoFunction=true;
							doFunction=confirmTime;
							moreInstruct=true;
							afterDoFunctionStandard=true;
							if(!InstructObj.content){
								InstructObj.nextTip='好的，请告诉我请假事由。';
							}else{
								InstructObj.continueAction=true;
							}
    					}
						
	 					//对应指令识别不正确
	 					if(!moreInstruct){
	 						if(!InstructObj.leaveType){
		 						moreInstruct=true;
								msg='我不太明白您的意思，您需要请什么类型的假？比如“事假”。如需取消，请说“退出”';
								//othermsg=baseJson.allLeaveTypeName;
		 					}else if(!InstructObj.begintime){
								moreInstruct=true;
								msg='好的，请告诉我请假的开始日期和时间。比如明天上午9点。';
		 					}else if(!InstructObj.endtime){
								moreInstruct=true;
								msg='好的，请告诉我请假的结束日期和时间。比如明天下午6点。';
		 					}
	 						
	 						if(!moreInstruct){
	 							//检验时间有效性
			 					if(InstructObj.begintime&&InstructObj.endtime){
			 						if(TimeCompare(InstructObj.begindate,InstructObj.begintime,InstructObj.enddate,InstructObj.endtime)){//时间合法
			 							if(!InstructObj.days){
				 							//计算请假天数与类别比较
				 							jQuery.ajax({
												async: false, 
												type : "POST", 
												url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
										   		data:{"type":"getLeaveDays","fromDate":InstructObj.begindate,"fromTime":InstructObj.begintime,"toDate":InstructObj.enddate,"toTime":InstructObj.endtime,"resourceId":userid},
												dataType : 'json', 
												success : function(data) {
						 							if(data.result){
						 								InstructObj.days=data.result;
						 							}else{
						 								InstructObj.days=0;
						 							}
												}
											});
			 							}
			 						}else{
			 							moreInstruct=true;
										msg='结束日期不合法，请重新告诉我请假的结束日期和时间。比如明天下午6点。如需取消，请说“退出”';
										othermsg="&nbsp;&nbsp;开始时间:"+InstructObj.begindate+" "+InstructObj.begintime+"&nbsp;&nbsp;结束时间:"+InstructObj.enddate+" "+InstructObj.endtime
										delete InstructObj.enddate;
										delete InstructObj.endtime;
										delete InstructObj.days;
			 						}
			 					}
	 							
	 							if(!moreInstruct){
	 								//进行请假校验. checkDay
	 								if(!InstructObj.checkDay&&InstructObj.days&&InstructObj.leaveType){
	 									var days=InstructObj.days;
	 									if(baseJson.checkLeaveType.indexOf(","+InstructObj.leaveType+",")>-1){//需要检查的请假类型
											var leaveObj=baseJson["levave_"+InstructObj.leaveType];
											if(parseFloat(leaveObj.real)>0){
												if(days>parseFloat(leaveObj.real)){
													moreInstruct=true;
													msg='对不起，'+InstructObj.leaveTypeName+'剩余'+leaveObj.show+'天，请选择其他请假类型.比如“事假”。如需取消，请说“退出”';
												}
											}else{
												moreInstruct=true;
												msg='对不起，您没有可用'+InstructObj.leaveTypeName+'，请选择其他请假类型.比如“事假”。如需取消，请说“退出”';
											}
										}else{
											InstructObj.checkDay="OK";
										}
										
										//假別与请假时间比较失败
										if(moreInstruct){
											delete InstructObj.leaveType;
											delete InstructObj.checkDay;
										}
										
	 								}
	 							}
	 						}
	 					}
	 					
	 					if(!moreInstruct){
	 						if(!InstructObj.content){
	 							moreInstruct=true;
								msg='好的，请告诉我请假事由。';
	 						}
	 					}
	 					//所有指令都识别
	 					if(!moreInstruct){
	 						moreInstruct=true;
							InstructObj.action="ok";
	 					}
	 				}else if(InstructObj.wftype=="Out"){//出差
	 					if(!InstructObj.begintime){
	 						if(obj.rc=="0" && obj.semantic && obj.semantic.slots){
	 							InstructObj=timeAnalysis(obj,InstructObj);
 								if(!InstructObj.begintime){
									moreInstruct=true;
									msg='我不太明白您的意思，请告诉我出差的开始日期和时间。比如明天上午9点。如需取消，请说“退出”';
								}
	 						}else{
	 							moreInstruct=true;
								msg='我不太明白您的意思，请告诉我出差的开始日期和时间。比如明天上午9点。如需取消，请说“退出”';
	 						}
	 						
	 					}else if(!InstructObj.endtime){
	 						if(obj.rc=="0" && obj.semantic && obj.semantic.slots){
		 						var dateTimes=simpleTimeAnalysis(obj)
 								var date=dateTimes[0];
		    					var time=dateTimes[1];
								//写入结束时间.
								if(time!=""){
									InstructObj.enddate=date
									InstructObj.endtime=time;
								}else{
									moreInstruct=true;
									msg='我不太明白您的意思，请告诉我出差的结束日期和时间。比如明天下午6点。如需取消，请说“退出”';
								}
							}else{
								moreInstruct=true;
								msg='我不太明白您的意思，请告诉我出差的结束日期和时间。比如明天下午6点。如需取消，请说“退出”';
							}
	 					}else{
	 						if(!InstructObj.content){
		 						InstructObj.content=obj.text;
	 						}
	 					}
	 					
	 					if(InstructObj.needComfirmTime){
     						//初始2个时间都识别. 进入时间确认界面.
     						afterDoFunction=true;
							doFunction=confirmTime;
							moreInstruct=true;
							afterDoFunctionStandard=true;
							if(!InstructObj.content){
								InstructObj.nextTip='好的，请告诉我出差事由。';
							}else{
								InstructObj.continueAction=true;
							}
    					}
    					
	 					if(!moreInstruct){
	 						if(!InstructObj.endtime){
								moreInstruct=true;
								msg='好的，请告诉我出差的结束日期和时间。比如明天下午6点。';
		 					}
		 				}
		 				
		 				//检查时间有效性
		 				if(!moreInstruct){
 							if(InstructObj.checkTime!="OK"){
								//检验时间有效性
		 						if(InstructObj.begintime&&InstructObj.endtime){
			 						if(TimeCompare(InstructObj.begindate,InstructObj.begintime,InstructObj.enddate,InstructObj.endtime)){//时间合法
			 							 InstructObj.checkTime="OK";
			 						}else{
			 							moreInstruct=true;
										msg='结束日期不合法，请重新告诉我出差的结束日期和时间。比如明天下午6点。如需取消，请说“退出”';
										othermsg="&nbsp;&nbsp;开始时间:"+InstructObj.begindate+" "+InstructObj.begintime+"&nbsp;&nbsp;结束时间:"+InstructObj.enddate+" "+InstructObj.endtime
										delete InstructObj.enddate;
										delete InstructObj.endtime;
			 						}
			 					}
	 						}
		 				}
		 				
		 				if(!moreInstruct){
	 						if(!InstructObj.content){
	 							moreInstruct=true;
								msg='好的，请告诉我出差事由。';
	 						}
	 					}
	 					
	 					//所有指令都识别
	 					if(!moreInstruct){
	 						moreInstruct=true;
							InstructObj.action="ok";
	 					}
	 					
		 				
	 				}else if(InstructObj.wftype=="Fna"){//费用报销
	 					if(obj.service=="chooseRsc"){
		 					InstructObj.resourceid=obj.id;
		 					InstructObj.resourcename=obj.text;
		 					moreInstruct=true;
		 					if(baseJson.fnaNoInteractiveField.indexOf(",crm,")==-1){
								msg='好的，请告诉我相关客户，如果没有，请说“跳过”。如需取消，请说“退出”';
		 					}else{
		 						msg='好的，请告诉我费用日期，如“2017年7月25日”。如需取消，请说“退出”';
		 					}
		 				}else if(obj.service=="chooseCrm"){
							InstructObj.crm=obj.id;
							InstructObj.crmName=obj.text;
		 					moreInstruct=true;
							msg='好的，请告诉我费用日期，如“2017年7月25日”。如需取消，请说“退出”';
		 				}else if(obj.service=="SelectFeeType"){
		 					InstructObj.feetypeid=obj.itemid;
							InstructObj.feetypeName=obj.text;
							if(!InstructObj.amount){
								moreInstruct=true;
								msg='好的，请告诉我您的费用金额，如“300.5”元。如需取消，请说“退出”';
							}
		 				}
	 					
	 					if(!moreInstruct){
	 						if(!InstructObj.budgettype&&baseJson.fnaNoInteractiveField.indexOf(",budgettype,")==-1){
		 						moreInstruct=true;
		 						msg='好的，请告诉我费用承担主体是谁，比如“我”或者其他人名字。如需取消，请说“退出”';
		 						if(obj.text=="个人"){
		 							InstructObj.budgettype=0;
		 							InstructObj.budgettypeName=obj.text;
		 						}else if(obj.text=="部门"){
		 							InstructObj.budgettype=1;
		 							InstructObj.budgettypeName=obj.text;
		 						}else if(obj.text=="分部"){
		 							InstructObj.budgettype=2;
		 							InstructObj.budgettypeName=obj.text;
		 						}else if(obj.text=="成本中心"){
		 							InstructObj.budgettype=3;
		 							InstructObj.budgettypeName=obj.text;
		 						}else{
		 							msg='我不太明白您的意思，请告诉我承担类型如[个人,部门,分部,成本中心]。如需取消，请说“退出”';
		 						}
		 					}
		 					if(!moreInstruct){
		 						if(!InstructObj.resourceid){
		 							moreInstruct=true;
			 						if(obj.text=="我"||obj.text=="我自己"||obj.text=="我自己"){
			 							InstructObj.resourceid=userid;
			 							InstructObj.resourcename=username;
			 							moreInstruct=true;
			 							if(baseJson.fnaNoInteractiveField.indexOf(",crm,")==-1){
											msg='好的，请告诉我相关客户，如果没有，请说“跳过”。如需取消，请说“退出”';
					 					}else{
					 						msg='好的，请告诉我费用日期，如“2017年7月25日”。如需取消，请说“退出”';
					 					}
			 						}else{
					 					searchKey=obj.text;
			      						afterDoFunction=true;
										doFunction=loadRSCByName;
										if(baseJson.fnaNoInteractiveField.indexOf(",crm,")==-1){
											jsonDate.showmsg='好的，请告诉我相关客户，如果没有，请说“跳过”。如需取消，请说“退出”';
					 					}else{
					 						jsonDate.showmsg='好的，请告诉我费用日期，如“2017年7月25日”。如需取消，请说“退出”';
					 					}
			 						}
			 					}
		 					}
		 					
		 					//判断跳过客户
		 					if(!moreInstruct){
		 						if(!InstructObj.crm&&!InstructObj.skipCrm&&obj.text=="跳过"){
		 							InstructObj.skipCrm=true;
									if(baseJson.defCrm){
										InstructObj.crm=baseJson.defCrm;
									} 							
									if(baseJson.defCrmName){
										InstructObj.crmName=baseJson.defCrmName;
									} 
									moreInstruct=true;
									msg='好的，请告诉我费用日期，如“2017年7月25日”。如需取消，请说“退出”';
		 						}
		 					}
		 					
		 					//查找相关客户
		 					if(!moreInstruct){
		 						if(!InstructObj.crm&&!InstructObj.skipCrm&&baseJson.fnaNoInteractiveField.indexOf(",crm,")==-1){
			 						moreInstruct=true;
			 						//使用关键字去搜索客户
			 						searchKey=obj.text;
	      							afterDoFunction=true;
									doFunction=loadCRMByName;
		 						}
		 					}
		 					
		 					if(!moreInstruct){
		 						//费用日期
		 						if(!InstructObj.occurdate){
			 						if(obj.rc=="0" && obj.semantic && obj.semantic.slots){
				 						var date="";
					    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
					    					date=obj.semantic.slots.datetime.date;
					    				}
										//写入结束时间.
										if(date!=""){
											InstructObj.occurdate=date;
											moreInstruct=true;
											msg='好的，请告诉我费用科目，如“手机话费”。如需取消，请说“退出”';
										}else{
											moreInstruct=true;
											msg='我不太明白您的意思，请告诉我费用日期，如“2017年7月25日”。如需取消，请说“退出”';
										}
									}else{
										moreInstruct=true;
										msg='我不太明白您的意思，请告诉我费用日期，如“2017年7月25日”。如需取消，请说“退出”';
									}
								}else if(!InstructObj.feetypeid){//费用科目.
									afterDoFunction=true;
 									doFunction=loadFeeType;
 									jsonDate.key=obj.text;
 									jsonDate.bdf_fieldid=baseJson.bdf_fieldid;
 									moreInstruct=true;
								}else if(!InstructObj.amount){//报销金额
									InstructObj.amount=ChineseAmountToNumber(obj.text)
								}
		 					}
		 				}
		 				
		 				//所有指令都识别
	 					if(!moreInstruct){
	 						moreInstruct=true;
							InstructObj.action="ok";
	 					}
	 					
	 				}else if(InstructObj.wftype=="Car"){
	 					 if(!InstructObj.begintime){
	 						if(obj.rc=="0" && obj.semantic && obj.semantic.slots){
	 							InstructObj=timeAnalysis(obj,InstructObj);
 								if(!InstructObj.begintime){
									moreInstruct=true;
									msg='我不太明白您的意思，请告诉我出车日期和时间。比如明天上午9点。如需取消，请说“退出”';
								}
	 						}else{
	 							moreInstruct=true;
								msg='我不太明白您的意思，请告诉我出车日期和时间。比如明天上午9点。如需取消，请说“退出”';
	 						}
	 						
	 					}else{
	 						if(!InstructObj.content){
		 						InstructObj.content=obj.text;
	 						}
	 					}
	 					
	 					if(!moreInstruct){
	 						if(!InstructObj.content){
      							moreInstruct=true;
      							msg='好的，请告诉我用车事由。';
      						}
	 					}
	 					
	 					//所有指令都识别
	 					if(!moreInstruct){
	 						moreInstruct=true;
								InstructObj.action="ok";
								doFunction=addCar;
	 					}
	 				}
	 			}else if(InstructObj.type=="BLOG"){
	 				InstructObj.content=obj.text;
	 				moreInstruct=true;
	 				InstructObj.action="ok";
	 			}else if(InstructObj.type=="MEETING"){
 					if(!InstructObj.begintime){
 						if(obj.rc=="0" && obj.semantic && obj.semantic.slots){
 							InstructObj=timeAnalysis(obj,InstructObj);
 							if(!InstructObj.begintime){
 								moreInstruct=true;
								msg='我不太明白您的意思，请告诉我会议的开始日期和时间。比如明天上午9点。如需取消，请说“退出”';
 							}
 						}else{
 							moreInstruct=true;
							msg='我不太明白您的意思，请告诉我会议的开始日期和时间。比如明天上午9点。如需取消，请说“退出”';
 						}
 						
 					}else if(!InstructObj.endtime){
 						if(obj.rc=="0" && obj.semantic && obj.semantic.slots){
	 						var dateTimes=simpleTimeAnalysis(obj)
 							var date=dateTimes[0];
		    				var time=dateTimes[1];
							//写入结束时间.
							if(time!=""){
								InstructObj.enddate=date
								InstructObj.endtime=time;
							}else{
								moreInstruct=true;
								msg='我不太明白您的意思，请告诉我会议的结束日期和时间。比如明天下午6点。如需取消，请说“退出”';
							}
						}else{
							moreInstruct=true;
							msg='我不太明白您的意思，请告诉我会议的结束日期和时间。比如明天下午6点。如需取消，请说“退出”';
						}
 					}else if(!InstructObj.selectAddress){//判断是否选择会议室类型
 						if(InstructObj.isCus){//是否确定会议室类型
 							if(InstructObj.isCus=="1"){
 								InstructObj.addressName=obj.text;
 								InstructObj.selectAddress=true;
 							}
 						}else{
 							if(obj.rc=="0" && obj.service=="SelectAddress"){
	 						 	InstructObj.isCus=obj.isCus;
	 						 	InstructObj.addressId=obj.itemid;
	 						 	
	 						 	if(InstructObj.isCus==1){
	 						 		if(!InstructObj.addressName){
	 						 			moreInstruct=true;
										msg='请告诉我自定义会议地点名称。如需取消，请说“退出”';
	 						 		}
	 						 	}else{
	 						 		InstructObj.addressName=obj.text;
	 						 		InstructObj.selectAddress=true;
	 						 	}				
	 						}else{
	 							afterDoFunction=true;
 								doFunction=loadMeetingAddress;
 								jsonDate.key=obj.text;
 								moreInstruct=true;
 								if(obj.service=="continue"){
 									jsonDate.key="";
 								}
	 						}
 						}
 					}else{
 						if(!InstructObj.content){
	 						InstructObj.content=obj.text;
 						}
 					}
 					
 					if(!moreInstruct){
 						if(!InstructObj.endtime){
							moreInstruct=true;
							msg='好的，请告诉我会议的结束日期和时间。比如明天下午6点。';
	 					}
	 				}
	 				
	 				//检查时间有效性
	 				if(!moreInstruct){
	 					if(InstructObj.checkTime!="OK"){
							//检验时间有效性
	 						if(InstructObj.begintime&&InstructObj.endtime){
		 						if(TimeCompare(InstructObj.begindate,InstructObj.begintime,InstructObj.enddate,InstructObj.endtime)){//时间合法
		 							 InstructObj.checkTime="OK";
		 						}else{
		 							moreInstruct=true;
									msg='结束日期不合法，请重新告诉我会议的结束日期和时间。比如明天下午6点。如需取消，请说“退出”';
									othermsg="&nbsp;&nbsp;开始时间:"+InstructObj.begindate+" "+InstructObj.begintime+"&nbsp;&nbsp;结束时间:"+InstructObj.enddate+" "+InstructObj.endtime
									delete InstructObj.enddate;
									delete InstructObj.endtime;
		 						}
		 					}
	 					}
	 				}
	 				
	 				if(!moreInstruct){
 						if(!InstructObj.selectAddress){
 							afterDoFunction=true;
 							doFunction=loadMeetingAddress;
 							moreInstruct=true;
	 					}
	 				}
	 				
	 				if(!moreInstruct){
 						if(!InstructObj.content){
 							InstructObj.content="开会";
 							//moreInstruct=true;
							//msg='请告诉我会议主题是什么，比如部门周例会。如需取消，请说“退出”';
	 					}
	 				}
	 				
	 				//所有指令都识别
 					if(!moreInstruct){
 						moreInstruct=true;
						InstructObj.action="ok";
 					}
	 			}else if(InstructObj.type=="CrmContact"){
	 				if(obj.service=="chooseCrm"){
	 					InstructObj.id=obj.id;
	 					InstructObj.name=obj.text;
	 					InstructObj.desc=obj.desc;
	 					moreInstruct=true;
						msg='好的，请告诉我联系内容。如需取消，请说“退出”';
	 				}
	 				
	 				if(!moreInstruct){
		 				if(!InstructObj.name){
		 					moreInstruct=true;
		 					//使用关键字去搜索客户
		 					searchKey=obj.text;
      						afterDoFunction=true;
							doFunction=loadCRMByName;
		 				}else if(!InstructObj.id){
		 					moreInstruct=true;
							msg='好的，您联系了哪个客户。';
		 				}else if(!InstructObj.content){
		 					InstructObj.content=obj.text;
	 					}
	 				}
	 				
	 				//所有指令都识别
 					if(!moreInstruct){
 						moreInstruct=true;
						InstructObj.action="ok";
 					}
	 			}else if(InstructObj.type=="FREE_RSC"){
	 				if(obj.service=="chooseRsc"){
	 					InstructObj.id=obj.id;
	 					InstructObj.name=obj.text;
	 					//为其新建日程..
	 					addCalendarAjax(InstructObj.id,InstructObj.name,username+"预约"+InstructObj.name,InstructObj.begindate,InstructObj.begintime,InstructObj.enddate,InstructObj.endtime,timestamp);
	 					$('.rscChooseDiv').off("tap");
	 					if(!moreInstruct){
	 						moreInstruct=true;
							InstructObj.action="ok";
	 					}
	 				}else if(obj.service=="FW_COMMON"&&obj.semantic&&obj.semantic.slots&&obj.semantic.slots.type&&obj.semantic.slots.type=="instruct"&&obj.semantic.slots.instruct&&obj.semantic.slots.instruct=="people"){
	 					//语音选人.
	 					var people=obj.semantic.slots.people;
	 					var lastResultRsc=$('.result:last').find('.RSC');
	 					var select_id="";
	 					var select_name="";
	 					if(lastResultRsc&&lastResultRsc.length>0){
	 						//判断当前语音搜索的人是否在查询的列表中. 暂时不支持多音字.
	 						$.each(lastResultRsc,function(j,item){
								 if($(this).attr("deepObj")){
								 	var deepObjJson=JSON.parse($(this).attr("deepObj"));
								 	if(people==deepObjJson.text){
								 		select_id=deepObjJson.id;
								 		select_name=people;
								 	}
								 }
							});
	 					}
	 					if(select_id!=""){
	 						InstructObj.id=select_id;
	 						InstructObj.name=select_name;
	 						//为其新建日程..
	 						addCalendarAjax(InstructObj.id,InstructObj.name,username+"预约"+InstructObj.name,InstructObj.begindate,InstructObj.begintime,InstructObj.enddate,InstructObj.endtime,timestamp);
	 						$('.rscChooseDiv').off("tap");
	 						if(!moreInstruct){
	 							moreInstruct=true;
								InstructObj.action="ok";
	 						}
	 					}else{
	 						//直接取消,重新进入下一个.
	 						var lastAnser=$('.anser:last');
							$(lastAnser).append('<div class="tips">已取消预约</div>');
							$('.rscChooseDiv').off("tap");
							$('.currentInstructTip').removeClass("currentInstructTip");
							textBackUnderstand(JSON.stringify(obj),timestamp)
	 						return;
	 					}
	 				}else{
	 					//语音选人.
	 					var people=obj.text;
	 					var lastResultRsc=$('.result:last').find('.RSC');
	 					var select_id="";
	 					var select_name="";
	 					if(lastResultRsc&&lastResultRsc.length>0){
	 						//判断当前语音搜索的人是否在查询的列表中. 暂时不支持多音字.
	 						$.each(lastResultRsc,function(j,item){
								 if($(this).attr("deepObj")){
								 	var deepObjJson=JSON.parse($(this).attr("deepObj"));
								 	if(people==deepObjJson.text){
								 		select_id=deepObjJson.id;
								 		select_name=people;
								 	}
								 }
							});
	 					}
	 					if(select_id!=""){
	 						InstructObj.id=select_id;
	 						InstructObj.name=select_name;
	 						//为其新建日程..
	 						addCalendarAjax(InstructObj.id,InstructObj.name,username+"预约"+InstructObj.name,InstructObj.begindate,InstructObj.begintime,InstructObj.enddate,InstructObj.endtime,timestamp);
	 						$('.rscChooseDiv').off("tap");
	 						if(!moreInstruct){
	 							moreInstruct=true;
								InstructObj.action="ok";
	 						}
	 					}else{
	 						//直接取消,重新进入下一个.
	 						var lastAnser=$('.anser:last');
							$(lastAnser).append('<div class="tips">已取消预约</div>');
							$('.rscChooseDiv').off("tap");
							$('.currentInstructTip').removeClass("currentInstructTip");
							textBackUnderstand(JSON.stringify(obj),timestamp)
	 						return;
	 					}
	 				}
	 			}else if(InstructObj.type=="flight"){//航班
	 				if(!InstructObj.endLoc){
	 					InstructObj.endLoc=obj.text;
	 					if(!InstructObj.begindate){
							msg="好的，请告诉我出发时间，如明天上午9点";
	   						moreInstruct=true;
						}
	 				}
	 				if(!moreInstruct){
		 				if(!InstructObj.begindate){
		 					if(obj.rc=="0" && obj.semantic && obj.semantic.slots){
		 						InstructObj=timeAnalysis(obj,InstructObj)
								if(!InstructObj.begindate){
									moreInstruct=true;
									msg='我不太明白您的意思，请告诉我出发时间，如明天上午9点。如需取消，请说“退出”';
								}
							}else{
								moreInstruct=true;
								msg='我不太明白您的意思，请告诉我出发时间，如明天上午9点。如需取消，请说“退出”';
							}
						}
	 				}
													
	 				if(!moreInstruct){
	 					moreInstruct=true;
						InstructObj.action="ok";
						afterDoFunction=true;
						doFunction=showFlightList;
						afterDoFunctionStandard=true;
	 				}
	 			}else if(InstructObj.type=="BillNote"){//记一笔
	 				if(!InstructObj.amount){//报销金额
	 					InstructObj.amount=ChineseAmountToNumber(obj.text)
					}
					if(!InstructObj.content){
						InstructObj.content=obj.text;
					}
													
 					moreInstruct=true;
					InstructObj.action="ok";
					afterDoFunction=true;
					doFunction=BillNoteConfirm;
					afterDoFunctionStandard=true;
	 			}
 			}
 			
 			if(!moreInstruct){
 				moreInstruct=true;
		 		cancel=true;
		 		msg="指令识别错误,已退出";
 			}
 		
 		}else{//非进一步查询,需要识别指令
	    	if(obj.rc=="0"){
	    		if(obj.service=="FW_CMD"){//泛微固定命令
	    			var type=obj.semantic.slots.type
	    			if(type=="Emsg"){//发内部消息
	    				jsonDate.slots=obj.semantic.slots;
	    				if(obj.semantic.slots.emtype=="personcard"){//人员名片共享
	    					if(obj.semantic.slots.who&&obj.semantic.slots.who=="self"){
	    						jsonDate.slots.cardId=userid;
								jsonDate.slots.cardName=username;
								jsonDate.slots.to_type="Emsg";
								load_SP_Data(rscTag4,obj.semantic.slots.to,"ID",sendPersonCard,timestamp,jsonDate,true);
	    					}else{
	    						load_SP_Data(rscTag4,obj.semantic.slots.name,"ID",sendPersonCard,timestamp,jsonDate,true);
	    					}
	    				}else if(obj.semantic.slots.emtype=="location"){//位置共享
	    					if($('#hideLocation').attr("currentLocation")){
	    						jsonDate.slots.to_type="Emsg";
		    				    load_SP_Data(rscTag4,obj.semantic.slots.to,"ID",sendLocation,timestamp,jsonDate,true);
	    					}else{
	    						isQA=true;
	    						msg="正在为您定位,请稍后再试";
	    						//重新定位.
	    						location="emobile:gps:fixPosition";
	    					}
	    				}else if(obj.semantic.slots.emtype=="doc"){//文档
	    					needES=true;
	    					if(obj.semantic.slots.content&&obj.semantic.slots.to){
	    						//搜索文档.. 然后点击搜索发送人.
	    						//load_SP_Data("DOC:2",obj.semantic.slots.content,"id",sendShareDoc,timestamp,jsonDate,false,true);
	    					}else{
	    						needES=true;
	    					}
	    					
	    				}else{
		    				var content="";
		    				if(obj.semantic.slots.content){
		    					content=obj.semantic.slots.content;
		    				}
		    				jsonDate.slots.to_type="Emsg";
		    				load_SP_Data(rscTag4,obj.semantic.slots.name,"ID",sendEmsg,timestamp,jsonDate,true);
	    				}
	    			
	    			}else if(type=="WF"){//流程
	    				if(obj.semantic.slots.wftype){//存在流程类型,特殊处理
	    					//检查该类型有没有配置文件
	    					jQuery.ajax({
								async: false, 
								type : "POST", 
								url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
						   		data:{"type":"checkWF","wftype":obj.semantic.slots.wftype},
								dataType : 'json', 
								success : function(data) { 
									if(data.result=="success"){
										InstructObj.type="WF";
										InstructObj.wftype=obj.semantic.slots.wftype;
										InstructObj.workflowid=data.workflowid;
										InstructObj.workflowname=data.workflowname;
										if(obj.semantic.slots.wftype=="Leave"){//请假
											jQuery.ajax({
												async: false, 
												type : "POST", 
												url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
										   		data:{"type":"LeaveParam"},
												dataType : 'json', 
												success : function(data) {
													baseJson=data;
													var leaveType=obj.semantic.slots.leaveType;
													if(obj.semantic.slots.maybeLeaveType&&leaveType=="假"){
														leaveType=obj.semantic.slots.maybeLeaveType;
													}
													InstructObj=timeAnalysis(obj,InstructObj);
	      					
													var days=0;
													if(obj.semantic.slots.object){
														if(obj.semantic.slots.object.number){
															if(obj.semantic.slots.object.number.real){
																var number=obj.semantic.slots.object.number.real;
																try{
																	days=ChineseToNumber(number);
																}catch(e){
																	days=number;
																}
															}
															if(obj.semantic.slots.object.number.half){
																var number=obj.semantic.slots.object.number.half;
																days+=parseFloat(number);
															}
														}
													}
													//InstructObj.days=days;
													
													if(leaveType!="假"){//请假类型
														var leaveTypeId=data.LeaveTypeMap[leaveType]
														if(data.LeaveTypeMap[leaveType] != undefined){
															InstructObj.leaveType=leaveTypeId;
															InstructObj.leaveTypeName=leaveType;
														}
													}else{
														if(InstructObj.begintime){
															leaveType="事假";
															var leaveTypeId=data.LeaveTypeMap[leaveType]
															if(data.LeaveTypeMap[leaveType] != undefined){
																InstructObj.leaveType=leaveTypeId;
																InstructObj.leaveTypeName=leaveType;
															}
														}
													}
													
													if(InstructObj.leaveType){
														if(baseJson.checkLeaveType.indexOf(","+InstructObj.leaveType+",")>-1){//需要检查的请假类型
															var leaveObj=baseJson["levave_"+InstructObj.leaveType];
															if(parseFloat(leaveObj.real)>0){
																if(days>parseFloat(leaveObj.real)){
																	moreInstruct=true;
      																msg='对不起，'+InstructObj.leaveTypeName+'剩余'+leaveObj.show+'天，请选择其他请假类型.比如“事假”。如需取消，请说“退出”';
      																//othermsg=baseJson.allLeaveTypeName;
																}
															}else{
																moreInstruct=true;
      															msg='对不起，您没有可用'+InstructObj.leaveTypeName+'，请选择其他请假类型.比如“事假”。如需取消，请说“退出”';
															}
														}
														
														//假別识别失败
														if(moreInstruct){
															delete InstructObj.leaveType;
														}
													}else{
														moreInstruct=true;
 														msg='好的，您需要请什么类型的假？比如“事假”。如需取消，请说“退出”';
 														//othermsg=baseJson.allLeaveTypeName;
													}
													//如果有请假天数和开始日期与时间
													if(days>0&&InstructObj.begintime){
														var mod=(days/0.5)%2;
														if(mod==0){//整天
															var p_days=parseInt(days)-1;//整天数
															p_days=p_days>0?p_days:0
															var eDate=InstructObj.begindate;
															if(p_days>0){
																var bDate=InstructObj.begindate;
																var dates=bDate.split("-");
																var startdate = new Date(dates[0], parseInt(dates[1])-1, dates[2]); 
																var enddate=DateAdd("d",p_days,startdate);
																eDate=enddate.getFullYear()+"-"+((enddate.getMonth()+1)>9?"":"0")+(enddate.getMonth()+1)+"-"+(enddate.getDate()>9?"":"0")+enddate.getDate();
															}
															InstructObj.enddate=eDate;
															InstructObj.endtime='18:00:00';
														}else{//有半天
															if(InstructObj.begintime<'12:00:00'){
																InstructObj.endtime='12:00:00';
															}else{
																InstructObj.endtime='18:00:00';
															}
															if(days>0.5){//1.5 2.5 3.5 等
																var p_days=parseInt(days);//整天数
																var bDate=InstructObj.begindate;
																var dates=bDate.split("-");
																var startdate = new Date(dates[0], parseInt(dates[1])-1, dates[2]); 
																var enddate=DateAdd("d",p_days,startdate);
																InstructObj.enddate=enddate.getFullYear()+"-"+((enddate.getMonth()+1)>9?"":"0")+(enddate.getMonth()+1)+"-"+(enddate.getDate()>9?"":"0")+enddate.getDate();
															}else{//0.5
																InstructObj.enddate=InstructObj.begindate;
															}
														}
													}
													
													//是否有请假理由
													if(obj.semantic.slots.content){
						      							InstructObj.content=obj.semantic.slots.content;
						      						}else{
						      							//直接使用假別作为事由
						      							if(InstructObj.leaveTypeName){
						      								InstructObj.content=InstructObj.leaveTypeName;
						      							}
						      						}
						      						
													if(!moreInstruct){
														if(!InstructObj.begintime){
							      							moreInstruct=true;
							      							msg='好的，请告诉我请假的开始日期和时间。比如明天上午9点。';
							      						}else if(!InstructObj.endtime){
							      							moreInstruct=true;
							      							msg='好的，请告诉我请假的结束日期和时间。比如明天下午6点。';
							      						}else{
							      							if(InstructObj.needComfirmTime){
								      							//初始2个时间都识别. 进入时间确认界面.
								      							afterDoFunction=true;
					 											doFunction=confirmTime;
					 											moreInstruct=true;
					 											afterDoFunctionStandard=true;
					 											if(!InstructObj.content){
					 												InstructObj.nextTip='好的，请告诉我请假事由。';
					 											}else{
					 												InstructObj.continueAction=true;
					 											}
							      							}
							      						}
													}
													
						      						
						      						if(!moreInstruct){
								 						if(!InstructObj.content){
								 							moreInstruct=true;
															msg='好的，请告诉我请假事由。';
								 						}
								 					}
								 					//所有指令都识别
								 					if(!moreInstruct){
								 						if(!InstructObj.days){
								 							//计算请假天数
								 							jQuery.ajax({
																async: false, 
																type : "POST", 
																url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
														   		data:{"type":"getLeaveDays","fromDate":InstructObj.begindate,"fromTime":InstructObj.begintime,"toDate":InstructObj.enddate,"toTime":InstructObj.endtime,"resourceId":userid},
																dataType : 'json', 
																success : function(data) {
										 							if(data.result){
										 								InstructObj.days=data.result;
										 							}else{
										 								InstructObj.days=0;
										 							}
																}
															});
							 							}
								 						moreInstruct=true;
														InstructObj.action="ok";
								 					}
						      						
												} 
											}); 
										}else if(obj.semantic.slots.wftype=="Out"){
											jQuery.ajax({
												async: false, 
												type : "POST", 
												url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
										   		data:{"type":"OutParam"},
												dataType : 'json', 
												success : function(data) {
													baseJson=data;
													
													InstructObj=timeAnalysis(obj,InstructObj);
													
													//是否有出差理由
						      						if(obj.semantic.slots.content){
						      							InstructObj.content=obj.semantic.slots.content;
						      						}
						      						
													if(!InstructObj.begintime){
						      							moreInstruct=true;
						      							msg='好的，请告诉我出差的开始日期和时间。比如明天上午9点。';
						      						}else if(!InstructObj.endtime){
						      							moreInstruct=true;
						      							msg='好的，请告诉我出差的结束日期和时间。比如明天下午6点。';
						      						}else{
							      						if(InstructObj.needComfirmTime){
								     						//初始2个时间都识别. 进入时间确认界面.
								     						afterDoFunction=true;
															doFunction=confirmTime;
															moreInstruct=true;
															afterDoFunctionStandard=true;
															if(!InstructObj.content){
																InstructObj.nextTip='好的，请告诉我出差事由。';
															}else{
																InstructObj.continueAction=true;
															}
								    					}
						      						}
						      						
						      						if(!moreInstruct){
						      							moreInstruct=true;
						      							if(!InstructObj.content){
							      							msg='好的，请告诉我出差事由。';
						      							}else{
															InstructObj.action="ok";
						      							}
						      						}
						      						
												}
											});
										}else if(obj.semantic.slots.wftype=="Fna"){//费用报销
											jQuery.ajax({
												async: false, 
												type : "POST", 
												url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
										   		data:{"type":"FnaNoInteractiveParam"},
												dataType : 'json', 
												success : function(data) {
													baseJson=data;
													//简化报销流程
													if(obj.semantic.slots.fnatype=="simple"){
														//简化流程包含 科目和金额..
														//费用承担人自己
														InstructObj.resourceid=userid;
														InstructObj.resourcename=username;
														//跳过客户,使用默认客户
														InstructObj.skipCrm=true;
														if(baseJson.defCrm){
															InstructObj.crm=baseJson.defCrm;
														} 							
														if(baseJson.defCrmName){
															InstructObj.crmName=baseJson.defCrmName;
														}
														//费用日期
														if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
															InstructObj.occurdate=obj.semantic.slots.datetime.date;
														}else{
															InstructObj.occurdate=nowDateStr;
														}
														//处理金额 
														InstructObj.amount=ChineseAmountToNumber(obj.semantic.slots.amount)
														//加载费用科目
														afterDoFunction=true;
														doFunction=loadFeeType;
														jsonDate.key=obj.semantic.slots.feetype;
														jsonDate.bdf_fieldid=baseJson.bdf_fieldid;
														moreInstruct=true;

													}else{
														if(obj.semantic.slots.amount&&obj.semantic.slots.feetype){
															//简化流程包含 科目和金额..
															//费用承担人自己
															InstructObj.resourceid=userid;
															InstructObj.resourcename=username;
															//跳过客户,使用默认客户
															InstructObj.skipCrm=true;
															if(baseJson.defCrm){
																InstructObj.crm=baseJson.defCrm;
															} 							
															if(baseJson.defCrmName){
																InstructObj.crmName=baseJson.defCrmName;
															}
															//费用日期
															if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
																InstructObj.occurdate=obj.semantic.slots.datetime.date;
															}else if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.begindate){
																InstructObj.occurdate=obj.semantic.slots.datetime.begindate;
															}else{
																InstructObj.occurdate=nowDateStr;
															}
															//处理金额 
															InstructObj.amount=ChineseAmountToNumber(obj.semantic.slots.amount)
															//加载费用科目
															afterDoFunction=true;
															doFunction=loadFeeType;
															jsonDate.key=obj.semantic.slots.feetype;
															jsonDate.bdf_fieldid=baseJson.bdf_fieldid;
															moreInstruct=true;
														}else{
															var fnaNoInteractiveField=data.fnaNoInteractiveField;
															//是否需要承担类型
															if(fnaNoInteractiveField.indexOf(",budgettype,")==-1){
																moreInstruct=true;
								      							msg='好的，请告诉我费用承担类型如[个人,部门,分部,成本中心]。如需取消，请说“退出”';
															}else{//默认承担人
																moreInstruct=true;
								      							msg='好的，请告诉我费用承担主体是谁，比如“我”或者其他人名字。如需取消，请说“退出”';
															}
															
															if(obj.semantic.slots.amount){
																InstructObj.amount=ChineseAmountToNumber(obj.semantic.slots.amount)
															}
														}
													}
												}
											});
										}else if(obj.semantic.slots.wftype=="Car"){//用车
											baseJson=data;
											InstructObj=timeAnalysis(obj,InstructObj);
											//是否有出差理由
				      						if(obj.semantic.slots.content){
				      							InstructObj.content=obj.semantic.slots.content;
				      						}
											if(!InstructObj.begintime){
				      							moreInstruct=true;
				      							msg='好的，请告诉我出车的日期和时间。比如明天上午9点。';
				      						}else if(!InstructObj.content){
				      							moreInstruct=true;
				      							msg='好的，请告诉我用车事由。';
				      						}else{
				      							moreInstruct=true;
												InstructObj.action="ok";
												doFunction=addCar;
				      						}
										 
										}else{//其他.暂时不支持
											InstructObj={};
											needES=true;
					    					schema="WF";
					    					if(obj.semantic.slots.name){
								    			searchKey=obj.semantic.slots.name;
							    			}
										}
										 
									}else{
										if(obj.semantic.slots.name){
											load_SP_Data("WFTYPE",obj.semantic.slots.name,"ID",createWF,timestamp);
										}else{
											load_SP_Data("WFTYPE",obj.text,"ID",createWF,timestamp);
										}
									}
								}
							}); 
	    					
	    				}else{
		    				var oper="query";
		    				var newoper="";
		    				if(obj.semantic.slots.newoper){
		    					newoper=obj.semantic.slots.newoper;
		    				}
		    				if(obj.semantic.slots.oper){
		    					oper=obj.semantic.slots.oper;
		    				}
		    				if(newoper.toLowerCase()=="querylist"){//查询列表.目前支持我的待办
		    					if(obj.semantic.slots.content){
		    						jsonDate.content=obj.semantic.slots.content;
		    					}
		    					if(obj.semantic.slots.who && obj.semantic.slots.who=="self"){
		    						jsonDate.name="";
		    						showWFTodoList(userid,timestamp,jsonDate);
		    					}else{
		    						if(obj.semantic.slots.name){
		    							jsonDate.name=obj.semantic.slots.name;
			    						load_SP_Data(rscTag,obj.semantic.slots.name,"ID",showWFTodoList,timestamp,jsonDate,true);
		    						}else{
		    							jsonDate.name="";
		    							showWFTodoList(userid,timestamp,jsonDate);
		    						}
		    					}
		    				}else if(newoper.toLowerCase()=="querycreate"){
		    					//alert("需要查询"+obj.semantic.slots.prefix+"新建的");
		    					needES=true;
		    					schema="WF";
		    					if(obj.semantic.slots.name){
					    			searchKey=obj.semantic.slots.name;
				    			}
				    			if(obj.semantic.slots.prefix){
				    				searchKey=obj.semantic.slots.prefix+searchKey;
				    			}
			   					if(obj.semantic.slots.suffix){
				    				searchKey+=" "+obj.semantic.slots.suffix;
				    			}
				    			if(obj.semantic.slots.who){
					    			if(obj.semantic.slots.who=="self"){
				    					if(es_version==es_version1){
			    							otherJson.CREATER=userid;
			    						}else{
			    							otherJson.CREATERID=userid;
			    						}
				    				}else if(obj.semantic.slots.who=="people"){ 
				    					searchKey+=" "+obj.semantic.slots.people;
			    						if(es_version==es_version2){
			    							otherJson.CREATERNAME=obj.semantic.slots.people;
			    						}  
				    				}
				    			}
	    				
				    			if(searchKey==""&&Object.keys(otherJson).length==0){
				    				needES=false;
				    				afterLoad=true;
		    						msg="不知道你要搜索什么样的流程";
				    			}
		    				}else{
		    					if(oper.toLowerCase()=="create"){//新建
		    						if(obj.semantic.slots.name){
				    					load_SP_Data("WFTYPE",obj.semantic.slots.name,"ID",createWF,timestamp);
		    						}else if(pageSemantic.content){
				    					load_SP_Data("WFTYPE",pageSemantic.content,"ID",createWF,timestamp);
		    						}else{
		    							afterLoad=true;
		    							msg="你要新建什么流程，请说完整.比如'新建留言流程'";
		    						}
			    				}else{//查询
			    					needES=true;
			    					schema="WF";
			    					if(obj.semantic.slots.name){
						    			searchKey=obj.semantic.slots.name;
					    			}
					    			if(obj.semantic.slots.prefix){
					    				searchKey=obj.semantic.slots.prefix+searchKey;
					    			}
				   					if(obj.semantic.slots.suffix){
					    				searchKey+=" "+obj.semantic.slots.suffix;
					    			}
				    				if(obj.semantic.slots.who){
						    			if(obj.semantic.slots.who=="self"){
					    					if(es_version==es_version1){
				    							otherJson.CREATER=userid;
				    						}else{
				    							otherJson.CREATERID=userid;
				    						}
					    				}else if(obj.semantic.slots.who=="people"){ 
					    					searchKey+=" "+obj.semantic.slots.people;
				    						if(es_version==es_version2){
				    							otherJson.CREATERNAME=obj.semantic.slots.people;
				    						} 
					    				}
					    			}
				    				if(searchKey==""&&Object.keys(otherJson).length==0){
					    				needES=false;
					    				afterLoad=true;
			    						msg="不知道你要搜索什么样的流程";
					    			}
			    				}
		    				}
	    				}
	    			}else if(type=="SIGN"){//签到
	    				if(obj.semantic.slots.signtype){
	    					sign(timestamp,obj.semantic.slots.signtype);
	    				}else{
	    					sign(timestamp);
	    				}
	    			}else if(type=="SIGNTRACK"){//外勤签到
	    				SignTrack();
	    			}else if(type=="APP"){//打开某个应用
	    				var name="";
	    				if(obj.semantic.slots.name){
			    			name=obj.semantic.slots.name;
		    			}
		    			//如果是所有,清空内容
		    			if(obj.semantic.slots.all){
		    				name="";
		    			}
		    			jsonDate.key=name;
		    			afterDoFunction=true;
						doFunction=getAppList;
	    			}else if(type=="WKP"){//新建日程
	    				var content="";
	    				if(obj.semantic.slots.content){
	    					content=obj.semantic.slots.content;
	    				}
	    				var date="";
	    				if(InstructObj.begindate){
	    					date=InstructObj.begindate;
	    				}
	    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
	    					date=obj.semantic.slots.datetime.date;
	    				}else if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.begindate){
	    					date=obj.semantic.slots.datetime.begindate;
	    				}
	    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date&&obj.semantic.slots.datetime.date_orig){
	    					if(date!=""){
	    						date=getDateByOrig(obj.semantic.slots.datetime.date_orig,date);
	    					}
	    				}
      					
	    				var time="";
	    				if(InstructObj.begintime){
	    					time=InstructObj.begintime;
	    				}
	    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.begintime){
	    					time=obj.semantic.slots.datetime.begintime;
	    				}
	    				
	    				var needEndTime=true;//指定时间段,不获取返回的结束时间.
	    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.time){
	    					time=obj.semantic.slots.datetime.time;
	    					needEndTime=false;
	    				}
	    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date_orig){
	    					InstructObj.date_orig=true;
	    				}
	    				//确认的时间.不需要转换
	    				if(obj.semantic.slots.cft&&obj.semantic.slots.cft=="confirmTime"){
	    					InstructObj.cft=true;
	    				}
	    				
      					//时间本身解析成功
	    				if(time==""){
	    					if(obj.semantic.slots.time){
	    						time=obj.semantic.slots.time;
	    					}
	    				}else{
	    					var addTime=0;
	      					if(obj.semantic.slots.addTime){
	      						addTime=obj.semantic.slots.addTime;
	      					}
	      					var times=time.split(":");
	      					var newHours=parseInt(times[0])+parseInt(addTime);
	      					if(newHours<24){
	      						if(times.length>2){
		      						time=(newHours>9?newHours:"0"+newHours)+":"+times[1]+":"+times[2];
	      						}else{
	      							time=(newHours>9?newHours:"0"+newHours)+":"+times[1];
	      						}
	      					}
	    				}
    					time=time.replaceAll(":","-");
    					if(immediatelyWKP&&time==""){
    						time=getCurrentTime().replaceAll(":","-");
    						InstructObj.confirmWKP=true;//没有时间,当前时间=10分钟,确认是日程
    					}
    					var timeEnd="";
    					if(InstructObj.endtime){
	    					timeEnd=InstructObj.endtime.replaceAll(":","-");
	    				}
	    				if(obj.semantic.slots.datetime){
	    					if(obj.semantic.slots.datetime.enddate&&obj.semantic.slots.datetime.enddate==obj.semantic.slots.datetime.begindate){
	    						if(obj.semantic.slots.datetime.endtime){
	    							timeEnd=obj.semantic.slots.datetime.endtime.replaceAll(":","-");
	    						}
	    					}
	    				}
      					if(obj.semantic.slots.timeEnd&&needEndTime){
      						timeEnd=obj.semantic.slots.timeEnd.replaceAll(":","-");
      					}
      					//是否有时间段识别
      					if(obj.semantic.slots.timeSlot){
      						InstructObj=getTime2Time(obj.semantic.slots.timeSlot,InstructObj);
	      					//如果时间段识别了.替换原来的结束时间.
	      					if(InstructObj.endtime){
	      						timeEnd=InstructObj.endtime.replaceAll(":","-");
	      					}
      					}
      					
      						
	    				if(obj.semantic.slots.name){
	    					load_SP_Data(rscTag,obj.semantic.slots.name,"ID",addCalendar,timestamp,content+":"+date+":"+time+":"+timeEnd);
	    				}else{
	    					//需要检测日程冲突
	    					if(obj.semantic.slots.need&&obj.semantic.slots.need=="check"){
	    						//有时间和内容. 做时间和人员做检测, 目前支持部门和下属
	    						if(date!=""){
		      						InstructObj.date=date;
		      					}
		      					if(time!=""){
		      						InstructObj.time=time;
		      					}
		      					if(timeEnd!=""){
		      						InstructObj.timeEnd=timeEnd;
		      					}
		      					InstructObj=validateDate(InstructObj);
		      					
								var times=InstructObj.time.split("-");
								var dates=InstructObj.date.split("-");
								
								var startdate = new Date(dates[0], parseInt(dates[1])-1, dates[2]); 
								startdate.setHours(parseInt(times[0]));
								startdate.setMinutes(parseInt(times[1]));
								startdate.setSeconds(parseInt(times[2]));
								
								var enddate=DateAdd("h",1,startdate);
								var sDate=InstructObj.date;
								var sTime=times[0]+":"+times[1];
								var eDate=enddate.format("yyyy-MM-dd");//enddate.getFullYear()+"-"+((enddate.getMonth()+1)>9?"":"0")+(enddate.getMonth()+1)+"-"+(enddate.getDate()>9?"":"0")+enddate.getDate();
								var eTime=enddate.format("hh:mm");//(enddate.getHours()>9?"":"0")+enddate.getHours()+":"+ (enddate.getMinutes()>9?"":"0")+enddate.getMinutes();
								InstructObj={};
								
								InstructObj.sDate=sDate;
								InstructObj.sTime=sTime;
								InstructObj.eDate=eDate;
								InstructObj.eTime=eTime;
								InstructObj.who=obj.semantic.slots.who;//团队还是下属
								InstructObj.content=obj.semantic.slots.content;//日程内容
								
								//进行人员冲突判断
								afterDoFunction=true;
								doFunction=checkHrmFree;
								afterDoFunctionStandard=true;
	    						
	    					}else{
		    					//进入日程指令..
		      					InstructObj.type="WKP";
		      					if(content!=""){
		      						InstructObj.content=content;
		      					}
		      					if(date!=""){
		      						InstructObj.date=date;
		      					}
		      					if(time!=""){
		      						InstructObj.time=time;
		      					}
		      					if(timeEnd!=""){
		      						InstructObj.timeEnd=timeEnd;
		      					}
		      					InstructObj=validateDate(InstructObj);
		      					if(!InstructObj.time){
	      							moreInstruct=true;
	      							msg='好的，请告诉我日期和时间。比如明天下午3点。';
	      						}else if(!InstructObj.content){
	      							moreInstruct=true;
	      							msg='好的，将为您创建日程，请告诉我日程主题，比如“开会”。';
	      						}else{
	      							moreInstruct=true;
	      							InstructObj.action="ok";
	      							//直接进入指令
	      							//判断开始时间与当前时间比较. 在 当前时间之前,是否疑似创建微博.
	      							if(InstructObj.date&&InstructObj.time){
	      								if(isBeforeNow(InstructObj.date,InstructObj.time.replaceAll("-",":"))){//开始是人过了
	      									//没有结束时间 或者 结束时间也过了
	      									if(!InstructObj.timeEnd||isBeforeNow(InstructObj.date,InstructObj.timeEnd.replaceAll("-",":"))){//结束时间也过了
	      										InstructObj.maybeType="BLOG";
	      										InstructObj.content=obj.text;
	      										InstructObj.date=nowDateStr;
	      									}
	      								}
	      							}
	      						}
	    					}
	    					//addCalendar("",content+":"+date+":"+time,timestamp);
	    				}
	    			}else if(type=="DOC"){//新建文档
	    				var oper="query";
	    				if(obj.semantic.slots.oper){
	    					oper=obj.semantic.slots.oper;
	    				}
	    				if(obj.semantic.slots.newoper&&obj.semantic.slots.newoper.toLowerCase()=="querycreate"){//querycreate
	    					oper="query";
	    				}
	    				if(oper.toLowerCase()=="create"){//新建
	    					play("暂时不支持新建文档");
	    				}else{//查询
	    					needES=true;
			    			schema=obj.semantic.slots.type;
			    			if(obj.semantic.slots.name){
				    			searchKey=obj.semantic.slots.name;
			    			}
			    			if(obj.semantic.slots.prefix){
			    				searchKey=obj.semantic.slots.prefix+searchKey;
			    			}
			    			if(obj.semantic.slots.who){
			    				if(obj.semantic.slots.who=="self"){
				    				otherJson.creatorId=userid;
				    				//searchKey+=" "+username;
			    				}else if(obj.semantic.slots.who=="people"){ 
			    					searchKey+=" "+obj.semantic.slots.people;
		    						if(es_version==es_version2){
			    						otherJson.CREATERNAME=obj.semantic.slots.people;
		    						}
			    				}
		    				}
		    				
		    				//其他额外条件
		    				if(obj.semantic.slots.otherJson){
		    					$.extend(otherJson,obj.semantic.slots.otherJson);
		    				}
		    				
		   					if(obj.semantic.slots.suffix){
		   						if(searchKey!=""||Object.keys(otherJson).length>0){//有查询内容,忽略后缀
		    			
				    			}else{
				    				searchKey+=" "+obj.semantic.slots.suffix;
				    			}
			    			}
		    				
	    				}
	    			}else if(type=="BLOG"){//微博
	    				var oper="query";
	    				if(obj.semantic.slots.oper){
	    					oper=obj.semantic.slots.oper;
	    				}
	    				if(oper.toLowerCase()=="create"){//新建
							if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
								InstructObj.date=obj.semantic.slots.datetime.date;
							}
							if(InstructObj.date){
								if(isAfterToday(InstructObj.date)){//今天之后. 默认日程
				    				var time="";
				    				var needEndTime=true;
				    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.time){
				    					time=obj.semantic.slots.datetime.time;
				    					needEndTime=false;
				    				}
				    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date_orig){
				    					InstructObj.date_orig=true;
				    				}
				    				//确认的时间.不需要转换
				    				if(obj.semantic.slots.cft&&obj.semantic.slots.cft=="confirmTime"){
				    					InstructObj.cft=true;
				    				}
				    				
			      					//时间本身解析成功
				    				if(time==""){
				    					if(obj.semantic.slots.time){
				    						time=obj.semantic.slots.time;
				    					}
				    				}else{
				    					var addTime=0;
				      					if(obj.semantic.slots.addTime){
				      						addTime=obj.semantic.slots.addTime;
				      					}
				      					var times=time.split(":");
				      					var newHours=parseInt(times[0])+parseInt(addTime);
				      					if(newHours<24){
				      						time=(newHours>9?newHours:"0"+newHours)+":"+times[1]+":"+times[2];
				      					}
				    				}
				    				 
			    					time=time.replaceAll(":","-");
				    				if(immediatelyWKP&&time==""){
			    						time=getCurrentTime().replaceAll(":","-");
			    					}
				    				//确认的时间.不需要转换
			    					if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.type){
			    						if(obj.semantic.slots.datetime.type="DT_BASIC"){
			    							InstructObj.all_cft=true;
			    							InstructObj.cft=true;
			    							InstructObj.date_orig=true;
			    						}
			    					}
			    					var timeEnd="";
			      					if(obj.semantic.slots.timeEnd&&needEndTime){
			      						timeEnd=obj.semantic.slots.timeEnd.replaceAll(":","-");
			      					}
			    					 
			    					//进入日程指令..
			      					InstructObj.type="WKP";
			      					InstructObj.content=obj.semantic.slots.content;
			      					if(time!=""){
			      						InstructObj.time=time;
			      					}
			      					if(timeEnd!=""){
			      						InstructObj.timeEnd=timeEnd;
			      					}
			      					InstructObj=validateDate(InstructObj);
	      							moreInstruct=true;
	      							InstructObj.action="ok";
			      						 
		      					}
							}else{
								//默认今天
								InstructObj.date=nowDateStr;
							}
							if(!InstructObj.type){//已经有模块.被WKP识别
								InstructObj.type="BLOG";
								InstructObj.userid= userid; 
								if(obj.semantic.slots.content){
									InstructObj.content=obj.semantic.slots.content;
								}
								
								if(!InstructObj.content){
	      							moreInstruct=true;
	      							msg='好的，请告诉我您做了哪些工作。';
	      						}else{
	      							moreInstruct=true;
	      							InstructObj.action="ok";
	      						}
							}
	    				}else if(oper.toLowerCase()=="report"){//指定部门和下属微博的统计情况
	    					var date=nowDateStr;
	    					if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
								date=obj.semantic.slots.datetime.date;
							}
							baseJson.date=date;
							afterDoFunction=true;
							doFunction=blogReport;
							afterDoFunctionStandard=true;

	    					if(obj.semantic.slots.who&&obj.semantic.slots.who=="subordinate"){//下属
	    						baseJson.who="subordinate";
	    					}else if(obj.semantic.slots.who&&obj.semantic.slots.who=="team"){//团队
	    						baseJson.who="team";
	    					}else{
	    						baseJson={};
	    						needES=true;
	    					}
	    				}else{//查询微博
			    			needES=true;
	    				}
	    			}else if(type=="Meeting"){//会议
	    				needES=true;
	    				var oper="query";
	    				if(obj.semantic.slots.oper){
	    					oper=obj.semantic.slots.oper;
	    				}
	    				if(oper.toLowerCase()=="create"){//新建
	    					//判断会议类型是否有效
	    					jQuery.ajax({
								async: false, 
								type : "POST", 
								url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
						   		data:{"type":"MeetingParam"},
								dataType : 'json', 
								success : function(data) {
									if(data.result==1){
										needES=false;
										InstructObj.type="MEETING";
										InstructObj.userid= userid; 	
										InstructObj.meetingtype=data.meetingtype;	
										InstructObj.roomcheck=data.roomcheck;
										moreInstruct=true;
										//解析时间
										InstructObj=timeAnalysis(obj,InstructObj);
					    				
										//通过日程传的数据.
										if(obj.semantic.slots.wkpTime){
											InstructObj.begindate=obj.semantic.slots.wkpTime.sDate;
											InstructObj.begintime=obj.semantic.slots.wkpTime.sTime;
											InstructObj.enddate=obj.semantic.slots.wkpTime.eDate;
											InstructObj.endtime=obj.semantic.slots.wkpTime.eTime;
											if(obj.semantic.slots.wkpTime.content){
												InstructObj.content=obj.semantic.slots.wkpTime.content;
											}
											InstructObj.needComfirmTime=true;
										}
										
										if(!InstructObj.begintime){
			      							msg='好的，请告诉我会议开始日期和时间，比如明天上午9点，如需取消，请说“退出”';
			      						}else if(!InstructObj.endtime){
			      							msg='好的，请告诉我会议结束日期和时间，比如明天下午6点。如需取消，请说“退出”';
			      						}else{
			      							if(InstructObj.needComfirmTime){
					     						//初始2个时间都识别. 进入时间确认界面.
					     						afterDoFunction=true;
												doFunction=confirmTime;
												moreInstruct=true;
												afterDoFunctionStandard=true;
												InstructObj.continueAction=true;
			      							}else{//直接进入选择会议室.
			      								afterDoFunction=true;
 												doFunction=loadMeetingAddress;
 												moreInstruct=true;
 												jsonDate.key="";
			      							}
			      						}
									}
								}
							});
	    				}
	    			}else if(type=="SELECT"){//一些固定指令
	    				var which =obj.semantic.slots.which;
	    				var functionName=obj.semantic.slots.functionName;
	    				if(which=="holiday"){//查询假期
	    					showHoliday(timestamp);
	    				}else if(which=="todolist"){//待办
	    					jsonDate.name="";
	    					showWFTodoList(userid,timestamp,jsonDate);
	    				}else if(functionName){//其他固定查询
	    					var people=obj.semantic.slots.people;//其他人
	    					if(obj.semantic.slots){
	    						jsonDate.slots=obj.semantic.slots;
	    					}
	    					if(obj.semantic.slots.who && obj.semantic.slots.who=="self"){
	    						jsonDate.name="";
	    						try{
		    						CustomFunction(eval(functionName),userid,timestamp,jsonDate);
	    						}catch(e){
	    							needES=true;
	    						}
	    					}else{
	    						if(people){
	    							jsonDate.name=obj.semantic.slots.people;
			    					load_SP_Data(rscTag,jsonDate.name,"ID",eval(functionName),timestamp,jsonDate,true);
	    						}else{
	    							if(obj.semantic.slots.op&&obj.semantic.slots.op=="subordinate"){//我的下属
				    					jsonDate.name="";
				    					jsonDate.nextTs=new Date().getTime();
		    							jsonDate.replaceText=true;
				    					deepSubordinate(userid,timestamp,jsonDate,eval(functionName));
				    				}else{
		    							jsonDate.name="";
		    							try{
				    						CustomFunction(eval(functionName),userid,timestamp,jsonDate);
			    						}catch(e){
			    							needES=true;
			    						}
				    				}
	    						}
	    					}
	    				}else{
	    					needES=true;
	    				}
	    			}else if(type=="SCAN"){//扫一扫,需要可以打开新的webview.
	    				afterDoFunction=true;
						doFunction=scanQR;
						afterDoFunctionStandard=true;
	    			}else if(type=="BillNote"){//记一笔,判断是否有此功能.
	    				//{"service":"FW_CMD","text":"记100块5毛5分手机费","semantic":{"slots":{"feetype":"手机费","type":"WriteNote","content":"100块5毛5分手机费","amount":"100块5毛5分"}},"rc":0}
	    				//判断是否有记一笔
	    				jQuery.ajax({
							async: false, 
							type : "POST", 
							url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
					   		data:{"type":"BillNoteParam"},
							dataType : 'json', 
							success : function(data) {
								if(data.result==1){
									baseJson.slots={};
								    baseJson.slots.url=data.url;
								   	baseJson.slots.map=data.map;
								   	baseJson.slots.retFlag=data.retFlag;
								   	
								   	moreInstruct=true;
								   	InstructObj.type="BillNote";
								   	
								   	if(obj.semantic.slots.amount){
										InstructObj.amount=ChineseAmountToNumber(obj.semantic.slots.amount);
									}
									if(obj.semantic.slots.content){
										InstructObj.content=obj.semantic.slots.content;
									}
									 
			      					
			      						
									if(InstructObj.amount){
										if(!InstructObj.content){
											InstructObj.content=obj.text;
										}
										afterDoFunction=true;
										doFunction=BillNoteConfirm;
										afterDoFunctionStandard=true;
										InstructObj.action="ok";
									}else{
										msg='好的，请告诉我金额和说明，如需取消，请说“退出”';
									}
								   	
								}else{
									needES=true;
								}
							}
						});
	    			}else if(type=="noFunction"){//暂不支持此功能
	    				isQA=true;
	    				msg="暂不支持此功能";
	    			}else if(type=="URL"){//直接打开url
	    				if(obj.semantic.slots.url){
	    					baseJson.url=obj.semantic.slots.url;
	    					afterDoFunction=true;
 							doFunction=openByUrl;
 							afterDoFunctionStandard=true;
	    				}else{
							needES=true;
						}
	    				
	    			}else if(type=="ShowErrInfo"){//显示错误信息
	    				 var msgInfo="暂无错误日志";
	    				 try{
	    				 	msgInfo=readErrorMsg();
	    				 }catch(e){}
	    				 isQA=true;
	    				 msg=msgInfo;
	    			}else{
	    				//play("泛微命令解析成功,新功能正在开发中");
	    				needES=true;
	    				if(obj.semantic.slots.name){
		    				searchKey=obj.semantic.slots.name;
	    				}
	    			}
	    			
	    		}else if(obj.service=="FW_CMD_ES"){//泛微查询命令
	    			needES=true;
	    			schema=obj.semantic.slots.type;
	    			if(obj.semantic.slots.name){
		    			searchKey=obj.semantic.slots.name;
	    			}
	    			if(obj.semantic.slots.adj){
		    			searchKey+=obj.semantic.slots.adj;
	    			}
	    			if(obj.semantic.slots.prefix){
	    				searchKey=obj.semantic.slots.prefix+searchKey;
	    			}
	    			if(obj.semantic.slots.who){
	    				if(obj.semantic.slots.who=="self"){
	    					if(schema=="DOC"){
		    					otherJson.creatorId=userid;
	    					}else if(schema=="WF"){
	    						if(es_version==es_version1){
	    							otherJson.CREATER=userid;
	    						}else{
	    							otherJson.CREATERID=userid;
	    						}
	    					}else{
			    				searchKey+=" "+username;
	    					}
	    					 
	    				}else if(obj.semantic.slots.who=="people"){ 
	    					searchKey+=" "+obj.semantic.slots.people;
    						if(es_version==es_version2){
    							if(schema=="DOC"||schema=="WF"){
    								otherJson.CREATERNAME=obj.semantic.slots.people;
    							}
    						} 
	    				}
	    				//我的下属.暂时忽略
    				}
	   				if(obj.semantic.slots.suffix){
		   				if(searchKey!=""&&(schema=="DOC"||schema=="ALL")){//有查询内容,忽略后缀
		    			
		    			}else{
		    				searchKey+=" "+obj.semantic.slots.suffix;
		    			}
	    			}
			    				
	    			//人员特殊处理
	    			if(schema=="RSC"){
	    				if(obj.semantic.slots.op&&obj.semantic.slots.op=="CALL"){
	    					needES=false;
	    					if(obj.semantic.slots.name||obj.semantic.slots.suffix){
	    						var name ="";
	    						if(obj.semantic.slots.name){
	    							name =obj.semantic.slots.name;
	    						}
	    						if(obj.semantic.slots.suffix){
				    				name+=" "+obj.semantic.slots.suffix;
				    			}
		    					if(name=="他" || name=="她" ||name=="她的" ||name=="他的" ||name=="给她" ||name=="给他" ){
		    						afterDoFunction=true;
		    						doFunction=callTel;
		    					}else{
									//查找人员电话    			
			    					load_SP_Data(rscTag,obj.semantic.slots.name,"MOBILE",callTel,timestamp);
		    					}	
	    					}else{
	    						moreInstruct=true;
								msg="您要打给谁，请直接说出名字";
								InstructObj.type="CALL";
								InstructObj.doFunction=callTel;
	    					}
	    				}else if(obj.semantic.slots.op&&obj.semantic.slots.op=="superior"){//上级
	    					needES=false;
	    					if(obj.semantic.slots.who && obj.semantic.slots.who=="self"){
	    						jsonDate.name="";
	    						showSuperior(userid,timestamp,jsonDate);
	    					}else{
	    						if(obj.semantic.slots.people ){
	    							jsonDate.name=obj.semantic.slots.people;
			    					load_SP_Data(rscTag,obj.semantic.slots.people,"ID",showSuperior,timestamp,jsonDate,true);
	    						}else{
	    							needES=true;
	    						}
	    					}
	    					
	    				}else if(obj.semantic.slots.op&&obj.semantic.slots.op=="subordinate"){//下属
	    					needES=false;
	    					if(obj.semantic.slots.who && obj.semantic.slots.who=="self"){
	    						jsonDate.name="";
	    						showSubordinate(userid,timestamp,jsonDate);
	    					}else{
	    						if(obj.semantic.slots.people){
	    							jsonDate.name=obj.semantic.slots.people;
			    					load_SP_Data(rscTag,obj.semantic.slots.people,"ID",showSubordinate,timestamp,jsonDate,true);
	    						}else{
	    							needES=true;
	    						}
	    					}
	    				}else{
	    					//同名时,可以精准定位到自己.
	    					if(obj.semantic.slots.who && obj.semantic.slots.who=="self"){
	    						otherJson.ID=userid;
	    					}
	    				}
	    			}else if(schema=="WKP"){//日程查询
	    				var type_n="";
	    				if(obj.semantic.slots.type_n){
	    					type_n=obj.semantic.slots.type_n;
	    				}
	    				var date="";
	    				//日程查询范围内的日程数据
	    				var sDate="";
	    				var eDate="";
						if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
							date=obj.semantic.slots.datetime.date;
							if(obj.semantic.slots.datetime.date_orig){
								if(obj.semantic.slots.datetime.date_orig=="最近"||obj.semantic.slots.datetime.date_orig=="后面"){
									date="";
								}else{
									var dates=getDatesByOrig(obj.semantic.slots.datetime.date_orig,date);
									sDate=dates[0];
									eDate=dates[1];
								}
							}
						}else if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.begindate){
							date=obj.semantic.slots.datetime.begindate;
							if(obj.semantic.slots.datetime.enddate){
								sDate=date
								eDate=obj.semantic.slots.datetime.enddate;
							}
						}else if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date_orig){
							var dates=getDatesByOrig(obj.semantic.slots.datetime.date_orig,date);
							sDate=dates[0];
							eDate=dates[1];
						}
						
						jsonDate.date=date;
						jsonDate.type_n=type_n;
						jsonDate.sDate=sDate;
						jsonDate.eDate=eDate;
						//可能需要做的事.例如查询代办.
						if(obj.semantic.slots.maybe){
							jsonDate.maybe=obj.semantic.slots.maybe;
						}
						//需要人员.查询人员空闲时间.需要结合上下文语义,优先本次查询条件
						if(obj.semantic.slots.need&&obj.semantic.slots.need=="RSC"){
							needES=false;
							InstructObj.type="FREE_RSC";//预订专家指令
							InstructObj=timeAnalysis(obj,InstructObj);
							moreInstruct=true;
							//没有时间.默认当期时间+10分钟 +小时
							if(!InstructObj.begindate){
								var startdate = new Date(); 
								startdate = DateAdd("n",10,startdate);
								var enddate=DateAdd("h",1,startdate);
								InstructObj.begindate=getDateStr(startdate);
								InstructObj.begintime=getTimeStr(startdate);
								InstructObj.enddate=getDateStr(enddate);
								InstructObj.endtime=getTimeStr(enddate);
							}else if(!InstructObj.endtime){//没有结束时间
								var dates=InstructObj.begindate.split("-");
								var times=InstructObj.begintime.split(":");
								var startdate = new Date(dates[0], parseInt(dates[1])-1, dates[2]); 
								startdate.setHours(parseInt(times[0]));
								startdate.setMinutes(parseInt(times[1]));
		
								var enddate=DateAdd("h",1,startdate);
								InstructObj.enddate=getDateStr(enddate);
								InstructObj.endtime=getTimeStr(enddate);
							}
							
							if(obj.semantic.slots.name){//以本次查询为准
								InstructObj.key=obj.semantic.slots.name;
								afterDoFunction=true;
 								doFunction=showFreeRscByWKP;
 								afterDoFunctionStandard=true;
							}else{//获取上一次的人员集合
								var rscObjStr=$('.result:last').attr("rscObj")
								if(rscObjStr){
									var rscObj=JSON.parse(rscObjStr);
									InstructObj.hrmid=rscObj.hrmid;
									afterDoFunction=true;
 									doFunction=showFreeRscByWKP;
 									afterDoFunctionStandard=true;
								}else{
	    							msg="对不起,不知道你要什么样的专家，比如，明天上午8点到10点有空闲的集成专家";
	    							moreInstruct=true;
									cancel=true;
								}
							}
						}else{
							//解析日期不为空.指令数据库查询
							if(date!=""){
								needES=false;
								//指定日期的日程安排
								//needES=false;
								if(obj.semantic.slots.who && obj.semantic.slots.who=="self"){
									jsonDate.name="";
		    						showWKP(userid,timestamp,jsonDate);
		    					}else{
		    						if(obj.semantic.slots.people){//指定人员
		    							jsonDate.name=obj.semantic.slots.people;
				    					load_SP_Data(rscTag,obj.semantic.slots.people,"ID",showWKP,timestamp,jsonDate,true);
		    						}else if(obj.semantic.slots.who&&obj.semantic.slots.who=="subordinate"){//所有下属
		    							jsonDate.name="";
		    							jsonDate.nextTs=new Date().getTime();
		    							jsonDate.replaceText=true;
		    							deepSubordinate(userid,timestamp,jsonDate,showWKP);
		    						}else{
		    							jsonDate.name="";
		    							showWKP(userid,timestamp,jsonDate);
		    						}
		    					}
							}else{
								needES=false;
								if(obj.semantic.slots.who && obj.semantic.slots.who=="self"){
									jsonDate.name="";
		    						showWKP(userid,timestamp,jsonDate);
		    					}else{
		    						if(obj.semantic.slots.people){
		    							jsonDate.name=obj.semantic.slots.people;
				    					load_SP_Data(rscTag,obj.semantic.slots.people,"ID",showWKP,timestamp,jsonDate,true);
		    						}else if(obj.semantic.slots.who&&obj.semantic.slots.who=="subordinate"){//所有下属
		    							jsonDate.name="";
		    							jsonDate.replaceText=true;
		    							jsonDate.nextTs=new Date().getTime();
		    							deepSubordinate(userid,timestamp,jsonDate,showWKP);
		    						}else{
		    							jsonDate.name="";
		    							showWKP(userid,timestamp,jsonDate);
		    						}
		    					}
							}
						}
	    			}else if(schema=="CRM"){//客户导航
	    				if(obj.semantic.slots.op&&obj.semantic.slots.op=="map"){
	    					if(obj.semantic.slots.name){
	    						needES=false;
	    						load_address("",obj.semantic.slots.name,timestamp,jsonDate);
	    					}
	    				}else if(obj.semantic.slots.op&&obj.semantic.slots.op=="nearby"){//附近的客户
	    					//获取经纬度
	    					//currentLocation
	    					//jsonDate.lat=date;
							//jsonDate.l=type_n;
							if($('#hideLocation').attr("currentLocation")){
								var locationObj=JSON.parse($('#hideLocation').attr("currentLocation"));
								otherJson.lat=locationObj.lat;
								otherJson.lng=locationObj.lng;
							}else{
								//定位失败
								location="emobile:gps:fixPosition";
								needES=false;
								isQA=true;
	    						msg="定位失败，正在给您重新定位，请稍后再试";
							}
	    				}else if(obj.semantic.slots.op&&obj.semantic.slots.op=="CcrmContact"){//新建客户联系
	    					needES=false;
	    					//进入客户联系指令..
	      					InstructObj.type="CrmContact";
	      					moreInstruct=true;
	      					//是否识别日期
	      					if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
	      						InstructObj.date=obj.semantic.slots.datetime.date;
	      					}
	      					//可能的识别内容,用于创建微博
	      					if(obj.semantic.slots.maybeContent){
	      						InstructObj.maybeContent=obj.semantic.slots.maybeContent;
	      					}
	      					if(obj.semantic.slots.name){
	      						searchKey=obj.semantic.slots.name;
	      						afterDoFunction=true;
								doFunction=loadCRMByName;
      						}else{
      							msg='好的，您联系了哪个客户。';
      						}
	    				}
	    			}
	    		}else if(obj.service=="FW_REPORT"){//报表
	    			if(obj.semantic && obj.semantic.slots&&obj.semantic.slots.reportType){
	    				needES=false;
	    				if(obj.semantic.slots.realReportType){
	    					obj.semantic.slots.reportType=obj.semantic.slots.realReportType;
	    				}
	   					//判断报表类型是否有效
	   					jQuery.ajax({
							async: false, 
							type : "POST", 
							url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
					   		data:{"type":"ReportParam","reportType":obj.semantic.slots.reportType},
							dataType : 'json', 
							success : function(data) {
								if(data.result==1){
									needES=false;
									if(obj.semantic.slots){
										var date="";
										var dattype="";
										var date_orig="";
										var datetype=1;//1表示指定日期  2表示周  3表示月
										var dif=0;//上个. 下个 计算差值  基本上就是(-1 0 1)
										var name="";
									    if(obj.semantic.slots.name){
									    	name=obj.semantic.slots.name;
									    }
									    //判断InstructObj是否有数据
									    if(InstructObj.begindate){
									    	date=InstructObj.begindate;
									    }
									    if(InstructObj.date_orig){
									    	date_orig=InstructObj.date_orig;
									    }
									    
									    jsonDate.slots={};
									    jsonDate.slots.url=data.url;
									    jsonDate.slots.key=name;
									    jsonDate.slots.fromDate="";
									    jsonDate.slots.toDate="";
									    jsonDate.slots.people="";
									    jsonDate.slots.map=data.map;
									    jsonDate.slots.retList=data.retList;
									    jsonDate.slots.retFlag=data.retFlag;
									    jsonDate.slots.statList=data.statList;
									    if(obj.semantic.slots.who){
									    	jsonDate.slots.who=obj.semantic.slots.who;
									    }
									    //传递经纬度
									    if($('#hideLocation').attr("currentLocation")){
											var currentLocation=JSON.parse($('#hideLocation').attr("currentLocation"));
											if(currentLocation&&currentLocation.time&&((new Date().getTime()-currentLocation.time)>10*1000*1000)){//超过10分钟,重新定位
												location="emobile:gps:fixPosition";
											}
											//传递经纬度
									    	jsonDate.slots.lng=currentLocation.lng;
									    	jsonDate.slots.lat=currentLocation.lat;
										}else{
											location="emobile:gps:fixPosition";
										}
									   
										//获取解析语义
										var datetime=obj.semantic.slots.datetime;
										if(datetime&&datetime.date_orig){
											date_orig=datetime.date_orig;
										}
										//获取时间
										if(datetime&&datetime.date){
											date=datetime.date;
										}
										//获取年
										var year="";
										var month="";
										if(datetime&&datetime.year){
											year=datetime.year;
											//年处理
											if(year.indexOf("年")>-1){
												year=year.substring(0,year.indexOf("年"));
											}
											try{
												year=parseInt(year);
												if(isNaN(year)){
													if(datetime.year=="今年"){
														year=now.getFullYear();
													}else if(datetime.year=="去年"){
														year=now.getFullYear()-1;
													}else{
														year="";
													}
												}
											}catch(e){
												if(datetime.year=="今年"){
													year=now.getFullYear();
												}else if(datetime.year=="去年"){
													year=now.getFullYear()-1;
												}else{
													year="";
												}
											}
											if(year.length==2){
												year=now.getFullYear().substring(0,2)+""+year;
											}
											jsonDate.slots.confirmYear=year;
											if(date_orig==""){
												date_orig="指定年";
											}
										}
										//获取月
										if(datetime&&datetime.month){
											month=datetime.month;
											//月处理
											if(month.indexOf("月")>-1){
												month=month.substring(0,month.indexOf("月"));
											}
											try{
												month=parseInt(month);
												if(isNaN(month)){
													if(datetime.month=="本月"){
														month=now.getMonth()+1;
													}else if(datetime.month=="上月"||datetime.month=="上个月"||datetime.month=="上一月"){
														month=lastmonth.getMonth()+1;
														year=lastmonth.getFullYear();
														jsonDate.slots.confirmYear=year;
													}else{
														month=datetime.month;
														month=ChineseMonthToNumber(month.substring(0,month.indexOf("月")))
													}
												}
											}catch(e){
												if(datetime.month=="本月"){
													month=now.getMonth()+1;
												}else if(datetime.month=="上月"||datetime.month=="上个月"||datetime.month=="上一月"){
													month=lastmonth.getMonth()+1;
													year=lastmonth.getFullYear();
													jsonDate.slots.confirmYear=year;
												}else{
													month="";
												}
											}
											if(month!=""){
												month=month>9?month:"0"+month;
												if(date_orig=="指定年"||date_orig==""){
													date_orig="指定月";
												}
												jsonDate.slots.confirmMonth=month;
												if(year==""){
													year=now.getFullYear();
													jsonDate.slots.confirmYear=year;
												}
											}
										}
										if(date==""){
											if(year!=""&&month!=""){
												date=year+"-"+month+"-01";
											}else if(year!=""){
												date=year+"-01-01";	
											}
										}
										
										 //如果有date_orig,没有date.默认今天
									    if(date_orig&&date==""){
									    	date=nowDateStr;
									    }
									    
										if(date!=""){
											var dates=date.split("-");
											jsonDate.slots.year=dates[0];
											jsonDate.slots.month=parseInt(dates[1]);
										}
										//用于报表展示时间的个性化输出
										jsonDate.slots.DisplayDate=date_orig;
										//指定哪一天
										if(date_orig.indexOf("日")>-1||date_orig.indexOf("天")>-1||date_orig.indexOf("号")>-1){
											datetype=1;
										}else if(date_orig.indexOf("礼拜")>-1||date_orig.indexOf("星期")>-1||date_orig.indexOf("周")>-1){
											if(date_orig.endWith("礼拜")||date_orig.endWith("星期")||date_orig.endWith("周")){//周的标识
												datetype=2;
												if(date_orig.indexOf("上")>-1||date_orig.indexOf("前")>-1){
													dif=-1;
												}else if(date_orig.indexOf("下")>-1||date_orig.indexOf("后")>-1){
													dif=1;
												}
											}else{//具体哪一天
												datetype=1;
											}
										}else if(date_orig.indexOf("月")>-1){
											datetype=3;
											if(date_orig.indexOf("上")>-1||date_orig.indexOf("前一")>-1||date_orig.indexOf("前个")>-1){
												dif=-1;
											}else if(date_orig.indexOf("下")>-1||date_orig.indexOf("后一")>-1||date_orig.indexOf("后个")>-1){
												dif=1;
											}
										}else if(date_orig.indexOf("年")>-1){ 
											datetype=4;
										}
									    
									    if(date!=""){//解析出日期
									    	jQuery.ajax({
												async: false, 
												type : "POST", 
												url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
										   		data:{"type":"getDateRange","date":date,"datetype":datetype,"dif":dif},
												dataType : 'json', 
												success : function(data) {
													if(data.fromDate){
														jsonDate.slots.fromDate=data.fromDate;
													}
													if(data.toDate){
														jsonDate.slots.toDate=data.toDate;
													}
													if(data.year){
														jsonDate.slots.confirmYear=data.year;
													}
													if(data.month){
														jsonDate.slots.confirmMonth=data.month;
													}
													//如果是指定月和指定年处理
													if(jsonDate.slots.DisplayDate=="指定月"){
														jsonDate.slots.DisplayDate=data.year+"年"+data.month+"月";
													}else if(jsonDate.slots.DisplayDate=="指定年"){
														jsonDate.slots.DisplayDate=data.year+"年";
													}
													
													
													if(obj.semantic.slots.who&&obj.semantic.slots.who=="self"){
														isShowReport=true;
														jsonDate.slots.people=userid
													}else if(obj.semantic.slots.who&&obj.semantic.slots.who=="subordinate"){//我的下属
								    					if(obj.semantic.slots.who_all&&obj.semantic.slots.who_all=="all"){//统计所有下属
															jsonDate.slots.people=userid;
															jsonDate.slots.peopleName=username;
															isShowReport=true;
														}else{//单个点击下属展示数据
									    					jsonDate.name="";
									    					jsonDate.nextTs=new Date().getTime();
							    							jsonDate.replaceText=true;
									    					deepSubordinate(userid,timestamp,jsonDate,showReportUrl);
														}
								    				}else if(obj.semantic.slots.people){
														load_SP_Data(rscTag,obj.semantic.slots.people,"ID",showReportUrl,timestamp,jsonDate,true);
													}else{
														isShowReport=true;
													}
												}
											 });
									    }else{
									    	var people="";
											if(obj.semantic.slots.who&&obj.semantic.slots.who=="self"){
												jsonDate.slots.people=userid;
												jsonDate.slots.peopleName=username;
												isShowReport=true;
											}else if(obj.semantic.slots.who&&obj.semantic.slots.who=="subordinate"){//我的下属
												if(obj.semantic.slots.who_all&&obj.semantic.slots.who_all=="all"){//统计所有下属
													jsonDate.slots.people=userid;
													jsonDate.slots.peopleName=username;
													isShowReport=true;
												}else{//单个点击下属展示数据
							    					jsonDate.name="";
							    					jsonDate.nextTs=new Date().getTime();
					    							jsonDate.replaceText=true;
							    					deepSubordinate(userid,timestamp,jsonDate,showReportUrl);
												}
								    		}else if(obj.semantic.slots.people){
												load_SP_Data(rscTag,obj.semantic.slots.people,"ID",showReportUrl,timestamp,jsonDate,true);
											}else{
												isShowReport=true;
											}
									    }
									}
								}else{
									needES=true;
								}
							}
						});
	    			}else{
	    				needES=true;
	    			}
	    		}else if(obj.service=="telephone"){//电话
	    			needES=true;
	    			if(obj.operation=="CALL"){
	    				needES=false;
	    				if(obj.semantic.slots&&obj.semantic.slots.code){
	    					callTel(obj.semantic.slots.code);
	    				}else if(obj.semantic.slots&&(obj.semantic.slots.name||obj.semantic.slots.suffix)){
	    					var name ="";
	    					if(obj.semantic.slots.name){
	    						name=obj.semantic.slots.name;
	    					}
	    					if(obj.semantic.slots.suffix){
			    				name+=" "+obj.semantic.slots.suffix;
			    			}
	    					if(name=="他" || name=="她" ||name=="她的" ||name=="他的" ||name=="给她" ||name=="给他" ){
	    						afterDoFunction=true;
	    						doFunction=callTel;
	    					}else{
								//查找人员电话    			
		    					load_SP_Data(rscTag,name,"MOBILE",callTel,timestamp);
	    					}
	    				}else{
	    					moreInstruct=true;
							msg="您要打给谁，请直接说出名字";
							InstructObj.type="CALL";
							InstructObj.doFunction=callTel;
	    				}
	    			}
	    		}else if(obj.service=="message"){//短信
	    			needES=true;
	    			if(obj.operation=="SEND"){
	    				needES=false;
	    				var content="";
	    				if(obj.semantic.slots){
		    				if(obj.semantic.slots.content){
		    					content=obj.semantic.slots.content;
		    				}
		    				if(obj.semantic.slots.code){
		    					sendSms(obj.semantic.slots.code,content);
		    				}else if(obj.semantic.slots.messageType=="voice_message"){
		    					needES=true;
		    				}else if(obj.semantic.slots.name){
								//查找人员电话    			
			    				load_SP_Data(rscTag,obj.semantic.slots.name,"MOBILE",sendSms,timestamp,content);
		    				}else{
		    					afterLoad=true;
		    					msg="你要发短信给谁";
		    				}
	    				}else if(obj.moreResults){
	    					var moreResult=obj.moreResults[0];
	    					if(moreResult.rc=="0"){
	    						if(moreResult.answer.type=="T"){
	    							isQA=true;
	    							msg=moreResult.answer.text;
	    						}
	    					}else{
	    						afterLoad=true;
		    					msg="你要发短信给谁";
	    					}
	    				}else{
	    					afterLoad=true;
		    				msg="你要发短信给谁";
	    				}
	    			}
	    		}else if(obj.service=="schedule"){//日程提醒
	    			hideToast();
	    			if(obj.operation=="CREATE"){
	    				 if(obj.semantic.slots.name=="reminder"){//提醒
	    				    InstructObj.confirmWKP=true;//确认是日程
		    				var content="";
		    				if(obj.semantic.slots.content){
		    					if(obj.semantic.slots.content!=obj.text){
			    					content=obj.semantic.slots.content;
		    					}
		    				}
		    				var date="";
		    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
		    					date=obj.semantic.slots.datetime.date;
		    				}
		    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date&&(obj.semantic.slots.datetime.dateOrig||obj.semantic.slots.datetime.date_orig)){
		    					if(date=="CURRENT_DAY"){
			    					date=nowDateStr;
			    				}
		    					if(date!=""){
		    						if(obj.semantic.slots.datetime.dateOrig){
		    							date=getDateByOrig(obj.semantic.slots.datetime.dateOrig,date);
		    						}else if(obj.semantic.slots.datetime.date_orig){
		    							date=getDateByOrig(obj.semantic.slots.datetime.date_orig,date);
		    						}
		    					}
	    					}
		    				
		    				var time="";
		    				var needEndTime=true;
		    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.time){
		    					time=obj.semantic.slots.datetime.time;
		    					needEndTime=false;
		    				}
		    				if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date_orig){
		    					InstructObj.date_orig=true;
		    				}
		    				//确认的时间.不需要转换
		    				if(obj.semantic.slots.cft&&obj.semantic.slots.cft=="confirmTime"){
		    					InstructObj.cft=true;
		    				}
		    				
	      					//时间本身解析成功
		    				if(time==""){
		    					if(obj.semantic.slots.time){
		    						time=obj.semantic.slots.time;
		    					}
		    				}else{
		    					var addTime=0;
		      					if(obj.semantic.slots.addTime){
		      						addTime=obj.semantic.slots.addTime;
		      					}
		      					var times=time.split(":");
		      					var newHours=parseInt(times[0])+parseInt(addTime);
		      					if(newHours<24){
		      						time=(newHours>9?newHours:"0"+newHours)+":"+times[1]+":"+times[2];
		      					}
		    				}
		    				 
	    					time=time.replaceAll(":","-");
		    				if(immediatelyWKP&&time==""){
	    						time=getCurrentTime().replaceAll(":","-");
	    					}
		    				//确认的时间.不需要转换
	    					if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.type){
	    						if(obj.semantic.slots.datetime.type="DT_BASIC"){
	    							InstructObj.all_cft=true;
	    							InstructObj.cft=true;
	    							InstructObj.date_orig=true;
	    						}
	    					}
	    					var timeEnd="";
	      					if(obj.semantic.slots.timeEnd&&needEndTime){
	      						timeEnd=obj.semantic.slots.timeEnd.replaceAll(":","-");
	      					}
	      					//是否有时间段识别
	      					if(obj.semantic.slots.timeSlot){
	      						InstructObj=getTime2Time(obj.semantic.slots.timeSlot,InstructObj);
		      					//如果时间段识别了.替换原来的结束时间.
		      					if(InstructObj.endtime){
		      						timeEnd=InstructObj.endtime.replaceAll(":","-");
		      					}
	      					}
	      					
	    					if(obj.semantic.slots.who&&obj.semantic.slots.who=="people"&&obj.semantic.slots.people){
	    						load_SP_Data(rscTag,obj.semantic.slots.people,"ID",addCalendar,timestamp,content+":"+date+":"+time+":"+timeEnd);
	    					}else{
		    					//进入日程指令..
		      					InstructObj.type="WKP";
		      					if(content!=""){
		      						InstructObj.content=content;
		      					}
		      					if(date!=""){
		      						InstructObj.date=date;
		      					}
		      					if(time!=""){
		      						InstructObj.time=time;
		      					}
		      					if(timeEnd!=""){
		      						InstructObj.timeEnd=timeEnd;
		      					}
		      					InstructObj=validateDate(InstructObj);
	      						if(!InstructObj.time){
	      							moreInstruct=true;
	      							msg='好的，请告诉我日期和时间。比如明天下午3点。';
	      						}else if(!InstructObj.content){
	      							moreInstruct=true;
	      							msg='好的，请告诉我需要提醒您做什么，比如“开会”。';
	      						}else{
	      							moreInstruct=true;
	      							InstructObj.action="ok";
	      						}
      						}
      						//addCalendar("",content+":"+date+":"+time,timestamp);
	    				 }else if(obj.semantic.slots.name=="clock"){//闹钟
	    				 	needES=true;
	    				 }
	    			}else{
		    			needES=true;
	    			}
	    		}else if(obj.service=="weather"){//天气提醒
	    			 if(obj.operation=="QUERY"){
	    			 	if(obj.data&& obj.data.result&&obj.semantic&&obj.semantic.slots&&obj.semantic.slots.datetime){
	    			 		isWeather=true;
	    			 	}else{
	    			 		isQA=true;
	    					msg="天气查询异常";
	    			 	}
	    			 }else{
	    			 	needES=true;
	    			 }
	    		}else if(obj.service=="map"){
	    			var city="";
   					var address="";
	    			if(obj.operation=="ROUTE"){//线路
	    				//	城市/city
						//	区县/area		
						//	道路/street		
						//	区域/region		
						//	位置点/poi
	    				if(obj.semantic.slots.endLoc){
	    					if(obj.semantic.slots.endLoc.poi){
	    						address=obj.semantic.slots.endLoc.poi;
	    					}
	    					if(obj.semantic.slots.endLoc.city){
	    						city=obj.semantic.slots.endLoc.city;
	    					}
	    					load_address(city,address,timestamp,jsonDate);
	    				}else{
	    					isQA=true;
	    					msg="线路规划失败";
	    				}
	    			}else if(obj.operation=="POSITION"){
	    				if(obj.semantic&&obj.semantic.slots&&obj.semantic.slots.location&&obj.semantic.slots.location.type=="LOC_POI"&&obj.semantic.slots.location.poi){
	    					if(obj.semantic.slots.location.poi=="CURRENT_POI"){//获取当前位置
	    						showFixPosition();
	    					}else{//获取查询位置
	    						load_address_list(obj.semantic.slots.location.poi,timestamp,jsonDate);
	    					}
	    				}else{
	    					isQA=true;
	    					msg="哎呀，我也不知道呢";
	    				}
	    			}else{
		    			isQA=true;
	    				msg="哎呀，我也不知道呢";
	    			}
	    		}else if(obj.service=="flight"){//航班查询."operation": "QUERY", 
					if(obj.operation=="QUERY"){//查询航班
						jQuery.ajax({
								async: false, 
								type : "POST", 
								url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
						   		data:{"type":"FlightParam"},
								dataType : 'json', 
								success : function(data) {
									if(data.result==1){
										baseJson.slots={};
									    baseJson.slots.url=data.url;
									    baseJson.slots.retList=data.retList;
									    baseJson.slots.retFlag=data.retFlag;
									    baseJson.slots.statList=data.statList;
									    
										//判断是否支持航班查询
										if(obj.semantic.slots){
											if(obj.semantic.slots.endLoc){//必须要有目的地.
												InstructObj.type="flight";
												InstructObj.endLoc=obj.semantic.slots.endLoc.cityAddr;
												if(obj.semantic.slots.startLoc&&obj.semantic.slots.startLoc.city=="CURRENT_CITY"){
													if($('#hideLocation').attr("currentLocation")){//页面是否已经定位经纬度
														var locationObj=JSON.parse($('#hideLocation').attr("currentLocation"));
														if(locationObj.city){
															InstructObj.startLoc=locationObj.city.replaceAll("市","");
														}else{
															location="emobile:gps:fixPosition";
															msg="定位失败，请告诉我出发城市";
															moreInstruct=true;
														}
													}else{
														//定位失败
														location="emobile:gps:fixPosition";
							    						msg="定位失败，请告诉我出发城市";
							    						moreInstruct=true;
													}
												}else{
													InstructObj.startLoc=obj.semantic.slots.startLoc.cityAddr;
												}
												
												//判断是否有时间
												if(obj.semantic.slots.startDate){
													if(obj.semantic.slots.startDate.date){
														InstructObj.begindate=obj.semantic.slots.startDate.date;
													}
													if(obj.semantic.slots.startDate.time){
														InstructObj.begintime=obj.semantic.slots.startDate.time;
													}
													if(obj.semantic.slots.startDate.endDate){
														InstructObj.enddate=obj.semantic.slots.startDate.endDate;
													}
													if(obj.semantic.slots.startDate.endTime){
														InstructObj.endtime=obj.semantic.slots.startDate.endTime;
													}
												}
												
												if(!moreInstruct){
													if(!InstructObj.begindate){
														msg="好的，请告诉我出发时间，如明天上午9点";
							    						moreInstruct=true;
													}
												}
												
												if(!moreInstruct){
 													moreInstruct=true;
													InstructObj.action="ok";
													afterDoFunction=true;
													doFunction=showFlightList;
													afterDoFunctionStandard=true;
												}
												
											}else{
												isQA=true;
					    						msg="航班信息难不倒我！你可以下令“查询后天去北京的航班”，我立刻执行！";
											}
										}else if(obj.semantic&&obj.semantic.prompt){//提示.
											isQA=true;
					    					msg=obj.semantic.prompt.replace("广州到上海","上海到北京");
										}else{
											needES=true;
										}	
									
									}else{
										isQA=true;
	    								msg="不支持航班查询!";
									}
								}
						});
						
					}else{
						needES=true;
					}
	    		}else if(obj.operation=="ANSWER"){
	    			if(obj.answer){
	    				hideToast();
	    				if(obj.answer.type=="T"){
	    					isQA=true;
	    					msg=obj.answer.text;
	    				}
	    			}else if(obj.semantic&&obj.semantic.slots&&obj.semantic.slots.answer){
	    				hideToast();
	    				isQA=true;
	    				msg=obj.semantic.slots.answer;
	    			}
	    			
	    			if(!isQA){
	    				needES=true;
	    			} 
	    		}else if(obj.service=="NativeAction"){//本地动作接口
	    			needES=true;
	    			if(obj.action=="findPlace"){
	    				needES=false;
	    				nativeAction=true;
	    				nativeJson.service='NativeAction';
	    				nativeJson.action='findPlace';
	    				nativeJson.rc='0';
	    				load_address_list(obj.text,timestamp,jsonDate);
	    			}else if(obj.action=="showWFTodoListById"){
	    				needES=false;
	    				nativeAction=true;
	    				afterDoFunction=true;
	    				if(obj.CannotEdit){//输入内容不允许编辑
		    				CanEdit=false;
	    				}
	    				$.extend(nativeJson,obj);
	    				doFunction=showWFTodoListById;
	    			}else if(obj.needAction){//其他额外调用,主要是多人情况下,点击人员进行相应操作
	    				needES=false;
	    				nativeAction=true;
	    				if(obj.CannotEdit){//输入内容不允许编辑
		    				CanEdit=false;
	    				}
	    				var functionName=obj.action;
	    				$.extend(nativeJson,obj);
	    				try{
   							CustomFunction(eval(functionName),obj.id,timestamp,nativeJson);
  						}catch(e){
  							isQA=true;
	    					msg="进一步点击操作失败";
  						}
	    			}
	    		}else{//其他固定指令
	    			//alert("其他场景命令解析成功");
	    			needES=true;
	    		}
	    	}else{//未识别
	    		needES=true;
	    	}
 		}
	    //如果是进一步搜索,延续上一次指定搜索条件
	    if(moreSearch){
	    	otherJson=lastOtherJson;
	    }
	    
    	//询问DIV
    	if($('#ask'+timestamp)&&$('#ask'+timestamp).length>0){//存在
    		var keyDivObj=$('#ask'+timestamp).find(".keyDiv");
    		$(keyDivObj).attr("schema",schema);
    		$(keyDivObj).attr("searchKey",searchKey);
    		$(keyDivObj).attr("otherJson",JSON.stringify(otherJson));
    		if(nativeAction){
    			$(keyDivObj).attr("nativeJson",JSON.stringify(nativeJson));
    			if(nativeJson.replaceText){
    				$(keyDivObj).attr("text",obj.text);
    				$(keyDivObj).html(addQuotes(obj.text));
    				$("#anser"+timestamp).html("");
    			}
    		}else{
    			if(obj.replaceText){
    				$(keyDivObj).attr("text",obj.text);
    				$(keyDivObj).html(addQuotes(obj.text));
    				$("#anser"+timestamp).html("");
    			}
    		}
    		$('.currentAskTip').removeClass("currentAskTip");
    	}else{
    		//移除上一次的
	   		removeLastAsk();
	   		if(CanEdit){
    			$('#contentDiv').append("<div id='ask"+timestamp+"' ts='"+timestamp+"' class='ask askCurrent'><div class='keyDiv' text='"+obj.text+"' schema='"+schema+"' searchKey='"+searchKey+"' lastKey='"+lastKey+"' otherJson='"+JSON.stringify(otherJson)+"' moreSearch='"+moreSearch+"'>“"+obj.text+"”</div><div class='tapDiv'>\轻点以编辑\</div></div>");
    		}else{
    			$('#contentDiv').append("<div id='ask"+timestamp+"' ts='"+timestamp+"' class='ask askCurrent'><div class='keyDiv' text='"+obj.text+"' schema='"+schema+"' searchKey='"+searchKey+"' lastKey='"+lastKey+"' otherJson='"+JSON.stringify(otherJson)+"' moreSearch='"+moreSearch+"'>“"+obj.text+"”</div></div>");
    		}
    		if(nativeAction){
    			var keyDivObj=$('#ask'+timestamp).find(".keyDiv");
    			$(keyDivObj).attr("nativeJson",JSON.stringify(nativeJson));
    		}
    	}
    	
    	//指令DIV
    	if($('#instructTip'+timestamp)&&$('#instructTip'+timestamp).length>0){//存在
 			
    	}else{
    		$('#contentDiv').append("<div id='instructTip"+timestamp+"' ts='"+timestamp+"'></div>");
    	}
    	
    	
    	//回答DIV
    	if($('#anser'+timestamp)&&$('#anser'+timestamp).length>0){//存在
 			
    	}else{
    		$('#contentDiv').append("<div id='anser"+timestamp+"' ts='"+timestamp+"' class='anser anserCurrent'></div>");
    	}
    	
    	//分割线DIV
    	if($('#split'+timestamp)&&$('#split'+timestamp).length>0){//存在
    	
    	}else{
    		$('#contentDiv').append("<div id='split"+timestamp+"' ts='"+timestamp+"' class='split splitCurrent'></div>");
    	}
    	
		if(CanEdit){
			editAsk();
		}
		
		$.scrollTo('#ask'+timestamp,500);
		
		if(needES){
			//是否有指令识别
			if(obj.service){
				var keyDivObj=$('#ask'+timestamp).find(".keyDiv");
  				$(keyDivObj).attr("service",obj.service);
			}
			//意图缓存是否有结果
			if(resultData){
				loadIntenCacheData(timestamp,resultData);
			}else{
				if(clientType=="Webclient"){//网页搜索.
					loadData(timestamp);
				}else{
					//如果是非进一步的微搜,未识别语义
					if(!moreSearch&&obj.rc!=0){
		    			jsonDate.key=obj.text;
		    			jsonDate.maybe="true";
		    			afterDoFunction=true;
						doFunction=getAppList;
					}else{
						loadData(timestamp);
					}
				}
			}
			
		}
		
		if(afterLoad){
			showResultStr(timestamp,msg,true);
		}
		
		if(isQA){
			showAnswer(timestamp,msg);
		}
		
		if(afterDoFunction){
			if(doFunction){
				if(doFunction.name=="callTel"){//打电话
					var ts=$("#ask"+timestamp).prev().attr("ts");
				
					var rscDiv=$("#anser"+ts).find(".RSC");
					if(rscDiv&&rscDiv.length>0){
						if($("#anser"+ts).find(".RSC").length==1){
							var rscObj=JSON.parse($("#anser"+ts).find(".RSC").attr("obj"));
							if(rscObj.mobile!=""){
								showResultStr(timestamp,"正在呼叫为您呼叫"+rscObj.name,false);
								doFunction(rscObj.mobile);
							}else{
								showResultStr(timestamp,rscObj.name+"号码为空，呼叫失败",true);
							}
						}else{
							moreInstruct=true;
							msg="您要打给谁，请直接说出名字";
							InstructObj.type="CALL";
							InstructObj.doFunction=doFunction;
						}
					}else{
						moreInstruct=true;
						msg="您要打给谁，请直接说出名字";
						InstructObj.type="CALL";
						InstructObj.doFunction=doFunction;
					}
					
				}else if(doFunction.name=="loadMeetingAddress"){//加载空闲会议室
					doFunction(timestamp,InstructObj,"",jsonDate);
				}else if(doFunction.name=="getAppList"){//加载emobile应用
					doFunction("",timestamp,jsonDate);
				}else if(doFunction.name=="loadFeeType"){//加载科目类型
					doFunction(timestamp,InstructObj,"",jsonDate);
				}else if(doFunction.name=="showWFTodoListById"){//加载知道流程类型的待办
					showWFTodoListById(obj.hrmId,timestamp,obj.otherJson,obj.id);
				}else{//其他
					if(afterDoFunctionStandard){//新标准调用,通过传递格式.
						doFunction(InstructObj,baseJson,timestamp);
					}else{
						needHideToast=false;
						doFunction(searchKey,timestamp,jsonDate);
					}
				}
			}
		}
		
		if(moreInstruct){
			if(msg!=''){
				play(msg);
			}
			if(needHideToast){
				hideToast();
			}
			//移除之前标识的当前互动指令
			$('.currentInstructTip').removeClass("currentInstructTip");

			if(InstructObj.lastTarget){
				InstructObj.lastTarget=InstructObj.target;
				InstructObj.target=timestamp;
			}else{
				InstructObj.lastTarget=timestamp;
				InstructObj.target=timestamp;
			}
			
			
			if(cancel){
				$('#instructTip'+timestamp).append('<div id="instructTipObj'+timestamp+'" class="instructTip instructTipObj" target="'+timestamp+'" obj=\''+JSON.stringify(InstructObj)+'\' baseJson=\''+JSON.stringify(baseJson)+'\' style="display:none"></div>');
				$('#anser'+timestamp).append('<div class="instructTip" target="'+timestamp+'" >'+msg+'&nbsp;'+othermsg+'</div>');
			}else{
				if(InstructObj.action){//完结后的指令
					$('#instructTip'+timestamp).append('<div id="instructTipObj'+timestamp+'" class="instructTip instructTipObj currentInstructTip" target="'+timestamp+'" obj=\''+JSON.stringify(InstructObj)+'\' baseJson=\''+JSON.stringify(baseJson)+'\' style="display:none"></div>');
					$('#anser'+timestamp).append('<div class="instructTip" target="'+timestamp+'"  style="display:none">'+msg+'&nbsp;'+othermsg+'</div>');
					if(InstructObj.type=="WKP"){
						var content="";
	    				if(InstructObj.content){
	    					content=InstructObj.content;
	    				}
	    				var date="";
	    				if(InstructObj.date){
	    					date=InstructObj.date;
	    				}
	    				var time="";
	    				if(InstructObj.time){
	    					time=InstructObj.time;
	    				}
	    				var timeEnd="";
	    				if(InstructObj.timeEnd){
	    					timeEnd=InstructObj.timeEnd;
	    				}
	    				var id="";
	    				if(InstructObj.id){
	    					id=InstructObj.id;
	    				}
	    				var name="";
	    				if(InstructObj.id){
	    					name=InstructObj.name;
	    				}
	    				
	    				$('.currentInstructTip').removeClass("currentInstructTip");
	    				if(InstructObj.maybeType){
	    					if(equalsIgnoreCase(InstructObj.maybeType,"blog")){
	    						addBlog(InstructObj,baseJson,timestamp);
	    					}
	    				}else{
							addCalendar((id==""?"":(id+":"+name)),content+":"+date+":"+time+":"+timeEnd,timestamp)
	    				}
					}else if(InstructObj.type=="CALL"){
						$('.currentInstructTip').removeClass("currentInstructTip");
						load_SP_Data(rscTag,obj.text,"MOBILE",callTel,timestamp);
					}else if(InstructObj.type=="WF"){
						$('.currentInstructTip').removeClass("currentInstructTip");
						if(InstructObj.wftype=="Leave"){//请假
							addLeave(InstructObj,baseJson,timestamp);
						}else if(InstructObj.wftype=="Out"){//出差
							addOut(InstructObj,baseJson,timestamp);
						}else if(InstructObj.wftype=="Fna"){//报销
							addFna(InstructObj,baseJson,timestamp);
						}else{
							if(doFunction){
								doFunction(InstructObj,baseJson,timestamp);
							}
						}					
					}else if(InstructObj.type=="BLOG"){//微博
						$('.currentInstructTip').removeClass("currentInstructTip");
						addBlog(InstructObj,baseJson,timestamp);			
					}else if(InstructObj.type=="MEETING"){//会议
						//$('.currentInstructTip').removeClass("currentInstructTip");
						addMeeting(InstructObj,baseJson,timestamp);			
					}else if(InstructObj.type=="CrmContact"){//客户联系
						$('.currentInstructTip').removeClass("currentInstructTip");
						addCrmContact(InstructObj,baseJson,timestamp);
					}else{
						$('.currentInstructTip').removeClass("currentInstructTip");
					}
				}else{
					$('#instructTip'+timestamp).append('<div id="instructTipObj'+timestamp+'" class="instructTip instructTipObj currentInstructTip" target="'+timestamp+'" obj=\''+JSON.stringify(InstructObj)+'\' baseJson=\''+JSON.stringify(baseJson)+'\' style="display:none"></div>');
					if(msg==""&&othermsg==""){
						$('#anser'+timestamp).append('<div class="instructTip" target="'+timestamp+'" style="display:none"></div>');
					}else{
						$('#anser'+timestamp).append('<div class="instructTip" target="'+timestamp+'">'+msg+(othermsg==""?'':'&nbsp;')+othermsg+'</div>');
					}
				}
			}
			saveHistory();
		}
		//显示天气预报
		if(isWeather){
			showWeather(timestamp,obj.data.result,obj.semantic.slots.datetime);
		}
		
		//展示自定义报表,只能通过接口形式返回数据
		if(isShowReport){
			showReportUrl("",timestamp,jsonDate);
		}
		
		//首次弹出帮助闪动
		setTimeout(function(){
 			showFAQTips();
 		},1000);
		
	}
	//点击跳转页面
	function goPage(detailid,schema,url) {
		//点击前 保存下之前的对话内容
		saveHistory();
		if(schema!=""&&goPageObj[schema]){
			var temp_url=goPageObj[schema].url;
			if(schema!='WF'){
				temp_url=temp_url.replaceAll("fromES","fromVoice");
			}
			temp_url=temp_url.replaceAll("\\{ID\\}",detailid);
			if(schema=="FAQ"){
				temp_url+="&title=问题库";
			}
			
			if(schema=='WF'||schema=='DOC'||schema=='RSC'||schema=='WKP'){
				location=temp_url;
			}else{
				if(clientType!="Webclient"){
					openNewView(temp_url);
				}else{
					location=temp_url;
				}
			}
			return;
		}
	
		//直接传url
		if(url!=""){
			if(clientType!="Webclient"){
				openNewView(url);
			}else{
				location=url;
			}
			return;
		}
	 }
	 
	 /*
	 * 支持直接打开url
	 */
	 function openByUrl(InstructObj,baseJson,timestamp){
	 	hideToast();
	 	saveHistory();
	 	if(baseJson.url){
	 		var url=baseJson.url;
	 		if(clientType!="Webclient"){
				openNewView(url);
			}else{
				location=url;
			}
	 	}
	 }
	 
	 
      //App custom javascript
      $(document).ready(function() {
      		//异步加载初始化参数
      		getInstruction("<%=fixedInst%>");
	   		getInitParam();
      		getGoPage();
      		loadNewMsg();//是否有消息
      		var fixPositionTime=1000;
      		var topColorTime=0;
      		//加载消息
			if(isFullE){
      			firstShowMsgDiv();
      			fixPositionTime=3000;
      			topColorTime=1000;
		   	}
		   	
      		//改变头部颜色
      		if("<%=topColor%>"!=""){
      			if(topColorTime==0){
		      		try{
		    			location="emobile:changeTopColor:<%=topColor%>";
		    		}catch(e){}
      			}else{
      				setTimeout(function(){
	      				location="emobile:changeTopColor:<%=topColor%>";
      				},topColorTime);
      			}
      		}
      		//注册录音事件
      		record();
      		
      		//设置文字输入宽度
      		$('.textSendInputDiv').css("width",voice_text_input_width+"px");
      		registInput();
      		 
      		 
      		if(storage){
      			if(storage.getItem("validTime"+userid)&&(new Date().getTime()-storage.getItem("validTime"+userid))/1000<60){// 默认有效时间1min
					if(storage.getItem("contentDiv"+userid)){
						isScrollHelp=false;
						changePage();
						$('#contentDiv').html(storage.getItem("contentDiv"+userid));
						clearConfirm();
						$.scrollTo('.askCurrent',0);
						setTimeout(function(){
							$.scrollTo('.askCurrent',0);
							setTimeout(function(){
								$.scrollTo('.askCurrent',0);
							},300);
						},200);
					}
      			}else{
					storage.removeItem("validTime"+userid);
					storage.removeItem("contentDiv"+userid);
				} 
			}
      		
      		
      		$.event.special.swipe.horizontalDistanceThreshold = 60;
      		//$('#main').css("height",wH+"px");
      		//$('#start').css("height",wH+"px");
	     	$('#contentDiv').css("margin-bottom",(wH-footerH+20));
	     	
	     	//对ask增加tap事件
	     	editAsk();
	     	//list点击事件
	     	listTap();
	     	//list划动
	     	$('.result').each(function(){
	     		swipeList(this);
	     	});
	     	//帮助隐藏事件
	     	hideHelpDetail();
	     	//图片点击
	     	imgCarousel();
	     	//客户联系选择
	     	crmContactTap();
	     	
	     	customerService($('.currentCustomerService'));
	     	
	     	moreInfo($('.currentMoreInfo'));
	     	
	     	loadMoreInfo($('.currentLoadMore'));
	     	
	     	
	     	//初始化声纹条
	     	siriWave=new SiriWave({
				speed: 0.1,
				amplitude: 0.5,
				container: document.getElementById('WaveContainer'),
				autostart: true,
    			height: 70,
			});
			siriWave.stop();
		   
			if($('#hideLocation').attr("currentLocation")){
      			//页面已经记录当前定位
      		}else{
      			setTimeout(function(){
      				//fixPosition("asd,31.080176,121.526519,上海");
      				location="emobile:gps:fixPosition";
      			},fixPositionTime);
      		}
      });

     $(document).on("scrollstop",function(){
      	 if($('.askCurrent')&&$('.askCurrent').length>0){
			if($('.anserCurrent')&&$('.anserCurrent').length>0){//有答案.
				//alert($(".anserCurrent").height());
				//alert(wH);
				//alert(footerH);
				//alert($(".askCurrent").height());
				//alert(wH-footerH-$(".askCurrent").height());
				if($(".anserCurrent").height()-(wH-footerH-$(".askCurrent").height()-100)>0){//答案大于屏幕高度
					//屏幕高度
					var wH_Current=wH-footerH;
				    //答案高度+底部麦克风高度-窗体高度+(允许向上滚动半屏高度)
					var diff=$(".anserCurrent").height()+$('.voicefooter').height()-wH+wH_Current;
					
					if(($(document).scrollTop()-diff)>$(".askCurrent").offset().top){
						//$.scrollTo('.askCurrent');
					}
				}else{
					 if($('#split'+$(".askCurrent").attr("ts"))&&$('#split'+$(".askCurrent").attr("ts")).next()&&$('#split'+$(".askCurrent").attr("ts")).next().hasClass("newMsg")){
					 
					 }else{
						 if($(document).scrollTop()>$(".askCurrent").offset().top){
						 	if(noScroll){
							 	$.scrollTo('.askCurrent');
						 	}
						 }
					 }
				}
			}
      	 }
	 }); 

	 $(document).on("pageshow","#main",function(){ // 当进入对话页面.滚动到提问
	 	if($('.askCurrent')&&$('.askCurrent').length>0){
		  	$.scrollTo('.askCurrent',0);
	 	}
	 	$('#helpContent').css("height",(wH-$('#helpTip').height()-footerH)+"px");
	 	$('#helpDetail').css("height",(wH-footerH)+"px");
	});
	
	
	//返回
	function doLeftButton() {
		if($('#contentDiv').css("display")=='block'){//显示对话内容
			if($('#contentDiv').html().trim()!=""){
				//saveHistory();
			}
			//startTarget
			clearConfirm();
			return "close"
		}else if($('#msgContentDiv').css("display")=='block'){//消息对话框
			return "close"
		}else{
			if($('#scrollHelpContent').css("display")=='block'){//滚动帮助
				return "close"
			}else{
				if($('#helpDetail').css("display")=='block'){
					showHelp();
				}else{
					hideHelp(currentContentDiv);
				}
				return 1;
			}
		}
	}
	
	//初始化帮助滚动区域
	var scrollHelpSize=6;
	function initScrollHelp(){
		 var scrollDiv = $("#scrollHelpDetail"),
        $ul = scrollDiv.find("ul"),
        $li = scrollDiv.find("li"),
        $length = $li.length,
        $liHeight = $li.height();
		
		$('#scrollHelpContent').css("height",(wH-footerH)+"px");
	    var scrollHelpTipHeight=$('#scrollHelpTip').height();
	    var scrollHelpDetailHeight=wH-footerH-(scrollHelpTipHeight*3/2);//帮助滚动窗体高度
	    var size=parseInt(scrollHelpDetailHeight/$liHeight);//页面最多展示个数
	    scrollHelpDetailHeight= $liHeight* size ;//避免出现一半
	    scrollHelpSize=size;
	    $('#scrollHelpDetail').css("height",scrollHelpDetailHeight+"px");
	}
	
	var scrollHelpInterval;
	//帮助滚动
	function scrollHelp(){
		if(scrollHelpInterval){
    		try{
    			clearInterval(scrollHelpInterval);
    		}catch(e){}
    	}
    	//判断当前页面,是否有对话内容
 
    	if(isScrollHelp){
	    	//判断是否有帮助内容 
	   		var scrollDiv = $("#scrollHelpDetail"),
	        $ul = scrollDiv.find("ul"),
	        $li = scrollDiv.find("li"),
	        $length = $li.length,
	        $liHeight = $li.height(),
	        num = 0;
	        $ul.removeClass("animate").css("-webkit-transform","translateY(0)");
	        //$($li).removeClass();
	        
	        
		    var size=scrollHelpSize; 
		    var eachtime=1/size; //1秒内全部出现,计算每个时间间隔
	    	
		    if($length > 1){
				$('#contentDiv').hide();
				$('#helpDetail').hide();
				$('#help').hide();
				if(!isFullE){
					$('#scrollHelpContent').show();
				}
		        scrollHelpInterval=setInterval(
		            function(){
		            	num=num+size;
		            	if(num>$length){
		            		num=$length;
		            	}
		            	var i=0;
		                
		                $ul.addClass("animate").css("-webkit-transform","translateY(-"+ $liHeight*(num) +"px)");
		                 
		                //对进入显示内容特效
		                for(var sli=num;sli<num+size;sli++){
		                	
		                	scrollHelpLiIn($($li)[sli],eachtime*i*1000);
		                	i++;
		                }
					    
		                setTimeout(
		                    function(){
		                        if(num == $length){
		                            $ul.removeClass("animate").css("-webkit-transform","translateY(0)");
		                            num = 0;
		                            i=0;
		                            for(var sli=num;sli<num+size;sli++){
					                	$($($li)[sli]).addClass("currentLi");
					                	scrollHelpLiIn($($li)[sli],eachtime*i*1000);
					                	i++;
					                }
		                        }
		                    },200);
		            },15000);
		    }
    	}
	}
	
	function scrollHelpLiIn(obj,t){
		if(obj != undefined){
			$(obj).addClass("currentLi");
			setTimeout(function(){
				$(obj).removeClass().addClass('fadeInUpBig animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
			      $(this).removeClass();
			    });
			    $('body').removeClass("ui-mobile-viewport-transitioning").removeClass("viewport-pop");
		    },t)
		}
	}
	
	
	function changePage(){
		//$.mobile.changePage("#main",{transition: "pop"}); 
	}
	
	//用于客户端回调音量监控
	function changeVoice(str){
		hasVoiceMonitor=true;
		try{
			var voiceH=(parseFloat(str)/10);
			if(voiceH==0){
				voiceH=0.1;
			}
			if(siriWave){
				siriWave.setAmplitude(voiceH);
			}
		}catch(e){
			if(siriWave){
				siriWave.setAmplitude(1);
			}
		}
	}
	
	
	//重新加载localStorage的值
	function reloadStorage(){
		//ToastInfo("加载localStorage",1);
	   	if(isFullE){
	   		if(!firstLoadMsg){
		   		showMsgDiv();
	   		}
	   		
	   		//try{ checkHtmlHasChange(); }catch(e){};
	   		
	   		//if(storage.getItem("weaver-voice-html-refresh")&&storage.getItem("weaver-voice-html-refresh")=="true"){
	   		//	storage.setItem("weaver-voice-html-refresh",false);
	   		//	saveHistory();
	   		//	location=window.location.href;
	   		//	return;
	   		//}
	   		
	   	}
	}
	
	//返回遮罩层的等待时间以及提示信息
	function getMaskTime(){
		//\n小贴士:我的待办. 追加随机帮助.
		return '{"time":"'+maskTime+'","tips":"'+maskTips+'"}';
	}

    
 	//消息绑定滚动事件
	$("#msgContentDiv").on("scroll",function(){
		if(isFullE){
		 	if($('#msgContentDiv').scrollTop()+msgDivHeight>=$('#msgContentChild').height()){
		 		getMsgListByPage();
		 	}
		 	if($('#msgContentDiv').scrollTop()>73*msgPageSize-msgDivHeight){//有第二页内容出来.
		 		onlyFirstPage=false;
		 	}else{
		 		onlyFirstPage=true;
		 	}
		}
	});
	
	//消息回到顶部
	function msgUpToTop(){
		$('#msgContentDiv').scrollTop(0);
	}
	 
    //通知有新消息
    function noticeNewMsg(num){
    	if(isFullE){//非全屏小e不加载消息列表
    		if(!firstLoadMsg){//如果第一次还未加载,忽略消息通知
    			needLoadNewMsg=true;
    		}
    	}
    }
    
    //首次加载消息,显示消息视图
    function firstShowMsgDiv(){
    	if(isFullE){
			$('#msgContentDiv').css("height",msgDivHeight+"px");
    		needLoadNewMsg=true;
    		isMsgDiv=true;
    		$('.contentDiv').hide();
	    	$('#msgContentDiv').show();
    		startLoadMsg();
    		
    		setTimeout(function(){
	    		//启用定时线程读取消息..
	    		loadMsgInterval=setInterval(function(){
					startLoadMsg();
				},readTimeInterval*1000);
    		},2000);
    	}
    }
    
	
    //获取消息,显示消息视图
    function showMsgDiv(){
    	if(isFullE){
	    	$('.contentDiv').hide();
		    $('#msgContentDiv').show();
		    hideHelp($('#msgContentDiv'));
		    isHelp=false;
		    hideMsgBtn();
	    }
    }
    
    //显示消息按钮
    function showMsgBtn(){
    	if(isFullE){
		    isMsgDiv=false;
			location ='emobile:{"func": "ChangeMsgButtonStatus","params": {"status": "1"}}';
			setTimeout(function(){
				location ='emobile:{"func": "ChangeMsgButtonStatus","params": {"status": "1"}}';
		    },1000);
		}
    }
    
    //隐藏消息按钮
    function hideMsgBtn(){
    	if(isFullE){
    		isMsgDiv=true;
			location ='emobile:{"func": "ChangeMsgButtonStatus","params": {"status": "0"}}';
		}
    }
    
    //调用手机端进行读取消息
    function startLoadMsg(){
    	if(currentPageTime && (new Date().getTime()/1000-currentPageTime)>5){//页面超过5秒轮询,应用被睡眠了
    		$('#msgContentDiv').scrollTop(0);
    		//检测时间,防止消息列表时间显示不正确
			try{refreshTime();}catch(e){}
    	}
    	currentPageTime=new Date().getTime()/1000;//页面记录当前活动时间(秒)
    	//有新消息通知
    	if(needLoadNewMsg){
    		if(isMsgDiv && onlyFirstPage){//消息界面,第一页
	    		isEnd=false;
	    		getMsgListByPage(1);//首次加载第一页
    		}else{
    			if(lastLoadMsgTime&&currentPageTime-lastLoadMsgTime>3&&isLoading){//判断是否长时间未加载,且消息一直处理loading中. 加强处理
    				getMsgListByPage(1);
    			}else if(lastLoadMsgTime&&currentPageTime-lastLoadMsgTime>5&&onlyFirstPage){//在第一页,超过5秒未加载数据,且有新消息通知.强制加载
    				getMsgListByPage(1);
    			}
    		}
    	}
    }
    
    //分页获取消息列表
    function getMsgListByPage(page){
    	if(page==1){//加载第一页
    		isEnd=false;
    		msgCurrentPage=1;
    		lastLoadMsgTime=currentPageTime;
    		location ='emobile:{"func": "conversationListDataSource","params": {"pagesize": "'+msgPageSize+'","pageindex": "'+page+'","callBack": "getMsgList"}}';
    		//getMsgList(page,'10','[{"icon":"","title":"黄冠冠","desc":"oooo","time":1514444544998,"unread":2,"noDisturb":"1","sessionId":"242|ujchgxhx","type":1},{"icon":"","title":"群聊","desc":"[附件]:sdk_rclist.txt","time":1514441229559,"unread":2,"noDisturb":"0","sessionId":"243|ujchgxhx","type":2},{"icon":"","title":"日程","desc":"[附件]:sdk_rclist.txt","time":1514440967640,"unread":0,"noDisturb":"1","sessionId":"239|ujchgxhx|schedus","type":1},{"icon":"","title":"流程","desc":"流程:(系统管理员)腾讯微信交互提醒","time":1514422811483,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|1","type":1},{"icon":"","title":"邮件","desc":"流程:(lyx02)ze03(2017-01-23 11:39:45导入)-lyx02-2017-","time":1514356449124,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|mails|6017","type":1},{"icon":"","title":"会议","desc":"流程:(lyx02)tcytest01-lyx02-2017-12-27","time":1514356448665,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|meetting|6718","type":1},{"icon":"","title":"盯办","desc":"流程:(lyx02)liuy_test020（clob测试）-yuanaaaa-lyx02-201","time":1514356448050,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|ding|102","type":1},{"icon":"","title":"小e工作台","desc":"流程:(lyx02)liuy_test020（clob测试）-yuanaaaa-lyx02-201","time":1514356448050,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|notice|-1","type":1},{"icon":"","title":"提醒","desc":"流程:(lyx02)liuy_test020（clob测试）-yuanaaaa-lyx02-201","time":1514356448050,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|102|notice","type":1},{"icon":"","title":"文档","desc":"流程:(lyx02)liuy_test020（clob测试）-yuanaaaa-lyx02-201","time":1514356448050,"unread":10,"noDisturb":"1","sessionId":"ujchgxhx|doc|102","type":1}]')
    	}else{//加载更多
	    	if(isEnd||isLoading){
	    		return;
	    	}
	    	if(!page) page=++msgCurrentPage;
    		isLoading=true;
    		lastLoadMsgTime=new Date().getTime()/1000;
    		location ='emobile:{"func": "conversationListDataSource","params": {"pagesize": "'+msgPageSize+'","pageindex": "'+page+'","callBack": "getMsgList"}}';
	    	//if(page==3){
	    	//	getMsgList(page,'10','[{"icon":"","title":"老广播","desc":"oooo","time":1514444544998,"unread":2,"noDisturb":"1","sessionId":"SysNotice|2421|ujchgxhx","type":1},{"icon":"","title":"系统广播","desc":"[附件]:sdk_rclist.txt","time":1514441229559,"unread":0,"noDisturb":"1","sessionId":"2433|ujchgxhx|sysnotice","type":1},{"icon":"","title":"lyx00","desc":"[附件]:sdk_rclist.txt","time":1514440967640,"unread":0,"noDisturb":"1","sessionId":"2394|ujchgxhx","type":1},{"icon":"","title":"系统默认工作流","desc":"流程:(系统管理员)腾讯微信交互提醒","time":1514422811483,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|11","type":1},{"icon":"","title":"zehy测试类型","desc":"流程:(lyx02)ze03(2017-01-23 11:39:45导入)-lyx02-2017-","time":1514356449124,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|60117","type":1},{"icon":"","title":"tcy-test","desc":"流程:(lyx02)tcytest01-lyx02-2017-12-27","time":1514356448665,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|67118","type":1},{"icon":"","title":"liuy类型9876543","desc":"流程:(lyx02)liuy_test020（clob测试）-yuanaaaa-lyx02-201","time":1514356448050,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|1012","type":1},{"icon":"","title":"liuy类型9876543","desc":"流程:(lyx02)liuy_test020（clob测试）-yuanaaaa-lyx02-201","time":1514356448050,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|1202","type":1},{"icon":"","title":"liuy类型9876543","desc":"流程:(lyx02)liuy_test020（clob测试）-yuanaaaa-lyx02-201","time":1514356448050,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|1402","type":1}]')
	    	//}else{
		    // 	getMsgList(page,'10','[{"icon":"","title":"lyx03","desc":"oooo","time":1514444544998,"unread":2,"noDisturb":"1","sessionId":"2422|ujchgxhx","type":1},{"icon":"","title":"lyx04","desc":"[附件]:sdk_rclist.txt","time":1514441229559,"unread":0,"noDisturb":"1","sessionId":"2434|ujchgxhx","type":1},{"icon":"","title":"lyx00","desc":"[附件]:sdk_rclist.txt","time":1514440967640,"unread":0,"noDisturb":"1","sessionId":"2395|ujchgxhx","type":1},{"icon":"","title":"系统默认工作流","desc":"流程:(系统管理员)腾讯微信交互提醒","time":1514422811483,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|12","type":1},{"icon":"","title":"zehy测试类型","desc":"流程:(lyx02)ze03(2017-01-23 11:39:45导入)-lyx02-2017-","time":1514356449124,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|60127","type":1},{"icon":"","title":"tcy-test","desc":"流程:(lyx02)tcytest01-lyx02-2017-12-27","time":1514356448665,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|67128","type":1},{"icon":"","title":"liuy类型9876543","desc":"流程:(lyx02)liuy_test020（clob测试）-yuanaaaa-lyx02-201","time":1514356448050,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|1022","type":1},{"icon":"","title":"liuy类型9876543","desc":"流程:(lyx02)liuy_test020（clob测试）-yuanaaaa-lyx02-201","time":1514356448050,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|1302","type":1},{"icon":"","title":"liuy类型9876543","desc":"流程:(lyx02)liuy_test020（clob测试）-yuanaaaa-lyx02-201","time":1514356448050,"unread":0,"noDisturb":"1","sessionId":"ujchgxhx|wf|1052","type":1},{"icon":"","title":"liuy类型9876543","desc":"流程:(lyx02)liuy_test020（clob测试）-yuanaaaa-lyx02-201","time":1514356448050,"unread":10,"noDisturb":"1","sessionId":"ujchgxhx|wf|1602","type":1}]')
	    	//}
    	}
    }
    
    /*json特殊字符转义处理.防止script注入*/
	function jsonSpecialString(string) {  
	    return string.replace(/(\n|\r|\t)/g, " ").replaceAll("<","&lt;").replaceAll(">","&gt;");  
	}

    //手机的回调地址
    function getMsgList(pageindex,pagesize,array){
    	//读取消息后,改变状态标识.用于下次读取标识
    	needLoadNewMsg=false;
    	isLoading=false;
    	var hasMsgError=false;//是否有消息加载异常
    	lastLoadMsgTime=new Date().getTime()/1000;
    	if(array){
    		var list;
    		//ios兼容转码.
			try{
				array=decodeURIComponent(array);
			}catch(e){}
			//去除特殊字符,过滤html注入
			array=jsonSpecialString(array);
			
			try{
				//list= JSON.parse(array);
				list=eval("("+array+")");
			}catch(e){
				msgError=true;
				alert("第"+pageindex+"页消息转换异常:"+e.message);
			}
    		if(list){
    			var size=list.length;
    			if(firstLoadMsg){
    				firstLoadMsg=false;
    				if(size==0){
    					hideHelp($('#scrollHelpContent'))
    					showMsgBtn();
    				}else{
    					hideMsgBtn();
    				}
    			}
    			var msgHtml="";
    			if(pageindex==1){
    				msgSessionId="";
    				newMsgSessindId=",";
    			}
    			
    			$.each(list,function(j,item){
					var isLast=(j==size-1)?"lastLi":"";
					if(msgSessionId.indexOf(","+item.sessionId+",")==-1){
						msgHtml+=showMsgItem(item,isLast);
					}
				});
				if(pageindex==1){//第一页.进行清空历史数据.
					$('#msgContentChild').html("");
				}
				if(newMsgSessindId!=","){
					msgSessionId+=newMsgSessindId;
				}
				newMsgSessindId=",";
				
				$('#msgContentChild').append(msgHtml);
	     	    $('#msgContentChild').find('.ul-li-div').css("width",ul_li_div_width+"px");
	     	    $('#msgContentChild').find('.first-title-span').css("width",ul_li_div_width-100+"px");
	     	    $('#msgContentChild').find('.second-desc-span').css("width",ul_li_div_width-50+"px");
	     	    
	     	    $('#msgContentChild').find(".am-list-item").off("tap touchstart touchmove").on("touchstart",function(){
	     	    	if(!tapLock){
				   		$(this).addClass("am-list-item-hover");
	     	    	}
				}).on("touchmove",function(){
			   		$('#msgContentChild').find(".am-list-item").removeClass("am-list-item-hover");
			   	}).on("tap",function(){
			   		if(!tapLock){
			   			tapLock=true;
						var obj=this;
						setTimeout(function(){
							$(obj).find(".msgUnReadTag").find("div").remove();
					    	var targetId=$(obj).attr("targetId");
					    	var targetType=$(obj).attr("targetType");
					    	var targetName=$(obj).attr("targetName");
					    	$('#msgContentChild').find(".am-list-item").removeClass("am-list-item-hover");
					    	tapLock=false
					    	location ='emobile:{"func": "openConversation","params": {"targetId": "'+targetId+'","type": "'+targetType+'","title":"'+targetName+'"}}';
					    },200);
			   		}
			   	})
		     	
     			if(list.length<pagesize){
     				isEnd=true;
     			}
    		}else{//无数据,判断第几页.
    			if(!hasMsgError){//无消息加载异常,已经到最后一页.
	    			isEnd=true;
    			}
    		}
    	}
    	firstLoadMsg=false;
    }
    

    //会议消息展现样式
    function showMsgItem(item,lastLi){
    	//判断图标
    	var icon=item.icon;
    	var id=item.sessionId;
    	newMsgSessindId+=id+",";
    	if(!icon||icon==""){
    		if(item.type==2){//群聊
    			icon="/mobile/plugin/fullsearch/img/blue/v_msg_group_wev8.png";
    			icon="data:image/png;base64,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"
    		}else{
	    		if(id.indexOf("wf|")>-1){//流程
	    			icon="/mobile/plugin/fullsearch/img/blue/v_msg_wf_wev8.png";
	    			icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEYAAABGCAYAAABxLuKEAAAE6ElEQVR42u2c20sUURjAhaCn/oAgCIIg6FXoDwh6CgJBKWdMInqp6KGniIjaXW2ToKtImhRFllhGEdJDdJHKnfGWed1c856iuV4y0anV0/nO7piX2XF29pwzZ7Y98KG7O3suvz3z3c45k5GRLukibCmoy9/mVWXJq8geb0Cq8CpSY0wiWFBMIsvvk2vwtfg78N2UguFTc/fiAd7CAw2tGLxdCUFdUKcrYVysz9mKf2m/V8kdpgAjjkDdsh/aEh/Iu5wtZOor0iw7IOtkFtqEtoUDUlWVs8kXkI57VWmcI5DVgtuGPkBfhIDiUQ/tp6Q/aEkI+uTcbdORszmmVJGQgvsGfeRvdqMmFQkujdzMvK8hbxf+NQZcAEWfOQPQZ8YzRdqDGwu7Bso/gT5nstEpirzbUatDwWrBGBjoFJbOGi/JHaamc4j1cYeitayQqVgroU1yEqY8OQsUyDuQclBi4lHlrCTinlTQK/H1ja34Khod8+vovQ4P6ppsQFpkHkGZWhgnr5+Fihm2K/sTzKEc3oG/qPEA4lPzkDr6isBYWlpEI796UdPYG9Q/04kWInPk/Z6pFlTUcIxF+xqMNQHdIpXzgtI28Wl58NeaT676/HLDURQYqSGfV4dusukDHmsicZDGEwr8hdfxri1uOc2yL5ol3wZr6wKRoHCyUAUbJpxYB4iiQdEDTdMEF0lc/29QlvtmkmD3qFIJSyhffnwQEkr0dpJKTHwXKZhsAw86C9Ht1jNxocBf0aDEJGjs6Tbmb6fRwNzvGeKkgcPmIihEgMH62yggH6RRue6UAZz7nT7XQCE/oiJnMzPTAGZifoTMHL20jNeaQrnTdo54u3bkYZefrdn2KVIlLTDdU81EzwCcjaCA6CGBnTI6109xxkiVRoq3kSYY+P9G8ylLt8+l+iOob6adDPT90FPLbY3NDRKhmcQyAtNLG0wiYgcOfTDyqBGYsJNgQGqHqwmYwZ9BVKjmOzFjZo3AaE6CgVkCZWi2m0TVDt1KSCgwOhSYKVahMAKjCXMr2YXCCEzYaDVggDeYZKAwAYMZcDHXZgLZOt0JfBy8YqstgAI6iam5pu3gWblWdwL/LGok+LQDBmYbUwePZkgwrU1Ydukh6Q0F4EBosFH9kPt9O1TFBIxhSBDdZpp85ZDlt1tefiszrRuWUmAlQXcCqYPBgTSztAMr0aHAepM+y+A1TTCGaYeYAg6JDgWUNoQPOhyKYEKOpDZpQVkZW32dbCLrTsxTmx4ld5+oUCBSZ5rzxWM3Xz4RZCGfJxQY84b7g3kv5sczyfygWFzcj1knzWko4AvxgSJpca2RU4v6a+VJ93XeUKwv6q/YBhKh2YGKYBFZaFu7o0GXmr673KHAGC/U5e10dOPQ854SMnAIGcClh3Wnstaz5NaBLSBQYHWBI5TENw6x2mpW3n6eDH5tAWAfv78gvonwW82iEbeczaJTECxCXPR64BFJOVxtOiHG4lp6O2uS21n1DdA+RfqcKlBgLNSO6xAr5eZzBCtPwSWyGdGalZIysUy7GMw0sxMobj6WA31ne+QPjue47CAX9eM4ZvGUGxQyUbRW46D0YVFux4vlLPGOF9s8WcJi9pAD6c4q5jD0wdFZkn6EQfqhFwx1UDTBXkppxxbUUWqauHZjMXqwjpHZj72X2g/WSZcUK38Bh7bvoYIOF8wAAAAASUVORK5CYII=";
			   }else if(id.indexOf("|schedus")>-1){//日程
			    	icon="/mobile/plugin/fullsearch/img/blue/v_msg_wkp_wev8.png";
			    	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEYAAABGCAYAAABxLuKEAAAE+UlEQVR42u2cz2sTQRTHBwo9eSiCUCgUhYJQEIRCQRAUwVOhWCgIPQmC0JP+B1Io9OihIAgFT4J4EW1S8RdFqy1oIFoRKpGWYKAYjFZTKtHION/Mjtmss5vdnZn9kWbgkexmdn589s178zOEdEM3JDbQRTJAs2SKZsgM+36LfeYsqTOhltT/3edxZhrPsGc7C8YSOcMqN8+kYKt8WCk00mJpphNGlvSzNzzHKlHSAMNNSo08WF7JB3KHHGiofoZUDQJxSrWRJ8s7iUB6WOGmmZQjBOKUcqMMrCzJgJIhY5rshy5BWcbi1JJey6jShMo8yhi92+UulSZccpG5efqAHGUZFlMARUgRZTatKaMso0qKoAhBmUdMddSGY/Y66l6L1cGETSmlGIq9Uzig0/vkOgBK0yDr8FYJd8mhXbkqlHFthVkZoXSpN/40hCySCZVxj7pdWT1Jaa1MG+F3ldLcRDxpyOxNmPGVNTpWyzzbQ+nPEq+Q+ETFHh6MNg13rZkLBuU+OcIerCln/LifVwRvGxX8nufXL0ajTcNdaqhrENuyECqj5SFuB4S8GuOV2Cvy3ysr/PrtxdZ4XuI3DeQdDs5CkD5LMG2BWu/kqGtwVipM8JMGyvDoUHCt8dO3YRFnA1Pfmm/aABROyI91eaV2N1rjeYnfNIT9QVmCa82snwmn4APEzxleqNfjrfefDDSB4frrKr9+ecJ/2n7TQN4IKEuYgabXBJc1cU1Dg4E9cHoUeBCETzcp/VPj34Oou980hC0KB4Z6TrCzCNe1goG8m261Ax/ngqfvJw1VMKzuXoZ3QzsY0WNdv0Tp2im1Xq9XGqpgWN3doAyGLrQAs1vwb1R1C/JW0xjAGZSBOa8MJglBDcykHjftBPP+sv+Om25B3qpgZG6bZsltZTBuNiYKUTe+FAxkGpPb92AYAxmYTeNgnh+n9MNVLm8usKFEnzze08OsaVxpH08/mG0ZmIpRMOicOcOvbxyWPV7uHL/fLp4ZMFUZmJoxMHjroucq3v7aaV7hva3WuLiHqQVojdAeXOO+eTA0WjDbd/8HYAcmtAGwEKA1Ti1CwO9mwdSib0qypiBAiAojDgKAeQE0B6YiA1OM3CttXuPP2Y3rl2XebAADwPCJa9w335SK8btroR2A0zLp1cebndP4tvNMxtx1lB08QBFG1l5hGFphkO0ag+t2cAx28GYjAeMGxa1pCWAy7dKvMdIhwZRxMMKIwl7I3j7uu9kSr990gWEDaTPTDl5g7H0Ztzhubh2C+/jdLJhBtxm8ghEwoh/i1RTs8DAcsN/HtcyN6wVTiHZqU7xtr4AxkXPogGfQdMSzXppmfGozS84aASMGjm7i7NFCM9BsAAafXpqiCwyre7vlk9I+nHYotd0fHGoxP+1g/CzuW96pto/A1Fy9kfKivttKZJQSfiVyIeg2kHrgtWusL8e1fIK8g69d1+k9MmRu4xCWS8Xie5wBZQiy/Bt041DorWbPjsW3fIK8o9hqZmnNZAfu2HRfXOtuZ1XczmrbAJ3vICh5bcd1LC9V7gAo5UCbEX02qREmOymGsmPuBEqaj+Wwsps+Rz2cuoNcuo/jtBlP5VNhaP2Og7qHRaM7ODqRuOPFYU+WGNKe6ZgNc8U6kN5Lkha6f2HQ/dMLLZAwwX5DacdWUzYbaXlNXKcSkvyPdfJSN9vpf6zTDR0W/gLrqv2g8lHXSAAAAABJRU5ErkJggg==";
			   }else if(id.indexOf("|mails")>-1){//邮件
			    	icon="/mobile/plugin/fullsearch/img/blue/v_msg_email_wev8.png";
			    	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEYAAABGCAYAAABxLuKEAAADzklEQVR42u2cQYvTQBSAFwRP/gBBEARB8LrgDxA8CcLCFu2k7t0fIWuTQhGPQnFhEQRXlz3pVQ+e3CZa2IOrFLoKhYogVheLaDQS56Xp2t1O0kzmTZJJMvBgtzR5b75O3ps3My8LC2UrW2ZbY3vllG5pRDe1ut4mG7pJOr44VFxfnIPPve/Q79Jr4NpcwTCs6kXawbu0o72pzseVHtwL7qkkjFuvKifpL93UzeoAAUaAwL21JujKPpAXlRPe0DfJSB6QGRmBTtCdOSBbW5VjRpvc0C3yOUEgh4XqBhvAlkxAqVvXLiP5DyzpgU3pPTZvK8d9p+pmUqhtYGPyYXccUt2MSyexMG+8rp2jv0ZfASiTkdMHmyWPFHKBKhsqA+W/gM2LcnyKqZ1PNeogRC3ogwSfInOylpRUB2g+x4s+ajjayA4ZJVplOiQLhHKxCNSuXckdFF/qlrYkkPfkwa8E+5tY+dU4O84rlIloTc41lOtn6IV2/sEQG/rK4VvIegGgeAJ95cmD7KKAgb5GmttQb92Iq+TBO8P9ONpzk26gE3QLRKjG3AUnkQRx9Pubm1YD3SKJZugCl7dwLTAsJw3+noyc5/1H6MP//u6qazs/vfuv7948pDe2rwlbYK9bpIUF5sle6+B/TDjTUN58eTmjN/7jRFohcxfSxQID8vT9PVQ4R6EYVg0NDPSdPdPtrJwWNZxlIBacICiIYFxgMPsYtbWrMsBgwAmDggnGMLVl1DAdxcC4cADKL+dHIBRMMMywbZhkUyaYOHCiQMEdMWST5Xg7ssHwwIkKBRMMMGCB+ZAEmChweKDggtE+scAMkwITBocXCvKIGbHA2EmCYcGBWSwvFGQwbibAHIXz56/NDQUZjJ36oxQEhxcKMpghazegnxYYkMfdO+6z/kNuKKhgKIPUwrUMkRquk5jgZR0Mc4InOyVQAQwzJRgfMy04GJpIJ7bsoBIY5rKD74B7BQbTS2RpUzUwoUubdbN6qbBgaN/Dt08ENvLVBVMdzD0fLLKZ/93+mtq+EuiWurnvR6dYCeVG93Yqm26gE3THTRwDo1G5qc93DMQpABhndbt2tjw4JHpwqDxqNu+RMrXl3PoW1uZaeZxV8Djr5AC0YZKd/IwUsoNWruNFKZXrCKar4HgOI0aLUmSRyr7CYPalVaCoXJYDtsst+YPyHMUKudDLccLyKRUcsudoo+ZBZbFoYuXF2lL2yotjVpbIGD1eQXq6jnkINqQ6SspXGJQvvZDog8YL7GsYJ7b8e6yFLlyr2Fgv1mGFff+zfL9Yp2w5a/8AX/Ri+5FP7ToAAAAASUVORK5CYII=";
			   }else if(id.indexOf("|meetting")>-1){//会议
			    	icon="/mobile/plugin/fullsearch/img/blue/v_msg_meeting_wev8.png";
			    	icon="data:image/png;base64,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";
			   }else if(id.indexOf("|ding")>-1){//盯办
			    	icon="/mobile/plugin/fullsearch/img/blue/v_msg_ding_wev8.png";
			    	icon="data:image/png;base64,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";
			   }else if(id.indexOf("|notice|-1")>-1){//小e工作台
			   		icon="/mobile/plugin/fullsearch/img/blue/v_msg_EAssistant_wev8.png";
			   		icon="data:image/png;base64,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";
			   }else if(id.indexOf("|notice")>-1){//提醒（通用型通知消息，暂时包含任务提醒）
			    	icon="/mobile/plugin/fullsearch/img/blue/v_msg_notice_wev8.png";
			    	icon="data:image/png;base64,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";
			   }else if(id.indexOf("|doc")>-1){//文档提醒消息
			    	icon="/mobile/plugin/fullsearch/img/blue/v_msg_doc_wev8.png";
			    	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEYAAABGCAYAAABxLuKEAAAEH0lEQVR42u1cS2/TQBCukBAC8RMoIB4XJCQ4AH8ACXqEW/k1FXXSlia2GyillOcdoUj8Ay6c2nIAUQkh9REqUTVN4t0kdaN22UlsVAXHceNZe9f1SCP1Yc/sfN6dndmd3aGhlFKSliaM6iXNoKMZg05mTPJRM8lSxiAlzoQzc5g4f1vmXIRn4R14NzFAjI2xE+MGvavp5CU3cuOQ8YPyBsgCmSBbOUCmCo1z7V5hkHUEMHqC1O5N+caw9ICMF6qXNZ2+4o22BQLSzTboBN3yDZnZrbMZnT7hjWxFCEg3tzKmlYO2SAGKplsPkPwH2hDLGuRhbIDoOjvtDBsmI0PboI2RgjI50zzvTKdMcl6GtkYCCp8JbnCFmwqA4vImtFlsgGbWb3FFFYVAcbmSNWt3hIDyWKfXuYKqgqC4XEXvOZ2ATaqZZ+AZC2zBiVHm2RlFHG1ghww2IcQp8k7JgzN9jRG8sSQy2DZ4mN9J/1lCuTRQ+qAZ1nQYxXNv62zlZ4vt2gcsDH3+YosDh+dWR4tX9NqVMAnhi3d11twNB0hE4LTA1sgcLvQUl8qVffbhU5PlZumRZBwGRSQ4YGswUPKN4bDrKe7w2d7ZZ/nndCAZLsHPgsGxAy12aQadCqvMJegpYWW4v4sEB2z2BWV+np3MGuQPFjBHHT5+wIgEB2wG232cLr2PocjLKCwZwnqOSe/5LCmQBdmA8ep1gsBZ8ANmTRZg6o2Df8ZPP4sEnLWem2FY6GMA8+1HK3Ccg9Vuz029zg6hPMDoc5R9X2kxO0DkjDg7jQqZpjGBiUOPZtIJL/9SPO7AAAZewCymPYYseQBjrYps8G6ApBKeifkDbHr1mO0UGGJ5AWOnPoawFJgemXbkQ0kRYMpSOt+j+h58YKzVyKdrNYAhi2mAFzjA61REHXNg6KT0SWQska9XEil62UEFH9Ozlhir/FRRYNaVWNqMQY/f0mZ95PgCUx9RYvukH8M6MBYwfbdPsKZtjA23fgyysYDpu+GGvkVbHnyL1o9BJsgGsvcOQieOgc8jYG7qw/41fN1phGEFMkAWyHQJdEWyqY9SBvIetwykF4EO0BVZGUjb15hWLsyXgBoZ+Jq2jQ8QyATZoCOc07XyaakZVqlZ0osTQ59Q0Uz6JnEVm9wmlAJozSBfEwMKtwWlALqTeVcucqFbCQBmS8s1L+CePMnXb6p+yAJsEHTMr3YbVtIVBKUs7FiOS9kCuSb42DA2r0Ob06N/XY4W3af0o0KBncrq5KnMJ0zQZp8QQaBMEXIp1uPF/6UPndwq1gPpkPtIcyC9OyuP7QqDmdpV6e946Cx2tS+9EHmOsqTMpRe9rklxdh9QrkkBWcpek+J3sU5Gp4+cCtGik4P9PnSxzh7nHc6/nP8V28/ydxJ1sU5KCaS/Yah+62xDpPQAAAAASUVORK5CYII=";
			   }else if(id.indexOf("SysNotice|")>-1){//系统广播消息(以前老得广播)
			    	icon="/mobile/plugin/fullsearch/img/blue/v_msg_broadcast_old_wev8.png";
			    	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEIAAABCCAYAAADjVADoAAAFCUlEQVR42u1cWWtTQRQugojiT3DD5UUQ9EH9A4L6WN/0B/gg1CapRQRFX9RaW1ALPtgFNxBxIS8qvqjQNqm1exXtviR30qTZmqTLbZKOcyY3abYmN3P3tBfOQ+/NzJzz9czZ7plbUaHC1W52H7SZuIt2M1dnM3MfCfURchIKE8IChYV7/YSs9LdkDIytMOqF7+BtRJAzhJ4RoRxpwrKSA+aCOWFu3QPQVeXcA//JTjM3K4PwhUCp67Zwe3UHQGft7CHCYAshXkEAsgnWaoG1NQfg+xXPbsJMPaGoigBkU9RuRg3AiyYg2MyoUqb9L9+WMaELKgLg2ClsA6xTagEeFQWhoxrtE9wb1jn1A6/KGEST8zhZABkAhCQh4FleEKpdJ8nEAQOBkKSAvdpxWi6bcIwYxqABQRAIBSVrBgRIOvMMzB4FZGECoecy2mUQwyjagIJMDFtC1y6SjSxcK0uwhMuTUGUpYbOzfIHgnKLCcaI+D8sYBEqQmxRzlYc1TqBUS9RA1s1lIAvkJHlBgEKHyvUErYnPW9zptHAPNhEIlEDmrOCpZzt54NaKocFGD3a1RzC/EKP0t8UnJiaQY203yJ4eN5xTW/hft1x4yrqAF9Eqzr5WQ/GCY4cfz+P46hoFz14jkZdqdDZ9WzSrIXxXLcIjz/3YN7yM12Jr64KH4xj9CFPNSF4FNajBg+PRxHjf4LIkMED2dG8xo4bqRxfjKUEBCADkX6sP26+h1G/FAJHUiuhSYj6YWwJ/M+svX1RUffgb7sPzfOPEAgE09IhsET6hGSMv/My80pdI8DZJTdUvNkcpQACNvw2k1vh5A7HxTjCQzW3+bfZRZoqpPisQ/ffdOLayhrlv4ZxnwbEVOsbxNcTK/32wD1aWwaFJnlLybz4YE6X6rED03XWnDOS/tkz3+rtpnt6PRuJUKxnWtQIQvXIwXKpKs2yNyfdB+owPxHK0LMIlbBFoJsO6fQDEtFGAgCBq0RWlz0dfZRrHmU8hKR4EARBewwBBaOJdQiu8JH5Iv//nqZfeT9+uJVCogjXR0gqIvntu+nzFH8u433N7LuU9WNY1HBBgG5JeKdt1wwUGlSUTNdzW6LquCBA+YxlLiCfqFNka04Zyn+ku1DuwlN9YTjEZy17mgEoz94kE9/k6033OfpHkPmlAVW+YgOpDQhuWvbkBVTK5YwmooCeLOenKCbEXEiF2xKlMiA0JWzKRg8RO1hAbki650nClk64JIct0dURytsvCBC8p6Ur1csrVDlgsDR+ol5CGWxIeI7tWmZmGl66FILuipbqNCjPFtg5rYWb0pV96qc5ucp03cqluzsZeqgPZVS/ni9k6YoAYfjK/XrwdklS8zSznCwXceqWBkKucP/4mkIoZJFawH+jqlR/LC57umy6p6/Ib9nNvvQTeagvIvaCJouxf/ppQ41brkNjWoXJvJiu5g59kZG3l1zvFtTE1nJKBA2UEwgBTw6kQeh8gk3jKAAhPZw3aL60p3cKdMHpTOsggV4f+Kaj0GhAIn2zHFFKd+jWuowofY5Q3ViC8As+b+igTGEbJNqHY9blqbAdZrEnPHfjM3kHCcUc9RaBOVY87ZofjQm6i6QFYyB00OwCbJ2vV5Eh011XHEd2dEYdCh/BpBIeiW0Cvh+Q3+myCUB2X5bMJMJdhPptQ8EMaZu6S0MFnpTmMiePSPqSxSshvMzsnhPzGKvz2klof0vgPQgxAZeTpb3wAAAAASUVORK5CYII=";
			   }else if(id.indexOf("|sysnotice")>-1){//系统广播消息
			    	icon="/mobile/plugin/fullsearch/img/blue/v_msg_broadcast_wev8.png";
			    	icon="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEYAAABGCAYAAABxLuKEAAAFU0lEQVR42u2c3W8bRRDADUXwiEThCfgLitQHpKLcXauIB0oCAvERQRAfqYsQAp54RwIJlb5URSoSCEU8gQimTeI7J1RBlCKSKirlI5FKk7SkJYXQtInvbMex469hZn3Udm2T+9j7rE8a2YnPe7s/z87szuxuJOLSBRC5JZkQHlBlYUBTxAOqLB5TFWkWX/9GSaOALmn2v+pnx6r3CgP0XSojEoYrdbzrLjUuRTVF+hIbuVLXeKuykpTFISozPbxre6BgwLuRW5OK2IuNGEUpcIDRTqjsUXoWPdO/QL7vvk2Ni6/gLzrnIIyWUn2mMEB18BUUTRYeQSjzbgNpEqwD1cVzIGvjD92nKmLMcyBNgKSvqW5eackzWAnVd1BqomqK8Kx7tmS85w7UkiM+BtIoWFeqs6NQ0kr33fiwycBAuQ5HmqK6O2ZPvPA4PD0Xd7vDjKwsLgYVSp0scoOTGd99jy9cMUeXTm2yZ2hjO25HFZwODZRat5qmtlkGEyjvY15zPrIzToEwC7XRFJRVpetedHFa2MFQG9dG99xvvAvhkDr0UK5rjThmLIaS6Np7s0CpifDk1rGUAA/i7Az+INa3rS2YZFx43pu+vgc2Zg9BeX0JimszkJl8wwM4Un/bmKweZ3W1Qpmpt6CUvghQLkB+8SgUr55m7zOTr5uzFd/0QOpEvx1DPNsypozq1OMmkNS3T0Nh+STQVVg5BanvntM/kxDOT1C8dsY4lOOPIdw/oFLI1JVjQWsUsbcVmCFXvMDYw5Cb/wwqpTx2ncuwPv120z25c59AeeOKCSiLDDC9kubYsDVDjVBiD96JbivnNJT1M++wBleKG7Bx9gioie6W9+V+/9gQmCYo+LdN150jFvXjlqiTQNInX4bi6i9Y/QpsLo1BauKJ/73fCBjeUOrCotEaGFkYcaTboFrnLw4jjxKUkmch8+Nrhr63FRgq1xEo1THNiD6D7ttmN3ZLGpE79ynkL43A5qV4Vf6UobKpQTm3CtnfDqDV3224vK3AkIElQ8sfSnWawMY0+GannYLy5z9nXaScXWaehHkUXfIXvsBfd6/pMo10pfSJFxBKr1NzqJ04ixb3Wy0g+/N7yKSMGnGQuVleFTNqfB2cP+1HjRE+tFoAGdTNvya4V8xrMCiHqSslrBZA3YcaETowyAQ9kjhjGQxWPpRgkAnZmH86YJpkOXLDop0OGH3xUsROASEGA4EFQwO8dhd9xgNMugOmRVfqGN/2xrfjrlu5a1sDvLCCYQM8G1OCEGvMYVuTyLBOCfRJpPWwQ2gnkRR2YIEqi3nqUIYd/gtU2Q1tehWocjBdO8ItGJ7+YR/k5gZdC20ybf31fShpc5CaeIr3GuGo4+kTp4LhJCVtno1yKTfFC05T+sTphFtj+iTBJX1CMAgKTzhNCTe3UrS1hFuWS8KNN5yWKVq3kvqNKdol2ylabnDaJfWrWiP1e5LUvzJ1Q1L/tKmkfj2cUuo832UgXi0calwGEoPCyrSlZSAEhwwyeSvuC4fYKvC49Ki3C4dmEdab/lpq1lmcaGzvQOomAJMytZy1Ok2QXgr9osS48KK1JfOyOBhiMIO2drOFdpOF3V1vbFuOLCyEaLHzgu1tOZ2NXEbgoPUO/NY/sx7I1GZRRZoK4FjllGObRTvbi41u9IpLfb7ekK5IGtXRmyMMsM/6dPpw1DF7YuqcGLbHyQ8uXVigSbD/jklRhH2eHZMSl6K+OyalOaYjPe7awTr4LF8frNPSvQ/v2q4p4qt6oJ3XUUxfUZmBO4rJ0OFdsvhB3eFdyyjZOi1I6qPsGXZ4F7vX/cO7/gVj/JjYyAAwBwAAAABJRU5ErkJggg==";
			   }
    		}
    	}else{
    		//如果是自定义群头像,base64放入缓存中.宽度和高度任意一个超过100会进行压缩
    		if(icon.startWith("http:")||icon.startWith("https:")){
    			if(storage){
	      			if(storage.getItem("icon-"+icon+"-validTime")&&(new Date().getTime()-storage.getItem("icon-"+icon+"-validTime"))/1000<2*24*60*60){// 默认有效时间48h
						if(storage.getItem("icon-"+icon)){
							var temp_icon=storage.getItem("icon-"+icon);
							if(temp_icon=="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAASABIAAD/4QBMRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAZKADAAQAAAABAAAAZAAAAAD/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+/8AAEQgAZABkAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/bAEMAAgICAgICBAICBAYEBAQGCAYGBgYICggICAgICgwKCgoKCgoMDAwMDAwMDA4ODg4ODhAQEBAQEhISEhISEhISEv/bAEMBAwMDBQQFCAQECBMNCw0TExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTE//dAAQAB//aAAwDAQACEQMRAD8A/n/ooooAKKKKACiiigAooooAKKKKACiiigAooooA/9D+f+iiigAooooAKKKKACiiigAooooAKKKKACiiigD/0f5/6KKKACiiigAooooAKKKKACiiigAooooAKKKKAP/S/n/ooooAKKKKACiiigAooooAKKKKACiiigAooooA/9P+f+iiigAooooAKKKKACiiigAooooAKKKKACiiigD/1P5/6KKKACiiigAooooAKKKKACiiigAooooAKKKKAP/V/n/ooooAKKKKACiiigAooooAKKKKACiiigAooooA/9k="){
								storage.removeItem("icon-"+icon+"-validTime");
								storage.removeItem("icon-"+icon);
								setTimeout(function(){
									loadBase64Img(icon);
								},100);
							}else{
								icon=temp_icon;
							}
						}
	      			}else{
						storage.removeItem("icon-"+icon+"-validTime");
						storage.removeItem("icon-"+icon);
						setTimeout(function(){
							loadBase64Img(icon);
						},100);
					} 
				}
    		}
    	}
    	//人员姓名头像处理
    	var imgDiv="";
		if(icon==""){
			imgDiv='<div class="imgDiv">'+getRSCname(item.title)+'</div>';
		} 
    	//未读标识处理
    	var unReadHtml="";
    	var unread=item.unread;
    	if(unread>0){
    		if(item.noDisturb=="0"){//不提醒.只显示红点
    			unReadHtml='<div style="height: 10px; min-width: 2px; margin-left: 5px;"></div>';
    		}else{
    			unReadHtml='<div>'+(unread>99?"99+":unread)+'</div>';
    		}
    	}
										
    	var rethtml='<div class="am-list-item MSG lastLi" targetId="'+id+'" targetType="'+item.type+'" targetName="'+item.title+'">'+
						'<div class="msg_line" style="margin-left: 10px;">'+
							'<div class="am-list-line" style="margin-left: -10px;">'+
								'<div class="am-list-content" style="width:inherit">'+
									'<div>'+
										'<span class="ul-li-div-img">'+
											(imgDiv==""?'<img src="'+icon+'" style="border-radius: 23px;">':imgDiv)+
										'</span>'+
										'<div class="msgUnReadTag">'+
				 						unReadHtml+
										'</div>'+
										'<div class="ul-li-div ul-li-div-msg" style="margin-left: 75px;">'+
											'<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80 first-title-span">'+item.title+'</span><span class="ui-li-span ui-li-span-time">'+getMsgShowTime(item.time)+'</span></div>'+
											'<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80 second-desc-span">'+item.desc+'</span><span class="ul-li-div-noDisturb '+(item.noDisturb=="0"?"showNoDisturb":"")+'"><img style="width: 15px;opacity: 0.4;filter: alpha(opacity=40)" src="/mobile/plugin/fullsearch/img/'+pageStyle+'v_msg_noDisturb_wev8.png"></span></div>'+
										'</div>'+
									'</div>'+
								'</div>'+
							'</div>'+
						'</div>'+
					'</div>';
		return rethtml;
    }
    
    
	//把图片转base64. 如果图片过大进行压缩
	function getBase64Image(img) {  
	     var canvas = document.createElement("canvas");  
	     var maxWidth=100;
	     var maxHeight=100;
	     var scale = img.width / img.height;
	     var needCompress=false;
	     var imgWidht=img.width;
	     var imgHeight=img.height;
	     if(imgWidht>maxWidth){
	     	needCompress=true;
	     	imgWidht=maxWidth
	     	imgHeight = parseInt(maxWidth / scale);
	     }
	     if(imgHeight>maxHeight){
	     	needCompress=true;
	     	imgHeight=imgHeight;
	     	imgHeight = parseInt(maxWidth * scale);
	     }
	     canvas.width = imgWidht;  
	     canvas.height = imgHeight;  
	     var ctx = canvas.getContext("2d");  
	     var dataURL ="";
	     if(needCompress){
	     	ctx.drawImage(img, 0, 0, img.width, img.height,0,0,imgWidht,imgHeight); 
	     	dataURL=canvas.toDataURL("image/jpeg",0.7);  
	     }else{
	     	ctx.drawImage(img,0,0,img.width, img.height);
	     	dataURL=canvas.toDataURL("image/jpeg");
	     }
	     canvas=null;
	     return dataURL;  
	}
	
	/*加载图片,然后通过base64处理*/
	function loadBase64Img(url){
          var img = document.createElement('img'); 
          img.src = url; 
          img.onload =function(){
              var data = getBase64Image(img);
              if(data!="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAASABIAAD/4QBMRXhpZgAATU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAZKADAAQAAAABAAAAZAAAAAD/7QA4UGhvdG9zaG9wIDMuMAA4QklNBAQAAAAAAAA4QklNBCUAAAAAABDUHYzZjwCyBOmACZjs+EJ+/8AAEQgAZABkAwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/EAB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/bAEMAAgICAgICBAICBAYEBAQGCAYGBgYICggICAgICgwKCgoKCgoMDAwMDAwMDA4ODg4ODhAQEBAQEhISEhISEhISEv/bAEMBAwMDBQQFCAQECBMNCw0TExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTExMTE//dAAQAB//aAAwDAQACEQMRAD8A/n/ooooAKKKKACiiigAooooAKKKKACiiigAooooA/9D+f+iiigAooooAKKKKACiiigAooooAKKKKACiiigD/0f5/6KKKACiiigAooooAKKKKACiiigAooooAKKKKAP/S/n/ooooAKKKKACiiigAooooAKKKKACiiigAooooA/9P+f+iiigAooooAKKKKACiiigAooooAKKKKACiiigD/1P5/6KKKACiiigAooooAKKKKACiiigAooooAKKKKAP/V/n/ooooAKKKKACiiigAooooAKKKKACiiigAooooA/9k="){
	              storage.setItem("icon-"+url+"-validTime", new Date().getTime());
				  storage.setItem("icon-"+url,data);
			  }
              $(img).remove();
          }
          $("#customMsgImg").append(img);  
    }

	/*读取错误信息*/
   	function readErrorMsg(){
   		var msg="暂无错误日志";
   		var errMsg;
   		var errArray;
   		if(storage.getItem("weaver-voice-err-msg")&&storage.getItem("weaver-voice-err-msg")!=""){
   			errMsg=storage.getItem("weaver-voice-err-msg");
			errArray=JSON.parse(errMsg);
			if(errArray.length>0){
				msg="";
				for(j = 0; j < errArray.length; j++) {
	   				msg=errArray[j]+"<br/>"+msg;
				} 
			}
   		}
   		return msg;
   	} 
    
	}catch(e){
		console.log(e);
		//window.localStorage.clear();
		storage.removeItem("validTime"+userid);
		storage.removeItem("contentDiv"+userid);
		//第一次加载出错,强行刷新.资源加随机数
		if("<%=reload%>"!="true"){
			try{
				//清理浏览器缓存
				//location='emobile:{"func":"clearCache","params":{}}';
			}catch(e){}
			//1秒后重载页面
			setTimeout(function(){
				//if(window.location.href.indexOf("voice.html")==-1){
					location=window.location.href+"&reload=1";
				//}
			},1000);
		}else{
			alert("加载异常,请清除EMobile缓存,重新进入");
		}
	}
</script>
