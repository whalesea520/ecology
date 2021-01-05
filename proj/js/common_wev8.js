String.prototype.replaceAll = function(reallyDo, replaceWith, ignoreCase) {  
    if (!RegExp.prototype.isPrototypeOf(reallyDo)) {  
        return this.replace(new RegExp(reallyDo, (ignoreCase ? "gi": "g")), replaceWith);  
    } else {  
        return this.replace(reallyDo, replaceWith);  
    }  
}  

function OpenNewWindow(sURL,w,h){
  var iWidth = 0 ;
  var iHeight = 0 ;
  iWidth=(window.screen.availWidth-10)*w;
  iHeight=(window.screen.availHeight-50)*h;
  ileft=(window.screen.availWidth - iWidth)/2;
  itop= (window.screen.availHeight - iHeight + 50)/2;
  var szFeatures = "" ;
  szFeatures =	"resizable=no,status=no,menubar=no,width=" +
				iWidth + ",height=" + iHeight*h + ",top="+itop+",left="+ileft
  window.open(sURL,"",szFeatures)
}

function openFullWindowForXtable(url){
	  var redirectUrl = url ;
	  var width = screen.width ;
	  var height = screen.height ;
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

function clearNoNum(obj){
	obj.value = obj.value.replace(/[^\d.]/g,"");
	obj.value = obj.value.replace(/^\./g,"");
	obj.value = obj.value.replace(/\.{2,}/g,".");
	obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$",".");
}


var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
function openDialog(url,title,width,height,blankTab,maxiumnable){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(width){
		dialog.Width = width;
	}else{
		dialog.Width = 600;
	}
	if(height){
		dialog.Height = height;
	}else{
		dialog.Height = 260;
	}
	if(title){
		dialog.Title=title;
	}
	dialog.Drag = true;
	if(maxiumnable&&maxiumnable==true){
		dialog.maxiumnable=true;
	}
	if(blankTab==true){
		dialog.URL = "/proj/data/ProjectBlankTab.jsp?url="+url.replaceAll("&","%26",false) +"&title="+title;
	}else{
		dialog.URL = url;
	}
	//console.log("dialogurl:"+dialog.URL);
	dialog.show();
}

function resetForm(obj){
	var form= obj.parents("form").first();
	
	//form.find("input[type='text']").val("");
	form.find(".e8_os").find("span.e8_showNameClass").remove();
	form.find(".e8_os").find("input[type='hidden']").val("");
	form.find("select[name!=mouldid]").selectbox("detach");
	form.find("select[name!=mouldid]").val("");
	form.find("select[name!=mouldid]").trigger("change");
	form.find("span.jNiceCheckbox").removeClass("jNiceChecked");
	beautySelect(form.find("select[name!=mouldid]"));
	form.find(".calendar").siblings("span").html("");
	form.find(".calendar").siblings("input[type='hidden']").val("");
}

jQuery(document).ready(function () {
	
	jQuery("form").find("input[type=reset]").bind('click',function(){resetForm(jQuery(this));});
	
	jQuery("input[type=checkbox]").each(function(){
	  if(jQuery(this).attr("tzCheckbox")=="true"){
	   jQuery(this).tzCheckbox({labels:['','']});
	  }
	 });
	
});


function refreshTab(){
	jQuery('.flowMenusTd',parent.document).toggle();
	jQuery('.leftTypeSearch',parent.document).toggle();
} 

//主表中金额转换字段调用
function numberToFormat(index,isking){
	var fstr = "field"+index;
	if(isking=="1"){
		fstr = "customfield"+index;
	}
	if(document.getElementById("field_lable"+index).value != ""){
		var floatNum = floatFormat(document.getElementById("field_lable"+index).value);
       	var val = numberChangeToChinese(floatNum)
       	if(val == ""){
       		alert(msgWarningJinEConvert);
            document.getElementById(fstr).value = "";
            document.getElementById("field_lable"+index).value = "";
            document.getElementById("field_chinglish"+index).value = "";
       	} else {
	        document.getElementById(fstr).value = floatNum;
	        document.getElementById("field_lable"+index).value = milfloatFormat(floatNum);
       		document.getElementById("field_chinglish"+index).value = val;
       	}
	}else{
		document.getElementById(fstr).value = "";
		document.getElementById("field_chinglish"+index).value = "";
	}
}
function numberToFormatForReadOnly(index,isking){
	var fstr = "field"+index;
	if(isking=="1"){
		fstr = "customfield"+index;
	}
	if($GetEle(fstr).value!=""){
		$GetEle(fstr+"span").innerHTML=milfloatFormat($GetEle(fstr).value);
		$GetEle(fstr+"ncspan").innerHTML=numberChangeToChinese($GetEle(fstr).value);
	}else{
		$GetEle(fstr+"span").innerHTML="";
		$GetEle(fstr+"ncspan").innerHTML="";
	}
}
function FormatToNumber(index,isking){
	var fstr = "field"+index;
	if(isking=="1"){
		fstr = "customfield"+index;
	}
	var elm = $GetEle("field_lable"+index);
	var n = getLocation(elm);
	if(document.getElementById("field_lable"+index).value != ""){
		document.getElementById("field_lable"+index).value = document.getElementById(fstr).value;
	}else{
		document.getElementById(fstr).value = "";
		document.getElementById("field_chinglish"+index).value = "";
	}
	setLocation(elm,n);
}
//明细表中金额转换字段调用
function numberToChinese(index,isking){
	var fstr = "field"+index;
	if(isking=="1"){
		fstr = "customfield"+index;
	}
	if($G("field_lable"+index).value != ""){
		var floatNum = floatFormat(document.getElementById("field_lable"+index).value);
		var val = numberChangeToChinese(floatNum);
		if(val == ""){
			alert(msgWarningJinEConvert);
			document.getElementById("field_lable"+index).value = "";
			document.getElementById(isking).value = "";
		}else{
			document.getElementById("field_lable"+index).value = val;
			document.getElementById(isking).value = floatNum;
		}
	} else {
		document.getElementById(isking).value = "";
	}
}
function ChineseToNumber(index,isking){
	var fstr = "field"+index;
	if(isking=="1"){
		fstr = "customfield"+index;
	}
	if(document.getElementById("field_lable"+index).value != ""){
		document.getElementById("field_lable"+index).value = chineseChangeToNumber(document.getElementById("field_lable"+index).value);
		document.getElementById(fstr).value = document.getElementById("field_lable"+index).value;
	}else{
		document.getElementById(fstr).value = "";
	}
}