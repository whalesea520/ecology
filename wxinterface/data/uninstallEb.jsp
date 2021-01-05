<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TransUtil" class="weaver.wxinterface.TransUtil" scope="page" />
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	if(user.getUID()!=1){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<HTML>
	<head>
		<title>卸载云桥</title>
		<script type='text/javascript' src="../js/jquery-1.8.3.min.js"></script>
		<style>
			*,html{
				font-family:"微软雅黑";
				color:#666;
				font-size:12px;
			}
			a{
				text-decoration:none;
				color:blue;
			}
			.title{
				font-size:16px;
				color:#666;
				padding-left:10px;
				heihgt:36px;
				line-height:36px;
				background:#f5f5f5;
				border-bottom:1px solid #dddddd;
			}
			.center{
				position:absolute;
				left:20px;
				right:20px;
				top:10px;
				bottom:10px;
				border:1px solid #ececec;
				overflow:hidden;
			}
			.btn{
				width:120px;
				height:36px;
				line-height:36px;
				background:#608ed9;
				color:#fff;
				text-align:center;
				cursor: pointer;
				position:absolute;
				right:20px;
				top:40px;
				border-radius:10px;
			}
			.deal{
				background:#878d97;
			}
			.finish{
				background:#4adc47;
			}
			.part{
				margin:20px;
			}
			.title2{
				height:30px;
				line-height:30px;
				text-align: center;
				background:#f5f5f5;
				color:#333;
				font-weight:bold;
				border:1px solid #dddddd;
			}
			.part table{
				width:100%;
				border:0;
			}
			.part table td{
				height:30px;
				line-height:30px;
				padding-left:10px;
				color:#333;
				border-right:1px solid #ddd;
				border-bottom:1px solid #ddd;
			}
			.part table th{
				height:30px;
				line-height:30px;
				padding-left:10px;
				color:#666;
				border-bottom:1px solid #ddd;
				border-right:1px solid #ddd;
				border-left:1px solid #ddd;
				font-weight:normal;
			}
			tr.head td{
				font-weight: bold;
				background: #F3F3F3;
				text-align:center;
			}
			.tips{
				text-align:center;
				height:50px;
				line-height:50px;
				font-style: italic;
				font-weight: bold;
				font-size:20px;
				margin-top:20px;
			}
		</style>
		<script>
			var ifdeal = false;
			$(document).ready(function(){
				$(".btn").click(function(){
					if(!ifdeal){
						if(confirm("所有的推送设置都会被删除,确定卸载云桥相关配置?")){
							ifdeal = true;
							$(this).addClass("deal").html("正在卸载...");
							$.ajax({
								url:"unebOperation.jsp?operation=uninstall",
								type:"post",
								dataType:"json",
								success:function(data){
									if(data.status == 0){
										$(".btn").addClass("finish").html("卸载完毕");
										location.href="uninstallEb.jsp"
									}else{
										alert(data.msg);
									}
								}
							});
						}
					}
				});
			});
		</script>
	</head>
	<body>
		<% 
			rs.executeSql("select * from wx_basesetting");
			String wxsysurl = "",accesstoken="",outsysid="",userkeytype="",uuid = ""; 
			if(rs.next()){
				wxsysurl = Util.null2String(rs.getString("wxsysurl"));
				accesstoken = Util.null2String(rs.getString("accesstoken"));
				outsysid = Util.null2String(rs.getString("outsysid"));
				userkeytype = Util.null2String(rs.getString("userkeytype"));
				uuid = Util.null2String(rs.getString("uuid"));
			}
		%>
		<div class="center">
			<div class="title">卸载云桥</div>
			<%if(!wxsysurl.equals("")){ %>
			<div>
				<div class="btn">卸载云桥</div>
				<div class="part" style="margin-top:45px;">
					<div class="title2">对接的云桥相关信息</div>
					<div>
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<th width="10%">云桥地址</th>
								<td width="90%" colspan="3"><a href="<%=wxsysurl %>" target="_blank"><%=wxsysurl %></a></td>
							</tr>
							<tr>
								<th width="10%">外部系统ID</th>
								<td width="40%"><%=outsysid %></td>
								<th width="10%" style="border-left:none;">标识类型</th>
								<td width="40%"><%=userkeytype %></td>
							</tr>
							<tr>
								<th>accesstoken</th>
								<td><%=accesstoken %></td>
								<th style="border-left:none;">系统UUID</th>
								<td><%=uuid %></td>
							</tr>
						</table>
					</div>
				</div>
				<div class="part">
					<div class="title2">相关消息推送设置</div>
					<div style="overflow-x:hidden;overflow-y:auto;height:350px;">
						<table class="table" width=100% border="0" cellspacing="0" cellpadding="0">
							<tr class="head">
								<td style="border-left:1px solid #ddd;">名称</td>
								<td>类型</td>
								<td>内容设置</td>
								<td>是否启用</td>
							</tr>
							<%
								String sql = "select * from WX_MsgRuleSetting order by type,id";
								int isenable = 1;
								rs.executeSql(sql);
								while(rs.next()){
									isenable = Util.getIntValue(rs.getString("isenable"),0);
							%>
							<tr>
								<td style="border-left:1px solid #ddd;"><%=Util.null2String(rs.getString("name")) %></td>
								<td><%=TransUtil.getWDTypeName(Util.null2String(rs.getString("type"))) %></td>
								<td>
									<div class="scroll">
										<%=Util.null2String(rs.getString("names")) %>
									</div>
								</td>
								<td><%if(isenable==1){ %>是<%}else{ %>否<%} %></td>
							</tr>
							<%}%>
						</table>
					</div>
				</div>
			</div>
			<%}else{ %>
			<div class="tips">当前系统没有对接云桥</div>
			<%} %>
		</div>
	</body>	
</HTML>
	