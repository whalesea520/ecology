<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.systeminfo.RightClickMenu" %>
<%
/**
 * 获取当前主题及对应皮肤（init.jsp中setting）
 */
String tmpCurTheme = (String)session.getAttribute("SESSION_TEMP_CURRENT_THEME");
String tmpCurskin = (String)session.getAttribute("SESSION_CURRENT_SKIN");
/**
	检测系统配置，查看是否使用右键菜单，如果使用右键菜单，是否显示复制和黏贴的按钮
*/
BaseBean baseBeanRigthMenu = new BaseBean();
int userightmenu = 1;
int showCopyAndPaste=0;
try{
	userightmenu = Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenu", "userightmenu"), 1);
    showCopyAndPaste = Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenucopy", "showCopyAndPaste"), 0);
}catch(Exception e){
	
}
String iframeShtml = "" ;
//iframeShtml += "<table border=0 cellspacing=0 cellpadding=0 id=menuTable name=menuTable"+menuTableClassStr+">";
String isIEBrowser = (String)session.getAttribute("browser_isie"); //是否为IE浏览器
if(userightmenu == 1){
    if(showCopyAndPaste==1&&"true".equals(isIEBrowser)){ //非IE暂不支持粘贴复制
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:onRCMenu_copy(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(16180,user.getLanguage())+",javascript:onRCMenu_plaster(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    defaultMenuCount=defaultMenuCount+2;
    }
	iframeShtml += "<div id='menuTable' name='menuTable' style='width: 160px;' unselectable='on' class='b-m-mpanel'>";
}else{
	
	iframeShtml += "<div id='menuTable' name='menuTable'  style='padding-left:5px;padding-right:5px;'>";
}
RCMenu=Util.StringReplace(RCMenu,"javaScript","javascript");    
boolean loadRcMenu = true;
if(hiddenmenu==1 && userightmenu ==1) loadRcMenu = false;

ArrayList RCMENUArray = new ArrayList();
RCMenu += systemAdminMenu;
RCMenu=RCMenu.trim();
int imgIndex=0;
if (!RCMenu.equals("")) {

				//由原来的apXPDropDown.class转为直接用Button，2003-11-18杨国生。 				
				RCMENUArray = Util.TokenizerString(RCMenu,"}") ;
				if(RCMENUArray == null || RCMENUArray.size() <= defaultMenuCount || loadTopMenu == 0){
					loadRcMenu = false;
				}
				
				int itemNumTemp =0 ;
				String btnNameTemp = "";
				String urlTemp = "";
				String targetTemp = "";
				String btnPageName="";
				
				for (int itemNum=0;itemNum<RCMENUArray.size();itemNum++)
				{	
					String RCMENUTemp = (String)RCMENUArray.get(itemNum);
					RCMENUTemp=RCMENUTemp.trim();
					if (!RCMENUTemp.equals("")){
						RCMENUTemp += "}" ;
						if (RCMENUTemp.indexOf("{-}")==-1)//如果是原来那插件的的隔线即字符串有{-}就不再生成了
						{
							itemNumTemp++;
							RCMENUTemp = RCMENUTemp.substring(1,RCMENUTemp.length()-1); //去掉左右的{}
							RCMENUTemp = RCMENUTemp.trim();
							//ArrayList RCMenuItemArray = Util.TokenizerString(RCMENUTemp,",") ;//把每一项里的参数分解出来
							//2004-04-22杨国生，更改每个菜单项的分解方式，把Util.TokenizerString方式换成substring这样就能固定为3项即菜单名、地址、目标，使得javascript方法能够使用多个参数
							btnNameTemp = RCMENUTemp.substring(0,RCMENUTemp.indexOf(","));
							//(String)RCMenuItemArray.get(0);//名称
							btnNameTemp=btnNameTemp.trim();
							urlTemp = RCMENUTemp.substring((RCMENUTemp.indexOf(",")+1),RCMENUTemp.lastIndexOf(","));	//(String)RCMenuItemArray.get(1);//地址或javascript function
							urlTemp=urlTemp.trim();
							targetTemp = RCMENUTemp.substring((RCMENUTemp.lastIndexOf(",")+1),RCMENUTemp.length());	//(String)RCMenuItemArray.get(2);//target
							targetTemp=targetTemp.trim();
							btnPageName=RCMENUTemp.substring(RCMENUTemp.lastIndexOf(":")+1,RCMENUTemp.lastIndexOf(",")-2);
							if (urlTemp.indexOf("javascript:")==-1)//如果直接给url时处理
								{
									if (targetTemp.equals("_blank"))
										urlTemp ="javascript:window.open('"+urlTemp+"','')";
									else if (targetTemp.equals("_parent"))
										urlTemp ="javascript:parent.parent.location.href=\\\""+urlTemp+"\\\"";
									else if ((targetTemp.equals("_self"))||(targetTemp.equals("_top")))
										urlTemp ="javascript:parent.location.href=\\\""+urlTemp+"\\\"";
									else 
										urlTemp ="javascript:parent."+targetTemp+".location.href=\\\""+urlTemp+"\\\"";
								}
							else 
								{
									if (urlTemp.indexOf("javascript:location=")!=-1)
										urlTemp = "javascript:parent.location.href=\\\"" + urlTemp.substring(21,urlTemp.length()-1)+"\\\"";
									else if (urlTemp.indexOf("javascript:location.href=")!=-1)
										urlTemp = "javascript:parent.location.href=\\\"" + urlTemp.substring(26,urlTemp.length()-1)+"\\\"";
									else
										urlTemp = "javascript:parent." + urlTemp.substring(11);
								}
							String imgPath=RightClickMenu.getIconPath(itemNumTemp,btnNameTemp);
							if("".equals(imgPath)){
								imgIndex++;
								if(imgIndex>9) imgIndex=0;
							}
			  				if(userightmenu == 1){
			  					if(btnPageName.equals("_table.firstPage")||btnPageName.equals("_table.prePage")){
			  						iframeShtml+="<div id='menuItemDivId"+ itemNum +"' unselectable='on' class='b-m-item'  onmouseover=\\\"this.className=\\\'"+"b-m-ifocus"+"\\\'\\\" onmouseout=\\\"this.className=\\\'"+"b-m-item"+"\\\'\\\"   ><div class='b-m-ibody' unselectable='on'><nobr unselectable='on'>";
									iframeShtml+="<img width=16 src='/wui/theme/" + tmpCurTheme + "/skins/" + tmpCurskin + "/contextmenu/"+("".equals(imgPath)?("default/"+imgIndex+".png"):("CM_"+imgPath+".gif"))+"' align='absmiddle'>";
									iframeShtml+="<button  tyle='button' onclick='"+urlTemp+"'  style='width:"+(RCMenuWidth-40)+"px;'>"+btnNameTemp+"</button>";
									iframeShtml+="</nobr></div></div>";
								}
								else{
									
									iframeShtml+="<div id='menuItemDivId"+ itemNum +"' unselectable='on' class='b-m-item'  onmouseover=\\\"this.className=\\\'"+"b-m-ifocus"+"\\\'\\\" onmouseout=\\\"this.className=\\\'"+"b-m-item"+"\\\'\\\"   ><div class='b-m-ibody' unselectable='on'><nobr unselectable='on'>";
									iframeShtml+="<img width=16  src='/wui/theme/" + tmpCurTheme + "/skins/" + tmpCurskin + "/contextmenu/"+("".equals(imgPath)?("default/"+imgIndex+".png"):("CM_"+imgPath+".gif"))+"' align='absmiddle'>";
									iframeShtml+="<button  onclick='"+urlTemp+"'   style='width:"+(RCMenuWidth-40)+"px;'>"+btnNameTemp+"</button>";
									iframeShtml+="</nobr></div></div>";
									
								}
			  				}else{ 
								
			  					if(btnPageName.equals("_table.firstPage")||btnPageName.equals("_table.prePage")){
									iframeShtml += "<button id='"+btnPageName+"' disabled='disabled' UNSELECTABLE='on' class='topClickMenuOut' onmouseover='this.className=\\\"topClickMenuOver\\\"' onmouseout='this.className=\\\"topClickMenuOut\\\"' onclick='"+urlTemp+"' style='width:"+RCMenuWidth+";height:"+RCMenuHeightStep+"' >&nbsp;<img src='/wui/theme/" + tmpCurTheme + "/skins/" + tmpCurskin + "/contextmenu/"+("".equals(imgPath)?("default/"+imgIndex+".png"):("CM_"+imgPath+".gif"))+"' border=0 align='absmiddle'>&nbsp;"+btnNameTemp+"&nbsp;</button>" ;
								}else{
									iframeShtml += "<button id='"+btnPageName+"' UNSELECTABLE='on' class='topClickMenuOut' onmouseover='this.className=\\\"topClickMenuOver\\\"' onmouseout='this.className=\\\"topClickMenuOut\\\"' onclick='"+urlTemp+"' style='height:"+RCMenuHeightStep+"' style='padding-top:2px;'>&nbsp;<img  style='margin-top:-2px;'  src='/wui/theme/" + tmpCurTheme + "/skins/" + tmpCurskin + "/contextmenu/"+("".equals(imgPath)?("default/"+imgIndex+".png"):("CM_"+imgPath+".gif"))+"' border=0  style='' align='absmiddle'><span style='padding-top:4px;'>&nbsp;"+btnNameTemp+"&nbsp;</span></button>" ;
								}
			  				}
			  			}						
					}
				}	
}else{
	loadRcMenu = false;
	iframeShtml="";
}
int menuCount = (int)(RCMenuHeight / RCMenuHeightStep);
int RCMenuWidthAll = (int)(menuCount * RCMenuWidth);
if(userightmenu == 1){
	iframeShtml +="</div>";
}else{
	iframeShtml +="</div>";
}
int needShow = 0;
if(loadRcMenu == true){
	needShow = 1;
}
%>
<input type="hidden" id="needShow" name="needShow" value="<%=needShow%>">

<script language="JavaScript">
//当前使用的主题
var GLOBAL_CURRENT_THEME = "<%=tmpCurTheme %>";
//当前主题使用的皮肤
var GLOBAL_SKINS_FOLDER = "<%=tmpCurskin %>";
function setMenuBoxHeightSelf(){
	try{
		var objhasTopTitleExtInput = document.getElementById("hasTopTitleExtInput");
		if(objhasTopTitleExtInput!=null && objhasTopTitleExtInput.value=="1"){
			document.getElementById("rightMenu").style.visibility = "hidden";
			document.getElementById("rightMenu").style.display="none";
		}
	}catch(e){}
	var menuCount = "<%=menuCount%>";
	var bodyWidth = window.document.body.offsetWidth;
	var menuCountLine = bodyWidth/<%=RCMenuWidth%>>1 ? Math.ceil(bodyWidth/<%=RCMenuWidth%>)-1 : Math.ceil(bodyWidth/<%=RCMenuWidth%>);
	var lineCount = Math.ceil(menuCount/menuCountLine);
	var h = <%=RCMenuHeightStep%>*lineCount;
	//window.status = "bodyWidth:"+bodyWidth+" | menuCountLine:"+menuCountLine+" | lineCount:"+lineCount;
	document.getElementById("rightMenuIframe").height = h + "px";

	window.frames["rightMenuIframe"].document.getElementById("menuTable").style.height = h + "px";
	<%if(loadRcMenu==true){%>
		var objMenuDiv = document.getElementById("divTopMenu");
		if(objMenuDiv!=null){
			objMenuDiv.style.height = h + "px";
			//objMenuDiv.style.border = "1px solid #979797";
			document.getElementById("rightMenu").style.border = "0px";
			//document.getElementById("divTopMenu").style.weight = bodyWidth+"px";
			//window.document.body.style.marginTop = h + "px";
		}else{
			document.getElementById("rightMenu").style.height = h + "px";
			//document.getElementById("rightMenu").style.weight = bodyWidth+"px";
			window.document.body.style.marginTop = h + "px";
		}
	<%}else{%>
	try{
		document.getElementById("divTopMenu").style.border = "0px";
	}catch(e){}
	try{
		document.getElementById("rightMenu").style.border = "0px";
	}catch(e){}
	<%}%>
}
function writeIframe()
{	 
	var shtmlTemp = "<%=iframeShtml%>";
	var shtml = "<html><head><link href='/wui/theme/" + GLOBAL_CURRENT_THEME + "/skins/" + GLOBAL_SKINS_FOLDER + "/contextmenu/contextmenu_wev8.css' rel='stylesheet' type='text/css' /><link rel='stylesheet' href='/css/Weaver_wev8.css'></head><body style='background-color:transparent' leftmargin=0 topmargin=0 bottommargin=0 <%if(userightmenu==1){%> oncontextmenu='return false'<%}%>>";
	shtml += shtmlTemp;	
	shtml += "</body></html>";
	document.getElementById("rightMenuIframe").contentWindow.document.writeln(shtml);
	document.getElementById("rightMenuIframe").contentWindow.document.close(); 
	try{
	 	if(document.getElementById("rightMenuIframe").contentWindow.document.getElementById("menuTable").innerHTML == ""){
			document.getElementById("rightMenu").style.display = "none";
		}
	}catch(e){}
	<%if(userightmenu==0 && loadRcMenu==true) {%>
    try{
	setMenuBoxHeightSelf();
    }catch(e){}
	<%}%>
}

//由原来的apXPDropDown.class转为直接用Button，2003-11-18杨国生。 end

</script>
<%
//System.out.println(request.getRequestURI());
//System.out.println("userightmenu = " + userightmenu);
//System.out.println("loadRcMenu = " + loadRcMenu);
if(userightmenu==1){%>
<div id="rightMenu" name="rightMenu"  style="Z-INDEX:1000">
<!--//由原来的apXPDropDown.class转为直接用Button，2003-11-18杨国生。 -->
<iframe id="rightMenuIframe" name="rightMenuIframe"  frameborder=0 marginheight=0 marginwidth=0 hspace=0 vspace=0 scrolling=no width="<%=RCMenuWidth+2%>" height="<%=RCMenuHeight+6%>" style="background-color:transparent">
</iframe>
</div>
<%}else{	%>
	<div id="rightMenu" name="rightMenu" class="topmenuTable" style="padding:3px;left:0px;right:6px;top:0px;margin-top:0px;posTop:0px;position:absolute;visibility:<%if(loadRcMenu==false){%>hidden<%}else{%>visible<%}%>;display:none;" align="left"  allowtransparency="true" style="background-color:transparent" >
	</div>
	<div id="divRightMenuIframe" name="divRightMenuIframe" style="display:none">
		<iframe id="rightMenuIframe" name="rightMenuIframe" frameborder=0 marginheight=0 marginwidth=0 hspace=0 vspace=0 scrolling=no width="100%" height="<%=RCMenuHeightStep+6%>" style="background-color:transparent">
		</iframe>
	</div>
<%}%>
<script language="JavaScript">
//解决新流程界面在加载页面时，会出现顶部菜单先出现再消失的问题 Start
var needShow = false;
var rightMenu=document.getElementById("rightMenu");
<%if(userightmenu==0 && loadRcMenu==true){%>
</script>
<script language="JavaScript" defer>
onSetRightMenu();

//alert(document.body.onload);
//alert(window.onload);

function onSetRightMenu(){
	var objRightMenuDiv = document.getElementById("rightMenu");
	var objMenuDiv = document.getElementById("divTopMenu");
	var objhasTopTitleExtInput = document.getElementById("hasTopTitleExtInput");
	var toolbarmenudiv = parent.document.getElementById("toolbarmenudiv");
	if(needShow==true && objMenuDiv==null && objhasTopTitleExtInput==null&&toolbarmenudiv!=null){
		objRightMenuDiv.style.display = "none";
		objRightMenuDiv.style.visibility = "hidden";
		objRightMenuDiv.style.position = "absolute";
		//objRightMenuDiv.style.height = "<%=RCMenuHeightStep+2%>px";
	}
	else
	{
		objRightMenuDiv.style.visibility = "visible";
		objRightMenuDiv.style.display="";
		objRightMenuDiv.style.position = "absolute";
	}
}
//解决新流程界面在加载页面时，会出现顶部菜单先出现再消失的问题 End
</script>
<script language="JavaScript">
doMenuInit();
function doMenuInit(){
	var objRightMenuDiv = document.getElementById("rightMenu");
	var objhasTopTitleExtInput = document.getElementById("hasTopTitleExtInput");
	if(objhasTopTitleExtInput!=null && objhasTopTitleExtInput.value=="1"){
		try{
			objRightMenuDiv.style.position = "relative";
			objRightMenuDiv.style.height = "0px";
			objRightMenuDiv.style.display = "none";
		}catch(e){}
	}else{
		try{
			var objMenuDiv = document.getElementById("divTopMenu");
			var rightMenuIframe = document.getElementById("rightMenuIframe");
			if(objMenuDiv!=null){
				if(rightMenuIframe!=null){
					objMenuDiv.appendChild(rightMenuIframe);
				}
				objRightMenuDiv.style.position = "relative";
				objRightMenuDiv.style.height = "0px";
				objRightMenuDiv.style.display = "none";
			}else{
				if(rightMenuIframe!=null){
					objRightMenuDiv.appendChild(rightMenuIframe);
					needShow = true;
				}
			}
		}catch(e){}
	}
}
<%}%>


var focus_e;
function showRightClickMenu(e){
	
	<%
		if(RCMenuHeight==0){	
	%>
	return false;
	<%}%>
    focus_e = document.activeElement;
    var evt = e?e:(window.event?window.event:null);
	var rightedge=document.body.clientWidth-evt.clientX
	var bottomedge=document.body.clientHeight-evt.clientY
	/**
	if (rightedge<rightMenu.offsetWidth)
		rightMenu.style.left=document.body.scrollLeft+event.clientX-rightMenu.offsetWidth
	else
		rightMenu.style.left=document.body.scrollLeft+event.clientX
	if (bottomedge<rightMenu.offsetHeight)
		rightMenu.style.top=document.body.scrollTop+event.clientY-rightMenu.offsetHeight
	else
		rightMenu.style.top=document.body.scrollTop+event.clientY
	*/
	var _srolltop;
	var isIEBrowser = "<%=isIEBrowser%>";
	if(isIEBrowser=="true"){
		_srolltop = document.documentElement.scrollTop;
	}else{
		_srolltop = document.body.scrollTop;
	}
	if(rightedge>evt.clientX){
		//rightMenu.style.left=document.body.clientWidth-rightedge;
		jQuery("#rightMenu").css("left",document.body.clientWidth-rightedge);
	}else{
		//rightMenu.style.left=evt.clientX-rightMenu.offsetWidth;
		jQuery("#rightMenu").css("left",evt.clientX-rightMenu.offsetWidth);
	}
	if(bottomedge>evt.clientY){
		//rightMenu.style.top=evt.clientY+document.body.scrollTop;
		jQuery("#rightMenu").css("top",evt.clientY+_srolltop);
	}else{
		//rightMenu.style.top=document.body.clientHeight+document.body.scrollTop-bottomedge;
		jQuery("#rightMenu").css("top",document.body.clientHeight+_srolltop-bottomedge);
	}
	if(rightMenu.offsetHeight>bottomedge){
		    //rightMenu.style.top=document.body.clientHeight+document.body.scrollTop-rightMenu.offsetHeight;
		    jQuery("#rightMenu").css("top",document.body.clientHeight+_srolltop-rightMenu.offsetHeight);
	}


	rightMenu.style.visibility="visible"	
	rightMenu.style.display="";	
	//evt.stopPropagation();
	evt.cancelBubble = true
	evt.returnValue = false; 
	return false
}
function showRightClickMenu2(e,x,y,sellchanceid){
	
	<%
		if(RCMenuHeight==0){	
	%>
	return false;
	<%}%>
    focus_e = document.activeElement;
    var _x;
    var _y;
    var _top;
    //alert(e.clientX);
    
		_x = x;
		_y = y; 
		_top = _y;
		//alert(_top);
	var rightedge=document.body.clientWidth-_x;
	var bottomedge=document.body.clientHeight-_y;
	/**
	if (rightedge<rightMenu.offsetWidth)
		rightMenu.style.left=document.body.scrollLeft+event.clientX-rightMenu.offsetWidth
	else
		rightMenu.style.left=document.body.scrollLeft+event.clientX
	if (bottomedge<rightMenu.offsetHeight)
		rightMenu.style.top=document.body.scrollTop+event.clientY-rightMenu.offsetHeight
	else
		rightMenu.style.top=document.body.scrollTop+event.clientY
	*/
	
	if(rightedge>_x){
		//rightMenu.style.left=document.body.clientWidth-rightedge;
		jQuery("#rightMenu").css("left",document.body.clientWidth-rightedge);
	}else{
		//rightMenu.style.left=evt.clientX-rightMenu.offsetWidth;
		jQuery("#rightMenu").css("left",_x-rightMenu.offsetWidth);
	}

	/**
	if(bottomedge>_y){
		_top = _y+document.body.scrollTop;
	}else{
		_top = document.body.clientHeight+document.getElementById("leftdiv").scrollTop-bottomedge;
	}*/
	//alert(_y);
	//alert(jQuery("#div_sellchance_"+sellchanceid).position().top);
	
	//_top = _y+jQuery("#div_sellchance_"+sellchanceid).position().top+60;
	
	//_top = _y-(document.getElementById("leftdiv").scrollTop+jQuery("#div_sellchance_"+sellchanceid).position().top);
	//alert(_top);
	jQuery("#rightMenu").css("top",_top);
	if(rightMenu.offsetHeight>bottomedge){
		    //rightMenu.style.top=document.body.clientHeight+document.body.scrollTop-rightMenu.offsetHeight;
		  //  jQuery("#rightMenu").css("top",document.body.clientHeight+document.body.scrollTop-rightMenu.offsetHeight);
	}


	rightMenu.style.visibility="visible"	
	rightMenu.style.display="";	
	//evt.stopPropagation();
	//evt.cancelBubble = true
	//evt.returnValue = false; 
	return false
}

function hideRightClickMenu(){
	<%if(userightmenu==1){%>
	rightMenu.style.visibility="hidden";
	rightMenu.style.display="none";
	<%}%>
}

var isIEBrowser ="<%=isIEBrowser%>";
	<%if(userightmenu==1){%>
	rightMenu.className = "clickRightMenu";
	
	document.oncontextmenu=showRightClickMenu
	
	document.body.onclick = hideRightClickMenu;
	if(isIEBrowser=="true"){
		rightMenu.style.left = document.body.clientWidth-rightMenu.offsetWidth-20;
	}else{
		rightMenu.style.left = document.body.clientWidth-rightMenu.offsetWidth-180;
	}
	rightMenu.style.top = 50;

	<%if(loadRcMenu == true){%>
	rightMenu.style.visibility="visible";
	if (!window.ActiveXObject) {
		rightMenu.style.display="";
	}
	<%}else{%>
	rightMenu.style.visibility="hidden";
	if (!window.ActiveXObject) {
		rightMenu.style.display="none";
	}
	<%}%>
<%}else{%>

<%}%>
//alert(rightMenu.style.visibility);
//alert(rightMenu.innerHTML);

 function viewSourceUrl()
{

    prompt("",location);

}
var mouse_event;
function onRCMenu_copy(){
	var copy_text = document.selection.createRange().text;
	//alert(copy_text);
	try{
		if(copy_text==''){
			copy_text = doccontentifm.document.selection.createRange().text;
		}
	}catch(e){
	}
	window.clipboardData.setData("Text", copy_text);
	rightMenu.style.visibility="hidden";
	rightMenu.style.display="none";
}

function onRCMenu_plaster(){
	if(window.clipboardData.getData("Text") != null){
		try{
			var plaster_text = window.clipboardData.getData("Text");
			//e = document.activeElement;
			//e = body.focus;
            //alert(focus_e.tagName);
			if(focus_e && focus_e.tagName=="INPUT" && focus_e.type=="text"){
				focus_e.value += plaster_text;
			}else if(focus_e && focus_e.tagName=="TEXTAREA"){
				focus_e.value += plaster_text;
			}
			rightMenu.style.visibility="hidden";
			rightMenu.style.display="none";
		}catch(e){
        }
	}
}
function showTDTitle(o)
{
	o.title = o.innerText;
}
//显示指定序号的右键菜单 luow TD30081 TD30084
function showRCMenuItem(menuIntemIndex){	
	var rightMenuIframeDocument = document.getElementById("rightMenuIframe").contentWindow.document;
	rightMenuIframeDocument.getElementById('menuItemDivId'+menuIntemIndex).style.display="";
	var menuCount = 0; 
	jQuery("#menuTable", rightMenuIframeDocument).children().each(function () {
		if (jQuery(this).css("display") != null && jQuery(this).css("display").toLowerCase() != "none") {
			menuCount++;
		}
	});
	
	
	jQuery("#rightMenuIframe").css("height", (menuCount * 24 + 6) + "px");
}
//隐藏指定序号的右键菜单 luow TD30081 TD30084
function hiddenRCMenuItem(menuIntemIndex){	
	var rightMenuIframeDocument = document.getElementById("rightMenuIframe").contentWindow.document;
	rightMenuIframeDocument.getElementById('menuItemDivId'+menuIntemIndex).style.display="none";
	var menuCount = 0; 
	jQuery("#menuTable", rightMenuIframeDocument).children().each(function () {
		if (jQuery(this).css("display") != null && jQuery(this).css("display").toLowerCase() != "none") {
			menuCount++;
		}
	});
	
	jQuery("#rightMenuIframe").css("height", (menuCount * 24 + 6) + "px");
}

writeIframe();
</script>
<%
//
if(userightmenu!=1){
	String  realPath  =  "http://"  +  request.getServerName()  +  ":"  +  request.getServerPort()  +  request.getContextPath()+request.getServletPath();
	
	if(realPath.indexOf("/workflow/request/AddRequest")!=-1||realPath.indexOf("/workflow/request/ManageRequest")!=-1||realPath.indexOf("/workflow/request/ViewRequest")!=-1){
		%>
		<script type="text/javascript">

			jQuery("#divTopMenu").hide();
			jQuery("#rightMenu").hide();
		
		</script>
		<%
	}
}
%>
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
