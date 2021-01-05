function refreshOpener(){
	try{
		if(opener != null && opener.onRefresh != null){
			opener.onRefresh();
		}
	}catch(e){
					
	}
}
function showTask(taskid){
	openFullWindowHaveBar("/workrelate/task/data/Main.jsp?taskid="+taskid);
}
function showGoal(goalid){
	openFullWindowHaveBar("/workrelate/goal/data/Main.jsp?taskid="+goalid);
}
//替换ajax传递特殊符号
function filter(str){
	str = str.replace(/\+/g,"%2B");
    str = str.replace(/\&/g,"%26");
	return str;	
}
function compdate(a, b) {
    var arr = a.split("-");
    var starttime = new Date(arr[0], arr[1]-1, arr[2]);
    var starttimes = starttime.getTime();

    var arrs = b.split("-");
    var lktime = new Date(arrs[0], arrs[1]-1, arrs[2]);
    var lktimes = lktime.getTime();

    if (starttimes > lktimes) {
        return false;
    }
    else
        return true;
}
function compdatedays(a, b) {
    var arr = a.split("-");
    var starttime = new Date(arr[0], arr[1]-1, arr[2]);
    var starttimes = starttime.getTime();

    var arrs = b.split("-");
    var lktime = new Date(arrs[0], arrs[1]-1, arrs[2]);
    var lktimes = lktime.getTime();

    var days = (lktimes - starttimes)/(3600*1000*24);
    return days;
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
function URLencode(sStr) 
{
    return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
}
document.onmousedown=click;
document.oncontextmenu = new Function("return false;")
function click(e) {
	if (document.all) {
		if (event.button==2||event.button==3) {
			oncontextmenu='return false';
		}
	}
	if (document.layers) {
		if (e.which == 3) {
			oncontextmenu='return false';
		}
	}
}
if (document.layers) {
	document.captureEvents(Event.MOUSEDOWN);
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
function getVal(val){
	if(val==null || typeof(val)=="undefined"){
		return "";
	}else{
		return val;
	}
}
function getsaveval(val){
	return filter(encodeURIComponent(getVal(val)));
}
function getFloatVal(val){
	if(isNaN(parseFloat(val))){
		return 0;
	}else{
		return parseFloat(val);
	}
}
function getIntVal(val){
	if(isNaN(parseInt(val))){
		return 0;
	}else{
		return parseInt(val);
	}
}
Number.prototype.toFixed=function (d) 
{ 

  var s=this+""; 
  if(!d)d=0;     
  if(s.indexOf(".")==-1)s+="."; 
  s+=new Array(d+1).join("0");     
  if(new RegExp("^(-|\\+)?(\\d+(\\.\\d{0,"+(d+1)+"})?)\\d*$").test(s)) 
  { 

    var s="0"+RegExp.$2,pm=RegExp.$1,a=RegExp.$3.length,b=true;       
    if(a==d+2){ 
      a=s.match(/\d/g); 
      if(parseInt(a[a.length-1])>4) 
      { 

        for(var i=a.length-2;i>=0;i--){ 
          a[i]=parseInt(a[i])+1;             
          if(a[i]==10){ 
            a[i]=0; 
            b=i!=1; 

          }else break; 

        } 

      } 
      s=a.join("").replace(new RegExp("(\\d+)(\\d{"+d+"})\\d$"),"$1.$2");         

    }if(b)s=s.substr(1); 
    return (pm+s).replace(/\.$/,""); 

  }return this+"";     

}; 

//隐藏主题页面的左侧菜单
function hideLeftMenu(){
	try{
		var parentbtn = window.parent.jQuery("#leftBlockHiddenContr");
		//alert(parentbtn.length);
		if(parentbtn.length>0){
			if(window.parent.jQuery("#leftBlockTd").width()>0){
				parentbtn.click();
			}
		}else if(window.parent.jQuery(".anticon").length>0){
		    parentbtn = window.parent.jQuery(".anticon");
		    if(parentbtn.hasClass("anticon-menu-fold")){
		        parentbtn.click();
		    }
		}else{
			parentbtn = window.parent.parent.jQuery("#LeftHideShow");
			if(parentbtn.length>0){
				if(parentbtn.attr("title")=="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>"){
					parentbtn.click();
				}
			}else{
				parentbtn = window.parent.parent.jQuery("div.e8_leftToggle");
				if(parentbtn.length>0){
					if(!parentbtn.hasClass("e8_leftToggleShow")){
						parentbtn.click();
					}
				}
			}
		}
	}catch(e){}
}
//显示主题页面的左侧菜单
function showLeftMenu(){
	try{
		var parentbtn = window.parent.jQuery("#leftBlockHiddenContr");
		//alert(parentbtn.length);
		if(parentbtn.length>0){
			if(window.parent.jQuery("#leftBlockTd").width()==0){
				parentbtn.click();
			}
		}else if(window.parent.jQuery(".anticon").length>0){
		    parentbtn = window.parent.jQuery(".anticon");
		    if(!parentbtn.hasClass("anticon-menu-fold")){
		        parentbtn.click();
		    }
		}else{
			parentbtn = window.parent.parent.jQuery("#LeftHideShow");
			if(parentbtn.length>0){
				if(parentbtn.attr("title")=="<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%>"){
					parentbtn.click();
				}
			}else{
				parentbtn = window.parent.parent.jQuery("div.e8_leftToggle");
				if(parentbtn.length>0){
					if(parentbtn.hasClass("e8_leftToggleShow")){
						parentbtn.click();
					}
				}
			}
		}
	}catch(e){}
}