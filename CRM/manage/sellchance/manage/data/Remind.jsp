
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String userid = user.getUID()+"";
	String sql1 = "select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"
			+" and (t1.creater = "+userid+" or t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
			+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
			+")"
			+" and not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+")";
		
	String sql2 = "select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"	
			+" and (t1.creater = "+userid+" or t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
			+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
			+")"
			+" and (select top 1 t3.createdate+' '+t3.createtime from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc)"
			+" >(select top 1 t2.operatedate+' '+t2.operatetime from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc)";
	
	String currentdate = TimeUtil.getCurrentDateString();		
	String sql3 = "select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
			+" and (t1.creater = "+userid+" or t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))"
			+" and ((t1.begindate<>'' and t1.begindate is not null and t1.enddate<>'' and t1.enddate is not null and t1.begindate<='"+currentdate+"' and t1.enddate>='"+currentdate+"')"
			+" or (t1.begindate<>'' and t1.begindate is not null and (t1.enddate='' or t1.enddate is null) and t1.begindate<='"+currentdate+"')"
			+" or (t1.enddate<>'' and t1.enddate is not null and (t1.begindate='' or t1.begindate is null) and t1.enddate>='"+currentdate+"'))";
	int newcount = 0;
	int fbcount = 0;
	int todaycount = 0;
	rs.executeSql(sql1);
	if(rs.next()){
		newcount = rs.getInt(1);
	}
	rs.executeSql(sql2);
	if(rs.next()){
		fbcount = rs.getInt(1);
	}
	rs.executeSql(sql3);
	if(rs.next()){
		todaycount = rs.getInt(1);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min_wev8.js"></script>
		<style type="text/css">
			html,body{margin: 0px;padding: 0px;}
			.datatable{width: 100%;table-layout: fixed;}	
			.datatable td{font-family:微软雅黑;font-size:12px;padding-left: 5px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;line-height: 22px;}
			.datatable td a,.datatable td a:hover,.datatable td a:active,.datatable td a:visited{color: #000 !important;text-decoration: none !important;}
			.nameinput{width: 200px;height:20px;border: 1px #1A8CFF solid;float: left;font-family:微软雅黑;font-size:12px;
				word-wrap:break-word;word-break:break-all;padding-left: 2px;outline:none;margin-right: 5px;
				border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
				background: #fff;box-shadow:0px 0px 2px #1A8CFF;-moz-box-shadow:0px 0px 2px #1A8CFF;-webkit-box-shadow:0px 0px 2px #1A8CFF;}
			.blur_text{font-style: italic;color: #C0C0C0;}
			.btn_save{width: 48px;height: 20px;line-height: 20px;text-align: center;cursor: pointer;float:left;
				background-color: #67B5E9;color:#fff;font-family:微软雅黑;margin-top:1px;
				border: 1px #50A9E4 solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
				box-shadow:0px 0px 2px #8EC8EE;-moz-box-shadow:0px 0px 2px #8EC8EE;-webkit-box-shadow:0px 0px 2px #8EC8EE;}
			.btn_save_hover{background-color: #1F8DD6;}
			
			.drm{width: 67px;height: 24px;float: left;background: #67B5E9;color: #fff;text-align: center;line-height: 24px;border-right: 1px #F5F5F5 dashed;cursor: pointer;}
			.drmn{background: #FF6262;}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			.nameinput{line-height:20px;}
		</style>
		<![endif]-->
	</head>
	<body>
		<table class="datatable" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<div class="drm <%if(newcount>0){%>drmn<%}%>" title="<%if(newcount>0){%>您有<%=newcount %>条新到达任务<%}else{%>暂无新到达任务<%}%>">新任务(<%=newcount %>)</div>
					<div class="drm <%if(fbcount>0){%>drmn<%}%>" title="<%if(fbcount>0){%>您有<%=fbcount %>条新反馈任务<%}else{%>暂无新反馈任务<%}%>">新反馈(<%=fbcount %>)</div>
					<div class="drm <%if(todaycount>0){%>drmn<%}%>" style="border-right: 0px;" title="<%if(todaycount>0){%>您今天有<%=todaycount %>条进行中任务<%}else{%>今天暂无进行中任务<%}%>">今天(<%=todaycount %>)</div>
				</td>
			</tr>
			<tr>
				<td style="padding-top: 5px;">
					<input id="taskname" class="nameinput blur_text" type="text"/>
					<div id="btn_save" class="btn_save" onclick="saveTask()">保存</div>
				</td>
			</tr>
		</table>
		<script type="text/javascript">
			var status = 0;
			var keyword = "快速新建任务";
			$(document).ready(function(){
				$("#btn_save").bind("mouseover",function(){
					$(this).addClass("btn_save_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_save_hover");
				});
			});
		  	$("#taskname").val(keyword).bind("focus",function(){
				if(this.value == keyword){
					this.value = "";
					$(this).removeClass("blur_text");
				}
			}).bind("blur",function(){
				if(this.value == ""){
					this.value = keyword;
					$(this).addClass("blur_text");
				}
			});
			$("div.drm").bind("click",function(){
				openMain('/workrelate/task/data/Main.jsp');
			});
		  	document.onkeydown=keyListener;
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){
			    	var target=$.event.fix(e).target;
					if($(target).attr("id")=="taskname"){
						saveTask();
					}			    	 
			    }    
			}
			function saveTask(){
				if(status==1) return;
				if($("#taskname").val()=="" || $("#taskname").val()==keyword){
					alert("请填写新任务名称!");
					return;
				}
				status = 1;
				$("#btn_save").html("<img src='/workrelate/task/images/loading3_wev8.gif' style='margin-top:2px;'/>");
				$.ajax({
					type: "post",
				    url: "/workrelate/task/data/Operation.jsp",
				    data:{"operation":"add","taskName":encodeURI($("#taskname").val())}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    alert("保存成功");
					    $("#btn_save").html("保存");
					    $("#taskname").val(keyword).addClass("blur_text").blur();
					    status = 0;
				    }
				});
			}
			function openMain(url){
				  var redirectUrl = url ;
				  var width = screen.availWidth-10 ;
				  var height = screen.availHeight-50 ;
				  var szFeatures = "top=0," ;
				  szFeatures +="left=0," ;
				  szFeatures +="width="+width+"," ;
				  szFeatures +="height="+height+"," ;
				  szFeatures +="directories=no," ;
				  szFeatures +="status=yes,toolbar=no,location=no," ;
				  szFeatures +="menubar=no," ;
				  szFeatures +="scrollbars=yes," ;
				  szFeatures +="resizable=yes" ; //channelmode
				  window.open(redirectUrl,"",szFeatures) ;
			}
		</script>
	</body>
</html>
