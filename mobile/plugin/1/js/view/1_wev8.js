//var locationBak = '';    // 用于备份位置字段的原有位置信息
var autoLocateFlag = 0; // 是否是提交时获取位置
var locatingFields = new Array(); // 定位中的字段
var submitFun ="";


/*用于处理自动定位的字段*/
function autoLocate(){
	try{
		for (var i=0; i<window._autoLocateFields.length; i++) {
			var autofield = window._autoLocateFields[i];
			locatingFields.push(autofield);
			document.getElementById('loadGps'  + autofield ).style.display='';
			document.getElementById('showInfo' + autofield ).innerHTML= SystemEnv.getHtmlNoteName(4084) + '...'; //正在获取
			//document.getElementById('getLocationId'  + autofield ).style.display='none';
			//document.getElementById('clearLocationId'  + autofield ).style.display='none';
		}
		getLoctionInfo(window._autoLocateFields[0]);	
		jQuery('#mustInput' +autofield).val("0");
		return true;
	}catch(e){   //无自动定位字段
		return false;
	}

}

function getLocation(fieldid){
	//alert(fieldid);
	document.getElementById('loadGps'  + fieldid ).style.display='';
	document.getElementById('showInfo' + fieldid ).innerHTML= SystemEnv.getHtmlNoteName(4084) + '...';//正在获取
	jQuery('#isMandFlag'  + fieldid ).hide(); 
	getLoctionInfo(fieldid);
	locatingFields.push(fieldid);
}
/*
function clearTrack(fieldid){	  
   jQuery('#showInfo' + fieldid).html('尚未定位');
   jQuery('#getLocationId' + fieldid).html('获取位置&nbsp;&nbsp;');
   
   jQuery('#mustInput' +fieldid).val(0);
   jQuery('#isMandFlag'  + fieldid ).show();
   
   jQuery('#field' + fieldid).val(locationBak);
   jQuery('#clearLocationId' + fieldid).hide();
}*/

/* resultStr格式：时间,经度,纬度,位置 */	
function getGpsInfo(data, resultStr){
	//alert(fieldid +" ==:"+ resultStr);
	//alert(jQuery("#field" + fieldid)[0]);
	//alert(jQuery("input[name=" + fieldid + "]")[0]);
	var datas = data.split(",");
	var fieldid = datas[0];
	var nodeId = datas[1];
	var userId = datas[2];
	var SPLIT_FIELD = "////~~weaversplit~~////";  //地址内部分隔
	var SPLIT_LOCATION = "/////~~weaversplit~~/////"; //地址之间分隔
	var locationInfos = resultStr.split(",");
	var date = dateConvert(locationInfos[0]);
	var longitude = locationInfos[1];
	var latitude = locationInfos[2];
	var addr = locationInfos[3];
	if(latitude == '0' || longitude == '0' || addr == 'null'){ //获取位置出错
		for (var i=0; i<window._autoLocateFields.length; i++) {
			locatingFields.splice(locatingFields.indexOf(fieldid),1);
			autofield= window._autoLocateFields[i];
		
			jQuery("#showInfo" + autofield).html(SystemEnv.getHtmlNoteName(4085)+"！");  //定位失败
			jQuery("#field" + autofield).val("");
			jQuery("#loadGps" + autofield).hide();
			jQuery('#mustInput' +autofield).val("0");
		}
		alert(SystemEnv.getHtmlNoteName(4086)); //位置获取失败，请检查网络或GPS是否打开！
		if(autoLocateFlag == 1){
			window[submitFun](null);
		}
		return false;
	}else{

/*		if(window._autoLocateFields.indexOf(fieldid)==-1){ //手动获取
			var locationData = '';
			locationBak = jQuery("#hidden" + fieldid).val();
			if(locationBak != '' && locationBak != null){
				locationData = locationBak;
				locationData += SPLIT_LOCATION;
			}
			locationData += nodeId + SPLIT_FIELD +userId + SPLIT_FIELD + date + SPLIT_FIELD +addr+
						SPLIT_FIELD + longitude + SPLIT_FIELD +　latitude;	
			jQuery("#showInfo" + fieldid).html(addr);
			jQuery("#field" + fieldid).val(locationData);
			//alert("手动：" + jQuery("#field" + fieldid).val());
			jQuery("#loadGps" + fieldid).hide();
			//jQuery('#getLocationId' + fieldid).html('重新获取位置&nbsp;&nbsp;');
			//jQuery('#clearLocationId'+ fieldid).show();	
			locatingFields.splice(locatingFields.indexOf(fieldid),1);
			jQuery('#mustInput' +fieldid).val(1);			
		}else{  //自动获取*/
			var locationData = '';
			var locationBak = '';
			var autofield   ='';
			for (var i=0; i<window._autoLocateFields.length; i++) {
				locatingFields.splice(locatingFields.indexOf(fieldid),1);
				autofield= window._autoLocateFields[i];
				locationData='';
				locationBak = jQuery("#hidden" + autofield).val();
				if(locationBak != '' && locationBak != null){
					locationData = locationBak;
					locationData += SPLIT_LOCATION;
				}
				locationData += nodeId + SPLIT_FIELD +userId + SPLIT_FIELD + date + SPLIT_FIELD +addr+
							SPLIT_FIELD + longitude + SPLIT_FIELD +　latitude;
								
				
				jQuery("#showInfo" + autofield).html(addr);
				jQuery("#field" + autofield).val(locationData);
				jQuery("#loadGps" + autofield).hide();
				//alert("自动："+autofield+" "+jQuery("#field" + autofield).val());
				jQuery('#mustInput' +autofield).val("1");
			}
			if(autoLocateFlag == 1){
				window[submitFun](null);
			}
	//	}
	}
	//jQuery('#clearLocationId' + fieldid).attr("disabled","");
	//jQuery('#clearLocationId' + fieldid).attr("onclick","clearTrack("+fieldid+")");		

}
    
/* 将时间戳抓换为北京时间 */
function dateConvert(obj){
   	var date = new Date(parseInt(obj)).Format("yyyy-MM-dd/hh:mm:ss");
   	//alert(date);
   	return date;
}

/* 时间转换函数 */
Date.prototype.Format = function (fmt) { 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //<a href="https://www.baidu.com/s?wd=%E6%AF%AB%E7%A7%92&tn=44039180_cpr&fenlei=mv6quAkxTZn0IZRqIHckPjm4nH00T1Y4ny79rynsmHI-PHNBnj0z0AP8IA3qPjfsn1bkrjKxmLKz0ZNzUjdCIZwsrBtEXh9GuA7EQhF9pywdQhPEUiqkIyN1IA-EUBtknHTYnjm4njbvnjmsPjcdrHT4" target="_blank" class="baidu-highlight">毫秒</a> 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
    }


//用于处理Html模式下边日期时间控件位置显示正确的问题。
function moveDataTimeContorl(){
	var $dtCtl = jQuery("div[class='dw-persp']");
	if($dtCtl != null && $dtCtl.css("display") != "none"){
		$dtCtl.css("position","absolute");
		$dtCtl.css("left", bodyScrollLeft);
	}
}

function getCalendarForClient(obj){
	var classtype = jQuery(obj).attr("class");
	var url = "";
	var objvalue = jQuery(obj).val();
	if(!!!objvalue){
		objvalue = "";
	}
	if(classtype == "scroller_date"){
		url = "emobile:calender_date:setCalenderValue:"+objvalue+":"+jQuery(obj).attr("id");
	}else if(classtype == "scroller_time"){
		if(objvalue != ""){
			objvalue = objvalue.replace(/:/g,"-").replace(/：/g,"-");
		}
		url = "emobile:calender_time:setCalenderValue:"+objvalue+":"+jQuery(obj).attr("id");
	}
	location.href = url;
}

function setCalenderValue(obj,value){
	jQuery("#"+obj).val(value);
	if(obj.indexOf("_")>-1){
		jQuery("#"+obj).trigger("change");
	}
	try{
		jQuery("#"+obj).change(); 
	}catch(e){}
	
	try{
		if(iscustome == 1){//自定义请假单
			setLeaveDays();
		}else if(iscustome == 2){//自定义加班单
			setValue();
		}else if(js_isBill == "1" && js_formid == "180"){//系统请假单
			doChangeLeaveDateTime();
		}
	}catch(e){}
}

function initFormPage() {
	
	 $('.scroller_date').scroller({
        preset: 'date',
        dateFormat:'yy-mm-dd',
        theme: 'default',
        display: 'bottom',
        mode: 'scroller',
        nowText:'今天',
        setText:'确定',
        cancelText:'取消',
        monthText:'月',
        yearText:'年',
        dayText:'日',
        showNow:true,
        dateOrder: 'yymmdd',
        onShow: moveDataTimeContorl
	});  
	$('.scroller_time').scroller({
        preset: 'time',
        timeFormat:'HH:ii',
        theme: 'default',
        display: 'bottom',
        mode: 'scroller',	      
        nowText:'现在',
        setText:'确定',
        cancelText:'取消',
        minuteText:'分',
        hourText:'时',
        timeWheels:'HHii',	        
        showNow:true,
        onShow: moveDataTimeContorl
    });  
	
	var textareaArray = $("TEXTAREA");
	textareaArray.attr("horizontalScrollPolicy", "off");
	textareaArray.attr("verticalScrollPolicy", "off");
	
	textareaArray.bind("input", function () {
	});
	
	textareaArray.bind("propertychange", function () {
		$(this).css("height", $(this)[0].scrollHeight-4);
	});
	
	
	
	if(fieldIdRemindType){
		doChangeRemindType(document.getElementById(fieldIdRemindType));
	}
}

//签字意见第一次加载
function remarksignload(){
    try{
        //如果已显示改造后的签字意见，则不显示手机端原生的签字意见
        if(showClientRemark){
            return false;
        }
    }catch(e){}
	getDataList(getUrlParam(), true);
}

//各种浏览按钮通用
function closeDialog(returnIdField) {
	$.close("selectionWindow");
}
function getDialogId() {
	return "selectionWindow";
}

//电子签章专用
function closeSignatureDialog() {
	$.close("signatureWindow");
    $("#signaddmorebg").hide();
}

function showDialog2(url, data, isHtml) {
	var top = ($( window ).height()-150)/2;
	var width = window.innerWidth > 480 ? 480 : window.innerWidth - 20;
	$.open({
		id : "selectionWindow",
		url : url,
		data: "r=" + (new Date()).getTime() + data,
		title : "请选择",
		width : width,
		height : 155,
		scrolling:'yes',
		top: top,
		callback : function(action, returnValue){
		}
	}); 
	$.reload('selectionWindow', url + "?r=" + (new Date()).getTime() + data);
	try {
		clearInterval(ckInterval);
	} catch (e){}
	setInterval("setRedflag()",1000);
}

var _BrowserWindow = window;
function onBrowserOk(result){
	if(result){
		var fieldId = result["fieldId"];
		var fieldSpanId = result["fieldSpanId"];
		var idValue = result["idValue"];
		var nameValue = result["nameValue"];
		
		nameValue = nameValue.replace(new RegExp(",","gm"),"&nbsp");
		var c = "<span id=\""+fieldSpanId+"\" name=\""+fieldSpanId+"\" keyid=\""+idValue+"\">"+nameValue+"</span>";
		if($("#"+fieldId+"_d")){
			$("#"+fieldId+"_d").val(idValue);
			$("#"+fieldSpanId+"_d").html(c);
			var showid = fieldId.replace("field", "").replace("_", "");
			var showname = $("#"+showid).val();
			 $("#"+showname).html(nameValue);
		}
		$("#"+fieldId).val(idValue);
		$("#"+fieldSpanId).html(c);
	}
	setTimeout(function(){
		closeDialog();
	},500);
}

function showDialog3(url, data) {
	var tempstr = data.split("&fieldId=");
	var fid = tempstr[1].substr(0,tempstr[1].indexOf("&"));
	data += "&selectedIds="+$("#"+fid).val();
	var top = ($( window ).height()-470)/2;
	var width = window.innerWidth > 430 ? 430 : window.innerWidth - 20;
	$.open({
		id : "selectionWindow",
		url : url,
		data: "r=" + (new Date()).getTime() + data,
		title : "请选择",
		width : width,
		height : 400,
		scrolling:'yes',
		top: top,
		callback : function(action, returnValue){
		}
	}); 
	//$.reload('selectionWindow', url + "?r=" + (new Date()).getTime() + data);
	try {
		clearInterval(ckInterval);
	} catch (e){}
	setInterval("setRedflag()",1000);
}

function departBrowser(data){     
        var params = data.split("&");
        var fieldId = "";
        var fieldSpanId = "";
        var browserType = ""; //1多选 2单选
        var selectedIds = ""; //1选部门 2选分部
        var selectType = "";
        //top._BrowserWindow = window;
        for(var i=0; i<params.length; i++){
            var keyValue = params[i].split("=");
            if(keyValue.length === 2){
                if(keyValue[0] == "returnIdField"){
                    fieldId = keyValue[1];                    
                }else if (keyValue[0] == "returnShowField"){
                    fieldSpanId = keyValue[1];    
                }else if (keyValue[0] == "isMuti"){
                    if(keyValue[1] == 0){ //单选
                        browserType = 2;
                    }else if(keyValue[1] == 1){ //多选
                       browserType = 1; 
                    }                    
                }
            }
        }
        jQuery("#"+fieldSpanId +" span[keyid]").each(function(index,obj){
            var keyid = jQuery(obj).attr("keyid");
            if(keyid !="" && jQuery(obj).html() != ""){
                selectedIds += (keyid + ",");                
            }
        });
        if(data.indexOf("method=listDepartment") != -1){
            selectType = 1;
        }else if(data.indexOf("method=listSubCompany") != -1){
            selectType = 2;
        }               
        //window.location.href = "/mobile/plugin/browsernew/departBrowser.jsp?fieldId="+fieldId
         //   +"&fieldSpanId="+fieldSpanId+"&browserType="+ browserType +"&selectedIds="+ selectedIds +"&selectType=" + selectType
         //   +"&wfid=<%=workflowid%>&requestId=<%=requestid%>&clienttype=" + clienttype +"&module=<%=module%>&scope=<%=scope%>&clientlevel=<%=clientlevel%>";
        
        top._BrowserWindow = window;
        $("#departChooseFrame")[0].contentWindow.resetBrowser({
            "fieldId" : fieldId,
            "fieldSpanId" : fieldSpanId,
            "browserType" : browserType,//1多选 2单选
            "selectType": selectType, //1选部门 2选分部
            "selectedIds" : selectedIds,
            "callbackOk": "callbackOk",
            "callbackBack": "callbackBack"
        });
        $(document.body).addClass("hrmshow");
}

function callbackOk(result){
    var fieldId = result["fieldId"];
    var fieldSpanId = result["fieldSpanId"];
    var idValue = result["idValue"];
    var nameValue = result["nameValue"];
    $(document.body).removeClass("hrmshow");
    
    //将返回值，添加到标签中 
    // 赋值主字段
    var fieldSpan = jQuery("#"+fieldSpanId);   
    fieldSpan.children().remove();
    var ids = idValue.split(",");
    var names = nameValue.split(",");
    for(var i=0; i<ids.length; i++){
        fieldSpan.append("<span keyid="+ids[i]+">"+names[i]+"</span>");
        if(i < ids.length-1){
            fieldSpan.append("<div style='height:10px; width:1px; overflow:hidden;'></div>");
        }
    }
    jQuery("#"+fieldId).val(idValue);
	if(nameValue ==""){
        jQuery("#"+fieldId + "_ismandspan").show();
    }else{
        jQuery("#"+fieldId + "_ismandspan").hide(); 
    }
    
    // 明细字段赋值
    fieldSpanId = fieldSpanId +"_d";
    fieldId = fieldId + "_d";
    fieldSpan = jQuery("#"+fieldSpanId); 
    fieldSpan.children().remove();
    var ids = idValue.split(",");
    var names = nameValue.split(",");
    //上部表示div
    try{
	    for(var i=0; i<ids.length; i++){
	        var titlefieldSpan = jQuery("#isshow" + fieldSpan.attr("groupid") + "_"+ fieldSpan.attr("rowid") + "_" + fieldSpan.attr("columnid"));
	        titlefieldSpan.append("<span keyid="+ids[i]+">"+names[i]+"</span>");
	        if(i < ids.length-1){
	            titlefieldSpan.append("<div style='height:10px; width:1px; overflow:hidden;'></div>");
	        }
        }
    }catch(e){}
    for(var i=0; i<ids.length; i++){
        fieldSpan.append("<span keyid="+ids[i]+">"+names[i]+"</span>");
        if(i < ids.length-1){
            fieldSpan.append("<div style='height:10px; width:1px; overflow:hidden;'></div>");
        }
    }
    jQuery("#"+fieldId).val(idValue);
	if(nameValue ==""){
        jQuery("#"+fieldId + "_ismandspan").show();
    }else{
        jQuery("#"+fieldId + "_ismandspan").hide(); 
    }
    
    
    
}
function callbackBack(){
    $(document.body).removeClass("hrmshow");
}

//签章选择和密码验证之后把完整个请求路径赋给img的markid
function setMarkPath(markId){
	//没有设置电子签章，返回-1
	if(markId == -1){
		$.alert("您没有设置电子签章！", promptWrod);
	}else{
		//清除操作
		if(markId == ""){
			document.getElementById("markId").value = "";
			var obj = document.getElementById("markImg");
			if(obj != null){
				obj.src = "";
				obj.style.display = "none";
			}
			try{
			  //jQuery("#userSignRemark").css("background","").css("background-position","");
              removeBackImages("/weaver/weaver.file.SignatureDownLoad?markId=","userSignRemark");
			}catch(e){}
			//根据内容来判断是否显示签字意见的必填标识。
			setInterval("setRedflag()",1000);
			//if ($("#userSignRemark").val() == "") {
			//	$("#userSignRemark_ismandspan").show();
			//}
			
			try {
				displayFormSignature(null);
			}catch (e) {}
		//选择签章操作
		}else{
			var path = "/weaver/weaver.file.SignatureDownLoad?markId=" + markId;
			document.getElementById("markId").value = markId;
			var obj = document.getElementById("markImg");
			if(obj != null){
				obj.src = path;
				obj.style.display = "";
			}
			try{
               //jQuery("#userSignRemark").css("background","url("+path+") no-repeat").css("background-position","0px 60px");
			   addBackImges(path,"/weaver/weaver.file.SignatureDownLoad?markId=","userSignRemark");
			}catch(e){}
			
			
			//隐藏签字意见的必填标识。
			setInterval("setRedflag()",1000);
			//$("#userSignRemark_ismandspan").hide();
			
			try {
				displayFormSignature(path);
			}catch (e) {}
		}
	}
}

//手写签章的专用弹出框
function showDialogEletricSignature(url,data){
	var top = ($(window).height()-150)/2;
	$.open({
		id:"signatureWindow",
		url:url,
		data: "r=" +data,
		title: ectSignWrod,
		width: 260,
		height: 80,
		scrolling:'no',
		top: top,
		callback : function(action,returnValue){
		}
	});
}

function showwfsigndetail(obj, targetId) {
	$(obj).hide();
	$("#" + targetId).show();
}

function loadstatus(obj) {
	try {
		$(".listbtnhandler").removeAttr("onclick");
		$(obj).attr("loadding", 1);
		$(obj).html("处理中...");
	} catch (e) {}
}

function setPageAllButtonDisabled() {
	try {
		$(".operationBt").unbind("click");
		$(".operationBt").attr("onclick", "");
		$(".operationBt").css("background", "#A4A4A4");
		$(".operationBt").css("border", "1px solid ");
	    $(".ullibutton").unbind("click");
		$(".ullibutton").attr("onclick", "");
		$(".ulbottombtn").attr("onclick","");
		$(".ulbottomonebtn").attr("onclick","");
		$(".ulbottomtwoleftbtn").attr("onclick","");
        $(".ulbottomtworightbtn").attr("onclick","");
	} catch (e) {}
}
function setPageAllButtonEnable(){
	try {
		$(".operationBt").unbind("click");
		$(".operationBt").bind("click", function(){
			window[submitFun](null);
		});
		$(".operationBt").css("background", "#0084CB");
		$(".operationBt").css("border", "1px solid #0084CB");
	} catch (e) {}
}

//判断input框中是否输入的是数字,包括小数点
function ItemNum_KeyPress(elementname) {
	var e = e || window.event;
	// 避免多次输入小数点
	var tmpvalue = $("input[name=" + elementname + "]").val();
	if(tmpvalue.indexOf(',')!=-1){
		 tmpvalue = tmpvalue.replace(/,/g,'');
	}
	if(isNaN(tmpvalue)){
		//判断第一个输入值为'-'负数时，不清除
		if(!(tmpvalue.charAt(0) == "-")){
				tmpvalue = "";
			$("input[name=" + elementname + "]").attr("value","");
		}
	}
	var count = 0;
	var count2 = 0;
	var len = -1;
	if(elementname){
		len = tmpvalue.length;
	}
	for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){
			count++;     
		}
	}
	for(i = 0; i < len; i++){//避免多次输入负号
		if(tmpvalue.charAt(i) == "-"){
			count2++;     
		}
	}
	if(!(((e.keyCode>=48) && (e.keyCode<=57)) || e.keyCode==46 || e.keyCode==45) || (e.keyCode==46 && count == 1) || (e.keyCode==45 && count2 == 1)) {  
		if(window.event){
			e.keyCode=0; 
			e.preventDefault();
		}else{
			e.preventDefault();
		}
	}
}

function changeToNormalFormat(inputfieldname){
var sourcevalue = $($("input[name='" + inputfieldname + "']")[0]).val();
      var tovalue = sourcevalue.replace(/,/g, "");
      $($("input[name='" + inputfieldname + "']")[0]).val(tovalue);
  }

function checknumber1(objectname) {
    
	var valuechar = $(objectname).val().split("") ;
	var isnumber = false ;
	var charnumber = -1;
	for(var i=0 ; i<valuechar.length ; i++) { 
    	charnumber = parseInt(valuechar[i]) ; 
    	if( isNaN(charnumber)&& valuechar[i]!="." && valuechar[i]!="-") {
        	isnumber = true ;
    	}
    }
	if(isnumber) {
    	$(objectname).val("");
	}
	if ($(objectname).val() != "" && $(objectname).val() != null) { 
		var datalength = $(objectname).attr("datalength");
		if(datalength!=null && datalength!=undefined){
			 $(objectname).val(toPrecision($(objectname).val(),datalength));
		}else{
		  $(objectname).val(parseFloat($(objectname).val()));
		}
    }
}

function changeToThousands(inputfieldname){
	var sourcevalue = $($("input[name='" + inputfieldname + "']")[0]).val();
	var re;
    if(sourcevalue.indexOf(".")<0)
        re = /(\d{1,3})(?=(\d{3})+($))/g;
    else
        re = /(\d{1,3})(?=(\d{3})+(\.))/g;
    var tovalue = sourcevalue.replace(re,"$1,");
    
    $($("input[name='" + inputfieldname + "']")[0]).val(tovalue);
}

function FormatToNumber(index){
    if($("input[name='field_lable" + index + "']").val() != ""){
    	$("input[name='field_lable" + index + "']").val($("input[name='field" + index + "']").val());
    }else{
    	$("input[name='field" + index + "']").val("");
    	$("input[name='field_chinglish" + index + "']").val("");
    }
}

function numberToFormat(index){
    if($("input[name='field_lable" + index + "']").val() != ""){
    	if($("input[name='field_lable" + index + "']").val().indexOf(",")>-1){
    		var replace_val = $("input[name='field_lable" + index + "']").val().replace(/,/g,"");
    		$("input[name='field_lable" + index + "']").val(replace_val);
    	}
    	$("input[name='field" + index + "']").val(floatFormat($("input[name='field_lable" + index + "']").val()));
        $("input[name='field_lable" + index + "']").val(milfloatFormat($("input[name='field" + index + "']").val()));
        $("input[name='field_chinglish" + index + "']").val(numberChangeToChinese($("input[name='field" + index + "']").val()));
    }else{
        $("input[name='field" + index + "']").val("");
        $("input[name='field_chinglish" + index + "']").val("");
    }
}

function floatFormat(num) {   
	if (num!=null) {
	    num  =  num+"";  
		ary = num.split(".");
		if(ary.length==1){
			if(num == "")
				num = "0";
			num = num + ".00";
		}else{
			if(ary[1].length<2)
				num = num + "0";
			else if(ary[1].length>2)
				num = ary[0] + "." + ary[1].substring(0,2);
		}
	} 
    return  num;  
}

 	//数字千分位格式化2
function milfloatFormat(num) {       
	if (num!=null) {   
	    num  =  num+"";  
	    var  re=/(-?\d+)(\d{3})/  
	    while(re.test(num)){  
	        num=num.replace(re,"$1,$2")  
	    }  
	    return  num;  
	}
	else return "";
}


//数字金额小写转大写
function numberChangeToChinese(num) {
	var prefh="";
	if(!isNaN(num)){
	    if(num<0){
	        prefh="负";
	        num=Math.abs(num);
	    }
	}
	if (isNaN(num) || num > Math.pow(10, 12)) return "";
	var cn = "零壹贰叁肆伍陆柒捌玖";
	var unit = new Array("拾佰仟", "分角");
	var unit1= new Array("万亿万", "");
	var numArray = num.toString().split(".");
	var start = new Array(numArray[0].length-1, 2);

	function toChinese(num, index)
	{
	var num = num.replace(/\d/g, function ($1)
	{
	return cn.charAt($1)+unit[index].charAt(start--%4 ? start%4 : -1)
	});
	return num;
	}

	for (var i=0; i<numArray.length; i++)
	{
	var tmp = "";
	for (var j=0; j*4<numArray[i].length; j++)
	{
	var strIndex = numArray[i].length-(j+1)*4;
	var str = numArray[i].substring(strIndex, strIndex+4);
	var start = i ? 2 : str.length-1;
	var tmp1 = toChinese(str, i);
	tmp1 = tmp1.replace(/(零.)+/g, "零").replace(/零+$/, "");
	//tmp1 = tmp1.replace(/^壹拾/, "拾")
	tmp = (tmp1+unit1[i].charAt(j-1)) + tmp;
	}
	numArray[i] = tmp ;
	}

	numArray[1] = numArray[1] ? numArray[1] : "";
	numArray[0] = numArray[0] ? numArray[0]+"圆" : numArray[0], numArray[1] = numArray[1].replace(/^零+/, "");
	numArray[1] = numArray[1].match(/分/) ? numArray[1] : numArray[1]+"整";
	var money =  numArray[0]+numArray[1];
	money = money.replace(/(亿万)+/g, "亿"); 
	if(money=="整"){
		money="零圆整";
	}else{
	    money=prefh+money;
	}
	return money;
}

//数字金额大写转小写 
function chineseChangeToNumber(num) {
	var prefh="";
	if(num.length>0){
	    if(num.indexOf("负")==0){
	        prefh="-";
	        num=num.substr(1);
	    }
	}

	var numArray = new Array()
	var unit = "万亿万圆$";
	for (var i=0; i<unit.length; i++)
	{
	var re = eval("/"+ (numArray[i-1] ? unit.charAt(i-1) : "") +"(.*)"+unit.charAt(i)+"/");
	if (num.match(re))
	{
	//numArray[i] = num.match(re)[1].replace(/^拾/, "壹拾")
	numArray[i] = numArray[i].replace(/[零壹贰叁肆伍陆柒捌玖]/g, function ($1)
	{
	return "零壹贰叁肆伍陆柒捌玖".indexOf($1);
	});
	numArray[i] = numArray[i].replace(/[分角拾佰仟]/g, function ($1)
	{
	return "*"+Math.pow(10, "分角 拾佰仟 ".indexOf($1)-2)+"+";
	}).replace(/^\*|\+$/g, "").replace(/整/, "0");
	numArray[i] = "(" + numArray[i] + ")*"+Math.ceil(Math.pow(10, (2-i)*4));
	}
	else numArray[i] = 0;
	}
	return prefh+eval(numArray.join("+"));
}

function checkLength(elementname,len,fieldname,msg,msg1) {
	len = len*1;
	var str = $("input[name=" + elementname + "]").val();
	//处理document.all可能找不到对象时的情况，通过id查找对象
    if(str == undefined) {
        str = document.getElementById(elementname).value;
    }
    
	if(len!=0 && realLength(str) > len){
		while(true){
			str = str.substring(0, str.length - 1);
			if(realLength(str) <= len){
				$("input[name=" + elementname + "]").val(str)
				return;
			}
		}
	}
}

//取字符串字节长度
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

function validateDate(obj){
	if(obj){
		var val = obj.value;
		if(val == ""){
			return true;
		}
		
		//判断长度是否为10
		if(val.length != 10){
			obj.value = "";
			return false;
		}
		
		//使用正规表达式验证日期格式
		var reg = /^((?:19|20)\d\d)-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])$/;
		if (!reg.test(val)){
			obj.value = "";
			return false;
		}
	}
}

function validateTime(obj){
	if(obj){
		var val = obj.value;
		if(val == ""){
			return true;
		}
		
		//判断长度是否为5
		if(val.length != 5){
			obj.value = "";
			return false;
		}
		
		//使用正规表达式验证时间格式
		var reg = /^(([0-1][0-9])|([1-2][0-3])):([0-5][0-9])$/;
		if (!reg.test(val)){
			obj.value = "";
			return false;
		}
	}
}

function validateYear(obj){
	if(obj){
		var val = obj.value;
		if(val == ""){
			return true;
		}
		
		//判断长度是否为4
		if(val.length != 4){
			obj.value = "";
			return false;
		}
		
		//使用正规表达式验证年份格式
		var reg = /^20\d{2}$/;
		if (!reg.test(val)){
			obj.value = "";
			return false;
		}
	}
}

function logout() {
	location = "/logout.do";
}

function dataInput2(parfield, strFieldName, tempParam){
     var strData = tempParam;
     
     var tempParfieldArr = strFieldName.split(",");
     for(var i = 0; i< tempParfieldArr.length; i++){
   	  var tempStr = tempParfieldArr[i];
   	     strData += "&" + encodeURI(tempStr);
   	     tempStr = tempStr.substring(tempStr.indexOf("|") + 1);
	     var val="";
	     if(document.getElementById(tempStr)){
		     val = document.getElementById(tempStr).value;  
	      }
   	      strData += "=" + escape(val);
     }

	 var nodenumstr="";
	 $("input[id^='nodenum']").each(function(rownode){
		 nodenumstr += $(this).attr("id").replace("nodenum","")+"-"+ $(this).val();
		 if(rownode!=($("input[id^='nodenum']").length-1)){
			 nodenumstr += ",";
		 }
	 });
	 strData += "&nodenumstr="+nodenumstr;
     
	jQuery.ajax({
		type: "GET",
		cache: false,
		url: encodeURI("/mobile/plugin/1/DataInputFromMobile.jsp"),
	    data: strData,
	    dataType: "json",  
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(){
		},
	    error:function (XMLHttpRequest, textStatus, errorThrown) {
	    } , 
	    success : function (data, textStatus) {
	    	if (data == undefined || data == null) {
	    		return;
	    	} else {
				setGropIdInfo(data.groupids);
	    		setClearField(data.clearField);
	    		setValueLinkage(data.values,parfield);
	    		setMandLinkage(data.mandField);
	    		setDisplayInfo(data.displays);
	    	}
	    } 
	}); 
}

function setRedflag(){
	 $("textarea").each(function(i){
        var name= $(this).attr("name");
        if(name!=undefined){
            if(isShowEditor())
               K.sync("#"+name);
        }
     });
	$(".ismand").each(function() {
		var vid = this.id;
		vid = vid.substring(0, vid.lastIndexOf("_"));
		//检查手写签批 和 语音附件
		var handWrittenObj = jQuery("#fieldHandWritten");
		var speechAppendObj = jQuery("#fieldSpeechAppend");
		var flagHandWritten = (handWrittenObj.size() == 0 || handWrittenObj.val() == "");
		var flagSpeechAppend = (speechAppendObj.size() == 0 || speechAppendObj.val() == "");
		
		//对签字意见必填性的检查
		if("userSignRemark" == vid){
			//分别检查  文字意见、电子签章、手写签批 和 语音附件。
			if($("#" + vid).val() == "" && jQuery("#markId").val() == "" && flagHandWritten && flagSpeechAppend){
				$(this).show();
			} else {
				$(this).hide();
			}
		}else{
			if ($("#" + vid).val() != "") {
				$(this).hide();
			} else {
				$(this).show();
			}
		}
	});
}

function doexpand(){
	$("#moresigninfotext").html("处理中...");
	jQuery("#workflowsignmore").attr("onclick", "");
	$("#workflowsignmore").css("background", "#A4A4A4");
	$("#workflowsignmore").css("border", "1px solid #A4A4A4");
	getDataList(getUrlParam());
}

/**
 * 获取url参数
 */
function getUrlParam() {
	var pagesize = 5;
	var workflowid = $("input[name='workflowid']").val();
	var requestid = $("input[name='requestid']").val();
	var workflowsignid = $("input[name='workflowsignid']").val();
	
	var paras = "userid=" + js_userid + "&sessionkey=" + js_sessionkey + "&module=" + js_module + "&scope=" + js_scope + "&fromRequestId=" + js_fromRequestid + "" + 
		"&pagesize=" + pagesize + 
		"&workflowId=" + workflowid + 
		"&requestId=" + requestid + 
		"&pageindex=" + workflowsignid + 
		"&tk" + new Date().getTime() + "=1";
		try{
		paras += "&fromRequestid" + js_fromRequestid;
		}catch(e){
		}
	return paras;
}

var alertMsg = "";

//督办提交

function dosupervise(_this){
	if(_this == null || _this == undefined){
		_this = jQuery("#dosupervise");
	}
	
	if(dochecksubmit()){
		setPageAllButtonDisabled();
		loadstatus(_this);
		
		$('#src').val("supervise");
		$('#workflowfrm').submit();
		
		try {
			clearInterval(ckInterval);
		} catch (e){}
		setInterval("setRedflag()",1000);
		
		return true;
	}else {
		try {
			clearInterval(ckInterval);
		} catch (e){}
		setInterval("setRedflag()",1000);
		
		if(isnewVersion && alertMsg != ""){
			return alertMsg;
		} else {
			return false;
		}
	}
}


//干预提交

function doIntervenor(_this){
//	alert("-1--doIntervenor---");

	
	if(_this == null || _this == undefined){
		_this = jQuery("#doIntervenor");
	}
	
	if(dochecksubmit()){
	   if(!isNeedAffirmance() && !confirm(""+SystemEnv.getHtmlNoteName(4070))){
	       return false;
	   }
		setPageAllButtonDisabled();
		loadstatus(_this);
		
		$('#src').val("intervenor");
		$('#workflowfrm').submit();
		
		try {
			clearInterval(ckInterval);
		} catch (e){}
		setInterval("setRedflag()",1000);
		
		return true;
	}else {
		try {
			clearInterval(ckInterval);
		} catch (e){}
		setInterval("setRedflag()",1000);
		
		if(isnewVersion && alertMsg != ""){
			return alertMsg;
		} else {
			return false;
		}
	}
}


function dosubmit(_this){
	if(isSubmitDirectNode == "1") {
		if(jQuery("#SubmitToNodeid").length > 0) {
			jQuery("#SubmitToNodeid").val(lastnodeid);
		}
	}
	if(_this == null || _this == undefined){
		_this = jQuery("#dosubmit");
	}
	
	if(dochecksubmit()){
		setPageAllButtonDisabled();
		submitFun ="dosubmit";
		if(locateAgain() == false){
				return false;
		}
		if(locateCheck() == false){
			setPageAllButtonEnable();
			return false;
		}
		loadstatus(_this);
		
		$('#src').val("submit");
		$('#workflowfrm').submit();
		
		try {
			clearInterval(ckInterval);
		} catch (e){}
		setInterval("setRedflag()",1000);
		
		return true;
	}else {
		try {
			clearInterval(ckInterval);
		} catch (e){}
		setInterval("setRedflag()",1000);
		
		if(isnewVersion && alertMsg != ""){
			return alertMsg;
		} else {
			return false;
		}
	}
}

function dosave(_this){
	if(_this == null || _this == undefined){
		_this = jQuery("#dosave");
	}
	if(dochecksave()){
	$("#requestURI").val(window.location.href);
    setPageAllButtonDisabled();
    loadstatus(_this);
	$('#src').val("save");
    $('#workflowfrm').submit();
	return true;
	}else{
		try {
			clearInterval(ckInterval);
		} catch (e){}
		setInterval("setRedflag()",1000);
		
		if(isnewVersion && alertMsg != ""){
			return alertMsg;
		} else {
			return false;
		}
	}
}

function dosubnoback(_this){
	if(isSubmitDirectNode == "1") {
		if(jQuery("#SubmitToNodeid").length > 0) {
			jQuery("#SubmitToNodeid").val(lastnodeid);
		}
	}
	if(_this == null || _this == undefined){
		_this = jQuery("#dosubnoback");
	}
	

	if(dochecksubmit()){
		setPageAllButtonDisabled();
		submitFun ="dosubnoback";
		if(locateAgain() == false){
			return false;
		}
		if(locateCheck() == false){
			setPageAllButtonEnable();
			return false;
		}
		loadstatus(_this);

		$('#src').val("subnoback");
		$('#workflowfrm').submit();
		
		try {
			clearInterval(ckInterval);
		} catch (e){}
		setInterval("setRedflag()",1000);
		
		return true;
	}else{
		try {
			clearInterval(ckInterval);
		} catch (e){}
		setInterval("setRedflag()",1000);
		
		if(isnewVersion && alertMsg != ""){
			return alertMsg;
		} else {
			return false;
		}
	}
}

/* 校验是提交前自动定位的字段重新获取位置 */
function locateAgain(){

	if(autoLocateFlag == 0){	
		if(locatingFields.length >0){
			alert(SystemEnv.getHtmlNoteName(4087)); //存在位置字段正在定位,请稍后再试！
			setPageAllButtonEnable();
			return false;
		}			
		if(autoLocate() == false){ //无自动定位字段
			return true;
		}
		autoLocateFlag = 1;
		return false;
	}else{
		autoLocateFlag = 0;
		return true;
	}
}

function doSubmitDirect(_this, isBack) {
	if(jQuery("#SubmitToNodeid").length > 0) {
		jQuery("#SubmitToNodeid").val(lastnodeid);
	}
	if(isBack == 1) {
		dosubmit(_this);
	}else if(isBack == 2) {
		dosubnoback(_this);
	}else if(isBack == 3) {
		dosubback(_this);
	}
}

function dosubback(_this){
	if(isSubmitDirectNode == "1") {
		if(jQuery("#SubmitToNodeid").length > 0) {
			jQuery("#SubmitToNodeid").val(lastnodeid);
		}
	}
	if(_this == null || _this == undefined){
		_this = jQuery("#dosubback");
	}
	
	
	if(dochecksubmit()){
		setPageAllButtonDisabled();
		submitFun ="dosubback";
		if(locateAgain() == false){
			return false;
		}	
		if(locateCheck() == false){
			setPageAllButtonEnable();
			return false;
		}	
		loadstatus(_this);
		
		$('#src').val("subback");
		$('#workflowfrm').submit();
		
		try {
			clearInterval(ckInterval);
		} catch (e){}
		setInterval("setRedflag()",1000);
		
		return true;
	}else{
		try {
			clearInterval(ckInterval);
		} catch (e){}
		setInterval("setRedflag()",1000);
		
		if(isnewVersion && alertMsg != ""){
			return alertMsg;
		} else {
			return false;
		}
	}
}

function docheckforward(){
	return remarksignCheck();
}

//供客户端调用获取图片相关信息。   
//fid 附件ID号 ，  filename 文件名称 ，   fieldID  字段ID号  ，  docID  文档ID号
function editAppendix(fid, fname, fieldID, docID){
	fname = encodeURIComponent(fname);
	var url = "/download.do?download=1&fileid="+fid+"&filename=" + fname +"&uploadKey=" + uploadKey;
    var paramID = "edit_" + fieldID + "_" + docID;
    var uploadKey = jQuery("#" + paramID).val();
    if(uploadKey == null || uploadKey == undefined){
    	uploadKey = "";
    }
    var val = "emobile:download:getAppendfix:" + docID + ":" + fieldID + ":" + url + ":" + uploadKey;
    location = val; 
}

//客户端程序对附件编辑完成保存时候调用引方法
function getAppendfix(fieldID, docID, uploadKey){
	var strData = uploadKey;
	if(strData != null && strData != ""){
		var len = strData.length - 1;
		if(strData.lastIndexOf(";") == len){
			strData = strData.substr(0, len);
		}
		
		var spanID = "update_" + fieldID + "_" + docID;
		var paramID = "edit_" + fieldID + "_" + docID;
		//先判断该文档是否已作编辑操作，如果是则先把之前的数据作删除
		var $spanObj = jQuery("#" + spanID);
		$spanObj.each(
		    function(i){
		    	jQuery(this).remove();
		    })
		
		var strHtm = jQuery("#" + fieldID + "_span").html();
		var strFrag = "";
		
		strFrag += "<div id='" + spanID + "' style='display:none'>";
		strFrag += "<input type='hidden' id='" + paramID + "' name='"+ paramID + "' value='" + strData + "'  ></div >";
		jQuery("#" + fieldID + "_span").html(strHtm + strFrag);
        dosave();
	}
}


//添加 附件上传字段 内容
function addAppendix(fieldID, canDel){
	if(typeof(canDel) == "undefined")
		canDel = "true";
	var canDel_symbol = canDel=="true"?"1":"0";
	//理论上应该控制能否删除附件，受客户端版本限制，标准暂不修改
    //var url = "emobile:upload:setAppendix:" + fieldID + ":" + event.clientY + ":" + "clearAppendix"+":"+canDel_symbol;
    var url = "emobile:upload:setAppendix:" + fieldID + ":" + event.clientY + ":" + "clearAppendix";
    location = url; 
}
//附件上传字段 回调方法
function setAppendix(fileName, strData, fieldID){
	if(strData != null && strData != ""){
		var len = strData.length - 1;
		if(strData.lastIndexOf(";") == len){
			strData = strData.substr(0, len);
		}
		
		var cnt = jQuery("#cnt" + fieldID).val();
		var strHtm = jQuery("#" + fieldID + "_span").html();
		var strFrag = "";
		strFrag += "<div id='addNew_" + fieldID + "_" + cnt + "'><span>" + fileName + "</span >&nbsp;&nbsp;";
		strFrag += "<input type='hidden' id='"+ fieldID +"name_" + cnt + "' name='"+ fieldID +"name_" + cnt + "' value='" + fileName + "' >";
		strFrag += "<input type='hidden' id='"+ fieldID +"_" + cnt + "' name='"+ fieldID + "_" + cnt + "' value='" + strData + "'  >&nbsp;&nbsp;";
		strFrag += "<a href=\"javascript:delAppendix('#" + fieldID + "','#addNew_" + fieldID + "_" + cnt + "')\"><img src='/images/delete_wev8.gif' /></a><br/><br/></div >";
		jQuery("#" + fieldID + "_span").html(strHtm + strFrag);
		
		if(fieldID.indexOf("_")!=-1){
			var strFrag_d = filestrFn(fieldID,cnt,fileName,strData,"_d")
			var strFrag_show = filestrFn(fieldID,cnt,fileName,strData,"_show")
			
			strHtm = jQuery("#" + fieldID + "_span_d").html();
			jQuery("#" + fieldID + "_span_d").append(strFrag_d);
			
			var isshowname = fieldID.replace("_","").replace("field","");
			var isshowvalue = jQuery("#"+isshowname).val();
			jQuery("#"+isshowvalue).append(strFrag_show);
			
			var fieldHtm = jQuery("#"+fieldID + "_span").html();
			var $appendIsmand_d = jQuery("#"+fieldID + "_d_ismandspan");
			if(fieldHtm == ""){
				$appendIsmand_d.show();
			}else{
				$appendIsmand_d.hide();
			}
		}
		
		
		//给当前字段所添加附件数加1，并保存到隐藏表单域中。
		cnt = parseInt(cnt, 10) + 1;
		jQuery("#cnt" + fieldID).val(cnt);
		
		//如果附件上传 字段值原本为空，则将该值设为非空，避免表单提交验证不通过。
		var $fieldObj = jQuery("#" + fieldID);
		if($fieldObj.val() == ""){
			$fieldObj.val("-1");
		}
	}
}

function filestrFn(fieldID,cnt,fileName,strData,str){
	var strFrag = "";
	strFrag += "<div id='addNew_" + fieldID + "_" + cnt +str+ "'><span>" + fileName + "</span >&nbsp;&nbsp;";
	if(str!="_show"){
		strFrag += "<a href=\"javascript:delAppendix('#" + fieldID + "','#addNew_" + fieldID + "_" + cnt + "')\"><img src='/images/delete_wev8.gif' /></a><br/><br/></div >";
	}
	return strFrag;
}


//删除附件上传数据
function delAppendix(fieldID, appID){
	if(confirm(sureToDeleteWord)){
		jQuery(appID).remove();
		if(fieldID.indexOf("_")!=-1){
			var appid_d = appID.replace("#","");
			jQuery("div[id^="+appid_d+"]").each(function(){
				jQuery(this).remove();
			});
			
			var fieldHtm_d = jQuery(fieldID + "_span").html().trim();
			var appendIsmand_d = jQuery(fieldID + "_d_ismandspan");
			var appendIsmand_nd = jQuery(fieldID + "_ismandspan");
			var appendIsmand_isedit = jQuery("#oldfieldview" + fieldID.replace("#field","")).val();
			var appendIsmand_vtype = jQuery(fieldID+"_tdwrap").attr("vtype");
			if(appendIsmand_vtype==null||appendIsmand_vtype==undefined||appendIsmand_vtype==""){
			     appendIsmand_vtype = -1;
			}
			if(fieldHtm_d == ""){
			    var tempclass = appendIsmand_nd.attr("class");
			    if(tempclass==undefined||tempclass==null) tempclass = "";
			    
			    if (tempclass != "" && tempclass.indexOf("ismand") != -1) {
				    appendIsmand_d.show();
				}else{
				    if(appendIsmand_vtype == 2){
				        appendIsmand_d.show();
				    }else{
				        if(appendIsmand_vtype == -1 && appendIsmand_isedit==3){
				            appendIsmand_d.show();
				        }else{				            
				            appendIsmand_d.hide();        
				        }
				    }
				}
			}else{
				appendIsmand_d.hide();
			}
		}
		
		if(appID.indexOf("#appDix_") == 0){
			//如果删除的附件是已经存入到服务器端的数据，则记录该ID号，待提交表单后后台程序来删除该附件。
			var appendID = appID.substr(8);
			var fieldVal = jQuery(fieldID).val();
			fieldVal = fieldVal.replace(appendID, "")
			jQuery(fieldID).val(fieldVal);
		}
		
		//如果附件上传 字段值原本为空，则检查当前字段是否还有值，如果没有则显示必填标记。
		var fieldHtm = jQuery(fieldID + "_span").html().trim();
		var $appendIsmand = jQuery(fieldID + "_ismandspan");
		if(fieldHtm == "" && $appendIsmand.size() != 0){
			if ($appendIsmand.attr("class") != "" && $appendIsmand.attr("class").indexOf("ismand") != -1) {
				$appendIsmand.show();
			}
			jQuery(fieldID).val("");
		}
		
	}
}
//清除附件上传字段
function clearAppendix(fieldID){
    jQuery("#" + fieldID).val("");
    jQuery("#cnt" + fieldID).val(0);
    jQuery("#" + fieldID + "_span").html("");
    //var $appendIsmand = jQuery("#" + fieldID + "_ismandspan");
    //if($appendIsmand.size() != 0){
    	//$appendIsmand.css("display","none");
    //}
    
    if(fieldID.indexOf("_")!=-1){
    	jQuery("#" + fieldID + "_span_d").html("");
    	var isshowname = fieldID.replace("_","").replace("field","");
		var isshowvalue = jQuery("#"+isshowname).val();
		jQuery("#"+isshowvalue).html("");
		
		var fieldHtm_d = jQuery.trim(jQuery(fieldID + "_span").html());
		var appendIsmand_d = jQuery("#"+fieldID + "_d_ismandspan");
        var appendIsmand_nd = jQuery("#"+fieldID + "_ismandspan");
        if(appendIsmand_d.length==0){
            jQuery("#" + fieldID + "_span_d").after("<span id='" + fieldID+"_d_ismandspan' style='color: red;font-size: 16pt;float:right;display:none'>!</span>");
        }
        appendIsmand_d = jQuery("#"+fieldID + "_d_ismandspan");
        var appendIsmand_isedit = jQuery("#oldfieldview" + fieldID.replace("field","")).val();
        var appendIsmand_vtype = jQuery("#"+fieldID+"_tdwrap").attr("vtype");
        if(appendIsmand_vtype==null||appendIsmand_vtype==undefined||appendIsmand_vtype==""){
             appendIsmand_vtype = -1;
        }
        if(fieldHtm_d == ""){
            var tempclass = appendIsmand_nd.attr("class");
            if(tempclass==undefined||tempclass==null) tempclass = "";
            //alert("fieldID = "+fieldID+" fieldHtm_d="+fieldHtm_d+" tempclass="+tempclass+" appendIsmand_vtype="+appendIsmand_vtype+" appendIsmand_isedit="+appendIsmand_isedit+"/"+appendIsmand_d.length);
            if (tempclass != "" && tempclass.indexOf("ismand") != -1) {
                appendIsmand_d.show();
            }else{
                if(appendIsmand_vtype == 2){
                    appendIsmand_d.show();
                }else{
                    if(appendIsmand_vtype == -1 && appendIsmand_isedit==3){
                        appendIsmand_d.show();
                    }else{                          
                        appendIsmand_d.hide();        
                    }
                }
            }
        }else{
            appendIsmand_d.hide();
        }
	}
}


//录制语音附件
function getSpeechAttachment(){
	var url="emobile:speech:setSpeechAttachment:fieldSpeechAppend";
	location = url;
}
//录制语音附件  回调方法
function setSpeechAttachment(strData){
	if(strData != "" && strData != null){
		var strHtml = "";
		strHtml += "<div class='voicebox'> <div class='outBox'> <div class='innerBox'>";
		strHtml += "	<div class='playbox'> <a href='emobile:play:fieldSpeechAppend'><div class='playButtonStyle'></div ></a > </div >";
		strHtml += "	<div class='outBoxSchedule'> <div class='schedule'></div > <div class='scheduleBottom'></div > </div >";
		strHtml += "</div > </div > </div > ";
		jQuery("#fieldSpeechAppend").val(strData);
		jQuery("#divSpeechAttachment").html(strHtml);
	}else{
		jQuery("#fieldSpeechAppend").val("");
		jQuery("#divSpeechAttachment").html("");
	}
}

//获取手写签章
function getHandWrittenSign(){
	var url = "emobile:palette:setHandWrittenSign";
	location = url;
}
//获取手写签章  回调方法
function setHandWrittenSign(strData, imgSrc){
	if(strData != "" && strData != null){
		jQuery("#fieldHandWritten").val(strData);
		jQuery('#divHandWrittenSign').html("<img src='" + imgSrc + "'>");
		
		//如果手动输入签字意见输入框未输入任何内容，则将其隐藏
		var $userSignObj = jQuery("#userSignRemark");
		if($userSignObj.val() == ""){
			$userSignObj[0].style.display = "none";
		}
	}else{
		jQuery("#fieldHandWritten").val("");
		jQuery('#divHandWrittenSign').html("");
		
		//将手动输入签字意见输入框状态由隐藏 改为 显示
		var $userSignObj = jQuery("#userSignRemark");
		$userSignObj[0].style.display = "";
	}
}

function addToRemark2(_this) {
	if ($(_this).val()!="0") {
		var remark = $('#userSignRemark').val();
		if (remark != null && remark != "") {
			$('#userSignRemark').val(remark + "\n" +$(_this).val());
		} else {
			$('#userSignRemark').val($(_this).val());
		}
	}
}

function exTblCol(ele, colCount) {
	if (colCount * 100 > $(ele).width()) {
		$(ele).children("TABLE").width(colCount * 100);
	}
}

function winResize(){
	$("div[name='detailTableDiv']").each(function () {
		if ($(this).children("TABLE").width() < $(this).width()) {
			$(this).children("TABLE").width($(this).width());
		}
	});
	
	var $viewMainTable = jQuery("table[class='ViewForm outertable']");
	if($viewMainTable != null){
		if(document.body.clientWidth > $viewMainTable.width()) {
			var tarObj = document.getElementById("view_header");
			if(tarObj != null && tarObj != undefined){
				tarObj.style.width = "100%";
			}
			tarObj = document.getElementById("header");
			if(tarObj != null && tarObj != undefined){
				tarObj.style.width = "100%";
			}
		} else {
			var tarObj = document.getElementById("view_header");
			if(tarObj != null && tarObj != undefined){
				tarObj.style.width = $viewMainTable.width() + 10;
			}
			tarObj = document.getElementById("header");
			if(tarObj != null && tarObj != undefined){
				tarObj.style.width = $viewMainTable.width() + 10;
			}
		}
	}
}

/**
 * 获取url参数
 */
function getMainFormUrlParam() {
	var workflowid = $("input[name='workflowid']").val();
	var requestid = $("input[name='requestid']").val();
	var paras = "userid=" + js_userid + "&sessionkey=" + js_sessionkey + "&module=" + js_module + "&scope=" + js_scope + "&fromRequestId=" + js_fromRequestid + "" +
		"&workflowid=" + workflowid + 
		"&requestid=" + requestid + 
		"&tk" + new Date().getTime() + "=1";
		
      try{
          datas += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
      }catch(e){
      }
	return paras;
}

function doforward(_this){
   //	if(remarksignCheck()){
	//先验证输入，再弹出转发接收人对话框
	//if($("#forwardresourceids").val()==""){
      var url = "/mobile/plugin/browser.jsp";
	  var datas = "&returnIdField=forwardresourceids&returnShowField=forwardresources&method=listUser";
	  datas += "&isMuti=1&requestid=" + js_requestid + "&nodeid=" + js_nodeid;
	  
      try{
          datas += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
      }catch(e){
      }
	  showDialog(url, datas);
	/*}else{
	   if(docheckforward()){
			$('#src').val("forward");
			$('#forwardflag').val("1");
			$('#workflowfrm').submit();
			return true;
	   }

	    if(isnewVersion && alertMsg != "" && isMustInputRemark()
        && $('#userSignRemark').val()==""){
			return alertMsg;
		} else {
			try {
		      clearInterval(ckInterval);
	       } catch (e){}
		     setInterval("setRedflag()",1000);
			return false;
		}
	}
	}*/
}

//征求意见
function doforward2(_this){

	if(remarksignCheck()){
	//先验证输入，再弹出转发接收人对话框
	if($("#forwardresourceids2").val()==""){
      var url = "/mobile/plugin/browser.jsp";
	  var datas = "&returnIdField=forwardresourceids2&returnShowField=forwardresources2&method=listUser";
	  datas += "&isMuti=1&forwardflag=2&requestid=" + js_requestid + "&nodeid=" + js_nodeid;
	  
      try{
          datas += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
      }catch(e){
      }
	  showDialog(url, datas);
	}else{
	   if(docheckforward()){
			$('#src').val("forward");
			$('#forwardflag').val("2");
			$('#workflowfrm').submit();
			return true;
	   }
	
	  	}
		}


		//电子签章
		var $elecSignObj = jQuery("#markId");
		//检查手写签批 和 语音附件
		var handWrittenObj = jQuery("#fieldHandWritten");
		var speechAppendObj = jQuery("#fieldSpeechAppend");
		var flagHandWritten = (handWrittenObj.size() == 0 || handWrittenObj.val() == "");
		var flagSpeechAppend = (speechAppendObj.size() == 0 || speechAppendObj.val() == "");


    if(isnewVersion && isMustInputRemark()
        && $('#userSignRemark').val()=="" && speechAppendObj.val() == "" && handWrittenObj.val() == "" && $elecSignObj.val() == ""){
		  alertMsg = "emobile:Message:请填写签字意见！:" + promptWrod;
			return alertMsg;
		} else {
			try {
		      clearInterval(ckInterval);
	       } catch (e){}
		     setInterval("setRedflag()",1000);
			return false;
	    }

	
	
	
}


//转办
function doforward3(_this){

		if(remarksignCheck()){
	//先验证输入，再弹出转发接收人对话框
	if($("#forwardresourceids3").val()==""){
      var url = "/mobile/plugin/browser.jsp";
	  var datas = "&returnIdField=forwardresourceids3&returnShowField=forwardresources3&method=listUser";
	  datas += "&isMuti=0&forwardflag=3&requestid=" + js_requestid + "&nodeid=" + js_nodeid;
	  
      try{
          datas += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
      }catch(e){
      }
	  showDialog(url, datas);
	}else{
	   if(docheckforward()){
			$('#src').val("forward");
			$('#forwardflag').val("3");
			$('#workflowfrm').submit();
			return true;
	   }
	  }
	}


	//电子签章
		var $elecSignObj = jQuery("#markId");
		//检查手写签批 和 语音附件
		var handWrittenObj = jQuery("#fieldHandWritten");
		var speechAppendObj = jQuery("#fieldSpeechAppend");
		var flagHandWritten = (handWrittenObj.size() == 0 || handWrittenObj.val() == "");
		var flagSpeechAppend = (speechAppendObj.size() == 0 || speechAppendObj.val() == "");
		
       if(isnewVersion && isMustInputRemark()
        && $('#userSignRemark').val()=="" && speechAppendObj.val() == "" && handWrittenObj.val() == "" && $elecSignObj.val() == ""){
			alertMsg = "emobile:Message:请填写签字意见！:" + promptWrod;
			return alertMsg;
		} else {
			try {
		      clearInterval(ckInterval);
	       } catch (e){}
		     setInterval("setRedflag()",1000);
			return false;
	    }
		
}

function goWfPic() {
	//window.location.href = "/mobile/plugin/1/workflowPicture.jsp?requestid=" + js_requestid +"&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&fromRequestid=" + js_fromRequestid + "&clientver=" + js_clientVer+"&fromES="+js_fromES;
	
    var locationHref = "/mobile/plugin/1/workflowPicture.jsp?requestid=" + js_requestid +"&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&fromRequestid=" + js_fromRequestid + "&clientver=" + js_clientVer+"&fromES="+js_fromES;
    
    try{
        locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
    }catch(e){
    }
    window.location.href = locationHref;
}
function goWfStatus() {
	//window.location.href = "/mobile/plugin/1/workflowStatus.jsp?requestid=" + js_requestid +"&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&fromRequestid=" + js_fromRequestid + "&clientver=" + js_clientVer+"&fromES="+js_fromES;
	
    var locationHref = "/mobile/plugin/1/workflowStatus.jsp?requestid=" + js_requestid +"&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&fromRequestid=" + js_fromRequestid + "&clientver=" + js_clientVer+"&fromES="+js_fromES;
    
    try{
        locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
    }catch(e){
    }
    window.location.href = locationHref;
}

function goBack() {
	var temp_fromReqId = 0;
	//防止js报错，添加try，catch
	var temp_js_fromES = "false";
	var temp_js_fromTask = "false";
	var temp_js_scope = "";
	try {
		temp_fromReqId = parseInt(js_fromRequestid);
	} catch (e) {
	}
    try {
        temp_js_fromES = js_fromES;
    } catch (e) {
    }
    try {
        temp_js_fromTask = js_fromTask;
    } catch (e) {
    }
    try {
        temp_js_scope = js_scope;
    } catch (e) {
    }
	if(temp_fromReqId > 0){
		//location = "/mobile/plugin/1/view.jsp?requestid=" + js_fromRequestid + "&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&clientver=" + js_clientVer;
		
	    var locationHref = "/mobile/plugin/1/view.jsp?requestid=" + js_fromRequestid + "&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&clientver=" + js_clientVer;
	    
	    try{
	        locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
	    }catch(e){
	    }
	    location = locationHref;
	} else {
		if(temp_js_fromES=="true"){
		    //location = "/mobile/plugin/fullsearch/list.jsp?fromES=true&module=" + js_module + "&scope=" + js_scope;
		    
	        var locationHref = "/mobile/plugin/fullsearch/list.jsp?fromES=true&module=" + js_module + "&scope=" + js_scope;
	        
	        try{
	            locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
	        }catch(e){
	        }
	        location = locationHref;
		}else if(temp_js_fromTask=="true"){
			//location = "/mobile/plugin/task/taskDetail.jsp?&module=" + js_module + "&scope=" + js_scope;
			
            var locationHref = "/mobile/plugin/task/taskDetail.jsp?&module=" + js_module + "&scope=" + js_scope;
            
            try{
                locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
            }catch(e){
            }
            location = locationHref;
		}else{
		   if(temp_js_scope==-1){
     		  location = "/home.do";
		   }else{
			  location = "/list.do?module=" + js_module + "&scope=" + js_scope + ""; 
		   }
		}
	}
}

function toDocument(docid){
	//location = '/mobile/plugin/2/view.jsp?detailid='+docid+'&module=' + js_module + '&scope=' + js_scope + '&fromWF=true&requestid=' + js_requestid + '&fromRequestid=' + js_fromRequestid + '&showAll=true&clientver=' + js_clientVer;
	
    var locationHref = '/mobile/plugin/2/view.jsp?detailid='+docid+'&module=' + js_module + '&scope=' + js_scope + '&fromWF=true&requestid=' + js_requestid + '&fromRequestid=' + js_fromRequestid + '&showAll=true&clientver=' + js_clientVer;
    
    try{
        locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
    }catch(e){
    }
    location = locationHref;
}

function toRequest(requestid){

    var tempfromRequestid = 0;
    try{
        tempfromRequestid = js_fromRequestid;
    }catch(e){
    }
    if(tempfromRequestid == undefined || tempfromRequestid == null || tempfromRequestid == 0){
        tempfromRequestid = $("input[name='requestid']").val();
    }
	if (isnewVersion) {
		//location = '/mobile/plugin/1/client.jsp?requestid='+requestid+'&module=' + js_module + '&scope=' + js_scope + '&fromWF=true&fromRequestid=' + js_requestid + '&clientver=' + js_clientVer;
		
        var locationHref = '/mobile/plugin/1/client.jsp?requestid='+requestid+'&module=' + js_module + '&scope=' + js_scope + '&fromWF=true&fromRequestid=' + tempfromRequestid + '&clientver=' + js_clientVer;
        
        try{
            locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
        }catch(e){
        }
        location = locationHref;
	} else {
		//location = '/mobile/plugin/1/view.jsp?requestid='+requestid+'&module=' + js_module + '&scope=' + js_scope + '&fromWF=true&fromRequestid=' + js_requestid + '&clientver=' + js_clientVer;
		
        var locationHref = '/mobile/plugin/1/view.jsp?requestid='+requestid+'&module=' + js_module + '&scope=' + js_scope + '&fromWF=true&fromRequestid=' + tempfromRequestid + '&clientver=' + js_clientVer;
        
        try{
            locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
        }catch(e){
        }
        location = locationHref;
	}
}

function toMeeting(meetingID){
	location = '/mobile/plugin/5/detail.jsp?id='+meetingID+'&module=' + js_module + '&scope=' + js_scope + '&fromWF=true&requestid=' + js_requestid + '&fromRequestid=' + js_fromRequestid + '&showAll=true&clientver=' + js_clientVer;
	
    var locationHref = '/mobile/plugin/5/detail.jsp?id='+meetingID+'&module=' + js_module + '&scope=' + js_scope + '&fromWF=true&requestid=' + js_requestid + '&fromRequestid=' + js_fromRequestid + '&showAll=true&clientver=' + js_clientVer;
    
    try{
        locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
    }catch(e){
    }
    location = locationHref;
}

function toDownload(fid,fname,isopenwin) {
	fname = encodeURIComponent(fname);// 含有%等特殊字符字段手机端下载不了问题，url前端无法解析，encode 下。
	if(isopenwin){
		//if(fid) location = "/download.do?fileid="+fid+"&filename="+fname+"&fromWF=true&requestid=" + js_requestid +"&module=" + js_module + "&scope=" + js_scope + "";
		if(fid){
	        var locationHref = "/download.do?fileid="+fid+"&filename="+fname+"&fromWF=true&requestid=" + js_requestid +"&module=" + js_module + "&scope=" + js_scope + "";
	        
	        try{
	            locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
	        }catch(e){
	        }
	        location = locationHref;
		}
	} else {
		//window.open("/download.do?download=1&fileid="+fid+"&filename="+fname,'_blank');
		var locationHref = "/download.do?download=1&fileid="+fid+"&filename="+fname
        try{
            locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
        }catch(e){
        }
        window.open(locationHref,'_blank');
	}
}

function detailview(contentId) {
	//location = "/mobile/plugin/1/detailview.jsp?userid=" + js_userid + "&sessionkey=" + js_sessionkey + "&workflowId=" + js_workflowid + "&content=" + $("#" + contentId).val() + "&_tok=" + new Date().getTime();
	
    var locationHref = "/mobile/plugin/1/detailview.jsp?userid=" + js_userid + "&sessionkey=" + js_sessionkey + "&workflowId=" + js_workflowid + "&content=" + $("#" + contentId).val() + "&_tok=" + new Date().getTime();
    
    try{
        locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
    }catch(e){
    }
    location = locationHref;
}

function toURL(url,isopenwin){
	if(!isopenwin){
		if(url) location = url+"&fromWF=true&requestid=" + js_requestid +"&module=" + js_module + "&scope=" + js_scope + "";
	} else {
		window.open(url,'_blank');
	}
}
//退回
function doreject2(_this, isselectrejectnode){
	if(_this == null || _this == undefined){
		_this = jQuery("#doreject");
	}
	//先检查是否当前是否满足退回的条件(是否需要取消套红，签章意见是否必填)
	if(docheckreject()){
		if (isselectrejectnode) {
			var url = "/mobile/plugin/browser.jsp";
			var locationHref = "&returnIdField=rejectToNodeid&returnShowField=rejectToNodeName&method=listBrowserData&browserTypeId=-9&customBrowType=" + js_workflowid + "|" + js_requestid + "|" + js_nodeid + "&isMuti=0";
            try{
                locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
            }catch(e){
            }
			var datas = encodeURI(locationHref);
			
			showDialog(url, datas);
			return false;
		} else {
			setPageAllButtonDisabled();
			
			submitFun ="doreject2";
			if(locateAgain() == false){
				return false;
			}	
			if(locateCheck() == false){
				setPageAllButtonEnable();
				return false;
			}	
			
			loadstatus(_this);
			$('#src').val("reject");
			$('#workflowfrm').submit();
			return true;
		}
	}else{
		if(isnewVersion && alertMsg != ""){
			return alertMsg;
		} else {
			return false;
		}
	}
}

function docheckreject2(istempletStatus){
	if (istempletStatus) {
		if(isnewVersion){
			alertMsg = "emobile:Message:请先取消套红！:" + promptWrod;
			return alertMsg;
		} else {
			$.alert('请先取消套红！', promptWrod);
			return false;
		}
	} else {
		return remarksignCheck("reject");
	}
}

/* 校验定位是否成功 */
function locateCheck(){
	try{
		for (var i=0; i<window._autoLocateFields.length; i++) {
			var autofield = window._autoLocateFields[i];
			if(jQuery("input[name='mustInput"+autofield+"']").val() == "0"){
				return false;
			}
		}
		return true;
	}catch(e){
		return true;
	}
}


function docheckClose(){
    if($("#showcardhidden").length>0&&$("#showcardhidden").val()=='1'){
		   $("#"+$("#showcardhidden").attr("closeAttr")).click();
		   
	}
}

function dochecksave(){
	showPoPRemarkWindow();
	docheckClose();
	var flag = true;
			jQuery("input[name='ismandfield']").each(function() {
			if(jQuery(this).attr("_uncheckmand") == "y")
				return true;
			var field = document.getElementById(this.value);
			if(this.value=='requestname'){
			if(field && flag){
				if(field.value==null || field.value.trim()=="" ){  
                     var mobilemessinfo="请填写标题字段!";
					if($(field).attr("filenamebak") !=undefined&&$(field).attr("filenamebak")!=null){
						 mobilemessinfo= "\""+$(field).attr("filenamebak")+"\"未填写！";
					}
					if(isnewVersion){
						alertMsg = "emobile:Message:"+mobilemessinfo+":" + promptWrod;
						flag = false;
					} else {
						$.alert(mobilemessinfo, promptWrod);
						flag = false;
						return false;
					}
				}else{
					return flag;
				}
			}
			}else{
				return flag;
			}
		});
	return flag;
		
}

function dochecksubmit(){
	showPoPRemarkWindow();
	docheckClose();
	if(autoLocateFlag == 1){  //提交时自动重新获取位置后的再次提交，不需要再次验证以下条件
		return true;
	}
    //获取是否是签章节点
	var isTempletStatus = false;
	var isSignatureStatus = false;//签章
	try {
		//防止主表部分未加载完毕
		isTempletStatus = getTempletStatus();
		isSignatureStatus = getSignatureStatus();
	} catch (e) {}
	
	var flag = true;
	if (isTempletStatus) {
		if(isnewVersion){
			alertMsg = "emobile:Message:请先执行套红操作！:" + promptWrod;
			flag = false;
		} else {
			$.alert('请先执行套红操作！', promptWrod);
			flag = false;
			return false;
		}
	} 
	
	if(flag){
		try{
		  var messageInfo=needAddRow();
		  if(messageInfo!=""){
			   if(isnewVersion){
						alertMsg = "emobile:Message:"+messageInfo+":" + promptWrod;
						flag = false;
			} else {
						$.alert(messageInfo, promptWrod);
						flag = false;
						return false;
			}
		  }
        }catch(e){}

		jQuery("input[name='ismandfield']").each(function() {
			if(jQuery(this).attr("_uncheckmand") == "y")
				return true;
			var field = document.getElementById(this.value);
			if(field && flag){
				if(field.value==null || field.value.trim()=="" ){  
					 var mobilemessinfo="请填写相关字段!";
					if($(field).attr("filenamebak") !=undefined&&$(field).attr("filenamebak")!=null){
						 mobilemessinfo= "\""+$(field).attr("filenamebak")+"\"未填写！";
					}
					if(isnewVersion){
						alertMsg = "emobile:Message:"+mobilemessinfo+":" + promptWrod;
						flag = false;
					} else {
					    $.alert(mobilemessinfo, promptWrod);
						flag = false;
						return false;
					}
				}
			}
		});
		
		jQuery("input[name='mustInput']").each(function() {
			if(flag){
				if(this.value == 0){  
					var mobilemessinfo="请填写相关字段!";
					if($(field).attr("filenamebak") !=undefined&&$(field).attr("filenamebak")!=null){
						 mobilemessinfo= "\""+$(field).attr("filenamebak")+"\"未填写！";
					}
					if(isnewVersion){
						alertMsg = "emobile:Message:"+mobilemessinfo+":" + promptWrod;
						flag = false;
					} else {
						$.alert(mobilemessinfo, promptWrod);
						flag = false;
						return false;
					}
				}
			}
		});
	}
	if(getLocateStatus(0)==2){
			if(jQuery("#remarkLocation").val()==""){
				$.alert('请在签入意见中插入位置');
				return false;
			}else{
				return true;
			}
	}

	//单据相关字段的验证
	
	//出差单据对开始日期和结束日期的验证
	if (js_isBill == "1" && js_formid == "181") {
		if(flag) {
			//先比较日期
			var fromDate = "";
			var toDate = "";
			try{
				fromDate = jQuery("input[nameBak='fromDate']").val();
				toDate = jQuery("input[nameBak='toDate']").val();
				fromDate = fromDate.replace(/-/g, "");
				toDate = toDate.replace(/-/g, "");
				if(fromDate > toDate){
					if(isnewVersion){
						alertMsg = "emobile:Message:" + cj_mes_timeWord + ":" + promptWrod;
						flag = false;
					} else {
						$.alert(cj_mes_timeWord, promptWrod);
						flag = false;
						return false;
					}
				}
			}catch(e){}
			
			//如果日期相等，需要再比较时间
			if(flag && (fromDate == toDate)){
				try{
					var fromTime = jQuery("input[nameBak='fromTime']").val();
					var toTime = jQuery("input[nameBak='toTime']").val();
					if(fromTime.replace(":","") >= toTime.replace(":","")){
						if(isnewVersion){
							alertMsg = "emobile:Message:" + cj_mes_timeWord + ":" + promptWrod;
							flag = false;
						} else {
							$.alert(cj_mes_timeWord, promptWrod);
							flag = false;
							return false;
						}
					}
				}catch(e){}
			}
		}
	}
	//请假申请单对开始日期和结束日期的验证
	if (js_isBill == "1" && js_formid == "180") {
		if(flag) {
			//先比较日期
			var fromDate = "";
			var toDate = "";
			try{
				fromDate = jQuery("input[nameBak='fromDate']").val();
				toDate = jQuery("input[nameBak='toDate']").val();
				fromDate = fromDate.replace(/-/g, "");
				toDate = toDate.replace(/-/g, "");
				if(fromDate > toDate){
					if(isnewVersion){
						alertMsg = "emobile:Message:" + cj_mes_timeWord + ":" + promptWrod;
						flag = false;
					} else {
						$.alert(cj_mes_timeWord, promptWrod);
						flag = false;
						return false;
					}
				}
			}catch(e){}
			
			//如果日期相等，需要再比较时间
			if(flag && (fromDate == toDate)){
				try{
					var fromTime = jQuery("input[nameBak='fromTime']").val();
					var toTime = jQuery("input[nameBak='toTime']").val();
					if(fromTime.replace(":","") >= toTime.replace(":","")){
						if(isnewVersion){
							alertMsg = "emobile:Message:" + cj_mes_timeWord + ":" + promptWrod;
							flag = false;
						} else {
							$.alert(cj_mes_timeWord, promptWrod);
							flag = false;
							return false;
						}
					}
				}catch(e){}
			}
		}
		if(flag){
			try {
				var leaveTypeObj = jQuery("[nameBak='newLeaveType']").val();
				var strleaveTypes = jQuery("#strleaveTypes").val();
				if(leaveTypeObj != ""){
					//当前请假天数
					var leaveDays = parseFloat(jQuery("[nameBak='leaveDays']").val());
					//年假
					if(leaveTypeObj == "-6"){
						//当前可用年假天数
						var allAnnualDays = parseFloat(jQuery("#allannualdays").val());
						if(allAnnualDays > 0){
							if(leaveDays > allAnnualDays){
								if(isnewVersion){
									alertMsg = "emobile:Message:" + cj_bohaiLeave2_1 + ":" + promptWrod;
									flag = false;
								} else {
									$.alert(cj_bohaiLeave2_1, promptWrod);
									flag = false;
									return false;
								}
							}
						} else {
							//可用 年假数为0
							if(isnewVersion){
								alertMsg = "emobile:Message:" + cj_bohaiLeave2_2 + ":" + promptWrod;
								flag = false;
							} else {
								$.alert(cj_bohaiLeave2_2, promptWrod);
								flag = false;
								return false;
							}
						}
					//带薪病假
					} else if(leaveTypeObj == "-12"){
						//当前可用带薪病假天数
						var allPsllDays = parseFloat(jQuery("#allpsldays").val());
						if(allPsllDays > 0){
							if(leaveDays > allPsllDays){
								if(isnewVersion){
									alertMsg = "emobile:Message:" + cj_bohaiLeave11_1 + ":" + promptWrod;
									flag = false;
								} else {
									$.alert(cj_bohaiLeave11_1, promptWrod);
									flag = false;
									return false;
								}
							}
						} else {
							//可用 带薪病假数为0
							if(isnewVersion){
								alertMsg = "emobile:Message:" + cj_bohaiLeave11_2 + ":" + promptWrod;
								flag = false;
							} else {
								$.alert(cj_bohaiLeave11_2, promptWrod);
								flag = false;
								return false;
							}
						}
					}else if(leaveTypeObj == "-13"){
						//当前可用调休天数
						var paidLeaveDays = parseFloat(jQuery("#paidLeaveDays").val());
						if(paidLeaveDays > 0){
							if(leaveDays > paidLeaveDays){
								if(isnewVersion){
									alertMsg = "emobile:Message:" + cj_bohaiLeave12_1 + ":" + promptWrod;
									flag = false;
								} else {
									$.alert(cj_bohaiLeave12_1, promptWrod);
									flag = false;
									return false;
								}
							}
						} else {
							//可用调休天数为0
							if(isnewVersion){
								alertMsg = "emobile:Message:" + cj_bohaiLeave12_2 + ":" + promptWrod;
								flag = false;
							} else {
								$.alert(cj_bohaiLeave12_2, promptWrod);
								flag = false;
								return false;
							}
						}
					} else if(leaveTypeObj != '' && strleaveTypes.indexOf(","+leaveTypeObj+",") > -1){
						//当前可用带薪病假天数
						var allPsllDays = parseFloat(jQuery("#allpsldays").val());
						if(allPsllDays > 0){
							if(leaveDays > allPsllDays){
								if(isnewVersion){
									alertMsg = "emobile:Message:" + cj_bohaiLeave11_1 + ":" + promptWrod;
									flag = false;
								} else {
									$.alert(cj_bohaiLeave11_1, promptWrod);
									flag = false;
									return false;
								}
							}
						} else {
							//可用 带薪病假数为0
							if(isnewVersion){
								alertMsg = "emobile:Message:" + cj_bohaiLeave11_2 + ":" + promptWrod;
								flag = false;
							} else {
								$.alert(cj_bohaiLeave11_2, promptWrod);
								flag = false;
								return false;
							}
						}
					} else { }
				}
			} catch (e) { }
		}
	}

		if(js_isBill == "1" && js_formid == "85"){
		//会议起止时间校验
		if(flag){

			var date1=$('#'+beginDate).val();
			var date2=$('#'+endDate).val();
			var time1=$('#'+beginTime).val();
			var time2=$('#'+endTime).val();

			var ss1 = date1.split("-",3);
			var ss2 = date2.split("-",3);

			date1 = ss1[1]+"/"+ss1[2]+"/"+ss1[0] + " " +time1;
			date2 = ss2[1]+"/"+ss2[2]+"/"+ss2[0] + " " +time2;

			var t1,t2;
			t1 = Date.parse(date1);
			t2 = Date.parse(date2);
			if(t1>t2){
				$.alert("开始时间不能大于结束时间！",promptWrod);
				flag=false;
			}
			if(!flag){
				alertMsg="";
			}
		}
		//会议室冲突校验
		if(flag){
		        if(RoomConflictChk == 1 ){
					//forbiddenPage();
				if(!($('#'+repeatType).length>0&&$('#'+repeatType).val()>0)){
					var strData = "&address="+$('#'+Address).val()+"&begindate="+$('#'+beginDate).val()+"&begintime="+$('#'+beginTime).val()+"&enddate="+$('#'+endDate).val()+"&endtime="+$('#'+endTime).val()+"&requestid="+js_requestid ;
					jQuery.ajax({  
						url : encodeURI("/meeting/data/ChkMeetingRoom.jsp?method=chkRoom"+strData),  
						async : false,
						type : "POST",
						data: "",
						dataType : "text",  
						cache: false,
						contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						success : function(datas) {
							if(datas != 0){
								if(RoomConflict == 1){
									flag = confirm(datas.trim()+"\n会议起止时间内会议室使用冲突，是否继续申请？");
				            	
								} else if(RoomConflict == 2) {
									$.alert(datas.trim()+"\n会议室冲突不能提交",promptWrod);
									flag=false;
								}
							}
						}  
					});
				 }
		        }
		     if(!flag){
				alertMsg="";
			}
		      }
				//参会人员冲突校验
			if(flag){
			if(MemberConflictChk == 1 ){
				var hrmval="";
				var crmval="";
				var repeatval=0;
				if(resources!=""){
					if($('#'+resources).length>0){
						hrmval=$('#'+resources).val();
					}
				}
				if(crms!=""){
					if($('#'+crms).length>0){
						crmval=$('#'+crms).val();
					}
				}
				if(repeatType!=""){
					if($('#'+repeatType).length>0){
						repeatval=$('#'+repeatType).val();
					}
				}
				if(repeatval<=0){
				strData = "&memberconflict="+MemberConflict+"&begindate="+$('#'+beginDate).val()+"&begintime="+$('#'+beginTime).val()+"&enddate="+$('#'+endDate).val()+"&endtime="+$('#'+endTime).val()+"&hrmids="+hrmval+"&crmids="+crmval+"&requestid="+js_requestid;
				jQuery.ajax({
						url : encodeURI("/meeting/data/ChkMeetingMember.jsp?userid="+js_userid+strData),  
						async : false,
						type : "POST",
						data: "",
						dataType : "text",  
						cache: false,
						contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						success : function(datas) {
							var dataObj=null;
							if(datas != ''){
								dataObj=eval("("+datas+")");
							}
							if(wuiUtil.getJsonValueByIndex(dataObj, 0) == "0"){
								flag=true;
							} else {
								if(MemberConflict == 1){
									flag = confirm(wuiUtil.getJsonValueByIndex(dataObj, 1));
								} else if(MemberConflict == 2) {
									$.alert(wuiUtil.getJsonValueByIndex(dataObj, 1));
									flag=false;
								}
							}
							
						}  
					}); 
			  }
			  }
			if(!flag){
				alertMsg="";
			}
			}
				
	}
	//签字意见检查
	if (!remarksignCheck() && flag) {
		flag = false;
	}
	
	if (isSignatureStatus && flag) {
		flag = confirm('该节点为签章节点，您未执行签章操作，是否确定提交？');
	}
	
	if (isNeedAffirmance() && flag) {
		flag = confirm(""+SystemEnv.getHtmlNoteName(4070));
	}
	if(document.activeElement.id && document.activeElement.id!=""){
		 if(document.getElementById(document.activeElement.id)
			   &&document.getElementById(document.activeElement.id).getAttribute("onblur")){
              document.getElementById(document.activeElement.id).blur();
		 }
	}
	try{//客户自定义验证事件
	   if(!dobeforecheck() || !checkCustomize()){
           flag = false;
	   }
	}catch(e){}

	try{//手机端自定义验证事件
		var checkMsg = checkCustomize1();
		if("" != checkMsg){
			if(isnewVersion){
				alertMsg = "emobile:Message:" + checkMsg + ":" + promptWrod;
				flag = false;
			} else {
				$.alert(checkMsg, promptWrod);
				flag = false;
				return false;
			}
		}
	}catch(e){}
	try{
		//财务-借款流程
		if (js_isBill == "1" && window._FnaSubmitRequestJsBorrowFlag) {
			var returnval = doSubmitFna4Mobile_Borrow();
			if(returnval == '1'){
				//flag = true;
			}else{
				flag = false;
				return false;
			}
		}
		//财务-还款流程
		if (js_isBill == "1" && window._FnaSubmitRequestJsRepayFlag) {
			var returnval = doSubmitFna4Mobile_Repay();
			if(returnval == '1'){
				//flag = true;
			}else{
				flag = false;
				return false;
			}
		}
	}catch(ex){}
	if(flag){
		try{
	       $("input[type='hidden'][id^='fieldsql']").remove();
		}catch(e){}
	}
	return flag;
}

//“退回”按钮专用回调方法
function closeRejectDialog(flagSubmit) {
	$.close("selectionWindow");
	
	//如果是点击确定才作转发操作，如果是 清除 或 取消 操作，则不作任何处理。
	if(flagSubmit){
		var flag = true;
		//确认已选择退回节点
		if (getIsselectrejectnode() == 1) {
			if(flag) {
				var rejectNodeIdObj = document.getElementById("rejectToNodeid");
				if(rejectNodeIdObj != null){
					var rejectNodeIdVal = rejectNodeIdObj.value;
					flag = (rejectNodeIdVal != "");
					if(!flag){
						$.alert(""+SystemEnv.getHtmlNoteName(4639),promptWrod);
					}
				} else {
					flag = false;
				}
			}
		}
		
		//确认是否退回
		if (isNeedAffirmance()) {
			if(flag) {
				flag = confirm(""+SystemEnv.getHtmlNoteName(4640));
			}
		}
		
		if(flag){
			setPageAllButtonDisabled();
			var $btnRejectObj = jQuery("#doreject");
			$btnRejectObj.attr("loadding", 1);
			$btnRejectObj.html(""+SystemEnv.getHtmlNoteName(4641));
			
			$('#src').val("reject");
			$('#workflowfrm').submit();
		}
	}
}

//“转发”按钮专用回调方法
function closeForwardDialog(flagSubmit) {
	$.close("selectionWindow");
    if($('#forwardresourceids')&&($('#forwardresourceids').val()!=null&&$('#forwardresourceids').val()!="")){
		  $(".signforwardimg").html("<span class=\"haschosespan\" onclick=\"doforward();\">已选("+$('#forwardresourceids').val().split(",").length+")</span>");
	}else{
          $(".signforwardimg").html("<span class=\"haschosespan\" onclick=\"doforward();\">已选(0)</span>");
	}
	if(flagSubmit){
		 doforwardShowSign();
         dosigncontent();
	}
    
	//如果是点击确定才作转发操作，如果是 清除 或 取消 操作，则不作任何处理。
	/*if(flagSubmit){
		var flag = true;
		if($('#forwardresourceids')&&($('#forwardresourceids').val()==null||$('#forwardresourceids').val()=="")){
			$.alert('请选择转发接收人！',promptWrod);
			flag = false;
		}
		if (isNeedAffirmance()) {
			if(flag) {
				flag = confirm(""+SystemEnv.getHtmlNoteName(4067));
			}
		}
	
		if(flag){
			setPageAllButtonDisabled();
			var $btnForwardObj = jQuery("#doforward");
			$btnForwardObj.attr("loadding", 1);
			$btnForwardObj.html("处理中...");
			$('#src').val("forward");
			$('#forwardflag').val("1");
			$('#workflowfrm').submit();
		}
	}*/
}


function doforwardhandler(){
       if($('#forwardresourceids')&&($('#forwardresourceids').val()==null||$('#forwardresourceids').val()=="")){
			 doforward();
			  $("#signbg").click();
		}else{
              if(docheckforward()){
                     var flag = true;
				     if (isNeedAffirmance()) {
						 flag = confirm(""+SystemEnv.getHtmlNoteName(4067));
		              }
					 if(flag){
						   $(".listbtnhandler").removeAttr("onclick");
						   setPageAllButtonDisabled();
					       var $btnForwardObj = jQuery("#doforward");
						   $btnForwardObj.attr("loadding", 1);
						   $btnForwardObj.html("处理中...");
                           $('#src').val("forward");
						   $('#forwardflag').val("1");
						   $('#workflowfrm').submit();
						   return true;
					 }
				 }
	    }
}

function closeForwardDialog2(flagSubmit) {
	$.close("selectionWindow");

	//如果是点击确定才作转发操作，如果是 清除 或 取消 操作，则不作任何处理。
	if(flagSubmit){
		var flag = true;
		if($('#forwardresourceids2')&&($('#forwardresourceids2').val()==null||$('#forwardresourceids2').val()=="")){
			$.alert('请选择意见征询接收人！',promptWrod);
			flag = false;
		}
		if (isNeedAffirmance()) {
			if(flag) {
				flag = confirm(""+SystemEnv.getHtmlNoteName(4068));
			}
		}
	
		if(flag){
			setPageAllButtonDisabled();
			var $btnForwardObj = jQuery("#doforward2");
			$btnForwardObj.attr("loadding", 1);
			$btnForwardObj.html("处理中...");
			$btnForwardObj.addClass("signbutcur");
			$('#src').val("forward");
			$('#forwardflag').val("2");
			$('#workflowfrm').submit();
		}
	}
}

function closeForwardDialog3(flagSubmit) {
	$.close("selectionWindow");

	//如果是点击确定才作转发操作，如果是 清除 或 取消 操作，则不作任何处理。
	if(flagSubmit){
		var flag = true;
		if($('#forwardresourceids3')&&($('#forwardresourceids3').val()==null||$('#forwardresourceids3').val()=="")){
			$.alert('请选择转办接收人！',promptWrod);
			flag = false;
		}
		if (isNeedAffirmance()) {
			if(flag) {
				flag = confirm(""+SystemEnv.getHtmlNoteName(4069));
			}
		}
	
		if(flag){
			setPageAllButtonDisabled();
			var $btnForwardObj = jQuery("#doforward3");
			$btnForwardObj.attr("loadding", 1);
			$btnForwardObj.html("处理中...");
			$btnForwardObj.addClass("signbutcur");
			$('#src').val("forward");
			$('#forwardflag').val("3");
			$('#workflowfrm').submit();
		}
	}
}

//将表情屏蔽掉
function utf16toEntities(str) { 
    var patt=/[\ud800-\udbff][\udc00-\udfff]/g; // 检测utf16字符正则 
    str = str.replace(patt, function(char){ 
    var H, L, code; 
    if (char.length===2) {
	H = char.charCodeAt(0); // 取出高位
	L = char.charCodeAt(1); // 取出低位
	code = (H - 0xD800) * 0x400 + 0x10000 + L - 0xDC00; // 转换算法 
	return "&#" + code + ";";
    } else { 
	return char; 
    } 
    }); 
   return str; 
}

//检查签字意见必填时候，是否已经填写。
function remarksignCheck(src) {
	var flag = true;
	if(isMustInputRemark(src)
	    && $('#userSignRemark')
        && ($('#userSignRemark').val()==null || $('#userSignRemark').val()==""||$('#userSignRemark').val().trim()=="")){
        
		//电子签章
		var $elecSignObj = jQuery("#markId");
		//检查手写签批 和 语音附件
		var handWrittenObj = jQuery("#fieldHandWritten");
		var speechAppendObj = jQuery("#fieldSpeechAppend");
		var flagHandWritten = (handWrittenObj.size() == 0 || handWrittenObj.val() == "");
		var flagSpeechAppend = (speechAppendObj.size() == 0 || speechAppendObj.val() == "");
		
		if($elecSignObj.val() == "" && flagHandWritten && flagSpeechAppend){
			if (isnewVersion) {
				alertMsg = "emobile:Message:请填写签字意见！:" + promptWrod;
			}else{
				$.alert('请填写签字意见！', promptWrod);
			}
			
			flag = false;
		}
	}
    if( $('#userSignRemark')
        && ($('#userSignRemark').val()!=null || $('#userSignRemark').val()!="")){
         $('#userSignRemark').val(utf16toEntities($('#userSignRemark').val()));
	}
	
	
	if (!flag) {
		try {
			inputRemarksign();
		} catch (e) {}
	}
	
	return flag;
}

/**
 * 获取url参数
 */
function getUrlParamByLastLogId(lastLogId) {

	if (lastLogId == null || lastLogId == undefined) {
		lastLogId = 0;
	}
	var pagesize = 5;
	//var workflowid = $("input[name='workflowid']").val();
	//var requestid = $("input[name='requestid']").val();
	var workflowsignid = lastLogId;//$("input[name='workflowsignid']").val();
	
    var tempfromRequestid = 0;
    try{
        tempfromRequestid = js_fromRequestid;
    }catch(e){
    }
    if(tempfromRequestid == undefined || tempfromRequestid == null || tempfromRequestid == 0){
        tempfromRequestid = $("input[name='requestid']").val();
    }
	var paras = "userid=" + js_userid + "&module=" + js_module + "&scope=" + js_scope + "&fromRequestId=" + tempfromRequestid + "" + 
		"&pagesize=" + pagesize + 
		"&workflowId=" + js_workflowid + 
		"&requestId=" + js_requestid + 
		"&pageindex=" + workflowsignid + 
		"&tk" + new Date().getTime() + "=1";
		try{
            paras += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
		}catch(e){
		}
		return paras;
}

function getWfPicUrl() {
    //return "/mobile/plugin/1/chart.jsp?requestid=" + js_requestid +"&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&fromRequestid=" + js_fromRequestid + "&clientver=" + js_clientVer;
    var url = "/mobile/plugin/1/chart.jsp?requestid=" + js_requestid +"&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&fromRequestid=" + js_fromRequestid + "&clientver=" + js_clientVer;
    try{
        if(!client_jsp_canview){
            url+="&error=error"
        }
    }catch(e){}
    try{
        url += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
    }catch(e){
    }
    return url;
}
function getWfStatusUrl() {
	//return "/mobile/plugin/1/operationRecord.jsp?requestid=" + js_requestid +"&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&fromRequestid=" + js_fromRequestid + "&clientver=" + js_clientVer;
	var url = "/mobile/plugin/1/operationRecord.jsp?requestid=" + js_requestid +"&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&fromRequestid=" + js_fromRequestid + "&clientver=" + js_clientVer;
    try{
        if(!client_jsp_canview){
            url+="&error=error"
        }
    }catch(e){}
    try{
        url += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
    }catch(e){
    }
    return url;
}

function getWfStatusUrl4hv() {
	//return "/mobile/plugin/1/operationRecord.jsp?requestid=" + js_requestid +"&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&fromRequestid=" + js_fromRequestid + "&clientver=" + js_clientVer + "&newversion=1";
	var url = "/mobile/plugin/1/operationRecord.jsp?requestid=" + js_requestid +"&workflowid=" + js_workflowid + "&module=" + js_module + "&scope=" + js_scope + "&clienttype=" + js_clienttype + "&clientlevel=" + js_clientlevel + "&fromRequestid=" + js_fromRequestid + "&clientver=" + js_clientVer + "&newversion=1";
    try{
        if(!client_jsp_canview){
            url+="&error=error"
        }
    }catch(e){}
    try{
        url += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
    }catch(e){
    }
    return url;
}

function null2string(str) {
	if (str == null || str == undefined) {
		return "";
	}
	return str;
}

function img_resize(_this) {
	var innerWidth = window.innerWidth;
	var imgWidth = $(_this).width();
	if (imgWidth >= innerWidth) {
		$(_this).width("100%");
	}
}

//自定义浏览框带参数sql替换
function joinFieldParams(data){
    if(data.indexOf("joinFieldParams")!=-1){
	   try{
			 var params = "";
             var paramsArray = data.split("&");
			 for (var i=0; i<paramsArray.length; i++) {
				 var paramstr = paramsArray[i];
				 var paramkv = paramstr.split("=");
				 if (paramkv.length > 1) {
					  if("joinFieldParams" == paramkv[0]){
						   params = paramkv[1];
					  }
				 }
			 }
           if(params!=''){
           		var joinParamsVal ="";
			    if(params.indexOf("#")>=0){
					var paraSplits =   params.split("#");
					for(var i=0;i<paraSplits.length;i++){
						var paraVal = paraSplits[i];
						var fieldParams = paraVal.split("-")[1];
					    var origanParams = paraVal.split("-")[0];
						var fieldValue = "";
						if($("input[id='"+fieldParams+"']").val() == 'undefined'
						|| $("input[id='"+fieldParams+"']").val() == undefined){
							 fieldValue = document.getElementById(fieldParams).value;
						}else{
							 fieldValue = $("input[id='"+fieldParams+"']").val();
						}
						joinParamsVal +="$"+origanParams+"$-@"+fieldValue;
						if(i!=(paraSplits.length-1)){
							joinParamsVal += "~";
						}
					 }
				}else{
					  var fieldParams = params.split("-")[1];
					  var origanParams = params.split("-")[0];
					  var fieldValue = "";
						if($("input[id='"+fieldParams+"']").val() == 'undefined'
						|| $("input[id='"+fieldParams+"']").val() == undefined){
							 fieldValue = document.getElementById(fieldParams).value;
						}else{
							 fieldValue = $("input[id='"+fieldParams+"']").val();
						}
					  joinParamsVal ="$"+origanParams+"$-@"+fieldValue;
				}
				var oldStr = "joinFieldParams="+params;
				var newStr = "joinFieldParams="+encodeURIComponent(joinParamsVal);
				if(joinParamsVal != "")
					return data.replace(eval("/"+oldStr+"/g"),newStr);
				else
					return data;
		   }else{
			    return data;
		   }
		  }catch(e){return data;}
    }else{
	     return data;
	}
}

//字段显示属性联动
function changeshowattr(fieldid,fieldvalue,rownum,workflowid,nodeid){
	//len = document.elements.length;
	var strData = "workflowid="+workflowid+"&nodeid="+nodeid+"&fieldid="+fieldid+"&fieldvalue="+fieldvalue;
	jQuery.ajax({
		type: "post",
		cache: false,
		url: encodeURI("/mobile/plugin/1/WorkflowChangeShowAttrAjax.jsp?" + strData),
		data: "",
		dataType: "text",  
		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		complete: function(){
		},
		error:function (XMLHttpRequest, textStatus, errorThrown) {
		} , 
		success : function (returnvalues, textStatus) {
			if (returnvalues == undefined || returnvalues == null) {
				return;
			} else { 
			    if(window.console)console.log("fieldid = "+fieldid+" fieldvalue = "+fieldvalue+" returnvalues = "+returnvalues);
				if(returnvalues !=""){
					var tfieldid=fieldid.split("_");
					var isdetail=tfieldid[1];
					var fieldarray=returnvalues.split("&");
					for(var n=0;n<fieldarray.length;n++){
						var fieldattrs=fieldarray[n].split("$");
						var fieldids=fieldattrs[0];
						var fieldattr=fieldattrs[1];
						var fieldidarray=fieldids.split(",");
						//表单设计器模板主表支持联动隐藏功能（4隐藏内容、5隐藏行）
	                    if(rownum<0 && jQuery("input#edesign_layout").length>0){
	                    	viewattrOperator.linkageControlHide(fieldids, fieldattr, true);
	                    	if(fieldattr==4 || fieldattr==5)
	                    		fieldattr = -1;
	                    }
						var tempfieldid = "";
						if(fieldattr==2){ // 必填
							for(var j=0;j<fieldidarray.length;j++){
								var tfieldidarray=fieldidarray[j].split("_");
								if ( tfieldidarray[1] == '0' ) {
								    tempfieldid = tfieldidarray[0];
									if (!!($("#oldfieldview" + tempfieldid))) {
										var isedit = $("#oldfieldview" + tempfieldid).val();
										var targetobjval = $("#field" + tempfieldid).val();
										SetFieldReadOnly(tempfieldid,false,isedit,fieldattr,targetobjval);
										if (isedit > 1) {
											var mandObj = $("#field" + tempfieldid + "_ismandspan");
											mandObj.attr("class", "ismand");
											if (targetobjval == null || targetobjval == undefined || targetobjval == "") {
												mandObj.show();
											}
											$("#field" + tempfieldid + "_ismandfield").val("field" + tempfieldid);
										}
									}
								}else{//明细
								    tempfieldid = tfieldidarray[0]+"_"+rownum ;
								    if (!!($("#oldfieldview" + tempfieldid))) {
                                        var isedit = $("#oldfieldview" + tempfieldid).val();
                                        var targetobjval = $("#field" + tempfieldid).val();
                                        SetDetailFieldReadOnly(tempfieldid,false,isedit,fieldattr,targetobjval);
                                    }
								}
							}
						}else if(fieldattr==1){ // 编辑
							for(var j=0;j<fieldidarray.length;j++){
								var tfieldidarray=fieldidarray[j].split("_");
								
                                    tempfieldid = tfieldidarray[0];
                                
								if ( tfieldidarray[1] == '0') {
									if (!!($("#oldfieldview" + tempfieldid))) {
										var isedit = $("#oldfieldview" + tempfieldid).val();
										SetFieldReadOnly(tempfieldid,false,isedit,fieldattr);
										if (isedit > 1) {
											var mandObj = $("#field" +tempfieldid + "_ismandspan");
											mandObj.attr("class", "");
											mandObj.hide();
											$("#field" + tempfieldid + "_ismandfield").val("");
										}
									}
								}else{
								    tempfieldid = tfieldidarray[0]+"_"+rownum ;
                                    if (!!($("#oldfieldview" + tempfieldid))) {
                                        var isedit = $("#oldfieldview" + tempfieldid).val();
                                        var targetobjval = $("#field" + tempfieldid).val();
                                        SetDetailFieldReadOnly(tempfieldid,false,isedit,fieldattr,targetobjval);
                                    }
								}
							}
						} else if (fieldattr == -1){ //没有设置联动，恢复原值和恢复原显示属性
							for(var j=0;j<fieldidarray.length;j++){
								var tfieldidarray=fieldidarray[j].split("_");
								if ( tfieldidarray[1] == '0') {
								    var tempfieldid = "";
	                                tempfieldid = tfieldidarray[0];
	                                
									if (!!($("#oldfieldview" + tempfieldid))) {
										var isedit = $("#oldfieldview" + tempfieldid).val();
										var targetobjval = $("#field" + tempfieldid).val();
										SetFieldReadOnly(tempfieldid,false,isedit,fieldattr,targetobjval);
										if (isedit == 3){
											var mandObj = $("#field" + tempfieldid + "_ismandspan");
											mandObj.attr("class", "ismand");
											if (targetobjval == null || targetobjval == undefined || targetobjval == "") {
												mandObj.show();
											}
											$("#field" + tempfieldid + "_ismandfield").val("field" + tempfieldid);
										}
										if (isedit == 2){
											var mandObj = $("#field" + tempfieldid + "_ismandspan");
											mandObj.attr("class", "");
											mandObj.hide();
											$("#field" + tempfieldid + "_ismandfield").val("");
										}
									}
								}else{
								    tempfieldid = tfieldidarray[0]+"_"+rownum ;
								    if (!!($("#oldfieldview" + tempfieldid))) {
                                        var isedit = $("#oldfieldview" + tempfieldid).val();
                                        var targetobjval = $("#field" + tempfieldid).val();
                                        SetDetailFieldReadOnly(tempfieldid,false,isedit,fieldattr,targetobjval);
                                    }
								}
							}
						} else if (fieldattr == 3){//只读操作
						      for(var j=0;j<fieldidarray.length;j++){
                                var tfieldidarray=fieldidarray[j].split("_");
                                var isedit = $("#oldfieldview" + tempfieldid).val();
                                var targetobjval = $("#field" + tempfieldid).val();
                                if ( tfieldidarray[1] == '0') {
                                    tempfieldid = tfieldidarray[0];
                                    if(!!($("#oldfieldview" + tempfieldid))) {                                       
                                        SetFieldReadOnly(tempfieldid,true,isedit,fieldattr);
                                    }
                                }else{
                                    tempfieldid = tfieldidarray[0]+"_"+rownum ;
                                    if(!!($("#oldfieldview" + tempfieldid))) {
                                        var isedit = $("#oldfieldview" + tempfieldid).val();    
                                        SetDetailFieldReadOnly(tempfieldid,true,isedit,fieldattr,targetobjval);
                                    
                                    }
                                }
                            }
						}
					}
				}
			}
			try {
		        clearInterval(ckInterval);
		    } catch (e){}
		    setInterval("setRedflag()",1000);
		} 
	});
}

/**
* 设置字段只读
* isedit = 3 必填  2 编辑 1 只读
* fieldattr -1 默认 1 编辑 2必填 3 只读
*/
function SetFieldReadOnly(fieldid,flag,isedit,fieldattr,targetobjval){
    //if(window.console)console.log("SetFieldReadOnly fieldid = "+fieldid+" flag = "+flag);
    if(isedit==null||isedit==undefined) isedit = 0;
    if(flag||flag=='true'){//只读
        if(jQuery("#field"+fieldid).length>0){
        
            var obj = jQuery("#field"+fieldid) ;
            obj.attr("vtype","3");
            var parentobj = jQuery("#field"+fieldid+"_tdwrap") ;
            parentobj = parentobj.children("div");
            if(jQuery("#field"+fieldid+"_tdwrap_div").length>0){
                parentobj = jQuery("#field"+fieldid+"_tdwrap_div") ;
            }
            showtext(parentobj,fieldid,true);
            parentobj.hide();
            jQuery("#readonlytext_field"+fieldid+"").show();
            
            var spanobj = jQuery("#field"+fieldid+"_ismandspan");
            spanobj.removeClass("ismand");
            spanobj.hide();
            
            $("#field" + fieldid + "_ismandfield").val("");
        }
    }else{//编辑和必填
        if(jQuery("#field"+fieldid).length>0){
            var obj = jQuery("#field"+fieldid) ;
            obj.attr("vtype",fieldattr);
            var parentobj = jQuery("#field"+fieldid+"_tdwrap") ;
            parentobj = parentobj.children("div");
            parentobj.show();
            showtext(parentobj,fieldid,false);
            if(fieldattr==2){
	            
	               var mandObj = $("#field" + fieldid + "_ismandspan");
	               if (targetobjval == null || targetobjval == undefined || targetobjval == "") {
	                   mandObj.attr("class", "ismand");
	                   mandObj.show();
	               }
	                $("#field" + fieldid + "_ismandfield").val("field" + fieldid);
	            
            }else{
                if (isedit > 2) {
                   var mandObj = $("#field" + fieldid + "_ismandspan");
                   if (targetobjval == null || targetobjval == undefined || targetobjval == "") {
                       mandObj.attr("class", "ismand");
                       mandObj.show();
                   }
                    $("#field" + fieldid + "_ismandfield").val("field" + fieldid);
                }
                var spanobj = jQuery("#field"+fieldid+"_ismandspan");
	            spanobj.removeClass("ismand");
	            spanobj.hide();
	            
	            $("#field" + fieldid + "_ismandfield").val("");
            }
        }
    }
}
/*主表和明细表解析方式不一样，该方法只处理明细表，凸  detailValueTD*/
function SetDetailFieldReadOnly(fieldid,flag,isedit,fieldattr,targetobjval){
    if(isedit==null||isedit==undefined) isedit = 0;
     targetobjval = jQuery.trim(targetobjval); 
    if(flag||flag=='true'){//只读 
            var obj = jQuery("#field"+fieldid+"_d");
        
            obj.attr("vtype","3");
            var parentobj = jQuery("#field"+fieldid+"_tdwrap") ;
            parentobj.attr("__click",parentobj.attr("onclick"));
            parentobj.removeAttr("onclick");
            //隐藏td里面的内容

            showdttext(parentobj,fieldid,true);
            var crobj = parentobj.children();
            crobj.hide();
            jQuery("#readonlytext_field"+fieldid).show();
            
            var mandObj = $("#field" + fieldid + "_ismandspan");
            var mandObj1 = jQuery("#field" + fieldid + "_d_ismandspan");
            mandObj.removeClass("ismand");
            mandObj.hide();
            mandObj1.hide();
            $("#field" + fieldid + "_ismandfield").val("");
        
    }else{//编辑和必填
            var obj = jQuery("#field"+fieldid+"_d");
            obj.attr("vtype",fieldattr);
            var parentobj =  jQuery("#field"+fieldid+"_tdwrap") ;
            parentobj.attr("onclick",parentobj.attr("__click"));
            parentobj.removeAttr("__click");
            //显示td里面的内容
            showdttext(parentobj,fieldid,false);
            var crobj = parentobj.children();
            crobj.show();
            if(jQuery("#cntfield"+fieldid).length>0){
                targetobjval = jQuery.trim(jQuery("#field"+fieldid + "_span").html());
                jQuery("#field"+fieldid+"_tdwrap").attr("vtype",fieldattr);
            }
            if (fieldattr == 2) {
	                var mandObj = $("#field" + fieldid + "_ismandspan");
	                mandObj.addClass("ismand");
	                var mandObj1 = jQuery("#field" + fieldid + "_d_ismandspan");
	                if (targetobjval == null || targetobjval == undefined || targetobjval == "") {
	                    mandObj1.css("color","red").css("font-size","16pt").css("float","right").css("line-height","25px");//.css("margin-top","-10px");    
	                    mandObj1.show();
	                }else{
	                    mandObj1.hide();
	                }
	                mandObj.hide();
	                $("#field" + fieldid + "_ismandfield").val("field" + fieldid);
            }else if(fieldattr == 1){
                    var mandObj = $("#field" + fieldid + "_ismandspan");
                    var mandObj1 = jQuery("#field" + fieldid + "_d_ismandspan");
                    mandObj.removeClass("ismand");
                    mandObj.hide();
                    mandObj1.hide();
                    $("#field" + fieldid + "_ismandfield").val("");
               
            }else if(fieldattr == -1){
                if(isedit >2 ){ 
                    var mandObj = $("#field" + fieldid + "_ismandspan");
                    mandObj.addClass("ismand");
                    var mandObj1 = jQuery("#field" + fieldid + "_d_ismandspan");
                    if (targetobjval == null || targetobjval == undefined || targetobjval == "") {
                        mandObj1.css("color","red").css("font-size","16pt").css("float","right").css("line-height","25px");//.css("margin-top","-10px");    
                        mandObj1.show();
                    }else{
                        mandObj1.hide();
                    }
                    mandObj.hide();
                    $("#field" + fieldid + "_ismandfield").val("field" + fieldid);
                }else{
                    var mandObj = $("#field" + fieldid + "_ismandspan");
                    var mandObj1 = jQuery("#field" + fieldid + "_d_ismandspan");
                    mandObj.removeClass("ismand");
                    mandObj.hide();
                    mandObj1.hide();
                    $("#field" + fieldid + "_ismandfield").val("");
                }
        }  
    }
}

/*td里面的对象 进行遍历*/
function showtext(obj,fieldid,flag){

    var tempid = "readonlytext_field"+fieldid+"";
    var prestr = "<span id='"+tempid+"' style='line-height:30px!important;'>" ;
    var endstr = "</span>";
    var showobj = jQuery("#"+tempid); 
    jQuery("#"+tempid).html("");
    jQuery("#"+tempid).remove();

    if(showobj.length == 0){
        showobj = jQuery(prestr+endstr);
    }
    var afterstr = "";
    try{        
	    if(flag){
	       //if(window.console) console.log("fieldid ="+fieldid+"  "+$("#cntfield"+fieldid).length);
	       if($("#cntfield"+fieldid).length==0){
			    var tagName = $("#field"+fieldid).get(0).nodeName ;
			    //if(window.console) console.log("tagName = "+tagName);
			    if(tagName == 'SELECT'){//下拉框取选中的text
			        afterstr = obj.find("option:selected").text();
		            obj.after(showobj.html(afterstr));
			    }else if(tagName == 'TEXTAREA'){
				    var name= $("#field"+fieldid).attr("name");
			        if(name!=undefined){
			            if(isShowEditor()){
			               K.sync("#"+name);
			            }   
			        }
			        afterstr = $("#field"+fieldid).val();
			        obj.after(showobj.html(afterstr));
			    }else if(tagName == 'INPUT'){
			       var inputtype = $("#field"+fieldid).attr("type"); 
			       if(window.console) console.log("tagName = "+tagName+"   inputtype = "+inputtype);
			       if(inputtype == 'checkbox'){
			           $("#field"+fieldid).attr("readOnly","true");
			       }else if(inputtype == 'text'){
			           afterstr = $("#field"+fieldid).val();
			           if($("#field_lable"+fieldid).length>0){
			               afterstr = $("#field_label"+fieldid).val()+"";    
			               afterstr += "("+$("#field_chinglish"+fieldid).val()+")";
			           }
			           obj.after(showobj.html(afterstr));
			       }else if(inputtype == "hidden"){
			           if($("#field"+fieldid).attr("fieldtype")=='browse'){
			               //浏览按钮
			               afterstr = $("#field"+fieldid+"_span").html();
			               obj.after(showobj.html(afterstr));
			           }
			       }
			    }
		    }else{
		         afterstr = $("#field"+fieldid+"_span").text();
		         //if(window.console) console.log("afterstr = "+afterstr);
                 obj.before(showobj.html(afterstr.replace(/<img.*>.*<\/img>/ig,"").replace(/<img.*\/>/ig, "")));
		    }
	    }else{
	       try{
		        jQuery("#"+tempid).html("");
		        jQuery("#"+tempid).hide();
	        }catch(e){}
	        jQuery("#"+tempid).remove();
	        removeElement(tempid);
	    }
    }catch(e){
        if(window.console) console.log("--->"+e.message);
    }
}

/*td里面的对象 进行遍历*/
function showdttext(obj,fieldid,flag){

    var tempid = "readonlytext_field"+fieldid+"";
    var prestr = "<span id='"+tempid+"' style='line-height:30px!important;'>" ;
    var endstr = "</span>";
    var showobj = jQuery("#"+tempid); 
    jQuery("#"+tempid).remove();
    
    if(showobj.length == 0){
        showobj = jQuery(prestr+endstr);
    }
    var afterstr = "";
    try{        
        if(flag){
            //if(window.console) console.log("fieldid = "+fieldid+" cnt length "+$("#cntfield"+fieldid).length);
            if($("#cntfield"+fieldid).length==0){
	            var tagName = $("#field"+fieldid).get(0).nodeName ;
	            
	            if(tagName == 'SELECT'){//下拉框取选中的text
	                afterstr = obj.find("option:selected").text();
	                obj.append(showobj.html(afterstr));
	            }else if(tagName == 'TEXTAREA'){
	                var name= $("#field"+fieldid).attr("name");
	                if(name!=undefined){
	                    if(isShowEditor()){
	                       K.sync("#"+name);
	                    }   
	                }
	                afterstr = $("#field"+fieldid).val();
	                obj.append(showobj.html(afterstr));
	            }else if(tagName == 'INPUT'){
	               var inputtype = $("#field"+fieldid).attr("type"); 
	
	               if(inputtype == 'checkbox'){
	                   $("#field"+fieldid).attr("readOnly","true");
	               }else if(inputtype == 'text'){
	                   afterstr = $("#field"+fieldid).val();
	                   if($("#field_lable"+fieldid+"_d").length>0){
	                       afterstr = $("#field_label"+fieldid+"_d").val()+"";
	                       if(afterstr!=''){    
	                            afterstr += "("+$("#field_chinglish"+fieldid+"_d").val()+")";
	                       }
	                   }
	                   obj.append(showobj.html(afterstr));
	               }else if(inputtype == "hidden"){
	                   if($("#field"+fieldid).attr("fieldtype")=='browse'){
	                       //浏览按钮
	                       afterstr = $("#field"+fieldid+"_span_d").html();
	                       if(afterstr.indexOf("field"+fieldid+"_d_ismandspan")!=-1){
	                           afterstr = "";
	                       }
	                       if(window.console) console.log("afterstr = "+afterstr);
	                       obj.append(showobj.html(afterstr));
	                   }
	                   //field_chinglish71896_0_d
	                   if($("#field_lable"+fieldid+"_d").length>0&&$("#field"+fieldid+"_d").attr("datetype")=='float'){
		                       //afterstr = $("#field_chinglish"+fieldid).html();
		                       if($("#field_chinglish"+fieldid+"_d").val()!=''){
			                       afterstr = ""+$("#field_chinglish"+fieldid+"_d").val()+"("+$("#field_lable"+fieldid+"_d").val()+")";
			                       obj.append(showobj.html(afterstr));
		                       }
	                   }
	               }
	            }
            }else{
                //附件上传
                afterstr = $("#field"+fieldid+"_span_d").text();
                obj.append(showobj.html(afterstr.replace(/<img.*>.*<\/img>/ig,"").replace(/<img.*\/>/ig, "").replace("!", "")));
            }

        }else{
           try{
                jQuery("#"+tempid).html("");
                jQuery("#"+tempid).hide();
            }catch(e){}
            jQuery("#"+tempid).remove();
            removeElement(tempid);
            
        }
    }catch(e){
        if(window.console) console.log("--->"+e.message);
    }
}

function changeToThousandsVal(_sourcevalue){
	var sourcevalue = _sourcevalue.toString();
	if(null != sourcevalue && 0 != sourcevalue){
	     if(sourcevalue.indexOf(".")<0)
	        re = /(\d{1,3})(?=(\d{3})+($))/g;
	     else
	        re = /(\d{1,3})(?=(\d{3})+(\.))/g;
		return sourcevalue.replace(re,"$1,");
	}else{
		return sourcevalue;
	}
}

function changeTo1000(svalue){
	var rvalue = "";
	var re;
	if(svalue.indexOf(".")<0){
        re = /(\d{1,3})(?=(\d{3})+($))/g;
    }else{
        re = /(\d{1,3})(?=(\d{3})+(\.))/g;
	}
    rvalue = svalue.replace(re,"$1,");
	return rvalue;
}

//下拉框主字段
function changeChildField(obj, fieldid, childfieldid){
	 var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill="+js_isBill+"&selectedfieldid=0&uploadType=0&isdetail=0&ismobile=1&selectvalue="+obj.value;
     document.getElementById("selectChange").src = "/mobile/plugin/1/SelectChange.jsp?"+paraStr;
}

//下拉框明细字段
function changeChildFieldDetail(obj, fieldid, childfieldid, rownum){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill="+js_isBill+"&selectvalue="+obj.value+"&isdetail=1&ismobile=1&rowindex="+rownum;
    document.getElementById("selectChangeDetail").src = "/mobile/plugin/1/SelectChange.jsp?"+paraStr;
}


//选择框初始值
function doInitChildSelect(fieldid,childfieldid,isdetail,groupid,rownum,finalvalue){

	try{
		var paraStr="";
		var childVal = "";
		if(isdetail == 'true'){
			 if(document.getElementById("field"+childfieldid+"_"+rownum)){
				  childVal =jQuery("#field"+childfieldid+"_"+rownum).val();
			 }
		}else{
			if(document.getElementById("field"+childfieldid)){
				childVal =jQuery("#field"+childfieldid).val();
			}
		}
	   if(isdetail=='true'){
            paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill="+js_isBill+"&selectedfieldid=0&uploadType=0&isdetail=1&ismobile=1&selectvalue="+finalvalue+"&childvalue="+childVal+"&rowindex="+rownum;
		}else{
			paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill="+js_isBill+"&selectedfieldid=0&uploadType=0&isdetail=0&ismobile=1&childvalue="+childVal+"&selectvalue="+finalvalue;
		}
		var frm = document.createElement("iframe");
		if(isdetail=='true'){
			frm.id = "iframe_"+childfieldid+"_"+fieldid+"_"+groupid+""+rownum;
		}else{
			frm.id = "iframe_"+childfieldid+"_"+fieldid+"_00";
		}
		frm.style.display = "none";
		document.body.appendChild(frm);
		if(isdetail=='true'){
			document.getElementById("iframe_"+childfieldid+"_"+fieldid+"_"+groupid+""+rownum).src= "/mobile/plugin/1/SelectChange.jsp?"+paraStr;
		}else{
			document.getElementById("iframe_"+childfieldid+"_"+fieldid+"_00").src="/mobile/plugin/1/SelectChange.jsp?"+paraStr;
		}
	}catch(e){}
}
/**
 * 删除元素
 * @param _element
 */
function removeElement(_element){
    try{
        var _parentElement = _element.parentNode;
        if(_parentElement){
            _parentElement.removeChild(_element);
        }
    }catch(e){
        
    }
}
/**
 * 打开url浏览框卡片，阻止事件冒泡
 * @param url
 */
function openbrowserurl(url){
	location.href=url;   
	var e=event || window.event;
    if (e && e.stopPropagation){
        e.stopPropagation();    
    }
    else{
        e.cancelBubble=true;
    }
}

function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);
    //QC79136 中修改
	var returnVal = isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1;
	try{
		if(String(returnVal).indexOf("e")>=0)return returnVal;
	}catch(e){}
	var valInt = (returnVal.toString().split(".")[1]+"").length;
	if(aNumber == null){
		return  "";
	}
	if(valInt != precision){
	    var lengInt = precision-valInt;
		//判断添加小数位0的个数
		if(lengInt == 1){
			returnVal += "0";
		}else if(lengInt == 2){
			returnVal += "00";
		}else if(lengInt == 3){
			returnVal += "000";
		}else if(lengInt < 0){
			if(precision == 1){
				returnVal += ".0";
			}else if(precision == 2){
				returnVal += ".00";
			}else if(precision == 3){
				returnVal += ".000";
			}else if(precision == 4){
				returnVal += ".0000";
			}		
		}		
	}
	return  returnVal;		
}
//用于安卓手机字段出现签字意见框时候表单元素焦点失去
//如果安卓数字输入1元提交后保存问题
function showPoPRemarkWindow(){
   	try{
		if($(':focus').length>0&&js_clienttype=='android') {
			$("#"+$(':focus').attr("id")).blur();
		}
	}catch(e){}
}

function initFlashVideo(){

}


//明细表字段属性功能
function detailattrshow(trrowindex){
     for(var key in detailfieldattr){
		      try{
					    if($("#field"+key+"_"+trrowindex).length>0){
							  var detailfieldattrobj=detailfieldattr[key];
                              if(detailfieldattrobj.indexOf("@")!=-1){
								    var fieldattrtype=detailfieldattrobj.split("@")[1];
									var fieldattrexp = detailfieldattrobj.split("@")[0];
									if(fieldattrtype=='getFieldDate'){
										eval("doFieldDate"+key+"("+trrowindex+");");
										var fieldattrexpobj=fieldattrexp.split("$");
										for(var fi=0;fi<fieldattrexpobj.length;fi++){
										    if(fieldattrexpobj[fi]!='datetime'&&fieldattrexpobj[fi].trim()!=''&&fieldattrexpobj[fi]!='-'){
												   var fieldattrchange=$("#field"+fieldattrexpobj[fi]+"_"+trrowindex).attr("onchange");
												   if(fieldattrchange!=null && fieldattrchange != undefined && fieldattrchange.indexOf("doFieldDate")==-1){
													    $("#field"+fieldattrexpobj[fi]+"_"+trrowindex).attr("onchange","doFieldDate"+key+"("+trrowindex+");"+fieldattrchange);
												   }
											}
										}

									}
									if(fieldattrtype=='doSqlField'){
                                        fieldAttrOperate.pageLoadInitValue(""+key+"", ""+trrowindex+"");
										if(fieldattrexp.indexOf("$")!=-1){
											     var fieldattrexpobj=fieldattrexp.split("$");
										         for(var fi=0;fi<fieldattrexpobj.length;fi++){
													    var reg = new RegExp("^[0-9]*$");
													   if(reg.test(fieldattrexpobj[fi])){
														   var fieldattrchange=$("#field"+fieldattrexpobj[fi]+"_"+trrowindex).attr("onchange");
															if(fieldattrchange!=null && fieldattrchange != undefined && fieldattrchange.indexOf("fieldAttrOperate.doSqlFieldAjax(this,'"+key+"',")==-1){
																 $("#field"+fieldattrexpobj[fi]+"_"+trrowindex).attr("onchange","fieldAttrOperate.doSqlFieldAjax(this,'"+key+"','"+trrowindex+"');"+fieldattrchange);
															}
													  }
										         }
										}
                                         
									}
							  }
						}
			   }catch(e){}
        }
	
}


