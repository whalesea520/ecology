<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.RecordSet"%>
<%
	int categoryid = Util.getIntValue(request.getParameter("categoryid"),0);
	String keyword = Util.null2String(request.getParameter("keyword")).trim();
	RecordSet rs = new RecordSet();
	Map<String,String> category = new HashMap<String,String>();
	if(categoryid > 0 && keyword.isEmpty()){
	    rs.executeSql("select id,parentid,categoryname from DocPrivateSecCategory where id=" + categoryid);
	    if(rs.next()){
	        category.put("sid",rs.getString("id"));
	        category.put("pid",rs.getString("parentid"));
	        category.put("sname",rs.getString("categoryname"));
	    }
	}
	
	String fileType = "0";
	String orderby = "id";
	
	String tableString = "<table tabletype=\"checkbox\" datasource=\"weaver.rdeploy.doc.PrivateSeccategoryManager.getPrivateData\" sourceparams=\"id:" + categoryid + "+orderby:" + orderby + "+txt:" + keyword + "\" pagesize=\"10\" pageBySelf=\"true\"> "+
	   "<sql backfields=\"*\" sqlform=\"tmpTable\" sqlorderby=\"type\" sqlsortway=\"desc\" sqlprimarykey=\"id\" />";
	tableString += "<head>";   
	tableString += "<col width=\"30px\" labelid=\"22969\"  text=\"\" column=\"name\" otherpara=\"column:type+" + fileType + "\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.getFileType\"/>";
    tableString += "<col width=\"45%\" labelid=\"17517\"  text=\"" + SystemEnv.getHtmlLabelName(17517,user.getLanguage()) + "\" column=\"name\" otherpara=\"column:type+" + fileType + "+column:id+column:isNew\" transmethod=\"weaver.docs.rdeploy.util.SplitPageForRdeploy.getFileName\"/>";
    tableString += "<col width=\"20%\" labelid=\"2036\"  text=\"" + SystemEnv.getHtmlLabelName(2036,user.getLanguage()) + "\" column=\"filesize\" />";
    tableString += "<col width=\"30%\" labelid=\"26805\"  text=\"" + SystemEnv.getHtmlLabelName(26805,user.getLanguage())  + "\" column=\"updatetime\"/>";
    tableString += "</head></table>";
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" type="text/css"
			href="/rdeploy/assets/css/wf/requestshow.css">		
<link rel="stylesheet" type="text/css"
			href="/rdeploy/assets/css/common.css">				
<script type="text/javascript">
	window.E8EXCEPTHEIGHT = 80;
	try{
		parent.setTabObjName("云盘文件");
	}catch(e){
	}
	var parentWin = null;
	var dialog = null;
	try{
		var topWi = window;
		var curWi = window;
		while(topWi != topWi.parent){
			curWi = topWi;
			topWi = topWi.parent;
		}
		parentWin = topWi.getParentWindow(curWi);
		dialog = topWi.getDialog(curWi);
	}catch(e){}
</script>
<script>

function onClose(){
	if(dialog){
		dialog.close();
	}else{
    	window.parent.close();
    }
}

function dataBack(data){
	if(dialog){
		try{
		dialog.callback(data);
		}catch(e){}
		try{
		dialog.close(data);
		}catch(e){}
	}else{
	    window.parent.returnValue = data;
	    window.parent.close();
	}
}

function onComfirm(){
	var ids = "";
	var names = "";
	var types = "";
	jQuery(".ListStyle tbody .jNiceCheckbox.jNiceChecked").each(function(){
		var $obj = jQuery(this).closest("tr").find("span.folder,span.file");
		ids += "," + $obj.attr("dataid");
		names += "," + $obj.html();
		if($obj.attr("class").indexOf("folder") > -1){
			types += ",folder";
		}else{
			types += ",pdoc";
		}
	});
	
	if(ids.length > 0){
		ids = ids.substring(1);
		names = names.substring(1);
		types = types.substring(1);
	}
	var data = {id:ids,name:names,sharetype:types};
	console.info(data);
	dataBack(data);
	
}

function onSearch(){
	document.SearchForm.submit();
}

jQuery(function(){
	jQuery(document).unbind("contextmenu").bind("contextmenu", function (e) { //禁用鼠标右键系统菜单
        return false;
    });
	jQuery("#navItem .nava").live({
		click : function(){
			if(this.id && this.id == "searchaNav") return;
			if(this.id){
				goPage(this.id);
			}else{
				goPage(0);
			}
		}
	});
	jQuery("span.folder").live({
		click : function(){
			var _id = this.getAttribute("dataid");
			goPage(_id);
		}
	});
	jQuery(".searchspan").click(function(){
		onSearch();
	});
	jQuery("#keyword").keypress(function(e){
		e = e || event;
		if(e.keyCode == 13){
			onSearch();
		}
	});
	fullPrivateDivNav({txt : "<%=keyword%>"});
});

function goPage(id){
	location.href = "/rdeploy/chatproject/doc/MultiPrivateBrowser.jsp?categoryid=" + id;
}

var privateNavMap = { 0 : undefined};
if(parent.window.privateNavMap){
	privateNavMap = parent.window.privateNavMap;
}

if("<%=categoryid%>" > 0){
	privateNavMap["<%=categoryid%>"] = {
		sid : "<%=category.get("sid")%>",
		pid : "<%=category.get("pid")%>",
		sname : "<%=category.get("sname")%>",
	}
	parent.window.privateNavMap = privateNavMap;
}

function fullPrivateDivNav(params) {
    $("#navItem").empty();
    var itemData;
    var widthItemDiv = 0;
    var sid = jQuery("#pid").val();
   		itemData = privateNavMap[sid];
    	while(sid != '0' && (!params || !params.txt || params.txt == ""))
    	{
    			if(typeof(itemData) != 'undefined')
                {
	               	if(itemData.pid == '0')
	               	{
	               		break;
	               	}
                }
                else
                {
                	break;
                }
                $divNav = $("<div />");
                $divNav.attr('id', itemData.sid + "divNav");
                $divNav.addClass("e8ParentNavContent");
                $a = $("<a />");
                $a.addClass("nava");
                $a.attr({
	                	'id' : itemData.sid,
	                	'title' : itemData.sname
                	});
                $a.append(itemData.sname);
                $divNav.append($a);
                $divParentNavLine = $("<div />");
                $divParentNavLine.attr('id', itemData.sid + "divNavLine");
                $divParentNavLine.addClass("e8ParentNavLine");
                $("#navItem").prepend($divNav).prepend($divParentNavLine);
                widthItemDiv += $("#"+itemData.sid + "divNav").outerWidth()+$("#"+itemData.sid + "divNavLine").outerWidth();
		    	itemData = privateNavMap[itemData.pid];
    	}
    
    	$divNav = $("<div />");
                $divNav.attr('id', "privateAlldivNav");
                $divNav.addClass("e8ParentNavContent");
                $a = $("<a />");
                $a.addClass("nava");
                var tabShowName = "<%=SystemEnv.getHtmlLabelName(129151,user.getLanguage())%>";
                $a.attr("title",tabShowName).append(tabShowName);
                $divNav.append($a);
                
                $divParentNavLine = $("<div />");
                $divParentNavLine.attr('id', "privateAlldivNavLine");
                $divParentNavLine.addClass("e8ParentNavLine");
                
                $("#navItem").prepend($divNav);
                widthItemDiv += $("#privateAlldivNav").outerWidth();
                widthItemDiv += $("#privateAlldivNavLine").outerWidth();
      
      if(params && params.txt && params.txt != ""){
	      var $searchNav = $("<div/>");
	            $searchNav.attr('id', "searchdivNav"); 
	            $searchNav.addClass("e8ParentNavContent");    
	            $a = $("<a />");
	            $a.addClass("nava");
	            var aname = "\"" + params.txt + "\" " + "<%=SystemEnv.getHtmlLabelName(81289,user.getLanguage())%>";
	            $a.attr({
		            	'id': "searchaNav",
		            	'title' : aname	
		            }); 
	            $a.append(aname);
	            $searchNav.append($a);
	            
	            $divParentNavLine = $("<div />");
                $divParentNavLine.attr('id', "searchdivNavLine");
                $divParentNavLine.addClass("e8ParentNavLine");
	            
	            $("#navItem").append($divParentNavLine).append($searchNav);
	            widthItemDiv += $("#privateAlldivNav").outerWidth();
	            widthItemDiv += $("#privateAlldivNavLine").outerWidth();
	    }
    
     if($("#navItem").outerWidth()-100 < widthItemDiv)
     {
           $(".e8ParentNavContent").each(function()
			{
			    if($("#navItem").outerWidth() -100 < widthItemDiv)
		       	{
		       		if($(this).css("display") == "block")
		       		{
		       			var wid = $(this).outerWidth();
	       				var widl = $(this).next().outerWidth();
		       			widthItemDiv = widthItemDiv - wid;
		       			widthItemDiv = widthItemDiv - widl;
		       			$(this).hide();
		       			$(this).next().hide();
		       		}
		       	}
			});      
                 
	}
}

function upFolder(){
	var _len = jQuery("#navItem").find(".e8ParentNavContent").length;
    if(_len > 1){
    	jQuery("#navItem").find(".e8ParentNavContent").eq(_len - 2).find(".nava").click();
    }else{
    	jQuery("#navItem").find(".e8ParentNavContent").find(".nava").click();
    }
}
</script>

<style>
	a {
	cursor: pointer;
}

.e8MenuNav .e8Home {
	background-repeat: no-repeat;
	background-position: 50% 5px;
	background-image: url(/images/ecology8/newdoc/home_wev8.png);
	height: 30px;
	width: 30px;
	cursor: pointer;
}

.e8MenuNav .e8Expand {
	background-repeat: no-repeat;
	background-position: 50% 9px;
	background-image: url(/images/ecology8/newdoc/expand_wev8.png);
	height: 100%;
	width: 30px;
	cursor: pointer;
	top: 0px;
	right: 0px;
	position: absolute;
	display: none;
}

.e8MenuNav .e8ParentNav {
	width: 93%;
	height: 100%;
	margin-left: 30px;
	margin-top: -30px;
}

.e8MenuNav .e8ParentNav .e8ParentNavLine {
	background-image: url(/images/ecology8/newdoc/line_wev8.png);
	background-repeat: no-repeat;
	background-position: 50% 50%;
	width: 20px;
	height: 30px;
	float: left;
}

.e8MenuNav .e8ParentNav .e8ParentNavContent {
	height: 30px;
	line-height: 30px;
	float: left;
	max-width: 100px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.nava {
	color: #8e9598;
}

.nava:hover {
	color: #474f60;
}

.closesearch {
	width: 18px;
	height: 18px;
	float: right;
	margin: 6px 20px 6px 10px;
	cursor: pointer;
	background-image: url("/rdeploy/assets/img/wf/searchclose.png");
	background-repeat: no-repeat;
	background-position: center;
}

.closesearch:hover {
	width: 18px;
	height: 18px;
	float: right;
	margin: 6px 20px 6px 10px;
	cursor: pointer;
	background-image: url("/rdeploy/assets/img/wf/searchclosehot.png");
	background-repeat: no-repeat;
	background-position: center;
}
	.upDiv {
	width: 30px;
	height: 30px;
	border: 1px solid #dadada;
	background-image: url("/rdeploy/assets/img/cproj/doc/up.png");
	background-repeat: no-repeat;
	background-position: center;
	float: left;
	cursor: pointer;
}

.upDiv:hover {
	width: 30px;
	height: 30px;
	border: 1px solid #dadada;
	background-image: url("/rdeploy/assets/img/cproj/doc/up_hot.png");
	background-repeat: no-repeat;
	background-position: center;
	float: left;
}

#outdepartmentiddiv {
	margin-right: -38px !important;
}

.e8MenuNav {
	width: 472px;
	height: 30px;
	color: #939d9e;
	vertical-align: middle;
	border: 1px solid #dadada;
	top: 0px;
	float: right;
}
.input-group{
	position:absolute;
	right:15px;
	top:5px;
	line-height:inherit;
	width:144px;
}
.input-group input.searchinput[type="text"]{
	border:0px;
	padding-top:0px;
	padding-bottom:0px;
}
.input-group input.private.searchinput[type="text"]{
	width:115px;
}
.input-group span.adspan{
	line-height:27px;
	height:29px;
}

.e8MenuNav{
	float:left;
	width:100%;
}
.upDiv{
	float:none;
	position:absolute;
	left:0px;
	top:0px;
}

span.folder{
	cursor:pointer;
}
span.folder.hover{
	color:#3597F1;
}
.content {
	font-size:12px!important;
}

</style>
</HEAD>
<BODY style="overflow:hidden;">
<form name="SearchForm" id="SearchForm" method="post" action="MultiPrivateBrowser.jsp">
	<input type="hidden" id="pid" name="categoryid" value="<%=categoryid%>"/>
	<div style="padding:5px 10px;position:relative" id="menuNavDiv">
		<%-- 目录 --%>
		<div style="width:100%; color: #939d9e; float:left;">
			<div style="padding-right:165px">
				<div style="position:relative;padding-left:40px;">
				<div class="upDiv" onclick="upFolder();"></div>
				<div class="e8MenuNav">
					<div class="e8Home" onclick=""></div>
					<div class="e8ParentNav" id="e8ParentNav">
						<div id="navItem">
						</div>
					</div>
				</div>
				<div style="clear: both;"></div>
				</div>
			</div>
		</div>
		<div style="clear: both;"></div>
		
		
		<%-- 搜索 --%>
		<div class="input-group">
			<input type="text" name="keyword" id="keyword" value="<%=keyword %>"
				class="searchinput private" placeholder="<%=SystemEnv.getHtmlLabelName(126309,user.getLanguage())%>" />
			<span class="searchspan" title="<%= SystemEnv.getHtmlLabelName(82529, user.getLanguage()) %>"> </span>	
		</div>
	</div>
	<div id="content" style="padding:0 5px;overflow:auto">
		<wea:SplitPageTag tableString='<%=tableString%>'
				isShowTopInfo="false" mode="run" />
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" >
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  >
			<wea:item type="toolbar">
			    <input type="button" accessKey=S  value="<%="S-"+SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" class="zd_btn_submit" onclick="onComfirm();">
				<input type="button" accessKey=T  value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</form>
<script>
	jQuery("#content").height(window.innerHeight - jQuery("#menuNavDiv").height() - jQuery("#zDialog_div_bottom").height() - 20);
</script>
</BODY></HTML>
