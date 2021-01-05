/**---util_wev.js合并开始---------*/
String.prototype.startWith=function(str){  
            if(str==null||str==""||this.length==0||str.length>this.length)  
              return false;  
            if(this.substr(0,str.length)==str)  
              return true;  
            else  
              return false;  
            return true;  
}
 
String.prototype.endWith=function(str){  
    if(str==null||str==""||this.length==0||str.length>this.length)  
      return false;  
    if(this.substring(this.length-str.length)==str)  
      return true;  
    else  
      return false;  
    return true;  
} 
 
String.prototype.replaceAll = function(s1,s2){  
	return this.replace(new RegExp(s1,"gm"),s2);  
} 

String.prototype.trim=function(){
　　 return this.replace(/(^\s*)|(\s*$)/g, "");
}

String.prototype.ltrim=function(){
　　 return this.replace(/(^\s*)/g,"");
}

String.prototype.rtrim=function(){
　　 return this.replace(/(\s*$)/g,"");
}

function trimQuotes(key){
	if(key.startWith("“")){
		key=key.substring(1);
	}
	if(key.endWith("”")){
		key=key.substring(0,key.length-1);
	}
	return key;
}

function trimHtmlTag(key){
	key=key.replaceAll("</?[^>]+>", "").replaceAll("&nbsp;", " ");
	return key
}


function addQuotes(key){
	if(!key.startWith("“")){
		key="“"+key;
	}
	if(!key.endWith("”")){
		key=key+"”";
	}
	return key;
}

$.fn.longPress = function(fn) {
    var timeout = undefined;
    var $this = this;
    for(var i = 0;i<$this.length;i++){
        $this[i].addEventListener('touchstart', function(event) {
            timeout = setTimeout(fn, 350);
            }, false);
        $this[i].addEventListener('touchend', function(event) {
            clearTimeout(timeout);
            }, false);
    }
}


var chnNumChar = {
  零:0,
  一:1,
  二:2,
  三:3,
  四:4,
  五:5,
  六:6,
  七:7,
  八:8,
  九:9,
  两:2
};

var chnNameValue = {
  十:{value:10, secUnit:false},
  百:{value:100, secUnit:false},
  千:{value:1000, secUnit:false},
  万:{value:10000, secUnit:true},
  亿:{value:100000000, secUnit:true}
}

function ChineseToNumber(chnStr){
  var rtn = 0;
  var section = 0;
  var number = 0;
  var secUnit = false;
  var str = chnStr.split('');
 
  for(var i = 0; i < str.length; i++){
    var num = chnNumChar[str[i]];
    if(typeof num !== 'undefined'){
      number = num;
      if(i === str.length - 1){
        section += number;
      }
    }else{
      if(number==0) number=1;
      var unit = chnNameValue[str[i]].value;
      secUnit = chnNameValue[str[i]].secUnit;
      if(secUnit){
        section = (section + number) * unit;
        rtn += section;
        section = 0;
      }else{
        section += (number * unit);
      }
      number = 0;
    }
  }
  return rtn + section;
}


function ChineseAmountToNumber(str){
		var seps = new Object();
		seps["元"] = 1;
		seps["块"] = 1;
		seps["十"] = 10;
		seps["拾"] = 10;
		seps["百"] = 100;
		seps["佰"] = 100;
		seps["千"] = 1000;
		seps["仟"] = 1000;
		seps["万"] = 10000;
		seps["亿"] = 100000000;
		seps["角"] = 0.1;
		seps["毛"] = 0.1;
		seps["分"] = 0.01;


		var nums = new Object();
		nums["零"] = 0;
		nums["一"] = 1;
		nums["壹"] = 1;
		nums["二"] = 2;
		nums["贰"] = 2;
		nums["两"] = 2;
		nums["三"] = 3;
		nums["叁"] = 3;
		nums["四"] = 4;
		nums["肆"] = 4;
		nums["五"] = 5;
		nums["伍"] = 5;
		nums["六"] = 6;
		nums["陆"] = 6;
		nums["七"] = 7;
		nums["柒"] = 7;
		nums["八"] = 8;
		nums["捌"] = 8;
		nums["九"] = 9;
		nums["玖"] = 9;
		
		var newStr="";
		//过滤多余的非金额相关str
		for(var i =0;i<str.length;i++){
			var isMoneyStr=false;
			var c=str.charAt(i);
			if("."==c){
				isMoneyStr=true;
			}
			if(!isMoneyStr){
				if(!isNaN(c)) isMoneyStr=true;
			}
			if(!isMoneyStr){
				for(var key in seps){
					if(c==key){
						 isMoneyStr=true;
						 break;
					}
				}
			}
			if(!isMoneyStr){
				for(var key in nums){
					if(c == key){
						isMoneyStr=true;
						 break;
					}
				}
			}
			if(isMoneyStr){
				newStr+=str.charAt(i);
			}
			
		}
		str=newStr;
		 
 
		var temp = "0";
		var rtn=0;
		var currentUnits=1;
		var units=[1,0.1,0.01];
		strFor:
		for(var i =0;i<str.length;i++){

			for(var key in seps){
				if(str.charAt(i)==key){
					if(parseFloat(temp)>0){
						rtn += parseFloat(temp) * parseFloat(seps[key]);
					}else{
						if(rtn==0) rtn=1;
						rtn = rtn * parseFloat(seps[key]);
					}
					currentUnits=parseFloat(seps[key]);
					temp="0";
					continue strFor;
				}
			}

			for(var key in nums){
				if(str.charAt(i) == key){
					temp += "" + nums[key];
					continue strFor;
				}
			}
			temp += "" + str.charAt(i);
		}
		
		if(rtn==0){
			rtn=parseFloat(temp);
		}else{
			if(parseFloat(temp)>0){
				var needUnits=1;
				for(var i= 0;i<units.length;i++){
					if(units[i]==currentUnits){
						if((i+1)<=units.length){
							needUnits=units[i+1];
							break;
						}
					} 
				}  
				rtn+=parseFloat(temp)*needUnits;
			}
		}
		return rtn.toFixed(2);
	}
	
function ChineseMonthToNumber(month){
	var m="";
	var monthStr = new Object();
	monthStr["一"] = 1;
	monthStr["二"] = 2;
	monthStr["三"] = 3;
	monthStr["四"] = 4;
	monthStr["五"] = 5;
	monthStr["六"] = 6;
	monthStr["七"] = 7;
	monthStr["八"] = 8;
	monthStr["九"] = 9;
	monthStr["十"] = 10;
	monthStr["十一"] = 11;
	monthStr["十二"] = 12;
	for(var key in monthStr){
		if(month==key){
			m=monthStr[key];
			break;
		}
	}
	return m;
}

/**---util_wev.js合并结束---------*/


//EMobile location 错误 统计回调
function filterFree(){
	hideToast();
}

//新窗口打开一个链接
function openNewView(url){
	location ='emobile:{"func": "openWindow","params": {"url": "'+url+'"}}';
}

             
/**
* 拨打电话
*/
function callTel(tel){
	hideToast();
	location = "tel:"+tel;
}


/**
* 发送短信
*/
function sendSms(tel,content){
	hideToast();
	if(!content){
		content="";
	}
	location = "sms:"+tel+":"+content;
}
/**
* 发送简单的内部消息
*/
function sendSimpleEmsg(id,content){
	hideToast();
	if(!content){
		content="";
	}
	location="emobile:openChat:"+id+":"+content 
}

/**
* 考勤
*/
function sign(timeTag,signtype){
	ToastLoading("加载中...");
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"getSignStatus"},
	    dataType: "json",  
	    success:function (data) {
	    	var str="当前时间不能考勤，无法完成指令！";
	    	$("#anser"+timeTag).append('<div class="tips"></div><div class="result bodycolor"></div>');
	    	if(data.result=="1"){
		    	currentSigntype="";
		    	if(signtype=="checkin"){
		    		if(data.hasCheckIn){
		    			str="您已经签到！";
		    			play(str);
		    			$("#anser"+timeTag).find(".tips").html(str);
		    			//你已签过到.
		    			//提示外勤签到.
		    			var objstr={};
						var slots={};
						var semantic={};
						var wkp={};
						objstr.text="外勤签到";
						objstr.rc="0";
						objstr.service="FW_CMD";
						objstr.CannotEdit=true;
						slots.type="SIGNTRACK";
						semantic.slots=slots;
						objstr.semantic=semantic;
	
		    			$("#anser"+timeTag).append(showMaybeInfo("或许您需要的是  外勤签到>>",objstr));
		    		}else{
		    			currentSigntype=signtype;
		    			fixPostionTimeTag=timeTag;
		    			//定位中
		    			//str="签到中…";
		    			//ToastLoading(str);
		    			openSign(); 
		    		}
		    	}else if(signtype=="checkout"){
		    		if(data.canCheckOut){
		    			//进行签退操作,可以重复执行
		    			currentSigntype=signtype;
		    			fixPostionTimeTag=timeTag;
		    			//定位中
		    			//str="签退中…";
		    			//ToastLoading(str);
		    			openSign();
		    		}else{
		    			str="您还未签到！";
		    			play(str);
		    			$("#anser"+timeTag).find(".tips").html(str);
		    		}
		    	}else{//未指定签到/签退. 自动选择
	    			fixPostionTimeTag=timeTag;
		    		if(data.hasCheckIn){//已经签到,进行签退操作
		    			currentSigntype="checkout";
		    			//定位中
		    			//str="签退中…";
		    			//ToastLoading(str);
		    			openSign();
		    		}else{//未签到,进行签到操作
		    			currentSigntype="checkin";
		    			//定位中
		    			//str="签到中…";
		    			//ToastLoading(str);
		    			openSign();
		    		}
		    	}
	    	}else{
	    		play(str);
	    		//未到签到时间段
	    		$("#anser"+timeTag).find(".tips").html(str);
	    	}
	    }
    });
}


//打开定位,进行签到
function openSign(){
	//{"address":"上海市闵行区浦江镇万里路浦江智谷","lng":"121.526519","lat":"31.080176","city":"上海市","time":1506417406747}
	//判断上次定位时间
	if($('#hideLocation').attr("currentLocation")){
		var currentLocation=JSON.parse($('#hideLocation').attr("currentLocation"));
		if(currentLocation&&currentLocation.time&&((new Date().getTime()-currentLocation.time)<30*1000)){//距离上次定位小于30秒,直接签到操作.
			signCheck(currentSigntype,currentLocation.lng,currentLocation.lat,currentLocation.address);
		}else{
			location="emobile:gps:signFixPosition";
		}
	}else{
		location="emobile:gps:signFixPosition";
	}
}
//签到/签退  checkin  checkout
function signCheck(signtype,lng,lat,address){
	hideToast();
	$("#anser"+fixPostionTimeTag).find(".tips").html("");
	location="emobile:openSign:"+signtype+":"+lng+":"+lat+":"+address+":signBack";
}

//签到/签退. 回调方法.
function signBack(str){
	var playstr="";
	var showstr="";
	var address="";
	var showAddress=false;
	var isShowMaybeInfo=false;
	if($('#hideLocation').attr("currentLocation")){
		var currentLocation=JSON.parse($('#hideLocation').attr("currentLocation"));
		if(currentLocation&&currentLocation.address){ 
			address=currentLocation.address;
		}
	}
	//显示签到结果响应..
	try{
		var obj = eval("("+str+")");
		if(obj.result=="success"){
			if(currentSigntype=="checkin"){
				playstr="签到成功！";
				showAddress=true;
			}else{
				playstr="签退成功！";
				showAddress=true;
			}
			showstr=obj.msg;
		}else{
			if(currentSigntype=="checkin"){
				playstr="签到失败！";
			}else{
				playstr="签退失败！";
			}
			if(obj.result=="error"){
				showstr=obj.error;
				if(showstr.indexOf("地理位置不在考勤范围内")>-1){
					isShowMaybeInfo=true;
				}
				
				
			}else if(obj.error=="134"){
				playstr="抱歉，当前设置不支持移动考勤，无法完成指令！"
				showstr=playstr;
			}
		} 
		
		play(playstr);
		$("#anser"+fixPostionTimeTag).find(".tips").html(showstr);
		if(showAddress&&address){
			$("#anser"+fixPostionTimeTag).find(".result").html(signAddressShow(address));
		}
		if(isShowMaybeInfo){
			//提示外勤签到.
   			var objstr={};
			var slots={};
			var semantic={};
			var wkp={};
			objstr.text="外勤签到";
			objstr.rc="0";
			objstr.service="FW_CMD";
			objstr.CannotEdit=true;
			slots.type="SIGNTRACK";
			semantic.slots=slots;
			objstr.semantic=semantic;

   			$("#anser"+fixPostionTimeTag).append(showMaybeInfo("或许您需要的是  外勤签到>>",objstr));
		}
		fixPostionTimeTag="";
		currentSigntype="";
	}catch(e){
		$("#anser"+fixPostionTimeTag).find(".tips").html(str);
		fixPostionTimeTag="";
		currentSigntype="";
	}
}
//签到后显示的地址.
function signAddressShow(address){
	return '<div class="crm_address_child lastLi" style="height: 30px;line-height: 30px;">'+
				'<span class="ui-li-span ui-li-span-heading ui-li-span80">'+
					'<img style="width:20px;vertical-align: middle;" src="/mobile/plugin/fullsearch/img/'+pageStyle+'location_wev8.png">&nbsp;&nbsp;'+address+
				'</span>'+
			'</div>';
}
//签到定位
function signFixPosition(str){
	hideToast();
	var strs=str.split(",");
	var lat=strs[1];//维度
	var lng=strs[2];//经度
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/locationUtil.jsp",
	    data:{"type":"regeo","lng":lng,"lat":lat},
	    dataType: "json",  
	    success:function (data) {
	    	data.time=new Date().getTime();
	    	$('#hideLocation').attr("currentLocation",JSON.stringify(data));
	    	signCheck(currentSigntype,lng,lat,data.address);
	    }
    });
}

function signFixPosition_error(str){
	ToastInfo("定位失败("+str+")",1);
	if(fixPostionTimeTag&&fixPostionTimeTag!=""){
		$("#anser"+timeTag).find(".tips").html("定位失败("+str+")");
		fixPostionTimeTag="";
	}
}

//成功定位返回处理
function fixPosition(str){
	var strs=str.split(",");
	var lat=strs[1];//维度
	var lng=strs[2];//经度
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/locationUtil.jsp",
	    data:{"type":"regeo","lng":lng,"lat":lat},
	    dataType: "json",  
	    success:function (data) {
	    	data.time=new Date().getTime();
	    	$('#hideLocation').attr("currentLocation",JSON.stringify(data));
	    }
    });
}

//定位错误提示
function fixPosition_error(str){
	ToastInfo("定位失败("+str+")",1);
}
//展示定位
function showFixPosition(){
	ToastLoading("定位中...");
	location="emobile:gps:fixPositionShow";
}

//成功定位后展示地址
function fixPositionShow(str){
	var strs=str.split(",");
	var lat=strs[1];//维度
	var lng=strs[2];//经度
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/locationUtil.jsp",
	    data:{"type":"regeo","lng":lng,"lat":lat},
	    dataType: "json",  
	    success:function (data) {
	    	data.time=new Date().getTime();
	    	$('#hideLocation').attr("currentLocation",JSON.stringify(data));
	    	hideToast();
	    	$('.anserCurrent').append('<div class="tips"></div><div class="result bodycolor" style="padding-top:10px"></div>');
	     	$('.anserCurrent').find(".result").html(signAddressShow(data.address));
	    }
    });
}

function fixPositionShow_error(){
	ToastInfo("定位失败("+str+")",1);
}

/**
* 外勤签到
*/
function SignTrack(){
	hideToast();
	location='emobile:{"func":"openSignTrack"}';
}

/**
* 发送内部消息
*/
function sendEmsg(id,timeTag,otherJson){
	hideToast();
	var content="";
	if(otherJson&&otherJson.slots&&otherJson.slots.content){
		content=otherJson.slots.content;
	}
	if(!content){
		content="";
	}
	//emobile:openChat:ids（逗号分隔）:发送内容 
	location="emobile:openChat:"+id+":"+content 
}


/**
* 内部消息发送人员卡片
*/
function sendPersonCard(id,timeTag,otherJson){
	if(!otherJson.slots.cardId){//名片
		otherJson.slots.cardId=id;
		otherJson.slots.cardName=otherJson.name;
		otherJson.slots.to_type="Emsg";
		load_SP_Data(rscTag,otherJson.slots.to,"ID",sendPersonCard,timeTag,otherJson,true);
		return;
	}else if(!otherJson.slots.toId){
		otherJson.slots.toId=id;
		hideToast();
		location = 'emobile:{"func":"sendPersonCard","params" : {"personid" : "'+otherJson.slots.cardId+'","targetid" : "'+otherJson.slots.toId+'"}}';
	}
}


/**
* 内部消息发送当前位置
*/
function sendLocation(id,timeTag,otherJson){
	if($('#hideLocation').attr("currentLocation")){
		var address="";
		var lat="";
		var lng="";
		var currentLocation=JSON.parse($('#hideLocation').attr("currentLocation"));
		if(currentLocation&&currentLocation.city){
			address=currentLocation.address;
		}
		if(currentLocation&&currentLocation.lat){
			lat=currentLocation.lat;
		}
		if(currentLocation&&currentLocation.lng){
			lng=currentLocation.lng;
		}
		hideToast();
		location = 'emobile:{"func":"sendLocation","params": {"address" : "'+address+'","latitude" : "'+lat+'","longitude" : "'+lng+'","targetid" : "'+id+'"}}';
	}else{
		ToastInfo("定位失败!",1);
	}
}

/**
* 内部消息发送文档.
*/
function sendShareDoc(id,timeTag,other,obj){
	var otherJson={};
	var item={};
	if(obj&&$(obj)&&$(obj).attr("otherObj")){
		otherJson=JSON.parse($(obj).attr("otherObj"));
		item=JSON.parse($(obj).attr("itemObj"));
	}else{
		otherJson=other;
	}
	if(!otherJson.slots.docid){
		otherJson.slots.docid=id;
		otherJson.slots.docName=item.simpleTitle;
		otherJson.slots.to_type="Emsg";
		$('#anser'+timeTag).html("");
		load_SP_Data(rscTag,otherJson.slots.to,"ID",sendShareDoc,timeTag,otherJson,false,false,true);
		return;
	}else{
		/*
		ToastLoading("分享中...");
		//调用文档分享接口...
		fileMap[otherJson.slots.docid]=otherJson.slots.docName;
		//调用共享接口
		jQuery.ajax({
			type: "post",
		    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp?type=chatShare&resourcetype=1",
		    data:{"resourceids":id,"resourceid":otherJson.slots.docid},
		    dataType: "json",  
		    success:function (data) {
		    	if(data.result){
		    		hideToast();
			    	//location = "emobile:netdiskshare:[]:["+otherJson.slots.docid+"]:setSendData:"+id;
		    	}else{
		    		ToastInfo("分享失败!",1);
		    	}
		    }
		});
		*/
	}
	
}
//直接发送内部消息.
function sendEmsgImmediately(id,msg,timeTag){
	ToastInfo("后台将为你发送消息...",2);
	if(id.indexOf("\"")==-1){
		id="\""+id.replaceAll(",","\",\"")+"\"";
	}
	location ='emobile:{"func":"backChat","params":{"targetIds":['+id+'],"msg":"'+msg+'","callback":"sendEmsgImmediatelyBack","extra":'+timeTag+'}}';
}
//直接发送内部消息回调
function sendEmsgImmediatelyBack(timeTag,obj){
	//ToastInfo("消息发送成功",2);
}


/**
* 通过群聊名字获取群列表
*/
function getGroupList(name,timeTag,callBackFunction,others){
	others.timeTag=timeTag;
	others.key=name;
	others.functionName=callBackFunction.name;
	if(name!=''){
		location='emobile:{"func":"getDiscussion","params":{"callback":"showDiscussionList","searchText":"'+name+'","obj":'+JSON.stringify(others)+'}}';
	}else{
		ToastInfo("关键字为空!",1);
	}
}

/*
*展示群聊讨论组
*/
function showDiscussionList(list,objStr){
	var obj=JSON.parse(objStr);
	var timeTag=obj.timeTag;
	var key=obj.key;
	try{
		var listArray=eval("("+list+")");
		var size=listArray.length;
		str="为您找到"+size+"条数据";
		if(size==0){
			str="对不起,没有找到"+key+".";
			play(str);
		}else if(size>1){
			str="找到"+size+"个"+key+"，请确认是哪个";
			play(str);
		}
		var firstItem;
 		if(size==0){
 			$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'"></div></div>');
 		}else if(size>0){
 			var listSize=size;
   			var pagesize=5; 
	    	var page=Math.ceil(listSize/pagesize);
		    if(page>1){
		    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364px;">';
		    	var pageHtml='<div class="otherInfo" style="padding-bottom: 10px;"><div class="morePage" style="width:'+15*page+'px">'
		    	for (var i=0;i<page;i++){
		    		if(i==0){
		    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
		    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
		    		}else{
		    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
		    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
		    		}
		    	}
		    	resultHtml+='</div>';
		    	pageHtml+='</div>';
		    	 
			    pageHtml+='</div>';
		    	$("#anser"+timeTag).append(resultHtml);
		    	$("#anser"+timeTag).append(pageHtml);
	    	}else{
	    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	    	}

			$.each(listArray,function(j,item){
				var currentPage=Math.ceil((j+1)/pagesize);
				var isLast=(((j+1)%pagesize)==0||j==listSize-1)?"1":"0";
				$("#listview_"+currentPage+"_"+timeTag).append(showDiscussionItem(item,isLast,obj));
				if(size==1){
					firstItem=item;
				}
			});
 		}
		
		setTimeout(function(){
			$("#result"+timeTag ).height($('.result-current-ul').height());
			swipeList($("#result"+timeTag ));
			saveHistory();
	 		hideToast();	
			if(firstItem){
	 			CustomFunction(eval(obj.functionName),firstItem.discussionId,"",obj);
	 		}
		},200);
 		
	}catch(e){
		ToastInfo("数据异常",1);
	}
}


//显示群聊组信息
function showDiscussionItem(item,isLast,obj){
	var css=isLast=="1"?"lastLi":"";
	//获取特殊值
	 
	var str={};
	str.text=item.discussionName;
	str.rc="0";
	str.service="NativeAction";
	str.CannotEdit=true;
	str.action=obj.functionName;
	str.id=item.discussionId;
	str.name=item.discussionName;
	if(obj.slots){
		str.slots=obj.slots;
	}
	str.needAction=true;//需要执行action
	

	var icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_groupChat_wev8.png';
	var css=isLast=="1"?"lastLi":"";
	var htmlStr='<div class="am-list-item '+css+'" deepObj=\''+JSON.stringify(str)+'\' onclick="deepUnderstand(this)">'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img">'+
							 	'<img src="'+icon+'">'+
							'</span>'+
							'<div class="ul-li-div" style="margin-top: 0px;margin-left: 75px;">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80" style="line-height: 46px;">'+item.discussionName+'</span></div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}

/*查询手机应用列表*/
function getAppList(id,timeTag,others){
	others.timeTag=timeTag;
	var name=others.key;
	location='emobile:{"func":"getModule","params":{"callback":"showModuleList","searchText":"'+name+'","obj":'+JSON.stringify(others)+'}}';
}

/*显示查询到应用*/
function showModuleList(list,objStr){
	var obj=JSON.parse(objStr);
	var timeTag=obj.timeTag;
	var key=obj.key;
	try{
		var listArray=eval("("+list+")");
		var size=listArray.length;
		str="为您找到"+size+"条数据";
		//通过后台查询列表. 以及客户端返回数据进行权限过滤.
		if(key==""){
			//判断客户端是否返回数据.
			var appNames="";
			var needFilter=false;
			if(size>0){
				appNames=",";
				needFilter=true;
				$.each(listArray,function(j,item){
					 appNames+=item.label+",";
				});
			}
			
			ToastLoading("加载中...");
			jQuery.ajax({
				type : "POST", 
				url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
		   		data:{"type":"Url2Forward","reportType":"Module"},
				dataType : 'json', 
				success : function(data) {
					if(data.result==1){
						str="您可以直接说出应用名字进行打开,或者点击名称";
						play(str);
						$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
						var nextTs=new Date().getTime();
						
						$.each(data.list,function(k,eachList){
							var htmlStr="<div class='reportItemDiv' style='line-height:40px;'>";
							htmlStr+="<div class='lineTips' style='line-height:35px;'>"+eachList.name+"</div>";
							var listSize=eachList.list.length;
							var jj=0;
							$.each(eachList.list,function(j,item){
								if(!needFilter||(needFilter && appNames.indexOf(item)>-1)){
									var isLastLi=(j==listSize-1||j==listSize-2)?"lastLi":"";
									var isnewLine=jj%2;
	
						 			var str={};
									str.text="打开"+item;
									str.rc="0";
									str.service="NativeAction";
									str.CannotEdit=true;
									str.action="getAppList";
									str.key=item;
									str.nextTs=nextTs;
									str.replaceText=true;
									str.needAction=true;//需要执行action
									
									
									if(isnewLine==0){
										htmlStr+="<div class='lineBottom "+isLastLi+"' style='height:40px;'>";
										htmlStr+="<div class='labelName reportLabelName' deepObj='"+JSON.stringify(str)+"' onclick='deepUnderstand(this)'>"+item +"</div>";
									}else{
										htmlStr+="<div class='labelName reportLabelName' deepObj='"+JSON.stringify(str)+"' onclick='deepUnderstand(this)'>"+item +"</div>";
										htmlStr+="</div>";
									}
									if(jj==listSize-1&&(isnewLine==0)){//最后一条数据且新起一行.
										htmlStr+="</div>";
									}
									jj++;
								}
							});
							if(jj>0){
								$("#listview_1_"+timeTag).append(htmlStr);
							}
						});
						 
						saveHistory();
						hideToast();	
					}else{
						//直接展示客户端返回的列表
						if(size>0){
							showModuleListItem(listArray,obj);
						}else{
							str="对不起,没有找到应用";
							play(str);
							$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
							hideToast();	
						}
					}
				}
			});
		}else{
			showModuleListItem(listArray,obj);
		}
	}catch(e){
		ToastInfo("数据异常",1);
	}
}

//列表展示手机端返回的应用
function showModuleListItem(listArray,obj){
	var timeTag=obj.timeTag;
	var key=obj.key;
	var maybe=obj.maybe;//没有说打开xxx,先查找应用. 找不到此应用
	var size=listArray.length;
		
	if(size==0){
		if(maybe&&maybe=="true"){//可能是应用名称,先进行应用的查询.再进入微搜
			//没有app则查询微搜
			//设置关键字
			var currentSearch=$('#ask'+timeTag).find(".keyDiv");
			$(currentSearch).attr("searchKey",key);
			//$(currentSearch).attr("allowSchema","DOC,WF");
			loadData(timeTag);
			return;
			//str="对不起,没有找到"+key;
			//play(str);
		}else{
			str="对不起,找不到此应用";
			play(str);
			$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'"></div></div>');
			hideToast();	
			return;
		}
	}else if(size>1){
		str="找到"+size+"个"+(key==""?"应用":key)+"，请确认是哪个";
		play(str);
	}
	var firstItem;
	if(size>0){
		var listSize=size;
 		var pagesize=5; 
	   	var page=Math.ceil(listSize/pagesize);
	    if(page>1){
	    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364px;">';
	    	var pageHtml='<div class="otherInfo" style="padding-bottom: 10px;"><div class="morePage" style="width:'+15*page+'px">'
	    	for (var i=0;i<page;i++){
	    		if(i==0){
	    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
	    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
	    		}else{
	    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
	    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
	    		}
	    	}
	    	resultHtml+='</div>';
	    	pageHtml+='</div>';
	    	 
		    pageHtml+='</div>';
	    	$("#anser"+timeTag).append(resultHtml);
	    	$("#anser"+timeTag).append(pageHtml);
	   	}else{
	   		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	   	}
		
		
		$.each(listArray,function(j,item){
			var currentPage=Math.ceil((j+1)/pagesize);
			var isLast=(((j+1)%pagesize)==0||j==listSize-1)?"1":"0";
			$("#listview_"+currentPage+"_"+timeTag).append(showModuleItem(item,isLast,obj));
			if(size==1){
				firstItem=item;
			}
		});
	}
	
	setTimeout(function(){
		$("#result"+timeTag ).height($('.result-current-ul').height());
		swipeList($("#result"+timeTag ));
		saveHistory();
		hideToast();	
		if(firstItem){
			location='emobile:{"func":"openModule","params":{"moduleInfo":'+JSON.stringify(firstItem)+'}}'
		}
	},500);
}

//显示应用列表
function showModuleItem(item,isLast,obj){
	var css=isLast=="1"?"lastLi":"";
	//获取特殊值
	var icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_app_wev8.png';
	var css=isLast=="1"?"lastLi":"";
	var htmlStr='<div class="am-list-item '+css+'"  obj=\''+JSON.stringify(item)+'\' onclick="openModule(this)">'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img">'+
							 	'<img src="'+icon+'">'+
							'</span>'+
							'<div class="ul-li-div" style="margin-top: 0px;margin-left: 75px;">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80" style="line-height: 46px;">'+item.label+'</span></div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}
//打开对应应用
function openModule(obj){
	location='emobile:{"func":"openModule","params":{"moduleInfo":'+$(obj).attr("obj")+'}}'
}

//清除确认框
function clearConfirm(){
	clearCalendarConfirm();
	clearWfConfirm();
	clearBlogConfirm();
	clearMeetingConfirm();
	clearCrmContactConfirm();
	clearFlightConfirm();
	clearBillNoteConfirm();
}
//通过原始说法.获取指定日期
function getDateByOrig(date_orig,date){
	var retDate=date;
	var now=new Date();
	var nowDateStr=now.getFullYear()+"-"+fixZero(now.getMonth()+1)+"-"+fixZero(now.getDate());
	var yearStr=now.getFullYear();
	var monthStr=now.getMonth()+1;
	var dayStr=now.getDate();
	var isSameDay=date==nowDateStr;
	
	var thisyear=["今年"];
	var nextyear=["明年"];
	var nextmonth=["下个月","下月"];//默认下月1号
	var early=["上旬"];//1号
	var mid=["中旬"];//10号
	var late=["下旬"];//20号
	var nexweek=["下周","下星期","下礼拜","下个星期","下个礼拜","下个周"];//默认礼拜一
	var weekTag=["周","星期","礼拜"];//[x] 跟上x替换.
	var weekTagX=["天","一","二","三","四","五","六","七","日"]
	//指定日期. 不做判断, 直接返回
	if(date_orig.indexOf("日")>-1||date_orig.indexOf("天")>-1||date_orig.indexOf("号")>-1){
		return retDate;
	}
	//指定周几, 直接返回
	for(var key in weekTag){
		for(var key1 in weekTagX){
			if(date_orig.indexOf(weekTag[key]+weekTagX[key1])>-1) return retDate;
		}
	}
	
	
	var retYear=yearStr;
	var retMonth=monthStr;
	var retDay=dayStr;
	//返回结果和当前是同一天,才有可能有问题.
	if(isSameDay){
		retDay=1;//默认1号.
		//年(18年10月份)(2017年8月)
		if(date_orig.indexOf("年")>-1){
			var yearOrig=date_orig.substring(0,date_orig.indexOf("年"));
			var hasNextYearTag=false;
			for(var key in nextyear){
				if(date_orig.indexOf(nextyear[key])>-1){
				  retYear=yearStr+1;
				  retMonth=1;
				  hasNextYearTag=true;
				  break;
				} 
			}
			if(!hasNextYearTag&&date_orig.length>1){
				for(var key in thisyear){
					if(date_orig.indexOf(thisyear[key])>-1){
					  hasNextYearTag=true;
					  retDay=dayStr;
					  break;
					} 
				}
			}
			
			if(!hasNextYearTag&&date_orig.length>1){
				try{
					retYear=parseInt(yearOrig);
					if(retYear.length<4){
						if(retYear.length==2){
							retYear="20"+retYear;
						}else{
							retYear=yearStr;
						}
					}
				}catch(e){
					try{
						retYear=ChineseToNumber(date_orig);
						if(retYear.length!=4) retYear=yearStr;
					}catch(e){
						retYear=yearStr;
					}
				}
			}
		}
		//提取月份(8月,本月,下月)
		if(date_orig.indexOf("月")>-1){
			var hasNextMonthTag=false;
			for(var key in nextmonth){
				if(date_orig.indexOf(nextmonth[key])>-1){
				   var newDate=DateAdd("m",1,now);
				   hasNextMonthTag=true;
				   retYear=newDate.getFullYear();
				   retMonth=newDate.getMonth()+1;
				   break;
				} 
			}
			if(!hasNextMonthTag){
				//判断是否有年
				var monthOrig=date_orig.substring(0,date_orig.indexOf("月"));
				if(monthOrig.lastIndexOf("年")>-1)  monthOrig.substring((monthOrig.indexOf("月")+1),monthOrig.length);
				if(isNaN(monthOrig)){//不是数字
					try{
						retMonth=ChineseToNumber(monthOrig);
					}catch(e){
						retMonth=monthStr;
					}
				}else{
					try{
						retMonth=parseInt(monthOrig);
					}catch(e){
						retMonth=monthStr;
					}
				}
				//多一层判断.是否是数字
				if(isNaN(monthOrig)){
					retMonth=monthStr;
				} 
			}
		}		
		//旬
		if(date_orig.indexOf("旬")>-1){
			for(var key in early){
				if(date_orig.indexOf(early[key])>-1){
				   retDay=1;
				   break;
				} 
			}
			for(var key in mid){
				if(date_orig.indexOf(mid[key])>-1){
				  retDay=10; 
				  break;
				} 
			}
			for(var key in late){
				if(date_orig.indexOf(late[key])>-1){
				  retDay=20;
				  break;
				} 
			}
		}
		retDate=retYear+"-"+fixZero(retMonth)+"-"+fixZero(retDay);
		//下星期
		for(var key in nexweek){
			if(date_orig.indexOf(nexweek[key])>-1){
			   var newDate=DateAdd("d",now.getDay()>0?8-now.getDay():1,now);
			   retDate=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-"+fixZero(newDate.getDate());
			   break;
			} 
		}
	}else{
		//下月..
		for(var key in nextmonth){
			if(date_orig.indexOf(nextmonth[key])>-1){
			   var newDate=DateAdd("m",1,now);
			   retDate=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-01";//下个月1号.
			   break;
			} 
		}
	}
	
	return retDate;
}

//日期(月,日) 前面补零
function fixZero(num){
	return (num>9?"":"0")+num;
}

//通过说法获取日期范围
function getDatesByOrig(date_orig,date){
	var dates=[date,date];
	var now=new Date();
	var yearStr=now.getFullYear();
	var monthStr=now.getMonth()+1;
	var dayStr=now.getDate();
	var currentmonth=["本月","这个月","这月"];//本月
	var nextmonth=["下个月","下月","下一个月","下一月"];//下月
	var currentweek=["本周","这周","这一周"];//本周
	var nexweek=["下周","下星期","下礼拜","下个星期","下个礼拜","下个周","下一周"];//下周
	var lastweek=["上周","上星期","上礼拜","上个星期","上个礼拜","上个周","上一周"];//上周
	var lastmonth=["上个月","上月","上一个月","上一月"];//上月
	var hasRecognition=false;//是否识别
	//指定日期. 不做判断, 直接返回
	if(date_orig.indexOf("日")>-1||date_orig.indexOf("天")>-1||date_orig.indexOf("号")>-1){
		return dates;
	}
	//下周
	for(var key in nexweek){
		if(date_orig.indexOf(nexweek[key])>-1){
		   var newDate=DateAdd("d",now.getDay()>0?8-now.getDay():1,now);
		   dates[0]=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-"+fixZero(newDate.getDate());
		   newDate=DateAdd("d",6,newDate);
		   dates[1]=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-"+fixZero(newDate.getDate());
		   hasRecognition=true;
		   break;
		} 
	}
	//本周
	if(!hasRecognition){
		for(var key in currentweek){
			if(date_orig.indexOf(currentweek[key])>-1){
			   var newDate=DateAdd("d",now.getDay()>0?1-now.getDay():-6,now);
			   dates[0]=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-"+fixZero(newDate.getDate());
			   newDate=DateAdd("d",6,newDate);
			   dates[1]=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-"+fixZero(newDate.getDate());
			   hasRecognition=true;
			   break;
			} 
		}
	}
	//上周
	if(!hasRecognition){
		for(var key in lastweek){
			if(date_orig.indexOf(lastweek[key])>-1){
			   var newDate=DateAdd("d",now.getDay()>0?1-now.getDay()-7:-6-7,now);
			   dates[0]=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-"+fixZero(newDate.getDate());
			   newDate=DateAdd("d",6,newDate);
			   dates[1]=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-"+fixZero(newDate.getDate());
			   hasRecognition=true;
			   break;
			} 
		}
	}
	//下月
	if(!hasRecognition){
		for(var key in nextmonth){
			if(date_orig.indexOf(nextmonth[key])>-1){
			   var newDate=DateAdd("m",1,now);
			   dates[0]=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-01";
			   newDate.setDate(1);
			   newDate=DateAdd("m",1,newDate);
			   newDate=DateAdd("d",-1,newDate);
			   dates[1]=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-"+fixZero(newDate.getDate());
			   hasRecognition=true;
			   break;
			} 
		}
	}
	//本月
	if(!hasRecognition){
		for(var key in currentmonth){
			if(date_orig.indexOf(currentmonth[key])>-1){
			   dates[0]=now.getFullYear()+"-"+fixZero(now.getMonth()+1)+"-01";
			   var newDate=DateAdd("m",1,now);
			   newDate.setDate(1);
			   newDate=DateAdd("d",-1,newDate);
			   dates[1]=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-"+fixZero(newDate.getDate());
			   hasRecognition=true;
			   break;
			}
		}
	}
	//上月
	if(!hasRecognition){
		for(var key in lastmonth){
			if(date_orig.indexOf(lastmonth[key])>-1){
			   var newDate=DateAdd("m",-1,now);
			   dates[0]=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-01";
			   newDate.setDate(1);
			   newDate=DateAdd("m",1,newDate);
			   newDate=DateAdd("d",-1,newDate);
			   dates[1]=newDate.getFullYear()+"-"+fixZero(newDate.getMonth()+1)+"-"+fixZero(newDate.getDate());
			   hasRecognition=true;
			   break;
			}
		}
	}
	
	return dates;
}


/**
* 新建日程
*/
function addCalendar(id,others,timeTag){
	hideToast();
	if(!id){
		id="";
	}
	if(!others){
		others=":::";
	}
	
	var content="";
	var date="";
	var time="";
	var timeEnd="";
	var otherss=others.split(":");
	content=otherss[0];
	date=otherss[1];
	time=otherss[2];
	if(otherss.length>3){
		timeEnd=otherss[3];
	}
	var id1="";
	var name1="";
	if(id!=""){
		var ids=id.split(":");
		id1=ids[0];
		name1=ids[1];
	}
	if(content!=""&&date!=""&&time!=""){
	
		//新建日程提示框
		var times=time.split("-");
		var dates=date.split("-");
		
		var startdate = new Date(dates[0], parseInt(dates[1])-1, dates[2]); 
		startdate.setHours(parseInt(times[0]));
		startdate.setMinutes(parseInt(times[1]));
		startdate.setSeconds(parseInt(times[2]));
		
		var enddate=DateAdd("h",1,startdate);
		var sDate=date;
		var sTime=times[0]+":"+times[1];
		var eDate=enddate.getFullYear()+"-"+((enddate.getMonth()+1)>9?"":"0")+(enddate.getMonth()+1)+"-"+(enddate.getDate()>9?"":"0")+enddate.getDate();
		var eTime=(enddate.getHours()>9?"":"0")+enddate.getHours()+":"+ (enddate.getMinutes()>9?"":"0")+enddate.getMinutes();
		
		//如果传了结束时间
		if(timeEnd!=""){
			var timesEnd=timeEnd.split("-");
			eDate=sDate;
			eTime=timesEnd[0]+":"+timesEnd[1];
		}
		
		var str="为"+(name1==""?'您':name1)+"安排日程，请确认";
		play(str);
		$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		$("#listview_1_"+timeTag).append(createCalendarConfirm(sDate,sTime,eDate,eTime,content,id1,name1,timeTag));
		
		//判断当前时间是否是未开始. 内容是否包含会议.
		if(!isBeforeNow(sDate,sTime)&&content.indexOf("会")>-1){
			$("#anser"+timeTag).append(showMaybeInfo2("或许您要的是创建会议","点击创建会议",wkp2meetingObj(sDate,sTime,eDate,eTime,content)));
		}
		
		//设置日期宽度
		$("#listview_1_"+timeTag).find('.wkp_date_div').css("width",((wW-30-40)/2)+"px");
		//设置编辑域宽度
		$("#listview_1_"+timeTag).find('.wkp_content').css("width",(wW-2)+"px");
		//注册内容编辑事件
		$("#listview_1_"+timeTag).find('.wkp_content').off("tap").on("tap",function(){
			var editDiv=$(this).find(".wkp_content_inner");  
			$(editDiv).unbind("focus").unbind("blur");
			$(editDiv).focus(function(){
				cancelCalenderColor();
				noScroll=false;
				$(editDiv).attr("contentEditable","true");
			    $('.voicefooter').hide();

			}).blur(function(){
				noScroll=true;
				$(editDiv).attr("contentEditable","false");
			    showVoicefooter();
			});
			
			$(editDiv).focus();
		});
		
		
		//注册 btn事件
		$("#listview_1_"+timeTag).find('.cancelWKP').off("tap").on("tap",function(){
			noScroll=true;
			play("日程已取消");
			$("#anser"+timeTag).html('<div class="tips">日程已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			saveHistory();
		});
		
		$("#listview_1_"+timeTag).find('.createWKP').off("tap").on("tap",function(){
			cancelCalenderColor();
			var sD=$("#listview_1_"+timeTag).find(".wkp_start_date_str").attr("date");
			var sT=$("#listview_1_"+timeTag).find(".wkp_start_time_str").attr("time");
			var eD=$("#listview_1_"+timeTag).find(".wkp_end_date_str").attr("date");
			var eT=$("#listview_1_"+timeTag).find(".wkp_end_time_str").attr("time");
			var content=$("#listview_1_"+timeTag).find(".wkp_title_str").text();
			var id=$("#listview_1_"+timeTag).find(".wkp_title_str").attr("peopleid");
			var name=$("#listview_1_"+timeTag).find(".wkp_title_str").attr("peoplename");
			if(content.length==0){
				ToastInfo("请输入标题",1);
				return;
			}
			//检查时间有效性..
			if(TimeCompareNotEqual(sD,sT,eD,eT)){
				noScroll=true;
				addCalendarAjax(id,name,content,sD,sT+":00",eD,eT+":00",timeTag);
			}else{
				ToastInfo("结束时间不能在开始时间之前",1);
			}

		});
		
		saveHistory();
	}else{
		var InstructObj={};
		var moreInstruct=false;
		InstructObj.type="WKP";
		InstructObj.lastTarget=timeTag;
		if(content!=""){
			InstructObj.content=content;
		}
		if(date!=""){
			InstructObj.date=date;
		}
		if(time!=""){
			InstructObj.time=time;
		}
		if(id1!=""){
			InstructObj.id=id1;
		}
		if(name1!=""){
			InstructObj.name=name1;
		}
		if(timeEnd!=""){
			InstructObj.timeEnd=timeEnd;
		}
		if(immediatelyWKP&&time==""){
			time=getCurrentTime().replaceAll(":","-");
		}
		InstructObj=validateDate(InstructObj);
		if(!InstructObj.time){
			moreInstruct=true;
			msg='好的，请告诉我日期和时间。比如明天下午3点。';
		}else if(!InstructObj.content){
			moreInstruct=true;
			msg='好的，将为您创建日程，请告诉我日程主题，比如“开会”。';
			if(InstructObj.name){
				msg='好的，将为'+InstructObj.name+'创建日程，请告诉我日程主题，比如“开会”。';
			}
		}else{
			moreInstruct=true;
			InstructObj.action="ok";
		}
		
		if(moreInstruct){
			hideToast();
			 
			if(InstructObj.action){//完结后的指令
				$('#instructTip'+timeTag).append('<div id="instructTipObj'+timeTag+'" class="instructTip instructTipObj currentInstructTip" target="'+timeTag+'" obj=\''+JSON.stringify(InstructObj)+'\' style="display:none"></div>');
				$('#anser'+timeTag).append('<div class="instructTip" target="'+timeTag+'" style="display:none"></div>');
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
    				if(InstructObj.name){
    					name=InstructObj.name;
    				}
    				
    				$('.currentInstructTip').removeClass("currentInstructTip");
					addCalendar((id==""?"":id+":"+name),content+":"+date+":"+time+":"+timeEnd,timeTag);
				}
			}else{
				play(msg);
				$('#instructTip'+timeTag).append('<div id="instructTipObj'+timeTag+'" class="instructTip instructTipObj currentInstructTip" target="'+timeTag+'" obj=\''+JSON.stringify(InstructObj)+'\' style="display:none"></div>');
				$('#anser'+timeTag).append('<div class="instructTip" target="'+timeTag+'">'+msg+'</div>');
			}
			 
			saveHistory();
		}
	
		//alert("emobile:addCalendar:"+id+":"+others);
		//emobile:addCalendar:ids（逗号分隔）:发送内容:日期:时间 
		//location="emobile:addCalendar:"+id+":"+others;
	}
}

/*验证时间的有效性,只能当前时间往后*/
function validateDate(InstructObj){
	var now=new Date();
	if(InstructObj.all_cft){
		return InstructObj;
	}
	if(!InstructObj.time){//没有时间
		if(InstructObj.date){//有日期
			var nowDate=now.getFullYear()+"-"+((now.getMonth()+1)>9?"":"0")+(now.getMonth()+1)+"-"+(now.getDate()>9?"":"0")+now.getDate();
			if(InstructObj.date==nowDate){
				var newDate=DateAdd("h",1,now);
				InstructObj.date=newDate.getFullYear()+"-"+((newDate.getMonth()+1)>9?"":"0")+(newDate.getMonth()+1)+"-"+(newDate.getDate()>9?"":"0")+newDate.getDate();
				InstructObj.time=(newDate.getHours()>9?"":"0")+newDate.getHours()+"-00-00";
			}else{
				InstructObj.time="09-00-00";
			}
		}
	}else{//有时间
		var date=InstructObj.date;
		if(!date){//如果没有日期,认为是今天
			date=nowDateStr;
			InstructObj.date=nowDateStr;
		}
		var dates=date.split("-");
		var regDate=new Date(dates[0], parseInt(dates[1])-1, dates[2]); 
		
		var time=InstructObj.time;
		var times=time.split("-");
		regDate.setHours(times[0]);
    	regDate.setMinutes(times[1]);
    
		if(InstructObj.date_orig){//指定日期. 最多区分上下午 +12
			if(false&&regDate.getTime()<now.getTime()){//指定日期,时间不处理
				if(parseInt(times[0])<12){
					regDate.setHours(regDate.getHours()+12);
					if(regDate.getTime()<now.getTime()){//增加以后,时间还是小.还原
						regDate.setHours(regDate.getHours()-12);
					}
				}
			}
			
		}else{//未指定. 可以跨天
			/*
			var first=true;
			var add_dif=12;
			while(regDate.getTime()<now.getTime()){
				if(first){
					first=false;
					if(regDate.getHours()>12||InstructObj.cft){
						add_dif=24;
					}
				}
				regDate.setHours(regDate.getHours()+add_dif);
			}
			*/
		}
		//没有确认上下午,且没有结束日期
		if(!InstructObj.cft&&!InstructObj.timeEnd){
			if(regDate.getTime()<now.getTime()&&parseInt(times[0])<12){
				regDate.setHours(regDate.getHours()+12);
				if(regDate.getTime()<now.getTime()){//增加以后,时间还是小.还原
					regDate.setHours(regDate.getHours()-12);
				}
			}
		}
		InstructObj.date=regDate.getFullYear()+"-"+((regDate.getMonth()+1)>9?"":"0")+(regDate.getMonth()+1)+"-"+(regDate.getDate()>9?"":"0")+regDate.getDate();
		InstructObj.time=(regDate.getHours()>9?"":"0")+regDate.getHours()+"-"+(regDate.getMinutes()>9?"":"0")+regDate.getMinutes()+"-00";
		
	}
	//兼容时间段识别
	if(!InstructObj.timeEnd&&InstructObj.endtime){
		InstructObj.timeEnd=InstructObj.endtime.replaceAll(":","-");
		if(InstructObj.timeEnd.length==5) InstructObj.timeEnd=InstructObj.timeEnd+"-00";
	}
	
	if(InstructObj.timeEnd){
		if(!TimeCompareNotEqual(InstructObj.date,InstructObj.time.replaceAll("-",":"),InstructObj.date,InstructObj.timeEnd.replaceAll("-",":"))){ delete InstructObj.timeEnd; }
	}
	
	return InstructObj;
}

//比较2个时间
function TimeCompare(begindate,begintime,enddate,endtime){
	try{
		var begindates=begindate.split("-");
		var begin=new Date(begindates[0], parseInt(begindates[1])-1, begindates[2]); 
		
		var begintimes=begintime.split(":");
		begin.setHours(begintimes[0]);
	    begin.setMinutes(begintimes[1]);
	    	
		var enddates=enddate.split("-");
		var end=new Date(enddates[0], parseInt(enddates[1])-1, enddates[2]); 
	 
		var endtimes=endtime.split(":");
		end.setHours(endtimes[0]);
	    end.setMinutes(endtimes[1]);
		if(end.getTime()>=begin.getTime()){
			return true;
		}else{
			return false;
		}
	}catch(e){
		return false;
	}
}

//比较2个时间
function TimeCompareNotEqual(begindate,begintime,enddate,endtime){
	try{
		var begindates=begindate.split("-");
		var begin=new Date(begindates[0], parseInt(begindates[1])-1, begindates[2]); 
		
		var begintimes=begintime.split(":");
		begin.setHours(begintimes[0]);
	    begin.setMinutes(begintimes[1]);
	    	
		var enddates=enddate.split("-");
		var end=new Date(enddates[0], parseInt(enddates[1])-1, enddates[2]); 
	 
		var endtimes=endtime.split(":");
		end.setHours(endtimes[0]);
	    end.setMinutes(endtimes[1]);
		if(end.getTime()>begin.getTime()){
			return true;
		}else{
			return false;
		}
	}catch(e){
		return false;
	}
}

//日期相加
 function DateAdd(interval, number, idate) {
	var date=new Date(idate.getFullYear(),idate.getMonth(),idate.getDate());
	date.setHours(idate.getHours());
    date.setMinutes(idate.getMinutes());
    number = parseInt(number);
    switch (interval) {
          case "y": date.setFullYear(date.getFullYear() + number); break;
          case "m": date.setMonth(date.getMonth() + number); break;
          case "d": date.setDate(date.getDate() + number); break;
          case "w": date.setDate(date.getDate() + 7 * number); break;
          case "h": date.setHours(date.getHours() + number); break;
          case "n": date.setMinutes(date.getMinutes() + number); break;
          case "s": date.setSeconds(date.getSeconds() + number); break;
          case "l": date.setMilliseconds(date.getMilliseconds() + number); break;
     }
    return date;
 }
 
 function weekStr(i){
 	var str="";
 	switch (i) {
          case "0": str="星期日"; break;
          case "1": str="星期一"; break;
          case "2": str="星期二"; break;
          case "3": str="星期三"; break;
          case "4": str="星期四"; break;
          case "5": str="星期五"; break;
          case "6": str="星期六"; break;
     }
     return str;
 }
 
  function weekStr1(i){
 	var str="";
 	switch (i) {
          case "0": str="周日"; break;
          case "1": str="周一"; break;
          case "2": str="周二"; break;
          case "3": str="周三"; break;
          case "4": str="周四"; break;
          case "5": str="周五"; break;
          case "6": str="周六"; break;
     }
     return str;
 }

function wkShowDate(id,date){
	var dates=date.split("-");
	var startdate = new Date(dates[0], parseInt(dates[1])-1, dates[2]); 
	var dateShow=date+"&nbsp;&nbsp;"+ weekStr1(startdate.getDay()+"");//dates[0]+"年"+dates[1]+"月"+dates[2]+"日&nbsp;&nbsp;&nbsp;"+ weekStr(startdate.getDay()+"");
	$('#'+id).html(dateShow);
}

function wkShowDateStr(date){
	var dates=date.split("-");
	var startdate = new Date(dates[0], parseInt(dates[1])-1, dates[2]); 
	return date+"&nbsp;&nbsp;"+ weekStr1(startdate.getDay()+"");
}
 
//创建日期确认 
function createCalendarConfirm(sDate,sTime,eDate,eTime,content,id,name,timeTag){
	var sDateShow=wkShowDateStr(sDate);
	var eDateShow=wkShowDateStr(eDate);
	var htmlStr='<div class="confirm_div wkp_confirm_div" ts="'+timeTag+'">'+
					/*'<div class="wkp_top">'+
						'<div class="am-list-line">'+
							'<div>'+
								'<span class="ul-li-div-img"><img src="/mobile/plugin/fullsearch/img/'+pageStyle+'v_wkp_wev8.png"></span>'+
								'<div class="ul-li-div" style="margin-left: 75px;margin-top: 0px;line-height: 46px;">'+
									'<span class="ui-li-span ui-li-span-heading ui-li-span80">日程</span>'+
								'</div>'+
							'</div>'+
						'</div>'+
					'</div>'+
					*/
					'<div style="height: 185px;">'+
						'<div style="wkp_content_parent">'+
							'<div class="wkp_content">'+
									'<div class="wkp_content_inner wkp_title_str contentEdit" contentEditable="true"  peopleid="'+id+'" peoplename="'+name+'" placeholder="请输入标题...">'+content+'</div>'+
							'</div>'+
							'<div class="wkp_content_time" style="float: left;width: 100%;height: 80px;line-height: 35px;">'+
								'<div class="wkp_date_parent wkp_date_div">'+
									'<div class="ul-li-div-first"> <span id="'+timeTag+'_wk_sDate" class="wkp-ui-li-span wkp_date_time wkp_start_date_str" date="'+sDate+'" onclick="getCalendarDate(this)" afterDo="wkShowDate" >'+sDateShow+'</span></div>'+
								    '<div class="ul-li-div-second"><span id="'+timeTag+'_wk_sTime" class="wkp-ui-li-span wkp_date_time wkp_start_time_str" time="'+sTime+'" onclick="getCalendarTime(this)">'+sTime+'</span></div>'+
								'</div>'+
								'<div class="time-arrow" style="float: left;margin-top:32px;"></div>'+	
								'<div class="wkp_date_parent wkp_date_div">'+
									'<div class="ul-li-div-first"> <span id="'+timeTag+'_wk_eDate" class="wkp-ui-li-span wkp_date_time wkp_end_date_str" date="'+eDate+'" onclick="getCalendarDate(this)" afterDo="wkShowDate" >'+eDateShow+'</span></div>'+
								    '<div class="ul-li-div-second"><span id="'+timeTag+'_wk_eTime" class="wkp-ui-li-span wkp_date_time wkp_end_time_str" time="'+eTime+'" onclick="getCalendarTime(this)">'+eTime+'</span></div>'+
								'</div>'+
							'</div>'+
						'</div>'+
						'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
			 				 '<div class="Btn cancelBtn cancelWKP">取消</div>'+
			  				 '<div class="Btn OkBtn createWKP">确定</div>'+
						'</div>'+
					'</div>'+
			'</div>';
	return htmlStr;

}

//异步创建日程
function addCalendarAjax(id,name,content,sdate,stime,eDate,eTime,timeTag){
	if(stime.length==5){
		stime+=":00";
	}
	if(eTime.length==5){
		eTime+=":00";
	}
	ToastLoading("创建中...");
	//内容完整.直接新建.
	jQuery.ajax({
			type: "post",
		    url: "/mobile/plugin/4/postjson.jsp",
		    data:{"operation":"create","title":content,"notes":content,"startdate":(sdate+" "+stime),"enddate":(eDate+" "+eTime),"scheduletype":"0","touser":id},
		    dataType: "json",  
		    success:function (data) {
		    	hideToast();
		    	if (data == undefined || data == null) {
		    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
		    		return;
		    	} else { 
		    		if(data.result==1){
		    			var wkpData=data.data;
		    			
		    			var item={};
		    			item.id=wkpData.id;
		    			item.schema="WKP";
		    			item.url="";
		    			item.simpleTitle=content;
		    			item.simpleDesc=wkpData.creator;
		    			
		    			var other={};
		    			other.BEGINDATE=sdate;
		    			other.BEINGTIME=stime;
		    			other.CREATEDATE=nowDateStr;
		    			item.other=JSON.stringify(other);
		    			
		    			var str="已为"+(name==""?"您":name)+"安排好日程";
		    			play(str);
		    			$("#anser"+timeTag).html('<div class="tips">'+str+'：</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
					    $("#listview_1_"+timeTag).append(showSchema(item,1));	
					    //判断当前时间是否是未开始. 内容是否包含会议.
					    if(!isBeforeNow(sdate,stime)&&content.indexOf("会")>-1){
							$("#anser"+timeTag).append(showMaybeInfo2("或许您要的是创建会议","点击创建会议",wkp2meetingObj(sdate,stime,eDate,eTime,content)));
						}
		    			saveHistory(); 
		    		}else{
		    			ToastInfo("日程创建失败!",1);
		    		}
		    		
		    	}
		    }
	});
	
}


//清除日程确认框
function clearCalendarConfirm(){
	if($('.wkp_confirm_div')&&$('.wkp_confirm_div').length>0){
		var ts=$('.wkp_confirm_div').attr("ts");
		$("#anser"+ts).html('<div class="tips">日程已取消</div><div class="result"><div ts="'+ts+'" id="listview_1_'+ts+'"></div></div>');
		saveHistory();
	}
}

//新建请假流程
function addLeave(InstructObj,baseJson,timeTag){
	if(InstructObj.begintime.length>5){
		InstructObj.begintime=InstructObj.begintime.substring(0,5);
	}
	if(InstructObj.endtime.length>5){
		InstructObj.endtime=InstructObj.endtime.substring(0,5);
	}
	var str="为您创建请假流程，请确认";
	play(str);
	$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	$("#listview_1_"+timeTag).append(createLeaveConfirm(InstructObj,baseJson,timeTag));
	//设置编辑域宽度
	$("#listview_1_"+timeTag).find('.wf_content').css("width",(wW-90)+"px");
	//注册内容编辑事件
	$("#listview_1_"+timeTag).find('.wf_content').off("tap").on("tap",function(){
		var editDiv=$(this).find(".wf_content_inner");  
		$(editDiv).unbind("focus").unbind("blur");
		$(editDiv).focus(function(){
			noScroll=false;
			$(editDiv).attr("contentEditable","true");
		    $('.voicefooter').hide();
		}).blur(function(){
			noScroll=true;
			$(editDiv).attr("contentEditable","false");
		    showVoicefooter();
		});
		
		$(editDiv).focus();
	});
	
	
	//注册 btn事件
	$("#listview_1_"+timeTag).find('.cancelLeave').off("tap").on("tap",function(){
		noScroll=true;
		play("请假已取消");
		$("#anser"+timeTag).html('<div class="tips">请假已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		saveHistory();
	});
	
	$("#listview_1_"+timeTag).find('.createLeave').off("tap").on("tap",function(){
		noScroll=true;
		var content=$("#listview_1_"+timeTag).find(".wf_title_str").text();
		InstructObj.content=content;
		delete baseJson.LeaveTypeMap;
		delete baseJson.allLeaveTypeName;
		delete InstructObj.action;
		addWFAjax(InstructObj,baseJson,timeTag);
	});
	saveHistory();
}


//请假确认
function createLeaveConfirm(InstructObj,baseJson,timeTag){

	var htmlStr='<div class="confirm_div wf_confirm_div" ts="'+timeTag+'">'+
					'<div class="wf_top">'+
						'<div class="am-list-line">'+
							'<div>'+
								'<span class="ul-li-div-img"><img src="/mobile/plugin/fullsearch/img/'+pageStyle+'v_wf_wev8.png"></span>'+
								'<div class="ul-li-div" style="margin-left: 75px;margin-top: 0px;line-height: 46px;">'+
									'<span class="ui-li-span ui-li-span-heading ui-li-span80">'+InstructObj.workflowname+'</span>'+
								'</div>'+
							'</div>'+
						'</div>'+
					'</div>'+
					'<div style="height: 230px;">'+
						'<div style="wf_content_parent">'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">请假类型:</span>'+
								'</div>'+
								'<div class="wf_field">'+
									'<span class="ui-li-span ui-li-span100 wf_field_font">'+InstructObj.leaveTypeName+'</span>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">请假时间:</span>'+
								'</div>'+
								'<div class="wf_field wf_datetime">'+
									'<div class="wf_time">'+InstructObj.begindate+' '+InstructObj.begintime+'</div>'+
								  	'<div class="wf_time">'+InstructObj.enddate+' '+InstructObj.endtime+'</div>'+
								'</div>'+
								'<div class="wf_field wf_days">'+
									'<div>共'+InstructObj.days+'天</div>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">请假事由:</span>'+
								'</div>'+
								'<div class="wf_field wf_content">'+
									'<div class="wf_content_inner wf_title_str" contentEditable="true">'+InstructObj.content+'</div>'+
								'</div>'+
							'</div>'+
						'</div>'+
						'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
			 				 '<div class="Btn cancelBtn cancelLeave">取消</div>'+
			  				 '<div class="Btn OkBtn createLeave">确定</div>'+
						'</div>'+
					'</div>'+
			'</div>';
	return htmlStr;
}

//新建出差
function addOut(InstructObj,baseJson,timeTag){
	if(InstructObj.begintime.length>5){
		InstructObj.begintime=InstructObj.begintime.substring(0,5);
	}
	if(InstructObj.endtime.length>5){
		InstructObj.endtime=InstructObj.endtime.substring(0,5);
	}
	var str="为您创建出差流程，请确认";
	play(str);
	$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	$("#listview_1_"+timeTag).append(createOutConfirm(InstructObj,baseJson,timeTag));
	//设置编辑域宽度
	$("#listview_1_"+timeTag).find('.wf_content').css("width",(wW-90)+"px");
	//注册内容编辑事件
	$("#listview_1_"+timeTag).find('.wf_content').off("tap").on("tap",function(){
		var editDiv=$(this).find(".wf_content_inner");  
		$(editDiv).unbind("focus").unbind("blur");
		$(editDiv).focus(function(){
			noScroll=false;
			$(editDiv).attr("contentEditable","true");
		    $('.voicefooter').hide();
		}).blur(function(){
			noScroll=true;
			$(editDiv).attr("contentEditable","false");
		    showVoicefooter();
		});
		
		$(editDiv).focus();
	});
	
	
	//注册 btn事件
	$("#listview_1_"+timeTag).find('.cancelLeave').off("tap").on("tap",function(){
		noScroll=true;
		play("出差已取消");
		$("#anser"+timeTag).html('<div class="tips">出差已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		saveHistory();
	});
	
	$("#listview_1_"+timeTag).find('.createLeave').off("tap").on("tap",function(){
		noScroll=true;
		var content=$("#listview_1_"+timeTag).find(".wf_title_str").text();
		InstructObj.content=content;
		delete baseJson.outTypeName;
		delete InstructObj.action;
		addWFAjax(InstructObj,baseJson,timeTag);
	});
	saveHistory();
}


//出差确认
function createOutConfirm(InstructObj,baseJson,timeTag){

	var htmlStr='<div class="confirm_div wf_confirm_div" ts="'+timeTag+'">'+
					'<div class="wf_top">'+
						'<div class="am-list-line">'+
							'<div>'+
								'<span class="ul-li-div-img"><img src="/mobile/plugin/fullsearch/img/'+pageStyle+'v_wf_wev8.png"></span>'+
								'<div class="ul-li-div" style="margin-left: 75px;margin-top: 0px;line-height: 46px;">'+
									'<span class="ui-li-span ui-li-span-heading ui-li-span80">'+InstructObj.workflowname+'</span>'+
								'</div>'+
							'</div>'+
						'</div>'+
					'</div>'+
					'<div style="height: 230px;">'+
						'<div style="wf_content_parent">'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">出差类型:</span>'+
								'</div>'+
								'<div class="wf_field">'+
									'<span class="ui-li-span ui-li-span100 wf_field_font">'+baseJson.outTypeName+'</span>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">出差时间:</span>'+
								'</div>'+
								'<div class="wf_field wf_datetime">'+
									'<div class="wf_time">'+InstructObj.begindate+' '+InstructObj.begintime+'</div>'+
								  	'<div class="wf_time">'+InstructObj.enddate+' '+InstructObj.endtime+'</div>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">出差事由:</span>'+
								'</div>'+
								'<div class="wf_field wf_content">'+
									'<div class="wf_content_inner wf_title_str" contentEditable="true">'+InstructObj.content+'</div>'+
								'</div>'+
							'</div>'+
						'</div>'+
						'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
			 				 '<div class="Btn cancelBtn cancelLeave">取消</div>'+
			  				 '<div class="Btn OkBtn createLeave">确定</div>'+
						'</div>'+
					'</div>'+
			'</div>';
	return htmlStr;
}

//新建费用报销
function addFna(InstructObj,baseJson,timeTag){
	var str="为您创建报销流程，请确认";
	play(str);
	$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	$("#listview_1_"+timeTag).append(createFnaConfirm(InstructObj,baseJson,timeTag));
	//设置编辑域宽度
	$("#listview_1_"+timeTag).find('.wf_content').css("width",(wW-90)+"px");
	//注册内容编辑事件
	$("#listview_1_"+timeTag).find('.wf_content').off("tap").on("tap",function(){
		var editDiv=$(this).find(".wf_content_inner");  
		$(editDiv).unbind("focus").unbind("blur");
		$(editDiv).focus(function(){
			noScroll=false;
			$(editDiv).attr("contentEditable","true");
		    $('.voicefooter').hide();
		}).blur(function(){
			noScroll=true;
			$(editDiv).attr("contentEditable","false");
		    showVoicefooter();
		});
		
		$(editDiv).focus();
	});
	
	
	//注册 btn事件
	$("#listview_1_"+timeTag).find('.cancelFna').off("tap").on("tap",function(){
		noScroll=true;
		play("报销已取消");
		$("#anser"+timeTag).html('<div class="tips">报销已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		saveHistory();
	});
	
	$("#listview_1_"+timeTag).find('.createFna').off("tap").on("tap",function(){
		noScroll=true;
		var content=$("#listview_1_"+timeTag).find(".wf_remark_str").text();
		var amount=$("#listview_1_"+timeTag).find(".wf_amount_str").text();
		InstructObj.description=content;
		if(amount!=InstructObj.amount){
			try{
				amount=parseFloat(amount);
				InstructObj.amount=amount;
			}catch(e){}
		}
		delete InstructObj.crmName;
		delete InstructObj.feetypeName;
		delete InstructObj.resourcename;
		delete InstructObj.action;
		//判断日期
		InstructObj.occurdate=$('#fna_date_'+timeTag).text();
		
		addWFAjax(InstructObj,baseJson,timeTag);
	});
	saveHistory();
}

//报销确认
function createFnaConfirm(InstructObj,baseJson,timeTag){
	var remarks=InstructObj.occurdate.split("-");
	var budgettypeHtml="";
	var crmHtml="";
	var reduceHeight=0;
	//承担类型
	if(baseJson.fnaNoInteractiveField.indexOf(",budgettype,")==-1){
		budgettypeHtml='<div class="wf_content_item wf_content_item30">'+
							'<div class="wf_label">'+
								 '<span class="ui-li-span ui-li-span100 wf_label_font">承担类型:</span>'+
							'</div>'+
							'<div class="wf_field">'+
								'<span class="ui-li-span ui-li-span100 wf_field_font">'+InstructObj.budgettypeName+'</span>'+
							'</div>'+
						'</div>';
		reduceHeight+=40;
	}
	//客户
	if(baseJson.fnaNoInteractiveField.indexOf(",crm,")==-1){
		crmHtml='<div class="wf_content_item wf_content_item30">'+
							'<div class="wf_label">'+
								 '<span class="ui-li-span ui-li-span100 wf_label_font">相关客户:</span>'+
							'</div>'+
							'<div class="wf_field">'+
								'<span class="ui-li-span ui-li-span100 wf_field_font">'+InstructObj.crmName+'</span>'+
							'</div>'+
						'</div>';
		reduceHeight+=40;
	}
	var htmlStr='<div class="confirm_div wf_confirm_div" ts="'+timeTag+'">'+
					'<div class="wf_top">'+
						'<div class="am-list-line">'+
							'<div>'+
								'<span class="ul-li-div-img"><img src="/mobile/plugin/fullsearch/img/'+pageStyle+'v_wf_wev8.png"></span>'+
								'<div class="ul-li-div" style="margin-left: 75px;margin-top: 0px;line-height: 46px;">'+
									'<span class="ui-li-span ui-li-span-heading ui-li-span80">'+InstructObj.workflowname+'</span>'+
								'</div>'+
							'</div>'+
						'</div>'+
					'</div>'+
					'<div style="height: '+(280+reduceHeight)+'px;">'+
						'<div style="wf_content_parent">'+
							'<div style="height:10px;"></div>'+
							budgettypeHtml+
							'<div class="wf_content_item wf_content_item30">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">承担主体:</span>'+
								'</div>'+
								'<div class="wf_field">'+
									'<span class="ui-li-span ui-li-span100 wf_field_font">'+InstructObj.resourcename+'</span>'+
								'</div>'+
							'</div>'+
							crmHtml+
							'<div class="wf_content_item wf_content_item30">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">费用日期:</span>'+
								'</div>'+
								'<div class="wf_field">'+
									'<span id="fna_date_'+timeTag+'" class="ui-li-span ui-li-span100 wf_field_font" onclick="getCalendarDate(this)">'+InstructObj.occurdate+'</span>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item wf_content_item30">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">费用科目:</span>'+
								'</div>'+
								'<div class="wf_field">'+
									'<span class="ui-li-span ui-li-span100 wf_field_font">'+InstructObj.feetypeName+'</span>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item wf_content_item30">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">费用金额:</span>'+
								'</div>'+
								'<div class="wf_field wf_content wf_content30">'+
									'<div class="wf_content_inner wf_content_inner30 wf_amount_str" contentEditable="true">'+InstructObj.amount+'</div>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">费用说明:</span>'+
								'</div>'+
								'<div class="wf_field wf_content">'+
									'<div class="wf_content_inner wf_remark_str" contentEditable="true">'+remarks[0]+"年"+remarks[1]+"月 "+InstructObj.feetypeName+'</div>'+
								'</div>'+
							'</div>'+
						'</div>'+
						'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
			 				 '<div class="Btn cancelBtn cancelFna">取消</div>'+
			  				 '<div class="Btn OkBtn createFna">确定</div>'+
						'</div>'+
					'</div>'+
			'</div>';
	return htmlStr;
}


//新建用车
function addCar(InstructObj,baseJson,timeTag){
	var str="为您创建用车流程，请确认";
	play(str);
	$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	$("#listview_1_"+timeTag).append(createCarConfirm(InstructObj,baseJson,timeTag));
	//设置编辑域宽度
	$("#listview_1_"+timeTag).find('.wf_content').css("width",(wW-90)+"px");
	//注册内容编辑事件
	$("#listview_1_"+timeTag).find('.wf_content').off("tap").on("tap",function(){
		var editDiv=$(this).find(".wf_content_inner");  
		$(editDiv).unbind("focus").unbind("blur");
		$(editDiv).focus(function(){
			noScroll=false;
			$(editDiv).attr("contentEditable","true");
		    $('.voicefooter').hide();
		}).blur(function(){
			noScroll=true;
			$(editDiv).attr("contentEditable","false");
		    showVoicefooter();
		});
		
		$(editDiv).focus();
	});
	
	
	//注册 btn事件
	$("#listview_1_"+timeTag).find('.cancelBtn').off("tap").on("tap",function(){
		noScroll=true;
		play("用车已取消");
		$("#anser"+timeTag).html('<div class="tips">用车已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		saveHistory();
	});
	
	$("#listview_1_"+timeTag).find('.OkBtn').off("tap").on("tap",function(){
		noScroll=true;
		var content=$("#listview_1_"+timeTag).find(".wf_remark_str").text();
		InstructObj.content=content;
		
		addWFAjax(InstructObj,baseJson,timeTag);
	});
	saveHistory();
}

//用车确认
function createCarConfirm(InstructObj,baseJson,timeTag){
	var htmlStr='<div class="confirm_div wf_confirm_div" ts="'+timeTag+'">'+
					'<div class="wf_top">'+
						'<div class="am-list-line">'+
							'<div>'+
								'<span class="ul-li-div-img"><img src="/mobile/plugin/fullsearch/img/'+pageStyle+'v_wf_wev8.png"></span>'+
								'<div class="ul-li-div" style="margin-left: 75px;margin-top: 0px;line-height: 46px;">'+
									'<span class="ui-li-span ui-li-span-heading ui-li-span80">'+InstructObj.workflowname+'</span>'+
								'</div>'+
							'</div>'+
						'</div>'+
					'</div>'+
					'<div style="height: 190px;">'+
						'<div style="wf_content_parent">'+
							'<div class="wf_content_item" style="margin-top:10px">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">用车时间:</span>'+
								'</div>'+
								'<div class="wf_field wf_datetime">'+
									'<div class="wf_time">'+InstructObj.begindate+' '+InstructObj.begintime+'</div>'+
								  	'<div class="wf_time">'+InstructObj.enddate+' '+(InstructObj.endtime?InstructObj.endtime:'')+'</div>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">用车说明:</span>'+
								'</div>'+
								'<div class="wf_field wf_content">'+
									'<div class="wf_content_inner wf_remark_str" contentEditable="true">'+InstructObj.content+'</div>'+
								'</div>'+
							'</div>'+
						'</div>'+
						'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
			 				 '<div class="Btn cancelBtn ">取消</div>'+
			  				 '<div class="Btn OkBtn">确定</div>'+
						'</div>'+
					'</div>'+
			'</div>';
	return htmlStr;
}

//异步提交流程
function addWFAjax(InstructObj,baseJson,timeTag){
	var op={};
	$.extend(op,InstructObj,baseJson,{"type":"saveWF"});
	ToastLoading("创建中...");
	//内容完整.直接新建.
	jQuery.ajax({
			type: "post",
		    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
		    data:op,
		    dataType: "json",  
		    success:function (data) {
		    	hideToast();
		    	if (data == undefined || data == null) {
		    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
		    		return;
		    	} else { 
		    		if(data.result==1){
		    			var str="已为您提交流程";
		    			if(data.data){
			    			play(str);
			    			$("#anser"+timeTag).html('<div class="tips">'+str+'：</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
						    $("#listview_1_"+timeTag).append(showSchema(data.data,1));	
		    			}else{
		    				str="流程提交异常,请联系管理员";
		    				play(str);
		    				//异常无数据返回
		    				$("#anser"+timeTag).html('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		    			}
		    			saveHistory(); 
		    		}else{
		    			if(data.requestid){
		    				ToastInfo("流程创建失败("+data.requestid+")!"+data.msg,2);
		    			}else{
			    			ToastInfo("流程创建失败!",1);
		    			}
		    		}
		    	}
		    }
	});
}
//清除流程确认框
function clearWfConfirm(){
	if($('.wf_confirm_div')&&$('.wf_confirm_div').length>0){
		var ts=$('.wf_confirm_div').attr("ts");
		$("#anser"+ts).html('<div class="tips">流程已取消</div><div class="result"><div ts="'+ts+'" id="listview_1_'+ts+'"></div></div>');
		saveHistory();
	}
}

//追加微博
function addBlog(InstructObj,baseJson,timeTag){
	var dateStr="今天";
	if(InstructObj.date!=nowDateStr){
		dateStr=InstructObj.date;
	}
	var str="为您追加"+dateStr+"的工作微博，请确认";
	play(str);
	$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	$("#listview_1_"+timeTag).append(createBlogConfirm(InstructObj,baseJson,timeTag));
	//设置编辑域宽度
	$("#listview_1_"+timeTag).find('.blog_content').css("width",wW+"px");
	//注册内容编辑事件
	$("#listview_1_"+timeTag).find('.blog_content').off("tap").on("tap",function(){
		var editDiv=$(this).find(".blog_content_inner");  
		$(editDiv).unbind("focus").unbind("blur");
		$(editDiv).focus(function(){
			noScroll=false;
			$(editDiv).attr("contentEditable","true");
		    $('.voicefooter').hide();
		}).blur(function(){
			noScroll=true;
			$(editDiv).attr("contentEditable","false");
		    showVoicefooter();
		});
		
		$(editDiv).focus();
	});
	
	
	//注册 btn事件
	$("#listview_1_"+timeTag).find('.cancelBlog').off("tap").on("tap",function(){
		noScroll=true;
		play("微博已取消");
		$("#anser"+timeTag).html('<div class="tips">微博已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		saveHistory();
	});
	
	$("#listview_1_"+timeTag).find('.createBlog').off("tap").on("tap",function(){
		noScroll=true;
		var content=$("#listview_1_"+timeTag).find(".blog_title_str").html();
		InstructObj.content='<div>'+content+'</div>';
		addBlogAjax(InstructObj,baseJson,timeTag); 
	});
	saveHistory();
}

//追加微博确认
function createBlogConfirm(InstructObj,baseJson,timeTag){
	var htmlStr='<div class="confirm_div blog_confirm_div" ts="'+timeTag+'">'+
					'<div style="height: 150px;">'+
						'<div style="blog_content_parent">'+
							'<div class="blog_content_item">'+
								'<div class="blog_field blog_content">'+
									'<div class="blog_content_inner blog_title_str" contentEditable="true">'+InstructObj.content+'</div>'+
								'</div>'+
							'</div>'+
						'</div>'+
						'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
			 				 '<div class="Btn cancelBtn cancelBlog">取消</div>'+
			  				 '<div class="Btn OkBtn createBlog">确定</div>'+
						'</div>'+
					'</div>'+
			'</div>';
	return htmlStr;
}
//清除微博确认框
function clearBlogConfirm(){
	if($('.blog_confirm_div')&&$('.blog_confirm_div').length>0){
		var ts=$('.blog_confirm_div').attr("ts");
		$("#anser"+ts).html('<div class="tips">微博已取消</div><div class="result"><div ts="'+ts+'" id="listview_1_'+ts+'"></div></div>');
		saveHistory();
	}
}
//异步追加微博
function addBlogAjax(InstructObj,baseJson,timeTag){
	ToastLoading("创建中...");
	//内容完整.直接新建.
	jQuery.ajax({
			type: "post",
		    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
		    data:{"type":"saveBlog","operation":"saveBlog","userid":InstructObj.userid,"content":InstructObj.content,"workdate":InstructObj.date,"comefrom":clientType},
		    dataType: "json",  
		    success:function (data) {
		    	hideToast();
		    	if (data == undefined || data == null) {
		    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
		    		return;
		    	} else { 
		    		if(data.result=="1"){
		    			var dateStr="今天";
						if(InstructObj.date!=nowDateStr){
							dateStr=InstructObj.date;
						}
		    			var str="已为您追加"+dateStr+"的工作微博";
		    			play(str);
		    			$("#anser"+timeTag).html('<div class="tips">'+str+'：</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
					    var discessList=new Array(data.discussItem);
					    $("#listview_1_"+timeTag).append(showBlog(data.userInfo,discessList,1));	
		    			saveHistory(); 
		    		}else{
		    			ToastInfo("微博创建失败!",1);
		    		}
		    	}
		    }
	});
}

//通过日程可能新建会议
function wkp2meetingObj(sDate,sTime,eDate,eTime,content){
	var objstr={};
	var slots={};
	var semantic={};
	var wkp={};
	objstr.text="创建会议";
	objstr.rc="0";
	objstr.service="FW_CMD";
	objstr.CannotEdit=true;
	slots.oper="create";
	slots.type="Meeting";
	semantic.slots=slots;
	objstr.semantic=semantic;
	//把日程初始时间带过去
	wkp.sDate=sDate;
	wkp.sTime=sTime;
	wkp.eDate=eDate;
	wkp.eTime=eTime;
	
	if(content&&content!=""){
		wkp.content=content;
	}
	slots.wkpTime=wkp;
	return objstr;
}

//时间确认选择框
function confirmTime(InstructObj,baseJson,timeTag){
	var typeStr="";
	if(InstructObj.type=="WF"){
		typeStr="流程";
		if(equalsIgnoreCase(InstructObj.wftype,"out")){
			typeStr="出差";
		}else if(equalsIgnoreCase(InstructObj.wftype,"Leave")){
			typeStr="请假";
		}
	}else if(equalsIgnoreCase(InstructObj.type,"meeting")){
		typeStr="会议";
	}
										
	var str="好的，请确认"+typeStr+"时间:";
	play(str);
	$("#anser"+timeTag).html("");
	$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div class="meeting_confirm_div"  ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	
	$("#listview_1_"+timeTag).append(createTimeConfirm(InstructObj.begindate,InstructObj.begintime,InstructObj.enddate,InstructObj.endtime,timeTag));
	
	//设置日期宽度
	$("#listview_1_"+timeTag).find('.wkp_date_div').css("width",((wW-30-40)/2)+"px");
		
	//注册 btn事件
	$("#listview_1_"+timeTag).find('.cancelTime').off("tap").on("tap",function(){
		play(typeStr+"已取消");
		$('.currentInstructTip').removeClass("currentInstructTip");
		$("#anser"+timeTag).html('<div class="tips">'+typeStr+'已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		saveHistory();
	});
	
	$("#listview_1_"+timeTag).find('.createTime').off("tap").on("tap",function(){
		cancelCalenderColor();
		var sD=$("#listview_1_"+timeTag).find(".wkp_start_date_str").attr("date");
		var sT=$("#listview_1_"+timeTag).find(".wkp_start_time_str").attr("time");
		var eD=$("#listview_1_"+timeTag).find(".wkp_end_date_str").attr("date");
		var eT=$("#listview_1_"+timeTag).find(".wkp_end_time_str").attr("time");
		//更新记录的时间指令
		var obj=JSON.parse($('#instructTipObj'+timeTag).attr("obj"));	
		obj.begindate=sD;
		obj.begintime=sT;
		obj.enddate=eD;
		obj.endtime=eT;
		if(obj.needComfirmTime){
			delete obj.needComfirmTime;
		}
		$('#instructTipObj'+timeTag).attr("obj",JSON.stringify(obj));
		
		if(TimeCompareNotEqual(sD,sT,eD,eT)){
			$("#anser"+timeTag).html("");
			//提示语
			if(InstructObj.nextTip){
				var nextTip=InstructObj.nextTip;
				//加载后续提醒内容.
				$('#anser'+timeTag).append('<div class="instructTip" target="'+timeTag+'">'+nextTip+'</div>');
				play(nextTip);
			}else if(InstructObj.continueAction){
				var objstr={};
				objstr.text="继续";
				objstr.rc="0";
				objstr.service="continue";
				backUnderstand(JSON.stringify(objstr),timeTag);
			}
		}else{
			ToastInfo("结束时间不能在开始时间之前",1);
		}
	});
	
	saveHistory();
}



//通用时间段 确认框
function createTimeConfirm(sDate,sTime,eDate,eTime,timeTag){
	var sDateShow=wkShowDateStr(sDate);
	var eDateShow=wkShowDateStr(eDate);
	var htmlStr='<div class="confirm_div" ts="'+timeTag+'">'+
					'<div style="height: 135px;">'+
						'<div style="wkp_content_parent">'+
							'<div class="wkp_content_time" style="float: left;width: 100%;height: 80px;line-height: 35px;">'+
								'<div class="wkp_date_parent wkp_date_div">'+
									'<div class="ul-li-div-first"> <span id="'+timeTag+'_wk_sDate" class="wkp-ui-li-span wkp_date_time wkp_start_date_str" date="'+sDate+'" onclick="getCalendarDate(this)" afterDo="wkShowDate" >'+sDateShow+'</span></div>'+
								    '<div class="ul-li-div-second"><span id="'+timeTag+'_wk_sTime" class="wkp-ui-li-span wkp_date_time wkp_start_time_str" time="'+sTime+'" onclick="getCalendarTime(this)">'+sTime+'</span></div>'+
								'</div>'+
								'<div class="time-arrow" style="float: left;margin-top:32px;"></div>'+	
								'<div class="wkp_date_parent wkp_date_div">'+
									'<div class="ul-li-div-first"> <span id="'+timeTag+'_wk_eDate" class="wkp-ui-li-span wkp_date_time wkp_end_date_str" date="'+eDate+'" onclick="getCalendarDate(this)" afterDo="wkShowDate" >'+eDateShow+'</span></div>'+
								    '<div class="ul-li-div-second"><span id="'+timeTag+'_wk_eTime" class="wkp-ui-li-span wkp_date_time wkp_end_time_str" time="'+eTime+'" onclick="getCalendarTime(this)">'+eTime+'</span></div>'+
								'</div>'+
							'</div>'+
						'</div>'+
						'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
			 				 '<div class="Btn cancelBtn cancelTime">取消</div>'+
			  				 '<div class="Btn OkBtn createTime">确定</div>'+
						'</div>'+
					'</div>'+
			'</div>';
	return htmlStr;
}


//清除会议确认框
function clearMeetingConfirm(){
	if($('.meeting_confirm_div')&&$('.meeting_confirm_div').length>0){
		$('.currentInstructTip').removeClass("currentInstructTip");
		var ts=$('.meeting_confirm_div').attr("ts");
		$("#anser"+ts).html('<div class="tips">会议已取消</div><div class="result"><div ts="'+ts+'" id="listview_1_'+ts+'"></div></div>');
		saveHistory();
	}
}

//申请会议
function addMeeting(InstructObj,baseJson,timeTag){
	InstructObj.begintime=InstructObj.begintime.substring(0,5);
	InstructObj.endtime=InstructObj.endtime.substring(0,5);
	var str="为您安排会议，请确认";
	play(str);
	$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	$("#listview_1_"+timeTag).append(createMeetingConfirm(InstructObj,baseJson,timeTag));
	//设置编辑域宽度
	$("#listview_1_"+timeTag).find('.wf_content').css("width",(wW-90)+"px");
	//注册内容编辑事件
	$("#listview_1_"+timeTag).find('.wf_content').off("tap").on("tap",function(){
		var editDiv=$(this).find(".wf_content_inner");  
		$(editDiv).unbind("focus").unbind("blur");
		$(editDiv).focus(function(){
			noScroll=false;
			$(editDiv).attr("contentEditable","true");
		    $('.voicefooter').hide();
		}).blur(function(){
			noScroll=true;
			$(editDiv).attr("contentEditable","false");
		    showVoicefooter();
		});
		
		$(editDiv).focus();
	});
	
	
	//注册 btn事件
	$("#listview_1_"+timeTag).find('.cancelMeeting').off("tap").on("tap",function(){
		noScroll=true;
		play("会议已取消");
		$('.currentInstructTip').removeClass("currentInstructTip");
		$("#anser"+timeTag).html('<div class="tips">会议已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		saveHistory();
	});
	
	$("#listview_1_"+timeTag).find('.createMeeting').off("tap").on("tap",function(){
		noScroll=true;
		var content=$("#listview_1_"+timeTag).find(".meeting_title_str").html();
		InstructObj.content=content;
		addMeetingAjax(InstructObj,baseJson,timeTag); 
	});
	saveHistory();
}

//新建会议确认
function createMeetingConfirm(InstructObj,baseJson,timeTag){
	var htmlStr='<div class="confirm_div meeting_confirm_div" ts="'+timeTag+'">'+
					'<div class="wf_top">'+
						'<div class="am-list-line">'+
							'<div>'+
								'<span class="ul-li-div-img"><img src="/mobile/plugin/fullsearch/img/'+pageStyle+'v_meeting_wev8.png"></span>'+
								'<div class="ul-li-div" style="margin-left: 75px;margin-top: 0px;line-height: 46px;">'+
									'<span class="ui-li-span ui-li-span-heading ui-li-span80">会议安排</span>'+
								'</div>'+
							'</div>'+
						'</div>'+
					'</div>'+
					'<div style="height: 230px;">'+
						'<div style="wf_content_parent">'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">会议地点:</span>'+
								'</div>'+
								'<div class="wf_field">'+
									'<span class="ui-li-span ui-li-span100 wf_field_font">'+InstructObj.addressName+(InstructObj.isCus==1?'&nbsp;&nbsp;(自定义)':'')+'</span>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">会议时间:</span>'+
								'</div>'+
								'<div class="wf_field wf_datetime">'+
									'<div class="wf_time">'+InstructObj.begindate+' '+InstructObj.begintime+'</div>'+
								  	'<div class="wf_time">'+InstructObj.enddate+' '+InstructObj.endtime+'</div>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">会议名称:</span>'+
								'</div>'+
								'<div class="wf_field wf_content">'+
									'<div class="wf_content_inner meeting_title_str" contentEditable="true">'+InstructObj.content+'</div>'+
								'</div>'+
							'</div>'+
						'</div>'+
						'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
			 				 '<div class="Btn cancelBtn cancelMeeting">取消</div>'+
			  				 '<div class="Btn OkBtn createMeeting">确定</div>'+
						'</div>'+
					'</div>'+
			'</div>';
	return htmlStr;
}

//冲突会议提示
function conflictMeeting(InstructObj,baseJson,timeTag){
	ToastLoading("创建中...");
	var str="您选择的会议室已被以下会议占用，是否重新选择会议室？";
	play(str);
	$("#anser"+timeTag).html("");
	$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div class="meeting_confirm_div"  ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	
	jQuery.ajax({
		async: false, 
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"loadConflictMeeting","begindate":InstructObj.begindate,"begintime":InstructObj.begintime,"enddate":InstructObj.enddate,"endtime":InstructObj.endtime,"address":InstructObj.addressId},
	    dataType: "json",  
		success : function(data) {
			hideToast();
			 if(data.result == 1){
			 	var listSize=data.count;
			 	$.each(data.list,function(j,item){
					var isLast=(j==listSize-1)?"1":"0";
					$("#listview_1_"+timeTag).append(showMeeting(item,isLast));
				});
				
				//增加2按钮
				var btnHtml='<div class="" style="width: 310px;margin: auto;line-height: 30px;height: 50px;margin-top: 10px">'+
				 				 '<div class="Btn cancelBtn MeetingBtn cancelMeeting">取消会议</div>'+
				  				 '<div class="Btn OkBtn MeetingBtn createMeeting">继续创建</div>'+
				  				 '<div class="Btn OkBtn MeetingBtn changeAddress" style="width:120px">选择其他会议室</div>'+
							'</div>';
				$("#listview_1_"+timeTag).append(btnHtml);	
				
			 	setTimeout(function(){
					$("#result"+timeTag ).height($('.result-current-ul').height());
				},200);
			 }
		}
	});
	
	
	//注册 btn事件
	$("#listview_1_"+timeTag).find('.cancelMeeting').off("tap").on("tap",function(){
		play("会议已取消");
		$('.currentInstructTip').removeClass("currentInstructTip");
		$("#anser"+timeTag).html('<div class="tips">会议已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		saveHistory();
	});
	
	$("#listview_1_"+timeTag).find('.createMeeting').off("tap").on("tap",function(){
		submitMeetingAjax(InstructObj,baseJson,timeTag);
	});
	
	$("#listview_1_"+timeTag).find('.changeAddress').off("tap").on("tap",function(){
		delete InstructObj.addressId;
		delete InstructObj.isCus;
		delete InstructObj.addressName;
		delete InstructObj.selectAddress;
		delete InstructObj.action;
		if($('#instructTipObj'+timeTag)&&$('#instructTipObj'+timeTag).length>0){
	    	$('#instructTipObj'+timeTag).attr("obj",JSON.stringify(InstructObj) );
	    }
		loadMeetingAddress(timeTag,InstructObj,"您选择的会议室已被占用，请重新选择会议室");
	});
	
	saveHistory();
}


//提交会议
function addMeetingAjax(InstructObj,baseJson,timeTag){
	ToastLoading("创建中...");
	//提交时判断会议室冲突检测
	if(InstructObj.roomcheck==0){//不校验
		submitMeetingAjax(InstructObj,baseJson,timeTag);
	}else{//校验
		if(InstructObj.isCus==1){//自定义会议室
			submitMeetingAjax(InstructObj,baseJson,timeTag);
		}else{//系统会议室
			var strData = "&address="+InstructObj.addressId+"&begindate="+InstructObj.begindate+"&begintime="+InstructObj.begintime+"&enddate="+InstructObj.enddate+"&endtime="+InstructObj.endtime;
			var op={"method":"chkRoom","address":InstructObj.addressId,"begindate":InstructObj.begindate,"begintime":InstructObj.begintime,"enddate":InstructObj.enddate,"endtime":InstructObj.endtime};
			jQuery.ajax({
				async: false, 
				type : "POST", 
				url: encodeURI("/meeting/data/ChkMeetingRoom.jsp?method=chkRoom"+strData),
		   		data:{},
				success : function(data) {
					 data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
					 if(data != "0"){
					 	if(InstructObj.roomcheck==1){
					 		//显示当前占用会议
					 		conflictMeeting(InstructObj,baseJson,timeTag)
					 	}else{
					 		delete InstructObj.addressId;
					 		delete InstructObj.isCus;
					 		delete InstructObj.addressName;
					 		delete InstructObj.selectAddress;
					 		delete InstructObj.action;
					 		if($('#instructTipObj'+timeTag)&&$('#instructTipObj'+timeTag).length>0){
						    	$('#instructTipObj'+timeTag).attr("obj",JSON.stringify(InstructObj) );
						    }
					 		loadMeetingAddress(timeTag,InstructObj,"您选择的会议室已被占用，请重新选择会议室");
					 	}
					 }else{
					 	submitMeetingAjax(InstructObj,baseJson,timeTag);
					 }
				}
			});
		}
	}
}

//直接提交.不再有任何校验
function submitMeetingAjax(InstructObj,baseJson,timeTag){ 
	ToastLoading("创建中...");
	delete InstructObj.lastTarget;
	delete InstructObj.target;
	delete InstructObj.checkTime;
	delete InstructObj.action;
	delete InstructObj.selectAddress;
	delete InstructObj.roomcheck;
	var op={};
	$.extend(op,InstructObj,{"type":"submitMeeting"});
	//内容完整.直接新建.
	jQuery.ajax({
			type: "post",
		    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
		    data:op,
		    dataType: "json",  
		    success:function (data) {
		    	hideToast();
		    	if (data == undefined || data == null) {
		    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
		    		return;
		    	} else { 
		    		if(data.result=="1"){
		    			var str="已为您创建会议";
		    			play(str);
		    			$("#anser"+timeTag).html("");
						$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		    			$("#listview_1_"+timeTag).append(showCreateMeeting(data.item,1));	
		    			$('.currentInstructTip').removeClass("currentInstructTip");
		    			$(".ask").off("tap");
		    			$('.tapDiv').remove();
		    			saveHistory(); 
		    		}else{
		    			ToastInfo("创建会议失败!",1);
		    		}
		    	}
		    }
	});
}


/*客户联系选择客户*/
function showCrmAction(item,isLast){
	var icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_crm_wev8.png';
	var css=isLast=="1"?"lastLi":"";
	var str={};
	str.id=item.id;
	str.text=item.simpleTitle;
	str.desc=item.simpleDesc;
	str.service="chooseCrm";
	str.rc="0";
	
	var htmlStr='<div class="crmContactChooseDiv am-list-item '+item.schema+' '+css+'" deepObj=\''+JSON.stringify(str)+'\' >'+
					'<div class="am-list-line">'+
						 '<div class="am-list-content">'+
							'<span class="ul-li-div-img">'+
							 	'<img src="'+icon+'">'+
							'</span>'+
							'<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+item.simpleTitle+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item.simpleDesc+'</span></div>'+
							'</div>'+
						 '</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}
/*客户联系选择点击*/
function crmContactTap(){
	$('.crmContactChooseDiv').off("tap");
	$('.anserCurrent').find('.crmContactChooseDiv').on("tap",function(){
		deepUnderstand(this);
		$('.crmContactChooseDiv').off("tap");
	})
	
}

/*客户联系确认框*/
function addCrmContact(InstructObj,baseJson,timeTag){
 	var str="好的，为您记录客户联系，请确认";
	play(str);
	$("#anser"+timeTag).append('<div class="tips">'+str+'：</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	$("#listview_1_"+timeTag).append(createCrmContactConfirm(InstructObj,baseJson,timeTag));
	//设置编辑域宽度
	$("#listview_1_"+timeTag).find('.crmContact_content').css("width",wW+"px");
	//注册内容编辑事件
	$("#listview_1_"+timeTag).find('.crmContact_content').off("tap").on("tap",function(){
		var editDiv=$(this).find(".blog_content_inner");  
		$(editDiv).unbind("focus").unbind("blur");
		$(editDiv).focus(function(){
			noScroll=false;
			$(editDiv).attr("contentEditable","true");
		    $('.voicefooter').hide();
		}).blur(function(){
			noScroll=true;
			$(editDiv).attr("contentEditable","false");
		    showVoicefooter();
		});
		
		$(editDiv).focus();
	});
	
	
	//注册 btn事件
	$("#listview_1_"+timeTag).find('.cancelCrmContact').off("tap").on("tap",function(){
		noScroll=true;
		play("客户联系已取消");
		$("#anser"+timeTag).html('<div class="tips">客户联系已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		saveHistory();
	});
	
	$("#listview_1_"+timeTag).find('.createCrmContact').off("tap").on("tap",function(){
		noScroll=true;
		var content=$("#listview_1_"+timeTag).find(".crmContact_title_str").html();
		InstructObj.content=content;
		addCrmContactAjax(InstructObj,baseJson,timeTag); 
	});
	saveHistory();
		
}
/*客户联系确认框*/
function createCrmContactConfirm(InstructObj,baseJson,timeTag){  
	var icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_crm_wev8.png';				
	var htmlStr='<div class="confirm_div crmContact_confirm_div" ts="'+timeTag+'">'+
					'<div class="am-list-item lastLi">'+
						'<div class="am-list-line">'+
							 '<div class="am-list-content">'+
								'<span class="ul-li-div-img">'+
								 	'<img src="'+icon+'">'+
								'</span>'+
								'<div class="ul-li-div">'+
								   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+InstructObj.name+'</span></div>'+
								   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+InstructObj.desc+'</span></div>'+
								'</div>'+
							 '</div>'+
						'</div>'+
					'</div>'+
					'<div style="height: 150px;">'+
						'<div style="blog_content_parent">'+
							'<div class="blog_content_item">'+
								'<div class="blog_field blog_content crmContact_content">'+
									'<div class="blog_content_inner crmContact_title_str" contentEditable="true">'+InstructObj.content+'</div>'+
								'</div>'+
							'</div>'+
						'</div>'+
						'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
			 				 '<div class="Btn cancelBtn cancelCrmContact">取消</div>'+
			  				 '<div class="Btn OkBtn createCrmContact">确定</div>'+
						'</div>'+
					'</div>'+
			'</div>';
	return htmlStr;
}




//清除客户联系认框
function clearCrmContactConfirm(){
	if($('.crmContact_confirm_div')&&$('.crmContact_confirm_div').length>0){
		var ts=$('.crmContact_confirm_div').attr("ts");
		$("#anser"+ts).html('<div class="tips">客户联系已取消</div><div class="result"><div ts="'+ts+'" id="listview_1_'+ts+'"></div></div>');
		saveHistory();
	}
}
//异步追加客户联系
function addCrmContactAjax(InstructObj,baseJson,timeTag){
	ToastLoading("创建中...");
	//内容完整.直接新建.
	jQuery.ajax({
			type: "post",
		    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
		    data:{"type":"saveCrmContact","content":InstructObj.content,"crmId":InstructObj.id,"crmName":InstructObj.name,"date":InstructObj.date?InstructObj.date:""},
		    dataType: "json",  
		    success:function (data) {
		    	hideToast();
		    	if (data == undefined || data == null) {
		    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
		    		return;
		    	} else { 
		    		if(data.result=="1"){
		    			var str="已为您新建客户联系";
		    			play(str);
		    			$("#anser"+timeTag).html('<div class="tips">'+str+'：</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
					    $("#listview_1_"+timeTag).append(showCrmContactConfirm(InstructObj,data.createdate));	
		    			saveHistory(); 
		    		}else{
		    			ToastInfo("客户联系创建失败!",1);
		    		}
		    	}
		    }
	});
}

/*展示保存的客户联系*/
function showCrmContactConfirm(InstructObj,createdate){  
	var icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_crm_wev8.png';		
  							
	var htmlStr='<div class="am-list-item am-list-item-blog lastLi" onclick="goPage(\''+InstructObj.id+'\',\'CRM\',\'\')">'+
					'<div class="am-list-line">'+
						 '<div class="am-list-content">'+
							'<span class="ul-li-div-img">'+
							 	'<img src="'+icon+'">'+
							'</span>'+
							'<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+InstructObj.name+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+InstructObj.desc+'</span></div>'+
							'</div>'+
						 '</div>'+
					'</div>'+
				'</div>'+
				'<div style="am-list-item lastLi">'+
					'<div class="blog_content_show">'+
						'<div>'+InstructObj.content+'</div>'+
					'</div>'+
					'<div class="blog_footer"><div>'+createdate+'</div></div>'+
				'</div>'+
					 
			'</div>';
	return htmlStr;
}

/**
* 新建流程
*/
function showAddWf(item,isLast,func,v){
	var css=isLast=="1"?"lastLi":"";
	var htmlStr='<div class="am-list-item lastLi '+item.schema+'" onclick="'+func.name+'(\''+v+'\')">'+
					'<div class="ul-li-div-addwf">'+
					   '<img src="/mobile/plugin/fullsearch/img/'+pageStyle+'wf_add_wev8.png">'+
					   '<span>'+item.title+'</span>'
					'</div>'+
  				'</div>';
  	return htmlStr;
}

//显示特殊schema的item
function showSchemaAction(item,isLast,func,filedname,timeTag,others){
	//获取特殊值
	var other=item.other;
	
	var v="";
	var desc="";
	try{
		var otherJson=eval("("+other+")");
		v=otherJson[filedname];
	}catch(e){
		v=item[filedname];
	}
	
	var icon="";
	if(item.schema=="WFTYPE"){
		return showAddWf(item,isLast,func,v);
	}else if(item.schema=="RSC"){
		return showRSC(item,isLast);
	}else if(item.schema=="DOC"){
		icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_doc_wev8.png';
		desc=item.simpleDesc
		delete item.title;
		delete item.description;
	}
	
	var css=isLast=="1"?"lastLi":"";
	var htmlStr='<div class="am-list-item '+item.schema+' '+css+'" itemObj=\''+JSON.stringify(item)+'\' otherObj=\''+JSON.stringify(others)+'\' onclick="'+func.name+'(\''+v+'\',\''+timeTag+'\',{},this)">'+
					'<div class="am-list-line">'+
						 '<div class="am-list-content">'+
							'<span class="ul-li-div-img">'+
							 	'<img src="'+icon+'">'+
							'</span>'+
							'<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+item.simpleTitle+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+desc+'</span></div>'+
							'</div>'+
						 '</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
	
}



/*获取人员名字*/
function getRSCname(name){
   var reg = /[\u4E00-\u9FA5]/;
   if(reg.test(name)){
   		if(name.length>2){
  			name = name.substring(name.length-2,name.length);
  		}
   }else{
  		if(name.length>4){
  			name = name.substring(0,4);
  		}
   }
   return name;
}


//加载费用科目
function loadFeeType(timeTag,InstructObj,msg,jsonData){
	key="";
	if(jsonData&&jsonData.key){
		key=jsonData.key;
	}
	ToastLoading("加载中...");
	removeFeeTypeTap();
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"loadFeeType","bdf_wfid":InstructObj.workflowid,"bdf_fieldid":jsonData.bdf_fieldid,"q":key},
	    dataType: "json",  
	    success:function (data) {
	    	hideToast();
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
				if(data.result==1){
					var str="请选择费用科目，或者您可以继续说出科目关键字重新筛选。如需取消，请说“退出”";
					if(msg&&msg!=""){
						str=msg;
					}
					if(data.size==0){
						str="对不起，没有找到你要的科目类型，请重新说出科目关键字。如需取消，请说“退出”"
					}
					play(str);
					$("#anser"+timeTag).html("");
					if(data.size>0){
		    			var listSize=data.size;;
		    			var pagesize=5; 
				    	var page=Math.ceil(listSize/pagesize);
					    if(page>1){
					    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364;">';
					    	var pageHtml='<div class="otherInfo" style="padding-bottom: 10px;"><div class="morePage" style="width:'+15*page+'px">'
					    	for (var i=0;i<page;i++){
					    		if(i==0){
					    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
					    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
					    		}else{
					    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
					    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
					    		}
					    	}
					    	resultHtml+='</div>';
					    	pageHtml+='</div>';
					    	 
						    pageHtml+='</div>';
					    	$("#anser"+timeTag).append(resultHtml);
					    	$("#anser"+timeTag).append(pageHtml);
				    	}else{
				    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
				    	}

						$.each(data.list,function(j,item){
							var currentPage=Math.ceil((j+1)/pagesize);
							var isLast=(((j+1)%pagesize)==0||j==listSize-1)?"1":"0";
							$("#listview_"+currentPage+"_"+timeTag).append(showFeeType(item,isLast));
						});
	    			}else if(data.size==0){
	    				$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'"></div></div>');
	    			}
						
					//添加点击事件
					feeTypeTap();
					
					setTimeout(function(){
						$("#result"+timeTag ).height($('.result-current-ul').height());
						swipeList($("#result"+timeTag ));
						saveHistory();
					},200);
						
				}else{
					var str="对不起,费用科目查询异常";
					play(str);
					$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
					saveHistory(); 
				}
	    	}
	    	
	    }
    });
}

//显示费用科目选择
function showFeeType(item,isLast){
	var icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_fee_wev8.png';
	var css=isLast=="1"?"lastLi":"";
	var htmlStr='<div class="am-list-item feeType currentFeeType '+css+'" itemid="'+item.id+'" itemname="'+item.name+'">'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img">'+
							 	'<img src="'+icon+'">'+
							'</span>'+
							'<div class="ul-li-div" style="margin-top: 0px;margin-left: 75px;">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item.name+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item.fullName+'</span></div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}
//科目点击事件
function feeTypeTap(){
	$('.currentFeeType').off("tap");
	$('.currentFeeType').on("tap",function(){
		var itemid=$(this).attr("itemid");
		var itemname=$(this).attr("itemname");
		removeFeeTypeTap();
		var str="{'text':'"+itemname+"','rc':'0','service':'SelectFeeType','itemid':'"+itemid+"','CannotEdit':true}";
		voiceBackUnderstand(str);
	});
}
//移除科目费用点击击事件
function removeFeeTypeTap(){
	$('.currentFeeType').off("tap");
	$('.currentFeeType').removeClass("currentFeeType");
}


/*交互过程选择人员*/
function showRSCAction(item,isLast){
	var css=isLast=="1"?"lastLi":"";
	//获取特殊值
	var other=item.other;
	
	var icon='/messager/images/icon_m_wev8.jpg';
	var job="";
	var subcomp="";
	var dept="";
	var mobile="";
	var rscObj={};
	rscObj.id=item.id;
	rscObj.name=item.simpleTitle;
	try{
		var otherJson=eval("("+other+")");
		if(otherJson.URL==""){
			if(otherJson.SEX=="1"){
				icon='/messager/images/icon_w_wev8.jpg';
			}
		}else{
			icon=otherJson.URL;
		}
		
		subcomp=otherJson.SUBCOMP;
		job=otherJson.JOBTITLENAME;
		dept=otherJson.DEPT;
		rscObj.mobile=otherJson.MOBILE;
		rscObj.sex=otherJson.SEX;
		
	}catch(e){}
	
	var str={};
	str.rc="0";
	str.service="chooseRsc";
	str.id=item.id;
	str.text=item.simpleTitle;
	str.CannotEdit=true;
	
	var imgDiv="";
	if(icon.indexOf("icon_w_wev8.jpg")>-1||icon.indexOf("icon_m_wev8.jpg")>-1||icon.indexOf("dummyContact.png")>-1){
		imgDiv='<div class="imgDiv">'+getRSCname(item.simpleTitle)+'</div>';
	}
	
	var htmlStr='<div class="rscChooseDiv am-list-item '+item.schema+' '+css+'" deepObj=\''+JSON.stringify(str)+'\'>'+
					'<div class="am-list-line">'+
						'<div class="am-list-content">'+
							'<span class="ul-li-div-img">'+
							 	(imgDiv==""?'<img src="'+icon+'">':imgDiv)+
							'</span>'+
							'<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading">'+item.simpleTitle+'</span> <span class="ui-li-span">'+job+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span">'+subcomp+'</span><span class="ui-li-span">'+dept+'</span></div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}
 
/*人员选择点击*/
function rscChooseTap(){
	$('.rscChooseDiv').off("tap");
	$('.anserCurrent').find('.rscChooseDiv').on("tap",function(){
		deepUnderstand(this);
		$('.rscChooseDiv').off("tap");
	})
	
}

/*
* 多个人员列表时,选择人员直接做对应操作
*/
function showRSCCusAction(item,isLast,func,filedname,timeTag,others){
 	
	var css=isLast=="1"?"lastLi":"";
	//获取特殊值
	var other=item.other;
	
	var icon='/messager/images/icon_m_wev8.jpg';
	var job="";
	var subcomp="";
	var dept="";
	var mobile="";
	var rscObj={};
	rscObj.id=item.id;
	rscObj.name=item.simpleTitle;
	try{
		var otherJson=eval("("+other+")");
		if(otherJson.URL==""){
			if(otherJson.SEX=="1"){
				icon='/messager/images/icon_w_wev8.jpg';
			}
		}else{
			icon=otherJson.URL;
		}
		
		subcomp=otherJson.SUBCOMP;
		job=otherJson.JOBTITLENAME;
		dept=otherJson.DEPT;
		rscObj.mobile=otherJson.MOBILE;
		rscObj.sex=otherJson.SEX;
		
	}catch(e){}
	
	var str={};
	str.text=item.simpleTitle;
	str.rc="0";
	str.service="NativeAction";
	str.CannotEdit=true;
	str.action=func.name;
	str.id=item.id;
	str.name=item.simpleTitle;
	if(others.nextTs){
		str.nextTs=others.nextTs;
	}
	if(others.replaceText){
		str.replaceText=others.replaceText;
	}
	if(others.slots){
		str.slots=others.slots;
	}
	str.needAction=true;//需要执行action
	
	var imgDiv="";
	if(icon.indexOf("icon_w_wev8.jpg")>-1||icon.indexOf("icon_m_wev8.jpg")>-1||icon.indexOf("dummyContact.png")>-1){
		imgDiv='<div class="imgDiv">'+getRSCname(item.simpleTitle)+'</div>';
	}
	
	var htmlStr='<div class="am-list-item '+item.schema+' '+css+'" obj=\''+JSON.stringify(rscObj)+'\' deepObj=\''+JSON.stringify(str)+'\' onclick="deepUnderstand(this)">'+
					'<div class="am-list-line">'+
						'<div class="am-list-content">'+
							'<span class="ul-li-div-img">'+
							 	(imgDiv==""?'<img src="'+icon+'">':imgDiv)+
							'</span>'+
							'<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading">'+item.simpleTitle+'</span> <span class="ui-li-span">'+job+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span">'+subcomp+'</span><span class="ui-li-span">'+dept+'</span></div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}
//多个人员,深入点击处理
function deepUnderstand(obj){
	if($(obj).attr("deepObj")){
		//判断是否多次展示..
		var deepObj=JSON.parse($(obj).attr("deepObj"));
		if(deepObj.nextTs){
			textBackUnderstand($(obj).attr("deepObj"),deepObj.nextTs);
		}else{
			voiceBackUnderstand($(obj).attr("deepObj"));
		}
	}else{
		ToastInfo("点击失效",0.5);
	}
}
//各个schema的显示
function showSchema(item,isLast){
	var li="";
	if(item.schema=="RSC"){
		li=showRSC(item,isLast);
	}else if(item.schema=="DOC"){
		li=showOther(item,isLast,'/mobile/plugin/fullsearch/img/'+pageStyle+'v_doc_wev8.png');
	}else if(item.schema=="WF"){
		li=showWFItem(item,isLast,'/mobile/plugin/fullsearch/img/'+pageStyle+'v_wf_wev8.png');
	}else if(item.schema=="WKP"){
		li=showWKPItem(item,isLast,'/mobile/plugin/fullsearch/img/'+pageStyle+'v_wkp_wev8.png');
	}else if(item.schema=="CRM"){
		li=showCRMItem(item,isLast,'/mobile/plugin/fullsearch/img/'+pageStyle+'v_crm_wev8.png');
	}else if(item.schema=="EMAIL"){
		li=showOther(item,isLast,'/mobile/plugin/fullsearch/img/'+pageStyle+'v_faq_wev8.png');
	}else if(item.schema=="COW"){
		li=showOther(item,isLast,'/mobile/plugin/fullsearch/img/'+pageStyle+'v_faq_wev8.png');
	}else if(item.schema=="FAQ"){
		li=showOther(item,isLast,'/mobile/plugin/fullsearch/img/'+pageStyle+'v_faq_wev8.png');
	}else if(item.schema=="WFTYPE"){
		li=showSchemaAction(item,isLast,createWF,"ID");
	}else{
		li=showOther(item,isLast,'/mobile/plugin/fullsearch/img/'+pageStyle+'v_default_wev8.png');
	}
	return li;
}


/**
*人员展示
*/
function showRSC(item,isLast){
	var css=isLast=="1"?"lastLi":"";
	//获取特殊值
	var other=item.other;
	
	var icon='/messager/images/icon_m_wev8.jpg';
	var job="";
	var subcomp="";
	var dept="";
	var mobile="";
	var rscObj={};
	rscObj.id=item.id;
	rscObj.name=item.simpleTitle;
	try{
		var otherJson=eval("("+other+")");
		if(otherJson.URL==""){
			if(otherJson.SEX=="1"){
				icon='/messager/images/icon_w_wev8.jpg';
			}
		}else{
			icon=otherJson.URL;
		}
		
		subcomp=otherJson.SUBCOMP;
		job=otherJson.JOBTITLENAME;
		dept=otherJson.DEPT;
		rscObj.mobile=otherJson.MOBILE;
		rscObj.sex=otherJson.SEX;
		mobile=rscObj.mobile;
	}catch(e){}
	
	var imgDiv="";
	if(icon.indexOf("icon_w_wev8.jpg")>-1||icon.indexOf("icon_m_wev8.jpg")>-1||icon.indexOf("dummyContact.png")>-1){
		imgDiv='<div class="imgDiv">'+getRSCname(item.simpleTitle)+'</div>';
	}
	var sendMsg="";
	if(item.intenCacheExpress){
		sendMsg=item.intenCacheExpress;
	}
	//默认打开人员卡片
	var onclickStr='goPage(\''+item.id+'\',\''+item.schema+'\',\''+item.url+'\')'; 
	//人员 点击事件 处理...
	if(item.afterDoAction&&item.afterDoAction!=''){
		if(item.afterDoAction=='tel'){//电话
			if(mobile!=''){
				//onclickStr='callTel(\''+mobile+'\')';
			}
		}else if(item.afterDoAction=='sms'){//短信
			if(mobile!=''){
				//onclickStr='sendSms(\''+mobile+'\',\''+item.intenCacheExpress+'\')';
			}
		}else if(item.afterDoAction=='emsg'){
			//onclickStr='sendSimpleEmsg(\''+item.id+'\',\''+item.intenCacheExpress+'\')';
		}
	}
	var op="/mobile/plugin/fullsearch/img/"+pageStyle+"v_op_emsg.png";
	
	var op_ClickStr='sendSimpleEmsg(\''+item.id+'\',\''+sendMsg+'\')';
	
	var htmlStr='<div class="am-list-item '+item.schema+' '+css+'" obj=\''+JSON.stringify(rscObj)+'\'>'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img"  onclick="'+onclickStr+'">'+
							 	(imgDiv==""?'<img src="'+icon+'">':imgDiv)+
							'</span>'+
							'<div class="ul-li-div-rsc" onclick="'+onclickStr+'">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading">'+item.simpleTitle+'</span> <span class="ui-li-span">'+job+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span">'+subcomp+'</span><span class="ui-li-span">'+dept+'</span></div>'+
							'</div>'+
							'<span class="ul-li-div-op" onclick="'+op_ClickStr+'">'+
							 	'<img style="width: 20px;height: 18.3px;top: 14px; position: absolute;" src="'+op+'">'+
							'</span>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
  	
}

/**
*日程
*/
function showWKPItem(item,isLast,icon){
	var css=isLast=="1"?"lastLi":"";
	var begindate=nowDateStr;
	var begintime="";
	var createdate="";
	//获取特殊值
	var other=item.other;
	try{
		var otherJson=eval("("+other+")");
		begindate=otherJson.BEGINDATE;
		begintime=otherJson.BEINGTIME;
		createdate=otherJson.CREATEDATE;
	}catch(e){}
	if(begintime.length>5){
		begintime=begintime.substring(0,5);
	}
	//对日期分解
	var dates=begindate.split("-");
	var t_year=dates[0];
	var t_month=dates[1];
	var t_day=dates[2];
	var fontSize=18;
	if(begindate==nowDateStr){//今天
		t_year=t_month;
		t_month=t_day;
		t_day="今天";
		fontSize=16;
	}else if(begindate==yesterdayStr){
		t_year=t_month;
		t_month=t_day;
		t_day="昨天";
		fontSize=16;
	}else if(begindate==tomorrowStr){
		t_year=t_month;
		t_month=t_day;
		t_day="明天";
		fontSize=16;
	}
	
	
	var htmlStr='<div class="am-list-item '+item.schema+' '+css+'" onclick="goPage(\''+item.id+'\',\''+item.schema+'\',\''+item.url+'\')">'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img">'+
							 	'<div style="text-align: center;height: 46px;width: 46px;margin-top: 1px;">'+
							 		'<div class="wkp_calendar_title">'+t_year+'.'+t_month+'</div>'+
							 		'<div class="wkp_calendar_body" style="font-size: '+fontSize+'px;">'+t_day+'</div>'+
							 	'</div>'+
							'</span>'+
							'<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+begintime+'&nbsp;&nbsp;&nbsp;'+item.simpleTitle.trim()+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item.simpleDesc.replaceAll("&nbsp;","")+'&nbsp;&nbsp;&nbsp;建于&nbsp;&nbsp;'+createdate+'</span></div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}	


/**
*客户
*/
function showCRMItem(item,isLast,icon){
	var css=isLast=="1"?"lastLi":"";
	var begindate=nowDateStr;
	var begintime="";
	var createdate="";
	//获取特殊值
	var other=item.other;
	var desc=item.simpleDesc;
	
	try{
		var otherJson=eval("("+other+")");
		if(otherJson.DISTANCE){
			var distance=parseInt(otherJson.DISTANCE);
			desc+='<span class="crm_distance">距离'+(distance>=1000?((Math.round((distance/1000.0)*100)/100 )+'km'):(distance+'m'))+'</span>';
		}
	}catch(e){}

	var op="/mobile/plugin/fullsearch/img/"+pageStyle+"go_wev8.png";
	
	var str={};
	str.text="导航到"+item.simpleTitle.trim();
	str.rc="0";
	str.service="NativeAction";
	str.CannotEdit=true;
	str.action="load_address_ById";
	str.id=item.id;
	 
	str.needAction=true;//需要执行action
	
	var htmlStr='<div class="am-list-item '+item.schema+' '+css+'" >'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img" onclick="goPage(\''+item.id+'\',\''+item.schema+'\',\''+item.url+'\')">'+
							 	'<img src="'+icon+'">'+
							'</span>'+
							'<div class="ul-li-div-crm" onclick="goPage(\''+item.id+'\',\''+item.schema+'\',\''+item.url+'\')">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+item.simpleTitle.trim()+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+desc+'</span></div>'+
							'</div>'+
							'<span class="ul-li-div-op" deepObj=\''+JSON.stringify(str)+'\' onclick="deepUnderstand(this)">'+
							 	'<img style="width: 15px;height: 23px;" src="'+op+'">'+
							 	'<p style="margin: 5px 0 0 0;">到这去</p>'+
							'</span>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}								

/**
*流程
*/
function showWFItem(item,isLast,icon){
	var css=isLast=="1"?"lastLi":"";
	var htmlStr='<div class="am-list-item '+item.schema+' '+css+'" onclick="'+((item.isnew&&item.isnew=="1")?"removeReadTag(this);":"")+'goPage(\''+item.id+'\',\''+item.schema+'\',\''+item.url+'\')">'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img">'+
							 	'<img src="'+icon+'">'+
							'</span>';
					if(item.isnew&&item.isnew=="1"){
						htmlStr+='<span class="unReadTag" style="float: left;position: absolute;left: 46px;">'+
						 			'<img src="/mobile/plugin/fullsearch/img/v_unread_wev8.png"  style="width:10px;height:10px;">'+
								 '</span>';
					}
					htmlStr+='<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+item.simpleTitle+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item.simpleDesc+'</span></div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}

//移除未读标识
function removeReadTag(obj){
	$(obj).find(".unReadTag").remove();
}
								
/**
*其他
*/
function showOther(item,isLast,icon){
	var css=isLast=="1"?"lastLi":"";
	var htmlStr='<div class="am-list-item '+item.schema+' '+css+'" onclick="goPage(\''+item.id+'\',\''+item.schema+'\',\''+item.url+'\')">'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img">'+
							 	'<img src="'+icon+'">'+
							'</span>'+
							'<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+item.simpleTitle+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item.simpleDesc+'</span></div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}

/**
客户导航
*/
function showCRMAddress(item){
	var address1="";
	var address2="";
	var address3="";
	try{
		var otherJson=eval("("+item.other+")");
		address1=otherJson.ADDRESS1;
		address2=otherJson.ADDRESS2;
		address3=otherJson.ADDRESS3;
		
	}catch(e){}
	
	var addressCount=0;
	if(address1!=""){
		addressCount++;
	}
	if(address2!=""){
		addressCount++;
	}
	if(address3!=""){
		addressCount++;
	}
	var htmlStr='<div class="crm_Location CRM">'+
					'<div class="am-list-line">'+
						'<div>'+
							'<div class="crm_title">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+item.simpleTitle+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item.simpleDesc+'</span></div>'+
							'</div>'+
						'</div>'+
					 	'<div>';
						if(address1==""&&address1==""&&address1==""){
							htmlStr+='<div class="crm_address">无有效地址</div>';
						}else{
							if(address1!=""){
								addressCount--;
								htmlStr+='<div class="crm_address" onclick="findPlace(this)" address="'+address1+'">'+
											   '<div class="crm_address_child '+ (addressCount==0?'lastLi':'')+'"><span class="ui-li-span ui-li-span-heading ui-li-span80"><img style="width:20px;vertical-align: middle;" src="/mobile/plugin/fullsearch/img/'+pageStyle+'location_wev8.png"/>&nbsp;&nbsp;'+address1+'</span></div>'+
										 '</div>';
							}
							if(address2!=""){
								addressCount--;
								htmlStr+='<div class="crm_address" onclick="findPlace(this)" address="'+address2+'">'+
											   '<div class="crm_address_child '+ (addressCount==0?'lastLi':'')+'"><span class="ui-li-span ui-li-span-heading ui-li-span80"><img style="width:20px;vertical-align: middle;" src="/mobile/plugin/fullsearch/img/'+pageStyle+'location_wev8.png"/>&nbsp;&nbsp;'+address2+'</span></div>'+
										 '</div>';
							}
							if(address3!=""){
								addressCount--;
								htmlStr+='<div class="crm_address" onclick="findPlace(this)" address="'+address3+'">'+
											   '<div class="crm_address_child '+ (addressCount==0?'lastLi':'')+'"><span class="ui-li-span ui-li-span-heading ui-li-span80"><img style="width:20px;vertical-align: middle;" src="/mobile/plugin/fullsearch/img/'+pageStyle+'location_wev8.png"/>&nbsp;&nbsp;'+address3+'</span></div>'+
										 '</div>';
							}
						}
				htmlStr+='</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}

/**
客户地址展示,不需要点击
*/
function showCRMAddressNoClick(item){
	var address1="";
	var address2="";
	var address3="";
	try{
		var otherJson=eval("("+item.other+")");
		address1=otherJson.ADDRESS1;
		address2=otherJson.ADDRESS2;
		address3=otherJson.ADDRESS3;
		
	}catch(e){}
	
	var addressCount=0;
	if(address1!=""){
		addressCount++;
	}
	if(address2!=""){
		addressCount++;
	}
	if(address3!=""){
		addressCount++;
	}
	var htmlStr='<div class="crm_Location CRM">'+
					'<div class="am-list-line">'+
						'<div>'+
							'<div class="crm_title">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+item.simpleTitle+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item.simpleDesc+'</span></div>'+
							'</div>'+
						'</div>'+
					 	'<div>';
						if(address1==""&&address1==""&&address1==""){
							htmlStr+='<div class="crm_address">无有效地址</div>';
						}else{
							if(address1!=""){
								addressCount--;
								htmlStr+='<div>'+
											   '<div class="crm_address_child '+ (addressCount==0?'lastLi':'')+'" style="height: 30px;line-height: 30px;"><span class="ui-li-span ui-li-span80"><img style="width:20px;vertical-align: middle;" src="/mobile/plugin/fullsearch/img/'+pageStyle+'location_wev8.png"/>&nbsp;&nbsp;'+address1+'</span></div>'+
										 '</div>';
							}
							if(address2!=""){
								addressCount--;
								htmlStr+='<div>'+
											   '<div class="crm_address_child '+ (addressCount==0?'lastLi':'')+'" style="height: 30px;line-height: 30px;"><span class="ui-li-span ui-li-span80"><img style="width:20px;vertical-align: middle;" src="/mobile/plugin/fullsearch/img/'+pageStyle+'location_wev8.png"/>&nbsp;&nbsp;'+address2+'</span></div>'+
										 '</div>';
							}
							if(address3!=""){
								addressCount--;
								htmlStr+='<div>'+
											   '<div class="crm_address_child '+ (addressCount==0?'lastLi':'')+'" style="height: 30px;line-height: 30px;"><span class="ui-li-span ui-li-span80"><img style="width:20px;vertical-align: middle;" src="/mobile/plugin/fullsearch/img/'+pageStyle+'location_wev8.png"/>&nbsp;&nbsp;'+address3+'</span></div>'+
										 '</div>';
							}
						}
				htmlStr+='</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}
//显示导航目的地
function load_address_list(address,timeTag,others){
	if(address==""){
		hideToast();
		play("地址不能为空");
		ToastInfo("地址不能为空",1);
		return;
	}
	ToastLoading("加载中...");
	if(address!=""){
		var currentCity="";
		if($('#hideLocation').attr("currentLocation")){
			var currentLocation=JSON.parse($('#hideLocation').attr("currentLocation"));
			if(currentLocation&&currentLocation.city){
				currentCity=currentLocation.city;
			}
		}
		jQuery.ajax({
			type: "post",
		    url: "/mobile/plugin/fullsearch/locationUtil.jsp",
		    data:{"type":"getPlaceList","address":address,"currentCity":currentCity},
		    dataType: "json",  
		    success:function (data) {
		    	hideToast();
		    	if(data.count=="0"){
		    		var str="对不起,没有找到"+address+"的地址";
		    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
		    		play(str);
		    		return;
		    	}
		    	play("请选择导航目的地");
		    	var size=data.list.length;
				if(size==0){
					$("#anser"+timeTag).append('<div class="tips">请选择导航目的地:</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
					 
					$("#listview_1_"+timeTag).append(showAddressList(address));
				}
				if(size>0){
					$("#anser"+timeTag).append('<div class="tips">请选择导航目的地:</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
					try{
						$.each(data.list,function(j,item){
							var isLast=(j==size-1)?"1":"0";
							$("#listview_1_"+timeTag).append(showAddressList(item,isLast));
						});
						
						saveHistory();
					}catch(e){}
				}
		    	saveHistory();
		    }
    	});	
	}
}
	
//只显示地址,无效,不使用
function showAddressOnly(address){
	var htmlStr='<div class="crm_Location CRM">'+
					'<div class="am-list-line">'+
					 	'<div>'+
						 	'<div class="crm_address" onclick="findPlace(this)" address="'+address+'">'+
								   '<div class="crm_address_child lastLi"><span class="ui-li-span ui-li-span-heading ui-li-span80"><img style="width:20px;vertical-align: middle;" src="/mobile/plugin/fullsearch/img/location_wev8.png"/>&nbsp;&nbsp;'+address+'</span></div>'+
							 '</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}
//显示地址列表
function showAddressList(item,isLast){
	var css=isLast=="1"?"lastLi":"";
	var htmlStr='<div class="am-list-item '+css+'" onclick="navigation(this)" obj=\''+JSON.stringify(item)+'\'>'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img">'+
							 	'<img src="/mobile/plugin/fullsearch/img/'+pageStyle+'v_location_wev8.png">'+
							'</span>'+
							'<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+item.name+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item.address+'</span></div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr
}		

//微博展示
function showBlog(rsc,discessList,showsize){
	var icon='/messager/images/icon_m_wev8.jpg';
	if(rsc.imageUrl==""){
		if(rsc.sex=="1"){
			icon='/messager/images/icon_w_wev8.jpg';
		}
	}else{
		icon=rsc.imageUrl;
	}
	var imgDiv="";
	if(icon.indexOf("icon_w_wev8.jpg")>-1||icon.indexOf("icon_m_wev8.jpg")>-1||icon.indexOf("dummyContact.png")>-1){
		imgDiv='<div class="imgDiv">'+getRSCname(rsc.username)+'</div>';
	}
	var rscStr='<div class="am-list-item am-list-item-blog RSC lastLi">'+
					'<div class="am-list-line" style="padding: 8px 5px 8px 0px;">'+
						'<div class="am-list-content">'+
							'<span class="ul-li-div-img">'+
							 	(imgDiv==""?'<img src="'+icon+'">':imgDiv)+
							'</span>'+
							'<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading">'+rsc.username+'</span> <span class="ui-li-span">'+rsc.jobtitle+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span">'+rsc.subName+'</span><span class="ui-li-span">'+rsc.deptName+'</span></div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	
  	var blogStr='<div class="blog_content_list">';
  	for(var i = 0;i < discessList.length && i<showsize; i++) {
  		var item=discessList[i];
  		var css=(i==discessList.length-1||i==showsize-1)?"lastLi":"";
  		var weekday="";
		var workdate=item.workdate;
		var tempdate=new Date(workdate.replace(/-/g,"/"));
		if(workdate==nowDateStr)
		   weekday="今天";
		else   
		   weekday=week[tempdate.getDay()];
	  	
		blogStr+='<div class="blog_content_list_item '+css+'">'+
					'<div class="blog_content_show">';
		
		if(item.id==""){
			blogStr+='<div class="blog_nosubmit"><img src="/mobile/plugin/fullsearch/img/'+pageStyle+'nosubmit_wev8.png" style="width:20px;float:left;margin-right:10px"><div>未提交微博</div></div>';
		}else{
			blogStr+='<div>'+item.contents.htmlstr+'</div>';
		}			
						
		blogStr+='</div>'+
					'<div class="blog_footer">'+
						'<div>'+workdate+'&nbsp;&nbsp;&nbsp;&nbsp;'+weekday+'</div>'+
					'</div>'+
				 '</div>';
  	}
  	blogStr+="</div>";			
    
  	return rscStr+blogStr;
}
//展示时间段内空闲的人员. 人员传入,或者通过微搜查询.
function showFreeRscByWKP(InstructObj,otherJson,timeTag){
	ToastLoading("加载中...");
	var hrmid="";
	if(InstructObj.hrmid){
		hrmid=InstructObj.hrmid;
	}
	if(InstructObj.key){
		jQuery.ajax({
			async: false, 
			type : "POST", 
			url: "/mobile/plugin/fullsearch/searchList.jsp?contentType=RSC:2&pagesize=20&pageindex=1&voice=1&keyword="+InstructObj.key,
	   		data:{},
			dataType : 'json', 
			success : function(data) {
				hrmid="";
				$.each(data.list,function(j,item){
					hrmid+=((hrmid==""?"":",")+item.id);
				}); 
			}
		});
	}
	if(hrmid!=""){
		jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"FreeWorkplanRSC","hrmids":hrmid,"begindate":InstructObj.begindate,"begintime":InstructObj.begintime,"enddate":InstructObj.enddate,"endtime":InstructObj.endtime},
	    dataType: "json",  
	    success:function (data) {
	    	hideToast();
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		if(data.list){
	    			var size=data.list.length;
	    			var listSize=size;
	    			
	    			if(size==0){
	    				var str="没有空闲专家";
						play(str);
						$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
						$('.currentInstructTip').removeClass("currentInstructTip");
						saveHistory();
						return;
					}
	    			var str="为您找到"+size+"个空闲专家,点击可预约";
					play(str); 
			    	var page=Math.ceil(listSize/5);
				    if(page>1){
				    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364;">';
				    	var pageHtml='<div class="otherInfo"><div class="morePage" style="width:'+15*page+'px">'
				    	for (var i=0;i<page;i++){
				    		if(i==0){
				    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
				    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
				    		}else{
				    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
				    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
				    		}
				    	}
				    	resultHtml+='</div>';
				    	pageHtml+='</div>';
				    	 
					    pageHtml+='</div>';
				    	$("#anser"+timeTag).append(resultHtml);
				    	$("#anser"+timeTag).append(pageHtml);
			    	}else{
			    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			    	}
				    
				   
					$.each(data.list,function(j,item){
						var currentPage=Math.ceil((j+1)/5);
						var isLast=(((j+1)%5)==0||j==listSize-1)?"1":"0";
						$("#listview_"+currentPage+"_"+timeTag).append(showRSCAction(item,isLast));
					});
					
					setTimeout(function(){
						$("#result"+timeTag ).height($('.result-current-ul').height());
						
						swipeList($("#result"+timeTag ));
						
						saveHistory();
					},200);
					
					//添加点击事件
					rscChooseTap();
	    		}
	    	}
	    }
    });
	}else{
		hideToast();
		var str="对不起,没有找到人员";
		play(str);
		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
		setTimeout(function(){
			$('.currentInstructTip').removeClass("currentInstructTip");
			saveHistory();
		},500)
		saveHistory();
	}

}

//检查日程冲突.
function checkHrmFree(InstructObj,otherJson,timeTag){
	jQuery.ajax({
		type : "POST", 
		url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
   		data:{"type":"checkHrmFree","begindate":InstructObj.sDate,"begintime":InstructObj.sTime,"enddate":InstructObj.eDate,"endtime":InstructObj.eTime,"who":InstructObj.who},
		dataType : 'json', 
		success : function(data) {
		  	if(data.result=="1"){
		  		InstructObj.rscId=data.rscId;
		  		//所有人员都有时间.
		  		if(data.count==0){
		  			addCalendarAjax(InstructObj.rscId,"",InstructObj.content,InstructObj.sDate,InstructObj.sTime,InstructObj.eDate,InstructObj.eTime,timeTag);
		  		}else{
		  			var str="好的，有"+data.count+"位同事有日程冲突，是否继续安排？";
		  			play(str);
					$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
								
					//增加按钮
					var btnHtml='<div class="" style="width: 310px;margin: auto;line-height: 30px;height: 50px;margin-top: 10px">'+
					 				 '<div class="Btn cancelBtn MeetingBtn cancelWKP">取消</div>'+
					  				 '<div class="Btn OkBtn MeetingBtn createWKP">继续安排</div>'+
					  				 '<div class="Btn OkBtn MeetingBtn searchFreeTime" style="width:120px">查看空闲时间</div>'+
								'</div>';
					$("#listview_1_"+timeTag).append(btnHtml);	
					
					//注册 btn事件
					$("#listview_1_"+timeTag).find('.cancelWKP').off("tap").on("tap",function(){
						play("安排日程已取消");
						$('.currentInstructTip').removeClass("currentInstructTip");
						$("#anser"+timeTag).html('<div class="tips">安排日程已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
						saveHistory();
					});
					
					$("#listview_1_"+timeTag).find('.createWKP').off("tap").on("tap",function(){
						addCalendarAjax(InstructObj.rscId,"",InstructObj.content,InstructObj.sDate,InstructObj.sTime,InstructObj.eDate,InstructObj.eTime,timeTag);
					});
					
					$("#listview_1_"+timeTag).find('.searchFreeTime').off("tap").on("tap",function(){
						 $("#anser"+timeTag).html('');
						 ToastLoading("加载中...");
						 jQuery.ajax({
							type : "POST", 
							url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
					   		data:{"type":"getHrmFreeTime","date":InstructObj.sDate,"hrmids":InstructObj.rscId},
							dataType : 'json', 
							success : function(data) {
							  	if(data.result=="1"){
							  		var listSize=data.list.length;
							  		 if(listSize>0){
							  		 	//展示空闲时间段
							  		 	play("为您找到其他时间段，请重新说出时间段");
										$("#anser"+timeTag).html('<div class="tips">为您找到其他时间段，请重新说出时间段：</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
										
										var htmlStr="<div class='reportItemDiv' style='line-height:35px;'>";
										
										$.each(data.list,function(j,item){
											var tempDs=item.beginDate.split("-");
											var tempDate = new Date(tempDs[0], parseInt(tempDs[1])-1, tempDs[2]); 
											var isLastLi=(j==listSize-1)?"lastLi":"";
											htmlStr+="<div class='lineBottom "+isLastLi+"'>";
											htmlStr+="<div class='labelName reportLabelName' style='width:100%'>"+item.beginDate+"&nbsp;&nbsp;"+weekStr(tempDate.getDay()+"")+"&nbsp;&nbsp;"+item.beginTime+" ~ "+item.endTime  +"</div></div>";
										});
										htmlStr+="</div>";
										$("#listview_1_"+timeTag).append(htmlStr);
										//构建交互指令
										
										var newInstructObj={};
										newInstructObj.type="WKP";
										newInstructObj.content=InstructObj.content;
										newInstructObj.id=InstructObj.rscId;
										newInstructObj.name="";
										
										$('#instructTip'+timeTag).append('<div id="instructTipObj'+timeTag+'" class="instructTip instructTipObj currentInstructTip" target="'+timeTag+'" obj=\''+JSON.stringify(newInstructObj)+'\' baseJson=\''+JSON.stringify(otherJson)+'\' style="display:none"></div>');
										saveHistory();
							  		 	
							  		 }else{
							  		 	play("对不起,没有找到大家都空闲的时间段");
										$("#anser"+timeTag).html('<div class="tips">对不起,没有找到大家都空闲的时间段</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
										saveHistory();
							  		 }
							  	}else{
							  		 ToastInfo("查询参数异常");
							  	}
							}
						});
						 
						 
						
					});
					saveHistory();
					 
		  		}
		  	}else{
		  		var str="对不起,没有找到人员";
		  		play(str);
		  		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
		  	}
		}
	});
}

//查询日程
function showWKP(id,timeTag,otherJson){
	ToastLoading("加载中...");
  	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"workplan","hrmId":id,"date":otherJson.date,"type_n":otherJson.type_n,"sDate":otherJson.sDate,"eDate":otherJson.eDate,"maybe":otherJson.maybe?otherJson.maybe:""},
	    dataType: "json",  
	    success:function (data) {
	    	var name=otherJson.name;
	    	hideToast();
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		if(data.list){
	    			var size=data.list.length;
	    			var listSize=size;
	    			
	    			if(size==0){
	    				var str="您没有日程安排";
		    			if(name!=""){
		    				str=name+"没有日程安排";
		    			}
						play(str);
						$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
						
						var who="您";
		    			if(name!=""){
		    				who=name;
		    			}
						//显示其他内容.
						if(otherJson.maybe&&otherJson.maybe!=""&&data.showMaybeStr&&data.showMaybeStr!=""){
							
							var objstr={};
							objstr.text="点击查看";
							objstr.rc="0";
							objstr.service="NativeAction";
							objstr.CannotEdit=true;
							objstr.id=id;
							objstr.name=who;
							objstr.needAction=true;//需要执行action
							if(otherJson.maybe=="todolist"){
								objstr.action="showWFTodoList";
								objstr.text="查看待办";
							}
							
							$("#anser"+timeTag).append(showMaybeInfo(data.showMaybeStr,objstr));
						}
					
						return;
					}
	    			var str="";
	    			var who="您";
	    			if(name!=""){
	    				who=name;
	    			}
	    			if(data.count>size){
	    				str="为您找到"+who+"的"+data.count+"条日程,以下是前"+size+"个";
	    			}else{
	    				str="为您找到"+who+"的"+size+"条日程";
	    			}
					play(str); 
			    	var page=Math.ceil(listSize/5);
				    if(page>1){
				    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364;">';
				    	var pageHtml='<div class="otherInfo"><div class="morePage" style="width:'+15*page+'px">'
				    	for (var i=0;i<page;i++){
				    		if(i==0){
				    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
				    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
				    		}else{
				    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
				    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
				    		}
				    	}
				    	resultHtml+='</div>';
				    	pageHtml+='</div>';
				    	 
					    pageHtml+='</div>';
				    	$("#anser"+timeTag).append(resultHtml);
				    	$("#anser"+timeTag).append(pageHtml);
			    	}else{
			    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			    	}
				    
				   
					$.each(data.list,function(j,item){
						var currentPage=Math.ceil((j+1)/5);
						var isLast=(((j+1)%5)==0||j==listSize-1)?"1":"0";
						$("#listview_"+currentPage+"_"+timeTag).append(showSchema(item,isLast));
					});
					
					//显示其他内容.
					if(otherJson.maybe&&otherJson.maybe!=""&&data.showMaybeStr&&data.showMaybeStr!=""){
						
						var objstr={};
						objstr.text="点击查看";
						objstr.rc="0";
						objstr.service="NativeAction";
						objstr.CannotEdit=true;
						objstr.id=id;
						objstr.name=who;
						objstr.needAction=true;//需要执行action
						if(otherJson.maybe=="todolist"){
							objstr.action="showWFTodoList";
							objstr.text="查看待办";
						}
						
						$("#anser"+timeTag).append(showMaybeInfo(data.showMaybeStr,objstr));
					}
					
					setTimeout(function(){
						$("#result"+timeTag ).height($('.result-current-ul').height());
						
						swipeList($("#result"+timeTag ));
						
						saveHistory();
					},200);
	    		}
	    	}
	    }
    });
}
//可能操作的展示与点击
function showMaybeInfo(str,objstr){
	return 	'<div class="bodycolor" style="height: 5px;"></div>'+
			'<div class="result" style="padding-top: 5px;">'+
  				'<div class="am-list-item lastLi" deepObj=\''+JSON.stringify(objstr)+'\' onclick="deepUnderstand(this)">'+
		  			'<div class="am-list-line">'+
		  				'<div style="width: 100%;text-align: left;margin-left:10px">'+
		  					'<span class="ui-li-span ui-li-span-heading ui-li-span80">'+str+'</span>'+
		  				'</div>'+
		  			'</div>'+
		  		'</div>'+
			'</div>';
}

//可能操作的展示与点击,第二种显示方式,有add(+)符号
function showMaybeInfo2(str,str2,objstr){
	return 	'<div class="bodycolor" style="height: 5px;"></div>'+
			'<div class="result bodycolor" style="padding-top: 12px;text-align: center;">'+
  				'<div>'+str+'</div>'+
		  		'<div class="rectangle dotRectangle" style="font-size: 14px;padding: 5px;margin-top:12px;height: 30px;line-height: 30px;" deepObj=\''+JSON.stringify(objstr)+'\' onclick="deepUnderstand(this)">'+
		  			'<div><img style="width:18px;position:absolute;margin-top:5px;" src="/mobile/plugin/fullsearch/img/'+pageStyle+'v_add.png">&nbsp;&nbsp;<div class="wordcolor" style="display: inline-block;margin-left: 21px;">'+str2+'</div></div>'+
		  		'</div>'+
			'</div>';
}

//人员 下级
function showSubordinate(id,timeTag,otherJson){
	ToastLoading("加载中...");
  	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"subordinate","hrmId":id},
	    dataType: "json",  
	    success:function (data) {
	    	var name=otherJson.name;
	    	hideToast();
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		if(data.list){
	    			var size=data.list.length;
	    			var listSize=size;
	    			
	    			if(size==0){
	    				var str="您没有下属";
		    			if(name!=""){
		    				str=name+"没有下属";
		    			}
						play(str);
						$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
						return;
					}
	    			var str="";
	    			var who="您";
	    			if(name!=""){
	    				who=name;
	    			}
	    			if(data.count>size){
	    				str="为您找到"+who+"的"+data.count+"个下属,以下是前"+size+"个";
	    			}else{
	    				str="为您找到"+who+"的"+size+"个下属";
	    			}
					play(str); 
			    	var page=Math.ceil(listSize/5);
				    if(page>1){
				    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364;">';
				    	var pageHtml='<div class="otherInfo"><div class="morePage" style="width:'+15*page+'px">'
				    	for (var i=0;i<page;i++){
				    		if(i==0){
				    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
				    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
				    		}else{
				    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
				    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
				    		}
				    	}
				    	resultHtml+='</div>';
				    	pageHtml+='</div>';
				    	 
					    pageHtml+='</div>';
				    	$("#anser"+timeTag).append(resultHtml);
				    	$("#anser"+timeTag).append(pageHtml);
			    	}else{
			    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			    	}
				    
				   
					$.each(data.list,function(j,item){
						var currentPage=Math.ceil((j+1)/5);
						var isLast=(((j+1)%5)==0||j==listSize-1)?"1":"0";
						$("#listview_"+currentPage+"_"+timeTag).append(showSchema(item,isLast));
					});
					
					setTimeout(function(){
						$("#result"+timeTag ).height($('.result-current-ul').height());
						
						swipeList($("#result"+timeTag ));
						
						saveHistory();
					},200);
	    		}
	    	}
	    }
    });
	
}

//查询下级,只有一条数据直接操作,多条数据点击后进一步操作
function deepSubordinate(id,timeTag,otherJson,func){
	ToastLoading("加载中...");
  	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"subordinate","hrmId":id},
	    dataType: "json",  
	    success:function (data) {
	    	var name=otherJson.name;
	    	hideToast();
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		if(data.list){
	    			var size=data.list.length;
	    			var listSize=size;
	    			
	    			if(size==0){
	    				var str="您没有下属";
		    			if(name!=""){
		    				str=name+"没有下属";
		    			}
						play(str);
						$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
						return;
					}else if(size==1){
						try{
							$.each(data.list,function(j,item){
								otherJson.name=item.simpleTitle;
								CustomFunction(eval(func),item.id,timeTag,otherJson);
								return;
							});
						}catch(e){
							ToastInfo("CustomFunction 执行异常",1);
						}
						return; 
					}
	    			var str="";
	    			var who="您";
	    			if(name!=""){
	    				who=name;
	    			}
	    			if(data.count>size){
	    				str="为您找到"+who+"的"+data.count+"个下属,以下是前"+size+"个，请选择";
	    			}else{
	    				str="为您找到"+who+"的"+size+"个下属，请选择";
	    			}
					play(str); 
			    	var page=Math.ceil(listSize/5);
				    if(page>1){
				    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364;">';
				    	var pageHtml='<div class="otherInfo"><div class="morePage" style="width:'+15*page+'px">'
				    	for (var i=0;i<page;i++){
				    		if(i==0){
				    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
				    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
				    		}else{
				    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
				    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
				    		}
				    	}
				    	resultHtml+='</div>';
				    	pageHtml+='</div>';
				    	 
					    pageHtml+='</div>';
				    	$("#anser"+timeTag).append(resultHtml);
				    	$("#anser"+timeTag).append(pageHtml);
			    	}else{
			    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			    	}
				    
				   
					$.each(data.list,function(j,item){
						var currentPage=Math.ceil((j+1)/5);
						var isLast=(((j+1)%5)==0||j==listSize-1)?"1":"0";
						$("#listview_"+currentPage+"_"+timeTag).append(showRSCCusAction(item,isLast,func,"ID",timeTag,otherJson));
						
					});
					
					$("#result"+timeTag ).height($('.result-current-ul').height());
					
					setTimeout(function(){
						$("#result"+timeTag ).height($('.result-current-ul').height());
						swipeList($("#result"+timeTag ));
						saveHistory();
					},200);
	    		}
	    	}
	    }
    });
	
}

//人员 上级 
function showSuperior(id,timeTag,otherJson){
    jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"superior","hrmId":id},
	    dataType: "json",  
	    success:function (data) {
	    	var name=otherJson.name;
	    	hideToast();
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		if(data.list){
	    			var size=data.list.length;
	    			var listSize=size;
	    			if(size==0){
	    				var str="您没有上级"
	    				if(name!=""){
	    					str=name+"没有上级";
	    				}
	    				play(str);
						$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
						return;
					}
	    			var str="您的上级";
	    			if(name!=""){
	    				str=name+"的上级"
	    			}
					play(str); 
			    	 
			    	$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
				   
					$.each(data.list,function(j,item){
						$("#listview_1_"+timeTag).append(showSchema(item,1));
					});
					
					setTimeout(function(){
						$("#result"+timeTag ).height($('.result-current-ul').height());
						
						swipeList($("#result"+timeTag ));
						
						saveHistory();
					},200);
	    		}
	    	}
	    }
    });
	
}

/*
* 查询待办
*/
function showWFTodoList(id,timeTag,otherJson){
	ToastLoading("加载中...");
	//如果有content,通过微搜查找类型. 多个值通过 in ()的方式集成
	var workflowid="";
	if(otherJson.content&&otherJson.content!=""){
		jQuery.ajax({
			type : "POST", 
			url: "/mobile/plugin/fullsearch/ajaxVoice.jsp?type=getWorkflowTypeId",
	   		data:{"keyword":otherJson.content},
			dataType : 'json', 
			success : function(data) {
				if(data.wfids&&data.wfids!=""){
					//展示流程类型
					var listSize=data.list.length;
					if(listSize==0){//近期没有数据,显示全部
						showWFTodoListById(id,timeTag,otherJson,data.wfids);
					}else if(listSize==1){//1条数据直接展示
						var t_id="";
						$.each(data.list,function(j,item){
							t_id=item.id;
							otherJson.content=item.name;
						})
						showWFTodoListById(id,timeTag,otherJson,t_id);
					}else{
	    				var str="为您找到"+listSize+"个"+otherJson.content+"相关的流程类型,请确认是哪个";
						play(str); 
				    	var page=Math.ceil(listSize/5);
					    if(page>1){
					    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364px;">';
					    	var pageHtml='<div class="otherInfo"><div class="morePage" style="width:'+15*page+'px">'
					    	for (var i=0;i<page;i++){
					    		if(i==0){
					    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
					    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
					    		}else{
					    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
					    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
					    		}
					    	}
					    	resultHtml+='</div>';
					    	pageHtml+='</div>';
					    	 
						    pageHtml+='<div id="doAction'+timeTag+'" class="rectangle rounded  doAction currentDoAction"></div></div>';
					    	$("#anser"+timeTag).append(resultHtml);
					    	$("#anser"+timeTag).append(pageHtml);
				    	}else{
					    	$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div><div class="otherInfo" id="otherInfo'+timeTag+'"><div id="doAction'+timeTag+'" class="rectangle rounded  doAction currentDoAction"></div></div>');
				    	}
					   	var nextTs=new Date().getTime();
					   	
						$.each(data.list,function(j,item){
							var currentPage=Math.ceil((j+1)/5);
							var isLast=(((j+1)%5)==0||j==listSize-1)?"lastLi":"";
							
							var str={};
							str.text=item.name;
							str.rc="0";
							str.service="NativeAction";
							str.CannotEdit=true;
							str.action="showWFTodoListById";
							str.id=item.id;
							str.nextTs=nextTs;
							str.replaceText=true;
							str.needAction=true;//需要执行action
							str.otherJson=otherJson;
							str.hrmId=id;
							
							var htmlStr='<div class="am-list-item '+isLast+'" deepObj=\''+JSON.stringify(str)+'\' onclick="deepUnderstand(this)">'+
											'<div class="am-list-line">'+
												'<div>'+
													'<span class="ul-li-div-img">'+
													 	'<img src="/mobile/plugin/fullsearch/img/'+pageStyle+'v_wf_wev8.png">'+
													'</span>'+
													'<div class="ul-li-div">'+
													   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80" style="margin-top:10px;">'+item.name+'</span></div>'+
													   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80"></span></div>'+
													'</div>'+
												'</div>'+
											'</div>'+
						  				'</div>';
							
							$("#listview_"+currentPage+"_"+timeTag).append(htmlStr);
						});
						
						
						$("#doAction"+timeTag).html("查看所有匹配类型待办");
	   		 			//增加点击事件. 只能点击一次.
	   		 			$("#doAction"+timeTag).off("tap").on("tap",function(){
	   		 				//清空当前内容
	   		 				$("#ask"+nextTs).remove();
	   		 				$("#instructTip"+nextTs).remove();
	   		 				$("#anser"+nextTs).remove();
	   		 				$("#split"+nextTs).remove();
	   		 				
	   		 				$("#anser"+timeTag).html("");
	   		 				$("#ask"+timeTag).addClass("askCurrent");
	   		 				$("#anser"+timeTag).addClass("anserCurrent");
	   		 				$("#split"+timeTag).addClass("splitCurrent");
	   		 				editAsk();
	   		 				showWFTodoListById(id,timeTag,otherJson,data.wfids);
	   		 				saveHistory();
	   		 			});    		 		
						
						
						setTimeout(function(){
							$("#result"+timeTag ).height($('.result-current-ul').height());
							
							swipeList($("#result"+timeTag ));
							
							saveHistory();
						},200);
					
					}
				}else{
					var str="对不起,没有找到"+otherJson.content+"相关流程类型";
					play(str);
					$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
					saveHistory();
				}
			}
		});
	}else{
		//没有内容. 直接查询所有待办
		showWFTodoListById(id,timeTag,otherJson,"");
	}
}
//通过workflowid 查找待办.workflowid为空 查询所有待办
function showWFTodoListById(id,timeTag,otherJson,workflowid){
	ToastLoading("加载中...");
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"getWfTodoList","hrmId":id,"workflowid":workflowid},
	    dataType: "json",  
	    success:function (data) {
	    	var name=otherJson.name;
	    	var aboutStr="";
	    	if(workflowid!=""&&otherJson.content){
	    		aboutStr=otherJson.content+"相关";
	    	}
	    	hideToast();
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		if(data.list){
	    			var size=data.list.length;
	    			var listSize=size;
	    			if(size==0){
	    				var str="您暂无"+aboutStr+"待办流程"
	    				if(name!=""){
	    					str=name+"没有"+aboutStr+"待办流程";
	    				}
						play(str);
						$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
						return;
					}
	    			var str="";
	    			var who="您";
	    			if(name!=""){
	    				who=name;
	    			}
	    			if(data.count>size){
	    				str="为您找到"+who+"的"+data.count+"条"+aboutStr+"待办,以下是前20条";
	    			}else{
	    				str="为您找到"+who+"的"+size+"条"+aboutStr+"待办";
	    			}
					play(str); 
			    	var page=Math.ceil(listSize/5);
				    if(page>1){
				    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364px;">';
				    	var pageHtml='<div class="otherInfo"><div class="morePage" style="width:'+15*page+'px">'
				    	for (var i=0;i<page;i++){
				    		if(i==0){
				    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
				    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
				    		}else{
				    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
				    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
				    		}
				    	}
				    	resultHtml+='</div>';
				    	pageHtml+='</div>';
				    	 
					    pageHtml+='</div>';
				    	$("#anser"+timeTag).append(resultHtml);
				    	$("#anser"+timeTag).append(pageHtml);
			    	}else{
			    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			    	}
				    
				   
					$.each(data.list,function(j,item){
						var currentPage=Math.ceil((j+1)/5);
						var isLast=(((j+1)%5)==0||j==listSize-1)?"1":"0";
						$("#listview_"+currentPage+"_"+timeTag).append(showSchema(item,isLast));
					});
					
					setTimeout(function(){
						$("#result"+timeTag ).height($('.result-current-ul').height());
						
						swipeList($("#result"+timeTag ));
						
						saveHistory();
					},200);
	    		}
	    	}
	    }
    });
}

/*
* 假期
*/
function showHoliday(timeTag){
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"holiday"},
	    dataType: "json",  
	    success:function (data) {
	    	hideToast();
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		if(data.result){
	    			var str="以下是您的假期情况";
					play(str);
					$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result">'+data.result+'</div>');
					saveHistory();
	    		}
	    	}
	    }
    });
}

/*
* 展示报表
*/
function showReportUrl(id,timeTag,otherJson,qData){
	ToastLoading("加载中...");
	var str="以下是您要查询的报表信息";
	var url=otherJson.slots.url;
	var map=otherJson.slots.map;
	if(id&&id!=""){
		if(otherJson.slots.people==""){
			otherJson.slots.people=id;
		}
	}
	
	var temp_str="";
	var queryData={};
	var crossDomain=false;
	if(qData){
		queryData=qData;
		if(otherJson.slots.crossDomain){
			crossDomain=otherJson.slots.crossDomain;
		}
	}else{
		for(var k in map){
			var name=map[k].name;
			if(name=="url"){
				if(map[k].column=="CrossDomain"){
					crossDomain=true;
					otherJson.slots.crossDomain=true;
				}		
			 	continue;
			}
			if(otherJson.slots[name]!=""&&otherJson.slots[name]!=undefined){
				queryData[map[k].column]=otherJson.slots[name];//encodeURIComponent(otherJson.slots[name]);
			}else if(map[k].defaultV!=""){
				if(name=="uri"){
					queryData["uri"]=encodeURIComponent(map[k].defaultV);
				}else{
					queryData[map[k].column]=map[k].defaultV;
				}
			}
		}
	}
	//url跟上随机串.
	if(url.indexOf("?")>-1){
		url+="&random="+new Date().getTime();
	}else{
		url+="?random="+new Date().getTime();
	}
	
	//跨域
	if(crossDomain){
		$.ajax({  
	        type:'get',  
	        url : url,  
	        dataType : 'jsonp',  
	        jsonp:"jsoncallback",  
	        data:queryData,
	        success  : function(data) {  
	            processReport(data,timeTag,otherJson,queryData);
	        },  
	        error : function() { 
	           ToastInfo("查询数据失败!",1);
	           return;
	        }  
	    });
	}else{
		jQuery.ajax({
		type: "post",
	    url: url,
	    data:queryData,
	    dataType: "json",  
	    success:function (data) {
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		processReport(data,timeTag,otherJson,queryData);
	    	}
	    }
	   });
	}
}

//标准明细列表返回的样式.类型1
function processReport(data,timeTag,otherJson,queryData){
	var retFlag={};
	if(otherJson.slots.retFlag){
		retFlag=otherJson.slots.retFlag;
	}
	//兼容判断下.成功标识
	if(!retFlag.SuccessF){
		retFlag.SuccessF="msg";
	}
	//兼容判断下. 成功值
	if(!retFlag.SuccessV){
		retFlag.SuccessV="0";
	}
	//返回显示类型
	if(!retFlag.RetType){
		retFlag.RetType="1";
	}
	if(!retFlag.IsPage){
		retFlag.IsPage="0";
	}
	//分页相关参数定义
	if(retFlag.ShowStyle=="1"&&retFlag.RetType=="1"){
		retFlag.IsPage="1";
	}
	//总条数
	if(!retFlag.Total){
		retFlag.Total="total";
	}
	//当前页数
	if(!retFlag.PageNum){
		retFlag.PageNum="pageNum";
	}
	//总页数
	if(!retFlag.TotalPage){
		retFlag.TotalPage="totalPage";
	}
	//每页条数
	if(!retFlag.PageSize){
		retFlag.PageSize="pageSize";
	}
	//显示备注
	if(!retFlag.DisplayRemark){
		retFlag.DisplayRemark="";
	}
	
	if(""+data[retFlag.SuccessF]==retFlag.SuccessV){
		//根据返回样式,不同方式展示 
		if(retFlag.ShowStyle=="2"){
			processReport2(data,timeTag,otherJson,queryData);
			return;
		}else if(retFlag.ShowStyle=="3"||retFlag.ShowStyle=="4"||retFlag.ShowStyle=="6"||retFlag.ShowStyle=="7"||retFlag.ShowStyle=="8"||retFlag.ShowStyle=="9"){
			processReport4(data,timeTag,otherJson,queryData);
			return;
		}else if(retFlag.ShowStyle=="5"){
			processReport5(data,timeTag,otherJson,queryData);
			return;
		}
			 
		var total=data[retFlag.Total];//total;//总条数
		var pageNum=parseInt(data[retFlag.PageNum]);//pageNum;//当前页
		var totalPage=data[retFlag.TotalPage];//totalPage;//总页数
		var pageSize=data[retFlag.PageSize];//pageSize;//每页条数
	 	var showItemSize=otherJson.slots.retList.length;
	 	$.each(otherJson.slots.retList,function(j,ret){
	 		if(ret.defaultN=="") showItemSize--;
		});
		if(otherJson.slots&&otherJson.slots.map&&otherJson.slots.map.pageNum&&otherJson.slots.map.pageNum.column){
			queryData[otherJson.slots.map.pageNum.column]=pageNum+1;
		}else{
			queryData.pageNum=pageNum+1;
		}

	 	
		var size=data[retFlag.RetList].length;//当前页返回条数.
		var showMore=false;
		var str="为您找到"+total+"条数据";
		if(size==0){
			str="对不起,没有找到您要的报表数据";
			if(retFlag.DisplayStr_NO&&retFlag.DisplayStr_NO!=""){
				str=retFlag.DisplayStr_NO;
			}
			play(str);
		}else if(size>1){
			if(totalPage>pageNum){
				showMore=true;
			}
			var startNum=((pageNum-1)*pageSize)+1;
			var endNum=startNum-1+size;
			str="为您找到"+total+"条数据，以下是"+startNum+"-"+endNum+"条";
			if(total<pageSize){
				str="为您找到"+total+"条数据";
			}
			if(retFlag.IsPage=="0"){//如果不是分页.直接显示条数
				str="为您找到"+total+"条数据";
				showMore=false;
			}
			if(retFlag.DisplayStr&&retFlag.DisplayStr!=""){
				if(retFlag.DisplayStr.indexOf("{DisplayStr}")>-1){
					if(data.DisplayStr){
						str=retFlag.DisplayStr.replace("{DisplayStr}",data.DisplayStr);
					}
				}else if(retFlag.DisplayStr.indexOf("{DisplayDate}")>-1){
					if(otherJson.slots&&otherJson.slots.DisplayDate){
						str=retFlag.DisplayStr.replace("{DisplayDate}",otherJson.slots.DisplayDate);
					}
				}else{
					str=retFlag.DisplayStr;
				}
			}
			play(str);
		}else{
			if(retFlag.DisplayStr&&retFlag.DisplayStr!=""){
				if(retFlag.DisplayStr.indexOf("{DisplayStr}")>-1){
					if(data.DisplayStr){
						str=retFlag.DisplayStr.replace("{DisplayStr}",data.DisplayStr);
					}
				}else if(retFlag.DisplayStr.indexOf("{DisplayDate}")>-1){
					if(otherJson.slots&&otherJson.slots.DisplayDate){
						str=retFlag.DisplayStr.replace("{DisplayDate}",otherJson.slots.DisplayDate);
					}
				}else{
					str=retFlag.DisplayStr;
				}
			}
			play(str);
		}
		var needDisplayRemark="";
	 	//是否有备注说明. 防止异常. 去除DisplayRemark
	 	if(retFlag.DisplayRemark&&retFlag.DisplayRemark!=""){
	 		needDisplayRemark=retFlag.DisplayRemark;
	 		delete retFlag.DisplayRemark;
	 	}		
		if(size==0){
			$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'"></div></div>');

		}else if(size>0){
			var reportHight=(36*showItemSize)-2;
			var listSize=size;
  			var eachpagesize=2; 
  			//每页显示数量条数,单页
			if(retFlag.EachPageSize){
				eachpagesize=retFlag.EachPageSize;
			}
	
  			if(listSize>=eachpagesize){
  				reportHight=reportHight*eachpagesize;
  			}
	    	var page=Math.ceil(listSize/eachpagesize);
		    if(page>1){
		    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:'+reportHight+'px;">';
		    	var pageHtml='<div class="otherInfo" style="padding-bottom: 10px;"><div class="morePage" style="width:'+15*page+'px">'
		    	for (var i=0;i<page;i++){
		    		if(i==0){
		    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
		    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
		    		}else{
		    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
		    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
		    		}
		    	}
		    	resultHtml+='</div>';
		    	pageHtml+='</div>';
		    	if(showMore){
					 pageHtml+='<div id="loadMore'+timeTag+'"  target="timeTag" class="rectangle rounded loadMore currentLoadMore" queryData=\''+JSON.stringify(queryData)+'\' otherJson=\''+JSON.stringify(otherJson)+'\'>点击加载更多</div>';
				} 
			    pageHtml+='</div>';
		    	$("#anser"+timeTag).append(resultHtml);
		    	$("#anser"+timeTag).append(pageHtml);
	    	}else{
	    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	    	}
	
			$.each(data[retFlag.RetList],function(j,item){
				var currentPage=Math.ceil((j+1)/eachpagesize);
				var isLast=(((j+1)%eachpagesize)==0||j==listSize-1)?"1":"0";
				$("#listview_"+currentPage+"_"+timeTag).append(showReportItem(item,isLast,otherJson.slots.retList,otherJson.slots.retFlag));
			});
		}
		//备注说明.有加载更多只展示第一页中
		if(needDisplayRemark!=""){
			if(retFlag.NeedRemarkQueryData&&retFlag.NeedRemarkQueryData=="1"){//是否需要记录查询条件.默认不记录
				$("#anser"+timeTag).append('<div class="result reportStatDiv" ts="'+timeTag+'" queryData=\''+JSON.stringify(queryData)+'\'><div ts="'+timeTag+'" id="remark_listview_'+timeTag+'" style="margin: 0 15px;line-height: 25px;"></div></div>');
				$("#remark_listview_"+timeTag).html(needDisplayRemark);
			}else{
				$("#anser"+timeTag).append('<div class="result reportStatDiv" ts="'+timeTag+'"><div ts="'+timeTag+'" id="remark_listview_'+timeTag+'" style="margin: 0 15px;line-height: 25px;"></div></div>');
				$("#remark_listview_"+timeTag).html(needDisplayRemark);
			}
		}
		
		
		loadMoreInfo($('#loadMore'+timeTag));
		
		swipeList($("#result"+timeTag ));
			
		saveHistory();
		
		hideToast();
	}else{
		ToastInfo("查询数据失败!",1);
	}
	
}

/*
*展示每个报表 单元项	
*/
function showReportItem(item,isLast,retList,retFlag){
	var recordData="";
	var htmlStr="<div class='reportItemDiv' style='line-height:35px;'>";
	if(retFlag.NeedRecordData&&retFlag.NeedRecordData=="1"){
		htmlStr="<div class='reportItemDiv' style='line-height:35px;' recordData='"+JSON.stringify(item)+"'>";
	}
	
	$.each(retList,function(j,ret){
		if(ret.defaultV=="ID"){
			//主键ID 暂时不处理
		}else{
			var isLastLi=(j==retList.length-1)?"lastLi":"";
			if(ret.defaultV=="NAME"){
				htmlStr+="<div class='lineTips "+isLastLi+"'>"+item[ret.name]+"</div>";
			}else{
				var key=ret.name;
				var showStr="";
				if(ret.defaultV){//默认值.
					showStr=ret.defaultV
				}
				showStr=showStr.replaceAll("#x20;","&nbsp;");
				var keys=key.split(",");
				for(var i in keys){
					showStr=showStr.replace("{"+keys[i]+"}",item[keys[i]]);
				}
				if(showStr==""){
					showStr=item[ret.name];
				}
				htmlStr+="<div class='lineBottom "+isLastLi+"'><div class='labelName reportLabelName'>"+ret.defaultN +"</div><div>"+showStr+"</div></div>";
			}
		}
	});
	htmlStr+="</div>";
	return htmlStr;
}


/*报表项 点击事件*/
function reportItemClick(obj,functionName){
	if(functionName!=''){
		//if($(obj).parents('.anser').hasClass("anserCurrent")){
			try{
				reportDoFunction(eval(functionName),obj);
			}catch(e){}
		//}
	}
}

/*报表项 点击事件转化成实际方法调用 触发*/
function reportDoFunction(doFunction,obj){
	try{
		doFunction(obj);
	}catch(e){}
}

//单条数据. 明细列表展示
/**
	为您找到以下数据
		名称
	 xxxx1	:	123
 	 xxxx2	:	234
*/
function processReport2(data,timeTag,otherJson,queryData){
	var str="为您找到以下数据";
	var retFlag=otherJson.slots.retFlag;
	if(retFlag.DisplayStr&&retFlag.DisplayStr!=""){
		if(retFlag.DisplayStr.indexOf("{DisplayStr}")>-1){
			if(data.DisplayStr){
				str=retFlag.DisplayStr.replace("{DisplayStr}",data.DisplayStr);
			}
		}else if(retFlag.DisplayStr.indexOf("{DisplayDate}")>-1){
			if(otherJson.slots&&otherJson.slots.DisplayDate){
				str=retFlag.DisplayStr.replace("{DisplayDate}",otherJson.slots.DisplayDate);
			}
		}else{
			str=retFlag.DisplayStr;
		}
	}
	play(str);
 			
   	$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result reportItemResult"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div><div class="otherInfo" id="otherInfo'+timeTag+'" style="padding-top: 8px;display:none"><div id="doAction'+timeTag+'" class="rectangle rounded  doAction currentDoAction"></div></div>');
	//返回查询条件key
	var retQueryData="retQueryData";
	if(retFlag.retQueryData){
		retQueryData=retFlag.retQueryData;
	}
	//返回数据中是否包含 retQueryData
	if(data[retQueryData]){
		//保存至reportItemResult
		$("#anser"+timeTag).find(".reportItemResult").attr("retQueryData",JSON.stringify(data[retQueryData]));
		//增加
		var nextTs=new Date().getTime();
		$("#anser"+timeTag).find(".reportItemResult").attr("nextTs",nextTs);
	}
	
	
	var htmlStr="<div class='reportItemDiv' style='line-height:35px;'>";
	$.each(otherJson.slots.retList,function(j,ret){
		if(ret.defaultV=="ID"){
			//主键ID 暂时不处理
		}else{
			//没有显示名称的 忽略.
			if(ret.defaultN==""){
			
			}else{
				var columEvent='';
				if(retFlag['#EVENT_'+ret.name]&&retFlag['#EVENT_'+ret.name]!=''){
					columEvent=" onclick='reportItemClick(this,\""+retFlag['#EVENT_'+ret.name]+"\")'";
					//是否可以重复触发..
				}
				var isLastLi=(j==otherJson.slots.retList.length-1)?"lastLi":"";
				if(ret.defaultV=="NAME"){
					htmlStr+="<div class='lineTips "+isLastLi+"' "+columEvent+">"+(ret.name?data[ret.name]:(ret.defaultN?ret.defaultN:''))+"</div>";
				}else{
					var key=ret.name;
					var showStr="";
					if(ret.defaultV){//默认值.
						showStr=ret.defaultV
					}
					showStr=showStr.replaceAll("#x20;","&nbsp;");
					var keys=key.split(",");
					for(var i in keys){
						showStr=showStr.replace("{"+keys[i]+"}",data[keys[i]]);
					}
					if(showStr==""){
						showStr=data[ret.name];
					}
					htmlStr+="<div class='lineBottom "+isLastLi+"' "+columEvent+"><div class='labelName reportLabelName'>"+ret.defaultN +"</div><div>"+showStr+"</div></div>";
				}
			}
		}
	});
	htmlStr+="</div>";
	
	$("#listview_1_"+timeTag).append(htmlStr);
	
	//展示点击查看明细数据.是否有对应报表.
	if(retFlag.DisplayDetailInfo&&retFlag.DisplayDetailInfo!=""){
		//判断明细报表是否存在.
		jQuery.ajax({
			async: false, 
			type : "POST", 
			url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	   		data:{"type":"ReportParam","reportType":retFlag.DisplayDetailInfo},
			dataType : 'json', 
			success : function(data) {
				if(data.result==1){
					//显示明细按钮..
					$("#doAction"+timeTag).html("点击查看明细");
					$("#doAction"+timeTag).addClass("currentDoAction");
					$("#otherInfo"+timeTag).show();
					//记录otherJson数据.
					otherJson.slots.url=data.url;
					otherJson.slots.map=data.map;
				    otherJson.slots.retList=data.retList;
				    otherJson.slots.retFlag=data.retFlag;
				    otherJson.slots.statList=data.statList;
									    
					$("#doAction"+timeTag).attr("otherJson",JSON.stringify(otherJson));
   		 			//增加点击事件. 只能点击一次.
   		 			$("#doAction"+timeTag).off("tap").on("tap",function(){
   		 				//
   		 				if($(this).hasClass("currentDoAction")){
	   		 				//直接发起请求.
							var timestamp = new Date().getTime();
					    	//移除上一次的
						   	removeLastAsk();
					   		 
					    	$('#contentDiv').append("<div id='ask"+timestamp+"' ts='"+timestamp+"' class='ask askCurrent'><div class='keyDiv'>“查看明细”</div></div>");
					    	$('#contentDiv').append("<div id='instructTip"+timestamp+"' ts='"+timestamp+"'></div>");
							$('#contentDiv').append("<div id='anser"+timestamp+"' ts='"+timestamp+"' class='anser anserCurrent'></div>");
							$('#contentDiv').append("<div id='split"+timestamp+"' ts='"+timestamp+"' class='split splitCurrent'></div>");
							
							$.scrollTo('.askCurrent',0);
							showReportUrl("",timestamp,JSON.parse($(this).attr("otherJson")));
   		 				}
   		 			}); 		 		
				}
			}
		});
	}
	saveHistory();
	
	hideToast();
}

/**
	标准列表返回,一行 二行数据展示 三行数据 等
 */
function processReport4(data,timeTag,otherJson,queryData){
	var retFlag=otherJson.slots.retFlag;
	var IsPage=retFlag.IsPage=="1";//是否分页

	var showSize=50;//最多显示数据条数. 不分页时使用
	var total=0;
	var pageNum=1;
	var totalPage=1;
	var pageSize=20;
	var size=data[retFlag.RetList].length;//当前页返回条数.
		
	if(IsPage){
		total=data[retFlag.Total];//total;//总条数
	    pageNum=parseInt(data[retFlag.PageNum]);//pageNum;//当前页
		totalPage=data[retFlag.TotalPage];//totalPage;//总页数
		pageSize=data[retFlag.PageSize];//pageSize;//每页条数
		if(otherJson.slots&&otherJson.slots.map&&otherJson.slots.map.pageNum&&otherJson.slots.map.pageNum.column){
			queryData[otherJson.slots.map.pageNum.column]=pageNum+1;
		}
	}else{
		total=size;//总条数
	}
	var showMore=false;
	var str="为您找到"+total+"条数据";
	var ShowStyle=retFlag.ShowStyle;
	if(total==0){
		str="对不起,没有找到您要的数据";
		if(retFlag.DisplayStr_NO&&retFlag.DisplayStr_NO!=""){
			str=retFlag.DisplayStr_NO;
		}
	}else{
		if(IsPage){//开启分页
			if(totalPage>pageNum){
				showMore=true;
			}
			var startNum=((pageNum-1)*pageSize)+1;
			var endNum=startNum-1+size;
			
			str="为您找到"+total+"条数据，以下是"+startNum+"-"+endNum+"条";
			if(total<pageSize){
				str="为您找到"+total+"条数据";
			}
		}else{
			if(total>showSize){
				str="为您找到"+total+"条数据，以下是前50条";
			}
		}
		
		if(retFlag.DisplayStr&&retFlag.DisplayStr!=""){
			if(retFlag.DisplayStr.indexOf("{DisplayStr}")>-1){
				if(data.DisplayStr){
					str=retFlag.DisplayStr.replace("{DisplayStr}",data.DisplayStr);
				}
			}else if(retFlag.DisplayStr.indexOf("{DisplayDate}")>-1){
				if(otherJson.slots&&otherJson.slots.DisplayDate){
					str=retFlag.DisplayStr.replace("{DisplayDate}",otherJson.slots.DisplayDate);
				}
			}else{
				str=retFlag.DisplayStr;
			}
		}	
	}
	var ReadListTitle=0;
	var readTitleStr="";
	//获取标题字段
 	var titleName="";
	try{
		if(retFlag.ReadListTitle&&parseInt(retFlag.ReadListTitle)>0){
			ReadListTitle=parseInt(retFlag.ReadListTitle);
		}
	}catch(e){}
 	if(ReadListTitle>0){
	 	$.each(otherJson.slots.retList,function(j,ret){
			if(ret.defaultV=="NAME"){
				titleName=ret.name;
			}
		});
	}
	readTitleStr=str+" ";
 			
	if(total==0){
		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'"></div></div>');
	}else if(total>0){
		var listSize=total>showSize?showSize:total;
		if(IsPage){//开启分页,直接就是当前数据数量
			listSize=size;
		}
		var eachpagesize=5; //每页5条数据
    	var page=Math.ceil(listSize/eachpagesize);
	    if(page>1){
	    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364px;">';
	    	var pageHtml='<div class="otherInfo" style="padding-bottom: 10px;"><div class="morePage" style="width:'+15*page+'px">'
	    	for (var i=0;i<page;i++){
	    		if(i==0){
	    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
	    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
	    		}else{
	    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
	    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
	    		}
	    	}
	    	resultHtml+='</div>';
	    	pageHtml+='</div>';
	    	if(showMore){
				 pageHtml+='<div id="loadMore'+timeTag+'"  target="timeTag" class="rectangle rounded loadMore currentLoadMore" queryData=\''+JSON.stringify(queryData)+'\' otherJson=\''+JSON.stringify(otherJson)+'\'>点击加载更多</div>';
			}
		    pageHtml+='</div>';
	    	$("#anser"+timeTag).append(resultHtml);
	    	$("#anser"+timeTag).append(pageHtml);
    	}else{
    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
    	}
		
		
		$.each(data[retFlag.RetList],function(j,item){
			var currentPage=Math.ceil((j+1)/eachpagesize);
			var isLast=(((j+1)%eachpagesize)==0||j==total-1||j==listSize-1)?"1":"0";
			if(ReadListTitle>0&&titleName!=""&&j<ReadListTitle){
				readTitleStr+=(j+1)+" "+item[titleName]+" ";
			}
			
			if(j<showSize){
				$("#listview_"+currentPage+"_"+timeTag).append(showSimpleReportItem((j+1),item,isLast,otherJson.slots.retList,retFlag));
			}
		});
		$('#result'+timeTag).css("height",$('#result'+timeTag).find('.result-current-ul').height()+"px");
	}
	if(readTitleStr!=""){
		playAll(readTitleStr);
	}
	
	loadMoreInfo($('#loadMore'+timeTag));
	swipeList($("#result"+timeTag ));
	saveHistory();
	hideToast();
}


/**
	样式6 
	排名 icon	title1
 
 ------------------------------
	样式3
	 		  title1		
	排名 icon
	 		  desc	
 --------------------------------
 	样式4
			  title1		title2
	排名 icon
	 		  desc		desc2
---------------------------------
	样式7
	 		  title1		
	排名 icon  desc1
	 		  desc2   第三行内容多自动换行	
*/
function showSimpleReportItem(j,item,isLast,retList,retFlag){
	//显示样式
	var ShowStyle=retFlag.ShowStyle;
	//显示排名
	var DisplayRanking=retFlag.DisplayRanking=="1";
	//显示小图标.0表示没有小图标
	var hideIcon=retFlag.DisplayIcon=="0";
	var defaultIcon='';
	var changeDateColumn=false;
	var schema='';
	var css=isLast=="1"?"lastLi":"";
	var isRSC=false;
	var showItemStyle=1;
	
	if(!hideIcon){
		var DisplayIcon=retFlag.DisplayIcon;
		if(DisplayIcon=="RSC"){
			defaultIcon='/messager/images/icon_m_wev8.jpg';
			schema="RSC";
			isRSC=true;
		}else if(DisplayIcon=="WKP"){
			changeDateColumn=true;
			schema="WKP";
			defaultIcon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_wkp_wev8.png';
		}else if(DisplayIcon=="DOC"){
			schema=DisplayIcon;
			defaultIcon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_doc_wev8.png';
		}else if(DisplayIcon=="WF"){
			schema=DisplayIcon;
			defaultIcon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_wf_wev8.png';
		} else if(DisplayIcon=="CRM"){
			schema=DisplayIcon;
			defaultIcon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_crm_wev8.png';
		}else if(DisplayIcon=="FAQ"){
			schema=DisplayIcon;
			defaultIcon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_faq_wev8.png';
		}else if(DisplayIcon=="SELL"){
			schema=DisplayIcon;
			defaultIcon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_sell_wev8.png';
		}else if(DisplayIcon=="PRJ"){
			schema=DisplayIcon;
			defaultIcon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_prj_wev8.png';
		}else if(DisplayIcon=="TASK"){
			schema=DisplayIcon;
			defaultIcon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_task_wev8.png';
		}else if(DisplayIcon=="NEWS"){
			schema=DisplayIcon;
			defaultIcon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_news_wev8.png';
		}else if(DisplayIcon.startWith("/")){
			defaultIcon=DisplayIcon;
		}else{//不正确的icon不显示
			isDisplayIcon=false;
		}
	}
	
	var item_id="";
	var item_icon="";
	var item_date="";
	var item_vale=["","","",""];
	var item_small_icon="";
	var maxItemSize=4;
	if(ShowStyle=="6"){
		maxItemSize=1;
	}else if(ShowStyle=="7"){
		maxItemSize=3;
	}else if(ShowStyle=="4"){
		maxItemSize=4;
	}else if(ShowStyle=="8"){
		maxItemSize=3;
	}else if(ShowStyle=="9"){
		maxItemSize=4;
	}else{
		maxItemSize=2;
	}
	var itemSize=0;	
	$.each(retList,function(j,ret){
		if(ret.defaultV=="ID"){
			item_id=item[ret.name];
		}else if(ret.defaultV=="ICON"){
			item_icon=item[ret.name];
			if(item_icon=="FEE_FOOD"){
				item_icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_fee_food_wev8.png'
			}else if(item_icon=="FEE_OIL"){
				item_icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_fee_oil_wev8.png'
			}else if(item_icon=="FEE_PHONE"){
				item_icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_fee_phone_wev8.png'
			}
		}else if(ret.defaultV=="DATE"){
			item_date=item[ret.name];
		}else{
			//ICON下的小图标
			if(ret.defaultN=="SMALL_ICON"){
				var key=ret.name;
				var showStr=ret.defaultV;//默认值.
				showStr=showStr.replaceAll("#x20;","&nbsp;");
				var keys=key.split(",");
				for(var i in keys){
					item_small_icon=showStr.replace("{"+keys[i]+"}",item[keys[i]]);
				}
			}else{
				if(itemSize<maxItemSize){
					//除开几个特殊字段指定,其他可以使用带参.
					if(ret.defaultV!=""&&ret.defaultV!="ID"&&ret.defaultV!="ICON"&&ret.defaultV!="DATE"&&ret.defaultV!="NAME"){
						var key=ret.name;
						var showStr=ret.defaultV;//默认值.
						showStr=showStr.replaceAll("#x20;","&nbsp;");
						var keys=key.split(",");
						for(var i in keys){
							showStr=showStr.replace("{"+keys[i]+"}",item[keys[i]]);
						}
						item_vale[itemSize++]=showStr;
					}else{
						item_vale[itemSize++]=item[ret.name];
					}
				}
			}
		}
	});
	//特殊小图标颜色
	var IconColor="";
	if(item_icon!=""){
		if(retFlag.IconColor&&retFlag.IconColor!=""){
			var IconColorUrl=retFlag.IconColor;
			var IconColorUrls=IconColorUrl.split(";")
			var iucs;
			for(var ic in IconColorUrls){
				iucs=IconColorUrls[ic].split("||");
				if(iucs.length==2){
					if(iucs[0]==item_icon){
						IconColor="background:"+iucs[1];
					}
				}
			}
		}
	}
	
	
	//人员无头像通过名字转
	var imgDiv="";
	if(isRSC&&(item_icon.indexOf("icon_w_wev8.jpg")>-1||item_icon.indexOf("icon_m_wev8.jpg")>-1||item_icon.indexOf("dummyContact.png")>-1||item_icon=="")){
		imgDiv='<div class="imgDiv">'+getRSCname(item_vale[0])+'</div>';
	}
	
	//如果未获取到icon值,且有默认值时
	if(!hideIcon&&item_icon==""&&defaultIcon!=""){
		item_icon=defaultIcon;
	}
	
	//日程日期作为图标.
	if(changeDateColumn){
		if(item_date!=""){
			//对日期分解
			var dates=item_date.split("-");
			var t_year=dates[0];
			var t_month=dates[1];
			var t_day=dates[2];
			imgDiv='<div style="text-align: center;height: 46px;width: 46px;margin-top: 1px;">'+
				 		'<div class="wkp_calendar_title1">'+t_year+'.'+t_month+'</div>'+
				 		'<div class="wkp_calendar_body2">'+t_day+'</div>'+
				 	'</div>';
		}else{
			item_icon=defaultIcon;
		}
	}
	//url点击
	var onclickStr="";
	if(retFlag.ClickURL&&retFlag.ClickURL!=""){
		var retFlagUrl=retFlag.ClickURL.replace("{ID}",item_id);
		onclickStr='onclick="goPage(\'\',\'\',\''+retFlagUrl+'\')"';

	}
 
	var htmlStr='';
	
	if(maxItemSize==2){
		//显示小图标,不显示排名
		if(!hideIcon&&!DisplayRanking){
			htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
						'<div class="am-list-line">'+
							'<div class="am-list-content">'+
								'<span class="ul-li-div-img">'+
								 	(imgDiv==""?'<img src="'+item_icon+'">':imgDiv)+
								'</span>'+
								'<div class="ul-li-div">'+
								   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
								   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item_vale[1]+'</span></div>'+
								'</div>'+
							'</div>'+
						'</div>'+
	  				'</div>';
		}else if(hideIcon&&DisplayRanking){//不显示小图标,显示排名
			htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
						'<div class="am-list-line">'+
							'<div class="am-list-content">'+
								'<span class="ul-li-div-ranking-img">'+
								 	j+
								'</span>'+
								'<div class="ul-li-div-ranking">'+
								  	'<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
								   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item_vale[1]+'</span></div>'+
								'</div>'+
							'</div>'+
						'</div>'+
	  				'</div>';
		}else if(!hideIcon&&DisplayRanking){//显示小图标,且显示排名
			htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
						'<div class="am-list-line">'+
							'<div class="am-list-content">'+
								'<span class="ul-li-div-ranking-img">'+
								 	j+
								'</span>'+
								'<span class="ul-li-div-img ul-li-div-img2">'+
								 	(imgDiv==""?'<img src="'+item_icon+'">':imgDiv)+
								'</span>'+
								'<div class="ul-li-div-icon-ranking">'+
								   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
								   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item_vale[1]+'</span></div>'+
								'</div>'+
							'</div>'+
						'</div>'+
	  				'</div>';
		}else{//不显示小图标,也不显示排名
			htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
						'<div class="am-list-line">'+
							'<div class="am-list-content">'+
								'<div class="ul-li-div-no">'+
								   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
								   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item_vale[1]+'</span></div>'+
								'</div>'+
							'</div>'+
						'</div>'+
	  				'</div>';
		} 
	}else if(maxItemSize==3){
		if(ShowStyle=="8"){
			//显示小图标,不显示排名
			if(!hideIcon&&!DisplayRanking){
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-img">'+
									 	(imgDiv==""?'<img src="'+item_icon+'">':imgDiv)+
									'</span>'+
									'<div class="ul-li-div">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[1]+'</span><span class="ui-li-span">'+item_vale[2]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else if(hideIcon&&DisplayRanking){//不显示小图标,显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-ranking-img">'+
									 	j+
									'</span>'+
									'<div class="ul-li-div-ranking">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[1]+'</span><span class="ui-li-span">'+item_vale[2]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else if(!hideIcon&&DisplayRanking){//显示小图标,且显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-ranking-img">'+
									 	j+
									'</span>'+
									'<span class="ul-li-div-img ul-li-div-img2">'+
									 	(imgDiv==""?'<img src="'+item_icon+'">':imgDiv)+
									'</span>'+
									'<div class="ul-li-div-icon-ranking">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[1]+'</span><span class="ui-li-span">'+item_vale[2]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else{//不显示小图标,也不显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<div class="ul-li-div-no">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[1]+'</span><span class="ui-li-span">'+item_vale[2]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}
		}else{
			//显示小图标,不显示排名
			if(!hideIcon&&!DisplayRanking){
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-img">'+
									 	(imgDiv==""?'<img src="'+item_icon+'" style="'+IconColor+'">':imgDiv)+
									'</span>';
						 if(item_small_icon!=""){			
							htmlStr+='<span class="ul-li-div-img3">'+
									 	item_small_icon+
									 '</span>';
						 }
						    htmlStr+='<div class="ul-li-div">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item_vale[1]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80 ui-li-span-normal-white-space">'+item_vale[2]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else if(hideIcon&&DisplayRanking){//不显示小图标,显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-ranking-img">'+
									 	j+
									'</span>'+
									'<div class="ul-li-div-ranking">'+
									  	'<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									    '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item_vale[1]+'</span></div>'+
									    '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80 ui-li-span-normal-white-space">'+item_vale[2]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else if(!hideIcon&&DisplayRanking){//显示小图标,且显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-ranking-img">'+
									 	j+
									'</span>'+
									'<span class="ul-li-div-img ul-li-div-img2">'+
									 	(imgDiv==""?'<img src="'+item_icon+'" style="'+IconColor+'">':imgDiv)+
									'</span>';
						if(item_small_icon!=""){			
							htmlStr+='<span class="ul-li-div-img3-ranking">'+
									 	item_small_icon+
									 '</span>';
						 }
						  htmlStr+='<div class="ul-li-div-icon-ranking">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item_vale[1]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80 ui-li-span-normal-white-space">'+item_vale[2]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else{//不显示小图标,也不显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<div class="ul-li-div-no">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item_vale[1]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80 ui-li-span-normal-white-space">'+item_vale[2]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}
		}
	}else if(maxItemSize==4){
		if(ShowStyle=="9"){
			//显示小图标,不显示排名
			if(!hideIcon&&!DisplayRanking){
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-img">'+
									 	(imgDiv==""?'<img src="'+item_icon+'">':imgDiv)+
									'</span>'+
									'<div class="ul-li-div">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[1]+'</span><span class="ui-li-span">'+item_vale[2]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80 ui-li-span-normal-white-space">'+item_vale[3]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else if(hideIcon&&DisplayRanking){//不显示小图标,显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-ranking-img">'+
									 	j+
									'</span>'+
									'<div class="ul-li-div">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[1]+'</span><span class="ui-li-span">'+item_vale[2]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80 ui-li-span-normal-white-space">'+item_vale[3]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else if(!hideIcon&&DisplayRanking){//显示小图标,且显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-ranking-img">'+
									 	j+
									'</span>'+
									'<span class="ul-li-div-img ul-li-div-img2">'+
									 	(imgDiv==""?'<img src="'+item_icon+'">':imgDiv)+
									'</span>'+
									'<div class="ul-li-div">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[1]+'</span><span class="ui-li-span">'+item_vale[2]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80 ui-li-span-normal-white-space">'+item_vale[3]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else{//不显示小图标,也不显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<div class="ul-li-div-no">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading">'+item_vale[0]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[1]+'</span><span class="ui-li-span">'+item_vale[2]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80 ui-li-span-normal-white-space">'+item_vale[3]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}
		}else{
			//显示小图标,不显示排名
			if(!hideIcon&&!DisplayRanking){
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-img">'+
									 	(imgDiv==""?'<img src="'+item_icon+'">':imgDiv)+
									'</span>'+
									'<div class="ul-li-div">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading">'+item_vale[0]+'</span> <span class="ui-li-span">'+item_vale[1]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[2]+'</span><span class="ui-li-span">'+item_vale[3]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else if(hideIcon&&DisplayRanking){//不显示小图标,显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-ranking-img">'+
									 	j+
									'</span>'+
									'<div class="ul-li-div-ranking">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading">'+item_vale[0]+'</span> <span class="ui-li-span">'+item_vale[1]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[2]+'</span><span class="ui-li-span">'+item_vale[3]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else if(!hideIcon&&DisplayRanking){//显示小图标,且显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-ranking-img">'+
									 	j+
									'</span>'+
									'<span class="ul-li-div-img ul-li-div-img2">'+
									 	(imgDiv==""?'<img src="'+item_icon+'">':imgDiv)+
									'</span>'+
									'<div class="ul-li-div-icon-ranking">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading">'+item_vale[0]+'</span> <span class="ui-li-span">'+item_vale[1]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[2]+'</span><span class="ui-li-span">'+item_vale[3]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}else{//不显示小图标,也不显示排名
				htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<div class="ul-li-div-no">'+
									   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading">'+item_vale[0]+'</span> <span class="ui-li-span">'+item_vale[1]+'</span></div>'+
									   '<div class="ul-li-div-second"> <span class="ui-li-span">'+item_vale[2]+'</span><span class="ui-li-span">'+item_vale[3]+'</span></div>'+
									'</div>'+
								'</div>'+
							'</div>'+
		  				'</div>';
			}
		}
	}else{
		//显示小图标,不显示排名
		if(!hideIcon&&!DisplayRanking){
			htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
						'<div class="am-list-line">'+
							'<div class="am-list-content">'+
								'<span class="ul-li-div-img">'+
								 	(imgDiv==""?'<img src="'+item_icon+'">':imgDiv)+
								'</span>'+
								'<div class="ul-li-div">'+
								   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading" style="line-height: 46px;">'+item_vale[0]+'</span></div>'+
								'</div>'+
							'</div>'+
						'</div>'+
	  				'</div>';
		}else if(hideIcon&&DisplayRanking){//不显示小图标,显示排名
			htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
						'<div class="am-list-line">'+
							'<div class="am-list-content">'+
								'<span class="ul-li-div-ranking-img">'+
								 	j+
								'</span>'+
								'<div class="ul-li-div-ranking">'+
								  	'<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading" style="line-height: 46px;">'+item_vale[0]+'</span></div>'+
								'</div>'+
							'</div>'+
						'</div>'+
	  				'</div>';
		}else if(!hideIcon&&DisplayRanking){//显示小图标,且显示排名
			htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
						'<div class="am-list-line">'+
							'<div class="am-list-content">'+
								'<span class="ul-li-div-ranking-img">'+
								 	j+
								'</span>'+
								'<span class="ul-li-div-img ul-li-div-img2">'+
								 	(imgDiv==""?'<img src="'+item_icon+'">':imgDiv)+
								'</span>'+
								'<div class="ul-li-div-icon-ranking">'+
								   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading" style="line-height: 46px;">'+item_vale[0]+'</span></div>'+
								'</div>'+
							'</div>'+
						'</div>'+
	  				'</div>';
		}else{//不显示小图标,也不显示排名
			htmlStr='<div class="am-list-item '+schema+' '+css+'" '+onclickStr+'>'+
						'<div class="am-list-line">'+
							'<div class="am-list-content">'+
								'<div class="ul-li-div-no">'+
								   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span80 ui-li-span-heading" style="line-height: 46px;">'+item_vale[0]+'</span></div>'+
								'</div>'+
							'</div>'+
						'</div>'+
	  				'</div>';
		} 
	}
	
  	
  	return htmlStr;
}


//统计+表格
/**
 为您找到以下结果
 统计1
 统计2
 统计3
 
 标题1  		标题2 		标题3
 xxx1_1		xxx1_2		xxx1_3
 xxx2_1		xxx2_2		xxx2_3
*/
function processReport5(data,timeTag,otherJson,queryData){
	var str="为您找到以下数据";
	var retFlag=otherJson.slots.retFlag;
	//自定义显示内容
	if(retFlag.DisplayStr&&retFlag.DisplayStr!=""){
		if(retFlag.DisplayStr.indexOf("{DisplayStr}")>-1){
			if(data.DisplayStr){
				str=retFlag.DisplayStr.replace("{DisplayStr}",data.DisplayStr);
			}
		}else if(retFlag.DisplayStr.indexOf("{DisplayDate}")>-1){
			if(otherJson.slots&&otherJson.slots.DisplayDate){
				str=retFlag.DisplayStr.replace("{DisplayDate}",otherJson.slots.DisplayDate);
			}
		}else{
			str=retFlag.DisplayStr;
		}
	}
	
	//自定义无数据显示内容.
	if(otherJson.slots.retList&&otherJson.slots.retList.length>0){
		if(data[retFlag.RetList]&&data[retFlag.RetList].length>0){
			 
		}else{
			if(retFlag.DisplayStr_NO&&retFlag.DisplayStr_NO!=""){
				str=retFlag.DisplayStr_NO;
			}
			
		}
	}
	//判断是否有权限.如果没有权限.直接提示无权限.不显示数据
	if(retFlag.HasRightF&&retFlag.HasRightV&&retFlag.NoRightMsg){
		if(data[retFlag.HasRightF]!=retFlag.HasRightV){
			str=retFlag.NoRightMsg;
			play(str);
			$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result reportStatDiv"><div ts="'+timeTag+'" id="stat_listview_'+timeTag+'"></div></div>');
			return;
		}
	}
	
	play(str);
	
	$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result reportStatDiv"><div ts="'+timeTag+'" id="stat_listview_'+timeTag+'"></div></div>');
	if(otherJson.slots.statList){
		var htmlStr="<div class='reportItemDiv' style='line-height:35px;padding:0px 15px 5px 15px;'>";
		var statisticsCount=0;
		$.each(otherJson.slots.statList,function(j,ret){
			var key=ret.name;
			var showStr=ret.defaultN;
			var keys=key.split(",");
			for(var i in keys){
				if(retFlag.HideNullStatistics=="1"&&data[keys[i]]==""){
					continue;
				}
				showStr=showStr.replace("{"+keys[i]+"}",data[keys[i]]);
				statisticsCount++;
			}
			htmlStr+="<div class='reportStatItemDiv' style='background:"+ret.bgColor+"'><div class='statItemDiv'>"+showStr +"</div></div>";
		});
		htmlStr+="</div>";
		//有统计项
		if(statisticsCount>0){
			$("#stat_listview_"+timeTag).append(htmlStr);
		}
	}
	
	
	if(otherJson.slots.retList&&otherJson.slots.retList.length>0&&data[retFlag.RetList]&&data[retFlag.RetList].length>0){
		//判断返回值有列数.
		var showItemSize=otherJson.slots.retList.length;
	 	$.each(otherJson.slots.retList,function(j,ret){
	 		if(ret.defaultN=="") showItemSize--;
		});
		if(showItemSize==0) showItemSize=1;//防止除数为0.
		var eachItemWidth=(wW-40)/showItemSize;
		
		var listSize=data[retFlag.RetList].length;
		
		var eachpagesize=10; 
		
    	var page=Math.ceil(listSize/eachpagesize);
	    if(page>1){
	    	var resultHtml='<div class="result reportStatDiv" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:309px;">';
	    	var pageHtml='<div class="otherInfo" style="padding-bottom: 10px;"><div class="morePage" style="width:'+15*page+'px">'
	    	for (var i=0;i<page;i++){
	    		if(i==0){
	    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><table class="tableItemDiv" ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></table></div>';
	    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
	    		}else{
	    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><table class="tableItemDiv" ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></table></div>';
	    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
	    		}
	    	}
	    	resultHtml+='</div>';
	    	pageHtml+='</div>';
		    pageHtml+='</div>';
	    	$("#anser"+timeTag).append(resultHtml);
	    	$("#anser"+timeTag).append(pageHtml);
    	}else{
    		$("#anser"+timeTag).append('<div class="result reportStatDiv" id="result'+timeTag+'"><table class="tableItemDiv" ts="'+timeTag+'" id="listview_1_'+timeTag+'"></table></div>');
    	}
	    	
		
		$.each(data[retFlag.RetList],function(j,itemRet){
			var currentPage=Math.ceil((j+1)/eachpagesize);
			var needHead=j%10==0;
			var isLast=(((j+1)%eachpagesize)==0||j==listSize-1)?"1":"0";
			$("#listview_"+currentPage+"_"+timeTag).append(showReportTableItem(itemRet,isLast,otherJson.slots.retList,needHead,eachItemWidth));
		
		});
		
		swipeList($("#result"+timeTag ));
	}
	//显示推荐人员
	showReportSuggestRscList(data,retFlag,timeTag);
	
    //报表5展示备注说明
	if(retFlag.DisplayRemark&&retFlag.DisplayRemark!=""){
		if(retFlag.NeedRemarkQueryData&&retFlag.NeedRemarkQueryData=="1"){//是否需要记录查询条件.默认不记录
			$("#anser"+timeTag).append('<div class="result reportStatDiv" ts="'+timeTag+'" queryData=\''+JSON.stringify(queryData)+'\'><div ts="'+timeTag+'" id="remark_listview_'+timeTag+'" style="margin: 0 15px;line-height: 25px;"></div></div>');
			$("#remark_listview_"+timeTag).html(retFlag.DisplayRemark);
		}else{
			$("#anser"+timeTag).append('<div class="result reportStatDiv" ts="'+timeTag+'"><div ts="'+timeTag+'" id="remark_listview_'+timeTag+'" style="margin: 0 15px;line-height: 25px;"></div></div>');
			$("#remark_listview_"+timeTag).html(retFlag.DisplayRemark);
		}
	}
	
	saveHistory();
	
	hideToast();
}
/**展示表报推荐人员**/
function showReportSuggestRscList(data,retFlag,timeTag){
	
	//有指定返回推荐人员,空值.默认suggestRscList
	if(retFlag.suggestRscList){
		var suggestRscList=retFlag.suggestRscList;
		if(suggestRscList=='') suggestRscList="suggestRscList";
		
		if(data[suggestRscList]&&data[suggestRscList].length>0){
			$("#anser"+timeTag).append('<div class="tips" style="padding-top: 10px;padding-bottom: 5px;">您还可以尝试联系以下人员</div><div class="result reportSuggestDiv"><div ts="'+timeTag+'" id="suggestRsc_listview_1_'+timeTag+'"></div></div>');
			var suggestListSize=data[suggestRscList].length;
			$.each(data[suggestRscList],function(j,item){			
				var isLast=(j==suggestListSize-1)?"1":"0";
				$("#suggestRsc_listview_1_"+timeTag).append(showRSC(item,isLast));
			});
		}
	}
}

/**展示每个tr*/
function showReportTableItem(item,isLast,retList,needHead,eachItemWidth){
	var htmlStr="";
	if(needHead){
		htmlStr+="<tr class='headDiv'>"
		$.each(retList,function(j,ret){
			if(ret.defaultN==""){
			
			}else{
				htmlStr+="<td class='headItemDiv "+(j==retList.length-1?" lastTdDiv":"")+"' style='width:"+eachItemWidth+"px'><div class='eachDataItemDiv' >"+ret.defaultN+"</div></td>";
			}
		});
		htmlStr+="</tr>"
	}

	htmlStr+="<tr class='dataDiv'>"
	$.each(retList,function(j,ret){
		if(ret.defaultN==""){
	
		}else{
			htmlStr+="<td class='dataItemDiv "+(j==retList.length-1?" lastTdDiv":"")+"' style='width:"+eachItemWidth+"px'><div class='eachDataItemDiv ' >"+(item[ret.name]==""?"&nbsp;":item[ret.name])+"</div></td>";
		}
	});
	htmlStr+="</tr>";
	return htmlStr;
}	

/*
*考勤报表
*/
function AttendanceReport(id,timeTag,otherJson){
	ToastLoading("加载中...");
	var datetime={};
	if(otherJson.slots.datetime){
		datetime=otherJson.slots.datetime;
	}
	
	var date="";
	var date_orig="";
	var datetype=1;//1表示指定日期  2表示周  3表示月
	var dif=0;//上个. 下个 计算差值  基本上就是(-1 0 1)
	//获取解析语义
	if(datetime.date_orig){
		date_orig=datetime.date_orig;
	}
	//获取时间
	if(datetime.date){
		date=datetime.date;
	}else if(datetime.begindate){
		date=datetime.begindate;
	}
	// dayFlags=["日","天","号"];
	// weekFlags=["周","礼拜","星期"];
	// lastFlags=["上","前"];
	// nextFlags=["下","后"];
	
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
	}else{//其他统一今天
		date="";
		datetype=1;
		dif=0;
		date_orig="今天";
	}
	
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"AttendanceReport","hrmId":id,"date":date,"datetype":datetype,"dif":dif},
	    dataType: "json",  
	    success:function (data) {
	    	var name=otherJson.name;
	    	hideToast();
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		 if(data.result==0){
	    			var str="查询考勤报表失败";
					play(str);
					$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
					saveHistory();
	    		}else if(data.result==-1){
	    			var str=data.msg;
					play(str);
					$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
					saveHistory();
	    		}else if(data.htmlStr){
	    			var fromDate=data.fromDate;
	    			var toDate=data.toDate;
	    			var showDate="";
	    			if(fromDate==toDate){
	    				showDate=fromDate;
	    			}else{
	    				showDate=fromDate+"至"+toDate;
	    			}
	    			var people=otherJson.name;
	    			var str="以下是您"+date_orig+"的考勤情况";
	    			if(people){
	    			 	str="以下是"+people+date_orig+"的考勤情况";
	    			}
					play(str);
					str="以下是您"+date_orig+"("+showDate+")的考勤情况";
	    			if(people){
	    			 	str="以下是"+people+date_orig+"("+showDate+")的考勤情况";
	    			}
					$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result">'+data.htmlStr+'</div>');
					saveHistory();
	    		}
	    	}
	    }
    });
}

//微博列表
function blogList(id,timeTag,otherJson){
	ToastLoading("加载中...");
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"viewBlog","operation":"viewBlog","blogid":id,"userid":userid},
	    dataType: "json",  
	    success:function (data) {
	    	hideToast();
	    	var name=otherJson.name;
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		if(data.status<=0){
	    			var str="对不起,您没有权限查看"+name+"的微博";
					play(str);
					$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
					saveHistory();
	    		}else{
	    			var str="以下是您最近五天的微博";
	    			if(name){
	    			 	str="以下是"+name+"最近五天的微博";
	    			}
					play(str);
	    			$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result">'+showBlog(data.userInfo,data.discessList,5)+'</div>');
	    			saveHistory();
	    		}
	    	}
	    	
	    }
    });
}
//微博统计. 填写人员和未填写人员.
function blogReport(InstructObj,baseJson,timeTag){
	ToastLoading("加载中...");
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"blogReport","who":baseJson.who,"date":baseJson.date},
	    dataType: "json",  
	    success:function (data) {
	    	hideToast();
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		 if(data.result==1){
	    		 	var nextTs=new Date().getTime();
    		 		var str="以下是微博填写情况，"+data.writtenCount+"人填写，"+data.unRrittenCount+"人未填写";
    		 		play(str);
    		 		$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result blogReport" id="result'+timeTag+'"></div><div class="otherInfo" id="otherInfo'+timeTag+'"><div id="doAction'+timeTag+'" class="rectangle rounded  doAction currentDoAction" style="margin-top:0px;"></div></div>');
    		 		$("#result"+timeTag).append(blogReportItem("填写人员",data.writtenUsers,timeTag,1,nextTs)+blogReportItem("未填写人员",data.unRrittenUsers,timeTag,0,nextTs));
    		 		//调试通过。等客户端版本升级
    		 		if(data.unRrittenCount==0){
    		 			$("#otherInfo"+timeTag).remove();
    		 		}else{
    		 			$("#doAction"+timeTag).html("给未填写人员发送提醒");
    		 			//增加点击事件. 只能点击一次.
    		 			$("#doAction"+timeTag).off("tap").on("tap",function(){
    		 				if($('#result'+timeTag).attr("rscObj")){
								var rscObj=JSON.parse($('#result'+timeTag).attr("rscObj"));
    		 					sendEmsgImmediately(rscObj.hrmid,"请填写微博",timeTag);
    		 				}else{
    		 					ToastInfo("发送失败!",1);
    		 				}
    		 				$("#doAction"+timeTag).off("tap");
    		 				$("#doAction"+timeTag).removeClass("currentDoAction");
    		 				saveHistory();
    		 			});
    		 		}
	    		 }else{
    		 		var str="对不起，没有找到相关数据";
    		 		play(str);
    		 		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result" ></div>');
	    		 }
	    	}
	    	saveHistory();
	    }
    });
}

//展示微博统计单元
function blogReportItem(showStr,users,timeTag,isWrite,nextTs){
 	var htmlStr="<div class='reportItemDiv' style='line-height:35px;'>";
 	htmlStr+="<div class='lineTips' >"+showStr+"</div>";
	if(users.length==0){
		htmlStr+="<div class='lineBottom lastLi'><div class='labelName reportLabelName'>无</div><div></div></div>";
	}else{
		var rscStatic="";
		$.each(users,function(j,ret){
			var isLastLi=(j==users.length-1)?"lastLi":"";
			var isnewLine=j%2==0;
			//增加人员点击事件,查看微博.
 			var str={};
			str.text=ret.lastname;
			str.rc="0";
			str.service="NativeAction";
			str.CannotEdit=true;
			str.action="blogList";
			str.id=ret.id;
			str.name=ret.lastname;
			str.nextTs=nextTs;
			str.replaceText=true;
			str.needAction=true;//需要执行action
	
			if(isnewLine){
				htmlStr+="<div class='lineBottom "+isLastLi+"' style='height: 50px;line-height: 50px;'>";
				htmlStr+="<div class='labelName reportLabelName' deepObj='"+JSON.stringify(str)+"' onclick='deepUnderstand(this)'>"+ret.lastname +"</div>";
			}else{
				htmlStr+="<div class='labelName reportLabelName' deepObj='"+JSON.stringify(str)+"' onclick='deepUnderstand(this)'>"+ret.lastname +"</div>";
				htmlStr+="</div>";
			}
			if(j==users.length-1&&isnewLine){//最后一条数据且新起一行.
				htmlStr+="</div>";
			}
			if(isWrite==0){
				rscStatic+=(rscStatic==""?"":",") +ret.id;
			}
		});
		if(rscStatic!=""){
			var hrmObj={};
			hrmObj.hrmid=rscStatic;
			$("#result"+timeTag ).attr("rscObj",JSON.stringify(hrmObj))
		}
	}
	htmlStr+="</div>";
	return htmlStr;
}

//筛选可用会议室
function loadMeetingAddress(timeTag,InstructObj,msg,jsonData){
	key="";
	if(jsonData&&jsonData.key){
		key=jsonData.key;
	}
	ToastLoading("加载中...");
	//加载新会议室前,移除之前会议室的选择
	removeMeetingRoomTap();
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
	    data:{"type":"loadMeetingAddress","begindate":InstructObj.begindate,"begintime":InstructObj.begintime,"enddate":InstructObj.enddate,"endtime":InstructObj.endtime,"key":key},
	    dataType: "json",  
	    success:function (data) {
	    	hideToast();
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
				if(data.result==1){
					var str="请选择会议地点，您可以说出会议室关键字进行进一步筛选。如需取消，请说“退出”";
					if(msg&&msg!=""){
						str=msg;
					}
					play(str);
					$("#anser"+timeTag).html("");
					if(data.size>0){
		    			var listSize=data.size;;
		    			var pagesize=5; 
				    	var page=Math.ceil(listSize/pagesize);
					    if(page>1){
					    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364;">';
					    	var pageHtml='<div class="otherInfo" style="padding-bottom: 10px;"><div class="morePage" style="width:'+15*page+'px">'
					    	for (var i=0;i<page;i++){
					    		if(i==0){
					    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
					    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
					    		}else{
					    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
					    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
					    		}
					    	}
					    	resultHtml+='</div>';
					    	pageHtml+='</div>';
					    	 
						    pageHtml+='</div>';
					    	$("#anser"+timeTag).append(resultHtml);
					    	$("#anser"+timeTag).append(pageHtml);
				    	}else{
				    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
				    	}

						$.each(data.list,function(j,item){
							var currentPage=Math.ceil((j+1)/pagesize);
							var isLast=(((j+1)%pagesize)==0||j==listSize-1)?"1":"0";
							if(page==1) isLast="0";
							$("#listview_"+currentPage+"_"+timeTag).append(showMeetingAddress(item,isLast,0));
							 
						});
						
	    			}
	    			if(data.size==0){
	    				$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'"></div></div>');
	    			}
					//自定义会议室
					$("#anser"+timeTag).append('<div class="tips"></div><div class="result"><div id="suggestListview'+timeTag+'"></div></div>');
					var item={};
					item.id="";
					item.name="自定义会议地点";
					$("#suggestListview"+timeTag).append(showMeetingAddress(item,1,1));
						
					//添加点击事件
					meetingRoomTap();
					
					setTimeout(function(){
						$("#result"+timeTag ).height($('.result-current-ul').height());
						
						swipeList($("#result"+timeTag ));
						
						saveHistory();
					},200);
						
				}else{
					var str="对不起,会议室查询异常";
					play(str);
					$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
					saveHistory(); 
				}
	    	}
	    	
	    }
    });
}

//显示会议地点
function showMeetingAddress(item,isLast,isCus){
	var icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_meetingAddress_wev8.png';
	if(item.used==1){
		icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_meetingAddress_used_wev8.png';
	}
	if(isCus=="1"){
		icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_meetingCusAddress_wev8.png';
	}
	var css=isLast=="1"?"lastLi":"";
	var htmlStr='<div class="am-list-item meetingAddress currentMeetingAddress '+css+'" itemid="'+item.id+'" itemname="'+item.name+'" isCus="'+isCus+'">'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img">'+
							 	'<img src="'+icon+'">'+
							'</span>'+
							'<div class="ul-li-div" style="margin-top: 0px;margin-left: 75px;">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80" style="line-height: 46px;">'+item.name+'</span></div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}
//会议室点击事件
function meetingRoomTap(){
	$('.currentMeetingAddress').off("tap");
	$('.currentMeetingAddress').on("tap",function(){
		var itemid=$(this).attr("itemid");
		var itemname=$(this).attr("itemname");
		var isCus=$(this).attr("isCus");
			    	
		removeMeetingRoomTap();
		var str="{'text':'"+itemname+"','rc':'0','service':'SelectAddress','itemid':'"+itemid+"','isCus':'"+isCus+"'}";
		voiceBackUnderstand(str);
	});
}
//移除会议室点击事件
function removeMeetingRoomTap(){
	$('.currentMeetingAddress').off("tap");
	$('.currentMeetingAddress').removeClass("currentMeetingAddress");
}


//显示会议列表信息
function showMeeting(item,isLast){
	var icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_meeting_wev8.png';
	var css=isLast=="1"?"lastLi":"";
	var htmlStr='<div class="am-list-item meeting '+css+'">'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img">'+
							 	'<img src="'+icon+'">'+
							'</span>'+
							'<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+item.simpleTitle+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item.simpleDesc+'</span></div>'+
							'</div>'+
							'<div class="wf_content_item meeting_content_item">'+
								'<div class="wf_label" style="padding-left: 0px;">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">会议时间:</span>'+
								'</div>'+
								'<div class="wf_field wf_datetime">'+
									'<div class="wf_time">'+item.begindate+' '+item.begintime+'</div>'+
								  	'<div class="wf_time">'+item.enddate+' '+item.endtime+'</div>'+
								'</div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}

//显示刚创建的会议
function showCreateMeeting(item,isLast){
	var icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_meeting_wev8.png';
	var css=isLast=="1"?"lastLi":"";
	var htmlStr='<div class="am-list-item meeting '+css+'">'+
					'<div class="am-list-line">'+
						'<div>'+
							'<span class="ul-li-div-img">'+
							 	'<img src="'+icon+'">'+
							'</span>'+
							'<div class="ul-li-div">'+
							   '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80">'+item.simpleTitle+'</span></div>'+
							   '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item.simpleDesc+'</span></div>'+
							'</div>'+
							'<div class="wf_content_item meeting_content_item">'+
								'<div class="wf_label" style="padding-left: 0px;">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">会议时间:</span>'+
								'</div>'+
								'<div class="wf_field wf_datetime">'+
									'<div class="wf_time">'+item.begindate+' '+item.begintime+'</div>'+
								  	'<div class="wf_time">'+item.enddate+' '+item.endtime+'</div>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item meeting_content_item">'+
								'<div class="wf_label" style="padding-left: 0px;">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">会议地点:</span>'+
								'</div>'+
								'<div class="wf_field">'+
									'<span class="ui-li-span ui-li-span100 wf_field_font">'+item.address+'</span>'+
								'</div>'+
							'</div>'+
						'</div>'+
					'</div>'+
  				'</div>';
  	return htmlStr;
}

//提交查询结果不是想要的
function intoFAQ() {
     if($('.askCurrent')&&$('.askCurrent').length>0){
     	var obj=$('.askCurrent');
     	if($('.askCurrent').html()!=''){
     		var editDiv=$(obj).find(".keyDiv");
     		var ask=trimQuotes($(editDiv).html()).replaceAll("</?[^>]+>", "");;
     		if(ask!=''){
     			var a=confirm("不是我想要的答案\n确认提交?");
     			if(a==true){
		     		jQuery.ajax({
						type: "post",
					    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
					    data:{"type":"insertFAQ","ask":ask},
					    dataType: "json",  
					    success:function (data) {
					    	ToastInfo('问题已提交',0.5);
					    }
				    });
     			}else{
     				ToastInfo('取消提交',1);
     			}
     		}else{
     			ToastInfo('您还未查询不能提交',1);
     		}
     	}else{
     		ToastInfo('您还未查询不能提交',1);
     	}
     }
}

//弹出选择地图进行导航
function navigation(obj){
	var currentCity="";
	var currentLat="";
	var currentLng="";
	if($('#hideLocation').attr("currentLocation")){
		var currentLocation=JSON.parse($('#hideLocation').attr("currentLocation"));
		if(currentLocation&&currentLocation.city){
			currentCity=currentLocation.city;
		}
		if(currentLocation&&currentLocation.lat){
			currentLat=currentLocation.lat;
		}
		if(currentLocation&&currentLocation.lng){
			currentLng=currentLocation.lng;
		}
	}
	if($(obj).attr("obj")){
		var data=JSON.parse($(obj).attr("obj"));
		if(data.address){
	    	location='emobile:navigation:'+currentLat+':'+currentLng+':'+data.lat+':'+data.lng+':'+data.address;
    	}else{
    		ToastInfo("地址无效",1);
    	}
	}else{
		var address=$(obj).attr("address");
		ToastLoading("加载中...");
		jQuery.ajax({
			type: "post",
		    url: "/mobile/plugin/fullsearch/locationUtil.jsp",
		    data:{"type":"geo","address":address,"currentCity":currentCity},
		    dataType: "json",  
		    success:function (data) {
		    	hideToast();
		    	$(obj).attr("obj",JSON.stringify(data));
		    	if(data.address){
			    	location='emobile:navigation:'+currentLat+':'+currentLng+':'+data.lat+':'+data.lng+':'+data.address;
		    	}else{
		    		ToastInfo("地址无效",1);
		    	}
		    	saveHistory();
		    }
    	});	
	}
}
	
//通过地址找附近导航标识
function findPlace(obj){
	if($(obj).attr("obj")){
		var data=JSON.parse($(obj).attr("obj"));
		if(data.address){
	    	var address=$(obj).attr("address");
			var str="{'text':'"+address+"','rc':'0','service':'NativeAction','action':'findPlace'}";
			voiceBackUnderstand(str);
    	}else{
    		ToastInfo("地址无效",0.5);
    	}
	}else{
		var currentCity="";
		if($('#hideLocation').attr("currentLocation")){
			var currentLocation=JSON.parse($('#hideLocation').attr("currentLocation"));
			if(currentLocation&&currentLocation.city){
				currentCity=currentLocation.city;
			}
			if(currentLocation&&currentLocation.lat){
				currentLat=currentLocation.lat;
			}
			if(currentLocation&&currentLocation.lng){
				currentLng=currentLocation.lng;
			}
		}
	
		var address=$(obj).attr("address");
		ToastLoading("加载中...");
		jQuery.ajax({
			type: "post",
		    url: "/mobile/plugin/fullsearch/locationUtil.jsp",
		    data:{"type":"geo","address":address,"currentCity":currentCity},
		    dataType: "json",  
		    success:function (data) {
		    	hideToast();
		    	$(obj).attr("obj",JSON.stringify(data));
		    	if(data.address){
		    		var address=$(obj).attr("address");
					var str="{'text':'"+address+"','rc':'0','service':'NativeAction','action':'findPlace'}";
					voiceBackUnderstand(str);
		    	}else{
		    		ToastInfo("地址无效",0.5);
		    	}
		    	saveHistory();
		    }
    	});	
	}
}

function getWeatherIconName(weather){
	var name=getWeatherIcon(weather);
	if(name=="na"){
		if(weather.indexOf("到")>-1){
			name=getWeatherIcon(weather.substring(0,weather.indexOf("到")));
		}else if(weather.indexOf("转")>-1){
			name=getWeatherIcon(weather.substring(0,weather.indexOf("转")));
		}
	}
	return name;
}
 
function getWeatherIcon(weather){
	if(weather=="晴"){
		return "00";
	}else if(weather=="多云"){
		return "01";
	}else if(weather=="阴"){
		return "02";
	}else if(weather=="阵雨"){
		return "03";
	}else if(weather=="雷阵雨"){
		return "04";
	}else if(weather=="雷阵雨伴有冰雹"){
		return "05";
	}else if(weather=="雨夹雪"){
		return "06";
	}else if(weather=="小雨"){
		return "07";
	}else if(weather=="中雨"){
		return "08";
	}else if(weather=="大雨"){
		return "09";
	}else if(weather=="暴雨"){
		return "10";
	}else if(weather=="大暴雨"){
		return "11";
	}else if(weather=="特大暴雨"){
		return "12";
	}else if(weather=="阵雪"){
		return "13";
	}else if(weather=="小雪"){
		return "14";
	}else if(weather=="中雪"){
		return "15";
	}else if(weather=="大雪"){
		return "16";
	}else if(weather=="暴雪"){
		return "17";
	}else if(weather=="雾"){
		return "18";
	}else if(weather=="冻雨"){
		return "19";
	}else if(weather=="沙尘暴"){
		return "20";
	}else if(weather=="浮尘"){
		return "29";
	}else if(weather=="扬沙"){
		return "30";
	}else if(weather=="强沙尘暴"){
		return "31";
	}else if(weather=="霾"){
		return "53";
	}else{
		return "na";
	}
}


//显示天气预报
function showWeather(timestamp,data,datetime){
	var currentData=data[0];
	var selectDate=datetime.date;
	var playStr=currentData.city+",";
	if(selectDate=="CURRENT_DAY"){
		selectDate=nowDateStr;
	}
	var updateTime=currentData.lastUpdateTime;
	
	var currentSelectIndex=0;//读取索引下标
	var showItemNum=4;//显示数量
	var dif=0;//偏移量
	var inRange=false;
	var containToday=false;
	//判断查询日期是否在返回数据范围
	$.each(data,function(j,item){
		if(item.date==selectDate){
			inRange=true;
			currentSelectIndex=j;
		}
	});    
	
	if((currentSelectIndex+1)>showItemNum){
		dif=currentSelectIndex-showItemNum+1;
	}
	var hasItem=0;
	$.each(data,function(j,item){
		if(j>=dif&&hasItem<showItemNum){
			hasItem++;
			if(item.date==nowDateStr){
				containToday=true;
			}
		}
	});
	var p2=containToday?('湿度：'+	currentData.humidity):('温度：'+currentData.tempRange);		
	var html='<div class="weatherDiv">'+
				'<div class="title_div">'+
				    '<ul class="wendu">'+
				        '<li class="font_size20">'+currentData.city+' ('+(containToday?'当前':'今天')+')</li>'+
				        '<li>'+
				            '<p class="font_size14 p1 clear">'+p2+'</p>'+
				            '<p class="font_size14 p2 clear">空气质量：'+currentData.airQuality+'</p>'+
				        '</li>'+
				    '</ul>'+
				    '<ul class="text">'+
				          '<li><img src="/mobile/plugin/fullsearch/img/weather/'+getWeatherIconName(currentData.weather)+'.png" width="70" height="70"></li>'+
				          '<li><span class="font_size14">'+currentData.weather+'</span></li>'+
				    '</ul>'+
			    '</div>'+
			    '<ul class="data clear">';
				 
				
				//过滤不显示的
				var hasItem=0;
				var isfirst=true;
				$.each(data,function(j,item){
					if(j>=dif&&hasItem<showItemNum){
						hasItem++;
						
						var tempdate=new Date(item.date.replace(/-/g,"/"));
						var weekday="";
						if(item.date==nowDateStr)
							weekday="今天";
						else   
							weekday=weekStr(tempdate.getDay()+"");
						
						var showDay=(tempdate.getMonth()+1)+"月"+tempdate.getDate()+"日";
						if(j==currentSelectIndex){
							if(weekday=="今天"){
								playStr+="今天,天气";
							}else{
								playStr+=showDay+",天气";
							}
							playStr+=item.weather+",温度"+item.tempRange;
						}
						
						html+= showWeatherItem(item,weekday,showDay,j==currentSelectIndex,isfirst);
						isfirst=false;
					}
				});	    
					      
				html+='</ul>'+
					  '<p id="qixiangqu" class="p3" style="clear:both;">今天'+updateTime.substring(11,13)+'时发布</p>'+
				   '</div>';
		if(!inRange){
			playStr="抱歉，我没法查看太远的天气情况，以下是最近4天的天气情况";
		}
		play(playStr);
		$("#anser"+timestamp).append('<div class="tips"></div><div class="result" >'+html+'</div>');
		hideToast();
}

function showWeatherItem(item,weekday,showDate,isCurrent,isFirst){
	var html='<li style="'+(isFirst?'border-left:0px':'')+'">'+
	            '<p class="'+(isCurrent?'weatherDataP':'')+'">'+weekday+'</p>'+
	            '<p class="'+(isCurrent?'weatherDataP':'')+'">'+showDate+'</p>'+
	            '<p class="'+(isCurrent?'weatherDataP':'')+'"><img src="/mobile/plugin/fullsearch/img/weather/'+getWeatherIconName(item.weather)+'.png" width="40" height="40"></p>'+
	            '<p class="'+(isCurrent?'weatherDataP':'')+'">'+item.tempRange+'</p>'+
	            '<p class="'+(isCurrent?'weatherDataP':'')+'">'+item.weather+'</p>'+
	        '</li>';
 	return html;
}

//机票查询
function showFlightList(InstructObj,otherJson,timeTag){
	ToastLoading("加载中...");
	var url=otherJson.slots.url;
	
	var queryData={};
	queryData.begindate=InstructObj.begindate;
	if(InstructObj.begintime){
		queryData.begintime=InstructObj.begintime;
	}
	if(InstructObj.enddate){
		queryData.enddate=InstructObj.enddate;
	}
	if(InstructObj.endtime){
		queryData.endtime=InstructObj.endtime;
	}
	queryData.startLoc=InstructObj.startLoc;
	queryData.endLoc=InstructObj.endLoc;
	 
	//url跟上随机串.
	if(url.indexOf("?")>-1){
		url+="&random="+new Date().getTime();
	}else{
		url+="?random="+new Date().getTime();
	}
	var dateStr= queryData.begindate+"的";
	jQuery.ajax({
		type: "post",
	    url: url,
	    data:queryData,
	    dataType: "json",  
	    success:function (data) {
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	} else { 
	    		var retFlag=otherJson.slots.retFlag;
			
				var showSize=50;//最多显示数据条数. 不分页时使用
				var total=0;
				var size=data[retFlag.RetList].length;//当前页返回条数.
				total=size;//总条数
				
				var showMore=false;
				var str="为您找到"+dateStr+total+"个航班,请选择";
				if(total==0){
					str="对不起,没有找到您要的航班数据";
				}else{
					if(total>showSize){
						str="为您找到"+dateStr+total+"个航班，以下是前50条";
					}
				}
			 			
				if(total==0){
					$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'"></div></div>');
				}else if(total>0){
					var listSize=total>showSize?showSize:total;
					var eachpagesize=5; //每页5条数据
			    	var page=Math.ceil(listSize/eachpagesize);
				    if(page>1){
				    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative;height:364px;">';
				    	var pageHtml='<div class="otherInfo" style="padding-bottom: 10px;"><div class="morePage" style="width:'+15*page+'px">'
				    	for (var i=0;i<page;i++){
				    		if(i==0){
				    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
				    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
				    		}else{
				    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
				    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
				    		}
				    	}
				    	resultHtml+='</div>';
				    	pageHtml+='</div>';
				    	pageHtml+='</div>';
				    	$("#anser"+timeTag).append(resultHtml);
				    	$("#anser"+timeTag).append(pageHtml);
			    	}else{
			    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			    	}
					
					
					$.each(data[retFlag.RetList],function(j,item){
						var currentPage=Math.ceil((j+1)/eachpagesize);
						var isLast=(((j+1)%eachpagesize)==0||j==total-1||j==listSize-1)?"1":"0";
						$("#listview_"+currentPage+"_"+timeTag).append(showFlightItem(item,isLast,otherJson.slots.retList,retFlag,timeTag));
						
					});
					$('#result'+timeTag).css("height",$('#result'+timeTag).find('.result-current-ul').height()+"px");
				}
				play(str);
				
				swipeList($("#result"+timeTag ));
				saveHistory();
				flightChooseTap();
				hideToast();
	    	}
	    }
	});

}

//航班展示
function showFlightItem(item,isLast,retList,retFlag,ts){	
	//显示小图标.0表示没有小图标
	var item_icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_flight_wev8.png';
	var schema='FlightChoose';
	var css=isLast=="1"?"lastLi":"";
	var showItemStyle=1;
	
	var item_id="";
	var item_price="";
	var item_vale=["","","","",""];
	var maxItemSize=5;
 
	var itemSize=0;	
	$.each(retList,function(j,ret){
		if(ret.defaultV=="ID"){//唯一值
			item_id=item[ret.name];
		}else if(ret.defaultV=="PRICE"){//价格字段
			item_price=item[ret.name];
		}else{
			if(itemSize<maxItemSize){
				//除开几个特殊字段指定,其他可以使用带参.
				if(ret.defaultV!=""&&ret.defaultV!="ID"){
					var key=ret.name;
					var showStr=ret.defaultV;//默认值.
					showStr=showStr.replaceAll("#x20;","&nbsp;");
					var keys=key.split(",");
					for(var i in keys){
						showStr=showStr.replace("{"+keys[i]+"}",item[keys[i]]);
					}
					item_vale[itemSize++]=showStr;
				}else{
					item_vale[itemSize++]=item[ret.name];
				}
			}
		}
	});
	
	
	var itemObj={};
	itemObj.id=item_id;
	itemObj.price=item_price;
	itemObj.item0=item_vale[0];
	itemObj.item1=item_vale[1];
	itemObj.item2=item_vale[2];
	itemObj.item3=item_vale[3];
	itemObj.item4=item_vale[4];
	
	var htmlStr='<div class="am-list-item '+schema+' '+css+'" itemObj=\''+JSON.stringify(itemObj)+'\' ts="'+ts+'">'+
				'<div class="am-list-line">'+
					'<div class="am-list-content">'+
						'<span class="ul-li-div-img">'+
						 	'<img src="'+item_icon+'" >'+
						'</span>'+
			    		'<div class="ul-li-div">'+
			    			'<div class="ul-li-div-first" style="height:46px;width: 80px;float:left;">'+
								'<span class="ui-li-span ui-li-span-heading ui-li-span100" style="font-size:18px;">'+item_vale[0]+'</span>'+
								'<span class="ui-li-span ui-li-span100">'+item_vale[2]+'</span>'+
							'</div>'+
							'<div class="flightLine"></div>'+
							'<div class="ul-li-div-first" style="width: 80px;float: left;height: 46px;"> '+
								'<span class="ui-li-span ui-li-span-heading ui-li-span100" style="font-size:18px;">'+item_vale[1]+'</span>'+
								'<span class="ui-li-span ui-li-span100">'+item_vale[3]+'</span>'+
							'</div>'+
						   '<div class="ul-li-div-second" style="margin-top: 46px;width: 100%;"> <span class="ui-li-span ui-li-span80 ">'+item_vale[4]+'</span></div>'+
						'</div>'+
						'<span class="wordcolor" style="width: 58px;position: absolute;right: 10px;text-align: center;font-size: 18px;top: 25px;">'+
						 	'<p style="margin: 5px 0 0 0;">'+item_price+'</p>'+
						'</span>'+
							
					'</div>'+
				'</div>'+
 				'</div>';
  	return htmlStr;
}
//机票注册选择.
function flightChooseTap(){
	
	$('.FlightChoose').off("tap");
	$('.anserCurrent').find('.FlightChoose').on("tap",function(){
		$('.FlightChoose').off("tap");
		if($(this).attr("itemObj")){
			var itemObj=JSON.parse($(this).attr("itemObj"));
			var timeTag=$(this).attr("ts");
			var str="请确认航班";
			play(str);
			$("#anser"+timeTag).html('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			$("#listview_1_"+timeTag).append(FlightComfirm(itemObj,timeTag));
			
			setTimeout(function(){
				//注册 btn事件
				$("#listview_1_"+timeTag).find('.cancelBtn').off("tap").on("tap",function(){
					play("机票预订已取消");
					$("#anser"+timeTag).html('<div class="tips">机票预订已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
					saveHistory();
				});
				
				$("#listview_1_"+timeTag).find('.OkBtn').off("tap").on("tap",function(){
					ToastLoading("正在提交");
					
					setTimeout(function(){
						play("好的，已经帮您递交申请，后续将会通知您。");
						$("#anser"+timeTag).html('<div class="tips">好的，已经帮您递交申请，后续将会通知您。</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
						hideToast();
						saveHistory();
					},1000)
					
		
				});
			},500);
			
			
			saveHistory();
		
			
		}
	})
}

//航班确认
function FlightComfirm(item,timeTag){
	var item_icon='/mobile/plugin/fullsearch/img/'+pageStyle+'v_flight_wev8.png';
	var htmlStr='<div class="confirm_div flight_confirm_div" ts="'+timeTag+'">'+
					'<div style="height: 145px;">'+
						'<div class="am-list-item lastLi">'+
							'<div class="am-list-line">'+
								'<div class="am-list-content">'+
									'<span class="ul-li-div-img">'+
									 	'<img src="'+item_icon+'" >'+
									'</span>'+
						    		'<div class="ul-li-div">'+
						    			'<div class="ul-li-div-first" style="height:46px;width: 80px;float:left;">'+
											'<span class="ui-li-span ui-li-span-heading ui-li-span100" style="font-size:18px;">'+item.item0+'</span>'+
											'<span class="ui-li-span ui-li-span100">'+item.item2+'</span>'+
										'</div>'+
										'<div class="flightLine"></div>'+
										'<div class="ul-li-div-first" style="width: 80px;float: left;height: 46px;"> '+
											'<span class="ui-li-span ui-li-span-heading ui-li-span100" style="font-size:18px;">'+item.item1+'</span>'+
											'<span class="ui-li-span ui-li-span100">'+item.item3+'</span>'+
										'</div>'+
									   '<div class="ul-li-div-second" style="margin-top: 46px;width: 100%;"> <span class="ui-li-span ui-li-span80 ">'+item.item4+'</span></div>'+
									'</div>'+
									'<span class="wordcolor" style="width: 58px;position: absolute;right: 10px;text-align: center;font-size: 18px;top: 25px;">'+
									 	'<p style="margin: 5px 0 0 0;">'+item.price+'</p>'+
									'</span>'+
								'</div>'+
							'</div>'+
						'</div>'+
						
						'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
			 				 '<div class="Btn cancelBtn">取消</div>'+
			  				 '<div class="Btn OkBtn">确定</div>'+
						'</div>'+
					'</div>'+
			'</div>';
	return htmlStr;
}

//清除确认框
function clearFlightConfirm(){
	if($('.flight_confirm_div')&&$('.flight_confirm_div').length>0){
		var ts=$('.flight_confirm_div').attr("ts");
		$("#anser"+ts).html('<div class="tips">机票预订已取消</div><div class="result"><div ts="'+ts+'" id="listview_1_'+ts+'"></div></div>');
		saveHistory();
	}
}


//打开扫一扫功能.暂不支持..
function scanQR(InstructObj,baseJson,timestamp){
	hideToast();
    currentTimeTag=timestamp;
    saveHistory();
    var url = "emobile:QRCode:scanQRResponse";			
    location = url; 
}
//扫描回调
function scanQRResponse(result){
	if(result.startWith("ecologylogin:")){
		var timeTag=currentTimeTag;
		var str="扫描登录确认";
		play(str);
		$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		
		var htmlStr='<div class="confirm_div" ts="'+timeTag+'">'+
							'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
				 				 '<div class="Btn cancelBtn">取消</div>'+
				  				 '<div class="Btn OkBtn">确定</div>'+
							'</div>'+
						'</div>'+
				'</div>';
		
		$("#listview_1_"+timeTag).append(htmlStr);
		
		
		//注册 btn事件
		$("#listview_1_"+timeTag).find('.cancelBtn').off("tap").on("tap",function(){
			noScroll=true;
			play("登录已取消");
			$("#anser"+timeTag).html('<div class="tips">登录已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			saveHistory();
		});
		
		$("#listview_1_"+timeTag).find('.OkBtn').off("tap").on("tap",function(){
			ToastLoading("登录中...");
			//内容完整.直接新建.
			jQuery.ajax({
				type: "post",
			    url: "/mobile/plugin/login/QCLoginManagerOperation.jsp?loginkey="+result.replace("ecologylogin:",""),
			    success:function (data) {
			    	hideToast();
			    	//去除空格.
			    	data=data.replace(/[\r\n]/g,"").replace(/[ ]/g,"");
			    	var retStr="登录成功";
			    	if(data=="1"){
			    		retStr="登录成功";
			    	}else{
			    		retStr="登录失败";
			    	}
		    		$("#anser"+timeTag).html('<div class="tips">'+retStr+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			    	play(retStr);
					saveHistory();
			    }
			});
		});
		currentTimeTag="";
	}else if(result.startWith("/mobile/plugin/")||result.startWith("http:")||result.startWith("https:")){
		currentTimeTag="";
		saveHistory();
	    openNewView(result);
	}else{
	    $("#anser"+currentTimeTag).html('<div class="tips">'+result+'</div><div class="result"><div ts="'+currentTimeTag+'"></div></div>');
	    currentTimeTag="";
	    saveHistory();
	}
}


//记账,确认框
function BillNoteConfirm(InstructObj,baseJson,timeTag){
	var str="为您记一笔，请确认";
	play(str);
	$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	
	var htmlStr='<div class="confirm_div accountNote_confirm_div" ts="'+timeTag+'">'+
					'<div class="wf_top">'+
						'<div class="am-list-line">'+
							'<div>'+
								'<span class="ul-li-div-img"><img src="/mobile/plugin/fullsearch/img/'+pageStyle+'v_billnote_wev8.png"></span>'+
								'<div class="ul-li-div" style="margin-left: 75px;margin-top: 0px;line-height: 46px;">'+
									'<span class="ui-li-span ui-li-span-heading ui-li-span80">记一笔</span>'+
								'</div>'+
							'</div>'+
						'</div>'+
					'</div>'+
					'<div style="height:100px;">'+
							'<div class="wf_content_item wf_content_item30" style="margin-top: 5px;">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">金额:</span>'+
								'</div>'+
								'<div class="wf_field wf_content wf_content30">'+
									'<div class="wf_content_inner wf_content_inner30 wf_amount_str" contentEditable="true">'+InstructObj.amount+'</div>'+
								'</div>'+
							'</div>'+
							'<div class="wf_content_item">'+
								'<div class="wf_label">'+
									 '<span class="ui-li-span ui-li-span100 wf_label_font">说明:</span>'+
								'</div>'+
								'<div class="wf_field wf_content">'+
									'<div class="wf_content_inner wf_remark_str" contentEditable="true">'+(InstructObj.content?InstructObj.content:"")+'</div>'+
								'</div>'+
							'</div>'+
						'</div>'+
						'<div class="" style="width: 200px;margin: auto;line-height: 30px;height: 50px;">'+
			 				 '<div class="Btn cancelBtn">取消</div>'+
			  				 '<div class="Btn OkBtn">确定</div>'+
						'</div>'+
					'</div>'+
			'</div>';
	
	$("#listview_1_"+timeTag).append(htmlStr);
	//设置编辑域宽度
	$("#listview_1_"+timeTag).find('.wf_content').css("width",(wW-90)+"px");
	//注册内容编辑事件
	$("#listview_1_"+timeTag).find('.wf_content').off("tap").on("tap",function(){
		var editDiv=$(this).find(".wf_content_inner");  
		$(editDiv).unbind("focus").unbind("blur");
		$(editDiv).focus(function(){
			noScroll=false;
			$(editDiv).attr("contentEditable","true");
		    $('.voicefooter').hide();
		}).blur(function(){
			noScroll=true;
			$(editDiv).attr("contentEditable","false");
		    showVoicefooter();
		});
		
		$(editDiv).focus();
	});
	
	
	//注册 btn事件
	$("#listview_1_"+timeTag).find('.cancelBtn').off("tap").on("tap",function(){
		noScroll=true;
		play("记一笔已取消");
		$("#anser"+timeTag).html('<div class="tips">记一笔已取消</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
		saveHistory();
	});
	
	$("#listview_1_"+timeTag).find('.OkBtn').off("tap").on("tap",function(){
		noScroll=true;
		var content=$("#listview_1_"+timeTag).find(".wf_remark_str").text();
		var amount=$("#listview_1_"+timeTag).find(".wf_amount_str").text();
		InstructObj.content=content;
		if(amount!=InstructObj.amount){
			try{
				amount=parseFloat(amount);
				InstructObj.amount=amount;
			}catch(e){}
		}
		
		if(InstructObj.amount&&InstructObj.amount!=""&&InstructObj.content&&InstructObj.content!=""){
			addBillNoteAjax(InstructObj,baseJson,timeTag);
		}else{
			ToastInfo("请输入完整!",1);
		}
		
		
	});
	saveHistory();
}

//保存记一笔数据
function addBillNoteAjax(InstructObj,otherJson,timeTag){
	ToastLoading("保存中...");
	var url=otherJson.slots.url;
	var map=otherJson.slots.map;
	
	var queryData={};
 
	for(var k in map){
		var name=map[k].name;
		if(name=="url"){
		 	continue;
		}
		if(InstructObj[name]!=""&&InstructObj[name]!=undefined){
			queryData[map[k].column]=InstructObj[name];
		}else if(map[k].defaultV!=""){
			if(name=="uri"){
				queryData["uri"]=encodeURIComponent(map[k].defaultV);
			}else{
				queryData[map[k].column]=map[k].defaultV;
			}
		}
	}
 
	//url跟上随机串.
	if(url.indexOf("?")>-1){
		url+="&random="+new Date().getTime();
	}else{
		url+="?random="+new Date().getTime();
	}
	 
	jQuery.ajax({
		type: "post",
	    url: url,
	    data:queryData,
	    dataType: "json",  
	    success:function (data) {
	    	if (data == undefined || data == null) {
	    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
	    		return;
	    	}else{
	    		hideToast();
	    		
	    		var retFlag={};
				if(otherJson.slots.retFlag){
					retFlag=otherJson.slots.retFlag;
				}
				//兼容判断下.成功标识
				if(!retFlag.SuccessF){
					retFlag.SuccessF="msg";
				}
				//兼容判断下. 成功值
				if(!retFlag.SuccessV){
					retFlag.SuccessV="0";
				}
		    		
				var retStr="保存成功";
				if(""+data[retFlag.SuccessF]==retFlag.SuccessV){
					$("#anser"+timeTag).html('<div class="tips">'+retStr+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			    	play(retStr);
					saveHistory();
				}else{
					retStr="保存失败"
					$("#anser"+timeTag).html('<div class="tips">'+retStr+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
			    	play(retStr);
					saveHistory();
				}
	    	}
	    }
	  });
}

//清除确认框
function clearBillNoteConfirm(){
	if($('.accountNote_confirm_div')&&$('.accountNote_confirm_div').length>0){
		var ts=$('.accountNote_confirm_div').attr("ts");
		$("#anser"+ts).html('<div class="tips">记一笔已取消</div><div class="result"><div ts="'+ts+'" id="listview_1_'+ts+'"></div></div>');
		saveHistory();
	}
}



	
//弹出加载提示框,不会自动结束
function ToastLoading(info){
   	var htmlStr='<div data-reactroot="" class="am-toast" style="top: 0px;">'+
				'<span>'+
					'<div class="am-toast-notice">'+
						'<div class="am-toast-notice-content">'+
							'<div class="am-toast-text am-toast-text-icon">'+
								'<i type="loading" class="anticon anticon-loading"></i>'+
								'<div id="toastTxt">'+info+'</div>'+
							'</div>'+
						'</div>'+
					'</div>'+
				'</span>'+
			'</div>';
	$('#toastDiv').html(htmlStr);
}
//弹出提示框,可以指定消失时间,单位秒
function ToastInfo(info,duration){
   	var htmlStr='<div data-reactroot="" class="am-toast" style="top: 0px;">'+
				'<span>'+
					'<div class="am-toast-notice">'+
						'<div class="am-toast-notice-content">'+
							'<div class="am-toast-text">'+
								'<div id="toastTxt">'+info+'</div>'+
							'</div>'+
						'</div>'+
					'</div>'+
				'</span>'+
			'</div>';
	$('#toastDiv').html(htmlStr);
	var delay=3;
	if(duration){
		delay=duration;
	}
	setTimeout(function(){$('.am-toast').remove();},delay*1000);
}

//移除所有弹出提示框   
function hideToast(){
   	$('.am-toast').remove();
}

//日期点击
function getCalendarDate(obj){
	$(".wkp_date_time").css("color","");
	//高亮字体
	$(obj).css("color","#40C2F4");
	var url = "";
	var objvalue = jQuery(obj).attr("date");
	if(!!!objvalue){
		objvalue = "";
	}
	if(objvalue==""){
		objvalue = jQuery(obj).text();
		if(!!!objvalue){
			objvalue = "";
		}
	}
	location.href = "emobile:calender_date:setCalenderValue:"+objvalue+":"+$(obj).attr("id")+":cancelSetCalenderValue";
}
//时间点击
function getCalendarTime(obj){
	$(".wkp_date_time").css("color","");
	//高亮字体
	$(obj).css("color","#40C2F4");
	var url = "";
	var objvalue = jQuery(obj).attr("time");
	if(!!!objvalue){
		objvalue = "";
	}
	if(objvalue==""){
		objvalue = jQuery(obj).text();
		if(!!!objvalue){
			objvalue = "";
		}
	}
	if(objvalue != ""){
		objvalue = objvalue.replace(/:/g,"-").replace(/：/g,"-");
	}
	location.href = "emobile:calender_time:setCalenderValue:"+objvalue+":"+$(obj).attr("id")+":cancelSetCalenderValue";
}
//反写日期和时间
function setCalenderValue(obj,value){
	//恢复字体
	$("#"+obj).css("color","");
	if(value&&value!=""){
		if(value.indexOf(":")>-1){//时间
			$("#"+obj).text(value);
			$("#"+obj).attr("time",value);
		}else{//日期
			var func=$("#"+obj).attr("afterDo");
			if(func){
				$("#"+obj).attr("date",value);
				AfterDateFunction(eval(func),obj,value);
			}else{
				$("#"+obj).text(value);
				$("#"+obj).attr("date",value);
			}
		}
	} 
}
function cancelCalenderColor(){
	$(".wkp_date_time").css("color","");
}

function cancelSetCalenderValue(obj){
	$("#"+obj).css("color","");
}
//反写日期和时间定于的自定义回调方法
function AfterDateFunction(callBackFunction,id,value){
	try{
		callBackFunction(id,value);
	}catch(e){}
}

//获取当前时间+10
function getCurrentTime(){
	var time=new Date();
	time=DateAdd('n',10,time);
	return fixZero(time.getHours())+":"+fixZero(time.getMinutes());
}
//今天之前   true 表示今天之前
function isBeforeToday(date){
	var currentT=new Date();
	return TimeCompare(date,"00:00",getDateStr(currentT),"00:00");
}
//今天之后 true 表示今天之后
function isAfterToday(date){
	var currentT=new Date();
	return TimeCompareNotEqual(getDateStr(currentT),"00:00",date,"00:00");
}
//当前时间之前 true 表示当前时间之前.
function isBeforeNow(date,time){
	var currentT=new Date();
	return TimeCompareNotEqual(date,time,getDateStr(currentT),getTimeStr(currentT));
}
//通过js date 获取日期格式 2017-10-09	
function getDateStr(date){
	return date.getFullYear()+"-"+fixZero(date.getMonth()+1)+"-"+fixZero(date.getDate());
}
//通过js date 获取时间格式 15:08	
function getTimeStr(date){
	return fixZero(date.getHours())+":"+fixZero(date.getMinutes());
}
//判断是否字符串是否相等,忽略大小写
function equalsIgnoreCase(str1,str2){
	return str1.toLowerCase()==str2.toLowerCase();
}
   
//解析获取到时间段
function getTime2Time(timeSlot,InstructObj){
	//判断会议类型是否有效
	jQuery.ajax({
		async: false, 
		type : "POST", 
		url: "/mobile/plugin/fullsearch/ajaxVoice.jsp",
   		data:{"type":"getTimeNLP","timeSlot":timeSlot},
		dataType : 'json', 
		success : function(data) {
			if(data.result==1){
				if(data.date1){
					InstructObj.begindate=data.date1;
				}
				if(data.time1){
					InstructObj.begintime=data.time1;
				}
				if(data.date2){
					InstructObj.enddate=data.date2;
				}
				if(data.time2){
					InstructObj.endtime=data.time2;
				}
			}
		}
	});
	return InstructObj;
} 

//统一时间分析方法  第三个参数表示根据指定time,不需要使用模糊timeEnd
function timeAnalysis(obj,InstructObj){
	var date="";
	if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
	    date=obj.semantic.slots.datetime.date;
	}else if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.begindate){
		date=obj.semantic.slots.datetime.begindate;
	}
	var time="";
	var timeOrig=false;
	if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.time){
	    time=obj.semantic.slots.datetime.time;
	    timeOrig=true;
	}else if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.begintime){
		time=obj.semantic.slots.datetime.begintime;
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
			if(times.lenght>2){
				time=(newHours>9?newHours:"0"+newHours)+":"+times[1]+":"+times[2];
			}else{
				time=(newHours>9?newHours:"0"+newHours)+":"+times[1];
			}
		}
	}
	
	if(date!=""&&time==""){
		time="09:00";
	}
				//写入开始时间.
	if(time!=""){
		InstructObj.begindate=date
		InstructObj.begintime=time;
		
		//判断识别串是否有结束相关内容
		//通过timeNLP识别
		if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.enddate){
			InstructObj.enddate=obj.semantic.slots.datetime.enddate;
		}
		if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.endtime){
			InstructObj.endtime=obj.semantic.slots.datetime.endtime;
		}
	}
	
						
	//是否有时间段识别
	if(obj.semantic.slots.timeSlot){
		InstructObj=getTime2Time(obj.semantic.slots.timeSlot,InstructObj);
	}
	
	//有开始日期,没有结束日期
	if(!InstructObj.enddate&&InstructObj.begindate){
		InstructObj.enddate=InstructObj.begindate;
	}
	
	//如果没有结束时间. 且指明开始时间
	if(!InstructObj.endtime&&obj.semantic.slots.timeEnd&&!timeOrig){
	    InstructObj.endtime=obj.semantic.slots.timeEnd;
	    InstructObj.needComfirmTime=true;
	}
	
	//处理下长度
	if(InstructObj.begintime&&InstructObj.begintime.length>5){
		InstructObj.begintime=InstructObj.begintime.substring(0,5);
	}
	if(InstructObj.endtime&&InstructObj.endtime.length>5){
		InstructObj.endtime=InstructObj.endtime.substring(0,5);
	}
	return InstructObj;
}
//单个日期解析.
function simpleTimeAnalysis(obj){
	var dateTimes=["",""];
	var date="";
	if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.date){
	    date=obj.semantic.slots.datetime.date;
	}else if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.begindate){
		date=obj.semantic.slots.datetime.begindate;
	}
	
	var time="";
	if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.time){
	    time=obj.semantic.slots.datetime.time;
	}else if(obj.semantic.slots.datetime&&obj.semantic.slots.datetime.begintime){
		time=obj.semantic.slots.datetime.begintime;
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
	
	if(time.length>5){
		time=time.substring(0,5);
	}
	dateTimes[0]=date;
	dateTimes[1]=time;
	return dateTimes;
}

//每次都需要判断时间是否过期.
function refreshTime(){
	today=new Date();
	now=new Date();
	nowDateStr=now.getFullYear()+"-"+((now.getMonth()+1)>9?"":"0")+(now.getMonth()+1)+"-"+(now.getDate()>9?"":"0")+now.getDate();
    yesterday=DateAdd('d',-1,today);
    yesterdayStr=yesterday.getFullYear()+"-"+((yesterday.getMonth()+1)>9?"":"0")+(yesterday.getMonth()+1)+"-"+(yesterday.getDate()>9?"":"0")+yesterday.getDate();
    tomorrow=DateAdd('d',1,today);
    tomorrowStr=tomorrow.getFullYear()+"-"+((tomorrow.getMonth()+1)>9?"":"0")+(tomorrow.getMonth()+1)+"-"+(tomorrow.getDate()>9?"":"0")+tomorrow.getDate();
    lastmonth=DateAdd("m",-1,today);
}
//统一的退出按钮
function exitFunction(){
	
}



//--------------以下是voice.jsp页面的js------------
	//查询数据. 目前是找到对应的人.或者流程.
    function load_SP_Data(schema,key,filedname,callBackFunction,timeTag,others,needHideList,noAutoClick,isTimeTag){
    	if(key!=""){
	     	util.getData({
		    	loadingTarget : document.body,
	    		paras : "noauth="+noauth+"&title="+key+"&contentType="+schema+"&pagesize=5&pageindex=1&voice=1&keyword="+key,//得数据的URL,
	    		callback : function (data,passobj){
	    			schema=schema.split(":")[0];
	    			hideToast();
					var errormsg = data.err;
					if(errormsg<0) {
						var msg=data.msg;
						msg=msg.replace("<b style='color:red;'>","").replace("</b>","");
						play(msg);
						return;
					}
					var size=data.list.length;
					var schemaTypeName="";
					var schemaTypeName1="";
					if(schema=="RSC"){
						schemaTypeName="人员";
					}else if(schema=="WFTYPE"||schema=="WF"){
						schemaTypeName1="流程";
					}
					var str="对不起,没有找到"+schemaTypeName+key+schemaTypeName1;//retResultStr[Math.floor(Math.random()*retResultStr.length)];
					
					if(size==0){
						if(others&&others.slots&&others.slots.to_type=="Emsg"){//内部消息,如果没有找到人,可能是群聊
							ToastLoading("加载中...");
							getGroupList(key,timeTag,callBackFunction,others);
							return;			
						}if(callBackFunction&&callBackFunction.name=="showReportUrl"){//查询报表
							//没有找到对应的人. 
							if(others.slots.key==""){
								others.slots.key=key;
								showReportUrl("",timeTag,others);
								return;
							}else{
								play(str);
								$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
							}
						}else{
							play(str);
							$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
						}
					}

					if(size>0){
						var hideList=false;
						if(size==1&&!noAutoClick){
							try{
								$.each(data.list,function(j,item){
									var otherJson={};
									try{
										otherJson=eval("("+item.other+")");
									}catch(e){
										otherJson=item;
									}
									if(schema=="RSC"&&filedname=="MOBILE"){
										var mobile=otherJson[filedname];
										mobile=mobile.replace(/[^0-9]+/ig,"");
										if(mobile==""){
											play("号码为空");
										}else{
											callBackFunction(mobile,others,timeTag);
										}
									}else{
										if(schema=="RSC"){//兼容人员识别错误,智能纠正
											if(others.name&&item.simpleTitle){
												others.name=item.simpleTitle;
											}
										}
										var id=otherJson[filedname];
										if(callBackFunction.name=="addCalendar"){  
											hideList=true;
											callBackFunction(id+":"+key,others,timeTag);
										}else if(needHideList){
											hideList=true;
											callBackFunction(id,timeTag,others);
										}else if(isTimeTag){
											callBackFunction(id,timeTag,others);
										}else{
											callBackFunction(id,others,timeTag);
										}
										
									}
									return;
								});
							}catch(e){}
						}
						if(!hideList){
							str="为您找到"+size+"条数据";
							if(size>1){
								str="找到"+size+"个"+key+"，请确认是哪个";
								play(str);
							}
							$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
							$.each(data.list,function(j,item){
								var isLast=(j==size-1)?"1":"0";
								if(needHideList&&schema=="RSC"&&filedname=="ID"){//需要隐藏,且搜索人员ID
									$("#listview_1_"+timeTag).append(showRSCCusAction(item,isLast,callBackFunction,filedname,timeTag,others));
								}else{
									$("#listview_1_"+timeTag).append(showSchemaAction(item,isLast,callBackFunction,filedname,timeTag,others));
								}
							});
						}
					}
					
					saveHistory();	
				}
		    });
	    }else{
	    	hideToast();
	    	play("没有识别关键字");
	    }
     }
     
	//查询数据 
    function loadData(timeTag){
    	ToastLoading("加载中...");
        var currentSearch=$('#ask'+timeTag).find(".keyDiv");
        var ask=trimQuotes($(currentSearch).html()).replaceAll("</?[^>]+>", "");//替换所有的标签
        var key=ask;
        var lastKey=$(currentSearch).attr("lastkey");
        var schema=$(currentSearch).attr("schema");
        var otherJson=$(currentSearch).attr("otherJson");
        if($(currentSearch).attr("searchKey")!=""){
        	key=$(currentSearch).attr("searchKey");
        }
        var moreSearch=$(currentSearch).attr("moreSearch");
        var ignoreKey=false;
        if(moreSearch=="false"&&$(currentSearch).attr("searchKey")==""&&otherJson!=""&&otherJson!="{}"){
        	ignoreKey=true;
        }
        
        var hasService=false;
        var service=$(currentSearch).attr("service");
        if(service=="FW_CMD_ES"||service=="FW_CMD"||service=="FW_COMMON"||service=="continue"){
        	hasService=true;
        }
        
        var searchStr=["查询","查找","查看","查一","查查","查"];
    	if(key!=""){
    		if(ignoreKey){
    			key="";
    		}
    		//对第一个查字特殊处理.
    		if(lastKey==""&&key.indexOf("查")==0){
    			var ignoreSearchStr=true;
    			for(var k in searchStr){
    				if(key.indexOf(searchStr[k])==0){
    					key=key.replaceAll(searchStr[k],"");
    					break;
    				}
    			}
    		}
    		//判断是否进入新客服工作台
    		//是否是搜索全部+上次是否已经处理
    		if(schema=="ALL"&&(timeTag!=lastDealTimeTag)&&!hasService){
	    		jQuery.ajax({
					type : "POST", 
					url: "/mobile/plugin/fullsearch/eassistantAjax.jsp?type=Workbench",
			   		data:{"text":ask},
					dataType : 'json', 
					success : function(data) {
						var isES=true;
						if(data.status){
							 if(data.status=="show"){//直接显示
							 	isES=false;
							 	showAnswer(timeTag,data.text);
							 	return;
							 }else if(data.status=="dealed"){//已处理
							 	isES=false;
							 	lastDealTimeTag=timeTag;
							 	if(data.semantic){
							 		var obj={};
							 		if(data.semantic.begindate){
							 			obj.begindate=data.semantic.begindate;
							 		}
							 		if(data.semantic.begintime){
							 			obj.begintime=data.semantic.begintime;
							 		}
							 		if(data.semantic.date_orig){
							 			obj.date_orig=data.semantic.date_orig;
							 		}
							 		if(data.semantic.enddate){
							 			obj.enddate=data.semantic.enddate;
							 		}
							 		if(data.semantic.endtime){
							 			obj.endtime=data.semantic.endtime;
							 		}
							 		if(data.semantic.content){
							 			obj.content=data.semantic.content;
							 		}
							 		//放入当前询问内容中,一旦重新编辑后失效
							 		$('#ask'+timeTag).find(".keyDiv").attr("semantic",JSON.stringify(obj));
							 	}
							 	
							 	//需要重新处理.
							 	location = "emobile:textUnderStand:textBackUnderstand:textBackErr:"+timeTag+":"+data.text; 
							 	return;
							 }
							 //判断微搜具体某种类型.
							 if(data.status.startWith("esearch_")){
							 	schema=data.status.replaceAll("esearch_","");
							 }
							 //微搜如果重新定义关键字.使用新的关键字查询
							 if(data.status.startWith("esearch")&&data.content&&data.content!=""){
							 	key=data.content;
							 }
						}
						if(isES){
							loadESData(timeTag,key,schema,lastKey,otherJson,ask);
						}
					}
				});
    		}else{
    			loadESData(timeTag,key,schema,lastKey,otherJson,ask);
    		}
	    }else{
	    	hideToast();
	    	play("没有识别关键字");
	    }
     }
     //微搜搜索
     function loadESData(timeTag,key,schema,lastKey,otherJson,ask){
     	ToastLoading("加载中...");
     	util.getData({
			    	loadingTarget : document.body,
		    		paras : "noauth="+noauth+"&title="+key+"&contentType="+schema+"&pagesize=20&pageindex=1&voice=1&keyword="+key+"&lastkey="+lastKey,//得数据的URL,
		    		datas :{"otherJson":otherJson},
		    		callback : function (data,passobj){
		    			hideToast();
						var errormsg = data.err;
						if(errormsg<0) {
							var msg=data.msg;
							msg=msg.replace("<b style='color:red;'>","").replace("</b>","");
							play(msg);
							return;
						}
						var size=data.count;
						var listSize=data.list.length;
						var suggestSize=data.suggestList.length;
						var suggestHrm=data.suggestHrm.length;
						var backKey=data.key;
						var hasHrm=data.hasHrm;
						var autoComit=false;
						//非进一步搜索,且没有结果也没有推荐
						if(lastKey==""&&listSize==0&&suggestSize==0&&hasHrm=="false"){
							autoComit=true;
						}
						
						$('#ask'+timeTag).attr("backKey",backKey);
						
						var str="对不起，没有找到您要的结果呢";
						
						var tipStr=retResultStrNoData[Math.floor(Math.random()*retResultStrNoData.length)];
						if(autoComit){
							str=tipStr;
						}
						if(schema=="RSC"){
							str="对不起，没有找到人员";
							autoComit=false;
						}else if(schema=="WF"){
							str="对不起，没有找到"+key+"流程";
							autoComit=false;
						}else if(schema=="CRM"){
							str="对不起，没有找到您要的客户或您对该客户没有权限。";
							autoComit=false;
						}
						if(listSize==0&&suggestSize==0&&suggestHrm==0){
							play(str);
							$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
							//return;
						}
						var item1_wf=false;//第一条返回是否是创建流程
					    var item2_wf=true; //第二天返回是否是创建流程
					    var oneRecord=false;
					    var firstSechma="ALL";
					    var wf_item;
						if(listSize==1){//就一条记录
							item2_wf=false;
							oneRecord=true;
							firstSechma=data.list[0].schema;
						}	    
						var lastOtherJsonStr=$('#ask'+timeTag).find('.keyDiv').attr("otherJson");
						if(data.list) {
							if(listSize>0){
								if(oneRecord&&firstSechma=="FAQ"){//只有一条FAQ数据.直接显示结果
									
									var answer="";
									try{
										var otherJson=eval("("+data.list[0].other+")");
										answer=otherJson["anser"];
									}catch(e){}
									showAnswer(timeTag,answer);
									
								}else{
									
									if(size>20){
										str="为您找到以下内容";
									}else{
										str="为您找到以下"+size+"条内容";
									}
									if(schema=="ALL"){
										str="请参考微搜的结果";
									}
									play(str);
							    	var page=Math.ceil(listSize/5);
								    if(page>1){
								    	var resultHtml='<div class="tips">'+str+':</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative">';
								    	var pageHtml='<div class="otherInfo"><div class="morePage" style="width:'+15*page+'px">'
								    	for (var i=0;i<page;i++){
								    		if(i==0){
								    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
								    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
								    		}else{
								    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
								    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
								    		}
								    	}
								    	resultHtml+='</div>';
								    	pageHtml+='</div>';
								    	if(size>20){
									    	pageHtml+='<div id="moreInfo'+timeTag+'" class="rectangle rounded moreInfo currentMoreInfo" target="'+timeTag+'" lastKey="'+backKey+'" lastSchema="'+schema+'" lastOtherJson=\''+lastOtherJsonStr+'\'>在'+(size>999?'999+':size)+'结果中进一步查询</div>';
								    	}
									    pageHtml+='</div>';
								    	$("#anser"+timeTag).append(resultHtml);
								    	$("#anser"+timeTag).append(pageHtml);
							    	}else{
							    		$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result" id="result'+timeTag+'"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
							    	}
								    
								     
								    var rscStatic=""; 
									$.each(data.list,function(j,item){
										if(j==0){
											wf_item=item;
											if(item.schema=="WFTYPE"){
												item1_wf=true;
											}
										}else if(j==1){
											if(item.schema!="WFTYPE"){
												item2_wf=false;
											}
										}
										var currentPage=Math.ceil((j+1)/5);
										var isLast=(((j+1)%5)==0||j==listSize-1)?"1":"0";
										$("#listview_"+currentPage+"_"+timeTag).append(showSchema(item,isLast));
										//如果是RSC.人员. 把每次人员查询结果, 放在result上面, 用于上下文交互
										if(item.schema=="RSC"){
											rscStatic+=(rscStatic==""?"":",") +item.id;
										}
									});
									
									if(rscStatic!=""){
										var hrmObj={};
										hrmObj.hrmid=rscStatic;
										$("#result"+timeTag ).attr("rscObj",JSON.stringify(hrmObj))
									}
									
									swipeList($("#result"+timeTag ));
									
									moreInfo($('#moreInfo'+timeTag));
								}		
							}
							
						}
						
						if(data.suggestList) {
							if(data.suggestList.length>0){
								if(data.list.length==0){
									play("为您推荐以下结果");
								}
								$("#anser"+timeTag).append('<div class="tips tips2">对不起没有找到您要的结果,<br/>为您推荐以下结果：</div><div class="result"><div id="suggestListview'+timeTag+'"></div></div>');
							       	
								$.each(data.suggestList,function(j,item){
									var isLast=(j==data.suggestList.length-1)?"1":"0";
									$("#suggestListview"+timeTag).append(showSchema(item,isLast));
								});
							}
						}
						
						if(data.suggestHrm) {
							if(data.suggestHrm.length>0){
								if(data.list.length==0){
									play("您可以尝试联系以下人员");
								}
								str="对以上结果不满意？";
								if(listSize==0&&suggestSize==0){
									str="对不起没有找到您要的结果,";
								}
								if(autoComit){
									str=tipStr;
								}
						
								$("#anser"+timeTag).append('<div class="tips tips2">'+str+'<br/>您可以尝试联系以下人员：</div><div class="result"><div id="suggestHrmListview'+timeTag+'"></div></div>');
							       	
								$.each(data.suggestHrm,function(j,item){
									var isLast=(j==data.suggestHrm.length-1)?"1":"0";
									$("#suggestHrmListview"+timeTag).append(showSchema(item,isLast));
								});
							}
						}
						
						//联系客服
						//没结果 有推荐结果 没人
						if(listSize==0&&hasHrm=="false"&&hasCS&&suggestSize>0&&false){
							$("#anser"+timeTag).append('<div class="customerServiceOuter" ><div id="customerService'+timeTag+'"  class="rectangle rounded customerServiceInner currentCustomerService " cser="" ts="'+timeTag+'"><div style="float: left;margin-left: 40px;">转人工客服</div><div style="float: left;margin-left: 15px;"><img style="width:25px" src="/mobile/plugin/fullsearch/img/'+pageStyle+'customerService_wev8.png"></div></div></div>');
							customerService($('#customerService'+timeTag));
						}
						
						
						//设置高度.做2次延迟, 如果有流程创建, 直接进入 
						setTimeout(function(){
							if($('#result'+timeTag).find('.result-current-ul').height()==0){
								setTimeout(function(){
									$('#result'+timeTag).css("height",$('#result'+timeTag).find('.result-current-ul').height()+"px");
									saveHistory();
									//如果第一条是创建流程,且第二天不是创建流程
									if(item1_wf && !item2_wf && lastKey==""){
										createWF(wf_item.id);
									}
								},300)
							}else{
								$('#result'+timeTag).css("height",$('#result'+timeTag).find('.result-current-ul').height()+"px");
								saveHistory();
								if(item1_wf && !item2_wf && lastKey==""){
									createWF(wf_item.id);
								}
							}
						},200);
						
						//自动提交问题
						if(autoComit){
							jQuery.ajax({
								type: "post",
							    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp?type=AutoInsertFAQ&random="+new Date().getTime(),
							    data:{"ask":ask},
							    dataType: "json",  
							    success:function (data) {}
						    });
						}
					}
			    });
		   
     }
	
	 //	意图缓存直接返回结果,显示. 后续操作处理
     function loadIntenCacheData(timeTag,data){
  		hideToast();
		var size=data.count;
		var listSize=data.list.length;
	    var oneRecord=false;
	    var needAutoClick=false;
	    var firstSechma="ALL";
		if(listSize==1){//就一条记录
			oneRecord=true;
			firstSechma=data.list[0].schema;
		}
		if(oneRecord&&firstSechma=="FAQ"){//只有一条FAQ数据.直接显示结果
			var answer="";
			try{
				var otherJson=eval("("+data.list[0].other+")");
				answer=otherJson["anser"];
			}catch(e){}
			showAnswer(timeTag,answer);
		}else{
			if(size>20){
				str="为您找到以下内容";
			}else{
				str="为您找到以下"+size+"条内容";
			}
			
			play(str);
	    	var page=Math.ceil(listSize/5);
		    if(page>1){
		    	var resultHtml='<div class="tips">'+str+':</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative">';
		    	var pageHtml='<div class="otherInfo"><div class="morePage" style="width:'+15*page+'px">'
		    	for (var i=0;i<page;i++){
		    		if(i==0){
		    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
		    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
		    		}else{
		    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
		    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
		    		}
		    	}
		    	resultHtml+='</div>';
		    	pageHtml+='</div>';
			    pageHtml+='</div>';
		    	$("#anser"+timeTag).append(resultHtml);
		    	$("#anser"+timeTag).append(pageHtml);
	    	}else{
	    		$("#anser"+timeTag).append('<div class="tips">'+str+':</div><div class="result" id="result'+timeTag+'"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
	    	}
		    
		     
		    var rscStatic=""; 
			$.each(data.list,function(j,item){
				var currentPage=Math.ceil((j+1)/5);
				var isLast=(((j+1)%5)==0||j==listSize-1)?"1":"0";
				$("#listview_"+currentPage+"_"+timeTag).append(showSchema(item,isLast));
				//如果是RSC.人员. 把每次人员查询结果, 放在result上面, 用于上下文交互
				if(item.schema=="RSC"){
					rscStatic+=(rscStatic==""?"":",") +item.id;
				}
				if(item.afterDoAction&&item.afterDoAction!=''){
					needAutoClick=true;
				}
			});
			
			if(rscStatic!=""){
				var hrmObj={};
				hrmObj.hrmid=rscStatic;
				$("#result"+timeTag ).attr("rscObj",JSON.stringify(hrmObj))
			}
			
			swipeList($("#result"+timeTag ));
			//单条记录,且有后续操作
			if(oneRecord&&needAutoClick){
				//$("#listview_1_"+timeTag).find(".am-list-item")[0].click();
			}
		}	
					
					
		//设置高度.做2次延迟, 如果有流程创建, 直接进入 
		setTimeout(function(){
			if($('#result'+timeTag).find('.result-current-ul').height()==0){
				setTimeout(function(){
					$('#result'+timeTag).css("height",$('#result'+timeTag).find('.result-current-ul').height()+"px");
					saveHistory();
				},300)
			}else{
				$('#result'+timeTag).css("height",$('#result'+timeTag).find('.result-current-ul').height()+"px");
				saveHistory();
			}
		},200);
     }
     
	  //通过名字查找人员,主要使用ID,name. 主要用于交互过程中找人
    function loadRSCByName(key,timeTag,others){
    	var schema="RSC:2";
    	if(key!=""){
	     	util.getData({
		    	loadingTarget : document.body,
	    		paras : "noauth="+noauth+"&title="+key+"&contentType="+schema+"&pagesize=20&pageindex=1&voice=1&keyword="+key,//得数据的URL,
	    		callback : function (data,passobj){
	    			schema=schema.split(":")[0];
	    			hideToast();
					var errormsg = data.err;
					if(errormsg<0) {
						var msg=data.msg;
						msg=msg.replace("<b style='color:red;'>","").replace("</b>","");
						play(msg);
						return;
					}
					var size=data.list.length;
					 
					var str="对不起，没有找到人员"+key+"，请告诉我人员名字。如需取消，请说“退出”"
					if(size==0){
						play(str);
						$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>'); 
					}else if(size==1){
						//只有一个人员. 直接保存,进入下一步
						$.each(data.list,function(j,item){
							var currentInstructObj=JSON.parse($('#instructTipObj'+timeTag).attr("obj"));
							currentInstructObj.resourceid=item.id;
		 					currentInstructObj.resourcename=item.simpleTitle; 
		 					$('#instructTipObj'+timeTag).attr("obj",JSON.stringify(currentInstructObj));
						});
						if(others.showmsg){
							str=others.showmsg;
						}else{
							str="请进入下一步操作";
						}
						play(str);
						$("#anser"+timeTag).find('.instructTip').html(str);
						$("#anser"+timeTag).find('.instructTip').show();
						
					}else{				 
						str="请选择人员:";
						play(str);
						
						var page=Math.ceil(size/5);
					    if(page>1){
					    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative">';
					    	var pageHtml='<div class="otherInfo"><div class="morePage" style="width:'+15*page+'px">'
					    	for (var i=0;i<page;i++){
					    		if(i==0){
					    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
					    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
					    		}else{
					    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
					    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
					    		}
					    	}
					    	resultHtml+='</div>';
					    	pageHtml+='</div>';
						    pageHtml+='</div>';
					    	$("#anser"+timeTag).append(resultHtml);
					    	$("#anser"+timeTag).append(pageHtml);
				    	}else{
				    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
				    	}
							    
							     
							     
						$.each(data.list,function(j,item){
							var currentPage=Math.ceil((j+1)/5);
							var isLast=(((j+1)%5)==0||j==size-1)?"1":"0";
							$("#listview_"+currentPage+"_"+timeTag).append(showRSCAction(item,isLast));
						});
								
						swipeList($("#result"+timeTag ));
						
						//设置高度.做2次延迟
						setTimeout(function(){
							if($('#result'+timeTag).find('.result-current-ul').height()==0){
								setTimeout(function(){
									$('#result'+timeTag).css("height",$('#result'+timeTag).find('.result-current-ul').height()+"px");
									saveHistory();
									
								},300)
							}else{
								$('#result'+timeTag).css("height",$('#result'+timeTag).find('.result-current-ul').height()+"px");
								saveHistory();
							}
						},200);
						
						//添加点击事件
						rscChooseTap();
					}
					
					saveHistory();	
				}
		    });
	    }else{
	    	hideToast();
	    	play("没有识别关键字");
	    }
     }
	
	 //通过名字查找客户,主要使用ID,name
    function loadCRMByName(key,timeTag,others){
    	var schema="CRM:2";
    	if(key!=""){
	     	util.getData({
		    	loadingTarget : document.body,
	    		paras : "noauth="+noauth+"&title="+key+"&contentType="+schema+"&pagesize=20&pageindex=1&voice=1&keyword="+key,//得数据的URL,
	    		callback : function (data,passobj){
	    			schema=schema.split(":")[0];
	    			hideToast();
					var errormsg = data.err;
					if(errormsg<0) {
						var msg=data.msg;
						msg=msg.replace("<b style='color:red;'>","").replace("</b>","");
						play(msg);
						return;
					}
					var size=data.list.length;
					 
					var str="对不起，没有找到您要的客户或您对该客户没有权限，您可以重新说出客户名字.如需取消，请说“退出”"
					if(size==0){
						play(str);
						$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>'); 
					}else{				 
						str="请选择客户:";
						play(str);
						
						var page=Math.ceil(size/5);
					    if(page>1){
					    	var resultHtml='<div class="tips">'+str+'</div><div class="result" id="result'+timeTag+'" page="'+page+'" currentPage="1" style="position: relative">';
					    	var pageHtml='<div class="otherInfo"><div class="morePage" style="width:'+15*page+'px">'
					    	for (var i=0;i<page;i++){
					    		if(i==0){
					    			resultHtml+='<div class="result-ul result-current-ul"  index="'+(i+1)+'"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'" ></div></div>';
					    			pageHtml+='<div class="dot currentDot" index="'+(i+1)+'"></div>';
					    		}else{
					    			resultHtml+='<div class="result-ul" index="'+(i+1)+'" style="left: '+wW+'px"><div ts="'+timeTag+'" id="listview_'+(i+1)+'_'+timeTag+'"></div></div>';
					    			pageHtml+='<div class="dot" index="'+(i+1)+'"></div>';
					    		}
					    	}
					    	resultHtml+='</div>';
					    	pageHtml+='</div>';
						    pageHtml+='</div>';
					    	$("#anser"+timeTag).append(resultHtml);
					    	$("#anser"+timeTag).append(pageHtml);
				    	}else{
				    		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
				    	}
							    
							     
							     
						$.each(data.list,function(j,item){
							var currentPage=Math.ceil((j+1)/5);
							var isLast=(((j+1)%5)==0||j==size-1)?"1":"0";
							$("#listview_"+currentPage+"_"+timeTag).append(showCrmAction(item,isLast));
						});
								
						swipeList($("#result"+timeTag ));
						
						//设置高度.做2次延迟
						setTimeout(function(){
							if($('#result'+timeTag).find('.result-current-ul').height()==0){
								setTimeout(function(){
									$('#result'+timeTag).css("height",$('#result'+timeTag).find('.result-current-ul').height()+"px");
									saveHistory();
									
								},300)
							}else{
								$('#result'+timeTag).css("height",$('#result'+timeTag).find('.result-current-ul').height()+"px");
								saveHistory();
							}
						},200);
						
					}
					//添加点击事件
					crmContactTap();
					
					saveHistory();	
				}
		    });
	    }else{
	    	hideToast();
	    	play("没有识别关键字");
	    }
     }
	
	//查询客户地址
	function load_address(city,address,timeTag,others){
		if(city==""&&address==""){
			hideToast();
			play("地址识别失败");
			ToastInfo("地址识别失败",1);
			return;
		}
		if(address!=""){
			util.getData({
		    	loadingTarget : document.body,
	    		paras : "noauth="+noauth+"&title="+address+"&contentType=CRM&pagesize=20&pageindex=1&voice=1&keyword="+address,//得数据的URL,
	    		callback : function (data,passobj){
					var errormsg = data.err;
					if(errormsg<0) {
						load_address_list(address,timeTag,others);
						return;
					}
					var size=data.list.length;
					if(size==0){
						load_address_list(address,timeTag,others);
					}else if(size==1){
						hideToast();
						$.each(data.list,function(j,item){
							var address1="";
							var address2="";
							var address3="";
							var address="";
							try{
								var otherJson=eval("("+item.other+")");
								address1=otherJson.ADDRESS1;
								address2=otherJson.ADDRESS2;
								address3=otherJson.ADDRESS3;
							}catch(e){}
							
							var addressCount=0;
							if(address1!=""){
								addressCount++;
								address=address1;
							}
							if(address2!=""){
								addressCount++;
								address=address2;
							}
							if(address3!=""){
								addressCount++;
								address=address3;
							}
							if(addressCount==1){
								$("#anser"+timeTag).append('<div class="tips">为您找到客户:</div><div class="result"><div ts="'+timeTag+'" id="listview_0_'+timeTag+'"></div></div>');
								$("#listview_0_"+timeTag).append(showCRMAddressNoClick(item));
								load_address_list(address,timeTag,others);
							}else{
								play("请选择您要去的地址");
								$("#anser"+timeTag).append('<div class="tips">请选择您要去的地址:</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
								$("#listview_1_"+timeTag).append(showCRMAddress(item,1));
							}
						});
					}else if(size>0){
						hideToast();
						play("请选择您要去的地址");
						$("#anser"+timeTag).append('<div class="tips">请选择您要去的地址:</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
						try{
							$.each(data.list,function(j,item){
								var isLast=(j==size-1)?"1":"0";
								$("#listview_1_"+timeTag).append(showCRMAddress(item,isLast));
							});
							
							saveHistory();
						}catch(e){}
					}
				}
		    });
		}else{
			hideToast();
	    	play("没有识别关键字");
		}
	}	
	
	//通过选择客户ID 进行查询
	function load_address_ById(crmId,timeTag,others){
		var otherJson={};
		otherJson.ID=crmId;
		var otherJsonStr=JSON.stringify(otherJson);
		util.getData({
		    	loadingTarget : document.body,
	    		paras : "noauth="+noauth+"&title=&contentType=CRM&pagesize=20&pageindex=1&voice=1&keyword=",//得数据的URL,
	    		datas :{"otherJson":otherJsonStr},
	    		callback : function (data,passobj){
					var errormsg = data.err;
					if(errormsg<0) {
						var msg=data.msg;
						msg=msg.replace("<b style='color:red;'>","").replace("</b>","");
						play(msg);
						return;
					}
					 
					$.each(data.list,function(j,item){
						var address1="";
						var address2="";
						var address3="";
						var address="";
						try{
							var otherJson=eval("("+item.other+")");
							address1=otherJson.ADDRESS1;
							address2=otherJson.ADDRESS2;
							address3=otherJson.ADDRESS3;
						}catch(e){}
						
						var addressCount=0;
						if(address1!=""){
							addressCount++;
							address=address1;
						}
						if(address2!=""){
							addressCount++;
							address=address2;
						}
						if(address3!=""){
							addressCount++;
							address=address3;
						}
						if(addressCount==1){
							load_address_list(address,timeTag,others);
						}else{
							play("请选择您要去的地址");
							$("#anser"+timeTag).append('<div class="tips">请选择您要去的地址:</div><div class="result"><div ts="'+timeTag+'" id="listview_1_'+timeTag+'"></div></div>');
							$("#listview_1_"+timeTag).append(showCRMAddress(item,1));
							hideToast();
						}
					});
				 	saveHistory();
				}
		    });
	}
	
//-------------其他事件--------------	
	/**
	*  网盘调用获取名称
	*/
	function getnamebyid(id,type){
		return fileMap[id];
	}
	
	/*
	*自定义方法入口
	*/
	function CustomFunction(callBackFunction,id,timeTag,otherJson){
		try{
			callBackFunction(id,timeTag,otherJson);
		}catch(e){
			//函数处理异常,直接搜索模块
			loadData(timestamp);
		}
	}

	
	function createWF(id){
		saveHistory();
		if(id==""){
			ToastInfo("流程ID为空",1);
		}else{
			location="/mobile/plugin/1/view.jsp?workflowid="+id+"&method=create"
		}
	}
	
	function saveHistory(){
		//如果语言隐藏.则显示
		showVoicefooter();
		//对新建流程指定宽度
		$('.ul-li-div-addwf').css("width",addWf_width+"px");
		$('#contentDiv').find('.ul-li-div').css("width",ul_li_div_width+"px");
		$('.ul-li-div-crm').css("width",(ul_li_div_width-40)+"px");
		$('.ul-li-div-rsc').css("width",(ul_li_div_width-40)+"px");
		$('.ul-li-div-ranking').css("width",(wW-40)+"px");
		$('.ul-li-div-icon-ranking').css("width",(wW-100)+"px");
		$('.ul-li-div-no').css("width",(wW-20)+"px");
		//修改箭头宽度
		if(ul_li_div_width>250){
			var maxFlightLineAdd=30;
			maxFlightLineAdd=ul_li_div_width-250>maxFlightLineAdd?maxFlightLineAdd:ul_li_div_width-250;
			$('.flightLine').css("width",(30+maxFlightLineAdd)+"px");
		}
		
		listTap();
		if(storage){
			storage.setItem("validTime"+userid, new Date().getTime());//有效时间
			storage.setItem("contentDiv"+userid, $('#contentDiv').html());//对话内容
		}
	}
	//显示footer的div
	function showVoicefooter(){
		if(showInputType==1){
			$('#voiceInputDiv').slideDown();
		}else{
			$('#textInputDiv').slideDown();
		}
	}
	
	
	//移除之前的标识
	function removeLastAsk(){
		//移除轻点以编辑
    	$('.tapDiv').remove();
    	if($('.askCurrent')&&$('.askCurrent').length>0){
    		$('.askCurrent').find(".keyDiv").attr("contentEditable","false");
    	}
    	
    	$('.askCurrent').removeClass("askCurrent");
    	$('.anserCurrent').removeClass("anserCurrent");
    	$('.splitCurrent').removeClass("splitCurrent");
    	$('.currentMoreInfo').removeClass("currentMoreInfo");
    	$('.currentAskTip').removeClass("currentAskTip");
    	$('.currentCustomerService').removeClass("currentCustomerService");
    	$('.currentInstructTip').removeClass("currentInstructTip");
    	$('.currentLoadMore').removeClass("currentLoadMore");
    	$('.currentDoAction').removeClass("currentDoAction");

	}
	
	//填写内容编辑
	function editAsk(){
		$(".ask").off("tap");
		$(".askCurrent").on("tap",function(){
			if($('.anserCurrent')&&$('.anserCurrent').length>0){
				
			}else{
				$('#anser'+$(this).attr("ts")).addClass("anserCurrent");
			}
			
			var editDiv=$(this).find(".keyDiv");
			
			$(editDiv).unbind("focus").unbind("blur");
			
			//判断是否允许编辑操作
			if($(editDiv).attr("nativeJson")){
				var nativeJson = JSON.parse($(editDiv).attr("nativeJson"));
				if(nativeJson.CannotEdit){//不允许编辑
					$(this).find(".tapDiv").hide();
					return;
				}
			}
			
			$(editDiv).focus(function(){
				$(editDiv).attr("contentEditable","true");
				$(this).html(trimQuotes($(this).html()));
			    $('.voicefooter').hide();
			    $(this).addClass("editKeyDiv");
			    $.scrollTo($(this).parent(),500); 
			}).blur(function(){
				$(editDiv).attr("contentEditable","false");
			    $(this).html(addQuotes($(this).html()));
			    $(this).next().show();
			    $(this).removeClass("editKeyDiv");
			    showVoicefooter();
			    //判断值是否改变.
			    var oldText=$(this).attr("text");
			    var newText=trimHtmlTag(trimQuotes($(this).html()));
			    if(newText==""){
			   	 	$(this).html(addQuotes($(this).attr("text")));
			    }
			    //需要移除回车等
			    if(newText!=""&&newText!=oldText){//值发送变化
			    	var ts=$(this).parent().attr("ts");
			    	$(this).attr("text",newText);
			    	$(this).attr("semantic","{}");
			    	//发送变化.删除已有答案.
			    	$('#anser'+ts).html("");
			    	
			    	//判断交互指令是否发送变化
			    	if($('#instructTipObj'+ts)&&$('#instructTipObj'+ts).length>0){
			    		var InstructObj=JSON.parse($('#instructTipObj'+ts).attr("obj"));
			    		var lastTarget=InstructObj.lastTarget;
			    		if(InstructObj.lastTarget!=$('#instructTipObj'+ts).attr("target")){
			    			$('#instructTipObj'+lastTarget).addClass("currentInstructTip");
			    		}
			    		$('#instructTipObj'+ts).remove();
			    	}
			    	//上一步是否点击了进一步查询
			    	if($(this).parent().prev().attr("class")&&$(this).parent().prev().attr("class").trim()=="askTip"){
			    		$(this).parent().prev().addClass("currentAskTip");
			    	}
			    	
			    	//判断是否是本地action,如果是本地action,不需要语音解析
			    	if($(this).attr("nativeJson")){
			    		var nativeJson = JSON.parse($(this).attr("nativeJson"));
			    		nativeJson.text=newText;
			    		textBackUnderstand(JSON.stringify(nativeJson),ts)
			    	}else{
				    	//s="{'text':'公司几点下午茶','rc':'4'}";
						//textBackUnderstand(s,ts)
				    	location = "emobile:textUnderStand:textBackUnderstand:textBackErr:"+ts+":"+newText; 
			    	}
			    }
			});
			
			$(this).find(".tapDiv").hide();
			$(editDiv).focus();
		});
	}
	
	//直接返回提示结果
	function  showResultStr(timeTag,str,isPlay){
		hideToast();
		if(isPlay){
			play(str);
		}
		$("#anser"+timeTag).append('<div class="tips">'+str+'</div><div class="result"></div>');
		saveHistory();
	}
	
	//智能问答
	function showAnswer(timeTag,answer,noplay){
		answer=answer.replaceAll("</?a[^>]+>", "");
		answer=answer.replaceAll("</a>", "");
		answer=answer.replaceAll('<script[^]*>[\\s\\S]*?</'+'script>',"");
		
		hideToast();
		if(!!!noplay){
			play(answer);
		}
		$("#anser"+timeTag).append('<div class="tips"></div><div class="result faqResult" ><div style="padding: 10px 10px 10px 10px;line-height:20px">'+answer+'</div></div>');
		$("#anser"+timeTag).find("img").css("max-width",wW-20+"px");
		//对img 增加点击查看事件
		$("#anser"+timeTag).find("img").off("tap");
		$("#anser"+timeTag).find("img").on("tap",function(){
			var imgSrc=$(this)[0].src;
			if(imgSrc!=""){
	        	location = 'emobile:imgCarousel:["'+imgSrc+'"]:0';
			}
		});
		//去除字体颜色
		$("#anser"+timeTag).find("*").css("color","");
		$("#anser"+timeTag).find("font").attr("color","");
		//去除背景色
		$("#anser"+timeTag).find("*").css("background-color","");
		saveHistory();
	}
	
	//加载客服
    function load_CSER_Data(timeTag){
    	var currentSearch=$('#ask'+timeTag).find(".keyDiv");
        var key=trimQuotes($(currentSearch).html());
        if($(currentSearch).attr("searchKey")!=""){
        	key=$(currentSearch).attr("searchKey");
        }
    	if(key!=""){
	     	util.getData({
		    	loadingTarget : document.body,
	    		paras : "noauth="+noauth+"&title="+key+"&contentType=CSER&pagesize=1&pageindex=1&voice=1&keyword="+key,//得数据的URL,
	    		callback : function (data,passobj){
	    			
					var errormsg = data.err;
					if(errormsg<0) {
						var msg=data.msg;
						msg=msg.replace("<b style='color:red;'>","").replace("</b>","");
						play(msg);
						return;
					}
					var size=data.list.length;
					var suggestSize=data.suggestList.length;
					if(size==0&&suggestSize==0){
						hideToast();
						play("未找到客服");
						saveHistory();
						return;	
					}
					if(size>0){
						try{
							$.each(data.list,function(j,item){
								$('#customerService'+timeTag).attr("cser",item.id);
								saveHistory();
								saveAndExport(item.id)
								return;
							});
						}catch(e){}
					}else{
						if(suggestSize>0){
							try{
								$.each(data.suggestList,function(j,item){
									$('#customerService'+timeTag).attr("cser",item.id);
									saveHistory();
									saveAndExport(item.id)
									return;
								});
							}catch(e){}
						}
					}
					
				}
		    });
	    }else{
	    	hideToast();
	    	play("没有识别关键字");
	    }
     }
	
	//导出聊天记录,并分享给客服
    function saveAndExport(shareId){
		var timestamp = new Date().getTime();
		jQuery.ajax({
			type: "post",
		    url: "/mobile/plugin/fullsearch/voiceOperation.jsp",
		    data:{"content":encodeURIComponent($('#contentDiv').html()),"timestamp":timestamp,"width":wW,"style":pageStyle},
		    dataType: "json",  
		    success:function (data) {
		    	hideToast();
		    	if (data == undefined || data == null) {
		    		ToastInfo("服务器运行出错!\n请联系系统管理员!",1);
		    		return;
		    	} else { 
		    		if(data.result){
		    			if(data.result!="success"){
		    				ToastInfo(data.result,1);
		    			}
		    			if(data.fileid&&data.fileid>0){
		    				fileMap[data.fileid]=data.filename;
		    				//调用共享接口
		    				jQuery.ajax({
								type: "post",
							    url: "/mobile/plugin/networkdisk/shareDiskFileOrFolder.jsp?userids="+shareId+"&fileid="+data.fileid,
							    data:{"userids":shareId,"fileid":data.fileid},
							    dataType: "json",  
							    success:function (data) {
							    	
							    }
							});
		    				location = "emobile:netdiskshare:[]:["+data.fileid+"]:setSendData:"+shareId;
		    			}else{
		    				sendEmsg(shareId);
		    			}
	    				return;
		    		}
		    	}
		    } 
	    });
	}
	
	/**
    * 列表左右切换效果
    */
    function swipeList(obj){    	 
    	 var page=$(obj).attr("page");
    	 if(page && page >1){
    	 	$(obj).off( "swipe swipeleft swiperight");
     	 $(obj).swipeleft(function(){
     	 	var currentPage=parseInt($(this).attr("currentPage"));
     	 	var current_ul=$(this).find('[index="'+currentPage+'"]');
     	 	var idx=$(current_ul).attr("index");
			var current_dot=$(this).next().find('[index="'+currentPage+'"]');
			
			//var current_ul=$(this).find(".result-current-ul");
			//var idx=$(current_ul).attr("index");
			//var current_dot=$(this).find('.dot [index="'+currentPage+'"]');
			//var current_dot=$(this).next().find(".currentDot");
			
			if(currentPage<page){
				$(this).attr("currentPage",currentPage+1);
				var next_ul=$(current_ul).next();
				var next_dot=$(current_dot).next();
				
				$(obj).animate({height:$(next_ul).height()},"normal");
				$(current_ul).animate({left:-wW},"normal",function(){
					$(this).removeClass("result-current-ul");
					$(current_dot).removeClass("currentDot");
				});
				$(next_ul).animate({left:0},"normal",function(){
				    $(this).addClass("result-current-ul");
				    $(next_dot).addClass("currentDot");
				});
			}else{
				ToastInfo("已经最后一页了!",0.5);
			}
		 }); 	
		 
		$(obj).swiperight(function(){
			var currentPage=parseInt($(this).attr("currentPage"));
     	 	var current_ul=$(this).find('[index="'+currentPage+'"]');
			var idx=$(current_ul).attr("index");
			var current_dot=$(this).next().find('[index="'+currentPage+'"]');
			
			
			//ToastInfo($(this).attr("currentPage"),1);
		 	//var current_ul=$(this).find(".result-current-ul");
			//var idx=$(current_ul).attr("index");
			//var current_dot=$(this).next().find(".currentDot");
			if(currentPage>1){
				$(this).attr("currentPage",currentPage-1);
				var prev_ul=$(current_ul).prev();
				var prev_dot=$(current_dot).prev();
				
				$(obj).animate({height:$(prev_ul).height()},"normal");
				$(current_ul).animate({left:wW},"normal",function(){
					$(this).removeClass("result-current-ul");
					$(current_dot).removeClass("currentDot");
				});
				$(prev_ul).animate({left:0},"normal",function(){
				    $(this).addClass("result-current-ul");
				    $(prev_dot).addClass("currentDot");
				}); 
				
			}else{
				ToastInfo("已经第一页了!",0.5);
			}
		});
    	 }	
    }
     
     /*list 点击 效果*/
     function listTap(){
     	//列表点击效果
     	$('.am-list-item').off("touchstart touchend");
     	$('.am-list-item-hover').removeClass("am-list-item-hover");
     	$(".am-list-item").on("touchstart",function(){
     		$(this).addClass("am-list-item-hover");
     	}).on("touchend",function(){
     		$(this).removeClass("am-list-item-hover");
     	}).on("touchmove",function(){
			$(".am-list-item").removeClass("am-list-item-hover");
		});
     	//导航地址点击效果
     	$('.crm_address').off("touchstart touchend");
     	$('.crm_address-hover').removeClass("crm_address-hover");
     	$(".crm_address").on("touchstart",function(){
     		$(this).addClass("crm_address-hover");
     	}).on("touchend",function(){
     		$(this).removeClass("crm_address-hover");
     	}).on("touchmove",function(){
			$(".crm_address").removeClass("crm_address-hover");
		});
     }

    
    /*进一步查询*/ 
    function moreInfo(obj){
    	if($(obj)&&$(obj).length>0){
			$(obj).off("tap");
			$(obj).on("tap",function(){
				if($(this).hasClass("currentMoreInfo")){
					$('#contentDiv').append('<div class="askTip currentAskTip" target="'+$(this).attr("target")+'" lastKey="'+$(this).attr("lastKey")+'" lastSchema="'+$(this).attr("lastSchema")+'" lastOtherJson=\''+$(this).attr("lastOtherJson")+'\'>请说出进一步查找的关键字</div>');
					$(this).removeClass("currentMoreInfo");
					$.scrollTo('.currentAskTip');
					
				}else{
					//alert("禁止触发事件");
				}
			});
		}
    } 
    
    /*加载更多数据,分页查询*/
    function loadMoreInfo(obj){
    	if($(obj)&&$(obj).length>0){
			$(obj).off("tap");
			$(obj).on("tap",function(){
				if($(this).hasClass("currentLoadMore")){
					
					//直接发起请求.
					var timestamp = new Date().getTime();
					 
			    	//移除上一次的
				   	removeLastAsk();
				   		 
			    	$('#contentDiv').append("<div id='ask"+timestamp+"' ts='"+timestamp+"' class='ask askCurrent'><div class='keyDiv'>“加载更多”</div></div>");
			    	$('#contentDiv').append("<div id='instructTip"+timestamp+"' ts='"+timestamp+"'></div>");
					$('#contentDiv').append("<div id='anser"+timestamp+"' ts='"+timestamp+"' class='anser anserCurrent'></div>");
					$('#contentDiv').append("<div id='split"+timestamp+"' ts='"+timestamp+"' class='split splitCurrent'></div>");
					
					$.scrollTo('.askCurrent',0);
					showReportUrl("",timestamp,JSON.parse($(this).attr("otherJson")),JSON.parse($(this).attr("querydata")));
				}else{
					//alert("禁止触发事件");
				}
			});
		}
    } 
     /*客服事件*/
     function customerService(obj){
     	if($(obj)&&$(obj).length>0){
			$(obj).off("tap");
			$(obj).on("tap",function(){
				if($(this).hasClass("currentCustomerService")){
					var cser=$(obj).attr("cser");
					if(cser!=''){
						sendEmsg(cser);
					}else{
						ToastLoading("正在为您转接人工客服...");
						load_CSER_Data($(obj).attr("ts"));
					}
				}else{
					//alert("禁止触发事件");
				}
			});
     	}
     }
     
     /*图片点击预览*/
     function imgCarousel(){
     	//对img 增加点击查看事件
		$('.faqResult').find("img").off("tap");
		$('.faqResult').find("img").on("tap",function(){
			var imgSrc=$(this)[0].src;
			if(imgSrc!=""){
	        	location.href = 'emobile:imgCarousel:["'+imgSrc+'"]:0';
			}
		});
     }
     //隐藏帮助
     function hideHelpDetail(){
     	$("#helpDetail").on("tap",function(){
     		showHelp();
     	});
     }


//用于客户端 调用 主动推送消息
function getNewMsg(){
	loadNewMsg();
}
function loadNewMsg(){
	//从服务器加载新消息
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp?type=LoadFAQAnswer&random="+new Date().getTime(),
	    data:{},
	    dataType: "json",  
	    success:function (data) {
	    	hideToast();
	    	if(data.list&&data.list.length>0){
	    		hideHelp();
				$.each(data.list,function(j,item){
					showNewMsg(item);
				});
		    	//更新客户端标识
				try{
	    			setTimeout(function(){
	      				location='emobile:{"func":"clearUnreadMsgForEHelper","params": {}}';
	      			},1000);
	    		}catch(e){}
			}
	    }
    });		
}

//显示客服回答内容.
function showNewMsg(item){
	if(!item) return;
	var currentInstruct=false;
	var hasConfirmDiv=false;
	//判断是否在交互场景中...
	//是否进一步指令
    if($('.currentInstructTip')&&$('.currentInstructTip').length>0){
    	currentInstruct=true;
    }
    //判断当前是否有确认框
    if($('.confirm_div')&&$('.confirm_div').length>0){
    	 hasConfirmDiv=true;
    }
    if(currentInstruct||hasConfirmDiv){
    	console.log("等待交互场景");
    	setTimeout(function(){showNewMsg(item)},3000);
    }else{
    	$('.currentNewMsg').removeClass("currentNewMsg");
    	var timestamp = new Date().getTime();
		$('#contentDiv').append("<div id='newMsg"+timestamp+"' ts='"+timestamp+"' class='newMsg currentNewMsg'>小e回答了您之前的问题</div>");
    	//展示结果
  			$('#contentDiv').append("<div id='ask"+timestamp+"' ts='"+timestamp+"' class='ask askMsg'><div class='keyDiv'>“"+item.ask+"”</div></div>");
  			$('#contentDiv').append("<div id='instructTip"+timestamp+"' ts='"+timestamp+"'></div>");
  			$('#contentDiv').append("<div id='anser"+timestamp+"' ts='"+timestamp+"' class='anser'></div>");
  			$('#contentDiv').append("<div id='split"+timestamp+"' ts='"+timestamp+"' class='split'></div>");
  			if(item.changeAsk&&item.changeAsk!=""){
  				//var testTxt=['{"service":"FW_CMD","text":"我的考勤","semantic":{"slots":{"type":"SELECT","functionName":"AttendanceReport"}},"rc":0}','{"service":"FW_CMD","text":"我的年假","semantic":{"slots":{"type":"SELECT","which":"holiday"}},"rc":0}']
  				//textBackUnderstand(testTxt[0],timestamp);
  				location = "emobile:textUnderStand:textBackUnderstand:textBackErr:"+timestamp+":"+item.changeAsk; 
  				//4秒后再检查下是否有新消息.
  				setTimeout(function(){loadNewMsg()},4000);
  			}else{
  				showAnswer(timestamp,item.answer,true);
  			}
  			
  			$.scrollTo('.currentNewMsg',0); 
				
    	//更新服务器已读标识
    	if(item.id!=''){
	    	jQuery.ajax({
				type: "post",
			    url: "/mobile/plugin/fullsearch/ajaxVoice.jsp?type=updateFAQAnswerFlag",
			    data:{"ids":item.id},
			    dataType: "json",  
			    success:function (data) {}
    		});
    	}
    }
}
	
//服务器加载跳转页面信息
function getGoPage(){
	//从服务器加载新消息
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/InitParamAjax.jsp?type=goPage&random="+new Date().getTime(),
	    data:{"viewmodule":viewmodule},
	    dataType: "json",  
	    success:function (data) {
	    	 goPageObj=data.pageMap;
	    }
    });		
}
//服务器加载初始化参数
function getInitParam(){
	//从服务器加载新消息
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/InitParamAjax.jsp?type=InitParam&random="+new Date().getTime(),
	    data:{},
	    dataType: "json",  
	    success:function (data) {
	    	degbugPeople=data.degbugPeople;
	    	noauth=data.noauth;
	    	hasCS=data.hasCS;
	    	recordInstruction=data.recordInstruction;
	    	es_version=data.es_version;
	    	isShowFAQTips=data.showFAQTips;
	    	
	    	if(data.intoFAQ){
	    		$('#intoFaqDiv').show();
	    		$('#otherOperateDiv').show();
	    	}
	    }
    });		
}

function showHelpContentItem(item,lastLi){
	return '<div class="am-list-item '+lastLi+'" onclick="showFixed(this)" sId="'+item.id+'" sName="'+item.name+'">'+
		       		'<div class="am-list-line">'+
			       		'<div class="am-list-content" style="width:inherit">'+
				       		'<div>'+
				       			'<span class="ul-li-div-img"><img src="'+item.img+'"></span>'+
					       		'<div class="ul-li-div" style="margin-left: 75px;width">'+
			       					  '<div class="ul-li-div-first"> <span class="ui-li-span ui-li-span-heading ui-li-span80" >'+item.name+'</span></div>'+
			       					  '<div class="ul-li-div-second"> <span class="ui-li-span ui-li-span80">'+item.example+'</span></div>'+
			       				'</div>'+
							'</div>'+
						'</div>'+
						'<div class="am-list-arrow"></div>'+
					'</div>'+
				'</div>';
}

//服务器加载帮助指令
function getInstruction(fixedInst){
	//从服务器加载新消息
	jQuery.ajax({
		type: "post",
	    url: "/mobile/plugin/fullsearch/InitParamAjax.jsp?type=instruction&random="+new Date().getTime(),
	    data:{},
	    dataType: "json",  
	    success:function (data) {
		 	var fixedInstList=data.fixedInstList;
		 	var fixedInstMap=data.fixedInstMap;
		 	var helpDetailMaxSize=data.helpDetailMaxSize;
		 	
			var size=fixedInstList.length;
			
			$.each(fixedInstList,function(j,item){
				var isLast=(j==size-1)?"lastLi":"";
				$('#helpContent').append(showHelpContentItem(item,isLast));
			});
			
			$('#help').find('.ul-li-div').css("width",(ul_li_div_width-35)+"px");
			
			for(var key in fixedInstMap){
				$("#helpDetail").append('<div id="helpDetailDiv_'+key+'" class="helpDetailDiv"></div>');
				$.each(fixedInstMap[key],function(j,item){
					$('#helpDetailDiv_'+key).append("<div>"+item+"</div>");
				});
			}
			//判断是否有 fixedInst
			
			var ii=0;
			var temp_list;
			for(var i=0;i<helpDetailMaxSize;i++){
				for(var j=0;j<size;j++){
					var IntsId=fixedInstList[j].id;
					if(fixedInst==""||IntsId==fixedInst){
						temp_list=fixedInstMap[fixedInstList[j].id];
						if(i<temp_list.length){
							ii++;
							$('#scrollHelpDetail_ul').append('<li id="key_li'+ii+'">'+temp_list[i]+'</li>');
						}
					}
				}
			}
			
	    	initScrollHelp();
     	
     	    scrollHelp();
     	    
	    }
    });		
}


//-------voice.jsp页面 js--------
var currentContentDiv;
//点击help事件
function help(){
	isScrollHelp=false;
	if(!isHelp){
		changePage();
		//记录帮助前展示的DIV
		var allContentDiv=$('.contentDiv');
		$.each(allContentDiv,function(j,obj){
			if($(obj).css("display")=='block'){
				currentContentDiv=obj;
			}
		});
		showHelp();
	}else{
		hideHelp(currentContentDiv);
	}
	return;
}

//显示帮助页
function showHelp(){
	$('.help').addClass("helphot");
	$('.contentDiv').hide();
	$('#help').slideDown("fast");
	$("#helpContent").scrollTo(0);
	isHelp=true;
	showMsgBtn();
}

//隐藏帮助页
function hideHelp(obj){
	$('#scrollHelpContent').hide();
	$('.helphot').removeClass("helphot");
	isHelp=false;
	
	$('#msgContentDiv').hide();
	$('#helpDetail').hide();
	$('#help').slideUp("fast",function(){
		$(obj).show();
		if(obj&&$(obj).attr("id")!="help"){
			if($(obj).attr("id")=="contentDiv"){
				$.scrollTo('.askCurrent',0);
			}else if($(obj).attr("id")=="msgContentDiv"){
				hideMsgBtn();
			}
		}else{
			$('#contentDiv').show();
			$.scrollTo('.askCurrent',0);
			//显示消息按钮
			showMsgBtn();
			
		}
	});
}

//展示具体指令,帮助详情
function showFixed(obj){
	$('#detailTip').html($(obj).attr("sName"));
	$('.helpDetailDiv').hide();
	$('#helpDetailDiv_'+$(obj).attr("sId")).show();
	$('#help').hide();
	$('#helpDetail').slideDown("fast");
}


//消息中的时间显示
function getMsgShowTime(time){
    var timestamp = new Date();
    timestamp.setTime(time);
    var tempdateStr=getDateStr(timestamp);
    if(tempdateStr==nowDateStr){
        return getTimeStr(timestamp);
    }else if(tempdateStr==yesterdayStr){
       	return	"昨天";
    }else{
        return tempdateStr;
    }
}

//显示提交问题帮助
function showFAQTips(){
   	var temp_date=util.getCurrentDate4Format("yyyy-MM-dd");
   	if(isShowFAQTips && temp_date!=showFaqTimeTlag && showInputType==1){
   		showFaqTimeTlag=temp_date;
   		if($('#intoFaqDiv').css("display")!="none"){
    		$('#intoFaqDiv').addClass("faqFlashDiv");
    		$('#faqDivTip').show();
    		setTimeout(function(){
    			$('#intoFaqDiv').removeClass("faqFlashDiv");
    			$('#faqDivTip').hide();
    		},7000);
   		}
   	}
}

/*个人工作情况. 文档点击查看明细*/
function showCreateDocByDate(obj){
	var retQueryData=$(obj).parents(".reportItemResult").attr("retQueryData");
	var nextTs=$(obj).parents(".reportItemResult").attr("nextTs");
	var retQueryDataObj;
	if(retQueryData){
		retQueryDataObj=JSON.parse(retQueryData);
	}
	if(retQueryDataObj){//有查询条件
		var str={};
		str.text="我创建的文档";
		str.rc="0";
		str.service="FW_CMD";
		str.CannotEdit=true;
		str.replaceText=true;
		
		var slots={};
		slots.type="DOC";
		slots.who="self";
		slots.oper="create";
		slots.newoper="queryCreate";
		
		
		var otherJson={};
		otherJson.isAccessories="0";
		var timeRange=new Array();
		timeRange[0]=retQueryDataObj.begindate;
		timeRange[1]=retQueryDataObj.enddate;
		otherJson.CREATEDATE=timeRange;
		    							
		slots.otherJson=otherJson;
		
		var semantic={};
		semantic.slots=slots;
		str.semantic=semantic;
 
		textBackUnderstand(JSON.stringify(str),nextTs);
	}
}
/*
*年会座位信息查询
*/
function AnnualMeetingSeat(obj){
	if($(obj).parents(".anser").hasClass("anserCurrent")){
		var reportStatObj=$(obj).parents(".reportStatDiv");
		if(reportStatObj){
			var querydata=$(reportStatObj).attr("querydata");
			var querydataObj=JSON.parse(querydata);
			if(querydataObj.searchKey){
				voiceBackUnderstand('{"service":"FW_REPORT","text":"'+querydataObj.searchKey+'的年会座位","semantic":{"slots":{"absolutely":"yes","reportType":"RSC_SEAT_AnnualMeeting","name":"'+querydataObj.searchKey+'"}},"rc":0}');
			}else{
				voiceBackUnderstand('{"service":"FW_REPORT","text":"年会座位","semantic":{"slots":{"absolutely":"yes","reportType":"RSC_SEAT_AnnualMeeting"}},"rc":0}');
			}
		}
	}
}
/*
* 同桌其他人
*/
function OtherAnnualMeetingMember(obj){
	if($(obj).parents(".anser").hasClass("anserCurrent")){
		var reportStatObj=$(obj).parents(".reportStatDiv");
		if(reportStatObj){
			var ts=$(reportStatObj).attr("ts");
			
			var reportItemDivObjs=$("#anser"+ts).find(".reportItemDiv");
			if(reportItemDivObjs.length>0){
				var recordData=$(reportItemDivObjs[0]).attr("recordData");
				var recordDataObj=JSON.parse(recordData);
				if(recordDataObj.seatinfo1){
					voiceBackUnderstand('{"service":"FW_REPORT","CannotEdit":"true","text":"同桌其他人","semantic":{"slots":{"absolutely":"yes","reportType":"RSC_SEAT_AnnualMeeting","name":"'+recordDataObj.seatinfo1+'"}},"rc":0}');
				}
			}else{
				ToastInfo("未找到数据",0.5);
			}
		}
	}
}

