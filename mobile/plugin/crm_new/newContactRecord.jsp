<!DOCTYPE html>
<%@page import="weaver.general.Util"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}
String id = Util.null2String(request.getParameter("id"));
%>
<html>
<head>
<title>新建联系记录</title>
</head>
<body>
<div id="crm_newContactRecord" class="page out">
	<style type="text/css">
		#crm_newContactRecord form{padding:5px 15px;}
		#crm_newContactRecord form textarea{width:100%;font-size:14px;border:1px solid #f0f0f0;height:100px;padding:5px 0;}
		#crm_newContactRecord form div.formTitle{color:#999;font-size:12px;border-bottom: 1px solid #f0f0f0;}
		
		.items_div_card{width: 90px;height: 90px;background: url(/mobilemode/images/emobile/photo_wev8.png) no-repeat;margin-right: 8px;background-size: 90px 90px;}
		.items_div_card input{font-size: 20px;width: 90px;height: 90px;filter: alpha(opacity=0);opacity: 0;cursor: pointer;}
		.items_img{width: 89px;height: 89px; border-radius: 3px; padding-top: 29px;float:left;display:none;}
		.items_img img{width: 89px;height: 89px;border-radius: 3px;border: 1px solid #eee;}
		
		.container{
            position:relative;
        }
        .search{
	        position:absolute;
	        width:30px;
	        height:30px;
	        top:5px;
	        right:2px;
	        z-index:99;
        }
	</style>
	<div class="header" data-role="header">
		<div class="left" onclick="javascript:history.go(-1);">新建联系记录</div>
		<div class="right okBtn"></div>
	</div>
	<div class="content">
		<div class="form_msg"></div>
		<iframe name="commentFrame" style="display: none"></iframe>
		<form id="commentForm" target="commentFrame" enctype="multipart/form-data" method="POST" action="/mobile/plugin/crm_new/crmAction.jsp?action=saveContactRecord" >
			<input type="hidden" name="customerid" value="<%=id%>" />
			<div class="formTitle">相关联系人：</div>
			<ul class="btnSelect" data-flag="contacts"></ul>
			<input type="text" name="contacts" style="display: none;"/>
	
			<div class="formTitle">相关商机：</div>
			<ul class="btnSelect" data-flag="sellchance"></ul>
			<input type="text" name="sellchance" style="display: none;"/>
			<div class="container">
	         <textarea id="description_" name="description" placeholder=" 填写联系记录……" ></textarea>
			</div>
			<img id="mec_photo" style="width:40px;height:40px;" alt="图片" src="/mobile/plugin/crm_new/images/picture.png" title="图片">
            <img class='microphone' style="width:40px;height:40px;" src="/mobile/plugin/crm_new/images/translation.png"/>
			<!--图片-->
			<div class="photoContainerWrap">
				<input type="hidden" name="fieldCommentImg" id="fieldCommentImg" value=""/>
				<input type="hidden" name="imageCountCommentImg" id="imageCountCommentImg" value="0"  />
				<input type="hidden" name="imgfileid" id="imgfileid" value=""  />
				<div id="photoContainer_CommentImg" class="photoContainer"></div>
			</div>
			<!--录音-->
			<div style="width:100%;height:12%;position:absolute;bottom:0px;left:0px;">
				<canvas id="canvas" style="display:none;"></canvas>
			</div>	
		</form>
	</div>
	
	
	
	
	<script type="text/javascript">
	$.extend(CRM, {
		buildNewContactRecordPage : function(id){
			//绑定图片点击事件
			$("#mec_photo").click(function(e){
				_p_addPhoto(e, "CommentImg");
				e.stopPropagation(); 
			});
			var that = this;
			var $crm_newContactRecord = $("#crm_newContactRecord");
			
			$(".header .okBtn", $crm_newContactRecord).click(function(){
				var $form_msg = $(".form_msg", $crm_newContactRecord);
				var $form = $("form", $crm_newContactRecord);
				var description = $("textarea[name='description']", $form).val();
				if($.trim(description) == ""){
					$form_msg.html("内容不能为空");
					$form_msg.show();
					setTimeout(function(){$form_msg.hide();}, 1000);
					return;
				}
				$form_msg.html("正在保存，请稍后...");
				$form_msg.show();
				
				that.ajax("/mobile/plugin/crm_new/crmAction.jsp?action=saveContactRecord", $form.serialize(), function(result){
                    $form_msg.hide();
                    //返回
                    history.go(-1);
                    //重置form
                    $form[0].reset();
                    //清除图片
                    $("#photoContainer_CommentImg").html("");
                    $(".btnSelect li.checked", $crm_newContactRecord).removeClass("checked");
                    //刷新列表
                    if(typeof(that.refreshContactRecordList) == "function"){
                        that.refreshContactRecordList(id);
                    }
                });
			});
			
			var url = "/mobile/plugin/crm_new/crmAction.jsp?action=getContactsAndSellChance&id="+id;
			that.ajax(url, function(result){
				var data = result["data"];
				var contactsDatas = data["contactsDatas"];
				var $contacts = $(".btnSelect[data-flag='contacts']", $crm_newContactRecord);
				for(var i = 0; i < contactsDatas.length; i++){
					var d = contactsDatas[i];
					$contacts.append("<li data-value=\""+d["id"]+"\">"+d["fullname"]+"</li>");
				}
				
				var sellChanceDatas = data["sellChanceDatas"];
				var $sellchance = $(".btnSelect[data-flag='sellchance']", $crm_newContactRecord);
				for(var i = 0; i < sellChanceDatas.length; i++){
					var d = sellChanceDatas[i];
					$sellchance.append("<li data-value=\""+d["id"]+"\">"+d["subject"]+"</li>");
				}
				
				$(".btnSelect li", $crm_newContactRecord).click(function(){
					var $this = $(this);
					var v;
					if($this.hasClass("checked")){
						$this.removeClass("checked");
						v = "";
					}else{
						$this.siblings("li.checked").removeClass("checked");
						$this.addClass("checked");
						v = $this.attr("data-value");
					}
					var flag = $this.parent().attr("data-flag");
					$("input[name='"+flag+"']", $crm_newContactRecord).val(v);
				});
			});
		},
		
		buildVoiceAnimate : function(){
			var canvas = document.getElementById('canvas'); 
			var ctx = canvas.getContext('2d'); 
			canvas.width = canvas.parentNode.offsetWidth; 
			canvas.height = canvas.parentNode.offsetHeight;
			//如果浏览器支持requestAnimFrame则使用requestAnimFrame否则使用setTimeout 
			window.requestAnimFrame = (function(){
				return window.requestAnimationFrame  || 
				window.webkitRequestAnimationFrame || 
				window.mozRequestAnimationFrame || 
				function(callback){ 
					window.setTimeout(callback, 1000 / 60); 
				}; 
			})(); 
			// 波浪大小
			var boHeight = canvas.height /3.0;
			var posHeight = canvas.height / 1.7;
			//初始角度为0 
			var step = 0; 
			//定义三条不同波浪的颜色 
			var lines = ["rgba(0,222,255, 0.2)", 
			  "rgba(157,192,249, 0.2)", 
			  "rgba(0,168,255, 0.2)"]; 
			function loop(){ 
				ctx.clearRect(0,0,canvas.width,canvas.height); 
				step++; 
				//画3个不同颜色的矩形 
				for(var j = lines.length - 1; j >= 0; j--) { 
					ctx.fillStyle = lines[j]; 
					//每个矩形的角度都不同，每个之间相差45度 
					var angle = (step+j*50)*Math.PI/180; 
					var deltaHeight = Math.sin(angle) * boHeight;
					var deltaHeightRight = Math.cos(angle) * boHeight; 
					ctx.beginPath();
					ctx.moveTo(0, posHeight+deltaHeight); 
					ctx.bezierCurveTo(canvas.width/2, posHeight+deltaHeight-boHeight, canvas.width / 2, posHeight+deltaHeightRight-boHeight, canvas.width, posHeight+deltaHeightRight); 
					ctx.lineTo(canvas.width, canvas.height); 
					ctx.lineTo(0, canvas.height); 
					ctx.lineTo(0, posHeight+deltaHeight); 
					ctx.closePath(); 
					ctx.fill();
				}
				requestAnimFrame(loop);
			} 
			loop();
			record2();//
		}
	});
	CRM.buildNewContactRecordPage("<%=id%>");
	CRM.buildVoiceAnimate();
	
	//图片区域变化
	$(document).ready(function(){      
	   $("#photoContainer_CommentImg").bind('DOMNodeInserted', function(e) {  
           //alert('element now contains: ' + $(e.target).html());  
            $.ajax({  
			    url: "/mobile/plugin/crm_new/crmAction.jsp?action=saveFiles",  
			    type: 'POST',  
			    cache: false,  
			    data: new FormData($("#commentForm")[0]),  
			    processData: false,  
			    contentType: false,  
			    success: function (result) {
			         var jsonResult = jQuery.parseJSON(result);
			         var data = jsonResult["data"];
			    $("#imgfileid").val(data);
			    },  
			    error: function (err) {
			         $("#imgfileid").val("");
			    }  
			});  

        });        
		
    });
	
	</script>
</div>
</body>
</html>
