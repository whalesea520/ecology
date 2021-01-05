<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="weaver.hrm.company.*"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
// || HrmUserVarify.checkUserRight("FnaBudgetfeeTypeEdit:Edit",user)
boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
if(!canEdit) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean subjectFilter = 1==Util.getIntValue(fnaSystemSetComInfo.get_subjectFilter(), 0);


DecimalFormat df3 = new DecimalFormat("####################################################0.000");

BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();

int subjectId = Util.getIntValue(request.getParameter("id"),0);
if(subjectId <= 0) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String sql="";

String name = "";
String codeName = "";
String codeName2 = "";
String description = "";
int feeperiod = 0;
int feetype = 0;
String agreegap = "";
int feelevel = 0;
int supsubject = 0;
String alertvalue = "";
int archive = 0;
boolean isEditFeeType = false;
boolean groupCtrl = false;
int budgetAutoMove = 0;
String displayOrder="";
boolean budgetCanBeNegative = false;
sql = "select * from FnaBudgetfeeType a where a.id = "+subjectId;
rs.executeSql(sql);
if(rs.next()){
	name = Util.null2String(rs.getString("name")).trim();
	codeName = Util.null2String(rs.getString("codeName")).trim();
	codeName2 = Util.null2String(rs.getString("codeName2")).trim();
	description = Util.null2String(rs.getString("description")).trim();
	feeperiod = Util.getIntValue(rs.getString("feeperiod"), 0);
	feetype = Util.getIntValue(rs.getString("feetype"), 0);
	agreegap = Util.null2String(rs.getString("agreegap")).trim();
	feelevel = Util.getIntValue(rs.getString("feelevel"), 3);
	supsubject = Util.getIntValue(rs.getString("supsubject"), 0);
	alertvalue = Util.null2String(rs.getString("alertvalue")).trim();
	archive = Util.getIntValue(rs.getString("archive"), 0);
	isEditFeeType = "1".equals(Util.null2String(rs.getString("isEditFeeType")).trim());
	groupCtrl = "1".equals(Util.null2String(rs.getString("groupCtrl")).trim());
    budgetAutoMove = Util.getIntValue(rs.getString("budgetAutoMove"), 0);
    displayOrder = df3.format(Util.getDoubleValue(rs.getString("displayOrder"), 0.0));
    budgetCanBeNegative = "1".equals(Util.null2String(rs.getString("budgetCanBeNegative")).trim());
}

StringBuffer gCtrlException = new StringBuffer();
StringBuffer gCtrlExceptionName = new StringBuffer();
int _idx01 = 0;
sql = "select * from FnabudgetfeetypeCGE a where a.mainSubjectId = "+subjectId;
rs.executeSql(sql);
while(rs.next()){
	int _subjectId = Util.getIntValue(rs.getString("subjectId"), 0);
	if(_idx01>0){
		gCtrlException.append(",");
		gCtrlExceptionName.append(",");
	}
	gCtrlException.append(_subjectId);
	gCtrlExceptionName.append(budgetfeeTypeComInfo.getBudgetfeeTypename(_subjectId+""));
	_idx01++;
}

String feelevelName = new FnaSplitPageTransmethod().getSubjectLevel(feelevel+"", user.getLanguage()+"");


StringBuffer allowZbBooleanStr = new StringBuffer();
StringBuffer depids = new StringBuffer();
StringBuffer depnames = new StringBuffer();
StringBuffer fbids = new StringBuffer();
StringBuffer fbnames = new StringBuffer();
StringBuffer fccids = new StringBuffer();
StringBuffer fccnames = new StringBuffer();

if(subjectFilter){
	BudgetfeeTypeComInfo.loadFnabudgetfeetypeRuleSet(subjectId, allowZbBooleanStr, depids, depnames, fbids, fbnames, fccids, fccnames);
}
boolean allowZb = ("true".equalsIgnoreCase(allowZbBooleanStr.toString()));

%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%><HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script language="javascript" src="/fna/js/guid_js_wev8.js?r=1"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1011,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doEdit(),_TOP} ";//保存
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
if(feelevel > 0){
%>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(1462,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
	    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doEdit();" 
	    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
<%
if(feelevel==3){
%>
	<input id="groupCtrlDb" name="groupCtrlDb" value="<%=(groupCtrl?"1":"") %>" type="hidden"  />
<%
}
%>
		
<input type="hidden" id="subjectId" name="subjectId" value="<%=subjectId %>" />
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'><!-- 基本信息 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(15409,user.getLanguage())%></wea:item><!-- 科目名称 -->
			<wea:item>
				<wea:required id="nameSpan" required="true">
        			<input class="inputstyle" id="name" name="name" style="width: 150px;" 
        				onchange='checkinput("name","nameSpan");' value="<%=FnaCommon.escapeHtml(name) %>" />
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(21108,user.getLanguage())%></wea:item><!-- 科目编码 -->
			<wea:item>
       			<input class="inputstyle" id="codeName" name="codeName" maxlength="30" style="width: 150px;" 
       				value="<%=FnaCommon.escapeHtml(codeName) %>"  _noMultiLang="true" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(132177,user.getLanguage())%></wea:item><!-- 会计科目编码 -->
			<wea:item>
       			<input class="inputstyle" id="codeName2" name="codeName2" maxlength="30" style="width: 150px;" 
       				value="<%=FnaCommon.escapeHtml(codeName2) %>"  _noMultiLang="true" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item><!-- 状态 -->
			<wea:item>
	            <select class="inputstyle" id="archive" name="archive" style="width: 80px;">
	              <option value="0" <% if(archive == 0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(25456,user.getLanguage())%></option>
	              <option value="1" <% if(archive == 1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22205,user.getLanguage())%></option>
	            </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18427,user.getLanguage())%></wea:item><!-- 科目级别 -->
			<wea:item>
			 	<%=feelevelName %>
			 	<input id="feelevel" name="feelevel" value="<%=feelevel %>" type="hidden"  _noMultiLang="true" />
			</wea:item>
<%
if(feelevel > 1){
%>
			<wea:item><%=SystemEnv.getHtmlLabelName(18428,user.getLanguage())%></wea:item><!-- 上级科目 -->
			<wea:item>
			 	<%=FnaCommon.escapeHtml(budgetfeeTypeComInfo.getBudgetfeeTypename(supsubject+"")) %>
			 	<input id="supsubject" name="supsubject" value="<%=supsubject %>" type="hidden"  _noMultiLang="true" />
			</wea:item>
<%
}
%>
			<wea:item><%=SystemEnv.getHtmlLabelName(15388,user.getLanguage())%></wea:item><!-- 预算周期 -->
			<wea:item>
<% 
	boolean canEditFeeperiod = !BudgetfeeTypeComInfo.checkSubjectIsUsed(subjectId) && (feelevel == 1);
	if(canEditFeeperiod){
%>
	            <select class="inputstyle" id="feeperiod" name="feeperiod" style="width: 80px;">
	              <option value="1" <% if(feeperiod==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%></option>
	              <option value="2" <% if(feeperiod==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%></option>
	              <option value="3" <% if(feeperiod==3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%></option>
	              <option value="4" <% if(feeperiod==4) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%></option>
	            </select>
<%
	}else{
		if(feeperiod==1){
			%><%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%><%
		}else if(feeperiod==2){
			%><%=SystemEnv.getHtmlLabelName(543,user.getLanguage())%><%
		}else if(feeperiod==3){
			%><%=SystemEnv.getHtmlLabelName(538,user.getLanguage())%><%
		}else if(feeperiod==4){
			%><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%><%
		}
%>
			 	<input id="feeperiod" name="feeperiod" value="<%=feeperiod %>" type="hidden"  _noMultiLang="true" />
<%
	}
%>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item><!-- 显示顺序 -->
			<wea:item>
				<input class="inputstyle" id="displayOrder" name="displayOrder" maxlength="30" style="width: 150px;" value="<%=displayOrder %>"
					onblur="displayOrder_Check();" _noMultiLang="true" />
			</wea:item>
			<wea:item attributes="{'samePair':'budgetAutoMove1'}"><%=SystemEnv.getHtmlLabelName(30786,user.getLanguage())%></wea:item><!-- 是否结转 -->
			<wea:item attributes="{'samePair':'budgetAutoMove1'}">
	            <select class=inputstyle id="budgetAutoMove" name="budgetAutoMove" style="width: 40px;">
	              <option value="1" <% if(budgetAutoMove==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	              <option value="0" <% if(budgetAutoMove==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
	            </select>
			</wea:item>
			
			<wea:item attributes="{'samePair':'budgetCanBeNegative1'}"><%=SystemEnv.getHtmlLabelName(130715,user.getLanguage())%></wea:item><!-- 预算可为负数 -->
			<wea:item attributes="{'samePair':'budgetCanBeNegative1'}">
	            <input id=budgetCanBeNegative name="budgetCanBeNegative" value="1" type="checkbox" tzCheckbox="true" <%=(budgetCanBeNegative?"checked":"") %> />
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(128826,user.getLanguage())%></wea:item><!-- 可编制预算 -->
			<wea:item>
				<input id="isEditFeeType" name="isEditFeeType" value="1" type="checkbox" tzCheckbox="true" <%=(isEditFeeType?"checked":"") %> />
			</wea:item>
			<wea:item attributes="{'samePair':'isEditFeeType1'}"><%=SystemEnv.getHtmlLabelName(32099,user.getLanguage())%></wea:item><!-- 下级统一费控 -->
			<wea:item attributes="{'samePair':'isEditFeeType1'}">
				<span style="float: left"><input id="groupCtrl" name="groupCtrl" value="1" type="checkbox" tzCheckbox="true" <%=(groupCtrl?"checked":"") %> /></span>
				<span style="float: left;margin-left: 10px;"><%=SystemEnv.getHtmlLabelName(128835,user.getLanguage())%>：</span>
				<%
				String _browserUrl = "/systeminfo/BrowserMain.jsp?url=/fna/browser/FnaBudgetfeeTypeBrowserMultiTree/FnaBudgetfeeTypeBrowserMultiTree.jsp%3Fsupsubject="+subjectId+"%26selectids=#id#";
				%>
				<span style="float: left;width: 350px;">
			        <brow:browser viewType="0" name="gCtrlException" browserValue='<%=gCtrlException.toString() %>' 
			                browserUrl="<%=_browserUrl %>"
			                hasInput="false" isSingle="false" hasBrowser = "true" isMustInput="1"
			                completeUrl="" 
			                browserSpanValue='<%=gCtrlExceptionName.toString() %>' width="80%" >
			        </brow:browser>
			    </span>
			</wea:item>
			<wea:item attributes="{'samePair':'groupCtrl1'}"><%=SystemEnv.getHtmlLabelName(18429,user.getLanguage())%></wea:item><!-- 科目预警值 -->
			<wea:item attributes="{'samePair':'groupCtrl1'}">
				<input class=inputstyle type=text id="alertvalue" name="alertvalue" maxlength=3 
					style="width:30px;text-align: right;" value="<%=alertvalue%>" _noMultiLang="true" />%
			</wea:item>
			<wea:item attributes="{'samePair':'groupCtrl1'}"><%=SystemEnv.getHtmlLabelName(15389,user.getLanguage())%></wea:item><!-- 允许偏差 -->
			<wea:item attributes="{'samePair':'groupCtrl1'}">
				<input class=inputstyle type=text id=agreegap name=agreegap maxlength=3 
					style="width:30px;text-align: right;" value="<%=agreegap%>" _noMultiLang="true" />%
			</wea:item>
			
			<wea:item attributes="{'samePair':'feetype1'}"><%=SystemEnv.getHtmlLabelName(15385,user.getLanguage())%></wea:item><!-- 收支类型 -->
			<wea:item attributes="{'samePair':'feetype1'}">
	            <select class="inputstyle" id="feetype" name="feetype" style="width:80px;">
	              <option value="1" <% if(feetype==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(629,user.getLanguage())%></option><!-- 支出 -->
	              <option value="2" <% if(feetype==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(566,user.getLanguage())%></option><!-- 收入 -->
	            </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item><!-- 描述 -->
			<wea:item>
				<textarea class=inputstyle id="description" name="description" cols="60" rows=4><%=FnaCommon.escapeHtml(description) %></textarea>
        	</wea:item>
		</wea:group>
<%
	if(subjectFilter){
%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(19374,user.getLanguage())%>'><!-- 应用范围 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></wea:item><!-- 总部 -->
			<wea:item>
	   			<input id="allowZb" name="allowZb" value="1" type="checkbox" tzCheckbox="true" <%=(allowZb?"checked":"") %> />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item><!-- 分部 -->
			<wea:item>
		        <brow:browser viewType="0" name="field6341" browserValue='<%=fbids.toString() %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("194")+"%3Fshow_virtual_org=-1%26selectedids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
		                browserSpanValue='<%=fbnames.toString() %>' width="80%" >
		        </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item><!-- 部门 -->
			<wea:item>
		        <brow:browser viewType="0" name="field6855" browserValue='<%=depids.toString() %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("57")+"%3Fshow_virtual_org=-1%26resourceids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
		                browserSpanValue='<%=depnames.toString() %>' width="80%" >
		        </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></wea:item><!-- 成本中心 -->
			<wea:item>
		        <brow:browser viewType="0" name="fccids" browserValue='<%=fccids.toString() %>' 
		                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/FccBrowserMulti.jsp%3Fselectids=#id#"
		                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
		                completeUrl="/data.jsp?type=FnaCostCenter"  temptitle='<%= SystemEnv.getHtmlLabelName(515,user.getLanguage())%>'
		                browserSpanValue='<%=fccnames.toString() %>' width="80%" >
		        </brow:browser>
			</wea:item>
		</wea:group>
<%
	}
%>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
	    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
	    	</wea:item>
	    </wea:group>
</wea:layout>
</div>
<%
}
%>
<input id="_guid1" name="_guid1" value="" type="hidden" />
<Script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...
var _guid1 = $System.Math.IntUtil.genGUIDV4();

var _fna_global_feelevel = "";
var _fna_global_supsubject = "";

function getErrorInfoAjax(resultJson){
	var __fna_global_feelevel = _fna_global_feelevel;
	var __fna_global_supsubject = _fna_global_supsubject;
	_fna_global_feelevel = "";
	_fna_global_supsubject = "";
	_guid1 = $System.Math.IntUtil.genGUIDV4();
	if(resultJson.flag){
		var parentWin = parent.getParentWindow(window);
		var dialog = parent.getDialog(parentWin);
		if(__fna_global_supsubject==""||__fna_global_supsubject=="0"){
			parentWin.parent.parent.leftframe.do_reAsyncChildNodes(null);
		}else{
			parentWin.parent.parent.leftframe.do_reAsyncChildNodes((fnaRound(__fna_global_feelevel,0)-1)+"_"+__fna_global_supsubject);
		}
		parentWin._table.reLoad();
		parentWin.closeDialog();
	}else{
		alert(resultJson.msg._fnaReplaceAll("<br>","\r")._fnaReplaceAll("<br />","\r"));
	}
}

//读取数据更新进度标志符
var _loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
//读取数据更新进度函数
function loadFnaBudgetEditSaveFnaLoadingAjax(_guid1){
	jQuery.ajax({
		url : "/fna/FnaLoadingAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : "guid="+_guid1,
		dataType : "json",
		success: function do4Success(_jsonObj){
		    try{
	    		if(_jsonObj.flag){
			    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					getErrorInfoAjax(_jsonObj.resultJson);
	    		}else{
		    		if(top!=null&&top.document!=null&&top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv")!=null){
			    		top.document.getElementById("mask_FnaBudgetViewInner1_infoDiv").innerHTML=null2String(_jsonObj.infoStr);
			    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
			    			setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
			    		}
		    		}else{
			    		if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
			    			setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
			    		}
		    		}
	    		}
		    }catch(e1){
		    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				alert(e1.message);
		    }
		}
	});	
}

jQuery(document).ready(function(){
	jQuery("#_guid1").val(_guid1);
	resizeDialog(document);
	checkinput("name","nameSpan");
	controlNumberCheck_jQuery("displayOrder",true,3,true,3);
	controlNumberCheck_jQuery("alertvalue", false, 0, true, 3);
	controlNumberCheck_jQuery("agreegap", false, 0, true, 3);
	
    jQuery("#isEditFeeType").bind("click",function(){
    	isEditFeeTypeOnChange();
	});
    isEditFeeTypeOnChange();
	
    jQuery("#groupCtrl").bind("click",function(){
    	groupCtrlOnChange();
	});
    groupCtrlOnChange();
    jQuery("#budgetCanBeNegative").bind("click",function(){
    	budgetCanBeNegativeOnChange();
	});
});

function isEditFeeTypeOnChange(){
	var _obj1 = jQuery("#isEditFeeType");
	if(_obj1.length==1){
		var _checked = _obj1.attr("checked")?"1":"0";
		if(_checked=="1"){
			showEle("feetype1");
		}else{
			hideEle("feetype1");
		}
	}else{
		hideEle("feetype1");
	}
}

function groupCtrlOnChange(){
	var _obj1 = jQuery("#groupCtrl");
	if(_obj1.length==1){
		var _checked = _obj1.attr("checked")?"1":"0";
		if(_checked=="1"){
			showEle("groupCtrl1");
		}else{
			hideEle("groupCtrl1");
		}
	}else{
		hideEle("groupCtrl1");
	}
	showOrHideBudgetAutoMove1();
}

function showOrHideBudgetAutoMove1(){
	var _obj1 = jQuery("#groupCtrl");
	var budgetCanBeNegative = jQuery("#budgetCanBeNegative").is(':checked');
	if(_obj1.length==1){
		var _checked1 = _obj1.attr("checked")?"1":"0";
		if(_checked1=="1"){
			if(!budgetCanBeNegative){
				showEle("budgetAutoMove1");
			}else{
				hideEle("budgetAutoMove1");
			}
			showEle("budgetCanBeNegative1");
		}else{
			hideEle("budgetAutoMove1");
			hideEle("budgetCanBeNegative1");
		}
	}else{
		hideEle("groupCtrl1");
	}
}

function budgetCanBeNegativeOnChange(){
	var budgetCanBeNegative = jQuery("#budgetCanBeNegative").is(':checked');
	if(!budgetCanBeNegative){
		showEle("budgetAutoMove1");
	}else{
		hideEle("budgetAutoMove1");
	}
}

function onBtnSearchClick(){}

//关闭
function doClose(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

//关闭
function doClose2(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

//保存
function doEdit2(obj){
	try{
		_guid1 = $System.Math.IntUtil.genGUIDV4();
		jQuery("#_guid1").val(_guid1);
		
		var id = null2String(jQuery("#subjectId").val());
		var name = null2String(jQuery("#name").val());
		var codeName = null2String(jQuery("#codeName").val());
		var codeName2 = null2String(jQuery("#codeName2").val());
		var description = null2String(jQuery("#description").val());
		var feeperiod = null2String(jQuery("#feeperiod").val());
		var feetype = null2String(jQuery("#feetype").val());
		var agreegap = null2String(jQuery("#agreegap").val());
		var feelevel = null2String(jQuery("#feelevel").val());
		var supsubject = null2String(jQuery("#supsubject").val());
		var alertvalue = null2String(jQuery("#alertvalue").val());
		var archive = null2String(jQuery("#archive").val());
		var feeCtlLevel = null2String(jQuery("#feeCtlLevel").val());
		var groupCtrl = jQuery("#groupCtrl").attr("checked")?"1":"";
		var gCtrlException = null2String(jQuery("#gCtrlException").val());
		var isEditFeeType = jQuery("#isEditFeeType").attr("checked")?"1":"";
		var budgetAutoMove = null2String(jQuery("#budgetAutoMove").val());
		var feetypeRuleSetZb = jQuery("#allowZb").attr("checked")?"1":"0";
		var feetypeRuleSetFb = null2String(jQuery("#field6341").val());
		var feetypeRuleSetBm = null2String(jQuery("#field6855").val());
		var feetypeRuleSetCbzx = null2String(jQuery("#fccids").val());
		var displayOrder = null2String(jQuery("#displayOrder").val());
		var budgetCanBeNegative = jQuery("#budgetCanBeNegative").attr("checked")?"1":"";
		
		var multiname=null2String(jQuery("#__multilangpre_"+jQuery("#name").attr("name")+jQuery("#name").attr("rnd_lang_tag")).val());
	
		var _data = "operation=edit&_guid1="+_guid1+"&id="+id+
			"&name="+fnaUrlEncoded(name)+"&__multilangpre_name="+multiname+"&codeName="+fnaUrlEncoded(codeName)+"&codeName2="+fnaUrlEncoded(codeName2)+"&description="+fnaUrlEncoded(description)+
			"&feeperiod="+feeperiod+"&feetype="+feetype+
			"&agreegap="+agreegap+"&feelevel="+feelevel+
			"&supsubject="+supsubject+"&alertvalue="+alertvalue+
			"&archive="+archive+"&feeCtlLevel="+feeCtlLevel+
			"&groupCtrl="+groupCtrl+"&gCtrlException="+gCtrlException+"&isEditFeeType="+isEditFeeType+
			"&budgetAutoMove="+budgetAutoMove+
			"&feetypeRuleSetZb="+feetypeRuleSetZb+"&feetypeRuleSetFb="+feetypeRuleSetFb+
			"&feetypeRuleSetBm="+feetypeRuleSetBm+"&feetypeRuleSetCbzx="+feetypeRuleSetCbzx+"&displayOrder="+displayOrder+
			"&budgetCanBeNegative="+budgetCanBeNegative;

		_fna_global_feelevel = feelevel;
		_fna_global_supsubject = supsubject;
		
		openNewDiv_FnaBudgetViewInner1(_Label33574);
		_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
		loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);

		jQuery.ajax({
			url : "/fna/maintenance/FnaBudgetfeeTypeOperation.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){}
		});	

	}catch(e1){
		showRightMenuIframe();
	}
}

//封存检查，并保存
function doEdit(obj){
	hideRightMenuIframe();
	try{
		if(jQuery("#name").val()==""){
			alert("<%=SystemEnv.getHtmlLabelName(15409,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>");
			return;
		}
		var id = null2String(jQuery("#subjectId").val());
		var archive = null2String(jQuery("#archive").val());
		var _data = "checkid="+id;
		if(archive=="1"){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/maintenance/FnaBudgetfeeTypeViewAjax.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "html",
				success: function do4Success(_html){
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
			    	_html = jQuery.trim(_html);
					if(_html=="1"){
						top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(81278,user.getLanguage())%>",
							function(){
								doEdit2(obj);
							},
							function(){
							  	showRightMenuIframe();
							},
							360
						);
					}else{
						doEdit2(obj);
					}
				}
			});	
		}else{
			doEdit2(obj);
		}
	}catch(e1){
		showRightMenuIframe();
	}
}

function displayOrder_Check(){
	var displayOrder = $GetEle("displayOrder").value.trim();
	if(displayOrder==""){
		$GetEle("displayOrder").value=<%=displayOrder%>;
	}
}
</script>
</BODY>
</HTML>
