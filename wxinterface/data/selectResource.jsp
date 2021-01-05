<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null||user.getUID()!=1){
		return;
	}
%>
<HTML>
	<head>
		<script type='text/javascript' src="../js/jquery-1.8.3.min.js"></script>
		<link rel="stylesheet" href="../css/new.css" />
		
		<link rel="stylesheet" href="../js/showLoading/css/showLoading.css">
		<script type='text/javascript' src="../js/showLoading/js/jquery.showLoading.js"></script>
		
		<link href="../js/ztree/zTreeStyle.css" rel="stylesheet" type="text/css" />
		<script type='text/javascript' src="../js/ztree/jquery.ztree.all-3.5.min.js"></script>
		
		<style>
			body {
				margin: 0;padding:0;
			}
		</style>
	</head>
	<% 
		String resourceids = Util.null2String(request.getParameter("resourceids"));
		String resourcetype = Util.null2String(request.getParameter("resourcetype"));
	 %>
	<script>
		var resourceids = '<%=resourceids%>';
		var resourcetype = '<%=resourcetype%>';
		var treeObj;
		var setting = {
			data: {simpleData: {enable: true}},//简单数据格式
			callback: {
				beforeAsync: function(){$("#tree").showLoading();},
				onAsyncSuccess: function(){$("#tree").hideLoading();}
			},
			async: {//异步加载数据
				enable: true,
				url:"/wxinterface/data/getDepartTree.jsp",
				otherParam: {"resourcetype":resourcetype,"resourceids":resourceids}
			},
			check:{
				enable:true,
				chkboxType: { "Y": "", "N": "" }
			}
		};
		$(document).ready(function(){
			treeObj = $.fn.zTree.init($("#tree"), setting);
			$("#closeBtn").click(function(){
				parent.dlg2.close();
			});
			$("#sureBtn").click(function(){
				var nodes = treeObj.getCheckedNodes(true);
				var ids = "",names = "";
				for(var i=0;i<nodes.length;i++){
					var node = nodes[i];
					ids +=","+node.subid;
					names+=","+node.name;
				}
				if(ids!="") ids+=",";
				if(names!="") names = names.substring(1);
				parent.$("#resourceids").val(ids);
				parent.$("#resourcenames").html(names);
				parent.dlg2.close();
			});
		});
	</script>
	<body>
		<div style="height:350px;overflow-y:auto;overflow-x:hidden;">
			<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0" style="table-layout: fixed;">
				<tr>
					<td id="treeTd" valign="top">
						<div style="">
							<ul id="tree" class="ztree"></ul>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="selFooter" style="padding-bottom:10px;">
			<div class="msgFooterBtn" style="margin-left:130px;" id="sureBtn">确定</div>
			<div class="msgFooterBtn" style="margin-left:100px;" id="closeBtn">取消</div>
		</div>
	</body>
</HTML>		