<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="weaver.formmode.exttools.impexp.exp.service.ExpDataService" trimDirectiveWhitespaces="true"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.formmode.exttools.impexp.entity.XmlBean"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	
	RecordSet rs1 = new RecordSet();
	String dbtype = rs1.getDBType();
	if("oracle".equals(dbtype)){
		rs1.executeSql("select * from modetreefield where nvl(isdelete,'0')<>'1'");
	}else{
		rs1.executeSql("select * from modetreefield where isnull(isdelete,'0')<>'1'");
	}
	RecordSet rs2 = new RecordSet();
	if("oracle".equals(dbtype)){
		rs2.executeSql("select * from modeinfo where nvl(isdelete,'0')<>'1'");
	}else{
		rs2.executeSql("select * from modeinfo where isnull(isdelete,'0')<>'1'");
	}
	RecordSet rs3 = new RecordSet();
	rs3.executeSql("select * from mode_impexp_log order by id desc");
%>
<html>
	<head>
		<script type="text/javascript" src="/formmode/js/jquery/jquery-1.8.3.min_wev8.js"></script>
		<script type="text/javascript" src="/formmode/js/jquery/jquery-1.8.3.min.js"></script>
	</head>
	<body>
		<div>
		应用<input type="button" value="导出" id="appexp"/><br>
		<%while(rs1.next()){ %>
			<%=rs1.getString("treefieldname") %><input type="radio" value="<%=rs1.getString("id") %>" name="appid"/>
		<%} %>
		</div>
		<br>
		<div>
		模块<input type="button" value="导出" id="modeexp"/><br>
		<%while(rs2.next()){ %>
			<%=rs2.getString("modename") %>(<%=rs2.getString("id") %>)<input type="radio" value="<%=rs2.getString("id") %>" name="modeid"/>
		<%} %>
		</div>
		<br>
		<div>
		<form name=frmMain method=post action="impexpAction.jsp" enctype="multipart/form-data" target="upload_faceico">
			<input type="hidden" id="id" name="id"/>
			<input type="hidden" id="ptype" name="ptype">
			<input type="file" value="上传附件" name="filename"/><br><br>
			<input type="button" value="导入应用" id="appimp"/>
			<input type="button" value="导入模块" id="modeimp"/>
		</form>
		<iframe id="upload_faceico" name="upload_faceico" style="display: none;"></iframe>
		</div>
		<div>
			<%while(rs3.next()){ 
				int type = rs3.getInt("type");
				int datatype = rs3.getInt("datatype");
				int userid = rs3.getInt("creator");
				String createdate = rs3.getString("createdate");
				String createtime = rs3.getString("createtime");
				int logid = rs3.getInt("id");
			%>
				<%="人员"+userid+" 在 "+createdate+" "+createtime+" "+(type==0?"导出":"导入")+" "+(datatype==0?"应用":"模块") %><a href="javascript:loadDetails('<%=logid %>');">详细</a><br>
			<%} %>
		</div>
		<div>
			<textarea rows="50" cols="100" id="logdetail"></textarea>
		</div>
	</body>
	<script type="text/javascript">
		$(function(){
			$("#appexp").click(function(){
				var appid = $("input[name='appid']:checked").val();
				if(appid==undefined){
					alert("请选择应用!");
				}else{
					doExp(appid,0);
				}
			});
			$("#modeexp").click(function(){
				var modeid = $("input[name='modeid']:checked").val();
				if(modeid==undefined){
					alert("请选择模块!");
				}else{
					doExp(modeid,1);
				}
			});
			$("#appimp").click(function(){
				var appid = $("input[name='appid']:checked").val();
				if(appid==undefined){
					alert("请选择应用!");
				}else{
					$("#ptype").val(0);
					$("#id").val(appid);
					doImp();
				}
			});
			$("#modeimp").click(function(){
				var appid = $("input[name='appid']:checked").val();
				if(appid==undefined){
					alert("请选择应用!");
				}else{
					$("#ptype").val(1);
					$("#id").val(appid);
					doImp();
				}
			});
		});
		function doExp(id,ptype){
			window.open("impexpAction.jsp?id="+id+"&ptype="+ptype+"&type=0");
		}
		function doImp(){
			var id = $("#id").val();
			var ptype = $("#ptype").val();
			document.frmMain.action = "impexpAction.jsp?id="+id+"&ptype="+ptype+"&type=1";
			document.frmMain.submit();
		}
		function loadDetails(logid){
			$.ajax({
				type:"post",
				url:"impexpAction.jsp",
				data:{type:2,logid:logid},
				dataType:"text",
				success:function(data){
					$("#logdetail").html(data);
				}
			});
		}
	</script>
</html>