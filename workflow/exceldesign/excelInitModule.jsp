
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link type="text/css" rel="stylesheet" href="/workflow/exceldesign/css/excel_wev8.css"/>
<%
	String wfid= Util.null2String(request.getParameter("wfid"));
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	String modeid = Util.null2String(request.getParameter("modeid"));
	String layouttype = Util.null2String(request.getParameter("layouttype"));
	String fromwhere = Util.null2String(request.getParameter("fromwhere"));	//区分节点属性批量设置进来的
	String isfieldisplay = "display:block";
%>
<HTML><HEAD>
	
</HEAD>
<BODY>
<div class="editor_nav newcolor">
    <div class="container">
        <div class="btns">
            <span title="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" class="close" onclick="parentDialog.close();"> </span>&nbsp;
        </div>
        <div class="moduleHeadStep">
        	<span name="ssstep" class="step1" style="padding-left:30px;"><%=SystemEnv.getHtmlLabelNames("68,82113",user.getLanguage()) %></span>
        </div>
        <div class="moduleHeadSplitLine" style="width:215px;"></div>
        <div class="moduleStep4Field"></div>
        <div class="moduleStep4Style"></div>
        <div class="moduleStep4Complete"></div>
    </div>
</div>
<div id="loadingdiv" style="font-size: 14px;text-align: center;line-height: 400px;"><span style="border: 1px solid #e1e1e1;text-align: center;color: #59627c;padding:9px;padding-left:15px;padding-right:15px;"><img src="/workflow/exceldesign/image/shortBtn/onload_wev8.png" border="no" style="position: relative;top: 3px;margin-right: 10px;" /> <span><%=SystemEnv.getHtmlLabelName(128943 ,user.getLanguage()) %></span></span></div>
<div style="width:100%;height:100%;">
	<div class="moduleContainter" style="display:none;">
		<%if((layouttype.equals("2") || layouttype.equals("1")) && !"initdetail".equals(fromwhere)){
			
			isfieldisplay = "display:none";
		} %>
		<div class="fieldContainer" style="width:100%;height:100%;overflow-x:hidden;overflow-y:auto;border-top: 1px solid #ececec;<%=isfieldisplay %>">
			<%if("initdetail".equals(fromwhere)){ %>
				<jsp:include page="/workflow/exceldesign/editDetailFieldAttr.jsp">
					<jsp:param name="nodeid" value="<%=nodeid %>" />
					<jsp:param name="layouttype" value="<%=layouttype %>" />
					<jsp:param name="formid" value='<%=request.getParameter("formid") %>' />
					<jsp:param name="isbill" value='<%=request.getParameter("isbill") %>' />
					<jsp:param name="detailindex" value='<%=request.getParameter("detailindex") %>' />
					<jsp:param name="viewonly" value='<%=Util.null2String(request.getParameter("viewonly")) %>' />
				</jsp:include>
			<%}else{ %>
			<jsp:include page="/workflow/workflow/edithtmlnodefield.jsp">
				<jsp:param name="wfid" value="<%=wfid %>" />
				<jsp:param name="ajax" value="1"/>
				<jsp:param name="nodeid" value="<%=nodeid %>"/>
				<jsp:param name="isExcel" value="1"/>
				<jsp:param name="modeid" value="<%=modeid %>"/>
				<jsp:param name="design" value="0"/>
				<jsp:param name="eloutype" value="<%=layouttype %>" />
			</jsp:include>
			<%} %>
		</div>
		
		<div class="styleContainer" style="display:none;overflow-y:auto;">
			<div class="styleDiv">
				<input type=checkbox notBeauty=true name="styleCheck" checked /> <span name="checkstylename"><%=SystemEnv.getHtmlLabelName(24518,user.getLanguage()) %></span>
				<div target=1 class="style1 selected" issys="sys">
					<div name="e_style_1" class="tylelement" style="text-align:left;">
						<div name="_label1" style="width: 60px;height:31px;line-height:31px;float: left;border: 1px solid #90badd;padding-left: 10px;background:#e7f3fc"><%=SystemEnv.getHtmlLabelName(31644,user.getLanguage()) %></div>
						<div name="_field1" style="border: 1px solid #90badd;padding-left: 80px;height:31px;line-height:31px;"><%=SystemEnv.getHtmlLabelName(33473,user.getLanguage()) %></div><!--表单内容  -->
						<div name="_label1" style="float: left;width: 60px;height:31px;line-height:31px;border: 1px solid #90badd;padding-left: 10px;margin-top: -1px;background:#e7f3fc;"><%=SystemEnv.getHtmlLabelName(31644,user.getLanguage()) %></div>
						<div name="_field1" style="border: 1px solid #90badd;margin-top: -1px;padding-left: 80px;height:31px;line-height:31px;"><%=SystemEnv.getHtmlLabelName(33473,user.getLanguage()) %></div>
						<div name="_label1" style="width: 95px;height:31px;line-height:31px;float: left;border: 1px solid #90badd;padding-left: 10px;background:#e7f3fc;margin-top: -1px;"><%=SystemEnv.getHtmlLabelName(31644,user.getLanguage()) %></div>
						<div name="_label1" style="border: 1px solid #90badd;padding-left: 115px;margin-top: -1px;background:#e7f3fc;height:31px;line-height:31px;"><%=SystemEnv.getHtmlLabelName(31644,user.getLanguage()) %></div>
						<div name="_field1" style="float: left;width: 95px;border: 1px solid #90badd;padding-left: 10px;margin-top: -1px;height:31px;line-height:31px;"><%=SystemEnv.getHtmlLabelName(33473,user.getLanguage()) %></div>
						<div name="_field1" style="border: 1px solid #90badd;margin-top: -1px;padding-left: 115px;height:31px;line-height:31px;"><%=SystemEnv.getHtmlLabelName(33473,user.getLanguage()) %></div>
					</div>
				</div>
			</div>
			
		</div>
		<div class="completeContainer" style="display:none;">
			<%=SystemEnv.getHtmlLabelName(128944,user.getLanguage()) %>
		</div>
	</div>
    <div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<%if("0".equals(layouttype) || "initdetail".equals(fromwhere)){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(1876,user.getLanguage()) %>" id="prevStepBtn" style="display:none" class="zd_btn_cancle" onclick="onPrevStep()">
					<%}%>
					<%if("batchset".equals(fromwhere)){ %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="saveAttrBtn" class="zd_btn_cancle" onclick="onSaveSttr()">
					<%} %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage()) %>" id="nextStepBtn"  class="zd_btn_cancle" onclick="onNextStep()">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="cancelBtn"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
				</wea:item>
			</wea:group>
		</wea:layout>      
	  </div>
</div>
	<script type="text/javascript">
		var dialog;
		var layouttype = "<%=layouttype%>";
		var fromwhere = "<%=fromwhere%>";
		jQuery(document).ready(function(){
			
			$("#loadingdiv").hide();
			$(".moduleContainter").show();
			$("span.e8_sep_line:first").css("display","none");
			$(".styleContainer").css("height",$(".moduleContainter").height()+"px")
			//导致Chrome下页面空白 liuzy
			//$(".styleContainer").perfectScrollbar();
			
			dialog = window.top.getDialog(window);
			if((layouttype === "2" || layouttype === "1") && fromwhere !== "initdetail")
				$("#nextStepBtn").trigger("click");
				
			var e_style_1 = $(".styleContainer").children("div.styleDiv").eq(0);
    		//初始化样式2
			var e_style_2 = $(e_style_1).clone();
			$(e_style_2).find("div[name^=_label],div[name^=_field]").css("border-color","#dcc68f");
			$(e_style_2).find("div[name^=_label]").css("background","#fbf7e7");
			$(e_style_2).find("div.style1").attr("target","2").removeClass("selected").attr("issys","sys");
			$(e_style_2).find("span[name=checkstylename]").text("<%=SystemEnv.getHtmlLabelName(127980,user.getLanguage()) %>");//橙色
			$(e_style_2).find("[name=styleCheck]").attr("checked",false);
			$(e_style_2).find(".jNiceCheckbox").removeClass("jNiceChecked");
			$(".styleContainer").append(e_style_2);
			
			//初始化样式3
			var e_style_3 = $(e_style_1).clone();
			$(e_style_3).find("div[name^=_label],div[name^=_field]").css("border-color","#8acc97");
			$(e_style_3).find("div[name^=_label]").css("background","#e7fdec");
			$(e_style_3).find("div.style1").attr("target","3").removeClass("selected").attr("issys","sys");
			$(e_style_3).find("span[name=checkstylename]").text("<%=SystemEnv.getHtmlLabelName(127981,user.getLanguage()) %>");
			$(e_style_3).find("[name=styleCheck]").attr("checked",false);
			$(e_style_3).find(".jNiceCheckbox").removeClass("jNiceChecked");
			$(".styleContainer").append(e_style_3);
			
			//初始化样式4
			var e_style_4 = $(e_style_1).clone();
			$(e_style_4).find("div[name^=_label],div[name^=_field]").css("border-color","#dba8a8");
			$(e_style_4).find("div[name^=_label]").css("background","#fce9e8");
			$(e_style_4).find("div.style1").attr("target","4").removeClass("selected").attr("issys","sys");
			$(e_style_4).find("span[name=checkstylename]").text("<%=SystemEnv.getHtmlLabelName(24520,user.getLanguage()) %>");
			$(e_style_4).find("[name=styleCheck]").attr("checked",false);
			$(e_style_4).find(".jNiceCheckbox").removeClass("jNiceChecked");
			$(".styleContainer").append(e_style_4);
			
			//初始化样式5
			var e_style_5 = $(e_style_1).clone();
			$(e_style_5).find("div[name^=_label],div[name^=_field]").css("border-color","#c3a2d4");
			$(e_style_5).find("div[name^=_label]").css("background","#f6eafb");
			$(e_style_5).find("div.style1").attr("target","5").removeClass("selected").attr("issys","sys");
			$(e_style_5).find("span[name=checkstylename]").text("<%=SystemEnv.getHtmlLabelName(127982,user.getLanguage()) %>");
			$(e_style_5).find("[name=styleCheck]").attr("checked",false);
			$(e_style_5).find(".jNiceCheckbox").removeClass("jNiceChecked");
			$(".styleContainer").append(e_style_5);
			
			//初始化样式6
			var e_style_6 = $(e_style_1).clone();
			$(e_style_6).find("div[name^=_label],div[name^=_field]").css("border-color","#d7db9b");
			$(e_style_6).find("div[name^=_label]").css("background","#fcfde8");
			$(e_style_6).find("div.style1").attr("target","6").removeClass("selected").attr("issys","sys");
			$(e_style_6).find("span[name=checkstylename]").text("<%=SystemEnv.getHtmlLabelName(24519,user.getLanguage()) %>");
			$(e_style_6).find("[name=styleCheck]").attr("checked",false);
			$(e_style_6).find(".jNiceCheckbox").removeClass("jNiceChecked");
			$(".styleContainer").append(e_style_6);
			
			$.ajax({
				url : "/workflow/exceldesign/excelStyleOperation.jsp",
				type : "post",
				data : {method:"searchall"},
				dataType:"JSON",
				success : function do4Success(msg){
					try{
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
		});
		
		var _step = 0;
		function onPrevStep(){
			_step --;
			if(_step <0)_step=0;
			if(_step == 0){
				jQuery("#prevStepBtn").css("display","none").next().css("display","none");
			}
			if(_step == 0){
				jQuery("#nextStepBtn").val("<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage()) %>");
				jQuery("#saveAttrBtn").css("display","").next().css("display","");
			}
			transformStep(_step);
		}
		
		function onNextStep(){
			var needConfirm = "<%=Util.getIntValue(modeid)>0 %>";
			if(_step == 1 && needConfirm == "true" && fromwhere !== "initdetail"){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(125558,user.getLanguage()) %>",function(){
					onNextStepExec();
				});
			}else{
				onNextStepExec();
			}
		}
		
		function onNextStepExec(){
			if(_step == 0 && fromwhere === "initdetail"){	//明细初始化未勾选字段不允许下一步
				if(judgeHavaCheckField())
					return;
			}
			_step ++;
			$("#prevStepBtn").css("display","").next().css("display","");;
			if(_step>2)_step=2
			if(_step == 1){
				jQuery("#nextStepBtn").val("  <%=SystemEnv.getHtmlLabelName(555,user.getLanguage()) %> ");
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
				jQuery("span[name=ssstep]").text('<%=SystemEnv.getHtmlLabelNames("68,82113",user.getLanguage()) %>');
				jQuery(".fieldContainer").show();
				jQuery(".styleContainer").hide();
				jQuery(".completeContainer").hide();
			}else if(whichstep == 1){
				jQuery(".moduleStep4Style").addClass("moduleStep4Style_hot");
				jQuery(".moduleStep4Complete").removeClass("moduleStep4Complete_hot");
				jQuery(".moduleHeadSplitLine").css("width","415px");
				jQuery("span[name=ssstep]").removeAttr("class").addClass("step2");
				jQuery("span[name=ssstep]").text("<%=SystemEnv.getHtmlLabelName(128945,user.getLanguage()) %>");
				jQuery(".fieldContainer").hide();
				jQuery(".styleContainer").show();
				jQuery(".completeContainer").hide();
			}else if(whichstep == 2){
				jQuery(".moduleStep4Style").addClass("moduleStep4Style_hot");
				jQuery(".moduleStep4Complete").addClass("moduleStep4Complete_hot");
				jQuery(".moduleHeadSplitLine").css("width","615px");
				jQuery("span[name=ssstep]").removeAttr("class").addClass("step3");
				jQuery("span[name=ssstep]").text("<%=SystemEnv.getHtmlLabelName(555,user.getLanguage()) %>");
				jQuery(".fieldContainer").hide();
				jQuery(".styleContainer").hide();
				jQuery(".completeContainer").show();
			}
		}
		
		function submitInit(){
			$("#zDialog_div_bottom").hide();
			var wc = $(".styleDiv").find(".style1.selected").attr("target");
			var issys = $(".styleDiv").find(".style1.selected").attr("issys");
			jQuery(".fieldContainer").find("#excelStyle").val(wc);
			jQuery(".fieldContainer").find("#excelIssys").val(issys);
			if(fromwhere === "initdetail"){
				confirmInitDetail();	//调用editDetailFieldAttr.jsp方法
				return;
			}else if(fromwhere === "batchset"){
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
			parentWin.setInitModule(excelStyle,"<%=nodeid%>",modeid);
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

	</script>
</BODY>
</HTML>