/*
*多了一个属性SendTo必设
*
*/
function  MessageWindow(para){	
	BaseWindow.call(this,para)
	this.para=para;
	this.objBody=null;
	this.lastMsgTime="";
	this.lastFormJid="";
}

MessageWindow.prototype=new BaseWindow();

MessageWindow.prototype._setName=function(){	
	this._verifyObjWindow();
	this.objWindow.find(".name").html(rMsg.messageWindowChatWith+this.para.name+rMsg.messageWindowChat);
}
MessageWindow.prototype._createMessage=function(){
	var str=	
			"<table height='100%' width='100%'><tr><td  width='100%'>"+
			"<div class='msg'>"+
			"	<div class='info'></div>" +									
			"	<div class='input'>" +
			"		<table width='100%' height='100%'><tr><td width='100%'><textarea class='textareabase'></textarea></td><td width='58'><span class='btnSend'  ACCESSKEY='S'></span></td></tr></table>" +
			"	</div>" +
			"	<div class='toolbar'></div>" +
			"</div>"+
			"</td><td>"+
			"	<div class='user'><table  width='100%' height='100%'><tr height='*'><td><div style='text-align:center;vertical-align :middle;background:url(/messager/images/window-user_wev8.gif) no-repeat center center;height:80;'>";
	if(Util.null2String(this.para.user.messagerurl)!="") str+="<img src='"+Util.null2String(this.para.user.messagerurl)+"' align='absmiddle'   height='69' width='69'>";
	str+="	</div></td></tr><tr ><td  style='height:150px;overflow:auto;'>"+
			
			"<table width=\"100%\"><colgroup><col width=\"40%\"><col width=\"*\"></colgroup>"+
			"<tr><td class='userfield' nowrap>姓<span class='space'/>名：</td><td class='uservalue'>"+Util.null2String(this.para.user.lastname)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>分<span class='space'/>部：</td><td class='uservalue'>"+Util.null2String(this.para.user.subcompany)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>部<span class='space'/>门：</td><td class='uservalue'>"+Util.null2String(this.para.user.department)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>直接上级：</td><td class='uservalue'>"+Util.null2String(this.para.user.superior)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>岗<span class='space'/>位：</td><td class='uservalue'>"+Util.null2String(this.para.user.jobtitle)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>电<span class='space'/>话：</td><td class='uservalue'>"+Util.null2String(this.para.user.telephone)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>移动电话：</td><td class='uservalue'>"+Util.null2String(this.para.user.mobile)+"</td></tr>"+
			"<tr><td class='userfield' nowrap>电子邮件：</td><td class='uservalue'>"+Util.null2String(this.para.user.email)+"</td></tr>"+
			
			"</table>"+
			
			"</td></tr><tr height='28px'><td align='right'><img src='/messager/images/window-logo_wev8.png'></td></tr></table>"+
			"</div> "+
			"</td></tr></table>"


	this.objBody.append(str);

	var $this=this;
	this.objBody.find(".textareabase").bind('keypress', function(e) {
		
		var code = (e.keyCode ? e.keyCode : e.which);
		
		if(code==13){
			var value=$this.objBody.find(".textareabase").val();
			$this.send(value);					
			return false;
		} 
	});	
	
	
	this.objBody.find(".input").children("textarea").bind('focus', function(e) {		
		$this.send(Config.FocusFlag);	
	});	
	this.objBody.find(".input").children("textarea").bind('blur', function(e) {		
		$this.send(Config.BlurFlag);
	});	
	
	this.objBody.find(".btnSend").bind('click', function(e) {
			var value=$this.objBody.find(".textareabase").val();		
			$this.send(value);					
	});	
}

MessageWindow.prototype._setLogo=function(){	
	this._verifyObjWindow();
	this.objWindow.find(".logo").append("<img src='"+this.para.userImg+"'>");
	this.objWindow.find(".logo").append("<div class='inputstateIcon'  style='position:absolute;left:20px;top:11px;display:none'>" +
			"<img src='/messager/images/input_wev8.gif' height='12px'>" +
			"</div>");
}
MessageWindow.prototype.hide=function(){
	if(this.isShow){
		ControlWindow.intMessagerWindowNum--;
		this.objWindow.fadeOut("fast");
		this.isShow=false;	
	}	
}
MessageWindow.prototype._createToolbar=function(){	
	this.objBody.find(".msg .toolbar").append(
			"<div style='float:left'><span id='btnSelectedAcc_"+this.para.id+"' style='left:0;'></span></div>"+	
			"<div style='float:right'>"+
			"	<span class='button'  style='padding-top:3' onclick='openPage(\"email\",\""+this.para.sendTo+"\",this.firstChild.title)'><img src='/messager/images/email_wev8.gif'  align='absmiddle' title='"+rMsg.toolSendEmail+"' /></span>"+
			(Config.canSendSms?
			"	<span class='button'   style='padding-top:2;padding-left:0' onclick='openPage(\"sms\",\""+this.para.sendTo+"\",this.firstChild.title)'><img src='/messager/images/phone_wev8.gif'  align='absmiddle' title='"+rMsg.toolSendSMS+"' /></span>"			
			:"")+
			"	<span class='button'  style='padding-top:3' onclick='openPage(\"prop\",\""+this.para.sendTo+"\",this.firstChild.title)'><img src='/messager/images/profile_wev8.gif'  align='absmiddle'  title='"+rMsg.toolProp+"'  /></span>"+			
			"	<span class='button'   style='padding-top:3;padding-left:1'  onclick='openPage(\"history\",\""+this.para.sendTo+"\",this.firstChild.title)'><img src='/messager/images/history_wev8.gif'  align='absmiddle'  title='"+rMsg.toolHistory+"' /></span>"+
			"</div>"
	);
	
	var $this=this;
	this.objBody.find(".msg .toolbar").children(".button").click(function(){
		if(this.type=="alert"){
			 $this.send(Config.AlertFlag)
		}		
	});
}
MessageWindow.prototype._fixMessageBody=function(){		

	var infoHeight=parseInt(this.objBody[0].style.height)-60-38;
	
	
	if(window.ActiveXObject){
		infoHeight=infoHeight+13;
	} 
	
	this.objBody.find(".info").css("height",""+infoHeight);
	
}


MessageWindow.prototype._subShow=function(){
	if(this.cusData.firstShow!="false"){
		//var infoHeight=parseInt(this.objBody.find(".user")[0].clientHeight)-60-35;
		//this.objBody.find(".info").height(infoHeight);
		this.cusData.firstShow="false";
	} 
	ControlWindow.intMessagerWindowNum++;
	//this.objBody.find(".info").html("");
	//this.objBody.find(".input").children("textarea")[0].focus();	
}
MessageWindow.prototype.showMessage=function(msg,fromJid,strTime){
	if($.trim(msg)=="") return;
	//var myImg=document.getElementById("imgMyLogo").src;
	var myImg=""; 
	var msgTime;
	if(strTime==null){
		msgTime=Util.getCurrentTimeForMsg();
	} else {
		msgTime=strTime;
	}
	var img="";
	var info=this.objBody.find(".info");
	if(msgTime==this.lastMsgTime&&this.lastFormJid==fromJid){
		this.objBody.find(".tdMsgs:last").append("<div style='word-wrap: break-word; word-break: break-all; width: 100%;'>"+msg+"</div>");
	} else { 
		var showName="";
		if(fromJid=="me"){
			img=getUserIconPath(Util.cutResourceAtFlag(jidCurrent));
			this.lastFormJid="me";
			showName=nickname;
		} else {
			img=getUserIconPath(Util.cutResourceAtFlag(fromJid));
			this.lastFormJid=fromJid;
			 showName=this.para.name;
		}		
		if(this.lastMsgTime!=""){
			//this.objBody.find(".tdMsgs:last").append("<div style='color:#808080'>"+this.lastMsgTime+"</div>");
		}		
		if(img==null){
			img="/messager/images/icon-blue_wev8.gif";
		}
		var strDiv="<table width='90%'><tr><td valign='top' width='36px'><img src='"+img+"' width='33px'/></td>"+
			   "	<td  valign='top' class='tdMsgs'>"+
			   "		<div><b>"+showName+":</b><font style='color:#808080'>"+msgTime+"</font></div>"+
			   "<div style='word-wrap: break-word; word-break: break-all; width: 100%;'>"+msg+"</div>"+
			   "	</td>"+
			   "</tr></table>";	
		info.append(strDiv);		
	}
	this.lastMsgTime=msgTime;
	
	//显示消息
	info[0].scrollTop=info[0].scrollTop+info[0].offsetHeight;
	this.show();
}
MessageWindow.prototype.send=function(msg,isNeedChangeStr){
	if($.trim(msg)=="") return;
	//alert(realLength(msg))
	if(realLength(msg)>800){alert("发送消息内容超长，请分条发送。");return;}
	msg=this.changeStr(msg,isNeedChangeStr);
	//send 消息	
	sendMessage(this.para.sendTo,msg);	
	
	if(
			$.trim(msg)!=Config.FocusFlag&&
			$.trim(msg)!=Config.BlurFlag&&
			$.trim(msg)!=Config.AlertFlag&&
			$.trim(msg)!=Config.OnlineFlag
	){
		this.showMessage(msg,"me");
		
		//清空消息
		this.objBody.find(".textareabase").val('');
	}
}
MessageWindow.prototype.changeStr=function(str,isNeedChangeStr){
	if(isNeedChangeStr==false) {
		return  str;
	}else {
		str=str.replace(/</g,"&lt;");
		str=str.replace(/>/g,"&gt;");
		return str;
	}
}
MessageWindow.prototype.receive=function(msg,fromJid,receiveTime){	
	if($.trim(msg)==""){
		return;	
	}else if($.trim(msg)==Config.AlertFlag){
		//doShowSomeBodyTempMsg(fromJid);
		return ;		
	} else if($.trim(msg)==Config.FocusFlag){			
		this.objWindow.find(".logo").children(".inputstateIcon").show();
		return ;
	}else if($.trim(msg)==Config.BlurFlag){
		this.objWindow.find(".logo").children(".inputstateIcon").hide();
		return ;
	}else if($.trim(msg)==Config.OnlineFlag){		 
		return ;
	}
	//Multimedia.playSound("reciveMessage");
	this.showMessage(msg,fromJid,receiveTime);
}

//重载 BaseWindow的以下方法
MessageWindow.prototype._setButtons=function(){		
	
}

MessageWindow.prototype._fixSize=function(){	
	this._fixWindow();
	this._fixMessageBody();
}
MessageWindow.prototype._initAccessory=function(){
	getUploader(this,this.para.id,this.para.sendTo)
}
MessageWindow.prototype._create=function(){		
	this._createBase();
	this.objBody=this.objWindow.find(".body");
	this._createMessage();
	this._createToolbar();		
}


/*
 * Function: 取字符串字节长度 Document by by 2007-3-9
 */
function realLength(str) {
	var j=0;
	for (var i=0;i<=str.length-1;i++) {
		j=j+1;
		if ((str.charCodeAt(i))>127) {
			j=j+1;
		}
	}
	return j;
}
