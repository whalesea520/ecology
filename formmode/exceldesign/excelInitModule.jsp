
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link type="text/css" rel="stylesheet" href="/formmode/exceldesign/css/excel_wev8.css"/>
<%
	String modeid= Util.null2String(request.getParameter("modeid"));
	String formid = Util.null2String(request.getParameter("formid"));
	String layoutid = Util.null2String(request.getParameter("layoutid"));
	String layouttype = Util.null2String(request.getParameter("layouttype"));
	String isdefault = Util.null2String(request.getParameter("isdefault"));
	String fromwhere = Util.null2String(request.getParameter("fromwhere"));	//区分节点属性批量设置进来的
	String isfieldisplay = "display:block";
%>
<HTML><HEAD>
	
</HEAD>
<BODY>
<div class="editor_nav newcolor">
    <div class="container">
        <div class="btns">
            <span title="关闭" class="close" onclick="parentDialog.close();"> </span>&nbsp;
        </div>
        <div class="moduleHeadStep">
        	<span name="ssstep" class="step1" style="padding-left:30px;">设置字段属性</span>
        </div>
        <div class="moduleHeadSplitLine" style="width:215px;"></div>
        <div class="moduleStep4Field"></div>
        <div class="moduleStep4Style"></div>
        <div class="moduleStep4Complete"></div>
    </div>
</div>
<div id="loadingdiv" style="font-size: 14px;text-align: center;line-height: 400px;"><span style="border: 1px solid #e1e1e1;text-align: center;color: #59627c;padding:9px;padding-left:15px;padding-right:15px;"><img src="/formmode/exceldesign/image/shortBtn/onload_wev8.png" border="no" style="position: relative;top: 3px;margin-right: 10px;" /> <span>正在加载，请稍候...</span></span></div>
<div style="width:100%;height:100%;">
	<div class="moduleContainter" style="display:none;">
		<div class="fieldContainer" style="width:100%;height:100%;overflow-x:hidden;overflow-y:auto;border-top: 1px solid #ececec;<%=isfieldisplay %>">
			<jsp:include page="/formmode/setup/EditHtmlField.jsp">
				<jsp:param name="modeId" value="<%=modeid %>" />
				<jsp:param name="formId" value="<%=formid %>" />
				<jsp:param name="Id" value="<%=layoutid %>"/>
				<jsp:param name="type" value="<%=layouttype %>" />
				<jsp:param name="isdefault" value="<%=isdefault %>" />
				<jsp:param name="isExcel" value="1"/>
				<jsp:param name="design" value="0"/>
				<jsp:param name="fromwhere" value="<%=fromwhere %>"/>
			</jsp:include>
		</div>
		
		<div class="styleContainer" style="display:none;overflow-y:auto;">
			<div class="styleDiv">
				<input type=checkbox notBeauty=true name="styleCheck" checked /> <span name="checkstylename">蓝色</span>
				<div target=1 class="style1 selected">
					<div name="e_style_1" class="tylelement" style="text-align:left;">
						<div name="_label1" style="width: 60px;height:31px;line-height:31px;float: left;border: 1px solid #90badd;padding-left: 10px;background:#e7f3fc">字段名</div>
						<div name="_field1" style="border: 1px solid #90badd;padding-left: 80px;height:31px;line-height:31px;">表单内容</div>
						<div name="_label1" style="float: left;width: 60px;height:31px;line-height:31px;border: 1px solid #90badd;padding-left: 10px;margin-top: -1px;background:#e7f3fc;">字段名</div>
						<div name="_field1" style="border: 1px solid #90badd;margin-top: -1px;padding-left: 80px;height:31px;line-height:31px;">表单内容</div>
						<div name="_label1" style="width: 95px;height:31px;line-height:31px;float: left;border: 1px solid #90badd;padding-left: 10px;background:#e7f3fc;margin-top: -1px;">字段名</div>
						<div name="_label1" style="border: 1px solid #90badd;padding-left: 115px;margin-top: -1px;background:#e7f3fc;height:31px;line-height:31px;">字段名</div>
						<div name="_field1" style="float: left;width: 95px;border: 1px solid #90badd;padding-left: 10px;margin-top: -1px;height:31px;line-height:31px;">表单内容</div>
						<div name="_field1" style="border: 1px solid #90badd;margin-top: -1px;padding-left: 115px;height:31px;line-height:31px;">表单内容</div>
					</div>
				</div>
			</div>
			
		</div>
		<div class="completeContainer" style="display:none;">
			正在初始化模板，请稍候……
		</div>
	</div>
    <div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="上一步" id="prevStepBtn" style="display:none" class="zd_btn_cancle" onclick="onPrevStep()">
					<%if(!"batchset".equals(fromwhere)){ %>
					<input type="button" value="保存" id="saveAttrBtn" class="zd_btn_cancle" onclick="onSaveSttr()">
					<%} %>
					<input type="button" value="下一步" id="nextStepBtn"  class="zd_btn_cancle" onclick="onNextStep()">
					<input type="button" value="取消" id="cancelBtn"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>      
	  </div>
</div>
	<script type="text/javascript">
		var dialog;
		var layouttype = "<%=layouttype%>";
		jQuery(document).ready(function(){
			
			$("#loadingdiv").hide();
			$(".moduleContainter").show();
			$("span.e8_sep_line:first").css("display","none");
			$(".styleContainer").css("height",$(".moduleContainter").height()+"px")
			//导致Chrome下页面空白 liuzy
			//$(".styleContainer").perfectScrollbar();
			
			dialog = window.top.getDialog(window);
			//if(layouttype === "0" || layouttype === "3" || layouttype== "4")
			//	$("#nextStepBtn").trigger("click");
				
			var e_style_1 = $(".styleContainer").children("div.styleDiv").eq(0);
			e_style_1.attr("issys","sys");
    		//初始化样式2
			var e_style_2 = $(e_style_1).clone();
			$(e_style_2).find("div[name^=_label],div[name^=_field]").css("border-color","#dcc68f");
			$(e_style_2).find("div[name^=_label]").css("background","#fbf7e7");
			$(e_style_2).find("div.style1").attr("target","2").removeClass("selected").attr("issys","sys");
			$(e_style_2).find("span[name=checkstylename]").text("橙色");
			$(e_style_2).find("[name=styleCheck]").attr("checked",false);
			$(e_style_2).find(".jNiceCheckbox").removeClass("jNiceChecked");
			$(".styleContainer").append(e_style_2);
			
			//初始化样式3
			var e_style_3 = $(e_style_1).clone();
			$(e_style_3).find("div[name^=_label],div[name^=_field]").css("border-color","#8acc97");
			$(e_style_3).find("div[name^=_label]").css("background","#e7fdec");
			$(e_style_3).find("div.style1").attr("target","3").removeClass("selected").attr("issys","sys");
			$(e_style_3).find("span[name=checkstylename]").text("绿色");
			$(e_style_3).find("[name=styleCheck]").attr("checked",false);
			$(e_style_3).find(".jNiceCheckbox").removeClass("jNiceChecked");
			$(".styleContainer").append(e_style_3);
			
			//初始化样式4
			var e_style_4 = $(e_style_1).clone();
			$(e_style_4).find("div[name^=_label],div[name^=_field]").css("border-color","#dba8a8");
			$(e_style_4).find("div[name^=_label]").css("background","#fce9e8");
			$(e_style_4).find("div.style1").attr("target","4").removeClass("selected").attr("issys","sys");
			$(e_style_4).find("span[name=checkstylename]").text("红色");
			$(e_style_4).find("[name=styleCheck]").attr("checked",false);
			$(e_style_4).find(".jNiceCheckbox").removeClass("jNiceChecked");
			$(".styleContainer").append(e_style_4);
			
			//初始化样式5
			var e_style_5 = $(e_style_1).clone();
			$(e_style_5).find("div[name^=_label],div[name^=_field]").css("border-color","#c3a2d4");
			$(e_style_5).find("div[name^=_label]").css("background","#f6eafb");
			$(e_style_5).find("div.style1").attr("target","5").removeClass("selected").attr("issys","sys");
			$(e_style_5).find("span[name=checkstylename]").text("紫色");
			$(e_style_5).find("[name=styleCheck]").attr("checked",false);
			$(e_style_5).find(".jNiceCheckbox").removeClass("jNiceChecked");
			$(".styleContainer").append(e_style_5);
			
			//初始化样式6
			var e_style_6 = $(e_style_1).clone();
			$(e_style_6).find("div[name^=_label],div[name^=_field]").css("border-color","#d7db9b");
			$(e_style_6).find("div[name^=_label]").css("background","#fcfde8");
			$(e_style_6).find("div.style1").attr("target","6").removeClass("selected").attr("issys","sys");
			$(e_style_6).find("span[name=checkstylename]").text("黄色");
			$(e_style_6).find("[name=styleCheck]").attr("checked",false);
			$(e_style_6).find(".jNiceCheckbox").removeClass("jNiceChecked");
			$(".styleContainer").append(e_style_6);
			
			$.ajax({
				url : "/formmode/exceldesign/excelStyleOperation.jsp",
				type : "post",
				data : {method:"searchall"},
				dataType:"JSON",
				success : function do4Success(msg){
					try{
					    if(msg!=""){
							msg = jQuery.trim(msg);
							var result = JSON.parse(msg);
							for(var key in result){
								var cloneObj = $(e_style_1).clone();
								$(cloneObj).find("div[name^=_label],div[name^=_field]").css("border-color",result[key].main_border);
								$(cloneObj).find("div[name^=_label]").css("background",result[key].main_label_bgcolor);
								$(cloneObj).find("div[name^=_field]").css("background",result[key].main_field_bgcolor);
								$(cloneObj).find("div.style1").attr("target",result[key].styleid).removeClass("selected").attr("issys","cus");
								$(cloneObj).find("span[name=checkstylename]").text(result[key].stylename);
								$(cloneObj).find("[name=styleCheck]").attr("checked",false);
								$(cloneObj).find(".jNiceCheckbox").removeClass("jNiceChecked");
								$(".styleContainer").append(cloneObj);
							}
							jQuery(".styleContainer [type=checkbox]").removeAttr("notBeauty");
							jQuery('body').jNice();
						} 
						$("[name=styleCheck]").click(function(){
							if($(this).closest("div").children("div").is(".selected"))
								return;
							$(".styleDiv").each(function(){
								if($(this).children("div").is(".selected")){
									$(this).children("div").removeClass("selected");
									$(this).find("input[type=checkbox]").attr("checked",false);
									$(this).find(".jNiceCheckbox").removeClass("jNiceChecked");
								}
							});
							$(this).closest("div").children("div").addClass("selected");
						});
						$(".styleDiv").click(function(){
							if($(this).is(".selected"))
								return;
							$(".styleDiv").each(function(){
								if($(this).children("div").is(".selected")){
									$(this).children("div").removeClass("selected");
									$(this).find("input[type=checkbox]").attr("checked",false);
									$(this).find(".jNiceCheckbox").removeClass("jNiceChecked");
								}
							});
							$(this).find("input[type=checkbox]").attr("checked",true);
							$(this).find(".jNiceCheckbox").addClass("jNiceChecked");
							$(this).children("div").addClass("selected");
						});
					}catch(e){
						window.top.Dialog.alert(e.message)
					}
				}
			});
			
			jQuery(".fieldContainer").scroll(function(){
				jQuery("select").selectbox("close");
			});
		});
		
		var _step = 0;
		function onPrevStep(){
			_step --;
			if(_step <0)_step=0;
			if(_step == 0){
				jQuery("#prevStepBtn").css("display","none").next().css("display","none");
			}
			if(_step == 0){
				jQuery("#nextStepBtn").val("下一步");
				jQuery("#saveAttrBtn").css("display","").next().css("display","");
			}
			transformStep(_step);
		}
		
		function onNextStep(){
			if(_step==0){
				if(checkFieldValue("layoutname")){
					var url = "/formmode/exceldesign/excelLayoutOperation.jsp";
					var modeid = jQuery("#modeId").val();
					var formid =  jQuery("#formId").val();
					var layoutid = jQuery("#Id").val();
					var layouttype = jQuery("#type").val();
					var layoutname = jQuery("#layoutname").val();
					var paramData = {method:"checklayoutname",modeid:modeid,formid:formid,layoutid:layoutid,layouttype:layouttype,layoutname:layoutname};
					$.ajax({
					    url: url,
					    data: paramData, 
					    dataType: 'json',
					    type: 'POST',
					    success: function (res) {
					    	var result = res.result;
							if(result==0){
								window.top.Dialog.alert("当前模板名称已被使用，请修改模板名称再保存！");
								return;
							}else{
								onNextStepExec();
							}
					    }
					});
				}else{
					return;
				}
			}else if(_step == 1){
				onNextStepExec();
			}
		}
		
		function onNextStepExec(){
			_step ++;
			$("#prevStepBtn").css("display","").next().css("display","");;
			if(_step>2)_step=2
			if(_step == 1){
				jQuery("#nextStepBtn").val("  完成 ");
				jQuery("#saveAttrBtn").css("display","none").next().css("display","none");
			}
			transformStep(_step);
			if(_step == 2)
				submitInit();
		}
		//切换  上/下 一步
		function transformStep(whichstep){
			if(whichstep == 0){
				jQuery(".moduleStep4Style").removeClass("moduleStep4Style_hot");
				jQuery(".moduleStep4Complete").removeClass("moduleStep4Complete_hot");
				jQuery(".moduleHeadSplitLine").css("width","215px");
				jQuery("span[name=ssstep]").removeAttr("class").addClass("step1");
				jQuery("span[name=ssstep]").text("设置字段属性");
				jQuery(".fieldContainer").show();
				jQuery(".styleContainer").hide();
				jQuery(".completeContainer").hide();
			}else if(whichstep == 1){
				jQuery(".moduleStep4Style").addClass("moduleStep4Style_hot");
				jQuery(".moduleStep4Complete").removeClass("moduleStep4Complete_hot");
				jQuery(".moduleHeadSplitLine").css("width","415px");
				jQuery("span[name=ssstep]").removeAttr("class").addClass("step2");
				jQuery("span[name=ssstep]").text("选择样式");
				jQuery(".fieldContainer").hide();
				jQuery(".styleContainer").show();
				jQuery(".completeContainer").hide();
			}else if(whichstep == 2){
				jQuery(".moduleStep4Style").addClass("moduleStep4Style_hot");
				jQuery(".moduleStep4Complete").addClass("moduleStep4Complete_hot");
				jQuery(".moduleHeadSplitLine").css("width","615px");
				jQuery("span[name=ssstep]").removeAttr("class").addClass("step3");
				jQuery("span[name=ssstep]").text("完成");
				jQuery(".fieldContainer").hide();
				jQuery(".styleContainer").hide();
				jQuery(".completeContainer").show();
			}
		}
		
		function submitInit(){
			$("#zDialog_div_bottom").hide();
			var wc = 0;
			wc = $(".styleDiv").find(".selected").attr("target");
			var issys = $(".styleDiv").find(".selected").attr("issys");
			jQuery(".fieldContainer").find("#excelStyle").val(wc);
			jQuery(".fieldContainer").find("#excelIssys").val(issys);
			if("<%=fromwhere %>" == "batchset"){
				jQuery("#saveAttrFlag").val("2");
			}else{
				jQuery("#saveAttrFlag").val("3");
			}
			fieldbatchsave();	//其实是提交 edithtmlnodefield.jsp中的提交 表单字段方法
		}
		
		//只保存字段属性
		function onSaveSttr(){
			jQuery("#saveAttrFlag").val("1");
			fieldbatchsave();
		}
		
		//在 wf_operation.jsp 中 src = nodefieldhtml 保存表单字段后 返回给iframe，iframe初始化后调用 此方法，只要调了，说明字段已保存完毕
		function initExcel(excelStyle,modeid){
			var parentWin = parent.getParentWindow(window);
			parentWin.setInitModule(excelStyle,modeid);
			var setimeut;
			setimeut = setTimeout(function (){
				clearTimeout(setimeut);
				dialog.close();
			},3000);
		}
		
		//关闭dialog
		function closeCurDialog(){
			var parentWin = parent.getParentWindow(window);
			parentWin.location.reload();
			dialog.close();
		}
		
		function checkFieldValue(ids){
			var idsArr = ids.split(",");
			for(var i=0;i<idsArr.length;i++){
				var obj = document.getElementById(idsArr[i]);
				if(obj&&obj.value==""){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});//必要信息不完整！
					return false;
				}
			}
			return true;
	   }
	</script>
</BODY>
</HTML>