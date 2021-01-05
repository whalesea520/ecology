<%@page import="weaver.fna.budget.BudgetAutoMove"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.general.BrowserElement"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

<%
//new LabelComInfo().removeLabelCache();
if (!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit", user) && !HrmUserVarify.checkUserRight("BudgetManualTransfer:do", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}


//是否结转设置
boolean ifbudgetmove = false;
boolean mBudgetMove = false;
boolean qBudgetMove = false;
boolean hBudgetMove = false;
int budgetAutoMovePending = 0;//结转时是否结转审批中预算

rs.executeSql("select * from FnaSystemSet");
if(rs.next()){
	ifbudgetmove = 1==rs.getInt("ifbudgetmove");
	String movetypes = rs.getString("movetypes");
	if((","+movetypes+",").indexOf(",1,") >= 0){
		mBudgetMove = true;
	}
	if((","+movetypes+",").indexOf(",2,") >= 0){
		qBudgetMove = true;
	}
	if((","+movetypes+",").indexOf(",3,") >= 0){
		hBudgetMove = true;
	}
	budgetAutoMovePending = Util.getIntValue(rs.getString("budgetAutoMovePending"), 0);
}
if (!ifbudgetmove) {
	out.println(SystemEnv.getHtmlLabelName(126697,user.getLanguage()));//请先启用预算结转，并进行结转配置
	return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

int fnayear=Util.getIntValue(request.getParameter("fnayear"),0);
if(fnayear==0){
	rs.executeSql("select id, fnayear from FnaYearsPeriods where status = 1 order by status desc,fnayear desc");
	if(rs.next()){
		fnayear = Util.getIntValue(rs.getString("fnayear"));
	}
}

int currentMM = Util.getIntValue(TimeUtil.getCurrentDateString().split("-")[1]);
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<script language="javascript" src="/fna/js/guid_js_wev8.js?r=1"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(126641,user.getLanguage())+",javascript:doAutoMove(),_self}";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post" action="">
<input id="operation" name="operation" value="" type="hidden" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(126641,user.getLanguage()) %>" 
				class="e8_btn_top" onclick="doAutoMove();"/><!-- 结转 -->
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(81711,user.getLanguage()) %>' ><!-- 基本信息 -->
			<wea:item attributes="{'samePair':'itmeG1'}"><%=SystemEnv.getHtmlLabelName(126698,user.getLanguage()) %></wea:item><!-- 当前结转配置 -->
			<wea:item attributes="{'samePair':'itmeG1'}">
				<%if(mBudgetMove){ %>
					<%=SystemEnv.getHtmlLabelNames("18095,33080",user.getLanguage()) %>；
				<%} %>
				<%if(qBudgetMove){ %>
					<%=SystemEnv.getHtmlLabelNames("18095,33081",user.getLanguage()) %>；
				<%} %>
				<%if(hBudgetMove){ %>
					<%=SystemEnv.getHtmlLabelNames("18095,33082",user.getLanguage()) %>；
				<%} %>
				<%if(budgetAutoMovePending==1){ %>
					<%=SystemEnv.getHtmlLabelNames("126675",user.getLanguage()) %>；<!-- 结转审批中费用 -->
				<%}else{ %>
					<%=SystemEnv.getHtmlLabelNames("126676",user.getLanguage()) %>；<!-- 不结转审批中费用 -->
				<%}%>
			</wea:item>
			
			<wea:item attributes="{'samePair':'itmeG1'}"><%=SystemEnv.getHtmlLabelName(126643,user.getLanguage()) %></wea:item><!-- 结转年月 -->
			<wea:item attributes="{'samePair':'itmeG1'}">
				<select id="fnayear" name="fnayear" style="width: 60px;" onchange="periodsid_onchange();">
				<%
				rs.executeSql("select id, fnayear from FnaYearsPeriods where status = 1 order by fnayear desc");
				while(rs.next()){
					int _fnayear = Util.getIntValue(rs.getString("fnayear"));
				%>
					<option value="<%=_fnayear %>" <%=(_fnayear==fnayear)?"selected":"" %>><%=_fnayear %></option>
				<%
				}
				%>
				</select>
				<select id="periodsid" name="periodsid" style="width: 60px;" onchange="periodsid_onchange();">
				<%
				for(int i=1;i<12;i++){
				%>
					<option value="<%=i %>" <%=(i==currentMM-1)?"selected":"" %>><%=i %></option>
				<%
				}
				%>
				</select>
				<br />
				<span id="span1" style="color: red;"></span>
			</wea:item>
			
			<wea:item attributes="{'samePair':'itmeG1'}"><%=SystemEnv.getHtmlLabelName(126644,user.getLanguage()) %></wea:item><!-- 审批中费用的流程数 -->
			<wea:item attributes="{'samePair':'itmeG1'}">
				<span id="tip0"></span>
			</wea:item>
			
			<wea:item attributes="{'samePair':'itmeG2'}"><%=SystemEnv.getHtmlLabelName(126645,user.getLanguage()) %></wea:item><!-- 处理状态 -->
			<wea:item attributes="{'samePair':'itmeG2'}">
				<img src='/images/ecology8/onload_wev8.gif'/ style='padding-left:5px!important;padding-right:10px!important;'>
				<span id="tip1" style="color: red;"></span>
			</wea:item>
	    </wea:group>
	</wea:layout>
</form>
<script type="text/javascript">
var _guid1 = "";
jQuery(document).ready(function(){
	periodsid_onchange();

<%if(BudgetAutoMove.isExecuteFlag()){ %>
	hideEle("itmeG1");
	showEle("itmeG2");
	doAutoMove();
<%}else{ %>
	hideEle("itmeG2");
<%} %>
	resizeDialog(document);
});

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

function periodsid_onchange(){
	var fnayear = jQuery("#fnayear").val();
	var periodsid = jQuery("#periodsid").val();
	var span1 = "";

<%if(mBudgetMove){%>
	//结转月度：第N期
	if(periodsid==1){
		span1 += "<%=SystemEnv.getHtmlLabelName(126646,user.getLanguage()) %>；<br />";
	}else if(periodsid==2){
		span1 += "<%=SystemEnv.getHtmlLabelName(126647,user.getLanguage()) %>；<br />";
	}else if(periodsid==3){
		span1 += "<%=SystemEnv.getHtmlLabelName(126648,user.getLanguage()) %>；<br />";
	}else if(periodsid==4){
		span1 += "<%=SystemEnv.getHtmlLabelName(126649,user.getLanguage()) %>；<br />";
	}else if(periodsid==5){
		span1 += "<%=SystemEnv.getHtmlLabelName(126650,user.getLanguage()) %>；<br />";
	}else if(periodsid==6){
		span1 += "<%=SystemEnv.getHtmlLabelName(126651,user.getLanguage()) %>；<br />";
	}else if(periodsid==7){
		span1 += "<%=SystemEnv.getHtmlLabelName(126652,user.getLanguage()) %>；<br />";
	}else if(periodsid==8){
		span1 += "<%=SystemEnv.getHtmlLabelName(126653,user.getLanguage()) %>；<br />";
	}else if(periodsid==9){
		span1 += "<%=SystemEnv.getHtmlLabelName(126654,user.getLanguage()) %>；<br />";
	}else if(periodsid==10){
		span1 += "<%=SystemEnv.getHtmlLabelName(126655,user.getLanguage()) %>；<br />";
	}else if(periodsid==11){
		span1 += "<%=SystemEnv.getHtmlLabelName(126656,user.getLanguage()) %>；<br />";
	}
<%}%>

<%if(qBudgetMove){%>
	//结转第N季度
	if(periodsid>=3 && periodsid<=5){
		span1 += "<%=SystemEnv.getHtmlLabelName(126658,user.getLanguage()) %>；<br />";
	}else if(periodsid>=6 && periodsid<=8){
		span1 += "<%=SystemEnv.getHtmlLabelName(126659,user.getLanguage()) %>；<br />";
	}else if(periodsid>=9 && periodsid<=11){
		span1 += "<%=SystemEnv.getHtmlLabelName(126660,user.getLanguage()) %>；<br />";
	}
<%}%>

<%if(hBudgetMove){%>
	//结转上半年度
	if(periodsid>=6 && periodsid<=11){
		span1 += "<%=SystemEnv.getHtmlLabelName(126662,user.getLanguage()) %>；<br />";
	}
<%}%>
	
	jQuery("#span1").html(span1);
	jQuery("#tip0").text("");
	jQuery.ajax({
		url : "/fna/BudgetAutoMove/FnaJzAjax1.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : "_guid1="+_guid1+"&fnayear="+fnayear+"&periodsid="+periodsid+"&mBudgetMove=<%=mBudgetMove %>&qBudgetMove=<%=qBudgetMove %>&hBudgetMove=<%=hBudgetMove %>",
		dataType : "json",
		success: function do4Success(_jsonObj){
			var tip0 = _jsonObj.spzCntText;
			jQuery("#tip0").html(tip0);
		}
	});	
}

//读取数据更新进度标志符
var _loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
//读取数据更新进度函数
function loadFnaBudgetEditSaveFnaLoadingAjax(_guid1){
	jQuery.ajax({
		url : "/fna/FnaJzProgressAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : "_guid1="+_guid1,
		dataType : "html",
		success: function do4Success(_html){
		    try{
	    		if(_html==""){
			    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
					jQuery("#tip1").text("");
					showEle("itmeG1");
					hideEle("itmeG2");
	    		}else{
		    		jQuery("#tip1").html("<%=SystemEnv.getHtmlLabelName(126665,user.getLanguage())%>"+_html);//结转中...结转进度：
	    			if(_loadFnaBudgetEditSaveFnaLoadingAjaxFlag){
		    			setTimeout("loadFnaBudgetEditSaveFnaLoadingAjax(_guid1)", "2000");
		    		}
	    		}
		    }catch(e1){
		    	_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = false;
		    }
		}
	});	
}

function doAutoMove(){
	jQuery("#tip1").text("");
	
	var fnayear = jQuery("#fnayear").val();
	var periodsid = jQuery("#periodsid").val();

	var _flag = <%=BudgetAutoMove.isExecuteFlag()?"true":"false" %>;
	if(_flag){
		var tip1 = "<%=SystemEnv.getHtmlLabelName(126665,user.getLanguage())%>";//系统正进行结转，本次结转请求，请稍后再试！
		jQuery("#tip1").text(tip1);
	}else{
		if(fnayear=="" || periodsid==""){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126667,user.getLanguage())%>");//请选择结转年月！
			return;
		}
	}

	if(!_flag){
		//确定要结转么？
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126668,user.getLanguage())%>",
			function(){
				doFnaJzAjax2(_flag, fnayear, periodsid);
			},
			function(){}
		);
	}else{
		doFnaJzAjax2(_flag, fnayear, periodsid);
	}
	
}

function doFnaJzAjax2(_flag, fnayear, periodsid){
	jQuery.ajax({
		url : "/fna/BudgetAutoMove/FnaJzAjax2.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : "_guid1="+_guid1,
		dataType : "json",
		success: function do4Success(_jsonObj){
			if(_jsonObj.execFlag){
				//系统正进行结转，本次结转请求，请稍后再试！
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126666,user.getLanguage())%>", 
					function(){
						//是否要显示当前进行中的结转进度？
						top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126669,user.getLanguage())%>",
							function(){
								doFnaJzAjax2_1(_flag, fnayear, periodsid);
							},
							function(){}
						);
					}
				);
			}else{
				doFnaJzAjax2_1(_flag, fnayear, periodsid);
			}
		}
	});	
}

function doFnaJzAjax2_1(_flag, fnayear, periodsid){
	hideEle("itmeG1");
	showEle("itmeG2");
	if(!_flag){
		jQuery("#tip1").text("<%=SystemEnv.getHtmlLabelName(126670,user.getLanguage())%>");//结转中！
	}
	_guid1 = $System.Math.IntUtil.genGUIDV4();
	jQuery.ajax({
		url : "/fna/BudgetAutoMove/FnaJzAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : "_guid1="+_guid1+"&fnayear="+fnayear+"&periodsid="+periodsid,
		dataType : "html",
		success: function do4Success(_html){
			_loadFnaBudgetEditSaveFnaLoadingAjaxFlag = true;
			loadFnaBudgetEditSaveFnaLoadingAjax(_guid1);
		}
	});	
}
</script>
</body>
</html>
