<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="/appres/hrm/js/color001.js"></script>
<script type="text/javascript">var _jQuery = jQuery.noConflict(true);</script>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-13[班次设置] Generated from 长东设计 www.mfstyle.cn -->
<%@ page import="weaver.hrm.schedule.domain.*"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="hrmScheduleShiftsSetManager" class="weaver.hrm.schedule.manager.HrmScheduleShiftsSetManager" scope="page"/>
<jsp:useBean id="hrmScheduleShiftsDetailManager" class="weaver.hrm.schedule.manager.HrmScheduleShiftsDetailManager" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("HrmSchedulingShifts:set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(125800, user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	String id = strUtil.vString(request.getParameter("id"));
	String auth = strUtil.vString(request.getParameter("auth"));
	if(strUtil.isNotNull(auth) && auth.equals("view")) id = String.valueOf(hrmScheduleShiftsSetManager.getRealShiftsSetId(id));
	int field002 = strUtil.parseToInt(request.getParameter("subcompanyid"), 0);
	int field003 = strUtil.parseToInt(request.getParameter("field003"));

	HrmScheduleShiftsSet bean = id.length() > 0 ? hrmScheduleShiftsSetManager.get(id) : null;
	boolean isNew = bean == null;
	bean = isNew ? new HrmScheduleShiftsSet(strUtil.getUUID()) : bean;
	if(isNew && field002 != 0) bean.setField002(field002);
	if(field003 >= 0) bean.setField003(field003);
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/color002.css" />
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/color003.css" />
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/color002.js"></script>
		<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			var common = new MFCommon();

			jQuery(document).ready(function(){
				showFieldItem();
			});
			
			function getType() {
				return $GetEle("field003").value;
			}

			function showFieldItem() {
				$GetEle("field45").style.display = getType() == '6' ? "" : "none";
			}

			function doSave() {
				var type = getType();
				if(!check_form(document.frmMain,'field001,field002,field007'+(type == '6' ? ',field004,field005' : ''))) return;
				if(type == '6') {
					var field004Value = $GetEle("field004").value;
					var field005Value = $GetEle("field005").value;
					if(parseInt(field004Value) <= 0 ||  parseInt(field005Value) <= 0) {
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125901,user.getLanguage())%>");
						return;
					}
				}
				try{parent.disableTabBtn();}catch(e){}
				common.ajax($("#weaver").attr("action")+"?cmd=save&"+$("#weaver").serialize()+"&randomstr="+randomString(6), false, function(result) {
					parentWin._table.reLoad();
					result = jQuery.parseJSON(result);
					parentWin.closeDialog();
				});
			}
			
			var dialog = null;
			
			function closeDialog() {
				if(dialog) dialog.close();
			}
			
			function doAdd(id) {
				id = id && id != "" ? id : "";
				closeDialog();
				common.initDialog({width:700, height:450, showMax:false});
				dialog = common.showDialog("/hrm/schedule/hrmScheduleShiftsDetail/tab.jsp?topage=content&field001=<%=bean.getId()%>&id="+id+"&field003="+getType(), id == "" ? "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" : "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>");
			}
			
			function resetLocation(type) {
				_table.reLoad();
				parentWin._table.reLoad();
			}
			
			function doDel(id) {
				if(!id) id = _xtable_CheckedCheckboxId();
				if(!id) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)) id = id.substring(0,id.length-1);
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function() {
					common.ajax("/hrm/schedule/hrmScheduleShiftsDetail/save.jsp?cmd=delete&ids="+id, false, function(result){resetLocation("<%=bean.getField003()%>");});
				});
			}
			
			function deleteDetail() {
				var obj = jQuery.parseJSON(common.ajax("cmd=getScheduleShiftsSetDetailSize&id=<%=bean.getId()%>"));
				if(parseInt(obj.result) > 0) {
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(125925,user.getLanguage())%>",function() {
						common.ajax("/hrm/schedule/hrmScheduleShiftsDetail/save.jsp?cmd=deleteBySet&id=<%=bean.getId()%>", false, function(result){resetLocation(getType());});
					}, function() {
						jQuery("select[id=field003]").find("option[value=<%=bean.getField003()%>]").attr("selected",true);
						showFieldItem();
					});
				}
			}

			function chooseAll(obj){
				$("input[name='dId']").each(function(){
					changeCheckboxStatus(this,obj.checked);
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
			<form id="weaver" name="frmMain" action="/hrm/schedule/hrmScheduleShiftsSet/save.jsp" method="post" >
				<input type="hidden" name="id" value="<%=bean.getId()%>">
				<wea:layout type="2col">
					<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>" attributes="{'groupSHBtnDisplay':'none'}">
						<wea:item attributes="{'samePair':'field001Item'}"><%=SystemEnv.getHtmlLabelName(125818,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field001Item'}">
							<wea:required id="field001Span" required="<%=String.valueOf(bean.getField001()).length() == 0%>">
								<input class="inputstyle" type="text" maxlength="100" name="field001" onchange="checkinput('field001','field001Span')" value="<%=bean.getField001()%>">
							</wea:required>
						</wea:item>
						<wea:item attributes="{'samePair':'field003Item'}"><%=SystemEnv.getHtmlLabelName(125819,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field003Item'}">
							<div style="width:100%">
								<wea:required id="field003Span" required="<%=String.valueOf(bean.getField003()).length() == 0%>">
									<select id="field003" name="field003" notBeauty=true class="inputStyle" onchange="showFieldItem();deleteDetail();">
										<option value="0" <%=String.valueOf(bean.getField003()).equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125827,user.getLanguage())%></option>
										<option value="1" <%=String.valueOf(bean.getField003()).equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125828,user.getLanguage())%></option>
										<option value="2" <%=String.valueOf(bean.getField003()).equals("2") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125823,user.getLanguage())%></option>
										<option value="3" <%=String.valueOf(bean.getField003()).equals("3") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125824,user.getLanguage())%></option>
										<option value="4" <%=String.valueOf(bean.getField003()).equals("4") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125825,user.getLanguage())%></option>
										<option value="5" <%=String.valueOf(bean.getField003()).equals("5") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125826,user.getLanguage())%></option>
										<option value="6" <%=String.valueOf(bean.getField003()).equals("6") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%></option>
									</select>
								</wea:required>
								<span id="field45" name="field45" style="margin-left:5px;display:none">
									<span style="margin-left:5px">
										<%=SystemEnv.getHtmlLabelName(125900,user.getLanguage())%>
										<wea:required id="field004Span" required="<%=String.valueOf(bean.getField004()).length() == 0%>">
											<input class="inputStyle" style="width:7%;margin-left:5px" type="text" maxlength="3" name="field004" onKeyPress="ItemCount_KeyPress()" onBlur="checknumber('field004');common.cusCheck('field004','field004Span');" onchange="checkinput('field004','field004Span')" value="<%=bean.getField004()%>">
										</wea:required>
									</span>
									<span style="margin-left:5px">
										<%=SystemEnv.getHtmlLabelName(125806,user.getLanguage())%>
										<wea:required id="field005Span" required="<%=String.valueOf(bean.getField005()).length() == 0%>">
											<input class="inputStyle" style="width:7%;margin-left:5px" type="text" maxlength="3" name="field005" onKeyPress="ItemCount_KeyPress()" onBlur="checknumber('field005');common.cusCheck('field005','field005Span');" onchange="checkinput('field005','field005Span')" value="<%=bean.getField005()%>">
										</wea:required>
									</span>
								</span>
							</div>
						</wea:item>
						<wea:item attributes="{'samePair':'field006Item'}"><%=SystemEnv.getHtmlLabelName(125820,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field006Item'}">
							<wea:required id="field006Span" required="<%=String.valueOf(bean.getField006()).length() == 0%>">
								<select id="field006" name="field006" notBeauty=true class="inputStyle">
									<option value="0" <%=String.valueOf(bean.getField006()).equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125837,user.getLanguage())%></option>
									<option value="1" <%=String.valueOf(bean.getField006()).equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125899,user.getLanguage())%></option>
								</select>
							</wea:required>
						</wea:item>
						<%
							if(strUtil.vString(detachCommonInfo.getDetachable()).equals("1")) {
						%>
						<wea:item attributes="{'samePair':'field002Item'}"><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field002Item'}">
							<brow:browser viewType="0" name="field002" width="60%"
								browserValue="<%=String.valueOf(bean.getField002())%>"
								browserSpanValue="<%=SubCompanyComInfo.getSubCompanyname(String.valueOf(bean.getField002()))%>"
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1"
								hasInput="true" isSingle="true" hasBrowser="true" isMustInput="2"
								completeUrl="/data.jsp?type=164&show_virtual_org=-1" _callback="">
							</brow:browser>
						</wea:item>
						<%}%>
						<wea:item attributes="{'samePair':'field007Item'}"><%=SystemEnv.getHtmlLabelName(16071,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field007Item'}">
							<div id="colorDiv" class="colorDiv">
								<button style="border-right: medium none; border-top: medium none; background-image: url(/appres/hrm/image/attendance/img001.png); overflow: hidden; border-left: medium none; width: 16px; cursor: pointer; border-bottom: medium none; background-repeat: no-repeat; height: 16px; background-color: transparent" type="button" onclick="onShowColor('field007Span','field007')"></button>
								<span id="field007Span" name="field007Span" style="width:24px;height:16px;vertical-align:middle;margin-left:5px;display:inline-block;background:<%=bean.getField007()%>"></span>
								<input type="hidden" id="field007" name="field007" value="<%=bean.getField007()%>">
							</div>
						</wea:item>
					</wea:group>
					<wea:group context="<%=SystemEnv.getHtmlLabelName(125817,user.getLanguage())%>" attributes="{'groupSHBtnDisplay':'none'}">
						<wea:item type="groupHead">
							<img class="toolpic additem" style="vertical-align:middle;margin-right:5px" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" accesskey="" src="/wui/theme/ecology8/weaveredittable/img/add_wev8.png" onclick="doAdd()">
							<img class="toolpic deleteitem" style="vertical-align:middle;margin-right:10px" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" accesskey="" src="/wui/theme/ecology8/weaveredittable/img/delete_wev8.png" onclick="doDel()">
						</wea:item>
						<wea:item attributes="{'isTableList':'true','colspan':'full', 'id':'Hrm_HrmScheduleShiftsDetail_Table'}">
							<%
								String sqlField = "t.*";
								String sqlFrom = "from (select t2.field003 as t2Field003, t.*, 0 as cnt from hrm_schedule_shifts_detail t left join hrm_schedule_shifts_set t2 on t.field001 = t2.id where t.delflag = 0) t";
								String sqlWhere = "where t.delflag = 0 and t.field001 = "+bean.getId();
								SplitPageTagTable table = new SplitPageTagTable("Hrm_HrmScheduleShiftsDetail", out, user);
								table.addOperate(SystemEnv.getHtmlLabelName(93,user.getLanguage()), "javascript:doAdd();", "false");
								table.addOperate(SystemEnv.getHtmlLabelName(91,user.getLanguage()), "javascript:doDel();", "false");
								table.setPopedompara("+column:cnt+==0");
								table.setSql(sqlField, sqlFrom, sqlWhere, "id", "desc");
								table.addFormatCol("45%", SystemEnv.getHtmlLabelName(125799,user.getLanguage()), "field002", "{cmd:class[weaver.hrm.schedule.manager.HrmScheduleShiftsDetailManager.getSelfWorkTime(+column:field002+, "+user.getLanguage()+")]}");
								table.addFormatCol("50%", SystemEnv.getHtmlLabelName(97,user.getLanguage()), "field003", "{cmd:class[weaver.hrm.schedule.manager.HrmScheduleShiftsDetailManager.getDateValue("+user.getLanguage()+",+column:t2Field003+,+column:field003+,+column:field004+,+column:field005+,+column:d001+,+column:d002+,+column:d003+,+column:d004+,+column:d005+,+column:d006+,+column:d007+,+column:d008+,+column:d009+,+column:d010+,+column:d011+,+column:d012+,+column:d013+,+column:d014+,+column:d015+,+column:d016+,+column:d017+,+column:d018+,+column:d019+,+column:d020+,+column:d021+,+column:d022+,+column:d023+,+column:d024+,+column:d025+,+column:d026+,+column:d027+,+column:d028+,+column:d029+,+column:d030+,+column:d031+,+column:w001+,+column:w002+,+column:w003+,+column:w004+,+column:w005+,+column:w006+,+column:w007+)]}");
							%>
							<wea:SplitPageTag isShowTopInfo="false" tableString="<%=table.toString()%>" selectedstrs="" mode="run"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</form>
			<div id="dialogDiv"><input type="text" id="full"/></div>
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
		<script type="text/javascript">
			$("#dialogDiv").dialog({autoOpen:false, modal:true, width:460, height:300, draggable:false, resizable:false});
			
			function closeDiv(){$("#dialogDiv").dialog("close");}
			
			function setColor(tdname, inputename, color) {
				$("#"+tdname).css({"background":color});
				$("input[id="+inputename+"]").val(color);
			}

			function onShowColor(tdname, inputename) {
				_jQuery("#full").spectrum({
					color: $("input[id="+inputename+"]").val(),
					flat: true,
					showInput: true,
					className: "full-spectrum",
					showInitial: false,
					showPalette: true,
					showSelectionPalette: true,
					maxPaletteSize: 10,
					preferredFormat: "hex",
					localStorageKey: "wcd.mf",
					onReset: function() {
						setColor(tdname, inputename, "#d9ead3");
						closeDiv();
					},
					onChoose: function(color) {
						setColor(tdname, inputename, color);
						closeDiv();
					},
					onCancel: function() {
						closeDiv();
					},
					palette: [
						["rgb(0, 0, 0)", "rgb(67, 67, 67)", "rgb(102, 102, 102)", "rgb(204, 204, 204)", "rgb(217, 217, 217)", "rgb(255, 255, 255)"],
						["rgb(152, 0, 0)", "rgb(255, 0, 0)", "rgb(255, 153, 0)", "rgb(255, 255, 0)", "rgb(0, 255, 0)", "rgb(0, 255, 255)", "rgb(74, 134, 232)", "rgb(0, 0, 255)", "rgb(153, 0, 255)", "rgb(255, 0, 255)"],
						["rgb(230, 184, 175)", "rgb(244, 204, 204)", "rgb(252, 229, 205)", "rgb(255, 242, 204)", "rgb(217, 234, 211)", "rgb(208, 224, 227)", "rgb(201, 218, 248)", "rgb(207, 226, 243)", "rgb(217, 210, 233)", "rgb(234, 209, 220)", "rgb(221, 126, 107)", "rgb(234, 153, 153)", "rgb(249, 203, 156)", "rgb(255, 229, 153)", "rgb(182, 215, 168)", "rgb(162, 196, 201)", "rgb(164, 194, 244)", "rgb(159, 197, 232)", "rgb(180, 167, 214)", "rgb(213, 166, 189)", "rgb(204, 65, 37)", "rgb(224, 102, 102)", "rgb(246, 178, 107)", "rgb(255, 217, 102)", "rgb(147, 196, 125)", "rgb(118, 165, 175)", "rgb(109, 158, 235)", "rgb(111, 168, 220)", "rgb(142, 124, 195)", "rgb(194, 123, 160)", "rgb(166, 28, 0)", "rgb(204, 0, 0)", "rgb(230, 145, 56)", "rgb(241, 194, 50)", "rgb(106, 168, 79)", "rgb(69, 129, 142)", "rgb(60, 120, 216)", "rgb(61, 133, 198)", "rgb(103, 78, 167)", "rgb(166, 77, 121)", "rgb(91, 15, 0)", "rgb(102, 0, 0)", "rgb(120, 63, 4)", "rgb(127, 96, 0)", "rgb(39, 78, 19)", "rgb(12, 52, 61)", "rgb(28, 69, 135)", "rgb(7, 55, 99)", "rgb(32, 18, 77)", "rgb(76, 17, 48)"]
					]
				});
				$("#dialogDiv").dialog('open');
				$(".ui-dialog").removeClass("ui-widget ui-widget-content ui-corner-all ui-front");
				$(".ui-dialog-titlebar").css("display","none");
			}
		</script>
	</body>
</html>
