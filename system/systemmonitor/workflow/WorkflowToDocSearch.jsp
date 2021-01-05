
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><%--added by xwj for td2023 on 2005-05-20--%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />

<%
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(), 0);//0:非政务系统，1：政务系统
	String offical = Util.null2String(request.getParameter("offical"));
	int officalType = Util.getIntValue(request.getParameter("officalType"),-1);

%>
<html>
	<head>
	<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
	<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" rel="stylesheet">
	<script language="javascript" src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
	<script language="javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
	<script language="javascript" src="/js/datetime_wev8.js"></script>
	<script language="javascript" src="/js/selectDateTime_wev8.js"></script>
	<script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	<script language="javaScript">

		function submitForm()
		{
			if (check_form(frmmain,'')){
				$("input[name$=_value]").each(function (i, e) {
					thisval = $(this).val();
					if (thisval != undefined && thisval != "") {
						var ename = $(this).attr("name");
						var eid = ename.replace("con", "").replace("_value", "");

						var targetelement = $("#con" + eid + "_name");
						var temphtml = "";
						//alert($("#" + ename + "span").children().length);
						$("#" + ename + "span a").each(function () {
							temphtml += " " + $(this).text();
						});
						var checkspan = /^<.*$/;
						if(checkspan.test(temphtml)){
							temphtml=temphtml.replace(/<[^>]+>/g,"");
						}
						targetelement.val(temphtml);
					}
				});

				$("input").each(function (i, e) {
					var thisval = $(this).val();
					if (thisval != undefined && thisval != "") {
						var ename = $(this).attr("name");
						var targetelement = $("#" + ename + "_name");

						if(!targetelement) return;
						var temphtml = "";
						$("#" + ename + "span a") && $("#" + ename + "span a").each(function () {
							temphtml += " " + $(this).text();
						});
						var checkspan = /^<.*$/;
						if(checkspan.test(temphtml)){
							temphtml=temphtml.replace(/<[^>]+>/g,"");
						}

						targetelement.val(temphtml);
					}
				});

				$('#weaver').submit();
			}
		}

		function submitClear()
		{
			btnclear_onclick();
		}
		
		function changelevel(obj,tmpindex){

		    if(obj.value!=""){
		    	console.log('checked');
		 		document.frmmain.check_con[tmpindex*1].checked = true;
		    }else{
		    	console.log('un checked');
		        document.frmmain.check_con[tmpindex*1].checked = false;
		    }
		}
		function changelevel1(obj1,obj,tmpindex){

		    if(obj.value!=""||obj1.value!=""){
		    	console.log('checked');
		 		document.frmmain.check_con[tmpindex*1].checked = true;
		    }else{
		    	console.log('un checked');
		        document.frmmain.check_con[tmpindex*1].checked = false;
		    }
		}
		function onSearchWFQTDate(spanname,inputname,inputname1,tmpindex){
			var oncleaingFun = function(){
				  $(spanname).innerHTML = '';
				  $(inputname).value = '';
		          if($(inputname).value==""&&$(inputname1).value==""){
		              document.frmmain.check_con[tmpindex*1].checked = false;
		          }
				}
				var language=readCookie("languageidweaver");
				if(language==8)
					languageStr ="en";
				else if(language==9)
					languageStr ="zh-tw";
				else
					languageStr ="zh-cn";
				if(window.console){
				   console.log("language "+language+" languageStr="+languageStr);
				}
				WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
					var returnvalue = dp.cal.getDateStr();$dp.$(inputname).value = returnvalue;document.frmmain.check_con[tmpindex*1].checked = true;},oncleared:oncleaingFun});
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
		function uescape(url){
		    return escape(url);
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

		function onShowBrowser1(id,url,type1) {
			//var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
			if (type1 == 1) {
				id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
				$G("con" + id + "_valuespan").innerHTML = id1;
				$G("con" + id + "_value").value=id1
			} else if (type1 == 1) {
				id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
				$G("con"+id+"_value1span").innerHTML = id1;
				$G("con"+id+"_value1").value=id1;
			}
		}

		function onShowBrowser2(id, url, type1, tmpindex) {
			var tmpids = "";
			var id1 = null;
			if (type1 == 8) {
				tmpids = $G("con" + id + "_value").value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids);
			} else if (type1 == 9) {
				tmpids = $G("con" + id + "_value").value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids);
			} else if (type1 == 1) {
				tmpids = $G("con" + id + "_value").value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
			} else if (type1 == 4) {
				tmpids = $G("con" + id + "_value").value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids
						+ "&resourceids=" + tmpids);
			} else if (type1 == 16) {
				tmpids = $G("con" + id + "_value").value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
			} else if (type1 == 7) {
				tmpids = $G("con" + id + "_value").value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
			} else if (type1 == 142) {
				tmpids = $G("con" + id + "_value").value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
			}
			//id1 = window.showModalDialog(url)
			if (id1 != null) {
				resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
					resourceids = resourceids.replace(',','');
					resourcename = resourcename.replace(',','');

					$G("con" + id + "_valuespan").innerHTML = resourcename;
					jQuery("input[name=con" + id + "_value]").val(resourceids);
					jQuery("input[name=con" + id + "_name]").val(resourcename);
				} else {
					$G("con" + id + "_valuespan").innerHTML = "";
					$G("con" + id + "_value").value = "";
					$G("con" + id + "_name").value = "";
				}
			}
			console.log('tmpindex:' + tmpindex);
			if ($G("con" + id + "_value").value == "") {

				document.getElementsByName("check_con")[tmpindex * 1].checked = false;
			} else {
				document.getElementsByName("check_con")[tmpindex * 1].checked = true;
			}
		}

		function onShowWorkFlowSerach(inputname, spanname) {

			retValue = window
					.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=<%=xssUtil.put(" where isvalid='1' ")%>");
			temp = $G(inputname).value;
			if(retValue != null) {
				if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
					$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
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
			}
		}

		function disModalDialogRtnM(url, inputname, spanname) {
			var id = window.showModalDialog(url);
			if (id != null) {
				if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
					var ids = wuiUtil.getJsonValueByIndex(id, 0);
					var names = wuiUtil.getJsonValueByIndex(id, 1);
					
					if (ids.indexOf(",") == 0) {
						ids = ids.substr(1);
						names = names.substr(1);
					}
					$G(inputname).value = ids;
					var sHtml = "";
					
					var ridArray = ids.split(",");
					var rNameArray = names.split(",");
					
					for ( var i = 0; i < ridArray.length; i++) {
						var curid = ridArray[i];
						var curname = rNameArray[i];
						if (i != ridArray.length - 1) sHtml += curname + "，"; 
						else sHtml += curname;
					}
					
					$G(spanname).innerHTML = sHtml;
				} else {
					$G(inputname).value = "";
					$G(spanname).innerHTML = "";
				}
			}
		}

		/* 加载用户自定义的查询条件 */
		function loadCustomSearch(workFlowId, cutomQueryId){
			if(!workFlowId && !cutomQueryId){
				jQuery('#customQueryDiv').html('');
				return;
			}

			jQuery.post(
				'/workflow/search/WFCustomSearchGenerate.jsp',
				{
					'issimple' : true,
					'workflowid' : workFlowId,
					'customid' : cutomQueryId
				},
				function(data){
					jQuery('#customQueryDiv').html(data);

					jQuery('#customQueryDiv').find('select').each(function(i,v){
						beautySelect(jQuery(v));
					});

					jQuery('#cutomQuerySelect').change(function(e){
						loadCustomSearch(null, jQuery(this).val());
					});

					jQuery('#cutomQuerySelect').click(function(e){
						if (e && e.stopPropagation)  
			            	e.stopPropagation()  
			       		else 
			            	window.event.cancelBubble=true 	
					});
				}
			);
		}

		function getajaxurl(typeId){
			var url = "";
			if(typeId==12|| typeId==4||typeId==57||typeId==7 || typeId==18 || typeId==164 || typeId== 194 || typeId==23 || typeId==26 || typeId==3 || typeId==8 || typeId==135
			   || typeId== 65 || typeId==9 || typeId== 89 || typeId==87 || typeId==58 || typeId==59){
				url = "/data.jsp?type=" + typeId;			
			} else if(typeId==1 || typeId==165 || typeId==166 || typeId==17){
				url = "/data.jsp";
			} else {
				url = "/data.jsp?type=" + typeId;
			}
			url = "/data.jsp?type=" + typeId;	
			//alert(typeId + "," + url);
		    return url;
		}
	</script>

	</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+ SystemEnv.getHtmlLabelName(197,user.getLanguage()) +",javascript:submitForm(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<!-- <FORM id="weaver" name="frmmain" method="post" action="WFSearchResult.jsp?offical=<%=offical %>"> -->
<form id="weaver" name="frmmain" method="post" action="WorkflowToDocTab.jsp">
	<table id="topTitle" cellpadding="0" cellspacing="0" >
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:submitForm();"/>&nbsp;&nbsp;
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>" class="e8_btn_top"  onclick="javascript:onReset();"/>&nbsp;&nbsp;
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table> 
	<div id="advancedSearchDiv">
		<wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
		    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(229, user.getLanguage())%></wea:item>
		    	<wea:item>
			    	 <input type="text" style='' name="requestname" value="" />
					 <input type="hidden" name="pageId" id="pageId" value=""/>
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></wea:item>
		    	<wea:item><input type="text" style='' name="workcode" value="" ></wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(33234, user.getLanguage())%></wea:item>
		    	<% String wfbytypeBrowserURL = "/workflow/workflow/WFTypeBrowserContenter.jsp";%>
		    	<wea:item>
    		    	<brow:browser viewType="0" name="typeid" browserValue=""
					browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser="true"
					isMustInput="1" completeUrl="/data.jsp?type=worktypeBrowser"
					browserDialogWidth="600px"
					browserSpanValue=""></brow:browser>
			    	
			    	<%--
			    	 <span>
			    		<select id="typeid" name="typeid" onchange="setWFbyType(this)">
			    			<option value="0">&nbsp;</option>
	    	  				<%
	   	  						WorkTypeComInfo.setTofirstRow();
	    	  					while(WorkTypeComInfo.next()){
							%>
							<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" ><%=WorkTypeComInfo.getWorkTypename()%></option>
							<%}%>
			    		</select>
			    	</span>  --%>
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(26361, user.getLanguage())%></wea:item>
		    	<wea:item>
			    	 <brow:browser viewType="0" name="workflowid" browserValue="" onPropertyChange="loadCustomSearch($('#workflowid').val())" browserOnClick="" browserUrl='<%=wfbytypeBrowserURL %>' hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('workflowBrowser')" width="80%" browserSpanValue=""> </brow:browser>
			    	  <input type="hidden" id="workflowid_name" name="workflowid_name" value="<%=request.getParameter("workflowid_name")%>"/> 
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(15534, user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<select class=inputstyle name=requestlevel style='' size=1>
						<option value="" ></option>
						<option value="0" ><%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%></option>
					</select>
		    	</wea:item>
		    	<wea:item ><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
		    	<wea:item >
			        <span  style='float:left'>
						<select class=inputstyle name=creatertype  style='height:25px;width:100px;' onchange="changeType(this.value,'createridse1span','createridse2span');">
							<%if (!user.getLogintype().equals("2")) {%>
								<option value="0"><%=SystemEnv.getHtmlLabelName(362, user.getLanguage())%></option>
							<%}%>
								<option value="1"><%=SystemEnv.getHtmlLabelName(136, user.getLanguage())%></option>
						</select>								
					</span>
					<span id="createridse1span" style="">
						<brow:browser viewType="0" id="createrid" name="createrid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="135px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue=""> 
					   </brow:browser> 
					</span>
					<span id="createridse2span" style="display:none;">
						<brow:browser viewType="0" id="createrid2" name="createrid2" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" width="135px;" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=18"  browserSpanValue=""> 
						</brow:browser> 
					</span>
		    	</wea:item>
		    	
		    </wea:group>
		     <wea:group context='<%=SystemEnv.getHtmlLabelName(32843,user.getLanguage())%>'  >
		    	<wea:item><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></wea:item>
		    	<wea:item>
		    		 <brow:browser viewType="0" name="ownerdepartmentid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue=""> </brow:browser>
		    		 <input type="hidden" id="ownerdepartmentid_name" name="ownerdepartmentid_name" value="<%=request.getParameter("ownerdepartmentid_name")%>"/>
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></wea:item>
		    	<wea:item>
		    		<brow:browser viewType="0" name="creatersubcompanyid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue=""> </brow:browser> 
		    		<input type="hidden" id="creatersubcompanyid_name" name="creatersubcompanyid_name" value="<%=request.getParameter("creatersubcompanyid_name")%>"/>
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(17994, user.getLanguage())%></wea:item>
		    	<wea:item  attributes="{\"colspan\":\"3\"}">
		    		<span class="wuiDateSpan" selectId="recievedateselect" selectValue="">
						<input class=wuiDateSel type="hidden" name="recievedatefrom" value="<%=Util.null2String(request.getParameter("recievedatefrom"))%>">
						<input class=wuiDateSel type="hidden" name="recievedateto" value="<%=Util.null2String(request.getParameter("recievedateto"))%>">
					</span>
		    	</wea:item>
		    	<wea:item><%=SystemEnv.getHtmlLabelName(553, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%></wea:item>
		    	<wea:item>
		            <select class=inputstyle size=1 style='' name="wfstatu">
						<option value="0" ><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(16658, user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(24627, user.getLanguage())%></option>
					</select>
		    	</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15112, user.getLanguage())%></wea:item>
				<wea:item>
			        <select class=inputstyle size=1 style='' name="archivestyle">
						<option value="0" ><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%></option>
					</select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19061, user.getLanguage())%></wea:item>
				<wea:item>
			        <select class=inputstyle  size=1 name=isdeleted style=''>
						<option value="0" ><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				    </select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(15536, user.getLanguage())%></wea:item>
				<wea:item>
			        <select class=inputstyle size=1 name=nodetype style=''>
						<option value="">&nbsp;</option>
						<option value="0" ><%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%></option>
						<option value="1" ><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%></option>
						<option value="2" ><%=SystemEnv.getHtmlLabelName(725, user.getLanguage())%></option>
						<option value="3" ><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%></option>
					</select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(16354, user.getLanguage())%></wea:item>
				<wea:item>
			        <brow:browser viewType="0" name="unophrmid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue=""> </brow:browser>
			         <input type="hidden" id="unophrmid_name" name="unophrmid_name" value="<%=request.getParameter("unophrmid_name")%>"/>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%></wea:item>
				<wea:item>
		          	<brow:browser viewType="0" name="docids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('9')" width="80%" browserSpanValue=""> </brow:browser>
		          	<input type="hidden" id="docids_name" name="docids_name" value="<%=request.getParameter("docids_name")%>"/>
				</wea:item>
				<%if(!offical.equals("1")){ %>
					<wea:item><%=SystemEnv.getHtmlLabelName(179, user.getLanguage())%></wea:item>
					<wea:item>
				         <brow:browser viewType="0" name="hrmcreaterid" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue=""> </brow:browser>
				         <input type="hidden" id="hrmcreaterid_name" name="hrmcreaterid_name" value="<%=request.getParameter("hrmcreaterid_name")%>"/>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></wea:item>
					<wea:item>
				         <brow:browser viewType="0" name="crmids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('18')" width="80%" browserSpanValue=""> </brow:browser>
				         <input type="hidden" id="crmids_name" name="crmids_name" value="<%=request.getParameter("crmids_name")%>"/>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></wea:item>
					<wea:item>
			        	<brow:browser viewType="0" name="proids" browserValue="" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' completeUrl="javascript:getajaxurl('135')" width="80%" browserSpanValue=""> </brow:browser>
			        	<input type="hidden" id="proids_name" name="proids_name" value="<%=request.getParameter("proids_name")%>"/>
					</wea:item>
				<%} %>
		    </wea:group>
		</wea:layout>
		<div id="customQueryDiv"></div>
	</div>
</form>
<script type="text/javascript">
function changeType(type,span1,span2){
	if(type=="1"){
		jQuery("#"+span1).css("display","none");
		jQuery("#"+span2).css("display","");		
	}else{
		jQuery("#"+span2).css("display","none");
		jQuery("#"+span1).css("display","");
	}
}

function setWFbyType(obj)
{
	var selvar = $(obj).val();
	jQuery("#wfidbytype").val("");
	jQuery("span[name='wfidbytypespan']").html("");
	jQuery("#outwfidbytypediv").next().find("button").remove();
	jQuery("#outwfidbytypediv").next().find("span").append("<button class='Browser e8_browflow' type='button' onclick=showModalDialogForBrowser(event,'/workflow/workflow/WFTypeBrowserContenter.jsp?wftypeid="+selvar+"','#','wfidbytype',true,1,'',{name:'wfidbytype',hasInput:true,zDialog:true,dialogTitle:'请选择',arguments:''});></button>")
}

function setSelectBoxValue(selector, value) {
	if (value == null) {
		value = jQuery(selector).find('option').first().val();
	}
	jQuery(selector).selectbox('change',value,jQuery(selector).find('option[value="'+value+'"]').text());
}

function cleanBrowserValue(name) {
	_writeBackData(name, 1, {id:'',name:''});
}

function onReset() {
	//browser
	jQuery('#weaver .e8_os input[type="hidden"]').each(function() {
		cleanBrowserValue(jQuery(this).attr('name'));
	});
	//input
	jQuery('#weaver input').val('');
	//select
	jQuery('#weaver select').each(function() {
		setSelectBoxValue(this);
	});
}
</script>
</BODY>
</HTML>
