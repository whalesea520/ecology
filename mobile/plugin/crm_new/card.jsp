<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@ page import="weaver.hrm.User"%>
<%
User user = MobileUserInit.getUser(request, response);
if(user == null){
	out.println("无用户，请登录");
	return;
}

%>
<html>
  <head>
    <title>名片</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0">
	<style type="text/css">
	* {font-family: 'Microsoft YaHei', Arial;}
	html, body, .page {height: 100%;width: 100%;overflow: hidden;margin: 0;padding: 0;}
	.items{width: 100%;height: 130px;border-bottom: 1px solid #eee;padding-left: 15px;}
	.items_div{float:left}
	.items_div_desc{background-position: 66px center;width: 67px;color: #666;font-size: 14px;padding-top: 5px;padding-bottom: 5px;display: table-cell;vertical-align: middle;box-sizing: border-box;}
	.items_div_card{width: 90px;height: 90px;background: url(/mobilemode/images/emobile/photo_wev8.png) no-repeat;margin-right: 8px;background-size: 90px 90px;}
	.items_div_card input{font-size: 20px;width: 90px;height: 90px;filter: alpha(opacity=0);opacity: 0;cursor: pointer;}
	.items_img{width: 89px;height: 89px; border-radius: 3px; padding-top: 29px;float:left;display:none;}
	.items_img img{width: 89px;height: 89px;border-radius: 3px;border: 1px solid #eee;}
	.items1{width: 100%;height: 80px;border-bottom: 1px solid #eee;margin-left: 15px;}
	.FCheckboxContainer {background-color: #fff;border-radius: 5px;}
	.FCheckBoxLayouthorizontal .FCheckboxContainer ul {margin: 0;padding: 5px 0 0 0;border-bottom: 0;}
	.FCheckBoxLayouthorizontal .FCheckboxContainer ul li.checked {background: 0;background-color: #333;border: 1px solid #333;color: #fff;background-clip: padding-box;}
	.FCheckBoxLayouthorizontal .FCheckboxContainer ul li {background: 0;padding: 0 10px; margin: 0 6px 6px 0;border: 1px solid #777;border-radius: 3px;color: #444;vertical-align: middle; display: inline-block;}
	.FCheckBoxLayouthorizontal .FCheckboxContainer ul li div {border: 0; padding: 5px 0;font-family: Heiti SC,Microsoft YaHei,Arial;}
	.FCheckboxContainer ul li div { font-size: 14px;}
	.language{color: #666;font-size: 14px;padding-top: 5px;padding-bottom: 5px;display: table-cell;vertical-align: middle;box-sizing: border-box;}
    .fButtons {padding: 10px 15px; overflow: hidden;}
    .fSubmitButton {background: url(/mobilemode/images/emobile/edit_wev8.png) no-repeat;background-size: 18px 18px;background-position: 10px center; background-color: #017afd;color: #fff;padding: 10px 15px 10px 34px;}
	.fButton {font-family: 'Microsoft Yahei',Arial;font-size: 15px;border-radius: 5px;cursor: pointer;float:right;border: none;}
	.fResetButton {background: url(/mobilemode/images/clear_wev8.png) no-repeat;background-size: 22px 22px;background-position: 10px center;background-color: #ddd;color: #333; padding: 10px 15px 10px 34px;}
	.resultDiv{padding-left: 15px;display:none;}
	.column_break .left_line {float: left;width: 6px;height: 24px;background: #017afd;}
	.formfield-label {background: url(/mobilemode/images/mec/line_wev8.png) no-repeat;background-position: 66px center;width: 67px;color: #666;font-size: 14px;padding-top: 5px;padding-bottom: 5px;display: table-cell;vertical-align: middle;box-sizing: border-box;}
	.formfield-content {padding-right: 25px;}
	.formfield-input {width: 100%;height: 40px;border: 0;line-height: 40px;padding: 0;font-size: 14px;}
	.formfield-wrap {border-bottom: 1px solid #eee;position: relative;display: table;table-layout: fixed;vertical-align: middle;width: 100%;}
    .right_line {height: 1px;background: #ececec;float: right;margin-top: 10px;}
	.middle_content {letter-spacing: 2px;box-sizing: content-box;line-height: 24px;margin-left: 25px;}
	.cardmore{position: absolute;top: 0px;right: 4px;width: 20px;height: 40px;line-height: 40px;text-align: center;}
	.cardmore img{height: 27px;padding-top: 13px;width: 10px;}
	.requrie{color:red;}
	.customers{position: absolute; opacity: 1; z-index: 10005; background-color: #fff; height: 100%; width: 100%; top: 0; left: 0; display:none;}
	.customerHeader{height: 45px; top: 0; background-color: #0161c9; color: #fff; }
	.customerHeaderLeft{font-size: 15px;font-weight: normal;margin-left: 15px;color: #fff;line-height: 45px;margin-right: 35px;overflow: hidden;text-overflow: ellipsis;white-space: nowrap;}
    .cardcontrolTitle {background-color: #f0f0f0;padding: 6px 15px;position: relative;height: 40px;box-sizing: border-box;}
    .cardcontrolTitle input {border: 1px solid #e5e5e5;border-radius: 50px;background-color: #fff;padding: 0px 10px 0px 30px;width: 100%;height: 28px;box-sizing: border-box;}
	.cardcontrolTitle .btn {position: absolute;top: 13px;left: 25px;width: 14px;}
    .cardcontent{overflow: auto;width: 100%;position: absolute;top: 85px;left: 0px;bottom: 0px;}
    .cardlist{padding-left: 0; list-style: none; margin: 0;}
    .cardlist li{padding: 0px; font-size: 14px;border-bottom: 1px solid #f4f4f4;position: relative;}
    .cardlist li>a{font-family: Arial; color: #333; -webkit-appearance: none;height: 36px; line-height: 36px; padding-left: 15px;display: block;ransition: transform 0.3s;    text-decoration: none;}
	.cardloading{position:absolute;top:0px;left:0px;height:100%;width:100%;background-color:#fff;z-index:88888;filter:alpha(Opacity=50);-moz-opacity:0.5;opacity: 0.5;display:none;}
	.cardloading div{height: 40px;width: 85px;position: relative;top: 270px;background: url(/mobilemode/images/mobile_loading2_wev8.gif) no-repeat; margin: 0 auto;}
	</style>
  </head>
  <body>
  	<div class="header">
		<div class="left" onclick="javascript:history.go(-1);">名片识别</div>
	</div>
  	<div class="content">
  		<form id="cardform" enctype="multipart/form-data">
	  		<div class="items">
				<div class="items_div">
					<div class="items_div_desc">名片正面&nbsp;<span class="requrie">*</span></div>
					<div class="items_div_card">
						<input id="card1" type="file" name="fieldname_card1" class="" accept="image/*" single="single">
						<input id="fieldname_img1" type="hidden" name="fieldname_img1">
					</div>
				</div>
				<div class="items_img"><img id="img_card1" class="item_img"></div>
			</div>
			
			<div class="items" style="display:none">
				<div class="items_div">
					<div class="items_div_desc">名片反面</div>
					<div class="items_div_card">
						<input id="card2" type="file" name="fieldname_card2" class="" accept="image/*" single="single">
						<input id="fieldname_img2" type="hidden" name="fieldname_img2">
					</div>
				</div>
				<div class="items_img"><img id="img_card2" class="item_img"></div>
			</div>
			<!-- 
			<div class="items1">
				<div class="language">
					选择名片语言：
				</div>
				<div class="Design_FCheckbox_Fielddom FCheckBoxLayouthorizontal">
					<div class="FCheckboxContainer" cb-type="1">
						<ul>
							<li data-value="0" class="checked" readonly="0">
								<div>
									中文简体
								</div>
							</li>
							<li data-value="1" class="checked" readonly="0">
								<div>
									中文（繁体）
								</div>
							</li>
							<li data-value="2" class="checked" readonly="0">
								<div>
									英文
								</div>
							</li>
						</ul>
					</div>
					<input type="text" style="display: none;" name="fieldname_language"
						value="0,1,2,3" data-role="none"
						id="C7C2762011E0000192A4B6C017201A80" fieldlabel="选择名片语言："
						require="">
				</div>
			</div>  -->
		</form>
			
		<div class="fButtons">
			<button class="fButton fSubmitButton" id="cardUpload" title="识别"/>
				识别
			<button class="fButton fSubmitButton" style="display:none;" id="cardSave" title="保存名片信息"/>
				保存名片信息
		</div>
		
		<form id="saveform">
			<div class="resultDiv">
				<div class="column_break">
					<div class="left_line"></div>
					<div class="middle_content" style="font-size: 16px; color: #333; font-weight: bold;">
						识别结果<div class="right_line" style="width: 271px;"></div>
					</div>
				</div>
				<div class="formfield-wrap">
					<div class="formfield-label">
						姓名：
					</div>
					<div class="formfield-content">
						<input class="formfield-input" placeholder="请输入..." type="text" name="fieldname_fullname" id="fieldname_fullname" value="" fieldlabel="姓名：" >
					</div>
				</div>
				
				<div class="formfield-wrap">
					<div class="formfield-label">
						职称：
					</div>
					<div class="formfield-content">
						<input class="formfield-input" placeholder="请输入..." type="text" name="fieldname_jobtitle" id="fieldname_jobtitle" value="" fieldlabel="职称：" >
					</div>
				</div>
				
				<%--<div class="formfield-wrap">--%>
					<%--<div class="formfield-label">--%>
						<%--部门：--%>
					<%--</div>--%>
					<%--<div class="formfield-content">--%>
						<%--<input class="formfield-input" placeholder="请输入..." type="text" name="fieldname_textfield1" id="fieldname_textfield1" value="" fieldlabel="部门：" >--%>
					<%--</div>--%>
				<%--</div>--%>
				
				<div class="formfield-wrap">
					<div class="formfield-label">
						公司：
					</div>
					<div class="formfield-content">
						<input type="hidden" id="fieldname_customerid">
						<input class="formfield-input" placeholder="请输入..." type="text" name="fieldname_customername" id="fieldname_customername" value="" fieldlabel="公司：" >
						<a class="cardmore" href="/mobile/plugin/crm_new/cardCustomers.jsp" data-formdata="" data-reload="true">
							<img src="/mobile/plugin/crm_new/images/rArrow999.gif" />
						</a>
						<!-- 
						<a class="cardmore" href="javascript:;" onclick="showCustomer()" data-formdata="">
							<img src="/mobilemode/apps/e-cology/images/rArrow999.gif" />
						</a> -->
					</div>
				</div>
				
				<div class="formfield-wrap">
					<div class="formfield-label">
						电话：
					</div>
					<div class="formfield-content">
						<input class="formfield-input" placeholder="请输入..." type="text" name="fieldname_phoneoffice" id="fieldname_phoneoffice" value="" fieldlabel="电话：" >
					</div>
				</div>
				
				<div class="formfield-wrap">
					<div class="formfield-label">
						邮箱：
					</div>
					<div class="formfield-content">
						<input class="formfield-input" placeholder="请输入..." type="text" name="fieldname_email" id="fieldname_email" value="" fieldlabel="邮箱：" >
					</div>
				</div>
			</div>
		</form>
  	</div>
  	<div class="cardloading">
		<div></div>
	</div>
	<!-- 
	<div id="customers" class="customers">
			<div class="customerHeader">
				<div class="customerHeaderLeft" onclick="goBack()">匹配到以下客户</div>
			</div>
			<div class="cardcontrolTitle">
				<img src="/mobile/plugin/crm_new/images/searchright_wev8.gif" class="btn">
				<input type="search" id="search" placeholder="Search...">
			</div>
		<div class="cardcontent">
			<ul class="cardlist">
			</ul>
		</div>
	</div>
	 -->
	<script type="text/javascript">
		$(function(){
		
			$("#card1").change(function(){
				$("#saveform")[0].reset();
				$(".requrie").hide();
				$(".resultDiv").hide();
				$("#cardSave").hide();
				$("#cardUpload").show();
				$("#cardUpload").removeAttr("disabled");
				$("#cardSave").removeAttr("disabled");
				$("#cardSave").css("background-color","#017afd");
				$("#cardUpload").css("background-color","#017afd");
				$(".items_img").show();
			  	imgPreview(1,this);
				$(".cardmore").removeAttr("data-formdata");
				$("#fieldname_customername").val("");
			});
			
			$("#card2").change(function(){
			  	imgPreview(2,this);
			});
			
			$("#cardUpload").click(function(){
				var img1 = $("#fieldname_img1").val();
				if(img1!=""){
					$(".cardloading").show();
					$("#cardUpload").css("background-color","#666");
					$("#cardUpload").attr("disabled","disabled");
					cardUpload();
				}else{
					alert('请选择图片');
				}
			});
			
			$("#cardSave").click(function(){
				saveData();
			});
			
			$("#fieldname_customername").change(function(){
				var custname = $("#fieldname_customername").val();
				$(".cardmore").attr("data-formdata","customername="+custname);
			});
		});
	
		function imgPreview(card,obj) {
		    var files = obj.files;
		    var file = files[0];
		    var reader = new FileReader();
		    reader.onload = function(){
		        var result = this.result;
		        document.getElementById('img_card'+card).src=result;
		        document.getElementById('fieldname_img'+card).value=result;
		    };
		    reader.readAsDataURL(file);
		}
		
		function cardUpload(){
			var params = $("#cardform").serialize();
			$.ajax({
			    url: '/mobile/plugin/crm_new/cardAction.jsp?action=savecard',
			    type: 'POST',
			    data: params,
			    dataType:"json",
			    success:function(data){
			    	$(".cardloading").hide();
			    	if(data.status==1){
			    		$(".resultDiv").show();
			    		$("#cardSave").show();
			    		$("#cardUpload").hide();
			    		formatHtml(data);
			    	}else{
			    	    if(typeof(data.errMsg)=="undefined"){
			    	        alert("处理异常，请联系管理员！");
						}else{
                            alert(data.errMsg);
						}
			    	}
			    },
			    complete : function(XMLHttpRequest,status){ //请求完成后最终执行参数
			    	$(".cardloading").hide();
			　　		if(status=='timeout'){//超时,status还有success,error等值的情况
			 　　　　　 	ajaxTimeoutTest.abort();
			　　　　　  	alert("请求超时，请重试");
			　　　　	}
			　　}
			})
		}
		
		function formatHtml(data){
			var frontid = data.frontid;
    		var backid = data.backid;
    		if(typeof(frontid)!="undefined"){
    			//$("#img_card1").attr("src","/weaver/weaver.file.FileDownload?fileid="+frontid);
    		}
    		if(typeof(backid)!="undefined"){
    			//$("#img_card2").attr("src","/weaver/weaver.file.FileDownload?fileid="+backid);
    		}
    		
    		var cardInfo = JSON.parse(data.cardInfo);
    		
    		var formatted_name = cardInfo.formatted_name;//姓名
    		if(formatted_name.length>0){
    			$("#fieldname_fullname").val(formatted_name[0].item);
    		}
    		
    		var title = cardInfo.title;//职称
    		if(title.length>0){
    			$("#fieldname_jobtitle").val(title[0].item);
    		}
    		
    		var organization = cardInfo.organization;//组织
    		if(organization.length>0){
    			// $("#fieldname_textfield1").val(organization[0].item.unit);
    			$("#fieldname_customerid").val("");
    			var custname = organization[1].item.name;
                if(typeof(custname)!="undefined"){
					$.ajax({
						url: '/mobile/plugin/crm_new/cardAction.jsp?action=queryCustomerByName&rd='+Math.random()+'&searchKey='+encodeURI(custname),
						type: 'POST',
						data: '{}',
						dataType:"json",
						success:function(data){
							if(data.status==1){
								var datas = data.datas;
								if(""!=datas){
									$("#fieldname_customerid").val(datas);
									alert("已匹配客户："+custname);
								}
							}else{
								alert(data.errMsg);
							}
						}
					})

                    $(".cardmore").attr("data-formdata","customername="+custname);
                    $("#fieldname_customername").val(custname);
				}else{
                    $(".cardmore").removeAttr("data-formdata");
					$("#fieldname_customername").val("");
				}
    		}else{
                $(".cardmore").removeAttr("data-formdata");
				$("#fieldname_customername").val("");
				
			}
    		
    		var telephone = cardInfo.telephone;//电话
    		if(telephone.length>0){
    			$("#fieldname_phoneoffice").val(telephone[0].item.number);
    		}
    		
			var email = cardInfo.email;//邮箱
    		if(email.length>0){
    			$("#fieldname_email").val(email[0].item);
    		}
    		
		}
		
		function showCustomer(){
			var name = $("#fieldname_customername").val();
			$(".cardlist").empty();
			$("#search").val(name);
			$("#customers").show();
			getCustomerList(name);
			
		}
		
		function getCustomerList(name){
			var html = "";
			$.ajax({
			    url: '/mobile/plugin/crm_new/crmAction.jsp?action=getCustomerList&rd='+Math.random()+'&searchKey='+encodeURI(name)+'&pageSize='+20,
			    type: 'POST',
			    data: '{}',
			    dataType:"json",
			    success:function(data){
			    	if(data.status==1){
			    		var datas = data.datas;
			    		if(datas.length>0){
			    			for(var key in datas){
			    				html+="<li><a href=\"javascript:;\" onclick=\"choose(this)\" value=\""+datas[key].id+"\">"+datas[key].name+"</a></li>";
			    			}
			    		}else{
			    			html+= "<li><div style=\"color:#ccc;font-size: 14px;text-align: center;padding:10px 0px;\">没有数据显示</div></li>";
			    		}
			    		$(".cardlist").append(html);
			    	}else{
			    		alert(data.errMsg);
			    	}
			    }
			})
		}
		
		function choose(obj){
			var id = $(obj).attr("value");
			var name = $(obj).html();
			$("#customers").hide();
			$("#fieldname_customerid").val(id);
			$("#fieldname_customername").val(name);
		}
		
		function goBack(){
			$("#customers").hide();
		}
		
		function saveData(){
			$(".cardloading").show();

			var fieldname_customername = $("#fieldname_customername").val();
			if(''==fieldname_customername){
                $(".cardloading").hide();
                alert("公司名称不能为空！");
                return;
			}

			var customerid = $("#fieldname_customerid").val();
			if(''==customerid){
               	var m = confirm("是否新建客户？");
               	if(m==true){
                    saveNewCustomer(customerid);
                   	// $(".cardloading").hide();
                   	// location.href="#&/mobile/plugin/crm_new/cardCustomers.jsp?sep=true&customername="+fieldname_customername;
				}else{
                    $(".cardloading").hide();
                    return;
                   	// saveNewCustomer(customerid);
               	}
			}else{
                saveNewCustomer(customerid);
			}
		}
        function saveNewCustomer(customerid){
            var params = $("#saveform").serialize();
            params+="&fieldname_customerid="+customerid;
            $.ajax({
                url: '/mobile/plugin/crm_new/cardAction.jsp?action=savedata&rd='+Math.random(),
                type: 'POST',
                data: params,
                dataType:"json",
                success:function(data){
                    $(".cardloading").hide();
                    if(data.status==1){
                        $("#cardSave").attr("disabled","disabled");
                        $("#cardSave").css("background-color","#666");
                        alert('保存成功');
                        CRM.refreshCrmList();
                        location.href="#/mobile/plugin/crm_new/contacter.jsp?id="+data.contacterId;
                    }else{
                        alert(data.errMsg);
                    }
                }
            })
        }
		
		$.fn.ImgZoomIn = function () {
            var window_h = $(window).height();
            var scroll_h = $(window).scrollTop();

            bgstr = '<div id="ImgZoomInBG" style="position: absolute;filter:Alpha(Opacity=70); opacity:0.7;z-index: 10000;background-color: #000;display: none;"></div>';
            imgstr = '<img id="ImgZoomInImage" src="' + $(this).attr('src')+'" style="cursor:pointer; display:none; position:absolute; z-index:10001;" />';
            if ($('#ImgZoomInBG').length < 1) {
                $('body').append(bgstr);
            }
            if ($('#ImgZoomInImage').length < 1) {
                $('body').append(imgstr);
            }
            else {
                $('#ImgZoomInImage').attr('src', $(this).attr('src'));
            }
			
            $('#ImgZoomInBG').css('top', scroll_h+'px');
            $('#ImgZoomInBG').css('left', '0px');
            $('#ImgZoomInBG').css('width', '100%');
            $('#ImgZoomInBG').css('height', window_h+'px');

            $('#ImgZoomInImage').css('width', '100%');
            $('#ImgZoomInImage').css('height', (window_h)+'px');
            $('#ImgZoomInImage').css('top', scroll_h+'px');
            $('#ImgZoomInImage').css('left', '0px');

            $('#ImgZoomInBG').show();
            $('#ImgZoomInImage').show();
        };

        
        $(document).ready(function () {
            $(document).on('touchend','.item_img',function (t){
                $(this).ImgZoomIn();
                document.ontouchstart=function(){
                    return false;
                }
                t.preventDefault();
            });

            $(document).on('touchend','#ImgZoomInImage',function(t){
                $('#ImgZoomInImage').hide();
                $('#ImgZoomInBG').hide();
                document.ontouchstart=function(){
                    return true;
                }
                t.preventDefault();
            });
        });
	</script>
  </body>
</html>
