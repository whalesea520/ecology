<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<HTML>
<HEAD>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<script type="text/javascript">
</script>
<style type="text/css">
*{		
	font-family:"微软雅黑"!important; 
}
span {
	display:block;
	margin-top:5px;
	margin-bottom:5px;
}
.btn {
	border:0px;cursor:pointer;
	background-color:#3A5FCD;
	padding-left:0;
	padding-left:10px;
	padding-right:10px;
	height:30px;
	line-height:30px;
	color:#FFFFFF;
	width:75px;
}
</style>
</HEAD>
<BODY style="overflow:auto;">
	<div style="width:80%;margin:0 auto">
		<div style="margin:0 auto;text-align:center">测试XPATH</div>
		<form name="checkxpath" method="post" action="/templetecheck/CheckXpathOperation.jsp">
		<div>
			<span>XML文件内容：</span>
			<textarea id="contentarea" name="contentarea" style="width:100%!important;overflow:auto;"></textarea>
		</div>
		<span>XPATH路径：<input name="xpath" id="xpath" style="width:80%"></input>&nbsp;&nbsp;&nbsp;&nbsp;<input class="btn" type="button" onclick="testxml()" style="width:50px;" value="测试"></input></span>
		<div>
			<span>匹配结果：</span>
			<textarea id="resarea" name="resarea" style="width:100%!important;overflow:auto;"></textarea>
		</div>
	</div>
	</form>
</div>
</BODY>
</HTML>
<script type="text/javascript">
$(document).ready(function(){
	var docheight = $(document).height();
	var contentheight = docheight*0.65;
	var resheight = docheight*0.15;
	$("#contentarea").height(contentheight);
	$("#resarea").height(resheight);
});

function testxml(){
	var xpathval = $("#xpath").val();
	var contentareaval = $("#contentarea").val();
	if("" == xpathval) {
		alert("XPath路径不能为空");
		return;
	}
	if("" == contentareaval) {
		alert("XML文件内容不能为空");
		return;
	}
	$.ajax({
		url:"/templetecheck/CheckXpathOperation.jsp?date="+((new Date()).getTime()),
		data : {
			"xpath":xpathval,
			"contentarea":contentareaval
		},
		
		dataType:"json",
		type:"post",
		success:function(data) {
			var status = data.status;
			if("error1" == status) {
				alert("XML文件格式错误");
				return;
			} else if("error2" == status) {
				alert("XPATH路径格式错误");
				return;
			} else if("error" == status) {
				alert("XML文件内容不能为空");
				return;
			} else {
				var res = "";
				for(var obj in data) {
					var objval = data[obj];
					
					if(objval != "") {
						if(res == "") {
							res = res + data[obj];
						} else {
							res = res + "\n" + data[obj];
						}
					}
				}
				//alert(res);
				//res = res.replace("\n","\r\n");
				var reg=new RegExp("\\n","g"); 
				res= res.replace(reg,"\r\n"); 
				if(res == "") {
					res = "没有匹配的内容！";
				}
				
				$("#resarea").text(res);
			}
		}
	});
}
</script>