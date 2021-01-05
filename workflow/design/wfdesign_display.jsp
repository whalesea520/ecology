<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.ServerUtil"%>


		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
		
		<script>
			var isIE9 = false;
			try {
				var osV = jQuery.client.browserVersion.version; 
				var isIE = jQuery.client.browser=="Explorer"? true : false;
				if (isIE && osV < 10) {
					isIE9 = true;
				}
			} catch (e) {}
		</script>
<%
	String workflowId = Util.null2String((String)request.getParameter("wfid"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(workflowId), 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String type = Util.null2String(request.getParameter("type"));
	String serverstr=request.getScheme()+"://"+request.getHeader("Host");
	String dataurl = "/workflow/design/wfdesign_data.jsp;jsessionid=" + session.getId() + "?userid=" + user.getUID() + "&wfid=" + workflowId + "&type=edit";
	String submiturl = "/weaver/weaver.workflow.layout.WorkflowXmlParser";
	boolean isExport = GCONST.isWorkflowIsOpenIOrE();
	boolean canFreeFlow = GCONST.getFreeFlow();		//是否开启自由流转
	boolean isResin = false;
	if("resin".equals(ServerUtil.getServerId())){
		isResin = true;
	}
	boolean canModifyLog = false;
	RecordSet.executeSql("select isModifyLog from workflow_base where id=" + workflowId);
	if (RecordSet.next()) {
		if("1".equals(Util.null2String(RecordSet.getString("isModifyLog")))){
			canModifyLog = true;
		}
	}
%>

<%if(user.getLanguage()==7) {%>
	<script type="text/javascript" src="/js/workflow/design/lang-cn_wev8.js"></script>
<%} else if(user.getLanguage()==8) {%>
	<script type='text/javascript' src='/js/workflow/design/lang-en_wev8.js'></script>
<%} else if(user.getLanguage()==9) {%>
	<script type='text/javascript' src='/js/workflow/design/lang-tw_wev8.js'></script>
<%}%>
<jsp:useBean id="xmlParser" class="weaver.workflow.layout.WorkflowXmlParser" scope="page" />
<!DOCTYPE html PUBLIC "">
<html>
	<head>
		<style type="text/css">
		.mask {
			display:none;
		    position: absolute;
		    top: 0%;
		    right: 0%;
		    width:230px;
		    height: 100%;
		    background-color: #000000;
		    z-index:1001;
		    -moz-opacity: 0.1;
		    opacity:.10;
		    filter: alpha(opacity=10);
		}
		.fontEllipsis{
			overflow:hidden;
			white-space:nowrap;
			text-overflow:ellipsis;
		}
		</style>
		<!-- Mimic Internet Explorer 7 -->
		<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
		<!-- jQuery -->
		<link rel="stylesheet" type="text/css" href="/wui/common/jquery/plugin/asyncbox/skins/ZCMS/asyncbox_wev8.css" />
		<script type="text/javascript" src="../../js/jquery/jquery-1.4.2.min_wev8.js"></script>
		<script type="text/javascript" src="js/option_check_wev8.js"></script> 
		<script type="text/javascript" src="/wui/common/jquery/plugin/asyncbox/AsyncBox_wev8.js"></script>
		
		<script type="text/javascript" src="/js/weaver_wev8.js" />
		<script type="text/javascript" src="/workflow/design/js/workflowDesign_wev8.js" />
		
		<link rel="stylesheet" type="text/css" href="/workflow/design/bin-debug/history/history_wev8.css" />
        <script type="text/javascript" src="/workflow/design/bin-debug/history/history_wev8.js"/>
        <!-- END Browser History required section -->  
        <script type="text/javascript" src="/workflow/design/bin-debug/swfobject_wev8.js" />
        <script type="text/javascript">
            // For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection. 
            var swfVersionStr = "10.2.0";
            // To use express install, set to playerProductInstall.swf, otherwise the empty string. 
            var xiSwfUrlStr = "/workflow/design/bin-debug/playerProductInstall.swf";
            var flashvars = {};
            var params = {};
            params.quality = "high";
            params.bgcolor = "#ffffff";
            params.allowscriptaccess = "sameDomain";
            params.allowfullscreen = "true";
            //params.wmode="transparent";
            params.wmode = "opaque";
            var attributes = {};
            attributes.id = "EAdvanceGrid";
            attributes.name = "EAdvanceGrid";
            attributes.align = "middle";
            swfobject.embedSWF(
                "/workflow/design/bin-debug/EAdvanceGrid.swf", "flashContent", 
                "100%", "100%", 
                swfVersionStr, xiSwfUrlStr, 
                flashvars, params, attributes);
            // JavaScript enabled so display the flashContent div in case it is not replaced with a swf object.
            swfobject.createCSS("#flashContent", "display:block;text-align:left;");
        </script>
        
        <script type="text/javascript">
         function setSpanInner(row,hascon,pre)
		{
			if(hascon=="1"){
    			jQuery("div[_id='"+row+"']").innerHTML="<img src=\"/images/ecology8/checkright_wev8.png\" width=\"16\" height=\"17\" border=\"0\">";
   			}else{
    			jQuery("div[_id='"+row+"']").innerHTML="";
			}
		}
		function hideorexp() {
			if(jQuery("#attributeBlock").width() == 230) {
				jQuery("#attributeBlock").css("width", "0px");
				jQuery("#attributeBlock").css("overflow", "hidden");
				jQuery("#contentBlock").css("margin-right", "20px");
				
				jQuery("#maskDiv").css("width", "35px");
				jQuery("#maskDiv").css("overflow", "hidden");
				
			} else {
				jQuery("#attributeBlock").css("width", "230px");
				jQuery("#contentBlock").css("margin-right", "230px");
				
				jQuery("#maskDiv").css("width", "230px");
			}
		}      
		
		function hasExport() {
			return <%=isExport%>;
		}
		
		function htmlFocus(){
			window.focus();
		}
		function keyDown(event){
			try {
				var obj = event.srcElement ? event.srcElement : event.target
				if (obj.type != undefined) {
					return;
				}
				if(event.ctrlKey){
					if (event.keyCode != 17) {				
						swfObj.flexFunctionKeyDown(1, event.keyCode);
					}
				} else {
					if (event.keyCode == 46) {
						swfObj.flexFunctionKeyDown(-1, event.keyCode);
					}
				}
			}catch (e){}
		}
		
		function keyUp(event){
			try {
				if(event.ctrlKey ){
					if (event.keyCode != 17) {
						swfObj.flexFunctionKeyUp(1, event.keyCode);
					}
				} 
			} catch(e){}
		}
		
		var isModify = false;
		function getModify() {
			isModify = true;
		}
		
		function setModify(flg) {
			isModify = flg;
		}
		
		function beforeunload() {
			//getModify();
			if(isModify == true || isModify == 'true' ) {	
				try {
					if (window.dialogArguments) {
						window.dialogArguments.parent.setDesignTime();
					} else {
						window.parent.setDesignTime();
					}
				}catch (e ) {}
				event.returnValue = "<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
			}
		}  
		
		// 判断input框中是否输入的是正整数,不包括小数点
		function ItemPlusCount_KeyPress() {
			var evt = getEvent();
			var keyCode = evt.which ? evt.which : evt.keyCode;
			if(!(((keyCode>=48) && (keyCode<=57)))) {
				if (evt.keyCode) {
					evt.keyCode = 0;
					evt.returnValue=false;     
				} else {
					evt.which = 0;
					evt.preventDefault();
				}
			}
		}
		function getEvent() {
			if (window.ActiveXObject) {
				return window.event;// 如果是ie
			}
			func = getEvent.caller;
			while (func != null) {
				var arg0 = func.arguments[0];
				if (arg0) {
					if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
							|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
						return arg0;
					}
				}
				func = func.caller;
			}
			return null;
		}

		function checknumber(objectname)
		{
		    var objvalue = objectname.value ; 
		    var isnumber = false ;
		    if(isNaN(parseInt(objvalue))) {
		        isnumber = true ;
		    }
		    if(window.console) console.log("isnumber = "+isnumber+" objvalue = "+objvalue);
		    if(isnumber) {
		        objectname.value = "" ;
		    }else{
		    	if(parseInt(objvalue)>=100){
		    		if(window.console) console.log("objvalue = 100/"+objvalue);
		    		objectname.value = "100" ;
		        }else{
		        	objectname.value = parseInt(objvalue) ;    
		        }
		    }
		    if(window.console) console.log("最后的值 objvalue = "+objectname.value);    
		}
        //-->
        </script>
        
        <script type="text/javascript">
        	/**
             * 流程图加载数据url
             */
            function getDataUrl() {
				var url = window.location.protocol + "//" + window.location.host + "<%=dataurl %>";
				return url;
			}
            function getSubmitUrl() {
            	var url = null;
            	<%if(isResin){%>
            		url = window.location.protocol + "//" + window.location.host + "<%=submiturl %>";
            	<%}else{%>
            		url = window.location.protocol + "//" + window.location.host + "<%=submiturl %>";
            	<%}%>
				return url;
			}
     
            function getLanguage() {
				var language = "<%=user.getLanguage() %>";
				return language;
			}
			
			function exportWorkflow(){
				var workflowid = <%=workflowId%>;
				var xmlHttp = ajaxinit();
				xmlHttp.open("post","/workflow/export/wf_operationxml.jsp", true);
				var postStr = "src=export&wfid="+workflowid;
				xmlHttp.onreadystatechange = function () 
				{
					switch (xmlHttp.readyState) 
					{
					   case 4 : 
					   		if (xmlHttp.status==200)
					   		{
					   			var downxml = xmlHttp.responseText.replace(/(^\s*)|(\s*$)/g, "");
					   			window.open(downxml,"_self");
					   		}
						    break;
					} 
				}
				xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded;");
				xmlHttp.send(postStr);
			}
			function ajaxinit(){
			    var ajax=false;
			    try {
			        ajax = new ActiveXObject("Msxml2.XMLHTTP");
			    } catch (e) {
			        try {
			            ajax = new ActiveXObject("Microsoft.XMLHTTP");
			        } catch (E) {
			            ajax = false;
			        }
			    }
			    if (!ajax && typeof XMLHttpRequest!='undefined') {
			    ajax = new XMLHttpRequest();
			    }
			    return ajax;
			}
			
        </script>
        
        <script type="text/javascript">
        function visibleVisible(flag) { 
        	if (flag == "true") {
        		jQuery("#maskDiv").show();
        	} else {
        		jQuery("#maskDiv").hide();
        	}
        }
        
        var swfObj;
        jQuery(document).ready(function () {
        	if(navigator.appName.indexOf("Microsoft") != -1){
				swfObj=$("#wfdesignIE")[0];
			}else{
				swfObj=$("#wfdesignNotIE")[0];
			}
        	jQuery(document.body).bind("keydown", function () {
        		if (event.keyCode == 13) {  
		        	event.keyCode = 9;  
		        }  
        	});
        });
        
        function reload() {
        	jQuery("#reload")[0].href = location.href + "&time" + new Date().getTime() + "="
        	jQuery("#reload")[0].click();
        	//location.reload() 
        }
        
        function showMessage(mes) {
        	maskflash(true);
        	alert(mes);
        	maskflash(false);
        } 
        
        function synchInfo(type, key, name, value) {
        	if (name == "wmsg.wfdesign.nodeName") {
        		if (jQuery.trim(value) == "") {
        			showMessage("<%=SystemEnv.getHtmlLabelName(81506,user.getLanguage())%>");
        			document.getElementById("wmsg.wfdesign.nodeName").focus();
        			return;
        		} else {
	        		swfObj.elementCheck(type, key, name, jQuery.trim(value));
	        		return ;
	        	} 
        	} 
        	if (name == "wmsg.wfdesign.type") {
        		swfObj.elementCheck(type, key, name, jQuery.trim(value));
	        	return ;
        	}
        	if (name == "wmsg.wfdesign.passnum") {
        		if(value>100){
        			value = 100 ;
        			jQuery("input[name=wmsg.wfdesign.passnum]").val(value);
        		}
        	}
        	if(name == "wmsg.wfdesign.Passpercent"){
        		if(value>100){
        			value = 100 ;
        			jQuery("input[name=wmsg.wfdesign.Passpercent]").val(value);
        		}
        		
            }
        	/** 联动 **/
        	if (name == "wmsg.wfdesign.passType") {
        		if (value == 3) {
        			jQuery("input[name=wmsg.wfdesign.passnum]").parent().parent().show();
        			jQuery("#wmsgwfdesignmustPass").parent().parent().hide();
        			jQuery("input[name=wmsg.wfdesign.Passpercent]").parent().parent().hide();
        		} else if (value == 4) {
	        		jQuery("input[name=wmsg.wfdesign.passnum]").parent().parent().hide();
        			jQuery("#wmsgwfdesignmustPass").parent().parent().show();
        			jQuery("input[name=wmsg.wfdesign.Passpercent]").parent().parent().hide();
        		}else if (value == 5) {
	        		jQuery("input[name=wmsg.wfdesign.Passpercent]").parent().parent().show();
	        		jQuery("input[name=wmsg.wfdesign.passnum]").parent().parent().hide();
        			jQuery("#wmsgwfdesignmustPass").parent().parent().hide();
        		}
        	}
        	if (name == "wmsg.wfdesign.stepName") {
        		if (jQuery.trim(value) == "") {
        			showMessage("<%=SystemEnv.getHtmlLabelName(81505,user.getLanguage())%>");
        			jQuery("input[name=wmsg.wfdesign.stepName]")[0].focus();
        			return;
        		}
        	}
        	swfObj.flexFunctionAlias(type, key, name, jQuery.trim(value + ""));
		}
        
        function repeatCheckFail() {
        	showMessage("<%=SystemEnv.getHtmlLabelName(81504,user.getLanguage())%>");
        	jQuery("input[name=wmsg.wfdesign.nodeName]")[0].focus();
        }
        
        function nodeTypeCheckFail() {
        	showMessage("<%=SystemEnv.getHtmlLabelName(81503,user.getLanguage())%>");
        	jQuery("input[name=wmsg.wfdesign.type]")[0].focus();
        }
        
		function getItemHtml(text, eleHtml, styleString) {
			if (styleString == null || styleString == undefined) {
				styleString = "";
			}
			var itemHtml = "<div name=\"attrContainer\" class=\"attrClass\" " + styleString + ">"
						 +      "<div class=\"attrValueBody\">"
						 +			    eleHtml
						 +	    "</div>"
						 +	    "<div class=\"attrKeyBody fontEllipsis\">" 
						 +           "<span style=\"width:100%;overflow:hidden;text-Overflow:ellipsis;white-Space:nowrap;word-Break:keep-all;overflow:hidden;\" title=\"" + text + "\">"
						 +              text 
						 +            "</span>"
						 +       "</div>"
						 + "</div>";
			return itemHtml;
		}
		
		function getComboxHtml(ids, names, values){ //此处可在数据库中取值后拼接html，注意：预选项加上 lang='checked'
			if (ids == null || ids == undefined || ids == "") {
				return "";
			}
			if (values == null || values == undefined) {
				values = "";
			}
			values = "," + values + ",";
			var optionshtml="<table style='width:100%;background-color:#FFFFFF;border:1px solid #c6c6c6;' cellpadding='0' cellspacing='0'>";
			var idArray = ids.split(",");
			var nameArray = names.split(",");
			for (var i=0; i<idArray.length; i++) {
				var checkedfg = values.indexOf("," + idArray[i] + ",") != -1 ? "lang=\"checked\"" : "";
				optionshtml += "<tr><td style='width:24px'>";
				optionshtml += "<input name=\"mustPassCB\" " + checkedfg + " style=\"width:24px!important;\" type='checkbox' value='" + idArray[i] + "'/></td><td  style='height:24px;line-height:24px;'>" + nameArray[i] + "</td></tr>" ;
			}
			optionshtml += "</tr></table>";
			return optionshtml; 
		} 
		
		function setSource(jsonString, flag) {
			var rtnHtml = "";
			jQuery("#attrBody").html("");
			var containNotEnabled = false;
			if (jsonString == null || jsonString == undefined || jsonString == "") {
				rtnHtml += "<div name=\"attrContainer\" class=\"attrClass\"><div class=\"attrTextValueBody\"><span class=\"attrTextSpan\" title=\"<%=Util.toScreen(WorkflowComInfo.getWorkflowname(workflowId),user.getLanguage()) %>\">";
				rtnHtml += "<%=Util.toScreen(WorkflowComInfo.getWorkflowname(workflowId), user.getLanguage()) %>";
				rtnHtml += "</span></div><div class=\"attrTextKeyBody\"><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></div></div>";
				if (flag == -1) {
					rtnHtml += "<div name=\"attrContainer\" class=\"attrClass\" style='text-align:left;line-height:26px;'><span style='color:red;'><%=SystemEnv.getHtmlLabelName(81500,user.getLanguage())%></span><br/><%=SystemEnv.getHtmlLabelName(81502,user.getLanguage())%></div>";
				}
			} else {
				var jsonSource = eval(jsonString);
				jQuery.each(jsonSource, function (i, item) { 
					var id = item.id;
					var type = item.type;
					var name = item.label;
					var label = eval(item.label);
					var value = item.value;
					var options = item.options;
					var url = item.url;
					var hasCon = item.hasIdetity;
					var wfid = item.wfid;
					var formid = item.formid;
					var isBill = item.isBill;
					var isCust = item.isCust;
					var isshow = item.isshow;
					var enabled = ("true" == item.enabled);					
					if (enabled == false) {
						containNotEnabled = true;
					}
					
					var styleString = "";
					if (isshow == false || isshow == "false") {
						styleString = " style='display:none;' ";
					}
					if (type == 1) {
						var checkFunction = "";
						if (name == "wmsg.wfdesign.nodeName") {
							checkFunction = "checkLength('wmsg.wfdesign.nodeName','60','<%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>');";
						}
						
						if (name == "wmsg.wfdesign.stepName") {
							checkFunction = "checkLength('wmsg.wfdesign.stepName','60','<%=SystemEnv.getHtmlLabelName(15611,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>');";
						}
						var keypers = "";
						if (name == "wmsg.wfdesign.passnum"||name=="wmsg.wfdesign.Passpercent") {
							keypers = " onkeypress='checknumber(this)' "
						}
						rtnHtml += getItemHtml(label, "<input type='text' name='" + name + "'" + (enabled == false ? " disabled='disabled' ":"") + " value='" + value + "' onchange=\"" + checkFunction + "synchInfo(" + flag + ", " + id + ", this.name, this.value);\" " + keypers + ">", styleString);
					}
					if (type == 2) {
						var isDymGetData = item.isDymGetData;
						var dymGetDataMethod = item.dymGetDataMethod;
						
						var attrDymStr = "";
						if (isDymGetData && dymGetDataMethod == "") {
						} else {
							//attrDymStr = dymGetDataMethod.split("\"", "");						
						}
						var selectHtml = "<select dymGetDataMethod=\"" + dymGetDataMethod + "\"" + (enabled == false ? " disabled='disabled' ":"") + "' name='" + name + "' _nodeid='" + id + "' _wfid='" + wfid + "' _formid='" + formid + "' _isBill='" + isBill + "' _isCust='" + isCust + "' onchange='synchInfo(" + flag + ", " + id + ", this.name, this.value);' style='width: 115px !important;'>";
						jQuery.each(options, function (j, j_item) { 
							var text = j_item.text;
							try {
								if (name != "wmsg.wfdesign.purposeNode") {
									text = eval(j_item.text);
								}
							} catch (e) {}
							var o_value = j_item.value;
							if (o_value == value) {
								selectHtml += "<option value='" + o_value + "' selected>" + text + "</option>"
							} else {
								selectHtml += "<option value='" + o_value + "'>" + text + "</option>"
							}
						});
						
						if (isDymGetData) {
							try {
								eval(dymGetDataMethod);
							} catch (e) {}
						}
						
						selectHtml += "</select>";
						rtnHtml += getItemHtml(label, selectHtml, styleString);
					} 
					if (type == 3) {
						//控制属性显示权限

						if(name=='wmsg.wfdesign.freeFlowConfig'){
							styleString = " style=\"display:none;\" ";
							<%if(!canFreeFlow){ %>
								return true;
							<%}%>
						}
						if(name=='wmsg.wfdesign.logBrownser'){
							<%if(!canModifyLog){ %>
								return true;
							<%}%>
						}
						if(name=='wmsg.wfdesign.turnForwardConfig'){
							styleString = " style=\"display:none;\" ";
						}
						//将是否设置标示存隐藏域

						var hidden_obj_key = name.replace(/\./g,"_")+"_"+id;
						var hidden_obj=$("#"+hidden_obj_key);
						if(hidden_obj.length==0){
							$("#div_hidden").append("<input type='hidden' id='"+hidden_obj_key+"' value='"+hasCon+"' />");
						}else{
							hasCon=hidden_obj.val()=="true"?true:false;
						}
						var class_name="propertyWin";
						if(hasCon)	class_name="propertyWin_ggy";
						if(name=='wmsg.wfdesign.nodeFormField') class_name="propertyForm";
						rtnHtml += getItemHtml(label, "<div _id='" + id + "' _name='" + name + "' class='" + class_name + "' onclick=\"openExtWin2('" + url + "',800)\" style='height:24px;cursor:pointer;'></div>", styleString);
					}
					if (type == 4) {
						var isDymGetData = item.isDymGetData;
						var dymGetDataMethod = item.dymGetDataMethod;
						
						if (isDymGetData && dymGetDataMethod == "") {
						}
						var comboxHtml = "<input type='text' id='wmsgwfdesignmustPass' " + (enabled == false ? " disabled='disabled' ":"") + " name='" + name + "' _nodeid='" + id + "' _wfid='" + wfid + "' _formid='" + formid + "' _isBill='" + isBill + "' _isCust='" + isCust + "' onchange='synchInfo(" + flag + ", " + id + ", this.name, this.value);' readOnly=\"true\" class=\"input-text\" />";
						if (isDymGetData) {
							try {
								eval(dymGetDataMethod);
							} catch (e) {}
						}
						rtnHtml += getItemHtml(label, comboxHtml, styleString);
					}
					
					if (type == 5) {
						var checked = "";
						if (value == true || value == "true") {
							checked = " checked='true' ";
						}
						rtnHtml += getItemHtml(label, "<input type='checkbox' " + checked + " style='width:25px!important;' name='" + name + "' value='" + value + "' onclick=\"synchInfo(" + flag + ", " + id + ", this.name, this.checked);\">", styleString);
					}
				});
			}
			
			if (containNotEnabled) {
				rtnHtml += "<div name=\"attrContainer\" class=\"attrClass\" style='text-align:left;line-height:26px;padding-top:4px;'><span style='color:red;'><%=SystemEnv.getHtmlLabelName(81500,user.getLanguage())%></span><br/><%=SystemEnv.getHtmlLabelName(81501,user.getLanguage())%></div>";
			}
			
			jQuery("#attrBody").html(rtnHtml);
			return "1";
		}
		
		var operatorGetting = false;
		function getOperator(name, wfid, nodeid) {
			var ajaxUrl = '/workflow/design/ds.jsp?design=1&wfid=' + wfid + "&nodeid=" + nodeid + "&token=" + new Date().getTime();
			var selectEle = document.getElementsByName(name)[0];
			if (selectEle == null) {
				setTimeout(
					function () {
						getOperator(name, wfid, nodeid);
					}, 100
				);
				return ;
			}
			
			if (operatorGetting == true) {
				return;
			}
			operatorGetting = true;
			jQuery(selectEle).empty();
			 var oOption = document.createElement("OPTION"); 
			 oOption.value = -1;  
		     oOption.text = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";  
		     selectEle.options.add(oOption);
			jQuery.ajax({
			    url: ajaxUrl,
			    dataType: "text", 
			    contentType : "charset=UTF-8", 
			    error:function(ajaxrequest){}, 
			    success:function(content){
			    	var addOption = "";
			    	var jsonSource = eval("[" + content + "]")
			    	jQuery.each(jsonSource, function (i, item) { 
			    		
			    		jQuery.each(item["options"], function (j, j_item) { 
							var text = j_item["name"];
							var o_value = j_item["type"];
							//jQuery("<option value='" + o_value + "'>" + text + "</option>");
							//selectEle.add(jQuery("<option value='" + o_value + "'>" + text + "</option>")[0]);
							 var oOption = document.createElement("OPTION");  
						     oOption.value = o_value;  
						     oOption.text = text;  
						     selectEle.options.add(oOption);
						     jQuery(selectEle).unbind("change");
						     jQuery(selectEle).attr("onchange", "")
						     jQuery(selectEle).bind("change", function () {
						     	if (this.value == -1) {
						     		return;
						     	}
						     	changeGroup(jQuery(selectEle).attr("_wfid"),jQuery(selectEle).attr("_nodeid"),jQuery(selectEle).attr("_formid"),jQuery(selectEle).attr("_isBill"),jQuery(selectEle).attr("_isCust"), jQuery(selectEle).val());
						     	this.options[0].selected = true;
						     });
						     operatorGetting = false;
						});
			    	});
			    }  
		    });
			
		}
		
		function getPurposeNode(name, wfid, linkid) {
			var selectEle = document.getElementsByName(name)[0];
			if (selectEle == null) {
				setTimeout(
					function () {
						getPurposeNode(name, wfid, linkid);
					}, 100
				);
				return ;
			}
			
			var ajaxUrl = "/workflow/design/purposenode.jsp";
			ajaxUrl += '?wfid='+wfid+'&linkid='+linkid+'&timeToken=' + new Date().getTime();
			
			jQuery.ajax({
			    url: ajaxUrl,
			    dataType: "text", 
			    contentType : "charset=UTF-8", 
			    error:function(ajaxrequest){}, 
			    success:function(content){
			    	var addOption = "";
			    	var jsonSource = eval("[" + content + "]")
			    	jQuery.each(jsonSource, function (i, item) { 
			    		jQuery.each(item["options"], function (j, j_item) { 
							var text = j_item["name"];
							var o_value = j_item["type"];
							//jQuery("<option value='" + o_value + "'>" + text + "</option>");
							//selectEle.add(jQuery("<option value='" + o_value + "'>" + text + "</option>")[0]);
							 var oOption = document.createElement("OPTION");  
						     oOption.value = o_value;  
						     oOption.text = text;  
						     
						     selectEle = document.getElementsByName(name)[0];
						     if (selectEle.value != o_value) {
						     	selectEle.options.add(oOption);
						     }
						     //jQuery(selectEle).unbind("change");
						     //jQuery(selectEle).attr("onchange", "")
						     //jQuery(selectEle).bind("change", function () {
						     //	changeGroup(jQuery(selectEle).attr("_wfid"),jQuery(selectEle).attr("_nodeid"),jQuery(selectEle).attr("_formid"),jQuery(selectEle).attr("_isBill"),jQuery(selectEle).attr("_isCust"), jQuery(selectEle).val());
						     //});
						});
			    	});
			    }  
		    });
		}
		
		//获取出口条件
		function getOutletConditions(workflowid, nodelinkid){
			var ajaxUrl = '/workflow/design/wfQueryConditions.jsp?nodelinkid='+nodelinkid+'&workflowid='+workflowid+'&timeToken=' + new Date().getTime();
			jQuery.ajax({
			    url: ajaxUrl,
			    dataType: "text", 
			    contentType : "charset=UTF-8", 
			    error:function(ajaxrequest){}, 
			    success:function(data){
			    	try {
			    		swfObj.flexFunctionNodeLinkCondition(nodelinkid, jQuery.trim(data));
			    	} catch (e) {}
			    }  
		    });
		}
		
		//获取指定出口列表
		function getustPassStep(name, wfid, nodeid, values, enabled) {
			var selectEle = document.getElementsByName(name)[0];
			if (selectEle == null) {
				setTimeout(
					function () {
						getustPassStep(name, wfid, nodeid, values, enabled);
					}, 100
				);
				return ;
			}
			var ajaxUrl = "/workflow/design/mustpassstep.jsp";
			ajaxUrl += '?wfid='+wfid+'&nodeid='+nodeid;
			
			jQuery.ajax({
			    url: ajaxUrl,
			    dataType: "text", 
			    contentType : "charset=UTF-8", 
			    error:function(ajaxrequest){}, 
			    success:function(content){
			    	var addOption = "";
			    	var jsonSource = eval("[" + content + "]")
			    	jQuery.each(jsonSource, function (i, item) { 
			    		var ids = "";
			    		var names = "";
			    		jQuery.each(item["options"], function (j, j_item) { 
							var text = j_item["name"];
							var o_value = j_item["type"];
						    ids += o_value + ",";
						    names += text + ",";
						});
						var comboxContentHtml = getComboxHtml(ids.substring(0, ids.length - 1), names.substring(0, names.length - 1), values);
						//if (enabled == "true") {
							Jselect(selectEle, { 
								bindid: "wmsgwfdesignmustPass", 
								hoverclass:'hover', 
								optionsbind:function(){return comboxContentHtml;} ,
								callback: function () {
									var vals = "";
									var eles = document.getElementsByName("mustPassCB");
									for (var i=0; i<eles.length; i++) {
										if (eles[i].checked) {
											vals += eles[i].value + ",";
										}
									}
									
									if (vals.length > 0) {
										vals = vals.substring(0, vals.length - 1);
									}
									
									synchInfo(0, nodeid, "wmsg.wfdesign.mustPass", vals);
								}
							}); 
						//}
			    	});
			    }  
		    });
		}
		/*
		var mustPassStep_store = new Ext.data.Store({
			url:'/workflow/design/mustpassstep.jsp',
			reader: new Ext.data.JsonReader({
				root:'options'
			},['name','type','node'])
		});
		
		*/
		
		//打开操作组编辑窗口

		function changeGroup(wfid, nodeid, formid, isBill, isCust, type) {
			var nodeoperator_url = '/workflow/workflow/operatorgroupContent.jsp?design=1&ajax=1';
			nodeoperator_url += '&wfid='+wfid+'&nodeid='+nodeid+'&formid='+formid+'&isbill='+isBill+'&iscust='+isCust+'&id='+type;
			openExtWin2(nodeoperator_url,1000);
		}
		
		function maskflash(flag) {
			swfObj.flexFunctionMask(flag);
		}
		
		var iframeID = "";
		//属性页弹出窗体
		function openExtWin2(url,width){
			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			//dialog.callbackfunParam = null;
			dialog.URL = url;
			dialog.callbackfun = function (paramobj, id1) {
			}
			dialog.CancelEvent = function () {
				dialog.close();
				controlContent('show');
			}
			dialog.closeHandle = function () {
				controlContent('show');
			}
			var dialog_title = "<%=SystemEnv.getHtmlLabelName(128937,user.getLanguage())%>";
			if(url.indexOf("setType=title")>-1)
				dialog_title = "<%=SystemEnv.getHtmlLabelName(33482,user.getLanguage())%>";
			else if(url.indexOf("setType=sign")>-1)
				dialog_title = "<%=SystemEnv.getHtmlLabelName(33483,user.getLanguage())%>";
			else if(url.indexOf("setType=forward")>-1)
				dialog_title = "<%=SystemEnv.getHtmlLabelName(33484,user.getLanguage())%>";
			else if(url.indexOf("setType=freewf")>-1)
				dialog_title = "<%=SystemEnv.getHtmlLabelName(33486,user.getLanguage())%>";
			else if(url.indexOf("setType=subWorkflow")>-1)
				dialog_title = "<%=SystemEnv.getHtmlLabelName(21584,user.getLanguage())%>";
			else if(url.indexOf("setType=exceptionhandle")>-1)
				dialog_title = "<%=SystemEnv.getHtmlLabelName(124778,user.getLanguage())%>";
			dialog.Title = dialog_title;
			dialog.Width = width ;
			dialog.Height = 600;
			dialog.Drag = true;
			dialog.maxiumnable = true;
			dialog.show();
			controlContent('hide');
			/*
			maskflash(true);
			Ext.useShims=true;
			var iframe = document.createElement('iframe');
			var randname = new Date().getTime();
			iframe.id = "iframe_"+randname;
			iframe.name = "iframe_"+randname;
			iframeID = "iframe_"+randname;
			iframe.src=url;
			iframe.style.width= '100%';
			iframe.style.height= '100%';
			var win = new Ext.Window({
		        layout: 'fit',
		        width: width,
		        resizable: true,
		        maximizable :true,
		        height:  600,
		        modal: true,
		        contentEl:iframe,
		        autoScroll: false,
		        listeners:{
		        	'close':function(){
						try{
							maskflash(false);
							eval("iframe_"+randname+".window.designOnClose();");
						}catch(e){
						}
		        	}
		        }
		    });
		    win.show();
		    openwin = win;
		    */
		}
		
		function controlContent(flag){
			try {
				if(isIE9){
					if(flag=='show'){
						$("#contentBlock").show();
					} else if(flag=='hide'){
						$("#contentBlock").hide();
					}
				}
			} catch (e) {}
		}
		
		function joinAttribute(nodetype) {
			if(nodetype==2){
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.realize+'",'
			}else if(nodetype ==1){
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.approve+'",'
			}else if(nodetype == 3){
				propertySource+=wmsg.wfdesign.type+':"'+wmsg.wfdesign.process+'",'
			}
			propertySource+=wmsg.wfdesign.passType+':"'+wmsg.wfdesign.approve+'",'
			if(passtype ==3){
				propertySource+=wmsg.wfdesign.passType+':"'+wmsg.wfdesign.passByMum+'",'
				propertySource+=wmsg.wfdesign.passnum+':"'+this.PassNum+'",'
			}else if(passtype ==4){
				propertySource+=wmsg.wfdesign.passType+':"'+wmsg.wfdesign.mustPass+'",'
				if(this.mustPassStep ==""){
					propertySource+=wmsg.wfdesign.mustPass+':"'+wmsg.wfdesign.select+'",'
				}else{
					var text = "";
					var ids ="";
					var aryId = this.mustPassStep.split(',');
					for(var i=0;i<aryId.length;i++){
						if(text != ""){
							text +=",";
						}
						if(ids!=""){
							ids+=","
						}
						ids += _FLOW.getStepByID(aryId[i]+"T").ID
						text += _FLOW.getStepByID(aryId[i]+"T").Text
					}
					//propertySource+=wmsg.wfdesign.mustPass+':"{type:"combobox",text:"'+ text+'", url:"'+this.mustPassStep+'"},'
					propertySource+=wmsg.wfdesign.mustPass+':'+'{type:"combobox", text:"'+text+'", url:"'+this.mustPassStep+'"}'+','
					//propertySource+=wmsg.wfdesign.mustPass+':"'+ text+'",'
				}
			}else if(passtype ==5){
				propertySource+=wmsg.wfdesign.passType+':"'+wmsg.wfdesign.percentPass+'",'
				propertySource+=wmsg.wfdesign.Passpercent+':"'+this.PassNum+'",'
			}
			
		}
		
		function closeDialog() {
			try{
				openwin.hide();
				openwin.close();
				maskflash(false);
			}catch(e){
			}
		}
		
function design_callback(ev,returnvalue,needSyncNodes) {
	maskflash(false);
	var needUpdateHidden=false;
	var needCallFlex=false;
	var type = 0;
	var key;
	var name;
	var value = returnvalue;
	var step;
	switch(ev){
	case 'showButtonNameOperate':
		//自定义右键按钮

		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.rightMenu+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		break;
	case 'showpreaddinoperate':
		//节点前附加操作

		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.preAddInOperate+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		needCallFlex=true;
		break;
	case 'showaddinoperate_node':
		//节点后附加操作

		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.addInOperate+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		needCallFlex=true;
		break;
	case 'showaddinoperate_link':
		//出口附加规则
		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.stepAddInOperate+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		closeDialog();
		type = 1;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		needCallFlex=true;
		break;
	case 'wfNodeBrownser':
		//日志查看范围
		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.logBrownser+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		break;
	case 'addwfnodefield':
		//节点表单字段
		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.nodeFormField+"')").prev().children("div");
		closeDialog();
		openwin = null;		
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		break;
	case 'addoperatorgroup':
	case 'editoperatorgroup':
		//节点操作者

		closeDialog();
		openwin = null;
		//Ext.getCmp("operatorSelect").clearValue();
		//operator_store.reload();
		/*
		jQuery("select[name=wmsg.wfdesign.oerator] option").each(function(){
			if(jQuery(this).val() != "-1" || jQuery(this).val() != ""){
				jQuery(this).remove();
			}
		});
		*/
		eval(jQuery("select[name=wmsg.wfdesign.oerator]").attr("dymGetDataMethod"));
		break;
	case 'addnodeoperator':
		//节点操作组

		closeDialog();
		openwin = null;
		break;
	case 'showFormSignatureOperate':
		//是否表单签章
		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.procTitleInfo+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		break;
	case 'showNodeTitleOperate':
		//流程标题提示信息
		closeDialog();
		openwin = null;
		break;
	case 'editoperatorgroup':
		//编辑操作者

		closeDialog();
		openwin = null;
		break;
	case 'showcondition':
		//出口条件设置
		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.condition+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin");
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy");
			$tdsib.removeClass("propertyWin").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		type = 1;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		needCallFlex=true;
		break;
	//标题显示设置、签字意见设置、转发设置、自由流转设置、子流程设置  liuzy
	case 'showNodeAttrOperate_title':
		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.titleShowConfig+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		break;
	case 'showNodeAttrOperate_sign':
		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.signIdeaConfig+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		break;
	case 'showNodeAttrOperate_forward':
		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.turnForwardConfig+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		break;
	case 'showNodeAttrOperate_freewf':
		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.freeFlowConfig+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		break;
	case 'showNodeAttrOperate_subWorkflow':
		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.subWorkFlowConfig+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		break;
	case 'showNodeAttrOperate_exceptionhandle':
		var $tdsib =  $(".attrKeyBody:contains('"+wmsg.wfdesign.exceptionHandleConfig+"')").prev().children("div");
		if(returnvalue == "true") {
			$tdsib.removeClass("propertyWin").addClass("propertyWin_ggy");
		}else {
			$tdsib.removeClass("propertyWin_ggy").addClass("propertyWin");
		}
		closeDialog();
		openwin = null;
		key = $tdsib.attr("_id");
		name = $tdsib.attr("_name");
		needUpdateHidden=true;
		break;
	}
	if(needUpdateHidden){
		var hidden_input_name = name.replace(/\./g,"_");
		//设置同步到所有节点

		if(typeof needSyncNodes!="undefined" && needSyncNodes=="true")
			jQuery("#div_hidden").find("input[id^='"+hidden_input_name+"_']").val(returnvalue);
		else		//同步到所有节点，有漏洞，必须隐藏域存在才生效，即点击过一次的节点才生效

			jQuery("#div_hidden").find("input#"+hidden_input_name+"_"+key).val(returnvalue);
	}
	name = ev;
	if(needCallFlex){
		swfObj.flexFunctionPostBackData4Browser(type, key, name, value);
	}
}

function isE8() {
	return true;
}

        </script>
        <link rel="stylesheet" type="text/css" href="/workflow/design/css/workflowDesign_wev8.css" />
        <base target="_self">
	</head>
	<body onbeforeunload="beforeunload();"  onKeydown="keyDown(event)" onKeyup="keyUp(event)" class="" id="" scroll="no" oncontextmenu="return false" onbeforeunload="" style="overflow:hidden;width:100%;height:100%;padding:0px!important;margin:0px!important;">
		<div style="position:absolute;height:15px;width:15px;overflow:hidden;right:5px;top:5px;background:url('/js/extjs/air/samples/tasks/ext-2.0/resources/images/gray/panel/tool-sprites_wev8.gif') 0 -165 no-repeat;z-index:55;" onclick="hideorexp();">
		</div>
		<div class="mask" id="maskDiv"></div>
		
		<a id="reload" href="#" style="display:none" >reload</a>
		<div id="container" style="border:1px solid #ccc;height:100%;">
			<div style="width:230px;float:right;" id="attributeBlock">
				<div id="attributeTitleBlock" style="position:relative;width:100%;height:98px;background:url(/images/design/topBg_wev8.png) 0 0 repeat-x;">
					<div style="position:absolute;height:20px;left:10px;bottom:10px;width:230px;">
						<%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%>
					</div>
				</div>
				<div style="border-left:1px solid #CFCFCF;width:230px;height:100%;">
					<div id="attrHead" class="attrClass">
						<div class="attrClass">
							<div class="attrValueHead"><%=SystemEnv.getHtmlLabelName(19113,user.getLanguage())%></div>
							<div class="attrKeyHead"><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></div>
						</div>
					</div>
					
					<div id="attrBody" style="width:100%;">
						<div name="attrContainer" class="attrClass">
							<div class="attrTextValueBody">
								<span class="attrTextSpan" title="<%=Util.toScreen(WorkflowComInfo.getWorkflowname(workflowId),user.getLanguage()) %>">
								<%=Util.toScreen(WorkflowComInfo.getWorkflowname(workflowId),user.getLanguage()) %>
								</span>
							</div>
							<div class="attrTextKeyBody">
								<%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%>
							</div>
						</div>
					</div>			
				</div>
			</div>
			<!-- 左侧工作区 -->
			<div style="height:100%;margin-right:230px;" id="contentBlock">
				<!-- <noscript> -->
				<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%" id="wfdesignIE">
	                <param name="movie" value="/workflow/design/bin-debug/Main.swf" />
	                <param name="quality" value="high" />
	                <param value='transparent'>
	                <param name="wmode" value="window" />
	                <param name="bgcolor" value="#ffffff" />
	                <param name="allowScriptAccess" value="sameDomain" />
	                <param name="allowFullScreen" value="true" />
	                <!--[if !IE]>-->
	                <object type="application/x-shockwave-flash" width="100%" height="100%" id="wfdesignNotIE">
	                	<param name="movie" value="/workflow/design/bin-debug/Main.swf" />
	                    <param name="quality" value="high" />
	                    <param value='transparent'>
	                    <param name="wmode" value="transparent" />
	                    <param name="bgcolor" value="#ffffff" />
	                    <param name="allowScriptAccess" value="sameDomain" />
	                    <param name="allowFullScreen" value="true" />
		                <!--<![endif]-->
		                <!--[if gte IE 6]>-->
	                    <p> 
	                        Either scripts and active content are not permitted to run or Adobe Flash Player version
	                        10.2.0 or greater is not installed.
	                    </p>
	                	<!--<![endif]-->
	                    <a href="http://www.adobe.com/go/getflashplayer">
	                        <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player_wev8.gif" alt="Get Adobe Flash Player" />
	                    </a>
	                	<!--[if !IE]>-->
	                </object>
	                <!--<![endif]-->
	            </object>
				<!-- </noscript>  -->
			</div>
		</div>
		<div id="div_hidden" style="display:none"></div>
	</body>
</html>
<link rel="stylesheet" type="text/css" href="/js/extjs/resources/css/ext-all_wev8.css" />
<script type="text/javascript" src="/js/extjs/adapter/ext/ext-base_wev8.js"></script>
<script type="text/javascript" src="/js/extjs/ext-all_wev8.js"></script>
