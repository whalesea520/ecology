
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.net.*,weaver.general.Util,weaver.general.BaseBean"%>
<%
isIncludeToptitle = 1;
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
    String tmpvalue=Util.toScreen(request.getParameter(tmpname),user.getLanguage(),"0");
	querystring+="^"+tmpname+"="+tmpvalue;
}
if(!querystring.equals(""))
	querystring=querystring.substring(1);


session.setAttribute("fav_pagename" , titlename ) ;
session.setAttribute("fav_uri" , uri ) ;
session.setAttribute("fav_querystring" , querystring ) ;
%>
<style>
.head_toolbar_noSearch {
	/*border:1px solid #00ffaa;*/
	border-top:0px;
	margin: 5 8 0 5;
}

.head_toolbar_search {
	/*border:1px solid #00ffaa;*/
	border-top:0px;
	margin: 0 8 0 5;
}
.clsSearchContent {
	/*margin-top:2;
	margin-top:2;*/
	PADDING: 4px;*/
}
</style>

<script language="javascript">
/*以下需要开发人员自定义--开始*/
var userightmenu_self = '1'; // 是否使用右键菜单
var _isViewPort=true;  //define layout type
var _pageId="";
var _defaultSearchStatus='close';  //close //show //more
var _divSearchDiv='';  //search div
var _divSearchDivHeight=61; //search div height
/*if(!_onShowOrHidenSearch){ 
	_onShowOrHidenSearch() 
  }else{	  
	you submit code()
  } 
*/
</script>

<input type="hidden" id="hasTopTitleExtInput" name="hasTopTitleExtInput" value="1">
<SPAN id=BacoTitle style="display:none;"><%=titlename%></SPAN>
<script language="javascript">
<%
BaseBean baseBean_TopTitle = new BaseBean();
int userightmenu_TopTitle = 1;
try{
	userightmenu_TopTitle = Util.getIntValue(baseBean_TopTitle.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_TopTitle == 0){
%>	
doSetTopMenu();
function doSetTopMenu(){
	var needShow = null;
	try{
		var obj = document.getElementById("needShow");
		needShow = obj.value;
	}catch(e){}
	if(needShow!=null && needShow=="1"){
		try{
			var objRightMenuDiv = document.getElementById("rightMenu");
			if(objRightMenuDiv!=null && objRightMenuDiv.style.display!="none"){
				//objRightMenuDiv.innerHTML = "";
				objRightMenuDiv.style.height = "0px";
				objRightMenuDiv.style.border = "0px";
				//window.document.body.style.marginTop = "0px";
				objRightMenuDiv.style.position = "relative";
				objRightMenuDiv.style.display = "none";
			}
		}catch(e){}
	}
}
<%
}
%>
var _btnSearchStatusShow=false;
var _divSearchDivHeightNo=61;  //no search div height
//var ck= new Cookies();
function showHelp(){
    /**
    var pathKey = this.location.pathname;
    if(pathKey!=""){
        pathKey = pathKey.substr(1);
    }
    var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
    var screenWidth = window.screen.width*1;
    var screenHeight = window.screen.height*1;
    window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=800,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
	**/
	showWFHelp("<%=helpdocid%>");
}



function _onBtnSearchClick(){  //确认搜索提交按钮			
	
}

function _onShowOrHidenSearch(){  //显示或隐藏搜索
	//alert(_btnSearchStatusShow)
	if(_btnSearchStatusShow) {
		Ext.getCmp("searchPanel").hide();	
		panelTitle.setHeight(_divSearchDivHeightNo);
		
		Ext.getCmp('_btnSearchForTitle').setText(wmsg.grid.search);
		_btnSearchStatusShow=false;
		//if(_pageId!='') Cookies.set(_pageId+"_search","close");
	} else {
		Ext.get(_divSearchDiv).dom.style.display='';
		Ext.getCmp("searchPanel").show()	
		if(_divSearchDivHeight>450){
			_divSearchDivHeight = 450;
			panelTitle.setHeight(_divSearchDivHeight);
			panelTitle.findById('searchPanel').setHeight(400);
		}else{
			panelTitle.setHeight(_divSearchDivHeight);
		}
		
		Ext.getCmp('_btnSearchForTitle').setText(wmsg.grid.hideSearch);
		_btnSearchStatusShow=true;
		//if(_pageId!='') Cookies.set(_pageId+"_search","open");
	} 
	Ext.getCmp("searchPanel").doLayout();
	viewport.doLayout();	
}


</script>

<script language="javascript">	
	var imagefilename="<%=imagefilename%>";
	var titlename="<font class='x-grid3-cell-inner'><%=titlename%></font>";
	var needfav="<%=needfav%>";
	var needhelp="<%=needhelp%>";
	var rightMenuBarItem = [];

	var panelTitle;
	var panleTitleSearch;
	var btnSearchTemp;
	
	Ext.onReady(function() {

		
		
		var clsToolbar="head_toolbar_noViewport";
		if(_isViewPort){
			clsToolbar="head_toolbar";
		}		
		var divSearchHeight=_divSearchDivHeightNo;
		
		var clsToolbarSearch="head_toolbar_noSearch";
		if(_pageId!='')	{
			clsToolbarSearch="head_toolbar_search";
			//var tempStatus=Cookies.get(_pageId+"_search");			
			//if(tempStatus!=null) _defaultSearchStatus=tempStatus;
		}

		var txtSearchStatus;
		
		if(_defaultSearchStatus=="close"){
			txtSearchStatus=wmsg.grid.search;
			
			_btnSearchStatusShow=false
			divSearchHeight=_divSearchDivHeightNo;			
		}else{
			txtSearchStatus=wmsg.grid.hideSearch;
			_btnSearchStatusShow=true
			divSearchHeight=_divSearchDivHeight;		
		}		
		//alert(_btnSearchStatusShow)	
		//alert(divSearchHeight)	
		var BacoTitle = document.getElementById("BacoTitle");
		var pagename = "";
		if(BacoTitle)
		{
			pagename = BacoTitle.innerText;
		}
		tbItems=[
			'<IMG src="'+imagefilename+'" height="20" align="absmiddle">','',titlename,'->',
			{iconCls:"btn_Favorite", tooltip:'<%=SystemEnv.getHtmlLabelName(18753, user.getLanguage())%>',handler: function(){
				var fav_uri = "<%=uri%>";
				var fav_querystring = "<%=querystring%>";
				try
				{
						var e8tabcontainer = jQuery("div[_e8tabcontainer='true']",parent.document);
						if(e8tabcontainer.length > 0) 
						{
							fav_uri = escape(parent.window.location.pathname);
							fav_querystring = escape(parent.window.location.search);
						}
						//alert(fav_uri+"  "+fav_querystring)
				}
				catch(e)
				{
					
				}
				pagename = escape(pagename); 
				window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename="+pagename+"&fav_uri="+fav_uri+"&fav_querystring="+fav_querystring+'&mouldID=doc');
			}},
			{iconCls:"btn_help", tooltip:'<%=SystemEnv.getHtmlLabelName(275, user.getLanguage())%>',handler: function(){showHelp()}}
			,'-',{id:'_btnSearchForTitle',text:txtSearchStatus,iconCls:'btn_searchForTitle',handler: function(){_onShowOrHidenSearch()}}
		] ;	

		if(_divSearchDiv==''){
			if(userightmenu_self!='1'){
				divSearchHeight=61;
			}else{
				divSearchHeight=35;
			}
			 
			tbItems=[
						'<IMG src="'+imagefilename+'" height="20" align="absmiddle">','',titlename,'->',
						{iconCls:"btn_Favorite", tooltip:'<%=SystemEnv.getHtmlLabelName(18753, user.getLanguage())%>',handler: function(){
							var fav_uri = "<%=uri%>";
							var fav_querystring = "<%=querystring%>";
							try
							{
									var e8tabcontainer = jQuery("div[_e8tabcontainer='true']",parent.document);
									if(e8tabcontainer.length > 0) 
									{
										fav_uri = escape(parent.window.location.pathname);
										fav_querystring = escape(parent.window.location.search);
									}
									//alert(fav_uri+"  "+fav_querystring)
							}
							catch(e)
							{
								
							}
							pagename = escape(pagename);
							window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename="+pagename+"&fav_uri="+fav_uri+"&fav_querystring="+fav_querystring+'&mouldID=doc');
						}},
						{iconCls:"btn_help", tooltip:'<%=SystemEnv.getHtmlLabelName(275, user.getLanguage())%>',handler: function(){showHelp()}}						
					] ;	
		}		
	

		if(imagefilename!=null&&titlename!=null){
			if(userightmenu_self!='1'){
				panelTitle = new Ext.Panel({ 
					border : false,
					region : 'north',
					height : divSearchHeight,
					items : [
						new Ext.Toolbar({
							height : 28, 
							cls : clsToolbar,
							border : false,
							items : tbItems
						})	
						,
						new Ext.Panel({
							id:'searchPanel',						
							cls : clsToolbarSearch,
							activeTab: 0,
							collapseMode:'mini',   				
							collapsible: false,          
						    //layout:'fit',
						    autoScroll:true,
						    items: [{
						    	id:"itemPanel",	
						    	listeners:{
						    	 beforerender : function(p){					              
						                try {
						                   if(_defaultSearchStatus=="show"){
						                       Ext.get(_divSearchDiv).dom.style.display='';
						                   }else{
						                   	   Ext.getCmp("searchPanel").hide();
						                   }
						                }  catch (e) {}
						            }
						    	}, 	
							    border:false,
						    	cls:'clsSearchContent',	 	  
						    	contentEl:_divSearchDiv					    	
							}]
							
						})
					    ,new Ext.Toolbar({
						    id:'rightMenuBar',
							border : false,		
							cls : clsToolbar,					
							items : rightMenuBarItem
						})			
					]
				});
			}else{
					panelTitle = new Ext.Panel({ 
					border : false,
					region : 'north',
					height : divSearchHeight,
					items : [
						new Ext.Toolbar({
							height : 28, 
							cls : clsToolbar,
							border : false,
							items : tbItems
						})	
						,
						new Ext.Panel({
							id:'searchPanel',						
							cls : clsToolbarSearch,
							activeTab: 0,
							collapseMode:'mini',   				
							collapsible: false,          
						    //layout:'fit',
						    autoScroll:true,
						    items: [{
						    	id:"itemPanel",	
						    	listeners:{
						    	 beforerender : function(p){					              
						                try {
						                   if(_defaultSearchStatus=="show"){
						                       Ext.get(_divSearchDiv).dom.style.display='';
						                   }else{
						                   	   Ext.getCmp("searchPanel").hide();
						                   }
						                }  catch (e) {}
						            }
						    	}, 	
							    border:false,
						    	cls:'clsSearchContent',	 	  
						    	contentEl:_divSearchDiv					    	
							}]
							
						})
					    ,new Ext.Toolbar({
						    id:'rightMenuBar',
							border : false,		
							cls : clsToolbar,					
							items : rightMenuBarItem
						})			
					]
				});
			}
		}
		
		if(userightmenu_self == '1'){
			Ext.getCmp('rightMenuBar').hide();
			_divSearchDivHeight = _divSearchDivHeight -25;
			panelTitle.setHeight(_divSearchDivHeight);
		}
	});	
	
</script>
