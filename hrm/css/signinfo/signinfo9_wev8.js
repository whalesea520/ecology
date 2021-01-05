function showsigninfo(ele) {
	var languageid=readCookie("languageidweaver");
	var target = jQuery(ele);
	var flag = false;
	var __x = 0;
	var __y = 0;
	if (!!ele) {
		var offset = target.offset();
		__x = offset.left - 134/2 + target.width()/2;
		__y = offset.top + 32;
		if(jQuery(document).width()-offset.left<235){
			__x = jQuery(document).width()-280;
			flag =true;
		}
	}
  var _grouphtml = "<div class=\"arrowsblock1\"><img src=\"/images/ecology8/workflow/multres/arrows_wev8.png\" width=\"22px\" height=\"22px\"></div>"
                      + "<div style=\"background:#fff;\" class=\"cg_block\">"
                      + "    <div id=\"_browcommgroupcontentblock\" style='z-index:9;height:235px;'>"
                      + "        <ul>"
                      + "            <li class=\"\">"
                      + "                <img src=\"/images/ecology8/workflow/multres/cg_lodding_wev8.gif\" height=\"27px\" width=\"57px\" style=\"vertical-align:middle;\"/><span class=\"cg_title\" style=\"\">"+SystemEnv.getHtmlNoteName(3650,languageid)
                      + "            </li>"
                      + "        </ul>"
                      + "    </div>"
                      + "</div>";
  var commongroupDiv = jQuery("<div id=\"_browcommgroupblock\" class=\"_browcommgroupblock\" style=\"display:none;z-index:1;left:" + __x + "px;top:" + __y + "px;\"></div>");
  commongroupDiv.html(_grouphtml);
  var signInfoDiv = jQuery("<div class=\"signinfo\"></div>");
  signInfoDiv.html(commongroupDiv);
  jQuery(document.body).append(signInfoDiv);  
	jQuery("#_browcommgroupblock").css({"left":__x+"px", top:__y+"px"});
	if(flag){
  	jQuery(".arrowsblock1").css({"padding-left":278-target.width()-(jQuery(document).width()-offset.left)+"px"});
  }
  initgroupinfo();
	jQuery("html").live('mouseup', function (e) {
		if (jQuery("#_browcommgroupblock").is(":visible") && !!!jQuery(e.target).closest("#_browcommgroupblock")[0]) {
			jQuery("#_browcommgroupblock").remove();
				jQuery("#tdSignInfo").data("isOpen",false);
		}
		//e.stopPropagation();
	});
	   
	if (jQuery.browser.msie) {
		jQuery("a").live("click", function () {
			window.__aeleclicktime = new Date().getTime();
		});
	}
}

function initgroupinfo() {
    var browgroupHtml = "";
    jQuery.ajax({
        type: "get",
        cache: false,
        url: "/hrm/resource/getSignInfo.jsp",
        dataType: "text",  
        contentType : "application/x-www-form-urlencoded;charset=UTF-8",
        complete: function(){
        },
        error:function (XMLHttpRequest, textStatus, errorThrown) {
        } , 
        success : function (data, textStatus) {
          jQuery("#_browcommgroupcontentblock").html(data);
					jQuery("#_browcommgroupcontentblock").css("overflow-y", "hidden");
					if (jQuery(".item_td").length > 2) {
						jQuery("#_browcommgroupcontentblock").css("height", "358px");
						jQuery("#_browcommgroupcontentblock").perfectScrollbar({horizrailenabled:false,zindex:999});
					}
					jQuery("#_browcommgroupblock").show();
					jQuery("#tdSignInfo").data("isOpen",true);
        } 
    }); 
}

jQuery(function () {
	jQuery("html").live('mouseup', function (e) {
		if (jQuery("#_browcommgroupblock").is(":visible") && !!!jQuery(e.target).closest("#_browcommgroupblock")[0]) {
			jQuery("#_browcommgroupblock").remove();
		}
		//e.stopPropagation();
	});
	
	if (jQuery.browser.msie) {
		jQuery("a").live("click", function () {
			window.__aeleclicktime = new Date().getTime();
		});
	}
});

function ajaxInit(){
   var ajax=false;
   try {
       ajax = new ActiveXObject("Msxml2.XMLHTTP");
   } catch (e) {
       try {
           ajax = new ActiveXObject("Microsoft.XMLHTTP");
       } catch (E) {
           ajax = false;
       }
   }
   if (!ajax && typeof XMLHttpRequest!='undefined') {
   ajax = new XMLHttpRequest();
   }
   return ajax;
}
function signInOrSignOut(signType){
	var languageid=readCookie("languageidweaver");
    if(signType != 1){
	    var ajaxUrl = "/wui/theme/ecology8/page/getSystemTime.jsp";
		ajaxUrl += "?field=";
		ajaxUrl += "HH";
		ajaxUrl += "&token=";
		ajaxUrl += new Date().getTime();
		
		jQuery.ajax({
		    url: ajaxUrl,
		    dataType: "text", 
		    contentType : "charset=UTF-8", 
		    error:function(ajaxrequest){}, 
		    success:function(content){
		    	var isWorkTime = jQuery.trim(content);
		    	if (isWorkTime == "true") {
		       	window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(4674,languageid),function(){
		       	writeSignStatus(signType);
		       },function(){
		       	return;
		       })     
		      }else{
		      	writeSignStatus(signType);
		      }
		    }  
	    });
    } else {
    	writeSignStatus(signType);
    }
}

function writeSignStatus(signType) {
	var ajax=ajaxInit();
    ajax.open("POST", "/hrm/schedule/HrmScheduleSignXMLHTTP.jsp?t="+Math.random(), true); 
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("signType="+signType);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            	var tmpDiv = jQuery("<div id=\"_tmptime\" style=\"display:none\"></div>");
            	jQuery(document.body).append(tmpDiv)
            	jQuery("#_tmptime").append(ajax.responseText)
            	showPromptForShowSignInfo(ajax.responseText, signType);
            	initgroupinfo();
            }catch(e){
            }
        }
    }
}

//type  1:显示提示信息
//      2:显示返回的历史动态情况信息
function showPromptForShowSignInfo(content, signType){
	var languageid=readCookie("languageidweaver");
    var targetSrc = "";
	content = jQuery.trim(content).replace(/&nbsp;/g, "");
	var confirmContent = "<div style=\"margin-left:5px;margin-right:5px;\">" + content.substring(content.toUpperCase().indexOf('<TD VALIGN="TOP">') + 17, content.toUpperCase().indexOf("<BUTTON"));
	
    var checkday="";
	if(signType==1) checkday="prevWorkDay";
	if(signType==2) checkday="today";
	jQuery.post("/blog/blogOperation.jsp?operation=signCheck&checkday="+checkday,"",function(data){
		var dataJson=eval("("+data+")");
		if (dataJson.isSignRemind==1){
		    if(!dataJson.prevWorkDayHasBlog&&signType==1){
				confirmContent += "<br><br><span style=\"color:red;\">"+SystemEnv.getHtmlNoteName(4675,languageid)+"</span>";
				targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
			}else if(!dataJson.todayHasBlog&&signType==2){
				confirmContent += "<br><br><span style=\"color:red;\">"+SystemEnv.getHtmlNoteName(4676,languageid)+"</span>";
				targetSrc = "/blog/blogView.jsp?menuItem=myBlog";
			}
			
			confirmContent += "</div>";
			if (targetSrc != undefined && targetSrc != null && targetSrc != "") {
				Dialog.confirm(
					confirmContent, function (){
						window.open(targetSrc);
					}, function () {}, 520, 90,false
			    );
			} else {
				Dialog.alert(confirmContent, function() {}, 520, 60,false);
			}
			
		    return ;
		}
		confirmContent += "</div>";
		Dialog.alert(confirmContent, function() {}, 520, 60,false);
    });
}

function onCloseDivShowSignInfo(){
    var showTableDiv  = document.getElementById('divShowSignInfo');
    var oIframe = document.createElement('iframe');
    
    divShowSignInfo.style.display='none';
    message_Div.style.display='none';
    if (document.all.HelpFrame && document.all.HelpFrame.style) {
        document.all.HelpFrame.style.display='none'
    }
}

jQuery(document).ready(function(){
	jQuery.get("/hrm/resource/getSignInfo.jsp?type=ischeck",function(data){
	var isNeedSign = jQuery.trim(data.isNeedSign);
	var signType = jQuery.trim(data.signType);
	if(isNeedSign == "true") {
		//jQuery("#tdSignInfo").show();
		if(signType == "1"){
			var languageid=readCookie("languageidweaver");
			window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(4680,languageid),function(){
				signInOrSignOut(parseInt(signType));
			});
		}
	}else{
			//jQuery("#tdSignInfo").hide();
	}
	},"json")
})
