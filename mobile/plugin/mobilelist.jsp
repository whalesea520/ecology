<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.io.UnsupportedEncodingException"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.mobile.plugin.ecology.service.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
  String sessionKey=Util.null2String(request.getParameter("sessionkey"));
  String pagetitle=Util.null2String(request.getParameter("pagetitle"));
  if(null!=pagetitle&&!"".equals(pagetitle))
				try {
					pagetitle=URLDecoder.decode(pagetitle, "UTF-8");
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
	}
  boolean wfcreate=true;
  int module=Util.getIntValue(request.getParameter("module"),0);
  int scope=9;
  String keyword=Util.null2String(request.getParameter("keyword"));;
  User user = HrmUserVarify.getUser(request , response);
  if(user==null){
  return;
  }
  String userid =user.getUID()+"";
  String setting = Util.null2String(request.getParameter("setting"));
  String detailid = Util.null2String(request.getParameter("detailid"));
%>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/js/jquery/jquery.js'></script>
	<style type="text/css">
	html,body {
		height:100%;
		margin:0;
		padding:0;
		font-size:9pt;
		background: #00538D;
	}
	a {
		text-decoration: none;
	}
	table {
		border-collapse: separate;
		border-spacing: 0px;
	}
	#page {
		width:100%;
		height:100%;
		background: -moz-linear-gradient(top, #C8E8F5, #00538D);
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#C8E8F5', endColorstr='#00538D');
		background: -webkit-gradient(linear, left top, left bottom, from(#C8E8F5), to(#00538D));
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
		background: url("/images/loading_bg.png");
		top: 50%;
		left: 50%;
		display: block;
		text-align: center;
		margin-top: -32px;
		margin-left: -125px;
		z-index: 1002;
	}
	
	#loadingmask {
		width: 100%;
		height: 100%;
		z-index: 1001;
		display:block;
		position:absolute;
		top:0px;
		left:0px;
		background:url("/images/bg_w_65.png");
	}
	
	/* 流程搜索区域 */
	.search {
		width: 100%;
		height: 42px;
		text-align: center;
		position: relative;
		background: #7F94AF;
		background: -moz-linear-gradient(0, #A4B0C0, #7F94AF);
		background: -webkit-gradient(linear, 0 0, 0 100%, from(#A4B0C0), to(#7F94AF) );
		border-bottom: 1px solid #5D6875;
	}
	
	/* 流程搜索text */
	.searchImg {
		width: 25px;
		padding: 2px;
		margin-left: auto;
		margin-right: auto;
		border-top: 1px solid #687D97;
		border-right: 0;
		border-bottom: 1px solid #687D97;
		border-left: 1px solid #687D97;
		background: #fff;
		-moz-border-radius: 5px 0 0 5px;
		-webkit-border-radius: 5px 0 0 5px;
		border-radius: 5px 0 0 5px;
		-webkit-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		-moz-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		box-shadow: inset 0px 1px 0px 0px #BCBFC3;
	}
	.searchText {
		width: 100%;
		margin-left: auto;
		margin-right: auto;
		border-top: 1px solid #687D97;
		border-right: 1px solid #687D97;
		border-bottom: 1px solid #687D97;
		border-left: 0;
		background: #fff;
		overflow:hidden;
		-moz-border-radius: 0 5px 5px 0;
		-webkit-border-radius: 0 5px 5px 0;
		border-radius: 0 5px 5px 0;
		-webkit-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		-moz-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		box-shadow: inset 0px 1px 0px 0px #BCBFC3;
	}
	
	.prompt {
		color: #777878;
	}
	
	/* 列表区域 */
	.list {
		width: 100%;
		background: url(/images/bg_w_75.png);
	}
	/* 列表项*/
	.listitem {
		width: 100%;
		height: 60px;
		background: url(/images/bg_w_25.png);
		border-bottom: 1px solid #D8DDE4;
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
		width: 50px;
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
		background:url(/images/bg_w_75.png);
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
		width: 20px;
	}
	</style>
</head>
<body>

	<table id="page"><tr><td width="100%" height="100%" valign="top" align="left">

		<div id="header">
			<table style="width: 100%; height: 40px;">
				<tr>
					<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
					</td>
					<td align="center" valign="middle">
						<div id="title"></div>
					</td>
					<td width="10%" align="right" valign="middle" style="padding-right:5px;">
					<%
					if(wfcreate&& (module==1||module==7||module==8||module==9||module==10)){
					%>
					<a href="javascript:goCreate();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn.png') no-repeat;text-align:center;line-height:26px;color:#000;">
							新建
						</div>
					</a>
					<%}else if(module==6){%>
					<a href="javascript:goAddressBook();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						组织结构
						</div>
					</a>
						<%}%>
					</td>
				</tr>
			</table>
		</div>

		<div class="search">
			<div style="height:5px"></div>
			<table style="width:100%;height: 28px;">
				<tr>
					<td>&nbsp;</td>
					<td class="searchImg" onclick="searchClick()"><img src="/images/icon-search.png"></td>
					<td class="searchText"><input type="text" id="keyword" name="keyword" class="prompt" style="border: none;width: 100%;height: 26px;" value="<%=keyword%>" escape="true" /></td>
					<td>&nbsp;</td>
				</tr>
			</table>
		</div>

		<div class="list" id="list">
			
		</div>
		
		<div class="listitem listitemmore" id="listItemMore"></div>

		<div class="lastupdatedate" id="lastupdatedate"></div>

	</td></tr></table>


	<div id="loading">数据加载中</div>
	<div id="loadingmask"></div>

	<input type="hidden" id="sessionkey" name="sessionkey" value="<%=sessionKey%>">
	<input type="hidden" id="module" name="module" value="<%=module%>">
	<input type="hidden" id="scope" name="scope" value="<%=scope%>">
	<input type="hidden" id="pageindex" name="pageindex" value="1">
	<input type="hidden" id="pagesize" name="pagesize" value="10">
	<input type="hidden" id="ishavepre" name="ishavepre" value="">
	<input type="hidden" id="count" name="count" value="">
	<input type="hidden" id="pagecount" name="pagecount" value="5">
	<input type="hidden" id="ishavenext" name="ishavenext" value="">

	<script type="text/javascript">
	$(document).ready(function() {

		$.ajaxSetup({ cache: false });
		$("#title").html("<%=pagetitle%>");
		loadList(1);
		$('#keyword').keypress(function(e) {
	        if(e.which == 13) {
	            jQuery(this).blur();
	            loadList(1);
	        }
	    });
	});
	
	function searchClick() {
		loadList(1);
	}
	
	function loadList(type) {
		$( "#loading" ).css("top",(($(window).height() - $("#loading").height())/2 + $(document).scrollTop())+"px");
		$( "#loading" ).show();
		$( "#loadingmask" ).height(Math.max(Math.max(document.body.scrollHeight,document.documentElement.scrollHeight),Math.max(document.body.offsetHeight, document.documentElement.offsetHeight),Math.max(document.body.clientHeight, document.documentElement.clientHeight)));
		$( "#loadingmask" ).show();
		
		var sessionkey = $("#sessionkey").val();
		var module = $("#module").val();
		var scope = $("#scope").val();
		var pageindex = $("#pageindex").val();
		var pagesize = $("#pagesize").val();
		var keyword = $("#keyword").val();
		var pagecount = $("#pagecount").val();
		
		//keyword = encodeURIComponent(,"GBK");
	  //keyword=	$URL.decode(keyword);		
		if(type==1) { //refresh
			pageindex = 1;
		} else if(type==2) { //add
			pageindex = parseInt(pageindex+"") + 1;
		}
		
		$("#listItemMore").html("点击显示更多").unbind("click");
		
		$.getJSON('ComponentList.jsp?setting=<%=setting%>&sessionkey='+sessionkey+'&module='+module+'&scope='+scope+'&pagesize='+pagesize+'&pageindex='+pageindex+'&keyword='+keyword,function(data){
			
			var errormsg = data.error;
			if(errormsg&&errormsg.length>0) {
				alert(errormsg);
				$("#listItemMore").html("加载失败");
				//location = "/login.do";
				//return;
			}
	
			if(data.list) {
				if(type==1) {
					$("#list").html("");
				}

				if($("#page_"+data.pageindex).length>0) {
					$("#page_"+data.pageindex).html("");
				} else {
					$("#list").append('<div id="page_'+data.pageindex+'"></div>');
				}

				$("#pagesize").val(data.pagesize);
				$("#ishavepre").val(data.ishavepre);
				$("#count").val(data.count);
				$("#pagecount").val(data.pagecount);
				$("#pageindex").val(data.pageindex);
				$("#ishavenext").val(data.ishavenext);
				
				if(data.ishavenext=="0") {
					$("#listItemMore").html("总共"+data.count+"条");
				} else {
					$("#listItemMore").html("点击获取更多").bind("click", function(){
						loadList(2);
					});
				}
				
				$.each(data.list,function(j,item){
					
		            if (module==2||module==3) {
						pathtype = "fileid";
					} else {
						pathtype = "url";
					}

					var imageurl = "/images/default.png";
		            if (item.image!=null&&item.image!="") {
		            	//imageurl =item.image;
		            	imageurl = '/downloadpic.do?url='+item.image+'&module='+module+'&scope='+scope;
		            }

					$("#page_"+pageindex).append(
							'<a href="javascript:goPage(\''+item.id+'\')">'+
							'<div class="listitem" id="id_'+item.id+'">'+
							'	<table style="width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;">'+
							'		<tbody>'+
							'			<tr>'+
							'				<td class="itempreview" '+(module=="3"?'style="width:5px;"':'')+'>'+
							(module!="3"?
							'					<img src="'+imageurl+'">'
							:'')+
							'				</td>'+
							'				<td class="itemcontent">'+
							'					<div class="itemcontenttitle">'+
							'						<table style="width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;">'+
							'							<tbody>'+
							'								<tr>'+
							'									<td class="ictwz">'+item.subject+'</td>'+
							(item.isnew==1?'					<td class=\"ictnew\" id=\"wfisnew_" + wfid + "\"><img src=\"/images/new.gif\" width=\"20\" ></td>':'')+
							'								</tr>'+
							'							</tbody>'+
							'						</table>'+
							'					</div>'+
							'					<div class="itemcontentitdt">'+item.description+'</div>'+
							'				</td>'+
							'				<td class="itemnavpoint">'+
							'					<img src="/images/icon-right.png">'+
							'				</td>'+
							'			</tr>'+
							'		</tbody>'+
							'	</table>'+
							'</div>'+
							'<div class="blankLines"></div>'+
							'</a>'					
					);
				});
				
				var d = new Date();
				$("#lastupdatedate").html("最后更新 今天 "+d.getHours()+":"+d.getMinutes()+":"+d.getSeconds()+"&nbsp;&nbsp;");
			}
			
			$( "#loading" ).hide();
			$( "#loadingmask" ).hide();

		});
		
	}
	
	function goPage(detailid) {
		$( "#loading" ).show();
		$( "#loadingmask" ).show();
		var module = $("#module").val();
		var scope = $("#scope").val();
		if(module==2) 
		location = "/mobile/plugin/2/view.jsp?module="+module+"&scope="+scope+"&detailid="+detailid;
		else 	if(module==3) 
		location = "/mobile/plugin/2/view.jsp?module="+module+"&scope="+scope+"&detailid="+detailid;
		else 	if(module==6) 
		location = "/mobile/plugin/6/view.jsp?module="+module+"&scope="+scope+"&detailid="+detailid;
	  else
		location = "/mobile/plugin/1/view.jsp?module="+module+"&scope="+scope+"&detailid="+detailid;
	}
	
	function goBack() {
		location = "/home.do";
	}
	
	function goCreate() {
		var module = $("#module").val();
		var scope = $("#scope").val();
		location = "/mobile/plugin/1/view.jsp?module="+module+"&scope="+scope+"&detailid=";
	}
	
	function goAddressBook() {
		var module = $("#module").val();
		var scope = $("#scope").val();
		location = "/mobile/plugin/6/view.jsp?module="+module+"&scope="+scope+"&detailid=";
	}
	
	</script>

</body>
</html>