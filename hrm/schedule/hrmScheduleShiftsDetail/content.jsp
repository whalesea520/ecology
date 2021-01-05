<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-14[班次明细] Generated from 长东设计 www.mfstyle.cn -->
<%@ page import="weaver.hrm.schedule.domain.HrmScheduleWorktime"%>
<%@ page import="weaver.hrm.schedule.domain.HrmScheduleShiftsSet"%>
<%@ page import="weaver.hrm.schedule.domain.HrmScheduleShiftsDetail"%>
<jsp:useBean id="hrmScheduleWorktimeManager" class="weaver.hrm.schedule.manager.HrmScheduleWorktimeManager" scope="page"/>
<jsp:useBean id="hrmScheduleShiftsDetailManager" class="weaver.hrm.schedule.manager.HrmScheduleShiftsDetailManager" scope="page"/>
<%
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(125817, user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	String id = strUtil.vString(request.getParameter("id"));
	Long field001 = strUtil.parseToLong(request.getParameter("field001"));
	int field003 = strUtil.parseToInt(request.getParameter("field003"), 0);

	HrmScheduleShiftsDetail bean = id.length() > 0 ? hrmScheduleShiftsDetailManager.get(id) : null;
	bean = bean == null ? new HrmScheduleShiftsDetail() : bean;
	
	HrmScheduleShiftsSet setBean = new HrmScheduleShiftsSet();
	setBean.setField003(field003);
	String groupTitle = setBean.getField003Name(user.getLanguage());
	int chooseNum = 0;
	switch(field003) {
		case 0:
			chooseNum = bean.totalWNum();
			break;
		case 1:
			chooseNum = bean.totalDNum();
			break;
	}
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			var common = new MFCommon();
			var id = "<%=bean.getId()%>";
			var field001 = "<%=field001%>";
			var field003 = "<%=field003%>";
			var wNumSpan = "wNumSpan";
			var dNumSpan = "dNumSpan";

			jQuery(document).ready(function(){showFieldItem();});

			function showFieldItem() {}

			function doSave() {
				var names = {};
				if(field003 == '0') {
					names = getNames(wNumSpan);
				} else if(field003 == '1') {
					names = getNames(dNumSpan);
					var _field003 = $GetEle("field003").value;
					if(_field003 == '1') {
						var field005 = $GetEle("field005").value;
						if(field005 == "" || parseInt(field005) < 1) {
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125919,user.getLanguage())%>");
							return;
						}
					}
				}
				var nameParams = "";
				for(var i = 0; i<names.length; i++) if($GetEle(names[i]).checked) nameParams += "&param"+names[i]+"=1";
				var appendParam = "&"+$("#weaver").serialize()+nameParams;
				
				var worktime = document.getElementsByName("worktime");
				var ids = "";
				for(var i=0; i<worktime.length; i++) if(worktime[i].checked) ids += (ids == "" ? "" : ";") + worktime[i].value;
				if(ids == "") {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("18214,125799",user.getLanguage())%>");
					return;
				} else {
					var obj = jQuery.parseJSON(common.ajax("cmd=checkDetailWorkTime&id="+id+"&arg="+field001+"&arg1="+ids+"&type="+field003+appendParam));
					if(obj.result == "1") {
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125923,user.getLanguage())%>");
						return;
					} else if(obj.result == "2") {
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125924,user.getLanguage())%>");
						return;
					} else if(obj.result == "3") {
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125920,user.getLanguage())%>");
						return;
					}
				}
				
				try{parent.disableTabBtn();}catch(e){}
				common.ajax($("#weaver").attr("action")+"?cmd=save&field002="+ids+appendParam+"&randomstr="+randomString(6), false, function(result) {
					parentWin.resetLocation(field003);
					result = jQuery.parseJSON(result);
					parentWin.closeDialog();
				});
			}
			
			function getNames(span) {
				var names = [];
				if(span == wNumSpan) {
					names = ["w007", "w001", "w002", "w003", "w004", "w005", "w006"];
				} else if(span == dNumSpan) {
					names = [
						"d001", "d002", "d003", "d004", "d005", "d006", "d007", "d008", "d009", "d010",
						"d011", "d012", "d013", "d014", "d015", "d016", "d017", "d018", "d019", "d020",
						"d021", "d022", "d023", "d024", "d025", "d026", "d027", "d028", "d029", "d030",
						"d031"
					];
				}
				return names;
			}
			
			function getCheckBox(span) {
				var checkbox = "wCheckBox";
				if(span == wNumSpan) checkbox = "wCheckBox"; 
				else if(span == dNumSpan) checkbox = "dCheckBox";
				return checkbox;
			}
			
			function chooseAll(obj, span) {
				var names = getNames(span);
				for(var i = 0; i<names.length; i++) changeCheckboxStatus($GetEle(names[i]), obj.checked);
				$GetEle(span).innerHTML = obj.checked ? names.length : 0;
			}
			
			function totalNum(obj, span) {
				var cl = parseInt($GetEle(span).innerHTML) + (obj.checked ? 1 : -1);
				$GetEle(span).innerHTML = cl;
				var names = getNames(span);
				var checkbox = $GetEle(getCheckBox(span));
				if(cl == names.length) changeCheckboxStatus(checkbox, true);
				else changeCheckboxStatus(checkbox, false);
			}
			
			function changeDiv(obj) {
				if(obj.value == 0) {
					$(".aDiv").show();
					$(".pDiv").hide();
				} else {
					$(".aDiv").hide();
					$(".pDiv").show();
				}
			}
		</script>
	</head>
	<body style="background:rgb(248,248,248)">
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
			<form id="weaver" name="frmMain" action="/hrm/schedule/hrmScheduleShiftsDetail/save.jsp" method="post" >
				<input type="hidden" name="id" value="<%=bean.getId()%>">
				<input type="hidden" name="field001" value="<%=field001%>">
				<wea:layout type="2col">
					<wea:group context="<%=groupTitle%>">
						<wea:item attributes="{'isTableList':'true','colspan':'full'}">
							<table cellspacing="0" cellpadding="0" style="width:100%;height:314px;border-collapse:collapse;background:rgb(248,248,248);" border="0">
								<tr style="width:100%;height:100%;">
									<td style="width:50%;border-right:1px solid rgb(220,220,220);">
										<div style="margin:10px auto auto 30px;">
											<div><%=SystemEnv.getHtmlLabelNames("18214,125799,18435",user.getLanguage())%></div>
											<div id="lScrollContainer" style="height:210px;width:80%;overflow:hidden;margin:10px 0px 10px 0px;background:white;border:1px solid rgb(121,121,121)">
												<div style="margin:5px 10px;">
												<%
													List list = hrmScheduleWorktimeManager.find();
													HrmScheduleWorktime workTimeBean = null;
													String[] field002Array = bean.getField002().split(";");
													for(int i=0; i<(list==null?0:list.size()); i++) {
														workTimeBean = (HrmScheduleWorktime)list.get(i);
														String curChecked = "";
														for(String field : field002Array) {
															if(workTimeBean.getId() == strUtil.parseToLong(field)) {
																curChecked = "checked";
																break;
															}
														}
														out.println("<div><input type='checkbox' name='worktime' "+curChecked+" value='"+workTimeBean.getId()+"'>"+workTimeBean.getField001()+SystemEnv.getHtmlLabelName(81913,user.getLanguage())+workTimeBean.getTime()+SystemEnv.getHtmlLabelName(81914,user.getLanguage())+"</div>");
													}
												%>
												</div>
											</div>
											<div style="height:45px;"><%=SystemEnv.getHtmlLabelName(125908,user.getLanguage())%></div>
										</div>
									</td>
									<td style="width:50%;<%=field003!=0&&field003!=1?"text-align:center":""%>">
										<%
											switch(field003) {
												case 0:
										%>
										<div style="margin:10px auto auto 30px;">
											<div><%=SystemEnv.getHtmlLabelNames("27938,18435",user.getLanguage())%></div>
											<div id="rScrollContainer" style="height:210px;width:80%;overflow:hidden;margin:10px 0px 10px 0px;background:white;border:1px solid rgb(121,121,121)">
												<div style="margin:5px 10px;">
													<table cellspacing="0" cellpadding="0" style="width:100%;height:100%;">
														<tr>
															<td style="border-bottom:1px solid rgb(121,121,121);text-align:left">
																<input type="checkbox" name="wCheckBox" value="" onclick="chooseAll(this, 'wNumSpan')"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>
															</td>
															<td style="border-bottom:1px solid rgb(121,121,121);text-align:right">
																<%=SystemEnv.getHtmlLabelNames("31503,81913",user.getLanguage())%><span id="wNumSpan" name="wNumSpan"><%=chooseNum%></span><%=SystemEnv.getHtmlLabelName(81914,user.getLanguage())%>
															</td>
														</tr>
														<tr>
															<td colspan="2">
																<div style="margin-top:5px">
																<%
																	int[] wIds = {398, 392, 393, 394, 395, 396, 397};
																	String[] wNames = {"w007", "w001", "w002", "w003", "w004", "w005", "w006"};
																	int[] wValues = {bean.getW007(), bean.getW001(), bean.getW002(), bean.getW003(), bean.getW004(), bean.getW005(), bean.getW006()};
																	for(int i=0; i<wNames.length; i++) {
																		out.println("<div><input type='checkbox' name='"+wNames[i]+"' value='' "+(wValues[i] == 1 ? "checked" : "")+" onclick=\"totalNum(this, 'wNumSpan')\">"+SystemEnv.getHtmlLabelName(wIds[i],user.getLanguage())+"</div>");
																	}
																%>
																</div>
															</td>
														</tr>
													</table>
												</div>
											</div>
											<div style="height:45px;"></div>
										</div>
										<%
													break;
												case 1:
										%>
										<div style="margin:10px auto auto 30px;">
											<div>
												<%=SystemEnv.getHtmlLabelNames("27938,18435",user.getLanguage())%>
												<select id="field003" name="field003" class="inputStyle" onchange="changeDiv(this)">
													<option value="0" <%=String.valueOf(bean.getField003()).equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125896,user.getLanguage())%></option>
													<!--<option value="1" <%=String.valueOf(bean.getField003()).equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125897,user.getLanguage())%></option>-->
												</select>
											</div>
											<div id="rScrollContainer" class="aDiv" style="height:255px;width:80%;overflow:hidden;margin:10px 0px 10px 0px;background:white;border:1px solid rgb(121,121,121);display:<%=bean.getField003() == 1 ? "none":""%>">
												<div style="margin:5px 10px;">
													<table cellspacing="0" cellpadding="0" style="width:100%;height:100%;">
														<tr>
															<td style="border-bottom:1px solid rgb(121,121,121);text-align:left">
																<input type="checkbox" name="dCheckBox" value="" onclick="chooseAll(this, 'dNumSpan')"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>
															</td>
															<td style="border-bottom:1px solid rgb(121,121,121);text-align:right">
																<%=SystemEnv.getHtmlLabelNames("31503,81913",user.getLanguage())%><span id="dNumSpan" name="dNumSpan"><%=chooseNum%></span><%=SystemEnv.getHtmlLabelName(81914,user.getLanguage())%>
															</td>
														</tr>
														<tr>
															<td colspan="2">
																<div style="margin-top:5px">
																	<table cellspacing="0" cellpadding="0" style="width:100%;height:100%;">
																	<%
																		String[] dNames = {
																			"d001", "d002", "d003", "d004", "d005", "d006", "d007", "d008", "d009", "d010",
																			"d011", "d012", "d013", "d014", "d015", "d016", "d017", "d018", "d019", "d020",
																			"d021", "d022", "d023", "d024", "d025", "d026", "d027", "d028", "d029", "d030",
																			"d031"
																		};
																		int[] dValues = {
																			bean.getD001(), bean.getD002(), bean.getD003(), bean.getD004(), bean.getD005(), bean.getD006(), bean.getD007(), bean.getD008(), bean.getD009(), bean.getD010(),
																			bean.getD011(), bean.getD012(), bean.getD013(), bean.getD014(), bean.getD015(), bean.getD016(), bean.getD017(), bean.getD018(), bean.getD019(), bean.getD020(),
																			bean.getD021(), bean.getD022(), bean.getD023(), bean.getD024(), bean.getD025(), bean.getD026(), bean.getD027(), bean.getD028(), bean.getD029(), bean.getD030(),
																			bean.getD031()
																		};
																		String dName = SystemEnv.getHtmlLabelName(390,user.getLanguage());
																		for(int i=0; i<dNames.length; i++) {
																			if(i == 0 || i % 5 == 0) out.println("<tr>");
																			out.println("<td><input type='checkbox' name='"+dNames[i]+"' value='' "+(dValues[i] == 1 ? "checked" : "")+" onclick=\"totalNum(this, 'dNumSpan')\">"+(i+1)+dName+"</td>");
																			if(i != 0 && (i+1) % 5 == 0) out.println("</tr>");
																		}
																	%>
																	</table>
																</div>
															</td>
														</tr>
													</table>
												</div>
											</div>
											<div class="pDiv" style="height:255px;width:80%;margin:10px 0px 10px 0px;display:<%=bean.getField003() == 1 ? "":"none"%>">
												<select id="field004" name="field004" class="inputStyle" style="width:70px">
													<option value="0" <%=String.valueOf(bean.getField004()).equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125894,user.getLanguage())%></option>
													<option value="1" <%=String.valueOf(bean.getField004()).equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125895,user.getLanguage())%></option>
												</select>
												<wea:required id="field005Span" required="<%=bean.getField005() < 0 || String.valueOf(bean.getField005()).length() == 0%>">
													<input class="inputstyle" style="width:50px;margin-left:10px" type="text" maxlength="2" name="field005" onKeyPress="ItemCount_KeyPress()" onBlur="checknumber('field005')" onchange="checkinput('field005','field005Span')" value="<%=bean.getField005() < 0 ? "" : String.valueOf(bean.getField005())%>">
												</wea:required>
												<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
											</div>
										</div>
										<%
													break;
												case 4:
													out.println(SystemEnv.getHtmlLabelName(125911,user.getLanguage()));
													break;
												case 5:
													out.println(SystemEnv.getHtmlLabelName(125910,user.getLanguage()));
													break;
												default:
													out.println(SystemEnv.getHtmlLabelName(125909,user.getLanguage()));
													break;
											}
										%>
									</td>
								</tr>
							</table>
						</wea:item>
					</wea:group>
				</wea:layout>
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
		<script type="text/javascript">jQuery(document).ready(function(){resizeDialog(document);});</script>
	<%} %>
		<script type="text/javascript">jQuery('#lScrollContainer,#rScrollContainer').perfectScrollbar();</script>
	</body>
</html>
