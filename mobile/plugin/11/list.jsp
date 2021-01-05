
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

String userid = request.getParameter("userid");
String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String opengps = Util.null2String((String)request.getParameter("opengps"));
%>
<!DOCTYPE html>
<html>
<head>
	<title>Attention List</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<script type="text/javascript" src="/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="/js/mylibs/showLoading/jquery.showLoading.js"></script>
	<script type="text/javascript" src="/js/mylibs/asyncbox/AsyncBox.v1.4.js"></script>
	<link rel="stylesheet" href="/js/mylibs/asyncbox/skins/ZCMS/asyncbox.css">
	<link rel="stylesheet" href="/mobile/plugin/11/css/blog_wev8.css">
	<script type="text/javascript" src="/js/script.js"></script>
	
	<script type="text/javascript">
	/*
	function afterAndroidRedirect(id, flag) {
		try {
			if ((flag + "") == "1") { 
				$("#wfisnew_" + id).remove();
				$("#wf_" + id).remove();
			}
		} catch(e) {
		}
	}
	*/
	function showItemDetailed(requestid,isnew) {
		//var path = "/workflow/edit.do?requestid=" + requestid + "&module=" + $("input[name='module']").val() + "&scope=" + $("input[name='scope']").val() + "&unread=false&isnew=" + isnew;
		//window.location.href = path;
	} 

	$(document).ready(function () {
		bindNavEvent();
		//加载数据
		getDataList(getUrlParam(), true);
	});
	
	/**
	 * 获取url参数
	 */
	function getUrlParam(pageindex) {
		var sessionkey = $("input[name='sessionkey']").val();
		var module = $("input[name='module']").val();
		var scope = $("input[name='scope']").val();
		var userid = $("input[name='userid']").val();
		var comefrom = $("input[name='comefrom']").val();
		var pagesize = config.newListPageSize;
		var paras = "method=getpage&page=BlogOperation&dataType=json&userid="+userid+"&";
		if (!util.isNullOrEmpty(pageindex)) {
			paras=paras+"operation=getAttentionList"; 			  //加载非第一页
		}else {
		    paras=paras+"operation=viewAttention";            //加载第一页
		}
		paras =paras+"&sessionkey=" + sessionkey + 
			"&module=" + module + 
			"&scope=" + scope + 
			"&pagesize=" + pagesize + 
			"&comefrom="  + comefrom +
			"&tk" + new Date().getTime() +"=1";
		
		if (!util.isNullOrEmpty(pageindex)) {
			paras += "&pageindex=" + pageindex;
		}
		return paras;
	}
	
	function getDataList(paras, isFirst){
		
	    util.getData({
	    	"loadingTarget" : document.body,
    		"paras" : paras,//得数据的URL,
    		"callback" : function (data){
		    	if(data.error){
		    		$("#listArea").html("<div class=\"listitem listitemmore\">没有数据</div><div class=\"blankLines\"></div>");
				} else {
				   
					var pageindex = data.pageindex;
					var pagesize = data.pagesize;
					var count = data.count;
					var ishavepre = data.ishavepre;
					var ishavenext = data.ishavenext
					var pagecount = data.pagecount;
					$("input[name='pageindex']").val(pageindex);
					$("input[name='pagesize']").val(pagesize);
					$("input[name='count']").val(count);
					$("input[name='ishavepre']").val(ishavepre);
					$("input[name='ishavenext']").val(ishavenext);
					$("input[name='pagecount']").val(pagecount);
					
					if(isFirst){
					
					    //菜单数字提醒
					    var unReadCount=data.menuItemCount[0];
					    //var attentionCount=data.menuItemCount.attentionCount;
					    var remindCount=data.menuItemCount[1];
						
						$("#unReadCount").html(unReadCount>0?"("+unReadCount+")":"");
						$("#remindCount").html(remindCount>0?"("+remindCount+")":"");
					
					}
					
					var listItemString = "<div id=\"pagecontent_" + pageindex + "\">";
					var listItems="";
					var currentPageDataCnt = 0;
					
					if(data.attentionList.length==0)
					   listItemString=listItemString+"<div class=\"listitem listitemmore\">没有关注的人</div><div class=\"blankLines\"></div>";
					
					$.each(data.attentionList, function (i, item){ 
						currentPageDataCnt++;
						
						var userid=item.userid;
						var username=item.username;
						var subName=item.subName;
						var deptName=item.deptName;
						var jobtitle=item.jobtitle;
						var isnew=item.isnew;
						var imageUrl=item.imageUrl;
						
						listItemString=listItemString+"<div class='listitem' onclick='javascript:showItemDetailed();'>"
									+"	<table width='100%' height='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed;'>"
									+"		<tr onclick='openBlog("+userid+")'>"
									+"			<TD class='itempreview'>"
									+"				<img src='"+imageUrl+"'>"
									+"			</TD>"
									+"			<TD class='itemcontent'>"
									+"				<div class='itemcontenttitle'>"
									+"					<table width='100%' height='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed;'>"
									+"						<tr>"
									+"							<TD class='ictwz'>"
									+"								<span>&nbsp;"+username+"&nbsp;</span><span class='ictwz_gw'>"+jobtitle+"</span>"
									+"							</TD>"
									+"							<TD class='ictnew' valign='bottom'>"
									+"								<img src='images/blog/new_wev8.png' width='20' style='display:"+(isnew=="1"?"":"none")+"'>"
									+"							</TD>"
									+"						</TR>"
									+"					</TABLE>"
									+"				</div>"
									+"				<div class='itemcontentitdt'>&nbsp;&nbsp;"+subName+"&nbsp;"+deptName+"</div>"
									+"			</TD>"
									+"			<TD class='itemnavpoint'>"
									+"				<img src='images/rightArrow_wev8.png'>	"
									+"			</TD>"
									+"		</TR>"
									+"	 </TABLE>"
									+" </div>"
									+"<div class='blankLines'></div>";
					});
					
					//alert(listItems);
					listItemString += "</div>";
					if (isFirst == true && currentPageDataCnt != 0) {
						$("#listArea").html("");
						if (ishavenext == "1") {
							listItemString += "<div class=\"listitem listitemmore\" id=\"listItemMore\">更多...</div><div class=\"blankLines\"></div>";
						}
						
						$("#listArea").append(listItemString);

						$("#listItemMore").bind("click", function () {
							$("#listItemMore").html("<img src=\"/images/ajax-loader_wev8.gif\" style=\"vertical-align:middle;\">&nbsp;正在加载...");
							getDataList(getUrlParam(parseInt($("input[name='pageindex']").val()) + 1), false);
						});
					} else {
					    //$("#listArea").append(listItemString);
						$("#listItemMore").before(listItemString);
						if (ishavenext == "1") {
							$("#listItemMore").html("更多...");
						} else {
							$("#listItemMore").hide();
						}
					}
				}
			}
	    });
	    //最后更新时间
	    $("#lastupdatedate").html("最后更新&nbsp;今天：" + util.getCurrentDate4Format("hh:mm:ss") + "&nbsp;&nbsp;");
    }
    /**
     * resize
     */
	window.onresize = function () {
	};


	function bindNavEvent() {
		$(".navbtn").bind("click", function () {
			var oldObj = $(".navbtnslt"); 
			oldObj.removeClass("navbtnslt");
			$(this).addClass("navbtnslt");
			var url=$(this).attr("url");
			jQuery(document.body).showLoading();
			window.location.href=url;
		});
	}
	
	function openBlog(blogid){
	   jQuery(document.body).showLoading();
	   window.location.href="viewBlog.jsp?userid=<%=request.getParameter("userid")%>&module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&blogid="+blogid;
	}
	
	function goBack() {
		location = "/home.do";
	}
	
	</script>
</head>

<body onload="setTimeout(function() { window.scrollTo(0, 1) }, 100);" />
<div id="view_page">
	<div id="view_header" style="<%if ("".equals(clienttype)||clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<table style="width: 100%; height: 40px;">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();"  style="text-decoration: none;">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
				</td>
				<td align="center" valign="middle">
					<div id="view_title">工作微博</div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
				</td>
			</tr>
		</table>
	</div>
	<div  class="content">
		<!-- 存放必须数据区域 START -->
		<input type="hidden" name="sessionkey" value="<%=request.getParameter("mobileSession") %>">
		<input type="hidden" name="module" value="<%=request.getParameter("module") %>">
		<input type="hidden" name="scope" value="<%=request.getParameter("scope") %>">
		<input type="hidden" name="userid" value="<%=userid%>">
		<!-- 当前页索引 -->
		<input type="hidden" name="pageindex" value="">
		<!-- 每页记录条数 -->
		<input type="hidden" name="pagesize" value="5">
		<!-- 总记录条数 -->
		<input type="hidden" name="count" value="">
		<!-- 是否有上一页 -->
		<input type="hidden" name="ishavepre" value="">
		<!-- 是否有下一页 -->
		<input type="hidden" name="ishavenext" value="">
		<!-- 总页数 -->
		<input type="hidden" name="pagecount" value="">
		<!-- 客户端类型 -->
		<input type="hidden" name="comefrom" value="<%=clienttype%>">
		
		<!-- 存放必须数据区域 END -->
		
		<!-- 微薄顶部导航区域 START -->
		
		<div class="navblock">
			<div class="navbtnblock">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed;color:#395582;">
					<tr>
						<td width="25%" align="center">
							<div class="navbtn navbtncenter navbtnleft" url="/mobile/plugin/11/mainPage.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>&clienttype=<%=clienttype%>&opengps=<%=opengps%>">
								主页<span id="unReadCount"></span>
							</div>
						</td>
						<td width="25%" align="center">
							<div class="navbtn navbtnslt" url="/mobile/plugin/11/list.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>&clienttype=<%=clienttype%>&opengps=<%=opengps%>">
								关注<span id="attentionCount"></span>
							</div>
						</td>
						<td width="25%" align="center">
							<div class="navbtn navbtncenter" url="/mobile/plugin/11/viewBlog.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>&clienttype=<%=clienttype%>&opengps=<%=opengps%>">
								我的
							</div>
						</td>
						<td width="*" align="center">
							<div class="navbtn navbtncenter navbtnright" url="/mobile/plugin/11/comment.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>&clienttype=<%=clienttype%>&opengps=<%=opengps%>">
								评论<span id="remindCount"></span>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<!-- 微薄顶部导航区域 END -->
		
		<!-- 列表区域 -->
		<div class="listArea" id="listArea"></div>
		
		<div class="lastupdatedate" id="lastupdatedate">
			最后更新&nbsp;今天：16:12:18&nbsp;&nbsp;
		</div>
	</div>
	</div>
</body>
</html>
