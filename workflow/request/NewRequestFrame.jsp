
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.general.MouldIDConst"%>
<%@page import="weaver.general.Util"%>
<%@page import="javassist.expr.Instanceof"%>

<!--以下是显示定制组件所需的js -->
 
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />

<!-- 
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
-->
 
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<!-- 
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
 -->
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/weaver-ext_wev8.css" />	
<link rel="stylesheet" type="text/css" href="/css/column-tree_wev8.css" />
<script src="/social/js/drageasy/drageasy.js"></script>
<script type="text/javascript" src="/social/js/bootstrap/js/bootstrap.js"></script>
<script type="text/javascript" src="/social/im/js/IMUtil_wev8.js"></script>
<script type="text/javascript" src="/social/js/imcarousel/imcarousel.js"></script>
<%--
<%if(user.getLanguage()==7) {%>
	<script type='text/javascript' src='/js/weaver-lang-cn-gbk_wev8.js'></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/weaver-lang-en-gbk_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/weaver-lang-tw-gbk_wev8.js'></script>
<%}%>
--%>
<jsp:include page="/systeminfo/WeaverLangJS.jsp">
    <jsp:param name="languageId" value="<%=user.getLanguage()%>" />
</jsp:include>

<style>
#loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
#mainRequestFrame {
 LEFT: 3px;
 heigth:100%!important;
/** margin-right:5px;**/
}
.requestContentBody {
 width: 100%;
 height: 100%;
 padding-top:60px;
 padding-bottom:0px;
}
#mainRequestFrame>.requestContentBody {
 height:auto;
 position:absolute;
}
#toolbarmenudiv, #toolbarmenuCoverdiv {
 width:100%;
 position:absolute;
 top:0px;
 BACKGROUND-COLOR:#ECECEC;
 margin-right:8px;
}
#toolbarmenuCoverdiv {
	border-bottom:1px solid #DADADA;
}

#requestTabButton {
 height:28px;
 width:100%;
 position:absolute;
 bottom:-1px;
 border:1px solid #cccccc;
 _bottom:-3px; /*-- for IE6.0 --*/
 margin-top:3px;
 border-top: 2px solid #01b0f1;

}

#toolbarmenudiv .x-btn-mc em button {
	height:20px;
}

#toolbarmenuCoverdiv .x-btn-mc em button {
	height:20px;
}



.x-tab-strip-active span.x-tab-strip-text {
color: #0072BB !important;
}

.x-tab-strip span.x-tab-strip-text {
color: #333;
font-weight: bold;
}


.magic-line {
z-index: 10;
}

.tab_menu li a {
	background:#fff!important;
}
</style>

<script type="text/javascript">

jQuery(function () {
	mainDivResize();
	divWfBillResize();
	// update by liao dong for qc60566 in 20130904 start
	   //jQuery("#bodyiframe").css("overflow-x", "hidden");
	try{
	  if(navigator.userAgent.indexOf("Firefox")>0){ 
	     jQuery("#bodyiframe").css("overflow-x", "auto");
	  }else{
	    jQuery("#bodyiframe").css("overflow-x", "hidden");
	  }
	}catch(e){jQuery("#bodyiframe").css("overflow-x", "hidden");}
	//end
	
	
	jQuery("#bodyiframe").bind("load", function () {
		jQuery(this.contentWindow.document.getElementById("flowbody")).css("overflow-x", "auto");
		
		var detailAreaWidth = jQuery(this.contentWindow.document.getElementById("flowbody")).width();
		if (window.ActiveXObject) {
			detailAreaWidth -= 5;
		} else {
			jQuery(this.contentWindow.document.getElementById("flowbody")).css("overflow-y", "auto");
			detailAreaWidth = jQuery(this.contentWindow.document.getElementById("flowbody")).width();
			detailAreaWidth -= 5;
		} 
		//alert("detailAreaWidth:"+detailAreaWidth);
		//jQuery(this.contentWindow.document.getElementById("workflowDetailArea")).css("width", "auto");
		//jQuery(this.contentWindow.document.getElementById("workflowDetailArea")).css("width", "100%");
		//jQuery(this.contentWindow.document.getElementById("workflowDetailArea")).css("overflow-x", "auto");
		jQuery(this.contentWindow.document.getElementById("workflowDetailArea")).children(".ListStyle").css("table-layout", "fixed");
		
	});
	/*
	if (window.ActiveXObject) {
		document.body.onresize = bodyresize;
	} else {
		*/
		window.onresize = bodyresize;
		/*
	}
		*/
		
		tabs();
		 //update();
		 //resetShadowPosition();
});

var __last_box_width = 0;
function tabs() {
	var width = jQuery(".e8_box").width();
	
	if (width <= 100) {
		setTimeout(function () {
			tabs();
		}, 50);
		return ;
	} 
	jQuery('#workflowFrameNavBlock').Tabs({
	     getLine:1,
	     mouldID:"<%= MouldIDConst.getID("workflow")%>",
	     needTopTitle:true
	 });
	 __last_box_width = jQuery(".e8_box").find("div#rightBox").width();
}

jQuery(document).ready(function(){
    //document.oncontextmenu = null;
});

function bodyresize() {
	mainDivResize();
	divWfBillResize();
}
function mainDivResize() {
	jQuery("#mainRequestFrame").css("height", document.body.clientHeight);
	jQuery("#divWfBill").css("height", document.body.clientHeight);
}

function divWfBillResize() {
	//if (!window.ActiveXObject) {
		jQuery("#divWfBill").css("height", document.body.clientHeight-60);
		jQuery("#divWfLog").css("height", document.body.clientHeight-60);
		jQuery("#divWfPic").css("height", document.body.clientHeight-60);
		if (jQuery("#divWfText")[0]) {
			jQuery("#divWfText").css("height", document.body.clientHeight-60);
		}
	//}
}

function displayRes() {
	
}

/*
function bindRightMenu(e, target) {
	bindInnerRightMenu(e, target);
}
*/

var reqframeBtndata = {doc: undefined, ot: undefined};
var __e8_isWf = true;
function bindInnerRightMenu(e, target) {
	var rightmenuiframe; 
	try {
		rightmenuiframe = target.contentWindow.document.getElementById("rightMenuIframe").contentWindow;
	} catch (e) {}
	
	if (!!!rightmenuiframe) {
		setTimeout(function () {
			bindInnerRightMenu(e, target);
		}, 100);
		return ;
	}
	
	var e8_head = jQuery("#toolbarmenudiv").find("div.e8_boxhead");
	if(e8_head.length==0){
		e8_head = jQuery("#toolbarmenudiv").find("div#rightBox");
	}
	
	jQuery("#rightclickcornerMenu").unbind("click");
	jQuery("#rightclickcornerMenu").click(function(e){
		bindCornerMenuEvent(e8_head, target.contentWindow, e);
		return false;
	});
	
	try{
		var rightMenu = jQuery("#rightMenu");
 		if(rightMenu.length>0){
 			rightMenu.remove();
 			rightMenu = null;
 		}
		jQuery(document).bind("contextmenu",function(e){
	   		showIframeRightMenu(e,target.contentWindow);
	   		return false;
	   	});
	   	jQuery(document).bind("click",function(e){
	   		target.contentWindow.hideRightClickMenu(e);
	   		//return false;
	   	});
	}catch(e){}
}

function getDocButton() {
	var tar = jQuery("#workflowtext")[0];
	var docbtn = jQuery("#topTitle .rightSearchSpan", tar.contentWindow.document).html();
	if (docbtn != null && docbtn != undefined && docbtn != "") {
		reqframeBtndata.doc = docbtn;
		switchtopbtn(true);
	} else {
		setTimeout(function () {
			getDocButton();
		}, 200);
	}
}

function getButton() {
	var otbtn = jQuery("#rightBox ._box").html();
	if (otbtn != null && otbtn != undefined && otbtn != "") {
		reqframeBtndata.ot = otbtn;
		switchtopbtn(false);
	} else {
		setTimeout(function () {
			getButton();
		}, 200);
	}
}

function switchtopbtn(isdoc) {
	if (isdoc) {
		if (reqframeBtndata.doc == null || reqframeBtndata.doc == undefined || reqframeBtndata.doc == "") {
			getDocButton() ;
		} else {
			jQuery("div#docblock .e8_btn_top_first_disabled").attr("disabled",false);
			jQuery("div#docblock .e8_btn_top_disabled").attr("disabled",false);
			jQuery("div#docblock .e8_btn_top_first_disabled").removeClass().addClass("e8_btn_top_first"); 
            jQuery("div#docblock .e8_btn_top_disabled").removeClass().addClass("e8_btn_top"); 
			if (!!!jQuery("#rightBox #docblock")[0]) {
				jQuery("#rightBox ._box").before("<div id='docblock'>" + reqframeBtndata.doc + "</div>");
			} else {
				jQuery("#rightBox #docblock").show();
				jQuery("#rightBox ._box").hide();
			}
			var pw = 0;
			jQuery("#rightBox #docblock").children().each(function () {
				pw += jQuery(this).width()+10;
			});
			var tar = jQuery("#workflowtext")[0];
			var _contentWindow = tar.contentWindow;
			jQuery("div#docblock").find("input[type=button]").each(function(index,obj){
			if(index==0){
				jQuery(this).removeClass("e8_btn_top").addClass("e8_btn_top_first");
				jQuery(this).hover(function(){
					jQuery(this).addClass("e8_btn_top_first_hover");
				},function(){
					jQuery(this).removeClass("e8_btn_top_first_hover");
				});
			}
			var _click = null;
			try{
				_click = this.getAttribute("onclick");
			}catch(e){
				try{ 
					_click = this.getAttributeNode("onclick").nodeValue;
				}catch(e){
					if(window.console)console.log(e);
					try{
						_click = this.getAttributeNode("onclick").value;
					}catch(e){
						if(window.console)console.log(e);
					}
				}
			}
			jQuery(this).removeAttr("onclick").bind("click",function(e){
				try{
				if(_click.toLowerCase().indexOf("javascript:")!=-1 && _click.indexOf("_contentWindow")==-1){
					_click = "javascript:_contentWindow."+_click.substring(_click.indexOf("javascript:")+11);
				}else if(_click.indexOf("_contentWindow")==-1){
					_click = "_contentWindow."+_click;
				}
				eval(_click);
				}catch(e){
					if(window.console)console.log("NewRequestFrame-->"+_click+"--->"+e);
				}
			});
		});
		jQuery("div#docblock").find("span.cornerMenu").each(function(){
			if(!jQuery(this).hasClass("middle")){
				jQuery(this).addClass("middle");
			}
			if(jQuery(this).attr("onclick")){
				var _click = this.getAttributeNode("onclick").nodeValue;
				jQuery(this).attr("onclick","").bind("click",function(e){
					if(_click.toLowerCase().indexOf("javascript:")!=-1 && _click.indexOf("_contentWindow")==-1){
						_click = "javascript:_contentWindow."+_click.substring(_click.indexOf("javascript:")+11);
					}else if(_click.indexOf("_contentWindow")==-1){
						_click = "_contentWindow."+_click;
					}
				});
			}
		});
			jQuery("#rightBox #docblock").width(pw)
			jQuery("#rightBox #docblock").parent().width(pw);
		}
	} else {
		jQuery("#rightBox #docblock").hide();
		jQuery("#rightBox ._box").show();
		if(__last_box_width){
			jQuery("#rightBox").width(__last_box_width);
			jQuery("#rightBox ._box").width(__last_box_width);
		}
		//getButton();
		//jQuery("#rightBox ._box").html(reqframeBtndata.ot)
	}
}
</script>

<div id="loading">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
	<span  id="loading-msg"><%=SystemEnv.getHtmlLabelName(19945, user.getLanguage())%></span>
</div>
<DIV id=mainRequestFrame class=" x-panel-body x-panel-body-noheader" style="left:0px;top:0px;">
	
	<DIV id=toolbarmenudiv style="height:60px;display:none;z-index:99!important;background: #f1f1f1 !important;overflow:hidden;" class="x-small-editor">
		<div class="e8_box" id="workflowFrameNavBlock">
	      <div class="e8_boxhead">
	         <div class="div_e8_xtree" id="div_e8_xtree"></div>
	         <div class="e8_tablogo" id="e8_tablogo" style=""></div>
	         <div class="e8_ultab">
	              <div class="e8_navtab" id="e8_navtab">
	              <span id="objName"><%=titlename%></span>
	         </div>
	         <div>
	             <ul class="tab_menu">
			        <li class="<%=viewdoc.equals("1")?"":"current" %>" id="tab1">
			            <a onclick="javascript:changeTabToWf('WfBill',this);" style="cursor:pointer;">
			             	<span id="test"><%=SystemEnv.getHtmlLabelName(34130,user.getLanguage())%></span>	 
			            </a>
			        </li>
			        <li>
			            <a onclick="javascript:changeTabToWf('WfPic',this);" id="tab2" style="cursor:pointer;">
			             	<span id="test"><%=SystemEnv.getHtmlLabelName(18912,user.getLanguage())%></span>
			            </a>
			        </li>
			        
			        <li>
			            <a onclick="javascript:changeTabToWf('WfLog',this);" id="tab3"  style="cursor:pointer;">
			             	<span id="test"><%=SystemEnv.getHtmlLabelName(19061,user.getLanguage())%></span>
			            </a>
			        </li>
			        <%if(isworkflowdoc.equals("1")){ %>
			        <li class="<%=viewdoc.equals("1")?"current":"" %>"  id="tab4">
			            <a id="divWfTextTab" onclick="javascript:changeTabToWf('WfText',this);"  style="cursor:pointer;">
			             	<span id="test"><%=SystemEnv.getHtmlLabelName(1265,user.getLanguage())%></span>
			            </a>
			        </li>
			        <%} %>
			        <% 
			        if (Util.getIntValue(requestid + "") > 0) {
			        %>
			        <li>
			            <a onclick="javascript:changeTabToWf('WfRes',this);"  style="cursor:pointer;">
			             	<span id="test"><%=SystemEnv.getHtmlLabelName(84399,user.getLanguage())%></span>
			            </a>
			        </li>
			        <%} %>
			        <% 
			        //流程共享
			        //System.out.println("isshared = "+isshared);
			        if (Util.getIntValue(requestid + "") > 0 && isshared.equals("1")) {
			        %>
			        <li>
			            <a onclick="javascript:changeTabToWf('WfSha',this);"  style="cursor:pointer;">
			             	<span id="test"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())+SystemEnv.getHtmlLabelName(119,user.getLanguage())%></span>
			            </a>
			        </li>
			        <%} %>
			           
	          	</ul>
		        <div id="rightBox" class="e8_rightBox">
		        </div>
	       	</div>
	     </div>
	  </div>
	  <div style="height:1px!important;background:#DADADA;width:100%;top:59px;position:absolute;z-index:0">
	  </div>
	
 </div>     
 
 
 
	</DIV>
	
	<div style="display:none;">
		<DIV id="toolbarmenuCoverdiv" style="display:none;z-index:1000!important;filter:alpha(opacity=20);-moz-opacity:0.2;-khtml-opacity: 0.2;opacity: 0.2;" class="x-toolbar x-small-editor">
		</DIV>  
	</div>
	<!--此处为流程图-->
		<div id="divWfPic" class='requestContentBody _synergyBox' style="height:100%;overflow:auto;display:none">
			<IFRAME src='' id=piciframe name=piciframe style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>
		</div>

		<!--此处为流转状态-->
		<div id="divWfLog" class='requestContentBody _synergyBox' style="height:100%;overflow:hidden;display:none">
			<IFRAME src='' id="statiframe" name="statiframe" style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>
		</div>

		<!--此处为流程表单-->
		<div id="divWfBill" class='requestContentBody _synergyBox'  style="height:100%;display:none;">
			<IFRAME src='' id=bodyiframe name=bodyiframe onload="bindInnerRightMenu(event, this)" style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>
		</div>
	<%if(isworkflowdoc.equals("1")){ %>
		<div id="divWfText" class='requestContentBody _synergyBox' style="height:100%;overflow:auto;display:none">
			<IFRAME src='' id=workflowtext onload="" name=workflowtext style='width:100%;height:100%'  BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>
		</div>
	<%} %>
	<% if (Util.getIntValue(requestid + "") > 0) {%>
		<!--此处为流程表单-->
		<div id="divWfRes" class='requestContentBody _synergyBox'  style="height:100%;display:none;">
			<IFRAME src='' id=resiframe name=resiframe style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>
		</div>
	<%} %>
	<% if (Util.getIntValue(requestid + "") > 0) {%>
		<!--此处为流程共享-->
		<div id="divWfSha" class='requestContentBody _synergyBox'  style="height:100%;display:none;">
			<IFRAME src='' id=shaiframe name=shaiframe style='width:100%;height:100%' BORDER=0 FRAMEBORDER=no NORESIZE=NORESIZE scrolling='auto'></IFRAME>
		</div>
	<%} %>
		<!-- 
	<DIV id="toolbarbottommenu" style="display:none;z-index:1000!important;filter:alpha(opacity=20);-moz-opacity:0.2;-khtml-opacity: 0.2;opacity: 0.2;" class="x-toolbar x-small-editor">
	</DIV>
	 -->
	
</div>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;" >	
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu" id="rightclickcornerMenu"></span>
		</td>
	</tr>
</table>

<div style="display:none;" id="wfsignApBlock">
</div>

<div id="backdiv" style="position:absolute;width:100%;height:100%;left:0;top:0;display:none;z-index:9998;"></div>

<div id="submitloaddingdiv_out" style="display:none;background:#000;width:100%;height:100%;top:0px;left:0px; bottom:0px;right:0px;position:absolute;top:0px;left:0px;z-index:9999;filter:alpha(opacity=20);-moz-opacity:0.2;opacity:0.2;">
</div>
<span id="submitloaddingdiv" style="display:none;height:48px;border:1px solid #9cc5db;background:#ebf8ff;color:#4c7c9f;line-height:48px;width:217px;position:absolute;z-index:9999;font-size:12px;">
	<img src="/images/ecology8/workflow/multres/cg_lodding_wev8.gif" height="27px" width="57px" style="vertical-align:middle;"/><span style="margin-left:22px;"><%=SystemEnv.getHtmlLabelName(84041,user.getLanguage())%></span>
</span>

<script type="text/javascript" src="/js/newwf_wev8.js"></script>
<script type="text/javascript" src="/js/newwf1_wev8.js"></script>
<!--如果是自由节点，则隐藏顶部菜单和底部菜单-->
<script>

     <%
	String  freewfid="0";
	//获取自由流程id(系统中只有一个流程绑定该具体单据)
	String  freeWfSql="select  id  from workflow_base a  where  a.formid=285";
	RecordSet.executeSql(freeWfSql);
    boolean isfreewf=false;
	if(RecordSet.next())
	{
	  freewfid=RecordSet.getString("id");
	  isfreewf=true;
	}

    if(isfreewf   &&  (workflowid+"").equals(freewfid))
	{
       //隐藏父窗口
	 %>
       // jQuery("#mainRequestFrame").hide();
    <%
	}	
	%>
	
	function downloads(files) {
        bodyiframe.downloads(files);
    }
</script>