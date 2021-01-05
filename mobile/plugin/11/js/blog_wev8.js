    function getDiscuddItem(item,isCurrentUser){
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
		
		var isCanAppend=(isCurrentUser==userid)&&(getDaydiff(todaydate,workdate)<=7);  //是否可以补交
		
		var isCanRemind=(isCurrentUser!=userid)&&(getDaydiff(todaydate,workdate)<=7);  //是否可以提醒
		
		var listItemString="";
		
		if(discussid!=""){
		    var isReplenish=item.isReplenish;
		    var content=item.content;
		    var createdate=item.createdate
		    var createtime=item.createtime;
		    var createtimetemp=(new Date(createdate.replace(/-/g,"/"))).pattern("MM月dd日");
		    var comefrom=item.comefrom;
		   
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
		        
		    todaydate=today.pattern("yyyy-MM-dd");
		    var isCanEdit=(isCurrentUser==userid)&&(getDaydiff(todaydate,createdate)<=3);  //是否可以编辑
		    //回复内容
		    var replaystr="";
			$.each(item.replyVoArray,function(i,replyItem){  
			    replaystr=replaystr+getReplyItem(replyItem);
			});
		
			listItemString ="<table class='tblItemTitle' width='100%' height='100%' border='0' cellspacing='0' cellpadding='0'>"
					+"		<tr>"
					+"			<TD class='itempreview' valign='top'>"
					+"				<div class='dateblock'>"
					+"					<div class='weekdspblock'>"+weekday+"</div>"
					+"					<div class='captdtblock'>"+workdatetemp+"</div>"
					+"				</div>"
					+"			</TD>"
					+"			<TD class='itemcontent' valign='top' >"
					+"				<div class='itemcontenttitle'>"
					+"					<table width='100%' height='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed;'>"
					+"						<tr>"
					+"							<TD class='ictwz' valign='top'>"
					+"								<span class='ictwz_gw' onclick='openBlog("+userid+")'>"+username+"</span>"
					+"								<span class='ictwz_img'><IMG src='/mobile/plugin/11/images/blog/"+(isReplenish=="1"?"stateAppend_wev8.png":"stateOk_wev8.png")+"'></span>"
					+"								<span class='ictwz_tm'>"+createtimetemp+"</span>"
					+"							</TD>"	
					+"						</TR>"
					+"						<TR>"
					+"							<TD class='itemoperation'>"
					+"								"+(isCanEdit?"<div onclick='doEdit(this)'>编辑</div>":"")
					+"								<div onclick='showReply(this,0)'>评论</div>"
					+"								<div onclick='showReply(this,1)'>私评</div>"
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
					
	}else {
	      //回复内容
		  var replaystr="";
		  $.each(item.replyVoArray,function(i,replyItem){  
			    replaystr=replaystr+getReplyItem(replyItem);
		  });
		  
		  listItemString ="<table class='tblItemTitle' width='100%' height='100%' border='0' cellspacing='0' cellpadding='0'>"
					+"		<tr>"
					+"			<TD class='itempreview' valign='top'>"
					+"				<div class='dateblock'>"
					+"					<div class='weekdspblock'>"+weekday+"</div>"
					+"					<div class='captdtblock'>"+workdatetemp+"</div>"
					+"				</div>"
					+"			</TD>"
					+"			<TD class='itemcontent' valign='top' >"
					+"				<div class='itemcontenttitle'>"
					+"					<table width='100%' height='100%' border='0' cellspacing='0' cellpadding='0' style='table-layout:fixed;'>"
					+"						<tr>"
					+"							<TD class='ictwz' valign='top'>"
					+"								<span class='ictwz_gw' onclick='openBlog("+userid+")'>"+username+"</span>"
					+"								<span class='ictwz_img'><IMG src='/mobile/plugin/11/images/blog/stateNo_wev8.png'></span>"
					+"								<span class='ictwz_tm'>未提交</span>"
					+"							</TD>"	
					+"						</TR>"
					+"						<TR>"
					+"							<TD class='itemoperation'>"
					+"								"+(isCanAppend?"<div onclick='doAppend(this)'>"+(todaydate==workdate?"提交":"补交")+"</div>":"")+
													(isCanRemind?"<div onclick='sendRemind(this)'>提醒</div>":"")+
													"<div onclick='showReply(this,0)'>评论</div>"+
													"<div onclick='showReply(this,1)'>私评</div>"
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
					+"                <div class='blogCotent'></div>"
			        +"                <div class='reply'>"+replaystr+"</div>"
			        +"				  <div class='fromBlock' style='clear:both'></div>"
					+"				</div>"
					+"			</TD>"
					+"		</TR>"
					+"	</TABLE>"					
	
	}
      return listItemString;
      
    }
    //保存工作微博
	function doSave(obj){
      var item=$(obj).parents(".listitem");	
	  item.find(".itemcontenttitle").show();
	  item.find(".itemcontentitdt").show();
	  item.find(".itemoperation").show();
	  item.find(".itemcontentEdit").hide();
      var action=$(obj).attr("action");
      var isToday=item.attr("isToday");   //是否为今天提交
      var workdate=item.attr("workdate"); //工作日
      var content=item.find("textarea[name='content']").val(); //微博或评论内容
      var discussid=item.attr("discussid"); //微博记录id
      var blogid=item.attr("userid");      //被评论人id
      var commentType=0;
      var relatedid=0;
      if(action=="replyBlog"){
          commentType=$(obj).attr("commentType");
          relatedid=$(obj).attr("relatedid");
      }
      var contentVer = content.replace(/ /g,"");
      contentVer = contentVer.replace(/\n/g,"");
      content = content.replace(/&/g,"&amp;"); 
      content = content.replace(/</g,"&lt;");
      content = content.replace(/>/g,"&gt;");
      content = content.replace(/\n/g,"<br/>");
      content = content.replace(/ /g,'&nbsp;');   //避免空字符产生???问题
      if(contentVer==""||content==""||content=="请输入评论内容"||content=="请输入内容"){
      	item.find(".itemcontentEdit").remove();
      	item.find("textarea[name='content']").css({height:'40px',color:'#ACACAC'});
      	if(action=="replyBlog"){
	    	item.find("textarea[name='content']").val("请输入评论内容");
      	}else {
      		item.find("textarea[name='content']").val("请输入内容");
      	}
         asyncbox.open({
	             html:"<div style='color:#2475C8;margin:8px;'>请输入内容</div>",
			　　　width : 250,
			　　　height : 150,
			     title : "提示",
			　　　btnsbar :  $.btn.OK , 
			　　　callback : function(action){}
		  });
      }else{
	      var paras="";
	      var datas="";
	      if(action=="saveBlog"){    //提交或补交微博
	         paras=getUrlParam("saveBlog");
	      }else if(action=="replyBlog"){     //评论微博 
	         paras=getUrlParam("replyBlog");
	      }else if(action=="updateBlog"){
	         paras=getUrlParam("updateBlog");
	      }
	      var todayItem=$(".listitem[isTodayItem=true]");
	      var unsubmit=todayItem.attr("unsubmit");
	      if(isToday=="true"&&todayItem.length==1&&unsubmit!="true")
	         content="<br>"+content;
	      content = encodeURIComponent(content);
	      //content=decodeURIComponent(content);
	      if($(obj).attr("issubmit")=="1") //防止重复提交
	      	 return ;
	      $(obj).addClass("optdisable");   //提交状态置灰button
	      $(obj).attr("issubmit","1");     //设置为提交状态
	      
	      util.getData({
		    	"loadingTarget" : document.body,
	    		"paras" : paras,//得数据的URL,
	    		"datas" : {workdate:workdate,content:content,discussid:discussid,blogid:blogid,commentType:commentType,relatedid:relatedid},
	    		"callback" : function (data){
	    		  if(action=="saveBlog"){
	    		    if(isToday=="true"){
	    		      if(todayItem.length==0){
		    		      var itemstr="<div class='listitem' onclick='javascript:showItemDetailed();' workdate='"+workdate+"' discussid='"+data.discussItem.id+"' userid='"+blogid+"' isTodayItem='true'>";
	                          itemstr=itemstr+getDiscuddItem(data.discussItem,blogid);
	                          itemstr=itemstr+" </div>";
		    		      	  item.after(itemstr);
	    		      }else{
	    		          if(unsubmit=="true"){
	    		             var itemstr=getDiscuddItem(data.discussItem,blogid);
	    		             todayItem.html(itemstr);
	    		             todayItem.attr("unsubmit","false");
	    		             todayItem.attr("discussid",data.discussItem.id);
	    		          }
	    		          todayItem.find(".blogCotent").append(decodeURIComponent(content));
	    		      }    
	    		      item.find("textarea[name='content']").css({height:'40px',color:'#ACACAC'});
	    		      item.find("textarea[name='content']").val("请输入内容");
	    		    }else{
	    		       var itemstr=getDiscuddItem(data.discussItem,blogid);
	    		       item.html(itemstr);
	    		       item.attr("unsubmit","false");
	    		       item.attr("discussid",data.discussItem.id);
	    		    }   
	    		  }else if(action=="replyBlog"){
	    		    item.find(".itemcontentReplybox").remove();
	    		    var itemstr=getReplyItem(data.replyItem);
	    		    var replyItem=item.find(".reply");
	    		    replyItem.append(itemstr);
	    		  }else if(action=="updateBlog"){
	    		    item.find(".itemcontenttitle").show();
					item.find(".itemcontentitdt").show();
					item.find(".blogCotent").html(decodeURIComponent(content));
					item.find(".itemcontentEdit").remove();
	    		  } 
	    		  
	    		  //回复button状态
	    		  $(obj).removeClass("optdisable");
	    		  $(obj).attr("issubmit","0");
	    		  
	    		}
	       });	
      } 	
	}



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
	   var item=$(obj).parents(".listitem");
	   if(item.find(".itemReplayBox").length<1){                            
		   var appendBox="<div class='itemReplayBox'>"
						+" <div class='bloginputblock'>"
						+"		<textarea  style='width:100%;margin-top:5px;height:80px'" 
						+" 			onfocus='this.style.height=\"80px\";if(this.value==\"请输入内容\"){this.style.color=\"#000000\"; this.value=\"\"}' "
						+"			onblur='if(this.value==\"\") {this.style.height=\"40px\"; this.style.color=\"#ACACAC\"; this.value=\"请输入内容\";}' "               
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
	   item.find(".itemcontenttitle").show();
	   item.find(".itemcontentitdt").show();
	   item.find(".itemReplayBox").remove();
	}  
  function doEdit(obj){
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
  function showReply(obj,commentType){
	   var item=$(obj).parents(".listitem");
	   if(item.find(".itemcontentReplybox").length<1){
		   var replybox="<div class='itemcontentReplybox'>"
					   +"	<div class='bloginputblock'>"
					   +"		<textarea style='width:90%;margin-top:5px;color:#ACACAC;hieght:80px' name='content' onfocus='contentActive(this)' onblur='contentNormal(this)'>请输入评论内容</textarea>"
					   +"	</div>"
					   +"	<div class='operationBt' onclick='doSave(this)' commentType='"+commentType+"' relatedid='0' action='replyBlog'>评论</div>&nbsp;&nbsp;<div class='operationBt' style='margin-left:8px'  onclick='doCancelReply(this)'>取消</div>"
					   +"</div>";
		   item.find(".reply").append(replybox);
	   }		   
	   item.find("textarea[name='content']").focus();
	}
	
	function doCancelReply(obj){
	   var item=$(obj).parents(".listitem");
	   item.find(".itemcontentReplybox").remove();
	}
   function doCancelEdit(obj){
	   var item=$(obj).parents(".listitem");
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
          $this.css({"color":"#ACACAC","height":"40px"});              	   
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