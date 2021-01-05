
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*"%>
<%@ page import="weaver.cowork.*"%>
<%@ page import="weaver.file.FileUpload" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int userid=user.getUID();

FileUpload fu = new FileUpload(request);
String module = Util.null2String((String)fu.getParameter("module"));
String scope = Util.null2String((String)fu.getParameter("scope"));

String titleurl = Util.null2String((String)request.getParameter("title"));
String title = URLDecoder.decode(titleurl,"UTF-8");

String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
String clientlevel = Util.null2String((String)fu.getParameter("clientlevel"));

String keyword = Util.null2String(fu.getParameter("keyword"));
int labelid = Util.getIntValue(fu.getParameter("labelid"), 0);
%>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
	<script type="text/javascript" src="/mobile/plugin/cowork/js/script_wev8.js"></script>
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
		width:100%;
		border-collapse: separate;
		border-spacing: 0px;
	}
	#page {
		width:100%;
		height:100%;
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
		background: url("/images/loading_bg_wev8.png");
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
		background:url("/images/bg_w_65_wev8.png");
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
		background-color:#F1F1F1;
	}
	/* 列表项*/
	.listitem {
		width: 100%;
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
		width: 20px;
		heigth: 20px;
	}
	/* 流程创建人头像区域  */
	.itempreview {
		vertical-align: top;
		height: 100%;
		width: 30px;
		text-align: center;
	}
	/* 流程创建人头像  */
	.itempreview img {
		width: 20px;
		height: 20px;
		margin-top: 14px;
	}
	
	/* 列表项内容区域 */
	.itemcontent {
		width: *;
		height: 100%;
		font-size: 14px;
		padding:17px 5px;
	}
	
	/* 列表项内容名称 */
	.itemcontenttitle {
		width: 100%;
		color: #000000;
		word-break: break-all;
		text-overflow: ellipsis;
		font-size: 14px;
	}
	
	/* 更多 */
	.listitemmore {
		height: 50px;
		text-align: center;
		line-height: 50px;
		font-weight: bold;
		color: #777878;
		background-color:#F1F1F1;
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
	
	/* new */
	.ictnew {
		width: 20px;
	}
	
	.btnNav {
		height:32px;
		border-top:1px solid #FFFFFF;
		border-bottom:1px solid #898989;
		background-image:-webkit-gradient(linear, left top, left bottom, color-stop(0, #DEE6E9), color-stop(1, #BAC5CB));
		padding-left:10px;
		padding-top:5px;
		padding-bottom:5px;
		overflow:hidden;
		font-size: 14px;
	}
	
	.topBtn {
		width:70px;
		height:30px;
		line-height:30px;
		text-align:center;
		border-top:1px solid #738792;
		border-bottom:1px solid #556B78;
		border-left:1px solid #738792;
		border-right:1px solid #738792;
		text-shadow:0 1px #FFFFFF;
		background-image:-webkit-gradient(linear, left top, left bottom, color-stop(0, #D5DADD), color-stop(1, #9DAFBB));
		-webkit-border-radius:4px;
		border-radius:4px;
		float:left;
	}

	.topBtnDown {
		width:70px;
		height:30px;
		line-height:30px;
		text-align:center;
		border-top:1px solid #29415E;
		border-bottom:1px solid #4C7E9F;
		border-left:1px solid #375A76;
		border-right:1px solid #375A76;
		color:#FFFFFF;
		background-image:-webkit-gradient(linear, left top, left bottom, color-stop(0, #4482B1), color-stop(1, #6297C1));
		-webkit-border-radius:4px;
		border-radius:4px;
		float:left;
	}
	
	.lab {
		padding:2px 8px;
		margin-top:5px;
		font-size:12px;
		background-color:#3F9EDE;
		border-top:1px solid #3A7CB0;
		color:#FFFFFF;
		border-radius:4px;
		display:inline-block;
		word-break: break-all;
	}
	
	.lab_sp {
		width:50px;
		height:2px;
		margin:6px 5px;
		background-image:url(/mobile/plugin/cowork/img/lab_sp_wev8.png);
	}
	
	.lab_select {
		font-weight:bold;
	}
	</style>
</head>
<body>

	<table id="page"><tr><td width="100%" height="100%" valign="top" align="left">

		<div id="header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
			<table style="width: 100%; height: 40px;">
				<tr>
					<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>
						</div>
					</a>
					</td>
					<td align="center" valign="middle">
						<div id="title"><%=title%></div>
					</td>
					<td width="10%" align="right" valign="middle" style="padding-right:5px;">
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
					<td class="searchText"><input type="text" id="keyword" name="keyword" class="prompt" style="border: none;width: 100%;height: 26px;" value="<%=keyword %>"></td>
					<td>&nbsp;</td>
				</tr>
			</table>
		</div>
		
		<div class="btnNav">
			<div class="<%if(labelid==0){%>topBtnDown<%}else{%>topBtn<%}%>" onclick="changeLabel(this, 0)"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></div>
			<div class="<%if(labelid==-1){%>topBtnDown<%}else{%>topBtn<%}%>" style="margin-left:6px;" onclick="changeLabel(this, -1)"><%=SystemEnv.getHtmlLabelName(25396,user.getLanguage())%></div>
			<div class="<%if(labelid==-2){%>topBtnDown<%}else{%>topBtn<%}%>" style="margin-left:6px;" onclick="changeLabel(this, -2)"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></div>
			<div id="labs" class="<%if(labelid>0){%>topBtnDown<%}else{%>topBtn<%}%>" style="margin-left:6px;" onclick="showLabel(this)"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%></div>
		</div>
  
		<div class="list" id="list">
			
		</div>
		
		<div class="listitem listitemmore" id="listItemMore"></div>

		<div class="lastupdatedate" id="lastupdatedate"></div>

	</td></tr></table>

	<input type="hidden" id="sessionkey" name="sessionkey" value="">
	<input type="hidden" id="module" name="module" value="<%=module %>">
	<input type="hidden" id="scope" name="scope" value="<%=scope %>">
	<input type="hidden" id="pageindex" name="pageindex" value="1">
	<input type="hidden" id="pagesize" name="pagesize" value="">
	<input type="hidden" id="ishavepre" name="ishavepre" value="">
	<input type="hidden" id="count" name="count" value="">
	<input type="hidden" id="pagecount" name="pagecount" value="">
	<input type="hidden" id="ishavenext" name="ishavenext" value="">
	
	<input type="hidden" id="labelid" name="labelid" value="<%=labelid %>">
	
	<div id="labeldiv" style="display:none;position: absolute;left:235px;top:110px;color:#FFFFFF;font-size:13px;width:92px;height:196px;background-image:url(/mobile/plugin/cowork/img/label_wev8.png);">
		<div class="labwin" style="text-align:center;width:60px;height:150px;top:25px;left:16px;overflow:hidden;position: relative;z-index: 10;">
			<div id="slide" style="position: absolute;top:0px;z-index: -1;">
				<%
				int curidx = 0;
				RecordSet.execute("select id,name,labelColor,textColor from cowork_label where userid="+userid+" and (labelType='label') order by labelOrder");
				while(RecordSet.next()){
					if(curidx > 0) {
						%><div class="lab_sp"></div><%
					}
					%><div class="lab_title" onclick="changeLabel(this, <%=RecordSet.getString("id")%>)"><%=RecordSet.getString("name")%></div><%
					curidx++;
				}
				%>
			</div>
		</div>
	</div>

	<script type="text/javascript">
	$(document).ready(function() {

		$.ajaxSetup({ cache: false });
		
		loadList(1);
		
		$('#keyword').keypress(function(e) {
	        if(e.which == 13) {
	            jQuery(this).blur();
	            loadList(1);
	        }
	    });
	    
	    var sliding = startClientY = startPixelOffset = pixelOffset = 0;
	    
		$('.labwin').bind('mousedown touchstart', function slideStart(event) {
			if (event.originalEvent.touches)
			event = event.originalEvent.touches[0];
			if (sliding == 0) {
				sliding = 1;
				startClientY = event.clientY;
			}
		});

		$('.labwin').bind('mousemove mousedown touchmove', function slide(event) {
			event.preventDefault();
			if (event.originalEvent.touches)
				event = event.originalEvent.touches[0];
			var deltaSlide = event.clientY - startClientY;
			if (sliding == 1 && deltaSlide != 0) {
				sliding = 2;
				startPixelOffset = pixelOffset;
			}
			if (sliding == 2) {
				pixelOffset = startPixelOffset + deltaSlide;
				if(pixelOffset < 0 && pixelOffset > $(".labwin").height() - $("#slide").height()) {
					$("#slide").css('top',pixelOffset +'px');
				}
			}
		});
		
		$('.labwin').bind('mouseup mousestop touchend', function slideEnd(event) {
			if (sliding == 2) {
				sliding = 0;
				pixelOffset = $("#slide").offset().top-$(".labwin").offset().top;
			}
		});
	});
	
	function searchClick() {
		loadList(1);
	}
	
	function loadList(type) {
		var sessionkey = $("#sessionkey").val();
		var module = $("#module").val();
		var scope = $("#scope").val();
		var pageindex = $("#pageindex").val();
		var keyword = $("#keyword").val();
		var pagecount = $("#pagecount").val();
		var labelid = $("#labelid").val();
		
		keyword = encodeURIComponent(keyword);
		
		if(type==1) { //refresh
			pageindex = 1;
			$("#list").html("");
		} else if(type==2) { //add
			pageindex = parseInt(pageindex+"") + 1;
		}
		
		$("#listItemMore").html("<img src='/mobile/plugin/cowork/img/ajax-loader_wev8.gif' style='vertical-align:middle;'>&nbsp;<%=SystemEnv.getHtmlLabelName(34119,user.getLanguage())%>...").unbind("click");
		
		util.getData({
	    	loadingTarget : document.body,
    		paras : "operation=getCoworkList&pageindex="+pageindex+"&keyword="+keyword+"&labelid="+labelid,//得数据的URL,
    		callback : function (data){
				var errormsg = data.error;
				if(errormsg&&errormsg.length>0) {
					alert(errormsg);
					$("#listItemMore").html("无法读取数据...");
				}
		
				if(data.list) {
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
						$("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(23631,user.getLanguage())%>"+data.count+" <%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>");
					} else {
						$("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(83447,user.getLanguage())%>...").bind("click", function(){
							loadList(2);
						});
					}
					
					$.each(data.list,function(j,item){
						var itemstr = "<div class='listitem' id='id_"+item.id+"'>"+
								"	<table>"+
								"		<tbody>"+
								"			<tr>";
						if(item.important==1) {
							itemstr+="			<td class='itempreview markImport' onclick='markCowork(this, "+item.id+")'>"+
									"				<img src='/mobile/plugin/cowork/img/imp_wev8.png'>";
						} else {
							itemstr+="			<td class='itempreview' onclick='markCowork(this, "+item.id+")'>"+
									"				<img src='/mobile/plugin/cowork/img/imp0_wev8.png'>";
						}
						itemstr+="				</td>"+
								"				<td class='itemcontent' onclick='goPage("+item.id+")'>"+
								"					<span class='itemcontenttitle'>" + item.subject + "</span>";
						
						if(item.label) {
							var labelstr = "";
							$.each(item.label,function(k,lab){
								labelstr += "		<span class='lab' style='color:"+lab.textColor+";background-color:"+lab.labelColor+";'>"+lab.name+"</span>";
							});
							if(labelstr) {
								itemstr += "<br/>"+labelstr;
							}
						}
						
						itemstr+="				</td>"+
								"				<td style='vertical-align: top;width:26px;' onclick='goPage("+item.id+")'>";
								
						if(item.isnew==1) {
							itemstr+="			<img src='/images/new.gif'>";
						}
						
						itemstr+="				</td>"+
								"				<td class='itemnavpoint' onclick='goPage("+item.id+")'>"+
								"					<img src='/mobile/plugin/cowork/img/right_wev8.png'>"+
								"				</td>"+
								"			</tr>"+
								"		</tbody>"+
								"	</table>"+
								"</div>"+
								"<div class='blankLines'></div>";
						$("#page_"+pageindex).append(itemstr);
					});
					
					var d = new Date();
					$("#lastupdatedate").html("<%=SystemEnv.getHtmlLabelName(25295,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%>"+": "+d.getHours()+":"+d.getMinutes()+":"+d.getSeconds()+"&nbsp;&nbsp;");
				}
			}
	    });
	}
	
	function goPage(detailid) {
		var module = $("#module").val();
		var scope = $("#scope").val();
		location = "/mobile/plugin/cowork/view.jsp?module="+module+"&scope="+scope+"&detailid="+detailid;
	}
	
	function goBack() {
		location = "/home.do";
	}
	
	function changeLabel(_this, labelid) {
		if(labelid > 0) {
			if($("#labelid").val()!=labelid) {
				$(_this).addClass("lab_select");
				$(_this).siblings(".lab_title").removeClass("lab_select");
				$("#labelid").val(labelid);
				loadList(1);
			}
		} else {
			if($("#labelid").val()!=labelid || ($("#labelid").val()==labelid && $(_this).hasClass("topBtn"))) {
				$("#slide .lab_title").removeClass("lab_select")
				$(_this).removeClass("topBtn").addClass("topBtnDown");
				$(_this).siblings(".topBtnDown").removeClass("topBtnDown").addClass("topBtn");
				$("#labelid").val(labelid);
				loadList(1);
			}
		}
		
		$("#labeldiv").hide();
	}
	
	function showLabel(_this) {
		$(_this).removeClass("topBtn").addClass("topBtnDown");
		$(_this).siblings(".topBtnDown").removeClass("topBtnDown").addClass("topBtn");
		
		$("#labeldiv").css("top", $("#labs").offset().top+19);
		$("#labeldiv").css("left", $("#labs").offset().left-10);
		
		$("#labeldiv").show();
	}
	
	function markCowork(_this, coworkid) {
		if($(_this).hasClass("processing")) return;
		
		$(_this).addClass("processing");
		
		var operation;
		if($(_this).hasClass("markImport")) {
			operation = "normal";
		} else {
			operation = "important";
		}
		
		$.getJSON("/mobile/plugin/cowork/CoworkOperation.jsp?coworkid="+coworkid+"&operation="+operation, function(data){
			if(data.result) {
				if($(_this).hasClass("markImport")) {
					$(_this).removeClass("markImport")
					$(_this).find("img").attr("src", "/mobile/plugin/cowork/img/imp0_wev8.png");
				} else {
					$(_this).addClass("markImport")
					$(_this).find("img").attr("src", "/mobile/plugin/cowork/img/imp_wev8.png");
				}
			}
			
			$(_this).removeClass("processing");
		});
	}
	</script>

</body>
</html>
