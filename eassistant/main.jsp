<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="net.sf.json.JSONObject,java.util.concurrent.ConcurrentHashMap,java.util.*,weaver.eassistant.*,weaver.hrm.*,java.util.regex.*"%>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null){
		response.sendRedirect("/login/Login.jsp");
		return;
	}
	if(!user.getLoginid().equals("ygs") && !user.getLoginid().equals("wangjy") && !user.getLoginid().equals("xrj")
		&& !user.getLoginid().equals("dl") && !user.getLoginid().equals("hgg") && !user.getLoginid().equals("ly")
		&& !user.getLoginid().equals("liul") && !user.getLoginid().equals("rqf")){
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
%>

<HTML>
 <HEAD>
  <TITLE> 小e客服工作台</TITLE>
  <META NAME="Generator" CONTENT="EditPlus">
  <META NAME="Author" CONTENT="">
  <META NAME="Keywords" CONTENT="">
  <META NAME="Description" CONTENT="">
  <script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>	  
  <script type="text/javascript" src="websocket.js"></script>	  
  <style type="text/css">
		#header_div {
			height: 50px;
			background: inherit;
			background-color: rgba(249, 249, 249, 1);
			border-bottom: 1px solid #d8d8d8;
			border-radius: 5px;
			border-bottom-right-radius: 0px;
			border-bottom-left-radius: 0px;
			-moz-box-shadow: none;
			-webkit-box-shadow: none;
			box-shadow: none;
			line-height: 50px;
			padding-left: 10px;
		}
	.fixDiv{
		background-color:#d8e1e2!important;
	}
	#body_div{
		width:100%;
		min-height:350px;
		background-color:#fff;
	}

	.customService{
		width: 100px;
		height: 30px;
		border: none;
		cursor: pointer;
		color: #fff;
		font-size: 18px;
		background-color: #8ba5ef;
	}

	.hungUpClass{
		background-color:red;
	}

	.onlineClass{
		background-color:green;
	}

	#left_div{
		width:60%;
		float:left;
		border:none;
	}
	#right_div{
		width:40%;
		border:none;
		float:right;
	}
	#leftheader_div{
		height:40px;
		line-height:40px;
		border-right:1px solid #d8d8d8;
		border-bottom:1px solid #d8d8d8;
	}

	.actionListDiv{
		overflow:auto;
		background-color:rgb(242,242,242);
		border-left:1px solid #d8d8d8;
	}

	.actionType{
		font-weight:bold;
		border-bottom:1px solid #d8d8d8;
		
	}

	.actionTypeArea{
		border-top: 1px solid #d8d8d8;
		margin:10px;
		border-right: 1px solid #d8d8d8;
	}

	.action{
		height: 40px;
		background: inherit;
		/*background-color: rgba(248, 248, 248, 1);*/
		background-color:#fff;
		box-sizing: border-box;
		/*border-width: 0px;*/
		border-style: solid;
		border-color: rgba(228, 228, 228, 1);
		border-top: 0px;
		border-right: 0px;
		border-radius: 0px;
		border-top-left-radius: 0px;
		border-top-right-radius: 0px;
		border-bottom-right-radius: 0px;
		-moz-box-shadow: none;
		-webkit-box-shadow: none;
		box-shadow: none;
		color: #666666;
		text-align: left;
		cursor:pointer;
		line-height: 40px;
	}

	.subaction {
		height: 40px;
		padding-left: 20px!important;
		line-height: 40px;
		border-bottom: 1px solid #d8d8d8;
		color:#000;
		font-size:12px;
		background-color:#fff;
	}

	.subaction:hover{
		background-color:rgba(233, 248, 255, 1);
	}

	.currentSelect {
		background-color: #FFFFCC!important;
		/*border: 1px solid #cddc39;*/
	}

	.actionTitle{
		padding-left:10px;
		border-left:1px solid #d8d8d8;
		font-size:14px;
	}

/*
	.actionType{
		height:25px!important;
		line-height:25px!important;
	}

	*/

	.subaction input[type=text]{
		    width: 100px;
			height: 30px;
			background-color: transparent;
			font-family: '微软雅黑';
			font-weight: 400;
			font-style: normal;
			font-size: 12px;
			text-decoration: none;
			color: #3366FF;
			text-align: left;
			border-color: transparent;
			outline-style: none;
			border-bottom:#999 1px solid;
	}


	.question{
		width: 100%;
		height: 91px;
		background: inherit;
		background-color: rgba(255, 255, 255, 1);
		box-sizing: border-box;
		border-width: 1px;
		border-style: solid;
		border-color: rgba(228, 228, 228, 1);
		border-left: 0px;
		border-top: 0px;
		border-right: 0px;
		border-radius: 0px;
		border-top-left-radius: 0px;
		border-top-right-radius: 0px;
		border-bottom-right-radius: 0px;
		border-bottom-left-radius: 0px;
		-moz-box-shadow: none;
		-webkit-box-shadow: none;
		box-shadow: none;
		text-align: left;
		position:relative;
		padding-left: 10px;
		border-right: 1px solid #d8d8d8;
		cursor:pointer;
	}


	.timeInfo{
		color:red;
		float:right;
		position: absolute;
		right: 20px;
		top: 30px;
	}

	.subject {
		padding-top: 15px;
		padding-bottom: 10px;
	}

	.otherInfo {
		color: #999;
	}

	.basicInfo{
		float:left;
	}

	.currentQuestion{
		height:119px;
		background-color:rgb(232,243,255);
	}
	
	.splitWordList{
		display:none;
		margin-top:10px;
	}

	.currentQuestion .timeInfo{
		    top: 50px;
			background-color: rgb(255,102,0);
			color: #fff;
			border-radius: 30px;
			width: 32px;
			height: 32px;
			line-height: 32px;
			text-align: center;
	}

	.currentQuestion .splitWordList{
		display:block;
	}

	.word{
		display:inline-block;
		color:#fff;
		background-color:rgba(45, 183, 245, 1);
		white-space:nowrap;
		height:30px;
		line-height:30px;
		padding-left:5px;
		padding-right:5px;
		margin-right:5px;
		cursor:pointer;
		-moz-user-select: none;
		-khtml-user-select: none; 
		user-select: none;
	}

	.selectWord{
		background-color:rgb(55, 148, 189);
	}

	.empty{
		border:1px solid #f90d0d!important;
	}



	#action_span{
		text-align: center;
    height: 40px;
    line-height: 40px;
    border-bottom: 1px solid #d8d8d8;
	}

	div#text_input_div {
		height: 50px;
		line-height: 50px;
		border-bottom:1px solid #d8d8d8;
		border-left: 1px solid #d8d8d8;
	}

	div#text_input_div input#textInput {
		margin-top:5px;
		margin-left:10px;
		height:40px;
		border:none;
		font-size:16px;
		outline:none;
		width:70%;
		ime-mode:disabled;
	}

	.sendBtnDiv{
		display:none;
		position:absolute;
		top:0;
		z-index:9999;
	}

	.userOnListDiv{
		position:absolute;
		width:160px;
		top:20px;
		right:10px;
		background-color: #fff;
		border: 1px solid #d8d8d8;
	}

	.userOnListDiv span{
		display:inline-block;
	}

	.userOnListDiv div{
		 height: 30px;
		line-height: 30px;
		border-bottom: 1px solid #d8d8d8;
	}

	.spanStatus{
		margin-left:20px;
	}

	#submit{
		color:#4D7AD8;
		border:none;
		background-color:transparent;
		cursor:pointer;
	}

	.accessBtnAction{
		/*width: 67px!important;*/
		height: 30px;
		text-align:center;
		line-height:26px;
		background-color: rgba(255, 255, 255, 1);
		border-width: 1px!important;
		border-style: solid!important;
		border-color: rgba(228, 228, 228, 1);
		border-radius: 5px;
		-moz-box-shadow: none;
		-webkit-box-shadow: none;
		box-shadow: none;
		margin-top:3px;
		color:#000;
		margin-left:10px;
		cursor:pointer;
		min-width:80px;
	}


	.accessBtnActionHover:hover{
		height: 30px;
		background: inherit;
		background-color: rgba(255, 255, 255, 1);
		box-sizing: border-box;
		border-width: 1px;
		border-style: solid;
		border-color: rgba(16, 142, 232, 1);
		border-radius: 2px;
		-moz-box-shadow: none;
		-webkit-box-shadow: none;
		box-shadow: none;
		color: rgb(16,142,232);
	}

	.accessBtnDiv{
		margin-right:10px;
		float:right;
	}

	.fixBtnAction{
		background-color:rgba(70, 136, 196, 1)!important;
		color:#fff!important;
		border: none;
		background-color: transparent;
		color: #0a30f5;
		cursor:pointer;
	}

  </style>
  <script type="text/javascript">
	var __tokenstring__ = "<%=user.getLoginid()%>";
	var __customOtherStatus = "<%=CONSTS.CUSTOMOTHERSTATUS%>";
	var __tokenUserIdString__ = "<%=user.getUID()%>";
	var wsUrl = "<%=CONSTS.wsUrl%>";
	var _onlineString = "√ 在 线";
	var _offlineString = "× 挂 起"

	function changeServiceStatusClick(obj, status){
		var $obj = jQuery(obj);
		if(status==1){
			$obj.removeClass("hungUpClass").addClass("onlineClass");
			$obj.val(_onlineString);
		}else if(status==0){
			$obj.addClass("hungUpClass").removeClass("onlineClass");
			$obj.val(_offlineString);
		}else{
			if($obj.hasClass("onlineClass")){//当前在线状态，改为挂起状态
				$obj.addClass("hungUpClass").removeClass("onlineClass");
				$obj.val(_offlineString);
				status = 0;
			}else{
				$obj.removeClass("hungUpClass").addClass("onlineClass");
				$obj.val(_onlineString);
				status = 1;
			}
			var token = "<%=user.getLoginid()%>";
			var msgType="<%=CONSTS.CUSTOMSTATUS%>";
			var json = {status:status,msgType:msgType,token:token,};
			sendMsg(json);
		}
	}

	function changeServiceStatus(obj, token, msgType){
		var _status=jQuery(obj).val();
		if(!token){
			token = "<%=user.getLoginid()%>";
		}
		if(!msgType){
			msgType="<%=CONSTS.CUSTOMSTATUS%>";
		}
		var json = {status:_status,msgType:msgType,token:token,};
		sendMsg(json);
	}

	function sendText(inputId,handleWay,isRecord,content){
		if(!inputId)inputId = textInputId;
		var input = jQuery(inputId).val();
		if(!input){
			try{
				jQuery(inputId).val(currentDealingData[currentDealingData.uuid].text) ;
				input = currentDealingData[currentDealingData.uuid].text;
			}catch(e){}
		}
		if(!isRecord)isRecord = "";
		if(!content)content = "";
		if(!!input){
			//发送处理结果
			if(!!currentDealingData){
				currentDealingData.msgType = "<%=CONSTS.RESPONSE%>";
				currentDealingData[currentDealingData.uuid].text = input;
				currentDealingData[currentDealingData.uuid].status = handleWay;
				currentDealingData[currentDealingData.uuid].isRecord = isRecord;
				currentDealingData[currentDealingData.uuid].content = content;
				currentDealingData[currentDealingData.uuid].processId = "<%=user.getUID()%>";
				//console.log(currentDealingData);
				sendMsg(currentDealingData);
				remove(currentDealingData);
				currentDealingData = null;
				next();
			}
			jQuery(inputId).val("");
			cmdTypeCommand = null;
			if(!!selectCommand){
				selectCommand.removeClass("currentSelect");
				selectCommand = null;
			}

		}
		filterCmd("",true);
		jQuery(textInputId).focus();
		jQuery(textInputId).select();
	}
	

	var cmdTypeCommand = null;
	var isTimeoutCmd = false;
	function sendTimeoutText(data,isNext){
		isTimeoutCmd = true;
		if(!selectCommand){
			sendESearch(data);
		}else{
			/*var result = sendCommand();
			if(!result){
				//发送该选中指令的默认指令
				var _parentCmd = selectCommand.attr("_parentCmd");
				if(!!_parentCmd){
					cmdTypeCommand = selectCommand.parent().children().eq(0).children().eq(1).eq(0);
					sendCommand();
				}
			}*/
			//选中了的话，则查询该命令绑定的默认发送指令
			var _bindTimeoutCmdID = selectCommand.attr("_bindTimeoutCmd");
			if(!!_bindTimeoutCmdID){
				var _bindTimeoutCmd = jQuery("input[_timeoutCmd='"+_bindTimeoutCmdID+"']");
				_bindTimeoutCmd.click();
			}else{
				//默认走微搜
				var _timeoutType = selectCommand.attr("_timeoutType");
				if(!!_timeoutType){
					data[data.uuid].status = "<%=CONSTS.ESEARCH%>"+_timeoutType;
				}else{
					data[data.uuid].status = "<%=CONSTS.ESEARCH%>";
				}
				sendESearch(data);
			}
		}
		if(isNext){
			currentDealingData = null;
			next();
		}
	}

	function sendESearch(data){
		data.msgType = "<%=CONSTS.RESPONSE%>";
		if(!data[data.uuid].status){
			data[data.uuid].status = "<%=CONSTS.ESEARCH%>";
		}
		data[data.uuid].processId = "<%=user.getUID()%>";
		sendMsg(data);
		remove(data);
		jQuery(textInputId).val("");
		cmdTypeCommand = null;
		if(!!selectCommand){
			selectCommand.removeClass("currentSelect");
			selectCommand = null;
		}
		filterCmd("",true);
		jQuery(textInputId).focus();
		jQuery(textInputId).select();
	}

	function speackInput(inputId){
		if(!inputId)inputId = textInputId;
	}


	var backWardsPending = null;

	var backWardsDealing = null;

	var currentDealingData = null;

	var pendingData = [];

	var textInputId = "#textInput";

	function keyEventFunction(){

		jQuery(document).keyup(function(e){

			if(e.keyCode==27)  //ESC  取消
			{  
				//jQuery(textInputId).val(jQuery("#action_0").attr("_defaultValue"));
				sendText(textInputId,"<%=CONSTS.ESEARCH%>");
			}else if(e.altKey  && e.keyCode==49){//Alt+1  发送输入框指令
				sendText(textInputId,"<%=CONSTS.DEALED%>");
			}else if(e.altKey  && e.keyCode==50){//Alt+2  发送转微搜指令
				//jQuery(textInputId).val(jQuery("#action_0").attr("_defaultValue"));
				sendText(textInputId,"<%=CONSTS.ESEARCH%>");
			}else if(e.altKey  && e.keyCode==51){//Alt+3  发送暂不支持此功能指令
				jQuery(textInputId).val(jQuery("#action_2").attr("_defaultValue"));
				sendText(textInputId,"<%=CONSTS.SHOW%>",true);
			}else if(e.altKey  && e.keyCode==81){//Alt+Q  发送【请询问与OA相关的问题】指令
				jQuery(textInputId).val(jQuery("#action_1").attr("_defaultValue"));
				sendText(textInputId,"<%=CONSTS.SHOW%>");
			}else if(e.keyCode==17){//松开ctrl键
				//将选中的值填入文本框
				nextInputFocus();
			}else if(e.keyCode==32){
				//发送指令
				var target = e.target;
				var needSend = true;
				if(!!target){
					var $target = jQuery(target);
					//if(target.tagName=="INPUT" && $target.attr("id")=="textInput"){
					if(target.tagName=="INPUT"){
						needSend = false;
					}
				}
				if(needSend){
					sendCommand();
					e.preventDefault();
					e.stopPropagation();
				}
			}else if(e.altKey && e.keyCode==90){
				//清除所有文本指令输入
				jQuery("input[class=actionInput]").val("");
			}
		});
	}

	//删除dom节点
	function remove(data){
		jQuery("#faq_"+data.uuid).remove();
	}

	//取下一个问题进入当前列表
	function next(){
		if(pendingData!=null && pendingData.length>0){
			var key = pendingData[0].uuid;
			currentDealingData = pendingData[0];
			filterCmd(currentDealingData[key].words);
			//jQuery(textInputId).val(currentDealingData[key].text);
			jQuery(textInputId).select();
			pendingData.remove(0,currentDealingData);
			jQuery("#faq_"+currentDealingData.uuid).addClass("currentQuestion");
			//重置时间，等于当前剩余时间+5s
			var timeRemain = parseInt(currentDealingData[key].timeRemain)+<%=CONSTS.DEALINGTIMEOUT-1%>;
			currentDealingData[key].timeRemain = timeRemain;
			if(timeRemain>=0){
				jQuery("#time_"+key).text(timeRemain);
			}
			jQuery(textInputId).focus();
		}
	}

	//循环计算待处理问题的计时
	function backWardsPendingFun(){
		for(var i = 0;i<pendingData.length;i++){
			var data = pendingData[i];
			var key = data.uuid;
			var timeRemain = --pendingData[i][key].timeRemain;
			if(timeRemain>=0){
				jQuery("#time_"+key).text(timeRemain);
			}else{
					pendingData.remove(i,data);
					sendTimeoutText(data,false);
			}
		}
		backWardsPending = setTimeout(backWardsPendingFun,1000);
	}

	//循环处理当前正在处理的问题计时
	function backWardsDealingFun(){
		if(currentDealingData!=null){
			var key = currentDealingData.uuid;
			var timeRemain = --currentDealingData[key].timeRemain;
			if(timeRemain>=0){
				jQuery("#time_"+key).text(timeRemain);
			}else{
				sendTimeoutText(currentDealingData,true);
			}
		}else{
			next();
		}
		backWardsDealing = setTimeout(backWardsDealingFun,1000);
	}

	/*
　 *　方法:Array.remove(dx)
　 *　功能:删除数组元素.
　 *　参数:dx删除元素的下标.
　 *　返回:在原数组上修改数组
*/
//经常用的是通过遍历,重构数组.
Array.prototype.remove=function(dx,data)
{
	if(isNaN(dx)||dx>this.length){return false;}
	for(var i=0,n=0;i<this.length;i++)
	{
	if(this[i]!=this[dx])
	{
	this[n++]=this[i]
	}
	}
	this.length-=1;
	//jQuery("#faq_"+data.uuid).remove();
　}

Array.prototype.add=function(data)
{
	var idx = this.length;
	if(idx<0)idx = 0;
	this[idx] = data;
//	this.length+=1;
	createFaqFun(data);
}

var questionListDiv = null;

var selectCommand = null;

/**
*根据分词过滤指令
*/
function filterCmd(wordList, notAutoFocus){
		if(!!wordList){
			var children = jQuery("#actionListDiv").children("div").children("div.actionType");
			wordList = wordList.split(",");
			children.each(function(idx,obj){
				var $obj = jQuery(obj);
				var text = $obj.attr("_label");
				if(!text || !!$obj.attr("_fixed")){
					$obj.parent().show();
				}else{
					//if(text=="转微搜"||text=="请询问与OA相关的问题"){
					//	$obj.show();
					//}else{
						var flag = false;
						for(var i=0;i<wordList.length;i++){
							var word = wordList[i];
							if(text.indexOf(word)!=-1){
								$obj.parent().show();
								flag = true;
								break;
							}
						}
						if(!flag){
							$obj.parent().hide();
						}
					//}
				}
			});
			
		}else{
			jQuery("div.actionType").parent().show();
		}
		if(!notAutoFocus){
			jQuery("input[class=actionInput]:visible:first").focus();
		}
}

//发送指令
function sendCommand(){
	if(selectCommand!=null){
		var _defaultValue = selectCommand.attr("_defaultValue");
		var _status = selectCommand.attr("_status");
		var isRecord = selectCommand.attr("_isRecord");
		if(!!_defaultValue && _defaultValue.indexOf("{{")!=-1){
			var cmds = _defaultValue.match(/{{.*?}}/g);
			var idx = selectCommand.attr("_idx");
			for(var i =0; i < cmds.length;i++){
				var cmd = cmds[i];
				var cmdObj = jQuery("#input_"+idx+i);
				var cmdValue = cmdObj.val().trim();
				if(!cmdValue){
					var _inputDefaultValue = cmdObj.attr("_inputDefaultValue");
					if(!!_inputDefaultValue){
						cmdValue = _inputDefaultValue;
						//cmdObj.val(cmdValue);
					}
				}
				if(cmdTypeCommand==null || cmdTypeCommand.length==0){
					var _parentCmd = selectCommand.attr("_parentCmd");
					if(!!_parentCmd){
						cmdTypeCommand = selectCommand.parent().children().eq(0).children().eq(1).children().eq(0);
					}
				}
				if(!cmdValue){
					//发送该选中指令的默认指令
					if(!!cmdTypeCommand && cmdTypeCommand.length>0 && cmdTypeCommand.attr("_isForm")=="true" && selectCommand.attr("_isForm")=="true"){
						_defaultValue = "";
					}else{
						cmdObj.addClass("empty");
						cmdObj.val("");
						cmdObj.focus();
						cmdTypeCommand = null;
						return false;
					}
				}else{
					isRecord = true;
					_defaultValue = _defaultValue.replace(cmd,cmdValue);
					cmdObj.removeClass("empty");
				}
			}
		}
		if(!!_defaultValue || (cmdTypeCommand!=null && cmdTypeCommand.length>0)){
			//发送指令
			if(_defaultValue!="转微搜" && _defaultValue!="我好像不太明白" ){
				if (!cmdTypeCommand || cmdTypeCommand.length==0 || cmdTypeCommand.attr("_isForm")!="true" || selectCommand.attr("_isForm")!="true"){
					jQuery(textInputId).val(_defaultValue);
					_defaultValue = "";
				}else{
					jQuery(textInputId).val(cmdTypeCommand.attr("_defaultValue"));
				}
			}
			sendText(textInputId,_status,isRecord ,_defaultValue);
			jQuery("input[class=actionInput]").val("");
			if(!!selectCommand){
				selectCommand.removeClass("currentSelect");
				selectCommand = null;
			}
			return true;
		}
	}
	cmdTypeCommand = null;
	return false;
}

	function createFaqFun(jsondata){
		var uuid = jsondata.uuid;
		var data = jsondata[uuid];
		var faqdiv = jQuery("<div></div>").attr("id","faq_"+uuid).attr("_key",uuid)
															.addClass("question");
		var basicInfoDiv =  jQuery("<div></div>").addClass("basicInfo");
		var subjectDiv =  jQuery("<div></div>").addClass("subject").text(data.text);
		var otherInfoDiv =  jQuery("<div></div>").addClass("otherInfo").text(data.creator+" "+data.createDate);
		var splitWordListDiv = jQuery("<div></div>").addClass("splitWordList");
		var wordList = data.words;
		if(!!wordList){
			wordList = wordList.split(",");
			for(var i=0;i<wordList.length;i++){
				var span = jQuery("<span></span>").addClass("word").text(wordList[i]);
				splitWordListDiv.append(span);
			}
		}
		basicInfoDiv.append(subjectDiv).append(otherInfoDiv).append(splitWordListDiv);

		faqdiv.append(basicInfoDiv);
		var timeInfoDiv = jQuery("<div></div>").addClass("timeInfo");
		var span = jQuery("<span></span>").attr("id","time_"+uuid).text(10);
		timeInfoDiv.append(span);
		faqdiv.append(timeInfoDiv);
		if(questionListDiv==null){
			questionListDiv = jQuery("#question_list_div");
		}
		questionListDiv.append(faqdiv);
	}

	var selectWordsText = [];

	function selectOrUnSelectThis($obj){
		if($obj.hasClass("selectWord")){
			for(var i=0;i<selectWordsText.length;i++){
				if(selectWordsText[i]==$obj.text()){
					selectWordsText.remove(i);
				}
			}
			$obj.removeClass("selectWord");
		}else{
			selectWordsText[selectWordsText.length] = $obj.text();
			$obj.addClass("selectWord");
		}
	}

	var isMouseoverEvent = false;

	function registMouseClickEvent(){

		jQuery("div#question_list_div").delegate("span.word","click",function(e){
			if(!isMouseoverEvent){
				selectOrUnSelectThis(jQuery(this));
				  if(!e.ctrlKey){
					//直接回填数值	
					nextInputFocus();
				  }
			}
		});

		jQuery("div#question_list_div").delegate("span.word","mouseup",function(e){
			if(!isMouseoverEvent){
				selectOrUnSelectThis(jQuery(this));
				  if(!e.ctrlKey){
					//直接回填数值	
					nextInputFocus();
				  }
			}else{//鼠标连选
				nextInputFocus();
				isMouseoverEvent = false;
			}
		});

		jQuery("div#question_list_div").delegate("span.word","mouseenter",function(e){
		  if(e.which==1){//左键按下
			 isMouseoverEvent = true;
			  selectOrUnSelectThis(jQuery(this));
		  }
		});

		jQuery("div#question_list_div").delegate("span.word","mousedown",function(e){
		  if(e.which==1){//左键按下
			  selectOrUnSelectThis(jQuery(this));
		  }
		});
	}



	

	function nextInputFocus(){  
		if(selectWordsText.length==0)return;
		var text = "";
		for(var i=0;i<selectWordsText.length;i++){
			if(!!selectWordsText[i]){
				text = text+selectWordsText[i];
			}
		}
		if(!!currentFocusInpuObj){
			//currentFocusInpuObj.focus();
			currentFocusInpuObj.val(text);
//			currentFocusInpuObj.next("input[class=actionInput]").focus();
			currentFocusInpuObj = currentFocusInpuObj.next("input[class=actionInput]");
		}
		selectWordsText = [];
		jQuery("span.selectWord").removeClass("selectWord");
	} 

	var currentFocusInpuObj = null;

	var userOnList = {};

	jQuery(document).ready(function(){
		questionListDiv = jQuery("#question_list_div");
		
		/*jQuery("#sendBtnDiv").hover(function(){
			window.sendBtnHoverStatus = false;
		},function(){
			window.sendBtnHoverStatus = true;
		}).bind("click",function(){
			//发送当前选中的指令
			sendCommand();
		});*/

		jQuery("#actionListDiv").css("max-height",(window.innerHeight-jQuery("#header_div").outerHeight()-jQuery("#action_span").outerHeight()-jQuery("#text_input_div").outerHeight()-jQuery("#fixActionListDiv").outerHeight()-30)+"px");

		jQuery("#textInput").keyup(function(){
			var value = this.value;
			if(!!value)value=value.toLowerCase();
			filterCmd(value,true);
		});

		/*jQuery(".actionListDiv").hover(function(){},function(){
			// jQuery("#sendBtnDiv").hide();
			window.sendBtnHoverStatus = true;
		});*/

		jQuery(".accessBtnAction").bind("click",function(e){
			if(isTimeoutCmd){//超时触发的命令，不缓存，不发送任何参数
				jQuery(textInputId).val(jQuery(this).attr("_defaultValue"));
				sendText(textInputId, jQuery(this).attr("_status"), false);
			}
			isTimeoutCmd = false;
			if(!jQuery(this).hasClass("fixBtnAction")){
				cmdTypeCommand = jQuery(this);
			}
			if(selectCommand==null || selectCommand.attr("_isForm")!="true" || jQuery(this).hasClass("fixBtnAction")){
				if(!jQuery(this).attr("_notInput")){
					jQuery(textInputId).val(jQuery(this).attr("_defaultValue"));
				}
				if(!jQuery(this).hasClass("fixBtnAction")){
					sendText(textInputId, jQuery(this).attr("_status"),jQuery(this).attr("_isRecord"), jQuery(this).parent().parent().parent().children().eq(1).children().eq(0).val());
				}else{
					sendText(textInputId, jQuery(this).attr("_status"), true);
				}
				e.preventDefault();
				e.stopPropagation();
			}else{
				sendCommand();
			}
		});

		jQuery("input").focus(function(){
			currentFocusInpuObj = jQuery(this);
		});

		jQuery(textInputId).focus(function(){
			//jQuery(this).select();
		}).bind("mouseenter",function(){
			jQuery(this).select();
		});

		/*jQuery(".actionFlag").hover(function(){
			//显示发送按钮
			window.sendBtnHoverStatus = false;
			var $this = jQuery(this);
			var sendBtnDiv = jQuery("#sendBtnDiv");
			var top = $this.position().top+$this.height()/2;
			var left = $this.position().left+$this.width();
			sendBtnDiv.css("top", top).css("left",left);
			sendBtnDiv.show();
			if(jQuery("input:focus").length==0){
				currentFocusInpuObj = $this.children("input:first");
				currentFocusInpuObj.focus();
			}
			//selectCommand = $this;
		},function(){
			//隐藏发送按钮
			window.sendBtnHoverStatus = true;
			setTimeout(function(){
				if(window.sendBtnHoverStatus){
					jQuery("#sendBtnDiv").hide();
				}
			},1000);
		});*/
		jQuery(".actionFlag").bind("click",function(e){
			var $this = jQuery(this);
			selectCommand = $this;
			var lastclicktime = $this.data("lastclicktime");
			if(!lastclicktime){
				lastclicktime = 0;
			}
			if($this.hasClass("currentSelect") && (new Date().getTime()-lastclicktime)>=500){
				jQuery("div.currentSelect").removeClass("currentSelect");
				$this.data("lastclicktime",new Date().getTime());
				selectCommand = null;
				currentFocusInpuObj = null;
			}else{
				$this.data("lastclicktime",new Date().getTime());
				jQuery("div.currentSelect").removeClass("currentSelect");
				$this.addClass("currentSelect");
				var $target = jQuery(e.target);
				if(!$target.hasClass("actionInput")){
					currentFocusInpuObj = $this.children("input:first");
					//currentFocusInpuObj.focus();
				}
			}
		}).dblclick(function(){
			sendCommand();
		});

		/*var initPendingData = [{"0":{text:"杨国生的房间1",timeRemain:10,words:"杨国生,的,房间",creator:"王金永", createDate:"2017-11-08 22:01"},uuid:"0"},
								{"1":{text:"杨国生的房间2",timeRemain:10,words:"杨国生,的,房间",creator:"王金永", createDate:"2017-11-08 22:02"},uuid:"1"},
								{"2":{text:"杨国生的房间3",timeRemain:10,words:"杨国生,的,房间",creator:"王金永", createDate:"2017-11-08 22:03"},uuid:"2"},
								{"3":{text:"杨国生的房间4",timeRemain:10,words:"杨国生,的,房间",creator:"王金永", createDate:"2017-11-08 22:04"},uuid:"3"},
								{"4":{text:"杨国生的房间5",timeRemain:10,words:"杨国生,的,房间",creator:"王金永", createDate:"2017-11-08 22:05"},uuid:"4"},
								{"5":{text:"杨国生的房间6",timeRemain:10,words:"杨国生,的,房间",creator:"王金永", createDate:"2017-11-08 22:06"},uuid:"5"},
								{"6":{text:"杨国生的房间7",timeRemain:10,words:"杨国生,的,房间",creator:"王金永", createDate:"2017-11-08 22:07"},uuid:"6"}];
		for(var i = 0; i < initPendingData.length;i++){
			pendingData.add(initPendingData[i]);
		}
		next();*/
		keyEventFunction();
		//jQuery("#faq_0").addClass("currentQuestion");
		//启动两个定时器，一个用于倒数处理时间，一个用于倒数等待时间
		backWardsPending = setTimeout(backWardsPendingFun,1000);
		backWardsDealing = setTimeout(backWardsDealingFun,1000);

		registMouseClickEvent();

		onOpen();

		jQuery(textInputId).focus();

	});

  </script>
 </HEAD>

 <BODY style="background-color:rgb(228,228,228);">
	<!--<div id = "sendBtnDiv" class="sendBtnDiv">
		<input type="button" class="sendBtn" id="sendBtn" name="sendBtn" value="发送"/>
	</div>-->
	<div id="userOnListDiv" class="userOnListDiv">
			
	</div>
	<div id="body_div" style="width:80%;min-height:400px;position:relative;margin:0 auto;">
		<div id="header_div">小e客服工作台</div>
		<div id="body_div">
			<div id="left_div">
				<div id="leftheader_div">
					<div style="padding-left:10px;float:left;">
						<span>问题列表</span>
						<span style="color:red;">快捷键：ESC=转微搜</span>
					</div>
					<div style="float:right;padding-right:10px;">
						<span>客服状态：</span>
						</span>
							<!--<select id="customService" name="customService" onchange="changeServiceStatus(this)">
								<option value="1">在线</option>
								<option value="0" selected>挂起</option>
							</select>-->
							<input type="button" name="customService" id="customService" value="× 挂 起" class=" customService" onclick="changeServiceStatusClick(this)"/>
						</span>
					</div>
					<div style="clear:both;"></div>
				</div>
				<!--问题列表内容-->
				<div id="question_list_div">
					<!--<div id="faq_12" class="question currentQuestion">
						<div class="basicInfo">
							<div class="subject">杨国生的房间</div>
							<div class="otherInfo">王金永 2017-11-08 22:01</div>
							<div class="splitWordList">
								<span class="word">杨国生</span>
								<span class="word">的</span>
								<span class="word">房间</span>
							</div>
						</div>
						<div class="timeInfo">
							<span id="time_12">10</span>
						</div>
					</div>-->
				</div>
			</div>
			<div id="right_div">
				<div id="rightheader_div">
					<div id="action_span">动作指令库</div>
					<div id="text_input_div">
						<span><input type="text" id="textInput" name="textInput" size="50" placeholder="请输入指令" style="ime-mode:disabled;-webkit-ime-mode:disabled;"/></span>
						<span style="float:right;padding-right:20px;display:inline-block;height:100%;">
							<span><input type="button" style="margin-top:13px;" name="submit" id="submit" onclick="sendText(null,'<%=CONSTS.DEALED%>')" value="发送(Alt+1)"/></span>
							<!--<span><input type="button" name="speakInputBtn" id="speakInputBtn" onclick="speackInput()" value="语音"/></span>-->
						</span>
					</div>
					<div id="fixActionListDiv" style="height:40px;border-bottom: 1px solid #d8d8d8;">
						<!--<div>
							<div id="action_0" class="action actionTitle actionFlag" _defaultValue="转微搜" _status="esearch">转微搜(Alt+2)</div>
						</div>
						<div>
							<div id="action_1" class="action actionTitle actionFlag" _defaultValue="请询问与协同办公相关的问题"  _status="show">请询问与协同办公相关的问题(Alt+Q)</div>
						</div>
						<div>
							<div id="action_2" class="action actionTitle actionFlag" _defaultValue="暂不支持此功能" _isRecord="true"  _status="show">暂不支持此功能(Alt+3)</div>
						</div>-->
						<div id="action_0" _defaultvalue="我好像不太明白,请询问与协同办公相关的问题,暂不支持此功能" _status="dealed" _parentcmd="action_0" _idx="0" class="actionTitle subaction actionFlag">
							<input type="button" name="access_btn_action_01" id="access_btn_action_01" class="accessBtnAction fixBtnAction" _status="<%=CONSTS.SHOW%>" _defaultvalue="请询问与协同办公相关的问题" value="OA相关">
							<input type="button" name="access_btn_action_010" id="access_btn_action_010" class="accessBtnAction fixBtnAction" _status="<%=CONSTS.ESEARCH+"_FAQ:-1"%>" _defaultvalue="FAQ" value="FAQ">
							<input type="button" name="access_btn_action_02" id="access_btn_action_02" class="accessBtnAction fixBtnAction" _isRecord="true"  _status="<%=CONSTS.SHOW%>" _defaultvalue="暂不支持此功能" value="暂不支持">
							<input type="button" name="access_btn_action_00" id="access_btn_action_00" _timeoutCmd="btmbBtn" class="accessBtnAction fixBtnAction" _status="<%=CONSTS.SHOW%>" _defaultvalue="我好像不太明白" value="不太明白">
							<input type="button" name="access_btn_action_011" id="access_btn_action_011" class="accessBtnAction fixBtnAction" _status="<%=CONSTS.ESEARCH%>" _defaultvalue="转微搜" _notInput="true" value="转微搜">
						</div>
					</div>
					<div class="actionListDiv" id="actionListDiv">
						
						<%=getCmds()%>
						<!--<div>
								<div id="action_3" _defaultValue="请假"  _status=CONSTS.DEALED class="actionType action actionTitle" _label="请假,病假,事假,带薪,年假,qj">请假</div>
								<div id="action_4" _defaultValue="我要请假" _status=CONSTS.DEALED class="subaction actionTitle actionFlag">我要请假</div>
								<div id="action_5" _status=CONSTS.DEALED _parentCmd="action_5" class="subaction actionTitle actionFlag" _idx="5" _defaultValue="{{[开始时间]}}到{{[结束时间]}}请假{{[事由]}}">
									<input type="text" class="actionInput" name="input_50" id="input_50" placeholder="[开始时间]" tabindex=1/>到<input type="text" class="actionInput" name="input_51" id="input_51" placeholder="[结束时间]" tabindex=2/>请假<input type="text" class="actionInput" name="input_52" id="input_52" placeholder="[事由]"  tabindex=3/>
								</div>
						</div>
						<div>
								<div id="action_6" _defaultValue="出差"  _status=CONSTS.DEALED  class="actionType action actionTitle" _label="出差,cc">出差</div>
								<div id="action_7" _defaultValue="我要出差" _status=CONSTS.DEALED class="subaction actionTitle actionFlag">我要出差</div>
								<div id="action_8" _status=CONSTS.DEALED _parentCmd="action_8" class="subaction actionTitle actionFlag" _idx="8" _defaultValue="{{开始时间}}到{{结束时间}}出差">
									<input type="text" class="actionInput" name="input_80" id="input_80" placeholder="[开始时间]"  tabindex=4/>到<input type="text" class="actionInput" name="input_81" id="input_81" placeholder="[结束时间]"  tabindex=5/>出差
								</div>
						</div>
						<div>
								<div id="action_9" _defaultValue="出差"  _status=CONSTS.DEALED  class="actionType action actionTitle" _label="出差,cc">出差</div>
								<div id="action_10" _defaultValue="我要出差" _status=CONSTS.DEALED class="subaction actionTitle actionFlag">我要出差</div>
								<div id="action_11" _status=CONSTS.DEALED _parentCmd="action_9" class="subaction actionTitle actionFlag" _idx="8" _defaultValue="{{开始时间}}到{{结束时间}}出差">
									<input type="text" class="actionInput" name="input_80" id="input_80" placeholder="[开始时间]"  tabindex=4/>到<input type="text" class="actionInput" name="input_81" id="input_81" placeholder="[结束时间]"  tabindex=5/>出差
								</div>
						</div>-->
					</div>
				</div>
			</div>
			<div style="clear:both;"/>
		</div>
	</div>
 </BODY>
</HTML>
<%!
/**
<div>
	<div id="action_3" _defaultValue="请假"  _status=CONSTS.DEALED class="actionType action actionTitle" _label="请假,病假,事假,带薪,年假,qj">请假</div>
	<div id="action_4" _defaultValue="我要请假" _status=CONSTS.DEALED class="subaction actionTitle actionFlag">我要请假</div>
	<div id="action_5" _status=CONSTS.DEALED _parentCmd="action_5" class="subaction actionTitle actionFlag" _idx="5" _defaultValue="{{[开始时间]}}到{{[结束时间]}}请假{{[事由]}}">
		<input type="text" class="actionInput" name="input_50" id="input_50" placeholder="[开始时间]" tabindex=1/>到<input type="text" class="actionInput" name="input_51" id="input_51" placeholder="[结束时间]" tabindex=2/>请假<input type="text" class="actionInput" name="input_52" id="input_52" placeholder="[事由]"  tabindex=3/>
	</div>
</div>
*/
private static final Pattern p = Pattern.compile("\\{\\{.*?\\}\\}");
private String toHtml(Map<String,String> data){
	StringBuilder sb = new StringBuilder();
	//sb.append("<div>\n");
	String _defaultValue=data.get("_defaultValue");
	if(_defaultValue!=null){
		_defaultValue = _defaultValue.trim();
	}
	sb.append("<div id='action_").append(data.get("_idx"));
	sb.append("' _defaultValue='").append(_defaultValue);
	sb.append("' _status='").append(data.get("_status")).append("'");
	if(data.get("_parentCmd")!=null && !data.get("_parentCmd").trim().equals("")){
		sb.append(" _parentCmd='action_").append(data.get("_parentCmd")).append("'");
	}
	if(data.get("_label")!=null && !data.get("_label").trim().equals("")){
		sb.append(" _label='").append(data.get("_label")).append("'");
	}
	if("true".equals(data.get("_fixed"))){
		sb.append(" _fixed='true'");
		
	}
	if(!"".equals(data.get("_timeoutType"))){
		sb.append(" _timeoutType='"+data.get("_timeoutType")+"'");
		
	}
	sb.append(" _isForm='").append(data.get("_isForm")).append("'");
	if(!"true".equals(data.get("_actionType"))){
		sb.append(" _bindTimeoutCmd='").append(data.get("_bindTimeoutCmd")!=null?data.get("_bindTimeoutCmd"):"").append("'");
	}
	sb.append(" _idx='").append(data.get("_idx")).append("'")
	
	.append(" class='actionTitle ");
	if("true".equals(data.get("_actionType"))){
		sb.append("actionType action");
	}else{
		sb.append("subaction actionFlag");
	}
	if("true".equals(data.get("_fixed"))){
		sb.append(" fixDiv");
	}
	sb.append("'>\n");
	
	//{{[开始时间]}}到{{[结束时间]}}请假{{[事由]}}
	if(_defaultValue!=null && _defaultValue.indexOf("{{")!=-1){//有参数
		Matcher m = p.matcher(_defaultValue);
		int i = 0;
		while(m.find()){
			String res = m.group(0);
			//<input type="text" class="actionInput" name="input_50" id="input_50" placeholder="[开始时间]" tabindex=1/>
			StringBuilder inputStr = new StringBuilder();
			inputStr.append("<input type='text' class='actionInput' tabindex=").append(data.get("_idx")).append(i+1)
					.append(" name='input_").append(data.get("_idx")).append(i).append("'")
					.append(" id='input_").append(data.get("_idx")).append(i).append("'");
					/*if(res.indexOf("今天")!=-1){
						inputStr.append(" value='今天'");
					}else if(res.indexOf("本月")!=-1){
						inputStr.append(" value='本月'");
					}*/
					String _inputDefaultValue = null;
					if(i==0){
						_inputDefaultValue = data.get("_inputDefaultValue");
					}else{
						_inputDefaultValue = data.get("_inputDefaultValue"+i);
					}
					if(_inputDefaultValue!=null){
						inputStr.append(" _inputDefaultValue='").append(_inputDefaultValue).append("'");
						inputStr.append(" value='").append(_inputDefaultValue).append("'");
					}
					inputStr.append(" placeholder='").append(res.replace("{{", "").replace("}}","")).append("'/>");
			_defaultValue = _defaultValue.replace(res,inputStr.toString());
			i++;
		}
		sb.append(_defaultValue);
	}else{
		if("true".equals(data.get("_accessBtn")) && _defaultValue!=null){
			sb.append("<span>"+data.get("_text")+"</span>");	
			String[] defaultValues = _defaultValue.split(",");
			String divString = "<span class='accessBtnDiv'>";
			for(int i=0;i<defaultValues.length;i++){
				String isRecord = "";
				if(i==0){
					isRecord = data.get("_isRecord");
				}else{
					isRecord = data.get("_isRecord"+i);
				}
				String _inputStr = "<input type='button' _timeoutCmd='"+(data.get("_timeoutCmd"+i)!=null?data.get("_timeoutCmd"+i):"")+"' _isRecord='"+isRecord+"' _isForm='"+data.get("_isForm")+"' name='access_btn_action_"+data.get("_idx")+i+"' id='access_btn_action_"+data.get("_idx")+i+"' class='accessBtnAction accessBtnActionHover' _status='"+data.get("_status")+"' _defaultValue='"+defaultValues[i]+"' value='"+defaultValues[i]+"'/>";
				divString+=(_inputStr);
			}
			divString+="</span>";
			sb.append(divString);
		}else{
			sb.append(data.get("_defaultValue"));	
		}
	}
	sb.append("\n</div>\n");
	//sb.append("</div>");
	return sb.toString();
}

private String getCmds(){
	StringBuilder cmdsHtml = new StringBuilder();
	List<Map<String,String>> cmds = initDatas();
	StringBuilder sb = new StringBuilder();
	
	String lastGroup = null;
	for(int i=0;i<cmds.size();i++){
		String currentGroup = cmds.get(i).get("_group");
		if(!currentGroup.equals(lastGroup)){
			if(lastGroup==null){
				sb = new StringBuilder();
				sb.append("<div class='actionTypeArea'>\n");
				sb.append(toHtml(cmds.get(i)));
				lastGroup = currentGroup;
			}else{
				sb.append("</div>\n");
				//System.out.println(sb.toString());
				cmdsHtml.append(sb.toString());
				sb = new StringBuilder();
				sb.append("<div class='actionTypeArea'>\n");
				sb.append(toHtml(cmds.get(i)));
				lastGroup = currentGroup;
			}
		}else{
			sb.append(toHtml(cmds.get(i)));
		}
	}
	sb.append("\n</div>");
	//System.out.println(sb.toString());
	cmdsHtml.append(sb.toString());
	return cmdsHtml.toString();
}

private List<Map<String,String>> initDatas(){
	List<Map<String,String>> cmds = new ArrayList<Map<String,String>>();
	Map<String,String> data = new HashMap<String,String>();

	final String ESEARCH_WF = "_WF";
	final String  ESEARCH_DOC = "_DOC";
	final String  ESEARCH_CRM = "_CRM";
	final String  ESEARCH_RSC = "_RSC";

	int i=3;

	

		/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "查询日程");
	data.put("_defaultValue", "我的日程");
	data.put("_isRecord","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_accessBtn","true");
	data.put("_label", "日程,计划,工作安排,备忘,行程,工作,去了哪里,cxrc,wdrc,我的日程");
	data.put("_group", "cxrc");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我的日程");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxrc");
	cmds.add(data);*/
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{人员姓名}}的日程");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxrc");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我{{时间}}的日程");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxrc");
	cmds.add(data);*/
	/*-----------类别结束----------------*/
	
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "新建流程");
	data.put("_defaultValue", "新建流程,流程效率排名报表");
	data.put("_accessBtn","true");
	data.put("_isRecord1","true");
	data.put("_timeoutCmd0","newWorkflowBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "新建流程,查询流程,流程报表,流程效率排名报表,效率排行,流程耗时,流程排名,lc,xjlc,lcxlpmbb");
	data.put("_group", "lc");
	data.put("_isForm","true");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{流程路径}}");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_bindTimeoutCmd","newWorkflowBtn");
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "lc");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "{{流程标题}}流程");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "lc");
	cmds.add(data);*/
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "流程效率排行报表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "lc");
	cmds.add(data);*/
	/*-----------类别结束----------------*/

	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "查询流程");
	data.put("_defaultValue", "微搜流程");
	data.put("_accessBtn","true");
	data.put("_isRecord","true");
	//data.put("_timeoutCmd0","myCreateWorkflowBtn");
	data.put("_timeoutCmd0","esearchWorkflowBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "查询流程,流程报表,流程效率排名报表,效率排行,流程耗时,流程排名,cxlc,微搜流程");
	data.put("_group", "cxlc");
	data.put("_isForm","true");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{流程标题}}");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_bindTimeoutCmd","esearchWorkflowBtn");
	data.put("_timeoutType",ESEARCH_WF);
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxlc");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "{{流程标题}}流程");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "lc");
	cmds.add(data);*/
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "流程效率排行报表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "lc");
	cmds.add(data);*/
	/*-----------类别结束----------------*/

	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "我的请求");
	data.put("_defaultValue", "我创建的流程");
	data.put("_accessBtn","true");
	data.put("_isRecord","true");
	data.put("_timeoutCmd0","myCreateWorkflowBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "查询流程,wdqq,我的请求,我创建的流程,wccdlc");
	data.put("_group", "wdqq");
	data.put("_isForm","true");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{流程标题}}");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_bindTimeoutCmd","myCreateWorkflowBtn");
	data.put("_timeoutType",ESEARCH_WF);
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "wdqq");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "{{流程标题}}流程");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "lc");
	cmds.add(data);*/
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "流程效率排行报表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "lc");
	cmds.add(data);*/
	/*-----------类别结束----------------*/

	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "待办查询");
	data.put("_defaultValue", "我的待办");
	data.put("_accessBtn","true");
	data.put("_isRecord","true");
	data.put("_timeoutCmd0","myWorkflowBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "我的待办,wddb");
	data.put("_group", "wddb");
	data.put("_isForm","true");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{流程路径}}");
	data.put("_bindTimeoutCmd","myWorkflowBtn");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_timeoutType",ESEARCH_WF);
	data.put("_group", "wddb");
	cmds.add(data);

	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{人员姓名}}的{{流程路径}}待办");
	data.put("_bindTimeoutCmd","btmbBtn");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "wddb");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "{{流程标题}}流程");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "lc");
	cmds.add(data);*/
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "流程效率排行报表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "lc");
	cmds.add(data);*/
	/*-----------类别结束----------------*/

	/*---------类别开始---------*/
	/*data = new HashMap<String,String>();
	data.put("_text", "已办事宜");
	data.put("_defaultValue", "已办事宜");
	data.put("_accessBtn","true");
	data.put("_isRecord","true");
	data.put("_timeoutCmd0","handledWfBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "ybsy,已办事宜,我的已办");
	data.put("_group", "ybsy");
	data.put("_isForm","true");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{流程标题}}");
	data.put("_bindTimeoutCmd","handledWfBtn");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_timeoutType",ESEARCH_WF);
	data.put("_group", "ybsy");
	cmds.add(data);*/
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "{{流程标题}}流程");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "lc");
	cmds.add(data);*/
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "流程效率排行报表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "lc");
	cmds.add(data);*/
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "文档新闻");
	data.put("_defaultValue", "播报新闻,系统文档数量,最热文档");
	data.put("_isRecord","true");
	data.put("_isRecord1","true");
	data.put("_isRecord2","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "文档新闻,播报新闻,wdxw,bbxw,xtwdsl,zrwd,系统文档数量,最热文档");
	data.put("_group", "wdxw");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "{{文档标题}}文档");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "wdxw");
	cmds.add(data);*/
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "播报新闻");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "wdxw");
	cmds.add(data);*/
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "知识报表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "多少知识,多少文档,知识报表,最受欢迎文档,最热门文档,知识报表,zsbb");
	data.put("_group", "zsbb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "系统文档数量");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "zsbb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "最热文档列表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "zsbb");
	cmds.add(data);*/
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "客户");
	data.put("_idx", ""+(i++));
	data.put("_defaultValue", "客户城市报表,客户行业报表");
	data.put("_isRecord","true");
	data.put("_isRecord1","true");
	data.put("_accessBtn","true");
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "客户,供应商,集团,公司,单位,企业,供应商,经销商,甲方,合作伙伴,客户经理,cxkh,客户城市报表,客户行业报表,khcsbb,khhybb");
	data.put("_group", "cckh");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{客户名称}}客户");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_timeoutType",ESEARCH_CRM);
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cckh");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{人员姓名}}负责的客户");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_timeoutType",ESEARCH_CRM);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cckh");
	cmds.add(data);
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	/*data = new HashMap<String,String>();
	data.put("_text", "客户报表");
	data.put("_defaultValue", "客户城市报表,客户行业报表");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "客户报表,客户分布,多少客户,行业分布,什么行业,khbb");
	data.put("_group", "khbb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "客户城市报表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "khbb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "客户行业报表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "khbb");
	cmds.add(data);*/
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "写客户联系");
	data.put("_defaultValue", "写客户联系");
	data.put("_timeoutCmd0","xkhlxBtn");
	data.put("_accessBtn","true");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "客户联系,拜访记录,xkhlx");
	data.put("_group", "xkhlx");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "写客户联系");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xkhlx");
	cmds.add(data);*/
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{客户名称}}");
	data.put("_bindTimeoutCmd","xkhlxBtn");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xkhlx");
	cmds.add(data);
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "查询商机");
	data.put("_defaultValue", "创建的商机,滚动的商机");
	data.put("_isRecord","true");
	data.put("_isRecord1","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "商机,销售机会,cxsj,创建的商机,滚动的商机,cjdsj,gddsj");
	data.put("_group", "cxsj");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "{{今天}}创建的商机");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_inputDefaultValue","今天");
	data.put("_group", "cxsj");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{今天}}滚动的商机");
	data.put("_inputDefaultValue","今天");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxsj");
	cmds.add(data);*/
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_defaultValue", "查询人员");
	//data.put("_defaultValue", "谁是");
	//data.put("_accessBtn","true");
	//data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "查询人员,找人,谁是,人,同事,同仁,人员,兄弟,帅哥,美女,美眉,谁,联系方式,邮件,邮箱,电子邮件,邮箱地址,电话,手机,座机,分机,上级,领导,上司,下级,下属,手下,名片,cxry,zr");
	data.put("_group", "cxry");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我要找人");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxry");
	cmds.add(data);*/
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "谁是{{人员姓名}}");
	//data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_timeoutType",ESEARCH_RSC);
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxry");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{人员姓名}}的上级");
	data.put("_bindTimeoutCmd","btmbBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxry");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{人员姓名}}的下级");
	data.put("_bindTimeoutCmd","btmbBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxry");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{部门名称}}成员");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_timeoutType",ESEARCH_RSC);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxry");
	cmds.add(data);
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_defaultValue", "查询工位");
	//data.put("_defaultValue", "工位查询");
	//data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "工位查询,工位,位置,房间,楼层,办公室,座位,cxgw,gwcx");
	data.put("_group", "cxgw");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "工位查询");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxgw");
	cmds.add(data);*/
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{人员姓名}}的工位");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxgw");
	cmds.add(data);
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "人员报表");
	data.put("_accessBtn","true");
	data.put("_defaultValue", "分支机构报表,公司人数报表,新入职员工");
	data.put("_isRecord","true");
	data.put("_isRecord1","true");
	data.put("_isRecord2","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "人员报表,机构,公司,分公司,入职,新人,分部,多少人,新员工,人数,rybb,分支机构报表,公司人数报表,新入职员工,fzjgbb,gsrsbb,xrzyg");
	data.put("_group", "rybb");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我们的分支机构");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "rybb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "公司目前有多少人");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "rybb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{本月}}入职的新员工");
	data.put("_inputDefaultValue","本月");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "rybb");
	cmds.add(data);*/
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_defaultValue", "电话短信");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "打电话,打给,拨通,拨打,呼叫,接通,联系,发短信,dhdx");
	data.put("_group", "dhdx");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "打电话给{{人员姓名}}");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "dhdx");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "发短信给{{人员姓名}}");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "dhdx");
	cmds.add(data);
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_defaultValue", "发消息");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "发消息,内部消息,message,发送名片,发送位置,fxx");
	data.put("_group", "fxx");
	cmds.add(data);
	

	data = new HashMap<String,String>();
	data.put("_defaultValue", "发消息给{{人员姓名}} ");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "fxx");
	cmds.add(data);

	data = new HashMap<String,String>();
	data.put("_defaultValue", "发送名片给{{人员姓名}} ");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "fxx");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "发送位置给{{人员姓名}}");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "fxx");
	cmds.add(data);
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "新建会议");
	data.put("_defaultValue", "新建会议");
	data.put("_timeoutCmd0","xjhyBtn");
	data.put("_isForm","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "定会议室,创建会议,xjhy");
	data.put("_group", "xjhy");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "新建会议");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjhy");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{时间}}开会");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjhy");
	cmds.add(data);*/
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{会议主题}}");
	data.put("_isForm","true");
	data.put("_bindTimeoutCmd","xjhyBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjhy");
	cmds.add(data);
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "考勤外勤");
	data.put("_defaultValue", "我要签到,我要签退,外勤签到");
	data.put("_isRecord","true");
	data.put("_isRecord1","true");
	data.put("_isRecord2","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "签到,签退,打卡,外勤,外勤打卡,kqwq,我要签到,我要签退,外勤签到,wyqd,wyqt,wqqd");
	data.put("_group", "kqwq");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我要签到");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "kqwq");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "我要签退");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "kqwq");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "外勤签到");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "kqwq");
	cmds.add(data);*/
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "考勤报表");
	data.put("_defaultValue", "本月考勤报表,上月考勤报表,今日考勤报表,假期查询");
	data.put("_isRecord","true");
	data.put("_isRecord1","true");
	data.put("_isRecord2","true");
	data.put("_isRecord3","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "考勤情况,考勤报表,考勤数据,考勤记录,请假,出差,公出,加班,迟到,早退,旷工,漏签,异常考勤,缺勤,假期,年假,请假额度,kqbb,考勤报表,假期额度,kqbb,jqcx,本月考勤报表,上月考勤报表,今日考勤报表,bykqbb,sykqbb,jrkqbb");
	data.put("_group", "kqbb");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我{{本月}}的考勤报表");
	data.put("_inputDefaultValue","本月");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "kqbb");
	cmds.add(data);*/
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{人员姓名}}的考勤报表");
	data.put("_bindTimeoutCmd","btmbBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "kqbb");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我还剩多少假可以请");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "kqbb");
	cmds.add(data);*/
	/*-----------类别结束----------------*/
	
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "天气预报");
	data.put("_defaultValue", "天气预报");
	data.put("_isForm","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "天气预报,tqyb");
	data.put("_group", "tqyb");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "天气预报");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "tqyb");
	cmds.add(data);*/
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{地点}}");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "tqyb");
	cmds.add(data);
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_defaultValue", "导航");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "导航,dh");
	data.put("_group", "dh");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "导航到{{位置}}");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "dh");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "导航到{{客户}} ");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "dh");
	cmds.add(data);
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "新建微博");
	data.put("_accessBtn","true");
	data.put("_defaultValue", "新建微博");
	data.put("_timeoutCmd0","xjwbBtn");
	data.put("_isForm","true");
	data.put("_isRecord","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "微博,工作微博,日志,工作日志,日报,工作日报,xjwb,新建微博");
	data.put("_group", "xjwb");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "新建微博");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjwb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "补交昨天的微博");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjwb");
	cmds.add(data);*/
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{微博内容}}");
	data.put("_isForm","true");
	data.put("_bindTimeoutCmd","xjwbBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjwb");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "补交微博{{微博内容}} ");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjwb");
	cmds.add(data);*/

	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "打开{{人员姓名}}的微博");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjwb");
	cmds.add(data);*/
	
	/*-----------类别结束----------------*/

	data = new HashMap<String,String>();
	data.put("_text", "补交微博");
	data.put("_accessBtn","true");
	data.put("_defaultValue", "补交昨天的微博");
	data.put("_timeoutCmd0","bjwbBtn");
	data.put("_isForm","true");
	data.put("_isRecord","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "微博,工作微博,日志,工作日志,日报,工作日报,补交昨天的微博,bjztdwb");
	data.put("_group", "bjwb");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "新建微博");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjwb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "补交昨天的微博");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjwb");
	cmds.add(data);*/
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{微博内容}}");
	data.put("_bindTimeoutCmd","bjwbBtn");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "bjwb");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "补交微博{{微博内容}} ");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjwb");
	cmds.add(data);*/

	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "打开{{人员姓名}}的微博");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjwb");
	cmds.add(data);*/
	
	/*-----------类别结束----------------*/

	data = new HashMap<String,String>();
	data.put("_text", "查询微博");
	data.put("_accessBtn","true");
	data.put("_defaultValue", "我的微博");
	data.put("_isRecord","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "微博,工作微博,日志,工作日志,日报,工作日报,我的微博,wdwb");
	data.put("_group", "cxwb");
	cmds.add(data);

	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{人员姓名}}的微博");
	data.put("_bindTimeoutCmd","btmbBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxwb");
	cmds.add(data);
	
	/*-----------类别结束----------------*/
	
	
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "销售报表");
	data.put("_accessBtn","true");
	data.put("_defaultValue", "我的合同收款,我的项目验收,我的直销合同情况");
	data.put("_isRecord","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "合同收款,回款,项目验收,完成了多少验收,完成了多少指标,直销合同,销售,合同款,合同额,签单情况,直销情况,xsbb,wdhtsk,wdxmys,wdzxht");
	data.put("_group", "xsbb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{人员姓名}}的合同收款情况");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_bindTimeoutCmd","btmbBtn");
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xsbb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{客户名称}}的合同收款情况");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_bindTimeoutCmd","btmbBtn");
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xsbb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{人员姓名}}的项目验收情况");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_bindTimeoutCmd","btmbBtn");
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xsbb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{人员姓名}}直销合同情况");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_bindTimeoutCmd","btmbBtn");
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xsbb");
	cmds.add(data);
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "业绩排行榜");
	data.put("_defaultValue", "全国业绩排行榜");
	data.put("_isRecord","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "业绩排名,排行,指标,差距,团队业绩,yjphb,全国业绩排行榜qgyjphb");
	data.put("_group", "yjphb");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "全国业绩排行榜");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "yjphb");
	cmds.add(data);*/
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "{{时间}}团队的业绩");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "yjphb");
	cmds.add(data);*/
	
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_defaultValue", "查询项目任务");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "项目执行,任务执行,cxxmrw");
	data.put("_group", "cxxmrw");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "查询{{项目名称}}项目");
	data.put("_bindTimeoutCmd","btmbBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxxmrw");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "查询{{任务名称}}任务");
	data.put("_bindTimeoutCmd","btmbBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cxxmrw");
	cmds.add(data);
	
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "报销");
	data.put("_defaultValue", "我要报销");
	data.put("_timeoutCmd0","bxBtn");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "报销,bx,我要报销,wybx");
	data.put("_group", "bx");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我要报销");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "bx");
	cmds.add(data);
	*/
	data = new HashMap<String,String>();
	data.put("_defaultValue", "帮我报销{{时间}}的{{报销科目}}{{报销金额}} ");
	data.put("_idx", ""+(i++));
	data.put("_bindTimeoutCmd","bxBtn");
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "bx");
	cmds.add(data);
	
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "报销报表");
	data.put("_defaultValue", "部门费用支出,报销标准,报销报表");
	data.put("_isRecord","true");
	data.put("_isRecord1","true");
	data.put("_isRecord2","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "报销报表,报销情况,报销标准,餐帖,餐补,餐费,话费,油补,发生的费用,费用支出,产生的费用,bxbb,部门费用支出,报销标准,报销报表,bmfyzc,bxbz,bxbb");
	data.put("_group", "bxbb");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "报销报表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "bxbb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "我的报销标准是多少");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "bxbb");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "我部门这个月的费用支出");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "bxbb");
	cmds.add(data);
	*/
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "班车查询");
	data.put("_defaultValue", "班车照片,班车时刻表,现在的班车");
	data.put("_isRecord","true");
	data.put("_isRecord1","true");
	data.put("_isRecord2","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "班车照片,班车时刻表,现在的班车,bccx,bczp,bcskb,xzdbc");
	data.put("_group", "bccx");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "班车资料");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "bccx");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "班车时刻表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "bccx");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "现在还有班车吗");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "bccx");
	cmds.add(data);*/
	
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "订机票");
	data.put("_defaultValue", "订机票");
	data.put("_isRecord","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "机票,航班,djp");
	data.put("_group", "djp");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "订机票");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "djp");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "帮我预定{{开始时间}}到{{结束时间}}的机票");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "djp");
	cmds.add(data);*/
	
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "其他");
	data.put("_defaultValue", "技术满意度报表,培训活动");
	data.put("_isRecord","true");
	data.put("_isRecord1","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "打开应用,培训活动,技术满意度,技术之星,服务之星,英雄榜,dkyy,技术满意度报表,培训活动,jsmydbb,pxhd");
	data.put("_group", "qt");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "打开{{应用名称}}");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "dkyy");
	cmds.add(data);*/
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "下星期公司有什么培训");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "dkyy");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "技术满意度报表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "dkyy");
	cmds.add(data);*/
	
	
	/*-----------类别结束----------------*/

	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "打开应用");
	data.put("_defaultValue", "所有应用");
	data.put("_timeoutCmd0","allAppBtn");
	data.put("_isRecord","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "打开应用,所有应用,dkyy,syyy");
	data.put("_group", "dkyy");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "打开{{应用名称}}");
	data.put("_bindTimeoutCmd","allAppBtn");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "dkyy");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "下星期公司有什么培训");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "dkyy");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "技术满意度报表");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "dkyy");
	cmds.add(data);*/
	
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "用车申请");
	data.put("_defaultValue", "我要订车");
	data.put("_timeoutCmd0","dcBtn");
	data.put("_accessBtn","true");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "订车,预约车辆,预定车,用车,ycsq,我要订车,wydc");
	data.put("_group", "ycsq");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我要订车");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "ycsq");
	cmds.add(data);*/
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{订车事由}}");
	data.put("_idx", ""+(i++));
	data.put("_isForm","true");
	data.put("_bindTimeoutCmd","dcBtn");
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "ycsq");
	cmds.add(data);
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "预约专家");
	data.put("_isForm","true");
	data.put("_defaultValue", "预约专家");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "空闲专家,预约专家,查找专家,yyzj");
	data.put("_group", "yyzj");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "预约专家");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "yyzj");
	cmds.add(data);*/
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{专家关键字}}");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "yyzj");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "查找空闲的{{专家关键字}}专家");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "yyzj");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "查找空闲的集成专家");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "yyzj");
	cmds.add(data);
	*/
	
	/*-----------类别结束----------------*/
	
	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "工作情况");
	data.put("_defaultValue", "团队工作汇总,我的工作汇总");
	data.put("_isRecord","true");
	data.put("_isRecord1","true");
	data.put("_isRecord2","true");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "工作情况,工作汇总,gzqk,团队工作汇总,我的工作汇总,tdgzhz,wdgzhz");
	data.put("_group", "gzqk");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我的工作汇总");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "gzqk");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "团队工作汇总");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "gzqk");
	cmds.add(data);*/
	/*-----------类别结束----------------*/

	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "请假");
	data.put("_defaultValue", "我要请假,请事假,请病假,请年假");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_accessBtn","true");
	data.put("_timeoutCmd0","qjBtn");
	data.put("_fixed","true");
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "请假,事假,病假,年假,婚假,产假,看护假,哺乳假,丧假,qj,我要请假,请事假,请病假,请年假,wyqj,qsj,qbj,qnj");
	data.put("_group", "qj");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我要请假,请事假,请病假,请年假");
	data.put("_accessBtn","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "qj");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{开始时间}}请假");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "qj");
	cmds.add(data);
	
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{开始时间}}到{{结束时间}}请假{{事由}} ");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "qj");
	cmds.add(data);*/
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{事由}} ");
	data.put("_bindTimeoutCmd","qjBtn");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "qj");
	cmds.add(data);
	/*-----------类别结束----------------*/

	

	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "新建日程");
	data.put("_defaultValue", "新建日程");
	data.put("_timeoutCmd0","xjrcBtn");
	data.put("_accessBtn","true");
	data.put("_isForm","true");
	data.put("_fixed","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_group", "xjrc");
	data.put("_label", "日程,计划,工作安排,备忘,行程,工作,xjrc");
	cmds.add(data);

	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{日程主题}}");
	data.put("_bindTimeoutCmd","xjrcBtn");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjrc");
	cmds.add(data);
	
	/*
	data = new HashMap<String,String>();
	data.put("_text", "新建日程");
	data.put("_defaultValue", "新建日程");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjrc");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "提醒我{{时间}}{{日程主题}}");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "xjrc");
	cmds.add(data);
	*/
	/*-----------类别结束----------------*/
	


	/*---------类别开始---------*/
	data = new HashMap<String,String>();
	data.put("_text", "出差");
	data.put("_accessBtn","true");
	data.put("_isForm","true");
	data.put("_timeoutCmd0","bussiessBtn");
	data.put("_defaultValue", "我要出差");
	data.put("_fixed","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "true");
	data.put("_label", "新建出差流程,cc,我要出差,wycc");
	data.put("_group", "cc");
	cmds.add(data);

	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{事由}}");
	data.put("_bindTimeoutCmd","bussiessBtn");
	data.put("_isForm","true");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cc");
	cmds.add(data);
	
	/*data = new HashMap<String,String>();
	data.put("_defaultValue", "我要出差");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cc");
	cmds.add(data);

	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{开始时间}}到{{结束时间}}出差");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cc");
	cmds.add(data);
	
	data = new HashMap<String,String>();
	data.put("_defaultValue", "{{开始时间}}出差");
	data.put("_idx", ""+(i++));
	data.put("_status", CONSTS.DEALED);
	data.put("_actionType", "false");
	data.put("_parentCmd", ""+(i-2));
	data.put("_group", "cc");
	cmds.add(data);*/
	
	/*-----------类别结束----------------*/
	
	return cmds;
}


%>
