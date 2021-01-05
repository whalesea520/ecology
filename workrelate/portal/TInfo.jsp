<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	int dept = Util.getIntValue(request.getParameter("dept"));

	
	String tsql1 = "";
	String tsql2 = "";
	String func1 = "";
	if(!rs.getDBType().equals("oracle")){
		tsql1 = " top 1 ";
		tsql2 = "";
		func1 = "isnull";
	}else{
		tsql1 = "";
		tsql2 = " and rownum=1 ";
		func1 = "nvl";
	}
	String userid = user.getUID()+"";
	String sql1 = "select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.creater<>"+userid
			+" and (t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
			+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
			+")"
			+" and not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+")";
		
	String sql2 = "select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"	
			+" and (t1.creater = "+userid+" or t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
			+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
			+")"
			+" and "+func1+"((select "+tsql1+" t3.createdate+' '+t3.createtime from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+" "+tsql2+" order by t3.createdate desc,t3.createtime desc),'')"
			+" > "+func1+"((select "+tsql1+" t2.operatedate+' '+t2.operatetime from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+" "+tsql2+" order by t2.operatedate desc,t2.operatetime desc),'')";
	if(rs.getDBType().equals("oracle")){
		sql2 = "select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"	
				+" and (t1.creater = "+userid+" or t1.principalid = "+userid
				+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
				+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
				+")"
				//+" and "+func1+"((select "+tsql1+" t3.createdate+' '+t3.createtime from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+" "+tsql2+" order by t3.createdate desc,t3.createtime desc),'')"
				//+" > "+func1+"((select "+tsql1+" t2.operatedate+' '+t2.operatetime from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+" "+tsql2+" order by t2.operatedate desc,t2.operatetime desc),'')";
				
				+" and ("+func1+"((select v.datetime from (select CONCAT(CONCAT(t3.createdate,' '),t3.createtime) as datetime,t3.taskid from TM_TaskFeedback t3 where t3.hrmid<>"+userid+" order by t3.createdate desc,t3.createtime desc) v where v.taskid=t1.id and rownum=1),'')"
				+">"+func1+"((select v.datetime from (select CONCAT(CONCAT(t2.operatedate,' '),t2.operatetime) as datetime,t2.taskid from TM_TaskLog t2 where t2.type=0 and t2.operator="+userid+" order by t2.operatedate desc,t2.operatetime desc) v where v.taskid=t1.id and rownum=1),''))";
	}
		
	String currentdate = TimeUtil.getCurrentDateString();		
	String sql3 = "select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
			+" and (t1.creater = "+userid+" or t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))"
			+" and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate<>'1' and tt.userid="+userid+" and tt.tododate<='"+currentdate+"')"
			;
	String sql4 = "select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
			+" and (t1.creater = "+userid+" or t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))"
			+" and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate<>'1' and tt.userid="+userid+" and tt.tododate='"+TimeUtil.dateAdd(currentdate,1)+"')"
			;
	int newcount = 0;
	int fbcount = 0;
	int todaycount = 0;
	int tomorrowcount = 0;
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
	rs.executeSql(sql4);
	if(rs.next()){
		tomorrowcount = rs.getInt(1);
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min.js"></script>
		<style type="text/css">
			html,body{margin: 0px;padding: 0px;}
			*{font-family:微软雅黑;font-size:12px;}
			.datatable{width: 100%;table-layout: fixed;margin-top: 5px;}	
			.datatable td{font-family:微软雅黑;font-size:12px;padding-left: 5px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;line-height: 22px;}
			.datatable td a,.datatable td a:hover,.datatable td a:active,.datatable td a:visited{color: #000 !important;text-decoration: none !important;}
			.nameinput{width: 200px;height:20px;border: 1px #1A8CFF solid;float: left;font-family:微软雅黑;font-size:12px;
				word-wrap:break-word;word-break:break-all;padding-left: 2px;outline:none;margin-right: 5px;background: #fff;
				/**
				border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
				box-shadow:0px 0px 2px #1A8CFF;-moz-box-shadow:0px 0px 2px #1A8CFF;-webkit-box-shadow:0px 0px 2px #1A8CFF;*/}
			.blur_text{font-style: italic;color: #C0C0C0;}
			.btn_save{width: 48px;height: 20px;line-height: 20px;text-align: center;cursor: pointer;float:left;
				background-color: #67B5E9;color:#fff;font-family:微软雅黑;margin-top:1px;
				border: 1px #50A9E4 solid;
				/**border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
				box-shadow:0px 0px 2px #8EC8EE;-moz-box-shadow:0px 0px 2px #8EC8EE;-webkit-box-shadow:0px 0px 2px #8EC8EE;*/}
			.btn_save_hover{background-color: #1F8DD6;}
			
			.drm{width: 80px;height: 24px;float: left;background: #67B5E9;color: #fff;text-align: center;line-height: 24px;border-right: 1px #F5F5F5 dashed;cursor: pointer;}
			.drmn{background: #FF6262;}
			
			.list{width: 100%;height: 220px;overflow: hidden;padding-left: 20px;padding-top: 5px;margin-top: 2px;}
			.list li{margin-left: 5px;line-height: 26px;color: #555555;border-bottom: 1px #F3F3F3 solid;}
			
			.tab1{width: 80px;line-height:26px;text-align:center;float: left;cursor: pointer;border-top:0px #fff solid;font-size: 12px;
				border-right: 1px #EBEBEB solid;font-weight: bold; }
			.tab1_hover{border-top-color: #F9F9F9;background: #F9F9F9;}
			.tab1_click{border-top-color: #3C75D2;background: #F6F6F6;}
			
			.tab2{width: auto;padding-left:4px;padding-right:4px;height:26px;line-height:26px;text-align:left;cursor: pointer;font-size: 12px;color: #999999;
				empty-cells: show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}
			.tab2_hover{color: #8B8B8B;}
			.tab2_click{font-weight: normal;color: #4B6EB8;}
			
			.show{
				SCROLLBAR-DARKSHADOW-COLOR: #EBEBEB;
				SCROLLBAR-ARROW-COLOR: #F7F7F7;
				SCROLLBAR-3DLIGHT-COLOR: #EBEBEB;
				SCROLLBAR-SHADOW-COLOR: #EBEBEB;
				SCROLLBAR-HIGHLIGHT-COLOR: #EBEBEB; 
				SCROLLBAR-FACE-COLOR: #EBEBEB;
				scrollbar-track-color: #F7F7F7;
				overflow-x: hidden; 
				overflow-y: hidden; 
			}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			.nameinput{line-height:20px;}
		</style>
		<![endif]-->
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body>
		<div style="width: 100%;height: 26px;background: #fff;border-bottom: 1px #EBEBEB solid;">
			<div id="tab1_3" class="tab1 tab1_click" _index="3" title="">任务执行</div>
			<div id="tab1_2" class="tab1" _index="2" title="">任务分析</div>
		</div>
		<div id="show2" class="show" style="width: 100%;height: 260px;display: none;">
			<iframe id="reportframe" src="" style="width: 100%;height: 260px;" frameborder="0"></iframe>
		</div>
		
		<div id="show3" class="show" style="width: 100%;height: 260px;">
		<table class="datatable" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td>
					<div class="drm <%if(newcount>0){%>drmn<%}%>" title="<%if(newcount>0){%>您有<%=newcount %>条新到达任务<%}else{%>暂无新到达任务<%}%>">新任务(<%=newcount %>)</div>
					<div class="drm <%if(fbcount>0){%>drmn<%}%>" title="<%if(fbcount>0){%>您有<%=fbcount %>条新反馈任务<%}else{%>暂无新反馈任务<%}%>">新反馈(<%=fbcount %>)</div>
					<div class="drm <%if(todaycount>0){%>drmn<%}%>" title="<%if(todaycount>0){%>您有<%=todaycount %>条标记为今天的任务<%}else{%>暂无标记为今天的任务<%}%>">今天(<%=todaycount %>)</div>
					<div class="drm <%if(tomorrowcount>0){%>drmn<%}%>" style="border-right: 0px;" title="<%if(tomorrowcount>0){%>您有<%=tomorrowcount %>条标记为明天的任务<%}else{%>暂无标记为明天的任务<%}%>">明天(<%=tomorrowcount %>)</div>
				</td>
			</tr>
			<tr>
				<td style="padding-top: 5px;">
					<input id="taskname" class="nameinput blur_text" type="text"/>
					<div id="btn_save" class="btn_save" onclick="saveTask()">保存</div>
				</td>
			</tr>
			<tr>
				<td>
					<%
					
					String searchsql = "select top 6 t1.id,t1.name "
						+",(select "+tsql1+" tlog.operatedate+' '+tlog.operatetime from TM_TaskLog tlog where tlog.taskid=t1.id and tlog.type not in (0,11,12) "+tsql2+" order by tlog.operatedate desc,tlog.operatetime desc) as lastoperatedate"
						+" from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
						+" and (t1.creater = "+userid+" or t1.principalid = "+userid
						+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))"
						+" and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate<>'1' and tt.userid="+userid+" and tt.tododate<='"+currentdate+"')"
						+" order by lastoperatedate desc" ;
					%>
					<ul class="list" onclick="">
					<%
						rs.executeSql(searchsql);
						while(rs.next()){
					%>
						<li title="<%=Util.convertDB2Input((String)rs.getString("name"))%>">
							<a href="javascript:openOperateWindow('/workrelate/task/data/Main.jsp?taskid=<%=rs.getString("id")%>')">
								<%=Util.getMoreStr(Util.convertDB2Input((String)rs.getString("name")), 30, "...") %>
							</a>
						</li>
					<%	} %>
					</ul>
				
				</td>
			</tr>
		</table>
		</div>
		<script type="text/javascript">
			var status = 0;
			var keyword = "快速新建任务";
			$(document).ready(function(){
				$("#btn_save").bind("mouseover",function(){
					$(this).addClass("btn_save_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_save_hover");
				});
				
				$("div.tab1").bind("mouseover",function(){
					$(this).addClass("tab1_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("tab1_hover");
				}).bind("click",function(){
					$("div.tab1").removeClass("tab1_click");
					$(this).addClass("tab1_click");
					var _index = $(this).attr("_index");
					$("div.show").hide();
					$("#show"+_index).show();
					if(_index==1){
						$("td.tab2")[0].click();
					}
					if(_index==2){
						$("#reportframe").attr("src","report/jsp/TReport.jsp");
					}
				});
				
				<%if(dept==1){%>
					$("#tab1_2").click();
				<%}%>
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
				$("#btn_save").html("<img src='/workrelate/task/images/loading3.gif' style='margin-top:2px;'/>");
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
			function openFullWindowHaveBar(url){
				  var redirectUrl = url ;
				  var width = screen.availWidth-10 ;
				  var height = screen.availHeight-50 ;
				  //if (height == 768 ) height -= 75 ;
				  //if (height == 600 ) height -= 60 ;
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
			function openOperateWindow(url){
				//openFullWindowHaveBar(url);
				
				  var redirectUrl = url ;
				  var width = screen.width ;
				  var height = screen.height ;
				  var top = height/2 - 260;
				  //alert(height+'-'+top);
				  var left = width/2 - 455;
				  var width = 910 ;
				  var height = 500 ;
				  var szFeatures = "" ;
				  szFeatures +="top="+top+"," ; 
				  szFeatures +="left="+left+"," ;
				  szFeatures +="width="+width+"," ;
				  szFeatures +="height="+height+"," ;
				  //szFeatures +="directories=no," ;
				  szFeatures +="status=yes,toolbar=no,location=no," ;
				  //szFeatures +="menubar=no," ;
				  szFeatures +="scrollbars=yes," ;
				  szFeatures +="resizable=yes" ; 
				  window.open(redirectUrl,"",szFeatures) ;
				  
			}
		</script>
	</body>
</html>
