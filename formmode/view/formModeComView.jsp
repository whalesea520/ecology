<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResolveFormMode" class="weaver.formmode.view.ResolveFormMode" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
//User user = HrmUserVarify.getUser (request , response) ;
int reqModeId = Util.getIntValue(request.getParameter("reqModeId"),0);
int reqFormId = Util.getIntValue(request.getParameter("reqFormId"),0);
int reqBillid = Util.getIntValue(request.getParameter("reqBillid"),0);
int customid = Util.getIntValue(request.getParameter("customid"),0);
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
int billid = Util.getIntValue(request.getParameter("billid"),0);
int type = Util.getIntValue(request.getParameter("type"),0);//0：查看；1：创建；2：编辑；3：监控
int issubpage = Util.getIntValue(request.getParameter("issubpage"),0);
int temp_Quotesid = Util.getIntValue(request.getParameter("temp_Quotesid"),0);
int temp_Commentid = Util.getIntValue(request.getParameter("temp_Commentid"),0);
int temp_CommentTopid = Util.getIntValue(request.getParameter("temp_CommentTopid"),0);
int temp_CommentUsersid = Util.getIntValue(request.getParameter("temp_CommentUsersid"),0);
String iframeSign = Util.null2String(request.getParameter("iframeSign"));
String isEditOpt = Util.null2String(request.getParameter("isEditOpt"));
boolean isVirtualForm = VirtualFormHandler.isVirtualForm(formId);
ResolveFormMode.setRequest(request);
ResolveFormMode.setUser(user);
ResolveFormMode.setIscreate(type);
//ResolveFormMode.setRelateFieldMap(parentTabValueMap);
//ResolveFormMode.setOtherPara_hs(docmap);
ResolveFormMode.setCustomid(customid);
ResolveFormMode.setVirtualForm(isVirtualForm);
Hashtable ret_hs = ResolveFormMode.analyzeLayout();
String hasHtmlMode = (String)ret_hs.get("hasHtmlMode");
String formhtml = Util.null2String((String)ret_hs.get("formhtml"));
StringBuffer jsStr = ResolveFormMode.getJsStr();
String needcheck = ResolveFormMode.getNeedcheck();
StringBuffer htmlHiddenElementsb = ResolveFormMode.getHtmlHiddenElementsb();

String replayContentFieldId = "";
String sql = "select id from workflow_billfield where billid = " + formId + " and fieldname = 'replycontent'";
rs.executeSql(sql);
if(rs.next()){
	replayContentFieldId = Util.null2String(rs.getString("id"));
}
%>
<html>
  <head>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/weaver_wev8.js"></script>
	<SCRIPT language="javascript" src="/workflow/request/js/requesthtml_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/AddMode_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
	<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
	<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
	<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
	<script type="text/javascript" src="/js/swfupload/handlersBywf_wev8.js"></script>
	<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
	<script type='text/javascript' src='/dwr/engine.js'></script>
	<script type='text/javascript' src='/dwr/util.js'></script>
	<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
	<script type="text/javascript" language="javascript" src="/formmode/js/jquery/aop/jquery.aop.min_wev8.js"></script>
	<script type="text/javascript" language="javascript" src="/formmode/js/json2_wev8.js"></script>
	<script type="text/javascript" language="javascript" src="/formmode/js/FieldPrompt_wev8.js"></script>
	<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
	<script type="text/javascript" src="/formmode/js/jquery/resize/jquery.ba-resize.min_wev8.js"></script>
	<link rel="stylesheet" href="/formmode/css/formModeReply_wev8.css" type="text/css" />
	<!--引入ueditor相关文件-->
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.config_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/ueditor.all.min_wev8.js"> </script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/lang/zh-cn/zh-cn_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/appwfat_wev8.js"></script>
<link type="text/css" href="/ueditor/ueditorext_wf_wev8.css" rel="stylesheet"></link>
<script type="text/javascript" charset="UTF-8" src="/ueditor/custbtn/wordtohtml_wev8.js"></script>
<script type="text/javascript" charset="UTF-8" src="/js/workflow/ck2uk_wev8.js"></script>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			var iframeSign = "<%=iframeSign%>";
			jQuery("#replySubmitButton").bind("click",function(){
				var ischeckok="false";
				try{
					if(check_form(document.frmmain,$G("needcheck").value+$G("inputcheck").value))
					  	ischeckok="true";
				}catch(e){
				 	 ischeckok="exception";
				}
				if(ischeckok=="exception"){
					if(check_form(document.frmmain,'<%=needcheck%>'))
						ischeckok="true";
				}
				if(ischeckok=="true"){
				    jQuery("#remarkShadowDiv").hide();
                    jQuery("body").hide();
                    jQuery(window.parent.document).find("#replyFrame").attr("style","width:100%; height:8px");
					jQuery(window.parent.document).find("#loading").show();
					jQuery(window.parent.document).find("#loading-msg").html("<%=SystemEnv.getHtmlLabelName(33113, user.getLanguage()) %>");
					StartUploadAll();
					checkuploadcomplet();
				}else{
					displayAllmenu();
				}
			});
			jQuery("img[src='/images/BacoError_wev8.gif']").each(function(){
				jQuery(this).parent().hide(); //隐藏所有必填项
			});
			/*jQuery("button[class='e8_browserAdd']").each(function(){
				jQuery(this).parent().hide();
			});*/
			jQuery("#formModeReplyExternal").resize(function(){
				parent.resetIframeHeight(iframeSign);
			});
			jQuery("#formModeReplyExternal_img").bind("click",function(){
				formModeReplyExternal("formModeReplyExternal");
			});
			jQuery("#formModeReplyExternal_img").click();
			if(iframeSign!='replyFrame'){
				jQuery(".replycancelButton").bind("click",function(){
					parent.cancelReply(parent.fModeReplyCommid);
				}).show();
				jQuery("#reminddiv").hide();
			}
		});
		function formModeReplyExternal(externalid){
		   if(jQuery("#"+externalid).is(":visible")){
		      jQuery("#"+externalid).hide();
		      jQuery("#"+externalid+"_img").attr("src","/cowork/images/edit_down_wev8.gif");
		   }else{
		      jQuery("#"+externalid).show();
		      jQuery("#"+externalid+"_img").attr("src","/cowork/images/edit_up_wev8.gif");
		   }
		}
		
	</script>
  </head>
  
  <body>
  	<form action="/formmode/data/ModeDataOperation.jsp" name=frmmain id=frmmain method="post">
  		<input type="hidden" id="operationReplyData" name="operationReplyData" value="1">
  		<input type="hidden" id="modeId" name="modeId" value="<%=modeId%>">
  		<input type=hidden name=formid id="formid" value="<%=formId%>">
  		<input type=hidden name=billid id="billid" value="<%=billid%>">
  		<input type=hidden name=formmodeid id="formmodeid" value="<%=modeId%>">
  		<input type="hidden" id="customid" name="customid" value="<%=customid%>">
  		<input type=hidden name=src id="src" value="submit">
  		<input type=hidden name=iscreate id="iscreate" value="<%=type%>">
  		<input type="hidden" id="reqModeId" name="reqModeId" value="<%=reqModeId%>">
  		<input type="hidden" id="reqFormId" name="reqFormId" value="<%=reqFormId%>">
  		<input type="hidden" id="reqBillid" name="reqBillid" value="<%=reqBillid%>">
  		<input type=hidden name ="needcheck" id="needcheck" value="<%=needcheck%>">
  		<input type=hidden name ="inputcheck" id="inputcheck" value="">
  		<input type="hidden" name="temp_Quotesid" id="temp_Quotesid" value="<%=temp_Quotesid%>">
  		<input type="hidden" name="temp_Commentid" id="temp_Commentid" value="<%=temp_Commentid%>">
  		<input type="hidden" name="temp_CommentTopid" id="temp_CommentTopid" value="<%=temp_CommentTopid%>">
  		<input type="hidden" name="temp_CommentUsersid" id="temp_CommentUsersid" value="<%=temp_CommentUsersid%>">
  		<input type="hidden" name="isEditOpt" id="isEditOpt" value="<%=isEditOpt%>">
  		
  		<div id="remarkShadowDiv" style="border:1px solid #d6d6d6;display:inline-block;width:100%;background:#F7F7F7;">
		<div id="remarkShadowDivInnerDiv" onclick="initRemark()" style="margin:10px 10px;height:30px;border:1px solid #d6d6d6;background:#fff;color:#a2a2a2;cursor:pointer;" title="<%=SystemEnv.getHtmlLabelName(26965,user.getLanguage())%>">
			<span style="margin:0 5px;"><img style="vertical-align:middle;" src="/images/sign/sign_wev8.png"></img></span>
			<span style="line-height:30px;">
			<%=SystemEnv.getHtmlLabelName(26965,user.getLanguage())%> 
			</span>
		</div>
		</div>
		<div style="display:none;" class="remarkDiv">
		 <%
		 out.print(formhtml);
		 out.println(htmlHiddenElementsb.toString());//把hidden的input输出到页面上
		 %>
		</div>
	 </form>
	  <script type="text/javascript">
		 <%
			out.println(jsStr.toString());
		 %>
		 </script>
	<script type="text/javascript" src="/js/swfupload/workflowswfupload_wev8.js"></script>
	<script language=javascript src="/js/checkData_wev8.js"></script>
<script type="text/javascript">
jQuery(function () {
	jQuery("#remarkShadowDivInnerDiv").hover(function () {
		jQuery(this).css("border", "1px solid #7FBBF2");
	}, function () {
		jQuery(this).css("border", "1px solid #d6d6d6");
	});
	bindRemark();
});
function wfbrowvaluechange(obj, fieldid, rowindex) {
}
function enableAllmenu(){
}
function displayAllmenu(){
}
function changecancleon(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#f4fcff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","block");
}

function changecancleout(obj){
	jQuery(obj).find(".fieldClassChange").css("background-color","#ffffff");
	jQuery(obj).find("#fieldCancleChange").find("span").css("display","none");
}

function clearAllQueue(oUploadcancle){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())+SystemEnv.getHtmlLabelName(21407,user.getLanguage())%>?", function(){
		oUploadcancle.cancelQueue();
	}, function () {}, 320, 90,true);
}

function changebuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#8d8d8d");
	}
}

function uploadbuttonon(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#52ab2f");
	}
}

function changebuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#aaaaaa");
	}
}

function uploadbuttonout(obj){
	var disabledflag = jQuery(obj).attr("disabled");
	if(!disabledflag){
		jQuery(obj).css("background-color","#6bcc44");
	}
}

function changefileaon(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#008aff!important;text-decoration:underline!important;");
}

function changefileaout(obj){
	jQuery(obj).css("cssText","cursor:pointer;color:#8b8b8b!important;text-decoration:none!important;");
}

function showProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-2px 0px!important;");
}

function hideProgressCancel(obj){
	jQuery(obj).find(".progressCancel").css("cssText","cursor:pointer;width:20px!important;height:20px!important;background-image:url('/images/ecology8/workflow/fileupload/cancle_wev8.png')!important;background-repeat:no-repeat!important;background-position:-14px 0px!important;");
}
function returnTrue(o){
	return;
}
function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);
}
function downloads(docId){
	top.location='/weaver/weaver.file.FileDownload?fileid='+docId+'&download=1&requestid=-1';
}
function openAccessory(fileId){ 
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId);
}
function openDocExt(showid,versionid,docImagefileid,isedit){
	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true");
	}
}
function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag, _fieldStr) {
	if(false){
		onShowBrowser2_old(id,url,linkurl,type1,ismand, funFlag);
	}else{
		var ismast = 1;//2：必须输：可编辑
		if (ismand == 0) {
			ismast = 1;
		}else{
			ismast = 2;
		}
		var dialogurl = url;
		
		if(_fieldStr==null){
			_fieldStr = "field";
		}
	
		var id1 = null;
		
		if (type1 == 23) {
			url += "?billid=<%=formId%>";
		}
		if (type1 == 224||type1 == 225||type1 == 226||type1 == 227) {
			if(id.split("_")[1]){
				//zzl-拼接行号
				url += "_"+id.split("_")[1];
			}
		}
		
		if (type1 == 2 || type1 == 19 ) {
		    spanname = _fieldStr + id + "span";
		    inputname = _fieldStr + id;
		    
			if (type1 == 2) {
				onFlownoShowDate(spanname,inputname,ismand);
			} else {
				onWorkFlowShowTime(spanname, inputname, ismand);
			}
		} else {
		    if (type1 != 256&&type1 != 257&&type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170 && type1!=194) {
		    	if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
		    		//id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
		    	} else {
		    		if (type1 == 161) {
					    //id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
					    dialogurl = url + "|" + id;
		    		}
		    	}
			} else {
	
		        if (type1 == 135) {
					tmpids = $GetEle(_fieldStr+id).value;
					dialogurl = url + "?projectids=" + tmpids;
					//id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        //} else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) { 
		        //type1 = 167 分权单部分部 不应该包含在这里ypc 2012-09-06 修改
		       } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170 || type1 == 194) {
			        tmpids = $GetEle(_fieldStr+id).value;
			        dialogurl = url + "?selectedids=" + tmpids;
					//id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else if (type1 == 37) {
			        tmpids = $GetEle(_fieldStr+id).value;
			        dialogurl = url + "?documentids=" + tmpids;
					//id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else if (type1 == 142 ) {
			        tmpids = $GetEle(_fieldStr+id).value;
			        dialogurl = url + "?receiveUnitIds=" + tmpids;
					//id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
				} else if (type1 == 162 ) {
					tmpids = $GetEle(_fieldStr+id).value;
	
					if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
						url = url + "&beanids=" + tmpids;
						url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
						dialogurl = url;
						//id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
					} else {
						url = url + "|" + id + "&beanids=" + tmpids;
						url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
						dialogurl = url;
						//id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
					}
				}else if (type1 == 256|| type1 == 257) {
					tmpids = $GetEle(_fieldStr+id).value;
					url = url + "_" + type1 + "&selectedids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					dialogurl = url;
					//id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
			        index = (id + "").indexOf("_");
			        if (index != -1) {
			        	tmpids=uescape("?isdetail=1&isbill=1&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle(_fieldStr+id).value+"&selectedids="+$GetEle(_fieldStr+id).value);
			        	dialogurl = url + tmpids;
			        	//id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			        } else {
			        	tmpids = uescape("?fieldid=" + id + "&isbill=1&resourceids=" + $GetEle(_fieldStr + id).value+"&selectedids="+$GetEle(_fieldStr+id).value);
			        	dialogurl = url + tmpids;
			        	//把此行的dialogWidth=550px; 改为600px
			        	//id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=600px;dialogHeight=550px");
			        }
				} else {
			        tmpids = $GetEle(_fieldStr + id).value;
			        dialogurl = url + "?resourceids=" + tmpids;
					//id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
				}
			}
			
			
			
			 var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			//dialog.callbackfunParam = null;
			dialog.URL = dialogurl;
			dialog.callbackfun = function (paramobj, id1) {
				if (id1 != undefined && id1 != null) {
					if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170 || type1==194) {
						if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
							var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
							var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
							var sHtml = ""
							
							if (resourceids.indexOf(",") == 0) {
								resourceids = resourceids.substr(1);
								resourcename = resourcename.substr(1);
							}
							var resourceIdArray = resourceids.split(",");
							var resourceNameArray = resourcename.split(",");
							for (var _i=0; _i<resourceIdArray.length; _i++) {
								var curid = resourceIdArray[_i];
								var curname = resourceNameArray[_i];
								if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
									sHtml += wrapshowhtml("<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp", curid,ismast);
								} else {
									sHtml += wrapshowhtml("<a href=" + linkurl + curid + " target=_blank>" + curname + "</a>&nbsp", curid,ismast);
								}
								
							}
							jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
							showOrHideBrowserImg(ismand,_fieldStr,id,resourceids);
							$GetEle(_fieldStr + id).value= resourceids;
						} else {
		 					$GetEle(_fieldStr+id).value="";
							jQuery($GetEle(_fieldStr+id+"span")).html("");
							showOrHideBrowserImg(ismand,_fieldStr,id,"");
						}
		
					} else {
					   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
			               if (type1 == 162) {
						   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
								var names = wuiUtil.getJsonValueByIndex(id1, 1);
								var descs = wuiUtil.getJsonValueByIndex(id1, 2);
								var href = wuiUtil.getJsonValueByIndex(id1, 3);
								sHtml = ""
								if(ids.indexOf(",") == 0){
									ids = ids.substr(1);
									names = names.substr(1);
									descs = descs.substr(1);
								}
								$GetEle(_fieldStr+id).value= ids;
								var idArray = ids.split(",");
								var nameArray = names.split("~~WEAVERSplitFlag~~");
								if(nameArray.length < idArray.length){
									nameArray = names.split(",");
								}
								var descArray = descs.split(",");
								for (var _i=0; _i<idArray.length; _i++) {
									var curid = idArray[_i];
									var curname = nameArray[_i];
									var curdesc = descArray[_i];
									//sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
									if(href==''){
										sHtml += wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp", curid,ismast);
									}else{
										sHtml += wrapshowhtml("<a title='" + curdesc + "' href='" + href + curid + "' target='_blank'>" + curname + "</a>&nbsp", curid,ismast);
									}
								}
								
								jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
								showOrHideBrowserImg(ismand,_fieldStr,id,ids);
			               }
						   if (type1 == 161) {
							   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
							   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
								var descs = wuiUtil.getJsonValueByIndex(id1, 2);
								var href = wuiUtil.getJsonValueByIndex(id1, 3);
								$GetEle(_fieldStr+id).value = ids;
								//sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
								if(href==''){
									sHtml = wrapshowhtml("<a title='" + descs + "'>" + names + "</a>&nbsp", ids,ismast);
								}else{
									sHtml = wrapshowhtml("<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp", ids,ismast);
								}
								jQuery($GetEle(_fieldStr+id+"span")).html(sHtml);
								showOrHideBrowserImg(ismand,_fieldStr,id,ids);
						   }
		            	    if (linkurl == "") {
		            	    	if(type1==256||type1==257){
		            	    		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
		            	    		var names = wuiUtil.getJsonValueByIndex(id1, 1);
		            	    		var idArray = ids.split(",");
		            	    		var nameArray = names.split(",");
		            	    		var sHtml = "";
		            	    		for (var _i=0; _i<idArray.length; _i++) {
										var curid = idArray[_i];
										var curname = nameArray[_i];
										sHtml += wrapshowhtml( curname + "&nbsp", curid,ismast);
									}
						        	jQuery($GetEle(_fieldStr + id + "span")).html(sHtml);
		            	    	}else if(type1==161||type1==162){
						        	jQuery($GetEle(_fieldStr + id + "span")).html(sHtml);
		            	    	}else{
						        	jQuery($GetEle(_fieldStr + id + "span")).html(wrapshowhtml(wuiUtil.getJsonValueByIndex(id1, 1),"",ismast));
		            	    	}
					        } else {
								if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
									jQuery($GetEle(_fieldStr+id+"span")).html(wrapshowhtml("<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp", wuiUtil.getJsonValueByIndex(id1, 0),ismast));
								} else {
									jQuery($GetEle(_fieldStr+id+"span")).html(wrapshowhtml("<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>", wuiUtil.getJsonValueByIndex(id1, 0),ismast));
								}
					        }
			               $GetEle(_fieldStr+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
			               showOrHideBrowserImg(ismand,_fieldStr,id,$GetEle(_fieldStr+id).value);
					   } else {
							$GetEle(_fieldStr+id).value="";
							jQuery($GetEle(_fieldStr+id+"span")).html("");
							showOrHideBrowserImg(ismand,_fieldStr,id,"");
					   }
					}
				}
				hoverShowNameSpan(".e8_showNameClass");
				try {
					eval(jQuery("#"+ _fieldStr + id).attr('onpropertychange'));
					eval(jQuery("#"+ _fieldStr + id + "__").attr('onpropertychange'));
				} catch (e) {
				}
			} ;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
			dialog.Width = 550 ;
			if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
				dialog.Width=648; 
			}
			dialog.Height = 600;
			dialog.Drag = true;
			//dialog.maxiumnable = true;
			dialog.show();
			
		    
		}
	}
}
function onChangeSharetypeNew(obj,delspan,delid,showid,names,ismand,Uploadobj){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84051, user.getLanguage()) %>"+names+"<%=SystemEnv.getHtmlLabelName(82179, user.getLanguage()) %>", function(){
	    jQuery(obj).parent().parent().parent().parent().css("display","none");
		var fieldid=delid.substr(0,delid.indexOf("_"));
	    var linknum=delid.substr(delid.lastIndexOf("_")+1);
		var fieldidnum=fieldid+"_idnum_1";
		var fieldidspan=fieldid+"span";
	    var delfieldid=fieldid+"_id_"+linknum;
	    if($GetEle(delspan).style.visibility=='visible'){
	      $GetEle(delspan).style.visibility='hidden';
	      $GetEle(delid).value='0';
		  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
	        var tempvalue=$GetEle(fieldid).value;
	          if(tempvalue==""){
	              tempvalue=$GetEle(delfieldid).value;
	          }else{
	              tempvalue+=","+$GetEle(delfieldid).value;
	          }
		     $GetEle(fieldid).value=tempvalue;
	    }else{
	      $GetEle(delspan).style.visibility='visible';
	      $GetEle(delid).value='1';
		  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
	        var tempvalue=$GetEle(fieldid).value;
	        var tempdelvalue=","+$GetEle(delfieldid).value+",";
	          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
	          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
	          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
	          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
	          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
		     $GetEle(fieldid).value=tempvalue;
	    }
		if (ismand=="1"){
			if ($GetEle(fieldidnum).value=="0"){
			    $GetEle(fieldid).value="";
			    var swfuploadid=fieldid.replace("field","");
			    var linkrequired=$GetEle("oUpload_"+swfuploadid+"_linkrequired");
			    $GetEle(fieldidspan).innerHTML="";
		        if(Uploadobj.getStats().files_queued==0){
				$GetEle(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		        }
		        if(linkrequired && linkrequired.value=="false"){
		        	$GetEle(fieldidspan).innerHTML="";
		        }
		  	}else{
			 $GetEle(fieldidspan).innerHTML="";
		  	}
		}else{//add by td78113
		  	//displaySWFUploadError(fieldid);
		}
		
		////
		var leaveNum = jQuery("#"+fieldid).val();
		if(leaveNum == "" || leaveNum == null){
			var upid = fieldid.substr(5);
			jQuery("#field_upload_"+upid).attr("disabled","disabled");
		}
	}, function () {}, 320, 90,true);
}
function checkFileRequired(fieldid){
	if(jQuery("#needcheck").val().indexOf("field"+fieldid)>-1){
		var isReturn = false;
		jQuery("#fsUploadProgress"+fieldid+" .progressBarStatus").each(function(i,obj){
			if(jQuery(obj).text()!='Cancelled'){
				isReturn = true;
				return false
			}
		})
		if(isReturn){
			jQuery("#field_"+fieldid+"span").hide();
		}else{
			if(jQuery("#field"+fieldid).val()==''){
				jQuery("#field_"+fieldid+"span").show();
			}else{
				jQuery("#field_"+fieldid+"span").hide();
			}
		}
	}
}
//创建文档

function onNewDoc(fieldid) {
	var topage = "/formmode/data/MultiDocAddOperation.jsp?fromFlowDoc=1&isfromTab=0&modeId=<%=modeId%>&formId=<%=formId%>&opentype=0&adddocfieldid="+fieldid;
	topage = encodeURIComponent(topage);
    var url='/docs/docs/DocList.jsp?&isOpenNewWind=0&topage='+topage;
    
 　　　var dlg=new window.top.Dialog();//定义Dialog对象
 	dlg.currentWindow = window;

	dlg.Model=true;
	dlg.Width=parent.document.body.offsetWidth;//定义长度
	dlg.Height=parent.document.body.offsetHeight;
	dlg.URL=url;
	dlg.Title="<%=SystemEnv.getHtmlLabelName(1986,user.getLanguage())%>";
	dlg.show();
}
//创建文档回写
function onNewDocCallBack(curid,fieldid,docsubject){
	var linkurl='/docs/docs/DocDsp.jsp?isrequest=1&id=';
	var ismand=$('#field'+fieldid).attr('viewtype');
		var ismast = 1;//2：必须输：可编辑
	if (ismand == 0) {
		ismast = 1;
	}else{
		ismast = 2;
	}
	var sHtml=jQuery($GetEle("field"+fieldid+"span")).html();
	var values=$GetEle("field" +fieldid).value;	
	if(values!=""){
		values+=",";
	}
	sHtml+= wrapshowhtml("<a href=" + linkurl + curid + " target=_blank>"+docsubject+"</a>&nbsp", curid,ismast);
	jQuery($GetEle("field"+fieldid+"span")).html(sHtml);
	showOrHideBrowserImg(ismand,"field",fieldid,curid);
	values+=curid;
	$GetEle("field" +fieldid).value=values;
	hoverShowNameSpan(".e8_showNameClass");
}

function initRemark(isinit){
    jQuery("#remarkShadowDiv").hide();
    jQuery(".remarkDiv").show();
    if (!!!isinit) {
       	remarkfocus();
    }
}
function remarkfocus() {
    var _ue = UE.getEditor('field<%=replayContentFieldId%>');
    _ue.focus(true);
    if (!!window.UEDITOR_CONFIG && !isNaN(window.UEDITOR_CONFIG.remarkfontsize)) {
        _ue.execCommand('fontsize', window.UEDITOR_CONFIG.remarkfontsize + "px");
    }
    if (!!window.UEDITOR_CONFIG && !!window.UEDITOR_CONFIG.remarkfontsize) {
        _ue.execCommand('fontfamily', window.UEDITOR_CONFIG.remarkfontfamily );
    }
}
//对编辑器添加焦点监听,增加按钮，并使编辑器获得焦点
function bindRemark(){
	var _uEditor = UEUtil.initEditor('field<%=replayContentFieldId%>');
	var remarkHide = function (e) {
	    <%if(issubpage > 0){%>
	    if(true){
	    	return;
	    }
	    <%}%>
		if (e.which == 1 && jQuery(e.target).parents('.remarkDiv,.edui-popup,.edui-dialog,.filtercontainer, ._signinputphraseblockClass').length <= 0 ) {
			var _remarkTxt = _uEditor.getContentTxt();
			var _remarkHtmlstr = _uEditor.getContent().replace(/<p><\/p>/g, "");
        	if((_remarkTxt == "" && _remarkHtmlstr.indexOf('<img src=') < 0) || _remarkHtmlstr == ""){
        		jQuery(".remarkDiv").hide();
        		jQuery("#remarkShadowDiv").show();
        	}
			e.stopPropagation();
		}
	};
	jQuery( window.parent.document).find("html").live('mousedown', remarkHide);
	jQuery( window.parent.parent.document).find("html").live('mousedown', remarkHide);
	jQuery( window.top.document).find("html").live('mousedown', remarkHide);
	_uEditor.ready(function(){
        jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_1");
		jQuery(".edui-for-wfdocbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_2");
		jQuery(".edui-for-wfwfbutton").children("div").children("div").children("div").children(".edui-metro").addClass("wfres_3");
		this.focus(true);
	});
}
function doPlaceholder4change(obj) {
}
</script>
<!-- browser 相关 -->
<script type="text/javascript" src="/formmode/js/modebrow_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

</body>
</html>
