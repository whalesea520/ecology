jQuery(function(){
		jQuery(window).bind("scroll", function () {
			_onChange();
		});
		jQuery("#_xTable").css("display","none");
		jQuery("#topTitle").topMenuTitle();
		jQuery("#hoverBtnSpan").hoverBtn(); 
		jQuery('.e8_box').Tabs({
			getLine:1,
			staticOnLoad:false,
			needInitBoxHeight:false,
			needLine:false,
			image:false,
			tabMenuHeight:30

		});
		
		setTimeout(function (){
			var len=jQuery("#titlePanel").width();
			//alert(len);
			jQuery(".tab_menu").css("width",(len-120));

		  },"500");
		
		jQuery("#advancedSearch").unbind("click");
		jQuery("#advancedSearch").click(function (){
			jQuery("#adserch").css("border","none");
			jQuery("#adserch").css("right","5px");
			if(jQuery("#adserch").css("display")=="none"){
			//	var scrollheight=jQuery(document).height()-jQuery(window).height();
				var len=jQuery("#titlePanel").width();
			/**	if(scrollheight>0){
					//有滚动条
					jQuery("#adserch").css("width",len-3);
				}else{
					//没有滚动条
					jQuery("#adserch").css("width",(len-3));
				}**/
				jQuery("#adserch").css("width",len-3);
				jQuery("#adserch").css("display","block");
			}else{
				jQuery("#adserch").css("display","none");
			}				
		})
		

	});		
function refreshTab() {
	jQuery('.flowMenusTd', parent.document).toggle();
	jQuery('.leftTypeSearch', parent.document).toggle();
}
//日期设置
function changeDate(obj,id,val){
	if(val==null)val='6';
	if(obj.value==val){
		jQuery("#"+id).show();
	}else{
		jQuery("#"+id).hide();
		jQuery("#"+id).siblings("input[type='hidden']").val("");
	}
}
function getDate(i) {
	var returndate = window.showModalDialog("/systeminfo/Calendar.jsp", "", "dialogHeight:320px;dialogwidth:275px");
	$GetEle("datespan" + i).innerHTML = returndate;
	$GetEle("dff0" + i).value = returndate;
}
//取消按钮
function cancel(){
	jQuery("#adserch").css("display","none");
}

var engine = 10;
if (window.navigator.appName == "Microsoft Internet Explorer")
{
   // This is an IE browser. What mode is the engine in?
   if (document.documentMode) // IE8
      engine = document.documentMode;
   else // IE 5-7
   {
      engine = 5; // Assume quirks mode unless proven otherwise
      if (document.compatMode)
      {
         if (document.compatMode == "CSS1Compat")
            engine = 7; // standards mode
      }
   }
   // the engine variable now contains the document compatibility mode.
}

/*
 if(engine<7){
	 jQuery("#titlePanel").addClass("dragScroll");
	 jQuery(".titlePanel").addClass("panelScroll");
 }else{
	 if(window.addEventListener){
		window.addEventListener('scroll',_onChange,false);
	 }else if(window.attachEvent){
		window.attachEvent('onscroll',_onChange);
	 }
 }
 */
function _onChange(){
	//获取滚动条的位置
	var top1=document.body.scrollTop;
	
	if (top1 == 0) {
		top1 = get_scrollTop_of_body();
	}
	//获取.titlePanel的位置
	var top2=jQuery(".titlePanel").offset().top;
	
		//window.console.log("top1:"+top1);
	    //window.console.log("top2:"+top2);
	var current = jQuery(".current");
	//alert(top1 + ", " + top2);
	if(top1>=top2){
		jQuery("#signscrollfixed").css("height", (jQuery("#titlePanel").height() + 1) + "px");
		jQuery("#titlePanel").css("position","fixed");
		jQuery("#titlePanel").css("top",0);
		jQuery("#titlePanel").css("z-index", 999);
		jQuery("#titlePanel").css("width",(document.body.clientWidth-2));
	}else{
		jQuery("#signscrollfixed").css("height", "");
		jQuery("#titlePanel").css("position","inherit");
		jQuery("#titlePanel").css("top",top2);
		jQuery("#titlePanel").css("width","100%");
	}
	//jQuery(".magic-line").css("top",(current.position().top + current.height()-12));
}

function get_scrollTop_of_body(){ 
     var scrollTop; 
     if(typeof window.pageYOffset != 'undefined'){//pageYOffset指的是滚动条顶部到网页顶部的距离
         scrollTop = window.pageYOffset; 
     }else if(typeof document.compatMode != 'undefined' && document.compatMode != 'BackCompat')        { 
         scrollTop = document.documentElement.scrollTop; 
     }else if(typeof document.body != 'undefined'){ 
         scrollTop = document.body.scrollTop; 
     } 
     return scrollTop; 
 }