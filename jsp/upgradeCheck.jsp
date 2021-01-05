<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<%@ page import="weaver.general.*" %>
<%@ page import="java.io.*" %>
<jsp:useBean id="suc" class="weaver.system.SysUpgradeCominfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<head>
<title></title>
<style>
.btnclass {
	margin-top:50px;
	margin-left:50px;
	widht:300px;
	height:30px;
}
</style>
<script type="text/javascript">
var returnflage = 0;

function continueExcute(obj) {
	if(obj == 1) {
		top.Dialog.confirm("请确定您已检查升级的跳包的情况，确认后将继续进行升级。",
				function(){
					$.ajax({
						url:"/jsp/continueExcute.jsp",
						type:"post",
						datatype:"json",
						success:function(data){
							if(data) {
								window.location.href="/jsp/processSql.jsp";
							}
							
						}
					});
				},
				function(){
					window.location.href="/jsp/processSql.jsp";
				});
		
	}else if(obj == 2){
		
		top.Dialog.confirm("请确认您已经查看错误日志，已核实该SQL语句可以直接跳过！",
				function(){
			$.ajax({
					url:"/jsp/continueExcute.jsp",
					type:"post",
					datatype:"json",
					success:function(data){
						if(data) {
							window.location.href="/jsp/processSql.jsp";
						}
					}
				});
				},
				function(){
					window.location.href="/jsp/processSql.jsp";
				});
	} else {
		$.ajax({
			url:"/jsp/continueExcute.jsp",
			type:"post",
			datatype:"json",
			success:function(data){
				if(data) {
					window.location.href="/jsp/upgradesuccess.jsp";
				}
			}
		});
	}
}

function showSQLError() {
	$("#alllog").val(0);//只显示sql报错信息
	document.form1.submit();
}
function stopExcute(obj){
	alert('请关闭Resin！')
}
function exportFile() {
       //var form = $("<form name='formdow'>");   //定义一个form表单
       //form.attr('style','display:none');   //在form表单中添加查询参数
       //form.attr('target','');
       //form.attr('method','post');
       //form.attr('action',"exportFile.jsp"); 
       //$('body').append(form);  //将表单放置在web中
      //form.append(input1);   //将查询参数控件提交到表单上
      $("#alllog").val(1);
       document.form1.submit();
}

function showLog(path) {
	doOpen("/login/errorMessage.jsp?path="+path,"升级错误日志");
}

var dWidth = 600;
var dHeight = 500;
function doOpen(url,title){
	if(typeof dialog  == 'undefined' || dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width =  dWidth || 500;
	dialog.Height =  dWidth || 300;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	
	dialog.show();
}

function skipall() {

	top.Dialog.confirm("请确认这个脚本已在数据库手动执行，否则不能直接跳过！",
			function(){
				$.post("/skipall.do?date="+((new Date()).getTime()),{
					
				},function(data){
					window.location.href="/jsp/processSql.jsp";
				});
			},
			function(){
				window.location.href="/jsp/processSql.jsp";
	});
}
function backup() {
	
	top.Dialog.confirm("升级失败，确认还原？",
			function(){
				window.location.href="/jsp/backup.jsp";
			},
			function(){
				window.location.href="/jsp/processSql.jsp";
	});
}
</script>
</head>
<body>
<form name="form1" action="/login/exportFile.jsp" type="post">
<input type="hidden" id="alllog" name="alllog" value="1"></input>
</form>
</body>
</html>