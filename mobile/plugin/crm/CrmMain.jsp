
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
	<link rel="stylesheet" href="/wui/common/css/w7OVFont_wev8.css" type="text/css">
	<style type="text/css">
	html,body {
		height:100%;
		margin:0;
		padding:0;
		font-size:9pt;
		background: white;
	}
	a {
		text-decoration: none;
		cursor: pointer;
	}
	table {
		border-collapse: separate;
		border-spacing: 0px;
	}
	#page {
		width:100%;
		height:100%;
		background: white;
	}
	
	#header {
		width: 100%;
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',
			endColorstr='#ececec' );
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),
			to(#ECECEC) );
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		/*
			filter: alpha(opacity=70);
			-moz-opacity: 0.70;
			opacity: 0.70;
			*/
	}
	#header_seach {
		width: 100%;
		background-color: #7f94af;
		border-top: #CCC solid 1px;
		border-bottom: #CCC solid 1px;
		height: 44px;
	}
	#header #title {
		color: #336699;
		font-size: 20px;
		font-weight: bold;
		text-align: center;
	}
	
	#loading {
		width: 250px;
		height: 65px;
		line-height: 65px;
		position: absolute;
		background: url("/mobile/plugin/images/loading_bg_wev8.png");
		top: 50%;
		left: 50%;
		display: block;
		text-align: center;
		margin-top: -32px;
		margin-left: -125px;
		z-index: 1002;
	}
	
	#loadingmask {
		position: absolute;
		width: 100%;
		height: 100%;
		z-index: 1001;
		display: block;
		filter:alpha(opacity=30); BACKGROUND-COLOR: #7f94af;
		opacity:0.3;
		overflow: hidden;
		top: 0;
		left: 0;
	}
	
	/* 流程搜索区域 */
	.search {
		width: 100%;
		height:44px;
		text-align: center;
		position: relative;
		background-color: #7f94af;

	}
	
	/* 流程搜索text */
	.searchText {
		width: 90%;
		height: 28px;
		margin-left: 0px;
		margin-right: auto;
		background: #fff;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		border-radius: 5px;
		/*-webkit-box-shadow: inset 0px 1px 0px 0px #BCBFC3;*/
		/*-moz-box-shadow: inset 0px 1px 0px 0px #BCBFC3;*/
	}
	
	.prompt {
		color: #777878;
	}
	
	/* 列表区域 */
	.list {
		width: 100%;
		background: url(/images/bg_w_75_wev8.png);
	}
	/* 列表项*/
	.listitem {
		width: 100%;
		height: 80px;
		background: url(/images/bg_w_25_wev8.png);
		border-bottom: 1px solid #D8DDE4;
		cursor: pointer;
	}
	/* 列表项后置导航 */
	.itemnavpoint {
		height: 100%;
		width: 26px;
		text-align: center;
	}
	/* 列表项后置导航图  */
	.itemnavpoint img {
		width: 10px;
		heigth: 14px;
	}
	/* 流程创建人头像区域  */
	.itempreview {
		height: 100%;
		width: 5px;
		text-align: center;
	}
	/* 流程创建人头像  */
	.itempreview img {
		width: 40px;
		height: 40px;
		margin-top: 4px;
	}
	
	/* 列表项内容区域 */
	.itemcontent {
		width: *;
		height: 100%;
		font-size: 14px;
		cursor: pointer;
	}
	
	/* 列表项内容名称 */
	.itemcontenttitle {
		width: 100%;
		height: 23px;
		overflow-y: hidden;
		line-height: 23px;
		font-weight: bold;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		font-size: 14px;
	}
	
	/* 列表项内容简介 */
	.itemcontentitdt {
		width: 100%;
		height: 23px;
		overflow-y: hidden;
		line-height: 23px;
		font-size: 12px;
		color: #777878;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}
	/* 更多 */
	.listitemmore {
		height: 50px;
		text-align: center;
		line-height: 50px;
		font-weight: bold;
		color: #777878;
		background:url(/images/bg_w_75_wev8.png);
		cursor: pointer;
		background-color: #ececec;
		
	}
	/* 列表更新时间 */
	.lastupdatedate {
		width: 100%;
		height: 20px;
		text-align: right;
		font-size: 12px;
		line-height: 20px;
		background: #E1E8EC;
		background: -moz-linear-gradient(0, white, #E1E8EC);
		background: -webkit-gradient(linear, 0 0, 0 100%, from(white),
			to(#E1E8EC) );
	}
	/* 间隔 */
	.blankLines {
		width: 100%;
		height: 1px;
		overflow: hidden;
		background-color: #ececec;
		
	
	}
	
	/* 列表项标题 */
	.ictwz {
		width: *;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}
	
	

	/* new */
	.ictnew {
		width: 70px;
	}
	
	.tdimg{
		border-top: 1px solid black;
		border-left: 1px solid black;
		border-bottom: 1px solid black;
		border-right:0px;
		background-color: white;
		vertical-align:middle;
		padding-left: 5px;
		padding-top: 3px;
		cursor: pointer;
	}
	
	.tdinput{
		border-top: 1px solid black;
		border-right: 1px solid black;
		border-bottom: 1px solid black;
		text-align:left;
		padding-left:5px;
		padding-right:5px;
		border-left:0px;
		background-color: white;
		vertical-align:middle;
	}
	
	.fivestar{
		width: 14px;
		height: 14px;
		background: url(/email/images/mailicon_wev8.png) -32px -160px no-repeat;
	}
	.fivestarcheck {
		width: 14px;
		height: 14px;
		background: url(/email/images/mailicon_wev8.png) -48px -160px no-repeat;
	}

	</style>
</head>
<body>

<%
	String clienttype = Util.null2String((String)request.getParameter("clienttype"));
	String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
	String module=Util.null2String((String)request.getParameter("module"));
	String scope=Util.null2String((String)request.getParameter("scope"));
	String opengps = Util.null2String((String)request.getParameter("opengps"));	 
%>


<table id="page"  style="width: 100%;height: 100%;"  cellpadding="0" cellspacing="0">
	<tr>
	<td width="100%" height="100%" valign="top" align="left">
			<div id="header"  style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
					<table style="width: 100%; height: 40px;">
						<tr>
							<td width="10%" align="left" valign="middle" style="padding-left:5px;">
									<a href="/home.do">
										<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
											返回
										</div>
									</a>
							</td>
							<td align="center" valign="middle">
								<div id="title" >客户</div>
							</td>
							<td width="10%" align="right" valign="middle" style="padding-right:5px;">
									
							</td>
						</tr>
					</table>
			</div>
			
			<form id="highSearchForm" name="highSearchForm" style="margin: 0px" onsubmit="return false;"> 
			<div id="header_seach">
						<input name ="index"  id="index" type="hidden" value="1">
						<div class="search">
									<table style="width: 100%;height:40px;margin-top: 2px"  cellpadding="0" cellspacing="0">
											<colgroup>
																<col width="5px">
												   				<col width="25px">
												   				<col width="*">
												   				<col width="5px">
											</colgroup>
											<tr>
													<td>
													</td>
													<td class="tdimg" id="seach">
														<img src="/images/icon-search.png">
													</td>
													<td class="tdinput">
														<input type="text" id="name" name="name" class="searchText prompt" onkeyup="doInput(event)" >
													</td>
													<td></td>
											</tr>
									</table>
						</div>
					
			</div>
			<div style="border-bottom: 1px #d8dde4 solid;height:35px;">
				<table style="width:100%;height: 100%">
					<tr>
						<td width="5px"></td>
						<td>行业</td>
						<td>
							<select id="sector" name="sector">
								<option value="">---请选择---</option>
								<%
									RecordSet rs=new RecordSet();
									String sql="select id,fullname from CRM_SectorInfo   where parentid=0 order by id asc";
									rs.execute(sql);
									while(rs.next()){
								%>
								<option value="<%=rs.getString("id")%>"><%=rs.getString("fullname")%></option>
								<%}%>
							</select>
						</td>
						<td>类型</td>
						<td>
							<select id="type" name="type">
								<option value="">---请选择---</option>
								<%
									sql="select id,fullname from CRM_CustomerType order by id asc";
									rs.execute(sql);
									while(rs.next()){
								%>
								<option value="<%=rs.getString("id")%>"><%=rs.getString("fullname")%></option>
								<%}%>
							</select>
						</td>
						<td width="5px"></td>
					</tr>
				</table>
			</div>
			</form>
			<div class="list" id="list">
						<div id="mailList">
						</div>
			</div>
	</td>
</tr>
<tr>
		<td>
				<div class=" listitemmore"  id="listItemMore"  >
						<%=SystemEnv.getHtmlLabelName(81408,user.getLanguage()) %>
				</div>
		</td>
</tr>	
</table>

<div id="loading"><%=SystemEnv.getHtmlLabelName(30665,user.getLanguage()) %>...</div>
<div id="loadingmask" ></div>

	

	
<script type="text/javascript">
var module="<%=module%>";
var scope="<%=scope%>";
jQuery(document).ready(function(){

	//对汉字参数进行处理
	jQuery.param=function( a ) {  
		    var s = [ ];  
		    var encode=function(str){  
		        str=escape(str);  
		        str=str.replace(/\+/g,"%u002B");
		        return str;  
		    };  
		    function add( key, value ){  
		        s[ s.length ] = encode(key) + '=' + encode(value);  
		    };  
		    // If an array was passed in, assume that it is an array  
		    // of form elements  
		    if ( jQuery.isArray(a) || a.jquery )  
		        // Serialize the form elements  
		        jQuery.each( a, function(){  
		            add( this.name, this.value );  
		        });  
		    // Otherwise, assume that it's an object of key/value pairs  
		    else  
		        // Serialize the key/values  
		        for ( var j in a )  
		            // If the value is an array then the key names need to be repeated  
		            if ( jQuery.isArray(a[j]) )  
		                jQuery.each( a[j], function(){  
		                    add( j, this );  
		                });  
		            else  
		                add( j, jQuery.isFunction(a[j]) ? a[j]() : a[j] );   
		    // Return the resulting serialization  
		    return s.join("&").replace(/%20/g, "+");  
	}
		
		loadMailListContent(1);
		//初始化标签相关响应
		$("#listItemMore").bind("click", function(){
			//TotalPage
			var upindex=parseInt($("#index").val())+1;
			if(upindex<=parseInt($("#TotalPage").val())){
					var newhtml="<img src='/images/loading2_wev8.gif'><%=SystemEnv.getHtmlLabelName(30665,user.getLanguage()) %>...";
					$("#index").attr("value",upindex);
					var temp=$("#index").val();
					$("#listItemMore").html(newhtml);
					loadMailListAppendContent(temp);
			}else{
				$("#listItemMore").hide();
				$("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(81408,user.getLanguage()) %>");
			}
		});
		$("#seach").bind("click", function(){
				$("#TotalPage").remove();
				loadMailListContent(1);
		});
		
		
		
});


function doInput(event){
	if(event.keyCode==13){
		$("#seach").click();
	}
	stopBubble(event);
}

//阻止事件冒泡函数
function stopBubble(e)
 {
     if (e && e.stopPropagation){
         e.stopPropagation()
     }else{
         window.event.cancelBubble=true
     }
}

//标签功能
function initLableTarget(){
	$(".trclick").unbind().bind("click", function(event){
		var customerid=$(this).attr("_id");
		var url = "/mobile/plugin/crm/CrmView.jsp?opengps=<%=opengps%>&customerid="+customerid+"&module="+module+"&scope="+scope+"&t="+Math.random();
		window.location.href=url;
	});
	
}

//默认加载
function loadMailListContent(index){
	$("#index").attr("value",index);
	var formData=$("#highSearchForm").serialize()+"&loadtype=0&module="+module+"&scope="+scope+"&data="+new Date().getTime();
	jQuery("#mailList").load("/mobile/plugin/crm/CrmListContent.jsp",formData, function(){
		//初始化标签相关响应
		initLableTarget();
		$("#loadingmask").hide();
		$("#loading").hide();
		if($("#TotalPage").val()=="1"){
			$("#listItemMore").hide();
			$("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(81408,user.getLanguage()) %>");
		}else
			$("#listItemMore").show();
	});
}


//更多加载
function loadMailListAppendContent(index){
	var formData="?"+$("#highSearchForm").serialize()+"&module="+module+"&scope="+scope+"&loadtype=1&data="+new Date().getTime();
	//通过post第2个参数传递过去无效
	$.post("/mobile/plugin/crm/CrmListContent.jsp"+formData, "", function(Data){
				jQuery("#mailList").append(Data);
				//初始化标签相关响应
				initLableTarget();
				if(index==$("#TotalPage").val()){
						$("#listItemMore").hide();
						$("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(81408,user.getLanguage()) %>");
				}else{
					//判断更多按钮是否可用
					$("#listItemMore").show();
					$("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(81408,user.getLanguage()) %>");
				}
	});
}

function getLeftButton(){ 
		return "1,<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>";
}

</script>
	
</body>
</html>