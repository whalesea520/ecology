
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet"/>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/js/datetime_wev8.js"></script>
		<script language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<script type="text/javascript">

			function onShowBrowser2(id, url, type1, tmpindex) {
				var tmpids = "";
				var dlgurl = "";
				if (type1 == 8) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?projectids=" + tmpids;
				} else if (type1 == 9) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?documentids=" + tmpids;
				} else if (type1 == 1) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?resourceids=" + tmpids;
				} else if (type1 == 4) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?selectedids=" + tmpids + "&resourceids=" + tmpids
				} else if (type1 == 16) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?resourceids=" + tmpids;
				} else if (type1 == 7) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?resourceids=" + tmpids;
				} else if (type1 == 142) {
					tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?receiveUnitIds=" + tmpids;
				} else {
				    tmpids = $G("con" + id + "_value").value;
					dlgurl = url + "?resourceids=" + tmpids;
				}
				
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.callbackfunParam = null;
				dialog.URL = dlgurl;
				dialog.callbackfun = function (paramobj, id1) {
					if (id1 != null) {
						resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
						resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
						if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
							resourceids = resourceids.replace(',','');
							resourcename = resourcename.replace(',','');
							$G("con" + id + "_valuespan").innerHTML = wrapshowhtml(resourcename, resourceids);
							jQuery("input[name=con" + id + "_value]").val(resourceids);
							jQuery("input[name=con" + id + "_name]").val(resourcename);
						} else {
							$G("con" + id + "_valuespan").innerHTML = "";
							$G("con" + id + "_value").value = "";
							$G("con" + id + "_name").value = "";
						}
					}
					if ($G("con" + id + "_value").value == "") {
						document.getElementsByName("check_con")[tmpindex * 1].checked = false;
					} else {
						document.getElementsByName("check_con")[tmpindex * 1].checked = true;
					}
					hoverShowNameSpan(".e8_showNameClass");
					try {
						jQuery("#"+ "con" + id + "_value").attr('onpropertychange');
					} catch (e) {
					}
					try {
						jQuery("#"+ "con" + id + "_value" + "__").attr('onpropertychange');
					} catch (e) {
					}
				};
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
				dialog.Width = 550 ;
				dialog.Height = 600;
				dialog.Drag = true;
				dialog.show();
			}
	
			function submitForm()
			{
				if (check_form(frmmain,'')){
					jQuery("input[name$=_value]").each(function (i, e) {
						thisval = jQuery(this).val();
						if (thisval != undefined && thisval != "") {
							var ename = jQuery(this).attr("name");
							var eid = ename.replace("con", "").replace("_value", "");

							var targetelement = jQuery("#con" + eid + "_name");
							var temphtml = "";
							jQuery("#" + ename + "span a").each(function () {
								temphtml += " " + jQuery(this).text();
							});
							var checkspan = /^<.*$/;
							if(checkspan.test(temphtml)){
								temphtml=temphtml.replace(/<[^>]+>/g,"");
							}
							if(targetelement.val()==""){
								targetelement.val(temphtml);
							}
						}
					});

					jQuery("input").each(function (i, e) {
						var thisval = jQuery(this).val();
						if (thisval != undefined && thisval != "") {
							var ename = jQuery(this).attr("name");
							var targetelement = jQuery("#" + ename + "_name");
							if(!targetelement) return;
							var temphtml = "";
							jQuery("#" + ename + "span a") && jQuery("#" + ename + "span a").each(function () {
								temphtml += " " + jQuery(this).text();
							});
							var checkspan = /^<.*$/;
							if(checkspan.test(temphtml)){
								temphtml=temphtml.replace(/<[^>]+>/g,"");
							}
							if(targetelement.val()==""){
								targetelement.val(temphtml);
							}
						}
					});

					jQuery('#frmmain').submit();
				}
			}

			function enablemenuall()
			{
				for (a=0;a<window.frames["rightMenuIframe"].document.all.length;a++){
					window.frames["rightMenuIframe"].document.all.item(a).disabled=true;
				}
			}
			function changelevel(obj,tmpindex){

			    if(obj.value!=""){
			 		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
			    }else{
			        document.getElementsByName("check_con")[tmpindex * 1].checked = false;
			    }
			}
			function changelevel1(obj1,obj,tmpindex){

			    if(obj.value!=""||obj1.value!=""){
			 		document.getElementsByName("check_con")[tmpindex * 1].checked = true;
			    }else{
			       document.getElementsByName("check_con")[tmpindex * 1].checked = false;
			    }
			}
			function onSearchWFQTDate(spanname,inputname,inputname1,tmpindex) {
				var oncleaingFun = function() {
					//edit by yuxf 2016-8-10
					//只有DOM对象才有innerHTML和value属性，jQuery对象应该是选择器.html()和选择器.val()
					jQuery(spanname).html("");
					jQuery(inputname).val("");
					if("" == jQuery(inputname).val() && "" == jQuery(inputname1).val()) {
						document.getElementsByName("check_con")[tmpindex * 1].checked = false;
					}
				}
				
				var language = readCookie("languageidweaver");
				if(language == 8) {
					languageStr = "en";
				}else if(language == 9) {
					languageStr = "zh-tw";
				}else {
					languageStr = "zh-cn";
				}
				
				WdatePicker({
					lang:languageStr,
					el:spanname,
					onpicked:function(dp){
						var returnvalue = dp.cal.getDateStr();
						/*
							edit by yuxf 2016-7-7
							$dp.$是My97的内置函数，不能想当然的把$改成jQuery，同时传参也不用加#，见下方链接的“示例5-2-3”
							$dp.$接收的参数是id，所以在赋值之前给input临时增加id(目前只有name)，以免影响到其它逻辑
							http://www.my97.net/dp/demo/resource/2.5.asp
						 */
						try{
							var thisInputElementName = jQuery(inputname).attr("name");
							jQuery(inputname).attr("id",thisInputElementName);
						}catch(ex) {
							//之所以把catch写在这里，是因为如果id没加上，那么赋值出问题绝对没跑了，在这打出控制台日志方便排查
							console.log("从span中取值给input赋值失败，请排查/workflow/request/WorkflowMultiPrintPageFrame.jsp中的onSearchWFQTDate方法！");
						}
						$dp.$(thisInputElementName).value = returnvalue;
						document.getElementsByName("check_con")[tmpindex * 1].checked = true;
					},
					oncleared:oncleaingFun
				});
			}
			function onSearchWFQTTime(spanname,inputname,inputname1,tmpindex){
			    var dads  = document.all.meizzDateLayer2.style;
			    setLastSelectTime(inputname);
				var th = spanname;
				var ttop  = spanname.offsetTop;
				var thei  = spanname.clientHeight;
				var tleft = spanname.offsetLeft;
				var ttyp  = spanname.type;
				while (spanname = spanname.offsetParent){
					ttop += spanname.offsetTop;
					tleft += spanname.offsetLeft;
				}
				dads.top  = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
				dads.left = tleft;
				outObject = th;
				outValue = inputname;
				outButton = (arguments.length == 1) ? null : th;
				dads.display = '';
				bShow = true;
			    CustomQuery=1;
			    outValue1 = inputname1;
			    outValue2=tmpindex;
			}
			

			function disModalDialog(url, spanobj, inputobj, need, curl) {
				var id = window.showModalDialog(url, "",
						"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
				if (id != null) {
					if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
						if (curl != undefined && curl != null && curl != "") {
							spanobj.innerHTML = "<A href='" + curl
									+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
									+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
						} else {
							spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
						}
						inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
					} else {
						spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
						inputobj.value = "";
					}
				}
			}

			function onShowBrowser(id,url,tmpindex) {
				var url = url + "?selectedids=" + $G("con" + id + "_value").value;
				disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
				$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;
		
				if ($G("con" + id + "_value").value == ""){
				    document.getElementsByName("check_con")[tmpindex * 1].checked = false;
				} else {
				    document.frmmain.check_con[tmpindex*1].checked = true
				    document.getElementsByName("check_con")[tmpindex * 1].checked = true;
				}
			}

			

			function onShowWorkFlowSerach(inputname, spanname) {

				//retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where isvalid='1' ");
				
				var dialogurl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=<%=xssUtil.put(" where isvalid='1' ")%>";
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.callbackfunParam = null;
				dialog.URL = dialogurl;
				dialog.callbackfun = function (paramobj, retValue) {
					temp = $G(inputname).value;
					if(retValue != null) {
						if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
							$G(spanname).innerHTML = wrapshowhtml(wuiUtil.getJsonValueByIndex(retValue, 1), wuiUtil.getJsonValueByIndex(retValue, 0));
							$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
							
							if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
								$G("frmmain").action = "WFCustomSearchBySimple.jsp";
								$G("frmmain").submit();
								enablemenuall();
							}
						} else {
							$G(inputname).value = "";
							$G(spanname).innerHTML = "";
							$G("frmmain").action = "WFSearch.jsp";
							$G("frmmain").submit();
	
						}
						hoverShowNameSpan(".e8_showNameClass");
						try {
							jQuery("#"+ inputname).attr('onpropertychange');
						} catch (e) {
						}
						try {
							jQuery("#"+ inputname + "__").attr('onpropertychange');
						} catch (e) {
						}
					}
				};
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
				dialog.Width = 550 ;
				dialog.Height = 600;
				dialog.Drag = true;
				//dialog.maxiumnable = true;
				dialog.show();
			}

			/* 加载表单字段 */
			function loadFormField(){
			    var workFlowId = jQuery("#workflowid").val();
				if(!workFlowId){
					jQuery('#formFieldDiv').html('');
					jQuery('#nodeidDiv').html("<select id='nodeid' name='nodeid'>" 
										 + "<option value='0'></option>" 
										 + "</select>");
					beautySelect('select[name=nodeid]');
					return;
				}

				jQuery.post(
					'/workflow/request/WorkflowMultiPrintSearchGenerate.jsp',
					{
						'issimple' : true,
						'workflowid' : workFlowId
					},
					function(data){
						jQuery('#formFieldDiv').html(data);

						jQuery('#formFieldDiv').find('select').each(function(i,v){
							beautySelect(jQuery(v));
						});
					}
				);

				jQuery.post(
					'/workflow/request/LoadNodesByWorkflow.jsp',
					{
						'workflowid' : workFlowId
					},
					function(data){
						data = (  "<select id='nodeid' name='nodeid'>" 
								+ "<option value='0'></option>"
								+ data
								+ "</select>" );

						jQuery('#nodeidDiv').html(data);
						beautySelect('select[name=nodeid]');
					}
				);
			}

			function getajaxurl(typeId){
				var url = "";
				if(typeId==12|| typeId==4||typeId==57||typeId==7 || typeId==18 
					|| typeId==164 || typeId== 194 || typeId==23 || typeId==26 
					|| typeId==3 || typeId==8 || typeId==135 || typeId== 65 
					|| typeId==9 || typeId== 89 || typeId==87 || typeId==58 
					|| typeId==59){
					url = "/data.jsp?type=" + typeId;			
				} else if(typeId==1 || typeId==165 || typeId==166 || typeId==17){
					url = "/data.jsp";
				} else {
					url = "/data.jsp?type=" + typeId;
				}
				url = "/data.jsp?type=" + typeId;	
			    return url;
			}

			function formreset(){
	resetCondition();
}
		function onChangeUserType(creatertype) {
		 
			jQuery("#createrid").val("");
			jQuery("#createrid1").val("");
			jQuery("#createridspan").html("");
			jQuery("#createrid1span").html("");
			if(creatertype==1){
				jQuery("#crm").hide();
				jQuery("#hrm").show();
			}else if(creatertype==2){
				jQuery("#hrm").hide();
				jQuery("#crm").show();
			}
		}
		
		function onShowCreater(tdname,inputename){
			var userType = jQuery("#creatertype").val();
			var datas=null;
			//var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
			//var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
			
			var url = "";
			if (userType == "1" ) {
			    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
			    url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
			} else  {
			    //datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
			    url = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
			}
			var dialogurl = url;
			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.callbackfunParam = null;
			dialog.URL = dialogurl;
			dialog.callbackfun = function (paramobj, datas) {
				if (datas) {
				    if (datas.id!=""){
				    	var name = "<a href='#"+datas.id+"'>"+datas.name+"</a>";
				    	if(userType=="1"){
				    		name = wrapshowhtml("<a href='javascript:openhrm("+datas.id+")' onclick='javascript:pointerXY(event);'>"+datas.name+"</a>", datas.id);
				    	}
				        jQuery("#"+tdname).html(name);
				        jQuery("#"+inputename).val(datas.id);
					}
				    else{
				        jQuery("#"+tdname).html("");
				        jQuery("#"+inputename).val("");
				    }
				    hoverShowNameSpan(".e8_showNameClass");
				    try {
						eval(jQuery("#inputename").attr('onpropertychange'));
					} catch (e) {
					}
					try {
						eval(jQuery("#inputename__").attr('onpropertychange'));
					} catch (e) {
					}
				}
			};
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
			dialog.Width = 550 ;
			dialog.Height = 600;
			dialog.Drag = true;
			dialog.show();
		}
		
		function wrapshowhtml(ahtml, id) {
			var str = "<span class=\"e8_showNameClass\">";
			str += ahtml;
			str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this,1,false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
			return str;
		}
		
		function getFlowWindowUrl(){
			//return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?typeid=" + $G("typeId").value;
			return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WFTypeBrowser.jsp";
		}
		
		function changeFlowType() {
			//_writeBackData('workflowid', 1, {id:'',name:''});
		}
		
		/*
		function disModalDialog(url, spanobj, inputobj, need, curl,id) {
				var dialogurl = url;
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.callbackfunParam = null;
				dialog.URL = dialogurl;
				dialog.callbackfun = function (paramobj, id1) {				
					if (id1 != null) {
						if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
							if (curl != undefined && curl != null && curl != "") {
								spanobj.innerHTML = "<A href='" + curl
										+ wuiUtil.getJsonValueByIndex(id1, 0) + "'>"
										+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
							} else {
								spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
							}
							inputobj.value = wuiUtil.getJsonValueByIndex(id1, 0);
						} else {
							spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
							inputobj.value = "";
						}
						$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
						if ($G("con" + id + "_value").value == ""){
						    document.getElementsByName("check_con")[tmpindex * 1].checked = false;
						} else {
						    document.frmmain.check_con[tmpindex*1].checked = true
						    document.getElementsByName("check_con")[tmpindex * 1].checked = true;
						}
					}
				};
				dialog.Title = "请选择";
				dialog.Width = 550 ;
				dialog.Height = 600;
				dialog.Drag = true;
				dialog.show();
			}

			function onShowBrowser(id,url,tmpindex) {
				var url = url + "?selectedids=" + $G("con" + id + "_value").value;
				disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"),false,null,id);
			}
		*/
		</script>
	</head>
	

	
	
<body>
<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统,1:政务系统
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitForm(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id="frmmain" name="frmmain" method="post" action="WorkflowMultiPrintMiddleHandler.jsp">
	<table id="topTitle" cellpadding="0" cellspacing="0" >
		<tr>
			<td></td>
			<td class="rightSearchSpan">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" class="e8_btn_top" onclick="javascript:submitForm();"/>&nbsp;&nbsp;
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>" class="e8_btn_top" onclick="javascript:formreset();"/>&nbsp;&nbsp;
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table> 
	<div id="advancedSearchDiv">
		<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
		        <!-- 类型 -->
		    	<wea:item><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="typeId"
						browserValue=""
						browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
						 onPropertyChange="changeFlowType()"
						hasInput="true" isSingle="true" hasBrowser="true"
						isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
						browserDialogWidth="600px"
						browserSpanValue=""></brow:browser>

				</wea:item>			
				<!-- 工作流 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></wea:item>
		    	<wea:item>
			    	<brow:browser onPropertyChange="loadFormField()" id="workflowid" name="workflowid" viewType="0" hasBrowser="true" hasAdd="false"  getBrowserUrlFn="getFlowWindowUrl" isMustInput="1" isSingle="true" hasInput="true" completeUrl="/data.jsp?type=workflowBrowser" width='80%' browserValue="" browserSpanValue=""/>		  				 
		    	</wea:item>
		    	<!-- 流程编号 -->
		    	<wea:item ><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></wea:item>
		    	<wea:item >
		    		<input type="text" name="wfcode" style='width:80%;' value="">
		    	</wea:item>
		        <!-- 打印状态 -->
				<wea:item ><%=SystemEnv.getHtmlLabelName(27044,user.getLanguage())%></wea:item >
				<wea:item >
			        <select id="ismultiprint" name="ismultiprint" >
						<option value="-1"></option>
						<option value="0" ><%=SystemEnv.getHtmlLabelName(27045,user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(27046,user.getLanguage())%></option>
					</select>
				</wea:item >
		    	<!-- 创建人 -->
				<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item >
				<wea:item>			
					<span style="float:left;">
					  <select  name=creatertype id="creatertype" onChange="onChangeUserType(this.value)">
						  <%if(isgoveproj==0){%>
						  <option value="1"   ><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></option>
						  <option value="2"  ><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
					  <%}else{%>
					   <option value="1"  ><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
					  <%}%>
					  </select>
					  </span>
					  <span id="crmAndHrm" style="">
					   <span id="hrm" >
							<brow:browser viewType="0" name="createrid" browserValue="" 
							 browserOnClick="onShowCreater('createridspan','createrid')"
							 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							 completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
							browserSpanValue=""></brow:browser>
						</span>
					   <span id="crm" style="display:none">
							<brow:browser viewType="0" name="createrid1" browserValue="" 
							 browserOnClick="onShowCreater('createrid1span','createrid1')"
							 hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							 completeUrl="/data.jsp?type=7" linkUrl="#" width="49%"
							browserSpanValue=""></brow:browser>
						</span>
			  		</span>	
				</wea:item>	
				<!-- 创建日期 -->
			    <wea:item ><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item >
		    	<wea:item >
		    	<%-- 
		            <button type="button"  class="calendar" id="SelectDate"  onclick="gettheDate('fromdate','fromdatespan')"></button>
					<span id="fromdatespan" ></span>
					<span id="fromdatespanimg"></span>
					&nbsp;-&nbsp;
					<button type="button"  class="calendar" id="SelectDate2" onclick="gettheDate('todate','todatespan')"></button>
					<span id="todatespan"></span>
					<input type="hidden" name="fromdate" value="" />
					<input type="hidden" name="todate" value="" />
				--%>
				<span class="wuiDateSpan" selectId="createDate">
					<input name="fromdate" value=""  type="hidden" class="wuiDateSel">
					<input name="todate" value=""  type="hidden" class="wuiDateSel">
				</span>
				</wea:item>			       
		    </wea:group>
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'>	
		    	<!-- 流程标题 -->
		    	<wea:item ><%=SystemEnv.getHtmlLabelName(26876,user.getLanguage())%></wea:item>
		    	<wea:item >
		    		<input type="text" name="requestname" style='width:80%;' value="">
		    	</wea:item>
		    	<!-- 紧急程度 -->
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<select name="requestlevel">
						<option value="">&nbsp;</option>
						<option value="0" ><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
					</select>
		    	</wea:item>							
				<!-- 节点类型 -->
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></wea:item>
		    	<wea:item>
		          	<select name="nodetype" >
						<option value="">&nbsp;</option>
						<option value="0" ><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option>
						<option value="3" ><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
					</select>
				</wea:item>	
				<!-- 节点处理人 -->
		    	<wea:item ><%=SystemEnv.getHtmlLabelName(26033,user.getLanguage())%></wea:item >
				<wea:item >   
			       <brow:browser viewType="0" name="operater" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
									browserSpanValue=""></brow:browser>
				</wea:item >	
				<!-- 节点 -->
				<wea:item ><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%></wea:item >
					<wea:item >
						<div id="nodeidDiv">
					         <select id="nodeid" name="nodeid">
								<option value="0"></option>
							</select>
						</div>
				</wea:item > 
				<%--归档日期 --%>
				<wea:item><%=SystemEnv.getHtmlLabelName(3000,user.getLanguage())%></wea:item>
				<wea:item>
					<span class="wuiDateSpan" selectId="archiveDate" >
					<input name="startDate" value=""  type="hidden" class="wuiDateSel">
					<input name="endDate" value=""  type="hidden" class="wuiDateSel">
					</span>
				</wea:item>
		    </wea:group>
		</wea:layout>
		<div id="formFieldDiv"></div>
	</div>
</form>
</body>
</html>
