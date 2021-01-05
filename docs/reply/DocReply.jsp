<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.FileUpload"%>

<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
String docid = fu.getParameter("docid");
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
String fromTab = fu.getParameter("fromTab");
int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int annexmainId=0;
int annexsubId=0;
int annexsecId=0;
%>
<form id=weaver name=weaver action="UploadDoc.jsp" method="post">
	<!-- 文档编号 -->
	<input type="hidden" id="optype" name="optype" value="reply" />
	<!-- 文档编号 -->
	<input type="hidden" id="docid" name="docid" value="<%= docid %>" />
	<!-- 回复人编号 -->
	<input type="hidden" id="userid" name="userid" value="<%= user.getUID() %>">
	<!-- 被回复的回复人编号 -->
	<input type="hidden" id="replyuserid" name="replyuserid" value="<%= user.getUID() %>">
	<!-- 被回复的回复编号 -->
	<input type="hidden" id="replyid" name="replyid" value="-1">
	<!-- 回复类型 -->
	<input type="hidden" id="replytype" name="replytype" value="0">
	<!-- 插入图片的图片ID -->
	<input type="hidden" id="imgFileids" name="imgFileids" value="">
	<!-- 插入图片的图片名称 -->
	<input type="hidden" id="imgFilenames" name="imgFilenames" value="">
	<!-- 相关文档的文档ID -->
	<input type="hidden" id="signdocids" name="signdocids" value="" />
	<!-- 相关文档的文档标题 -->
	<input type="hidden" id="signdocnames" name="signdocnames" value="" />
	<!-- 相关流程的流程ID -->
	<input type="hidden" id="signworkflowids" name="signworkflowids" value="" />
	<!-- 相关流程的流程名称 -->
	<input type="hidden" id="signworkflownames" name="signworkflownames" value="" />
	<!-- 上传附件的附件ID -->
	<input type=hidden id="field-annexupload" name="field-annexupload" value="">
	<!-- 上传附件的附件名称 -->
	<input type="hidden" name="field-annexupload-name" id="field-annexupload-name" value="">
	<!-- 上传附件的附件数量 -->
	<input type="hidden" name="field-annexupload-count" id="field-annexupload-count" value="">
	<!-- 删除附件的附件ID -->
	<input type=hidden id="field_annexupload_del_id" name="field_annexupload_del_id" value="">
	<!--  -->
	<input type=hidden name='annexmainId' id='annexmainId' value=<%=annexmainId%>>
	<!--  -->
	<input type=hidden name='annexsubId' id='annexsubId' value=<%=annexsubId%>>
	<!--  -->
	<input type=hidden name='annexsecId' id='annexsecId' value=<%=annexsecId%>>
	<!--  -->
	<input type=hidden name='fileuserid' id='fileuserid' value=<%=userid%>>
	<!--  -->
	<input type=hidden name='fileloginyype' id='fileloginyype' value=<%=logintype%>>
<div class='flowsign' style='z-index: 10;background-color: #F7F7F7;'>
	<div class="fieldset flash" id="fsUploadProgressannexuploadSimple"
		style='position: absolute; left: 10px; width: 300px; opacity: 1;'>
	</div>
	<table cellspacing="0" cellpadding="0" width="100%" border="0">
		<COLGROUP>
			<COL width="*">
		</COLGROUP>
		<tr>
			<td
				style="border: 1px solid #cccccc; border-right: 1px solid #cccccc !important;">
				<input type="hidden" id="remarkText10404" name="remarkText10404"
					temptitle="<%=SystemEnv.getHtmlLabelName(126377,user.getLanguage())%>"
					value="">

				<div id="remarkShadowDiv" name="remarkShadowDiv"
					style="display: inline-block; width: 100%;">
					<div id="remarkShadowDivInnerDiv"
						style="margin: 10px 10px; height: 30px; border: 1px solid #d6d6d6; background: #fff; color: #a2a2a2; cursor: pointer;"
						onclick="initRemark()"
						title="<%=SystemEnv.getHtmlLabelName(126377,user.getLanguage())%>">
						<span style="margin: 0 5px;"><img
								style="vertical-align: middle;" src="/images/sign/sign_wev8.png"></img>
						</span>
						<span style="line-height: 30px;"><%=SystemEnv.getHtmlLabelName(126377,user.getLanguage())%></span>
					</div>
				</div>
				<div style="display: none;" class="remarkDiv">
				<!-- <div style="background-color: #f0f0ee; line-height: 30px;  width: 100%;"> <span style="padding-left:15px; font-size: 12px;">写回复</span> </div>  -->
					<textarea name=remark id=remark
						style="width: 100%; height: 140px; margin: 0; resize: none; color: #a2a2a2; overflow: auto; color: #c7c7c7;"
						temptitle="<%=SystemEnv.getHtmlLabelName(17614, user.getLanguage())%>"></textarea>
						<div id="btnDiv" style="background-color: #f0f0ee;font-size: 12px;height: 40px;line-height: 40px;">
							<div  onclick="cenReply();" class="celBtn1"><%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%></div>
							<div onclick="submitForm();" class="submitBtn1"><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></div>
						</div>
				</div>
			</td>

		</tr>
	</table>

</div>
</form>
<script type="text/javascript">	
	var _ueditorMain = '';
	function submitForm()
	{
	        var _remarkTxt = _ueditorMain.getContentTxt();
				var _remarkHtmlstr = _ueditorMain.getContent();
	        	if((_remarkTxt == "" &&  _remarkHtmlstr == "") && $("#signworkflowids").val() == '' && $("#signdocids").val() == '' && $("#field-annexupload").val() == ''){
	        		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126383,user.getLanguage())%>");
	        		setTimeout(function(){
	        			top.Dialog.close();
	        		},2000);
	        	}	
	       	else
	       	{
	       		$(".submitBtn1").attr("disabled",true); 
	    		$(".celBtn1").attr("disabled",true); 
	       		$.ajax({
					   type: "POST",
					   url: "UploadDoc.jsp",
					   data: $('#weaver').serialize(),
					   dataType:"json",
					   success:function(docReplyModel){
					   		iframepage.window.$("#imDefaultdiv").hide();
					   	//	iframepage.window.fullDocReplyMain(docReplyModel,false,true);
					   		iframepage.window.replyNewsAll(docReplyModel,false,true);
					   		
					   		
					   	//	if(iframepage.window.ishave)
					   	//	{
					   	//		iframepage.window.residueAllReply($("#docid").val());
					   	//	}
					   	//	else
					   	//	{
					   	//		iframepage.window.fullDocReplyMain(docReplyModel,false,true);
					   	//	}
					   	// 改写回复总数
					   			var replyCountText = $("#divReplayATabTitle",window.parent.parent.document).text();
					   			replyCountText = replyCountText.substr(replyCountText.lastIndexOf(";")+1);
					   			var replyCount = replyCountText.substr(replyCountText.lastIndexOf("(")+1,replyCountText.lastIndexOf(")"));
					   			var replyCountAdd = parseInt(replyCount);
					   			replyCountAdd = replyCountAdd + 1;
					   			$("#divReplayATabTitle",window.parent.parent.document).text(replyCountText.replace(replyCount,replyCountAdd)+")");
					    }
					});
					cenReply();
	       	} 	
	}

	function cenReply()
	{
		$(".submitBtn1").attr("disabled",false); 
	    $(".celBtn1").attr("disabled",false); 
		_ueditorMain.setContent("");
       	$("#replyid").val('-1');
		$("#replytype").val("0");
		$("#replymainid").val("");
		$("#replyuserid").val(<%= user.getUID() %>);
		$("#signdocids").val('');
		$("#signworkflowids").val('');
		$("#field-annexupload").val('');
		$("#field-annexupload-name").val('');
		$("#field-annexupload-count").val('');
		jQuery("#_fileuploadphraseblock").find("#_filecontentblock ul").empty();
		$("#_fileuploadphraseblock").css("top","-100px");
        $("#_fileuploadphraseblock").css("z-index","99");
		jQuery(".edui-for-wfdocbutton").children("div").children("div").children("div").children(".edui-metro").removeClass("wfres_2_slt");
		jQuery(".edui-for-wfdocbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_2");
		jQuery(".edui-for-wfwfbutton").children("div").children("div").children("div").children(".edui-metro").removeClass("wfres_3_slt");
		jQuery(".edui-for-wfwfbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_3");
		jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro").removeClass("wfres_1");
		jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_1_slt");
		x = 0;
		jQuery("#fsUploadProgressfileuploaddiv").empty("");
		$(".edui-for-wfannexbutton").css("visibility","hidden");
		
		_ueditorMain.body.style.overflowY = "hidden";
		_ueditorMain.autoHeightEnabled = true;
        _ueditorMain.enableAutoHeight();
        _ueditorMain.ui._fullscreen = true;
		initremarkueditor();
		jQuery(".remarkDiv").hide();
		jQuery("#btnDiv").hide();
		jQuery("#remarkShadowDiv").show();
		_ueditorMain.focus(false);
	}
$(function(){
	// setTimeout(function () {
		initremarkueditor();
	// }, 1000);
});
	var __bsV = 99;
	var __isIE = false;
	window.__ueditready = false;
	window._isremarkcomp = false;
	try {
		__bsV = jQuery.client.browserVersion.version; 
		__isIE = jQuery.client.browser=="Explorer"?"true":"false";
	} catch (e) {
	}
	
	function initremarkueditor() {
		if (__isIE && __bsV <= 9) {
			setTimeout(function () {
				initremarkueditor2();
			}, 200);
		} else {
			initremarkueditor2();
		}
	}

	function initremarkueditor2() {
		if (__isIE && __bsV <= 9) {
			if (window.__ueditready != undefined && window.__ueditready > 0) {
				setTimeout(function () {
					initremarkueditor();
				}, 500); 
				return;
			} 
		}
		_ueditorMain = UEUtil.initRemark('remark');
       	bindRemark(_ueditorMain);
        if (window.__isremarkPage == true) {
        	initRemark();
        	jQuery("#_wfsigninputIvt").hide();
        }
        jQuery(".edui-for-wfannexbutton").css("cursor","pointer");
        try {
   			var _targetobj = jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro");
        	if (document.getElementById("field-annexupload").value != '') {
        		_targetobj.addClass("wfres_1_slt");
        		_targetobj.removeClass("wfres_1");
        	} else {
        		_targetobj.addClass("wfres_1");
        		_targetobj.removeClass("wfres_1_slt");
        	}
        } catch (e) {}
	}
	
	function initRemark(isinit){
		if (!!!isinit) {
			remarkfocus();
		}
	}
	
	/**
	 * 获取焦点
	 */
	function remarkfocus() {
		if (window.__ueditready == false) {
        	setTimeout(function () {
        		 remarkfocus();
        	}, 1000);
        	return;
        }
        else
        {
        	jQuery("#btnDiv").show();
			jQuery("#remarkShadowDiv").hide();
			jQuery(".remarkDiv").show();
			_ueditorMain.focus(true);
        }
	}
	
	function autoscroll4remark() {
		try {
			var remarkscrolltop = jQuery("#remark").offset().top;
			jQuery(document.body).animate({scrollTop : remarkscrolltop + "px"}, 500);
		} catch(e) {}
	}


	
	function triggerMouseupHandle(e) {
		//转发页面不隐藏
		if (window.__isremarkPage == true) {
			return;
		}
		var _remarkTxt = _ueditorMain.getContentTxt();
		var _remarkHtmlstr = _ueditorMain.getContent().replace(/<p><\/p>/g, "");
       	if(_remarkHtmlstr == ""){
       		jQuery("#btnDiv").hide();
       		jQuery(".remarkDiv").hide();
       		jQuery("#remarkShadowDiv").show();
       	}
	}
	function hideRemark() {
			if(!!!_ueditorMain)
			{
					jQuery(".remarkDiv").hide();
	        		jQuery("#btnDiv").hide();
	        		jQuery("#remarkShadowDiv").show();
			}
			else
			{
				//转发页面不隐藏
				if (window.__isremarkPage == true) {
					return;
				}
				var banfold = jQuery("#fsUploadProgressfileuploaddiv").attr("banfold");
					var _remarkTxt = _ueditorMain.getContentTxt();
				var _remarkHtmlstr = _ueditorMain.getContent();
	        	if((_remarkTxt == "" &&  _remarkHtmlstr == "") && $("#signworkflowids").val() == '' && $("#signdocids").val() == '' && $("#field-annexupload").val() == ''){
		        		_ueditorMain.body.style.overflowY = "hidden";
						_ueditorMain.autoHeightEnabled = true;
				        _ueditorMain.enableAutoHeight();
				        _ueditorMain.ui._fullscreen = true;
		        		jQuery(".remarkDiv").hide();
		        		jQuery("#btnDiv").hide();
		        		jQuery("#remarkShadowDiv").show();
		        	}
			}
			
		};
	
	//对编辑器添加焦点监听,增加按钮，并使编辑器获得焦点
	function bindRemark(_uEditor){
		var remarkHide = function (e) {
			//转发页面不隐藏
			if (window.__isremarkPage == true) {
				return;
			}
			var banfold = jQuery("#fsUploadProgressfileuploaddiv").attr("banfold");
			if (e.which == 1 && jQuery(e.target).parents('.remarkDiv,.edui-popup,.edui-dialog,.filtercontainer, ._signinputphraseblockClass').length <= 0 && banfold != "1") {
				var _remarkTxt = _uEditor.getContentTxt();
				var _remarkHtmlstr = _uEditor.getContent().replace(/<p><\/p>/g, "");
	        	if((_remarkTxt == "" && _remarkHtmlstr.indexOf('<img src=') < 0) || _remarkHtmlstr == ""){
	        		_uEditor.body.style.overflowY = "hidden";
					_uEditor.autoHeightEnabled = true;
			        _uEditor.enableAutoHeight();
			        _uEditor.ui._fullscreen = true;
	        		jQuery(".remarkDiv").hide();
	        		jQuery("#btnDiv").hide();
	        		jQuery("#remarkShadowDiv").show();
	        	}
				e.stopPropagation();
			}
		};

		jQuery("html").live('mousedown', remarkHide);
		_uEditor.ready(function(){
	        jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_1");
			jQuery(".edui-for-wfdocbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_2");
			jQuery(".edui-for-wfwfbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_3");
			window._isremarkcomp = true;
			window.__ueditready = true;
			if(<%= fromTab.equals("1") %>)
			{
				jQuery("#btnDiv").show();
				jQuery("#remarkShadowDiv").hide();
				jQuery(".remarkDiv").show();
				_uEditor.focus(true);
			}
		});
	}



function onShowSignBrowser4signinput(url, linkurl, inputname, spanname, type1, countEleID) {
    if(top.Dialog._Array.length == 0){
    	jQuery("[id^=Consult]").hide();
    }
    var tmpids = jQuery("#" + inputname).val();
    var url;
     if (type1 === 37) {
					   url = "/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>&url=" + url + "?documentids=" + tmpids + uescape("&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>");
				    } else {
				        url = "/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1) %>&url=" + url + "?resourceids=" + tmpids + uescape("&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>");
				    }
    var dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    dialog.callbackfunParam = null;
    dialog.URL = url;
    dialog.callbackfun = function (paramobj, id1) {
        if (id1) {
            if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
                var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
                var sHtml = "";
                resourceids = resourceids.substr(0);
                resourcename = resourcename.substr(0);
                var resourceidArray = resourceids.split(",");
                var resourcenameArray = resourcename.split(",");
                
               
	            for (var _i = 0; _i < resourceidArray.length; _i++) {
	                var curid = resourceidArray[_i];
	                var curname = resourcenameArray[_i];
	                if (type1 === 37) {
	                	jQuery("#signdocnames").val(jQuery("#signdocnames").val()+"////~~weaversplit~~////"+curname);
	                	jQuery("#" + inputname).val(jQuery("#" + inputname).val()+","+curid);
	                    sHtml = sHtml + "<a href='/docs/docs/DocDsp.jsp?id=" + curid + "&isrequest=1'  target='_blank' title='" + curname + "' style=\"color:#123885;\" >" + curname + "</a>&nbsp;&nbsp;";
	                } else {
	                	jQuery("#signworkflownames").val(jQuery("#signworkflownames").val()+"////~~weaversplit~~////"+curname);
	                	jQuery("#" + inputname).val(jQuery("#" + inputname).val()+","+curid);
	                	sHtml += "<a href='/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid="+curid+"&isrequest=1' target='_blank' style=\"color:#123885;\">"+curname+ "</a>&nbsp;&nbsp;";
	                }
	            }
	            jQuery("#" + countEleID).html(sHtml);
	            var editorid = "remark"; 
	            try{
	            	UE.getEditor(editorid).setContent(" &nbsp;" + sHtml, true);
	            }catch(e){}
	            try {
	            	var _targetobj;
					var _targetobjimg = "";
					var _targetobjClass = "";
            		if (type1 == 152) { //相关流程
            			_targetobj = jQuery(".edui-for-wfwfbutton").children("div").children("div").children("div").children(".edui-metro");
            			_targetobjClass = "wfres_3";
            		} else {
            			_targetobj = jQuery(".edui-for-wfdocbutton").children("div").children("div").children("div").children(".edui-metro");
            			_targetobjClass = "wfres_2";
            		}
	            	if (resourceidArray.length != 0) {
	            		_targetobj.addClass(_targetobjClass + "_slt");
	            		_targetobj.removeClass(_targetobjClass);
	            	} else {
	            		_targetobj.addClass(_targetobjClass);
	            		_targetobj.removeClass(_targetobjClass + "_slt");
	            	}
	            } catch (e) {}
            } else {
                jQuery("#" + inputname).val("");
                if (!! countEleID) {
                    jQuery("#" + countEleID).children("Table").find("TD[class=signcountClass_center]").html("0");
                    jQuery("#" + countEleID).hide();
                }
                
                try {
	            	var _targetobj;
					var _targetobjimg = "";
					var _targetobjClass = "";
            		if (type1 == 152) { //相关流程
            			_targetobj = jQuery(".edui-for-wfwfbutton").children("div").children("div").children("div").children(".edui-metro");
            			_targetobjClass = "wfres_3";
            		} else {
            			_targetobj = jQuery(".edui-for-wfdocbutton").children("div").children("div").children("div").children(".edui-metro");
            			_targetobjClass = "wfres_2";
            		}
            		_targetobj.addClass(_targetobjClass);
	                _targetobj.removeClass(_targetobjClass + "_slt");
	            } catch (e) {}
            }
        }
    };
    dialog.Height = 620 ;
    if (type1 === 37) {
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>";
    }else{
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>";
	    if(jQuery.browser.msie){
			dialog.Height = 570;
		}else{
			dialog.Height = 570;
		}
    }
    
    dialog.Drag = true;
    dialog.show();
}
</script>