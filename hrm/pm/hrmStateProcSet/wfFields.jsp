<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.pm.domain.*,weaver.hrm.attendance.domain.*"%>
<%@ include file="/hrm/header.jsp"%>
<jsp:useBean id="stateProcSetManager" class="weaver.hrm.pm.manager.HrmStateProcSetManager" scope="page" />
<jsp:useBean id="stateProcFieldsManager" class="weaver.hrm.pm.manager.HrmStateProcFieldsManager" scope="page" />
<jsp:useBean id="stateProcRelationManager" class="weaver.hrm.pm.manager.HrmStateProcRelationManager" scope="page" />
<jsp:useBean id="workflowBillfieldManager" class="weaver.hrm.attendance.manager.WorkflowBillfieldManager" scope="page" />
<!-- Added by wcd 2015-07-03[状态变更流程] -->
<%
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(84790, user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	String id = strUtil.vString(request.getParameter("id"));
	HrmStateProcSet bean = stateProcSetManager.get(id);
	int billId = bean.getField002();
	boolean isDisabled = billId == 40 || billId == 41 || billId == 42;
	List list = stateProcFieldsManager.find("[map]field001:"+bean.getBillId()+";languageid:"+user.getLanguage());
	List fieldList = workflowBillfieldManager.find("[map]billid:"+billId+";languageid:"+user.getLanguage());
	List relationList = stateProcRelationManager.find("[map]field001:"+id);
	
	HrmStateProcFields fBean = null;
	StringBuffer checkFields = new StringBuffer();
	for(int i=0; i<(list == null ? 0 : list.size()); i++){
		fBean = (HrmStateProcFields)list.get(i);
		if(fBean.getField010() == 1){
			checkFields.append(checkFields.length() == 0 ? "" : ",")
			.append("select"+fBean.getId());
		}
	}
	if(bean.isHAF() && relationList.size() == 0) {
		stateProcRelationManager.initRelation(bean.getId(), list, fieldList);
		relationList = stateProcRelationManager.find(stateProcSetManager.getMapParam("field001:"+id));
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
			
		 	function doSave(){
		    	if(!check_form(document.frmMain,'<%=checkFields.toString()%>')) return;
				try{parent.disableTabBtn();}catch(e){}
				
				common.ajax($("#weaver").attr("action")+"?cmd=saveRelation&"+$("#weaver").serialize(), false, function(result){
					parentWin._table.reLoad();
					parentWin.closeDialog();
				});
		 	}
			
			function changeImg(sObj, imgSpan, field010){
				if(field010 == 0) return;
				if(sObj.value !== ""){
					$GetEle(imgSpan).style.display = "none";
				} else {
					$GetEle(imgSpan).style.display = "";
				}
			}
			
			function resetValue(cObj, sId, field005, field006, field010){
				common.ajax($("#weaver").attr("action")+"?cmd=getSelectValue&type="+field005+"&fType="+field006+"&billId=<%=billId%>&languageid=<%=user.getLanguage()%>&ck="+cObj.checked+"&randomstr="+randomString(6), false, function(result){
					result = jQuery.parseJSON(result);
					$GetEle("select"+sId).length = 1;
					if(field010 == 1) $GetEle("img"+sId).style.display = "";
					var keyArray = result.keys.split(",");
					var valueArray = result.values.split(",");
					for (var i=0; i<keyArray.length; i++) with($GetEle("select"+sId)) options[options.length] = new Option(valueArray[i], keyArray[i]);
				});
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
				if(!isDisabled) topMenu.add(SystemEnv.getHtmlLabelName(86,user.getLanguage()), "javascript:doSave();");
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
				<input type="hidden" name="field001" value="<%=id%>">
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
						<%
							HrmStateProcRelation rBean = null;
							WorkflowBillfield wfBean = null;
							for(int i=0; i<(list == null ? 0 : list.size()); i++){
								fBean = (HrmStateProcFields)list.get(i);
								if(bean.getBillId() == 0 && fBean.getField009() > 210) break;
								String selectFieldName = "";
								for(int x=0; x<(relationList==null?0:relationList.size()); x++){
									rBean = (HrmStateProcRelation)relationList.get(x);
									if(String.valueOf(rBean.getField002()).equals(String.valueOf(fBean.getId()))){
										selectFieldName = rBean.getField004();
										break;
									}
								}
								
						%>
						<wea:item><%=SystemEnv.getHtmlLabelNames(fBean.getField003(), user.getLanguage())%></wea:item>
						<wea:item>
							<select notBeauty="true" id="select<%=fBean.getId()%>" name="select<%=fBean.getId()%>" class="inputStyle" style="width:50%" onchange="changeImg(this, 'img<%=fBean.getId()%>', '<%=fBean.getField010()%>')" <%=isDisabled ? "disabled" : ""%>>
								<option value=""></option>
								<%
									boolean isSameType = false, isSameHtmltype = false, isSelectField = false;
									for(int j=0; j<(fieldList == null ? 0 : fieldList.size()); j++){
										wfBean = (WorkflowBillfield)fieldList.get(j);
										isSameType = wfBean.getType().intValue() == fBean.getField006().intValue();
										isSameHtmltype = wfBean.getFieldhtmltype().equals(String.valueOf(fBean.getField005()));
										isSelectField = selectFieldName.length() > 0 && selectFieldName.equals(wfBean.getFieldname());
										if(!isSelectField && ((fBean.getField005() == 5 && !isSameHtmltype)|| (fBean.getField005() != 5 && (!isSameHtmltype || !isSameType)))) continue;
								%>
								<option value="<%=wfBean.getFieldname()+"___"+wfBean.getId()%>" <%=selectFieldName.length() > 0 && selectFieldName.equals(wfBean.getFieldname()) ? "selected" : ""%>><%=wfBean.getLabelName()%></option>
								<%	}%>
							</select>
							<span id="img<%=fBean.getId()%>" class="img<%=fBean.getId()%>" style="display:<%=fBean.getField010() == 1 && selectFieldName.length() == 0 ? "" : "none"%>"><img align='absmiddle' src='/images/BacoError_wev8.gif'></span>
							<span style="padding-left:15px"><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames(fBean.getField005Title(),user.getLanguage())%>" /></span>
							<input type="checkbox" name="checkbox<%=fBean.getId()%>" value=1 onclick="resetValue(this, '<%=fBean.getId()%>', '<%=fBean.getField005()%>', '<%=fBean.getField006()%>', '<%=fBean.getField010()%>')" <%=isDisabled ? "disabled" : ""%>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(82481,user.getLanguage())%>
						</wea:item>
						<%	}%>
					</wea:group>
				</wea:layout>
				<%if(bean.getBillId() == 0) {%>
					<wea:layout type="2col">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%>'>
							<%
								HrmStateProcRelation rBean = null;
								WorkflowBillfield wfBean = null;
								for(int i=0; i<(list == null ? 0 : list.size()); i++){
									fBean = (HrmStateProcFields)list.get(i);
									if(fBean.getField009() <= 210 || fBean.getField009() >= 400) continue;
									String selectFieldName = "";
									for(int x=0; x<(relationList==null?0:relationList.size()); x++){
										rBean = (HrmStateProcRelation)relationList.get(x);
										if(String.valueOf(rBean.getField002()).equals(String.valueOf(fBean.getId()))){
											selectFieldName = rBean.getField004();
											break;
										}
									}
									
							%>
							<wea:item><%=SystemEnv.getHtmlLabelNames(fBean.getField003(), user.getLanguage())%></wea:item>
							<wea:item>
								<select notBeauty="true" id="select<%=fBean.getId()%>" name="select<%=fBean.getId()%>" class="inputStyle" style="width:50%" onchange="changeImg(this, 'img<%=fBean.getId()%>', '<%=fBean.getField010()%>')" <%=isDisabled ? "disabled" : ""%>>
									<option value=""></option>
									<%
										boolean isSameType = false, isSameHtmltype = false, isSelectField = false;
										for(int j=0; j<(fieldList == null ? 0 : fieldList.size()); j++){
											wfBean = (WorkflowBillfield)fieldList.get(j);
											isSameType = wfBean.getType() == fBean.getField006();
											isSameHtmltype = wfBean.getFieldhtmltype().equals(String.valueOf(fBean.getField005()));
											isSelectField = selectFieldName.length() > 0 && selectFieldName.equals(wfBean.getFieldname());
											if(!isSelectField && ((fBean.getField005() == 5 && !isSameHtmltype)|| (fBean.getField005() != 5 && (!isSameHtmltype || !isSameType)))) continue;
									%>
									<option value="<%=wfBean.getFieldname()+"___"+wfBean.getId()%>" <%=selectFieldName.length() > 0 && selectFieldName.equals(wfBean.getFieldname()) ? "selected" : ""%>><%=wfBean.getLabelName()%></option>
									<%	}%>
								</select>
								<span id="img<%=fBean.getId()%>" class="img<%=fBean.getId()%>" style="display:<%=fBean.getField010() == 1 && selectFieldName.length() == 0 ? "" : "none"%>"><img align='absmiddle' src='/images/BacoError_wev8.gif'></span>
								<span style="padding-left:15px"><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames(fBean.getField005Title(),user.getLanguage())%>" /></span>
								<input type="checkbox" name="checkbox<%=fBean.getId()%>" value=1 onclick="resetValue(this, '<%=fBean.getId()%>', '<%=fBean.getField005()%>', '<%=fBean.getField006()%>', '<%=fBean.getField010()%>')" <%=isDisabled ? "disabled" : ""%>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(82481,user.getLanguage())%>
							</wea:item>
							<%	}%>
						</wea:group>
					</wea:layout>
					<wea:layout type="2col">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(15688,user.getLanguage())%>'>
							<%
								HrmStateProcRelation rBean = null;
								WorkflowBillfield wfBean = null;
								for(int i=0; i<(list == null ? 0 : list.size()); i++){
									fBean = (HrmStateProcFields)list.get(i);
									if(fBean.getField009() < 400) continue;
									String selectFieldName = "";
									for(int x=0; x<(relationList==null?0:relationList.size()); x++){
										rBean = (HrmStateProcRelation)relationList.get(x);
										if(String.valueOf(rBean.getField002()).equals(String.valueOf(fBean.getId()))){
											selectFieldName = rBean.getField004();
											break;
										}
									}
									
							%>
							<wea:item><%=SystemEnv.getHtmlLabelNames(fBean.getField003(), user.getLanguage())%></wea:item>
							<wea:item>
								<select notBeauty="true" id="select<%=fBean.getId()%>" name="select<%=fBean.getId()%>" class="inputStyle" style="width:50%" onchange="changeImg(this, 'img<%=fBean.getId()%>', '<%=fBean.getField010()%>')" <%=isDisabled ? "disabled" : ""%>>
									<option value=""></option>
									<%
										boolean isSameType = false, isSameHtmltype = false, isSelectField = false;
										for(int j=0; j<(fieldList == null ? 0 : fieldList.size()); j++){
											wfBean = (WorkflowBillfield)fieldList.get(j);
											isSameType = wfBean.getType() == fBean.getField006();
											isSameHtmltype = wfBean.getFieldhtmltype().equals(String.valueOf(fBean.getField005()));
											isSelectField = selectFieldName.length() > 0 && selectFieldName.equals(wfBean.getFieldname());
											if(!isSelectField && ((fBean.getField005() == 5 && !isSameHtmltype)|| (fBean.getField005() != 5 && (!isSameHtmltype || !isSameType)))) continue;
									%>
									<option value="<%=wfBean.getFieldname()+"___"+wfBean.getId()%>" <%=selectFieldName.length() > 0 && selectFieldName.equals(wfBean.getFieldname()) ? "selected" : ""%>><%=wfBean.getLabelName()%></option>
									<%	}%>
								</select>
								<span id="img<%=fBean.getId()%>" class="img<%=fBean.getId()%>" style="display:<%=fBean.getField010() == 1 && selectFieldName.length() == 0 ? "" : "none"%>"><img align='absmiddle' src='/images/BacoError_wev8.gif'></span>
								<span style="padding-left:15px"><img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelNames(fBean.getField005Title(),user.getLanguage())%>" /></span>
								<input type="checkbox" name="checkbox<%=fBean.getId()%>" value=1 onclick="resetValue(this, '<%=fBean.getId()%>', '<%=fBean.getField005()%>', '<%=fBean.getField006()%>', '<%=fBean.getField010()%>')" <%=isDisabled ? "disabled" : ""%>>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(82481,user.getLanguage())%>
							</wea:item>
							<%	}%>
						</wea:group>
					</wea:layout>
				<%}%>
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
