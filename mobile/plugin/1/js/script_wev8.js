/* Author: ZengDongPing*/
var config={
	clientServer:"http://mdev.e-cology.cn/client.do?",   /* Mobile Core服务器地址*/
	newListPageSize:0               /* 新闻列表页面每次加载条数 */
}


var util={
	 getData:function(para,passobj){
	    //if(para.loadingTarget!=null) jQuery(para.loadingTarget).showLoading();
		jQuery.ajax({
			type: "post",
			cache: false,
		    url: "/mobile/plugin/1/workflowSign.jsp?_" + new Date().getTime() + "=1&" + para.paras,
		    data:para.datas,
		    dataType: "json",  
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(){
				//if(para.loadingTarget!=null)  jQuery(para.loadingTarget).hideLoading();
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success:function (data, textStatus) {
		    	if (data == undefined || data == null) {
		    		alert("服务器运行出错!\n请联系系统管理员!");
		    		return;
		    	} else { 
		    		para.callback.call(this,data,passobj);
		    	}
		    } 
	    });
	},
	
	/*
	 * 当且仅当data为非空的字符串时返回false，其他情况返回true
	 * @param data： 目标字符串
	 * @return 当且仅当data为非空的字符串时返回false，其他情况返回true
	 * */
	isNullOrEmpty: function (data) {
		if (data == undefined || data == null || data == "") {
			return true;
		}
		return false;
	},
	
	/*
	 * 指定格式的当前日期字符串
	 * @param format 格式化字符串
	 * @return 指定格式的当前日期字符串
	 */
	getCurrentDate4Format : function (formatstring) {
		var testDate = new Date(); 
		var testStr = testDate.format(formatstring);
		return testStr;
	}
}

/**
 * 为日期增加格式化方法
 * @param format 格式化字符串
 * @return 指定格式的字符串
 */
Date.prototype.format = function(format){ 
	var o = { 
		"M+" : this.getMonth()+1, //month 
		"d+" : this.getDate(),    //day 
		"h+" : this.getHours(),   //hour 
		"m+" : this.getMinutes(), //minute 
		"s+" : this.getSeconds(), //second 
		"q+" : Math.floor((this.getMonth()+3)/3), //quarter 
		"S" : this.getMilliseconds() //millisecond 
	} 

	if(/(y+)/.test(format)) { 
		format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
	} 

	for(var k in o) { 
		if(new RegExp("("+ k +")").test(format)) { 
			format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length)); 
		} 
	} 
	return format; 
}

/**
 * 为String增加endWith与startWith方法
 */
String.prototype.endWith=function(s){
	if(s==null||s==""||this.length==0||s.length>this.length)
		return false;
	if(this.substring(this.length-s.length)==s)
		return true;
	else
		return false;
	return true;
}

String.prototype.startWith=function(s){
	if(s==null||s==""||this.length==0||s.length>this.length)
		return false;
	if(this.substr(0,s.length)==s)
		return true;
	else
		return false;
	return true;
}