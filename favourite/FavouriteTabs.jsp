
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="frs" class="weaver.conn.RecordSet" scope="page" />
<%
	String favouritetabid = request.getParameter("favouritetabid");
%>
<HTML>
	<HEAD>
		<META http-equiv=Content-Type content="text/html; charset=UTF-8">
		<%if(user.getLanguage()==7) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-cn-gbk_wev8.js'></script>
		<%
		}
		else if(user.getLanguage()==8) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-en-gbk_wev8.js'></script>
		<%
		}
		else if(user.getLanguage()==9) 
		{
		%>
			<script type='text/javascript' src='js/favourite-lang-tw-gbk_wev8.js'></script>
		<%
		}
		%>
		<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />
		<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
		<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>
		<script language="javascript" src="js/SessionProvider_wev8.js"></script>
		<script type="text/javascript" src="js/FavouriteEditWindow_wev8.js"></script>
		<script type="text/javascript" src="/js/extjs/examples/view/data-view-plugins_wev8.js"></script>
		<link rel="stylesheet" type="text/css" href="css/favourite-viewer_wev8.css" />
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
		<SCRIPT language=javascript src="/js/weaver_wev8.js"></SCRIPT>
		<SCRIPT language=javascript src="/js/xmlextras_wev8.js"></SCRIPT>
		<SCRIPT language=javascript src="js/drag_wev8.js"></SCRIPT>
		<STYLE id=styleMenu type=text/css>
TABLE.ElementTable {
	BORDER-RIGHT: #bdbebd 1px solid;
	BORDER-TOP: #bdbebd 1px solid;
	MARGIN-BOTTOM: 10px;
	BORDER-LEFT: #bdbebd 1px solid;
	WIDTH: 100%;
	BORDER-BOTTOM: #bdbebd 1px solid;
}

TABLE.Econtent {
	WIDTH: 100%;
	COLOR: #000000
}

TABLE.Econtent A {
	COLOR: #000000
}

TABLE.Econtent A:visited {
	COLOR: #000000
}

TABLE.Econtent TD {
	COLOR: #000000
}
</STYLE>
<SCRIPT language=JavaScript>
function moveElement(moveEid,srcFlagObj)
{
	var tdInfo = document.getElementById('tdInfo');
	var oEmove=document.getElementById("_elementTable_"+moveEid);
	var targetFlagObj=oEmove.parentNode;

	var srcFlag=srcFlagObj.areaflag;
	var targetFlag=targetFlagObj.areaflag;

	var srcStr="";
	var targetStr="";

	for(i=0;i<srcFlagObj.childNodes.length;i++){
		var tempNode=srcFlagObj.childNodes[i];		
		if (tempNode.className!="ElementTable") continue;
		
		srcStr+=tempNode.eid+",";
	}

	for(i=0;i<targetFlagObj.childNodes.length;i++){
		var tempNode=targetFlagObj.childNodes[i];		
		if (tempNode.className!="ElementTable") continue;
		
		targetStr+=tempNode.eid+",";
	}
	url="FavouriteTabOperation.jsp";
	
	GetContent(tdInfo,url,false);	
}
</SCRIPT>
<SCRIPT language=javascript>
function isdel()
{
   var str = "确定要删除吗?";
   if(!confirm(str))
   {
       return false;
   }
   return true;
} 
var isSetting=false;
var objAreaFlags = new Array();
function init(){
    var strLayoutAreaFlag=document.getElementById("txtlayoutAreas").value;	
	var layoutAreaFlag=strLayoutAreaFlag.split(",");	
	for(var i=0;i<layoutAreaFlag.length;i++)	
	{
		objAreaFlags[i]=document.getElementById("area_"+layoutAreaFlag[i]);
		
	}
	for(var i=0;i<objAreaFlags.length;i++){
		var subTables=objAreaFlags[i].getElementsByTagName("table");
		for(var j=0;j<subTables.length;j++){			
			if(subTables[j].className!="ElementTable") continue;		
			//subTables[j].rows[0].attachEvent("onmousedown",dragStart);
			//jQuery(subTables[j].rows[0]).bind("mousedown",dragStart);
			//jQuery(subTables[j]).bind("drag",draging);
			//jQuery(subTables[j]).bind("dragend",dragEnd);
			//subTables[j].attachEvent("ondrag",draging);
			//subTables[j].attachEvent("ondragend",dragEnd);				
		}
	}    
}
function issubmit()
{
   var str = "null";
   if(!confirm(str))
   {
       return false;
   }
   return true;
} 
function openFavouriteTab(favouriteid,title)
{
	var maintabs = parent.Ext.getCmp('main-tabs');
	var mainpanel = parent.Ext.getCmp('main-view');
	var attributes = {
 						id:favouriteid,
     					url:'/favourite/SysFavouriteOperation.jsp?favouriteid='+favouriteid,
     					title:title,
     					text: title
 				};
 	maintabs.showpanel.loadSysFavourite(attributes);
    parent.Ext.getCmp('main-view').setTitle(title);
    parent.Ext.getCmp('main-view').text = favouriteid;
	maintabs.activate(mainpanel);
}
function onESetting(divSettingobj)
{	
	divSettingobj.style.display='';
}
function onSysFavouritesAdd(divSysAddobj)
{
	var divSysAddobj = document.getElementById(divSysAddobj);
	if(divSysAddobj.style.display=="")
	{
		divSysAddobj.style.display='none';
	}
	else
	{
		divSysAddobj.style.display='';
	}
	
}
function onNoUseSetting(eid){
	document.getElementById("_divESetting_"+eid).style.display='none';
	isSetting=false;
}
function onUseSetting(favourite_tabid,favouriteid)
{	
	var favouriteAliasid = "_eTitel_"+favourite_tabid;
	var favouriteAlias = document.getElementById(favouriteAliasid).value;
	
	var favouritepagesizeid = "_ePerpage_"+favourite_tabid;
	var favouritepagesize = document.getElementById(favouritepagesizeid).value;
	
	var titlecheckedid = "_chkTitleField_"+favourite_tabid;
	var titlechecked = $GetEle(titlecheckedid).checked;
	titlechecked = titlechecked?"1":"-1";
	
	var titlesizeid = "_wordcount_"+favourite_tabid;
	var titlesize = $GetEle(titlesizeid).value;
	
	var importlevelcheckid = "_chkImportLevelField_"+favourite_tabid;
	var importlevelcheck = $GetEle(importlevelcheckid).checked;
	if(importlevelcheck==false)
	{
		importlevelvalue=-1;
	}
	else
	{
		importlevelvalue=1;
	}
	var divContent=document.getElementById("_divEcontent_"+favourite_tabid);
	
	var msg=SystemEnv.getHtmlNoteName(3494,this.languageid);
    divContent.innerHTML="<img src=/images/loading2_wev8.gif> "+msg;
	Ext.Ajax.request({
           url: '/favourite/FavouriteTabOperation.jsp',
           method: 'POST',
           params: 
           {
	           	action: "editfe",
	           	favourite_tabid: favourite_tabid,
	           	favouriteid:favouriteid,
	           	favouriteAlias: favouriteAlias,
	           	favouritepagesize: favouritepagesize,
	           	showfavouritetitle: titlechecked,
	           	favouritetitlesize: titlesize,
	           	showfavouritelevel: importlevelvalue
           },
           success: function(response, request)
	   	   {
	   	   	   document.getElementById("_divESetting_"+favourite_tabid).style.display='none';
	   	   	   var favouriteAliasShowid = "spanEtitle"+favourite_tabid;
	   	   	   var favouriteAliasShow = document.getElementById(favouriteAliasShowid);
	   	   	   favouriteAliasShow.innerHTML = favouriteAlias;
	   	   	   onRefresh(favouriteid,favourite_tabid,response);
	   	   	   setTipInfo();
	   	   },
           failure: function ( result, request) 
           { 
	   		alert(favourite.maingrid.deletefailure); 
		   },
           scope: this
       });
	
}
function onDel(favourite_tabid)
{	
    if(!confirm("您确认删除此元素吗？")) return;
	var oEdel=document.getElementById("_elementTable_"+favourite_tabid);
	var oEdelTD=oEdel.parentNode;
	var oEdelTDFlag=oEdelTD.areaflag;
	var oEdelTDElements="";

	
	Ext.Ajax.request({
           url: '/favourite/FavouriteTabOperation.jsp',
           method: 'POST',
           params: 
           {
	           	action: "deletefe",
	           	favourite_tabid: favourite_tabid
           },
           success: function(response, request)
	   	   {
	   		   oEdel.parentNode.removeChild(oEdel);
	   		   for(i=0;i<oEdelTD.childNodes.length;i++)
				{
					var tempNode=oEdelTD.childNodes[i];		
					if(tempNode.className!="ElementTable") 
						continue;
					oEdelTDElements+=tempNode.favourite_tabid+",";
				}
				setTipInfo();
	   	   },
           failure: function ( result, request) 
           { 
	   		alert(favourite.maingrid.deletefailure); 
		   },
           scope: this
       });
	
	
}
function openFullWindowForXtable(url){
  var redirectUrl = url ;
  var width = screen.width ;
  var height = screen.height ;
  //if (height == 768 ) height -= 75 ;
  //if (height == 600 ) height -= 60 ;
  //var szFeatures = "top=100," ; 
  //szFeatures +="left=400," ;
  //szFeatures +="width="+width/2+"," ;
  //szFeatures +="height="+height/2+"," ; 
  //szFeatures +="directories=no," ;
  //szFeatures +="status=yes," ;
  //szFeatures +="menubar=no," ;
  //szFeatures +="scrollbars=yes," ;
  //szFeatures +="resizable=yes" ; //channelmode
  //window.open(redirectUrl,"",szFeatures) ;
  window.open(redirectUrl);
}

function  readCookie(name){  
   var  cookieValue  =  "7";  
   var  search  =  name  +  "=";
   try{
	   if(document.cookie.length  >  0) {    
	       offset  =  document.cookie.indexOf(search);  
	       if  (offset  !=  -1)  
	       {    
	           offset  +=  search.length;  
	           end  =  document.cookie.indexOf(";",  offset);  
	           if  (end  ==  -1)  end  =  document.cookie.length;  
	           cookieValue  =  unescape(document.cookie.substring(offset,  end))  
	       }  
	   }  
   }catch(exception){
   }
   return  cookieValue;  
} 
function onRefresh(favouriteid,tabid,response)
{
	var divContent=document.getElementById("_divEcontent_"+tabid);
    divContent.innerHTML = response.responseText;
}
function onAddElement(favouriteid,tabid)
{		
	var tblInfo = document.getElementById('tblInfo');
	var tdInfo = document.getElementById('tdInfo');
	tblInfo.style.display='';
	var timestamp = (new Date()).valueOf();
	url="FavouriteTabOperation.jsp?favouriteid="+favouriteid+"&tabid="+tabid+"&action=addfe&ti="+timestamp;
	GetContent(tdInfo,url,true);
}
function  GetContent(divObj,url,isAddElement,code)
{
	var tblInfo = document.getElementById('tblInfo');
	var tdInfo = document.getElementById('tdInfo');
	divObj.innerHTML="<img src=/images/loading2_wev8.gif> 处理中...";
	var xmlHttp;
    if (window.XMLHttpRequest) 
    {
    	xmlHttp = new XMLHttpRequest();
    }  
    else if (window.ActiveXObject) 
    {
    	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");  
    }
	xmlHttp.open("GET",url, true);
	xmlHttp.onreadystatechange = function () {
		switch (xmlHttp.readyState) {
           case 3 :
			    divObj.innerHTML="<img src=/images/loading2_wev8.gif> 传输中...";
		        break;
		   case 4 :
				divObj.innerHTML =xmlHttp.responseText;
                if(xmlHttp.status < 400)   if(code!=null&&code!="") eval(code);
		       if(isAddElement){
				   var tblElement=tdInfo.firstChild;
					tblInfo.insertAdjacentElement("afterEnd",tblElement);
					tblInfo.style.display='none';
					//jQuery(tblElement.rows[0]).bind("mousedown",dragStart)
					//tblElement.rows[0].attachEvent("onmousedown",dragStart);
					//jQuery(tblElement).bind("drag",draging);
					//tblElement.attachEvent("ondrag",draging);
					//jQuery(tblElement).bind("dragend",dragEnd);
					//tblElement.attachEvent("ondragend",dragEnd);
			   }
			   var tipinfo = document.getElementById("tipinfo");
			   tipinfo.style.display = "none";
               break;
		}
	}
	xmlHttp.setRequestHeader("Content-Type","text/xml")
	xmlHttp.send(null);
}
function deleteSysFavourite(sysfavouriteid,favouriteid,favourite_tabid)
{
	if(!confirm("您确认删除吗？")) return;
	var divContent=document.getElementById("_divEcontent_"+favourite_tabid);
	var msg=SystemEnv.getHtmlNoteName(3494,this.languageid);
    divContent.innerHTML="<img src=/images/loading2_wev8.gif> "+msg;
	Ext.Ajax.request({
           url: '/favourite/FavouriteTabOperation.jsp',
           method: 'POST',
           params: 
           {
	           	action: "deletesysfa",
	           	sysfavouriteid: sysfavouriteid,
	           	favouriteid:favouriteid,
	           	favourite_tabid:favourite_tabid
           },
           success: function(response, request)
	   	   {
	   	   	    onRefresh(favouriteid,favourite_tabid,response);
	   	   },
           failure: function ( result, request) 
           { 
	   		alert(favourite.maingrid.deletefailure); 
		   },
           scope: this
       });
}
function addSysFavourites(favouriteid,favouritetabid,type)
{	
	var url ="";
	if(type=="1")
	{
		url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp";
	    document.cookie="favouritetypes=1"; 
	}
	else if(type=="2")
	{
		url = "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp";
	    document.cookie="favouritetypes=2";
	}
	else if(type=="3")
	{
		var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp";
	    document.cookie="favouritetypes=3";
	}
	else if(type=="4")
	{
		url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp";
	    document.cookie="favouritetypes=4";
	}
	document.getElementById("_divSysFavouriteAdd_"+favouritetabid).style.display='none';
	parent.onShowBrowser(url);
	var resourceids = parent.document.getElementById("resourceids").value;
	
	var resourcenames = parent.document.getElementById("resourcenames").value;
	var favouritetype = parent.$GetEle("favouritetypes").value;
	var jsonvalues = parent.document.getElementById("jsonvalues").value;

	if(""!=resourceids)
	{
		var importlevel = "1";
		try
		{
			Ext.Ajax.request({
	      		url: '/favourite/FavouriteTabOperation.jsp',
	      		method: 'POST',
	      		params: 
	      		{
	      		 	action: "addsysfa",
	      		 	favouriteid: favouriteid,
	      		 	favourite_tabid: favouritetabid,
	      		 	jsonvalues:jsonvalues,
	      		 	importlevel: importlevel,
	      		 	type:favouritetype
	      		},
	      		success: function(response, request)
				{
					var responseArray = Ext.decode(response.responseText);
				 	for(var i=0;i<responseArray.databody.length;i++)
				 	{
						//var result =response.responseText.replace(/(^\s*)|(\s*$)/g, "");
						transformJsonToHtml(responseArray.databody[i],favouriteid,favouritetabid);
					}
					
				},
	      		failure: function (response, request) 
	      		{ 
					alert(favourite.other.addfailure); 
				},
	      		scope: this
	  		  });
	  }
	  catch(ee)
	  {
		  alert("description : "+ee.description)
	  }
	  parent.document.getElementById("resourceids").value = "";
	  parent.document.getElementById("resourcenames").value = "";
	  parent.$GetEle("favouritetypes").value = "";
	  parent.document.getElementById("jsonvalues").value = "";
   	}
}
function unAddSysFavourites(favouriteid,favouritetabid)
{
	document.getElementById("_divSysFavouriteAdd_"+favouritetabid).style.display='none';
}
var win;
function showEditWindow(favouriteid)
{
	var titleid = "sysFavouriteHiddenTitle_"+favouriteid;
	
	var importlevelid = "sysFavouriteImportname_"+favouriteid;
	var typeid = "sysFavouriteType_"+favouriteid;
	var title = document.getElementById(titleid).value;
	var importlevel = document.getElementById(importlevelid).innerHTML;
	var type = document.getElementById(typeid).innerHTML;
	importlevel = formatImportlevel(importlevel);
    var ItemData = Ext.data.Record.create([ 
		{name: 'id'}, 
		{name: 'title'}, 
		{name: 'importlevel'},
		{name: 'favouritetype'}
	]);
	var itemData = new ItemData({ 
		id: favouriteid, 
		title: title, 
		importlevel: importlevel,
		favouritetype: type
    }); 
   var data = itemData.data;
   win = new FavouriteEditWindow(data,2,favourite.maingrid.editfavourite);
   win.on('validsysfavourite', this.editSysFavourite, this);
   win.show();
}
function editSysFavourite(data)
{
	if(win)
   	{
   		win.close();
   	}
	var titleid = "sysFavouriteTitle_"+data.id;
	var rtitleid = "sysFavouriteHiddenTitle_"+data.id;
	
	var importlevelid = "sysFavouriteImportname_"+data.id;
	var typeid = "sysFavouriteType_"+data.id;
	var title = document.getElementById(titleid);
	var rtitle = document.getElementById(rtitleid);
	var importlevel = document.getElementById(importlevelid);
	var importlevelname = formatImportlevel(data.importlevel);
	var type = document.getElementById(typeid);
	var re;
	var temptitle = data.title;
    re = /\&nbsp/g;
   	temptitle = temptitle.replace(re, "＆nbsp");
   	re = /\</g;
	temptitle = temptitle.replace(re, "&lt;");    
	re = /\>/g;
	temptitle = temptitle.replace(re, "&gt;");  
	re = /\"/g;
	temptitle = temptitle.replace(re, "&quot;");  
	title.innerHTML = temptitle;
	re = /\&nbsp/g;
	rtitle.value=data.title.replace(re, "＆nbsp");
	importlevel.innerHTML = importlevelname;
	type.innerHTML = data.favouritetype;
}
function formatImportlevel(importlevel) 
{
	if(importlevel=="1")
	{
		return favourite.window.simple;
	}
	else if(importlevel=="2")
	{
		return favourite.window.middle;
	}
	else if(importlevel=="3")
	{
		return favourite.window.imports;
	}
	else if(importlevel==favourite.window.simple)
	{
		return "1";
	}
	else if(importlevel==favourite.window.middle)
	{
		return "2";
	}
	else if(importlevel==favourite.window.imports)
	{
		return "3";
	}
}
function savePosition()
{
	var jsondata= "{databody:[";
	var elementTables=document.getElementsByTagName("table");
	var isneedsave = false;
	for(var j=0;j<elementTables.length;j++)
	{		
		if(elementTables[j].className!="ElementTable") 
			continue;	
		else
		{
			var areaid = elementTables[j].parentNode.id;
			var favouritetabid = elementTables[j].eid;
			var position = "";
			if(areaid=="area_A")
			{
				position = "1";
			}
			else
			{
				position = "2";
			}
			isneedsave = true;
			jsondata +="{favourite_tabid:"+favouritetabid+",position:"+position+"},";
		}
	}
	jsondata +="{favourite_tabid:'',position:''}]}"
	if(isneedsave)
	{
		Ext.Ajax.request({
	      		url: '/favourite/FavouriteTabOperation.jsp',
	      		method: 'POST',
	      		params: 
	      		{
	      		 	action: "saveposition",
	      		 	jsonvalues: jsondata
	      		},
	      		success: function(response, request)
				{
					
				},
	      		failure: function (response, request) 
	      		{ 
				},
	      		scope: this
	  		  });
  	}
}
function transformJsonToHtml(data,favouriteid,favouritetabid)
{
	var datatableid = "favouritetabdatatable_"+favouriteid;
	var datatable = document.getElementById(datatableid);
	var newtr = datatable.insertRow(-1);
	newtr.setAttribute("id","sysFavouriteTr_"+data.id);
	newtr.setAttribute("height","18");
	var headtd = newtr.insertCell(-1);
	headtd.width=8;
	
	headtd.innerHTML = "<IMG src='/images/homepage/style/style1/esymbol_wev8.gif' name=esymbol><div id='sysFavouriteTypeDiv_"+data.id+"' style='display:none;'>"+
								"<span id='sysFavouriteType_"+data.id+"'>"+data.type+"</span>"+
							"</div>";
    
    var titletd = newtr.insertCell(-1);
    titletd.setAttribute("width","*");
    var re;
   	re = /\&nbsp/g;
  	var temptitle = data.title.replace(re, "＆nbsp");
	titletd.innerHTML = "<input type='hidden' id='sysFavouriteHiddenTitle_"+data.id+"' value='"+temptitle+"'><A href=javascript:openFullWindowForXtable('"+data.desc+"');><span id='sysFavouriteTitle_"+data.id+"'>"+temptitle+"</span></A>";
       
    var importtd = newtr.insertCell(-1);
    importtd.setAttribute("width","76");
    var importlevel = data.order;
    var importname = formatImportlevel(importlevel);
    importtd.innerHTML = " <div id='sysFavouriteImportnameDiv_"+data.id+"'><span id='sysFavouriteImportname_"+data.id+"'>"+importname+"</span></div>"
    
    var operatortd = newtr.insertCell(-1);
    operatortd.setAttribute("width","70");
	operatortd.innerHTML = "<A onclick='javascript:showEditWindow("+data.id+");' href='javascript:void(0);'>"+favourite.favouritepanel.edit+"</A>&nbsp;&nbsp;&nbsp;&nbsp;<A onclick='javascript:deleteSysFavourite("+data.id+","+favouriteid+","+favouritetabid+");' href='javascript:void(0);'>"+favourite.favouritepanel.deletes+"</A>";
    
    
    var linetr = datatable.insertRow(-1);
    linetr.setAttribute("height","1");
    linetr.style.background = "url(/images/homepage/style/style1/esparatorimg_wev8.gif)";
    var linetd = linetr.insertCell(-1);
    linetd.colSpan="5";
}
function showDivEcontent(tabfavouriteid)
{
	var tabfavouriteid = "_divEcontent_"+tabfavouriteid;
	var tabfavourite = document.getElementById(tabfavouriteid);
	if(tabfavourite)
	{
	if(tabfavourite.style.display=='none') 
		tabfavourite.style.display=''; 
	else 
		tabfavourite.style.display='none';
	}
}
function setTipInfo()
{
	var elementTables=document.getElementsByTagName("table");
	var isneedTipInfo = true;
	for(var j=0;j<elementTables.length;j++)
	{		
		if(elementTables[j].className=="ElementTable") 
		{
			isneedTipInfo = false;
			return;
		}	
	}
	if(isneedTipInfo)
	{
		var tipinfo = document.getElementById("tipinfo");
		tipinfo.style.display = "block";
	}
}
</SCRIPT>
	</HEAD>
	<BODY onload="init();setTipInfo();" onunload="savePosition();">
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<div style="overflow:auto;height:100%;">
			<span id="tipinfo" style="display:none;"><B><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%>：</B><script language=javascript>document.write(favourite.tabspanel.tabdesc);</script></span>
			<TABLE id=parentTable cellSpacing=10 cellPadding=0 width="100%"
				border=0>
				<TBODY>
					<TR>
						<TD id=area_A vAlign=top width="50%" areaflag="A">
								<TABLE id=tblInfo
									style="BORDER-RIGHT: #bdbebd 1px solid; BORDER-TOP: #bdbebd 1px solid; DISPLAY: none; FONT-SIZE: 12px; MARGIN-BOTTOM: 10px; BORDER-LEFT: #bdbebd 1px solid; BORDER-BOTTOM: #bdbebd 1px solid"
									width="100%">
									<TBODY>
										<TR>
											<TD id=tdInfo></TD>
										</TR>
									</TBODY>
								</TABLE>
								<%									
									String leftsql = "";
									if (!"".equals(favouritetabid) && null != favouritetabid)
									{
										leftsql = "select a.id,a.favouriteid,a.favouritealias,a.favouritepagesize,a.favouritetitlesize,a.showfavouritetitle,a.showfavouritelevel,a.position "+
											  "	from favourite_tab a,favouritetab b "
												+ "where a.tabid=b.id "
												+ "  and a.position=1"
												+ "  and b.id="+ favouritetabid;
									}
									rs.execute(leftsql);
									while (rs.next())
									{
										String tabfavouriteid = rs.getString(1);
										String favouriteid = rs.getString(2);
										String favouriteAlias = rs.getString(3);
										int favouritepagesize = rs.getInt(4);
										int favouritetitlesize = rs.getInt(5);
										int showfavouritetitle = rs.getInt(6);
										int showfavouritelevel = rs.getInt(7);
								%>
								<TABLE class=ElementTable id=_elementTable_<%=tabfavouriteid%>
									cellSpacing=0 cellPadding=0 width="100%" name="tblE"
									ebaseid="6" eid="<%=tabfavouriteid%>">
									<div id="favouriteid_<%=favouriteid %>" style="display:none;">
									</div> 
									<TBODY>
										<TR
											style="BACKGROUND: url(/images/homepage/style/style1/headBg_wev8.gif)">
											<TD vAlign=center align=left>
												&nbsp;
												<IMG title=<%=SystemEnv.getHtmlLabelName(19652, user.getLanguage()) %> style="CURSOR: hand"
													onclick="showDivEcontent('<%=tabfavouriteid%>');"
													height=16 src="/images/homepage/element/2_wev8.gif" width=16
													align=absMiddle border=0>
												&nbsp;
												<FONT id=_etitlecolor color=#000000><B><SPAN
														id=spanEtitle<%=tabfavouriteid%>><%=favouriteAlias%></SPAN>
												</B> </FONT>
											</TD>
											<TD align=right>
												&nbsp;&nbsp;
												<IMG
													onmouseover="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=70)'"
													title=<%=SystemEnv.getHtmlLabelName(611, user.getLanguage()) %>
													style="FILTER: progid :DXImageTransform.Microsoft.Alpha(opacity =30); CURSOR: hand"
													onclick="onSysFavouritesAdd('_divSysFavouriteAdd_<%=tabfavouriteid%>')"
													onmouseout="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=30)'"
													src="/images/btnDocExpand_wev8.gif">
												&nbsp;
												<IMG
													onmouseover="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=70)'"
													title=<%=SystemEnv.getHtmlLabelName(22250, user.getLanguage()) %>
													style="FILTER: progid :DXImageTransform.Microsoft.Alpha(opacity =30); CURSOR: hand"
													onclick="onESetting(_divESetting_<%=tabfavouriteid%>)"
													onmouseout="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=30)'"
													src="/images/homepage/style/style1/setting1_wev8.gif">
												&nbsp;
												<IMG
													onmouseover="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=70)'"
													title=<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %>
													style="FILTER: progid :DXImageTransform.Microsoft.Alpha(opacity =30); CURSOR: hand"
													onclick=onDel(<%=tabfavouriteid%>)
												onmouseout="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=30)'"
													src="/images/homepage/style/style1/close1_wev8.gif">
												&nbsp;
												<A onclick="javascript:openFavouriteTab('<%=favouriteid%>','<%=favouriteAlias %>');"
													href="javascript:void(0);"><IMG
														onmouseover="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=70)'"
														title=<%=SystemEnv.getHtmlLabelName(17499, user.getLanguage()) %>
														style="FILTER:progid:DXImageTransform.Microsoft.Alpha(opacity =30); CURSOR:hand"
														onmouseout="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=30)'"
														src="/images/homepage/style/style1/more1_wev8.gif" border=0>
												</A>&nbsp;
											</TD>
										</TR>
										<TR>
											<TD colSpan=2>
												<DIV id='_divESetting_<%=tabfavouriteid%>'
													style="display: none">
													<TABLE class=viewForm bgColor=#ffffff valign="top">
														<TBODY>
															<TR vAlign=top>
																<TD width="20%">
																	&nbsp;<%=SystemEnv.getHtmlLabelName(19491, user.getLanguage()) %>
																</TD>
																<!--元素标题-->
																<TD class=field width="80%">
																	<INPUT class=inputStyle id=_eTitel_<%=tabfavouriteid%>
																		style="WIDTH: 98%" value=<%=favouriteAlias%>>
																</TD>
															</TR>
															<TR vAlign=top style="height: 1px">
																<TD class=line colSpan=2></TD>
															</TR>
															<TR vAlign=top>
																<TD>
																	&nbsp;<%=SystemEnv.getHtmlLabelName(19493, user.getLanguage()) %>
																</TD>
																<!--显示条数-->
																<TD class=field>
																	<INPUT class=inputStyle id=_ePerpage_<%=tabfavouriteid%> style="WIDTH: 98%" value=<%=favouritepagesize %>>
																</TD>
															</TR>
															<TR vAlign=top style="height: 1px">
																<TD class=line colSpan=2></TD>
															</TR>
															<TR vAlign=top>
																<TD>
																	&nbsp;<%=SystemEnv.getHtmlLabelName(19495, user.getLanguage()) %>
																</TD>
																<!--显示字段-->
																<TD class=field>
																	<INPUT type=checkbox <%if(showfavouritetitle==1){ %>CHECKED<%} %> value=4 name=_chkTitleField_<%=tabfavouriteid%>>
																	<%=SystemEnv.getHtmlLabelName(229, user.getLanguage()) %> &nbsp;<%=SystemEnv.getHtmlLabelName(19524, user.getLanguage()) %>:
																	<INPUT class=inputstyle title=<%=SystemEnv.getHtmlLabelName(19524, user.getLanguage()) %> style="WIDTH: 24px"
																		value=<%=favouritetitlesize %> name=_wordcount_<%=tabfavouriteid%>
																		basefield="4">
																	&nbsp;
																	<BR>
																	<INPUT type=checkbox <%if(showfavouritelevel!=0){ %>CHECKED<%} %> value=4 name=_chkImportLevelField_<%=tabfavouriteid%>>
																	<%=SystemEnv.getHtmlLabelName(18178, user.getLanguage()) %>
																</TD>
															</TR>
															<TR vAlign=top style="height: 1px">
																<TD class=line colSpan=2></TD>
															</TR>
															<TR vAlign=top>
																<TD></TD>
																<TD>
																	<A
																		href="javascript:onUseSetting('<%=tabfavouriteid%>','<%=favouriteid%>')"><%=SystemEnv.getHtmlLabelName(19565, user.getLanguage()) %></A>
																	&nbsp;&nbsp;&nbsp;
																	<A
																		href="javascript:onNoUseSetting('<%=tabfavouriteid%>')"><%=SystemEnv.getHtmlLabelName(19566, user.getLanguage()) %></A>
																</TD>
															</TR>
															<TR vAlign=top style="height: 1px">
																<TD class=line colSpan=2></TD>
															</TR>
														</TBODY>
													</TABLE>
												</DIV>
												<DIV id='_divSysFavouriteAdd_<%=tabfavouriteid%>'
													style="display: none">
													<TABLE class=viewForm bgColor=#ffffff valign="top">
														<TBODY>
															<TR vAlign=top>
																<TD>
																	&nbsp;<%=SystemEnv.getHtmlLabelName(22255, user.getLanguage()) %>：
																</TD>
																<TD class=field width="80%">
																	<A onclick="javascript:addSysFavourites('<%=favouriteid%>','<%=tabfavouriteid%>',1)"
																		href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(22243,user.getLanguage()) %></A>
																	&nbsp;&nbsp;
																	<A onclick="javascript:addSysFavourites('<%=favouriteid%>','<%=tabfavouriteid%>',2)"
																		href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(22244, user.getLanguage()) %></A>
																		&nbsp;&nbsp;
																	<A onclick="javascript:addSysFavourites('<%=favouriteid%>','<%=tabfavouriteid%>',3)"
																		href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(22245, user.getLanguage()) %></A>
																		&nbsp;&nbsp;
																	<A onclick="javascript:addSysFavourites('<%=favouriteid%>','<%=tabfavouriteid%>',4)"
																		href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(21313,user.getLanguage()) %></A>
																</TD>
															</TR>
															<TR vAlign=top style="height: 1px">
																<TD class=line colSpan=2></TD>
															</TR>
														</TBODY>
													</TABLE>
												</DIV>
												<DIV id='_divEcontent_<%=tabfavouriteid%>'
													style="OVERFLOW: auto; WIDTH: 100%">
													<TABLE class=Econtent id='favouritemaintable'
														style="COLOR: #000000" width="100%">
														<TBODY>
															<TR>
																<TD width=1></TD>
																<TD width=*>
																	<%
																		String favouritesql = "select top "+favouritepagesize+" a.id,a.pagename,a.url,a.importlevel,a.favouritetype from sysfavourite a,sysfavourite_favourite b "
																					+ " where a.id=b.sysfavouriteid "
																					+ " and b.favouriteid=" + favouriteid
																					+ " and a.importlevel>="+showfavouritelevel
																					+ " and b.resourceid="+user.getUID()+" order by a.importlevel desc,a.adddate desc";
																		String dbtype = rs.getDBType();
																		if(dbtype.equals("oracle"))
																		{
																			favouritesql = "select a.id,a.pagename,a.url,a.importlevel,a.favouritetype from sysfavourite a,sysfavourite_favourite b "
																			+ " where a.id=b.sysfavouriteid "
																			+ " and b.favouriteid=" + favouriteid
																			+ " and a.importlevel>="+showfavouritelevel+" and rownum<="+favouritepagesize+ " and b.resourceid="+user.getUID()+" order by a.importlevel desc,a.adddate desc";
																		}
																		frs.execute(favouritesql);
																	%>
																	<TABLE width="100%" id="favouritetabdatatable_<%=favouriteid %>">
																			<%
																				while (frs.next())
																					{
																						String id = frs.getString(1);
																						String title = frs.getString(2);
																						String rtitle = frs.getString(2);
																						String link = frs.getString(3);
																						int importlevel = frs.getInt(4);
																						int type = frs.getInt(5);
																						String importname = "";
																						if (1 == importlevel)
																						{
																							importname = SystemEnv.getHtmlLabelName(154, user.getLanguage());
																						}
																						else if (2 == importlevel)
																						{
																							importname = SystemEnv.getHtmlLabelName(22241, user.getLanguage());
																						}
																						else
																						{
																							importname = SystemEnv.getHtmlLabelName(15533, user.getLanguage());
																						}
																						if(favouritetitlesize==0)
																						{
																							favouritetitlesize = 25;
																						}
																						if(title.length()>favouritetitlesize)
																						{
																							title = title.substring(0, favouritetitlesize);
																							title+="...";
																						}
																						rtitle = rtitle.replaceAll("&nbsp", "＆nbsp");
																						rtitle = Util.toHtml5(rtitle);
																						title = title.replaceAll("&nbsp", "＆nbsp");
																						title = Util.toHtml5(title);
																			%>
																			<TR height=18 id="sysFavouriteTr_<%=id %>">
																				<TD width=8>
																					<IMG
																						src="/images/homepage/style/style1/esymbol_wev8.gif"
																						name=esymbol>
																					<div id="sysFavouriteTypeDiv_<%=id %>" style="display:none;">
																						<span id="sysFavouriteType_<%=id %>"><%=type%></span>
																					</div>
																				</TD>
																				<TD width=* title="<%=title%>">
																					<input type="hidden" id="sysFavouriteHiddenTitle_<%=id %>" value="<%=rtitle%>">
																					<A
																						href="javascript:openFullWindowForXtable('<%=link%>')">
																						<span id="sysFavouriteTitle_<%=id %>"><%=title%></span>
																					</A>
																				</TD>
																				<%if(showfavouritelevel!=0){ %>
																				<TD width=76>
																					<div id="sysFavouriteImportnameDiv_<%=id %>">
																						<span id="sysFavouriteImportname_<%=id %>"><%=importname%></span>
																					</div>
																				</TD>
																				<%} %>
																				<TD width=70>
																					<A onclick="javascript:showEditWindow('<%=id %>');"
																						href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(93, user.getLanguage()) %></A>
																					&nbsp;
																					<A onclick="javascript:deleteSysFavourite('<%=id %>','<%=favouriteid %>','<%=tabfavouriteid%>');"
																						href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %></A>
																				</TD>
																			</TR>
																			<TR
																				style="BACKGROUND: url(/images/homepage/style/style1/esparatorimg_wev8.gif)"
																				height=1>
																				<TD colSpan=5></TD>
																			</TR>
																			<%
																				}
																			%>
																	</TABLE>
																</TD>
															</TR>
														</TBODY>
													</TABLE>
												</DIV>
											</TD>
										</TR>
									</TBODY>
								</TABLE>
								<%
									}
								%>
						</TD>
						<TD id=area_B vAlign=top width="50%" areaflag="B">
								<TABLE id=tblInfo
									style="BORDER-RIGHT: #bdbebd 1px solid; BORDER-TOP: #bdbebd 1px solid; DISPLAY: none; FONT-SIZE: 12px; MARGIN-BOTTOM: 10px; BORDER-LEFT: #bdbebd 1px solid; BORDER-BOTTOM: #bdbebd 1px solid"
									width="100%">
									<TBODY>
										<TR>
											<TD id=tdInfo></TD>
										</TR>
									</TBODY>
								</TABLE>
								<%									
									String rightsql = "";
									if (!"".equals(favouritetabid) && null != favouritetabid)
									{
										rightsql = "select a.id,a.favouriteid,a.favouritealias,a.favouritepagesize,a.favouritetitlesize,a.showfavouritetitle,a.showfavouritelevel,a.position "+
											  "	from favourite_tab a,favouritetab b "
												+ "where a.tabid=b.id "
												+ "  and a.position=2"
												+ "  and b.id="+ favouritetabid;
									}
									rs.execute(rightsql);
									while (rs.next())
									{
										String tabfavouriteid = rs.getString(1);
										String favouriteid = rs.getString(2);
										String favouriteAlias = rs.getString(3);
										int favouritepagesize = rs.getInt(4);
										int favouritetitlesize = rs.getInt(5);
										int showfavouritetitle = rs.getInt(6);
										int showfavouritelevel = rs.getInt(7);
								%>
								<TABLE class=ElementTable id=_elementTable_<%=tabfavouriteid%>
									cellSpacing=0 cellPadding=0 width="100%" name="tblE"
									ebaseid="6" eid="<%=tabfavouriteid%>">
									<div id="favouriteid_<%=favouriteid %>" style="display:none;">
									</div>
									<TBODY>
										<TR
											style="BACKGROUND: url(/images/homepage/style/style1/headBg_wev8.gif)">
											<TD vAlign=center align=left>
												&nbsp;
												<IMG title=<%=SystemEnv.getHtmlLabelName(19652, user.getLanguage()) %> style="CURSOR: hand"
													onclick="showDivEcontent('<%=tabfavouriteid%>');"
													height=16 src="/images/homepage/element/2_wev8.gif" width=16
													align=absMiddle border=0>
												&nbsp;
												<FONT id=_etitlecolor color=#000000><B><SPAN
														id=spanEtitle<%=tabfavouriteid%>><%=favouriteAlias%></SPAN>
												</B> </FONT>
											</TD>
											<TD align=right>
												&nbsp;&nbsp;
												<IMG
													onmouseover="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=70)'"
													title=<%=SystemEnv.getHtmlLabelName(611, user.getLanguage()) %>
													style="FILTER: progid :DXImageTransform.Microsoft.Alpha(opacity =30); CURSOR: hand"
													onclick="onSysFavouritesAdd('_divSysFavouriteAdd_<%=tabfavouriteid%>')"
													onmouseout="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=30)'"
													src="/images/btnDocExpand_wev8.gif">
												&nbsp;
												<IMG
													onmouseover="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=70)'"
													title=<%=SystemEnv.getHtmlLabelName(22250, user.getLanguage()) %>
													style="FILTER: progid :DXImageTransform.Microsoft.Alpha(opacity =30); CURSOR: hand"
													onclick="onESetting(_divESetting_<%=tabfavouriteid%>)"
													onmouseout="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=30)'"
													src="/images/homepage/style/style1/setting1_wev8.gif">
												&nbsp;
												<IMG
													onmouseover="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=70)'"
													title=<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %>
													style="FILTER: progid :DXImageTransform.Microsoft.Alpha(opacity =30); CURSOR: hand"
													onclick=onDel(<%=tabfavouriteid%>)
												onmouseout="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=30)'"
													src="/images/homepage/style/style1/close1_wev8.gif">
												&nbsp;
												<A onclick="javascript:openFavouriteTab('<%=favouriteid%>','<%=favouriteAlias %>');"
													href="javascript:void(0);"><IMG
														onmouseover="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=70)'"
														title=<%=SystemEnv.getHtmlLabelName(17499, user.getLanguage()) %>
														style="FILTER:progid:DXImageTransform.Microsoft.Alpha(opacity =30); CURSOR:hand"
														onmouseout="this.style.filter='progid:DXImageTransform.Microsoft.Alpha(opacity=30)'"
														src="/images/homepage/style/style1/more1_wev8.gif" border=0>
												</A>&nbsp;
											</TD>
										</TR>
										<TR>
											<TD colSpan=2>
												<DIV id='_divESetting_<%=tabfavouriteid%>'
													style="display: none">
													<TABLE class=viewForm bgColor=#ffffff valign="top">
														<TBODY>
															<TR vAlign=top>
																<TD width="20%">
																	&nbsp;<%=SystemEnv.getHtmlLabelName(19491, user.getLanguage()) %>
																</TD>
																<!--元素标题-->
																<TD class=field width="80%">
																	<INPUT class=inputStyle id=_eTitel_<%=tabfavouriteid%>
																		style="WIDTH: 98%" value=<%=favouriteAlias%>>
																</TD>
															</TR>
															<TR vAlign=top style="height: 1px">
																<TD class=line colSpan=2></TD>
															</TR>
															<TR vAlign=top>
																<TD>
																	&nbsp;<%=SystemEnv.getHtmlLabelName(19493, user.getLanguage()) %>
																</TD>
																<!--显示条数-->
																<TD class=field>
																	<INPUT class=inputStyle id=_ePerpage_<%=tabfavouriteid%> style="WIDTH: 98%" value=<%=favouritepagesize %>>
																</TD>
															</TR>
															<TR vAlign=top style="height: 1px">
																<TD class=line colSpan=2></TD>
															</TR>
															<TR vAlign=top>
																<TD>
																	&nbsp;<%=SystemEnv.getHtmlLabelName(19495, user.getLanguage()) %>
																</TD>
																<!--显示字段-->
																<TD class=field>
																	<INPUT type=checkbox <%if(showfavouritetitle==1){ %>CHECKED<%} %> value=4 name=_chkTitleField_<%=tabfavouriteid%>>
																	<%=SystemEnv.getHtmlLabelName(229, user.getLanguage()) %> &nbsp;<%=SystemEnv.getHtmlLabelName(19524, user.getLanguage()) %>:
																	<INPUT class=inputstyle title=<%=SystemEnv.getHtmlLabelName(19524, user.getLanguage()) %> style="WIDTH: 24px"
																		value=<%=favouritetitlesize %> name=_wordcount_<%=tabfavouriteid%>
																		basefield="4">
																	&nbsp;
																	<BR>
																	<INPUT type=checkbox <%if(showfavouritelevel!=0){ %>CHECKED<%} %> value=4 name=_chkImportLevelField_<%=tabfavouriteid%>>
																	<%=SystemEnv.getHtmlLabelName(18178, user.getLanguage()) %>
																</TD>
															</TR>
															<TR vAlign=top style="height: 1px">
																<TD class=line colSpan=2></TD>
															</TR>
															<TR vAlign=top>
																<TD></TD>
																<TD>
																	<A
																		href="javascript:onUseSetting('<%=tabfavouriteid%>','<%=favouriteid%>')"><%=SystemEnv.getHtmlLabelName(19565, user.getLanguage()) %></A>
																	&nbsp;&nbsp;&nbsp;
																	<A
																		href="javascript:onNoUseSetting('<%=tabfavouriteid%>')"><%=SystemEnv.getHtmlLabelName(19566, user.getLanguage()) %></A>
																</TD>
															</TR>
															<TR vAlign=top style="height: 1px"> 
																<TD class=line colSpan=2></TD>
															</TR>
														</TBODY>
													</TABLE>
												</DIV>
												<DIV id='_divSysFavouriteAdd_<%=tabfavouriteid%>'
													style="display: none">
													<TABLE class=viewForm bgColor=#ffffff valign="top">
														<TBODY>
															<TR vAlign=top>
																<TD>
																	&nbsp;<%=SystemEnv.getHtmlLabelName(22255, user.getLanguage()) %>：
																</TD>
																<TD class=field width="80%">
																	<A onclick="javascript:addSysFavourites('<%=favouriteid%>','<%=tabfavouriteid%>',1)"
																		href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(22243,user.getLanguage()) %></A>
																	&nbsp;&nbsp;
																	<A onclick="javascript:addSysFavourites('<%=favouriteid%>','<%=tabfavouriteid%>',2)"
																		href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(22244, user.getLanguage()) %></A>
																		&nbsp;&nbsp;
																	<A onclick="javascript:addSysFavourites('<%=favouriteid%>','<%=tabfavouriteid%>',3)"
																		href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(22245, user.getLanguage()) %></A>
																		&nbsp;&nbsp;
																	<A onclick="javascript:addSysFavourites('<%=favouriteid%>','<%=tabfavouriteid%>',4)"
																		href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(21313,user.getLanguage()) %></A>
																</TD>
															</TR>
															<TR vAlign=top style="height: 1px">
																<TD class=line colSpan=2></TD>
															</TR>
														</TBODY>
													</TABLE>
												</DIV>
												<DIV id='_divEcontent_<%=tabfavouriteid%>'
													style="OVERFLOW: auto; WIDTH: 100%">
													<TABLE class=Econtent id='favouritemaintable'
														style="COLOR: #000000" width="100%">
														<TBODY>
															<TR>
																<TD width=1></TD>
																<TD width=*>
																	<%
																		String favouritesql = "select top "+favouritepagesize+" a.id,a.pagename,a.url,a.importlevel,a.favouritetype from sysfavourite a,sysfavourite_favourite b "
																					+ " where a.id=b.sysfavouriteid "
																					+ " and b.favouriteid=" + favouriteid
																					+ " and a.importlevel>="+showfavouritelevel+ " and b.resourceid="+user.getUID()+" order by a.importlevel desc,a.adddate desc";
																		String dbtype = rs.getDBType();
																		if(dbtype.equals("oracle"))
																		{
																			favouritesql = "select a.id,a.pagename,a.url,a.importlevel,a.favouritetype from sysfavourite a,sysfavourite_favourite b "
																			+ " where a.id=b.sysfavouriteid "
																			+ " and b.favouriteid=" + favouriteid
																			+ " and a.importlevel>="+showfavouritelevel+" and rownum<="+favouritepagesize+ " and b.resourceid="+user.getUID()+" order by a.importlevel desc,a.adddate desc";
																		}
																		frs.execute(favouritesql);
																	%>
																	<TABLE width="100%" id="favouritetabdatatable_<%=favouriteid %>">
																			<%
																				while (frs.next())
																					{
																						String id = frs.getString(1);
																						String title = frs.getString(2);
																						String rtitle = frs.getString(2);
																						String link = frs.getString(3);
																						int importlevel = frs.getInt(4);
																						int type = frs.getInt(5);
																						String importname = "";
																						if (1 == importlevel)
																						{
																							importname = SystemEnv.getHtmlLabelName(154, user.getLanguage());
																						}
																						else if (2 == importlevel)
																						{
																							importname = SystemEnv.getHtmlLabelName(22241, user.getLanguage());
																						}
																						else
																						{
																							importname = SystemEnv.getHtmlLabelName(15533, user.getLanguage());
																						}
																						
																						if(favouritetitlesize==0)
																						{
																							favouritetitlesize = 25;
																						}
																						if(title.length()>favouritetitlesize)
																						{
																							title = title.substring(0, favouritetitlesize);
																							title+="...";
																						}
																						rtitle = rtitle.replaceAll("&nbsp", "＆nbsp");
																						rtitle = Util.toHtml5(rtitle);
																						title = title.replaceAll("&nbsp", "＆nbsp");
																						title = Util.toHtml5(title);
																			%>
																			<TR height=18 id="sysFavouriteTr_<%=id %>">
																				<TD width=8>
																					<IMG
																						src="/images/homepage/style/style1/esymbol_wev8.gif"
																						name=esymbol>
																					<div id="sysFavouriteTypeDiv_<%=id %>" style="display:none;">
																						<span id="sysFavouriteType_<%=id %>"><%=type%></span>
																					</div>
																				</TD>
																				<TD width=* title="<%=title%>">
																					<input type="hidden" id="sysFavouriteHiddenTitle_<%=id %>" value="<%=rtitle%>">
																					<A
																						href="javascript:openFullWindowForXtable('<%=link%>')">
																						<span id="sysFavouriteTitle_<%=id %>"><%=title%></span>
																					</A>
																				</TD>
																				<%if(showfavouritelevel!=0){ %>
																				<TD width=76>
																					<div id="sysFavouriteImportnameDiv_<%=id %>">
																						<span id="sysFavouriteImportname_<%=id %>"><%=importname%></span>
																					</div>
																				</TD>
																				<%} %>
																				<TD width=70>
																					<A onclick="javascript:showEditWindow('<%=id %>');"
																						href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(93, user.getLanguage()) %></A>
																					&nbsp;
																					<A onclick="javascript:deleteSysFavourite('<%=id %>','<%=favouriteid %>','<%=tabfavouriteid%>');"
																						href="javascript:void(0);"><%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %></A>
																				</TD>
																			</TR>
																			<TR
																				style="BACKGROUND: url(/images/homepage/style/style1/esparatorimg_wev8.gif)"
																				height=1>
																				<TD colSpan=5></TD>
																			</TR>
																			<%
																				}
																			%>
																	</TABLE>
																</TD>
															</TR>
														</TBODY>
													</TABLE>
												</DIV>
											</TD>
										</TR>
									</TBODY>
								</TABLE>
								<%
									}
								%>
						</TD>
					</TR>
				</TBODY>
			</TABLE>
			<INPUT id=txtlayoutAreas type=hidden value=A,B>
			<TABLE id=tblMove
				style="BORDER-RIGHT: #ff3300 1px dotted; BORDER-TOP: #ff3300 1px dotted; DISPLAY: none; BORDER-LEFT: #ff3300 1px dotted; BORDER-BOTTOM: #ff3300 1px dotted"
				height=20 width="100%">
				<TBODY>
					<TR>
						<TD>
							&nbsp;
						</TD>
					</TR>
				</TBODY>
			</TABLE>
			<DIV id=divCenter
				style="BORDER-RIGHT: #8888aa 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: #8888aa 1px solid; DISPLAY: none; PADDING-LEFT: 5px; Z-INDEX: 100; BACKGROUND: white; LEFT: 270px; PADDING-BOTTOM: 5px; BORDER-LEFT: #8888aa 1px solid; PADDING-TOP: 5px; BORDER-BOTTOM: #8888aa 1px solid; POSITION: absolute; TOP: 366px"></DIV>
		</div>
</BODY>
</html>