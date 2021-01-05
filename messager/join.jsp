<jsp:useBean id="rsMessagerJoin" class="weaver.conn.RecordSet" scope="page"/>
<!--<div id="divMessagerState"/>-->
<%@ page import="weaver.systeminfo.*" %>
<%
	int widthMsg=262;
	int heightMsg=500;
%>

<style  type="text/css">
#divMessagerState{
	background:#CDCDCD;
	
	height:18px;
	cursor:hand;cursor:pointer;
 	width:58px; 	
}
.txtUserState{

}
#divMessagerState .imgState{		
	width:16px;	
}

#divMessagerState .txtState{	
	word-wrap:break-word;
	color:gray;
}

#divMessager{
	position:absolute;right:40px;top:100px;background:#ffffff; 
	top:-1000px;	
	display:none;
	
	/*
	visibility:hidden;*/
	width:<%=widthMsg%>;
	height:<%=heightMsg%>;
	
	/*padding:3px;display:none;*/
	vertical-align:top;
}
#divMessager  .title .logo{
	color:captiontext;
	cursor:default;	
	font-family:Arial,sans-serif;
	
	font-weight:bold;
	height:1.5em;
	min-height:18px;
	padding-top:3px;
	white-space:nowrap;
	position:absolute;
	left:0px;
}
#divMessager  .title .logo font{
	vertical-align:middle;
	padding-left:3px;
	font-size:10pt;
}

#divMessager  .imgClose{	
	cursor:hand;cursor:pointer;
	position:absolute;
	right:10px;	
	top:1px;
	z-index:100;
}

#divMessager  .imgHide{	
	cursor:hand;cursor:pointer;
	position:absolute;
	right:52px;	
	top:1px;
	z-index:100;  
}

#divModiLogo{
	display:none;
	border:1px solid #ddddee;
	width:350px;
	height:350px;
	background:#EEEEFF;
	padding:10px;
	text-align:center;
	vertical-align:middle;
	position:absolute;	
}
#divModiLogo #divImg{
	border:1px solid #ddddee;
	background:#FFFFFF;
	width:330px;
	height:330px;
	margin:10px;
	padding:10px;	
	text-align:center;
	vertical-align:middle;
	overflow:auto;	
}

.messagerA A{
	COLOR: blue; TEXT-DECORATION: underline
}
.messagerA A:hover {
	COLOR: red; TEXT-DECORATION: underline
}

.messagerA A:link {
	COLOR: blue; TEXT-DECORATION: underline
}
.messagerA A:visited {
	COLOR: blue;TEXT-DECORATION: underline
}


.resize{	
	/*BACKGROUND-IMAGE:url('/messager/images/resize_wev8.gif');cursor: se-resize;*/
	background-repeat :no-repeat;
	height:16px;
	width: 15px;
	position: absolute;
	bottom: 0;
	right: 0;	
	z-index:100;
}


</style>
<LINK href="/messager/ui_wev8.css" type="text/css" rel="STYLESHEET">
<LINK href="/messager/css/gray/main_wev8.css" type="text/css" rel="STYLESHEET">
<!--<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>-->
<script type="text/javascript" src="/messager/jquery/jqDnR_wev8.js"></script> 
<!-- For Other -->
<%@ include file="/messager/Config.jsp" %>
<script type="text/javascript" src="/messager/Util_wev8.js"></script>	

 <!-- For Window -->	
<script type="text/javascript" src="/messager/window/ControlWindow_wev8.js"></script>
<script type="text/javascript" src="/messager/window/BaseWindow_wev8.js"></script>
<script type="text/javascript" src="/messager/window/MessageWindow_wev8.js"></script>
<script type="text/javascript" src="/messager/window/ChatWindow_wev8.js"></script>



<SCRIPT type="text/javascript">	
    var isMessagerShow=false;
    var nickname="<%=user.getLastname()%>";
	function showMessager(objBtn){
		//alert(objBtn.outerHTML)
		var btnPosition = jQuery(objBtn).position();
		//alert(btnPosition.left+":"+btnPosition.top)		
		//var offsetX=jQuery("#divMessager").width()-20;
		//var offsetY=5;		
		//else {	
		jQuery("#divMessager").css({
			top:80,
			left:screen.width-jQuery("#divMessager").width()-30
		});
		//}	
		if(jQuery("#imgMsgStateBar").attr("isMsgAlert")=="true"){
			doShowAllTempMsg();									
		}  else {
			if(isMessagerShow){
				jQuery("#divMessager").hide(); 	
				jQuery("#divMessager").css("visibility","hidden");
				isMessagerShow=false;			
			} else {
				jQuery("#divMessager").show(); 
				jQuery("#divMessager").css("visibility","visible");
				isMessagerShow=true;
			}	
		}
	}			
	jQuery(function() {
		jQuery("#tdMessageState").click(function(){
			showMessager(this);
		}).append("<img src='/messager/images/status/im_unavailable_wev8.png' id='imgMsgStateBar' align='absmiddle'  width='16px' title='<%=SystemEnv.getHtmlLabelName(24508, 7)%>'/>");
		
		//jQuery("#divMessager").iedrag({handle:'.title'});
		jQuery("#divMessager").jqDrag('.title');
		//.jqResize('.resize',{
		//	minWidth:100,
		//	minHeight:50
		//})
		
		/*jQuery("#divMessager").resizable({
                handler: '.resize',
                min: { width: 236, height: 400 },
                onResize: function(e) {
                	document.getElementById("wmForWeb").width = e.data.resizeData.target.css('width');
                	document.getElementById("wmForWeb").height = e.data.resizeData.target.css('height');
                },
                onStop: function(e) {
                    
                }
        });	*/	
        
		window.setTimeout(function(){
			jQuery("#divMessager").show();
		},8000);
		
		var sobjText = "<%=SystemEnv.getHtmlLabelName(24127, 7)%>";
		var sobjValue = "99";
		try{
			if (document.getElementsByName("searchtype") 
					&& document.getElementsByName("searchtype")[0]
					&& document.getElementsByName("searchtype")[0].type != "hidden") {
				var objOpt = document.createElement("option");
				objOpt.text=sobjText;
				objOpt.value = sobjValue;	 
				document.getElementsByName("searchtype")[0].options.add(objOpt);
			} else {
				sobjText = sobjText.substr(2);
				jQuery("#searchBlockUl").append("<li><a href=\"#\"><img src=\"/wui/theme/" + GLOBAL_CURRENT_THEME + "/page/images/toolbar/images_wev8.png\"/>"
												+ "<span searchType=\"" + sobjValue + "\">" 
												+ sobjText + "</span></a></li>");
				jQuery("#searchBlockUl li a").click(function() {
		            var text = jQuery(this).children("span").html();
		            jQuery(".selectTile a span").html(text);
		            jQuery("input[name='searchtype']").val(jQuery(this).children("span").attr("searchType"));
		            jQuery(".selectContent ul").hide();
        		});
			}
		} catch(e){}
	});
	function onMsgHide(){
		jQuery("#divMessager").hide(); 	
		isMessagerShow=false;
		//jQuery("#imgMsgStateBar").trigger("click");	
	}

	function onMsgClose(){
		if(!isMesasgerUnavailable){
			if(confirm("<%=SystemEnv.getHtmlLabelName(24509, 7)%>?")){
				logoutForMessager();
				//onMsgHide();
			}
		} else {
			onMsgHide();
		}		
	}
</SCRIPT>

<%
	//if(user.getLoginid)
%>

<div id="divMessager">		
		
		
		
		<img class="imgHide" src="/messager/images/imgHide_wev8.gif"  id="imgHide" onclick='onMsgHide()' title='<%=SystemEnv.getHtmlLabelName(24510, 7)%>'/>
		<img class="imgClose" src="/messager/images/close_wev8.jpg"  id="imgClose" onclick='onMsgClose()' title='<%=SystemEnv.getHtmlLabelName(1205, 7)%>'/> 
		<!--<table width="100%" height="100%" cellpadding="0" cellspacing="0"> 
		
			<tr>
				<td class="corner-top-left"></td>
				<td class="line-x-t"></td>
				<td class="corner-top-right"></td>
			</tr>
			<tr>
				<td class="line-y-l"></td>
				<td valign="top">
				 -->
				<div class="title"  style="background:url('/messager/css/gray/panel_title_wev8.png');height:30px;font-weight:bold;cursor:move"></div>		
				 	
					<%
					String loginid=user.getLoginid().toLowerCase();
					String strCur=loginid+"_"+TimeUtil.getCurrentTimeString();
					String psw=Util.getEncrypt(strCur);
					String psw2=Util.getEncrypt(Util.getEncrypt(strCur)).toLowerCase();
					String strSql="select count(0) from HrmMessagerAccount where userid='"+loginid+"'";
					rsMessagerJoin.executeSql(strSql);
					if(rsMessagerJoin.next()){
						if(rsMessagerJoin.getInt(1)>0){
							strSql="update HrmMessagerAccount set psw='"+psw2+"' where userid='"+loginid+"'";
						} else {
							strSql="insert into HrmMessagerAccount(userid,psw) values('"+loginid+"','"+psw2+"')";
						}
					}
					rsMessagerJoin.executeSql(strSql);
%>
					
					 <jsp:include page="/messager/flex/wmForWeb.jsp">
						<jsp:param  name="loginid" value="<%=loginid%>"/>
						<jsp:param name="psw" value="<%=psw%>" />					 	
						<jsp:param name="width" value="<%=widthMsg%>" />
						<jsp:param name="height" value="<%=heightMsg%>" />
					 </jsp:include>
				<!-- 	
				</td>
				<td class="line-y-r"></td>
			</tr>
			<tr>
				<td class="corner-bottom-left"></td>
				<td class="line-x-b"></td>
				<td class="corner-bottom-right"></td>
			</tr>
		</table>
		<div class="resize"></div>
		ign="top">
				
</div>

	<!------------Window Template --start------------>
 	 <div class="window" id="windowTemplate">	
		<table width="100%" height="100%" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="corner-top-left"></td>
				<td class="line-x-t"></td>
				<td class="corner-top-right"></td>
			</tr>
			<tr>
				<td class="line-y-l"></td>
				<td valign="top">
					 <div class="content">
						<!--标题区-->
						<div class="title">
							<div class="logo"></div>
							<div class="name">Message Window</div>
							<div class="operate"></div>
						</div>
						<!--主体区-->
						<div class="body"></div>
					</div>
				</td>
				<td class="line-y-r"></td>
			</tr>
			<tr> 
				<td class="corner-bottom-left"></td>
				<td class="line-x-b"></td>
				<td class="corner-bottom-right"></td>
			</tr>			
		</table>

		<div class="resize"></div>
		<iframe height="100%" width="100%" style="z-index:-1;position:absolute;left:0px;top:0px;border:none;"></iframe>
	 </div>
	 <!------------Window Template --end------------>		
<%@ include file="/messager/DocAccessory.jsp" %>

<div style="padding: 2px; display: none" id="divUserIcon"><IFRAME
	src="/messager/GetUserIcon.jsp?loginid=<%=loginid%>" height="100%"
	width="100%" BORDER="0" FRAMEBORDER="no" NORESIZE="NORESIZE"
	scrolling="no"></IFRAME></div>
<div style="padding: 2px; display: none" id="divIframe" class="openFrame"><IFRAME
	 id="ifmOpenPage" height="100%" width="100%" BORDER="0"
	src="" FRAMEBORDER="no" NORESIZE="NORESIZE" scrolling="no"></IFRAME></div>
<script language="javascript">
var imgWindow;
function openUserIconWindow(item){
	imgWindow=ControlWindow.getBaseWindow("imgWindow",rMsg.headIcon,"",600,400,350,100,'divUserIcon');
	imgWindow.show();		
}


function openPage(type, sendTo, titleStr) {

	var strStr = "/messager/OpenPage.jsp?type=" + type + "&sendTo="
			+ sendTo;
	if (type == "prop") {
		window.open(strStr)
	} else if (type == "face") {		
	} else if (type == "email" || type == "sms") {

		var openPageWindow = ControlWindow.getBaseWindow("openPageWindow"
				+ type + sendTo.substring(0, sendTo.indexOf("@")),
				titleStr, "", 380, 280, 350, 100, 'divIframe');
		openPageWindow.show(); 
		openPageWindow.objWindow.find("#ifmOpenPage").attr("src", strStr);
	} else if (type == "allhistory")  {
		var openPageWindow = ControlWindow.getBaseWindow("openPageWindow"
				+ type + sendTo.substring(0, sendTo.indexOf("@")),
				titleStr, "", 600, 400, 350, 100, 'divIframe');
		openPageWindow.show();
		strStr = "/messager/MsgSearch.jsp";
		openPageWindow.objWindow.find("#ifmOpenPage").attr("src", strStr);
	}else {
		var openPageWindow = ControlWindow.getBaseWindow("openPageWindow"
				+ type + sendTo.substring(0, sendTo.indexOf("@")),
				titleStr, "", 600, 400, 350, 100, 'divIframe');
		openPageWindow.show();
		openPageWindow.objWindow.find("#ifmOpenPage").attr("src", strStr);
	}
}

</script>

