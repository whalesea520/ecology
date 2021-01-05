<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="sysFavouriteInfo" class="weaver.favourite.SysFavouriteInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
<link rel="stylesheet" type="text/css" href="css/favourite-viewer_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/xtheme-gray_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/weaver-ext_wev8.css" />
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
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28111,user.getLanguage())+SystemEnv.getHtmlLabelName(527,user.getLanguage());//"收藏夹列表"
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow-y:auto;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String favouriteid = Util.null2String(request.getParameter("favouriteid"));   //-1表示默认收藏夹【我的收藏】，-2表示没有【收藏目录】查询条件
String navName = "";
if(favouriteid.indexOf(",") <= 0 && !"-1".equals(favouriteid) && !"-2".equals(favouriteid))
{
	String sql = " select * from favourite where id="+favouriteid;
	//System.out.println("select sql : "+sql);
	rs.executeSql(sql);
	if(rs.next())
	{
		navName = rs.getString("favouritename");
	}
}
else if("-1".equals(favouriteid))
{
	navName = SystemEnv.getHtmlLabelName(18030 ,user.getLanguage());//"我的收藏";
}else if("-2".equals(favouriteid)){
	navName = SystemEnv.getHtmlLabelName(28111,user.getLanguage()) + SystemEnv.getHtmlLabelName(30947,user.getLanguage()); //收藏查询
}
String temppagename = Util.null2String(request.getParameter("pagename"));
String namesimple = Util.null2String(request.getParameter("namesimple"));

String importlevel = Util.null2String(request.getParameter("importlevel"));
String tempfavouritetype = Util.null2String(request.getParameter("tempfavouritetype"));
String favouritfolder = Util.null2String(request.getParameter("favouritfolder"));  //收藏目录
String sqlwhere = "";
String browserSpanValue = "";
if(!"".equals(temppagename))
	sqlwhere += " and a.pagename like '%"+temppagename+"%'";
String tableString="";
if(!"".equals(importlevel))
{	
	sqlwhere +=" and a.importlevel="+importlevel;
}
if(!"".equals(tempfavouritetype))
{	
	sqlwhere +=" and a.favouritetype="+tempfavouritetype;
}

if(!"-2".equals(favouriteid))
{
	sqlwhere += " and b.favouriteid in (" + favouriteid + ")";
	String [] values = favouriteid.split(",");
	for(int i = 0; i < values.length;i++){
		browserSpanValue += sysFavouriteInfo.getFavouriteName(values[i],String.valueOf(user.getLanguage())) + ",";
	}
	if(browserSpanValue.endsWith(",")){
		browserSpanValue = browserSpanValue.substring(0,browserSpanValue.length() - 1);
	}
}

String PageConstId = "FavouriteList_gxh";
String backfields=" a.*,b.favouriteid " ;
String perpage="10";
String fromSql=" sysfavourite a, sysfavourite_favourite b "; 
String sqlorderby = "a.importlevel,a.adddate";
String sqlWhere = " a.resourceid =" + user.getUID()
					+ " and a.id = b.sysfavouriteid " + sqlwhere;
//out.println("select "+backfields+" from "+fromSql+" where "+sqlWhere);
tableString =  " <table instanceid=\"ListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\" >";
tableString += " <checkboxpopedom popedompara=\"column:a.id\" showmethod=\"weaver.general.SplitPageTransmethod.getCheckBox\" />"+
		 " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" />"+
         "       <head>"+
		 "           <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\"  orderkey=\"a.favouritetype\" column=\"favouritetype\" transmethod=\"weaver.favourite.SysFavouriteInfo.getFavouriteType\" otherpara=\"" + user.getLanguage() + "\"/>"+
		 "           <col width=\"52%\"  text=\""+SystemEnv.getHtmlLabelName(22426,user.getLanguage())+"\" orderkey=\"a.pagename\" column=\"id\" transmethod=\"weaver.favourite.SysFavouriteInfo.getSysFavouriteUrl\" />"+
		 "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(28111,user.getLanguage())+ SystemEnv.getHtmlLabelName(33092,user.getLanguage()) + "\" orderkey=\"b.favouriteid\" column=\"favouriteid\" transmethod=\"weaver.favourite.SysFavouriteInfo.getFavouriteName\" otherpara=\"" + user.getLanguage() + "\"/>"+
		 "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(18178,user.getLanguage())+"\" orderkey=\"a.importlevel\" column=\"importlevel\" transmethod=\"weaver.favourite.SysFavouriteInfo.getImportLevel2\" />"+
         "       </head>"+
         "<operates width=\"20%\">"+
		 " <popedom transmethod=\"weaver.general.SplitPageTransmethod.getOpratePopedom\" otherpara=\"4\" ></popedom> "+
		 "     <operate href=\"javascript:editById()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" target=\"_fullwindow\" index=\"0\"/>"+
		 "     <operate href=\"javascript:copySysFavourite()\" text=\""+SystemEnv.getHtmlLabelName(77,user.getLanguage())+"\" target=\"_fullwindow\" index=\"1\"/>"+
		 "     <operate href=\"javascript:moveSysFavourite()\" text=\""+SystemEnv.getHtmlLabelName(78,user.getLanguage())+"\" target=\"_fullwindow\" index=\"2\"/>"+
		 "     <operate href=\"javascript:doDeleteById()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_fullwindow\" index=\"3\"/>"+       
		 "</operates>"+                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
         " </table>";
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:add2(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:copySysFavourites(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+",javascript:moveSysFavourites(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:delFavourite(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="/favourite/FavouriteList.jsp" method="post" name="frmmain" id="datalist" onsubmit="onsearchFavourite()">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" id="mutiladd" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" class="e8_btn_top" onclick="add()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage()) %>" class="e8_btn_top" onclick="copySysFavourites()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(78,user.getLanguage()) %>" class="e8_btn_top" onclick="moveSysFavourites()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" class="e8_btn_top" onclick="delFavourite()"/>
			
			<input type="text" class="searchInput" name="namesimple" value="<%=namesimple%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=SystemEnv.getHtmlLabelName(28111,user.getLanguage())+SystemEnv.getHtmlLabelName(527,user.getLanguage()) %></span><!-- 收藏夹列表 -->
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(22426,user.getLanguage()) %></wea:item>
			<wea:item><input  type="text" name="pagename" value='<%=temppagename%>'></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(28111,user.getLanguage())+ SystemEnv.getHtmlLabelName(33092,user.getLanguage())%></wea:item>
			<wea:item>
				<div name="folder_div"></div>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage()) %></wea:item>
			<wea:item>
				<select id='tempfavouritetype' name='tempfavouritetype' style='width:120px!important;'>
			  		<option></option>
			  		<option value='1' <%if("1".equals(tempfavouritetype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
			  		<option value='2' <%if("2".equals(tempfavouritetype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></option>
			  		<option value='3' <%if("3".equals(tempfavouritetype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>
			  		<option value='4' <%if("4".equals(tempfavouritetype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
			  		<option value='5' <%if("5".equals(tempfavouritetype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(375 ,user.getLanguage()) %></option><!-- 其他 -->
			  	</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18178,user.getLanguage()) %></wea:item>
			<wea:item>
				<select id='importlevel' name='importlevel' style='width:120px!important;'>
			  		<option></option>
			  		<option value='1' <%if("1".equals(importlevel)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></option>
			  		<option value='2' <%if("2".equals(importlevel)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(22241,user.getLanguage())%></option>
			  		<option value='3' <%if("3".equals(importlevel)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
			  	</select>
			</wea:item>
		</wea:group>
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="zd_btn_submit"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetAll();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<input name="sysfavouriteid" value="" type="hidden" />
<input type="hidden" id="action1" name="action1" value="">
<input type="hidden" id="favouriteid" name="favouriteid" value="<%=favouriteid %>">
<input type="hidden" name="resourceids" id="resourceids" value="">
<input type="hidden" name="resourcenames" id="resourcenames" value="">
<input type="hidden" name="jsonvalues" id="jsonvalues" value="">
<input type="hidden" name="favouritetypes" id="favouritetype" value="">
<TABLE width="100%">
    <tr>
        <td valign="top">  
        	<input type="hidden" name="pageId" id="pageId" value="<%=PageConstId %>"/>
           	<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>
<div id="Menu" class="x-menu x-menu-floating x-layer " style="position: absolute; z-index: 15000; visibility: visible;display:none;">
	<a class="x-menu-focus" href="#" onclick="return false;" tabindex="-1"></a>
	<ul class="x-menu-list" style="height: 106px;">
		<li id="x-menu-el-adddoc" class="x-menu-list-item "><a id="adddoc1" class="x-menu-item" href="#" onclick="return false;"><span class="x-menu-item-icon add-doc"></span><span class="x-menu-item-text" onclick='addSysFavourites(1);'><script language=javascript>document.write(favourite.mainpanel.adddoc);</script></span></a></li><!-- 添加文档类收藏 -->
		<li id="x-menu-el-addworkflow" class="x-menu-list-item "><a id="addworkflow1" class="x-menu-item" href="#" onclick="return false;"><span class="x-menu-item-icon add-workflow"></span><span class="x-menu-item-text" onclick='addSysFavourites(2);'><script language=javascript>document.write(favourite.mainpanel.addworkflow);</script></span></a></li><!-- 添加流程类收藏 -->
		<li id="x-menu-el-addpro" class="x-menu-list-item "><a id="addpro1" class="x-menu-item" href="#" onclick="return false;"><span class="x-menu-item-icon add-project"></span><span class="x-menu-item-text" onclick='addSysFavourites(3);'><script language=javascript>document.write(favourite.mainpanel.addproj);</script></span></a></li><!-- 添加项目类收藏 -->
		<li id="x-menu-el-addcus" class="x-menu-list-item "><a id="addcus1" class="x-menu-item" href="#" onclick="return false;"><span class="x-menu-item-icon add-custom"></span><span class="x-menu-item-text" onclick='addSysFavourites(4);'><script language=javascript>document.write(favourite.mainpanel.addcus);</script></span></a></li><!-- 添加客户类收藏-->
	</ul>
</div>
</form>
</BODY>
</HTML>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script>
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:doRefresh});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
		$(".searchInput").val('');
	});

	//初始化搜索条件中的【收藏目录】查询条件浏览按钮
	$("div[name='folder_div']").e8Browser({
		name : "favouritfolder",
		viewType : "0",
		browserValue : "<%=favouritfolder%>",
		getBrowserUrlFn : null,
		hasInput : true,
		isSingle : false,
		hasBrowser : true,
		isMustInput : "1",
		completeUrl : "/favourite/favouriteData.jsp",
		browserSpanValue : "<%=browserSpanValue%>",
		_callback : "updateTopTitle"
	});
	$("#favouritfolder_browserbtn").css("visibility","hidden");  //隐藏浏览按钮
});
jQuery(document).ready(function(){
	$(document).bind('click', HideMenu);
});

function HideMenu(e){
    if($(e.target)[0].id =="Menu")
        return;
    $("#Menu").hide();
}
function doRefresh()
{
	document.frmmain.action = "/favourite/FavouriteList.jsp";
	$("input[name='pagename']").val($("input[name='namesimple']").val());   //将简单搜索的值赋给高级搜索中的收藏标题
	$("#datalist").submit(); 
}
//更新toptitle
function updateTopTitle(e,data,nameAndId){  
	/*var _name = data.name;
	if(_name){
		parent.$("#objName").html(_name);  //修改标题
	}*/
}

//点击提交时的处理事件
function onsearchFavourite(){
	var favouritfolder = $("#favouritfolder").val();
	parent.$("#objName").html("<%=SystemEnv.getHtmlLabelName(28111,user.getLanguage()) + SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>");
	if(!favouritfolder){   //没有选择查询条件时，查询所有数据
		$("#favouriteid").val("-2");
	}else{
		$("#favouriteid").val(favouritfolder);  //将搜索条件的值赋给之前的隐藏域值，避免因本次添加的这个条件，影响之前的业务逻辑
	}
	//$("#datalist").submit();
}

function resetAll()
{
	/*frmmain.pagename.value = "";
	frmmain.importlevel.value = "";
	jQuery("#importlevel").selectbox("detach")
	jQuery("#importlevel").selectbox();
	frmmain.tempfavouritetype.value = "";
	jQuery("#tempfavouritetype").selectbox("detach")
	jQuery("#tempfavouritetype").selectbox();
	frmmain.namesimple.value = "";*/
	$("input[name='namesimple']").val("");
	resetCondtion();
}

function add(obj)
{
	var target = null;
	if(obj){   //右键菜单
		var target = $("#rightMenu");
	}else{  //工具栏按钮
		target = $("#mutiladd",parent.document);
	}
	//var X = $('#mutiladd',parent.document).offset().top;
	//var Y = $('#mutiladd',parent.document).offset().left;
	var X = target.offset().top;
	var Y = target.offset().left;
	if(!obj){   //按钮的话，top为0
		X = 0;
	}
	//alert("X : "+X+" Y : "+Y);
	$('#Menu').css("top",X);
	$('#Menu').css("left",Y);
	$('#Menu').toggle();
}
//右键菜单点击添加
function add2(){
	var target = $("#rightMenu");
	var X = target.position().top;
	var Y = target.position().left;
	//点击时，当前点击的右键菜单还未隐藏，如果已隐藏，说明不是当前点击的右键菜单，是在tab页的上方，即父窗口中打开的右键菜单
	if(target.length == 0 || target.css("display") == "none"){
		target = parent.$("#rightMenu");
		X = target.position().top - 60;   //此时右键菜单的top是相对于顶部的，而不是tab页的，因此要减去这个高度
		Y = target.position().left;
		if(X <= 0){  //top小于0，菜单还是在下方工具栏按钮处打开吧，暂时处理方式，其实更好的处理方式是将菜单clone，然后添加到tab页的父窗口来
			X = 0;  
			Y = $("#mutiladd",parent.document).offset().left;
		}
	}
	$('#Menu').css("top",X).css("left",Y).show();
}
function addSysFavourites(type)
{
	var url = "";
	var title = "";
	if(type=="1")
	{
		url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp&mouldID=doc";
		title = favourite.mainpanel.adddoc;   //添加文档类收藏
	}
	else if(type=="2")
    {
    	url = "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp";
    	title = favourite.mainpanel.addworkflow;   //添加流程类收藏
    }
    else if(type=="3")
    {
    	url = "/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp&mouldID=proj";
    	title = favourite.mainpanel.addproj;   //添加项目类收藏
    }
    else if(type=="4")
    {
    	url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp&mouldID=customer";
    	title = favourite.mainpanel.addcus;   //添加客户类收藏
    }
	onShowBrowser2(url,title,type);
	//alert("resourceids : "+resourceids);
	
}
function onShowBrowser(url,favouritetypes){
	data = window.showModalDialog(url)
	//alert("data : "+data);
	if (data){
		//alert("data : "+data.id);
		if (data.id!=""&&data.id!="0"){
			resourceids = data.id
			resourcename = data.name
			var sHtml = "{databody:["
			if(resourceids.indexOf(",")==0)
				resourceids = resourceids.substring(1);
			$GetEle("resourceids").value= resourceids;
			if(resourcename.indexOf(",")==0)
				resourcename = resourcename.substring(1);
			$GetEle("resourcenames").value= resourcename;
			$GetEle("favouritetypes").value= favouritetypes
			ids = resourceids.split(",");
			names=resourcename.split(",");
			for(var i=0;i<ids.length;i++){
				if(ids[i]!=0){
					sHtml = sHtml+"{linkid:"+ids[i]+",pagename:'"+names[i]+"'},";
				}
			}
			if(sHtml!=""){
				sHtml = sHtml.substring(0,sHtml.length-1);
			}
			sHtml = sHtml+"]}";
			$GetEle("jsonvalues").value= sHtml;
			
			if(""!=resourceids)
			{
				var resourceids = $GetEle("resourceids").value;
				var resourcenames = $GetEle("resourcenames").value;
				var favouritetype = $GetEle("favouritetypes").value;
				var jsonvalues = $GetEle("jsonvalues").value;
				var importlevel = "1";
				var favouriteid = $GetEle("favouriteid").value;
				var timestamp = (new Date()).valueOf();
		       	$GetEle("resourceids").value = "";
			  	$GetEle("resourcenames").value = "";
			  	$GetEle("favouritetype").value = "";
			  	$GetEle("jsonvalues").value = "";
			  	
			    var params = "action=add&favouriteid="+favouriteid+"&ts="+timestamp+"&jsonvalues="+jsonvalues+"&importlevel="+importlevel+"&favouritetype="+favouritetype;
			    //alert(params);
			    jQuery.ajax({
			        type: "POST",
			        url: "/favourite/SysFavouriteOperationAjax.jsp",
			        data: params,
			        contentType: "application/x-www-form-urlencoded; charset=utf-8",
			        success: function(msg){
			        	var result = jQuery.trim(msg);
			        	_table.reLoad();
			        	$('#Menu').hide();
			        }
			    });
			    
			  	
		   	}
		}
	}
}

//将原本的model对话框改为dialog
function onShowBrowser2(url,title,favouritetypes){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width = 500;
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.callbackfunParam = favouritetypes;
	dialog.callbackfun = afterAdd;
	dialog.show();
}

//关闭窗口时的回调方法，会返回选择的值
function afterAdd(favouritetypes,data){
	if (data){
		if (data.id!=""&&data.id!="0"){
			resourceids = data.id
			resourcename = data.name
			var sHtml = "{databody:["
			if(resourceids.indexOf(",")==0)
				resourceids = resourceids.substring(1);
			$GetEle("resourceids").value= resourceids;
			if(resourcename.indexOf(",")==0)
				resourcename = resourcename.substring(1);
			$GetEle("resourcenames").value= resourcename;
			$GetEle("favouritetypes").value= favouritetypes
			ids = resourceids.split(",");
			names=resourcename.split(",");
			for(var i=0;i<ids.length;i++){
				if(ids[i]!=0){
					sHtml = sHtml+"{linkid:"+ids[i]+",pagename:'"+names[i]+"'},";
				}
			}
			if(sHtml!=""){
				sHtml = sHtml.substring(0,sHtml.length-1);
			}
			sHtml = sHtml+"]}";
			$GetEle("jsonvalues").value= sHtml;
			
			if(""!=resourceids)
			{
				var resourceids = $GetEle("resourceids").value;
				var resourcenames = $GetEle("resourcenames").value;
				var favouritetype = $GetEle("favouritetypes").value;
				var jsonvalues = $GetEle("jsonvalues").value;
				var importlevel = "1";
				var favouriteid = $GetEle("favouriteid").value;
				var timestamp = (new Date()).valueOf();
		       	$GetEle("resourceids").value = "";
			  	$GetEle("resourcenames").value = "";
			  	$GetEle("favouritetype").value = "";
			  	$GetEle("jsonvalues").value = "";
			  	
			    var params = "action=add&favouriteid="+favouriteid+"&ts="+timestamp+"&jsonvalues="+jsonvalues+"&importlevel="+importlevel+"&favouritetype="+favouritetype;
			    //alert(params);
			    jQuery.ajax({
			        type: "POST",
			        url: "/favourite/SysFavouriteOperationAjax.jsp",
			        data: params,
			        contentType: "application/x-www-form-urlencoded; charset=utf-8",
			        success: function(msg){
			        	var result = jQuery.trim(msg);
			        	_table.reLoad();
			        	$('#Menu').hide();
			        }
			    });
		   	}
		}
	}
}

function copySysFavourite(id)
{
	if(id=="")
	{
		top.Dialog.alert(favourite.maingrid.noselect);//"请先选择需要复制的数据!"
		return ;
	}
	var sysfavouriteids = id;
	//var returnvalue = window.showModalDialog('/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&action=append&sysfavouriteids='+sysfavouriteids+"&mouldID=favourite");
	//if(returnvalue==1)
    //{
    //	top.Dialog.alert("复制成功!");
    //}
    var title = favourite.maingrid.copy+"<%=navName%>";
	var url = "/favourite/FavouriteBrowserTab.jsp?action=append&sysfavouriteids="+sysfavouriteids+"&mouldID=favourite";
	openDialog(url,title,500,600);
	return returnvalue;
}
function copySysFavouriteTemp(id)
{
	if(id=="")
	{
		top.Dialog.alert(favourite.maingrid.noselect);
		return ;
	}
	var sysfavouriteids = id;
	//var returnvalue = window.showModalDialog('/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&action=append&sysfavouriteids='+sysfavouriteids+"&mouldID=favourite");
	//return returnvalue;
	//var title = favourite.maingrid.move+"<%=navName%>";
	var title = favourite.maingrid.move+favourite.maingrid.othertitle;
	var url = "/favourite/FavouriteBrowserTab.jsp?action=appendanddel&sysfavouriteids="+sysfavouriteids+"&mouldID=favourite";
	openDialog(url,title,500,560);
}
function copySysFavourites()
{
	var ids = "";
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	if(ids=="")
	{
		top.Dialog.alert(favourite.maingrid.noselect);
		return ;
	}
	var sysfavouriteids = ids;
	//var title = favourite.maingrid.copy+"<%=navName%>";
	var title = favourite.maingrid.copy+favourite.maingrid.othertitle;
	var url = "/favourite/FavouriteBrowserTab.jsp?action=append&sysfavouriteids="+sysfavouriteids+"&mouldID=favourite"
	openDialog(url,title,500,560);
	//var returnvalue = window.showModalDialog('/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&action=append&sysfavouriteids='+sysfavouriteids+"&mouldID=favourite");
	//if(returnvalue==1)
    //{
    //	top.Dialog.alert(favourite.favouritepanel.copysuccess);//"复制成功!"
    //	if(window.parent && window.parent.parent && window.parent.parent.reloadTree){  //因为可能会新建目录，因此刷新左侧的树
    //		 window.parent.parent.reloadTree();
    //    }
    //}
}
function moveSysFavourite(id)
{
	if(id=="")
	{
		top.Dialog.alert(favourite.maingrid.noselect);
		return ;
	}
	copySysFavouriteTemp(id);
    /*if(returnvalue==1)
    {        
        document.frmmain.action = "/favourite/SysFavouriteOperation.jsp";
		document.frmmain.sysfavouriteid.value = id;
		document.frmmain.action1.value = "delete";
		document.frmmain.submit();
    }*/
}
function moveSysFavourites()
{
	var ids = "";
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	if(ids=="")
	{
		top.Dialog.alert(favourite.maingrid.noselect);
		return ;
	}
	copySysFavouriteTemp(ids);
    /*if(returnvalue==1)
    {
    	if(window.parent && window.parent.parent && window.parent.parent.reloadTree){  //因为可能会新建目录，因此刷新左侧的树
   		 	window.parent.parent.reloadTree();
       	}
       	
        document.frmmain.action = "/favourite/SysFavouriteOperation.jsp";
		document.frmmain.sysfavouriteid.value = ids;
		document.frmmain.action1.value = "delete";
		document.frmmain.submit();
    }*/
}
function editById(id)
{
	var url = "/favourite/SysFavouriteOperateTab.jsp?isdialog=1&id="+id;
	var title = favourite.maingrid.editfavourite;//"编辑收藏"
	openDialog(url,title,500,300);
}
function doDeleteById(id)
{
	if(id=="") return ;
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.frmmain.action = "/favourite/SysFavouriteOperation.jsp";
		document.frmmain.sysfavouriteid.value = id;
		document.frmmain.action1.value = "delete";
		document.frmmain.submit();
	}, function () {}, 320, 90);	
}
function reloadTable()
{
	_table.reLoad();
	/*if(window.parent && window.parent.parent && window.parent.parent.reloadTree){  //因为可能会新建目录，因此刷新左侧的树
    	window.parent.parent.reloadTree();
    }*/
}
//刷新左侧的树
function reloadTree(){
	if(window.parent && window.parent.parent && window.parent.parent.reloadTree){
    	window.parent.parent.reloadTree();
    }
}
function delFavourite()
{
	var ids = "";
	if(!ids){
		ids = _xtable_CheckedCheckboxId();
	}
	if(ids.match(/,$/)){
		ids = ids.substring(0,ids.length-1);
	}
	if(ids=="")
    {
       	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return ;
    }
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.frmmain.action = "/favourite/SysFavouriteOperation.jsp";
		document.frmmain.sysfavouriteid.value = ids;
		document.frmmain.action1.value = "delete";
		document.frmmain.submit();
	}, function () {}, 320, 90);			
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
//新建子目录
function openDialog(url,title,width,height){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = width;
	dialog.Height = height;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
