<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.systeminfo.RightClickMenu" %>
<%@page import="weaver.general.KtreeHelp"%>
<%@ page import="weaver.general.GCONST" %>
<%
/**
 * 获取当前主题及对应皮肤（init.jsp中setting）
 */
String tmpCurTheme = "ecology8";//(String)session.getAttribute("SESSION_TEMP_CURRENT_THEME");
String tmpCurskin = "default";//(String)session.getAttribute("SESSION_CURRENT_SKIN");

String iframeShtml = "" ;
//iframeShtml += "<table border=0 cellspacing=0 cellpadding=0 id=menuTable name=menuTable"+menuTableClassStr+">";

if(userightmenu == 1){
	iframeShtml += "<div id='menuTable' name='menuTable' unselectable='on' class='b-m-mpanel' style='background-color:rgb(249,249,249);'>";
}else{
	iframeShtml += "<div id='menuTable' name='menuTable'  style='padding-left:5px;padding-right:5px;background-color:rgb(249,249,249);'>";
}
RCMenu=Util.StringReplace(RCMenu,"javaScript","javascript");    
boolean loadRcMenu = true;
if(hiddenmenu==1 && userightmenu ==1) loadRcMenu = false;

ArrayList RCMENUArray = new ArrayList();
String[] rcm = RCMenu.split("}");
for(int __i=0;__i<rcm.length;__i++){
	showColMenuIndex++;
	if(__i==rcm.length-1 && !Util.null2String(rcm[__i]).trim().equals("")){
		showColMenuIndex++;
	}
}
showColMenuIndex--;
if(showColMenuIndex==-1)showColMenuIndex = 0;
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
					String RCMENUTemp = Util.null2String((String)RCMENUArray.get(itemNum));
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
							boolean isSplitLine = false;
							if(urlTemp.equals("__hr__")){
								isSplitLine = true;
							}else if (urlTemp.indexOf("javascript:")==-1)//如果直接给url时处理
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
							if(isSplitLine){
								iframeShtml+="<div style='height:1px;background-color:#d8d8d8;margin-right:8px;margin-left:8px;'></div>";
							}else{
								if(userightmenu == 1){
									if(btnPageName.equals("_table.firstPage")||btnPageName.equals("_table.prePage")||btnPageName.equals("_table.nextPage")||btnPageName.equals("_table.lastPage")){
										/*iframeShtml+="<div id='menuItemDivId"+ itemNum +"' unselectable='on' class='b-m-item'  onmouseover=\\\"this.className=\\\'"+"b-m-ifocus"+"\\\'\\\" onmouseout=\\\"this.className=\\\'"+"b-m-item"+"\\\'\\\"   ><div class='b-m-ibody' unselectable='on'><nobr unselectable='on'>";
										iframeShtml+="<img width=16  src='/wui/theme/" + tmpCurTheme + "/skins/" + tmpCurskin + "/contextmenu/"+("".equals(imgPath)?("default/"+imgIndex+"_wev8.png"):("CM_"+imgPath+"_wev8.png"))+"' align='absmiddle'>";
										iframeShtml+="<button  tyle='button' onclick='"+urlTemp+"'  style='width:"+(RCMenuWidth-40)+"px;' title='"+btnNameTemp+"'>"+btnNameTemp+"</button>";
										iframeShtml+="</nobr></div></div>";*/
									}
									else{
										
										iframeShtml+="<div id='menuItemDivId"+ itemNum +"' unselectable='on' class='b-m-item'  onmouseover=\\\"this.className=\\\'"+"b-m-ifocus"+"\\\'\\\" onmouseout=\\\"this.className=\\\'"+"b-m-item"+"\\\'\\\"   ><div class='b-m-ibody' unselectable='on'><nobr unselectable='on'>";
										if(btnNameTemp.equals("导出应用")){
											iframeShtml+="<img width=16   src='/wui/theme/" + tmpCurTheme + "/skins/" + tmpCurskin + "/contextmenu/"+("".equals(imgPath)?("CM_icon25_wev8.png"):("default/"+imgIndex+"_wev8.png"))+"' align='absmiddle'>";
										}else if(btnNameTemp.equals("导入应用")){
											iframeShtml+="<img width=16   src='/wui/theme/" + tmpCurTheme + "/skins/" + tmpCurskin + "/contextmenu/"+("".equals(imgPath)?("CM_icon20_wev8.png"):("default/"+imgIndex+"_wev8.png"))+"' align='absmiddle'>";
										}else{
											iframeShtml+="<img width=16   src='/wui/theme/" + tmpCurTheme + "/skins/" + tmpCurskin + "/contextmenu/"+("".equals(imgPath)?("default/"+imgIndex+"_wev8.png"):("CM_"+imgPath+"_wev8.png"))+"' align='absmiddle'>";
										}
										iframeShtml+="<button  onclick='"+urlTemp+";parent.hideRightClickMenu();'   style='width:"+(RCMenuWidth-40)+"px;' title='"+btnNameTemp+"'>"+btnNameTemp+"</button>";
										iframeShtml+="</nobr></div></div>";
										
									}
								}else{ 
									
									if(btnPageName.equals("_table.firstPage")||btnPageName.equals("_table.prePage")){
										iframeShtml += "<button id='menuItemDivId"+ itemNum +"' disabled='disabled' UNSELECTABLE='on' class='topClickMenuOut' onmouseover='this.className=\\\"topClickMenuOver\\\"' onmouseout='this.className=\\\"topClickMenuOut\\\"' onclick='"+urlTemp+"' style='width:"+RCMenuWidth+";height:"+RCMenuHeightStep+"' >&nbsp;<img width='16' src='/wui/theme/" + tmpCurTheme + "/skins/" + tmpCurskin + "/contextmenu/"+("".equals(imgPath)?("default/"+imgIndex+"_wev8.png"):("CM_"+imgPath+"_wev8.png"))+"' border=0 align='absmiddle'>&nbsp;"+btnNameTemp+"&nbsp;</button>" ;
									}else{
										iframeShtml += "<button id='menuItemDivId"+ itemNum +"' UNSELECTABLE='on' class='topClickMenuOut' onmouseover='this.className=\\\"topClickMenuOver\\\"' onmouseout='this.className=\\\"topClickMenuOut\\\"' onclick='"+urlTemp+"' style='height:"+RCMenuHeightStep+"' style='padding-top:2px;'>&nbsp;<img  style='margin-top:-2px;'  width='16'  src='/wui/theme/" + tmpCurTheme + "/skins/" + tmpCurskin + "/contextmenu/"+("".equals(imgPath)?("default/"+imgIndex+"_wev8.png"):("CM_"+imgPath+"_wev8.png"))+"' border=0  style='' align='absmiddle'><span style='padding-top:4px;'>&nbsp;"+btnNameTemp+"&nbsp;</span></button>" ;
									}
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
String isEnExtranetHelp = KtreeHelp.getInstance().isEnableExtranetHelp;
%>
<input type="hidden" id="needShow" name="needShow" value="<%=needShow%>">

<script language="JavaScript">
var _parentmenuDocument = document;
var _menuDocument = document;
var _menuWindow = window;
var __isReloadPage = true;
var __isParentPage = false;
//当前使用的主题
var GLOBAL_CURRENT_THEME = "ecology8";
//当前主题使用的皮肤
var GLOBAL_SKINS_FOLDER = "default";
function setMenuBoxHeightSelf(){
	try{
		var objhasTopTitleExtInput = _menuDocument.getElementById("hasTopTitleExtInput");
		if(objhasTopTitleExtInput!=null && objhasTopTitleExtInput.value=="1"){
			_menuDocument.getElementById("rightMenu").style.visibility = "hidden";
			_menuDocument.getElementById("rightMenu").style.display="none";
		}
	}catch(e){}
	var menuCount = "<%=menuCount%>";
	var bodyWidth = _menuWindow._menuDocument.body.offsetWidth;
	var menuCountLine = bodyWidth/<%=RCMenuWidth%>>1 ? Math.ceil(bodyWidth/<%=RCMenuWidth%>)-1 : Math.ceil(bodyWidth/<%=RCMenuWidth%>);
	var lineCount = Math.ceil(menuCount/menuCountLine);
	var h = <%=RCMenuHeightStep%>*lineCount;
	//_menuWindow.status = "bodyWidth:"+bodyWidth+" | menuCountLine:"+menuCountLine+" | lineCount:"+lineCount;
	_menuDocument.getElementById("rightMenuIframe").height = h + "px";

	_menuWindow.frames["rightMenuIframe"]._menuDocument.getElementById("menuTable").style.height = h + "px";
	<%if(loadRcMenu==true){%>
		var objMenuDiv = _menuDocument.getElementById("divTopMenu");
		if(objMenuDiv!=null){
			objMenuDiv.style.height = h + "px";
			//objMenuDiv.style.border = "1px solid #979797";
			_menuDocument.getElementById("rightMenu").style.border = "0px";
			//_menuDocument.getElementById("divTopMenu").style.weight = bodyWidth+"px";
			//_menuWindow._menuDocument.body.style.marginTop = h + "px";
		}else{
			_menuDocument.getElementById("rightMenu").style.height = h + "px";
			//_menuDocument.getElementById("rightMenu").style.weight = bodyWidth+"px";
			_menuWindow._menuDocument.body.style.marginTop = h + "px";
		}
	<%}else{%>
	try{
		_menuDocument.getElementById("divTopMenu").style.border = "0px";
	}catch(e){}
	try{
		_menuDocument.getElementById("rightMenu").style.border = "0px";
	}catch(e){}
	<%}%>
}
var __parent = window;

function writeIframe(evt,__document,_contentWindow)
{	 try{
		if(!!__document){
			_menuDocument = __document;
			_parentDocument = __document;
			rightMenu = _menuDocument.getElementById("rightMenu");
		}
		if(!!_contentWindow){
			__parent = _contentWindow;
			parent.__parent = _contentWindow;
		}
		var shtmlTemp = "<%=iframeShtml%>";
		if(!!_contentWindow){
			shtmlTemp = shtmlTemp.replace(/\bparent\./g,"__parent.");
		}
		var shtml = "<!DOCTYPE HTML><html><head><script>__parent=parent.__parent;<"+"/script><link href='/wui/theme/" + GLOBAL_CURRENT_THEME + "/skins/" + GLOBAL_SKINS_FOLDER + "/contextmenu/contextmenu_wev8.css' rel='stylesheet' type='text/css' /><link rel='stylesheet' href='/css/Weaver_wev8.css'></head><body leftmargin=0 topmargin=0 bottommargin=0 <%if(!closeRightMenu){%> oncontextmenu='return false'<%}%>>";
		shtml += shtmlTemp;	
		shtml += "</body></html>";
		if(_menuDocument.getElementById("rightMenuIframe")&&_menuDocument.getElementById("rightMenuIframe").contentWindow){
			if(!!_contentWindow){
				//_menuDocument.getElementById("rightMenuIframe").contentWindow.__parent = _contentWindow;
			}
			_menuDocument.getElementById("rightMenuIframe").contentWindow.document.writeln(shtml);
			_menuDocument.getElementById("rightMenuIframe").contentWindow.document.close(); 
			try{
			 	if(_menuDocument.getElementById("rightMenuIframe").contentWindow.document.getElementById("menuTable").innerHTML == ""){
					_menuDocument.getElementById("rightMenu").style.display = "none";
				}
			}catch(e){}
		}
		
		try{
			var pageId = jQuery("#pageId").val();
			if(!pageId || (!!jQuery("#pageId").attr("_showCol") && jQuery("#pageId").attr("_showCol").toLowerCase()=="false")){
				hiddenRCMenuItem(<%=showColMenuIndex%>);
			}
		}catch(e){}
		<%if(userightmenu==0 && loadRcMenu==true) {%>
	    try{
		setMenuBoxHeightSelf();
	    }catch(e){}
		<%}%>
		_menuWindow.setTimeout(function(){
			try{
				var menuCount = 0;
				jQuery("#menuTable", _menuDocument.getElementById("rightMenuIframe").contentWindow.document).children().each(function () {
				if (!jQuery(this).css("display") || jQuery(this).css("display").toLowerCase() != "none") {
					menuCount++;
				}
			});
			jQuery("#rightMenuIframe",_menuDocument).css("height", (menuCount * 22+6) + "px");
			}catch(e){
			}
		},2000);
	}catch(e){
		if(window.console)console.log(e,"RightClickMenu.jsp#writeIframe");
	}
}



//由原来的apXPDropDown.class转为直接用Button，2003-11-18杨国生。 end

</script>
<%
//System.out.println(request.getRequestURI());
//System.out.println("RCMenuHeight = " + RCMenuHeight);
//System.out.println("loadRcMenu = " + loadRcMenu);
if(userightmenu==1){%>
<div id="rightMenu" name="rightMenu"  style="z-index:99999;position:absolute;">
<!--//由原来的apXPDropDown.class转为直接用Button，2003-11-18杨国生。 -->
<iframe id="rightMenuIframe" name="rightMenuIframe"  frameborder=0 marginheight=0 marginwidth=0 hspace=0 vspace=0 scrolling=no width="<%=RCMenuWidth-12%>px" height="<%=RCMenuHeight%>px">
</iframe>
</div>
<%}else{	%>
	<div id="rightMenu" name="rightMenu" class="topmenuTable" style="position:absolute;padding:3px;left:0px;right:6px;top:0px;margin-top:0px;posTop:0px;position:absolute;visibility:<%if(loadRcMenu==false){%>hidden<%}else{%>visible<%}%>;display:none;" align="left"  allowtransparency="true" style="background-color:transparent" >
	</div>
	<div id="divRightMenuIframe" name="divRightMenuIframe" style="display:none">
		<iframe id="rightMenuIframe" name="rightMenuIframe" frameborder=0 marginheight=0 marginwidth=0 hspace=0 vspace=0 scrolling=no width="<%=RCMenuWidth-12%>px" height="<%=RCMenuHeightStep%>px">
		</iframe>
	</div>
<%}%>
<script language="JavaScript">
//解决新流程界面在加载页面时，会出现顶部菜单先出现再消失的问题 Start
var needShow = false;
var rightMenuStr="#rightMenu";
var rightMenu = _menuDocument.getElementById("rightMenu");
<%if(userightmenu==0 && loadRcMenu==true){%>
</script>
<script language="JavaScript" defer>
onSetRightMenu();

//alert(_menuDocument.body.onload);
//alert(_menuWindow.onload);

function onSetRightMenu(){
	var objRightMenuDiv = _menuDocument.getElementById("rightMenu");
	var objMenuDiv = _menuDocument.getElementById("divTopMenu");
	var objhasTopTitleExtInput = _menuDocument.getElementById("hasTopTitleExtInput");
	var toolbarmenudiv = parent._menuDocument.getElementById("toolbarmenudiv");
	if(needShow==true && objMenuDiv==null && objhasTopTitleExtInput==null&&toolbarmenudiv!=null){
		jQuery(objRightMenuDiv).hide();
		objRightMenuDiv.style.visibility = "hidden";
		objRightMenuDiv.style.position = "absolute";
		//objRightMenuDiv.style.height = "<%=RCMenuHeightStep+2%>px";
	}
	else
	{
		objRightMenuDiv.style.visibility = "visible";
		//jQuery(objRightMenuDiv).show();
		objRightMenuDiv.style.position = "absolute";
	}
}
//解决新流程界面在加载页面时，会出现顶部菜单先出现再消失的问题 End
</script>
<script language="JavaScript">
doMenuInit();
function doMenuInit(){
	var objRightMenuDiv = _menuDocument.getElementById("rightMenu");
	var objhasTopTitleExtInput = _menuDocument.getElementById("hasTopTitleExtInput");
	if(objhasTopTitleExtInput!=null && objhasTopTitleExtInput.value=="1"){
		try{
			objRightMenuDiv.style.position = "relative";
			objRightMenuDiv.style.height = "0px";
			objRightMenuDiv.style.display = "none";
		}catch(e){}
	}else{
		try{
			var objMenuDiv = _menuDocument.getElementById("divTopMenu");
			var rightMenuIframe = _menuDocument.getElementById("rightMenuIframe");
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


function showRightClickMenuByHand(_left,_top){
	if(__isParentPage){
		_top += 60;
		_top -= jQuery(document).scrollTop();
	}
	jQuery("#rightMenu",_menuDocument).css("left", _left);
	jQuery("#rightMenu",_menuDocument).css("top", _top);
	jQuery("#rightMenu",_menuDocument).css("visibility", "visible");
	jQuery("#rightMenu",_menuDocument).show();	
}

var focus_e;
function showRightClickMenu(e){
		<%
			if(RCMenuHeight==0){	
		%>
		return false;
		<%}%>
		if(typeof(changePageMenuDiaplay)=="function"){
			changePageMenuDiaplay(2);
		}
        focus_e = _menuDocument.activeElement;
        var evt = e?e:(_menuWindow.event?_menuWindow.event:null);
        var target = null;
        if(_menuWindow.event){
        	target = evt.srcElement;
        }else{
        	target = evt.target;
        }
        var exceptTop = 0;
        if(jQuery(target).closest("div.e8_boxhead").length==0 && __isParentPage){
        	exceptTop = 60;
        }
		var rightedge=_menuDocument.body.clientWidth-evt.clientX
		var bottomedge=_menuDocument.body.clientHeight-evt.clientY
		var scrolltop =  get_scrollTop_of_body();
		if(__isParentPage){
			scrolltop = 0;
		}
		if(rightedge>evt.clientX){
			jQuery(rightMenuStr,_menuDocument).css("left",_menuDocument.body.clientWidth-rightedge);
		}else{
			jQuery(rightMenuStr,_menuDocument).css("left",evt.clientX-_menuDocument.getElementById("rightMenu").offsetWidth);
		}
		if(bottomedge>evt.clientY){
			jQuery(rightMenuStr,_menuDocument).css("top",evt.clientY+scrolltop+exceptTop);
		}else{
			jQuery(rightMenuStr,_menuDocument).css("top",_menuDocument.body.clientHeight+scrolltop-bottomedge+exceptTop);
		}
		if(_menuDocument.getElementById("rightMenu").offsetHeight>bottomedge){
			    if(evt.clientY>(_menuDocument.body.clientHeight/2)){//当页面高度小于菜单高度，那么在页面的上面二分之一的地方点击，菜单显示上面部分，在页面下面部分点击，菜单显示下面部分
					jQuery(rightMenuStr,_menuDocument).css("top",_menuDocument.body.clientHeight+scrolltop-_menuDocument.getElementById("rightMenu").offsetHeight+exceptTop);
			    }
		}

		_menuDocument.getElementById("rightMenu").style.visibility="visible";
		jQuery(rightMenuStr,_menuDocument).show();	
		try{
			evt.stopPropagation();
		}catch(e){
			evt.cancelBubble = true
			evt.returnValue = false; 
		}
		return false;
}
function get_scrollTop_of_body(){ 
        var scrollTop; 
        if(typeof _menuWindow.pageYOffset != 'undefined'){
            scrollTop = _menuWindow.pageYOffset; 
        }else if(typeof _menuDocument.compatMode != 'undefined' && _menuDocument.compatMode != 'BackCompat')        { 
            scrollTop = _menuDocument.documentElement.scrollTop; 
        }else if(typeof _menuDocument.body != 'undefined'){ 
            scrollTop = _menuDocument.body.scrollTop; 
        } 
        return scrollTop; 
}
function hideRightClickMenu(){
	if(jQuery("#modeTitle",_menuWindow.parent._menuDocument).length>0){
		jQuery("#modeTitle",_menuWindow.parent._menuDocument).parent().css("display","none");
	}			
	<%if(userightmenu==1){%>
	try{
		_menuDocument.getElementById("rightMenu").style.visibility="hidden";
	}catch(e){}
	//rightMenu.style.display=""; //update by liaodong for qc62834 in 20130913
	jQuery(rightMenuStr).hide();
	<%}%>
}

var isIEBrowser ="<%=isIEBrowser%>";
var __closeRightMenu__ = <%=closeRightMenu%>;
	<%if(userightmenu==1){%>
	_menuDocument.getElementById("rightMenu").className = "clickRightMenu";
	<%if(!closeRightMenu){%>
		_menuDocument.oncontextmenu=showRightClickMenu
		
		_menuDocument.body.onclick = hideRightClickMenu;
	<%}%>
	if(isIEBrowser=="true"){
		_menuDocument.getElementById("rightMenu").style.left = _menuDocument.body.clientWidth-_menuDocument.getElementById("rightMenu").offsetWidth-200;
	}else{
		_menuDocument.getElementById("rightMenu").style.left = _menuDocument.body.clientWidth-_menuDocument.getElementById("rightMenu").offsetWidth-180;
	}
	_menuDocument.getElementById("rightMenu").style.top = 50;

	<%if(loadRcMenu == true){%>
	_menuDocument.getElementById("rightMenu").style.visibility="visible";
	if (!_menuWindow.ActiveXObject) {
		_menuDocument.getElementById("rightMenu").style.display="";
	}
	<%}else{%>
	_menuDocument.getElementById("rightMenu").style.visibility="hidden";
	if (!_menuWindow.ActiveXObject) {
		_menuDocument.getElementById("rightMenu").style.display="none";
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
	var copy_text = _menuDocument.selection.createRange().text;
	//alert(copy_text);
	try{
		if(copy_text==''){
			copy_text = doccontentifm._menuDocument.selection.createRange().text;
		}
	}catch(e){
		copy_text = ShowSelection();
	}
	_menuWindow.clipboardData.setData("Text", copy_text);
	_menuDocument.getElementById("rightMenu").style.visibility="hidden";
	//rightMenu.style.display="none";
}

function ShowSelection()    {
	if(_menuDocument.getElementById('FCKiframefieldid')){
		 return _menuDocument.getElementById(_menuDocument.getElementById('FCKiframefieldid').value).contentWindow.document.selection.createRange().text;       
	}else{
		return "";
	}
}

function onRCMenu_plaster(){

	if(_menuWindow.clipboardData.getData("Text") != null){
		try{
			var plaster_text = _menuWindow.clipboardData.getData("Text");
			//e = _menuDocument.activeElement;
			//e = body.focus;
            //alert(focus_e.tagName);
			if((focus_e && focus_e.tagName=="INPUT" && focus_e.type=="text")||(focus_e && focus_e.tagName=="TEXTAREA")){
				var selectText = getSelectTxt();
				var pos = getCursorPos(focus_e);
				if(pos==0){
					focus_e.value=focus_e.value.replace(selectText,"");
					focus_e.value = plaster_text+focus_e.value;
				}else if(pos==focus_e.value.length){
					focus_e.value=focus_e.value.replace(selectText,"");
					focus_e.value = focus_e.value+plaster_text;
				}else if(pos>0&&pos<focus_e.value.length){
					focus_e.value=focus_e.value.replace(selectText,"");
					var tmp1 = focus_e.value.substring(0,pos);
					var tmp2 = focus_e.value.substring(pos,focus_e.value.length);
					focus_e.value = tmp1+plaster_text+tmp2;
				}
				
			}
			_menuDocument.getElementById("rightMenu").style.visibility="hidden";
			_menuDocument.getElementById("rightMenu").style.display="none";
		}catch(e){
			alert(e)
        }
	}
}

function getSelectTxt(){
	var selectTxt;
	selectTxt=document.selection.createRange().text;    
	return selectTxt;
}

function getCursorPos(obj)     
{   
	obj.focus();   
	var currentRange=document.selection.createRange();   
	var workRange=currentRange.duplicate();   
	obj.select();   
	var allRange=document.selection.createRange();   
	var pos=0;   
	while(workRange.compareEndPoints("StartToStart",allRange)>0)   
	{   
	  workRange.moveStart("character",-1);   
	  pos++;   
	}   
	currentRange.select();   
	return   pos;   
}   
function getCursorPos1(inpObj){
    if(navigator.userAgent.indexOf("MSIE") > -1) { // IE
    		alert("ie")
            var range = document.selection.createRange();
            range.text = '';
            alert(inpObj.createTextRange())
            range.setEndPoint('StartToStart',inpObj.createTextRange());
            return range.text.length;
        } else {
            return inpObj.selectionStart;
        }
}

function showTDTitle(o)
{
	o.title = o.innerText;
}
//显示指定序号的右键菜单 luow TD30081 TD30084
function showRCMenuItem(menuIntemIndex){
	var rightMenuIframeDocument = _menuDocument.getElementById("rightMenuIframe").contentWindow.document;
	rightMenuIframeDocument.getElementById('menuItemDivId'+menuIntemIndex).style.display="";
	var menuCount = 0; 
	jQuery("#menuTable", rightMenuIframeDocument).children().each(function () {
		if (jQuery(this).css("display") != null && jQuery(this).css("display").toLowerCase() != "none") {
			menuCount++;
		}
	});
	
	
	jQuery("#rightMenuIframe").css("height", (menuCount * 22+6) + "px");
}
//隐藏指定序号的右键菜单 luow TD30081 TD30084
function hiddenRCMenuItem(menuIntemIndex){	
	var rightMenuIframeDocument = _menuDocument.getElementById("rightMenuIframe").contentWindow.document;
	
	jQuery("#menuItemDivId"+menuIntemIndex,rightMenuIframeDocument).hide();
	
	var menuCount = 0; 
	jQuery("#menuTable", rightMenuIframeDocument).children().each(function () {
		if (!jQuery(this).css("display") || jQuery(this).css("display").toLowerCase() != "none") {
			menuCount++;
		}
	});
	
	jQuery("#rightMenuIframe").css("height", (menuCount * 22+6) + "px");
}

//writeIframe();
    if (_menuWindow.addEventListener){
	    _menuWindow.addEventListener("load", writeIframe, false);
	}else if (_menuWindow.attachEvent){
	    _menuWindow.attachEvent("onload", writeIframe);
	}else{
	    _menuWindow.onload=writeIframe;
	}
function __openFavouriteBrowser(flag) {
	___openFavouriteBrowser(flag);
}

function __showHelp(flag) {
	if (typeof(showHelp) == 'function') {
		showHelp();
	} else {
		___showHelp(flag);
	}
}

function ___openFavouriteBrowser(flag) {  
	var BacoTitle = parent.jQuery("#objName");
	if (!!!BacoTitle[0]) {
		BacoTitle = parent.jQuery("#e8_navtab");
	}
	var pagename = "";
	
	var fav_uri = "";
	var fav_querystring = "";
	
	var __url = parent.window.location.href;
	try {
		var __regexp = new RegExp("http://[^/]+", "gmi");
		__url = __url.replace(__regexp, '');
	} catch (e) {
	}
	if (__url.indexOf("?") == -1) {
		fav_uri = __url;
	} else {
		fav_uri = escape(__url.substring(0, __url.indexOf("?")));
		fav_querystring = escape(escape(__url.substr(__url.indexOf("?") + 1)));
	}
	try {
		var e8tabcontainer = jQuery("div[_e8tabcontainer='true']",parent.document);
		if(e8tabcontainer.length > 0)  {
		    fav_uri = escape(parent.window.location.pathname);
			fav_querystring = (escape(jQuery.trim(parent.window.location.search)));
		}
	} catch(e) {}
	if (BacoTitle) {
		pagename = BacoTitle.text();
	}
	
	if (flag == -9) {
		var __reqname = jQuery("input[name=requestname]").val();
		if (!!__reqname && __reqname != "") {
			pagename = __reqname;
		}
	}
	pagename = escape(jQuery.trim(pagename)); 
	
	var dialogurl = '/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename='+pagename+'&fav_uri='+fav_uri+'&fav_querystring='+fav_querystring+'&mouldID=doc';
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.Title = "收藏夹";
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();
}

function ___showHelp(flag){
    /*var pathKey = this.location.pathname;
    //alert(pathKey);
    if(pathKey!=""){
        pathKey = pathKey.substr(1);
    }*/
    var pathKey = "";
	var __url = this.location.href;
	try {
		var __regexp = new RegExp("http://[^/]+", "gmi");
		__url = __url.replace(__regexp, '');
	} catch (e) {}
	pathKey = encodeURIComponent(__url);
    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    var isEnableExtranetHelp = <%=isEnExtranetHelp%>;
    if(isEnableExtranetHelp==1){
    	//operationPage = "/formmode/apps/ktree/ktreeHelp.jsp";
    	operationPage = '<%=KtreeHelp.getInstance().extranetUrl%>';
    }
    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=1000,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
}
</script>
<%
//
if(userightmenu!=1){
	String  realPath  =  "http://"  +  request.getServerName()  +  ":"  +  request.getServerPort()  +  request.getContextPath()+request.getServletPath();
	
	if(realPath.indexOf("/workflow/request/AddRequest")!=-1||realPath.indexOf("/workflow/request/ManageRequest")!=-1||realPath.indexOf("/workflow/request/ViewRequest")!=-1){
		%>
		<script type="text/javascript">

			jQuery("#divTopMenu").hide();
			jQuery("#rightMenu",_menuDocument).hide();
		
		</script>
		<%
	}
}
%>

