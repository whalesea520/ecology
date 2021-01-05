
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ctu" class="weaver.task.CommonTransUtil" scope="page" />
<%@ page import="weaver.docs.docs.DocImageManager"%>
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
	<link rel="stylesheet" href="/express/css/base_wev8.css" />
<style type="text/css">
	.task_name{
		width:auto;
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
	.task_font:hover{text-decoration:underline;cursor:pointer;}
	.message_contend	{
			margin-top:15px;
			line-height:28px;
			border-bottom-style:dashed ;
			border-width: 1px;
			border-bottom-color:#d6d7d8;
			margin-left:19px;
			margin-right:19px;
	}
</style>
	<div style="height: 40px;line-height: 38px;"><span style="  color:#666666; font-size:12px; font-weight:600; padding-left:14px;">提醒</span></div>
	<div id="message" class="right_message">
	<%
		rs.executeSql("SELECT tasktype,count(*) AS sum FROM task_msg  WHERE( receiverid = "+ user.getUID() +" and type=1) GROUP BY tasktype  ");
	    int total=0;
	    int tasktotal=0;
	    int wftotal=0;
	    int meetingtotal=0;
	    int doctotal=0;
	    int coworktotal=0;
	    int emailtotal=0;
		while(rs.next()){  
			total=total+rs.getInt("sum");
			int tasktype=rs.getInt("tasktype");
			if(tasktype==1)
				tasktotal=rs.getInt("sum");
			else if(tasktype==2)
				wftotal=rs.getInt("sum");
			else if(tasktype==3)
				meetingtotal=rs.getInt("sum");
			else if(tasktype==4)
				doctotal=rs.getInt("sum");
			else if(tasktype==5)
				coworktotal=rs.getInt("sum");
			else if(tasktype==6)
				emailtotal=rs.getInt("sum");
		}
		%>
		        <div class="right_items" style="margin-left:5px;" _type="0"><div><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>(<span id="total"><%=total%></span>)</div></div>					<!-- 全部 -->
				<div class="right_items" _type="1"><div><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%>(<span class="delremind"  id="tasktotal" _type="1"><%=tasktotal%></span>)</div></div>		<!-- 任务 -->
				<div class="right_items" _type="2"><div><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%>(<span class="delremind" id="wftotal" _type="2"><%=wftotal%></span>)</div></div>			<!-- 流程 -->
				<div class="right_items" _type="3"><div><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%>(<span class="delremind" id="meetingtotal" _type="3"><%=meetingtotal%></span>)</div></div>	<!-- 会议 -->
				<div class="right_items" _type="4"><div><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>(<span class="delremind" id="doctotal" _type="4"><%=doctotal%></span>)</div></div>			<!-- 文档 -->
				<div class="right_items" _type="5"><div><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%>(<span class="delremind" id="coworktotal" _type="5"><%=coworktotal%></span>)</div></div>	<!-- 协作 -->
				<div class="right_items" _type="6"><div><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%>(<span class="delremind" id="emailtotal" _type="6"><%=emailtotal%></span>)</div></div>		<!-- 邮件 -->
	</div>
	
	<%
		rs.executeSql("SELECT * FROM task_msg where receiverid="+user.getUID()+" ORDER BY createdate desc");
	 %>
		<div id="getremark"></div>
	
	 <%if(total == 0){
	 %>
	 	<div style="color: #666666; margin-top: 20px; text-align: center;"><%=SystemEnv.getHtmlLabelName(30645,user.getLanguage())%></div>
	 <%} %>
	<script type="text/javascript" src="/express/js/jquery-1.8.3.min_wev8.js"></script>
	<script type="text/javascript">
	jQuery(document).ready(function(){
		var lan = $("#remindNum",parent.parent.document).html();
		jQuery(".right_items").bind('click',function(){
			jQuery(".right_items_focus").removeClass("right_items_focus");
			jQuery(this).addClass("right_items_focus");
			var taskType = jQuery(this).attr("_type");
			$.post("TaskOperation.jsp",{taskType:taskType,operation:"getRemind"},function(data){
				jQuery("#getremark").html(data);
			});	
		});
		
		jQuery(".right_items").first().addClass("right_items_focus");
		jQuery(".right_items_focus").click();
		
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
	
	
	function delRemind(taskType,id,obj){
		$(obj).find("img").css({"display": "none"});
		$.post("TaskOperation.jsp",{id:id,operation:"delRemind"},function(data){
			if(data == "success"){
				$(".delremind").each(function(){
					if($(this).attr("_type") == taskType){
						var totalNum = $("#total").html();
						var newTotalNum = parseInt(totalNum)-1;
						var num = $(this).html();
						var newNum = parseInt(num)-1;
						if(parseInt(totalNum) == 0){
							newTotalNum =0 ;
						}
						if(parseInt(num) == 0){
							newNum = 0;
						}	
					$("#total").html(newTotalNum);
					$(this).html(newNum);
					var obj = $("#remindNum",parent.parent.document);
					var totalNum = $(obj).html();
					var newTotalNum = parseInt(totalNum) -1;
					if( parseInt(totalNum) == 0){
						newTotalNum = 0;
					}
					$(obj).html(newTotalNum);
		}
		});
	}
	});
	}
</script>
