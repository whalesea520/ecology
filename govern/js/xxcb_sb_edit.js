jQuery(document).ready( function(){ 

//获取当前时间
var myDate = getNowFormatDate();
//alert(myDate);
var myTime = getNowFormatTime();
//alert(myTime);
//jQuery("#field11098span").text(myDate);
//jQuery("#field11098").val(myDate);
//jQuery("#field11099span").text(myTime);
//jQuery("#field11099").val(myTime);
jQuery(jQuery("input[ecologyname='uf_xxcb_sbInfo.clsj']").prev()).text(myTime);
jQuery(jQuery("input[ecologyname='uf_xxcb_sbInfo.clrq']").prev()).text(myDate);

jQuery(jQuery("input[ecologyname='uf_xxcb_sbInfo.clsj']")).val(myTime);
jQuery(jQuery("input[ecologyname='uf_xxcb_sbInfo.clrq']")).val(myDate);

//获取当前日期，格式YYYY-MM-DD
    function getNowFormatDate() {
        var date = new Date();
        var seperator1 = "-";
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = year + seperator1 + month + seperator1 + strDate;
        return currentdate;
    }
//获取当前时间，格式HH:MM
    function getNowFormatTime() {
       var date = new Date();
    var seperator2 = ":";
    var hours= date.getHours();
    var minnutes = date.getMinutes();
    if (hours>= 1 && hours<= 9) {
        hours= "0" + hours;
    }
    if (minnutes >= 0 && minnutes <= 9) {
        minnutes = "0" + minnutes ;
    }
    var currenttime = hours + seperator2 + minnutes ;
    return currenttime ;
    }
	//获取刊型信息
	var url = "/govern/information/xxcb/getKanxingInfo.jsp?billid="+GetQueryString("billid");
	//alert(url);
	jQuery.ajax({
		type:'get',
		url:url,
		dataType : "json",
		async:false,
		success:function do4Success (obj){ 
			jQuery("#checkbox").html(obj.htmlStr);

		}, 
			error:function (){ 
			top.Dialog.alert("Error");
			} 
	});
	
	//插入已阅人员数据
	url = "/govern/information/xxcb/saveReaderInfo.jsp?billid="+GetQueryString("billid");
	//alert(url);
	jQuery.ajax({
		type:'get',
		url:url,
		dataType : "json",
		async:false,
		success:function do4Success (obj){ 
			

		}, 
			error:function (){ 
			top.Dialog.alert("Error");
			} 
	});
	
})



//报错选中的刊型
function saveKanxing(){
  var allIds = '';
	jQuery(".kxbox").each(function(i){
  	this.src = "test" + i + ".jpg";
  	if( $(this).is(':checked') ) {
		    allIds += $(this).val()+",";
		}		
  });
  
  if(allIds==''){
  	alert("请选择采用刊型");
  	return false;
  }else{
  	allIds = allIds.substring(0,allIds.length-1);
  	jQuery(jQuery("input[ecologyname='uf_xxcb_sbInfo.state']")[0]).val(1);    //状态修改为采用
  	jQuery(jQuery("input[ecologyname='uf_xxcb_sbInfo.cykx']")[0]).val(allIds);
//  	jQuery("#field11096").val(allIds);
//  	jQuery("#field11113").val(1);			//状态修改为采用
  	
  	doSubmit(3206,2);	//调用表单建模的编辑保存	
  }
	
	
	
}
function checkCustomize(){
	var allIds = '';
	jQuery(".kxbox").each(function(i){
  	this.src = "test" + i + ".jpg";
  	if( $(this).is(':checked') ) {
		    allIds += $(this).val()+",";
		}		
  });
  
  if(allIds==''){
  	alert("请选择采用刊型");
  	return false;
  }else{
  	allIds = allIds.substring(0,allIds.length-1);
  	jQuery(jQuery("input[ecologyname='uf_xxcb_sbInfo.state']")[0]).val(1);   //状态修改为采用
  	jQuery(jQuery("input[ecologyname='uf_xxcb_sbInfo.cykx']")[0]).val(allIds);
//  	jQuery("#field11096").val(allIds);
//  	jQuery("#field11113").val(1);			//状态修改为采用
//  	var lm = '';
//  	var ids = $parentid$;
//	alert("allIds=  "+allIds+"ids= "+ ids);
//	var kxids = allIds.split(",");
//	for(var j = 0; j < kxids.length; j++) {
//		alert("ContentSelectOperation.jsp?kx="+kxids[j]+"&lm="+lm+"&ids="+ids);
//	    jQuery.ajax({
//		type:'p',
//		url:"ContentSelectOperation.jsp?kx="+kxids[j]+"&lm="+lm+"&ids="+ids,
//		dataType : "json",
//		async:false,
//		});
//	} 
  }
	return true;
  
}


function GetQueryString(name){
     var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
     var r = window.location.search.substr(1).match(reg);
     if(r!=null)return  unescape(r[2]); return null;
}
