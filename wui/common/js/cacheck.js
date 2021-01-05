/**
 * need jqeury  SEH_GetCertUniqueID
 * 成功 返回 cert 证书 key ;  signed 签名随机数
 */
var SafeEngineObj = function(prop){
	var root = prop.window || window ;
	
	// 检查浏览器环境是否正常
	this.checkEnvIsOk = function(){
		if(isIE()){
			return !! (root['SafeEngineCtl'] && ('ErrorCode' in root['SafeEngineCtl'])) ;
		}else{
			return !! root['UCCGetPluggedeKey'] ; 
		}
	}
	//检查浏览器
	var isIE = function(){
		if (!!(root['ActiveXObject'] || "ActiveXObject" in root))
			return true;
		 else
			return false;
	}
	
}


var SafeEngineCtlObj = {
	configUsb:21,
	isbindEvent : false ,
	isTest : false ,
	usbType : -1 ,
	ischeckPass:false,
	clickBtnId: '',
	plugin : window ,
	callback : null ,
	form : null ,
	SafeEngineObj : null ,
	pluginMsg : {
		"Firefox" : {msg:"22004,18700;#;7171",link : "/hrm/ca_interface/safeengine_FF.zip"}, // "22004,18700;382100"
		"ie" : {msg : "22004,18700;#;7171",link : "/hrm/ca_interface/safeengineCom_IE.zip"},
	},
	isDoCACheck : function(){
		return SafeEngineCtlObj.configUsb == SafeEngineCtlObj.usbType ;
	},
	dialog : function(ret){
		var method = 'getCA_CHECK_ERR_MGG' ;
		if(ret['errCode']){
			$.ajax({
				url:'/login/LoginOperation.jsp',
				type:'post',
				data:{method:method,
				      code:ret.step,
				      errCode:ret.errCode,
				      langid:$("#islanguid").val()},
				dataType:'json',
				success:function(data){
					var msg = data.msg || "";
					alert(msg);
				}
			});	
		}else{
			alert(ret);
		}
	},
	checkEnv : function(){ // SafeEngineCtl.SEH_InitialSession
		var isok = SafeEngineCtlObj.SafeEngineObj.checkEnvIsOk()  ,msgObj;
		
		if(SafeEngineCtlObj.isIE()){ // ErrorCode
			msgObj = SafeEngineCtlObj.pluginMsg['ie'] ;
		}else{
			var userAgent = navigator.userAgent ;
			if(userAgent.indexOf('Firefox') > -1) msgObj = SafeEngineCtlObj.pluginMsg['Firefox'] ;
		}
		
		if(!msgObj) msgObj = {msg:"22004,18700;382100",link:"javascript:void(0) ;"} ;
		
		if(isok) return true ;
		$.ajax({
			url:'/login/LoginOperation.jsp',
			type:'post',
			data:{method:'getHtmlMsg',msg:msgObj.msg,langid:$("#islanguid").val()},
			dataType:'json',
			success:function(data){
				var msg = data.msg ;
				var ms = msg.split(';#;');
				$('#errorMessage').html(ms[0]+(ms[1]?('<a href="'+msgObj.link+'" >'+ms[1]+'</a>') : ""));
			}
		});
		return false ;
	},
	ajaxCheck :function(loginInput,from1,clickBtnId,needCA,callback){
		SafeEngineCtlObj.callback = callback ;
		SafeEngineCtlObj.form = from1 ;
		
		var $login = $("#"+loginInput) , loginVal = encodeURIComponent($login.val());
		if(needCA != '1') {
			return ;
		}
		SafeEngineCtlObj.clickBtnId = clickBtnId ;
		
		$login.blur(function(){
			if(document.all("errorMessage")) document.all("errorMessage").innerHTML = "";
			var _message = document.all("message");
			if(_message && _message.value == "101"){
				_message.value = "";
			}
			SafeEngineCtlObj.ajaxSend(loginInput,from1);
		});
		
		if(loginVal){// exist
			SafeEngineCtlObj.ajaxSend(loginInput,from1);
		}
	},
	ajaxSend : function(loginInput,from1){
		var $login = $("#"+loginInput) ;
		
		$.ajax({
			url :"/login/LoginOperation.jsp",
			type:"post",
			data:{method:"checkCA",loginid:encodeURIComponent($login.val())},
			dataType:"json",
			success : function(data){
				SafeEngineCtlObj.usbType = data.usbType ;
				var trKey='ca_pin_tr' ;
				if(SafeEngineCtlObj.isDoCACheck()){ // show pin
					$('#'+trKey+"_height").show();
					$('#'+trKey).show();
				}else{
					$('#'+trKey+"_height").hide();
					$('#'+trKey).hide();
				}
				if(SafeEngineCtlObj.isbindEvent) return  ;
				
			},
			error : function(){
				alert('ajaxCheck ca err!');
			}
		});
	},
	
	
	submit : function(){
		if(SafeEngineCtlObj.isDoCACheck()){
			SafeEngineCtlObj.checkBorser() ;
			var isok = SafeEngineCtlObj.checkEnv() ;
			if(!isok) return false ;
			
			var msgObj = SafeEngineCtlObj.initErrorMsg() ;
			var pin = $.trim($('#caPin').val());
			var msgPin = $.trim($('#for_caPin').text()) ;
			if(!pin){
				SafeEngineCtlObj.dialog(msgPin);
				return false ;
			}
			SafeEngineCtlObj.init(pin,'8888',function(ret){
				SafeEngineCtlObj.createParams(ret.cert,ret.signed,$('form[name="'+SafeEngineCtlObj.form+'"]'));
				SafeEngineCtlObj.callback() ; // ca submit
			},function(ret){
				SafeEngineCtlObj.dialog(ret);
				if(console){
					console.log(ret.toString());
				}
			});
		}else{
			SafeEngineCtlObj.callback() ;  // no ca submit
		}
	},
	
	createParams : function(cert,signed,$form){
		var $cert = $('#cert',$form) , $sign = $('#signed',$form);
		
		if($cert.length == 0) {
			$form.append('<input type="hidden" id="cert" name="cert" />');
			$cert = $('#cert',$form) ;
		}
		if($sign.length == 0){
			$form.append('<input type="hidden" id="signed" name="signed" />');
			$sign = $('#signed',$form) ;
		}
		$cert.val(cert);
		$sign.val(signed);
	},
	checkBorser:function(){
		SafeEngineCtlObj.SafeEngineObj = new SafeEngineObj({ "window" : SafeEngineCtlObj.plugin}) ;
		if(SafeEngineCtlObj.isIE()){
			var $SafeEngineCtlDiv = $('#SafeEngineCtlDiv',SafeEngineCtlObj.plugin.document) ,
			 	$SafeEngineCtl = $('#SafeEngineCtl',SafeEngineCtlObj.plugin.document) ;
			if($SafeEngineCtlDiv.length == 0 && $SafeEngineCtl.length == 0){
				$(SafeEngineCtlObj.plugin.document.body).append('<div id="SafeEngineCtlDiv" style="display:none;"><OBJECT ID="SafeEngineCtl"  CLASSID="CLSID:B48B9648-E9F0-48A3-90A5-8C588CE0898F" width="300" height="50" border=0 ></OBJECT></div>') ;
			}else{
				// others no check
			}
		}
	},
	//获取 唯一key
	initUniqueKey:function(successCallback,errorCallback,checkCallBack,pwd){
		// check
		if(!SafeEngineCtlObj.SafeEngineObj.checkEnvIsOk()){
			var isok = SafeEngineCtlObj.SafeEngineObj.checkEnvIsOk()  ,msgObj;
			
			if(SafeEngineCtlObj.isIE()){ // ErrorCode
				msgObj = SafeEngineCtlObj.pluginMsg['ie'] ;
			}else{
				var userAgent = navigator.userAgent ;
				if(userAgent.indexOf('Firefox') > -1) msgObj = SafeEngineCtlObj.pluginMsg['Firefox'] ;
			}
			
			if(!msgObj) msgObj = {msg:"22004,18700;382100",link:"javascript:void(0) ;"} ;
			
			if(isok) return ;
			$.ajax({
				url:'/login/LoginOperation.jsp',
				type:'post',
				data:{method:'getHtmlMsg',msg:msgObj.msg,langid:$("#islanguid").val()},
				dataType:'json',
				success:function(data){
					var msg = data.msg ;
					var ms = msg.split(';#;');
					var htmlmsg = ms[0]+(ms[1]?('<a href="'+msgObj.link+'" >'+ms[1]+'</a>') : "");
					checkCallBack(htmlmsg);
				}
			});
			return ;
		}
		
		if(SafeEngineCtlObj.isIE()){
			var SafeEngineCtl = SafeEngineCtl ? SafeEngineCtl : SafeEngineCtlObj.plugin.SafeEngineCtl,strCert ;
			
			if(!SafeEngineCtl) {
				errorCallback(SafeEngineCtlObj.makeReturn('-1000','',''));
				return ;
			}
			SafeEngineCtl.SEH_InitialSession(0xa,'com1',pwd,0,0xa,'com1','');
			if(SafeEngineCtl.ErrorCode!=0){
				SafeEngineCtl.SEH_ClearSession();
				errorCallback(SafeEngineCtlObj.makeReturn('-1',SafeEngineCtl.ErrorCode,'SEH_InitialSession'));
				return ;
			}
			
			strCert = SafeEngineCtl.SEH_GetSelfCertificate(0xa,'com1','');
			if(SafeEngineCtl.ErrorCode!=0){
				SafeEngineCtl.SEH_ClearSession();
				errorCallback( SafeEngineCtlObj.makeReturn('-1',SafeEngineCtl.ErrorCode,'SEH_GetSelfCertificate'));
				return ;
			}
			
			var uk = SafeEngineCtl.SEH_GetCertUniqueID(strCert) ;
			
			if(SafeEngineCtl.ErrorCode!=0){
				SafeEngineCtl.SEH_ClearSession();
				errorCallback(SafeEngineCtlObj.makeReturn('-1',SafeEngineCtl.ErrorCode,'SEH_GetCertUniqueID'));
				return ;
			}
			
			successCallback(uk);
			
			
			return ;
		}else{
			var strCert,i,strSigned ,usbkey,comtype,
				UCCGetPluggedeKey = UCCGetPluggedeKey ? UCCGetPluggedeKey : SafeEngineCtlObj.plugin.UCCGetPluggedeKey,
				SEH_GetSelfCertificate = SEH_GetSelfCertificate ? SEH_GetSelfCertificate : SafeEngineCtlObj.plugin.SEH_GetSelfCertificate,
				SEH_SignData = SEH_SignData ? SEH_SignData : SafeEngineCtlObj.plugin.SEH_SignData,
			    SEH_GetCertUniqueID = SEH_GetCertUniqueID ? SEH_GetCertUniqueID : SafeEngineCtlObj.plugin.SEH_GetCertUniqueID ;
			new UCCGetPluggedeKey().then(function(krs){
				var list = krs.DevPluggedTypeList || '', arr = list.split(";"),lastArr = arr[arr.length-1].split("$$");
					usbkey = parseInt(arr[0],16) + "" ;
					comtype = (lastArr[0]||'').indexOf('2') >=0 ? 'com2' : 'com1' ;
				new SEH_GetSelfCertificate(usbkey,comtype,"","0","","","","0").then(function(certData){
					strCert = certData ;
					new SEH_GetCertUniqueID("","","","0","","","", strCert, "0").then(function(ukdata){
						successCallback(ukdata);
					},function(error){
						var rs = SafeEngineCtlObj.makeReturn('-1', error.LastError,'SEH_GetCertUniqueID');
						errorCallback(rs);
					});
				},function(error){
					var rs = SafeEngineCtlObj.makeReturn('-1', error.LastError,'SEH_GetSelfCertificate');
					errorCallback(rs);
				});
			},function(error){
				var rs = SafeEngineCtlObj.makeReturn('-1', error.LastError,'SEH_GetSelfCertificate');
				errorCallback(rs);
			});
		}
	},
	// 发起ca认证
	init : function(pwd,random,successCallback,errorCallback){
		if(SafeEngineCtlObj.isIE()){
			SafeEngineCtlObj.initIE(pwd,random,successCallback,errorCallback) ;
		}else{
			SafeEngineCtlObj.initNotInIe(pwd,random,successCallback,errorCallback);
		}
	},
	initIE : function(pwd,random,successCallback,errorCallback){
		var strCert,i,strSigned , SafeEngineCtl = SafeEngineCtl ? SafeEngineCtl : SafeEngineCtlObj.plugin.SafeEngineCtl ;
		
		if(!SafeEngineCtl) {
			errorCallback(SafeEngineCtlObj.makeReturn('-1000','',''));
			return ;
		}
		SafeEngineCtl.SEH_InitialSession(0xa,'com1',pwd,0,0xa,'com1','');
		if(SafeEngineCtl.ErrorCode!=0){
			SafeEngineCtl.SEH_ClearSession();
			errorCallback(SafeEngineCtlObj.makeReturn('-1',SafeEngineCtl.ErrorCode,'SEH_InitialSession'));
			return ;
		}
		strCert = SafeEngineCtl.SEH_GetSelfCertificate(0xa,'com1','');
		if(SafeEngineCtl.ErrorCode!=0){
			SafeEngineCtl.SEH_ClearSession();
			errorCallback( SafeEngineCtlObj.makeReturn('-1',SafeEngineCtl.ErrorCode,'SEH_GetSelfCertificate'));
			return ;
		}
		i = SafeEngineCtl.SEH_SetConfiguration(0);
		if(SafeEngineCtl.ErrorCode!=0){
			SafeEngineCtl.SEH_ClearSession();
			errorCallback( SafeEngineCtlObj.makeReturn('-1',SafeEngineCtl.ErrorCode,'SEH_SetConfiguration') );
			return ;
		}
		strSigned = SafeEngineCtl.SEH_SignData(random, 3);
		if(SafeEngineCtl.ErrorCode!=0){
			SafeEngineCtl.SEH_ClearSession();
			errorCallback( SafeEngineCtlObj.makeReturn('-1',SafeEngineCtl.ErrorCode,'SEH_SignData') );
			return ;
		}
		SafeEngineCtl.SEH_ClearSession();
		//success ;
		successCallback( {
			code:'1',
			cert:strCert,
			signed:strSigned
		}) ;
	},
	initNotInIe:function(pwd,random,successCallback,errorCallback){
		var strCert,i,strSigned ,usbkey,comtype,
			UCCGetPluggedeKey = UCCGetPluggedeKey ? UCCGetPluggedeKey : SafeEngineCtlObj.plugin.UCCGetPluggedeKey,
			SEH_GetSelfCertificate = SEH_GetSelfCertificate ? SEH_GetSelfCertificate : SafeEngineCtlObj.plugin.SEH_GetSelfCertificate,
			SEH_SignData = SEH_SignData ? SEH_SignData : SafeEngineCtlObj.plugin.SEH_SignData;
		
		new UCCGetPluggedeKey().then(function(krs){
			var list = krs.DevPluggedTypeList || '', arr = list.split(";"),lastArr = arr[arr.length-1].split("$$");
			usbkey = parseInt(arr[0],16) + "" ;
			comtype = (lastArr[0]||'').indexOf('2') >=0 ? 'com2' : 'com1' ;
			
			new SEH_GetSelfCertificate(usbkey,comtype,pwd,"0","","","","0")
			.then(function(certData){
				strCert = certData ;
				// next
				new SEH_SignData(usbkey, comtype, pwd, "0", "", "", "",random, "3", "0")
					.then(function(signData){
						strSigned = signData ;
						// next
						successCallback({
							code:'1',
							cert:strCert,
							signed:strSigned
						});
					},function(error){
						errorCallback(SafeEngineCtlObj.makeReturn('-1', error.LastError,'SEH_SignData'));
					});	
			},function(error){
				var rs = SafeEngineCtlObj.makeReturn('-1', error.LastError,'SEH_GetSelfCertificate');
				errorCallback(rs);
			});
		},function(error){
			var rs = SafeEngineCtlObj.makeReturn('-1', error.LastError,'UCCGetPluggedeKey');
			errorCallback(rs);
		});
		
	},
	initErrorMsg : function(){
		var ca_msgArr = ($.trim($('#ca_msg').val())||'').split('|'),obj={},len=ca_msgArr.length;
		for(var i=0;i<len;i++){
			var msg = ca_msgArr[i] ;
			if(msg.indexOf(':') >=0){
				var msgs = msg.split(":") ;
				obj[msgs[0]] = msgs[1] ;
			}
		}
		return obj ;
	},
	makeReturn : function(code,errCode,step){
		return {
			code:code,
			errCode:errCode,
			step:step,
			toString:function(){
				return code+";"+errCode+";"+step ;
			},
			
		}
	},
	isIE : function() {
		if (!!window.ActiveXObject || "ActiveXObject" in window)
			return true;
		 else
			return false;
	}
} ;

