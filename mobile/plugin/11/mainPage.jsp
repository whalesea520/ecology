
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.blog.service.BlogGroupService"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Map"%>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

String userid = request.getParameter("userid");
String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String opengps = Util.null2String((String)request.getParameter("opengps"));
String groupid=Util.null2String(request.getParameter("groupid"));
groupid=groupid.equals("")?"all":groupid;
BlogGroupService groupService=new BlogGroupService();
ArrayList groupList = groupService.getGroupsById(Util.getIntValue(request.getParameter("userid")));
int groupCount=groupList.size();
String module = Util.null2String((String)request.getParameter("module"));
String scope = Util.null2String((String)request.getParameter("scope"));
%>
<!DOCTYPE html>
<html>
<head>
	<title>Blog Home</title>
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
	<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
	<script type="text/javascript" charset="UTF-8" src="/js/blog/blogUtil.js"></script>
	<script type="text/javascript">
	var clientVersion=0;
	var clienttype="<%=clienttype%>";
	var opengps="<%=opengps%>"; 
	
	$(document).ready(function () {
		if(clienttype=="android"||clienttype=="androidpad"){
			clientVersion=mobileInterface.getClientVersion();
		}
		bindNavEvent();
		//加载数据
		getDataList(getUrlParam("view"), true);
		initGroup();
	});
	
	function initGroup(){
		$("#moregroupdown .tabitem").bind("click",function(){
			groupid=$(this).attr("_groupid");
			var url=$("#homepage").attr("url")+"&groupid="+groupid;
			window.location.href=url
		});
	}
	
	/**
	 * 获取url参数
	 */
	function getUrlParam(type,pageindex) {
		var sessionkey = $("input[name='sessionkey']").val();
		var module = $("input[name='module']").val();
		var scope = $("input[name='scope']").val();
		var userid = $("input[name='userid']").val();
		var comefrom = $("input[name='comefrom']").val();
		var groupid = $("input[name='groupid']").val();
		var pagesize = config.newListPageSize;
		var paras = "method=getpage&dataType=json&userid="+userid+"&";
		if (type=="more") {
			paras=paras+"operation=getBlogDynamic"; 			  //加载非第一页
		}else if(type=="view") {
		    paras=paras+"operation=viewBlogDynamic";            //加载第一页
		}
		else if(type=="saveBlog")
		    paras=paras+"operation=saveBlog";            //提交微博
		else if(type=="replyBlog")    
		    paras=paras+"operation=saveBlogReply";       //提交评论
		else if(type=="markRead")    
		    paras=paras+"operation=markBlogRead";          //标记已读
		    
		paras =paras+"&sessionkey=" + sessionkey + 
			"&module=" + module + 
			"&scope=" + scope + 
			"&pagesize=" + pagesize + 
			"&comefrom="  + comefrom +
			"&groupid="+groupid+
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
					var groupid = data.groupid;
					
					$("input[name='pageindex']").val(pageindex);
					$("input[name='pagesize']").val(pagesize);
					$("input[name='count']").val(count);
					$("input[name='ishavepre']").val(ishavepre);
					$("input[name='ishavenext']").val(ishavenext);
					$("input[name='pagecount']").val(pagecount);
					$("input[name='groupid']").val(groupid);
					
					//第一次加载时
					if(isFirst){
					     
					    $("#listArea").html(""); 
					    
					    //菜单数字提醒
						var unReadCount=data.menuItemCount[0];
						//var attentionCount=data.menuItemCount.attentionCount;
						var remindCount=data.menuItemCount[1];
						
						$("#unReadCount").html(unReadCount>0?"(<span class='count'>"+unReadCount+"</span>)":"");
						$("#remindCount").html(remindCount>0?"(<span class='count'>"+remindCount+"</span>)":"");
						
					}
					
					var listItemString = "<div id=\"pagecontent_" + pageindex + "\">";
					var currentPageDataCnt = 0;
					var todayIssubmit=data.todayIssubmit;  //今天是否已经提交 
					if(data.discussList.length==0){
					   $("#listArea").append("<div class=\"listitem listitemmore\">没有发表微博</div><div class=\"blankLines\"></div>");
					}
					
					$.each(data.discussList, function (i, item){ 
						currentPageDataCnt++;

						var workdate=item.workdate;
						var discussid=item.id;
						var userid=item.userid;
						var isread=item.isnew;
                        var itemstr="<div class='listitem' workdate='"+workdate+"' discussid='"+discussid+"' userid='"+userid+"' isread='"+isread+"' onmousemove='markRead(this)'>";
                        itemstr=itemstr+getDiscuddItem(item,"0");
                        itemstr=itemstr+" </div><div class='blankLines'></div>";
                        
                        listItemString=listItemString+itemstr;
					});
					
					listItemString += "</div>";
					if (isFirst == true && currentPageDataCnt != 0) {
						
						if (ishavenext == "1") {
							listItemString += "<div class='listitem listitemmore' id='listItemMore'>更多...</div><div class=\"blankLines\"></div>";
						}
						
						$("#listArea").append(listItemString);

						$("#listItemMore").bind("click", function () {
							$("#listItemMore").html("<img src=\"/mobile/plugin/11/images/ajax-loader_wev8.gif\" style=\"vertical-align:middle;\">&nbsp;正在加载...");
							getDataList(getUrlParam("more",parseInt($("input[name='pageindex']").val()) + 1), false);
						});
					} else {
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
    
   //已读标记 
   function markRead(obj){
     var item=$(obj);
     if(item.attr("isread")=="0"){
        item.attr("isread","1");
        var discussid=item.attr("discussid");
        var blogid=item.attr("userid");
        
        var paras=getUrlParam("markRead");
        paras=paras+'&discussid='+discussid+"&blogid="+blogid; 
        util.getData({
    		"paras" : paras,//得数据的URL,
    		"callback" : function (data){
    		    item.find(".img_new").hide();
    		    var count=$("#unReadCount .count").text();
    		    count=count-1;
    		    if(count>0)
    		      $("#unReadCount").html(count>0?"(<span class='count'>"+count+"</span>)":"");
    		    else 
    		      $("#unReadCount").hide();  
    		}
       });
     }
   } 
    
   function getDiscuddItem(item,isCurrentUser){
        
        var today=new Date();
		var todaydate=today.pattern("yyyy-MM-dd");
        var week = {"0" : "周日","1" : "周一","2" : "周二","3" : "周三", "4" : "周四","5" : "周五","6" : "周六"};
        var weekday="";
        
        var discussid=item.id;
        var userid=item.userid;
        var username=item.username;
		var workdate=item.workdate;
		var tempdate=new Date(workdate.replace(/-/g,"/"));
		var workdatetemp=tempdate.pattern("MM月dd日");
		if(workdate==todaydate)
		   weekday="今天";
		else   
		   weekday=week[tempdate.getDay()];
		
		var isCanAppend=(isCurrentUser==1)&&(getDaydiff(todaydate,workdate)<=7);  //是否可以补交
		var isCanEdit=(isCurrentUser==1)&&(getDaydiff(todaydate,createdate)<=3);  //是否可以编辑
		
		var listItemString="";
		    
	    var isReplenish=item.isReplenish;
	    var content=item.content;
	    var createdate=item.createdate
	    var createtime=item.createtime;
	    var createtimetemp=(new Date(createdate.replace(/-/g,"/")+" "+createtime)).pattern("MM月dd日 HH:mm");
	    var imageurl=item.imageurl;
	    var isnew=item.isnew;
	    var comefrom=item.comefrom;
	    var isHasLocation=item.isHasLocation;
		    if(comefrom=="1")  
		        comefrom="(来自Iphone)";
		    else if(comefrom=="2")  
		        comefrom="(来自Ipad)";
		    else if(comefrom=="3")  
		        comefrom="(来自Android)";          
		    else if(comefrom=="4")  
		        comefrom="(来自Web手机版)";
		    else
		        comefrom="";    
	    	
		    if(isHasLocation=="1")
		    	comefrom="<span class='location' onclick='showLocation("+discussid+")'>地图查看</span>&nbsp;&nbsp;"+comefrom;
	    
	    todaydate=today.pattern("yyyy-MM-dd");
	    
	    //回复内容
	    var replaystr="";
		$.each(item.replyVoArray,function(i,replyItem){
		    replaystr=replaystr+getReplyItem(replyItem);
		});
		
		listItemString ="<table class='tblItemTitle' width='100%' height='100%' border='0' cellspacing='0' cellpadding='0'>"
					+"		<tr>"
					+"			<TD class='itempreview' valign='top'>"
					+"				<img src='"+imageurl+"'>"
					+"			</TD>"
					+"			<TD class='itemcontent' valign='top' >"
					+"				<div class='itemcontenttitle'>"
					+"					<table width='100%' height='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed;'>"
					+"						<tr>"
					+"							<TD class='ictwz' valign='top'>"
					+"								<span class='ictwz_gw' onclick='openBlog("+userid+")'>"+username+"</span>"
					+"								<span class='ictwz_img'><IMG src='/mobile/plugin/11/images/blog/"+(isReplenish=="1"?"stateAppend_wev8.png":"stateOk_wev8.png")+"'></span>"
					+"								<span class='ictwz_tm'>"+createtimetemp+"</span>"
					+"								<span class='img_new'><img src='/mobile/plugin/11/images/blog/new_wev8.png'  width='20' style='display:"+(isnew=="0"?"":"none")+"'></span>"
					+"							</TD>"	
					+"						</TR>"
					+"						<TR>"
					+"							<TD class='itemoperation'>"
					+"								"+(isCanEdit?"<div id='appendBtn' onclick='doEdit(this)'>编辑</div>":"")
					+"								<div id='replyBlogBtn' onclick='showReply(this,0)'>评论</div>"
					+"								<div id='priReplyBlogBtn' onclick='showReply(this,1)'>私评</div>"
					+"							</TD>"
					+"						</TR>"
					+"					</TABLE>"
					+"				</div>" 				
					+"			</TD>"
					+"			<TD class='itemnavpoint'></TD>"
					+"		</TR>"
					+"		<TR  style='height:5px;'><TD></TD></TR>"
					+"		<TABLE>"
					+"		<table width='95%' height='100%' border='0' cellspacing='0' cellpadding='0'>"
					+"		<TR>"
					+"			<TD>"
					+"				<div class='itemcontentitdt'>"
					+"                <div class='blogCotent'>"+content+"</div>"
					+"				  <div class='fromBlock' style='clear:both'>"+comefrom+"</div>"
			        +"                <div class='reply'>"+replaystr+"</div>"
					+"				</div>"
					+"			</TD>"
					+"		</TR>"
					+"	</TABLE>"
	
		
					
      return listItemString;
      
    } 
	
	function openBlog(blogid){
	   jQuery(document.body).showLoading(); 
	   window.location.href="viewBlog.jsp?userid=<%=request.getParameter("userid")%>&module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&blogid="+blogid;
	}
	
	function goBack() {
		location = "/home.do";
	}
	
	//打开文档 
    function opendoc1(docid){
   		location = "/mobile/plugin/2/view.jsp?detailid="+docid+"&module=<%=module%>&scope=<%=scope%>";
    }  
   
    //下载文件
    function downloads(fileid,obj,filename){
   		filename=filename?filename:"";
   		location = "/download.do?fileid="+fileid+"&filename="+filename+"&module=<%=module%>&scope=<%=scope%>";
    }
	</script>
	
	<script type="text/javascript">
		var today=new Date();
	
	function bindNavEvent() {
		$(".navbtn").bind("click", function () {
			var tabid=$(this).attr("id");
			if(tabid=="homepage"&&<%=groupCount%>>0){
			   showGroup(this);
			   return;
			}   
			   
			var oldObj = $(".navbtnslt"); 
			oldObj.removeClass("navbtnslt");
			$(this).addClass("navbtnslt");
			var url=$(this).attr("url");
			jQuery(document.body).showLoading();
			window.location.href=url;
		});
	}
	
	 function getReplyItem(replyItem){
	    
	  var replyid=replyItem.id;
	  var replyUserid=replyItem.userid;
	  var replyUsername=replyItem.username;
	  var replyCreatedate=replyItem.createdate;
	  var replyCreatetime=replyItem.createtime;
	  var replyCreatetimetemp=(new Date(replyCreatedate.replace(/-/g,"/")+" "+replyCreatetime)).pattern("MM月dd日 HH:mm");
	  var replyComefrom=replyItem.comefrom;
	  var replyContent=replyItem.content;
	  var commentType=replyItem.commentType;
	  
	  var comefrom=replyItem.comefrom;
	  var comefromtemp="";
	  if(comefrom!="0"||commentType=="1")
	      comefromtemp+="(";
	  if(commentType=="1")
	      comefromtemp+="私评&nbsp;";
	      
	  if(comefrom=="1")  
	    comefromtemp+="来自Iphone";
	  else if(comefrom=="2")  
	    comefromtemp+="来自Ipad";
	  else if(comefrom=="3")  
	    comefromtemp+="来自Android";          
	  else if(comefrom=="4")  
	    comefromtemp+="来自Web手机版";
	        
	   if(comefrom!="0"||commentType=="1")
	      comefromtemp+=")";  
	      
	  
	  //回复内容
	  var replaystr="<div class='commentonblock listitemco'>"
			+"				<table width='100%' height='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed;'>"
			+"					<tr>"
			+"						<TD width='5px'>"
			+"						</TD>"
			+"						<TD class='itemcontentReply'>"
			+"							<div class='itemcontenttitle'>"
			+"								<table width='100%' height='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed;'>"
			+"									<tr>"
			+"										<TD class='ictwz'>"
			+"											<span class='ictwz_gw'>"+replyUsername+"</span>"
			+"											<span class='ictwz_img'><IMG src='/mobile/plugin/11/images/blog/stateRe_wev8.png' style='vertical-align: top;margin-top:1px;'></span>"
			+"											<span class='ictwz_tm'>"+replyCreatetimetemp+"</span>"
			+"										</TD>"
			+"									</TR>"
			+"								</TABLE>"
			+"							</div>"
			+"							<div class='itemcontentitdt'>"
			+"                             <div class='replyContent'>"+replyContent+"</div>"   
	        +"				               <div class='fromBlock' style='clear:both'>"+comefromtemp+"</div>"
	        +"                          </div>"   
			+"						</TD>"
			+"						<TD width='5px'>"
			+"						</TD>"
			+"					</TR>"
			+"				</TABLE>"
			+"				</div>"
			
			return replaystr;
	    
	    }
	  
	 function doAppend(obj){
	 	if($(obj).attr("canClick")=="0")
		      	 return ;
		$(obj).parent().find("#appendBtn").addClass("optdisable");
	 	$(obj).parent().find("#appendBtn").attr("canClick","0");
	 	$(obj).parent().find("#replyBlogBtn").addClass("optdisable");
	 	$(obj).parent().find("#replyBlogBtn").attr("canClick","0");
	 	$(obj).parent().find("#priReplyBlogBtn").addClass("optdisable");
	 	$(obj).parent().find("#priReplyBlogBtn").attr("canClick","0");
		   var item=$(obj).parents(".listitem");
		   if(item.find(".itemReplayBox").length<1){
			   var appendBox="<div class='itemReplayBox'>"
							+" <div class='bloginputblock'>"
							+"		<textarea  style='width:100%;margin-top:5px;height:80px'" 
							+" 			onfocus='this.style.height=\"80px\";if(this.value==\"请输入内容\"){this.style.color=\"#000000\"; this.value=\"\"}' "
							+"			onblur='if(this.value==\"\") {this.style.height=\"80px\"; this.style.color=\"#ACACAC\"; this.value=\"请输入内容\";}' "               
							+"			name='content' id='contentInput'>请输入内容</textarea>"
							+" </div>"
							+" <div class='operationBt' onclick='doSave(this)' action='saveBlog'>保存</div>&nbsp;&nbsp;<div class='operationBt' style='margin-left:8px'  onclick='doCancel(this)'>取消</div>"
							+"</div>"
			   
			   item.find(".itemcontent").append(appendBox);
		   }
		   item.find("textarea[name='content']").focus();
		}  
	    
	  function doCancel(obj){
		    var item=$(obj).parents(".listitem");
		    item.find("#appendBtn").removeClass("optdisable");
	 		item.find("#appendBtn").attr("canClick","1");
	 		item.find("#replyBlogBtn").removeClass("optdisable");
	 		item.find("#replyBlogBtn").attr("canClick","1");
	 		item.find("#priReplyBlogBtn").removeClass("optdisable");
	 		item.find("#priReplyBlogBtn").attr("canClick","1");
		   item.find(".itemcontenttitle").show();
		   item.find(".itemcontentitdt").show();
		   item.find(".itemReplayBox").remove();
		}  
	  function doEdit(obj){
	  		if($(obj).attr("canClick")=="0")
		      	 return ;
			$(obj).parent().find("#appendBtn").addClass("optdisable");
		 	$(obj).parent().find("#appendBtn").attr("canClick","0");
		 	$(obj).parent().find("#replyBlogBtn").addClass("optdisable");
		 	$(obj).parent().find("#replyBlogBtn").attr("canClick","0");
		 	$(obj).parent().find("#priReplyBlogBtn").addClass("optdisable");
		 	$(obj).parent().find("#priReplyBlogBtn").attr("canClick","0");
		   var item=$(obj).parents(".listitem");
		   var content=item.find(".blogCotent").html();
		   content=content.replace(/&nbsp;/g,' ');
		   content=content.replace(/<br>/g, "\n");
		   var contentTemp=$("<div>"+content+"</div>");
		   if(contentTemp.text()!=contentTemp.html()){
		   	  if(item.find(".itemcontentEdit").length<1){
		         asyncbox.open({
		             html:"<div style='color:#2475C8;margin:8px;'>微博内容包含HTML格式<br/>编辑会丢失格式，是否编辑？</div>",
				　　　width : 250,
				　　　height : 150,
				     title : "提示",
				　　　btnsbar : $.btn.OKCANCEL, //按钮栏配置请参考 “辅助函数” 中的 $.btn。
				　　　callback : function(action){
				　　　　　if(action == 'ok'){
				           var editorHeight=item.find(".blogCotent").height();
				           editorHeight=editorHeight>40?editorHeight:40;
				　　　　　　  content=contentTemp.text();
				           content = content.replace(/&/g,"&amp;");
				           //content=content.replace(/&nbsp;/g,' ');
						   //item.find(".itemcontenttitle").hide();
						   item.find(".itemcontentitdt").hide();
						   //item.find(".itemoperation").hide();
						   
						   
						   var editbox="<div class='itemcontentEdit'>"
									   +"	<div class='bloginputblock'>"
									   +"		<textarea style='width:100%;margin-top:5px;height:"+editorHeight+"px' name='content'>"+content+"</textarea>"
									   +"	</div>"
									   +"	<div class='operationBt' onclick='doSave(this)' action='updateBlog'>保存</div>&nbsp;&nbsp;<div class='operationBt' style='margin-left:8px'  onclick='doCancelEdit(this)'>取消</div>"
									   +"</div>";
									   
						   item.find(".itemcontent").append(editbox);
				　　　　　}
				　　　}
				　});
		   	  }
		   	  item.find("textarea").focus();
		      
		   }else{
		       var editorHeight=item.find(".blogCotent").height();
		       editorHeight=editorHeight>40?editorHeight:40;
			   content=contentTemp.text();
			   //item.find(".itemcontenttitle").hide();
			   item.find(".itemcontentitdt").hide();
			   //item.find(".itemoperation").hide();
			   if(item.find(".itemcontentEdit").length<1){
				   var editbox="<div class='itemcontentEdit'>"
							   +"	<div class='bloginputblock'>"
							   +"		<textarea style='width:100%;margin-top:5px;height:"+editorHeight+"px' name='content'>"+content+"</textarea>"
							   +"	</div>"
							   +"	<div class='operationBt' onclick='doSave(this)' action='updateBlog'>保存</div>&nbsp;&nbsp;<div class='operationBt' style='margin-left:8px'  onclick='doCancelEdit(this)'>取消</div>"
							   +"</div>";
							   
				   item.find(".itemcontent").append(editbox);
			   }
			   item.find("textarea").focus();
		  } 
		}  
		
		function doCancelReply(obj){
		    var item=$(obj).parents(".listitem");
		    item.find("#appendBtn").removeClass("optdisable");
	 		item.find("#appendBtn").attr("canClick","1");
	 		item.find("#replyBlogBtn").removeClass("optdisable");
	 		item.find("#replyBlogBtn").attr("canClick","1");
	 		item.find("#priReplyBlogBtn").removeClass("optdisable");
	 		item.find("#priReplyBlogBtn").attr("canClick","1");
		    item.find(".itemcontentReplybox").remove();
		}
	   function doCancelEdit(obj){
		   	var item=$(obj).parents(".listitem");
		   	item.find("#appendBtn").removeClass("optdisable");
	 		item.find("#appendBtn").attr("canClick","1");
	 		item.find("#replyBlogBtn").removeClass("optdisable");
	 		item.find("#replyBlogBtn").attr("canClick","1");
	 		item.find("#priReplyBlogBtn").removeClass("optdisable");
	 		item.find("#priReplyBlogBtn").attr("canClick","1");
		   item.find(".itemcontenttitle").show();
		   item.find(".itemcontentitdt").show();
		   item.find(".itemoperation").show();
		   item.find(".itemcontentEdit").remove();
		}
	    
	    function sendRemind(obj){
	       if($(obj).attr("isRemind")=="true")
	          return ;	   
		   var item=$(obj).parents(".listitem");
		   var workdate=item.attr("workdate");  //工作日  
		   var blogid=item.attr("userid");  
		  
		   var paras=getUrlParam("sendRemind"); 
		   util.getData({
		    	"loadingTarget" : document.body,
	    		"paras" : paras,//得数据的URL,
	    		"datas" :{blogid:blogid,workdate:workdate},
	    		"callback" : function (data){
	    		   $(obj).attr("isRemind","true");
	    		   $(obj).html("已提醒");
	    		   $(obj).css("color","red");
	    		}
	       });		  
		}
	    
	    //计算时间间隔天数
		function  getDaydiff(d1, d2){  
		    var begindateStr=d1.split("-");
			var enddateStr=d2.split("-");
			var begindate,enddate;
			begindate=new Date(begindateStr[0],begindateStr[1]-1,begindateStr[2]);
			enddate=new Date(enddateStr[0],enddateStr[1]-1,enddateStr[2]); 
			var seprator=(begindate-enddate)/1000/60/60/24;
			return seprator;
	    }
		
		function contentActive(obj){
		   var $this=$(obj);
		   if($this.val()=="请输入评论内容"||$this.val()=="请输入内容"){
	          $this.val("");
	          $this.css({"color":"#000000","height":"80px"});               	   
		   }
		}
		
		function contentNormal(obj){
		   var $this=$(obj);
		   if($this.val()==""){
	          $this.val("请输入评论内容");
	          $this.css({"color":"#ACACAC","height":"80px"});              	   
		   }
		}
	    
	    
	 	//时间日期格式化
	    Date.prototype.pattern=function(fmt) {     
		    var o = {     
		    "M+" : this.getMonth()+1, //月份     
		    "d+" : this.getDate(), //日     
		    "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时     
		    "H+" : this.getHours(), //小时     
		    "m+" : this.getMinutes(), //分     
		    "s+" : this.getSeconds(), //秒     
		    "q+" : Math.floor((this.getMonth()+3)/3), //季度     
		    "S" : this.getMilliseconds() //毫秒     
		    };     
		    var week = {     
		    "0" : "\u65e5",     
		    "1" : "\u4e00",     
		    "2" : "\u4e8c",     
		    "3" : "\u4e09",     
		    "4" : "\u56db",     
		    "5" : "\u4e94",     
		    "6" : "\u516d"    
		    };     
		    if(/(y+)/.test(fmt)){     
		        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));     
		    }     
		    if(/(E+)/.test(fmt)){     
		        fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "\u661f\u671f" : "\u5468") : "")+week[this.getDay()+""]);     
		    }     
		    for(var k in o){     
		        if(new RegExp("("+ k +")").test(fmt)){     
		            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));     
		        }     
		    }     
	    return fmt;     
	   }
	   
	   function openUrl(url) {
	   		jQuery(document.body).showLoading();
		   	window.location.href=url;
	   }
	   
	  
	   function showGroup(obj){
			var target="#moregroupdown";
		 	var x=$(obj).offset().left
			var y=$(obj).offset().top
			
		 	$(target).css("top",y+33);
		 	$(target).css("left",x);
		 	$(target).show();
	   }
	
		//阻止事件冒泡
	   function stopEvent() {
			if (event.stopPropagation) { 
				event.stopPropagation();
			}else if (window.event) { 
				window.event.cancelBubble = true; 
			}
		}
		jQuery(".btnGrayDropContent").hover(function(){
			jQuery("#moregroupdown").show();
		},function(){
			jQuery("#moregroupdown").hide();
		})
		jQuery(".btnGrayDropContent  li").hover(function(){
			jQuery(this).css("background-color","#cccccc");
		},function(){
			jQuery(this).css("background-color","#f8f8f8");
		});
		
		jQuery(".btnGrayDropContent .tabitem").click(function(){
			var groupid=jQuery(this).attr("_groupid");
			loadCoworkItemList("attention",groupid);
			jQuery("#moregroupdown").hide();
		});
	   
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
		<input type="hidden" name="groupid" value="<%=groupid%>">
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
		<!-- 当前登陆者id -->
		<input type="hidden" name="userid" value="<%=userid%>">
		<!-- 客户端类型 -->
		<input type="hidden" name="comefrom" value="<%=clienttype%>">
		
		<!-- 存放必须数据区域 END -->
		
		<!-- 微薄顶部导航区域 START -->
		
		<div class="navblock">
			<div class="navbtnblock">
				<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed;color:#395582;">
					<tr>
						<td width="25%" align="center">
							<div id="homepage" style="position: relative;" class="navbtn navbtnslt navbtnleft" url="/mobile/plugin/11/mainPage.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>&clienttype=<%=clienttype%>&opengps=<%=opengps%>">
								主页<span id="unReadCount" style="display: none;"></span><img style="display:<%=groupCount>0?"":"none"%>" src="/blog/images/group_sort_wev8.png"/>
							</div>
						</td>
						<td width="25%" align="center">
							<div class="navbtn navbtncenter" url="/mobile/plugin/11/list.jsp?module=<%=request.getParameter("module")%>&scope=<%=request.getParameter("scope")%>&userid=<%=request.getParameter("userid")%>&clienttype=<%=clienttype%>&opengps=<%=opengps%>">
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
		
		<div id="moregroupdown" class="btnGrayDropContent" style="width: 92px;" >
	 	  <div class="tabitem downitem" _groupid="all">全部微博</div>
		  <%
			for(int i=0; i<groupList.size(); i++)
			{
			Map groupMap=(Map)groupList.get(i);
			String id=(String)groupMap.get("id");
			String groupname=(String)groupMap.get("groupname");
			%>
			<div class="tabitem downitem" _groupid="<%=id%>"><%=groupname%></div>
		  <%} %>	
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
