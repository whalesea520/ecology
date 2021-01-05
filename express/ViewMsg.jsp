
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@page import="java.text.MessageFormat"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.docs.docs.DocImageManager"%>
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo"></jsp:useBean>
<html>
<head>
<script type="text/javascript" src="/express/js/jquery-1.8.3.min_wev8.js"></script>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
<link rel="stylesheet" href="/express/css/base_wev8.css" />
<style type="text/css">
	.task_name{
		clear:both;
		float:left;
		margin-left:19px;
		margin-bottom:8px;
	}
	.task_time{
		float:right;
		color:#666666;
		font-size:12px;
	}
	.task_font{
		margin-left:10px;
		float:left;
		width:290px;
		color:#2C70D7;
		font-size:12px;
		white-space:nowrap;  
    	text-overflow:ellipsis;  
    	-o-text-overflow:ellipsis;  
    	overflow: hidden;  
	}
	.message_contend	{
			clear:both;
			height:40px;
			margin-top:15px;
			line-height:28px;
			border-bottom-style:dashed ;
			border-width: 1px;
			border-bottom-color:#d6d7d8;
			margin-left:19px;
			margin-right:19px;
	}
	.task_font:hover{
		cursor: pointer;
		text-decoration:underline;
	}
</style>
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery(".right_items").first().addClass("right_items_focus");
		jQuery(".right_items").bind('click',function(){
			jQuery(".right_items_focus").removeClass("right_items_focus");
			jQuery(this).addClass("right_items_focus");
			var type = $(this).attr("_type");
			if(type == "1"){
				$("#blogRemind").css({display:'none'});
				$("#remindItem").css({display:'block'});
				$.post("TaskOperation.jsp",{operation:"getAttention"},function(data){
					jQuery("#remindItem").html(data);
			});	
			}
			if(type=="0"){
				$("#remindItem").css({display:'none'});
				$("#blogRemind").css({display:'block'});
			}
			
		});
		
		$(".task_font").live("click",function(){
			var taskId = $(this).attr("taskid");
			var taskType = $(this).attr("tasktype");
			openTask(taskId,taskType);
		});
		
		
	
	});
	
	function openTask(taskid,tasktype){
	   var url="";
	   if(tasktype=="1")      //任务
	       url="/express/task/data/DetailView.jsp?taskid="+taskid;
	   else if(tasktype=="2") //流程
	       url="/workflow/request/ViewRequest.jsp?requestid="+taskid+"&isovertime=0"; 
	   else if(tasktype=="4") //文档
	       url="/docs/docs/DocDsp.jsp?fromFlowDoc=&blnOsp=false&topage=&pstate=sub&id="+taskid;
	   else if(tasktype=="5") //协作
	       url="/cowork/viewCowork.jsp?id="+taskid;   
	   else if(tasktype=="7")
	       url="/blog/viewBlog.jsp?blogid="+taskid;  
	   openFullWindowHaveBar(url);        
	}
	
	
	function delRemind(tasktype,id,obj){
		$(obj).find("img").css({"display": "none"});
		$.post("TaskOperation.jsp",{id:id,operation:"delRemind"},function(data){
			if(data == "success"){
				var num = $("#task_msg").html();
				$("#task_msg").html(parseInt(num)-1);
				
				var obj = $("#megNum",parent.parent.document);
				var totalNum = $(obj).html();
				var newTotalNum = parseInt(totalNum) -1;
				if( parseInt(totalNum) == 0){
					newTotalNum = 0;
				}
				$(obj).html(newTotalNum);
		}
	});
	}
</script>
</head>

<body>
	<div  style="height: 40px;line-height: 38px; "><span style=" color:#666666; font-size:12px; font-weight:600; padding-left:14px; "><%=SystemEnv.getHtmlLabelName(24532,user.getLanguage())%></span></div>	<!-- 消息 -->
	<div id="message" class="right_message">
	<%
		String userid=""+user.getUID();
		BlogDao blogDao = new BlogDao();
		SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
		SimpleDateFormat dateFormat2=new SimpleDateFormat("M月d日");
		List remindList=blogDao.getMsgRemidList(user,"remind",""); 
		Map count=blogDao.getReindCount(user); 
	  	int remindCount=((Integer)count.get("remindCount")).intValue();           //提醒未查看数
	%>
				<div class="right_items" style="margin-left:5px;" _type="0"><div><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())%>(<span id="blog_msg"><%=remindCount %></span>)</div></div><!-- 微博 -->
		<%
			rs.executeSql("select count(*) from task_msg WHERE receiverid="+userid+" AND (type = 2 OR type=3)");
			int taskCount = 0;
			while(rs.next()){
				taskCount = rs.getInt(1);
			}
		%>
			<div class="right_items" _type="1"><div><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>(<span id="task_msg"><%=taskCount%></span>)</div></div>	<!-- 任务 -->
	</div>
	
	 <%if(remindList.size()>0){ %>
 <div id="blogRemind" style="text-align: left; padding-left: 20px; padding-top: 10px;" class="msgContainer">
 <%
 for(int i=0;i<remindList.size();i++){ 
    Map map=(Map)remindList.get(i);
    
    String id=(String)map.get("id");
    String remindType=(String)map.get("remindType");
    String remindid=(String)map.get("remindid");
    String relatedid=(String)map.get("relatedid");
    String remindValue=(String)map.get("remindValue");
 %>
   <div id="msg_<%=id%>" class="msg" style="width: 95%;border-bottom: #D6D7D8 1px dashed;margin-bottom: 8px;clear: both;height: 22px;background: url('images/remind_wev8.gif') no-repeat;padding-left: 20px;">
     <div style="text-align: left; float: left; padding-left: 5px;width:100%">
      <%if(remindType.equals("1")) { %>
           <div style="text-decoration: none;float: left;">
			  <FONT class=font><FONT class=font><%=ResourceComInfo.getLastname(relatedid) %>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(26988,user.getLanguage())%></FONT></FONT><!-- 向你申请关注 -->
		   </div>
		   <div style="float: right;">
		       <a  style="margin-right: 8px;color: #1d76a4;text-decoration: none;" href="javascript:dealRequest(<%=relatedid%>,<%=id%>,'<%=ResourceComInfo.getLastname(relatedid) %>',-1)"><%=SystemEnv.getHtmlLabelName(25659,user.getLanguage())%></a> <!-- 拒绝 -->
		       <a  style="margin-right: 8px;color: #1d76a4;text-decoration: none;" href="javascript:dealRequest(<%=relatedid%>,<%=id%>,'<%=ResourceComInfo.getLastname(relatedid) %>',1)"><%=SystemEnv.getHtmlLabelName(18186,user.getLanguage())%></a> <!-- 同意 -->
		   </div>
      <%}else if(remindType.equals("2")) {%>
         <!-- 关注申请 -->
         <div><a href="viewBlog.jsp?blogid=<%=relatedid%>" target="_blank" style="margin-right: 3px"><%=ResourceComInfo.getLastname(relatedid)%></a>&nbsp;<%=SystemEnv.getHtmlLabelName(26989,user.getLanguage())%></div><!-- 接受了你的关注请求 -->
       <%}else if(remindType.equals("3")){%>
         <!-- 关注申请拒绝 -->
         <div><a href="viewBlog.jsp?blogid=<%=relatedid%>" target="_blank" style="margin-right: 3px"><%=ResourceComInfo.getLastname(relatedid)%></a>&nbsp;<%=SystemEnv.getHtmlLabelName(26991,user.getLanguage())%></div>  <!-- 拒绝了你的关注请求 -->
       <%}else if(remindType.equals("8")){
    	   Object object[]=new Object[1];
		   object[0]="&nbsp;<span style='color: #1d76a4;font-weight: bold;'>"+remindValue+"</span>&nbsp;";
    	   String message = MessageFormat.format(SystemEnv.getHtmlLabelName(26995,user.getLanguage()),object);
       %>
         <!-- 微博未提交系统提醒 -->
         <div><%=message %></div>
       <%}else if(remindType.equals("6")){
    	  BlogDiscessVo discessVo=blogDao.getDiscussVo(remindValue);   
    	  if(discessVo==null) continue;
    	  String content=discessVo.getContent();
          String contentHtml=content.replaceAll("<[^>].*?>","");
          String workdate=dateFormat2.format(dateFormat1.parse(discessVo.getWorkdate()));
          Object object[]=new Object[1];
		  object[0]="&nbsp;<span style='color: #1d76a4;font-weight: bold;'>"+workdate+"</span>&nbsp;";
          String message = MessageFormat.format(SystemEnv.getHtmlLabelName(26993,user.getLanguage()),object);
    	%>
    	<!-- 微博提交提醒 -->
         <div>
         <a href="viewBlog.jsp?blogid=<%=relatedid%>" target="_blank" style="margin-right: 3px"><%=ResourceComInfo.getLastname(relatedid)%></a>&nbsp;&nbsp;<%=message%></div>&nbsp;&nbsp;
         <div style="padding-left:5px;padding-right:5px">&nbsp;&nbsp;
              <a href="viewBlog.jsp?blogid=<%=relatedid%>" style="">
	              <%
	                    	   out.println(content); 
	             %>
	          </a>
         </div>
       <%}else if(remindType.equals("7")){
    	    remindValue=dateFormat2.format(dateFormat1.parseObject(remindValue));
    	    Object object[]=new Object[1];
  		    object[0]="&nbsp;<span style='color: #1d76a4;font-weight: bold;'>"+remindValue+"</span>&nbsp;";
			String message = MessageFormat.format(SystemEnv.getHtmlLabelName(26994,user.getLanguage()),object);
       %>
         <!-- 微博未提交提交提醒 -->
         <div><a href="viewBlog.jsp?blogid=<%=relatedid%>" target="_blank" style="margin-right: 3px"><%=ResourceComInfo.getLastname(relatedid)%></a><%=message%></div>
       <%} %>
     </div>
   </div>  
   <%} %>
 </div>   
 <script>
   jQuery("#remindcount").hide();
   
   function dealRequest(sender,requestid,name,status){
     if(status==-1){
	     if(window.confirm("<%=SystemEnv.getHtmlLabelName(16631,user.getLanguage())+SystemEnv.getHtmlLabelName(25659,user.getLanguage())%>\“"+name+"\”<%=SystemEnv.getHtmlLabelName(129,user.getLanguage())%>")){  //确认拒绝申请  
	        jQuery.post("/blog/blogOperation.jsp?operation=dealRequest&sender="+sender+"&requestid="+requestid+"&status="+status);
	        jQuery("#msg_"+requestid).remove();
	        if(jQuery(".msg").length==0)
	           jQuery(".msgContainer").append("<div class='norecord'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%></div>");
	     }
	 }else {
	    if(window.confirm("<%=SystemEnv.getHtmlLabelName(16631,user.getLanguage())+SystemEnv.getHtmlLabelName(18186,user.getLanguage())%>\“"+name+"\”<%=SystemEnv.getHtmlLabelName(129,user.getLanguage())%>?")){ //确认同意申请
	        jQuery.post("/blog/blogOperation.jsp?operation=&sender="+sender+"&requestid="+requestid+"&status="+status);
	        jQuery("#msg_"+requestid).remove();
	        if(jQuery(".msg").length==0)
	           jQuery(".msgContainer").append("<div class='norecord'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%></div>");
	    } 
	 }
  }
   
 </script>
 <%
 
 
   //删除已经查看的提醒
   String sql="delete from blog_remind where remindid="+userid+" and (remindType=2 or remindType=3 or remindType=7 )";
 	rs.execute(sql);
   //更新系统未提交提醒状态
   sql="update blog_remind set status=-1  where remindid="+userid+" and remindType=8";
   rs.execute(sql);
   sql="update blog_remind set status=1  where remindid="+userid+" and remindType=1";
   rs.execute(sql);
 }
 %>
	
	<%if(remindCount==0&&taskCount==0){
	%>
		<div style="color: #666666; margin-top: 20px; text-align: center;"></div>
	<%	
	} %>
	<div id="getAtten">
		<div id="remindItem" style="OVERFLOW-Y: auto; OVERFLOW-X:hidden;"></div>
	</div>
</body>
</html>