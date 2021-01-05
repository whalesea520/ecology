<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.attendance.domain.HrmLeaveTypeColor" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<jsp:useBean id="otherManager" class="weaver.hrm.report.schedulediff.HrmScheduleDiffOtherManager" scope="page"/>
<script language="javascript" type="text/javascript" src="/appres/hrm/js/color001.js"></script>
<script type="text/javascript">var _jQuery = jQuery.noConflict(true);</script>
<!-- Modified by wcd 2015-04-28 [请假类型改造，拖动列表，名称可编辑，增加启用、作为报表列，增加颜色选择器]-->
<%@ include file="/hrm/header.jsp" %>
<%	
	String imagefilename = "/images/hdMaintenance_wev8.gif"; 
	String titlename = SystemEnv.getHtmlLabelName(21609,user.getLanguage()); 
	String needfav = "1";
	String needhelp = "";
	String subcompanyid = strUtil.vString(request.getParameter("subcompanyid"), "0");
	String showname = !subcompanyid.equals("0") ? SubCompanyComInfo.getSubCompanyname(subcompanyid) : CompanyComInfo.getCompanyname("1");
%>
<HTML>
	<HEAD>
		<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/color001.css" />
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/color002.css" />
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/color003.css" />
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/mfcommon_wev8.css">
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/color002.js"></script>
		<script language="javascript" src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script language="javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
		<script type="text/javascript">
			var common = new MFCommon();
			var dialog = null;
			jQuery(document).ready(function(){
			<%//if(showname.length()>0){%>
				//parent.setTabObjName('<%=showname%>')
			<%//}%>
				registerDragEvent();
				$("#tabfield").find("tr")
					.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
					.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
			});

			function onBtnSearchClick(){
				jQuery("#frmMain").submit();
			}

			function addRow(){
				var rowIndex = jQuery("#tabfield tr").length;
				var oRow = jQuery("#tabfield")[0].insertRow(-1);
				oRow.className="DataLight";
				var oCell = oRow.insertCell(-1);
				oCell.innerHTML = "<input name=fieldChk type=checkbox value=''>" ;
				
				oCell = oRow.insertCell(-1);
				oCell.innerHTML = "<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' />" ;

				oCell = oRow.insertCell(-1);
				oCell.innerHTML = "<input type=\"input\" class=\"InputStyle\" style=\"width:120px\"  name=\"selectname\" value=\"\" onblur=\"ctrlImg(this,'imgSpan"+rowIndex+"');\"><span id=\"imgSpan"+rowIndex+"\" class=\"imgSpan"+rowIndex+"\"><IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle></span>";
					
				oCell = oRow.insertCell(-1);
				oCell.innerHTML = "<input type=checkbox id=chkIsUse"+rowIndex+" name=chkIsUse>";
				
				oCell = oRow.insertCell(-1);
				oCell.innerHTML = "<input type=checkbox class=\"chkIsReportCol"+rowIndex+"\" id=chkIsReportCol"+rowIndex+" name=chkIsReportCol>";
				
				oCell = oRow.insertCell(-1);
				oCell.innerHTML = "<input type=checkbox class=\"isCalWorkDayCol"+rowIndex+"\" id=isCalWorkDayCol"+rowIndex+" name=isCalWorkDayCol readOnly checked>";
												
				oCell = oRow.insertCell(-1);
				
				oCell.innerHTML = "<input type=checkbox class=\"ispaidleave"+rowIndex+"\" id=ispaidleave"+rowIndex+" name=ispaidleaveCol >";
				oCell = oRow.insertCell(-1);
				oCell.innerHTML = "<button style=\"border-right: medium none; border-top: medium none; background-image: url(/appres/hrm/image/attendance/img001.png); overflow: hidden; border-left: medium none; width: 16px; cursor: pointer; border-bottom: medium none; background-repeat: no-repeat; height: 16px; background-color: transparent\" type=\"button\" onclick = \"onShowColor('colorspan"+rowIndex+"','color"+rowIndex+"')\"></button>&nbsp;<span id=\"colorspan"+rowIndex+"\" style=\"width:16px;height:8px;display:inline-block;background:#FF0000\"></span><input type=\"hidden\" id=\"color"+rowIndex+"\" name=\"color\" class=\"inputstyle\" value=\"#FF0000\"><input type=\"hidden\" name=\"itemid\" value=\"-1\"><input type=\"hidden\" name=\"field004\" value=\"0\"><input type=\"hidden\" name=\"field005\" value=\"otherLeaveType\"><input type=\"hidden\" name=\"field006\" value=\""+rowIndex+"\">";
				
				jQuery("body").jNice();
			}

			function registerDragEvent(){
				var fixHelper = function(e, ui) {
					ui.children().each(function() {  
						jQuery(this).width(jQuery(this).width());
						jQuery(this).height("30px");
					});  
					return ui;  
				}; 
				 jQuery(".ListStyle tbody").sortable({
					 helper: fixHelper,
					 axis:"y",
					 start:function(e, ui){
						ui.helper.addClass("moveMousePoint");
						ui.helper.addClass("e8_hover_tr")
						if(ui.item.hasClass("notMove")) e.stopPropagation();
						$(".hoverDiv").css("display","none");
						return ui;  
					 },  
					 stop:function(e, ui){
						jQuery(ui.item).hover(function(){
							jQuery(this).addClass("e8_hover_tr");
						},function(){
							jQuery(this).removeClass("e8_hover_tr");
						});
						jQuery(ui.item).removeClass("moveMousePoint");
						sortOrder();
						return ui;  
					 }  
				 });  
			}
			
			function sortOrder() {
				jQuery("#tabfield tbody tr").each(function(index){
					if(index==0)return;
					jQuery(this).find("input[name=field006]").val(index);
				})
			}

			function jsChkAll(obj){
				$("input[name='fieldChk']").each(function(){
					changeCheckboxStatus(this,obj.checked);
				}); 
			}
			function formPaidleaveCheckAll(checked){
			  $("#frmMain").find("input[name=ispaidleaveCol]").each(function(){
					changeCheckboxStatus(this,checked);
				}); 
			}

			function formUseCheckAll(checked) {
			  $("#frmMain").find("input[name=chkIsUse]").each(function(){
					changeCheckboxStatus(this,checked);
			  });
			  //formReportCheckAll(checked, !checked);
			}

			function formReportCheckAll(checked, readonly) {
			  $("#frmMain").find("input[name=chkIsReportCol]").each(function(){
					changeCheckboxStatus(this,checked);
					if(readonly == true) {
						$(this).attr("readOnly", "true");
						var cSpan = $(this).parent().find("span");
						if(cSpan.hasClass("jNiceCheckbox") || cSpan.hasClass("jNiceChecked")){
							cSpan.removeClass("jNiceCheckbox");
							cSpan.removeClass("jNiceChecked");
							cSpan.addClass("jNiceCheckbox_disabled");
						}
					} else if(readonly == false) {
						$(this).attr("readOnly", "false");
						var cSpan = $(this).parent().find("span");
						if(cSpan.hasClass("jNiceCheckbox_disabled") || cSpan.hasClass("jNiceChecked_disabled")){
							cSpan.removeClass("jNiceCheckbox_disabled");
							cSpan.removeClass("jNiceChecked_disabled");
							cSpan.addClass("jNiceCheckbox");
						}
					}
			  });
			}
			function formCalWorkDayCheckAll(checked) {
			  $("#frmMain").find("input[name=isCalWorkDayCol]").each(function(){
					changeCheckboxStatus(this,checked);
			  });
			  
			if(checked){
			$("span[id^=relateweekdayspan]").css("display","none");
				$("span[id^=relateweekdayspan]").find(".sbHolder").css("width","85px");
			}else{
			$("span[id^=relateweekdayspan]").css("display","");
				$("span[id^=relateweekdayspan]").find(".sbHolder").css("width","85px");
			}
			}
			

			function closeDialog() {
				if(dialog) dialog.close();
			}

			function showContent(id) {
				closeDialog();
				common.initDialog({width:500, height:300});
				dialog = common.showDialog("/hrm/attendance/hrmLeaveTypeColor/tab.jsp?topage=content&id="+id, "<%=SystemEnv.getHtmlLabelNames("34032,68", user.getLanguage())%>");
			}
			
			function doSave(obj){
				var results = document.getElementsByName("selectname");
				for(var i=0; i<results.length; i++){
					if(!results[i] || results[i].value.trim() == ""){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
						return;
					}
				}
				var field002 = "", field003 = "",isCalWorkDayField="",relateweekdayField="";
				$("#frmMain").find("input[name=chkIsUse]").each(function(){
				field002+=(field002.length == 0?"":",")+(this.checked?1:0);
				});
				
				$("#frmMain").find("input[name=chkIsReportCol]").each(function(){
				field003+=(field003.length == 0?"":",")+(this.checked?1:0);
				});
				
				$("#frmMain").find("input[name=isCalWorkDayCol]").each(function(){
				isCalWorkDayField+=(isCalWorkDayField.length == 0?"":",")+(this.checked?1:0);
				relateweekdayField+=(this.checked?"2,":($("#relateweekday"+$(this).attr("_index")).val()+","));
				});
				$GetEle("field002").value = field002;
				$GetEle("field003").value = field003;
				//alert("isCalWorkDayCol>>>"+isCalWorkDayCol);
				$GetEle("isCalWorkDayField").value = isCalWorkDayField;
				$GetEle("relateweekdayField").value = relateweekdayField;
				var ispaidleaveField="";
				$("#frmMain").find("input[name=ispaidleaveCol]").each(function(){
					ispaidleaveField+=(ispaidleaveField.length == 0?"":",")+(this.checked?1:0);
				});
				$GetEle("ispaidleaveField").value = ispaidleaveField;
				try{parent.disableTabBtn();}catch(e){}
				frmMain.submit();
			}
			
			function doDelete(){
				var v = document.getElementsByName("fieldChk");
				var ids = "";
				for(var i=0;i<v.length;i++){
					if(v[i].checked == true) {
						if(v[i].value!="") ids = ids + v[i].value + ",";
					}   
				}
				if(ids==""){
					ids = "-1";
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
					return;
				}else{
					ids = ids.substr(0,ids.length-1);
				}
				$("input[name=operation]").val('delete');
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
					frmMain.ids.value = ids;
					frmMain.submit();
				}); 
			}

			function chkAll(obj){
				$(document).find("input[name=fieldChk]").each(function(){
					changeCheckboxStatus(this,obj.checked);
				})
			}
			
			function ctrlImg(obj, span){
				$GetEle(span).style.display = obj.value.trim() == "" ? "" : "none";
			}
			
			function checkValue(obj, cbox){
				var cSpan = $("."+cbox).parent().find("span");
				if(obj.checked) {
					$("."+cbox).removeAttr("readOnly");
					if(cSpan.hasClass("jNiceCheckbox_disabled")){
						cSpan.removeClass("jNiceCheckbox_disabled");
						cSpan.addClass("jNiceCheckbox");
					}
					if(cSpan.hasClass("jNiceChecked_disabled")){
						cSpan.removeClass("jNiceChecked_disabled");
						cSpan.addClass("jNiceChecked");
					}
				} else {
					$("."+cbox).attr("readOnly", "true");
					if(cSpan.hasClass("jNiceCheckbox")){
						cSpan.removeClass("jNiceCheckbox");
						cSpan.addClass("jNiceCheckbox_disabled");
					}
					if(cSpan.hasClass("jNiceChecked")) {
						cSpan.removeClass("jNiceChecked");
						cSpan.addClass("jNiceChecked_disabled");
					}
				}
			}
			function checkRelateweekday(obj,index){
				if(obj.checked){
				$("#relateweekdayspan"+index).css("display","none");
				$("#relateweekdayspan"+index).find(".sbHolder").css("width","85px");
				}else{
				$("#relateweekdayspan"+index).css("display","");
				$("#relateweekdayspan"+index).find(".sbHolder").css("width","85px");
				}
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(HrmUserVarify.checkUserRight("LeaveTypeColor:All",user)) {
			RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addRow(),_self} " ; 
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDelete(),_self} " ; 
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ; 
			RCMenuHeight += RCMenuHeightStep ;
		}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(HrmUserVarify.checkUserRight("LeaveTypeColor:All", user)){ %>
						<input type="button" class="e8_btn_top" onclick="addRow();" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
						<input type="button" class="e8_btn_top" onclick="doDelete();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
						<input type="button" class="e8_btn_top" onclick="doSave(this);" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
					<%} %>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id="frmMain" action="LeaveTypeColorOperation.jsp" method="post">
			<input type="hidden" name="subcompanyid" value="<%=subcompanyid%>">
			<input type="hidden" name="ids" value="ids">
			<input type="hidden" name="operation" value="edit">
			<input type="hidden" name="field002" value="">
			<input type="hidden" name="field003" value="">
			<input type="hidden" name="isCalWorkDayField" value="">
			<input type="hidden" name="relateweekdayField" value="">
			<input type="hidden" name="ispaidleaveField" value="">
			<TABLE CLASS="ListStyle" valign="top" cellspacing=1 style="position:fixed;z-index:99!important;">
				<colgroup>
					<col width="3%">
					<col width="4%">
					<col width="15%">
					<col width="15%">
					<col width="15%">
					<col width="20%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<TR class="header">
					<td><input name="chkAll" type="checkbox" onclick="jsChkAll(this)"></td>                                
					<td>&nbsp;</td>
					<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
					<td><input type="checkbox" name="checkalluse" onClick="formUseCheckAll(checkalluse.checked)" value="ON">
						<%=SystemEnv.getHtmlLabelName(31676,user.getLanguage())%>
					</td>
					<td><input type="checkbox" name="checkallreport" onClick="formReportCheckAll(checkallreport.checked)" value="ON">
						<%=SystemEnv.getHtmlLabelName(82831,user.getLanguage())%>
					</td>
					<td><input type="checkbox" name="isCalWorkDay" onClick="formCalWorkDayCheckAll(isCalWorkDay.checked)" value="ON">
						<%=SystemEnv.getHtmlLabelName(128750,user.getLanguage())%>
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(128751,user.getLanguage())%>" />
					</td>
					<td><input type="checkbox" name="ispaidleave" onClick="formPaidleaveCheckAll(ispaidleave.checked)" value="ON">
					<%=SystemEnv.getHtmlLabelName(131582,user.getLanguage())%>
	<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(131583,user.getLanguage())%>" />
				</td>
					<td><%=SystemEnv.getHtmlLabelName(16071,user.getLanguage())%></td>
				</tr>
			</TABLE>
			<TABLE id="tabfield" CLASS="ListStyle" valign="top" cellspacing=1 style="table-layout: fixed;z-index:1!important;">
			  <colgroup>
					<col width="3%">
					<col width="4%">
					<col width="15%">
					<col width="15%">
					<col width="15%">
					<col width="20%">
					<col width="10%">
					<col width="10%">
			  </colgroup>
			  <tr><td colspan="7"></td></tr>
			<%
				List list = colorManager.find(colorManager.getMapParam("subcompanyid:"+subcompanyid));
				HrmLeaveTypeColor bean = null;
				int lSize = list == null ? 0 : list.size();
				if(lSize > 0) bean = (HrmLeaveTypeColor)list.get(lSize-1);
				int max = Math.max(bean == null ? 0 : bean.getField006(), 9999);
				List scheduleList = otherManager.getScheduleList(user, null, null, strUtil.parseToInt(subcompanyid, 0), 0, "", 0, max);
				Map scheduleMap=null;
				Map typeMap = new HashMap();
				String newLeaveType = "";
				for(int i=0 ; i<scheduleList.size() ; i++ ) {
					typeMap = (Map)scheduleList.get(i);
					break;
				}
				for(int index=0; index<lSize; index++){
					bean = (HrmLeaveTypeColor)list.get(index);
					String selectname = bean.getField001();
					String color = bean.getColor();
					if(!color.startsWith("#")) color = "#"+color;
					int isUse = bean.getField002();
					int isReportCol = bean.getField003();
					String field004 = strUtil.vString(bean.getField004());
					int isCalWorkDay = bean.getIsCalWorkDay();//默认值是1表示过滤非工作时间
					int relateweekday = bean.getRelateweekday();//默认值是2 周一
					int ispaidleave = bean.getIspaidleave();//默认值不是带薪假
					if(field004.equals("-12") ){
						ispaidleave = 1;
					}
			%>
			<tr class="DataLight">
				<td>
					<input type="<%=(field004.equals("-6") || field004.equals("-12") || field004.equals("-13") || (""+ispaidleave).equals("1")) ? "hidden" : (strUtil.isNull((String)typeMap.get(String.valueOf(bean.getField004()))) ? "checkbox" : "hidden")%>" id="fieldChk" name="fieldChk" value="<%=bean.getId()%>">
				</td>
				<td><img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' /></td>
				<td>
					<div class="Mcontainer">
						<input type="input" class="InputStyle" style="width:120px" name="selectname" value="<%=selectname%>" onblur="ctrlImg(this,'imgSpan<%=index%>');">
						<div class="Msearch" onclick="showContent('<%=bean.getId()%>');" style="display: none;"></div>
					</div>
					<span id="imgSpan<%=index%>" class="imgSpan<%=index%>" style="display:<%=selectname.length()==0 ? "" : "none"%>"><IMG src="/images/BacoError_wev8.gif" align="absMiddle"></span>
				</td>
				<td>
					<input type="checkbox" id="chkIsUse<%=index%>" name="chkIsUse" <%=isUse == 1?"checked":""%> >
				</td>
				<td>
					<input type="checkbox" class="chkIsReportCol<%=index%>" id="chkIsReportCol<%=index%>" name="chkIsReportCol" <%=isReportCol == 1?"checked":""%> >
				</td>
				<td>
					<input type="checkbox" class="isCalWorkDayCol<%=index%>" id="isCalWorkDayCol<%=index%>" name="isCalWorkDayCol" <%=isCalWorkDay == 1?"checked":""%> onclick="checkRelateweekday(this,<%=index%>)" _index="<%=index%>">
				      <span id="relateweekdayspan<%=index%>" style="display: <%=isCalWorkDay == 1?"none":""%>">
				      <select class=inputstyle name="relateweekday" id="relateweekday<%=index%>">
						  <option value="2" <%=relateweekday == 2?"selected":""%> ><%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%></option>
				          <option value="3" <%=relateweekday == 3?"selected":""%> ><%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%></option>
				          <option value="4" <%=relateweekday == 4?"selected":""%> ><%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%></option>
						  <option value="5" <%=relateweekday == 5?"selected":""%> ><%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%></option>
				          <option value="6" <%=relateweekday == 6?"selected":""%> ><%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%></option>
				          <option value="7" <%=relateweekday == 7?"selected":""%> ><%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%></option>
				          <option value="1" <%=relateweekday == 1?"selected":""%> ><%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%></option>
						</select>
				       </span>
				</td>
				<td>
				<input type="checkbox" class="ispaidleaveCol<%=index%>" id="ispaidleaveCol<%=index%>" name="ispaidleaveCol" <%=((bean.getField004() == -12)||(bean.getField004() == -6)||(bean.getField004() == -13))?"readOnly":""%> <%=ispaidleave == 1?"checked":""%>  _index="<%=index%>">
				</td>
				<td>
					<button style="border-right: medium none; border-top: medium none; background-image: url(/appres/hrm/image/attendance/img001.png); overflow: hidden; border-left: medium none; width: 16px; cursor: pointer; border-bottom: medium none; background-repeat: no-repeat; height: 16px; background-color: transparent" type="button" onclick="onShowColor('colorspan<%=index%>','color<%=index%>')"></button>
					<span id="colorspan<%=index%>" name="colorspan" style="width:16px;height:8px;display:inline-block;background:<%=color%>"></span>
					<input type="hidden" id="color<%=index%>" name="color" value="<%=color%>">
					<input type="hidden" name="field004" value="<%=bean.getField004()%>">
					<input type="hidden" name="field005" value="<%=bean.getField005()%>">
					<input type="hidden" name="itemid" value="<%=bean.getItemid()%>">
					<input type="hidden" name="field006" value="<%=bean.getField006()%>">
				</td>
			</tr>
			<%}%>
			</table>
		</form>
		<div id="dialogDiv">
			<input type='text' id="full"/>
		</div>
		<script type="text/javascript">
			$("#dialogDiv").dialog({  
				autoOpen: false,
				modal: true,
				width:  460, 
				height: 300,
				draggable: false,
				resizable: false
			});
			
			function closeDiv(){
				$("#dialogDiv").dialog("close");
			}
			
			function setColor(tdname, inputename, color){
				$("#"+tdname).css({"background":color});
				$("input[id="+inputename+"]").val(color);
			}

			function onShowColor(tdname,inputename){
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
						setColor(tdname, inputename, "#FF0000");
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
						["rgb(0, 0, 0)", "rgb(67, 67, 67)", "rgb(102, 102, 102)",
						"rgb(204, 204, 204)", "rgb(217, 217, 217)","rgb(255, 255, 255)"],
						["rgb(152, 0, 0)", "rgb(255, 0, 0)", "rgb(255, 153, 0)", "rgb(255, 255, 0)", "rgb(0, 255, 0)",
						"rgb(0, 255, 255)", "rgb(74, 134, 232)", "rgb(0, 0, 255)", "rgb(153, 0, 255)", "rgb(255, 0, 255)"], 
						["rgb(230, 184, 175)", "rgb(244, 204, 204)", "rgb(252, 229, 205)", "rgb(255, 242, 204)", "rgb(217, 234, 211)", 
						"rgb(208, 224, 227)", "rgb(201, 218, 248)", "rgb(207, 226, 243)", "rgb(217, 210, 233)", "rgb(234, 209, 220)", 
						"rgb(221, 126, 107)", "rgb(234, 153, 153)", "rgb(249, 203, 156)", "rgb(255, 229, 153)", "rgb(182, 215, 168)", 
						"rgb(162, 196, 201)", "rgb(164, 194, 244)", "rgb(159, 197, 232)", "rgb(180, 167, 214)", "rgb(213, 166, 189)", 
						"rgb(204, 65, 37)", "rgb(224, 102, 102)", "rgb(246, 178, 107)", "rgb(255, 217, 102)", "rgb(147, 196, 125)", 
						"rgb(118, 165, 175)", "rgb(109, 158, 235)", "rgb(111, 168, 220)", "rgb(142, 124, 195)", "rgb(194, 123, 160)",
						"rgb(166, 28, 0)", "rgb(204, 0, 0)", "rgb(230, 145, 56)", "rgb(241, 194, 50)", "rgb(106, 168, 79)",
						"rgb(69, 129, 142)", "rgb(60, 120, 216)", "rgb(61, 133, 198)", "rgb(103, 78, 167)", "rgb(166, 77, 121)",
						"rgb(91, 15, 0)", "rgb(102, 0, 0)", "rgb(120, 63, 4)", "rgb(127, 96, 0)", "rgb(39, 78, 19)", 
						"rgb(12, 52, 61)", "rgb(28, 69, 135)", "rgb(7, 55, 99)", "rgb(32, 18, 77)", "rgb(76, 17, 48)"]
					]
				});
				$("#dialogDiv").dialog('open');
				$(".ui-dialog").removeClass("ui-widget ui-widget-content ui-corner-all ui-front");
				$(".ui-dialog-titlebar").css("display","none");
			}
		</script>
	</BODY>
</HTML>
