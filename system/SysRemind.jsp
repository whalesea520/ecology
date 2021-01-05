
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.workflow.msg.StartMsgServer"%>
<%@page import="weaver.file.Prop"%>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<%
String isTimeOutLogin = Prop.getPropValue("Others","isTimeOutLogin");
if("2".equals(isTimeOutLogin))return;
%>
<%session.setAttribute("fromlogin","yes");%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">

<SCRIPT language="JavaScript" src="/js/weaver_wev8.js"></SCRIPT>
<script type='text/javascript' src='/dwr/interface/MsgUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>

<style type="text/css">
<!--
BODY {
	FONT-SIZE: 9pt; MARGIN: 0px; FONT-FAMILY: Verdana; LIST-STYLE-TYPE: circle; scrollbar-base-color:#FFFFCC; scrollbar-face-color:#d6d3ce; SCROLLBAR-HIGHLIGHT-COLOR: #f5f9ff; SCROLLBAR-SHADOW-COLOR: #D6D3D6; SCROLLBAR-3DLIGHT-COLOR: #D6D3D6; SCROLLBAR-ARROW-COLOR: #797979; SCROLLBAR-TRACK-COLOR: #EFF3F7; SCROLLBAR-DARKSHADOW-COLOR: #ffffff ; BACKGROUND-COLOR:#D9D9D9
}
-->
</style>
</head>
 
 <SCRIPT language=JavaScript>
 
function CLASS_MSN_MESSAGE(id,width,height,caption,title,message,target,action){  
    this.id     = id;  
    this.title  = title;  
    this.caption= caption;  
    this.message= message;  
    this.target = target;  
    this.action = action;  
    this.width    = width?width:200;  
    this.height = height?height:120;  
    this.timeout= 150;  
    this.speed    = 20; 
    this.step    = 1; 
    this.right    = screen.width -1;  
    this.bottom = screen.height; 
    this.left    = this.right - this.width; 
    this.top    = this.bottom - this.height; 
    this.timer    = 0; 
    this.pause    = false;
    this.close    = false;
    this.autoHide    = true;
    this.url    = "";
    this.liststr  = "";
}  
  

 //隐藏消息方法  
  
CLASS_MSN_MESSAGE.prototype.hide = function(){  
    if(this.onunload()){  

        var offset  = this.height>this.bottom-this.top?this.height:this.bottom-this.top; 
        var me  = this;  
 
        if(this.timer>0){   
            window.clearInterval(me.timer);  
        }  
 
        var fun = function(){  
            if(me.pause==false||me.close){
                var x  = me.left; 
                var y  = 0; 
                var width = me.width; 
                var height = 0; 
                if(me.offset>0){ 
                    height = me.offset; 
                } 
     
                y  = me.bottom - height; 
     
                if(y>=me.bottom){ 
                    window.clearInterval(me.timer);  
                    me.Pop.hide();  
                } else { 
                    me.offset = me.offset - me.step;  
                } 
                me.Pop.show(x,y,width,height);    
            }             
        }  
 
        this.timer = window.setInterval(fun,this.speed)      
    }  
}  
  
 
//    消息卸载事件，可以重写  
 
CLASS_MSN_MESSAGE.prototype.onunload = function() {  
    return true;  
}  

 //  消息命令事件，要实现自己的连接，请重写它  


CLASS_MSN_MESSAGE.prototype.oncommand = function(url){  
    //this.close = true;
    //this.hide();  
   window.open(url);
}  
  
  
//   消息显示方法  

CLASS_MSN_MESSAGE.prototype.show = function(){  
  try{
    var oPopup = window.createPopup(); //IE5.5+  
    
    this.Pop = oPopup;  
    var link = this.url;
    var w = this.width;  
    var h = this.height;
    var dealLabel = "<%= SystemEnv.getHtmlLabelName(18985,user.getLanguage()) %>";
  
    
    var str = "<DIV  WIDTH: " + w + "px; BORDER-BOTTOM: #455690 1px solid; POSITION: absolute; TOP: 0px; HEIGHT: " + h + "px; BACKGROUND-COLOR: #c9d3f3'>"  
    //str += "<TABLE style='BORDER-TOP: #ffffff 1px solid; BORDER-LEFT: #ffffff 1px solid' cellSpacing=0 cellPadding=0 width='100%' bgColor=#cfdef4 border=0 >"  
    str += "<table width='100%' border='0' cellspacing='0' cellpadding='0' background='/images/PopupBg_wev8.jpg' height='135'>"
       
    str += "<TR>"
    str += "<td  height='5'><img src='/images/PopupTop_wev8.jpg' width='210' height='5'></td>"
    str += "</TR>"  
    
   
    str += "<TR>"
    str += "<th background='/images/PopupTitleBg_wev8.jpg' height='26' >"
    str += "<TABLE width='100%' border='0' cellspacing='0' cellpadding='0' style='FONT-SIZE: 9pt; MARGIN: 0px; FONT-FAMILY: Verdana'>"
    str += "<TR>"
        
    str += "<td width='18'></td>"
    str += "<td width='20'><img src='/images/PopupDot_wev8.gif'></td>"
    str += "<th valign='bottom' align='left' >" + this.caption + "</th>"
    str += "<TD style='PADDING-RIGHT: 2px; PADDING-TOP: 2px' vAlign=center align=right width=19>"  
    str += "<SPAN  style='FONT-WEIGHT: bold; FONT-SIZE: 12px; CURSOR: hand; COLOR: red; MARGIN-RIGHT: 4px' id='btSysClose' ><img src='/images/PopupClose_wev8.gif' alt='关闭' border='0'>&nbsp;&nbsp;&nbsp;</SPAN></TD>"  
    
    
    str += "</TR>"  
    str += "</TABLE>"  
    str += "</th>"
    str += "</TR>"  
    
    str += "<TR>"  
    str += "<TD valign='top' style='PADDING-RIGHT: 1px;PADDING-BOTTOM: 1px' colSpan=3 height=" + (h-29) + ">"
    str += "<DIV style=' PADDING-RIGHT: 8px;  PADDING-LEFT: 8px; FONT-SIZE: 9pt; FONT-FAMILY: Verdana; PADDING-BOTTOM: 8px;  WIDTH: 100%;  PADDING-TOP: 8px; '>&nbsp;" + this.title + "<BR><BR>"  
    //str += "<DIV style='WORD-BREAK: break-all' align=left><A href='javascript:void(0)' hidefocus=true id='btCommand'><FONT color=#ff0000>" + this.message + "</FONT></A></DIV>"
    
    str += "<TABLE width='100%' border='0' cellspacing='0' cellpadding='0' style='FONT-SIZE: 9pt; MARGIN: 0px; FONT-FAMILY: Verdana'>"
    str += this.message;

    //str += "<tr><td><br><img src='/images/bwbullet_wev8.gif'></td><td><br><a id='sysRemindInfo' href='#'>&nbsp" + dealLabel + "</a></td></tr>";

    str += "</TABLE>"    
    
    str += "</DIV>"  
    str += "</TD>"  
    str += "</TR>" 
                  
    str += "<TR>"
    str += "<td  height='15'><img src='/images/PopupBottom_wev8.jpg' width='210'></td>"
    str += "</TR>"
     
    str += "</TABLE>"  
    str += "</DIV>"  
    
    oPopup.document.body.innerHTML = str; 
    
  
    this.offset  = 0; 
    var me  = this;  

    oPopup.document.body.onmouseover = function(){me.pause=true;}
    oPopup.document.body.onmouseout = function(){me.pause=false;}

    var fun = function(){  
        var x  = me.left; 
        var y  = 0; 
        var width    = me.width; 
        var height    = me.height; 
 
            if(me.offset>me.height){ 
                height = me.height; 
            } else { 
                height = me.offset; 
            } 
 
        y  = me.bottom - me.offset; 
        if(y<=me.top){ 
            me.timeout--; 
            if(me.timeout==0){ 
                window.clearInterval(me.timer);  
                if(me.autoHide){
                    me.hide(); 
                }
            } 
        } else { 
            me.offset = me.offset + me.step; 
        } 
        me.Pop.show(x,y,width,height+17);    
 
    }  
  
    this.timer = window.setInterval(fun,this.speed)      
  
       
    var btClose = oPopup.document.getElementById("btSysClose");  
  
    btClose.onclick = function(){  
        me.close = true;
        me.hide();  
    }
    
    var sysRemindInfo = oPopup.document.getElementById("sysRemindInfo");
    
    if (sysRemindInfo != null && sysRemindInfo != undefined) {
    	sysRemindInfo.onclick = function(){
    		openFullWindow("sysremind/SysRemindInfoFrame.jsp");
    	}
    }
    
    var messagerTips = oPopup.document.getElementById("messagerTips");
    
    if (messagerTips != null && messagerTips != undefined) {
    	messagerTips.onclick = function(){
    		window.parent.doShowAllTempMsg();
    	}
    }
    
    //var btCommand = oPopup.document.getElementById("btCommand");  
    //btCommand.onclick = function(){  
      
        //me.oncommand(link);  
    //}
   }catch(e){}     
}  

// 设置速度方法 

CLASS_MSN_MESSAGE.prototype.speed = function(s){ 
    var t = 20; 
    try { 
        t = praseInt(s); 
    } catch(e){} 
    this.speed = t; 
} 


//设置步长方法 
 
CLASS_MSN_MESSAGE.prototype.step = function(s){ 
    var t = 1; 
    try { 
        t = praseInt(s); 
    } catch(e){} 
    this.step = t; 
} 
  
CLASS_MSN_MESSAGE.prototype.rect = function(left,right,top,bottom){ 
    try { 
        this.left        = left    !=null?left:this.right-this.width; 
        this.right        = right    !=null?right:this.left +this.width; 
        this.bottom        = bottom!=null?(bottom>screen.height?screen.height:bottom):screen.height; 
        this.top        = top    !=null?top:this.bottom - this.height; 
    } catch(e){} 
} 
</SCRIPT> 
 
 
<script language=javascript>
lightstatus2 = "off";

img1click = "off";
img2click = "off";
img3click = "off";
img4click = "off";

var count =5;

function handlenewrequest(str) {

    var height = 120 + count * 17;

    var MSG1 = new CLASS_MSN_MESSAGE("aa",210,height,"<%=SystemEnv.getHtmlLabelName(19085,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(19085,user.getLanguage())%>",str,"","");  
    MSG1.rect(null,null,null,screen.height-60); 
    MSG1.speed    = 30; 
    MSG1.step    = 10; 
    //alert(MSG1.top);
    //MSG1.url = "http://www.google.com";
    //MSG1.liststr = str;
    MSG1.show();
    
}

function setPoppupHeight(num) {
    count = num * 1 + 1;
}

function turnlighton(index, status) {
    switch (index) {
        case 1: if (status == "on") {
            img1.src = "/images_frame/dh/img1_wev8.gif";
            img1.style.cursor = "hand";
            img1click = "on";
        } else {
            img1.src = "/images_frame/dh/img1-2_wev8.gif";
            img1.style.cursor = "text";
            img1click = "off";
        }
        break;
        case 2: if (status == "on") {
            img2.src = "/images_frame/dh/img2_wev8.gif";
            img2.style.cursor = "hand";
            lightstatus2 = "on";
            img2click = "on";
        } else {
            img2.src = "/images_frame/dh/img2-2_wev8.gif";
            img2.style.cursor = "text";
            lightstatus2 = "off";
            img2click = "off";
        }
        break;
        case 3: if (status == "on") {
            img3.src = "/images_frame/dh/img3_wev8.gif";
            img3.style.cursor = "hand";
            img3click = "on";
        } else {
            img3.src = "/images_frame/dh/img3-2_wev8.gif";
            img3.style.cursor = "text";
            img3click = "off";
        }
        break;
        case 4: if (status == "on") {
            img4.src = "/images_frame/dh/img4_wev8.gif";
            img4.style.cursor = "hand";
            img4click = "on";
        } else {
            img4.src = "/images_frame/dh/img4-2_wev8.gif";
            img4.style.cursor = "text";
            img4click = "off";
        }
        break;
        default:
    }
}

function doPopup(o){
     if(!o==""){
         setPoppupHeight(o.substring(0,o.indexOf(",")));
         handlenewrequest(o.substring(o.indexOf(",")+1)) ;
     }
    /*
	 try{
	 	parent.updateRemindInfo()
	 }catch(e){}
	 */
}
 
function send(){
  try{
	<%
		String  theme  = (String)session.getAttribute("SESSION_CURRENT_THEME");
		if("ecology8".equals(theme)){
	%>
	 	parent.updateRemindInfo();
	<%	
		}else{
	%>
    MsgUtil.getPopupMsg(<%=user.getUID()%>,<%=user.getType()%>,<%=user.getLanguage()%>,doPopup)
  <%
		}
	%>    
	
  }catch(e){}  
}

//doPopup();
send();

//window.setInterval("doPopup()", 3 * 60 * 1000);
window.setInterval("send()", 3 * 60 * 1000);

</script>

<div style="left:0;top:0;height:18;width:90"> 
    <img id=img1 src="/images_frame/dh/img1-2_wev8.gif" onclick="" title="<%=SystemEnv.getHtmlLabelName(2062,user.getLanguage())%>">
    <img id=img2 src="/images_frame/dh/img2-2_wev8.gif" onclick="" title="<%=SystemEnv.getHtmlLabelName(6003,user.getLanguage())%>">
    <img id=img3 src="/images_frame/dh/img3-2_wev8.gif" onclick="" title="<%=SystemEnv.getHtmlLabelName(2066,user.getLanguage())%>">
    <img id=img4 src="/images_frame/dh/img4-2_wev8.gif" onclick="" title="<%=SystemEnv.getHtmlLabelName(2068,user.getLanguage())%>">
</div>

<BODY >
</BODY>
</HTML>