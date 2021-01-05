<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@ include file="/hrm/header.jsp"%>
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page" />
<jsp:useBean id="attProcActionManager" class="weaver.hrm.attendance.manager.HrmAttProcActionManager" scope="page" />
<!-- Added by wcd 2015-04-27[考勤流程设置-动作设置] -->
<%
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelNames("15880,18015",user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	String id = strUtil.vString(request.getParameter("id"));
	HrmAttProcSet sBean = attProcSetManager.get(id);
	attProcActionManager.setUser(user);
	List list = attProcActionManager.find("[map]field001:"+id+";field004:0;wfId:"+sBean.getField001());
	if(list == null || list.size() == 0) list = attProcActionManager.find("[map]field001:-1;field004:1;mfid:"+sBean.getField006());
	HrmAttProcAction bean = null;
	StringBuffer fields = new StringBuffer(), checkFields = new StringBuffer();
	for(int i=0; i<(list==null?0:list.size());i++) {
		bean = (HrmAttProcAction)list.get(i);
		fields.append(fields.length() == 0 ? "" : ",").append(bean.getField002());
		checkFields.append(checkFields.length() == 0 ? "" : ",").append(bean.getField002()+"_field006");
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
			var fields = "<%=fields.toString()%>";
			var id = "<%=id%>";
			var currentId = "";
			var wfId = "<%=String.valueOf(sBean.getField001())%>";
			
		 	function doSave(){
				try{parent.disableTabBtn();}catch(e){}
				
				var _all = fields.split(",");
				var allParams = "", curParam = "";
				
				var saveFields = ["field003", "field005", "field006", "field007", "field008"];
				for(var i=0; i<_all.length; i++){
					if(i != 0) allParams+="___";
					for(var j=0; j<saveFields.length; j++){
						curParam = getParam(_all[i]+"_"+saveFields[j], saveFields[j] === "field007");
						if(curParam.length == 0) continue;
						allParams += (j == 0 ? "" : ";") + curParam;
					}
				}
				common.ajax($("#weaver").attr("action")+"?cmd=saveSet&field001="+id+"&field002="+allParams+"&randomstr="+randomString(6), false, function(result){
					parentWin._table.reLoad();
					parentWin.closeDialog();
				});
		 	}
			
			function getParam(param, isCheck){
				return $GetEle(param) ? (param+":"+(isCheck ? $GetEle(param).checked : $GetEle(param).value.trim())) : "";
			}
			
			function getBrowserUrlFn(obj){
				var mode = jQuery(obj).val();
				var browserObj = $GetEle(this.name);
				var browserValue = !browserObj ? "" : browserObj.value;
				if(mode=="1"||mode=="2") return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkflowNodeBrowserMulti.jsp?workflowId="+wfId+"&printNodes="+browserValue;
				else return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/hrm/attendance/workflowLink/multiBrowser.jsp?wfid="+wfId+"&printNodes="+browserValue;
			}
			function getCompleteUrl(obj){
				var mode = jQuery("#"+obj).val();
				if(mode=="1"||mode=="2") return "/data.jsp?type=workflowNodeBrowser&wfid="+wfId;
				else return "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid="+wfId;
			}
			function clearLinkOrNode(obj, bId){
				var e8_os = jQuery("#"+bId).find("div.e8_os");
				var innerOs = jQuery("#"+bId).find("div.e8_innerShow");
				e8_os.find("input[type='hidden']").val("");
				e8_os.find("span.e8_showNameClass").remove();
				innerOs.find("span[name$='spanimg']").html("");
				var span = jQuery(obj).closest("tr").find("span.jNiceWrapper");
				if(jQuery(obj).val()=="1"||jQuery(obj).val()=="2") span.show();
				else span.hide();
			}
			
			jQuery(document).ready(function(){
				var _all = fields.split(",");
				for(var i=0; i<_all.length; i++){
					var obj = jQuery("select[name="+_all[i]+"_field005]");
					if(obj.val() == "0") obj.closest("tr").find("span.jNiceWrapper").hide();
				}
			});
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
				topMenu.add(SystemEnv.getHtmlLabelName(86,user.getLanguage()), "javascript:doSave();");
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
			<form id="weaver" name="frmMain" action="/hrm/attendance/hrmAttProcSet/save.jsp" method="post" >
				<input type="hidden" name="field001" value="<%=id%>">
				<table class="ListStyle" cols=4  border=0 cellspacing=1 style="">
					<colgroup>
						<col width="25%">
						<col width="25%">
						<col width="25%">
						<col width="25%">
					</colgroup>
					<tr class="header">
						<td nowrap><%=SystemEnv.getHtmlLabelName(19831,user.getLanguage())%></td>
						<td nowrap><%=SystemEnv.getHtmlLabelName(33408,user.getLanguage())%></td>
						<td nowrap><%=SystemEnv.getHtmlLabelName(33410,user.getLanguage())%></td>
						<td nowrap><%=SystemEnv.getHtmlLabelName(33409,user.getLanguage())%></td>
					</tr>
					<%
						for(int i=0; i<(list==null?0:list.size());i++) {
							bean = (HrmAttProcAction)list.get(i);
					%>
					<script>currentId = "<%=bean.getField002()+"_field005"%>";</script>
					<tr class="DataLight">
						<td nowrap><%=SystemEnv.getHtmlLabelNames(bean.getField003(),user.getLanguage())%></td>
						<td nowrap>
							<select name='<%=bean.getField002()+"_field005"%>' id='<%=bean.getField002()+"_field005"%>' notBeauty="true" onchange="clearLinkOrNode(this, '<%=bean.getField002()+"_obj"%>')">
								<option value="2" <%=bean.getField005() == 2 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(18009,user.getLanguage())%></option>
								<option value="1" <%=bean.getField005() == 1 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(18010,user.getLanguage())%></option>
								<option value="0" <%=bean.getField005() == 0 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("15587,15610",user.getLanguage())%></option>
							</select>
						</td>
						<td nowrap id="<%=bean.getField002()+"_obj"%>">
							<brow:browser viewType="0" name='<%=bean.getField002()+"_field006"%>' width="100%"
							browserValue='<%=bean.getField006().equals("-1") || bean.getField006().equals("0") ? "" : String.valueOf(bean.getField006())%>' 
							browserSpanValue='<%=bean.getField006().equals("-1") || bean.getField006().equals("0") ? "" : String.valueOf(bean.getField006Name())%>'
							getBrowserUrlFn="getBrowserUrlFn"
							getBrowserUrlFnParams='<%=bean.getField002()+"_field005"%>'
							browserUrl=""
							hasInput="true" isSingle="false" hasBrowser="true" isMustInput='1'
							completeUrl="javascript:getCompleteUrl(currentId)" />
						</td>
						<td nowrap>
							<input type="checkbox" value="<%=String.valueOf(bean.getField007())%>" name="<%=bean.getField002()+"_field007"%>" id="<%=bean.getField002()+"_field007"%>" <%=bean.getField007() == 1 ? "checked" : ""%>/>
							<input type="hidden" name="<%=bean.getField002()+"_field003"%>" id="<%=bean.getField002()+"_field003"%>" value="<%=bean.getField003()%>">
							<input type="hidden" name="<%=bean.getField002()+"_field008"%>" id="<%=bean.getField002()+"_field008"%>" value="<%=bean.getField008()%>">
						</td>
					</tr>
					<%	}%>
				</table>
			</form>
	<%if("1".equals(isDialog)){ %>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	<%} %>
	</body>
</html>
