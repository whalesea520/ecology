function compdate(a, b) {
    var arr = a.split("-");
    var starttime = new Date(arr[0], arr[1], arr[2]);
    var starttimes = starttime.getTime();

    var arrs = b.split("-");
    var lktime = new Date(arrs[0], arrs[1], arrs[2]);
    var lktimes = lktime.getTime();

    if (starttimes > lktimes) {
        return false;
    }
    else
        return true;
}
function comptime(beginTime,endTime) {
    var beginTimes = beginTime.substring(0, 10).split('-');
    var endTimes = endTime.substring(0, 10).split('-');

    beginTime = beginTimes[1] + '-' + beginTimes[2] + '-' + beginTimes[0] + ' ' + beginTime.substring(10, 19);
    endTime = endTimes[1] + '-' + endTimes[2] + '-' + endTimes[0] + ' ' + endTime.substring(10, 19);

    alert(beginTime + "aaa" + endTime);
    alert(Date.parse(endTime));
    alert(Date.parse(beginTime));
    var a = (Date.parse(endTime) - Date.parse(beginTime)) / 3600 / 1000;
    if (a < 0) {
        alert("endTime小!");
    } else if (a > 0) {
        alert("endTime大!");
    } else if (a == 0) {
        alert("时间相等!");
    } else {
        return 'exception'
    }
}
function startWith(str,dim){     
	var reg=new RegExp("^"+dim);     
	return reg.test(str);        
}  
function openFullWindowHaveBar(url){
	  var redirectUrl = url ;
	  var width = screen.availWidth-10 ;
	  var height = screen.availHeight-50 ;
	  //if (height == 768 ) height -= 75 ;
	  //if (height == 600 ) height -= 60 ;
	   var szFeatures = "top=0," ;
	  szFeatures +="left=0," ;
	  szFeatures +="width="+width+"," ;
	  szFeatures +="height="+height+"," ;
	  szFeatures +="directories=no," ;
	  szFeatures +="status=yes,toolbar=no,location=no," ;
	  szFeatures +="menubar=no," ;
	  szFeatures +="scrollbars=yes," ;
	  szFeatures +="resizable=yes" ; //channelmode
	  window.open(redirectUrl,"",szFeatures) ;
}
function openFullWindowForXtable(url){
	  var redirectUrl = url ;
	  var width = screen.width ;
	  var height = screen.height ;
	  //if (height == 768 ) height -= 75 ;
	  //if (height == 600 ) height -= 60 ;
	  var szFeatures = "top=100," ; 
	  szFeatures +="left=400," ;
	  szFeatures +="width="+width/2+"," ;
	  szFeatures +="height="+height/2+"," ; 
	  szFeatures +="directories=no," ;
	  szFeatures +="status=yes," ;
	  szFeatures +="menubar=no," ;
	  szFeatures +="scrollbars=yes," ;
	  szFeatures +="resizable=yes" ; //channelmode
	  window.open(redirectUrl,"",szFeatures) ;
}
//替换ajax传递特殊符号
function filter(str){
	str = str.replace(/\+/g,"%2B");
    str = str.replace(/\&/g,"%26");
	return str;	
}
function getVal(val){
	if(val==null || typeof(val)=="undefined"){
		return "";
	}else{
		return val;
	}
}
function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);

	return isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1 ;
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
function toInt(str , def) {
	if(isNaN(parseInt(str))) return def ;
	else return str ;
}
//判断input框中是否输入的是数字,包括小数点
function checknumber(objid)
{
	var valuechar = $("#"+objid).val().split("") ;
	var isnumber = false ;
	var hasdian = false;
	for(i=0 ; i<valuechar.length ; i++) { 
		charnumber = parseInt(valuechar[i]) ; 
		if( isNaN(charnumber)&& valuechar[i]!="." && valuechar[i]!="-"){
			isnumber = true ;
		}
		if((valuechar[i]=="."&&i==0&&hasdian==false)||(valuechar[i]=="-"&&i>0)){
			isnumber = true ;
		}
		if(valuechar[i]=="."){
			hasdian = true;
		}
		if (valuechar.length==1 && valuechar[i]=="-"){
		    isnumber = true ;
		}
	}
	if(isnumber){
		obj.value = "";
	}
}
//判断input框中是否输入的是数字,包括小数点
function ItemNum_KeyPress(elementname)
{
	var evt = getEvent();
	evt = jQuery.event.fix(evt);
	if(elementname==undefined){
		elementname = evt.target.name;
	}
	
	var keyCode = evt.which ? evt.which : evt.keyCode;
	 // 避免多次输入小数点
	 tmpvalue = $GetEle(elementname).value;
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
	 for(i = 0; i < len; i++){// 避免多次输入负号
	    if(tmpvalue.charAt(i) == "-"){
	    count2++;     
	    }
	 }
	 
	 if(!(((keyCode>=48) && (keyCode<=57)) || keyCode==46 || keyCode==45) || (keyCode==46 && count == 1) || (keyCode==45 && count2 == 1))
	  {  
	     //(e.which ? e.which : e.keyCode) = 0;
	     if (evt.keyCode) {
	     	evt.keyCode = 0;evt.returnValue=false;     
	     } else {
	     	evt.which = 0;evt.preventDefault();
	     }
	  }
}
//取消输入框后面跟随的红色惊叹号
function checkmyinput(elementname,spanid){
	var tmpvalue = $("#"+elementname).val();

	while(tmpvalue.indexOf(" ") >= 0){
		tmpvalue = tmpvalue.replace(" ", "");
	}
	if(tmpvalue != ""){
		while(tmpvalue.indexOf("\r\n") >= 0){
			tmpvalue = tmpvalue.replace("\r\n", "");
		}
		if(tmpvalue != ""){
			$("#"+spanid).html("");
		}else{
			$("#"+spanid).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			//$GetEle(elementname).value = "";
		}
	}else{
		$("#"+spanid).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		//$GetEle(elementname).value = "";
	}
}
Date.prototype.format = function(format)
{
    var o = {
    "M+" : this.getMonth()+1, //month
    "d+" : this.getDate(),    //day
    "h+" : this.getHours(),   //hour
    "m+" : this.getMinutes(), //minute
    "s+" : this.getSeconds(), //second
    "q+" : Math.floor((this.getMonth()+3)/3),  //quarter
    "S" : this.getMilliseconds() //millisecond
    }
    if(/(y+)/.test(format)) format=format.replace(RegExp.$1,
    (this.getFullYear()+"").substr(4 - RegExp.$1.length));
    for(var k in o)if(new RegExp("("+ k +")").test(format))
    format = format.replace(RegExp.$1,
    RegExp.$1.length==1 ? o[k] :
    ("00"+ o[k]).substr((""+ o[k]).length));
    return format;
}
function Map() {    
    var struct = function(key, value) {    
        this.key = key;    
        this.value = value;    
    }    
     
    var put = function(key, value){    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                this.arr[i].value = value;    
                return;    
            }    
        }    
        this.arr[this.arr.length] = new struct(key, value);    
    }    
         
    var get = function(key) {    
        for (var i = 0; i < this.arr.length; i++) {    
            if ( this.arr[i].key === key ) {    
                return this.arr[i].value;    
            }    
        }    
        return null;    
    }    
         
    var remove = function(key) {    
        var v;    
        for (var i = 0; i < this.arr.length; i++) {    
            v = this.arr.pop();    
            if ( v.key === key ) {    
                continue;    
            }    
            this.arr.unshift(v);    
        }    
    }    
         
    var size = function() {    
        return this.arr.length;    
    }    
         
    var isEmpty = function() {    
        return this.arr.length <= 0;    
    }    
       
    this.arr = new Array();    
    this.get = get;    
    this.put = put;    
    this.remove = remove;    
    this.size = size;    
    this.isEmpty = isEmpty;    
}
function onRefresh(){
	window.location.reload();
}
function addCookie(objName,objValue,objHours){//添加cookie
	var str = objName + "=" + escape(objValue);
	if(objHours > 0){//为0时不设定过期时间，浏览器关闭时cookie自动消失
		var date = new Date();
		var ms = 10*365*24*60*60*1000;
		date.setTime(date.getTime() + ms);
		str += "; expires=" + date.toGMTString();
	}
	document.cookie = str;
}
function getCookie(objName){//获取指定名称的cookie的值
	var arrStr = document.cookie.split("; ");
	for(var i = 0;i < arrStr.length;i ++){
		var temp = arrStr[i].split("=");
		
		if(temp[0] == objName) return unescape(temp[1]);
 	}
}
function checkmyemail(elementname,spanid){
	var emailStr = $("#"+elementname).val();
	emailStr = emailStr.replace(" ","");
	if (emailStr == "" || !checkEmail(emailStr)) {
		$("#"+spanid).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		$("#"+elementname).val("");
	} else {
		$("#"+spanid).html("");
	}
}
function getVal(val){
	if(val==null || typeof(val)=="undefined"){
		return "";
	}else{
		return val;
	}
}
/**
 * 数字格式转换成千分位
 *@param{Object}num
 */
function commafy(num){
	num = getVal(num);
	if($.trim(num+"")==""){
		return"";
	}
	if(isNaN(num)){
		return"";
	}
	num = num+"";
	if(/^.*\..*$/.test(num)){
		var pointIndex =num.lastIndexOf(".");
		var intPart = num.substring(0,pointIndex);
		var pointPart =num.substring(pointIndex+1,num.length);
		intPart = intPart +"";
		var re =/(-?\d+)(\d{3})/
		while(re.test(intPart)){
			intPart =intPart.replace(re,"$1,$2")
		}
		num = intPart+"."+pointPart;
	}else{
		num = num +"";
		var re =/(-?\d+)(\d{3})/
		while(re.test(num)){
			num =num.replace(re,"$1,$2")
		}
	}
	
	var start = num.indexOf(".");
	if(start<0){
		num += ".00";
	}else if(start==num.length-2){
		num += "0";
	}
	
	return num;
}

/**
 * 去除千分位
 *@param{Object}num
 */
function delcommafy(num){
	num = getVal(num);
	if($.trim(num+"")==""){
		return"";
	}
	num=num.replace(/,/gi,'');
	return num;
}
Number.prototype.toFixed=function(len)
{
	var tempNum = 0;
    var s,temp;
    var s1 = this + "";
    var start = s1.indexOf(".");
    
    //截取小数点后,0之后的数字，判断是否大于5，如果大于5这入为1

    if(s1.substr(start+len+1,1)>=5)
	   tempNum=1;

    //计算10的len次方,把原数字扩大它要保留的小数位数的倍数
    var temp = Math.pow(10,len);
    //求最接近this * temp的最小数字
    //floor() 方法执行的是向下取整计算，它返回的是小于或等于函数参数，并且与之最接近的整数
    s = Math.floor(this * temp) + tempNum;
    return s/temp;
}

function setOrder(type){
	var oldtype = jQuery("#ordertype").val();
	if(oldtype==type) return;
	jQuery("#ordertype").val(type);
	jQuery("a.orderbtn").removeClass("orderbtn_select");
	if(type==1){
		jQuery("a.orderbtn:first").addClass("orderbtn_select");
	}else{
		jQuery("a.orderbtn:last").addClass("orderbtn_select");
	}
	jQuery("#feedbacktable").find("tr").remove();
	jQuery("#listmore2").attr("_currentpage",0).trigger("click");
}