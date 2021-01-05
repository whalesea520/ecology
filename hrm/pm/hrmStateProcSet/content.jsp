<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-07-03[状态变更流程] -->
<%@ page import="weaver.hrm.pm.domain.HrmStateProcSet"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="hrmStateProcSetManager" class="weaver.hrm.pm.manager.HrmStateProcSetManager" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("StateChangeProcess:Set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(84790, user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	int subcompanyid = strUtil.parseToInt(request.getParameter("subcompanyid"), 0);
	subcompanyid = subcompanyid < 0 ? 0 : subcompanyid;
	
	if(subcompanyid == 0) {
		String dftsubcomid = "";
		rs.executeProc("SystemSet_Select","");
		if(rs.next()) subcompanyid = rs.getInt("dftsubcomid");
	}
	String id = strUtil.vString(request.getParameter("id"));
	boolean isEdit = id.length() > 0;

	HrmStateProcSet bean = isEdit ? hrmStateProcSetManager.get(id) : null;
	bean = bean == null ? new HrmStateProcSet() : bean;
	if(bean.getField004() <= 0) bean.setField004(subcompanyid);
	String field002Name = "";
	if(bean.getField002() != 0){
		rs.executeSql("select b.labelname from WorkFlow_Bill a left join HtmlLabelInfo b on a.nameLabel = b.indexID and b.languageid = "+user.getLanguage()+" where a.id = "+bean.getField002());
		field002Name = rs.next() ? rs.getString(1) : "";
	}
%>
<html>
	<head>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			var common = new MFCommon();

			function doSave(op){
		    	if(!check_form(document.frmMain,'field001,field002,field004,field006')) return;
				if($GetEle("field006").value == "-1") {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
					return;
				}
				try{parent.disableTabBtn();}catch(e){}
				common.ajax($("#weaver").attr("action")+"?cmd=save&field005="+($GetEle("field005").checked?1:0)+"&"+$("#weaver").serialize()+"&randomstr="+randomString(6), false, function(result){
					parentWin._table.reLoad();
					result = jQuery.parseJSON(result);
					if(op === 1) parentWin.showContent(result.id, $GetEle("field006").value);
					else parentWin.closeDialog();
				});
		 	}
			
			function getWfBrowserUrl(data){
				var _sql = "";
				var formid = $("#field002").val();
				if(formid != "") _sql = "where formid="+formid;
				return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+_sql;
			}
			
			function getWfCompleteUrl(data){
				var _sql = "";
				var formid = $("#field002").val();
				if(formid != "") _sql = "formid="+formid;
				return "/data.jsp?type=workflowBrowser&from=prjwf&sqlwhere="+_sql;
			}
			
			function setForm(event,data,name) {
				common.ajax("cmd=getFormInfo&arg="+data.id, false, function(result){
					result = jQuery.parseJSON(result);
					_writeBackData('field002', 2, {id: $.trim(result.id), name: $.trim(result.name)}, {hasInput:true});
				});
			}
			
			function getFormBrowserUrl(data){
				return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/hrm/attendance/workflowBill/browser.jsp?selectedids=&wfid="+$("#field001").val();
			}
			
			function getFormCompleteUrl(data){
				return "/data.jsp?type=Hrm_WorkflowBill&wfid="+$("#field001").val();
			}
			
			function checkValue(obj, span){
				if(obj.value == -1) $GetEle(span).innerHTML = "<img src='/images/BacoError_wev8.gif' align='absMiddle'>";
			}
			
			function onCreateWf() {
				try{
					showModalDialogForBrowser(event,
						"/workflow/workflow/addwf.jsp?isTemplate=0&isdialog=1&ajax=1&from=prjwf&prjwfformid="+$("#field002").val(), 
						'#', "wfid", true, 2, '', {
							name:"wfid",hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',
							dialogWidth:"800px",dialogHeight:"600px",maxiumnable:true,_callback:afterCreateWf
					});
				}catch(e){}
			}
			
			function afterCreateWf(event,data,name,oldid){
				if (data!=null && data.id!= ""){
					_writeBackData('field001', 2, {id:data.id,name:data.name},{hasInput:true});
				}
			}
			
			function genFormCheck(){
				var title = "";
				var type = $GetEle("field006").value;
				if(type == "-1"){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84792,user.getLanguage())%>");
					return;
				} else if(type == "2"){
					title = "<%=SystemEnv.getHtmlLabelNames("6088,18015",user.getLanguage())%>";
				} else if(type == "4"){
					title = "<%=SystemEnv.getHtmlLabelNames("6090,18015",user.getLanguage())%>";
				} else if(type == "5"){
					title = "<%=SystemEnv.getHtmlLabelNames("6091,18015",user.getLanguage())%>";
				} else {
					if(type == "0"){
						title = "<%=SystemEnv.getHtmlLabelNames("16250,18015",user.getLanguage())%>";
					} else if(type == "1"){
						title = "<%=SystemEnv.getHtmlLabelNames("15710,18015",user.getLanguage())%>";
					} else if(type == "3"){
						title = "<%=SystemEnv.getHtmlLabelNames("6089,18015",user.getLanguage())%>";
					} else if(type == "6"){
						title = "<%=SystemEnv.getHtmlLabelNames("6092,18015",user.getLanguage())%>";
					} else if(type == "7"){
						title = "<%=SystemEnv.getHtmlLabelNames("6094,18015",user.getLanguage())%>";
					} else if(type == "8"){
						title = "<%=SystemEnv.getHtmlLabelNames("6093,18015",user.getLanguage())%>";
					}
					window.top.Dialog.alert("“"+title+"”<%=SystemEnv.getHtmlLabelName(83398,user.getLanguage())%>");
					return;
				}
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83405,user.getLanguage())%>“"+title+"”<%=SystemEnv.getHtmlLabelName(83441,user.getLanguage())%>",function(){
					genForm(type);
				});
			}
			
			function genForm(type){
				var subcompanyid = $('#field004').val() || 0 ;
				
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Width = 400;
				dialog.Height = 120;
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(82091,user.getLanguage())%>";
				dialog.URL = "/hrm/pm/hrmStateProcSet/genForm.jsp";
				dialog.normalDialog = false;
				dialog.OKEvent = function(){
					var formName = dialog.innerFrame.contentWindow.document.getElementById('title').value;
					if(formName == "") {
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
						return;
					} else {
						jQuery.ajax({
							url : "/hrm/pm/hrmStateProcSet/genFormSave.jsp",
							type : "post",
							async : true,
							data : {"field006":type, "formName":formName,"subcompanyid":subcompanyid},
							dataType : "json",
							contentType: "application/x-www-form-urlencoded;charset=utf-8",
							success: function do4Success(data){
								if(data.errmsg) {
									window.top.Dialog.alert(data.errmsg);
								} else if(data.formId) {
									_writeBackData('field002', 2, {id: $.trim(data.formId), name: $.trim(data.formName)}, {hasInput:true});
									_writeBackData('field001', 2, {id:"", name:""}, {hasInput:true});
									window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("700,15413,15242",user.getLanguage())%>", function(){dialog.close();});
								} else {
									dialog.close();
								}
							}
						});	
					}
				};
				dialog.show();
			}
		</script>
	</head>
	<body>
	<%if("1".equals(isDialog)){ %>
		<div class="zDialog_div_content">
	<%} %>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
				TopMenu topMenu = new TopMenu(out, user);
				topMenu.add(SystemEnv.getHtmlLabelName(86,user.getLanguage()), "javascript:doSave(0);");
				if(!isEdit) topMenu.add(SystemEnv.getHtmlLabelName(32159,user.getLanguage()), "javascript:doSave(1);");
				RCMenu += topMenu.getRightMenus();
				RCMenuHeight += RCMenuHeightStep * topMenu.size();
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%topMenu.show();%>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<form id="weaver" name="frmMain" action="/hrm/pm/hrmStateProcSet/save.jsp" method="post" >
				<input type="hidden" name="id" value="<%=id%>">
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(34067,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="field001" width="235px"
								browserValue='<%=String.valueOf(bean.getField001()) %>' 
								browserSpanValue='<%=WorkflowComInfo.getWorkflowname(String.valueOf(bean.getField001())) %>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere= where isbill=1"
								getBrowserUrlFn="getWfBrowserUrl"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="javascript:getWfCompleteUrl()" _callback="setForm">
							</brow:browser>
							<span class="e8_browserSpan"><button class="e8_browserAdd" title="<%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%>" id="wfid_addbtn" type="button" onclick="onCreateWf();"></button></span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="field002" width="235px"
								browserValue='<%=String.valueOf(bean.getField002()) %>' 
								browserSpanValue='<%=field002Name%>'
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/hrm/attendance/workflowBill/browser.jsp?selectedids="
								getBrowserUrlFn="getFormBrowserUrl"
								hasInput="true" isSingle="true" hasBrowser="true" isMustInput="2"
								completeUrl="javascript:getFormCompleteUrl()">
							</brow:browser>
							&nbsp;&nbsp;&nbsp;&nbsp;<span class='e8_btn_top' id="genform_span" onclick="genFormCheck();"><%=SystemEnv.getHtmlLabelNames("81855,15413",user.getLanguage())%></span>&nbsp;&nbsp;<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(124924,user.getLanguage())%>" />
						</wea:item>
						<%
							if(strUtil.vString(ManageDetachComInfo.getDetachable()).equals("1")) {
						%>
						<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="field004" browserValue='<%=String.valueOf(bean.getField004())%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=164" width="235px" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(bean.getField004()))%>'>
							</brow:browser>
						</wea:item>
						<%	}%>
						<wea:item><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></wea:item>
						<wea:item>
							<input type="checkbox"  tzCheckbox="true" <%=bean.getField005() == 1 || bean.getField005() == -1?"checked":"" %> id="field005" name="field005" value="1" <%=bean.isSysForm() ? "disabled" : ""%>/>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(84791,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="field006Span" required='<%=bean.getField006()==-1%>'>
								<select id="field006" name="field006" class="inputStyle" onchange="checkinput('field006','field006Span');checkValue(this, 'field006Span');">
									<option value="-1"></option>
									<option value="0" <%=bean.getField006() == 0 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("16250,18015",user.getLanguage())%></option>
									<option value="1" <%=bean.getField006() == 1 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("15710,18015",user.getLanguage())%></option>
									<option value="2" <%=bean.getField006() == 2 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6088,18015",user.getLanguage())%></option>
									<option value="3" <%=bean.getField006() == 3 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6089,18015",user.getLanguage())%></option>
									<option value="4" <%=bean.getField006() == 4 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6090,18015",user.getLanguage())%></option>
									<option value="5" <%=bean.getField006() == 5 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6091,18015",user.getLanguage())%></option>
									<option value="6" <%=bean.getField006() == 6 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6092,18015",user.getLanguage())%></option>
									<option value="7" <%=bean.getField006() == 7 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6094,18015",user.getLanguage())%></option>
									<option value="8" <%=bean.getField006() == 8 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6093,18015",user.getLanguage())%></option>
								</select>
							</wea:required>
						</wea:item>
					</wea:group>
				</wea:layout>
			</form>
	<%if("1".equals(isDialog)){ %>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="4col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<script type="text/javascript">jQuery(document).ready(function(){resizeDialog(document);});</script>
	<%} %>
	</body>
</html>
