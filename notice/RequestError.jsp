<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
	<head>
		<style type="text/css">
			.box1{
				width:100%;
				heigth:100%;
			}
			.maindiv{
				width:334px;
				height:96px;
				margin: auto;  
	            position: absolute;  
	            top: -100px; 
	            left: 0; 
	            bottom: 0; 
	            right: 0; 
			}
			.lefticon{
				background-image:url("/images/ecology8/workflow/wfiniterror1_wev8.png");
				background-repeat:no-repeat;
				background-position:100% 100%;
				width:108px;
				height:96px;
				float:left;
			}
			.rightdiv{
				width:226px;
				height:96px;
				float:left;
			}
			.rightdiv div span{
				font-size:18px;
				font-weight:blod;
			}
			
			.color1{color:#5c5c5c !important;}
			.color2{color:#757575 !important;}
			
			.errorcontent{
				margin-top:5px;
			}
			
			.btndiv{
				margin-top:18px;
				margin-left:45px;
				background-image:url("/images/ecology8/workflow/wfinitbtn1_wev8.png");
				background-repeat:no-repeat;
				width:126px;
				height:36px;
				cursor:pointer;
			}
		</style>
		<script language="javascript">
			function sendSystemwf(){
				changebtngroundimg(3);
				jQuery('#btndiv').removeAttr('onclick');
				var messagedetail = "由于流程ID、表单ID、节点ID、节点类型、请求ID、是否是系统表单、操作类型流程提交必须字段可能为空，导致流程初始化失败，请联系流程操作人<%=user.getUsername()%>进行处理";
				jQuery.ajax({
					type:'post',
					url:'/workflow/request/TriggerRemindWorkflow.jsp?_'+new Date().getTime()+"=1",
					data:{
						remark:messagedetail,
						loginuserid:<%=user.getUID()%>,
					},
					error:function (XMLHttpRequest, textStatus, errorThrown) {
						changebtngroundimg(1);
						jQuery('.btndiv').on('click',sendSystemwf());
					} , 
				    success:function (data, textStatus) {
				    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126317,user.getLanguage())%>");
				    }
				});
			}
			
			function changebtngroundimg(index){
				jQuery('.btndiv').css('background-image','url("/images/ecology8/workflow/wfinitbtn'+index+'_wev8.png")');
			}
			
			jQuery(function(){
				
			});
		</script>
	</head>
	<body>
		<div class="box1">
			<div class="maindiv">
				<div class="lefticon"></div>
				<div class="rightdiv">
					<div class="errorcontent">
						<span class="color1">工作流初始错误，</span>
						<span class="color2">点击通知</span>
					</div>
					<div id="btndiv" class="btndiv" onclick="sendSystemwf()">
					</div>
				</div>
			</div>
		</div>
	</body>
</html>