
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="java.net.*" %>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="weaver.general.KtreeHelp"%>
<jsp:useBean id="RecordSetFavourite" class="weaver.conn.RecordSet" scope="page"/>

<%
isIncludeToptitle = 1;
String gopage = "";
String hostname = request.getServerName();
String uri = request.getRequestURI();
String querystring="";
titlename = Util.null2String(titlename) ;
String ajaxs="";
for(Enumeration En=request.getParameterNames();En.hasMoreElements();)
{
	String tmpname=(String) En.nextElement();
	
    if(tmpname.equals("ajax"))
	{
		ajaxs=tmpname;
    	continue;
	}
    //String tmpvalue=Util.toScreen(request.getParameter(tmpname),user.getLanguage(),"0");
	//querystring+="^"+tmpname+"="+tmpvalue;
    String [] paramValues = request.getParameterValues(tmpname);   //修复bug，收藏的报表，列不能全部显示的问题，modify by fmj 2015-03-013
    if(paramValues.length > 0){
    	for(int __kk = 0; __kk < paramValues.length; __kk++){
    		querystring+="^"+tmpname+"="+Util.toScreen(paramValues[__kk],user.getLanguage(),"0");
    	}
    }
}
if(!querystring.equals(""))
	querystring=querystring.substring(1);
String pagename= titlename ;

session.setAttribute("fav_pagename" , pagename ) ;
session.setAttribute("fav_uri" , uri ) ;
session.setAttribute("fav_querystring" , querystring ) ;
int addFavSuccess=Util.getIntValue(session.getAttribute("fav_addfavsuccess")+"");
session.setAttribute("fav_addfavsuccess" , "" ) ;
pagename = URLEncoder.encode(pagename);


//is workflow page
boolean isWfFomPage=false;
String strUrl=request.getRequestURL().toString();

if(strUrl.indexOf("AddRequest.jsp")!=-1
		||strUrl.indexOf("ManageRequestNoForm.jsp")!=-1
		||strUrl.indexOf("ManageRequestNoFormMode.jsp")!=-1
		||strUrl.indexOf("ManageRequestNoFormBill.jsp")!=-1
		||strUrl.indexOf("ViewRequest.jsp")!=-1){
	isWfFomPage=true;
}
String isEnableExtranetHelp = KtreeHelp.getInstance().isEnableExtranetHelp;
%>

<!-- bpf start 2013-10-23  -->	
		
		<style type="text/css">
			.popDiv{
				float:right;
				position:absolute;
				top:0px;
				right:0px;
				display:none;
				border:#D8D8D8 1px solid;
			}
			.shadowDiv{
				position:absolute;
				float:left;
				top:0px;
				right:0px;
				width:11px;
				height:7px;
				z-index:3;
				display:none;
				background-image:url(/images/ecology8/angle_wev8.png);
				background-repeat:no-repeat;
			}
		</style>
		
		<div class="shadowDiv" id="shadowBorderDiv"></div>




<script language=javascript>

function setBorder(){
	var a = jQuery("span.selectedTitle");
	var div = jQuery("#shadowBorderDiv");
	//div.show();
	var _top = a.offset().top+a.height();
	var left = a.offset().left;
	//div.width(a.width());
	var width = a.width()+parseInt(a.css("padding-left").replace("px",""))+parseInt(a.css("padding-right").replace("px",""));
	if(a.offset().top==0){
		div.css("top",_top-5);
		div.css("left",left+(width/2)-7);
	}else{
		div.each(function(){jQuery.dequeue(this,'fx');}).animate({top:_top-1,left:left-1}, 1500);
	}
}

jQuery(document).ready(function(){
	window.setTimeout(function(){
		try{
			try{
				preDo();
			}catch(e){}
			//setBorder();
			try{
				afterDo();
			}catch(e){}
		}catch(e){jQuery("#shadowBorderDiv").hide();}
	},10);
	
	jQuery(window).scroll(
		function(){
			try{
				//setBorder();
			}catch(e){}
		}
	);
	
	jQuery("#hoverBtnSpan").bind("click",function(e){
		try{
			//jQuery("#shadowBorderDiv").hide();
			setBorder();
		}catch(e){jQuery("#shadowBorderDiv").hide();}
	});
	
});

function startMouseMove(){
	var handle = null;
	jQuery(document).bind("mousemove",function(e){
		var event = e || window.event;
		var pageX = e.pageX;
		var width = jQuery(document).width();
		//console.log(jQuery(document).width()+"::"+e.pageX+"::"+handle);
		if(Math.abs(pageX-width)<=50){
	if(handle==null){
		   handle=window.setTimeout(function(){
			jQuery("#popDiv").show("slow");
	},1000);
	}
		}else{
		clearTimeout(handle);
		handle=null;
	}
	});
	jQuery("#popDiv").hover(function(){},function(){
		jQuery("#popDiv").hide("slow");
	});
}


function showHelp(){
    /*var pathKey = this.location.pathname;
    //alert(pathKey);
    if(pathKey!=""){
        pathKey = pathKey.substr(1);
    }*/
    var pathKey = "";
	var __url = this.location.href;
	try {
		var __regexp = new RegExp("http(s)?://[^/]+", "gmi");
		__url = __url.replace(__regexp, '');
	} catch (e) {}
	pathKey = encodeURIComponent(__url);
    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;

    var isEnableExtranetHelp = <%=isEnableExtranetHelp%>;
    if(isEnableExtranetHelp==1){
    	//operationPage = "http://e-cology.com.cn/formmode/apps/ktree/ktreeHelp.jsp";
    	operationPage = '<%=KtreeHelp.getInstance().extranetUrl%>';
    }
    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=1000,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
function openFavouriteBrowser()
{  
	
	var BacoTitle = jQuery("#BacoTitle");
	var pagename = "";
	var navName = "";
	var fav_uri = "<%=URLEncoder.encode(uri)%>";
	var fav_querystring = "<%=URLEncoder.encode(querystring)%>";
	
	try
	{
			var e8tabcontainer = jQuery("div[_e8tabcontainer='true']",parent.document);
			if(e8tabcontainer.length > 0) 
			{
				fav_uri = escape(parent.window.location.pathname);
				fav_querystring = escape(parent.window.location.search);
				navName = e8tabcontainer.find("#objName").text();
			}else{
				navName = jQuery("#objName").text();
			}
			//alert(fav_uri+"  "+fav_querystring)
	}
	catch(e)
	{
		
	}
	if(BacoTitle)
	{
		pagename = BacoTitle.text();
	}
	if(!pagename){
		pagename = navName;
	}
    pagename = jQuery.trim(pagename);
	//window.showModalDialog('/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename='+pagename+'&fav_uri='+fav_uri+'&fav_querystring='+fav_querystring+'&mouldID=doc');

    jQuery.post("/systeminfo/FavouriteSession.jsp",{pagename:pagename},function (data) {
        var sessionKey = data.sessionKey;
        var e8tabcontainer2 = jQuery("div[_e8tabcontainer='true']",parent.document);
        var dialogurl = "";
        if(e8tabcontainer2.length > 0){
            dialogurl = '/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename='+sessionKey+'&fav_uri='+fav_uri+'&fav_querystring='+fav_querystring+'&mouldID=doc';
        }else{
            dialogurl = '/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename='+ sessionKey + '&fav_uri='+fav_uri+'&mouldID=doc';  //fav_querystring不通过url传值，而通过session获取，避免url过长时，导致问题
        }

        var dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        dialog.URL = dialogurl;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>";
        dialog.Width = 550 ;
        dialog.Height = 600;
        dialog.Drag = true;
        dialog.show();
    });

}
</script>